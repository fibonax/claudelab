# Code Detective

One of Claude Code's biggest strengths is exploring codebases you didn't write.
Before changing anything, you should always **understand the code first** — read
files, search for patterns, and build a mental model of how things connect.

This exercise teaches the "explore first" habit: ask Claude to investigate
before you act.

## Your Task

You've just inherited a small API project. You don't know much about it yet.
Before making any changes, you need to understand the codebase by asking Claude
to explore it for you.

Ask Claude to investigate the project and write its findings in a file called
`answers.md`. The file must answer **three questions**:

### Question 1: Routes
How many route files are there, and what does each one handle?

### Question 2: Models
What data models does the project define?

### Question 3: Bugs
Can you find any bugs or typos in the code?

## Requirements

- Create a file called `answers.md` in the workspace root (not in a subfolder)
- The file must mention the routes (or route files)
- The file must mention both the user and post models
- The file must identify the bug in the code (there's a typo hiding in one
  of the model files)
- The file must be at least 5 lines long

## Tips

- Ask Claude to explore the project before asking specific questions — let it
  read through files and report back
- Claude can use tools like Grep and Glob to search the codebase efficiently
- Don't jump into fixing things — the goal here is **understanding**

## When You're Done

Run `/cclab:check` to validate your work.
