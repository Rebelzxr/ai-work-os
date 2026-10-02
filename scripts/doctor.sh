#!/usr/bin/env bash
# Read-only health check for an AI Work OS workspace and this machine.
# Never prints a secret value: gh/claude/codex checks report set/not-set or yes/no only.
#
#   ./scripts/doctor.sh              check the current directory
#   ./scripts/doctor.sh ~/my-work    check a specific workspace
#
# Exit code: 0 if everything is PASS or WARN, 1 if anything is FIX.
set -uo pipefail
WS="${1:-.}"
[ -d "$WS" ] || { echo "No such directory: $WS" >&2; exit 1; }
WS="$(cd "$WS" && pwd)"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fix=0

pass() { printf 'PASS  %s\n' "$1"; }
warn() { printf 'WARN  %s\n' "$1"; }
fixmsg() { printf 'FIX   %s\n' "$1"; fix=1; }

echo "AI Work OS doctor — $WS"
echo

# --- tools ---
if command -v git >/dev/null 2>&1; then pass "git found ($(git --version | head -1))"; else fixmsg "git not found on PATH — install git"; fi
if command -v python3 >/dev/null 2>&1; then pass "python3 found ($(python3 --version 2>&1))"; else fixmsg "python3 not found on PATH — the frontmatter and check-captions checks need it"; fi
if command -v claude >/dev/null 2>&1; then pass "claude found on PATH"; else warn "claude not found on PATH — install Claude Code, or ignore if you only use Codex"; fi
if command -v codex >/dev/null 2>&1; then pass "codex found on PATH"; else warn "codex not found on PATH — install Codex, or ignore if you only use Claude Code"; fi

# --- gh auth: yes/no only, never the token ---
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then pass "gh: authenticated"; else warn "gh: not authenticated (run 'gh auth login' if you use GitHub from here)"; fi
else
  warn "gh not found on PATH — optional, needed for 'gh skill install' and PR workflows"
fi

# --- workspace hooks wired (Claude Code) ---
SETTINGS="$WS/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
  if python3 "$HERE/scripts/check-hook-config.py" "$WS"; then
    pass "Claude Code PreToolUse hook configured for Bash; executable block-dangerous script found (not observed firing)"
  else
    fixmsg ".claude/settings.json: no valid PreToolUse Bash command pointing to an existing executable block-dangerous script; check JSON, matcher and direct quoted path (shell wrappers are not verified)"
  fi
else
  fixmsg "no .claude/settings.json in this workspace — run setup.sh, or copy template/.claude/settings.json"
fi

# --- Codex hooks: not shipped yet (see docs/roadmap.md) ---
if [ -f "$WS/.codex/hooks.json" ]; then
  warn "Codex hooks.json present but not validated or observed firing by this doctor"
else
  warn "Codex hook wiring is not shipped yet — this doctor does not verify Codex protection. See docs/roadmap.md"
fi

# --- default project skills (thinking is optional) ---
# Discover every skill from the default packs; fall back to the core
# skills if this copy of doctor.sh is run somewhere without a packs/ folder next to it.
ALL_SKILLS=()
DEFAULT_PACKS=(core business marketing web video sales delivery plan handoff)
if [ -d "$HERE/packs" ]; then
  for p in "${DEFAULT_PACKS[@]}"; do
    for d in "$HERE/packs/$p/skills"/*/; do
      [ -d "$d" ] || continue
      ALL_SKILLS+=("$(basename "$d")")
    done
  done
fi
[ "${#ALL_SKILLS[@]}" -gt 0 ] || ALL_SKILLS=(business-brief eod evidence-loop handoff job-packet onboard what-now)

check_skills_dir() { # label, dir
  local label="$1" dir="$2" linked=0 missing=()
  if [ ! -d "$dir" ]; then
    warn "$label: not present ($dir) — no default aiwos skills available there yet"
    return
  fi
  for s in "${ALL_SKILLS[@]}"; do
    if [ -d "$dir/$s" ] && [ -f "$dir/$s/SKILL.md" ]; then
      linked=$((linked+1))
    else
      missing+=("$s")
    fi
  done
  if [ "$linked" -eq "${#ALL_SKILLS[@]}" ]; then
    pass "$label: all ${#ALL_SKILLS[@]} default aiwos skills available"
  elif [ "$linked" -eq 0 ]; then
    warn "$label: present but no default aiwos skills available ($dir) — run setup.sh --link-skills"
  else
    warn "$label: $linked/${#ALL_SKILLS[@]} default aiwos skills available, missing: ${missing[*]} — run setup.sh <your-workspace> --link-skills (review any name collisions yourself)"
  fi
}

check_skills_dir "workspace .claude/skills" "$WS/.claude/skills"
check_skills_dir "workspace .agents/skills (Codex)" "$WS/.agents/skills"
echo "INFO  Thinking pack: optional; add with setup.sh <your-workspace> --link-skills --pack thinking (plus --codex for Codex)."
# Older global links may still affect other projects; report them without changing them.
for dir in "$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.codex/skills"; do
  [ ! -d "$dir" ] || warn "Global skills folder exists: $dir; this check counts project skills only"
done

echo
if [ "$fix" -eq 1 ]; then echo "Result: one or more FIX items above need attention."; else echo "Result: no FIX items."; fi
exit "$fix"
