#!/usr/bin/env bash
# Setup for adv-003: Server Smith
# Scaffolds a workspace where the learner authors a stdio MCP server. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/adv-003"

# Fresh start: remove learner artifacts so a previous solution can't pass
rm -f "$WORKSPACE/tools/word-server.py"
rm -f "$WORKSPACE/.mcp.json"

mkdir -p "$WORKSPACE/tools"
mkdir -p "$WORKSPACE/sample-texts"

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Word Tools

## Project Description

A small project that ships its own MCP server. The server is a Python 3
script (standard library only) that speaks the Model Context Protocol over
stdio — JSON-RPC 2.0 messages on stdin/stdout, one per line. It exposes a
`word_count` tool that counts the words in a given text.

## Tech Stack

- Python 3 (MCP server, stdlib only — no pip dependencies)
- MCP stdio protocol (JSON-RPC 2.0 over stdin/stdout)

## Project Structure

- `tools/word-server.py` — the MCP server (you build this)
- `tools/README.md` — reference for the MCP protocol shape
- `sample-texts/` — small text files to try the tool on
- `.mcp.json` — registers the server with Claude Code (you build this too)
EOF

# sample-texts — small files to exercise the word_count tool on
cat > "$WORKSPACE/sample-texts/pangram.txt" << 'EOF'
The quick brown fox jumps over the lazy dog.
EOF

cat > "$WORKSPACE/sample-texts/haiku.txt" << 'EOF'
An old silent pond
A frog jumps into the pond
Splash! Silence again
EOF

# tools/README.md — local reference for the MCP stdio protocol shape
cat > "$WORKSPACE/tools/README.md" << 'EOF'
# MCP stdio Protocol Reference

This is the protocol shape your `word-server.py` must implement. An MCP
stdio server is just a process that reads JSON-RPC 2.0 messages from
**stdin** (one JSON object per line) and writes responses to **stdout**
(one JSON object per line). Nothing else may go to stdout — debug output
belongs on stderr.

## Message Flow

The client (Claude Code) drives the conversation:

1. `initialize`              -> server replies with its capabilities
2. `notifications/initialized` -> a notification (no `id`) — do NOT reply
3. `tools/list`              -> server replies with its tool catalog
4. `tools/call`              -> server runs a tool and replies with content

When stdin closes (EOF), the server must exit cleanly.

## 1. initialize

Request:

    {"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2025-06-18", "capabilities": {}, "clientInfo": {"name": "client", "version": "1.0.0"}}}

Response:

    {"jsonrpc": "2.0", "id": 1, "result": {"protocolVersion": "2025-06-18", "capabilities": {"tools": {}}, "serverInfo": {"name": "word-server", "version": "1.0.0"}}}

## 2. notifications/initialized

    {"jsonrpc": "2.0", "method": "notifications/initialized"}

This is a notification: it has no `id`, so the server must NOT send a
response. Replying to a notification is a protocol violation.

## 3. tools/list

Request:

    {"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}}

Response — a `tools` array; each tool has `name`, `description`, and a
JSON Schema `inputSchema`:

    {"jsonrpc": "2.0", "id": 2, "result": {"tools": [{"name": "word_count", "description": "Counts the words in a text.", "inputSchema": {"type": "object", "properties": {"text": {"type": "string"}}, "required": ["text"]}}]}}

## 4. tools/call

Request:

    {"jsonrpc": "2.0", "id": 3, "method": "tools/call", "params": {"name": "word_count", "arguments": {"text": "the quick brown fox"}}}

Response — a `content` array of text blocks:

    {"jsonrpc": "2.0", "id": 3, "result": {"content": [{"type": "text", "text": "4"}]}}

## Errors

For an unknown method (that has an `id`), reply with a JSON-RPC error:

    {"jsonrpc": "2.0", "id": 5, "error": {"code": -32601, "message": "Method not found: some/method"}}

## Testing by Hand

Put one request per line in a file, then feed it to the server via
redirection (don't pipe strings into shells):

    python3 tools/word-server.py < requests.jsonl > responses.out
    cat responses.out
EOF
