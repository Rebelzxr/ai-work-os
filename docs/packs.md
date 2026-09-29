# Packs

A pack is a plugin: a folder under `packs/<name>/` with its own `.claude-plugin/plugin.json` and a `skills/` folder of `<skill-name>/SKILL.md` directories. The repo's `.claude-plugin/marketplace.json` at the root lists every pack as one entry in its `plugins` array, so `claude plugin install <pack>@ai-work-os` installs one pack at a time.

## Shipped so far

| Pack | Plugin name | What it has |
|---|---|---|
| `packs/core/` | `aiwos-core` | `evidence-loop`, `job-packet`, `handoff`, `eod`, `onboard`, `what-now` — start here |
| `packs/business/` | `aiwos-business` | `lead-triage`, `whatsapp-reply`, `quote-from-message`, `safe-to-paste`, `check-before-send`, `voice-note-to-sop` — drafts only, nothing sends |
| `packs/thinking/` | `aiwos-thinking` | `goal`, `feature-to-feeling`, `packaging-audit`, `price-copy-audit`, `prompt-contract`, `reverse-prompt`, `stochastic-multi-agent-consensus` |

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
5. `setup.sh --link-skills --pack <name>` links only that pack's skills into `~/.claude/skills` for local testing without the plugin system.
6. Every skill that mentions send, post, publish, deploy, pay or delete must contain a `## Human approval` section. `bash tests/packs/run.sh` enforces this for every pack.
7. Give the skill a fixture under `tests/packs/<skill-name>/`: `input.md` plus a `checklist.md` of expected-output items. For most skills this is a fixture + checklist meant for manual or agent evaluation, not a fully automated pass/fail — `bash tests/packs/run.sh` checks the fixture is present and non-trivial (a real input, at least three checklist items), but does not itself judge whether a run of the skill satisfied the checklist. `safe-to-paste` is the one skill in this pack with a real automated test on top of that: `tests/packs/safe-to-paste/test_patterns.py` asserts its regexes against known values and fails for real if they stop matching. Where you can build the same kind of deterministic check for a new skill, do — see `tests/test-what-now.sh` and `tests/test-onboard.sh` (in `packs/core`) for a small deterministic reference script plus a fixture input with a clear right answer and at least one wrong-answer distractor.

## Licence and privacy notes for new packs

- Third-party code is never vendored into a pack. Link to it (see `docs/third-party-skills.md`) and credit it; adapt only from sources with a clear permissive licence and, where the source material is someone else's, only from what's already public.
- Run a privacy scan (`grep` for personal paths, emails, tokens) over the new pack's files before every push.

## Business pack

Adapted from the author's own published guides in the free [dainer-ai.biz library](https://dainer-ai.biz/library), rewritten as skills for a Malaysian SME owner in plain English.

| Skill | What it does |
|---|---|
| lead-triage | Sorts new enquiries, drafts replies, flags the ones that need you. Never sends. |
| whatsapp-reply | Drafts WhatsApp replies in your voice from your notes and five real examples. |
| quote-from-message | Turns a customer message into a draft quote from your price list, and asks when details are missing. |
| safe-to-paste | Checks text for IC numbers, phone numbers, bank accounts and similar before it goes into an AI tool. Has a real pattern test. |
| check-before-send | Labels each claim in a draft as verified, unverified or broken before it goes to a customer. |
| voice-note-to-sop | Turns a voice-note transcript into a step-by-step SOP, with open questions instead of guesses. |

Money skills (receipts, invoices, weekly report) come in v2.1, after a separate review of the maths.

## Thinking pack

Seven thinking tools the author used privately before this release. Each was checked for origin before shipping: licence or author lines, the skill-installer lock file, any git history in the folder, and a web search for distinctive phrases.

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
