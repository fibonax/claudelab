#!/usr/bin/env bash
# Validation for adv-003: Server Smith
# Checks: server file + .mcp.json present, then RUNS the learner's server
# with a scripted JSON-RPC conversation and inspects the responses.

WORKSPACE="$HOME/.cclab/workspace/adv-003"
SERVER="$WORKSPACE/tools/word-server.py"
PASS=true

# Check 1: python3 is available
if ! command -v python3 > /dev/null 2>&1; then
  echo "FAIL: python3 not found on PATH"
  echo "  This exercise needs Python 3 to run your MCP server. Install it"
  echo "  (e.g. via https://www.python.org or your package manager) and re-check."
  exit 1
fi

# Check 2: the server file exists
if [ ! -f "$SERVER" ]; then
  echo "FAIL: tools/word-server.py not found"
  echo "  Write your MCP server at tools/word-server.py inside the workspace."
  echo "  See tools/README.md for the protocol shape."
  exit 1
fi

# --- .mcp.json checks ---

# Check 3: .mcp.json exists
if [ ! -f "$WORKSPACE/.mcp.json" ]; then
  echo "FAIL: .mcp.json not found in workspace root"
  echo "  Register your server in .mcp.json, like you did in wf-007."
  PASS=false
else
  if ! grep -q '"mcpServers"' "$WORKSPACE/.mcp.json"; then
    echo "FAIL: .mcp.json missing \"mcpServers\" key"
    echo "  The .mcp.json file needs a \"mcpServers\" object containing your server."
    PASS=false
  fi
  if ! grep -q '"word-server"' "$WORKSPACE/.mcp.json"; then
    echo "FAIL: .mcp.json missing a server named \"word-server\""
    echo "  Name the server entry \"word-server\" under mcpServers."
    PASS=false
  fi
  if ! grep -qE '"type"[[:space:]]*:[[:space:]]*"stdio"' "$WORKSPACE/.mcp.json"; then
    echo "FAIL: .mcp.json missing \"type\": \"stdio\""
    echo "  The server entry needs \"type\": \"stdio\" — it's a local process."
    PASS=false
  fi
  if ! grep -q '"command"' "$WORKSPACE/.mcp.json"; then
    echo "FAIL: .mcp.json missing \"command\" field"
    echo "  The server config needs a \"command\" (python3) and \"args\" with the script path."
    PASS=false
  fi
fi

# --- Behavioral check: run the server against a scripted conversation ---

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

REQUESTS="$TMP_DIR/requests.jsonl"
RESPONSES="$TMP_DIR/responses.out"

cat > "$REQUESTS" << 'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"cclab-validator","version":"1.0.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"word_count","arguments":{"text":"the quick brown fox"}}}
EOF

# Run the server with stdin from the requests file. A correct server exits
# at EOF; guard against a hung one with a ~10s timeout.
(cd "$WORKSPACE" && python3 tools/word-server.py < "$REQUESTS" > "$RESPONSES" 2> "$TMP_DIR/stderr.log") &
SERVER_PID=$!

WAITED=0
while kill -0 "$SERVER_PID" 2> /dev/null && [ "$WAITED" -lt 10 ]; do
  sleep 1
  WAITED=$((WAITED + 1))
done

if kill -0 "$SERVER_PID" 2> /dev/null; then
  kill "$SERVER_PID" 2> /dev/null
  wait "$SERVER_PID" 2> /dev/null
  echo "FAIL: the server did not exit when stdin closed (killed after 10s)"
  echo "  Your read loop must end at EOF — 'for line in sys.stdin:' does this"
  echo "  naturally. The server must exit cleanly when the client closes stdin."
  PASS=false
else
  wait "$SERVER_PID"
  SERVER_EXIT=$?
  if [ "$SERVER_EXIT" -ne 0 ]; then
    echo "FAIL: the server crashed (exit code $SERVER_EXIT)"
    echo "  Run it yourself to see the error:"
    echo "    cd ~/.cclab/workspace/adv-003/"
    echo "    python3 tools/word-server.py < requests.jsonl"
    if [ -s "$TMP_DIR/stderr.log" ]; then
      echo "  stderr said:"
      head -5 "$TMP_DIR/stderr.log" | sed 's/^/    /'
    fi
    PASS=false
  fi
fi

# Check 4: initialize response contains protocolVersion
if ! grep -q '"protocolVersion"' "$RESPONSES"; then
  echo "FAIL: no \"protocolVersion\" in the server's responses"
  echo "  The initialize result must include a protocolVersion, capabilities"
  echo "  with \"tools\": {}, and serverInfo. See tools/README.md, section 1."
  PASS=false
fi

# Check 5: tools/list response advertises word_count
if ! grep -q '"word_count"' "$RESPONSES"; then
  echo "FAIL: no \"word_count\" tool in the server's responses"
  echo "  tools/list must return a tools array with one tool named"
  echo "  \"word_count\". See tools/README.md, section 3."
  PASS=false
fi

# Check 6: tools/call counted "the quick brown fox" as 4 words
if ! grep -qE '"text"[[:space:]]*:[[:space:]]*"4"' "$RESPONSES"; then
  echo "FAIL: tools/call for \"the quick brown fox\" did not return \"4\""
  echo "  The word_count result must be {\"content\": [{\"type\": \"text\","
  echo "  \"text\": \"4\"}]} — the count as a string in a text block."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
