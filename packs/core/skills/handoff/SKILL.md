---
name: handoff
description: "Compact the current session into a self-contained prompt that a fresh agent session can pick up with no chat history. Use when the user says \"handoff\", when the context is long, before switching tools or agents, or before a long break."
---

# Handoff

A handoff is a file, not a chat message. A fresh session should be able to continue from it alone.

## Steps

1. Re-read the board row and the job receipt for this work. Trust files over memory.
2. Run the quick checks that tell the next session where things stand (for example `git log --oneline -3`, the test summary, whether the site is live).
3. Write `memory/session-handoffs/YYYY-MM-DD-<topic>.md` with the sections below.
4. Reply with the file path and the one line to paste into the new session.

## Sections

```markdown
# Handoff: <topic>

Paste into a fresh session opened at <workspace path>:
> Read <this file path> and continue the job it describes. <One hard limit, for example "do not deploy".>

## Goal
<The outcome, in one or two sentences.>

## Where it stands
<What is done, with evidence (commits, receipts, test results). What is live versus local.>

## Decisions made
<Decision, and the option rejected with the reason, so the next session does not reopen it.>

## Open items by owner
- Human: <decisions only they can make>
- Agent: <the next concrete steps>

## Check before you start
<Commands that confirm the state is still as described.>

## Next action
<The single first step.>
```

## Constraints

- Self-contained: no "as we discussed". Include paths, versions and names.
- No secrets and no private client data. Link to files instead of pasting their contents.
- Keep it under two screens. Long history belongs in receipts.

End with one STATUS line.
