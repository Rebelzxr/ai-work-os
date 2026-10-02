---
name: follow-up-drafts
description: "Check a list of sent quotes for who is due a follow-up, who must stop, and draft one useful follow-up message per customer who is due. Use when an owner has sent quotes on WhatsApp or email and wants to follow up without chasing people who already said no. Never sends anything."
---

# Follow-up drafts with stop rules

## Start safely

On the first run, use only made-up examples (including any prices, policies and voice samples); label the output **practice, not for sending**. Do not ask for real customer messages yet.

Before any later real input, tell the owner to **clean locally first**, in an offline text editor, before pasting into any AI or putting files in an agent-readable folder. Remove names, IC numbers, phone numbers, bank details and addresses; also remove order IDs and details that could identify someone. Use labels such as Customer A and Area B. Keep the originals outside the AI workspace. Never ask the AI to clean raw private records after uploading them.

Optional dependency: `safe-to-paste` belongs to the default `aiwos-business` pack. If that pack is installed, use the skill only as a second check of the locally cleaned text. If the optional dependency is missing, manually check the cleaned text for the same identifiers before drafting; stop and ask for local cleaning if anything remains. It is not an upload barrier.

Adapted from Dainer's published library guide "Follow-ups that stop when they should", written for businesses that send quotes and lose track of who to follow up with.

## What this produces

From a list of open quotes: who is due a follow-up today, who must stop (an explicit "no", a booking elsewhere, or too many follow-ups already), and one draft follow-up message for each customer who is due — each one carrying something new or useful, never a bare "any update?". Nothing is sent. The owner sends every message themselves.

## Before you start

- A list of open quotes: label (never a real name), date quoted, last contact date, last contact by (us/customer), status, notes.
- The owner's stop rules, if they have any beyond the defaults below.
- A short bank of useful things to share: a finished-job photo they have permission to use, a care tip, an answer to a common question.

**Privacy first:** use labels like "Customer A" in the list you paste in, never real names, phone numbers or amounts that identify a person — keep those in the owner's own sheet.

## Steps

1. **Apply the stop rules first.**
   - **Always stop, no exceptions** (the owner cannot override these): the customer said no, said they booked elsewhere, or asked not to be contacted again; or their status is already "Won" or "Lost".
   - **Default stop the owner may change:** the quote has already had two follow-ups with no reply. The owner can set a different number of attempts or a different schedule, never a way around a "no".
2. **Sort what's left into due / not yet due**, based on the owner's follow-up plan. Default schedule, measured from the quote date (not from the date of the last follow-up):
   - **First follow-up:** due about a week (7+ days) after quoting, if none has gone out yet.
   - **Second and final follow-up:** due about two weeks (14+ days) after quoting, if exactly one follow-up has already gone out with no reply.
   - **Stop** once two follow-ups have gone out with no reply, regardless of how long it has been.
3. **Draft one message per customer who is due**, each one carrying something new from the supplied facts: a useful tip, a photo offer, an answer to something they asked, or a gentle deadline if the owner gave one — never a bare "just checking in". If no useful detail is supplied, ask the owner for one or leave a clearly marked [placeholder] for them to fill before sending.
4. **Output a table**: label → status (due / stop / not yet) → reason → draft message (or "no draft — stopped").

## Worked example

Row: "Customer B | quoted 16 days ago | no reply since | status: Followed up once"
→ Status: due (past the two-week mark for a second follow-up, only one follow-up so far).
→ Draft for owner to complete: "Hi! Following up on the quote we sent: [owner: add one confirmed useful tip or answer relevant to this quote]. Is there anything you'd like clarified?"
→ Owner check: no useful detail or quote-validity terms were supplied. Fill the placeholder before sending; do not claim a recent similar job or say the quote still stands without confirmation.

Row: "Customer C | said 'we went with someone else, thanks'"
→ Status: stop. Reason: explicit no. No draft.

## Failure modes

- Do not draft a follow-up for anyone flagged stop, regardless of how long it has been.
- Do not invent a new price, discount or deadline that the owner did not give.
- Do not invent completed jobs, photo details, quote validity or other supporting claims. Ask the owner or leave a [placeholder] when the input is missing the detail.
- Do not send the same message twice — check "last contact by" so a follow-up isn't drafted for someone who already replied and is waiting on the owner.

## Human approval

**This skill only produces draft messages and a due/stop table. A person reads every draft and sends it themselves, one customer at a time — this skill never sends a message.**
