---
name: plain-writing
description: Write and review new prose for human readers (docs, READMEs, PR descriptions, commit messages, design notes, explanations) the way a senior engineer writes to a colleague they respect, then scan it for AI-writing tells. Use when drafting a doc or message a person will read. To clean up text that already exists, use anti-slop; for text an agent will parse, use asd-ste100.
---

Write like a senior engineer explaining something to a colleague they respect: plain, specific, a little opinionated, and finished once the point is made.

If the user gave a sample of their own writing, match its sentence length, word choice and formality over the defaults below.

## Draft

1. **Start with the point.** The first sentence gives the answer, the action, or what the doc is for. Context comes after, only as much as the reader needs.
2. **Use specifics.** Real names, versions, paths, commands, numbers, dates, exact error text. Take them from the source material or the user. When one is missing, ask, or leave `TODO: <what's missing>`. Invent nothing (no numbers, names or anecdotes) to sound human.
3. **Pick plain words.** use, run, check, fix, set up, break, slow. The word you'd say out loud.
4. **Vary the rhythm.** Mix short sentences with longer ones. One idea per sentence. Contractions are fine (don't, it's, we'll) unless the doc is formal.
5. **Say why and take a position.** "We use X because Y fell over at Z." Name tradeoffs and known gaps ("Not tested on Windows").
6. **Let content set the shape.** Prose for reasoning. Lists for steps or truly parallel items. A table when the same fields repeat 3+ times. A section is as long as its content, even one line.
7. **Punctuate plainly.** Join clauses with a comma, period, colon, semicolon or parentheses. Hyphens go only inside compound words (`read-only`). Ranges use "to" (`2020 to 2024`).
8. **Label headings plainly.** Sentence case, short labels (`Install`, `Rotate the key`). Skip headings in anything under about 300 words.
9. **Use placeholders for secrets.** `<API_KEY>`, `<db-host>`. Keep real tokens, passwords, internal hostnames and customer data out of docs.
10. **Stop when done.** The last line is the last useful fact or step.

Done when every section answers a question the reader has.

## Review

Run after every draft and every edit. Read [TELLS.md](TELLS.md) now, then:

1. **Dash check.** This must print nothing (fix any hit outside code blocks):
   ```sh
   perl -CSD -ne 'print "$.: $_" if /[\x{2013}\x{2014}]|\S\s+--?\s/' FILE
   ```
2. **Tells scan.** Go through every item in TELLS.md. For each hit, rewrite the whole sentence around a plainer claim. Swapping one word for a synonym leaves the tell.
3. **Read-aloud test.** Say each paragraph as if to a colleague. Rewrite anything you'd never say.
4. **Cut test.** Remove each sentence in your head. If the reader loses nothing, delete it.

Done when the dash check prints nothing and no line matches a tell.
