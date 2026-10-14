#!/usr/bin/env bash
# Logs one line per session to <cwd>/.claude-sessions (tab-separated):
#   date time  session_id  ticket  branch  summary  agent
# Runs for Claude Code and Devin CLI (Devin loads hooks from ~/.claude/settings.json).
# SessionStart appends the line; UserPromptSubmit fills in the summary from the first prompt.
# Resume with `claude -r <id>` or `devin -r <id>`, depending on the agent column.
set -u
command -v jq >/dev/null || exit 0

input=$(cat)
# \x1f instead of tabs: read collapses empty tab-separated fields.
IFS=$'\x1f' read -r event sid dir prompt agent < <(
  printf '%s' "$input" | jq -r '[
      .hook_event_name, .session_id, (.cwd // ""),
      (.prompt // "" | tostring | gsub("\\s+"; " ")),
      (if .transcript_path then "claude" else "devin" end)
    ] | map(. // "" | tostring) | join("\u001f")'
)
# Devin's payload has no cwd.
dir=${dir:-${DEVIN_PROJECT_DIR:-$PWD}}
[ -n "${sid:-}" ] && [ -d "$dir" ] || exit 0
log="$dir/.claude-sessions"

ticket_from() {
  local t
  t=$(grep -oiE '\b[A-Z][A-Z0-9]+-[0-9]+\b' <<<"$1" | head -1)
  printf '%s' "${t^^}"
}

has_line() { [ -f "$log" ] && grep -q "$sid" "$log"; }

case "$event" in
  SessionStart)
    # Resume/compact re-fire SessionStart; keep one line per session.
    has_line && exit 0
    branch=$(git -C "$dir" branch --show-current 2>/dev/null)
    ticket=$(ticket_from "$branch")
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$(date '+%Y-%m-%d %H:%M')" "$sid" \
      "${ticket:--}" "${branch:--}" "-" "$agent" >> "$log"
    ;;

  UserPromptSubmit)
    prompt=$(sed 's/^ //; s/ $//' <<<"$prompt")
    case $prompt in '' | '<'*) exit 0 ;; esac
    [ ${#prompt} -gt 80 ] && prompt="${prompt:0:80}…"
    pticket=$(ticket_from "$prompt")

    if has_line; then
      # Only the first prompt names the session.
      awk -F'\t' -v sid="$sid" '
        (NF == 1 && index($0, sid)) || ($2 == sid && $5 == "-") { found = 1 }
        END { exit !found }
      ' "$log" || exit 0
      tmp=$(mktemp "$log.XXXXXX") || exit 0
      awk -F'\t' -v OFS='\t' -v sid="$sid" -v s="$prompt" -v t="$pticket" -v a="$agent" '
        NF == 1 && index($0, sid) {
          # Legacy space-separated line: "date time sid"
          split($0, old, " "); $0 = old[1] " " old[2] OFS old[3] OFS "-" OFS "-" OFS "-"
        }
        $2 == sid && $5 == "-" {
          if ($3 == "-" && t != "") $3 = t
          $5 = s
          if ($6 == "") $6 = a
        }
        { print }
      ' "$log" > "$tmp" && mv "$tmp" "$log" || rm -f "$tmp"
    else
      branch=$(git -C "$dir" branch --show-current 2>/dev/null)
      ticket=$(ticket_from "$branch"); ticket=${ticket:-$pticket}
      printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$(date '+%Y-%m-%d %H:%M')" "$sid" \
        "${ticket:--}" "${branch:--}" "$prompt" "$agent" >> "$log"
    fi
    ;;
esac
exit 0
