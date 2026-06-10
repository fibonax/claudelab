# Hints for adv-004: Parallel Worlds

## Hint 1

This is wf-008 twice, plus a merge. Create two worktrees with
`git worktree add <path> -b <branch>` — one at `.worktrees/feature-stats`
on branch `feature/stats`, one at `.worktrees/feature-export` on branch
`feature/export`. In each worktree, create the feature file
(`src/stats.ts` / `src/export.ts`) and commit it. Then go back to the
workspace root, make sure you're on `main`, and `git merge` each branch.

## Hint 2

The exact shape of each step:

- `git worktree add .worktrees/feature-stats -b feature/stats` from the
  workspace root (and the same for `feature-export` / `feature/export`)
- `cd` into a worktree before running `git add` / `git commit` — commands
  run inside a worktree affect that worktree's branch, not `main`
- The file content can be any valid TypeScript, even a single exported
  function
- Merging happens from the **main checkout** (the workspace root), not
  from inside a worktree: `git checkout main`, then
  `git merge feature/stats`, then `git merge feature/export`
- Finish with `git status` on main — it must be clean, so don't leave
  stray files in the workspace root

## Hint 3

Run these commands from `~/.cclab/workspace/adv-004/`:

```bash
# Worktree 1: stats
git worktree add .worktrees/feature-stats -b feature/stats
cat > .worktrees/feature-stats/src/stats.ts << 'EOF'
import type { Record } from "./data.js";

export function totalValue(records: Record[]): number {
  return records.reduce((sum, r) => sum + r.value, 0);
}
EOF
cd .worktrees/feature-stats
git add src/stats.ts
git commit -m "feat(stats): add summary statistics module"
cd ../..

# Worktree 2: export
git worktree add .worktrees/feature-export -b feature/export
cat > .worktrees/feature-export/src/export.ts << 'EOF'
import type { Record } from "./data.js";

export function toCsv(records: Record[]): string {
  const rows = records.map((r) => `${r.id},${r.label},${r.value}`);
  return ["id,label,value", ...rows].join("\n");
}
EOF
cd .worktrees/feature-export
git add src/export.ts
git commit -m "feat(export): add CSV export module"
cd ../..

# Merge both back into main
git checkout main
git merge feature/stats
git merge feature/export

# Verify
git branch --merged main   # both feature branches listed
git status                 # clean
ls src/                    # app.ts data.ts export.ts stats.ts
```
