#!/usr/bin/env bash
# Setup for wf-004: Skill Surgeon
# Scaffolds a project with several source files, CLAUDE.md with code style
# conventions, and an empty .claude/skills/ directory. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-004"

mkdir -p "$WORKSPACE/src"
mkdir -p "$WORKSPACE/.claude/skills"

# src/app.ts -- main application entry point
cat > "$WORKSPACE/src/app.ts" << 'EOF'
import { createServer } from "./server.js";
import { loadConfig } from "./config.js";
import { logger } from "./logger.js";

const config = loadConfig();
const server = createServer(config);

server.listen(config.port, () => {
  logger.info(`Server started on port ${config.port}`);
});

process.on("uncaughtException", (error: Error) => {
  logger.error("Uncaught exception", error);
  process.exit(1);
});
EOF

# src/server.ts -- HTTP server with request handling
cat > "$WORKSPACE/src/server.ts" << 'EOF'
import http from "node:http";
import { logger } from "./logger.js";
import type { AppConfig } from "./config.js";

export function createServer(config: AppConfig): http.Server {
  return http.createServer((req, res) => {
    const start = Date.now();

    if (req.url === "/health") {
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ status: "ok" }));
    } else if (req.url === "/api/users") {
      // TODO: This handler does too many things -- needs refactoring
      const data = [
        { id: 1, name: "Alice", email: "alice@example.com" },
        { id: 2, name: "Bob", email: "bob@example.com" },
      ];
      const filtered = data.filter((u) => u.name !== "");
      const mapped = filtered.map((u) => ({ ...u, name: u.name.trim() }));
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify(mapped));
    } else {
      res.writeHead(404, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: "Not found" }));
    }

    const duration = Date.now() - start;
    logger.info(`${req.method} ${req.url} ${res.statusCode} ${duration}ms`);
  });
}
EOF

# src/config.ts -- configuration loader
cat > "$WORKSPACE/src/config.ts" << 'EOF'
export interface AppConfig {
  port: number;
  environment: string;
  logLevel: string;
  dbUrl: string;
}

export function loadConfig(): AppConfig {
  return {
    port: Number(process.env.PORT) || 3000,
    environment: process.env.NODE_ENV || "development",
    logLevel: process.env.LOG_LEVEL || "info",
    dbUrl: process.env.DATABASE_URL || "postgres://localhost:5432/app",
  };
}
EOF

# src/logger.ts -- simple logging utility
cat > "$WORKSPACE/src/logger.ts" << 'EOF'
type LogLevel = "debug" | "info" | "warn" | "error";

function formatMessage(level: LogLevel, message: string, meta?: unknown): string {
  const timestamp = new Date().toISOString();
  const metaStr = meta ? ` ${JSON.stringify(meta)}` : "";
  return `[${timestamp}] ${level.toUpperCase()}: ${message}${metaStr}`;
}

export const logger = {
  debug: (message: string, meta?: unknown) =>
    console.debug(formatMessage("debug", message, meta)),
  info: (message: string, meta?: unknown) =>
    console.info(formatMessage("info", message, meta)),
  warn: (message: string, meta?: unknown) =>
    console.warn(formatMessage("warn", message, meta)),
  error: (message: string, meta?: unknown) =>
    console.error(formatMessage("error", message, meta)),
};
EOF

# package.json -- project config
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "skill-surgeon",
  "version": "1.0.0",
  "description": "A small HTTP server for practicing skill authoring",
  "type": "module",
  "main": "dist/app.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/app.js",
    "dev": "node --watch dist/app.js"
  },
  "devDependencies": {
    "typescript": "^5.4.0",
    "@types/node": "^20.0.0"
  }
}
EOF

# tsconfig.json -- TypeScript config
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

# CLAUDE.md -- project description with code style conventions
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Skill Surgeon

## Project Description

A small HTTP server application used as a playground for practicing
advanced skill authoring in Claude Code. The codebase has several files
with different patterns -- perfect for building a refactoring skill.

## Tech Stack

- TypeScript (strict mode)
- Node.js (ES modules)

## Code Style

- Use ES modules (import/export), never CommonJS (require)
- Use const by default, let when mutation is needed, never var
- Use TypeScript strict mode
- Prefer named exports over default exports
- Use kebab-case for file names, PascalCase for types, camelCase for variables

## Commands

- `npm run build` -- compile TypeScript
- `npm start` -- start the server
- `npm run dev` -- start with watch mode
EOF
