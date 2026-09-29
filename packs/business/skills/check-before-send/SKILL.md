---
name: check-before-send
description: "Review an AI-drafted reply, quote or report against the business's own source files before a customer sees it: six questions, three honest labels (verified / unverified / broken), and a log entry. Use as the last step before any AI draft reaches a customer."
---

# Check before send

Adapted from Dainer's published library guide "Check the AI's answer before a customer sees it" (<https://dainer-ai.biz/library>). This is the review step that sits between any draft (from `lead-triage`, `whatsapp-reply` or `quote-from-message`) and the owner pressing send.

## The six questions

1. Does every price, date or fact in the draft actually appear in the business's own source file (price list, notes, policy)?
2. Did the draft invent anything the source file does not say?
3. Is the tone right for this customer (upset, first-time, repeat, VIP)?
4. Would sending this create a promise the business cannot keep (a date, a discount, a guarantee)?
5. Is any customer's private data (name, phone, IC, address) repeated back further than needed?
6. If something is missing or ambiguous, does the draft ask instead of guess?

## The three labels

- **Verified** — every fact checked against the source file, nothing invented, safe to send.
- **Unverified** — could not check against a source (no price list line, no policy on file) — hold and ask the owner.
- **Broken** — the draft states something the source file contradicts, or invents a promise — do not send, fix the source gap first.

## Steps

1. Open the draft next to its source file(s).
2. Answer the six questions.
3. Apply one label with a one-line reason.
4. If Unverified or Broken, say exactly what is missing or wrong and what would make it Verified.
5. Log the result (date, draft type, label, reason) so repeat mistakes turn into a written rule instead of a repeated correction.

## Worked example

Draft: "Yes, we offer a 20% loyalty discount after your 5th booking."
Source file (policies): no mention of a loyalty discount.
Label: **Broken** — invented a discount not in policy. Do not send. Either add this discount to the policy file first, or redraft without it.

## Failure modes

- Do not label something Verified because it "sounds right" — it must match a specific line in a specific source file.
- Do not skip the check because the draft came from a skill in this pack — every AI draft gets checked, regardless of source.
- A missing source file is itself a reason to label Unverified, not a reason to skip the check.

## Human approval

**This skill only labels and logs a draft. The owner still reads the final draft and presses send themselves — this skill never sends anything.**
