---
name: quote-from-message
description: "Turn a customer's WhatsApp or email request into a draft quote built only from the business's own price list — line items, assumptions, open questions and a total to check. Use when the owner provides a locally cleaned customer request and a price list and wants a first-draft quote. Never sends the quote."
---

# Quote from message

## Start safely

On the first run, use only made-up examples (including any prices, policies and voice samples); label the output **practice, not for sending**. Do not ask for real customer messages yet.

Before any later real input, tell the owner to **clean locally first**, in an offline text editor, before pasting into any AI or putting files in an agent-readable folder. Remove names, IC numbers, phone numbers, bank details and addresses; also remove order IDs and details that could identify someone. Use labels such as Customer A and Area B. Keep the originals outside the AI workspace. Never ask the AI to clean raw private records after uploading them.

Use `safe-to-paste` from the default `aiwos-business` pack only as a second check of the locally cleaned text. It cannot stop an upload or undo disclosure.

Adapted from Dainer's published library guide "Turn a customer message into a draft quote".

## What this needs

- The customer's request (a WhatsApp message, email, or form submission).
- The business's price list in plain text: one service per line, a clear unit, what is included, what is not, and a rule for when a price "needs the owner" (custom jobs, bulk, out-of-area). A vague price list produces a vague quote — if the business hasn't put its prices in this shape yet, do that first; the published library guide covers turning a messy price list into this format.

## Steps

1. Read the request and list every service it asks for.
2. For each service, find the matching line in the price list and use that number only. If nothing matches, mark it **"not on price list — needs owner price"** instead of guessing.
3. List every detail the request leaves out (e.g. "number of bedrooms not stated", "standard or deep clean not stated"). Never fill a missing quantity with a guess; it becomes a question in step 4.
4. List the questions the owner must ask before the quote is final (missing quantity, missing date, ambiguous scope).
5. Produce a line-item table with a total, and flag the total for the owner to check in a spreadsheet before sending — this skill does arithmetic but a wrong price list entry still produces a wrong total.

## Worked example

Request: "need quote for office cleaning, twice a week, medium size office"
Price list has: "Office cleaning — per visit, per 1000 sq ft: RM120. Frequency discount: 2x/week = 10% off per visit."

Draft:
| Line | Basis | Amount |
|---|---|---|
| Office cleaning, per visit | RM120 per 1000 sq ft × (size not given — **ask before pricing**) | — |
| Frequency discount (2x/week) | −10% per visit | — |
| **Total per visit** | | **Not priced until the size is confirmed** |

Missing details: office size in square feet ("medium" is not a size).
Questions before sending: exact square footage, preferred days, access arrangement.

## Failure modes

- Never invent a price for a service missing from the price list — mark it and stop.
- Never silently pick a quantity when the message does not state one — flag it as a question for the owner, never a defaulted assumption.
- Do not let a discount or bundling rule apply itself without a matching line in the price list.
- A quote missing a quantity (e.g. "clean my house" with no bedroom count) must be flagged as a question, not defaulted into a false-confident total.

## Human approval

**This skill only produces a draft quote for the owner to check and send. It never emails, messages or submits a quote to a customer.**
