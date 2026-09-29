---
name: eod
description: "End-of-day logging. Use when the user says \"eod\", \"end of day\", \"log session\" or \"log all\". Writes a short technical log, an optional plain-language learning note, and updates the board only if the state changed. Summarises saved evidence; never invents progress."
---

# End of day

State should already be saved during the work. This step summarises what exists; it is not the only chance to save.

## Rules first

- Summarise only what has evidence: receipts, commits, files, tests. If something is unproven, say so.
- A trivial session (a question answered, nothing changed) writes nothing.
- Edit only the board rows whose state changed. Re-read the board before saving, and keep other people's recent edits.
- Never copy client data, secrets or private messages into logs.

## File 1: `memory/daily-logs/YYYY-MM-DD.md` (append; terse and technical)

```markdown
## Session HH:MM · <lane>
- Did: <what changed, with file paths>
- Evidence: <receipt links, commit hashes, test summaries>
- Decided: <decision, and the option rejected>
- Blocked: <blocker and who owns it>
- Next: <the exact next action>
```

## File 2 (optional): a learning note in your notes app (append; plain language)

```markdown
## HH:MM · <one-line title>
What I did · What I decided and why · What went wrong and how I fixed it · What I would do differently
```

Write it in the owner's voice only from what they said or did. Do not invent feelings.

## File 3: `memory/TODO.md` (only if the state changed)

For each lane touched: update the outcome's state, evidence and next action in its existing row. Move finished rows out. Update the "Context for next session" block so a fresh session knows where to start.

## Several sessions at once ("log all")

Summarise each session separately, then merge into one daily log with a heading per session. Do not merge two sessions' claims into one.

End with one STATUS line that says what was written.
