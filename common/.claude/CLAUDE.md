# Git

- Never run `git commit`, `git push` (including force-push), or create pull requests. I do all of these myself.
- When changes are ready, tell me and, if useful, suggest the commands or a commit message/PR description for me to run — without any AI attribution lines (no Claude or Devin `Co-Authored-By`, "Generated with …", or similar).

# Tickets

- Work is tracked in Jira tickets with keys like `ABC-123`. The key is usually in the branch name (`ABC-123-short-slug`, `feature/ABC-123-short-slug`, sometimes lowercase). Read it with `git branch --show-current` and uppercase it before you ask the user.
- Never invent a key. If the branch has none (for example `dev` or `main`), ask.

# Working notes

- Write plans, investigations, handoff state, and PR drafts to `.docs/` at the repo root, as `<TICKET>-<slug>.md` when the branch name has a ticket key. `.docs/` is ignored globally; never commit it.
- Claude Code and Devin CLI both work in these repos. When the other agent may continue the work, keep the note's Status section current (`/handoff-note`).
- Never let two agents edit the same working tree at once; give the second one its own git worktree.
- When work on a ticket is done (after `/ship`), record it in the zk zettelkasten with `/zk-ticket`: one note per ticket key, with the branches used, decisions, and a dated log.

# Done means verified

- Before calling work finished, run the repo's checks (`/verify`) and report exactly what ran, what passed, and what did not run.
