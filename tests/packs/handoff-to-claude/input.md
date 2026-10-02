Invented fixture — a documentation comparison for a fictional service desk.

OBJECTIVE: Compare `docs/service-note.md` with `docs/approved-note.md` and list mismatches.
INPUTS: `docs/service-note.md`, `docs/approved-note.md`
ALLOWED_WRITES: `dispatch/receipts/NOTE-CHECK-0002.receipt.md`
ACCEPTANCE: Every mismatch names both source paths; no source file changes.
EVIDENCE: The receipt records the comparison command and result.
STOP_IF: A requested path is outside the list or a source is missing.

Bad-brief example: the original draft asked for “fix everything” but gave no acceptance criteria. It also contained PHONE: [redacted] and TOKEN: [redacted].
