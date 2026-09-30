#!/usr/bin/env python3
"""Structural checks only: do not run a model or certify its output quality."""
from pathlib import Path
import re
import sys


def check(skill):
    body = skill.read_text()
    pack = skill.parent.parent.parent.resolve()
    root = pack.parent.parent
    errors = []
    for ref in set(re.findall(r'(?:[\w.-]+/)*scripts/[\w./-]+\.(?:py|sh)', body)):
        target = (root / ref if ref.startswith('packs/') else skill.parent / ref).resolve()
        if pack not in target.parents or not target.is_file():
            errors.append(f'missing or outside pack: {ref}')
    if pack.name in ('business', 'marketing', 'video'):
        lower = body.lower()
        for text in ('made-up', 'clean locally first', 'names', 'ic', 'phone', 'bank', 'addresses'):
            if text not in lower:
                errors.append(f'missing local privacy instruction: {text}')
        if 'second check' not in lower:
            errors.append('missing second-check privacy boundary')
    if pack.name in ('marketing', 'video') and 'safe-to-paste' in body:
        if 'aiwos-business' not in body or not re.search(r'if (?:it is )?missing|if [^\n]*is missing|if .*not installed|without it', body, re.I):
            errors.append('missing business-pack dependency or fallback')
    return errors


if __name__ == '__main__':
    errors = check(Path(sys.argv[1]))
    for error in errors:
        print(error)
    sys.exit(bool(errors))
