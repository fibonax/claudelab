#!/usr/bin/env bash
# Setup for cc-007: Command Center
# Scaffolds a basic project workspace. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-007"

# Idempotent: remove and recreate
if [ -d "$WORKSPACE" ]; then
  rm -rf "$WORKSPACE"
fi

mkdir -p "$WORKSPACE/src"

# CLAUDE.md — basic project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Notes App

## Project Description
A simple note-taking application built with TypeScript.

## Tech Stack
- TypeScript
- Node.js

## Commands
- `npm run build` — compile TypeScript
- `npm start` — run the app
- `npm test` — run tests
EOF

# src/index.ts — simple source file
cat > "$WORKSPACE/src/index.ts" << 'EOF'
interface Note {
  id: number;
  title: string;
  body: string;
  createdAt: Date;
}

const notes: Note[] = [];

export function createNote(title: string, body: string): Note {
  const note: Note = {
    id: notes.length + 1,
    title,
    body,
    createdAt: new Date(),
  };
  notes.push(note);
  return note;
}

export function listNotes(): Note[] {
  return [...notes];
}
EOF

# src/search.ts — another source file for context
cat > "$WORKSPACE/src/search.ts" << 'EOF'
import { listNotes } from "./index.js";

export function searchNotes(query: string) {
  return listNotes().filter(
    (note) =>
      note.title.toLowerCase().includes(query.toLowerCase()) ||
      note.body.toLowerCase().includes(query.toLowerCase()),
  );
}
EOF

# Do NOT create commands.md — that's the learner's job
