---
name: safe-to-paste
description: "A two-minute privacy check before anything goes into an AI chat tool: what to remove, a green/amber/red sort of the job, and the deterministic patterns to catch (Malaysian IC numbers, phone numbers, bank account numbers). Use before pasting any customer text, document or transcript into any AI tool."
---

# Safe to paste

Adapted from Dainer's published library guide "Before you paste anything into AI: a two-minute safety check" (<https://dainer-ai.biz/library>). This is the privacy gate every other skill in this pack assumes has already run.

## The check (about two minutes)

1. **Scan for identity and financial data**: names, phone numbers, home/delivery addresses, Malaysian IC numbers (format `\d{6}-\d{2}-\d{4}`), bank account numbers, credit card numbers, passport numbers.
2. **Replace, don't delete**: swap real values for labels that keep the shape — "Customer A", "012-XXXXXXX", "Area B", "Order 1" — so the AI still has enough structure to do the job.
3. **Sort the job**:
   - **Green** — no personal data needed at all (a price-list question, a general SOP question). Paste as-is.
   - **Amber** — some structure needed but identity is not (a quote, a reply draft, a schedule). Clean first, then paste the minimum.
   - **Red** — a document a customer gave in confidence (a contract, a medical or legal detail, someone else's private business data). Do not paste, or get explicit consent first.
4. **Check the tool's own privacy setting** (e.g. "improve the model" / training toggle) is off if the business handles sensitive categories often.

## Deterministic patterns this skill's test checks for

- Malaysian IC: `\d{6}-\d{2}-\d{4}` (e.g. `000000-00-0000`, shown here as an obviously-fake test value)
- Local phone: `01\d[- ]?\d{3,4}[- ]?\d{4}`
- Bank account number: a bare run of 10–16 digits not already matched as an IC or phone

A street address is part of the manual "Scan for identity and financial data" step above, but has no dedicated regex — it is not one of this skill's deterministic-test patterns.

If any of these appear in text about to be pasted, this skill blocks and asks for the value to be replaced with a label before continuing.

## Worked example

Input: "Customer Ahmad, IC 000000-00-0000, phone 019-0000000, wants a quote for his account 0000000000000." (fake test values, shaped like real ones)
Output: "Customer A, IC [REMOVED], phone [REMOVED], wants a quote for his account [REMOVED]." — plus a note: "3 sensitive values removed: 1 IC, 1 phone, 1 bank/account number. Confirm before proceeding."

## Failure modes

- Do not "helpfully" reconstruct a removed value from context.
- Do not treat a red-flagged document as safe just because the owner is in a hurry — say so and stop.
- A false negative (missed IC/phone/account number) is worse than a false positive — when unsure, flag it.

## Human approval

This skill is a check, not a send action — it has nothing to approve on its own. It exists so that a later drafting or sending step is working from already-cleaned text.
