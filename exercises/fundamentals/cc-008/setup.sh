#!/usr/bin/env bash
# Setup for cc-008: Prompt Architect
# Scaffolds an API project with missing input validation. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-008"

# Idempotent: remove and recreate
if [ -d "$WORKSPACE" ]; then
  rm -rf "$WORKSPACE"
fi

mkdir -p "$WORKSPACE/src/api"
mkdir -p "$WORKSPACE/src/tests"

# CLAUDE.md — project description with code style conventions
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# User Management API

## Project Description
A REST API for managing user accounts — create, read, update, delete.

## Tech Stack
- TypeScript
- Node.js

## Code Style
- Use ES modules (import/export), never CommonJS (require)
- Use const by default, let when mutation is needed, never var
- Use TypeScript strict mode
- Check all external input before processing

## Commands
- `npm run build` — compile TypeScript
- `npm test` — run tests
- `npm start` — start the server
EOF

# src/api/types.ts — type definitions
cat > "$WORKSPACE/src/api/types.ts" << 'EOF'
export interface CreateUserInput {
  name: string;
  email: string;
  age: number;
}

export interface User {
  id: string;
  name: string;
  email: string;
  age: number;
  createdAt: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}
EOF

# src/api/handlers.ts — API handler with NO validation (the problem to fix)
cat > "$WORKSPACE/src/api/handlers.ts" << 'EOF'
import { CreateUserInput, User, ApiResponse } from "./types.js";

const users: User[] = [];
let nextId = 1;

function generateId(): string {
  return String(nextId++);
}

export function createUser(data: unknown): ApiResponse<User> {
  // TODO: no input checking — accepts anything blindly
  const input = data as CreateUserInput;

  const user: User = {
    id: generateId(),
    name: input.name,
    email: input.email,
    age: input.age,
    createdAt: new Date().toISOString(),
  };

  users.push(user);
  return { success: true, data: user };
}

export function getUser(id: string): ApiResponse<User> {
  const user = users.find((u) => u.id === id);
  if (!user) {
    return { success: false, error: "User not found" };
  }
  return { success: true, data: user };
}

export function listUsers(): ApiResponse<User[]> {
  return { success: true, data: [...users] };
}

export function deleteUser(id: string): ApiResponse<{ deleted: boolean }> {
  const index = users.findIndex((u) => u.id === id);
  if (index === -1) {
    return { success: false, error: "User not found" };
  }
  users.splice(index, 1);
  return { success: true, data: { deleted: true } };
}
EOF

# src/tests/ directory is empty — learner will create test files
# Do NOT create exploration.md, plan.md, or test files — those are the learner's job
