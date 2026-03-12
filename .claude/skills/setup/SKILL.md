---
name: setup
description: Configure permissions for a smoother cclab learning experience. Adds allow rules so Claude can read/write exercise files without repeated prompts. Use when the user says "setup", "configure permissions", "stop asking me", or wants to reduce permission prompts.
---

# Setup Permissions

Configure Claude Code permissions for a smoother cclab learning experience.

## Process

### Step 1: Check existing permissions

Read the user's `~/.claude/settings.json` using the Read tool.

**If the file does not exist**, inform the user that you'll create it.

**If the file exists**, parse the JSON and check if the `permissions.allow` array already contains cclab-related rules (any entry matching `~/.cclab/*`).

If cclab rules are already present, display:

```
cclab permissions are already configured. You're all set!
```

Stop here.

### Step 2: Show what will be added

Display the following to the user:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 cclab — Permission Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To avoid repeated permission prompts during exercises,
cclab needs access to read and write files in ~/.cclab/.

The following rules will be added to ~/.claude/settings.json:

  "Read(~/.cclab/*)"
  "Write(~/.cclab/*)"
  "Edit(~/.cclab/*)"
  "Bash(mkdir -p ~/.cclab/*)"
  "Bash(bash */setup.sh)"
  "Bash(bash */validate.sh)"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 3: Apply permissions

Read `~/.claude/settings.json` again (to get the latest content).

**If the file does not exist or is empty**, write:

```json
{
  "permissions": {
    "allow": [
      "Read(~/.cclab/*)",
      "Write(~/.cclab/*)",
      "Edit(~/.cclab/*)",
      "Bash(mkdir -p ~/.cclab/*)",
      "Bash(bash */setup.sh)",
      "Bash(bash */validate.sh)"
    ]
  }
}
```

**If the file exists with valid JSON:**

- If `permissions.allow` already exists, append the cclab rules to the existing array (do not duplicate)
- If `permissions` does not exist, add the `permissions` key with the `allow` array
- Preserve all existing settings (do not remove any existing rules or keys)

Write the updated JSON back to `~/.claude/settings.json`.

### Step 4: Confirm

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Done! Permissions configured.

 Claude can now read and write exercise files in
 ~/.cclab/ without asking each time.

 Run /cclab:start to begin learning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
