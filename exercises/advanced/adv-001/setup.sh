#!/usr/bin/env bash
# Setup for adv-001: Specialist Squad
# Scaffolds a small TS project with security smells for an auditor agent. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/adv-001"

# Reset learner-created artifacts so /cclab:reset restores the initial state
rm -f "$WORKSPACE/.claude/agents/auditor.md"

mkdir -p "$WORKSPACE/src/api"
mkdir -p "$WORKSPACE/.claude/agents"

# package.json
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "payments-service",
  "version": "1.0.0",
  "description": "Internal payments service (audit playground)",
  "type": "module",
  "scripts": {
    "build": "tsc"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# src/auth.ts — hardcoded secrets (intentional security smell)
cat > "$WORKSPACE/src/auth.ts" << 'EOF'
const JWT_SECRET = "hunter2-do-not-share";
const STRIPE_KEY = "sk_live_51Hxyz9876543210abcdef";

export function signToken(userId: any): string {
  // No expiry, no audience claim — token never dies
  return Buffer.from(userId + ":" + JWT_SECRET).toString("base64");
}

export function verifyToken(token: any): boolean {
  const decoded = Buffer.from(token, "base64").toString("utf8");
  return decoded.includes(JWT_SECRET);
}

export function chargeCard(amount: any) {
  console.log("Charging via " + STRIPE_KEY + " amount=" + amount);
}
EOF

# src/api/routes.ts — missing input validation, any types (intentional smells)
cat > "$WORKSPACE/src/api/routes.ts" << 'EOF'
import { signToken, chargeCard } from "../auth.js";

const payments: any[] = [];

export function handleLogin(body: any) {
  // No validation: body.username could be anything, including SQL
  const query = "SELECT * FROM users WHERE name = '" + body.username + "'";
  console.log("Running: " + query);
  return signToken(body.username);
}

export function handlePayment(body: any) {
  // No amount validation — negative amounts issue refunds for free
  payments.push({ user: body.user, amount: body.amount });
  chargeCard(body.amount);
  return { ok: true };
}

export function handleExport(params: any) {
  // Path traversal: params.file is used as-is
  console.log("Reading file: ./exports/" + params.file);
}
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Payments Service

## Project Description

A small internal payments service used as a playground for configuring a
locked-down security auditor subagent. The source code contains intentional
security issues for the auditor to find.

## Tech Stack

- TypeScript
- Node.js

## Known Smells

- Hardcoded secrets in src/auth.ts
- Missing input validation in src/api/routes.ts
- `any` types throughout
EOF
