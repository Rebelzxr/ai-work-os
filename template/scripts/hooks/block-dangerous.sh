#!/usr/bin/env bash
# block-dangerous.sh: Claude Code PreToolUse hook for the Bash tool.
# Passes the hook JSON (on stdin) to block-dangerous.py, which reads the command and applies the rules.
# Exit 2 blocks the command and shows the reason to the agent, which must then propose a safer
# alternative or ask you. Exit 0 lets it run.
# It fails closed: if python3 is missing or the check cannot finish, the command is blocked.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
command -v python3 >/dev/null 2>&1 || { echo "BLOCKED: python3 is needed to check commands safely. Install python3 or remove this hook." >&2; exit 2; }
python3 "$HERE/block-dangerous.py"
rc=$?
if [ "$rc" -ne 0 ] && [ "$rc" -ne 2 ]; then
  echo "BLOCKED: the safety check could not finish, so the command was stopped to be safe." >&2
  exit 2
fi
exit "$rc"
