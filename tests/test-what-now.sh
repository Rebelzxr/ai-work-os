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

TMP="$(mktemp -d)"
trap 'rm -r "$TMP"' EXIT
check_board() {
  local expected="$1" label="$2"
  cat > "$TMP/board.md"
  GOT="$(python3 "$SCRIPT" "$TMP/board.md")"
  ok '[ "$GOT" = "$expected" ]' "$label (got: $GOT)"
}

check_board "Actual blocker" "ignores unblocked and completed distractors" <<'EOF'
| Outcome | Owner and state | Next action and evidence |
|---|---|---|
| Unblocked distractor | Builder · unblocked | Continue |
| Already finished | Builder · completed | I approve the old draft |
| Done distractor | DONE · previously blocked | approve |
| Actual blocker | Builder · blocked | Waiting on source |
EOF

check_board "Needs a decision" "unblocked state does not outrank approval" <<'EOF'
| Outcome | Owner and state | Next action and evidence |
|---|---|---|
| Unblocked distractor | Builder · unblocked | Continue |
| Blocked in outcome only | Builder · active | Continue |
| Historical note | Builder · active, previously blocked | Continue |
| Needs a decision | Planner · drafted | You decide the next step |
EOF

check_board "Active work" "completed rows are excluded before fallback" <<'EOF'
| Outcome | Owner and state | Next action and evidence |
|---|---|---|
| Already finished | Builder · **COMPLETED** | I approve the old draft |
| Also finished | done | approve |
| Active work | Builder · active | Continue |
EOF

check_board "NONE: no active rows" "completed-only board has no next task" <<'EOF'
| Outcome | Owner and state | Next action and evidence |
|---|---|---|
| Already finished | completed | approve |
| Also finished | Builder · done | Continue |
EOF

check_board "First blocker" "blocked ties follow board order" <<'EOF'
| Outcome | Owner and state | Next action and evidence |
|---|---|---|
| First blocker | BLOCKED · waiting | Continue |
| Second blocker | Builder · blocked | Continue |
EOF

echo "what-now: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
