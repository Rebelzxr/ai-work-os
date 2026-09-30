#!/usr/bin/env bash
# Real temporary workspaces; malformed configuration must never get a hook PASS.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP=$(mktemp -d)
pass=0; fail=0
ok() { if eval "$1"; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $2"; fi; }
TMPHOME="$TMP/home"
HOME="$TMPHOME" bash "$HERE/setup.sh" "$TMP/good" --link-skills --codex >/dev/null
mkdir -p "$TMP/broken"
out_good=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/good"); rc_good=$?
ok '[ "$rc_good" -eq 0 ]' "doctor exits 0 with configured hooks"
ok 'printf "%s" "$out_good" | grep -q "PASS  Claude Code PreToolUse hook configured"' "hook configuration gets a precise PASS"
ok 'printf "%s" "$out_good" | grep -q "not observed firing"' "configuration is not proof of firing"
ok '! printf "%s" "$out_good" | grep -qE "^FIX"' "no FIX on good workspace"
ok 'printf "%s" "$out_good" | grep -q "workspace .claude/skills: all 17 default aiwos skills available"' "checks default project skills"
ok 'printf "%s" "$out_good" | grep -q "workspace .agents/skills (Codex): all 17 default aiwos skills available"' "checks project Codex skills"
out_broken=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/broken"); rc_broken=$?
ok '[ "$rc_broken" -eq 1 ]' "missing settings fails"
ok 'printf "%s" "$out_broken" | grep -q "no .claude/settings.json"' "names missing file"
ok '! printf "%s" "$out_good" | grep -qiE "ghp_|gho_|sk-ant|token=|api[_-]?key="' "does not print secrets"
rm "$TMP/good/.claude/skills/eod"
ln -s "$TMP/no-such-skill" "$TMP/good/.claude/skills/eod"
out_missing=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/good")
ok 'printf "%s" "$out_missing" | grep -q "16/17.*missing: eod"' "dangling symlink does not count"
ok '! printf "%s" "$out_missing" | grep -qE "run setup.sh.*--force"' "repair advice never recommends force"

# Exercise the same parser doctor calls, without repeating optional auth checks.
CHECK="$HERE/scripts/check-hook-config.py"
SETTINGS="$TMP/good/.claude/settings.json"
cp "$SETTINGS" "$TMP/settings.json"
for content in '{"note":"block-dangerous"}' '{broken' '{"hooks":[]}' '{"hooks":{"PreToolUse":null}}'; do
  printf '%s' "$content" > "$SETTINGS"
  python3 "$CHECK" "$TMP/good"; rc=$?
  ok '[ "$rc" -eq 1 ]' "unrelated text or invalid JSON structure cannot pass"
done
out_unrelated=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/good"); rc=$?
ok '[ "$rc" -eq 1 ] && ! printf "%s" "$out_unrelated" | grep -q "PASS  Claude Code PreToolUse"' "doctor fails on invalid hook configuration"
cp "$TMP/settings.json" "$SETTINGS"
chmod -x "$TMP/good/scripts/hooks/block-dangerous.sh"
python3 "$CHECK" "$TMP/good"; rc=$?
ok '[ "$rc" -eq 1 ]' "non-executable script cannot pass"
chmod +x "$TMP/good/scripts/hooks/block-dangerous.sh"
rm "$TMP/good/scripts/hooks/block-dangerous.sh"
ln -s "$TMP/missing-hook" "$TMP/good/scripts/hooks/block-dangerous.sh"
python3 "$CHECK" "$TMP/good"; rc=$?
ok '[ "$rc" -eq 1 ]' "dangling hook cannot pass"
rm "$TMP/good/scripts/hooks/block-dangerous.sh"
cp "$HERE/template/scripts/hooks/block-dangerous.sh" "$TMP/good/scripts/hooks/block-dangerous.sh"
for mode in matcher event disabled fake-command; do
  python3 - "$TMP/settings.json" "$SETTINGS" "$mode" <<'PY'
import json, sys
cfg = json.load(open(sys.argv[1]))
mode = sys.argv[3]
if mode == 'matcher': cfg['hooks']['PreToolUse'][0]['matcher'] = 'Read'
if mode == 'event': cfg['hooks']['PostToolUse'] = cfg['hooks'].pop('PreToolUse')
if mode == 'disabled': cfg['disableAllHooks'] = True
if mode == 'fake-command': cfg['hooks']['PreToolUse'][0]['hooks'][0]['command'] = 'echo block-dangerous'
with open(sys.argv[2], 'w') as f: json.dump(cfg, f)
PY
  python3 "$CHECK" "$TMP/good"; rc=$?
  ok '[ "$rc" -eq 1 ]' "wrong matcher, event, disabled hooks or echo cannot pass"
done
# Quoting matters: never reinterpret a literal dollar as shell expansion.
for mode in single-quote escaped-dollar unquoted-variable async; do
  python3 - "$TMP/settings.json" "$SETTINGS" "$mode" <<'PYCASE'
import json, sys
cfg = json.load(open(sys.argv[1]))
hook = cfg['hooks']['PreToolUse'][0]['hooks'][0]
mode = sys.argv[3]
if mode == 'single-quote': hook['command'] = "'$CLAUDE_PROJECT_DIR/scripts/hooks/block-dangerous.sh'"
if mode == 'escaped-dollar': hook['command'] = r'"\$CLAUDE_PROJECT_DIR/scripts/hooks/block-dangerous.sh"'
if mode == 'unquoted-variable': hook['command'] = '$CLAUDE_PROJECT_DIR/scripts/hooks/block-dangerous.sh'
if mode == 'async': hook['async'] = True
with open(sys.argv[2], 'w') as f: json.dump(cfg, f)
PYCASE
  python3 "$CHECK" "$TMP/good"; rc=$?
  ok '[ "$rc" -eq 1 ]' "literal dollars, unquoted expansion and async hooks cannot pass"
done
HOME="$TMPHOME" bash "$HERE/setup.sh" "$TMP/space workspace" >/dev/null
python3 "$CHECK" "$TMP/space workspace"; rc=$?
ok '[ "$rc" -eq 0 ]' "quoted project variable works with workspace spaces"
python3 - "$TMP/space workspace" <<'PYCASE'
import json, pathlib, sys
root = pathlib.Path(sys.argv[1]); p = root / '.claude/settings.json'
cfg = json.loads(p.read_text())
cfg['hooks']['PreToolUse'][0]['hooks'][0]['command'] = '"' + str(root / 'scripts/hooks/block-dangerous.sh') + '"'
p.write_text(json.dumps(cfg))
PYCASE
python3 "$CHECK" "$TMP/space workspace"; rc=$?
ok '[ "$rc" -eq 0 ]' "quoted absolute script path works with spaces"
cp "$TMP/settings.json" "$SETTINGS"
mkdir -p "$TMP/good/.codex"
printf '{}' > "$TMP/good/.codex/hooks.json"
out_codex=$(HOME="$TMPHOME" bash "$HERE/doctor.sh" "$TMP/good")
ok 'printf "%s" "$out_codex" | grep -q "WARN  Codex hooks.json present but not validated"' "file presence is not Codex hook proof"
python3 - "$TMP" <<'PY'
import shutil, sys
shutil.rmtree(sys.argv[1])
PY
echo "doctor: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
