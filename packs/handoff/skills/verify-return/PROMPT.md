# Copy-paste edition

## What to give it

- The original packet: `[PACKET_PATH]`
- The returned receipt: `[RECEIPT_PATH]`
- The changed workspace or artifact paths: `[ARTIFACT_PATHS]`
- The acceptance commands and their expected results: `[CHECKS]`

## The prompt

```text
Verify this returned AIW-OS job from the files, not from the builder's claim.

PACKET: [PACKET_PATH]
RECEIPT: [RECEIPT_PATH]
ARTIFACT PATHS: [ARTIFACT_PATHS]
ACCEPTANCE CHECKS: [CHECKS]

Inspect the current file list and every changed artifact. Compare the paths with ALLOWED_WRITES. Re-run each material check and read its exit code and result lines. Compare the artifact with the objective and named sources. Check the packet's STOP_IF conditions.

Return exactly:
STATUS: VERIFIED | UNVERIFIED | BROKEN
FILES CHECKED: [paths]
CHECKS RERUN: [commands and result lines]
DIFFERENCES: [none, or numbered findings]
REMAINING GATE: [none, or one gate]
NEXT ACTION: [one concrete action]
```

## What you get back

A file-and-test comparison with an honest status and a concrete next action when proof is incomplete.

## Check before you use it

- Make sure the packet and receipt refer to the same job ID.
- Confirm the file list comes from the current workspace.
- Read failures rather than treating a zero-length or missing output as success.
- Keep local acceptance separate from any live result.

## Next job

If the result is clean but important, use `cross-model-review` in the default `aiwos-handoff` pack with only the artifact, criteria and evidence.
