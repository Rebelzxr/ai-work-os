---
name: decision-stress-test
description: "Compare a proposal, a smaller experiment and doing nothing, then name what must be true and one reversible next step."
---

# Decision stress test

Pressure-test one material choice without pretending the evidence is stronger than it is. Compare the stated proposal with a smaller experiment and doing nothing. Surface what must be true, the cost of being wrong and one reversible next step.

## Read first

- Read the core [what-now](../../../core/skills/what-now/SKILL.md) skill in the default `aiwos-core` pack for the daily next action; do not repeat its board-selection routine.
- Read the shared `AGENTS.md` and [docs/multi-agent.md](../../../../docs/multi-agent.md) when the decision crosses tools.
- Read the proposal, relevant board row, business brief if present and the latest evidence named by the owner.

## Procedure

1. Restate the decision in one sentence and name the deadline, owner, constraints and source facts.
2. Set out three options: the proposal as written, the smallest honest experiment that could change the choice, and do nothing for now.
3. For each option, list the expected useful result, what must be true, the earliest disconfirming signal, time or money exposure if supplied, and what can be undone.
4. Separate known facts, assumptions, unknowns and values. Do not manufacture probabilities, savings, growth, urgency or confidence scores.
5. Choose a reversible next step that tests the most important unknown. Give its owner, input, boundary, acceptance check and stop condition.
6. State what would make the choice change and when to review it. If no option has enough evidence, recommend waiting or a smaller test rather than dressing up a guess.
7. Point the chosen next step to the default `aiwos-core` pack's `what-now` skill for daily scheduling without copying that skill's logic.

## Return shape

Return:

- decision and source facts;
- a three-option comparison;
- what must be true for each option;
- downside, reversibility and unknowns;
- one reversible next step with a check and stop condition;
- review trigger and date;
- one STATUS line.

## Common stops

- The proposal is not stated clearly enough to compare.
- The decision depends on private data or a source that was not supplied.
- The requested answer asks for fake precision or a guaranteed result.
- The next step is one-way, external or outside the person's authority.

## Human approval

This memo does not approve a send, post, publish, deploy, pay or delete action. A person decides whether to take the next step and keeps control of pricing, accounts, commitments and shared data.

## Shared foundation

Use core [what-now](../../../core/skills/what-now/SKILL.md) and [evidence-loop](../../../core/skills/evidence-loop/SKILL.md), both in the default `aiwos-core` pack, for the resulting daily action and proof. This skill adds the three-option stress test only; neither dependency is optional in the default setup.
