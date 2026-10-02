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

Use the explicit state in the "Owner and state" cell: a label at the start of the cell or after `·` in `Owner · state`. Skip rows marked `done` or `completed`, even when their old next action still asks for approval. `Unblocked` is not `blocked`, and status words in an outcome or explanatory note do not set the state. Surface any receipt mismatch separately without choosing completed work as the next task.

Pick in this order, using top-to-bottom board order to break ties. This simple rule does not calculate age or count dependencies:
1. a row explicitly marked `blocked`;
2. else a row whose "next action" needs the user specifically (a decision, an approval, a send);
3. else the first active row on the board.

`<this skill's folder>/scripts/bottleneck.py <board.md>` is a plain-text reference script of this same order, used by the CI fixture check — read it if the priority above is ambiguous on a real board.

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

Give at most three actions. If the board has nothing active, say so plainly and suggest running the core `onboard` skill from the default `aiwos-core` pack (new workspace) or adding a row to `memory/TODO.md`.

## What this skill never does

- Never edits `memory/TODO.md`, a receipt, or a packet.
- Never invents an outcome or evidence that is not on the board or in a receipt.
- Never treats another agent's unproven "done" claim as evidence by itself.
