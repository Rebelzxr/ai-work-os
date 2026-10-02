---
name: discovery-call-planner
description: "Prepare a focused discovery-call plan from a checked business brief and supplied prospect facts: a timebox, questions about past behaviour, fit signals, disqualifiers and a clear next step. It never pretends a call is booked."
---

# Discovery call planner

This job prepares the owner to learn whether a real problem, fit and next step exist. It does not decide that a prospect is qualified from a short description alone.

## Start safely

Use an invented Malaysian business and an invented prospect on the first run. Label it **practice, not for use**. Do not ask for a private call transcript or personal contact details.

For later work, use a prospect label, public facts, the owner's business brief and the purpose of the conversation. Clean any notes locally first and keep only the minimum needed facts.

Remove names, identity numbers, phone numbers, bank details, addresses and raw private messages before any later input reaches an AI. Keep the original record outside the AI workspace and do not ask the AI to clean it after upload.

## Inputs

- `context/business-brief.md` with offer, fit rules, scope limits and working capacity, prepared by the default `aiwos-core` pack's `business-brief` skill.
- A prospect label and supplied evidence, including source and date.
- The conversation goal, planned length and any known constraints.
- Questions the owner already wants answered.

## Steps

1. State the single decision the call should inform, such as “is there a defined problem worth scoping?”
2. Set a simple timebox: opening, situation, past attempts, cost of the problem, desired result, fit check and close.
3. Write eight open questions about what happened, what was tried, what changed, what it costs, what a useful result means and who decides. Avoid questions that invite a made-up answer.
4. Add listening signals: evidence that the need is real, evidence that the offer fits and evidence that the work should stop.
5. Add disqualifiers from the brief, including missing authority, impossible timing, outside service area, missing source material or work outside scope.
6. Give three possible next steps: scope a proposal, ask for a named missing input, or close the record as not a fit. Do not assume which one happened.

## Output

Return a one-page plan with the call goal, timebox, eight questions, evidence to listen for, disqualifiers, notes fields and the three next-step choices. Include a line for the owner to record what was actually said and what remains unverified.

## Failure modes

- Do not present the call as booked, attended or successful without a supplied record.
- Do not invent a budget, authority, deadline, pain point or promised result.
- Do not turn a question into a claim about the prospect.
- Do not expand the offer to fit an out-of-scope request.

## Human approval

The owner checks the questions, fit rules and next-step choices before using the plan. A person handles the conversation and decides whether any later proposal or contact action is appropriate.
