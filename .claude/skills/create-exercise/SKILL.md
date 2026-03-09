---
name: create-exercise
description: Create a new ClaudeLab exercise with proper structure, metadata, validation, and hints. Use when the user says "create exercise", "new exercise", "add an exercise", "build a lab", or describes a Claude Code concept they want to teach. Also trigger when user references exercise IDs like "cc-NNN" in the context of creation.
---

# Create Exercise

Create a new ClaudeLab exercise following the standard structure.

## Process

### Step 1: Gather exercise details
Ask the user (use AskUserQuestion) for:
- **Concept**: What Claude Code feature/concept does this teach?
- **Track**: fundamentals | skills | workflows | advanced
- **Prerequisites**: Which exercises (cc-NNN) should come before this?
- **Difficulty**: beginner | intermediate | advanced

### Step 2: Assign exercise ID
Read `src/exercises/` to find the highest existing cc-NNN ID.
Assign the next sequential ID.

### Step 3: Create exercise structure

src/exercises/cc-NNN/
├── metadata.json       # Exercise metadata
├── setup.ts            # Setup script (creates initial state)
├── instructions.md     # What the user sees
├── validate.ts         # Validation logic
├── hints/
│   ├── hint-1.md       # Gentle nudge
│   ├── hint-2.md       # More specific
│   └── hint-3.md       # Nearly gives the answer
└── solution/           # Reference solution (for testing)
└── expected.ts

### Step 4: Write metadata.json
```json
{
  "id": "cc-NNN",
  "title": "Exercise Title",
  "track": "fundamentals",
  "difficulty": "beginner",
  "prerequisites": [],
  "estimatedMinutes": 10,
  "concepts": ["concept-1", "concept-2"],
  "version": "1.0.0"
}
```

### Step 5: Write validation
Validation MUST be programmatic where possible. Use file existence checks,
content assertions, command exit codes, and test results — not LLM judgment.

Example validation patterns:
- File exists: check that the expected file was created
- File contains pattern: check that the file includes expected content
- Command succeeds: run a verification command and check exit code 0
- Script passes: run a validation script that returns pass/fail

### Step 6: Write progressive hints
- **Hint 1**: Restate the problem differently. Point to relevant docs.
- **Hint 2**: Name the specific file/command/concept needed.
- **Hint 3**: Give a near-complete code snippet with one blank to fill.

### Step 7: Write the solution and test it
Create the reference solution in `solution/expected.ts`.
Run the validation script against the solution to confirm it passes.

### Step 8: Run validation
Run the validation against the reference solution to confirm it passes.
Fix any failures before considering the exercise complete.

## Examples

### Example: Teaching CLAUDE.md basics
User says: "Create an exercise teaching users how to write a good CLAUDE.md"

Result:
- ID: cc-005
- Track: fundamentals
- The exercise sets up an empty project, asks the user to create a CLAUDE.md,
  and validates that it contains required sections (commands, style rules, etc.)