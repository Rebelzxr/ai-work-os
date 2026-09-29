#!/usr/bin/env bash
# Set up the AI Work OS in a folder.
#
#   ./setup.sh ~/my-work                     copy the template into ~/my-work
#   ./setup.sh ~/my-work --link-skills        also link skills from every pack in packs/ into ~/.claude/skills
#   ./setup.sh ~/my-work --link-skills --codex   and into the Codex skills paths
#   ./setup.sh ~/my-work --link-skills --pack core          link only the core pack's skills
#   ./setup.sh ~/my-work --link-skills --pack core,business link two packs' skills (comma-separated)
#   ./setup.sh ~/my-work --link-skills --pack core --pack business   same as above, repeated flags
#                                              (default with no --pack: every pack in packs/)
#   ./setup.sh ~/my-work --force              overwrite template files that already exist
#                                              (an existing skill folder with the same name is
#                                              moved to skills-backup/, never deleted)
#   ./setup.sh ~/my-work --upgrade            dry run: show what a normal run would change to an
#                                              existing workspace, write nothing, never overwrite
#
# Safe to run again: existing files are kept unless you pass --force.
set -euo pipefail

TARGET="" LINK="" CODEX="" FORCE="" UPGRADE=""
declare -a PACKS=()
while [ $# -gt 0 ]; do
  arg="$1"
  case "$arg" in
    --link-skills) LINK=1 ;;
    --codex) CODEX=1 ;;
    --force|-f) FORCE=1 ;;
    --upgrade) UPGRADE=1 ;;
    --pack)
      shift
      val="${1:-}"
      [ -n "$val" ] || { echo "--pack needs a name, for example: --pack core" >&2; exit 1; }
      IFS=',' read -ra parts <<< "$val"
      added=0
      for p in "${parts[@]}"; do
        [ -n "$p" ] || continue
        PACKS+=("$p"); added=$((added+1))
      done
      [ "$added" -gt 0 ] || { echo "--pack needs at least one name, for example: --pack core" >&2; exit 1; }
      ;;
    -h|--help) sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) echo "Unknown option: $arg" >&2; exit 1 ;;
    *) TARGET="$arg" ;;
  esac
  shift
done
[ -n "$TARGET" ] || { echo "Tell me where to set it up, for example: ./setup.sh ~/my-work" >&2; exit 1; }

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate any --pack names before doing anything else: shape first (reject path
# traversal like "../x" or anything with a slash), then existence on disk.
for p in "${PACKS[@]:-}"; do
  [ -n "$p" ] || continue
  if ! [[ "$p" =~ ^[a-z0-9-]+$ ]]; then
    echo "invalid pack name: '$p' (must match ^[a-z0-9-]+\$ — lowercase letters, digits, hyphens only)" >&2
    exit 1
  fi
  [ -d "$HERE/packs/$p/skills" ] || { echo "no such pack: '$p' (looked in packs/$p/skills)" >&2; exit 1; }
done

if [ -n "$UPGRADE" ]; then
  # Dry run only: report what would change, write nothing.
  [ -d "$TARGET" ] || { echo "Nothing to upgrade: $TARGET does not exist yet. Run without --upgrade first." >&2; exit 1; }
  TARGET="$(cd "$TARGET" && pwd)"
  echo "Upgrade dry run for $TARGET (read-only: nothing is written; a changed file is never overwritten by --upgrade):"
  would_add=0 would_update=0 unchanged=0
  while IFS= read -r -d '' src; do
    rel="${src#"$HERE/template/"}"
    dest="$TARGET/$rel"
    if [ ! -e "$dest" ]; then
      echo "  would add:    $rel"; would_add=$((would_add+1))
    elif ! cmp -s "$src" "$dest"; then
      echo "  would update: $rel (your copy differs from the template)"; would_update=$((would_update+1))
    else
      unchanged=$((unchanged+1))
    fi
  done < <(find "$HERE/template" -type f -print0)
  echo
  echo "$would_add file(s) would be added, $would_update would be offered as an update, $unchanged already match."
  [ "$would_update" -gt 0 ] && echo "Nothing was changed. Review each one yourself; re-run with --force to overwrite (this also overwrites files you edited by hand)."
  exit 0
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
copied=0 kept=0

while IFS= read -r -d '' src; do
  rel="${src#"$HERE/template/"}"
  dest="$TARGET/$rel"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ -z "$FORCE" ]; then kept=$((kept+1)); continue; fi
  cp "$src" "$dest"; copied=$((copied+1))
done < <(find "$HERE/template" -type f -print0)
chmod +x "$TARGET"/scripts/hooks/*.sh 2>/dev/null || true

link_into() { # dest_dir
  mkdir -p "$1"
  local -a src_dirs=()
  if [ "${#PACKS[@]}" -gt 0 ]; then
    for p in "${PACKS[@]}"; do src_dirs+=("$HERE/packs/$p/skills"); done
  else
    # Default: every pack. Glob packs/*/skills directly rather than the top-level
    # skills/ symlinks, so setup.sh works on Windows/Git Bash where those symlinks
    # may not resolve (see docs/roadmap.md). The skills/ symlinks stay in the repo
    # for v1 compatibility, but nothing here requires them.
    for d in "$HERE"/packs/*/skills; do [ -d "$d" ] && src_dirs+=("$d"); done
  fi
  for glob_dir in "${src_dirs[@]}"; do
    for skill in "$glob_dir"/*/; do
      [ -e "$skill" ] || continue
      name="$(basename "$skill")"
      if [ -e "$1/$name" ] && [ -z "$FORCE" ]; then echo "  kept existing $1/$name"; continue; fi
      if [ -L "$1/$name" ]; then rm "$1/$name"; echo "  replaced the existing link $1/$name"
      elif [ -e "$1/$name" ]; then bak="$1-backup/$name-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$1-backup"; mv "$1/$name" "$bak"; echo "  moved your existing $name to $bak"
      fi
      ln -s "${skill%/}" "$1/$name"; echo "  linked $1/$name"
    done
  done
}
if [ -n "$LINK" ]; then
  echo "Linking skills (links, so 'git pull' in this repo updates them):"
  link_into "$HOME/.claude/skills"
  if [ -n "$CODEX" ]; then
    # OpenAI's docs (learn.chatgpt.com/docs/build-skills) list the user scope as
    # $HOME/.agents/skills; that is now the primary path. v1 of this repo linked
    # into $HOME/.codex/skills instead, which is not in the current docs, so we
    # keep linking there too rather than silently dropping anyone whose Codex
    # install still reads it.
    link_into "$HOME/.agents/skills"
    link_into "$HOME/.codex/skills"
    echo "  Codex note: linked into ~/.agents/skills (the documented path) and ~/.codex/skills (kept for older Codex installs)."
    echo "  Run ./doctor.sh after this to see what is linked in each folder."
  fi
fi

cat <<EOF

AI Work OS is ready in $TARGET
  $copied file(s) copied, $kept existing file(s) kept$([ -z "$FORCE" ] && [ "$kept" -gt 0 ] && echo " (use --force to overwrite)")

Next:
  1. Open $TARGET/AGENTS.md and fill in the <angle brackets> (5 minutes), or start Claude Code there and say "onboard".
  2. Put your first outcome on memory/TODO.md.
  3. Start Claude Code in that folder and say "what now".
  Optional: ./install-skills.sh to see recommended third-party skills.
EOF
