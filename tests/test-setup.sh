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
ok '[ -L "$TMP/work/.claude/skills/evidence-loop" ] && [ -L "$TMP/work/.agents/skills/handoff" ]' "skills linked for Claude and the documented Codex path"
ok '[ ! -e "$TMP/home/.claude" ] && [ ! -e "$TMP/home/.agents" ] && [ ! -e "$TMP/home/.codex" ]' "setup leaves user-level skills untouched"
ok '[ -L "$TMP/work/.claude/skills/onboard" ] && [ -L "$TMP/work/.claude/skills/what-now" ]' "onboard and what-now are linked too"
ok '[ "$(ls "$TMP/work/.claude/skills" | wc -l | tr -d " ")" -eq 17 ]' "default --link-skills links 17 skills across the five default packs"
ok '[ -L "$TMP/work/.claude/skills/lead-triage" ] && [ ! -e "$TMP/work/.claude/skills/goal" ]' "default --link-skills includes business but leaves thinking optional"
ok '[ -L "$TMP/work/.claude/skills/gbp-posts" ] && [ -L "$TMP/work/.claude/skills/site-loop" ] && [ -L "$TMP/work/.claude/skills/video-brief" ]' "default --link-skills includes marketing, web and video pack skills too"

echo "my edit" > "$TMP/work/AGENTS.md"
HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" >/dev/null
ok 'grep -q "my edit" "$TMP/work/AGENTS.md"' "second run keeps existing files"
echo "my active jobs" > "$TMP/work/memory/TODO.md"
force_out=$(HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --force)
ok 'grep -q "my edit" "$TMP"/work/.aiwos-backups/*/template/AGENTS.md' "--force backs up filled-in AGENTS.md"
ok 'grep -q "my active jobs" "$TMP"/work/.aiwos-backups/*/template/memory/TODO.md' "--force backs up filled-in TODO.md"
ok 'printf "%s" "$force_out" | grep -q "backed up:.*memory/TODO.md"' "--force prints its backup list"
ok '! grep -q "my edit" "$TMP/work/AGENTS.md"' "--force overwrites"

for f in "$HERE"/skills/*/SKILL.md; do
  ok 'python3 "$HERE/tests/check-frontmatter.py" "$f"' "frontmatter parses in $f"
done

list=$(bash "$HERE/install-skills.sh"); one=$(bash "$HERE/install-skills.sh" gstack)
ok 'printf "%s" "$list" | grep -q "superpowers"' "install-skills lists skills"
ok 'printf "%s" "$one" | grep -q "Add --run"' "install-skills does not run without --run"


# --force backs up a skill folder and a replaced symlink, outside discovery paths.
rm "$TMP/work/.claude/skills/handoff"
mkdir -p "$TMP/work/.claude/skills/handoff"
echo mine > "$TMP/work/.claude/skills/handoff/SKILL.md"
rm "$TMP/work/.claude/skills/onboard"
ln -s "$TMP/missing-skill" "$TMP/work/.claude/skills/onboard"
HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --link-skills --force >/dev/null
ok 'grep -q mine "$TMP"/work/.aiwos-backups/*/skills/.claude/skills/handoff/SKILL.md && [ -L "$TMP/work/.claude/skills/handoff" ]' "--force backs up an existing skill folder"
ok '[ "$(readlink "$TMP"/work/.aiwos-backups/*/skills/.claude/skills/onboard)" = "$TMP/missing-skill" ]' "--force preserves even a dangling skill link"
ok '! ls -d "$TMP"/work/.claude/skills/*.bak* >/dev/null 2>&1' "no backup copies inside skills discovery folder"
HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --link-skills --pack thinking >/dev/null
ok '[ -L "$TMP/work/.claude/skills/goal" ] && [ -L "$TMP/work/.claude/skills/lead-triage" ]' "--pack thinking adds optional skills without removing existing packs"
# --pack links only that pack's skills, not the whole set
rm -rf "$TMP/home2"; mkdir -p "$TMP/home2"
HOME="$TMP/home2" bash "$HERE/setup.sh" "$TMP/work3" --link-skills --pack core >/dev/null
ok '[ -L "$TMP/work3/.claude/skills/onboard" ]' "--pack core links a core skill"
HOME="$TMP/home2" bash "$HERE/setup.sh" "$TMP/work4" --link-skills --pack does-not-exist >/dev/null 2>"$TMP/pack-err"
ok 'grep -q "no such pack" "$TMP/pack-err"' "--pack with an unknown name errors instead of linking everything"

# --pack accepts a comma-separated list
rm -rf "$TMP/home3"; mkdir -p "$TMP/home3"
HOME="$TMP/home3" bash "$HERE/setup.sh" "$TMP/work5" --link-skills --pack business,thinking >/dev/null
ok '[ -L "$TMP/work5/.claude/skills/lead-triage" ] && [ -L "$TMP/work5/.claude/skills/goal" ]' "--pack business,thinking links both packs' skills"
ok '[ ! -e "$TMP/work5/.claude/skills/onboard" ]' "--pack business,thinking does not link the core pack"
ok '[ "$(ls "$TMP/work5/.claude/skills" | wc -l | tr -d " ")" -eq 13 ]' "--pack business,thinking links exactly 13 skills (6+7)"

# repeated --pack flags accumulate, same as a comma list
rm -rf "$TMP/home4"; mkdir -p "$TMP/home4"
HOME="$TMP/home4" bash "$HERE/setup.sh" "$TMP/work6" --link-skills --pack core --pack business >/dev/null
ok '[ -L "$TMP/work6/.claude/skills/onboard" ] && [ -L "$TMP/work6/.claude/skills/lead-triage" ]' "repeated --pack flags accumulate both packs"
ok '[ ! -e "$TMP/work6/.claude/skills/goal" ]' "repeated --pack core --pack business does not link the thinking pack"

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
ok 'printf "%s" "$out" | grep -q "^-my other edit"' "--upgrade shows the actual per-file diff"
out2=$(HOME="$TMP/home" bash "$HERE/setup.sh" "$TMP/work" --upgrade --force); upgrade_rc=$?
ok '[ "$upgrade_rc" -eq 0 ]' "--upgrade ignores --force rather than writing (dry run always)"
after_hash2=$(md5 -q "$TMP/work/AGENTS.md" 2>/dev/null || md5sum "$TMP/work/AGENTS.md" | cut -d' ' -f1)
ok '[ "$before_hash" = "$after_hash2" ]' "--upgrade --force still writes nothing (upgrade is read-only)"

rm -rf "$TMP"
echo "setup: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
