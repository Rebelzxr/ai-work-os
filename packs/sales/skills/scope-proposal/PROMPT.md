# Scope proposal — copy-paste edition

## What to give it

- A checked business brief.
- Cleaned discovery notes using labels instead of names or contact details.
- The requested outcome and known constraints.
- The exact rate rules, units, included items, discounts and timing terms supplied by the owner.
- Any deadline, source-material dependency and correction limit that is known.

## The prompt

```text
Create a review draft for a scope-led proposal from the supplied brief, discovery notes and rate rules.

Return these parts in order: objective; deliverables with quantity and owner input; exclusions; milestones and dependencies; acceptance criteria; revision or correction limit; open questions; rate-rule calculation showing quantity × unit rate, each rule and each subtotal; payment schedule; assumptions; owner-check list.

Use only the supplied rate rules. If a required quantity or rule is missing, write “price pending owner rule” and name the exact question. Flag every out-of-scope request instead of absorbing it. Do not invent a term, price, discount, tax, currency, deadline, testimonial, review, guarantee or result. Keep the draft marked not final. Begin with “Practice, not for use” for invented examples.
```

## What you get back

- A proposal-shaped local draft with clear boundaries.
- A visible calculation for every priced line.
- Missing-term and out-of-scope flags.
- Acceptance criteria and a final owner-check list.

## Check before you use it

Recalculate every line against the supplied rate rules, check the unit and quantity, confirm that exclusions cover the extra request, and remove any claim without a dated source and permission. The owner confirms the final version before it leaves the workspace.

## Next job

Use the checked scope with `client-kickoff` in the default `aiwos-delivery` pack after the owner records acceptance, or with `deal-follow-up` in the default `aiwos-sales` pack when a decision is pending.
