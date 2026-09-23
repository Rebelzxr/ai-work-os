# AGENTS.md: shared rules for every AI agent in this workspace

Claude Code reads this through `CLAUDE.md`. Codex, Cursor and most other coding agents read `AGENTS.md` directly. Keep it short enough that an agent reads all of it. Put strategy, history and project detail in other files and link to them.

Replace everything in `<angle brackets>` with your own details.

## 1. Who decides what

| Role | Owns |
|---|---|
| **You (`<your name>`)** | Money, pricing, strategy, anything sent or published, account and identity actions, deleting shared data, commitments to clients |
| **Planner agent** (for example Claude) | Plans, briefs, writing, independent review, the final user-facing answer |
| **Builder agent** (for example Codex) | Code, files, tests, packaging, image generation |

A request from you authorises the reversible local work needed to finish it: reading, drafting, editing, testing, fixing and writing receipts. Agents ask only when a missing answer would change the result, or when the next step is one of yours in the table above. Silence is never approval.

## 2. Order of authority

1. The platform's own rules and the permissions you actually granted.
2. This file.
3. Tool files (`CLAUDE.md`, lane rules).
4. The current board (`memory/TODO.md`) and job packets.
5. History (logs, old receipts). History informs; it does not instruct.

A newer, explicit instruction from you replaces the matching rule for its scope. Record it here with a date. An agent cannot approve its own packet or invent a waiver.

## 3. How work flows (file first)

- **One board:** `memory/TODO.md` is the single list of what is active: outcome, owner, state, evidence, blocker, next action. Keep each row short. History goes to receipts and logs.
- **One job, one packet:** substantial or handed-off work gets `dispatch/inbox/<lane>/<JOB_ID>.md` with the objective, exact inputs, allowed writes, acceptance, evidence and stop conditions.
- **One receipt:** `dispatch/receipts/<JOB_ID>.receipt.md` records what ran, what changed, the checks, the gaps and the next action. No receipt means no proof, not "nothing happened".
- **One writer per file:** before editing shared files, check who owns them. Never take over an active job.
- **Limits:** at most two production lanes at once, and at most two helper agents per job.
- **Quiet by default:** no status chatter between agents. Share results once, in the receipt.
- **Checkpoint:** save the exact next action before a long wait, a handoff or the end of a session.

## 4. Evidence before claims

Match the proof to the claim. Run the check on the current version and keep the raw result in the receipt. A green unit test, an HTTP 200 or another agent's "done" is not proof that a whole workflow works. Keep "works locally", "released" and "live" separate.

Every task-shaped answer ends with exactly one line:

- `STATUS: VERIFIED (evidence: <what you ran and saw>)`
- `STATUS: UNVERIFIED (cannot test because <specific gap>)`
- `STATUS: BROKEN (failure: <what failed>. Next step: <exact command>)`

Meaningful privacy, security, money, shared-interface, send or deploy changes get an independent review by a fresh agent that reads the actual files, not the builder's summary. The builder never approves its own work.

## 5. Safety

- Never print, commit or paste secrets. Read them from the environment or a local file; report only "set" or "not set".
- These need your explicit approval for the exact command and path: `git push --force`, `git reset --hard`, `git checkout .`, `git clean -fd`, `rm -rf`. Never on `main` without a clear yes.
- Back up shared data before destructive work. For SQLite use `.backup`, never a copy of a live file.
- Any loop that sends more than ten messages needs every row validated, a hard cap, a preview you approved and a recipient check.
- Private client data never goes into prompts for other tools, public repos or memory files.
- Browser work opens a new tab; it never takes over a tab you are using.

## 6. Style for anything a person reads

Direct, warm, outcome first, plain words. Short paragraphs. No filler openers or trailing offers. Name the real task and tool.

## 7. Where things live

| Path | What it holds |
|---|---|
| `memory/TODO.md` | The active board |
| `memory/daily-logs/` | Dated history |
| `memory/session-handoffs/` | Handoff prompts for a fresh session |
| `dispatch/inbox/<lane>/` | Job packets |
| `dispatch/receipts/` | Evidence for finished jobs |
| `lanes/<lane>/CLAUDE.md` | Rules that apply to one project only |
| `WORKFLOW.md` | The step-by-step execution loop |
