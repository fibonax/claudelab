#!/usr/bin/env bash
# Validation for wf-007: Plug It In
# Checks: .mcp.json configured, .claude/settings.json with MCP permissions, sample server present

WORKSPACE="$HOME/.cclab/workspace/wf-007"
PASS=true

# --- .mcp.json checks ---

# Check 1: .mcp.json exists
if [ ! -f "$WORKSPACE/.mcp.json" ]; then
  echo "FAIL: .mcp.json not found in workspace"
  echo "  Create a .mcp.json file in the project root with your MCP server configuration."
  exit 1
fi

# Check 2: .mcp.json contains "mcpServers"
if ! grep -q '"mcpServers"' "$WORKSPACE/.mcp.json"; then
  echo "FAIL: .mcp.json missing \"mcpServers\" key"
  echo "  The .mcp.json file needs a \"mcpServers\" object containing your server definitions."
  PASS=false
fi

# Check 3: .mcp.json contains "timestamp" or "timestamp-server"
if ! grep -qiE '"timestamp"' "$WORKSPACE/.mcp.json"; then
  echo "FAIL: .mcp.json missing a server named \"timestamp\" or \"timestamp-server\""
  echo "  Add a server entry with a name like \"timestamp\" under mcpServers."
  PASS=false
fi

# Check 4: .mcp.json contains "command"
if ! grep -q '"command"' "$WORKSPACE/.mcp.json"; then
  echo "FAIL: .mcp.json missing \"command\" field"
  echo "  The server config needs a \"command\" field specifying how to run the server."
  PASS=false
fi

# Check 5: .mcp.json contains "python3" or "python"
if ! grep -qE '"python3?"|"python"' "$WORKSPACE/.mcp.json"; then
  echo "FAIL: .mcp.json missing python command"
  echo "  The command should be \"python3\" (or \"python\") to run the server script."
  PASS=false
fi

# --- .claude/settings.json checks ---

# Check 6: .claude/settings.json exists
if [ ! -f "$WORKSPACE/.claude/settings.json" ]; then
  echo "FAIL: .claude/settings.json not found"
  echo "  Create .claude/settings.json with MCP tool permissions."
  PASS=false
else
  # Check 7: settings.json contains MCP permission pattern
  if ! grep -qE 'mcp__|mcp_' "$WORKSPACE/.claude/settings.json"; then
    echo "FAIL: .claude/settings.json missing MCP permission pattern"
    echo "  Add an allow entry like \"mcp__timestamp__*\" to grant access to MCP tools."
    PASS=false
  fi
fi

# --- Sample server check ---

# Check 8: tools/timestamp-server.py still exists
if [ ! -f "$WORKSPACE/tools/timestamp-server.py" ]; then
  echo "FAIL: tools/timestamp-server.py not found"
  echo "  The sample MCP server should still be present. Run /cclab:reset to restore it."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
