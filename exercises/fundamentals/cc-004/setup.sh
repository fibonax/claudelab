#!/usr/bin/env bash
# Setup for cc-004: Code Detective
# Scaffolds a multi-file API project with a deliberate bug. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-004"

mkdir -p "$WORKSPACE/src/routes"
mkdir -p "$WORKSPACE/src/models"
mkdir -p "$WORKSPACE/src/utils"

# package.json
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "blog-api",
  "version": "1.0.0",
  "description": "A simple blog API with users and posts",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsc --watch",
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

# src/models/user.ts — contains the deliberate "emial" typo
cat > "$WORKSPACE/src/models/user.ts" << 'EOF'
export interface User {
  id: number;
  name: string;
  emial: string;  // stores the user's email address
  createdAt: Date;
}

const users: User[] = [];
let nextId = 1;

export function createUser(name: string, email: string): User {
  const user: User = {
    id: nextId++,
    name,
    emial: email,
    createdAt: new Date(),
  };
  users.push(user);
  return user;
}

export function findUserById(id: number): User | undefined {
  return users.find((u) => u.id === id);
}

export function listUsers(): User[] {
  return [...users];
}
EOF

# src/models/post.ts
cat > "$WORKSPACE/src/models/post.ts" << 'EOF'
export interface Post {
  id: number;
  title: string;
  body: string;
  authorId: number;
  published: boolean;
  createdAt: Date;
}

const posts: Post[] = [];
let nextId = 1;

export function createPost(title: string, body: string, authorId: number): Post {
  const post: Post = {
    id: nextId++,
    title,
    body,
    authorId,
    published: false,
    createdAt: new Date(),
  };
  posts.push(post);
  return post;
}

export function findPostById(id: number): Post | undefined {
  return posts.find((p) => p.id === id);
}

export function listPosts(): Post[] {
  return [...posts];
}

export function publishPost(id: number): Post | undefined {
  const post = posts.find((p) => p.id === id);
  if (post) {
    post.published = true;
  }
  return post;
}
EOF

# src/routes/users.ts
cat > "$WORKSPACE/src/routes/users.ts" << 'EOF'
import { createUser, findUserById, listUsers } from "../models/user.js";
import { isValidEmail } from "../utils/validate.js";

export function handleGetUsers(): { status: number; body: unknown } {
  const users = listUsers();
  return { status: 200, body: users };
}

export function handleGetUser(id: number): { status: number; body: unknown } {
  const user = findUserById(id);
  if (!user) {
    return { status: 404, body: { error: "User not found" } };
  }
  return { status: 200, body: user };
}

export function handleCreateUser(
  name: string,
  email: string,
): { status: number; body: unknown } {
  if (!name || !email) {
    return { status: 400, body: { error: "Name and email are required" } };
  }
  if (!isValidEmail(email)) {
    return { status: 400, body: { error: "Invalid email format" } };
  }
  const user = createUser(name, email);
  return { status: 201, body: user };
}
EOF

# src/routes/posts.ts
cat > "$WORKSPACE/src/routes/posts.ts" << 'EOF'
import { createPost, findPostById, listPosts, publishPost } from "../models/post.js";
import { findUserById } from "../models/user.js";

export function handleGetPosts(): { status: number; body: unknown } {
  const posts = listPosts();
  return { status: 200, body: posts };
}

export function handleGetPost(id: number): { status: number; body: unknown } {
  const post = findPostById(id);
  if (!post) {
    return { status: 404, body: { error: "Post not found" } };
  }
  return { status: 200, body: post };
}

export function handleCreatePost(
  title: string,
  body: string,
  authorId: number,
): { status: number; body: unknown } {
  if (!title || !body) {
    return { status: 400, body: { error: "Title and body are required" } };
  }
  const author = findUserById(authorId);
  if (!author) {
    return { status: 404, body: { error: "Author not found" } };
  }
  const post = createPost(title, body, authorId);
  return { status: 201, body: post };
}

export function handlePublishPost(id: number): { status: number; body: unknown } {
  const post = publishPost(id);
  if (!post) {
    return { status: 404, body: { error: "Post not found" } };
  }
  return { status: 200, body: post };
}
EOF

# src/utils/validate.ts
cat > "$WORKSPACE/src/utils/validate.ts" << 'EOF'
export function isValidEmail(email: string): boolean {
  const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return pattern.test(email);
}

export function isNonEmptyString(value: unknown): value is string {
  return typeof value === "string" && value.trim().length > 0;
}

export function isPositiveInteger(value: unknown): value is number {
  return typeof value === "number" && Number.isInteger(value) && value > 0;
}
EOF

# src/index.ts — entry point that imports routes
cat > "$WORKSPACE/src/index.ts" << 'EOF'
import { handleGetUsers, handleGetUser, handleCreateUser } from "./routes/users.js";
import { handleGetPosts, handleGetPost, handleCreatePost, handlePublishPost } from "./routes/posts.js";

interface Route {
  method: string;
  path: string;
  handler: (...args: unknown[]) => { status: number; body: unknown };
}

const routes: Route[] = [
  { method: "GET", path: "/users", handler: handleGetUsers },
  { method: "GET", path: "/users/:id", handler: handleGetUser as Route["handler"] },
  { method: "POST", path: "/users", handler: handleCreateUser as Route["handler"] },
  { method: "GET", path: "/posts", handler: handleGetPosts },
  { method: "GET", path: "/posts/:id", handler: handleGetPost as Route["handler"] },
  { method: "POST", path: "/posts", handler: handleCreatePost as Route["handler"] },
  { method: "PATCH", path: "/posts/:id/publish", handler: handlePublishPost as Route["handler"] },
];

console.log("Blog API ready");
console.log("Available routes:");
for (const route of routes) {
  console.log(`  ${route.method} ${route.path}`);
}
EOF

# CLAUDE.md — basic project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Blog API

## Project Description

A simple blog API that manages users and posts. Users can create accounts,
write posts, and publish them. The API uses typed handler functions with
a simple route registry.

## Tech Stack

- TypeScript
- Node.js

## Commands

- `npm run build` — compile TypeScript
- `npm start` — run the server
- `npm run dev` — watch mode
- `npm test` — run tests
EOF

# Remove answers.md if it exists (idempotent reset)
rm -f "$WORKSPACE/answers.md"
