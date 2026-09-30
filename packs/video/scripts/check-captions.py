#!/usr/bin/env python3
"""Compatibility entry point; the portable checker ships with video-brief."""
from pathlib import Path
import runpy

_checker = Path(__file__).resolve().parents[1] / "skills/video-brief/scripts/check-captions.py"
if __name__ == "__main__":
    runpy.run_path(str(_checker), run_name="__main__")
else:
    globals().update(runpy.run_path(str(_checker)))
