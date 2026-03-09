---
name: curriculum-design
description: Design the exercise curriculum for ClaudeLab — defining learning tracks, exercise sequence, concepts taught, and validation approach for each exercise. Use when the user says "curriculum design", "design exercises", "plan the curriculum", "exercise roadmap", "learning path", or has an approved PRD and wants to design the exercise content before creating individual tasks.
disable-model-invocation: true
---

# Curriculum Design

Design the exercise curriculum based on an approved PRD.
This replaces UX Design and System Design for cclab — there are no screens
to wireframe or APIs to architect. The "product" is a set of progressive
exercises delivered through Claude Code's plugin system.

## Prerequisites
An approved PRD must exist. Read it first:
- Check `docs/prd/` for the relevant PRD document
- If no PRD exists, tell the user to create one first with `/prd-create`

## Process

### Step 1: Read the approved PRD
Read the PRD thoroughly. Extract:
- Target user personas and their skill levels
- Learning goals and success metrics
- MVP scope (which concepts to cover)
- Exercise tracks defined in the PRD

### Step 2: Research Claude Code concepts
Use a subagent to research:
- Claude Code official documentation for the list of features/concepts
- Existing exercises (if any) to avoid duplication
- Prerequisite chains (what must be learned before what)

### Step 3: Design the learning tracks
Define the progression within each track:
- What concept does each exercise teach?
- What order should exercises follow?
- What are the prerequisite chains?

### Step 4: Design each exercise (high-level)
For each exercise, define:
- Exercise ID (cc-NNN)
- Concept taught
- Difficulty level
- Prerequisites
- Validation approach (how we know the user succeeded)
- Estimated time

### Step 5: Define validation strategies
For each exercise, specify the validation approach:
- **File check**: Does a specific file exist with specific content?
- **Command check**: Does a command succeed (exit code 0)?
- **Content check**: Does a file contain expected patterns?
- **State check**: Is the project in the expected state?

Validation MUST be programmatic. No LLM-based grading.

### Step 6: Write the Curriculum Design Document
Save to: `docs/curriculum/CURRICULUM-{feature-name}.md`
Use the template below.

### Step 7: Present and STOP
Present the curriculum design to the user. Say:
"Here is the Curriculum Design. Please review it. When you approve, I'll
proceed to Task Planning. If you want changes, tell me what to modify."

DO NOT proceed until the user explicitly approves.

## Curriculum Design Template

# Curriculum Design: {Feature/MVP Name}

**Version:** 1.0
**Date:** {YYYY-MM-DD}
**PRD Reference:** docs/prd/PRD-{name}.md
**Status:** DRAFT | IN REVIEW | APPROVED

---

### 1. Learning Objectives

What will users be able to do after completing this curriculum?
- Objective 1: ...
- Objective 2: ...
- Objective 3: ...

### 2. Track Overview

| Track | Focus | Exercise Count | Target Audience |
|---|---|---|---|
| fundamentals | Core Claude Code concepts | N | Beginners |
| skills | Skills, subagents, hooks | N | Intermediate |
| workflows | End-to-end development workflows | N | Intermediate |
| advanced | Complex patterns, optimization | N | Advanced |

### 3. Exercise Sequence

#### Track: fundamentals

| ID | Title | Concept | Difficulty | Prerequisites | Est. Time |
|---|---|---|---|---|---|
| cc-001 | ... | CLAUDE.md basics | beginner | None | 10 min |
| cc-002 | ... | Using /init | beginner | cc-001 | 10 min |
| cc-003 | ... | ... | beginner | cc-002 | 15 min |

#### Track: skills

| ID | Title | Concept | Difficulty | Prerequisites | Est. Time |
|---|---|---|---|---|---|
| cc-010 | ... | Creating a skill | intermediate | cc-003 | 20 min |
| ... | ... | ... | ... | ... | ... |

(Repeat for each track)

### 4. Prerequisite Graph

cc-001 (CLAUDE.md basics)
│
└──▶ cc-002 (Using /init)
│
└──▶ cc-003 (Plan Mode)
│
├──▶ cc-010 (Creating a skill)
└──▶ cc-020 (Writing hooks)

### 5. Exercise Definitions

#### Exercise: cc-001 — {Title}

**Concept:** What Claude Code feature this teaches
**Track:** fundamentals
**Difficulty:** beginner
**Prerequisites:** None
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will be able to...

**Setup:** What state the project starts in
- The exercise starts with an empty project directory
- No CLAUDE.md exists yet

**Instructions Summary:** What the user is asked to do
- Create a CLAUDE.md file with required sections
- Include at least: project description, commands, and one code style rule

**Validation Strategy:**
- File exists: `CLAUDE.md` in project root
- Content check: file contains `## Commands` section
- Content check: file contains at least one code style rule
- Content check: file is between 10-200 lines (not empty, not bloated)

**Hints:**
1. (Gentle) Think about what Claude needs to know every session...
2. (Specific) Your CLAUDE.md needs sections for Commands and Code Style...
3. (Near-answer) Create a CLAUDE.md with `## Commands` listing your build/test commands and `## Code Style` with your conventions...

#### Exercise: cc-002 — {Title}
...

(Repeat for each exercise in MVP scope)

### 6. Validation Patterns Reference

| Pattern | When to Use | Example |
|---|---|---|
| File exists | User must create a file | `CLAUDE.md exists` |
| File contains | User must include specific content | `contains "## Commands"` |
| File NOT contains | User must avoid something | `does not contain "require("` |
| Command succeeds | User must fix something | `git status exits 0` |
| Directory structure | User must create correct layout | `.claude/skills/*/SKILL.md exists` |
| JSON valid | User must write valid config | `settings.json parses without error` |
| Grep match | User must follow a pattern | `grep -q "description:" SKILL.md` |

### 7. Open Questions

- [ ] Question 1
- [ ] Question 2