# Hints for cc-005: The Great Refactor

## Hint 1

Claude can rename things across your entire codebase in one go. Just tell
it what to rename and what the new name should be. Claude will find all
the references — the definition, imports, and call sites.

## Hint 2

Ask Claude to rename `getUserData` to `fetchUserProfile` everywhere — in
the function definition, all imports, and all call sites. Say "rename
across all files" to make sure Claude updates every file, not just one.

## Hint 3

Tell Claude: "Rename the function `getUserData` to `fetchUserProfile` in
every file in the src/ directory. Update the definition in
user-service.ts, and update all imports and call sites in users.ts,
admin.ts, auth.ts, and user.test.ts." There should be zero references
to the old name left anywhere.
