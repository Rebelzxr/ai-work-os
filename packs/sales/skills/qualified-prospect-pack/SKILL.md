---
name: qualified-prospect-pack
description: "Build a short ranked prospect pack from public sources: fit evidence, a dated public trigger and a careful first-message draft. Use for a small batch of possible buyers. Never invents contacts, scrapes against site terms or contacts anyone."
---

# Qualified prospect pack

This job helps an owner choose a few plausible prospects. It does not turn a public page into permission to contact a person.

## Start safely

On the first run, use only invented Malaysian businesses and invented source pages. Label the result **practice, not for use**. Do not ask for private lead lists, personal contact details or customer records.

For later work, use only public pages the owner supplied or inspected. Keep the source URL, page title and access date beside every claim. If a source is unavailable or its date is unclear, mark the fact unverified.

Public research is not a reason to collect private records. Keep names, personal phone numbers, private email addresses and customer details out of the input. Use a prospect label and a public business page instead.

## Inputs

- The checked `context/business-brief.md`, prepared by the default `aiwos-core` pack's `business-brief` skill.
- The fit rules: service area, business type, size signal, problem the offer solves and disqualifiers.
- A small list of public source URLs or notes, with access dates.
- The owner's approved channel and tone for a first message.

Never ask for a private spreadsheet, a scraped contact dump, a personal phone number or an inferred email address. A public source may support a business fact, but it does not prove a private contact route or consent.

## Steps

1. Check each prospect against the supplied fit rules. Show the exact fact that supports each fit point.
2. Find one current, public trigger tied to the prospect, such as a dated opening, hiring notice, new service, public request or visible problem. Record the source and access date.
3. If there is no clear trigger, mark the prospect **hold — no public trigger**. Do not rank it as ready and do not create a first message for it.
4. Rank only on supplied evidence: fit, trigger strength, source quality and recency. Do not score a missing fact as positive.
5. Draft a short, specific first message for each ready prospect. Use the public trigger, make no outcome promise and leave the owner to confirm the correct public channel.

## Output

Return a table with:

`rank | prospect label | fit evidence | dated trigger | source and access date | public channel found? | status | first-message draft or hold reason`

Add a **source gaps** section and a **not ready** section. Keep the batch small enough for the owner to inspect every row. State that all businesses in a practice fixture are invented.

## Failure modes

- Do not invent a decision-maker, job title, phone number, email, social handle, budget or need.
- Do not use a public source to infer private contact information.
- Do not bulk scrape, bypass access limits or use a source against its terms.
- Do not call a stale page a current trigger.
- Do not present a message as approved or delivered.

## Human approval

The owner checks every source, prospect, channel and draft. A person chooses the audience and manually sends any approved message; this skill never contacts a prospect or opens an account action.
