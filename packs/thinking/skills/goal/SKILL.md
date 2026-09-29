---
name: goal
description: "Run a business goal to completion with minimal check-ins: log it, work toward it in bounded steps, and report back with at most one decision, one review item and one next action per cycle — never a task-list dump. Use when the owner sets a goal and wants the agent to run it, checking in only when a real decision is needed."
---

# Goal loop

Written for an owner who manages by goal, not by prompt: they set the outcome, the agent works toward it in bounded steps, and the owner is only interrupted for a decision only they can make.

## Set up once

Keep one goal file (e.g. `GOALS.md`) with one block per active goal:

```markdown
## <goal name> — started <date>
Outcome: <what "done" looks like, in one sentence>
State: <where it stands>
Next: <the exact next bounded step>
Owner decisions pending: <none, or the specific question>
```

## Each work cycle

1. Read the goal block. Do the next bounded step — not the whole goal at once.
2. Update the goal block: what changed, with evidence (a file, a test result, a receipt), not a feeling of progress.
3. Report back in the "manage up" format — **at most one decision, one thing to review, one next action.** Never a bullet list of everything that happened.
4. If a step needs money, an account action, a public send, or a strategy call, stop and ask — that decision is the owner's, not the loop's.

## Worked example

Goal: "Get the pricing page live with three tiers."
Cycle 1 report: "Drafted three tiers from your notes — one thing to review: does the middle tier include support calls? Next: once you confirm, I'll build the page."
Not this: a five-paragraph update covering copy options, competitor research, font choices and hosting notes all at once.

## Failure modes

- Do not let the loop run past a decision point by guessing what the owner would want on spend, pricing, or a public release.
- Do not report progress with no evidence attached — "made progress on X" is not a state update.
- Do not turn "manage up" into silence — a stalled goal with nothing reported for days is itself something to report.

## Human approval

**Any step that would spend money, publish something publicly, change an account, or commit to a price or promise stops and asks the owner first.** The loop keeps working on everything else in the meantime rather than blocking on an unrelated approval.
