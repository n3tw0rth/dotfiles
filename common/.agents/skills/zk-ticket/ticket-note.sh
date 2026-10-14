#!/usr/bin/env bash
# Records ticket work in the zk zettelkasten: one note per ticket at
# $ZK_NOTEBOOK_DIR/tickets/<KEY>.md, created from the zk "tickets" group template.
#
#   ticket-note.sh <entry.json>    create or update the ticket's note, print its path
#   ticket-note.sh --show <KEY>    print the note (nothing if it does not exist yet)
#
# entry.json ("ticket" and "log" are required):
#   ticket     "ABC-123"
#   title      ticket title, used when the note is created
#   agent      "claude" or "devin"
#   repo       default: name of the current git repo
#   branch     default: current git branch (listed under ## Branches only if it contains the key)
#   summary    replaces the ## Summary section
#   log        one line for this session, appended to ## Log
#   decisions  ["Chose X over Y because Z", ...], appended to ## Decisions
#   related    ["ABC-100", ...], wiki-linked under ## Related
#   links      ["https://...", ...], listed under ## Links
#
# Branches for the key are also collected from <repo>/.agent-sessions and from
# local and remote git branch names, so ## Branches tracks every branch used.
set -euo pipefail

die() {
  printf 'ticket-note: %s\n' "$*" >&2
  exit 1
}
command -v jq >/dev/null || die "jq is required"
command -v zk >/dev/null || die "zk is required"
notebook=${ZK_NOTEBOOK_DIR:-$HOME/notes}
[ -d "$notebook/.zk" ] || die "no zk notebook at $notebook"

if [ "${1:-}" = --show ]; then
  key=${2:-}
  [ -f "$notebook/tickets/${key^^}.md" ] && cat "$notebook/tickets/${key^^}.md"
  exit 0
fi

entry=${1:-}
[ -f "$entry" ] || die "usage: ticket-note.sh <entry.json> | --show <KEY>"
jq -e 'type == "object"' "$entry" >/dev/null || die "$entry is not a JSON object"

# One value per line; arrays are flattened and whitespace is collapsed.
get() {
  jq -r --arg k "$1" '.[$k] // empty | (if type == "array" then .[] else . end)
    | tostring | gsub("\\s+"; " ") | sub("^ "; "") | sub(" $"; "")' "$entry"
}

key=$(get ticket)
key=${key^^}
[[ $key =~ ^[A-Z][A-Z0-9]+-[0-9]+$ ]] || die "invalid ticket key: '$key'"
log=$(get log)
[ -n "$log" ] || die '"log" is required'
title=$(get title)
agent=$(get agent)
summary=$(get summary)
top=$(git rev-parse --show-toplevel 2>/dev/null || true)
repo=$(get repo)
repo=${repo:-${top##*/}}
repo=${repo:-unknown}
branch=$(get branch)
explicit_branch=$branch
branch=${branch:-$(git branch --show-current 2>/dev/null || true)}
today=$(date +%F)

note="$notebook/tickets/$key.md"
if [ ! -f "$note" ]; then
  mkdir -p "$notebook/tickets"
  created=$(zk new "$notebook/tickets" --no-input --print-path \
    --title "$key${title:+ — $title}" --extra "ticket=$key")
  [ "$created" = "$note" ] || die "zk created '$created', expected '$note'; check the tickets group in the zk config"
fi

# Rewrites the note in place (keeps its inode and permissions).
rewrite() {
  local tmp
  tmp=$(mktemp)
  awk "$@" "$note" >"$tmp" && cat "$tmp" >"$note"
  rm -f "$tmp"
}

# section <heading> <line> [replace]: append the line to "## <heading>", or
# replace the section body. Adds the section at the end when it is missing.
section() {
  rewrite -v h="## $1" -v line="$2" -v mode="${3:-append}" '
    function emit(last,   s, e, k) {
      s = 1; while (s <= n && sec[s] ~ /^[[:space:]]*$/) s++
      e = n; while (e >= s && sec[e] ~ /^[[:space:]]*$/) e--
      print ""
      if (mode != "replace") for (k = s; k <= e; k++) print sec[k]
      print line
      if (!last) print ""
      n = 0; insec = 0; done = 1
    }
    insec && /^## / { emit(0) }
    insec { sec[++n] = $0; next }
    $0 == h && !done { print; insec = 1; next }
    { print }
    END {
      if (insec) emit(1)
      else if (!done) { print ""; print h; print ""; print line }
    }'
}

has() { grep -qF -- "$1" "$note"; }

# Succeeds when the branch name carries the key as a whole token
# (ABC-1 matches feature/ABC-1-x but not ABC-12345-x).
has_key() {
  [[ ${1^^} =~ (^|[^A-Z0-9])$key([^0-9]|$) ]]
}

add_branch() { # <branch>
  [ -n "$1" ] && [ "$1" != - ] || return 0
  has "- $repo: \`$1\`" || section Branches "- $repo: \`$1\` (added $today)"
}

# Adds a tag to the frontmatter "tags: [...]" list.
add_tag() {
  rewrite -v t="$1" '
    NR == 1 && $0 == "---" { fm = 1; print; next }
    fm && $0 == "---" { fm = 0 }
    fm && !done && /^tags: *\[/ {
      inner = $0; sub(/^tags: *\[ */, "", inner); sub(/ *\] *$/, "", inner)
      n = split(inner, a, / *, */)
      for (i = 1; i <= n; i++) if (a[i] == t) found = 1
      if (!found) $0 = "tags: [" inner (inner == "" ? "" : ", ") t "]"
      done = 1
    }
    { print }'
}

# Branches: from the session log (oldest first), then git, then the current one.
if [ -n "$top" ]; then
  while IFS= read -r b; do
    has_key "$b" && add_branch "$b"
  done < <({
    [ -f "$top/.agent-sessions" ] && cut -f2 "$top/.agent-sessions"
    git -C "$top" for-each-ref --format='%(refname:lstrip=2)' refs/heads
    git -C "$top" for-each-ref --format='%(refname:lstrip=3)' refs/remotes
  } | grep -vx HEAD | awk '!seen[$0]++')
fi
# The current branch counts only when named in the entry or when it carries the
# key, so running this from e.g. `dev` after a merge does not record `dev`.
if [ -n "$explicit_branch" ] || has_key "$branch"; then
  add_branch "$branch"
fi

[ "$repo" = unknown ] || add_tag "$repo"
[ -z "$summary" ] || section Summary "$summary" replace

while IFS= read -r d; do
  [ -n "$d" ] && ! has ": $d" && section Decisions "- $today: $d"
done < <(get decisions)

while IFS= read -r r; do
  r=${r^^}
  [[ $r =~ ^[A-Z][A-Z0-9]+-[0-9]+$ && $r != "$key" ]] || continue
  has "[[$r]]" || section Related "- [[$r]]"
done < <(get related)

while IFS= read -r l; do
  [ -n "$l" ] && ! has "- $l" && section Links "- $l"
done < <(get links)

section Log "- $today $(date +%H:%M) · ${agent:-agent} · $repo · \`${branch:--}\` — $log"

zk index --quiet --notebook-dir "$notebook" >/dev/null 2>&1 || true
printf '%s\n' "$note"
