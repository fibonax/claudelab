---
name: implement-task
description: Implement a single task from the approved task list. Use when the user says "implement task", "build TASK-NNN", "create TASK-NNN", or wants to execute a task from the task list. Also trigger on "start implementing" or "let's build this".
disable-model-invocation: true
---

# Implement Task

Implement a single task based on the approved task definition and curriculum design.

## Prerequisites
- Approved task list: `docs/tasks/TASK-LIST.md`
- The specific task file: `docs/tasks/TASK-NNN.md`
- Curriculum Design: `docs/curriculum/CURRICULUM-{name}.md`
- All dependency tasks must be DONE (check TASK-LIST.md)

## Process

### Step 1: Read the task and its context
Read:
1. The specific TASK-NNN.md (scope, acceptance criteria)
2. The curriculum design (for the exercise definition this task implements)
3. Any dependency tasks that are already DONE (for patterns to follow)
4. If exercises exist, read them to match the established patterns

### Step 2: Create the exercise content
For each exercise in the task scope, create:
- `metadata.json` — exercise metadata matching the curriculum design
- `instructions.md` — clear, actionable instructions for the learner
- `validate.sh` or validation script — programmatic validation
- `hints/hint-1.md`, `hint-2.md`, `hint-3.md` — progressive hints
- `solution/` — reference solution for testing

### Step 3: Write validation
Validation MUST be programmatic. Implement the validation strategy
defined in the curriculum design using:
- File existence checks
- Content pattern matching (grep)
- Command exit codes
- JSON validity checks

### Step 4: Test the exercise
Run the full exercise cycle:
1. Run setup (if any)
2. Apply the reference solution
3. Run validation — must pass
4. Remove the solution
5. Run validation — must fail (proves validation actually checks something)

### Step 5: Commit
```bash
git add .
git commit -m "feat(exercises): TASK-NNN cc-NNN exercise title"
```

### Step 6: Update task status
Update `docs/tasks/TASK-LIST.md`:
- Change TASK-NNN status from TODO → DONE
- Check off the acceptance criteria in TASK-NNN.md

### Step 7: Report
Tell the user:
"TASK-NNN is complete. Exercise cc-NNN created and validated.
Reference solution passes. Validation correctly fails without solution.
Changes committed as: {commit message}.
Ready for the next task."

## Implementation Rules
- Follow the curriculum design for exercise content and validation strategy.
  If you disagree with the design, STOP and tell the user before deviating.
- Validation must be deterministic. No LLM-based grading.
- Hints must be progressive: hint 1 gentle, hint 2 specific, hint 3 near-answer.
- Reference solution must pass validation. Absence of solution must fail validation.