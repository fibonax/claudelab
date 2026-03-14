# Hints for wf-008: Branch Out

## Hint 1

Git worktrees let you check out multiple branches at the same time, each
in its own directory. Use `git worktree add <path> -b <branch-name>` to
create a new worktree with a fresh branch. The exercise expects the
worktree at `.worktrees/feature-auth/` on a branch called
`feature/improve-auth`. After creating the worktree, you'll need to
create a file inside it and commit the change.

## Hint 2

Run `git worktree add .worktrees/feature-auth -b feature/improve-auth`
from the workspace root. Then `cd .worktrees/feature-auth/` and create
a new file like `src/auth-utils.ts` — it can contain any valid TypeScript
code (even a simple export). Stage and commit it with
`git add src/auth-utils.ts && git commit -m "feat(auth): add auth utils"`.
Then `cd` back to the workspace root. Make sure you don't leave any
uncommitted changes on `main`.

## Hint 3

Run these commands from `~/.cclab/workspace/wf-008/`:

```bash
# Step 1: Create the worktree
git worktree add .worktrees/feature-auth -b feature/improve-auth

# Step 2: Create a file in the worktree
cat > .worktrees/feature-auth/src/auth-utils.ts << 'EOF'
export function hashPassword(password: string): string {
  // Simple hash placeholder — use bcrypt in production
  return Buffer.from(password).toString("base64");
}

export function validateToken(token: string): boolean {
  return token.length > 0;
}
EOF

# Step 3: Commit in the worktree
cd .worktrees/feature-auth
git add src/auth-utils.ts
git commit -m "feat(auth): add auth utility helpers"

# Step 4: Return to main workspace
cd ../..

# Step 5: Verify
git worktree list
git branch --show-current   # should say "main"
git status                  # should be clean
```
