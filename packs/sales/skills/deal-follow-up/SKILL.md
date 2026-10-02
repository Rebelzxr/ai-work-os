---
name: deal-follow-up
description: "Turn labelled deal records into a sales-side queue of act, waiting or stop, with one useful next action per deal and a clear handoff to the default aiwos-marketing pack's follow-up-drafts skill for wording. Opt-outs are absolute and nothing is sent."
---

# Deal follow-up queue

This is the sales record and decision queue. It does not duplicate `follow-up-drafts` in the default `aiwos-marketing` pack, which writes the actual message wording from approved facts.

## Start safely

Use invented Malaysian businesses, invented deal labels and invented dates on the first run. Label the output **practice, not for use**. Do not ask for private contact details or raw message histories.

For later work, use cleaned deal records with labels, stage, proposal or call date, last action by, next due rule, useful facts, owner dependencies and opt-out status.

Clean the record locally first. Remove names, identity numbers, phone numbers, bank details, addresses and raw private messages; keep originals outside the AI workspace and use labels such as Deal A. The AI is a second check, not a cleaning barrier.

## Steps

1. Apply the stop rule first. Any explicit opt-out, no, booking elsewhere, closed-lost status or record marked stop is **stop** with no next contact action. An opt-out cannot be overridden by a later date.
2. Put a deal in **waiting** when the next move belongs to the prospect, a missing owner input is blocking it, or the supplied cadence says it is not due.
3. Put a deal in **act** only when a next move belongs to the owner and the record supplies a useful, truthful reason to act.
4. Give exactly one next action per act or waiting row, with the source fact and due reason. If no useful fact exists, flag the row for owner input instead of writing “just checking in”.
5. For a row that needs wording, link to the default `aiwos-marketing` pack's `follow-up-drafts` skill with the exact approved facts and the row label. Do not write a second message system here.

## Output

Return `label | status (act / waiting / stop) | reason | one next action | due basis | source or missing input | wording handoff`. Include an **opt-outs and stops** section and an **owner decisions** section. State that the queue is a draft and does not prove a message was sent.

## Failure modes

- Never create a next action for an explicit opt-out or stop record.
- Never invent a response, proposal validity, discount, deadline, result or new fact.
- Never mark a deal won, lost or advanced without a supplied record.
- Never duplicate message drafting; point the owner to `follow-up-drafts` in the default `aiwos-marketing` pack.

## Human approval

The owner checks status, timing, facts and recipient scope. A person approves every message and sends it manually; this skill never sends, schedules or contacts anyone.
