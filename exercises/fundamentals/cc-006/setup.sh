#!/usr/bin/env bash
# Setup for cc-006: Git Like a Pro
# Initializes a git repo with an initial commit on main. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-006"

# Idempotent: remove and recreate if it already exists
if [ -d "$WORKSPACE" ]; then
  rm -rf "$WORKSPACE"
fi

mkdir -p "$WORKSPACE/src"

# src/app.ts — simple starter file
cat > "$WORKSPACE/src/app.ts" << 'EOF'
interface AppConfig {
  port: number;
  host: string;
  debug: boolean;
}

const config: AppConfig = {
  port: 3000,
  host: "localhost",
  debug: false,
};

export function startApp(): void {
  console.log(`Server starting on ${config.host}:${config.port}`);
}

startApp();
EOF

# CLAUDE.md — includes Git section with conventional commits format
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Logger Service

## Project Description
A lightweight TypeScript logging utility for server applications.

## Tech Stack
- TypeScript
- Node.js

## Git

### Commit Convention
Use conventional commits for all commit messages:

```
<type>(<scope>): <description>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

Examples:
- `feat(logging): add structured log levels`
- `fix(config): resolve port binding issue`
- `chore: initial project setup`

### Branch Naming
Use the format: `feature/<short-description>` or `fix/<short-description>`
EOF

# Initialize git repo and make the initial commit
cd "$WORKSPACE"
git init --quiet
git checkout -b main --quiet
git add -A
git commit --quiet -m "chore: initial project setup"
