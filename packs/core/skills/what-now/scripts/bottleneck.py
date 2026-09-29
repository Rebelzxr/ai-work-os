#!/usr/bin/env python3
"""Deterministic reference for the what-now skill's bottleneck rule.

Parses the markdown tables in a TODO.md-style board and picks the row the
skill should name as the bottleneck, using the same priority the SKILL.md
describes:
  1. a row whose "Owner and state" cell contains "blocked" (oldest first —
     first blocked row found, top to bottom);
  2. else a row whose "Next action" cell needs the user specifically
     (contains "I approve", "you decide", "your call", or "approve");
  3. else the first row on the board.

This is a reference implementation for the CI fixture check, not the skill
itself — the skill (an LLM reading the real board) should reach the same
row on the fixture in tests/fixtures/what-now/.

Usage: bottleneck.py <path-to-board.md>
Prints the chosen row's Outcome cell to stdout.
"""
import re
import sys

NEEDS_USER = re.compile(r"\bI approve\b|\byou decide\b|\byour call\b|\bapprove\b", re.I)


def parse_rows(text: str):
    rows = []
    for line in text.splitlines():
        line = line.strip()
        if not line.startswith("|") or line.startswith("|---") or set(line) <= {"|", "-", " "}:
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if len(cells) < 3:
            continue
        if cells[0].lower() in ("outcome",):
            continue
        rows.append(cells)
    return rows


def pick(rows):
    for r in rows:
        if "blocked" in r[1].lower():
            return r
    for r in rows:
        if NEEDS_USER.search(r[2]):
            return r
    return rows[0] if rows else None


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: bottleneck.py <board.md>", file=sys.stderr)
        return 2
    text = open(sys.argv[1], encoding="utf-8").read()
    rows = parse_rows(text)
    chosen = pick(rows)
    if not chosen:
        print("NONE: no active rows")
        return 0
    print(chosen[0])
    return 0


if __name__ == "__main__":
    sys.exit(main())
