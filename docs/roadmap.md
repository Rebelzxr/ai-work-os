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

- Whether the legacy `~/.codex/skills` path is still read by a current Codex install. Older setups linked user-level folders; setup now links only project-level `.claude/skills` and, with `--codex`, `.agents/skills`. Existing global links are left for the owner to review.
- Whether `npx skills add` discovers skills under `packs/*/skills/` without an extra manifest, or only the flat `skills/` folder — see `docs/install.md`. The flat folder is kept (as symlinks) specifically so this doesn't matter either way.
- `claude mcp list` output format, for a future `doctor.sh` check of connected MCP servers — not attempted in this build.

## v2.1 gaps (marketing, web, video packs)

- **Assets not regenerated.** `assets/terminal-setup.svg` and `assets/terminal-tests.svg` still show the v1.0/early-v2.0 terminal output (19 skills linked, an older test total) and were not re-captured for this build — regenerating a "real terminal output only" capture needs an actual run, which this job's scope did not include. The README's alt text on these images says so; the current setup offers 17 default skills and 7 optional thinking tools. The README badge sums the current suite outputs and includes structural checks; those checks do not measure skill output quality.
- **docs/connect/telegram.md is docs-only, not live-tested.** Creating a bot and confirming `getMe` was out of scope for a build told not to call any message-sending API; the page says this plainly.
- **docs/connect/google.md, notion.md, vercel.md, cloudflare.md are not shipped.** They need a clean test account per service, which is an account-creation decision, not something this build could do unattended. `docs/connect/README.md` lists them as coming and points at each vendor's own docs in the meantime.
- **`aiwos-marketing`, `aiwos-web` and `aiwos-video` have not had a live Codex plugin-install round trip**, the same gap noted above for `aiwos-business` and `aiwos-thinking` — only `aiwos-core` has been installed and exercised in a live Codex session.
- **Fixture checklists for the three new packs are manual/agent-evaluation fixtures**, same as most of `packs/business` and `packs/thinking` — `tests/packs/run.sh` checks they exist and are non-trivial, not that a live run of the skill actually satisfies every checklist item. `check-captions.py` is the one fully automated, deterministic check in this batch (`tests/test-captions.sh`, must-pass/must-fail fixtures, with current counts printed by the suite).
