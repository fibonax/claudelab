#!/usr/bin/env bash
# Setup for cc-005: The Great Refactor
# Scaffolds a project with getUserData() used across 5 files. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-005"

mkdir -p "$WORKSPACE/src/services"
mkdir -p "$WORKSPACE/src/routes"
mkdir -p "$WORKSPACE/src/middleware"
mkdir -p "$WORKSPACE/src/tests"

# package.json
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "user-api",
  "version": "1.0.0",
  "description": "User management API with role-based access",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "node --test dist/**/*.test.js"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# tsconfig.json
cat > "$WORKSPACE/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"]
}
EOF

# src/services/user-service.ts — defines and exports getUserData()
cat > "$WORKSPACE/src/services/user-service.ts" << 'EOF'
export interface UserProfile {
  id: number;
  name: string;
  email: string;
  role: "admin" | "editor" | "viewer";
  lastLogin: Date;
}

const users: Map<number, UserProfile> = new Map();

export function getUserData(userId: number): UserProfile | null {
  const user = users.get(userId);
  if (!user) {
    return null;
  }
  return { ...user, lastLogin: new Date() };
}

export function createUser(
  name: string,
  email: string,
  role: UserProfile["role"],
): UserProfile {
  const id = users.size + 1;
  const user: UserProfile = {
    id,
    name,
    email,
    role,
    lastLogin: new Date(),
  };
  users.set(id, user);
  return user;
}
EOF

# src/routes/users.ts — imports and calls getUserData()
cat > "$WORKSPACE/src/routes/users.ts" << 'EOF'
import { getUserData } from "../services/user-service.js";

export function handleGetUser(userId: number): { status: number; body: unknown } {
  const user = getUserData(userId);
  if (!user) {
    return { status: 404, body: { error: "User not found" } };
  }
  return { status: 200, body: user };
}

export function handleGetUserEmail(userId: number): { status: number; body: unknown } {
  const user = getUserData(userId);
  if (!user) {
    return { status: 404, body: { error: "User not found" } };
  }
  return { status: 200, body: { email: user.email } };
}
EOF

# src/routes/admin.ts — imports and calls getUserData()
cat > "$WORKSPACE/src/routes/admin.ts" << 'EOF'
import { getUserData } from "../services/user-service.js";

export function handleAdminGetUser(userId: number): { status: number; body: unknown } {
  const user = getUserData(userId);
  if (!user) {
    return { status: 404, body: { error: "User not found" } };
  }
  if (user.role !== "admin") {
    return { status: 403, body: { error: "Insufficient permissions" } };
  }
  return { status: 200, body: user };
}

export function handleGetUserRole(userId: number): { status: number; body: unknown } {
  const user = getUserData(userId);
  if (!user) {
    return { status: 404, body: { error: "User not found" } };
  }
  return { status: 200, body: { role: user.role } };
}
EOF

# src/middleware/auth.ts — imports and calls getUserData()
cat > "$WORKSPACE/src/middleware/auth.ts" << 'EOF'
import { getUserData } from "../services/user-service.js";

export interface AuthContext {
  userId: number;
  role: string;
  authenticated: boolean;
}

export function authenticate(userId: number): AuthContext {
  const user = getUserData(userId);
  if (!user) {
    return { userId, role: "anonymous", authenticated: false };
  }
  return {
    userId: user.id,
    role: user.role,
    authenticated: true,
  };
}

export function requireRole(
  userId: number,
  requiredRole: string,
): boolean {
  const user = getUserData(userId);
  if (!user) {
    return false;
  }
  return user.role === requiredRole;
}
EOF

# src/tests/user.test.ts — imports and tests getUserData()
cat > "$WORKSPACE/src/tests/user.test.ts" << 'EOF'
import { describe, it } from "node:test";
import assert from "node:assert";
import { getUserData, createUser } from "../services/user-service.js";

describe("getUserData", () => {
  it("should return null for non-existent user", () => {
    const result = getUserData(999);
    assert.strictEqual(result, null);
  });

  it("should return user data for existing user", () => {
    const created = createUser("Alice", "alice@example.com", "editor");
    const result = getUserData(created.id);
    assert.notStrictEqual(result, null);
    assert.strictEqual(result!.name, "Alice");
    assert.strictEqual(result!.email, "alice@example.com");
  });

  it("should return a copy with updated lastLogin", () => {
    const created = createUser("Bob", "bob@example.com", "viewer");
    const result = getUserData(created.id);
    assert.notStrictEqual(result, null);
    assert.ok(result!.lastLogin instanceof Date);
  });
});
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# User API

## Project Description

A user management API with role-based access control. Supports user
creation, lookup, authentication, and role-based authorization.

## Tech Stack

- TypeScript
- Node.js

## Commands

- `npm run build` — compile TypeScript
- `npm start` — run the server
- `npm test` — run tests
EOF
