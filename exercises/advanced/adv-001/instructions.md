# Specialist Squad

In wf-005 you built your first subagent with a `tools:` restriction. That was
the basic version. Real specialist agents get the full treatment: an explicit
tool allowlist, an explicit denylist, a model choice that fits the job, and a
permission mode that enforces how the agent behaves.

## The Full Subagent Configuration Surface

Subagents live in `.claude/agents/<name>.md` (project-level) or
`~/.claude/agents/` (user-level, available in all projects). Only `name` and
`description` are required — everything else is specialization:

- **`name`** — unique identifier (kebab-case)
- **`description`** — when Claude should use this agent. Claude
  **auto-delegates** based on this field, so write it as a when-to-use
  statement ("Use this agent when..."), not just a label.
- **`tools`** — an **allowlist**. If omitted, the agent inherits *all* tools.
  Listing tools means *only* these are available.
- **`disallowedTools`** — a **denylist**. Even if a tool would otherwise be
  available, listing it here blocks it. Combining an allowlist with a
  denylist is defense in depth: if someone later widens `tools:`, the
  denylist still holds.
- **`model`** — `sonnet`, `opus`, `haiku`, `inherit`, or a full model ID.
  Match the model to the work: `haiku` is fast and cheap, perfect for
  pattern-scanning jobs; save `opus` for deep reasoning.
- **`permissionMode`** — `default`, `acceptEdits`, `plan`, or
  `bypassPermissions`. `plan` puts the agent in read-only exploration mode —
  it can look but not touch.

The markdown body below the frontmatter is the agent's **system prompt** —
this is where its expertise lives.

## Your Task

The workspace contains a small payments service with real security smells:
hardcoded secrets, missing input validation, `any` types everywhere. Build a
locked-down **security auditor** subagent at `.claude/agents/auditor.md` that
can scan the code but is structurally incapable of changing it:

1. Frontmatter with `name: auditor` and a `description:` written as a
   when-to-use statement
2. A `tools:` allowlist of read-only tools: `Read, Grep, Glob` — and nothing
   that can modify state (no `Edit`, `Write`, or `Bash`)
3. A `disallowedTools:` denylist that includes `Write` — defense in depth
4. A `model:` choice of `haiku`, `sonnet`, `opus`, or `inherit` —
   `haiku` is the right call for fast scanning
5. `permissionMode: plan` — read-only exploration mode
6. A body that is a real system prompt: who the agent is, an audit checklist
   covering the kinds of issues in this codebase, and how to report findings

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/adv-001/
```

Look at what the auditor will be scanning:

- **`src/auth.ts`** — hardcoded JWT secret and a live-looking API key
- **`src/api/routes.ts`** — string-concatenated SQL, unvalidated amounts,
  path traversal
- **`CLAUDE.md`** — project description
- **`.claude/agents/`** — empty directory where your agent goes

Then create `.claude/agents/auditor.md` — inside Claude Code, in your editor,
or from the terminal with `nano`/`vim`.

## Requirements

- `.claude/agents/auditor.md` exists
- Frontmatter has `name: auditor`
- Frontmatter has a `description:`
- Frontmatter `tools:` line includes `Read` or `Grep`, and does NOT include
  `Edit`, `Write`, or `Bash`
- Frontmatter `disallowedTools:` line includes `Write`
- Frontmatter `model:` is one of `haiku`, `sonnet`, `opus`, or `inherit`
- Frontmatter has `permissionMode:` containing `plan`
- File is at least 15 lines long

## Tips

- All the configuration fields must be in the **frontmatter** (between the
  `---` delimiters) — the validator checks there, not the body
- `tools:` and `disallowedTools:` are comma-separated lists, e.g.
  `tools: Read, Grep, Glob`
- Skim `src/auth.ts` and `src/api/routes.ts` first — write your audit
  checklist around the actual smells (secrets, injection, validation, types)
- A good `description:` starts with "Use this agent when..." so Claude knows
  when to delegate to it automatically

## When You're Done

Run `/cclab:check` to validate your work.
