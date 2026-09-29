# Recommended third-party skills

These are skills from other people that work well next to the AI Work OS. They are **not** copied into this repo. Install them from their own repos, read their licences, and credit their authors. `./install-skills.sh` lists them with the official install commands.

| Skill | What it is for | Official install | Licence |
|---|---|---|---|
| [superpowers](https://github.com/obra/superpowers) by Jesse Vincent | Process skills: brainstorm, write a plan, test first, debug step by step, verify before claiming done | In Claude Code: `/plugin install superpowers@claude-plugins-official` | MIT |
| [gstack](https://github.com/garrytan/gstack) by Garry Tan | An opinionated set of roles: CEO review, designer, eng manager, release manager, QA | `git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack && cd ~/gstack && ./setup` | MIT |
| [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) by forrestchang | One CLAUDE.md of coding pitfalls drawn from Andrej Karpathy's observations: think first, keep it simple, change only what you must | In Claude Code: `/plugin marketplace add forrestchang/andrej-karpathy-skills`, then `/plugin install andrej-karpathy-skills@karpathy-skills` | Its README says MIT but the repo has no LICENSE file, so it is linked here, never copied |
| [huashu-design](https://github.com/alchaincyf/huashu-design) by alchaincyf | HTML-native design: prototypes, slides, motion and a five-part design review | `npx skills add alchaincyf/huashu-design` | MIT |
| [last30days](https://github.com/mvanhorn/last30days-skill) by Matt Van Horn | Research what people said about a topic in the last 30 days across Reddit, X, YouTube and Hacker News | `npx skills add mvanhorn/last30days-skill -g` | MIT |
| [impeccable](https://github.com/pbakaus/impeccable) by Paul Bakaus | A design language and UI critique for coding agents | `npx impeccable install` | Apache-2.0 |
| [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | UI and UX design intelligence: styles, palettes, font pairings | In Claude Code: `/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill`, then `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill` | MIT |
| [agent-browser](https://github.com/vercel-labs/agent-browser) by Vercel Labs | A browser automation CLI for agents: open pages, click, fill forms, take screenshots | `npm install -g agent-browser && agent-browser install` | Apache-2.0 |
| [fable-forge](https://github.com/Rebelzxr/fable-forge) by Dainer | Website design for agents: subject-led direction, honest content, render evidence | `git clone https://github.com/Rebelzxr/fable-forge.git ~/fable-forge && ~/fable-forge/install.sh` | Apache-2.0 |

Install commands were copied from each project's README on 23 September 2026. Re-checked 29 September 2026 via `gh api repos/<owner>/<repo>` for each of the nine repos above: none is archived, and every licence matches what's listed here — the install commands themselves were not re-fetched from each README on this pass. If one stops working, the project's own README is the source of truth.

## Marketing, web and video (checked 29 September 2026)

Added alongside the `packs/marketing`, `packs/web` and `packs/video` packs. Full detail, including licence warnings and the exact `gh api` check used, is in [docs/links.md](links.md) — this table is the short version.

| Skill | What it is for | Official install | Licence |
|---|---|---|---|
| [marketingskills](https://github.com/coreyhaines31/marketingskills) by Corey Haines | 50+ marketing skills (SEO, ai-seo, copywriting, social, cold-email, emails, video) — deeper than the 3 skills authored in `packs/marketing` | See its README (Agent Skills spec) | MIT |
| [claude-plugins-official](https://github.com/anthropics/claude-plugins-official) (playwright, frontend-design, github) | Official plugins used by `packs/web`'s `site-loop`: browser capture, front-end design review, GitHub operations | `/plugin install playwright@claude-plugins-official` (similarly for the others), inside Claude Code | Apache-2.0 directory; each inner plugin may carry its own licence |
| [HyperFrames](https://github.com/heygen-com/hyperframes) | HTML to deterministic MP4; the default hand-off target for `packs/video`'s `video-brief` | `claude plugin marketplace add heygen-com/hyperframes` then `claude plugin install hyperframes@hyperframes` (Node ≥22 and FFmpeg; requirements checked 2026-09-30) | Apache-2.0 |
| [video-use](https://github.com/browser-use/video-use) | Edit video by conversation | See its README | MIT |
| [Remotion skills](https://github.com/remotion-dev/skills) / [Remotion](https://github.com/remotion-dev/remotion) | React-based video | `npx skills add remotion-dev/skills` | **Link only, with a warning:** the skills repo has no LICENSE file, and Remotion's own runtime licence is free only up to 3 employees — a bigger business needs a paid company licence |
| [PLUTO](https://pluto.dainer-ai.biz/) | Dainer's hosted website-visibility check | Open the URL | n/a (hosted product) |

## How they fit together

- **superpowers** and **karpathy** shape *how* an agent codes: plan, test, keep changes small.
- **gstack** gives an agent *roles* to play.
- **marketingskills**, **HyperFrames**, **video-use** and the official Claude plugins go deeper on marketing, video and web than this repo's own small packs try to.
- **AI Work OS** is the layer around all of them: who decides what, one board, job packets, receipts, evidence before claims, and hooks that stop one-way-door commands.
