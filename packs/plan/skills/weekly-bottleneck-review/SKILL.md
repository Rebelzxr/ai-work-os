---
name: weekly-bottleneck-review
description: "Turn the board, brief and recent receipts into three capacity-fit outcomes, time blocks, a buffer and a stop list."
---

# Weekly bottleneck review

Choose a small week that fits the real hours available to one person. Read the current board, the business brief when it exists, and last week's receipts. Find the constraint that matters most, then make three outcomes fit around fixed commitments and a buffer.

## Read first

- Read the core [what-now](../../../core/skills/what-now/SKILL.md) skill in the default `aiwos-core` pack. It owns the daily bottleneck; this skill adds a weekly view and must not copy its daily selection logic.
- Read the shared `AGENTS.md` and [docs/multi-agent.md](../../../../docs/multi-agent.md) when the week includes more than one tool.
- Read `memory/TODO.md`, `context/business-brief.md` if present, and the receipts from the previous week. If a named file is absent, say so.

## Procedure

1. Separate facts from assumptions. Record the week, working hours, fixed commitments, due support, and the source for each item.
2. Identify the one bottleneck that would make the week fail if ignored. Use evidence from the board and recent receipts; do not turn a hunch into a fact.
3. Reserve fixed commitments first, then a visible buffer for interruptions. Only the remaining hours may hold planned work. If the three outcomes do not fit, reduce scope, move an outcome or put it on the stop-doing list.
4. Choose exactly three outcomes. For each, state the result, why it matters this week, the input, the first check, the owner and a time block that begins after commitments and buffer.
5. Write a stop-doing list of work that will not receive time this week. Include the reason and the condition that would bring it back.
6. Name the first daily `what-now` check for each workday, but leave the daily choice to the default `aiwos-core` pack's skill.
7. Return a capacity calculation and a review date. If hours, priorities or receipts are unclear, mark the plan `UNVERIFIED` rather than making up precision.

## Return shape

Return:

- week and sources read;
- capacity: total hours, commitments, buffer and planned hours;
- bottleneck and evidence;
- exactly three outcomes with blocks and checks;
- stop-doing list;
- missing inputs, assumptions and the first daily check;
- one STATUS line.

## Common stops

- The board or business brief is missing when it is required to judge the week.
- The proposed work exceeds the available hours after commitments and buffer.
- A receipt claims a result without a check or contains a conflicting source.
- The plan would require an account action, private record or unapproved external action.

## Human approval

This is a planning memo, not permission to send, post, publish, deploy, pay or delete. A person approves any such action and any material change to prices, commitments or strategy.

## Shared foundation

Use core [what-now](../../../core/skills/what-now/SKILL.md) and [evidence-loop](../../../core/skills/evidence-loop/SKILL.md), both in the default `aiwos-core` pack, for the daily bottleneck and claims about checked results. This skill adds capacity and weekly sequencing only; neither dependency is optional in the default setup.
