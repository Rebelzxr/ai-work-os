#!/usr/bin/env bash
# session-start.sh: Claude Code SessionStart hook. Prints a one-screen resume point.
# Output becomes context for the new session, so keep it short: the date, the
# "Context for next session" block and the lane headings from the board.
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TODO="$ROOT/memory/TODO.md"
echo "Workspace: $(basename "$ROOT") · $(date '+%Y-%m-%d %H:%M')"
[ -f "$TODO" ] || { echo "No memory/TODO.md yet."; exit 0; }
awk '/^## Context for next session/{on=1; print; next} on && /^## /{on=0} on' "$TODO" | head -12
echo "Lanes on the board:"
grep -E '^## ' "$TODO" | grep -v -E 'Context for next session|Backlog' | sed 's/^## /- /'
exit 0
