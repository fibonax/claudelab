#!/usr/bin/env bash
# Setup for cc-003: Convention Enforcer
# Scaffolds a project with CommonJS/var code that needs fixing. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-003"

mkdir -p "$WORKSPACE/src"

# package.json — ES module project
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "string-utils",
  "version": "1.0.0",
  "description": "A collection of string and date utility functions",
  "type": "module",
  "main": "dist/utils.js",
  "scripts": {
    "build": "tsc",
    "test": "node --test dist/**/*.test.js"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# tsconfig.json — TypeScript config
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

# src/utils.ts — intentionally uses CommonJS require() and var (the "wrong" style)
cat > "$WORKSPACE/src/utils.ts" << 'EOF'
var path = require("path");
var fs = require("fs");

var DEFAULT_DATE_FORMAT = "YYYY-MM-DD";

function formatDate(date: Date): string {
  var year = date.getFullYear();
  var month = String(date.getMonth() + 1).padStart(2, "0");
  var day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function parseConfig(filePath: string): Record<string, string> {
  var fullPath = path.resolve(filePath);
  var content = fs.readFileSync(fullPath, "utf-8");
  var lines = content.split("\n");
  var config: Record<string, string> = {};

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i].trim();
    if (line && !line.startsWith("#")) {
      var parts = line.split("=");
      var key = parts[0].trim();
      var value = parts.slice(1).join("=").trim();
      config[key] = value;
    }
  }
  return config;
}

function validateEmail(email: string): boolean {
  var pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return pattern.test(email);
}

function slugify(text: string): string {
  var result = text.toLowerCase();
  result = result.replace(/[^a-z0-9]+/g, "-");
  result = result.replace(/^-+|-+$/g, "");
  return result;
}

module.exports = { formatDate, parseConfig, validateEmail, slugify };
EOF

# CLAUDE.md — has project description, but NO code style section
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# String Utils

## Project Description

A collection of utility functions for string manipulation, date formatting,
configuration parsing, and input validation. Used as a shared library across
multiple internal services.

## Tech Stack

- TypeScript
- Node.js

## Commands

- `npm run build` — compile TypeScript
- `npm test` — run tests
EOF
