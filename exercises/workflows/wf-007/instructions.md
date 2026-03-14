# Plug It In

Claude Code can connect to external tools through the **Model Context Protocol
(MCP)**. MCP servers expose tools that Claude can call during a session --
things like querying databases, calling APIs, or running custom scripts. You
configure these connections so Claude discovers and uses them automatically.

## How MCP Works

MCP uses a client-server architecture. Claude Code is the **client**. You
provide a **server** -- a program that exposes tools via a standardized JSON-RPC
protocol. When Claude Code starts, it connects to your configured servers and
discovers their available tools.

### Transport Types

MCP supports two transport types:

| Transport | How it works | Best for |
|---|---|---|
| **stdio** | Launches a local process, communicates via stdin/stdout | Local scripts, CLI tools |
| **http** | Connects to a running HTTP server | Remote services, shared servers |

For local scripts (like the one in this exercise), **stdio** is the right
choice. Claude Code launches your script as a child process and sends JSON-RPC
messages through stdin/stdout.

### Tool Naming Convention

When Claude Code discovers tools from an MCP server, it names them using a
double-underscore convention:

```
mcp__<server-name>__<tool-name>
```

For example, if you configure a server named `"timestamp"` that exposes a tool
called `get_timestamp`, Claude Code sees it as `mcp__timestamp__get_timestamp`.
This naming is important for the permissions system.

## Your Task

This workspace has a sample MCP server at `tools/timestamp-server.py` -- a
Python3 script that exposes two tools: `get_timestamp` (returns the current
time) and `word_count` (counts words in text). Read `tools/README.md` to learn
more about it.

Your job is to configure Claude Code to connect to this server.

### Part 1: Create .mcp.json

Create `.mcp.json` in the project root. This file tells Claude Code which MCP
servers to connect to. You need to configure the `timestamp-server.py` script
using stdio transport.

The `.mcp.json` structure looks like this:

```json
{
  "mcpServers": {
    "<server-name>": {
      "type": "stdio",
      "command": "<executable>",
      "args": ["<script-path>"]
    }
  }
}
```

### Part 2: Create .claude/settings.json

MCP tools need explicit permission to run. Create `.claude/settings.json` with
a permissions allow list that grants access to your server's tools.

Use the wildcard pattern to allow all tools from your server:

```
mcp__<server-name>__*
```

The settings file structure:

```json
{
  "permissions": {
    "allow": ["<tool-permission-pattern>"]
  }
}
```

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-007/
```

Take a look at the existing files to understand the project:

- **`CLAUDE.md`** -- project description
- **`tools/timestamp-server.py`** -- the sample MCP server (Python3)
- **`tools/README.md`** -- explains what the server does and its tools

Notice there's no `.mcp.json` or `.claude/` directory yet -- you'll create
them as part of this exercise. You can create the files in several ways:

- **Inside Claude Code** -- ask Claude to create the configuration files
- **Open in VS Code** -- run `code ~/.cclab/workspace/wf-007/` in your
  terminal, then create the files directly
- **From the terminal** -- use any editor you like:
  ```bash
  nano .mcp.json
  mkdir -p .claude
  nano .claude/settings.json
  ```

## Requirements

- `.mcp.json` exists in the project root
- `.mcp.json` contains `"mcpServers"` configuration
- The server config references `"timestamp"` or `"timestamp-server"`
- The server config has a `"command"` field
- The command uses `"python3"` or `"python"` to run the server
- `.claude/settings.json` exists
- Settings include an MCP permission pattern (containing `mcp__` or `mcp_`)
- The sample server at `tools/timestamp-server.py` is still present

## Tips

- The server name in `.mcp.json` becomes part of the tool name:
  `mcp__<server-name>__<tool-name>`
- Use `"python3"` as the command since the server is a Python script
- The script path in `"args"` is relative to the project root:
  `["tools/timestamp-server.py"]`
- The wildcard `*` in permissions lets you allow all tools from a server
  at once

## When You're Done

Run `/cclab:check` to validate your work.
