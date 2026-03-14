# Hints for wf-005: Agent Assembler

## Hint 1

Subagents live in `.claude/agents/` as markdown files. Like skills, they have
YAML frontmatter (between `---` delimiters) with configuration, and a markdown
body with instructions. The key difference from skills is the `tools:` field
in frontmatter — you control exactly which tools the agent can use. A code
reviewer should only have read-only tools (no Edit or Write).

## Hint 2

Create `.claude/agents/code-reviewer.md` with frontmatter containing
`name: code-reviewer`, a meaningful `description:`, and
`tools: Read, Grep, Glob, Bash` (read-only tools only — no Edit or Write).
In the body, write a review checklist with at least 4 criteria (error handling,
naming conventions, code duplication, security). Organize the feedback output
into priority levels: critical, warnings, and suggestions. Make sure the file
is at least 15 lines.

## Hint 3

Create `.claude/agents/code-reviewer.md` with this content:

```markdown
---
name: code-reviewer
description: Reviews code for quality, security, and maintainability issues
tools: Read, Grep, Glob, Bash
---

You are a code reviewer. When invoked, analyze the specified files or directory
for quality issues.

## Review Checklist

1. **Error handling** — are errors caught and handled? Look for missing
   try/catch blocks and unhandled promise rejections
2. **Naming conventions** — are variables, functions, and files named clearly
   and consistently?
3. **Code duplication** — is there repeated logic that should be extracted
   into shared functions?
4. **Security** — are there hardcoded secrets, missing input validation,
   or unsafe operations?

## Output Format

Organize findings by priority:

- **Critical** — must fix before shipping
- **Warnings** — should fix soon
- **Suggestions** — nice to have improvements
```
