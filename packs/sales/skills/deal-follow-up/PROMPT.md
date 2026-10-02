# Deal follow-up queue — copy-paste edition

## What to give it

- Cleaned deal rows using labels, not names or contact details.
- Stage, call or proposal date, last action by, next due rule and opt-out status.
- The useful facts that may support one next action.
- The path to the existing `follow-up-drafts` job in the default `aiwos-marketing` pack for message wording.

## The prompt

```text
Turn these labelled deal records into a sales-side queue.

Apply the stop rule first: an explicit opt-out, no, booking elsewhere, closed-lost status or stop flag stays “stop” with no next contact action. Use “waiting” when the next move belongs to the prospect, an owner input is missing, or the supplied cadence says it is not due. Use “act” only when the next move belongs to the owner and a useful truthful reason is supplied.

Return: label | status (act / waiting / stop) | reason | one next action | due basis | source or missing input | wording handoff. For wording, point to the existing follow-up-drafts job with the approved facts; do not create a second message system. Never invent a response, price, deadline, result, proposal validity or contact detail. Begin with “Practice, not for use” for invented examples.
```

## What you get back

- An act / waiting / stop queue.
- One next action or one clear missing input per non-stop row.
- A separate opt-outs and stops list.
- A handoff for wording only when the facts support it.

## Check before you use it

Confirm that opt-outs have no next contact action, every due reason comes from the record, and the wording handoff names only approved facts. The owner checks the queue and recipient scope.

## Next job

Use `follow-up-drafts` in the default `aiwos-marketing` pack for a message draft when the queue says act and the owner has supplied something useful; use `scope-proposal` in the default `aiwos-sales` pack or `client-kickoff` in the default `aiwos-delivery` pack when the next step is commercial or delivery work.
