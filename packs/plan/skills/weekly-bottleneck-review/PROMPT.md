# Copy-paste edition

## What to give it

- The current board: `[BOARD]`
- The business brief, if one exists: `[BUSINESS_BRIEF]`
- Last week's receipts: `[RECEIPTS]`
- Working hours, fixed commitments and a buffer rule: `[CAPACITY]`
- Any deadline or protected time: `[LIMITS]`

## The prompt

```text
Review one person's coming week from the supplied files.

Read the board [BOARD], the business brief [BUSINESS_BRIEF] if present, and last week's receipts [RECEIPTS]. Use only supplied facts. State missing files and assumptions.

Capacity and commitments: [CAPACITY]
Protected time and deadlines: [LIMITS]

Find the main bottleneck. Reserve fixed commitments first, then a visible buffer. Choose exactly three outcomes that fit in the remaining hours. For each, give the result, source input, time block, first check and owner. Add a stop-doing list with a reason and return condition. Do not copy a daily task selector; point daily checks to the existing what-now job.

Return exactly:
WEEK AND SOURCES: [short list]
CAPACITY: [total, commitments, buffer, planned hours]
BOTTLENECK: [one bottleneck and evidence]
OUTCOME 1: [result, block, input, check, owner]
OUTCOME 2: [result, block, input, check, owner]
OUTCOME 3: [result, block, input, check, owner]
STOP DOING: [list]
ASSUMPTIONS OR MISSING: [list]
FIRST DAILY CHECK: [what-now handoff]
STATUS: VERIFIED | UNVERIFIED | BROKEN
```

## What you get back

A three-outcome weekly memo that shows its capacity calculation, buffer, bottleneck, stop list and evidence gaps.

## Check before you use it

- Confirm fixed commitments were counted before planned work.
- Confirm the three blocks fit after the buffer.
- Check each outcome against a current board row or receipt.
- Treat a plan with more work than hours as `UNVERIFIED` until scope changes.

## Next job

Use `what-now` in the default `aiwos-core` pack for the first daily choice, then use the relevant job in the default `aiwos-delivery` or `aiwos-handoff` pack for the selected outcome.
