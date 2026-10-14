---
name: ticket-start
description: Start work on a ticket. Proposes the branch name and creates the .docs/<KEY>-<slug>.md working note (context, plan, verification, status, PR draft) that Claude Code and Devin share. Use when the user starts a new ticket or task.
argument-hint: <TICKET-KEY> [ticket title or pasted ticket text]
---

# Start a ticket

Input: `$ARGUMENTS`, a ticket key (for example `ABC-123`) and optionally the ticket title or text.

1. **Conventions.** Take branch naming, the integration branch, and commit format from the loaded rules (AGENTS.md, CLAUDE.md, local overlays). If the key is missing, ask for it. Never invent a ticket key.
2. **Tree state.** Run `git status --short --branch`. If there are uncommitted changes, or the branch belongs to another ticket, tell the user before you go on.
3. **Branch.** Propose a name in the repo's convention with a short kebab-case slug from the title. Print the command, for example `git fetch origin && git switch -c <branch> origin/<integration-branch>`. Do not run it.
4. **Working note.** If `.docs/<KEY>-*.md` exists, read it and continue from it. Otherwise create `.docs/<KEY>-<slug>.md`:

   ```markdown
   # <KEY> — <title>

   ## Context
   What the ticket asks, in your own words. Links. Open questions.

   ## Plan
   Steps, files, approach. Alternatives only when the tradeoff matters.

   ## Verification
   Checks to run and what they prove. /verify fills in the results.

   ## Status
   - Done:
   - Next:
   - Decisions:
   - Gotchas:
   - Files touched:

   ## PR draft
   /ship fills this in.
   ```

5. **Investigate, then plan.** Read the code the ticket touches and fill in Context and Plan from evidence. Ask the user only about real gaps.
6. **Report** the branch command, the note path, and the open questions.
