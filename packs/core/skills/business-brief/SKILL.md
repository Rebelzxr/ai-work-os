---
name: business-brief
description: "Run a short, one-question-at-a-time interview that fills a small business brief with the offer, prices, scope, proof, voice and working limits an AI job needs. Start with a made-up example, never ask for customer data, and write only inside the workspace."
---

# Business brief

The brief is the shared source for later jobs. It describes the business without storing customer records.

## First run

Start with a clearly labelled invented example before asking about the owner's business:

> **Invented example — Bunga Basin Repairs:** a small Malaysian home-repair service serving one local area on weekdays. It lists fixed call-out rules, names the jobs it accepts, keeps before-and-after photos with permission, and stops at the owner's working hours.

Say that this example is practice, not an instruction to copy. Ask whether the owner wants to replace it with their own general business facts. Do not ask for customer names, phone numbers, identity numbers, bank details, addresses or private messages.

## Interview rules

1. Ask one short question at a time and wait for the answer before asking the next.
2. Use plain language. If the owner does not know an answer, write `[owner to decide]` rather than guessing.
3. Cover the business label, area, working hours, best-fit customer, offer, prices or rate rules, included work, excluded work, proof with source and date, voice, constraints and the AI boundary.
4. Keep examples and facts separate. Mark every practice fact as invented and every real fact as supplied by the owner.
5. Never request raw customer records. If the owner offers one, ask them to remove identifying details locally and continue with a general description.

## Write safely

- Use the copied workspace template at `context/business-brief.md` as the shape.
- Write only `context/business-brief.md` inside the current workspace, after the owner has checked the completed draft.
- Do not write to a home folder, a parent folder, a shared drive or an account.
- If the workspace path or copied template is unavailable, return the draft in the chat and state that no file was written.
- Keep the file marked `draft` until the owner checks prices, scope and proof.

## What to return

Return the path written, the fields still marked `[owner to decide]`, and a short list of facts the owner checked. If no file was written, say so plainly. Never call the brief complete while required prices, scope limits or proof sources are missing.

## Failure modes

- Do not turn the invented example into a claim about the owner's business.
- Do not fill a missing price, policy, result, source or permission from general knowledge.
- Do not store customer data or private contact details in the brief.
- Do not perform any outside action because the brief is complete.

## Human approval

The owner checks the brief, especially prices, scope, proof and the AI boundary. This skill writes a local draft only; a person remains responsible for any message, public action, account change, purchase or deletion.
