#!/usr/bin/env python3
"""Deterministic SRT/VTT caption lint for the video-brief skill.

Checks a caption file for:
  - malformed cue blocks and out-of-range timestamp fields
  - ASCII control characters inside cue text (tabs and line endings allowed)
  - timing overlaps between consecutive cues
  - a cue whose end time is before (or equal to) its start time
  - too many characters on one line (default max 42)
  - too many lines in one cue (default max 2)
  - reading speed too fast: characters per second of cue duration (default max 20)

Character counts ignore VTT formatting tags (<i>, <b>, <c.classname>, <v Speaker>,
timestamp tags like <00:00:01.000>, and their closing tags) — those are markup, not
what a viewer reads on screen. Character references are decoded after tag stripping.

Reads the file as UTF-8, tolerating (and stripping) a leading byte-order mark (BOM),
since many editors and Whisper-style exporters write SRT/VTT with one. A file that is
not valid UTF-8 (with or without BOM) is reported as a clear FAIL line, not a traceback.

Usage:
  check-captions.py <file.srt|file.vtt> [--max-chars-per-line N] [--max-lines N] [--max-cps N]

Exit code: 0 if no problems found, 1 if any problem found (or the file can't be parsed).
Prints one line per problem, then a final PASS/FAIL summary line.
"""
import re
import sys
import argparse
import html

TIME_RE_SRT = re.compile(r"(\d{2,3}):([0-5]\d):([0-5]\d)[,.]([0-9]{3})", re.ASCII)
# WebVTT timestamps may omit the hours component (e.g. Whisper-style "mm:ss.ttt"
# exports for cues under an hour); SRT always carries hh:mm:ss,ttt (checked above).
TIME_RE_VTT = re.compile(r"(?:(\d{2,3}):)?([0-5]\d):([0-5]\d)\.([0-9]{3})", re.ASCII)

# VTT formatting/voice/timestamp tags, e.g. <i>, </i>, <b>, <c.loud>, <v Speaker Name>,
# <00:00:01.000> — strip these before counting characters or judging reading speed,
# since they're markup a viewer never reads on screen.
# Only real caption markup: WebVTT <c.x>, <i>, <b>, <u>, <v Speaker>, <lang xx>, <ruby>, <rt>,
# timestamp tags like <00:00:01.000>, and SRT's <font ...>. A bare "<" or ">" in the text
# (e.g. "< 30°C and > 10 bar") is visible text and must be counted.
TAG_RE = re.compile(
    r"</?(?:[ibu]|c(?:\.[^\s>]+)*|v(?:[ \t][^>]*)?|lang(?:[ \t][^>]*)?|ruby|rt|font(?:[ \t][^>]*)?)>"
    r"|<(?:\d{2,3}:)?\d{2}:\d{2}\.\d{3}>",
    re.ASCII | re.IGNORECASE,
)
# Anything that looks like a cue timing line: a timestamp, or an arrow of any shape.
CLOCK_RE = re.compile(r"\d+:\d+", re.ASCII)
ARROW_RE = re.compile(r"[-=~]+>|\u2192")
TEXT_CONTROL_RE = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]")


# WebVTT cue settings (W3C WebVTT, cue settings): vertical, line, position, size, align, region.
_NUM = r"\d+(?:\.\d+)?"
VTT_SETTING_RE = re.compile(
    r"vertical:(?:rl|lr)"
    r"|line:(?:-?" + _NUM + r"%?)(?:,(?:start|center|end))?"
    r"|position:" + _NUM + r"%(?:,(?:line-left|center|line-right))?"
    r"|size:" + _NUM + r"%"
    r"|align:(?:start|center|end|left|right)"
    r"|region:[^\s]+",
    re.ASCII,
)


def setting_problems(fields):
    """Semantic checks on WebVTT cue settings that already match VTT_SETTING_RE:
    percentages must be 0-100, a line number without % must be an integer, and
    no setting may appear twice (players silently ignore invalid settings)."""
    out, seen = [], set()
    for f in fields:
        name, _, value = f.partition(":")
        if name in seen:
            out.append(f"cue setting '{name}' appears more than once")
        seen.add(name)
        main = value.split(",")[0]
        if main.endswith("%"):
            try:
                pct = float(main[:-1])
            except ValueError:
                out.append(f"cue setting '{f}' has an invalid percentage")
                continue
            if not 0 <= pct <= 100:
                out.append(f"cue setting '{f}' is outside 0-100%")
        elif name == "line" and not re.fullmatch(r"-?\d+", main):
            out.append(f"cue setting '{f}': a line number without % must be a whole number")
    return out


def looks_like_timing(line):
    """True for anything that reads like a cue timing line, well-formed or not:
    two clock times (00:01 ... 00:05), or one clock time next to an arrow of any shape."""
    clocks = len(CLOCK_RE.findall(line))
    return clocks >= 2 or (clocks >= 1 and bool(ARROW_RE.search(line)))


def strip_tags(line):
    return html.unescape(TAG_RE.sub("", line))


def parse_timecode(s, is_vtt):
    rx = TIME_RE_VTT if is_vtt else TIME_RE_SRT
    m = rx.fullmatch(s.strip(" \t"))
    if not m:
        return None
    if is_vtt:
        h_s, mnt_s, sec_s, ms_s = m.groups()
        h = int(h_s) if h_s else 0
        mnt, sec, ms = int(mnt_s), int(sec_s), int(ms_s)
    else:
        h, mnt, sec, ms = (int(x) for x in m.groups())
    return h * 3600 + mnt * 60 + sec + ms / 1000.0


def parse_cues(text, is_vtt):
    """Return cue dicts and errors for every non-cue, non-metadata block."""
    cues = []
    problems = []
    seen_cue = False
    # Line boundaries are CR, LF or CRLF only (WebVTT spec); Unicode separators stay inside a line.
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    blocks = re.split(r"\n[ \t]*\n(?:[ \t]*\n)*", text.strip("\n \t"))
    for block_number, block in enumerate(blocks, start=1):
        lines = [l for l in re.split(r"\r\n|\r|\n", block) if l.strip(" \t") != ""]
        if not lines:
            continue
        if is_vtt:
            first = lines[0]
            if block_number == 1:
                if not re.fullmatch(r"WEBVTT(?:[ \t].*)?", first):
                    problems.append("missing or malformed WEBVTT header")
                if "-->" in block:
                    problems.append("missing blank line after WEBVTT header")
                # Header text may not hold a cue. A timestamp or arrow in the header means a
                # missing blank line or a malformed timing line, so the cue would be skipped.
                elif any(looks_like_timing(re.sub(r"^WEBVTT", "", line)) for line in lines):
                    problems.append("timing-like line inside the WEBVTT header (missing blank line or malformed arrow)")
                continue
            # Timing takes priority: even NOTE, STYLE and REGION can name a cue.
            if any("-->" in line for line in lines[:2]):
                seen_cue = True
            elif not any("-->" in line for line in lines):
                is_note = bool(re.match(r"NOTE(?:[ \t]|$)", first))
                if (is_note or first in {"STYLE", "REGION"}) and any(looks_like_timing(l) for l in lines):
                    # A metadata block can't hold a cue; a timing-like line here is a broken cue.
                    problems.append(f"block {block_number}: timing-like line inside a {first.split()[0]} block (malformed cue)")
                    continue
                if is_note:
                    continue
                if first in {"STYLE", "REGION"}:
                    if seen_cue:
                        problems.append(f"block {block_number}: {first} block after a cue")
                    continue
        # VTT identifiers are optional and may be any text. SRT requires an index.
        idx = None
        if not is_vtt:
            if not re.fullmatch(r"[0-9]+", lines[0].strip()):
                problems.append(f"block {block_number}: missing or malformed cue index")
                continue
            idx = lines[0].strip()
            lines = lines[1:]
        elif "-->" not in lines[0]:
            idx = lines[0].strip()
            if looks_like_timing(idx):
                problems.append(f"block {block_number}: cue identifier looks like a broken timing line")
                continue
            lines = lines[1:]
        if not lines or "-->" not in lines[0]:
            problems.append(f"block {block_number}: missing or malformed timing line")
            continue
        time_line = lines[0]
        text_lines = lines[1:]
        # Timing lines are plain ASCII: digits, ':', '.', ',', '-->', ASCII spaces/tabs and
        # cue settings. A non-breaking or other Unicode space (common after copy-paste from
        # rich text) makes players drop the cue, so flag it.
        if re.search(r"[^\x21-\x7e \t]", time_line):
            problems.append(f"block {block_number}: timing line contains an unusual character (e.g. a non-breaking space); retype it with plain spaces")
            continue
        parts = time_line.split("-->")
        if len(parts) != 2:
            problems.append(f"block {block_number}: malformed timing line (expected one -->)")
            continue
        # The arrow must have a space or tab on both sides (WebVTT spec; the SRT convention too).
        if not re.search(r"[ \t]-->[ \t]", time_line):
            problems.append(f"block {block_number}: timing line needs a space on both sides of -->")
        start = parse_timecode(parts[0], is_vtt)
        # VTT timing lines can carry cue settings after the end time; keep only the timecode token.
        end_fields = [f for f in re.split(r"[ \t]+", parts[1].strip(" \t")) if f]
        end_token = end_fields[0] if end_fields else ""
        extra = end_fields[1:]
        if extra and (not is_vtt or not all(VTT_SETTING_RE.fullmatch(f) for f in extra)):
            problems.append(f"block {block_number}: unexpected text or an unknown cue setting after the end time")
        elif extra:
            problems.extend(f"block {block_number}: {msg}" for msg in setting_problems(extra))
        end = parse_timecode(end_token, is_vtt)
        if not text_lines:
            problems.append(f"block {block_number}: cue has no text")
        elif any("-->" in l or (ARROW_RE.search(l) and CLOCK_RE.search(l)) for l in text_lines):
            problems.append(f"block {block_number}: a second timing line inside the cue text")
        # Check raw text before tag stripping can hide an invalid character.
        if any(TEXT_CONTROL_RE.search(line) for line in text_lines):
            problems.append(f"block {block_number}: cue text contains an ASCII control character; remove it")
        cues.append({"index": idx, "start": start, "end": end, "lines": text_lines})
    return cues, problems


def check(cues, max_chars_per_line, max_lines, max_cps):
    problems = []
    prev_end = None
    prev_ref = None
    for i, cue in enumerate(cues, start=1):
        ref = cue["index"] or str(i)
        if cue["start"] is None or cue["end"] is None:
            problems.append(f"cue {ref}: unparsable timecode")
            continue
        if cue["end"] <= cue["start"]:
            problems.append(f"cue {ref}: end time ({cue['end']:.3f}s) is at or before start time ({cue['start']:.3f}s)")
        if prev_end is not None and cue["start"] < prev_end:
            problems.append(f"cue {ref}: overlaps previous cue {prev_ref} (starts at {cue['start']:.3f}s, previous ends at {prev_end:.3f}s)")
        if len(cue["lines"]) > max_lines:
            problems.append(f"cue {ref}: {len(cue['lines'])} lines, max is {max_lines}")
        stripped_lines = [strip_tags(l) for l in cue["lines"]]
        for line in stripped_lines:
            if len(line) > max_chars_per_line:
                problems.append(f"cue {ref}: line has {len(line)} characters, max is {max_chars_per_line}: {line!r}")
        duration = cue["end"] - cue["start"] if (cue["end"] is not None and cue["start"] is not None) else 0
        char_count = sum(len(l) for l in stripped_lines)
        if duration > 0 and char_count > 0:
            cps = char_count / duration
            if cps > max_cps:
                problems.append(f"cue {ref}: reading speed {cps:.1f} chars/sec exceeds max {max_cps} ({char_count} chars in {duration:.2f}s)")
        prev_end = cue["end"]
        prev_ref = ref
    return problems


def lint_text(text, is_vtt, max_chars_per_line=42, max_lines=2, max_cps=20):
    cues, problems = parse_cues(text, is_vtt)
    if not cues:
        return problems or ["no cues found — file may be empty or unparsable"]
    return problems + check(cues, max_chars_per_line, max_lines, max_cps)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("file")
    ap.add_argument("--max-chars-per-line", type=int, default=42)
    ap.add_argument("--max-lines", type=int, default=2)
    ap.add_argument("--max-cps", type=float, default=20)
    args = ap.parse_args()

    try:
        # utf-8-sig transparently strips a leading BOM if present, and reads plain
        # UTF-8 unchanged if not — safe for both cases with one encoding name.
        with open(args.file, encoding="utf-8-sig") as f:
            text = f.read()
    except OSError as e:
        print(f"FAIL: could not read {args.file}: {e}")
        sys.exit(1)
    except UnicodeDecodeError as e:
        print(f"FAIL: {args.file} is not valid UTF-8: {e}")
        sys.exit(1)

    filename = args.file.lower()
    is_vtt = filename.endswith(".vtt") or (
        not filename.endswith(".srt") and text.strip().upper().startswith("WEBVTT")
    )
    problems = lint_text(text, is_vtt, args.max_chars_per_line, args.max_lines, args.max_cps)

    if problems:
        for p in problems:
            print("FAIL:", p)
        print(f"RESULT: FAIL ({len(problems)} problem(s))")
        sys.exit(1)
    print("RESULT: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
