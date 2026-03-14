---
name: validate-exercise
description: Validate an existing ClaudeLab exercise for correctness, completeness, and quality. Use when the user says "validate exercise", "check exercise", "test exercise", "review exercise cc-NNN", or wants to verify an exercise works correctly end-to-end.
---

# Validate Exercise

Run comprehensive validation on a ClaudeLab exercise.

## Validation Checklist

### 1. Structure validation
Verify all required files exist:
- [ ] metadata.json
- [ ] setup.ts
- [ ] instructions.md
- [ ] validate.ts
- [ ] At least 1 hint file in hints/
- [ ] solution/expected.ts

### 2. Metadata validation
- [ ] ID matches folder name pattern (cc-NNN or wf-NNN)
- [ ] Track is one of: fundamentals, skills, workflows, advanced
- [ ] Difficulty is one of: beginner, intermediate, advanced
- [ ] Prerequisites reference existing exercise IDs
- [ ] estimatedMinutes is a positive number

### 3. Setup validation
Run the setup script and verify it completes without errors.

### 4. Solution validation
Run the reference solution through the validator.
Must complete successfully (exit code 0).

### 5. Hint quality
Read each hint file and verify:
- Hints are progressively more specific
- Hint 1 does NOT contain the answer
- Hint 3 is specific enough to unblock someone stuck

### 6. Instructions quality
- Instructions are clear and actionable
- Expected outcome is stated
- No assumptions about prior knowledge beyond listed prerequisites

## Output
Report results as a checklist with pass/fail for each item.
If any items fail, provide specific fix suggestions.