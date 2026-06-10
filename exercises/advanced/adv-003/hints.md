# Hints for adv-003: Server Smith

## Hint 1

The whole server is one loop: `for line in sys.stdin:` reads one JSON-RPC
message per line and ends at EOF, which is exactly when your server should
exit. For each line, `json.loads` it, look at the `"method"` field, build a
response dict, and write it with `json.dumps` plus a newline — then
`sys.stdout.flush()`. The exact request/response shapes for all four methods
are spelled out in `tools/README.md`.

## Hint 2

Dispatch on the method name. Every response carries the request's `id`:

- `initialize` → result with `"protocolVersion"`, `"capabilities": {"tools": {}}`,
  and `"serverInfo": {"name": "word-server", "version": "1.0.0"}`
- `tools/list` → result with `"tools": [...]` — one entry named `word_count`
  with a description and an `inputSchema` of
  `{"type": "object", "properties": {"text": {"type": "string"}}, "required": ["text"]}`
- `tools/call` → read `params["arguments"]["text"]`, count with
  `len(text.split())`, and return
  `{"content": [{"type": "text", "text": str(count)}]}`
- `notifications/initialized` has no `"id"` — skip it, send nothing
- anything else with an `id` → `{"error": {"code": -32601, "message": "..."}}`

For `.mcp.json`, it's the same shape as wf-007 with the server named
`word-server` and args `["tools/word-server.py"]`.

## Hint 3

A complete `tools/word-server.py`:

```python
#!/usr/bin/env python3
import json
import sys

TOOLS = [
    {
        "name": "word_count",
        "description": "Counts the words in a text.",
        "inputSchema": {
            "type": "object",
            "properties": {"text": {"type": "string"}},
            "required": ["text"],
        },
    }
]


def send(message):
    sys.stdout.write(json.dumps(message) + "\n")
    sys.stdout.flush()


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        request = json.loads(line)
        method = request.get("method", "")
        request_id = request.get("id")
        params = request.get("params", {})

        if request_id is None:
            # Notification (e.g. notifications/initialized) — no response.
            continue

        if method == "initialize":
            send({
                "jsonrpc": "2.0",
                "id": request_id,
                "result": {
                    "protocolVersion": "2025-06-18",
                    "capabilities": {"tools": {}},
                    "serverInfo": {"name": "word-server", "version": "1.0.0"},
                },
            })
        elif method == "tools/list":
            send({
                "jsonrpc": "2.0",
                "id": request_id,
                "result": {"tools": TOOLS},
            })
        elif method == "tools/call" and params.get("name") == "word_count":
            text = params.get("arguments", {}).get("text", "")
            send({
                "jsonrpc": "2.0",
                "id": request_id,
                "result": {
                    "content": [{"type": "text", "text": str(len(text.split()))}]
                },
            })
        else:
            send({
                "jsonrpc": "2.0",
                "id": request_id,
                "error": {"code": -32601, "message": f"Method not found: {method}"},
            })


if __name__ == "__main__":
    main()
```

And `.mcp.json` in the workspace root:

```json
{
  "mcpServers": {
    "word-server": {
      "type": "stdio",
      "command": "python3",
      "args": ["tools/word-server.py"]
    }
  }
}
```
