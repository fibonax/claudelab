#!/usr/bin/env bash
# Validation for adv-006: Plugin Architect
# Checks: plugin manifest, bundled skill, bundled hooks.json, AND the hook
# script behaves correctly when fed a payload on stdin (exit 0, log written).

WORKSPACE="$HOME/.cclab/workspace/adv-006"
PLUGIN="$WORKSPACE/wordsmith"
MANIFEST="$PLUGIN/.claude-plugin/plugin.json"
SKILL="$PLUGIN/skills/lint-prose/SKILL.md"
HOOKS="$PLUGIN/hooks/hooks.json"
SCRIPT="$PLUGIN/scripts/count-prose.sh"
PASS=true

# === Part 1: plugin manifest checks ===

# Check 1: plugin.json exists
if [ ! -f "$MANIFEST" ]; then
  echo "FAIL: wordsmith/.claude-plugin/plugin.json not found"
  echo "  The manifest is the one file every plugin must have. Create it at"
  echo "  wordsmith/.claude-plugin/plugin.json inside the workspace."
  exit 1
fi

# Check 2: manifest names the plugin wordsmith
if ! grep '"name"' "$MANIFEST" | grep -q 'wordsmith'; then
  echo "FAIL: plugin.json doesn't set \"name\" to wordsmith"
  echo "  name is the only required manifest field — it namespaces the"
  echo "  plugin's skills. Add \"name\": \"wordsmith\"."
  PASS=false
fi

# Check 3: manifest declares bundled skills
if ! grep -q '"skills"' "$MANIFEST"; then
  echo "FAIL: plugin.json missing the \"skills\" array"
  echo "  Add \"skills\": [\"./skills/lint-prose/\"] so the plugin ships the skill."
  PASS=false
fi

# Check 4: manifest points at the hooks file
if ! grep -q '"hooks"' "$MANIFEST"; then
  echo "FAIL: plugin.json missing the \"hooks\" field"
  echo "  Add \"hooks\": \"./hooks/hooks.json\" so the bundled hook activates"
  echo "  automatically when the plugin is enabled."
  PASS=false
fi

# Check 5: manifest is valid JSON
if command -v python3 &>/dev/null; then
  if ! python3 -c "import json; json.load(open('$MANIFEST'))" 2>/dev/null; then
    echo "FAIL: plugin.json is not valid JSON"
    echo "  Check for missing commas, brackets, or quotes. Use a JSON validator to find errors."
    PASS=false
  fi
else
  # Fallback: basic structure check (opening/closing braces)
  if ! grep -q '^{' "$MANIFEST" || ! grep -q '}' "$MANIFEST"; then
    echo "FAIL: plugin.json doesn't appear to be valid JSON"
    echo "  Make sure it starts with { and ends with }."
    PASS=false
  fi
fi

# === Part 2: bundled skill checks ===

# Check 6: SKILL.md exists
if [ ! -f "$SKILL" ]; then
  echo "FAIL: wordsmith/skills/lint-prose/SKILL.md not found"
  echo "  Create the bundled skill at wordsmith/skills/lint-prose/SKILL.md."
  PASS=false
else
  # Extract the YAML frontmatter (between the first pair of --- delimiters)
  FRONTMATTER=$(awk '/^---[[:space:]]*$/{n++; next} n==1{print} n>=2{exit}' "$SKILL")

  # Check 7: frontmatter has name: lint-prose
  if ! printf '%s\n' "$FRONTMATTER" | grep -qiE '^name:[[:space:]]*lint-prose[[:space:]]*$'; then
    echo "FAIL: SKILL.md frontmatter missing name: lint-prose"
    echo "  Add name: lint-prose between the --- delimiters at the top of the file."
    PASS=false
  fi

  # Check 8: frontmatter has description:
  if ! printf '%s\n' "$FRONTMATTER" | grep -qi '^description:'; then
    echo "FAIL: SKILL.md frontmatter missing description:"
    echo "  Add a description: that tells Claude when to use the skill."
    PASS=false
  fi

  # Check 9: body has a # heading
  if ! grep -q '^# ' "$SKILL"; then
    echo "FAIL: SKILL.md body has no # heading"
    echo "  Give the skill body a markdown title, e.g. # Lint Prose."
    PASS=false
  fi

  # Check 10: at least 3 numbered steps
  STEP_COUNT=$(grep -cE '^[[:space:]]*[0-9]+\.' "$SKILL" 2>/dev/null || echo "0")
  if [ "$STEP_COUNT" -lt 3 ]; then
    echo "FAIL: SKILL.md has fewer than 3 numbered steps (found $STEP_COUNT)"
    echo "  Describe the linting procedure as numbered steps (1. ..., 2. ..., 3. ...)"
    echo "  covering passive voice, long sentences, and jargon."
    PASS=false
  fi
fi

# === Part 3: bundled hooks checks ===

# Check 11: hooks.json exists
if [ ! -f "$HOOKS" ]; then
  echo "FAIL: wordsmith/hooks/hooks.json not found"
  echo "  Create the bundled hook configuration at wordsmith/hooks/hooks.json."
  PASS=false
else
  # Check 12: hooks.json wires a PostToolUse event
  if ! grep -q '"PostToolUse"' "$HOOKS"; then
    echo "FAIL: hooks.json missing the \"PostToolUse\" event"
    echo "  The prose logger observes writes after they happen — use PostToolUse."
    PASS=false
  fi

  # Check 13: matcher covers Write or Edit
  if ! grep '"matcher"' "$HOOKS" | grep -qE '(Write|Edit)'; then
    echo "FAIL: hooks.json has no \"matcher\" covering Write or Edit"
    echo "  Add \"matcher\": \"Write|Edit\" so the hook fires when prose changes."
    PASS=false
  fi

  # Check 14: command references the script via CLAUDE_PLUGIN_ROOT
  if ! grep '"command"' "$HOOKS" | grep -q 'CLAUDE_PLUGIN_ROOT'; then
    echo "FAIL: hooks.json command doesn't use \${CLAUDE_PLUGIN_ROOT}"
    echo "  A plugin is installed to a path you don't control — reference the"
    echo "  script as \${CLAUDE_PLUGIN_ROOT}/scripts/count-prose.sh."
    PASS=false
  fi

  # Check 15: hooks.json is valid JSON
  if command -v python3 &>/dev/null; then
    if ! python3 -c "import json; json.load(open('$HOOKS'))" 2>/dev/null; then
      echo "FAIL: hooks.json is not valid JSON"
      echo "  Check for missing commas, brackets, or quotes. Use a JSON validator to find errors."
      PASS=false
    fi
  else
    # Fallback: basic structure check (opening/closing braces)
    if ! grep -q '^{' "$HOOKS" || ! grep -q '}' "$HOOKS"; then
      echo "FAIL: hooks.json doesn't appear to be valid JSON"
      echo "  Make sure it starts with { and ends with }."
      PASS=false
    fi
  fi
fi

# === Part 4: hook script checks ===

# Check 16: count-prose.sh exists
if [ ! -f "$SCRIPT" ]; then
  echo "FAIL: wordsmith/scripts/count-prose.sh not found"
  echo "  Create the hook script at wordsmith/scripts/count-prose.sh."
  PASS=false
elif [ ! -x "$SCRIPT" ]; then
  # Check 17: count-prose.sh is executable
  echo "FAIL: wordsmith/scripts/count-prose.sh is not executable"
  echo "  Run: chmod +x wordsmith/scripts/count-prose.sh"
  PASS=false
else
  # Check 18: script exits 0 explicitly
  if ! grep -q 'exit 0' "$SCRIPT"; then
    echo "FAIL: count-prose.sh doesn't contain 'exit 0'"
    echo "  A PostToolUse observer must always exit 0 so it never disrupts the session."
    PASS=false
  fi

  # --- behavioral check: run the learner's script against a real payload ---
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT

  cat > "$TMP_DIR/payload.json" << 'EOF'
{"session_id":"cclab-validate","cwd":"/tmp","hook_event_name":"PostToolUse","tool_name":"Write","tool_input":{"file_path":"draft.md","content":"The report was written by the team."}}
EOF

  # Check 19: script exits 0 when fed a payload on stdin
  ( cd "$TMP_DIR" && "$SCRIPT" < "$TMP_DIR/payload.json" > /dev/null 2>&1 )
  RC=$?
  if [ "$RC" -ne 0 ]; then
    echo "FAIL: count-prose.sh exited $RC when fed a payload (expected 0)"
    echo "  Read stdin with input=\"\$(cat)\", append the log line, then exit 0."
    PASS=false
  fi

  # Check 20: script wrote a line to prose-log.txt
  if [ ! -s "$TMP_DIR/prose-log.txt" ]; then
    echo "FAIL: count-prose.sh did not append a line to prose-log.txt"
    echo "  The script should append one line to prose-log.txt in the current"
    echo "  directory each time it runs (e.g. echo \"...\" >> prose-log.txt)."
    PASS=false
  fi
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
