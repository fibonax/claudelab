# Branch Out

When you're working on a feature and need to quickly fix a bug on another
branch, what do you do? Stash your changes, switch branches, fix the bug,
switch back, pop the stash... it's tedious and error-prone.

**Git worktrees** solve this by letting you check out multiple branches
simultaneously, each in its own directory. Every worktree is a fully
functional checkout — you can build, test, and commit independently without
disturbing your main working tree.

## Why Worktrees Matter

- **Parallel work** — work on two branches at the same time, no stashing
- **Isolation** — changes in one worktree don't affect another
- **Shared history** — all worktrees share the same `.git` repository,
  so branches, commits, and remotes stay in sync
- **Claude Code uses them** — when you run `claude --worktree`, Claude
  creates a git worktree so it can work on a separate branch without
  touching your current files

## How Worktrees Work

A worktree is created with `git worktree add`:

```bash
git worktree add <path> -b <new-branch>
```

This creates a new directory at `<path>`, checks out a new branch
`<new-branch>` there, and links it back to the main repository. You can
also attach to an existing branch by omitting `-b`:

```bash
git worktree add <path> <existing-branch>
```

Useful commands:

| Command | What it does |
|---|---|
| `git worktree add <path> -b <branch>` | Create a worktree with a new branch |
| `git worktree list` | List all worktrees |
| `git worktree remove <path>` | Remove a worktree |
| `git worktree prune` | Clean up stale worktree references |

## Your Task

This workspace is a small TypeScript project with a git repository. You're
on the `main` branch. The project has an auth module (`src/auth.ts`) that
needs improvement, but you want to work on that in isolation — without
changing anything on `main`.

### Step 1: Create a worktree

Create a worktree at `.worktrees/feature-auth/` on a new branch called
`feature/improve-auth`:

```bash
git worktree add .worktrees/feature-auth -b feature/improve-auth
```

### Step 2: Make changes in the worktree

Navigate into the worktree and create a new utility file for auth helpers:

```bash
cd .worktrees/feature-auth/
```

Create `src/auth-utils.ts` with some auth helper functions (the content
is up to you — even a simple utility function is fine).

### Step 3: Commit your changes

While inside the worktree directory, stage and commit your new file:

```bash
git add src/auth-utils.ts
git commit -m "feat(auth): add auth utility helpers"
```

### Step 4: Return and verify

Go back to the main workspace directory and verify that:

- The worktree is listed: `git worktree list`
- You're still on `main`: `git branch --show-current`
- Your main working tree is clean: `git status`
- The worktree has its own commit history

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-008/
```

Take a look at the existing files to understand the project:

- **`src/app.ts`** — the main application entry point
- **`src/auth.ts`** — the auth module (needs improvement)
- **`src/dashboard.ts`** — the dashboard module (needs new features)
- **`CLAUDE.md`** — project description

Notice you're on the `main` branch with a clean working tree — the
perfect starting point for creating a worktree.

You can work through this exercise in several ways:

- **Inside Claude Code** — ask Claude to run the git worktree commands
  for you and create the file
- **From the terminal** — run the commands yourself step by step
- **Mix both** — use the terminal for git commands and Claude for
  creating the TypeScript file

## Requirements

- A worktree exists (more than 1 entry in `git worktree list`)
- A branch named `feature/improve-auth` exists
- A new file exists in the worktree (e.g., `.worktrees/feature-auth/src/auth-utils.ts`)
- At least one commit exists in the worktree branch
- The main workspace is still on the `main` branch
- The main workspace has a clean working tree

## Tips

- You can't check out the same branch in two worktrees — that's why you
  create a new branch with `-b`
- The `.worktrees/` directory is just a convention — you can put worktrees
  anywhere, but keeping them inside the project makes cleanup easier
- After you're done with a worktree, clean up with
  `git worktree remove .worktrees/feature-auth`

## When You're Done

Run `/cclab:check` to validate your work.
