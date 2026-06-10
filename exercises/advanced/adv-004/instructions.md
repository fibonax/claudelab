# Parallel Worlds

In wf-008 you created a single worktree to work on one branch in isolation.
That was the warm-up. The real payoff of worktrees is **parallel
development**: two (or more) checkouts of the same repository, each on its
own branch, each evolving independently — and then everything merges back
into `main`.

This is exactly how you run multiple Claude Code sessions on one project.
Each session gets its own worktree, so two Claudes can edit, build, and
commit at the same time without stepping on each other's files. Claude Code
even automates it: `claude --worktree <name>` creates a worktree under
`.claude/worktrees/` for you. In this exercise you'll do it with plain git
commands so the mechanics stay visible — once you've done it by hand,
`--worktree` is no longer magic.

The flow you're about to practice:

```
main ──●──────────────────────●────●──  (merge both features back)
        \                    /    /
         ●  feature/stats ──●    /      (worktree 1)
          \                     /
           ●  feature/export ──●        (worktree 2)
```

## Your Task

The workspace is a small TypeScript project on `main` with a shared data
module (`src/data.ts`). Two independent features are planned: a **stats**
module and an **export** module. Build them in parallel worktrees, then
merge both back into `main`.

### Step 1: Create the first worktree

From the workspace root, create a worktree at `.worktrees/feature-stats/`
on a new branch `feature/stats`:

```bash
git worktree add .worktrees/feature-stats -b feature/stats
```

### Step 2: Build the stats feature

Inside that worktree, create `src/stats.ts` — any reasonable content works
(e.g., a function that sums or averages the record values). Then commit it
with a conventional message:

```bash
cd .worktrees/feature-stats
git add src/stats.ts
git commit -m "feat(stats): add summary statistics module"
cd ../..
```

### Step 3: Create the second worktree

While `feature/stats` still exists in its own world, create a second
worktree at `.worktrees/feature-export/` on a new branch `feature/export`.
Inside it, create `src/export.ts` (e.g., a function that turns records into
CSV lines) and commit it. Both worktrees now exist simultaneously — run
`git worktree list` and admire your parallel worlds.

### Step 4: Merge both features back

Return to the main checkout (the workspace root), make sure you're on
`main`, and merge both branches:

```bash
git checkout main
git merge feature/stats
git merge feature/export
```

The first merge fast-forwards; the second creates a merge commit because
the branches diverged. Both `src/stats.ts` and `src/export.ts` should now
exist on `main`, and `git status` should be clean.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/adv-004/
```

Look around to understand the project:

- **`src/app.ts`** — the entry point, with TODOs for both features
- **`src/data.ts`** — the shared data module both features build on
- **`CLAUDE.md`** — project description

You can work through this however you like: ask Claude to run the git
commands and write the TypeScript, do it all yourself in the terminal, or
mix both. For the full parallel experience, try opening two terminal tabs —
one per worktree — and switch between them as you build each feature.

## Requirements

- Branches `feature/stats` and `feature/export` both exist
- `src/stats.ts` was created and committed on `feature/stats`
- `src/export.ts` was created and committed on `feature/export`
- Both branches are merged into `main`
- `src/stats.ts` and `src/export.ts` exist in the main checkout
- `main` has at least 3 commits (initial + both features)
- The main checkout is on `main` with a clean working tree

## Tips

- Each worktree is a full checkout — `cd` into it and git commands operate
  on its branch, not on `main`
- You can't check out the same branch in two worktrees, which is why each
  one gets its own `-b` branch
- `git branch --merged main` shows which branches are already in `main` —
  the validator uses the same command
- After merging, the worktrees and branches are no longer needed; in a real
  project you'd clean up with `git worktree remove` and `git branch -d`
  (leave them in place here so the check can see them)
- This is the manual version of `claude --worktree stats` + a second
  session with `claude --worktree export` — same git plumbing underneath

## When You're Done

Run `/cclab:check` to validate your work.
