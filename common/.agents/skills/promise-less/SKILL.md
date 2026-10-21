---
name: promise-less
description: Keep the promises in docs and change proposals small, plain and checkable, so the reader expects exactly what the change delivers. Use when writing or reviewing a README, PR description, design proposal, release note or status update, or when the user asks to tone down claims or set lower expectations.
argument-hint: "[file]"
---

# Promise less

Every claim in a doc is a promise the reader will hold you to. Promise what the change does today and what you checked. Keep promises simple and stupid: one plain claim the reader can verify.

## Write

1. **Describe what it does now.** "Adds a retry on 503 responses from the billing API." Present tense, actual behavior, actual scope.
2. **Back every outcome with evidence.** A speed, reliability or cost claim needs the number and the conditions behind it: "p95 went from 840 ms to 310 ms in the staging load test (`k6 run load.js`)". Without a measurement, describe the mechanism ("caches the token for 10 minutes") and let the reader draw the conclusion.
3. **Pick the narrow word**, the one that matches what you checked:

   | Instead of | Write |
   |---|---|
   | ensures, guarantees | the mechanism: checks, retries, rejects |
   | fixes the issue | fixes the crash in `X` when `Y` is empty |
   | improves performance | the measured number, or the mechanism |
   | fully, all, always, never | the cases you tested |
   | robust, scalable, production-ready, future-proof | what was tested, and at what size |
   | seamless, zero downtime, no impact | what happens during the change, and what you saw |

4. **Name the limits.** One line each for what it doesn't cover, what wasn't tested, and known gaps: "Not tested with more than 10k rows."
5. **Commit to one deliverable.** A proposal promises the smallest change that solves the problem. Later phases go under **Possible follow-ups** as options, without dates or "we will". Add a date or estimate only when the user gives one.
6. **Sell only this change.** Future benefits ("paves the way for", "lays the foundation for") go under Possible follow-ups, or nowhere.

## Review

Run on every draft, and on an existing doc when asked.

1. **List the promises:** every sentence that claims an outcome, a quality, a guarantee, future work or a timeline.
2. **Check each one.** Keep it if the reader can verify it with a command, a test, a number or the code. Otherwise rewrite it as the plain thing the change does, or cut it.
3. **Read it as the reader.** What will they expect to happen after reading this? If that's more than the change delivers, cut until it matches.

Done when every promise left in the doc is one the change keeps and the reader can check.
