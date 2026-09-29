---
name: what-now
description: "Read the board and the latest receipts, then answer one question: what now. Use when the user says \"what now\", \"morning brief\", \"status\" or opens a session with no other instruction. Read-only: never edits the board."
---

# What now

Turns `memory/TODO.md` plus the newest evidence into one bottleneck, one outcome and up to three actions. Read-only — it never edits the board itself.

## Read, in order

1. `memory/TODO.md` — every active lane's rows, and the "Context for next session" block.
2. For each row that names a receipt, open `dispatch/receipts/<JOB_ID>.receipt.md` and check it actually supports what the row claims (a row saying "done" with no receipt, or a receipt that contradicts the row, is a blocker worth surfacing, not something to paper over).
3. `dispatch/inbox/<lane>/` for a packet with no matching receipt yet — that is work in flight, not the bottleneck to name unless nothing else is moving.

## Decide the bottleneck

The bottleneck is the one row that is blocking the most other work or is most overdue, not simply the first row on the board. In order:
1. a row marked blocked (oldest first, when several are blocked);
2. else a row whose "next action" needs the user specifically (a decision, an approval, a send);
3. else the first active row on the board.

`<this skill's folder>/scripts/bottleneck.py <board.md>` is a plain-text reference implementation of this same order, used by the CI fixture check — read it if the priority above is ambiguous on a real board.

## Answer format

Keep it short:

```
Bottleneck: <the one row/blocker, plain language>
Outcome: <the single most useful thing to finish today>
Actions:
1. <owner> — <action>
2. <owner> — <action>
3. <owner> — <action>
```

Give at most three actions. If the board has nothing active, say so plainly and suggest running `onboard` (new workspace) or adding a row to `memory/TODO.md`.

## What this skill never does

- Never edits `memory/TODO.md`, a receipt, or a packet.
- Never invents an outcome or evidence that is not on the board or in a receipt.
- Never treats another agent's unproven "done" claim as evidence by itself.
