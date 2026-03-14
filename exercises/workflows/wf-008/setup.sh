#!/usr/bin/env bash
# Setup for wf-008: Branch Out
# Scaffolds a git repo with an initial commit for learning worktrees. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-008"

# Check git version supports worktrees (>= 2.5)
GIT_VERSION=$(git --version | sed 's/git version //')
GIT_MAJOR=$(echo "$GIT_VERSION" | cut -d. -f1)
GIT_MINOR=$(echo "$GIT_VERSION" | cut -d. -f2)
if [ "$GIT_MAJOR" -lt 2 ] || { [ "$GIT_MAJOR" -eq 2 ] && [ "$GIT_MINOR" -lt 5 ]; }; then
  echo "ERROR: git >= 2.5 is required for worktree support (found $GIT_VERSION)"
  exit 1
fi

mkdir -p "$WORKSPACE/src"

# If .git already exists, clean up and reset to initial state
if [ -d "$WORKSPACE/.git" ]; then
  # Prune any stale worktrees
  git -C "$WORKSPACE" worktree prune 2>/dev/null

  # Remove any existing worktrees
  git -C "$WORKSPACE" worktree list --porcelain | grep "^worktree " | tail -n +2 | sed 's/^worktree //' | while read -r wt; do
    git -C "$WORKSPACE" worktree remove --force "$wt" 2>/dev/null
  done

  # Delete the feature branch if it exists
  git -C "$WORKSPACE" branch -D feature/improve-auth 2>/dev/null

  # Switch to main if not already there
  git -C "$WORKSPACE" checkout main 2>/dev/null
fi

# src/app.ts — main application entry point
cat > "$WORKSPACE/src/app.ts" << 'EOF'
import { authenticate } from "./auth.js";
import { renderDashboard } from "./dashboard.js";

async function main(): Promise<void> {
  const user = await authenticate("admin", "secret");

  if (user) {
    console.log(`Welcome, ${user.name}!`);
    renderDashboard(user);
  } else {
    console.log("Authentication failed.");
  }
}

main().catch(console.error);
EOF

# src/auth.ts — auth module (needs improvement)
cat > "$WORKSPACE/src/auth.ts" << 'EOF'
interface User {
  id: number;
  name: string;
  role: string;
}

const USERS: User[] = [
  { id: 1, name: "Admin", role: "admin" },
  { id: 2, name: "Editor", role: "editor" },
  { id: 3, name: "Viewer", role: "viewer" },
];

export async function authenticate(
  username: string,
  password: string
): Promise<User | null> {
  // TODO: This is a placeholder — needs proper auth logic
  // Currently just returns the first user regardless of credentials
  return USERS[0] || null;
}

export function getUserById(id: number): User | null {
  return USERS.find((u) => u.id === id) || null;
}
EOF

# src/dashboard.ts — dashboard module (needs new feature)
cat > "$WORKSPACE/src/dashboard.ts" << 'EOF'
interface User {
  id: number;
  name: string;
  role: string;
}

export function renderDashboard(user: User): void {
  console.log("=== Dashboard ===");
  console.log(`User: ${user.name}`);
  console.log(`Role: ${user.role}`);
  // TODO: Add stats panel
  // TODO: Add recent activity feed
  console.log("=================");
}
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Auth Dashboard

## Project Description

A small TypeScript application with user authentication and a dashboard.
The auth module needs improvement (better validation, token support) and
the dashboard needs new features (stats, activity feed).

## Tech Stack

- TypeScript
- Node.js

## Code Style

- Use ES modules (import/export)
- Use const by default, let when mutation is needed
- Use async/await for asynchronous operations

## Commands

- `npm run build` — compile TypeScript
- `npm start` — run the application
EOF

# Initialize git repo if not already initialized
if [ ! -d "$WORKSPACE/.git" ]; then
  git -C "$WORKSPACE" init
  # Rename default branch to main if needed (supports git < 2.28)
  git -C "$WORKSPACE" checkout -b main 2>/dev/null || true
fi

# Ensure .worktrees/ is gitignored (so worktree dir doesn't make main dirty)
if ! grep -q '.worktrees/' "$WORKSPACE/.gitignore" 2>/dev/null; then
  echo ".worktrees/" >> "$WORKSPACE/.gitignore"
fi

# Stage and commit all files
git -C "$WORKSPACE" add -A
# Only commit if there are changes to commit
if ! git -C "$WORKSPACE" diff --cached --quiet 2>/dev/null; then
  git -C "$WORKSPACE" commit -m "chore: initial project setup"
elif ! git -C "$WORKSPACE" rev-parse HEAD >/dev/null 2>&1; then
  # No commits yet, force the initial commit
  git -C "$WORKSPACE" commit -m "chore: initial project setup"
fi

# Ensure clean working tree
git -C "$WORKSPACE" checkout main 2>/dev/null
