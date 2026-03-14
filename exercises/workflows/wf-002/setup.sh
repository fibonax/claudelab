#!/usr/bin/env bash
# Setup for wf-002: Guard Rails
# Scaffolds a project with sensitive and regular files. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-002"

mkdir -p "$WORKSPACE/src"
mkdir -p "$WORKSPACE/secrets"
mkdir -p "$WORKSPACE/.claude"

# src/app.ts — main application
cat > "$WORKSPACE/src/app.ts" << 'EOF'
import { connectDb, query } from "./db.js";

interface User {
  id: number;
  name: string;
  email: string;
}

async function getUsers(): Promise<User[]> {
  const db = await connectDb();
  const result = await query(db, "SELECT * FROM users");
  return result.rows as User[];
}

async function main(): Promise<void> {
  const users = await getUsers();
  console.log(`Found ${users.length} users`);
  for (const user of users) {
    console.log(`  - ${user.name} (${user.email})`);
  }
}

main().catch(console.error);
EOF

# src/db.ts — database connection module
cat > "$WORKSPACE/src/db.ts" << 'EOF'
interface DbConnection {
  host: string;
  port: number;
  connected: boolean;
}

interface QueryResult {
  rows: Record<string, unknown>[];
  rowCount: number;
}

export async function connectDb(): Promise<DbConnection> {
  const host = process.env.DB_HOST ?? "localhost";
  const port = parseInt(process.env.DB_PORT ?? "5432", 10);
  console.log(`Connecting to database at ${host}:${port}`);
  return { host, port, connected: true };
}

export async function query(
  db: DbConnection,
  sql: string,
): Promise<QueryResult> {
  if (!db.connected) {
    throw new Error("Database not connected");
  }
  console.log(`Executing: ${sql}`);
  return { rows: [], rowCount: 0 };
}
EOF

# .env — fake credentials (sensitive!)
cat > "$WORKSPACE/.env" << 'EOF'
# Database configuration
DB_HOST=prod-db.example.com
DB_PORT=5432
DB_USER=admin
DB_PASSWORD=fake-password-do-not-use

# API configuration
API_KEY=sk-fake-api-key-12345
API_SECRET=fake-secret-67890

# Feature flags
ENABLE_LOGGING=true
DEBUG_MODE=false
EOF

# secrets/api-keys.json — fake API keys (sensitive!)
cat > "$WORKSPACE/secrets/api-keys.json" << 'EOF'
{
  "stripe": {
    "publishable": "pk_test_fake_stripe_key",
    "secret": "sk_test_fake_stripe_secret"
  },
  "sendgrid": {
    "api_key": "SG.fake_sendgrid_key_do_not_use"
  },
  "aws": {
    "access_key_id": "AKIAFAKEACCESSKEY",
    "secret_access_key": "fake+aws+secret+key+do+not+use"
  }
}
EOF

# CLAUDE.md — project description mentioning security practices
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# User Service

## Project Description

A user management service with database connectivity and external API
integrations. Handles user CRUD operations, authentication tokens, and
third-party service connections.

## Tech Stack

- TypeScript
- Node.js
- PostgreSQL

## Security Practices

- Never commit `.env` files or `secrets/` directory contents to version control
- API keys and database credentials are stored in environment variables
- Use `.env.example` (without real values) for documentation
- Rotate credentials regularly

## Commands

- `npm run build` — compile TypeScript
- `npm test` — run tests
- `npm run dev` — start development server
EOF
