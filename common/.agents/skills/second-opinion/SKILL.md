---
name: second-opinion
description: Get an independent, read-only review of the current changes from the other coding agent (Devin CLI when you are Claude Code, Claude Code when you are Devin), then verify each finding. Use after implementation and /verify, or when the user asks for a second opinion or cross-review.
argument-hint: "[focus area]"
---

# Second opinion from the other agent

1. **Patch.** Get the base from the loaded rules (the integration branch). Write the whole change to `.docs/<KEY>-review.patch`: `git diff <base>...HEAD`, then `git diff HEAD` for uncommitted work, then a list of untracked files. Use `review` as the key when there is no ticket.
2. **Prompt.** Write `.docs/<KEY>-review-prompt.md` asking for:
   - A code review of the patch, not a rewrite. The reviewer may read any repo file for context, but must not edit files or run commands.
   - Focus on correctness, regressions, missed callers, security and access boundaries, config and deployment impact, and repo conventions. Add the argument as extra focus if one was given.
   - Output: one item per finding with severity (high/medium/low), `file:line`, the issue, and why it matters. "No findings" when there are none. No praise and no summary of the diff.
3. **Run the other agent** headless from the repo root. It can take several minutes. Save its output to `.docs/<KEY>-review.md`.
   - From Claude Code: `devin -p --prompt-file .docs/<KEY>-review-prompt.md`
   - From Devin: `claude -p --permission-mode dontAsk --allowedTools "Read,Grep,Glob" < .docs/<KEY>-review-prompt.md`
4. **Triage.** Check every finding against the code yourself. Mark each one confirmed, rejected (with the reason), or unsure. Fix confirmed findings that are in scope; list the rest for the user.
5. **Report** the triaged list, not the raw output.
