# dispatch: job packets in, receipts out

A durable, file-based hand-off between you and your agents, or between two agents. Chat is optional; these files are the record.

## Packet
`inbox/<lane>/<JOB_ID>.md`, one field per line:

```text
JOB_ID: SITE-PRICING-0001
LANE: site
OWNER: builder
OBJECTIVE: one sentence
INPUTS: exact paths or links
ALLOWED_WRITES: exact paths the job may change
ACCEPTANCE: what must be true, and how it is checked
EVIDENCE: what the receipt must contain
STOP_IF: conditions that end the job early
```

A packet cannot approve itself. It cannot authorise a public send, a spend or an account change. Those need the human.

## Receipt
`receipts/<JOB_ID>.receipt.md`: commands run and their results, the version or file hashes, gaps, the next action and one STATUS line. Move the packet to `inbox/<lane>/done/` only after the receipt exists.

## One writer
Before starting, check that nobody else is running the same JOB_ID. Never retry something external just because a receipt is missing. Check the destination first.
