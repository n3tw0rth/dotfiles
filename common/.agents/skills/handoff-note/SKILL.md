---
name: handoff-note
description: Save the current state of the work to the ticket's .docs note so another agent (Claude Code or Devin CLI) or a later session can continue, and print the commands to resume. Use when pausing, switching agents, or before the context gets long.
argument-hint: "[what the next agent should do]"
---

# Handoff note

1. **Find the note** at `.docs/<KEY>-*.md`, with the key from the branch name. If there is none, create it in the /ticket-start layout.
2. **Update Status from facts**, not memory: `git status --short`, `git diff --stat <base>...`, and this session.
   - Done: what is finished and verified (point to Verification).
   - Next: ordered, concrete steps. Put the argument first if one was given.
   - Decisions: choices made and why, including rejected options.
   - Gotchas: traps found, such as flaky tests, required services, or odd conventions.
   - Files touched: paths, each with a one-line purpose.

   Update Plan if it changed. Replace stale lines; do not append history.
3. **Print resume commands** for both agents, with the real note path:
   - Devin: `devin -- "Continue <KEY>: read .docs/<file>.md and do the Next steps."`
   - Claude Code: `claude "Continue <KEY>: read .docs/<file>.md and do the Next steps."`

   To resume this exact session instead, the user can find its id in `.agent-sessions` at the repo root (one `session-id<TAB>branch` line per session and branch). They run `claude -r <id>` for UUID ids, or `devin -r <id>` for word-pair ids such as `saber-melon`.
