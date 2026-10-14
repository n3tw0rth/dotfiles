---
name: ship
description: Prepare verified changes for the user to commit and open a PR. Drafts commit messages, the PR title and description, the target branch, and the exact commands, without committing or pushing. Use when the work is done and the user wants to ship it.
argument-hint: "[target-branch]"
---

# Prepare to ship

You never commit, push, or open pull requests. You prepare everything so the user can.

1. **Verified?** The ticket note needs a Verification table that covers the latest changes. If it does not, run /verify first.
2. **Review the diff**: `git diff <base>...HEAD`, `git diff HEAD`, and untracked files. Flag anything that should not ship: debug code, unrelated changes, secrets, `.docs/` files, and local overlays (`AGENTS.local.md`, `.claude/`, `.devin/`, `CLAUDE.local.md`).
3. **Target branch.** Use the argument if given, else the integration branch from the loaded rules. Never infer it from the remote's default branch alone. Ask when unsure.
4. **Commit messages** follow the repo's convention, from the loaded rules or else recent `git log --oneline`.
   - Default form: `<type>: <KEY> <imperative subject>`, at most 72 characters. Add a body only when the reason is not obvious.
   - Suggest more than one commit only when the changes clearly separate.
   - No AI attribution lines of any kind.
5. **PR title and description.** Follow the repo's writing-style rules if it has any.
   - Summary: what and why in 1–3 sentences, with the ticket key.
   - Changes: bullets by area.
   - Verification: the checks that actually ran (from the table) and what did not run.
   - Config and deployment impact: env vars, manifests, secrets, migrations, other repos to update. Write "None" when there is none.
   - Risks and rollback.
6. **Hand over.** Write all of this to the note's PR draft section, or to `.docs/<KEY>-pr.md`. Then print for the user:
   - `git add` with explicit paths, then `git commit` with the message.
   - `git push -u origin <branch>`.
   - The PR link. For an Azure DevOps remote (`git@ssh.dev.azure.com:v3/<org>/<project>/<repo>` or `https://dev.azure.com/<org>/<project>/_git/<repo>`) that is `https://dev.azure.com/<org>/<project>/_git/<repo>/pullrequestcreate?sourceRef=<branch>&targetRef=<target>`. For other hosts, use the usual compare or new-PR URL.
7. **Record.** Run /zk-ticket so the ticket's zettelkasten note gets this branch, the decisions, the PR link, and a log line.
