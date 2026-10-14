---
name: zk-ticket
description: Record ticket work in the zk zettelkasten. One note per ticket key holds the branches used over time, decisions with their reasons, related tickets, links, and a dated log of agent sessions. Use when work on a ticket is done (after /ship), before pausing a ticket for a long time, or when the user asks to log the ticket.
argument-hint: "[TICKET-KEY]"
---

# Record ticket work in the zettelkasten

Each ticket has one note at `$ZK_NOTEBOOK_DIR/tickets/<KEY>.md` (default `~/notes`). `~/.agents/skills/zk-ticket/ticket-note.sh` creates it from the zk `tickets` template and appends to it. Write only through that script: never edit the note by hand, and never create a second note for the same key.

1. **Key.** Take it from the argument, else from the branch name. Never invent one; ask.
2. **Read what is already recorded**: `~/.agents/skills/zk-ticket/ticket-note.sh --show <KEY>` prints the note, or nothing if there is none yet. Don't repeat decisions or links that are already there.
3. **Gather** from this session and the ticket's `.docs/<KEY>-*.md` note:
   - `title`: the ticket title. It only matters when the note is new.
   - `summary`: 2–4 sentences on what the ticket asks, what was built, and where it stands (merged, in review, blocked). It replaces the old summary, so keep whatever is still true.
   - `log`: one line on what this session did: areas changed, checks run, outcome.
   - `decisions`: new decisions only. Give each its reason, and the rejected alternative if there was one.
   - `related`: other ticket keys this work depends on, unblocks, or touches.
   - `links`: the PR URL (from /ship) and relevant docs.
4. **Write the entry** as JSON to `.docs/<KEY>-zk.json` with your file-writing tool, not a shell heredoc. The text can contain quotes, backticks, or words the guard hook blocks.

   ```json
   {
     "ticket": "ABC-123",
     "title": "…",
     "agent": "claude",
     "summary": "…",
     "log": "…",
     "decisions": ["…"],
     "related": ["ABC-100"],
     "links": ["https://…"]
   }
   ```

   Set `agent` to `claude` or `devin`, whichever you are. `repo` and `branch` default to the current git repo and branch. Set them only when you record work from another directory.
5. **Run** `~/.agents/skills/zk-ticket/ticket-note.sh .docs/<KEY>-zk.json` from the repo root. The script also:
   - adds every branch for this key that it finds in `.agent-sessions` and in local or remote git branches;
   - tags the note with the repo name;
   - prints the note path.
6. **Report** the path. The user opens the note with `zk ticket <KEY>` or `<leader>kj` in nvim. `zk tickets` lists all ticket notes.
