# Roadmap: known gaps

## Codex hook wiring (tracked, not shipped)

Codex now has its own hooks (`PreToolUse`, `PostToolUse`, `PreCompact`, `SessionStart`, `Stop`), on by default, living in `~/.codex/hooks.json` or `<repo>/.codex/hooks.json` — see <https://learn.chatgpt.com/docs/hooks> (checked 2026-09-29). A `PreToolUse` hook on `Bash` can block with exit code 2, the same mechanism `template/scripts/hooks/block-dangerous.sh` already uses for Claude Code.

This v2.0 core build does **not** ship a `template/.codex/hooks.json`, for one reason: the exact shape of the JSON Codex sends on stdin to a `PreToolUse` hook (which field carries the shell command `block-dangerous.py` needs to read) has not yet been confirmed against a live Codex run. Shipping the wiring without that confirmation risks a hook that silently never fires (worse than no hook, because it looks protected and isn't) or one that crashes on every command.

**What ships instead:** `block-dangerous.py` already separates "read the JSON and find the command" from "check the command" — the checking logic is Codex-agnostic. Wiring Codex only needs:
1. A live test: run a `PreToolUse` hook against a real Codex session and capture the actual JSON on stdin.
2. A small adapter (or a one-line change to `block-dangerous.sh`) that reads the command from whichever field Codex actually sends.
3. A `template/.codex/hooks.json` pointing at it.
4. A test in `tests/test-hooks.sh` that feeds the *Codex* JSON shape through the adapter, the same way the existing 213 tests feed the Claude Code shape through today.

Until then, `doctor.sh` reports "Codex hook wiring is not shipped yet" rather than claiming protection that hasn't been tested. `AGENTS.md` and the rules files are agent-agnostic and still work as a read-only contract for Codex; only the automatic block is missing.

## Other items not yet verified

- Whether `~/.codex/skills` is still read by a current Codex install (v1 of this repo linked there; `setup.sh --codex` now links both that path and the documented `~/.agents/skills`, and `doctor.sh` reports what's actually on disk).
- Whether `npx skills add` discovers skills under `packs/*/skills/` without an extra manifest, or only the flat `skills/` folder — see `docs/install.md`. The flat folder is kept (as symlinks) specifically so this doesn't matter either way.
- `claude mcp list` output format, for a future `doctor.sh` check of connected MCP servers — not attempted in this build.
