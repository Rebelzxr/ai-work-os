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

With no `--pack`, `--link-skills` links **core + business + marketing + web + video + sales + delivery + plan + handoff** (33 skills) into `~/my-work/.claude/skills`. Add `--codex` to also link into `~/my-work/.agents/skills`. Setup does not write user-level skills folders. Existing global links from an earlier install stay where they are; remove unwanted links by name yourself after checking their targets.

To add the **optional thinking pack** later:

```bash
./setup.sh ~/my-work --link-skills --pack thinking
```

Add `--codex` for Codex. An explicit `--pack core,business` (or repeated `--pack core --pack business`) selects only those packs for that run; existing skills stay in place. Links point to this clone, so updating the clone also changes the linked skill content.

### Review an upgrade

Run `./setup.sh ~/my-work --upgrade` for a read-only list and per-file diff of template changes. Merge wanted changes into your files. A normal setup run preserves existing files and adds missing ones.

`--force` is for deliberate replacement only. Before replacing anything, setup moves every affected original file, directory or link under `~/my-work/.aiwos-backups/<timestamp>/` and prints its location. Backups are outside skill discovery folders; repeated runs use separate folders. To undo a replacement, stop agents in the workspace, inspect the printed backup, move the new file aside and restore that original to its printed source path.

### Project skill paths

Claude skills: `<workspace>/.claude/skills`. Codex skills: `<workspace>/.agents/skills`. Run `./doctor.sh ~/my-work` from this clone to check the workspace. It checks hook configuration and executable availability; it does not prove that a runtime has fired a hook or loaded a skill. The doctor counts the 33 default skills; thinking is optional.

## Add skills to an existing workspace (plugins)

Have `AGENTS.md` and `memory/TODO.md` already? Add a pack below. If either is missing, use the new-workspace route above first.

This repo is a [Claude Code plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces): `.claude-plugin/marketplace.json` at the repo root lists ten plugins — `aiwos-core` (source: `./packs/core`, 7 skills), `aiwos-business` (source: `./packs/business`, 6 skills), `aiwos-marketing` (source: `./packs/marketing`, 3 skills), `aiwos-web` (source: `./packs/web`, 1 skill), `aiwos-video` (source: `./packs/video`, 1 skill), `aiwos-sales` (source: `./packs/sales`, 4 skills), `aiwos-delivery` (source: `./packs/delivery`, 3 skills), `aiwos-plan` (source: `./packs/plan`, 2 skills), `aiwos-handoff` (source: `./packs/handoff`, 6 skills), and optional `aiwos-thinking` (source: `./packs/thinking`, 7 skills). See [docs/packs.md](packs.md) for what each one has.

**Claude Code:**

```bash
claude plugin marketplace add Rebelzxr/ai-work-os
claude plugin install aiwos-core@ai-work-os --scope project
claude plugin install aiwos-business@ai-work-os --scope project
claude plugin install aiwos-marketing@ai-work-os --scope project
claude plugin install aiwos-web@ai-work-os --scope project
claude plugin install aiwos-video@ai-work-os --scope project
claude plugin install aiwos-sales@ai-work-os --scope project
claude plugin install aiwos-delivery@ai-work-os --scope project
claude plugin install aiwos-plan@ai-work-os --scope project
claude plugin install aiwos-handoff@ai-work-os --scope project
# Optional thinking tools:
claude plugin install aiwos-thinking@ai-work-os --scope project
```

Skills then run as `/aiwos-core:onboard`, `/aiwos-core:what-now`, `/aiwos-core:eod`, `/aiwos-core:evidence-loop`, `/aiwos-core:handoff`, `/aiwos-core:job-packet`, `/aiwos-core:business-brief`, and likewise `/aiwos-business:lead-triage`, `/aiwos-sales:qualified-prospect-pack`, `/aiwos-delivery:client-kickoff`, `/aiwos-plan:weekly-bottleneck-review`, `/aiwos-handoff:handoff-to-codex`, `/aiwos-marketing:gbp-posts`, `/aiwos-web:site-loop`, `/aiwos-video:video-brief`, and so on for each pack's skills. Run `claude plugin validate .` and `claude plugin validate ./packs/<name>` for every pack before release; these checks cover the marketplace and all ten plugin manifests.

**Codex:** OpenAI's plugin docs say the Codex app reads a repo's own `$REPO_ROOT/.agents/plugins/marketplace.json`, and also treats a `$REPO_ROOT/.claude-plugin/marketplace.json` as **legacy-compatible** — so the same file this repo already has works:

```bash
codex plugin marketplace add Rebelzxr/ai-work-os
codex plugin add aiwos-core@ai-work-os
```

**Verified against a live Codex install** (codex-cli 0.154.0, 2026-09-29), for `aiwos-core` only: `codex plugin marketplace add .` read this repo's `.claude-plugin/marketplace.json` with no separate `.agents/plugins/marketplace.json` needed, `codex plugin list` showed `aiwos-core@ai-work-os`, and `codex plugin add aiwos-core@ai-work-os` installed it to the Codex plugin cache with all seven core skills present under `skills/`. The plugin and marketplace were removed again after the test so this check left no residue on the machine it ran on. **The other nine packs have not had the same live Codex round trip** — they are validated structurally by the Claude plugin checks but are not claimed as installed and exercised in a live Codex session.

Sources used for this section:
- Plugin manifest format: <https://code.claude.com/docs/en/plugin-marketplaces> (fetched 2026-09-29)
- Plugin manifest fields (`plugin.json`): <https://code.claude.com/docs/en/plugins-reference> (fetched 2026-09-29)
- Codex plugins and the legacy-compatible marketplace path: `developers.openai.com/plugins/build/plugins` — confirmed by the live Codex test above, not just the doc citation

## One job, two editions

New v2.3 jobs ship as `SKILL.md` for Claude Code or Codex and `PROMPT.md` for a copy-paste run in any AI chat. Both describe the same inputs, result, check before use and next job. The chat version cannot inspect a local workspace by itself.

## Run a one-person business

Copy the [business brief template](../template/context/business-brief.md) into the workspace, check it, and keep the working file at `context/business-brief.md`. Then use the [weekly rhythm](../workflows/weekly-rhythm.md) to choose a small set of jobs for the week and leave a buffer for existing commitments.

## Work across more than one AI

Use [docs/multi-agent.md](multi-agent.md) and the `aiwos-handoff` jobs when more than one tool touches a workspace. The handoff pack covers Codex, Claude Code and chat briefs, receiving, return verification and read-only cross-model review. A person still approves external actions.

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
