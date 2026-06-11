# Forked Context

In wf-004 you built a skill that took positional arguments via `$ARGUMENTS`
and `$0`. That works, but it has two rough edges: positional variables get
cryptic as soon as a skill takes more than one argument, and a skill that
reads long documents dumps all that intermediate content into your main
conversation, eating context you wanted for actual work.

This exercise teaches the fix for both: **named arguments** and
**`context: fork`**.

## Named Arguments

The `arguments:` frontmatter field declares a list of argument names. Each
name maps to a position: the first argument the user types fills the first
name, the second fills the second, and so on. In the skill body you
reference them as `$name` instead of `$0` and `$1`:

```yaml
---
name: summarize
arguments: [target, audience]
---

Read the file at $target and summarize it for $audience.
```

Now `/summarize docs/changelog.md managers` gives `$target` the value
`docs/changelog.md` and `$audience` the value `managers`. The positional
forms still exist (`$ARGUMENTS` for everything, `$ARGUMENTS[N]` or `$N` for
the 0-indexed Nth argument), but named arguments read like documentation --
anyone opening the SKILL.md knows exactly what each argument means.

YAML accepts the list inline (`arguments: [target, audience]`) or as
dashed lines:

```yaml
arguments:
  - target
  - audience
```

## Forked Context

By default a skill runs inline: every file it reads and every intermediate
step lands in your main conversation. For a summarization skill that's
backwards -- you want the 30-line document *read* in private and only the
short summary *reported* back.

The `context: fork` frontmatter field does exactly that. The skill runs in
an isolated forked context -- a subagent-like execution with its own
conversation -- and only its final result returns to the main thread. Big
intermediate reading never pollutes your context window:

```yaml
---
name: summarize
context: fork
---
```

This is the go-to pattern for skills that read a lot and return a little:
summarization, log analysis, large-file audits.

## Your Task

Create a skill called `summarize` at `.claude/skills/summarize/SKILL.md`
that reads any document in the project and writes a summary pitched at a
specific audience -- and runs in a forked context so the document never
lands in your main conversation.

Your SKILL.md must include:

### Frontmatter (between `---` delimiters)

- `name: summarize`
- `description:` -- a when-to-use statement (e.g., "Use when the user wants
  a short summary of a document for a specific audience")
- `arguments:` declaring `target` and `audience` (inline list or dashed
  lines -- both work)
- `context: fork` so the skill runs in an isolated forked context
- `disable-model-invocation: true` so only an explicit `/summarize` runs it

### Body (after the frontmatter)

- Instruct Claude to read the file at `$target` and write a summary
  pitched at `$audience`
- Start with a `#` heading
- Include at least **3 numbered steps** (e.g., read, distill, adapt to the
  audience)
- The file must be at least **18 lines** total

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/adv-005/
```

Take a look at the existing files:

- **`docs/changelog.md`** -- a release changelog
- **`docs/design-note.md`** -- an architecture design note
- **`.claude/skills/`** -- empty skills directory (this is where your
  skill goes)

Both docs are around 30 lines -- long enough that you wouldn't want them
pasted into your conversation just to get a three-bullet summary. Create
the skill however you like: ask Claude to write the SKILL.md, or open the
workspace in your editor and write it yourself.

Once it exists, try it: `/summarize docs/design-note.md managers` -- and
notice the document reading happens out of sight.

## Requirements

- `.claude/skills/summarize/SKILL.md` exists
- Frontmatter has `name: summarize`
- Frontmatter has `description:`
- Frontmatter declares `arguments:` including both `target` and `audience`
- Frontmatter has `context: fork`
- Frontmatter has `disable-model-invocation: true`
- Body references both `$target` and `$audience`
- Contains at least 3 numbered steps
- Is at least 18 lines long

## Tips

- Argument order matters: `arguments: [target, audience]` means the first
  thing the user types is `$target`, the second is `$audience`
- Forked skills only report their final answer back -- so tell the skill
  exactly what shape that answer should take (e.g., "return 3-5 bullets,
  no preamble")
- A good `description:` says *when* to use the skill, not just what it is
- `disable-model-invocation: true` plus `context: fork` is a natural pair
  for utility skills: the user decides when to run it, and it stays out of
  the way while it works

## When You're Done

Run `/cclab:check` to validate your work.
