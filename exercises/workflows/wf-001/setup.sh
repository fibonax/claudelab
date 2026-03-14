#!/usr/bin/env bash
# Setup for wf-001: Hook Line
# Scaffolds a project workspace for learning hook configuration. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-001"

mkdir -p "$WORKSPACE/src"

# src/app.ts — a small TypeScript application
cat > "$WORKSPACE/src/app.ts" << 'EOF'
import { greet, add, formatList } from "./utils.js";

const name = process.argv[2] || "World";

console.log(greet(name));
console.log(`2 + 3 = ${add(2, 3)}`);

const items = ["hooks", "skills", "agents"];
console.log(formatList(items));
EOF

# src/utils.ts — utility functions
cat > "$WORKSPACE/src/utils.ts" << 'EOF'
export function greet(name: string): string {
  return `Hello, ${name}!`;
}

export function add(a: number, b: number): number {
  return a + b;
}

export function formatList(items: string[]): string {
  if (items.length === 0) return "(empty)";
  if (items.length === 1) return items[0];
  const last = items[items.length - 1];
  const rest = items.slice(0, -1).join(", ");
  return `${rest}, and ${last}`;
}
EOF

# package.json — project config
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "hook-line",
  "version": "1.0.0",
  "description": "A small project for learning Claude Code hooks",
  "type": "module",
  "main": "dist/app.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/app.js"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Hook Line

## Project Description

A small TypeScript project used as a playground for learning Claude Code
hook configuration. The project itself is simple — the focus is on setting
up hooks that automate tasks when Claude edits files.

## Tech Stack

- TypeScript
- Node.js

## Commands

- `npm run build` — compile TypeScript
- `npm start` — run the application
EOF
