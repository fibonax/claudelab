#!/usr/bin/env bash
# Setup for wf-003: Command Crafter
# Scaffolds a project with source files and an empty .claude/skills/ directory. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-003"

mkdir -p "$WORKSPACE/src"
mkdir -p "$WORKSPACE/.claude/skills"

# package.json — project configuration
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "code-toolkit",
  "version": "1.0.0",
  "description": "A small toolkit of code analysis utilities",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "test": "node --test dist/**/*.test.js"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# src/index.ts — main entry point
cat > "$WORKSPACE/src/index.ts" << 'EOF'
import { countLines, extractFunctions } from "./utils.js";

export interface AnalysisResult {
  filePath: string;
  lineCount: number;
  functions: string[];
  summary: string;
}

export function analyzeFile(filePath: string, content: string): AnalysisResult {
  const lineCount = countLines(content);
  const functions = extractFunctions(content);

  const summary = `File ${filePath} has ${lineCount} lines and ${functions.length} functions.`;

  return {
    filePath,
    lineCount,
    functions,
    summary,
  };
}

export function formatReport(results: AnalysisResult[]): string {
  const header = "# Code Analysis Report\n\n";
  const body = results
    .map(
      (r) =>
        `## ${r.filePath}\n- Lines: ${r.lineCount}\n- Functions: ${r.functions.join(", ") || "none"}\n`
    )
    .join("\n");

  return header + body;
}
EOF

# src/utils.ts — utility functions
cat > "$WORKSPACE/src/utils.ts" << 'EOF'
export function countLines(content: string): number {
  if (!content) return 0;
  return content.split("\n").length;
}

export function extractFunctions(content: string): string[] {
  const pattern = /(?:export\s+)?(?:async\s+)?function\s+(\w+)/g;
  const functions: string[] = [];
  let match: RegExpExecArray | null;

  while ((match = pattern.exec(content)) !== null) {
    functions.push(match[1]);
  }

  return functions;
}

export function truncate(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text;
  return text.slice(0, maxLength - 3) + "...";
}
EOF

# CLAUDE.md — project documentation
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Code Toolkit

## Project Description

A small toolkit for analyzing source code files. Provides utilities to count
lines, extract function names, and generate analysis reports.

## Tech Stack

- TypeScript
- Node.js (ES modules)

## Commands

- `npm run build` — compile TypeScript
- `npm test` — run tests
EOF
