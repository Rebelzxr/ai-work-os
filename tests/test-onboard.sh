#!/usr/bin/env bash
# Fixture check for the onboard skill's "workspace only" refusal rule.
# The guard script must allow a write inside the workspace and refuse one
# outside it (parent folder, another path, an escape via '..').
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$HERE/packs/core/skills/onboard/scripts/guard_workspace.py"
TMP=$(mktemp -d)
mkdir -p "$TMP/ws"
pass=0; fail=0
ok() { if eval "$1"; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $2"; fi; }

python3 "$SCRIPT" "$TMP/ws" "$TMP/ws/AGENTS.md" >/dev/null 2>&1
ok '[ $? -eq 0 ]' "allows a write inside the workspace"

python3 "$SCRIPT" "$TMP/ws" "$TMP/outside.md" >/dev/null 2>&1
ok '[ $? -eq 1 ]' "refuses a write to the workspace's parent"

python3 "$SCRIPT" "$TMP/ws" "$TMP/ws/../../etc/hosts" >/dev/null 2>&1
ok '[ $? -eq 1 ]' "refuses a write that escapes via .."

python3 "$SCRIPT" "$TMP/ws" "$HOME/.zshrc" >/dev/null 2>&1
ok '[ $? -eq 1 ]' "refuses a write to an unrelated home-directory file"

out=$(python3 "$SCRIPT" --check-workspace "$TMP/ws"); rc=$?
ok '[ "$rc" -eq 1 ] && printf "%s" "$out" | grep -q "./setup.sh ~/my-work --link-skills"' "missing workspace gives a complete setup route"
touch "$TMP/ws/AGENTS.md"
python3 "$SCRIPT" --check-workspace "$TMP/ws" >/dev/null; rc=$?
ok '[ "$rc" -eq 1 ]' "missing TODO still needs setup"
mkdir -p "$TMP/ws/memory"
touch "$TMP/ws/memory/TODO.md"
python3 "$SCRIPT" --check-workspace "$TMP/ws" >/dev/null; rc=$?
ok '[ "$rc" -eq 0 ]' "complete workspace is ready"
rm "$TMP/ws/memory/TODO.md"
ln -s "$TMP/missing-board" "$TMP/ws/memory/TODO.md"
python3 "$SCRIPT" --check-workspace "$TMP/ws" >/dev/null; rc=$?
ok '[ "$rc" -eq 1 ]' "dangling board link is missing"

rm -rf "$TMP"
echo "onboard: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
