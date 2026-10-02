# Copy-paste edition

## What to give it

- The complete work order: `[WORK_ORDER]`
- The shared rules file or the relevant rules: `[RULES]`
- The exact receipt path: `[RECEIPT_PATH]`
- The allowed file list and acceptance checks from the packet

## The prompt

```text
Act as the receiving builder for this AIW-OS work order.

Read the shared rules and the work order first. Confirm that JOB_ID, objective, inputs, allowed writes, acceptance, evidence and stop conditions are present. Work only inside the allowed files. If the packet asks for a path outside that list, stop before writing it and report the path.

Run every acceptance check and record its command and result. Write a receipt at [RECEIPT_PATH] containing what changed, files touched, checks, unresolved items, next action and exactly one STATUS line.

Work order:
[WORK_ORDER]
```

## What you get back

A scoped local result and a receipt that distinguishes checked facts, failed checks and remaining gates.

## Check before you use it

- Confirm the receipt path is allowed by the packet.
- Confirm the builder has read the shared rules and lock file.
- Inspect the changed paths yourself; do not trust a short “done” reply.
- Re-run the named checks if the result matters.

## Next job

Use `verify-return` from the default `aiwos-handoff` pack on the sender side. If an independent judgement is needed, prepare `cross-model-review` from that same default pack after the result is locally checked.
