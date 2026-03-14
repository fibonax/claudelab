#!/usr/bin/env bash
# Setup for wf-006: Plan & Conquer
# Scaffolds a project with multiple improvement opportunities. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-006"

mkdir -p "$WORKSPACE/src/api"
mkdir -p "$WORKSPACE/src/services"
mkdir -p "$WORKSPACE/src/utils"
mkdir -p "$WORKSPACE/.claude/skills"
mkdir -p "$WORKSPACE/.claude/agents"

# src/api/handlers.ts — API handlers with no input validation and no error handling
cat > "$WORKSPACE/src/api/handlers.ts" << 'EOF'
import { UserService } from "../services/user-service.js";

const userService = new UserService();

export async function getUser(req: any, res: any) {
  const user = await userService.findById(req.params.id);
  res.json(user);
}

export async function createUser(req: any, res: any) {
  const user = await userService.create(req.body);
  res.status(201).json(user);
}

export async function updateUser(req: any, res: any) {
  const user = await userService.update(req.params.id, req.body);
  res.json(user);
}

export async function deleteUser(req: any, res: any) {
  await userService.delete(req.params.id);
  res.status(204).send();
}

export async function listUsers(req: any, res: any) {
  const users = await userService.findAll();
  res.json(users);
}
EOF

# src/api/types.ts — incomplete type definitions
cat > "$WORKSPACE/src/api/types.ts" << 'EOF'
export interface User {
  id: string;
  name: string;
  email: string;
}

// TODO: Add CreateUserRequest interface with validation fields
// TODO: Add UpdateUserRequest interface (partial updates)
// TODO: Add ApiResponse wrapper type with status and data
// TODO: Add PaginatedResponse type for list endpoints
// TODO: Add ErrorResponse type for error handling
EOF

# src/services/user-service.ts — hardcoded values and no logging
cat > "$WORKSPACE/src/services/user-service.ts" << 'EOF'
import { User } from "../api/types.js";

export class UserService {
  private users: User[] = [];

  async findById(id: string): Promise<User | undefined> {
    return this.users.find((u) => u.id === id);
  }

  async findAll(): Promise<User[]> {
    return this.users;
  }

  async create(data: any): Promise<User> {
    const user: User = {
      id: String(Math.floor(Math.random() * 10000)),
      name: data.name,
      email: data.email,
    };
    this.users.push(user);
    return user;
  }

  async update(id: string, data: any): Promise<User | undefined> {
    const index = this.users.findIndex((u) => u.id === id);
    if (index === -1) return undefined;
    this.users[index] = { ...this.users[index], ...data };
    return this.users[index];
  }

  async delete(id: string): Promise<boolean> {
    const index = this.users.findIndex((u) => u.id === id);
    if (index === -1) return false;
    this.users.splice(index, 1);
    return true;
  }

  getMaxUsers(): number {
    return 100;
  }

  getDefaultRole(): string {
    return "user";
  }

  getApiVersion(): string {
    return "v1";
  }
}
EOF

# src/utils/logger.ts — stub logger with only console.log
cat > "$WORKSPACE/src/utils/logger.ts" << 'EOF'
export class Logger {
  log(message: string): void {
    console.log(message);
  }
}

// TODO: Add log levels (info, warn, error, debug)
// TODO: Add timestamp to log output
// TODO: Add structured logging (JSON format)
// TODO: Add context/prefix support (e.g., "[UserService] ...")
EOF

# package.json — project config
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "plan-and-conquer",
  "version": "1.0.0",
  "description": "A user API service used for learning the plan-then-implement workflow",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# CLAUDE.md — project description listing known issues
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Plan & Conquer API

## Project Description

A simple user API service with CRUD operations. The project is functional but
has several areas that need improvement.

## Tech Stack

- TypeScript
- Node.js

## Commands

- `npm run build` — compile TypeScript
- `npm start` — run the application

## Known Issues

The following areas need attention:

1. **No input validation** — `src/api/handlers.ts` accepts any input without
   checking required fields, types, or formats. Missing name or email should
   return a 400 error.

2. **No error handling** — `src/api/handlers.ts` has no try/catch blocks.
   If the service throws, the API crashes instead of returning a proper error
   response.

3. **Incomplete types** — `src/api/types.ts` only has the `User` interface.
   It needs request/response types: `CreateUserRequest`, `UpdateUserRequest`,
   `ApiResponse`, `PaginatedResponse`, and `ErrorResponse`.

4. **Hardcoded values** — `src/services/user-service.ts` has hardcoded
   `getMaxUsers()`, `getDefaultRole()`, and `getApiVersion()` that should be
   configurable (environment variables or a config object).

5. **Stub logger** — `src/utils/logger.ts` only has a basic `console.log`.
   It needs log levels (info, warn, error, debug), timestamps, and
   structured output.

6. **No logging in service** — `src/services/user-service.ts` performs
   operations silently. Important actions (create, update, delete) should
   be logged.
EOF
