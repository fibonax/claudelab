# ClaudeLab (cclab)

An interactive tutorial system that teaches Claude Code — directly inside Claude Code. Learn through progressive, validated exercises with setup, instructions, validation, and hints.

## Inspiration

When I started using Claude Code, I tried to find tutorials online but almost all of them were blogs or instructional videos, even the official course from Anthropic. At that time, I was also learning Rust and [Rustlings](https://github.com/rust-lang/rustlings) is a pretty neat CLI learning tool. It inspired me to create ClaudeLab (cclab).

## How It Works

ClaudeLab is a Claude Code plugin. Each exercise is self-contained with:

- **Metadata** — ID (`cc-NNN`), track, difficulty
- **Setup** — prepares the environment
- **Instructions** — what to do (markdown)
- **Validation** — programmatic checks for correctness
- **Hints** — progressive: gentle → specific → near-answer

## Tracks

- **Fundamentals** — core Claude Code concepts
- **Skills** — building and using skills
- **Workflows** — real-world development patterns
- **Advanced** — deep customization and plugin development

## Getting Started

```bash
# Install the plugin in Claude Code, then:
claude
```

## Development

See [CLAUDE.md](./CLAUDE.md) for project conventions and the development pipeline.

## License

MIT
