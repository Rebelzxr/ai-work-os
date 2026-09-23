#!/usr/bin/env bash
# Tests for setup.sh and install-skills.sh. Uses a throwaway HOME so your real skills are untouched.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP=$(mktemp -d); pass=0; fail=0
ok() { if eval "$1"; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $2"; fi; }

HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --link-skills --codex >/dev/null
ok '[ -f "$TMP/work/AGENTS.md" ] && [ -f "$TMP/work/CLAUDE.md" ] && [ -f "$TMP/work/memory/TODO.md" ]' "template files copied"
ok '[ -f "$TMP/work/.claude/settings.json" ]' "hook settings copied"
ok '[ -x "$TMP/work/scripts/hooks/block-dangerous.sh" ]' "hooks executable"
ok '[ -L "$TMP/home/.claude/skills/evidence-loop" ] && [ -L "$TMP/home/.codex/skills/handoff" ]' "skills linked for Claude and Codex"

echo "my edit" > "$TMP/work/AGENTS.md"
HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" >/dev/null
ok 'grep -q "my edit" "$TMP/work/AGENTS.md"' "second run keeps existing files"
HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --force >/dev/null
ok '! grep -q "my edit" "$TMP/work/AGENTS.md"' "--force overwrites"

for f in "$HERE"/skills/*/SKILL.md; do
  ok 'python3 "$HERE/tests/check-frontmatter.py" "$f"' "frontmatter parses in $f"
done

list=$(bash "$HERE/install-skills.sh"); one=$(bash "$HERE/install-skills.sh" gstack)
ok 'printf "%s" "$list" | grep -q "superpowers"' "install-skills lists skills"
ok 'printf "%s" "$one" | grep -q "Add --run"' "install-skills does not run without --run"


# --force keeps a user's own skill folder: moved to skills-backup, never deleted
rm -rf "$TMP/home/.claude/skills/handoff"; mkdir -p "$TMP/home/.claude/skills/handoff"; echo mine > "$TMP/home/.claude/skills/handoff/SKILL.md"
HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/extra" --link-skills --force >/dev/null
ok 'ls "$TMP"/home/.claude/skills-backup/handoff-*/SKILL.md >/dev/null 2>&1 && [ -L "$TMP/home/.claude/skills/handoff" ]' "--force backs up an existing skill folder"
ok '! ls -d "$TMP"/home/.claude/skills/*.bak* >/dev/null 2>&1' "no backup copies left inside the skills folder"
rm -rf "$TMP"
echo "setup: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
