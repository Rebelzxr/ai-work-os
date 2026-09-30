---
name: safe-to-paste
description: "A second privacy review of text the owner has already cleaned locally. Start with made-up examples and explain offline cleaning before any real text is pasted into AI. This skill cannot intercept uploads or prevent disclosure."
---

# Safe to paste

## Start safely

On the first run, use only made-up examples (including any prices, policies and voice samples); label the output **practice, not for sending**. Do not ask for real customer messages yet.

Before any later real input, tell the owner to **clean locally first**, in an offline text editor, before pasting into any AI or putting files in an agent-readable folder. Remove names, IC numbers, phone numbers, bank details and addresses; also remove order IDs and details that could identify someone. Use labels such as Customer A and Area B. Keep the originals outside the AI workspace. Never ask the AI to clean raw private records after uploading them.

Adapted from Dainer's published library guide "Before you paste anything into AI: a two-minute safety check" (<https://dainer-ai.biz/library>). This is a second check after local cleaning, not an upload barrier. Text entered into this AI session has already been shared with its model provider. The pattern test checks examples only; it does not run automatically on uploads.

## Local checklist for the owner (before sharing real text)

1. **Scan for identity and financial data**: names, phone numbers, home/delivery addresses, Malaysian IC numbers (format `\d{6}-\d{2}-\d{4}`), bank account numbers, credit card numbers, passport numbers.
2. **Replace, don't delete**: swap real values for labels that keep the shape — "Customer A", "012-XXXXXXX", "Area B", "Order 1" — so the AI still has enough structure to do the job.
3. **Sort the job**:
   - **Green** — no personal data needed at all (a price-list question, a general SOP question). Share only the minimum after checking it locally.
   - **Amber** — some structure needed but identity is not (a quote, a reply draft, a schedule). Clean first, then paste the minimum.
   - **Red** — a document a customer gave in confidence (a contract, a medical or legal detail, someone else's private business data). Do not paste. Keep it outside the agent workspace; ask for a made-up example instead.
4. **Review the tool's privacy settings and terms.** Turning off training does not stop the provider receiving your prompts and files.

## Deterministic patterns this skill's test checks for

- Malaysian IC: `\d{6}-\d{2}-\d{4}` (e.g. `000000-00-0000`, shown here as an obviously-fake test value)
- Local phone: `01\d[- ]?\d{3,4}[- ]?\d{4}`
- Bank account number: a bare run of 10–16 digits not already matched as an IC or phone

A street address is part of the manual "Scan for identity and financial data" step above, but has no dedicated regex — it is not one of this skill's deterministic-test patterns.

## Second check in AI

Review only the minimum locally cleaned text. If an identifier remains, stop drafting without repeating it; ask the owner to clean the original locally and provide a smaller, cleaned version. This cannot undo an earlier disclosure, does not intercept pastes, and cannot guarantee that all identifiers are found.

## Worked example

Input: "Customer Example, IC 000000-00-0000, phone 019-0000000, wants a quote for his account 0000000000000." (fake test values, shaped like real ones)
Output: "Customer A, IC [REMOVED], phone [REMOVED], wants a quote for his account [REMOVED]." — plus a note: "Made-up demonstration only: name replaced, IC, phone and bank/account fields removed. For real records, make these edits locally before sharing anything."

## Failure modes

- Do not "helpfully" reconstruct a removed value from context.
- Do not treat a red-flagged document as safe just because the owner is in a hurry — say so and stop.
- A false negative (missed IC/phone/account number) is worse than a false positive — when unsure, flag it.

## Human approval

This skill is a check, not a send action — it has nothing to approve on its own. It reviews already-cleaned text before a later drafting step. A person still reviews and sends any final message manually.
