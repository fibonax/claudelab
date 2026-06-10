# Server Smith

In wf-007 you **configured** a connection to an existing MCP server. This
time you forge your own. An MCP stdio server has no magic in it — it's just
a process that reads JSON-RPC 2.0 messages from stdin (one JSON object per
line) and writes responses to stdout (one JSON object per line). Once you've
written one by hand, MCP stops being a black box: you can wrap any script,
database, or API into a tool Claude can call.

> **Prerequisite:** this exercise needs Python 3 (standard library only —
> no pip installs). Check with `python3 --version`.

## The Protocol in Four Moves

A client like Claude Code launches your server as a child process and sends:

1. **`initialize`** — handshake. You reply with a protocol version, your
   capabilities, and your server info.
2. **`notifications/initialized`** — a notification (it has no `id`). You
   must NOT reply to it.
3. **`tools/list`** — you reply with your tool catalog: each tool's name,
   description, and a JSON Schema for its input.
4. **`tools/call`** — you run the named tool with the given arguments and
   reply with a `content` array of text blocks.

When stdin closes (EOF), your server must exit cleanly. The full message
shapes — exact request and response JSON — are in `tools/README.md` in your
workspace. Keep it open while you build.

## Your Task

Write `tools/word-server.py` — a minimal MCP stdio server in Python 3,
using only the standard library (`sys` and `json` are all you need). It
exposes one tool:

- **`word_count`** — takes `{"text": "..."}` and returns the number of
  words in the text as a text content block, e.g. `"4"` for
  `"the quick brown fox"`.

Then register it in `.mcp.json` at the workspace root, exactly as you
learned in wf-007 — server name `word-server`, stdio transport, launched
with `python3 tools/word-server.py`.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/adv-003/
```

Look around:

- **`CLAUDE.md`** — project description
- **`tools/README.md`** — the MCP protocol reference (your spec)
- **`sample-texts/`** — two small text files to try your tool on

Build the server iteratively: handle `initialize` first, test it, then add
the other methods. To test by hand, put one request per line in a file and
feed it to the server via redirection:

```bash
python3 tools/word-server.py < requests.jsonl > responses.out
cat responses.out
```

## Requirements

- `tools/word-server.py` exists and runs with `python3`, stdlib only
- It reads JSON-RPC requests line-by-line from stdin and writes one JSON
  response per line to stdout, flushing after each response
- `initialize` → result with `protocolVersion` (any version string),
  `capabilities` containing `"tools": {}`, and `serverInfo` with name
  `word-server` and a version
- `tools/list` → result with a `tools` array containing one tool named
  `word_count`, with a description and an `inputSchema`
  (`type: object`, a `text` string property, `required: ["text"]`)
- `tools/call` with `{"name": "word_count", "arguments": {"text": "..."}}`
  → result `{"content": [{"type": "text", "text": "<N>"}]}` where N is the
  word count
- `notifications/initialized` (no `id`) is handled gracefully — no response
- Unknown methods get a JSON-RPC error response
- The server exits cleanly when stdin closes (EOF)
- `.mcp.json` registers `word-server` with stdio transport and the
  `python3` command

## Tips

- `for line in sys.stdin:` reads stdin line-by-line and ends naturally at
  EOF — exactly the loop shape you want
- After writing a response, call `sys.stdout.flush()` — without it the
  client can deadlock waiting for output stuck in the buffer
- stdout is the protocol channel: never `print()` debug messages to it.
  Use `print(..., file=sys.stderr)` instead
- `len(text.split())` is all the word counting you need
- A notification is any message without an `id` — check for that before
  replying
- The validator runs your server for real with a scripted conversation, so
  test it yourself the same way before checking

## When You're Done

Run `/cclab:check` to validate your work.
