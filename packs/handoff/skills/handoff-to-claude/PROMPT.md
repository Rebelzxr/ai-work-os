# Copy-paste edition

## What to give it

- The workspace path: `[WORKSPACE]`
- The objective: `[OBJECTIVE]`
- Exact input paths and allowed write paths: `[INPUTS]`, `[ALLOWED_WRITES]`
- Acceptance checks, evidence required and stop conditions
- A cleaned brief with no secrets, tokens, customer records or direct contact details

## The prompt

```text
Create a bounded AIW-OS work order for Claude Code.

JOB_ID: [JOB_ID]
LANE: [LANE]
WORKSPACE: [WORKSPACE]
OBJECTIVE: [OBJECTIVE]
INPUTS: [INPUTS]
ALLOWED_WRITES: [ALLOWED_WRITES]
ACCEPTANCE: [ACCEPTANCE]
EVIDENCE: [EVIDENCE]
STOP_IF: [STOP_IF]

Use only the supplied facts and paths. If a required field is missing, stop and name it. Write the packet at [WORKSPACE]/dispatch/inbox/[LANE]/[JOB_ID].md. Show this command for a person to run:

(cd "[WORKSPACE]" && claude -p "Read dispatch/inbox/[LANE]/[JOB_ID].md. Follow its allowed writes and stop conditions. Write the receipt at dispatch/receipts/[JOB_ID].receipt.md.")

Also give a fresh-session instruction for opening Claude Code at [WORKSPACE]. Say that no Claude job was run.
```

## What you get back

A packet path, a `claude -p` command, a fresh-session instruction, the allowed files, acceptance checks and stop conditions.

## Check before you use it

- Confirm every path is exact and inside the workspace.
- Confirm the receipt path is included in the allowed writes.
- Confirm the packet has a real acceptance check, not a general hope.
- Confirm no private data, token or direct contact detail appears in the packet or command.
- Confirm there is no conflicting lease in `dispatch/LOCKS.md`.

## Next job

Use `receive-handoff` in the default `aiwos-handoff` pack when acting as the builder, then `verify-return` from that same default pack on the sender side.
