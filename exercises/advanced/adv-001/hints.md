# Hints for adv-001: Specialist Squad

## Hint 1

This builds on the wf-005 agent format, but every restriction now lives in
the YAML frontmatter of `.claude/agents/auditor.md`. Beyond `name:` and
`description:`, you need four specialization fields: `tools:` (an allowlist —
only what you list is available), `disallowedTools:` (a denylist — explicitly
blocked), `model:` (pick one suited to fast scanning), and `permissionMode:`
(there's a mode that makes the agent read-only by design).

## Hint 2

Create `.claude/agents/auditor.md` with frontmatter containing:
`name: auditor`, a `description:` phrased as "Use this agent when...",
`tools: Read, Grep, Glob` (no Edit, Write, or Bash — the auditor must not be
able to modify anything), `disallowedTools: Write` (defense in depth: even if
the allowlist is widened later, Write stays blocked), `model: haiku` (fast,
cheap pattern scanning), and `permissionMode: plan` (read-only exploration
mode). The body is the agent's system prompt — write an audit checklist
covering hardcoded secrets, injection, input validation, and `any` types.
Make the file at least 15 lines.

## Hint 3

Create `.claude/agents/auditor.md` with this content:

```markdown
---
name: auditor
description: Use this agent when code needs a security audit — it scans for hardcoded secrets, injection risks, and missing validation, and reports findings without modifying anything.
tools: Read, Grep, Glob
disallowedTools: Write
model: haiku
permissionMode: plan
---

You are a security auditor. Scan the codebase and report issues — never
modify files.

## Audit Checklist

1. **Hardcoded secrets** — API keys, passwords, tokens in source files
2. **Injection** — string-concatenated SQL or shell commands from user input
3. **Input validation** — request bodies and params used without checks
4. **Type safety** — `any` types that bypass the compiler's protection
5. **Path traversal** — user-supplied values used in file paths

## Report Format

For each finding, give: file and line, severity (Critical/Warning/Info),
what the issue is, and a one-line suggested fix.
```
