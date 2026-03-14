# Hints for wf-007: Plug It In

## Hint 1

MCP servers are configured in `.mcp.json` at the project root. For a local
Python script, use the `stdio` transport type with `"command"` and `"args"`.
You also need to add MCP tool permissions to `.claude/settings.json` so Claude
Code is allowed to call the server's tools.

## Hint 2

Create `.mcp.json` with this structure:
`{"mcpServers": {"timestamp": {"type": "stdio", "command": "python3", "args": ["tools/timestamp-server.py"]}}}`.
Then create `.claude/settings.json` with a permissions allow list. The tool
naming convention is `mcp__<server-name>__<tool-name>`, so you can use
`"mcp__timestamp__*"` to allow all tools from the timestamp server.

## Hint 3

Create `.mcp.json`:

```json
{
  "mcpServers": {
    "timestamp": {
      "type": "stdio",
      "command": "python3",
      "args": ["tools/timestamp-server.py"]
    }
  }
}
```

Then create `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "mcp__timestamp__*"
    ]
  }
}
```
