---
name: whatsapp-reply
description: "Draft a WhatsApp reply to a customer message, in Bahasa Malaysia, English, or a natural mix, using only the business's real prices and policies. Use when the owner pastes in a customer message and wants a draft reply in the customer's own language and tone. Never sends anything."
---

# WhatsApp reply

Adapted from Dainer's published library guide "Draft WhatsApp replies in BM or English" (<https://dainer-ai.biz/library>), for a Malaysian SME owner who replies to customers all day on WhatsApp Business.

## What this needs first (build once)

- **A notes file**: price list, service area, opening hours, and main policies (deposit, cancellation, warranty) in rough form.
- **A voice file**: 5 replies the owner already sent and was happy with, copied as-is — this is what makes the draft sound like the owner, not a brochure.

Without these two files this skill will guess, and a guess is worse than nothing. Ask for them before drafting if they are missing.

## Steps

1. Read the incoming customer message and detect its language (BM, English, or a mix — Manglish is normal and the reply should match it).
2. Pull only facts that exist in the notes file. If a fact is missing (a price, a slot, a policy), the draft says "confirm with the customer" or asks a question — it does not invent a number.
3. Match tone and length to the 5 voice examples, not to a generic "friendly assistant" register.
4. Output the draft reply, plus a one-line note of anything the owner should check before sending (a missing fact, an assumption made).

## Worked example

Voice examples show short, warm, mostly-BM replies with emoji used sparingly.
Customer: "boleh tak buat esok pagi punya slot? nak clean whole house"
Draft: "Boleh! Esok pagi ada slot pukul 9 atau 11. Whole house cleaning around RM150-250 ikut saiz — rumah berapa bilik ya? 😊"
Note to owner: "Confirmed slot times from notes; price range is an estimate pending bedroom count — check before sending."

## Failure modes

- Never invent a price, slot, or policy not in the notes file.
- Never promise a refund, discount, or exception the owner has not pre-approved in the notes file.
- If the message is a complaint or sounds legally sensitive, draft a short holding reply only ("thanks for letting us know, the owner will follow up shortly") and flag it — do not attempt to resolve it.
- Keep the customer's real name, phone number and address out of the draft text; use them only to address the message, not to repeat them back in full.

## Human approval

**This skill only produces a draft reply. A person reads it and presses send in WhatsApp themselves — this skill never sends or posts a message.**
