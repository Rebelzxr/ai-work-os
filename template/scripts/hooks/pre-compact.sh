#!/usr/bin/env bash
# pre-compact.sh: Claude Code PreCompact hook. Before the chat is compressed,
# snapshot the board and note the event in today's log, so nothing about the
# current state depends on what survives compaction.
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TODAY=$(date +%Y-%m-%d); NOW=$(date +%H%M)
mkdir -p "$ROOT/memory/sessions" "$ROOT/memory/daily-logs"
[ -f "$ROOT/memory/TODO.md" ] && cp "$ROOT/memory/TODO.md" "$ROOT/memory/sessions/$TODAY-$NOW-TODO.md"
LOG="$ROOT/memory/daily-logs/$TODAY.md"
[ -f "$LOG" ] || printf '# Daily log %s\n\n' "$TODAY" > "$LOG"
echo "- $(date +%H:%M) context compacted; board snapshot saved to memory/sessions/$TODAY-$NOW-TODO.md" >> "$LOG"
exit 0
