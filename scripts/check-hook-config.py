#!/usr/bin/env python3
"""Inspect hook configuration without executing any command from settings."""
import json
import os
from pathlib import Path
import re
import shlex
import sys


def command_path(command, workspace):
    """Accept direct paths only; preserve shell quoting without running a shell."""
    command = command.strip()
    variable = r'\$(?:CLAUDE_PROJECT_DIR|\{CLAUDE_PROJECT_DIR\})'
    # The shipped form quotes the variable; also accept the entire path quoted.
    match = re.fullmatch(r'"' + variable + r'"(/[\w./-]+)', command)
    if not match:
        match = re.fullmatch(r'"' + variable + r'(/[^"$`\\]+)"', command)
    if match:
        return workspace / match.group(1).lstrip('/')
    try:
        parts = shlex.split(command)
    except ValueError:
        return None
    if len(parts) != 1:
        return None
    path = parts[0]
    # shlex alone loses whether a dollar was literal, escaped or expanded.
    # Other shell constructs are outside this small configuration check.
    if any(char in path for char in '$`\\'):
        return None
    if command != shlex.quote(path) and command != '"' + path + '"':
        return None
    script = Path(path)
    return script if script.is_absolute() else workspace / script


def configured(workspace):
    try:
        settings = json.loads((workspace / '.claude/settings.json').read_text())
    except (OSError, ValueError):
        return False
    if not isinstance(settings, dict) or settings.get('disableAllHooks') is True:
        return False
    hooks = settings.get('hooks', {})
    if not isinstance(hooks, dict):
        return False
    entries = hooks.get('PreToolUse', [])
    if not isinstance(entries, list):
        return False
    for entry in entries:
        if not isinstance(entry, dict) or entry.get('matcher', '') not in ('Bash', '*', ''):
            continue
        commands = entry.get('hooks', [])
        if not isinstance(commands, list):
            continue
        for hook in commands:
            if not isinstance(hook, dict) or hook.get('type') != 'command' or hook.get('async'):
                continue
            command = hook.get('command')
            if not isinstance(command, str):
                continue
            script = command_path(command, workspace)
            if script is None or script.name not in ('block-dangerous.sh', 'block-dangerous.py'):
                continue
            if script.is_file() and os.access(script, os.X_OK):
                # The shipped shell entry point needs its Python companion too.
                if script.name == 'block-dangerous.sh' and not script.with_suffix('.py').is_file():
                    continue
                return True
    return False


if __name__ == '__main__':
    sys.exit(0 if len(sys.argv) == 2 and configured(Path(sys.argv[1]).resolve()) else 1)
