# Install

Checked against the primary docs below on **2026-09-29**. Formats change; if a command here stops working, check the linked page's date against today and open an issue.

## One-command install (plugin marketplace)

This repo is a [Claude Code plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces): `.claude-plugin/marketplace.json` at the repo root lists six plugins — `aiwos-core` (source: `./packs/core`, 6 skills), `aiwos-business` (source: `./packs/business`, 6 skills), `aiwos-thinking` (source: `./packs/thinking`, 7 skills), `aiwos-marketing` (source: `./packs/marketing`, 3 skills), `aiwos-web` (source: `./packs/web`, 1 skill) and `aiwos-video` (source: `./packs/video`, 1 skill). See [docs/packs.md](packs.md) for what each one has.

**Claude Code:**

```bash
claude plugin marketplace add Rebelzxr/ai-work-os
claude plugin install aiwos-core@ai-work-os
# and, if you want them:
claude plugin install aiwos-business@ai-work-os
claude plugin install aiwos-thinking@ai-work-os
claude plugin install aiwos-marketing@ai-work-os
claude plugin install aiwos-web@ai-work-os
claude plugin install aiwos-video@ai-work-os
```

Skills then run as `/aiwos-core:onboard`, `/aiwos-core:what-now`, `/aiwos-core:eod`, `/aiwos-core:evidence-loop`, `/aiwos-core:handoff`, `/aiwos-core:job-packet`, and likewise `/aiwos-business:lead-triage`, `/aiwos-thinking:goal`, `/aiwos-marketing:gbp-posts`, `/aiwos-web:site-loop`, `/aiwos-video:video-brief`, and so on for each pack's skills. Verified with `claude plugin validate .` (validates the whole marketplace plus all six plugins) and `claude plugin validate ./packs/<name>` for every pack (Claude Code 2.1.284, 2026-09-29): `✔ Validation passed` for the marketplace and every one of the six plugin manifests.

**Codex:** OpenAI's plugin docs say the Codex app reads a repo's own `$REPO_ROOT/.agents/plugins/marketplace.json`, and also treats a `$REPO_ROOT/.claude-plugin/marketplace.json` as **legacy-compatible** — so the same file this repo already has works:

```bash
codex plugin marketplace add Rebelzxr/ai-work-os
codex plugin add aiwos-core@ai-work-os
```

**Verified against a live Codex install** (codex-cli 0.154.0, 2026-09-29), for `aiwos-core` only: `codex plugin marketplace add .` read this repo's `.claude-plugin/marketplace.json` with no separate `.agents/plugins/marketplace.json` needed, `codex plugin list` showed `aiwos-core@ai-work-os`, and `codex plugin add aiwos-core@ai-work-os` installed it to `~/.codex/plugins/cache/ai-work-os/aiwos-core/2.0.0/` with all six skills present under `skills/`. The plugin and marketplace were removed again after the test (`codex plugin remove`, `codex plugin marketplace remove`) so this check leaves no residue on the machine it ran on. **`aiwos-business`, `aiwos-thinking`, `aiwos-marketing`, `aiwos-web` and `aiwos-video` have not had the same live Codex round trip** — they are validated structurally by `claude plugin validate .` and `claude plugin validate ./packs/<name>` (manifest shape, frontmatter, marketplace entry match) but not installed and exercised in a live Codex session. Treat the Codex install command above as expected-to-work-the-same-way for those five packs, not as separately confirmed.

Sources used for this section:
- Plugin manifest format: <https://code.claude.com/docs/en/plugin-marketplaces> (fetched 2026-09-29)
- Plugin manifest fields (`plugin.json`): <https://code.claude.com/docs/en/plugins-reference> (fetched 2026-09-29)
- Codex plugins and the legacy-compatible marketplace path: `developers.openai.com/plugins/build/plugins` — confirmed by the live Codex test above, not just the doc citation

## Skills-only install (no plugin system)

Works with any agent that reads the [Agent Skills](https://github.com/agentskills/agentskills) folder format:

```bash
npx skills add Rebelzxr/ai-work-os
```

This discovers `SKILL.md` files under `packs/*/skills/` and the top-level `skills/` folder (kept as compatibility symlinks — see below). **Unverified**: whether `npx skills add` walks nested `packs/*/skills/` without a manifest pointing at it, or only the top-level `skills/` folder, has not been tested live yet. If it only finds `skills/`, that folder still has every core skill (as symlinks into `packs/core/skills/`), so nothing is missed.

## setup.sh (the workspace, not just the skills)

The plugin and `npx skills` routes install skills only. `setup.sh` is still how you get the workspace itself — the board, `AGENTS.md`, the hooks, `dispatch/`:

```bash
git clone https://github.com/Rebelzxr/ai-work-os.git
cd ai-work-os
./setup.sh ~/my-work --link-skills
```

With no `--pack`, `--link-skills` links every skill in every pack (24, across `core`, `business`, `thinking`, `marketing`, `web` and `video`). Add `--codex` to also link skills for Codex, `--pack core` (or `--pack core,business`, or repeated `--pack core --pack business`) to link only specific packs, and see `./setup.sh --help` for `--force` and `--upgrade`.

## Codex skills path

OpenAI's docs list the Codex **user** skills scope as `$HOME/.agents/skills` (project scope is `$CWD/.agents/skills` up to the repo root). `setup.sh --codex` links there. It also links into `$HOME/.codex/skills` for backward compatibility with earlier installs of this repo, which used that path before it was checked against the docs.

Source: <https://learn.chatgpt.com/docs/build-skills> (redirected from `developers.openai.com/codex/skills`; checked 2026-09-29). Note: `vercel-labs/skills`' own README maps the Codex global scope to `~/.codex/skills` instead, which conflicts with OpenAI's page — that is exactly why `setup.sh --codex` links both paths rather than picking one. Run `./doctor.sh` after linking to see what's actually on disk.

## Uninstall / start over

- Plugin: `claude plugin marketplace remove ai-work-os` (removes the marketplace and uninstalls `aiwos-core`).
- `setup.sh --link-skills`: remove the symlinks under `~/.claude/skills` (and `~/.agents/skills`, `~/.codex/skills` if you used `--codex`) by name.
- Workspace: it's plain files in the folder you gave `setup.sh` — delete that folder yourself when you're done with it.
