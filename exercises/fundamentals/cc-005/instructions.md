# The Great Refactor

Renaming a function sounds simple — until it's used in five different files.
You have to update the definition, every import, and every call site. Miss
one and the build breaks.

This is where Claude really shines. Tell it to rename something and it will
find every reference across your entire codebase and update them all in one
pass — definition, imports, and call sites.

## Your Task

This project has a function called `getUserData()` defined in
`src/services/user-service.ts`. It's imported and used in four other files:

- `src/routes/users.ts`
- `src/routes/admin.ts`
- `src/middleware/auth.ts`
- `src/tests/user.test.ts`

The function needs to be renamed from `getUserData` to `fetchUserProfile`
**everywhere** — the definition, all imports, and all call sites.

Ask Claude to rename `getUserData` to `fetchUserProfile` across the entire
codebase. When you're done, there should be **zero** references to the old
name anywhere in `src/`.

## Requirements

- `getUserData` must not appear anywhere in `src/` (completely removed)
- `fetchUserProfile` must appear in all 5 files:
  - `src/services/user-service.ts` (the definition)
  - `src/routes/users.ts` (import and call)
  - `src/routes/admin.ts` (import and call)
  - `src/middleware/auth.ts` (import and call)
  - `src/tests/user.test.ts` (import and test)

## Tips

- Be explicit: tell Claude to rename "in every file" or "across the entire
  codebase" so it doesn't just update one file
- Claude will update the function definition, all import statements, and all
  call sites in a single operation
- After the rename, you can verify with a quick search — there should be no
  remaining references to the old name

## When You're Done

Run `/cclab:check` to validate your work.
