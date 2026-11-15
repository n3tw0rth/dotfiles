---
name: zk-stock
description: Research and track Colombo Stock Exchange (CSE) companies in the zk zettelkasten. One hub note per company, atomic research notes, and a decision journal with review dates. Use when the user asks to investigate or track a stock, record a buy/sell/hold/pass decision, or review past stock decisions.
argument-hint: "[SYMBOL]"
---

# Stock research in the zettelkasten

Notes live in `$ZK_NOTEBOOK_DIR/stocks` (default `~/notes`). `~/.agents/skills/zk-stock/stock-note.sh` creates them and prints the path; run it with no arguments for every command. Create notes and change their tags only through that script, then fill the sections with your file-editing tool.

| Note | Path | Holds |
| ---- | ---- | ----- |
| **hub** | `companies/<SYMBOL>.md` | One per company: business, thesis, kill criteria, financials, valuation, position, log |
| **research** | `research/<id>-<slug>.md` | One claim with its evidence, linked to the hubs it bears on |
| **decision** | `decisions/<date>-<symbol>-<action>.md` | One buy/add/trim/sell/hold/pass with its reasons and a review date |

`<SYMBOL>` is the short symbol (`JKH`). The hub's `security:` field holds the full code (`JKH.N0000`); a non-voting share (`.X0000`) belongs in the same hub.

## Rules for every note

- **Sourced.** Each number carries its source and date: the filing, the page, or the `quote` line. Mark an estimate as an estimate.
- **Whose view.** The user owns Thesis, Kill criteria, State of mind and every decision. Draft them from the user's words and prefix your own analysis with `Agent:`.
- **Atomic.** A research note holds one claim. Link it to the notes it supports or contradicts with `[[file-name-without-md]]`.
- **Dated.** Append to tables and to the hub's Log; change earlier rows only to correct an error.

## Investigate a company

1. `stock-note.sh show <SYMBOL>` prints the hub and the notes that link to it. Start from what is recorded.
2. `stock-note.sh company <SYMBOL>` creates the hub when it is missing.
3. Read the sources, newest first: the latest annual report, the quarterly statements since then, and the announcements, all on the company profile at `https://www.cse.lk/pages/company-profile/company-profile.component.html?symbol=<SECURITY>`. Ask the user for a PDF you cannot fetch.
4. Fill the hub: Business, a Financials row per period read, Risks, Catalysts, and `sector:` in the frontmatter.
5. `stock-note.sh quote <SYMBOL>` gives today's price. Add a Valuation row computed from it and the latest EPS, NAV and DPS.
6. Write a research note for each finding that bears on the thesis: `stock-note.sh research <kind> <SYMBOLS|-> <title>`, with the claim as the title.
7. Report the bull case, the bear case, and the Open questions the sources left unanswered. Done when every figure in the hub has a source and every Open question is listed.

## Record a decision

1. Ask for the action, quantity and price unless the user gave them.
2. `stock-note.sh decision <SYMBOL> <action> [price]` creates the note with a review date 90 days out; change `review:` when the user names another horizon.
3. Fill each section from the user's words. Ask for the Expected outcome with a probability and for the Kill criteria; a decision without them is unfinished. Offer `/grilling` when the reasons are thin.
4. For buy, add, trim and sell: add a Position row to the hub, then `stock-note.sh status <SYMBOL> <watching|holding|exited|rejected>` when the status changed. A pass on a company the user will stop following is `rejected`.

## Review decisions

1. `stock-note.sh due` lists open decisions whose review date has come.
2. For each: quote the price, compare what happened with the Expected outcome and the Kill criteria, and ask the user whether the reasoning held or the result was luck.
3. Write the Review section, then `stock-note.sh close <decision-file-name>`. A lesson that applies beyond this company gets a research note of kind `insight`.

The user opens notes with `zk stock <SYMBOL>`, `zk stocks`, `zk reviews`, or `<leader>ks` / `<leader>kr` in nvim.
