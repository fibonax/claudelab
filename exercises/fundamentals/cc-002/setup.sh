#!/usr/bin/env bash
# Setup for cc-002: Your First CLAUDE.md
# Scaffolds a minimal TypeScript project. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-002"

mkdir -p "$WORKSPACE/src"

# package.json — realistic Node.js project
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "task-manager",
  "version": "1.0.0",
  "description": "A simple REST API for managing tasks",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsc --watch",
    "test": "node --test dist/**/*.test.js"
  },
  "dependencies": {},
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# tsconfig.json — valid TypeScript config
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

# src/index.ts — simple entry point
cat > "$WORKSPACE/src/index.ts" << 'EOF'
interface Task {
  id: number;
  title: string;
  completed: boolean;
  createdAt: Date;
}

const tasks: Task[] = [];
let nextId = 1;

export function addTask(title: string): Task {
  const task: Task = {
    id: nextId++,
    title,
    completed: false,
    createdAt: new Date(),
  };
  tasks.push(task);
  return task;
}

export function listTasks(): Task[] {
  return [...tasks];
}

export function completeTask(id: number): Task | undefined {
  const task = tasks.find((t) => t.id === id);
  if (task) {
    task.completed = true;
  }
  return task;
}

console.log("Task Manager API ready");
EOF

# Do NOT create CLAUDE.md — that's the learner's job
