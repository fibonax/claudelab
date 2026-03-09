# cclab: Rustlings for Claude Code — Learn by Doing, Right in Your Terminal

## The Problem

Claude Code is arguably the most powerful agentic coding tool on the market, but it has a brutal discoverability problem. Developers install it, run a few prompts, get decent results, and assume that's all there is. They never discover CLAUDE.md context files, custom slash commands, skills, hooks, subagents, MCP servers, git worktree parallelism, or the dozens of other features that turn Claude Code from "a chatbot in my terminal" into an autonomous development system. The gap between a novice Claude Code user and an expert is enormous — easily a 5-10x productivity difference — and there's no structured path to cross it.

The current learning options are broken in predictable ways. Official docs are comprehensive but reference-style — great for looking something up, terrible for building muscle memory. YouTube tutorials show you someone else's screen, not your own. Blog posts go stale within weeks as Claude Code ships updates. Courses on Coursera or DeepLearning.AI teach concepts in a passive video-and-quiz format, which is fundamentally wrong for a tool that lives in the terminal. You don't learn a CLI tool by watching slides. You learn it by typing commands, seeing what happens, and building habits.

The open-source developer tool community has solved this exact problem for programming languages. Rustlings (58k+ GitHub stars) teaches Rust through small exercises you fix in your editor. Exercism does the same across dozens of languages. Githug teaches git through progressive challenges. But nobody has applied this proven "learn by doing with validation" model to AI development tools. That's the gap.

## The Solution

cclab is a Claude Code plugin that teaches Claude Code itself through progressive, validated exercises — directly inside Claude Code. You install it with one command (`/plugin add`), type `/cclab:start`, and you're learning. No web browser. No video player. No separate app. You learn Claude Code inside Claude Code.

The core loop is simple and addictive. cclab presents an exercise: a clear objective ("Create a CLAUDE.md file that tells Claude to always use TypeScript strict mode"), a scaffolded project to work in, and hints if you get stuck. You do the work using Claude Code as you normally would. When you think you're done, you run `/cclab:check` — cclab runs automated assertions against your project (does the CLAUDE.md file exist? does it contain the right directives? does Claude Code actually behave differently when prompted?) and tells you whether you passed. If you pass, you unlock the next exercise. If you fail, you get specific feedback on what's wrong and can try again.

Exercises are organized into progressive learning paths called "quests." The first quest ("Fundamentals") teaches CLAUDE.md, basic prompting patterns, and file context. The second ("Workflows") covers slash commands, hooks, and permissions. The third ("Power User") introduces skills, subagents, MCP servers, and parallel workflows with worktrees. Each quest has 8-12 exercises that take 5-15 minutes each, so a developer can complete one during a coffee break or burn through a whole quest in a focused afternoon.

The secret weapon is that cclab is a Claude Code plugin — which means it dogfoods the very features it teaches. The plugin itself uses skills, slash commands, hooks, and scripts. When a learner finishes the "Custom Slash Commands" exercise, they can look at cclab's own source code and see exactly how a real-world plugin implements them. The tool is both the teacher and the textbook.

## Target Audience

The primary user is a developer who already has Claude Code installed (or is about to install it) and wants to actually get good at it. They're the person who has a Claude Max or Pro subscription, uses Claude Code a few times a week for basic tasks, but knows they're barely scratching the surface. They saw someone on X/Twitter demonstrate multi-agent worktrees or a custom hook that auto-lints on every edit, thought "I should learn how to do that," but never found a structured way to start.

This person is typically a mid-level to senior developer (3-10 years experience), working at a startup or tech company, already comfortable in the terminal. They're active on GitHub, follow AI tooling discussions on Hacker News or X/Twitter, and star repos that look useful. Critically, they're the type who installs developer tools through GitHub repos and npm packages, not through enterprise procurement. There are roughly 1-2 million developers actively using Claude Code as of early 2026, and growing fast. Even a conservative 2% penetration gets you 20-40k users — more than enough for a strong open-source following.


## Market Landscape

The competitive landscape for "learn Claude Code" tools is thin but growing:

**learn-faster-kit (Hugo Lau)** — A Claude Code plugin with educational agents inspired by the FASTER self-teaching methodology. It uses spaced repetition and active learning techniques, which is a clever approach. However, it's a pedagogical framework, not a structured curriculum with specific exercises and validation. It helps you learn *anything* faster using Claude Code, but doesn't teach Claude Code itself through hands-on practice.

**awesome-claude-code (hesreallyhim)** — A curated list of Claude Code plugins, commands, and resources. Massively useful as a directory, but it's a reading list, not a learning tool. It tells you what exists; it doesn't help you build skills.

**Claude Command Suite (qdhenry)** — 216+ slash commands covering development workflows. Impressive in scope, but it's a productivity tool, not a learning tool. Using it doesn't teach you how or why the commands work, or how to build your own.

**Official Anthropic courses (Coursera, Skilljar, DeepLearning.AI)** — Passive learning formats (video + quiz). Good for conceptual understanding, wrong for building CLI muscle memory. They don't put you in a terminal with exercises to complete.

**Rustlings (the format inspiration, not a competitor)** — 58.9k GitHub stars. Proves that the "progressive exercises with automated validation in the terminal" format is wildly popular among developers. Nobody has cloned this model for an AI tool.

The real wedge for cclab is that it's the only tool that combines all three: (1) native to Claude Code as a plugin, (2) structured progressive curriculum, and (3) automated validation that proves you actually learned the thing. Everything else has one or two of these, but not all three.

## Technical Considerations

**Architecture:** cclab is a Claude Code plugin, distributed as a Git repository. It consists of skills (for the `/cclab:*` commands), exercise files (markdown instructions + scaffolded project templates), and validation scripts (bash/Node.js scripts that assert exercise completion). No external server needed — everything runs locally.

**Plugin structure:**
```
cclab/
├── skills/
│   ├── start/SKILL.md          # /cclab:start — begin or resume
│   ├── check/SKILL.md          # /cclab:check — validate current exercise
│   ├── hint/SKILL.md           # /cclab:hint — get a hint
│   ├── status/SKILL.md         # /cclab:status — show progress
│   └── reset/SKILL.md          # /cclab:reset — reset current exercise
├── exercises/
│   ├── 01-fundamentals/
│   │   ├── 01-hello-claude/
│   │   │   ├── README.md       # Exercise instructions
│   │   │   ├── scaffold/       # Starter project files
│   │   │   └── validate.sh     # Assertion script
│   │   ├── 02-claude-md/
│   │   └── ...
│   ├── 02-workflows/
│   └── 03-power-user/
├── hooks/
│   └── post-check.sh           # Runs after validation, updates progress
├── progress.json               # Local progress tracking
└── CLAUDE.md                   # Plugin context for Claude Code
```

**Validation engine:** Each exercise has a `validate.sh` script that runs assertions. Assertions can check file existence, file content (grep/regex), command output, git state, Claude Code configuration, and even behavioral tests (e.g., "run Claude Code with this prompt and verify the output respects the CLAUDE.md constraint"). The validation script returns exit code 0 on pass, non-zero on fail, with human-readable error messages on stdout.

**Progress tracking:** A local `progress.json` file tracks completed exercises. No server, no account, no telemetry. This is important for open-source trust. Optional: generate a shareable "completion badge" as an SVG that users can add to their GitHub profile README.

**Key technical risks:** (1) Claude Code plugin API stability — the plugin system is relatively new and could change. Mitigate by keeping the plugin surface area small and testing against each Claude Code release. (2) Exercise validation reliability — asserting that a developer "did the right thing" in an open-ended environment is harder than checking if Rust code compiles. Mitigate by designing exercises with clear, unambiguous success criteria and testing validation scripts extensively. (3) Claude Code version fragmentation — exercises that reference specific commands or behaviors might break across versions. Mitigate by testing each quest against the latest Claude Code version in CI and tagging exercises with minimum version requirements.