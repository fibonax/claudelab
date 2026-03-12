# Hints for cc-004: Code Detective

## Hint 1

Don't jump into fixing code. First, ask Claude to read and explore. Try
something like: "Read through this project and tell me what it does." Claude
can use Grep and Glob to search the codebase and report back to you.

## Hint 2

Ask Claude three things: (1) "What route files exist and what do they handle?"
(2) "What models does this project define?" (3) "Are there any bugs or typos
in the code?" Save all the answers in a file called `answers.md` in the
workspace root.

## Hint 3

Ask Claude: "Explore this codebase. List all route files, list all models,
and look for any bugs or typos. Write your findings to answers.md." Claude
should find the `emial` typo in `src/models/user.ts` — the field is
misspelled as `emial` instead of `email`.
