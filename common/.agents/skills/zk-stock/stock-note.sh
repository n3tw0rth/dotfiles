#!/usr/bin/env bash
# Stock research notes in the zk zettelkasten, for Colombo Stock Exchange (CSE)
# companies. Notes live under $ZK_NOTEBOOK_DIR/stocks and come from the zk
# stock-* templates:
#
#   companies/<SYMBOL>.md                  one hub note per company
#   decisions/<date>-<symbol>-<action>.md  decision journal, one note per decision
#   research/<id>-<slug>.md                atomic notes: one claim each
#
#   stock-note.sh company <SYMBOL> [name]            create the company note if missing, print its path
#   stock-note.sh decision <SYMBOL> <action> [price] create a decision note, print its path
#                                                    action: buy add trim sell hold pass
#   stock-note.sh research <kind> <SYMBOLS|-> <title> create a research note, print its path
#                                                    kind: filing news insight sector macro
#                                                    SYMBOLS: JKH or JKH,HAYL; "-" for none
#   stock-note.sh status <SYMBOL> <status>           status: watching holding exited rejected
#   stock-note.sh close <decision>                   mark a decision reviewed (file name without .md)
#   stock-note.sh due                                open decisions whose review date has come
#   stock-note.sh show <SYMBOL>                      print the company note and the notes that link to it
#   stock-note.sh quote <SYMBOL>                     print today's price line from cse.lk
#
# <SYMBOL> is the short symbol (JKH) or the full security code (JKH.N0000). The
# short form means the voting share, <SYMBOL>.N0000, unless the company note
# records another code. The price comes from an undocumented cse.lk endpoint;
# when it fails, pass the name and price by hand.
set -euo pipefail

die() {
  printf 'stock-note: %s\n' "$*" >&2
  exit 1
}
command -v jq >/dev/null || die "jq is required"
command -v zk >/dev/null || die "zk is required"
export ZK_NOTEBOOK_DIR=${ZK_NOTEBOOK_DIR:-$HOME/notes}
[ -d "$ZK_NOTEBOOK_DIR/.zk" ] || die "no zk notebook at $ZK_NOTEBOOK_DIR"
dir=$ZK_NOTEBOOK_DIR/stocks
api=https://www.cse.lk/api/companyInfoSummery
today=$(date +%F)
review_days=90

# Prints a frontmatter field of a note.
field() { # <key> <note>
  awk -v k="$1: " '
    NR == 1 && $0 == "---" { fm = 1; next }
    fm && $0 == "---" { exit }
    fm && index($0, k) == 1 { print substr($0, length(k) + 1); exit }' "$2"
}

# Sets symbol, security and note from a symbol or security code.
parse() { # <SYMBOL>
  local arg=${1^^}
  [[ $arg =~ ^[A-Z][A-Z0-9]{1,9}(\.[A-Z][0-9]{4})?$ ]] || die "invalid symbol: '$1' (expected JKH or JKH.N0000)"
  symbol=${arg%%.*}
  note=$dir/companies/$symbol.md
  security=
  if [[ $arg == *.* ]]; then
    security=$arg
  elif [ -f "$note" ]; then
    security=$(field security "$note")
  fi
  security=${security:-$symbol.N0000}
}

# Prints the cse.lk record of a security as JSON; fails when there is none.
quote_json() { # <SECURITY>
  curl -fsS -m 20 -A 'Mozilla/5.0' -X POST "$api" --data-urlencode "symbol=$1" 2>/dev/null |
    jq -e '.reqSymbolInfo // empty'
}

# Rewrites a note in place (keeps its inode and permissions).
rewrite() { # <note> <awk args...>
  local f=$1 tmp
  shift
  tmp=$(mktemp)
  awk "$@" "$f" >"$tmp" && cat "$tmp" >"$f"
  rm -f "$tmp"
}

# Replaces one of the old tags in the frontmatter "tags: [...]" list.
swap_tag() { # <note> <old-regex> <new>
  rewrite "$1" -v old="$2" -v new="$3" '
    NR == 1 && $0 == "---" { fm = 1; print; next }
    fm && $0 == "---" { fm = 0 }
    fm && /^tags: *\[/ { gsub("\\<(" old ")\\>", new) }
    { print }'
}

# Appends a dated line to "## Log", the last section of a company note.
log() { # <note> <text>
  grep -qx '## Log' "$1" || printf '\n## Log\n' >>"$1"
  [ "$(tail -n 1 "$1")" != '## Log' ] || printf '\n' >>"$1"
  printf -- '- %s · %s\n' "$today" "$2" >>"$1"
}

new_note() { # <subdir> <title> <extra>
  mkdir -p "$dir/$1"
  zk new "$dir/$1" --no-input --print-path --title "$2" --extra "$3"
}

ensure_company() { # [name]; needs parse first
  local name=${1:-} created
  [ ! -f "$note" ] || return 0
  if [ -z "$name" ]; then
    name=$(quote_json "$security" | jq -r '.name // empty') || name=
    [ -n "$name" ] || printf 'stock-note: cse.lk has no record of %s; check the security code\n' "$security" >&2
  fi
  created=$(new_note companies "$symbol${name:+ — $name}" "symbol=$symbol,security=$security")
  [ "$created" = "$note" ] || die "zk created '$created', expected '$note'; check the stock-companies group in the zk config"
}

cmd=${1:-}
[ $# -eq 0 ] || shift
case $cmd in
  company)
    parse "${1:-}"
    shift
    ensure_company "$*"
    printf '%s\n' "$note"
    ;;

  decision)
    parse "${1:-}"
    action=${2:-}
    price=${3:-}
    case $action in
      buy | add | trim | sell | hold | pass) ;;
      *) die "action must be one of: buy add trim sell hold pass" ;;
    esac
    [[ $price =~ ^([0-9]+(\.[0-9]+)?)?$ ]] || die "invalid price: '$price'"
    ensure_company
    stem=$today-${symbol,,}-$action
    decision=$dir/decisions/$stem.md
    if [ ! -f "$decision" ]; then
      [ -n "$price" ] || price=$(quote_json "$security" | jq -r '.lastTradedPrice // empty') || price=
      review=$(date -d "+$review_days days" +%F)
      created=$(new_note decisions "$today $symbol $action${price:+ @ $price}" \
        "symbol=$symbol,action=$action,price=$price,review=$review")
      [ "$created" = "$decision" ] || die "zk created '$created', expected '$decision'; check the stock-decisions group in the zk config"
      log "$note" "decision · [[$stem]] $action${price:+ @ $price}, review $review"
    fi
    printf '%s\n' "$decision"
    ;;

  research)
    kind=${1:-}
    symbols=${2:-}
    [ $# -lt 2 ] || shift 2
    title=$*
    case $kind in
      filing | news | insight | sector | macro) ;;
      *) die "kind must be one of: filing news insight sector macro" ;;
    esac
    [ -n "$title" ] || die "usage: stock-note.sh research <kind> <SYMBOLS|-> <title>"
    links=
    notes=()
    if [ "$symbols" != - ]; then
      IFS=, read -ra list <<<"$symbols"
      for s in "${list[@]}"; do
        parse "$s"
        ensure_company
        links+="${links:+ }[[$symbol]]"
        notes+=("$note")
      done
    fi
    created=$(new_note research "$title" "kind=$kind,companies=$links")
    stem=${created##*/}
    for n in "${notes[@]}"; do
      log "$n" "$kind · [[${stem%.md}]] $title"
    done
    printf '%s\n' "$created"
    ;;

  status)
    parse "${1:-}"
    status=${2:-}
    case $status in
      watching | holding | exited | rejected) ;;
      *) die "status must be one of: watching holding exited rejected" ;;
    esac
    [ -f "$note" ] || die "no company note for $symbol"
    swap_tag "$note" 'watching|holding|exited|rejected' "$status"
    log "$note" "status · $status"
    printf '%s\n' "$note"
    ;;

  close)
    decision=$dir/decisions/${1:-}
    decision=${decision%.md}.md
    [ -f "$decision" ] || die "no decision note: ${1:-}"
    swap_tag "$decision" open reviewed
    printf '%s\n' "$decision"
    ;;

  due)
    [ -d "$dir/decisions" ] || exit 0
    zk list "$dir/decisions" --tag open --quiet --format json |
      jq -r --arg today "$today" '
        map(. + {review: ((.metadata.review // "") | tostring | .[0:10])})
        | map(select(.review <= $today)) | sort_by(.review)[]
        | "\(.review)  \(.title)  \(.absPath)"'
    ;;

  show)
    parse "${1:-}"
    [ -f "$note" ] || exit 0
    cat "$note"
    printf '\n--- notes that link here ---\n'
    zk list --link-to "$note" --quiet --sort created --format '{{path}}  {{title}}'
    ;;

  quote)
    parse "${1:-}"
    quote_json "$security" | jq -r --arg today "$today" '
      def n: if . == null then "-" else (. * 100 | round / 100 | tostring) end;
      "\($today) \(.symbol) last \(.lastTradedPrice | n) prev \(.previousClose | n)"
      + " chg \(.changePercentage | n)% 12m \(.p12LowPrice | n)-\(.p12HiPrice | n)"
      + " mcap \(if .marketCap == null then "-" else (.marketCap / 1e9 | n) + "bn" end)"
      + " shares \(.quantityIssued // "-")"' ||
      die "no cse.lk record for $security"
    ;;

  *)
    sed -n '2,/^set -euo/{/^set -euo/!s/^# \{0,1\}//p}' "$0" >&2
    exit 1
    ;;
esac
