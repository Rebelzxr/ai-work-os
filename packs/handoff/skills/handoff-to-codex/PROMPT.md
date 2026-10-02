# Copy-paste edition

## What to give it

- The workspace path: `[WORKSPACE]`
- A one-sentence objective: `[OBJECTIVE]`
- Exact input paths: `[INPUTS]`
- Exact files Codex may change: `[ALLOWED_WRITES]` (include the receipt `dispatch/receipts/[JOB_ID].receipt.md` and `dispatch/receipts/[JOB_ID].codex-output.md`, which the command's `-o` flag writes)
- Acceptance checks and stop conditions: `[ACCEPTANCE]`, `[STOP_IF]`
- A cleaned brief with no secrets, tokens, customer records or direct contact details

## The prompt

```text
Create a bounded AIW-OS work order for Codex.

JOB_ID: [JOB_ID]
LANE: [LANE]
WORKSPACE: [WORKSPACE]
OBJECTIVE: [OBJECTIVE]
INPUTS: [INPUTS]
ALLOWED_WRITES: [ALLOWED_WRITES]
ACCEPTANCE: [ACCEPTANCE]
EVIDENCE: List the commands, result lines, changed paths and remaining gaps.
STOP_IF: [STOP_IF]

Use only the supplied paths and facts. Do not add permissions, invent missing acceptance criteria, or include private data in the packet. Write the packet at [WORKSPACE]/dispatch/inbox/[LANE]/[JOB_ID].md. Show this person-runnable command:

codex exec -C "[WORKSPACE]" -s workspace-write -o "[WORKSPACE]/dispatch/receipts/[JOB_ID].codex-output.md" "Read [WORKSPACE]/dispatch/inbox/[LANE]/[JOB_ID].md and follow it exactly. Write the receipt at [WORKSPACE]/dispatch/receipts/[JOB_ID].receipt.md."

Say that no Codex job was run.
```

## What you get back

A work-order path, a person-runnable command, the exact file scope, checks, stop conditions and a note that execution has not started.

## Check before you use it

- Confirm the workspace and every path exists or is intentionally new.
- Confirm acceptance is measurable and the receipt path is allowed.
- Confirm the packet contains no secret, token, phone number or customer detail.
- Confirm `dispatch/LOCKS.md` has no conflicting live lease.

## Next job

After Codex returns, use `receive-handoff` in the default `aiwos-handoff` pack for the builder side or `verify-return` from that same default pack to check the actual files and tests.
