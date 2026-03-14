#!/usr/bin/env bash
# Setup for wf-005: Agent Assembler
# Scaffolds a project with source files of varying quality. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-005"

mkdir -p "$WORKSPACE/src/api"
mkdir -p "$WORKSPACE/src/utils"
mkdir -p "$WORKSPACE/.claude/agents"

# src/app.ts — main application entry point
cat > "$WORKSPACE/src/app.ts" << 'EOF'
import { handleGetUser, handleCreateUser } from "./api/handlers.js";
import { log } from "./utils/logger.js";

const PORT = 3000;

log("info", "Starting application...");

// Simulated request routing
function handleRequest(method: string, path: string, body?: unknown): void {
  if (method === "GET" && path === "/users") {
    handleGetUser("123");
  } else if (method === "POST" && path === "/users") {
    handleCreateUser(body);
  } else {
    console.log("404 Not Found");
  }
}

handleRequest("GET", "/users");
handleRequest("POST", "/users", { name: "Alice", email: "alice@example.com" });

log("info", "Application started on port " + PORT);
EOF

# src/api/handlers.ts — API handler with NO error handling (intentional quality issue)
cat > "$WORKSPACE/src/api/handlers.ts" << 'EOF'
const API_KEY = "sk-1234567890abcdef";
const DB_HOST = "production-db.internal.company.com";
const DB_PASSWORD = "supersecret123";

interface User {
  id: string;
  name: string;
  email: string;
}

const users: User[] = [
  { id: "1", name: "Alice", email: "alice@example.com" },
  { id: "2", name: "Bob", email: "bob@example.com" },
];

export function handleGetUser(id: any) {
  const user = users.find(u => u.id === id);
  const response = JSON.stringify(user);
  console.log(response);
  return response;
}

export function handleCreateUser(data: any) {
  const newUser = {
    id: String(users.length + 1),
    name: data.name,
    email: data.email,
  };
  users.push(newUser);
  console.log("Created user: " + JSON.stringify(newUser));
  return newUser;
}

export function handleDeleteUser(id: any) {
  const index = users.findIndex(u => u.id === id);
  users.splice(index, 1);
  console.log("Deleted user " + id);
}

export function handleUpdateUser(id: any, data: any) {
  const user = users.find(u => u.id === id);
  user!.name = data.name;
  user!.email = data.email;
  console.log("Updated user " + id);
  return user;
}
EOF

# src/utils/logger.ts — logging utility
cat > "$WORKSPACE/src/utils/logger.ts" << 'EOF'
type LogLevel = "info" | "warn" | "error" | "debug";

export function log(level: LogLevel, message: string): void {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] [${level.toUpperCase()}] ${message}`);
}

export function logError(error: unknown): void {
  if (error instanceof Error) {
    log("error", error.message);
  } else {
    log("error", String(error));
  }
}
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Code Review Practice

## Project Description

A small API server project used as a playground for learning Claude Code
subagent configuration. The source code has intentional quality issues
that a code reviewer should catch.

## Tech Stack

- TypeScript
- Node.js

## Known Issues

The codebase has several quality problems:
- API handlers lack error handling
- Some functions use `any` types instead of proper types
- Hardcoded credentials in source files
- No input validation on API endpoints
- Missing null checks in update/delete operations
EOF
