---
name: gbp-posts
description: "Turn short notes about real finished jobs into a batch of honest Google Business Profile posts, following Google's own post rules. Use when a business owner has a handful of real jobs done and wants posts drafted for their Google Business Profile. Never publishes anything — drafts only."
---

# Google Business Profile posts

## Start safely

On the first run, use only made-up examples (including any prices, policies and voice samples); label the output **practice, not for sending**. Do not ask for real customer messages yet.

Before any later real input, tell the owner to **clean locally first**, in an offline text editor, before pasting into any AI or putting files in an agent-readable folder. Remove names, IC numbers, phone numbers, bank details and addresses; also remove order IDs and details that could identify someone. Use labels such as Customer A and Area B. Keep the originals outside the AI workspace. Never ask the AI to clean raw private records after uploading them.

Optional dependency: `safe-to-paste` belongs to the default `aiwos-business` pack. If that pack is installed, use the skill only as a second check of the locally cleaned text. If the optional dependency is missing, manually check the cleaned text for the same identifiers before drafting; stop and ask for local cleaning if anything remains. It is not an upload barrier.

Adapted from Dainer's published library guide "A month of Google Business Profile posts from jobs you really did", written for a local service business whose Google Business Profile rarely gets updated.

## What this produces

For a handful of real, recently finished jobs: one honest Google Business Profile post draft per job, plus a short content log line for each. Nothing is invented and nothing is published — the owner reviews every draft and posts it themselves from their own Business Profile.

## Before you start

- Short notes on 2–4 recent jobs: area, the customer's problem (no names), what was done, and one detail that shows care.
- For each job, whether a photo exists and whether the owner has permission to use it (never post a photo with a face, house number or car plate without clear permission).
- Anything that must not be mentioned for a job (price, a competitor's brand, a customer's identifying detail).

**Privacy first:** remove customer names, phone numbers, addresses and plate numbers before pasting any job note here. If you installed the optional `aiwos-business` pack, use its `safe-to-paste` skill as a second check after local cleaning.

## Steps

1. **Check the note is real and specific.** Reject or ask for more if a note has no area, no problem and no action taken — a vague note makes a generic post, and generic posts are the thing this skill exists to avoid.
2. **Draft one post per job**, following Google's own rules:
   - No invented reviews, ratings, star counts or "as seen on" claims.
   - No offer, discount or price unless the owner's note explicitly gives one.
   - Never put a phone number inside the post text, even if the note gives one — use the Google Business Profile's own call button.
   - Say what the problem was, what was done, and where (area, not a home address).
3. **Flag the photo status** for each draft: "has permission" / "no photo" / "ask the customer first" — never assume permission.
4. **Add a one-line content-log entry** per post: date, job, one-line topic — so the owner can see what went out and when.
5. **Output a table**: job → draft post text → photo status → log line.

## Worked example

Note: "SS2, Petaling Jaya. Customer's aircon wasn't cooling. Found a clogged filter and low gas, cleaned and topped up. Laid a mat to protect the floor. Photo: yes, of the unit only, no faces, permission given."

→ Draft: "Aircon not cooling in SS2? We found a clogged filter and low gas on a recent job here, cleaned it and topped up — and on this job we laid a mat to protect the floor while we worked. If your unit's struggling in the heat, we're happy to take a look."
→ Photo status: has permission (unit only, no faces).
→ Log line: "2026-09 — SS2 aircon service post."

## Failure modes

- Do not add a review, a rating, a "% of customers loved this" line, or a claim the note does not support.
- Never put a phone number inside the post text, even if the note gives one — use the Google Business Profile's own call button.
- Do not include a price or discount unless the note gives one.
- Do not use a photo without an explicit "yes" on permission in the note.
- Do not name or identify the customer.

## Human approval

**This skill only produces draft posts and a log line. A person checks every draft against their own notes and publishes it themselves on their Google Business Profile — this skill never posts, publishes or connects to any Google account.**
