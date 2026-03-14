#!/usr/bin/env bash
# Setup for wf-007: Plug It In
# Scaffolds a project with a sample MCP server for learners to configure. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/wf-007"

mkdir -p "$WORKSPACE/tools"

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Timestamp Tools

## Project Description

A small project with a sample MCP server that provides timestamp and text
utility tools. The server is a Python3 script that implements the Model
Context Protocol (MCP) using stdio transport.

## Tech Stack

- Python 3 (MCP server)
- MCP stdio protocol (JSON-RPC over stdin/stdout)

## Available Tools (via MCP)

- `get_timestamp` — returns the current time in multiple formats
- `word_count` — counts words, characters, and lines in text
EOF

# tools/timestamp-server.py — sample MCP server (Python3, stdlib only)
cat > "$WORKSPACE/tools/timestamp-server.py" << 'PYEOF'
#!/usr/bin/env python3
"""
Minimal MCP server implementing the stdio transport protocol.

Exposes two tools:
  - get_timestamp: returns the current time in ISO, Unix, and human-readable formats
  - word_count: counts words, characters, and lines in a given text

Protocol: JSON-RPC 2.0 over stdin/stdout (one message per line).
Requires only Python 3 standard library.
"""

import json
import sys
import datetime

SERVER_NAME = "timestamp-server"
SERVER_VERSION = "1.0.0"

TOOLS = [
    {
        "name": "get_timestamp",
        "description": "Returns the current time in ISO 8601, Unix epoch, and human-readable formats.",
        "inputSchema": {
            "type": "object",
            "properties": {},
            "required": []
        }
    },
    {
        "name": "word_count",
        "description": "Counts the number of words, characters, and lines in the given text.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "text": {
                    "type": "string",
                    "description": "The text to analyze"
                }
            },
            "required": ["text"]
        }
    }
]


def handle_initialize(request_id):
    """Handle the initialize method."""
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "result": {
            "protocolVersion": "2024-11-05",
            "capabilities": {
                "tools": {}
            },
            "serverInfo": {
                "name": SERVER_NAME,
                "version": SERVER_VERSION
            }
        }
    }


def handle_tools_list(request_id):
    """Handle the tools/list method."""
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "result": {
            "tools": TOOLS
        }
    }


def handle_tools_call(request_id, params):
    """Handle the tools/call method."""
    tool_name = params.get("name", "")
    arguments = params.get("arguments", {})

    if tool_name == "get_timestamp":
        now = datetime.datetime.now(datetime.timezone.utc)
        result_text = json.dumps({
            "iso": now.isoformat(),
            "unix": int(now.timestamp()),
            "human": now.strftime("%A, %B %d, %Y at %H:%M:%S UTC")
        }, indent=2)
        return {
            "jsonrpc": "2.0",
            "id": request_id,
            "result": {
                "content": [
                    {
                        "type": "text",
                        "text": result_text
                    }
                ]
            }
        }

    elif tool_name == "word_count":
        text = arguments.get("text", "")
        words = len(text.split()) if text else 0
        characters = len(text)
        lines = text.count("\n") + 1 if text else 0
        result_text = json.dumps({
            "words": words,
            "characters": characters,
            "lines": lines
        }, indent=2)
        return {
            "jsonrpc": "2.0",
            "id": request_id,
            "result": {
                "content": [
                    {
                        "type": "text",
                        "text": result_text
                    }
                ]
            }
        }

    else:
        return {
            "jsonrpc": "2.0",
            "id": request_id,
            "error": {
                "code": -32601,
                "message": f"Unknown tool: {tool_name}"
            }
        }


def handle_notifications_initialized(request_id):
    """Handle the notifications/initialized notification (no response needed)."""
    return None


def main():
    """Main loop: read JSON-RPC messages from stdin, write responses to stdout."""
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        try:
            message = json.loads(line)
        except json.JSONDecodeError:
            error_response = {
                "jsonrpc": "2.0",
                "id": None,
                "error": {
                    "code": -32700,
                    "message": "Parse error"
                }
            }
            sys.stdout.write(json.dumps(error_response) + "\n")
            sys.stdout.flush()
            continue

        method = message.get("method", "")
        request_id = message.get("id")
        params = message.get("params", {})

        response = None

        if method == "initialize":
            response = handle_initialize(request_id)
        elif method == "notifications/initialized":
            response = handle_notifications_initialized(request_id)
        elif method == "tools/list":
            response = handle_tools_list(request_id)
        elif method == "tools/call":
            response = handle_tools_call(request_id, params)
        else:
            if request_id is not None:
                response = {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "error": {
                        "code": -32601,
                        "message": f"Method not found: {method}"
                    }
                }

        if response is not None:
            sys.stdout.write(json.dumps(response) + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    main()
PYEOF

chmod +x "$WORKSPACE/tools/timestamp-server.py"

# tools/README.md — explains the sample server
cat > "$WORKSPACE/tools/README.md" << 'EOF'
# Timestamp Server

A sample MCP (Model Context Protocol) server written in Python 3.

## What It Does

This server implements the MCP stdio transport protocol -- it reads JSON-RPC
messages from stdin and writes responses to stdout. It exposes two tools:

### get_timestamp

Returns the current time in three formats:
- **ISO 8601** -- e.g., `2025-01-15T14:30:00+00:00`
- **Unix epoch** -- e.g., `1736952600`
- **Human-readable** -- e.g., `Wednesday, January 15, 2025 at 14:30:00 UTC`

No input required.

### word_count

Counts words, characters, and lines in a given text.

**Input:** `{"text": "your text here"}`

**Output:** `{"words": 3, "characters": 14, "lines": 1}`

## How to Run

The server is designed to be launched by Claude Code via MCP configuration.
You don't run it directly -- instead, you configure `.mcp.json` to tell
Claude Code how to start it.

To test it manually:

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}' | python3 tools/timestamp-server.py
```

## Requirements

- Python 3 (standard library only, no pip dependencies)
EOF
