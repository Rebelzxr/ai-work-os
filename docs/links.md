# Links (video, web and marketing add-ons)

These are never vendored into this repo. Install each from its own project, read its licence, and credit its author. Every row below was checked live against the GitHub API (`gh api repos/<owner>/<repo> --jq '.license.spdx_id, .stargazers_count'`) or, where noted, by a direct HTTP check, on **29 September 2026**. If a row here goes stale, that project's own page is the source of truth — `doctor.sh` does not (yet) flag old pages on this file; treat the check date as a hint, not a guarantee.

| Project | What it is for | Official install | Licence | Stars (29 Sep 2026) |
|---|---|---|---|---|
| [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) (HyperFrames) | HTML to deterministic MP4/video rendering; 21 skills; the default hand-off target for `packs/video/skills/video-brief` | `claude plugin marketplace add heygen-com/hyperframes` then `claude plugin install hyperframes@hyperframes`. Needs Node ≥22 and FFmpeg (requirements checked against its README on 2026-09-30). | Apache-2.0 | 54,100 |
| [browser-use/video-use](https://github.com/browser-use/video-use) | Edit video by conversation | See its own README | MIT | 27,553 |
| [remotion-dev/skills](https://github.com/remotion-dev/skills) and [remotion-dev/remotion](https://github.com/remotion-dev/remotion) | React-based video; `npx skills add remotion-dev/skills` | `npx skills add remotion-dev/skills` | **Warning:** the `skills` repo ships with no LICENSE file. The Remotion runtime itself is free for individuals, non-profits and for-profit organisations with up to 3 employees — a business bigger than that needs a paid company licence before shipping video built with it. Read Remotion's own licence page before using this for an SME with more than 3 staff. | 4,765 (skills) / 61,051 (remotion) |
| [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | 50+ marketing skills (seo-audit, ai-seo, copywriting, social, cold-email, emails, video) around one shared product-marketing context file — deeper than anything authored in `packs/marketing` here | Agent Skills spec; see its README for `npx skills add` or plugin install | MIT | 51,883 |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Official plugin directory: `playwright`, `frontend-design`, `github`, and several messaging channels | `/plugin install playwright@claude-plugins-official` (or `frontend-design@claude-plugins-official`, etc.), run inside Claude Code | Apache-2.0 (directory); each plugin inside may carry its own licence — check before installing one | 37,190 |
| [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) | Browser automation CLI for agents: open pages, click, fill forms, take screenshots — usable inside `site-loop`'s capture step | `npm install -g agent-browser && agent-browser install` | Apache-2.0 | 43,350 |
| [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | A design language and UI critique for coding agents | `npx impeccable install` | Apache-2.0 | 72,378 |
| [Rebelzxr/fable-forge](https://github.com/Rebelzxr/fable-forge) | Dainer's own website-design skill: subject-led creative direction with render evidence | `git clone https://github.com/Rebelzxr/fable-forge.git ~/fable-forge && ~/fable-forge/install.sh` | Apache-2.0 | 0 |
| [Rebelzxr/second-brain-agent](https://github.com/Rebelzxr/second-brain-agent) | Dainer's second-brain skill set: digest, compile-wiki, ask-brain, weekly-review | See its own README | MIT | 0 |
| [Rebelzxr/ai-news-picker](https://github.com/Rebelzxr/ai-news-picker) | Dainer's daily AI news picker | See its own README | MIT | 0 |
| [PLUTO](https://pluto.dainer-ai.biz/) | Dainer's hosted website-visibility check — a running tool, not a repo | Open the URL directly; no install | n/a (hosted product) | Checked live: `curl` returned `200` on 29 Sep 2026 |
| [dainer-ai.biz/library](https://dainer-ai.biz/library) | The free published library this repo's `packs/business` and `packs/marketing` skills are adapted from | Open the URL directly | n/a (published content) | Checked live: `curl` returned `200` on 29 Sep 2026 |

## Vercel and Cloudflare

The official Vercel plugin/MCP and Cloudflare's own skills are the right route for deploy and DNS work from an agent — see `docs/connect/README.md` for what is documented so far in this repo, and each vendor's own docs for the rest. Both of these can take irreversible or billed actions (a production deploy, a domain purchase, a DNS change); `template/AGENTS.md` §5 lists the ones that always need your approval.

## Never vendored

None of the projects above have any file copied into this repository. Where a skill in `packs/marketing`, `packs/web` or `packs/video` is *adapted* from Dainer's own already-published work (the `dainer-ai.biz/library` guides), that is noted in the skill's own `SKILL.md`, not treated as a third-party link.
