# Packs

A pack is a plugin: a folder under `packs/<name>/` with its own `.claude-plugin/plugin.json` and a `skills/` folder of `<skill-name>/SKILL.md` directories. The repo's `.claude-plugin/marketplace.json` at the root lists every pack as one entry in its `plugins` array, so `claude plugin install <pack>@ai-work-os` installs one pack at a time.

## Shipped so far

| Pack | Plugin name | What it has |
|---|---|---|
| `packs/core/` | `aiwos-core` (7 skills) | `business-brief`, `evidence-loop`, `job-packet`, `handoff`, `eod`, `onboard`, `what-now` — start here |
| `packs/business/` | `aiwos-business` (6 skills) | `lead-triage`, `whatsapp-reply`, `quote-from-message`, `safe-to-paste`, `check-before-send`, `voice-note-to-sop` — drafts only, nothing sends |
| `packs/marketing/` | `aiwos-marketing` (3 skills) | `gbp-posts`, `follow-up-drafts`, `content-from-real-work` — drafts only, nothing posts or sends |
| `packs/web/` | `aiwos-web` (1 skill) | `site-loop` — brief, build, local preview, phone/desktop light/dark captures, console-error check, preview deploy; never runs a production deploy |
| `packs/video/` | `aiwos-video` (1 skill) | `video-brief` plus its caption lint |
| `packs/sales/` | `aiwos-sales` (4 skills) | `qualified-prospect-pack`, `discovery-call-planner`, `scope-proposal`, `deal-follow-up` — drafts only |
| `packs/delivery/` | `aiwos-delivery` (3 skills) | `client-kickoff`, `deliverable-production`, `quality-gate` |
| `packs/plan/` | `aiwos-plan` (2 skills) | `weekly-bottleneck-review`, `decision-stress-test` |
| `packs/handoff/` | `aiwos-handoff` (6 skills) | Codex, Claude Code and chat briefs, receiving, return verification and cross-model review |
| `packs/thinking/` | `aiwos-thinking` (7 skills, optional) | `goal`, `feature-to-feeling`, `packaging-audit`, `price-copy-audit`, `prompt-contract`, `reverse-prompt`, `stochastic-multi-agent-consensus` |

The nine default packs contain 33 skills. The thinking pack is optional and adds 7 more. Install any pack at project scope:

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
# Optional:
claude plugin install aiwos-thinking@ai-work-os --scope project
```

## One job, two editions

Every new v2.3 job has an agent edition in `SKILL.md` for Claude Code or Codex and a copy-paste edition in `PROMPT.md` for any AI chat. They cover the same inputs, output, check before use and next job. A chat AI cannot inspect local files unless a person supplies a cleaned brief.

## Run a one-person business

Use the [business brief template](../template/context/business-brief.md) first, keep the checked copy at `context/business-brief.md`, then follow the [weekly rhythm](../workflows/weekly-rhythm.md). The brief holds the offer, rate rules, scope limits, proof, voice, working hours and the AI boundary.

## Work across more than one AI

The [multi-agent guide](multi-agent.md) explains the one-rules-file, one-writer and receipt loop. The `aiwos-handoff` pack contains `handoff-to-codex`, `handoff-to-claude`, `handoff-to-chat`, `receive-handoff`, `verify-return` and `cross-model-review`.

## Adding a new pack

1. Create `packs/<name>/.claude-plugin/plugin.json`, kebab-case `name` (e.g. `aiwos-business`), and the fields `displayName`, `version`, `description`, `author`, `license`. Copy `packs/core/.claude-plugin/plugin.json` as a starting point.
2. Put each skill in `packs/<name>/skills/<skill-name>/SKILL.md`, same frontmatter style as the core skills (`name`, `description` — see `tests/check-frontmatter.py`).
3. Add one entry to the root `.claude-plugin/marketplace.json`'s `plugins` array:

   ```json
   {
     "name": "aiwos-business",
     "source": "./packs/business",
     "description": "One line a browsing user sees before installing."
   }
   ```

   The entry `name` must match the `name` in that pack's own `plugin.json` (see the "Marketplace entries and the manifest" rules at <https://code.claude.com/docs/en/plugins-reference>, checked 2026-09-29) — the two are validated together, and a mismatch fails the install with `Plugin "<manifest-name>" not found in marketplace "<marketplace>"`.
4. Run `claude plugin validate .` at the repo root (validates the whole marketplace plus every relative-path plugin) before committing.
5. `./setup.sh <workspace> --link-skills --pack <name>` links only that pack's skills into `<workspace>/.claude/skills` for local testing without the plugin system.
6. Every skill that mentions send, post, publish, deploy, pay or delete must contain a `## Human approval` section. `bash tests/packs/run.sh` enforces this for every pack.
7. Give the skill a fixture under `tests/packs/<skill-name>/`: `input.md` plus a `checklist.md` of expected-output items. For most skills this is a fixture + checklist meant for manual or agent evaluation, not a fully automated pass/fail — `bash tests/packs/run.sh` checks the fixture is present and non-trivial (a real input, at least three checklist items), but does not itself judge whether a run of the skill satisfied the checklist. `safe-to-paste` is the one skill in this pack with a real automated test on top of that: `tests/packs/safe-to-paste/test_patterns.py` asserts its regexes against known values and fails for real if they stop matching. Where you can build the same kind of deterministic check for a new skill, do — see `tests/test-what-now.sh` and `tests/test-onboard.sh` (in `packs/core`) for a small deterministic reference script plus a fixture input with a clear right answer and at least one wrong-answer distractor.

## Licence and privacy notes for new packs

- Third-party code is never vendored into a pack. Link to it (see `docs/third-party-skills.md`) and credit it; adapt only from sources with a clear permissive licence and, where the source material is someone else's, only from what's already public.
- Run a privacy scan (`grep` for personal paths, emails, tokens) over the new pack's files before every push.

## Business pack

Adapted from the author's own published guides, rewritten as skills for a Malaysian SME owner in plain English.

| Skill | What it does |
|---|---|
| lead-triage | Sorts new enquiries, drafts replies, flags the ones that need you. Never sends. |
| whatsapp-reply | Drafts WhatsApp replies in your voice from your notes and five real examples. |
| quote-from-message | Turns a customer message into a draft quote from your price list, and asks when details are missing. |
| safe-to-paste | Second check after the owner cleans text locally, before sharing with AI. Starts with made-up examples; cannot intercept uploads. Has a sample regex test. |
| check-before-send | Labels each claim in a draft as verified, unverified or broken before it goes to a customer. |
| voice-note-to-sop | Turns a voice-note transcript into a step-by-step SOP, with open questions instead of guesses. |

Money skills (receipts, invoices, weekly report) come in v2.1, after a separate review of the maths.

## Thinking pack

Seven optional thinking tools, excluded from the default setup. Add with `./setup.sh ~/my-work --link-skills --pack thinking`. The author used these privately before this release. Each was checked for origin before shipping: licence or author lines, the skill-installer lock file, any git history in the folder, and a web search for distinctive phrases.

| Skill | Origin | What we shipped |
|---|---|---|
| goal | Written by the author for his own workspace | Rewritten for general use, improved |
| feature-to-feeling | Written by the author for his own projects | Rewritten for general use, improved |
| packaging-audit | Most likely written by the author (no author or licence line either way) | Rewritten for general use, improved |
| price-copy-audit | Origin unclear | Clean-room rewrite: same job, new wording, no original text reused |
| prompt-contract | Origin unclear; the "agree the contract before you build" idea is common in public repos | Clean-room rewrite |
| reverse-prompt | Origin unclear; "ask clarifying questions first" is a widely published pattern | Clean-room rewrite |
| stochastic-multi-agent-consensus | A known community technique with public prior art (for example `KENAN-LABS/stochastic-consensus`) | Clean-room version of the general technique; no text copied; the skill credits the pattern as community prior art |

Test fixtures use made-up names and correctly shaped but fake Malaysian IC, phone and bank numbers. None are real people's data.

## Marketing pack

Adapted from the same published guides as the business pack, plus one generic authored method.

| Skill | What it does |
|---|---|
| gbp-posts | Turns real finished jobs into Google Business Profile post drafts, following Google's own post rules. No invented reviews, ratings or offers. Never posts. |
| follow-up-drafts | Checks a quote list against stop rules, then drafts one useful follow-up per customer who is due. Never sends. |
| content-from-real-work | A generic method: turns one sanitised real job into a LinkedIn/X/blog draft plus shorter repurposed versions. Method only — no private personal-brand voice text. |

## Web pack

One skill: `site-loop`, sourced from the library guide "AI-assisted visual QA: Playwright captures at phone and desktop, light and dark" and this repo's own `evidence-loop` template. Runs brief → build → local preview → captures (phone/desktop × light/dark) → console-error check → explicitly approved preview deploy, and stops there — it never runs a production deploy, changes a live domain, or merges to a production branch.

## Video pack

`video-brief` turns one real job into a 30–60s script, shot list, on-screen text and caption rules, then hands off to a video builder (HyperFrames is the linked default — see `docs/third-party-skills.md`). It never renders or publishes video itself.

`skills/video-brief/scripts/check-captions.py` (beta) is a deterministic lint for common SRT/WebVTT caption mistakes. It is not a complete WebVTT validator: for a full format check, also play the file in your video tool or run it through a dedicated validator. It checks: malformed cue blocks, timestamp ranges, timing overlaps, a cue ending before it starts, characters per line, lines per cue, and reading speed (characters/second). `tests/test-captions.sh` runs it against must-pass and must-fail fixtures under `tests/video/` (the suite prints its current assertion count; character counts strip real caption tags only (<i>, <b>, <u>, <c.x>, <v>, <lang>, <ruby>, <rt>, <font>, timestamp tags) and decode character references; a plain < or > in the text is counted). Lines break only at CR, LF or CRLF, as the WebVTT spec says, timing lines must be plain ASCII (a non-breaking space fails), the arrow needs a space on both sides, and anything after the end time other than a valid WebVTT cue setting (vertical, line, position, size, align, region with allowed values: percentages 0-100, whole line numbers, no repeats) is an error. It fails closed: any line that looks like a timing line (two clock times, or a clock time next to an arrow) inside the WEBVTT header or a NOTE, STYLE or REGION block is reported as a broken cue, so a NOTE such as "meeting 10:00 to 11:00" also fails; reword it or drop it.

## Third-party links for these three packs

`docs/links.md` has the full table (repo, licence, star count, check date) for HyperFrames, marketingskills, video-use, Remotion (with its 3-employee licence warning), the official Claude playwright/frontend-design/github plugins, and agent-browser and impeccable — all checked live against the GitHub API on 29 September 2026.

## Optional pack dependencies and portable scripts

Marketing and video can use business's `safe-to-paste` as a second privacy check. Without business, follow their local-cleaning checklist and manual check instead. Web can use core's `evidence-loop`; without core, keep its own local evidence and result note. Each skill states its fallback. No optional pack adds send authority.

Scripts referenced by a skill must live inside that same pack; use a path relative to the installed skill folder. The caption checker lives inside `video-brief`, so plugin-only and skill-only copies include it. `tests/check-skill-contracts.py` checks these references, local privacy instructions and optional dependency wording. These are structural checks, not evaluations of AI output quality.
