#!/usr/bin/env bash
# Structure, fixture and safety-language checks for packs/business, packs/thinking,
# packs/marketing, packs/web and packs/video.
# Exits non-zero on any failure. Prints one line per check.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

fail=0
skills_checked=0
fm_check_tmp="$(mktemp)"
trap 'rm -f "$fm_check_tmp"' EXIT

SEND_WORDS_RE='(^|[^a-zA-Z])(send|sends|sending|post|posts|posting|publish|publishes|publishing|deploy|deploys|deploying|pay|pays|paying|delete|deletes|deleting)([^a-zA-Z]|$)'

for pack_dir in packs/business packs/thinking packs/marketing packs/web packs/video; do
  [ -d "$pack_dir/skills" ] || { echo "FAIL: no skills dir in $pack_dir"; fail=1; continue; }

  # plugin manifest present
  if [ ! -f "$pack_dir/.claude-plugin/plugin.json" ]; then
    echo "FAIL: missing $pack_dir/.claude-plugin/plugin.json"
    fail=1
  else
    python3 -c "import json,sys; json.load(open('$pack_dir/.claude-plugin/plugin.json'))" \
      && echo "PASS: $pack_dir/.claude-plugin/plugin.json is valid JSON" \
      || { echo "FAIL: $pack_dir/.claude-plugin/plugin.json is not valid JSON"; fail=1; }
  fi

  for skill_dir in "$pack_dir"/skills/*/; do
    name="$(basename "$skill_dir")"
    skill_md="$skill_dir/SKILL.md"
    skills_checked=$((skills_checked + 1))

    if [ ! -f "$skill_md" ]; then
      echo "FAIL: $name has no SKILL.md"
      fail=1
      continue
    fi

    # frontmatter check (reuses the repo's existing checker)
    if python3 tests/check-frontmatter.py "$skill_md" >"$fm_check_tmp" 2>&1; then
      echo "PASS: $name frontmatter OK"
    else
      echo "FAIL: $name frontmatter"; cat "$fm_check_tmp"
      fail=1
    fi

    # safety-language lint: if SKILL.md mentions send/post/publish/deploy/pay/delete,
    # it must contain an explicit human-approval section.
    body_lower="$(tr '[:upper:]' '[:lower:]' < "$skill_md")"
    if echo "$body_lower" | grep -qE "$SEND_WORDS_RE"; then
      if echo "$body_lower" | grep -qi "## human approval"; then
        echo "PASS: $name has send/post/publish/deploy/pay/delete language AND a Human approval section"
      else
        echo "FAIL: $name mentions a send/post/publish/deploy/pay/delete word but has no '## Human approval' section"
        fail=1
      fi
    else
      echo "SKIP: $name has no send/post/publish/deploy/pay/delete language (lint not required)"
    fi

    # fixture presence
    fixture_dir="tests/packs/$name"
    if [ -f "$fixture_dir/input.md" ] && [ -f "$fixture_dir/checklist.md" ]; then
      echo "PASS: $name has input.md and checklist.md fixtures"
    else
      echo "FAIL: $name missing tests/packs/$name/input.md or checklist.md"
      fail=1
    fi

    # Structural check on the fixture content itself (not just file presence).
    # These fixtures are for manual/agent evaluation, not a fully automated pass/fail
    # (see docs/packs.md) — safe-to-paste's test_patterns.py is the one exception with
    # a real regex test. This check is the one thing here that can still fail for real:
    # a placeholder or emptied-out fixture trips it.
    input_chars=$(wc -c < "$fixture_dir/input.md" 2>/dev/null | tr -d ' ')
    checklist_items=$(grep -c '^- \[ \]' "$fixture_dir/checklist.md" 2>/dev/null || echo 0)
    if [ "${input_chars:-0}" -lt 20 ]; then
      echo "FAIL: $name tests/packs/$name/input.md is empty or a placeholder (${input_chars:-0} chars, need >=20)"
      fail=1
    elif [ "${checklist_items:-0}" -lt 3 ]; then
      echo "FAIL: $name tests/packs/$name/checklist.md has only $checklist_items checkbox item(s), need >=3"
      fail=1
    else
      echo "PASS: $name fixture has a real input (${input_chars} chars) and $checklist_items checklist items"
    fi
  done
done

echo "---"
echo "Skills checked: $skills_checked"

# Deterministic regex test for safe-to-paste
if [ -f tests/packs/safe-to-paste/test_patterns.py ]; then
  if python3 tests/packs/safe-to-paste/test_patterns.py; then
    echo "PASS: safe-to-paste deterministic regex test"
  else
    echo "FAIL: safe-to-paste deterministic regex test"
    fail=1
  fi
else
  echo "FAIL: tests/packs/safe-to-paste/test_patterns.py missing"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  echo "RESULT: FAIL"
  exit 1
fi
echo "RESULT: PASS"
exit 0
