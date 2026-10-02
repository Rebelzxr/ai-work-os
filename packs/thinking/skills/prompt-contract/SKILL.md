---
name: prompt-contract
description: "Before building anything non-trivial, write a short contract — goal, constraints, format, what counts as done, and what to do if blocked — so scope doesn't drift mid-build. Use before any multi-step build, feature, script or integration; skip for one-line fixes and pure lookups."
---

# Prompt contract

Clean-room skill: this is a common pattern in agent-driven development (several independent write-ups and repos describe a similar "contract before you build" step), not adapted from any single source's text.

Most rework doesn't come from bad code — it comes from an ambiguous ask that both sides silently interpreted differently. A short written contract, agreed before building starts, catches that in one pass instead of three rounds of revision.

## When to use

Any non-trivial build: a new feature, a script, a skill, a refactor, a multi-file change, an integration. Skip it for single-line fixes, config edits, and pure lookups — the contract should cost less than the rework it prevents.

## The contract

```markdown
GOAL: one sentence — the outcome, not the steps.
CONSTRAINTS: hard rules and explicit out-of-scope items (files not to touch, behavior not to change).
FORMAT: what the deliverable looks like when done (a file at a path, a passing test, a specific output shape).
DONE WHEN: a numbered, checkable list — not "it works," but "command X exits 0" or "page renders with no console error."
IF BLOCKED: what to do when a constraint conflicts with the goal — stop and ask, or make the smallest safe assumption and say so.
```

## Steps

1. Write the contract before writing code.
2. If anything in GOAL, CONSTRAINTS or DONE WHEN is genuinely unclear, that's a sign to ask one specific question rather than guess and build — see `reverse-prompt` in the optional `aiwos-thinking` pack.
3. Build against the contract. If the build reveals the contract was wrong, stop and rewrite the contract rather than silently drifting from it.
4. At the end, check DONE WHEN item by item — do not mark done from a general feeling that it's finished.

## Worked example

Vague ask: "clean up the settings page."
Contract:
- GOAL: reduce the settings page to the 6 options actually used; remove the rest.
- CONSTRAINTS: do not change the settings data schema; do not touch the billing tab.
- FORMAT: same page, same route, fewer visible controls.
- DONE WHEN: (1) page renders with 6 controls, (2) removed controls' code deleted not just hidden, (3) existing settings tests still pass.
- IF BLOCKED: if a "used" control turns out to have hidden dependents, stop and ask before removing it.

## Failure modes

- A contract that just restates the request in bullet form adds no value — it must surface the ambiguous parts.
- Do not let DONE WHEN stay vague ("looks good") — every item should be checkable by someone who wasn't in the room.
- Skipping the contract on "small" multi-file changes is the most common way scope drifts unnoticed.
