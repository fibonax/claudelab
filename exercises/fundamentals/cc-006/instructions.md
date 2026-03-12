# Git Like a Pro

Claude Code doesn't just edit files — it speaks git fluently. You can ask Claude to
create branches, stage changes, and write commits, all in plain English. Combined
with a CLAUDE.md that specifies your commit conventions, Claude becomes a git
workflow assistant that never forgets the format.

In this exercise you'll walk through a real feature branch workflow: branch off main,
add a new file, and commit it with a proper conventional commit message.

## Your Task

The workspace already has a git repo initialized on `main` with an initial commit.
There's a `CLAUDE.md` that specifies conventional commit format and a `src/app.ts`
starter file. Your job:

**Step 1 — Create a feature branch**

Ask Claude to create a new branch called `feature/add-logging` and switch to it.

**Step 2 — Add a logging utility**

Ask Claude to create `src/logger.ts` — a simple logging utility with at least a
basic log function. It should be a real, useful file (not empty).

**Step 3 — Commit with a conventional commit**

Ask Claude to commit the new file with a conventional commit message. The message
must start with `feat` (e.g., `feat(logging): add logging utility`). Check the
CLAUDE.md in the workspace — it describes the expected format.

**Step 4 — Verify**

Make sure everything is clean: the branch is `feature/add-logging`, the commit is
there, and the working tree has no uncommitted changes.

## Requirements

- Current branch must be `feature/add-logging`
- `src/logger.ts` must exist and have at least 3 lines of content
- The latest commit on this branch must contain `feat` in the message
- The working tree must be clean (everything committed)

## Tips

- Read the CLAUDE.md in the workspace — it tells Claude what commit format to use
- Claude can run git commands for you; you don't need to run them yourself
- If something goes wrong, you can ask Claude to check `git status` or `git log`

## When You're Done

Run `/cclab:check` to validate your work.
