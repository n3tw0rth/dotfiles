#!/usr/bin/env bash
# PreToolUse guard shared by Claude Code and Devin CLI. Both load it from
# ~/.claude/settings.json (Devin reads Claude-format hooks there).
# Exit 2 blocks the tool call and shows stderr to the agent.
#
# Blocks:
#   - git commit/push (also through git aliases and `bash -c`), gh pr create/merge,
#     and cloud/infra CLIs (az, aws, gcloud, kubectl, helm, terraform, tofu, terragrunt, eksctl)
#   - reading or editing secret files (.env, tfstate, tfvars, .npmrc, secrets.json, keys)
#
# This is a guardrail, not a sandbox: script files, git called from another
# language, and writing into a running shell get past it. Each tool's deny
# rules back it up.
set -u
command -v jq >/dev/null || exit 0

input=$(cat)
tool=$(jq -r '.tool_name // ""' <<<"$input")
# Where the command runs: Devin sends tool_input.workdir, Claude sends cwd.
workdir=$(jq -r '.tool_input.workdir // .cwd // empty' <<<"$input")
workdir=${workdir:-$PWD}

block() {
  printf 'Blocked by personal guard: %s. Do not work around it; print the command for the user to run instead.\n' "$1" >&2
  exit 2
}

# Succeeds when the path or shell word names a secret file.
is_secret() {
  local p=$1 base
  p=${p//\"/}
  p=${p//\'/}
  [[ $p =~ ^[0-9]*[\<\>]+(.*)$ ]] && p=${BASH_REMATCH[1]}
  p=${p%/}
  [ -n "$p" ] || return 1
  base=${p##*/}
  case $base in
    .env.dist | .env.sample | .env.example | .env.template | *.pub) return 1 ;;
    .env | .env.* | *.tfstate | *.tfstate.* | *.tfvars | *.tfvars.json | .npmrc | secrets.json | *.pem | id_rsa* | id_ed25519* | id_ecdsa*) return 0 ;;
  esac
  case "/$p/" in
    */.terraform/* | */.ssh/* | */.aws/* | */.azure/* | */.kube/* | */.config/gcloud/*) return 0 ;;
  esac
  return 1
}

# $1: shell command text. $2: nesting depth (aliases, bash -c).
check_command() {
  local depth=${2:-0} seg w i j sub alias
  local -a words gopts
  [ "$depth" -le 5 ] || return 0
  # One segment per simple command: split on ; & | && || $( ` ( ) { } and newlines.
  while IFS= read -r seg; do
    read -ra words <<<"${seg//[\"\']/}"
    for w in "${words[@]}"; do
      is_secret "$w" && block "'$w' looks like a secret file"
    done
    # Skip env assignments, wrappers (sudo, env, timeout, eval, ...), shell
    # keywords, and the wrappers' flags and arguments.
    i=0
    while [ "$i" -lt "${#words[@]}" ]; do
      case ${words[i]} in
        [A-Za-z_]*=*) ;;
        sudo | env | command | time | timeout | nohup | exec | eval | xargs | nice) ;;
        if | then | else | elif | do | while | until | '!') ;;
        -* | [0-9]*) [ "$i" -gt 0 ] || break ;;
        *) break ;;
      esac
      i=$((i + 1))
    done
    [ "$i" -lt "${#words[@]}" ] || continue
    case ${words[i]##*/} in
      az | aws | gcloud | kubectl | helm | terraform | tofu | terragrunt | eksctl)
        block "'${words[i]##*/}' acts on cloud resources"
        ;;
      gh)
        [[ ${words[i + 1]:-} == pr && ${words[i + 2]:-} =~ ^(create|merge)$ ]] &&
          block "the user opens and merges pull requests"
        ;;
      bash | sh | zsh | dash | ksh)
        # Check the command string of `bash -c "..."` (also -lc, -ec, ...).
        for ((j = i + 1; j < ${#words[@]}; j++)); do
          if [[ ${words[j]} =~ ^-[a-zA-Z]*c[a-zA-Z]*$ ]]; then
            check_command "${words[*]:j+1}" $((depth + 1))
            break
          fi
        done
        ;;
      git)
        gopts=()
        i=$((i + 1))
        while [[ ${words[i]:-} == -* ]]; do
          case ${words[i]} in
            -C | -c | --git-dir | --work-tree | --namespace)
              gopts+=("${words[i]}" "${words[i + 1]:-}")
              i=$((i + 2))
              ;;
            *)
              gopts+=("${words[i]}")
              i=$((i + 1))
              ;;
          esac
        done
        sub=${words[i]:-}
        case $sub in
          '') ;;
          commit | push | commit-tree) block "the user makes every git commit and push" ;;
          *)
            # Resolve aliases such as `cm = commit` or `sp = !git push` and check the result.
            alias=$(git -C "$workdir" "${gopts[@]}" config --get "alias.$sub" 2>/dev/null) || alias=
            case $alias in
              '') ;;
              '!'*) check_command "${alias#!}" $((depth + 1)) ;;
              *) check_command "git ${gopts[*]} $alias" $((depth + 1)) ;;
            esac
            ;;
        esac
        ;;
    esac
  done < <(sed -E 's/(\|\||&&|\$\(|[;&|`(){}])/\n/g' <<<"$1")
}

check_paths() {
  local p
  while IFS= read -r p; do
    is_secret "$p" && block "'$p' looks like a secret file"
  done < <(jq -r '
    .tool_input // {}
    | [.file_path, .path, .filePath, .notebook_path, .glob, .include]
      + [(.patch // .input // "") | tostring
         | scan("(?m)^\\*\\*\\* (?:Add File|Update File|Delete File|Move to): (.+)$") | .[0]]
    | .[] | select(type == "string" and length > 0)' <<<"$input")
}

case $tool in
  Bash | exec) check_command "$(jq -r '.tool_input.command // ""' <<<"$input")" ;;
  *) check_paths ;;
esac
exit 0
