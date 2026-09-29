#!/usr/bin/env python3
"""Deterministic guard for the onboard skill's "workspace only" rule.

Given a workspace root and a candidate file path the skill wants to write,
exit 0 (allowed) only when the candidate resolves inside the workspace root.
Exit 1 (refused) for anything outside it: a parent folder, $HOME directly,
another project, a path that escapes via '..', or a symlink that points out.

Usage: guard_workspace.py <workspace_root> <candidate_path>
"""
import os
import sys


def is_inside(root: str, candidate: str) -> bool:
    root_real = os.path.realpath(root)
    # Resolve the candidate's directory (the file itself may not exist yet);
    # realpath on a non-existent leaf still resolves the existing parents.
    cand_real = os.path.realpath(candidate)
    try:
        common = os.path.commonpath([root_real, cand_real])
    except ValueError:
        return False  # different drives on Windows, or otherwise unrelated
    return common == root_real


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: guard_workspace.py <workspace_root> <candidate_path>", file=sys.stderr)
        return 2
    root, candidate = sys.argv[1], sys.argv[2]
    if is_inside(root, candidate):
        print(f"ALLOWED: {candidate}")
        return 0
    print(f"REFUSED: {candidate} is outside the workspace {root}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
