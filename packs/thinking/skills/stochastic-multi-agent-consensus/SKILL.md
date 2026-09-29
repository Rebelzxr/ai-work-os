---
name: stochastic-multi-agent-consensus
description: "Run the same open-ended question past several independently-framed agents, then look at what most of them agree on (consensus), what a few disagree about (divergence) and what only one surfaced (an outlier worth a second look). Use for high-stakes decisions, option ranking or strategic calls where a single pass risks one agent's blind spot or hallucination."
---

# Stochastic multi-agent consensus

Clean-room skill, written independently. The general technique — polling several agents on the same question and looking at where they agree — is a known pattern with more than one public version (for example, similarly-named skills exist under MIT-style licences elsewhere); no text from any of those was copied here, and none should be treated as this skill's origin without checking that project's own licence directly.

## When to use

A decision that's expensive to get wrong and has no single obviously-correct answer: ranking strategic options, scoring a risky plan, or any call where one agent's confident-but-wrong take could go unchecked. Not for questions with a checkable right answer — run a test or a lookup instead.

## Steps

1. Write one clear prompt for the question — the same substance for every agent, but framed slightly differently each time (a different persona, a different order of considerations) so they aren't just repeating each other's reasoning.
2. Run it independently N times (5–10 is usually enough; more for higher stakes). Each run must not see the others' answers.
3. Collect all answers and sort into:
   - **Consensus** — what most agents landed on, independently. This is the most trustworthy part — agreement that emerged without coordination is the best available signal against any single hallucination.
   - **Divergence** — where agents split into a few distinct camps. Worth naming both camps and why, not just picking the majority.
   - **Outliers** — an answer only one agent gave. Usually noise, but occasionally the one idea nobody else considered — flag it for a human look rather than discarding it silently.
4. Report the consensus as the recommendation, the divergence as the real open question, and the outlier as a footnote worth five seconds of attention.

## Worked example

Question: "Should we raise prices 15% or add a new tier instead?"
6 of 10 independent runs recommend a new tier over a flat raise (consensus). 3 runs split between "raise now" and "wait a quarter" (divergence, worth naming). 1 run suggests bundling instead of either (outlier, flagged for a look).

## Failure modes

- Do not run all N with identical framing — that measures the model's default answer repeated, not independent judgment.
- Do not silently drop the outlier — record it even when the consensus is reported as the answer.
- This does not replace a real test or measurement when one is available; it's for judgment calls, not fact-checkable claims.

## Human approval

This skill produces a recommendation and its dissent, not a decision. A pricing, strategy or spend call from the consensus still goes to the person who owns that decision.
