# Hints for cc-003: Convention Enforcer

## Hint 1

CLAUDE.md isn't just documentation — it's an instruction set. If you write
"always use ES modules", Claude will follow that when writing or fixing code.
Look at the existing CLAUDE.md — it has a project description but no code
style rules. Add a Code Style section with your conventions.

## Hint 2

Your CLAUDE.md needs a `## Code Style` section. What rules? Think about the
three bad patterns in `src/utils.ts`: CommonJS `require()`, `var` declarations,
and `module.exports`. Once you've written the rules, ask Claude to apply them
to the code. Both parts need to be done — updating CLAUDE.md AND fixing the code.

## Hint 3

Add this to CLAUDE.md:

```
## Code Style

- Use ES modules (import/export), never CommonJS (require)
- Use const by default, let when mutation is needed, never var
- Use TypeScript strict mode
```

Then tell Claude: "Fix src/utils.ts to follow the code style rules in
CLAUDE.md." All `require()` calls should become `import`, all `var`
should become `const` or `let`, and `module.exports` should become
`export { ... }`.
