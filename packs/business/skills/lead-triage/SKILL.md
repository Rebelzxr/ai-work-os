---
name: lead-triage
description: "Sort new customer enquiries (WhatsApp, website form, email, social DM) into Hot, Warm, Later and Unclear, and draft a safe reply for each. Use when a batch of new enquiries has come in and the owner wants them sorted and drafted before they reply. Never sends anything."
---

# Lead triage

## Start safely

On the first run, use only made-up examples (including any prices, policies and voice samples); label the output **practice, not for sending**. Do not ask for real customer messages yet.

Before any later real input, tell the owner to **clean locally first**, in an offline text editor, before pasting into any AI or putting files in an agent-readable folder. Remove names, IC numbers, phone numbers, bank details and addresses; also remove order IDs and details that could identify someone. Use labels such as Customer A and Area B. Keep the originals outside the AI workspace. Never ask the AI to clean raw private records after uploading them.

Use `safe-to-paste` from the default `aiwos-business` pack only as a second check of the locally cleaned text. It cannot stop an upload or undo disclosure.

Adapted from Dainer's published library guide "The Lead Triage Desk", written for a Malaysian SME owner drowning in enquiries across WhatsApp, a website form, Facebook/Instagram DMs and email.

## What this produces

For a batch of locally cleaned enquiries: each one sorted into a category, a one-line reason, and a draft reply for the categories that get one. Nothing is sent. The owner reads every draft, edits if needed, and sends it themselves.

## Before you start

- Made-up enquiries for the first run; on later runs, 10–20 locally cleaned enquiries.
- The business's price list and service area (rough is fine — point the default `aiwos-business` pack's `quote-from-message` skill at this if one exists).
- Categories, if the owner already has some. Default to Hot / Warm / Later / Unclear.

**Second check:** after local cleaning, use the default `aiwos-business` pack's `safe-to-paste` skill to review the minimum text needed for this draft.

## Steps

1. **Sort.** For each enquiry, assign one category and one reason in plain language ("asked for a date and a price" = Hot; "just browsing / no contact info yet" = Later).
2. **Draft the safe ones.** For Hot and Warm, draft a short reply using only the business's real prices and policies — never an invented number. If a fact is missing, the draft says "ask the customer for X" instead of guessing.
3. **Flag the risky ones.** A complaint, a refund request, a price objection, or anything that sounds urgent or upset goes to "Unclear" with the reason, and gets no auto-drafted reply — it goes straight to the owner.
4. **Output a table**: enquiry (sanitised) → category → reason → draft reply (or "flagged, no draft").

## Worked example

Input: "Hi, can you clean a 3-bedroom apartment this Saturday? Budget around RM150."
→ Category: Hot (date + budget given). Draft: "Hi! Let me check Saturday's availability and confirm the exact price for a 3-bedroom clean against our price list — could you also let me know if it needs a deep clean? [Owner confirms availability and price, then sends]"

Input: "You guys are scammers, my order never arrived and nobody replies!!"
→ Category: Unclear — complaint, no draft. Flag: "angry customer, missing order, needs owner reply today."

## Failure modes

- Do not invent a price, date or availability that is not in the business's own price list or notes.
- Do not draft a reply to a complaint, a refund request or anything with legal/medical/safety language — flag it instead.
- Do not merge two customers' details into one draft.

## Human approval

**This skill only produces drafts. A person reads every draft and presses send themselves — this skill never sends, messages, or replies to a customer directly.**
