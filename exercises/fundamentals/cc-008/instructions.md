# Prompt Architect

You've learned how to give Claude context (CLAUDE.md), explore codebases, make
edits, and use git. Now it's time to level up the way you *ask* Claude to do
things. The difference between a vague prompt and a structured one is often the
difference between a mediocre result and a great one.

In this capstone exercise you'll practice three prompt patterns that consistently
produce better results. Each pattern has a concrete task you must complete.

## The Three Patterns

### Pattern 1: Explore First

Before changing code, ask Claude to **read and understand** it. This prevents
blind edits and gives Claude the context it needs to make good decisions.

> "Explore the codebase and summarize the API structure in exploration.md."

### Pattern 2: Verify Against

Give Claude something to **verify its work against** — write tests first, then
implement. This catches mistakes early and ensures the implementation matches
your intent.

> "Write tests first, then implement the feature to make them pass."

### Pattern 3: Step-by-Step

Break complex tasks into **numbered steps**. This keeps Claude focused and gives
you checkpoints to review progress.

> "Create a plan: Step 1 — identify what's missing. Step 2 — list the rules.
> Step 3 — implement."

## Your Task

This workspace has an API handler (`src/api/handlers.ts`) that accepts user input
with **no validation at all** — it blindly trusts whatever it receives. Your job
is to fix this using all three prompt patterns.

**Challenge 1 — Explore First**

Ask Claude to explore this project and summarize the API structure. Save the
summary to `exploration.md` in the workspace root. It should mention the API
handlers or endpoints and be at least 5 lines long.

**Challenge 2 — Verify Against (Tests First)**

Ask Claude to write tests for input validation in
`src/tests/handlers.test.ts` — *before or alongside* implementing the actual
validation. The test file must contain real test code (using `test`, `describe`,
or `it`).

Then ask Claude to add input validation to `src/api/handlers.ts`. After this
step, the handler file should contain validation logic (look for "validate",
"validation", or type-checking code).

**Challenge 3 — Step-by-Step**

Ask Claude to create a plan in `plan.md` (in the workspace root) with numbered
steps for adding input validation. The plan should have at least 3 numbered
steps (e.g., `1.`, `2.`, `3.` or `Step 1`, `Step 2`, `Step 3`).

## Requirements

- `exploration.md` exists, mentions API/handler/endpoint, at least 5 lines
- `src/tests/handlers.test.ts` exists with real test code
- `plan.md` exists with at least 3 numbered steps
- `src/api/handlers.ts` contains validation logic

## Tips

- You don't have to complete these in order — but Explore First naturally
  comes before the others
- Read the CLAUDE.md in the workspace for code style conventions
- Be explicit in your prompts about *where* to save files

## When You're Done

Run `/cclab:check` to validate your work.
