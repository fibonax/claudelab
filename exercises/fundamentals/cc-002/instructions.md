# Your First CLAUDE.md

Every time Claude Code starts a session, it reads a special file called `CLAUDE.md`
from your project root. Think of it as a **briefing document** — the same way you'd
brief a new team member on their first day, CLAUDE.md tells Claude what the project
is, what technologies it uses, and how to build and run things.

Without a CLAUDE.md, Claude is working blind. With a good one, Claude understands
your project from the very first prompt.

## Your Task

This workspace contains a small TypeScript project — a task manager API. Look
around the project files to understand what it does, then create a `CLAUDE.md`
file in the project root.

Your CLAUDE.md must include at least these sections:

1. **Project Description** — What does this project do? (Use a `##` heading
   containing "Project" or "Description")
2. **Tech Stack** — What technologies does it use? Mention at least one
   (e.g., TypeScript, Node.js, npm)
3. **Commands** — How do you build, test, and run the project? (Use a `##`
   heading containing "Commands" or "Development")

## Requirements

- The file must be called `CLAUDE.md` (in the workspace root, not in a subfolder)
- It must be between 10 and 100 lines
- Use `##` markdown headings to structure your sections

## Tips

- Read the existing project files first to understand what you're documenting
- Be specific — "A REST API for managing tasks" is better than "A project"
- Include actual commands from package.json in your Commands section

## When You're Done

Run `/cclab:check` to validate your work.
