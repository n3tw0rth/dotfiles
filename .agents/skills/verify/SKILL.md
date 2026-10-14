---
name: verify
description: Run the repository's own checks (tests, lint, format, build) on the current changes and record exactly what ran. Use before calling work done, before /ship, or when the user asks to verify.
argument-hint: "[full]"
---

# Verify the current changes

Some repos have no CI quality gate, so this run can be the only check. Be exact about what ran.

1. **Scope.** Get the base from the loaded rules (the integration branch), or ask. Changed files: `git diff --name-only <base>...HEAD` plus `git status --porcelain` (staged, unstaged, untracked).
2. **Choose checks from the repo itself.** Prefer documented commands (AGENTS.md, docs, README) over guesses.
   - `package.json`: the scripts that exist, such as `test`, `lint`, `format:check`, `typecheck`. If a full lint or format run is slow or flags many unrelated files, run it on the changed files only (`npx eslint <files>`, `npx prettier --check <files>`). Run `build` when the change can affect the build (config, dependencies, imports, bundler settings), or when the argument is `full`.
   - `pom.xml`: `mvn -q package`. Add `-DskipTests` only if tests need services that are not available, and say so.
   - `pyproject.toml`: the test runner it configures (`uv run pytest`, `poetry run pytest`).
   - Terraform (`*.tf`): never run terraform. Review the HCL statically, then print `terraform fmt -check -recursive` and `terraform validate` for the user to run.
   - Nothing runnable: say so, and use syntax checks where they apply (`node --check <file>`).
3. **Run** the checks. If `.nvmrc` differs from the active Node version, use the `.nvmrc` version.
4. **Failures.** Read each failure. Fix the ones the change causes. Before you call a failure pre-existing, prove it: run the same check on the base in a temporary `git worktree add`, then remove that worktree.
5. **Record** a table under Verification in the ticket's `.docs` note, and show it to the user:

   | Check | Command | Result |
   |---|---|---|

   Also list the checks that could not run and why (missing services, credentials, blocked commands).
