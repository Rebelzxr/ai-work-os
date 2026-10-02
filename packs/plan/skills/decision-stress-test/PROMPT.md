# Copy-paste edition

## What to give it

- The proposal: `[PROPOSAL]`
- The goal and deadline: `[GOAL_AND_DEADLINE]`
- Constraints and supplied source facts: `[CONSTRAINTS_AND_FACTS]`
- The relevant board row or recent receipt: `[BOARD_OR_RECEIPT]`
- Any stated exposure that can be checked: `[EXPOSURE]`

## The prompt

```text
Stress-test one decision using only the supplied facts.

PROPOSAL:
[PROPOSAL]

GOAL AND DEADLINE:
[GOAL_AND_DEADLINE]

CONSTRAINTS AND SOURCE FACTS:
[CONSTRAINTS_AND_FACTS]

BOARD OR RECEIPT:
[BOARD_OR_RECEIPT]

EXPOSURE:
[EXPOSURE]

Compare three options: the proposal, the smallest honest experiment, and doing nothing for now. For each, state what must be true, the first disconfirming signal, the supplied exposure, what can be undone and the unknowns. Do not invent probabilities, savings, growth, urgency or guaranteed results. Choose one reversible next step with an owner, boundary, acceptance check and stop condition.

Return exactly:
DECISION: [one sentence]
SOURCE FACTS: [list]
PROPOSAL: [what must be true; downside; reversible parts]
SMALLER EXPERIMENT: [what must be true; check; stop condition]
DO NOTHING: [what it protects; what signal would reopen it]
UNKNOWN OR CONFLICTING: [list]
REVERSIBLE NEXT STEP: [owner, input, boundary, check, stop condition]
REVIEW TRIGGER: [signal and date]
STATUS: VERIFIED | UNVERIFIED | BROKEN
```

## What you get back

A three-option memo that exposes assumptions and ends with one reversible test rather than a made-up certainty.

## Check before you use it

- Confirm the proposal and source facts are specific enough to compare.
- Check that the experiment is smaller than the proposal and can be undone.
- Remove any precision that is not supported by a source.
- Keep the decision separate from permission to act.

## Next job

Point the reversible next step to `what-now` in the default `aiwos-core` pack for daily scheduling, then verify its result with `evidence-loop` from that same default pack.
