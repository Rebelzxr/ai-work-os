#!/usr/bin/env bash
# Recommended third-party skills, installed from their own repos (never copied here).
#
#   ./install-skills.sh               list them with their official install commands
#   ./install-skills.sh gstack --run  show the command for one skill, ask, then run it
#
# Commands starting with /plugin run inside Claude Code, so this script only prints them.
set -uo pipefail

# name|what it is for|official install command|source|licence
SKILLS=(
  "superpowers|Process skills: brainstorm, plan, test-first, debug, verify before claiming done|/plugin install superpowers@claude-plugins-official|https://github.com/obra/superpowers|MIT"
  "gstack|Garry Tan's setup: CEO, designer, eng manager, release and QA roles|git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack && cd ~/gstack && ./setup|https://github.com/garrytan/gstack|MIT"
  "karpathy|One CLAUDE.md of coding pitfalls drawn from Andrej Karpathy's observations (by forrestchang)|/plugin marketplace add forrestchang/andrej-karpathy-skills, then /plugin install andrej-karpathy-skills@karpathy-skills|https://github.com/multica-ai/andrej-karpathy-skills|README says MIT; no LICENSE file, so linked only"
  "huashu-design|HTML-native design: prototypes, slides, motion, design review|npx skills add alchaincyf/huashu-design|https://github.com/alchaincyf/huashu-design|MIT"
  "last30days|Research what people said about a topic in the last 30 days|npx skills add mvanhorn/last30days-skill -g|https://github.com/mvanhorn/last30days-skill|MIT"
  "impeccable|Design language and UI critique for coding agents|npx impeccable install|https://github.com/pbakaus/impeccable|Apache-2.0"
  "ui-ux-pro-max|UI and UX design intelligence: styles, palettes, type pairings|/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill, then /plugin install ui-ux-pro-max@ui-ux-pro-max-skill|https://github.com/nextlevelbuilder/ui-ux-pro-max-skill|MIT"
  "agent-browser|Browser automation CLI for agents: open, click, fill, screenshot|npm install -g agent-browser && agent-browser install|https://github.com/vercel-labs/agent-browser|Apache-2.0"
  "fable-forge|Dainer's website design skill: subject-led direction and render evidence|git clone https://github.com/Rebelzxr/fable-forge.git ~/fable-forge && ~/fable-forge/install.sh|https://github.com/Rebelzxr/fable-forge|Apache-2.0"
)

field() { printf '%s' "$1" | cut -d'|' -f"$2"; }

if [ $# -eq 0 ]; then
  echo "Recommended third-party skills (installed from their own repos):"
  echo
  for s in "${SKILLS[@]}"; do
    printf '  %-14s %s\n' "$(field "$s" 1)" "$(field "$s" 2)"
    printf '  %-14s %s\n' "" "install: $(field "$s" 3)"
    printf '  %-14s %s · licence: %s\n\n' "" "$(field "$s" 4)" "$(field "$s" 5)"
  done
  echo "Run one: ./install-skills.sh <name> --run"
  exit 0
fi

name="$1"; run="${2:-}"
for s in "${SKILLS[@]}"; do
  [ "$(field "$s" 1)" = "$name" ] || continue
  cmd="$(field "$s" 3)"
  echo "$name: $cmd"
  echo "Source: $(field "$s" 4) (read it before you run it)"
  case "$cmd" in /plugin*) echo "This one runs inside Claude Code. Paste the command there."; exit 0 ;; esac
  [ "$run" = "--run" ] || { echo "Add --run to install it."; exit 0; }
  read -r -p "Run this now? [y/N] " yes
  [ "$yes" = "y" ] || [ "$yes" = "Y" ] || { echo "Skipped."; exit 0; }
  bash -c "$cmd"
  exit $?
done
echo "Unknown skill: $name. Run ./install-skills.sh to see the list." >&2
exit 1
