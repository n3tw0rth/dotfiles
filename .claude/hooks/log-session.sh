#!/usr/bin/env bash
# Records which branch each agent session works on, one line per session and
# branch, in <session start dir>/.agent-sessions (tab-separated):
#   session_id (padded to 36 chars)  branch
# Runs for Claude Code and Devin CLI (Devin loads hooks from ~/.claude/settings.json)
# on SessionStart and UserPromptSubmit, so a branch switch mid-session adds a line.
# Resume with `claude -r <id>` (UUID ids) or `devin -r <id>` (word-pair ids such as saber-melon).
set -u
command -v jq >/dev/null || exit 0

# \x1f instead of tabs: read collapses empty tab-separated fields.
IFS=$'\x1f' read -r sid dir < <(
  jq -r '[.session_id, (.cwd // "")] | map(. // "" | tostring) | join("\u001f")'
)
# Devin's payload has no cwd.
dir=${dir:-${DEVIN_PROJECT_DIR:-$PWD}}
[ -n "${sid:-}" ] || exit 0
# Pin each session to the directory it started in: the cwd drifts when the agent runs cd.
state=${XDG_STATE_HOME:-$HOME/.local/state}/agent-sessions
mkdir -p "$state" 2>/dev/null || exit 0
pin="$state/${sid//\//_}"
if [ -s "$pin" ]; then
  dir=$(cat "$pin")
else
  printf '%s\n' "$dir" > "$pin"
  # Pins only matter while a session can still be resumed.
  find "$state" -type f -mtime +60 -delete 2>/dev/null
fi
[ -d "$dir" ] || exit 0

branch=$(git -C "$dir" branch --show-current 2>/dev/null)
# Pad ids to UUID width (36) so Devin's shorter ids line up with Claude's.
line=$(printf '%-36s\t%s' "$sid" "${branch:--}")
log="$dir/.agent-sessions"
grep -qxF -- "$line" "$log" 2>/dev/null || printf '%s\n' "$line" >> "$log"
exit 0
