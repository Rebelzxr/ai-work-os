# Dispatch locks

Keep one short lease line for each active writer. Check this file before taking a packet or editing shared files. Remove an expired line only after checking that its owner is no longer working.

Format:

`LANE | OWNER | FILES | since=YYYY-MM-DDTHH:MMZ | expires=YYYY-MM-DDTHH:MMZ`

Example only — replace this line with a real lease before work starts:

`example | builder | src/example.md | since=2026-10-02T09:00Z | expires=2026-10-02T10:00Z`
