# Hints for cc-006: Git Like a Pro

## Hint 1

Claude understands git natively. You can ask it in plain English: "Create a
branch", "Add a file", "Commit with a conventional message." Try it step by
step — branch first, then add the file, then commit.

## Hint 2

First: "Create a feature branch called feature/add-logging and switch to it."
Then: "Create a logging utility in src/logger.ts with a log function."
Finally: "Commit this change with a conventional commit message starting with
feat." Check the CLAUDE.md — it shows the exact format.

## Hint 3

Tell Claude: "Switch to a new branch called feature/add-logging, create
src/logger.ts with a simple log function, then commit everything with the
message 'feat(logging): add logging utility'." Make sure the working tree is
clean after the commit — all changes must be staged and committed.
