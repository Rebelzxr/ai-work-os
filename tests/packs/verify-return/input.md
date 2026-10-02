Invented fixture — a builder returned a confident message after a failed check.

PACKET: `dispatch/inbox/docs/NOTE-CHECK-0004.md`
RECEIPT: `dispatch/receipts/NOTE-CHECK-0004.receipt.md`
CLAIM: “Done; comparison passed.”
ACTUAL TEST: `python3 tests/check-note.py` exited 1 because one mismatch remains.
ALLOWED_WRITES: `docs/result.md`, `dispatch/receipts/NOTE-CHECK-0004.receipt.md`

The sender must inspect the current files, rerun the failed test and mark the return BROKEN or UNVERIFIED. The claim alone is not evidence.
