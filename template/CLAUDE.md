# CLAUDE.md: entry point for Claude Code

@AGENTS.md

This file routes work. The rules live in `AGENTS.md`. Load only what the current job needs.

## Lanes

| When the request is about | Read first |
|---|---|
| `<project one>` | `lanes/<project-one>/CLAUDE.md` and its row in `memory/TODO.md` |
| `<project two>` | `lanes/<project-two>/CLAUDE.md` |
| Anything else | `memory/TODO.md`, then ask which lane it belongs to |

## Common requests

- **"what now"**: read `memory/TODO.md`. Give the one bottleneck, the one most useful outcome, then at most three actions with an owner each.
- **"handoff"**: use the `handoff` skill. Write a self-contained prompt to `memory/session-handoffs/`.
- **"eod"** or **"log session"**: use the `eod` skill. Summarise what was saved; do not invent progress.
- **"send to builder"**: write a job packet with the `job-packet` skill, then hand it to the builder agent.
