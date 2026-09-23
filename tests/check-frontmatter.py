#!/usr/bin/env python3
"""Check that every SKILL.md starts with YAML frontmatter that has a name and a description.
Uses PyYAML when installed (strict, like most agent loaders); otherwise a simple key check."""
import re, sys
bad = 0
for path in sys.argv[1:]:
    text = open(path, encoding="utf-8").read()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        print(f"no frontmatter: {path}"); bad += 1; continue
    try:
        import yaml
        data = yaml.safe_load(m.group(1)) or {}
    except ImportError:
        data = dict(line.split(": ", 1) for line in m.group(1).splitlines() if ": " in line)
    except Exception as e:
        print(f"invalid YAML in {path}: {e}"); bad += 1; continue
    if not data.get("name") or not data.get("description"):
        print(f"missing name or description: {path}"); bad += 1
sys.exit(1 if bad else 0)
