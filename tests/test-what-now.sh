#!/usr/bin/env bash
# Fixture check for the what-now skill's bottleneck rule.
# The reference script (packs/core/skills/what-now/scripts/bottleneck.py) must name
# the one blocked row on the synthetic fixture board, not a distractor row.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$HERE/packs/core/skills/what-now/scripts/bottleneck.py"
BOARD="$HERE/tests/fixtures/what-now/board.md"
pass=0; fail=0
ok() { if eval "$1"; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $2"; fi; }

GOT="$(python3 "$SCRIPT" "$BOARD")"
ok '[ "$GOT" = "Send the signed contract to the vendor" ]' "names the one blocked row, not a distractor (got: $GOT)"
ok '[ "$GOT" != "Publish the pricing page" ]' "does not pick the first row just because it is first"
ok '[ "$GOT" != "Post the case study" ]' "does not pick an approval-needed row over a blocked row"

echo "what-now: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
