#!/usr/bin/env bash
# Setup for adv-002: Iron Gate
# Scaffolds a small maintenance CLI for learning blocking PreToolUse hooks. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/adv-002"

# Reset learner-created artifacts so /cclab:reset restores the initial state
rm -f "$WORKSPACE/.claude/settings.json" \
      "$WORKSPACE/scripts/guard.sh"
rmdir "$WORKSPACE/.claude" "$WORKSPACE/scripts" 2> /dev/null

mkdir -p "$WORKSPACE/src"

# src/cleanup.ts — the deletion logic that motivates the guard
cat > "$WORKSPACE/src/cleanup.ts" << 'EOF'
import { rm } from "node:fs/promises";

export interface CleanupTarget {
  path: string;
  recursive: boolean;
}

const TEMP_PATTERNS = [".cache", "tmp", "dist", "node_modules/.cache"];

export function isTempPath(path: string): boolean {
  return TEMP_PATTERNS.some((pattern) => path.includes(pattern));
}

export async function removeTarget(target: CleanupTarget): Promise<void> {
  if (!isTempPath(target.path)) {
    throw new Error(`Refusing to delete non-temp path: ${target.path}`);
  }
  await rm(target.path, { recursive: target.recursive, force: true });
  console.log(`Removed: ${target.path}`);
}
EOF

# src/index.ts — CLI entry point
cat > "$WORKSPACE/src/index.ts" << 'EOF'
import { removeTarget } from "./cleanup.js";

const path = process.argv[2];

if (!path) {
  console.error("Usage: sweep <path>");
  process.exit(1);
}

removeTarget({ path, recursive: true }).catch((err: Error) => {
  console.error(err.message);
  process.exit(1);
});
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Sweep

## Project Description

A small maintenance CLI that deletes temp directories (caches, build
output). Because the tool's whole job is running deletions, this project
uses a blocking PreToolUse hook as a safety gate: any Bash command that
looks like a catastrophic delete must be refused before it runs.

## Tech Stack

- TypeScript
- Node.js

## Safety Rules

- Never run `rm -rf` against `/` or `~`
- The PreToolUse guard hook (scripts/guard.sh) enforces this
EOF
