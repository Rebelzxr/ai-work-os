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
  if grep -q "block-dangerous" "$SETTINGS" 2>/dev/null; then
    pass "Claude Code hooks wired in .claude/settings.json (block-dangerous found)"
  else
    fixmsg ".claude/settings.json exists but does not reference block-dangerous — hooks may not be protecting this workspace"
  fi
else
  fixmsg "no .claude/settings.json in this workspace — run setup.sh, or copy template/.claude/settings.json"
fi

# --- Codex hooks: not shipped yet (see docs/roadmap.md) ---
if [ -f "$WS/.codex/hooks.json" ]; then
  pass "Codex hooks.json present"
else
  warn "Codex hook wiring is not shipped yet — Claude Code hooks protect this workspace, Codex does not. See docs/roadmap.md"
fi

# --- skills linked (all packs, not just core) ---
# Discover every skill from this repo's packs/*/skills; fall back to the six core
# skills if this copy of doctor.sh is run somewhere without a packs/ folder next to it.
ALL_SKILLS=()
if [ -d "$HERE/packs" ]; then
  for d in "$HERE"/packs/*/skills/*/; do
    [ -e "$d" ] || continue
    ALL_SKILLS+=("$(basename "$d")")
  done
fi
[ "${#ALL_SKILLS[@]}" -gt 0 ] || ALL_SKILLS=(eod evidence-loop handoff job-packet onboard what-now)

check_skills_dir() { # label, dir
  local label="$1" dir="$2" linked=0 missing=()
  if [ ! -d "$dir" ]; then
    warn "$label: not present ($dir) — no aiwos skills linked there yet"
    return
  fi
  for s in "${ALL_SKILLS[@]}"; do
    if [ -L "$dir/$s" ] || [ -d "$dir/$s" ]; then
      linked=$((linked+1))
    else
      missing+=("$s")
    fi
  done
  if [ "$linked" -eq "${#ALL_SKILLS[@]}" ]; then
    pass "$label: all ${#ALL_SKILLS[@]} aiwos skills linked"
  elif [ "$linked" -eq 0 ]; then
    warn "$label: present but no aiwos skills linked ($dir) — run setup.sh --link-skills"
  else
    warn "$label: $linked/${#ALL_SKILLS[@]} aiwos skills linked, missing: ${missing[*]} — run setup.sh <your-workspace> --link-skills (not --force: that overwrites your filled-in workspace files; if a folder with the same name blocks a link, move it yourself)"
  fi
}

check_skills_dir "~/.claude/skills" "$HOME/.claude/skills"
check_skills_dir "~/.agents/skills (Codex, documented path)" "$HOME/.agents/skills"
check_skills_dir "~/.codex/skills (Codex, legacy path)" "$HOME/.codex/skills"

echo
if [ "$fix" -eq 1 ]; then echo "Result: one or more FIX items above need attention."; else echo "Result: no FIX items."; fi
exit "$fix"
