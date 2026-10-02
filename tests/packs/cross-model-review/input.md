Invented fixture — a different model reviews a small report without editing it.

ARTIFACT: `reports/invented-weekly-note.md`
CRITERIA: It has exactly three outcomes, each tied to a supplied source and a check.
EVIDENCE: `python3 tests/check-report.py` exited 0; the source list is attached.
LIMIT: The producer's chat history is not part of the review packet.

The reviewer must return PASS or FIX with reasons tied to the criteria. It must flag any outcome that has no source even if the producer says “done”.
