# Business brief — copy-paste edition

## What to give it

- The path to a workspace and its copied `context/business-brief.md` file.
- General facts about the business: offer, service area, working hours, rate rules, scope limits, proof sources, voice and constraints.
- No customer names, contact details, identity numbers, bank details, addresses or private messages.

## The prompt

```text
Help me fill a short business brief for a one-person or small Malaysian business.

Start by showing this clearly labelled practice example: “Invented example — Bunga Basin Repairs: a small weekday home-repair service with stated call-out rules, accepted jobs, permission-checked photos and fixed working hours.” Tell me it is invented and ask whether I want to replace it with my own general business facts.

Ask only one short question at a time. Cover: business label, country and service area, working hours, best-fit customer by situation, offer, prices or rate rules, included work, excluded work, correction limit, real proof with source and date, voice, constraints, and what the AI must never do. Never ask for customer records or private contact details. If I do not know an answer, write [owner to decide].

Fill only the supplied business-brief template inside the workspace. Keep the status as draft until I check it. Do not invent prices, sources, results, permissions or policies. If you cannot write the file, return the draft and say that no file was written.
```

## What you get back

- A filled `context/business-brief.md` or a clearly labelled draft if the chat cannot write files.
- A list of unresolved `[owner to decide]` fields.
- A short owner-check list covering prices, scope, proof and the AI boundary.

## Check before you use it

Confirm that the brief contains no private customer information, that each price has a unit or is marked undecided, that included and excluded work are separate, and that every proof item has a source and date. The owner decides before any outside action.

## Next job

Use the checked brief with `qualified-prospect-pack` in the default `aiwos-sales` pack for demand work, `discovery-call-planner` in the default `aiwos-sales` pack for a scheduled conversation, or `client-kickoff` in the default `aiwos-delivery` pack for an approved project.
