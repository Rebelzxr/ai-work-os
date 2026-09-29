---
name: job-packet
description: "Turn a request into a bounded job packet another agent can run without the chat history, and set up its receipt. Use when handing work from a planner agent to a builder agent (for example Claude to Codex), or when the user says \"send to builder\" or \"dispatch\"."
---

# Job packet

A packet gives the builder everything it needs and nothing it does not: the goal, the exact files, what "done" means and when to stop.

## Before writing

- Check the board and `dispatch/inbox/` for an existing packet with the same goal. Never start a second writer on the same files.
- Confirm the request actually authorises this work. A packet cannot approve itself, and it can never authorise a send, a spend, a deploy or an account change.

## Write `dispatch/inbox/<lane>/<JOB_ID>.md`

`JOB_ID` is short and unique: `<LANE>-<TOPIC>-<number or date>`, for example `SITE-PRICING-0001`.

```text
JOB_ID:
LANE:
OWNER: builder
OBJECTIVE: one sentence, the outcome not the steps
INPUTS: exact paths, links or data the job may read
ALLOWED_WRITES: exact paths the job may change (nothing else)
ACCEPTANCE: checks that must pass, and how to run them
EVIDENCE: what the receipt must contain (commands, results, screenshots, hashes)
STOP_IF: conditions that end the job early and report back
```

## Good packets

- Name files, not areas ("src/app/page.tsx", not "the homepage").
- Make acceptance checkable by someone else ("tsc exit 0; renders at 375px with no horizontal scroll").
- Say what is out of scope.
- Keep private data out. Point at files the builder is allowed to read.

## After it runs

The builder writes `dispatch/receipts/<JOB_ID>.receipt.md`. Read the actual files and outputs yourself before you tell anyone it is done (see the `evidence-loop` skill). Then move the packet to `inbox/<lane>/done/` and update the board row.
