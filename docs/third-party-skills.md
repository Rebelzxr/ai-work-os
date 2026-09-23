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

Install commands were copied from each project's README on 23 September 2026. If one stops working, the project's own README is the source of truth.

## How they fit together

- **superpowers** and **karpathy** shape *how* an agent codes: plan, test, keep changes small.
- **gstack** gives an agent *roles* to play.
- **AI Work OS** is the layer around all of them: who decides what, one board, job packets, receipts, evidence before claims, and hooks that stop one-way-door commands.
