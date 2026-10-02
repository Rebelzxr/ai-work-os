---
name: whatsapp-reply
description: "Draft a WhatsApp reply to a customer message, in Bahasa Malaysia, English, or a natural mix, using only the business's real prices and policies. Use when the owner provides a locally cleaned customer message and wants a draft reply in the customer's own language and tone. Never sends anything."
---

# WhatsApp reply

## Start safely

On the first run, use only made-up examples (including any prices, policies and voice samples); label the output **practice, not for sending**. Do not ask for real customer messages yet.

Before any later real input, tell the owner to **clean locally first**, in an offline text editor, before pasting into any AI or putting files in an agent-readable folder. Remove names, IC numbers, phone numbers, bank details and addresses; also remove order IDs and details that could identify someone. Use labels such as Customer A and Area B. Keep the originals outside the AI workspace. Never ask the AI to clean raw private records after uploading them.

Use `safe-to-paste` from the default `aiwos-business` pack only as a second check of the locally cleaned text. It cannot stop an upload or undo disclosure.

Adapted from Dainer's published library guide "Draft WhatsApp replies in BM or English", for a Malaysian SME owner who replies to customers all day on WhatsApp Business.

## What this needs first (build once)

- **A notes file**: price list, service area, opening hours, and main policies (deposit, cancellation, warranty) in rough form.
- **A voice file**: 5 replies the owner already sent and was happy with, cleaned locally before sharing — this is what makes the draft sound like the owner, not a brochure.

For practice, use made-up notes and voice examples. For real drafts, ask for locally cleaned files if missing; do not guess prices or policies.

## Steps

1. Read the incoming customer message and detect its language (BM, English, or a mix — Manglish is normal and the reply should match it).
2. Pull only facts that exist in the notes file. If a fact is missing (a price, a slot, a policy), the draft says "confirm with the customer" or asks a question — it does not invent a number.
3. Match tone and length to the 5 voice examples, not to a generic "friendly assistant" register.
4. Output the draft reply, plus a one-line note of anything the owner should check before sending (a missing fact, an assumption made).

## Worked example

Made-up notes for this practice: tomorrow has 9am and 11am slots; whole-house cleaning costs RM150–250 depending on bedroom count. Made-up voice examples show short, warm, mostly-BM replies with emoji used sparingly.
Customer: "boleh tak buat esok pagi punya slot? nak clean whole house"
Draft: "Boleh! Esok pagi ada slot pukul 9 atau 11. Whole house cleaning around RM150-250 ikut saiz — rumah berapa bilik ya? 😊"
Note to owner: "Confirmed slot times from notes; price range is an estimate pending bedroom count — check before sending."

## Failure modes

- Never invent a price, slot, or policy not in the notes file.
- Never promise a refund, discount, or exception the owner has not pre-approved in the notes file.
- If the message is a complaint or sounds legally sensitive, draft a short holding reply only ("thanks for letting us know, the owner will follow up shortly") and flag it — do not attempt to resolve it.
- Keep real names, phone numbers and addresses outside the AI input and draft. The owner adds any needed recipient details locally when sending manually.

## Human approval

**This skill only produces a draft reply. A person reads it and presses send in WhatsApp themselves — this skill never sends or posts a message.**
