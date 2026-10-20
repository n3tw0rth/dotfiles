# AI-Writing Candidate Catalog

Use this catalog to find candidates, not to authorize edits. Context determines whether a match is confirmed, protected, or uncertain. Density, repetition, genre, and the function of the passage matter more than an isolated word.

## Protected regions and uses

Mask code fences, inline code, command output, URLs, citations, and literal examples unless the user explicitly includes them in scope. Preserve quoted or attributed material when it is evidence. Protect accurate domain terminology, genuine corrections, calibrated uncertainty, legal or policy scope, and genre-natural formatting.

## 1. Negative parallelism and staged contrast

Usually hard candidates when the rejected half is decorative:

```regex
not (just|only|merely|simply|solely) [^.;]{2,80}(but|it'?s|—)
isn'?t (just|only|merely|simply|about)
it'?s not (a|an|the|that|about|just) [^.;]{2,80}(it'?s|but)
(is|was|are|were)n'?t about [^.;]{2,60}[.;] (it|this|that)'?s about
less about [^.;]{2,60}(than|and more about)
more than (just|a mere|simply)
not because [^.;]{2,80}but because
the (question|point|issue|problem|goal|real [a-z]+) is(n'?t| not) (whether|about|just|if)
not only [^.;]{2,80}but (also )?
no [a-z]+, no [a-z]+(, no [a-z]+)?[,.]? just
```

Check rhetorical self-answering by hand: a question immediately answered by a word or fragment. Preserve genuine corrections such as "Use pnpm, not npm" and real contrasts whose two sides carry distinct information.

## 2. Puffery, promotion, and inflated significance

Single occurrences are usually soft. Repetition or a phrase replacing a concrete claim raises confidence.

```regex
\b(delve|delving)\b
\btapestry\b
\b(testament|stands as)\b
\bseamless(ly)?\b
\b(pivotal|paramount|crucial)\b
\bunderscore(s|d)?\b
\b(landscape|realm|sphere) of\b
\bnavigat(e|ing) (the )?(landscape|challenges?)\b
\bfoster(s|ing)?\b
\bleverage(s|d)?\b
\bmeticulous(ly)?\b
\bintricate\b
\bboasts\b
\bgame.?chang(er|ing)\b
\b(seismic|monumental|transformative) (shift|change)\b
\bshowcas(e|es|ing)\b
\bplays? a (vital|key|crucial|pivotal) role\b
\bdeep(er)? dive\b
\bunlock(s|ing)? (the|your)\b
\bembark(s|ed|ing)? on\b
\bever.?(evolving|changing)\b
\bfast.?paced (world|environment)\b
\bin today'?s\b
\bcutting.?edge\b
\b(holistic|synergy|empower(s|ing|ment)?)\b
```

Literal and domain-valid uses remain protected. Do not flag `robust`, `harness`, `surface`, `primitive`, or similar terms without confirming that the use is empty or metaphorical in context.

## 3. Chatbot residue, sycophancy, and reasoning leakage

Usually hard when spoken by the current author rather than quoted as an example:

```regex
\b(great question|excellent question|you'?re absolutely right)\b
\b(certainly|of course)!?
i hope this helps
please (don'?t hesitate|feel free) to (ask|reach out)
let me know if (you|there)
as an ai (language )?model
as of my knowledge cutoff
let me (think|reason|break this down) (step by step|through this)?
here'?s my thought process
```

Do not remove ordinary relational warmth merely because it is polite. The finding is empty assistant residue or automatic praise.

## 4. Empty participial clauses, false agency, and formulaic challenges

Review clause-ending or sentence-opening `-ing` phrases such as "highlighting," "ensuring," "reflecting," "showcasing," and "fostering." They are findings only when they repeat the previous statement, claim an unsupported consequence, or hide the actor and mechanism.

```regex
\b(the data|the numbers|the results) (tell(s)? a story|speak(s)? for (itself|themselves)|paint(s)? a (clear )?picture)\b
despite (these |the )?challenges[^.;]{0,100}(continues? to|remain(s)?|thriv(e|es|ing))
```

Literal agency and supported causal statements are protected.

## 5. Vague attribution and unexplained name-dropping

Soft candidates:

```regex
\b(experts?|researchers?|critics?|observers?|analysts?) (believe|argue|say|suggest|warn|agree)\b
\b(studies|research|reports|evidence) (show|shows|indicate|indicates|suggest|suggests)\b
```

Attributed claims are protected when the source is named or recoverable from a nearby citation. Never invent a source. Multiple named sources may represent distinct evidence; do not delete them merely to shorten a list.

## 6. Filler, reflexive hedging, and generic conclusions

```regex
it'?s (worth|important) (to note|noting|to remember|to consider)
(that|it) (being )?said,
while (it'?s|this is) (true|important)
in many ways
to some (extent|degree)
at its core
in essence
essentially,
ultimately,
in conclusion
in summary
to sum(marize| up)
overall,
at the end of the day
when it comes to
in order to
due to the fact that
the future (looks|is) (bright|promising)
```

Protect calibrated hedges, meaningful concessions, and summary sections required by the genre.

## 7. False ranges, forced triplets, and synonym cycling

```regex
from [^.;]{3,50} to [^.;]{3,50}
\b\w+, \w+, and \w+[.!?]
\b(\w+ \w+), (\w+ \w+), and (\w+ \w+)
```

Confirm ranges and triplets manually. Preserve every distinct fact. For synonym cycling, look for several labels for the same person or concept within one paragraph where repeating the established term would be clearer.

## 8. Formatting, cadence, and document shape

Review, do not automatically edit:

- repeated em dashes or colons used to manufacture emphasis;
- bold scattered through ordinary prose;
- decorative emoji headings or bullets;
- bold-label lists whose labels merely repeat the following sentence;
- headings on text too short to need navigation;
- a tidy preview, matched three-part body, and recap conclusion;
- three or more consecutive sentences of nearly equal length and shape;
- repeated paragraph lengths, openers, or closing morals;
- staccato one-line paragraphs outside a genre that calls for them.

Punctuation, title case, passive voice, parentheses, curly quotes, lists, and headings are not defects by themselves.

## 9. Soft clarity checks

These are supporting observations, not universal AI tells:

- a sentence that requires backtracking to parse;
- adverbs supporting a weak or unmeasured claim;
- elaborate alternatives to `is`, `has`, `use`, or `help`;
- a sentence that could appear unchanged in another project's documentation because it names no local mechanism, behavior, instruction, or evidence;
- an unexplained metaphor such as "north star," "flywheel," "gold-plating," or "endgame";
- a bold label or colon that restates rather than advances the point.

Prefer clarity, but do not turn anti-slop into a generic copy-editing pass. Established terminology and the author's consistent house style remain protected.
