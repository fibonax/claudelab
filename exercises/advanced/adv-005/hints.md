# Hints for adv-005: Forked Context

## Hint 1

This skill needs two new frontmatter fields beyond what wf-004 used. The
`arguments:` field declares named arguments -- `arguments: [target, audience]`
means the first thing the user types becomes `$target` and the second becomes
`$audience` in the body. The `context: fork` field runs the skill in an
isolated forked context so the document it reads never lands in your main
conversation. Create the skill at `.claude/skills/summarize/SKILL.md`.

## Hint 2

Create `.claude/skills/summarize/SKILL.md` with frontmatter containing:
`name: summarize`, `description:` (a when-to-use statement),
`arguments: [target, audience]`, `context: fork`, and
`disable-model-invocation: true`. In the body, start with a `#` heading,
reference `$target` (the file to read) and `$audience` (who the summary is
for), and lay out at least 3 numbered steps: read the file, distill the key
points, adapt the wording to the audience. The file needs 18+ lines total.

## Hint 3

Create `.claude/skills/summarize/SKILL.md`:

```
---
name: summarize
description: Use when the user wants a short summary of a document pitched at a specific audience
arguments: [target, audience]
context: fork
disable-model-invocation: true
---

# Summarize

Read the file at `$target` and write a summary pitched at `$audience`.

1. Read the file at `$target` in full and note its structure.
2. Distill the 3-5 points that matter most, dropping low-level detail.
3. Rewrite those points in language suited to `$audience` -- plain terms
   for managers, precise terms for engineers.
4. Return only the final summary as a short bulleted list, no preamble.

Keep the summary under 120 words. Because this skill runs in a forked
context, only the final summary reaches the main conversation.
```
