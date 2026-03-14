# Code of Conduct

## Our Commitment

ClaudeLab is a learning tool. Everything we build should make it easier for people to learn Claude Code — especially beginners. We hold ourselves to high standards in both community behavior and exercise quality.

## Community Standards

### Be Respectful

- Treat all contributors and learners with kindness and patience.
- Welcome newcomers — remember that this project exists to help people learn.
- Give constructive feedback. Critique the work, not the person.
- Respect differing viewpoints and experience levels.

### Be Collaborative

- Communicate openly. If you're unsure, ask.
- Share context and reasoning behind your decisions.
- Review others' contributions thoughtfully and promptly.

### Unacceptable Behavior

- Harassment, insults, or derogatory comments.
- Publishing others' private information without consent.
- Trolling, spam, or deliberately disruptive behavior.
- Any conduct that would be inappropriate in a professional setting.

## Exercise Quality Standards

Exercises are the core of ClaudeLab. Every exercise shipped to learners must meet these standards:

### Official References Only

All exercise content **must** be grounded in official sources:

- [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Anthropic API documentation](https://docs.anthropic.com/en/api)
- Official Claude Code CLI help (`claude --help`, `/help`)
- Verified behavior from the Claude Code runtime

Do **not** base exercises on blog posts, third-party tutorials, community speculation, or undocumented behavior. If a feature is not in the official docs, it does not belong in an exercise.

**Why this matters:** Learners trust ClaudeLab to teach them correctly. Exercises based on unofficial or outdated sources create confusion and break when the product changes.

### Clear and Easy to Adapt

Every exercise must be:

- **Clear** — Instructions use plain language. A beginner should understand what to do after one read. Avoid jargon unless it is the concept being taught, and define it when introduced.
- **Focused** — Each exercise teaches one concept. Do not combine multiple unrelated ideas into a single exercise.
- **Self-contained** — Everything needed to complete the exercise is provided. No assumed knowledge beyond listed prerequisites.
- **Easy to adapt** — Exercise structure follows the standard anatomy (metadata, instructions, setup, validate, hints). Contributors should be able to use any existing exercise as a template for a new one without guesswork.
- **Deterministic** — Validation scripts produce the same result every time. No flaky checks, no LLM-based validation, no timing-dependent assertions.

### Hint Quality

Hints are part of the learning experience, not an afterthought:

- **Hint 1** — A gentle nudge. Points the learner toward the right area without giving the answer.
- **Hint 2** — More specific. Narrows the approach and may reference a command or file.
- **Hint 3** — Nearly the answer. The learner should be able to finish after reading this.

Each hint level must be meaningfully different from the previous one.

## Enforcement

Maintainers are responsible for enforcing this code of conduct. Violations may result in:

1. A friendly reminder for first-time or minor issues.
2. A formal warning with specific expectations for change.
3. Temporary or permanent exclusion from the project for repeated or severe violations.

To report an issue, contact the maintainer at **thanhtt@fibonax.dev**.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant](https://www.contributor-covenant.org/), with project-specific exercise quality standards added for ClaudeLab.
