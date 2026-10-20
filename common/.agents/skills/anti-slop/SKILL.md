---
name: anti-slop
description: Preservation-first audit and rewrite of existing prose (an agent's draft, someone else's doc, a PR description) to remove formulaic AI-writing patterns without changing facts, authorial stance, or valid domain language. Use when the user asks to de-slop, humanize, remove AI tells from, or audit text that already exists. For drafting new text, use plain-writing.
---

# Anti-Slop

Remove formulaic AI-writing patterns while preserving what the author actually said. The goal is good prose in the intended register, not detector evasion or a generic imitation of human voice.

## Modes

Choose the narrowest mode authorized by the request:

- **Audit:** report candidate findings and their dispositions. Do not change the source.
- **Conservative rewrite:** repair confirmed findings in the smallest coherent spans. This is the default when the user asks for a rewrite.
- **Macro rewrite:** restructure paragraphs or document shape only when the user explicitly requests structural cleanup, substantial rewriting, or a new draft.

Do not widen an audit into a rewrite or a conservative rewrite into a macro rewrite.

## Core contract

### A match is evidence, not permission

Detection produces candidates. Classify each candidate on two independent axes:

- **Severity:** hard or soft.
- **Disposition:** confirmed, protected, or uncertain.

Edit only confirmed findings. A hard match may still be protected because it is literal, technical, quoted, attributed, accurately qualified, or natural for the genre. Leave uncertain candidates unchanged.

### Preserve the source

Prefer no change to an uncertain edit. If no defect is confirmed, return the source unchanged.

Preserve:

- names, numbers, dates, durations, percentages, currencies, units, URLs, references, citations, quotations, and code identifiers;
- negation, conditions, comparisons, exceptions, uncertainty, modality, attribution, causal force, scope, and relationships between parties;
- force-bearing terms such as `must`, `never`, `all`, `only`, `required`, and `prohibited`;
- distinct list items and attributed claims unless the user authorizes content cuts;
- Markdown frontmatter, tables, link destinations, ordered-list numbering, and code indentation unless their formatting is itself in scope.

Add no unsupported fact, source, mechanism, measurement, opinion, advice, anecdote, emotion, certainty, first-person stance, or conclusion. Do not conduct external research or silently correct factual claims during a style pass. Report suspected factual problems separately.

For legal, medical, scientific, security, financial, and policy text, treat qualifiers and scope language as load-bearing. Change them only when the user explicitly requests a substantive edit and supplies the intended meaning.

### Protect evidence and literal material

By default, do not rewrite code fences, inline code, command output, URLs, citations, or literal examples demonstrating bad prose. Treat quotations and blockquotes according to their role: preserve evidence and attributed text, but edit quoted prose when the user explicitly asks to revise it.

## Workflow

1. **Fix the target.** Identify the genre, venue, audience, authorial stance, length limit, required facts, citations, and house style. Read [references/voices.md](references/voices.md) for the applicable register.
2. **Record the preservation ledger.** Note the source elements covered by the core contract before rewriting.
3. **Scan.** Use [references/tells.md](references/tells.md). Include manual checks for cadence, document shape, and generic prose. Mask protected regions unless they are explicitly in scope.
4. **Diagnose.** Give each candidate a severity and disposition with a short contextual reason. Scanner output never decides disposition by itself.
5. **Repair.** In conservative mode, change the smallest coherent span containing each confirmed finding. Preserve unaffected sentences, order, and paragraph boundaries. A small adjacent change is allowed only when grammar or reference resolution requires it.
6. **Validate.** Compare the rewrite with the preservation ledger, then rescan changed spans and their surrounding context. Check that the rewrite introduced no new hard finding, semantic drift, unsupported specificity, or register mismatch.
7. **Stop safely.** Make at most three repair attempts per span. If a safe repair still is not available, restore the source span and report the unresolved finding.
8. **Check the register.** Read the result aloud and apply the selected genre profile without manufacturing personality.

Completion means zero unresolved confirmed findings, no introduced hard findings, and every remaining candidate classified as protected, uncertain, or advisory. It does not mean zero raw pattern matches.

## Rewrite principles

### Negative parallelism

Classify each "not X but Y" construction before editing:

1. **Decorative strawman:** remove the rejected half and state the supported claim directly.
2. **Genuine contrast or correction:** preserve it. Clarify only with evidence already present in the source.
3. **Empty contrast:** delete it only when it carries no distinct fact and the selected mode permits the cut; otherwise report it.

Do not disguise the same frame as "less about X than Y," "X matters, but Y matters more," "the real X is Y," or a rhetorical question followed by a fragment.

### Other common repairs

- Replace puffery with the plain supported claim. Delete it when no claim remains.
- Preserve every distinct item in a triplet or list. Break formulaic rhythm without dropping facts; remove an item only when it is truly redundant and content cuts are authorized.
- Rephrase a false range as the two actual items while preserving both.
- Remove reflexive hedging and both-sides framing, but preserve evidence-calibrated uncertainty and genuine concessions.
- Replace vague attribution with a source already present in the text. If none exists, flag the gap instead of inventing or researching one.
- Improve specificity only from the source or context supplied by the user. Put author questions in the audit, not inside the rewritten prose.
- Vary cadence only where it is mechanically repetitive. Do not replace uniform prose with alternating short and long sentences or a run of fragments.
- Remove throat-clearing, recap conclusions, and engagement bait when they add no fact, instruction, or warranted claim.

## Avoid overcorrection

- Match the author, not a persona. Do not add slang, typos, attitude, first person, emotion, anecdotes, or deliberate mess unless the source already demonstrates them.
- Punctuation is contextual. Em dashes, parentheses, colons, curly quotes, passive voice, title case, and multi-clause sentences are not defects by themselves.
- Repeated domain terms are often clearer than synonym cycling.
- Established technical terms such as `API surface`, `primitive`, `vector`, `modality`, and `scaffolding` are protected when used accurately.
- Do not trade precision for personality in technical, academic, or high-stakes writing.

## Output

Match the request:

- **Audit:** provide a compact finding table with span, category, severity, disposition, and reason. Include unresolved author questions separately.
- **Direct rewrite:** return only the rewritten text unless the user asks for analysis. If a confirmed finding could not be repaired safely, add a brief unresolved-finding note instead of hiding it.
- **Requested analysis:** provide the rewritten text followed by a brief validation summary covering preserved constraints, confirmed fixes, protected matches, unresolved findings, and repair passes.
