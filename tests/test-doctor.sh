#!/usr/bin/env bash
# Fixture check for doctor.sh: a workspace with the template's .claude/settings.json
# must report no FIX items (exit 0); one missing it must report a FIX and exit 1.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP=$(mktemp -d)
pass=0; fail=0
ok() { if eval "$1"; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $2"; fi; }

TMPHOME="$TMP/home"
HOME="$TMPHOME" bash "$HERE/setup.sh" "$TMP/good" --link-skills --codex >/dev/null
mkdir -p "$TMP/broken"

out_good=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/good"); rc_good=$?
ok '[ "$rc_good" -eq 0 ]' "doctor exits 0 on a workspace with hooks wired"
ok 'printf "%s" "$out_good" | grep -q "PASS  Claude Code hooks wired"' "doctor reports the wired hooks as PASS"
ok '! printf "%s" "$out_good" | grep -qE "^FIX"' "no FIX line on a good workspace"

# doctor also reports the Codex skills paths and checks all 19 skills, not just core
ok 'printf "%s" "$out_good" | grep -q "~/.claude/skills: all 19 aiwos skills linked"' "doctor checks all 19 skills in ~/.claude/skills, not just the 6 core ones"
ok 'printf "%s" "$out_good" | grep -q "~/.agents/skills (Codex, documented path): all 19 aiwos skills linked"' "doctor reports the documented Codex skills path"
ok 'printf "%s" "$out_good" | grep -q "~/.codex/skills (Codex, legacy path): all 19 aiwos skills linked"' "doctor reports the legacy Codex skills path"

out_nolink=$(HOME="$TMP/home-nolink" bash "$HERE/doctor.sh" "$TMP/good")
ok 'printf "%s" "$out_nolink" | grep -q "~/.agents/skills (Codex, documented path): not present"' "doctor warns when the Codex documented skills path does not exist at all"

out_broken=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/broken"); rc_broken=$?
ok '[ "$rc_broken" -eq 1 ]' "doctor exits 1 on a workspace with no settings.json"
ok 'printf "%s" "$out_broken" | grep -q "no .claude/settings.json"' "doctor names the missing settings file"

# never prints a secret value: gh/claude/codex lines are yes/no or found/not-found only
ok '! printf "%s" "$out_good" | grep -qiE "ghp_|gho_|sk-ant|token=|api[_-]?key="' "doctor never prints a token-shaped value"

# a missing link gets safe advice: plain --link-skills, never --force (which overwrites the user's AGENTS.md and TODO.md)
rm "$TMPHOME/.claude/skills/goal"
out_missing=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/good")
ok 'printf "%s" "$out_missing" | grep -q "missing: goal"' "doctor names the missing skill"
ok '! printf "%s" "$out_missing" | grep -qE "run setup.sh[^(]*--force"' "doctor never tells the user to run setup.sh with --force"

rm -rf "$TMP"
echo "doctor: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
