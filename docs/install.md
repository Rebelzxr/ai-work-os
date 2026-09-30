# Install

Checked against the primary docs below on **2026-09-29**. Formats change; if a command here stops working, check the linked page's date against today and open an issue.

## Create a new workspace (recommended starting route)

The kit is free; Claude Code or Codex may need a paid plan. You need bash, git and python3. From a terminal:

```bash
git clone https://github.com/Rebelzxr/ai-work-os.git
cd ai-work-os
./setup.sh ~/my-work --link-skills
cd ~/my-work
claude
```

Say **"onboard"** to fill in the rules and board, then **"what now"**. The first customer-drafting run uses made-up examples. Clean any later real input locally before sharing it with an AI tool.

`setup.sh` creates the workspace itself: `AGENTS.md`, `memory/TODO.md`, hooks and `dispatch/`. Plugins and `npx skills` install skills only; they cannot replace this step.

With no `--pack`, `--link-skills` links **core + business + marketing + web + video** (17 skills) into `~/my-work/.claude/skills`. Add `--codex` to also link into `~/my-work/.agents/skills`. Setup does not write user-level skills folders. Existing global links from an earlier install stay where they are; remove unwanted links by name yourself after checking their targets.

To add the **optional thinking pack** later:

```bash
./setup.sh ~/my-work --link-skills --pack thinking
```

Add `--codex` for Codex. An explicit `--pack core,business` (or repeated `--pack core --pack business`) selects only those packs for that run; existing skills stay in place. Links point to this clone, so updating the clone also changes the linked skill content.

### Review an upgrade

Run `./setup.sh ~/my-work --upgrade` for a read-only list and per-file diff of template changes. Merge wanted changes into your files. A normal setup run preserves existing files and adds missing ones.

`--force` is for deliberate replacement only. Before replacing anything, setup moves every affected original file, directory or link under `~/my-work/.aiwos-backups/<timestamp>/` and prints its location. Backups are outside skill discovery folders; repeated runs use separate folders. To undo a replacement, stop agents in the workspace, inspect the printed backup, move the new file aside and restore that original to its printed source path.

### Project skill paths

Claude skills: `<workspace>/.claude/skills`. Codex skills: `<workspace>/.agents/skills`. Run `./doctor.sh ~/my-work` from this clone to check the workspace. It checks hook configuration and executable availability; it does not prove that a runtime has fired a hook or loaded a skill. The doctor counts the 17 default skills; thinking is optional.

## Add skills to an existing workspace (plugins)

Have `AGENTS.md` and `memory/TODO.md` already? Add a pack below. If either is missing, use the new-workspace route above first.

This repo is a [Claude Code plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces): `.claude-plugin/marketplace.json` at the repo root lists six plugins — `aiwos-core` (source: `./packs/core`, 6 skills), `aiwos-business` (source: `./packs/business`, 6 skills), `aiwos-thinking` (source: `./packs/thinking`, 7 skills), `aiwos-marketing` (source: `./packs/marketing`, 3 skills), `aiwos-web` (source: `./packs/web`, 1 skill) and `aiwos-video` (source: `./packs/video`, 1 skill). See [docs/packs.md](packs.md) for what each one has.

**Claude Code:**

```bash
claude plugin marketplace add Rebelzxr/ai-work-os
claude plugin install aiwos-core@ai-work-os --scope project
# and, if you want them:
claude plugin install aiwos-business@ai-work-os --scope project
# Optional thinking tools:
claude plugin install aiwos-thinking@ai-work-os --scope project
claude plugin install aiwos-marketing@ai-work-os --scope project
claude plugin install aiwos-web@ai-work-os --scope project
claude plugin install aiwos-video@ai-work-os --scope project
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

This discovers `SKILL.md` files under `packs/*/skills/` and the top-level `skills/` folder (kept as compatibility symlinks — see below). **Unverified**: whether `npx skills add` walks nested `packs/*/skills/` without a manifest pointing at it, or only the top-level `skills/` folder, has not been tested live yet. If it only finds `skills/`, that folder still has every core skill (as symlinks into `packs/core/skills/`), so the core skills remain available; other packs may be missing.

## Uninstall / start over

- Plugin: `claude plugin marketplace remove ai-work-os` (removes the marketplace and uninstalls `aiwos-core`).
- `setup.sh --link-skills`: remove the symlinks under `<workspace>/.claude/skills` (and `<workspace>/.agents/skills` if you used `--codex`) by name. This does not remove your board, rules or backups.
- Workspace: it's plain files in the folder you gave `setup.sh` — delete that folder yourself when you're done with it.
