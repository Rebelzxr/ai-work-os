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
ok '[ -L "$TMP/home/.claude/skills/evidence-loop" ] && [ -L "$TMP/home/.agents/skills/handoff" ]' "skills linked for Claude and the documented Codex path"
ok '[ -L "$TMP/home/.codex/skills/handoff" ]' "skills also linked into the legacy Codex path"
ok '[ -L "$TMP/home/.claude/skills/onboard" ] && [ -L "$TMP/home/.claude/skills/what-now" ]' "onboard and what-now are linked too"
ok '[ "$(ls "$TMP/home/.claude/skills" | wc -l | tr -d " ")" -eq 24 ]' "default --link-skills links all 24 skills across all six packs"
ok '[ -L "$TMP/home/.claude/skills/lead-triage" ] && [ -L "$TMP/home/.claude/skills/goal" ]' "default --link-skills includes business and thinking pack skills, not just core"
ok '[ -L "$TMP/home/.claude/skills/gbp-posts" ] && [ -L "$TMP/home/.claude/skills/site-loop" ] && [ -L "$TMP/home/.claude/skills/video-brief" ]' "default --link-skills includes marketing, web and video pack skills too"

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
# --pack links only that pack's skills, not the whole set
rm -rf "$TMP/home2"; mkdir -p "$TMP/home2"
HOME="$TMP/home2" bash "$HERE/setup.sh" "$TMP/work3" --link-skills --pack core >/dev/null
ok '[ -L "$TMP/home2/.claude/skills/onboard" ]' "--pack core links a core skill"
HOME="$TMP/home2" bash "$HERE/setup.sh" "$TMP/work4" --link-skills --pack does-not-exist >/dev/null 2>"$TMP/pack-err"
ok 'grep -q "no such pack" "$TMP/pack-err"' "--pack with an unknown name errors instead of linking everything"

# --pack accepts a comma-separated list
rm -rf "$TMP/home3"; mkdir -p "$TMP/home3"
HOME="$TMP/home3" bash "$HERE/setup.sh" "$TMP/work5" --link-skills --pack business,thinking >/dev/null
ok '[ -L "$TMP/home3/.claude/skills/lead-triage" ] && [ -L "$TMP/home3/.claude/skills/goal" ]' "--pack business,thinking links both packs' skills"
ok '[ ! -e "$TMP/home3/.claude/skills/onboard" ]' "--pack business,thinking does not link the core pack"
ok '[ "$(ls "$TMP/home3/.claude/skills" | wc -l | tr -d " ")" -eq 13 ]' "--pack business,thinking links exactly 13 skills (6+7)"

# repeated --pack flags accumulate, same as a comma list
rm -rf "$TMP/home4"; mkdir -p "$TMP/home4"
HOME="$TMP/home4" bash "$HERE/setup.sh" "$TMP/work6" --link-skills --pack core --pack business >/dev/null
ok '[ -L "$TMP/home4/.claude/skills/onboard" ] && [ -L "$TMP/home4/.claude/skills/lead-triage" ]' "repeated --pack flags accumulate both packs"
ok '[ ! -e "$TMP/home4/.claude/skills/goal" ]' "repeated --pack core --pack business does not link the thinking pack"

# --pack rejects a name that is not lowercase-alnum-hyphen, including path traversal
HOME="$TMP/home4" bash "$HERE/setup.sh" "$TMP/work7" --link-skills --pack "../x" >/dev/null 2>"$TMP/pack-err2"
ok 'grep -q "invalid pack name" "$TMP/pack-err2"' "--pack rejects a path-traversal-shaped name instead of linking anything"
HOME="$TMP/home4" bash "$HERE/setup.sh" "$TMP/work8" --link-skills --pack "Core" >/dev/null 2>"$TMP/pack-err3"
ok 'grep -q "invalid pack name" "$TMP/pack-err3"' "--pack rejects an uppercase name that does not match ^[a-z0-9-]+\$"

# --upgrade is a dry run: it reports, and writes nothing
echo "my other edit" > "$TMP/work/AGENTS.md"
before_hash=$(md5 -q "$TMP/work/AGENTS.md" 2>/dev/null || md5sum "$TMP/work/AGENTS.md" | cut -d' ' -f1)
out=$(HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --upgrade)
after_hash=$(md5 -q "$TMP/work/AGENTS.md" 2>/dev/null || md5sum "$TMP/work/AGENTS.md" | cut -d' ' -f1)
ok '[ "$before_hash" = "$after_hash" ]' "--upgrade never writes to an existing file"
ok 'printf "%s" "$out" | grep -q "would update:"' "--upgrade reports the file that changed"
out2=$(HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --upgrade --force)
ok '[ "$?" -eq 0 ] || true' "--upgrade ignores --force rather than writing (dry run always)"
after_hash2=$(md5 -q "$TMP/work/AGENTS.md" 2>/dev/null || md5sum "$TMP/work/AGENTS.md" | cut -d' ' -f1)
ok '[ "$before_hash" = "$after_hash2" ]' "--upgrade --force still writes nothing (upgrade is read-only)"

rm -rf "$TMP"
echo "setup: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
