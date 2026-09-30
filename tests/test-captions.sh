#!/usr/bin/env bash
# Unit tests for the portable video-brief caption checker: must-pass and must-fail
# SRT/VTT fixtures under tests/video/, same style as tests/test-hooks.sh.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$HERE/packs/video/skills/video-brief/scripts/check-captions.py"
FIX="$HERE/tests/video"
pass=0; fail=0

ok() { # expected-exit, file, label
  local want="$1" file="$2" label="$3" got
  python3 "$SCRIPT" "$file" >/dev/null 2>&1
  got=$?
  if [ "$got" = "$want" ]; then pass=$((pass+1)); echo "PASS: $label"; else fail=$((fail+1)); echo "FAIL (want exit $want, got $got): $label"; fi
}

# --- must pass (exit 0) ---
ok 0 "$FIX/must-pass.srt" "clean SRT passes"
ok 0 "$FIX/must-pass.vtt" "clean VTT passes"
ok 0 "$FIX/must-pass-vtt-mmss.vtt" "Whisper-style VTT with mm:ss.ttt (hours omitted) passes"
ok 0 "$FIX/must-pass-vtt-tags.vtt" "VTT with <i>/<v> tags passes once tags are stripped before counting"
ok 0 "$FIX/must-pass-vtt-entities.vtt" "VTT character references count as decoded text"
ok 0 "$FIX/must-pass-vtt-metadata.vtt" "VTT header, NOTE, STYLE and REGION blocks are allowed"
ok 0 "$FIX/must-pass-long-hours.srt" "SRT hours may exceed two digits"

# --- must fail (exit 1) ---
ok 1 "$FIX/must-fail-overlap.srt" "overlapping cues fail"
ok 1 "$FIX/must-fail-end-before-start.srt" "end-before-start fails"
ok 1 "$FIX/must-fail-too-many-chars.srt" "too many characters per line fails"
ok 1 "$FIX/must-fail-too-many-lines.srt" "too many lines in one cue fails"
ok 1 "$FIX/must-fail-reading-speed.vtt" "reading speed too fast fails"
ok 1 "$FIX/must-fail-bom-too-many-chars.srt" "BOM SRT whose first cue breaks the char limit fails"
ok 1 "$FIX/must-fail-vtt-identified-too-many-chars.vtt" "VTT cue with a text identifier still gets checked and fails"
ok 1 "$FIX/must-fail-invalid-bytes.srt" "invalid-byte file fails cleanly (no traceback)"
ok 1 "$FIX/must-fail-bad-arrow.srt" "bad arrow after a valid cue fails"
ok 1 "$FIX/must-fail-invalid-seconds.srt" "seconds above 59 fail"
ok 1 "$FIX/must-fail-no-timing.srt" "text block with no timing after a valid cue fails"
ok 1 "$FIX/must-fail-invalid-minutes.vtt" "VTT minutes above 59 fail"
ok 1 "$FIX/must-fail-invalid-milliseconds.vtt" "VTT milliseconds must have exactly three digits"
ok 1 "$FIX/must-fail-garbled-timing.vtt" "garbled VTT timing after a valid cue fails"

# --- content checks: the right problem is actually named, not just any failure ---
check_contains() { # file, needle, label
  local file="$1" needle="$2" label="$3" out
  out="$(python3 "$SCRIPT" "$file" 2>&1)"
  if printf '%s' "$out" | grep -qi "$needle"; then
    pass=$((pass+1)); echo "PASS: $label"
  else
    fail=$((fail+1)); echo "FAIL: $label"
  fi
}
check_contains "$FIX/must-fail-overlap.srt" "overlaps" "overlap fixture names the overlap"
check_contains "$FIX/must-fail-end-before-start.srt" "end time" "end-before-start fixture names the timing problem"
check_contains "$FIX/must-fail-too-many-chars.srt" "characters" "too-many-chars fixture names the character limit"
check_contains "$FIX/must-fail-too-many-lines.srt" "lines" "too-many-lines fixture names the line limit"
check_contains "$FIX/must-fail-reading-speed.vtt" "reading speed" "reading-speed fixture names the reading-speed problem"
check_contains "$FIX/must-fail-bom-too-many-chars.srt" "characters" "BOM fixture names the character limit (BOM was stripped, not left in the text)"
check_contains "$FIX/must-fail-vtt-identified-too-many-chars.vtt" "characters" "identified VTT cue fixture names the character limit"
check_contains "$FIX/must-fail-invalid-bytes.srt" "not valid UTF-8" "invalid-byte fixture reports a clean decode error, not a traceback"
check_contains "$FIX/must-fail-bad-arrow.srt" "block 2: missing or malformed timing line" "bad arrow is reported rather than skipped"
check_contains "$FIX/must-fail-invalid-seconds.srt" "unparsable timecode" "invalid seconds name the timecode problem"
check_contains "$FIX/must-fail-no-timing.srt" "block 2: missing or malformed cue index" "untimed text is reported rather than skipped"
check_contains "$FIX/must-fail-invalid-minutes.vtt" "unparsable timecode" "invalid minutes name the timecode problem"
check_contains "$FIX/must-fail-invalid-milliseconds.vtt" "unparsable timecode" "invalid milliseconds name the timecode problem"
check_contains "$FIX/must-fail-garbled-timing.vtt" "unparsable timecode" "garbled VTT timecode is reported"

# --- block classification regressions ---
ok 0 "$FIX/must-pass-vtt-style-and-note.vtt" "STYLE before cues and NOTE between cues pass"
ok 1 "$FIX/must-fail-vtt-header-no-blank.vtt" "header without a blank line fails"
check_contains "$FIX/must-fail-vtt-header-no-blank.vtt" "missing blank line after WEBVTT header" "header without a blank line fails: diagnostic"
ok 1 "$FIX/must-fail-vtt-header-malformed-arrow.vtt" "header followed by a malformed timing line and an over-long cue fails"
check_contains "$FIX/must-fail-vtt-header-malformed-arrow.vtt" "timing-like line inside the WEBVTT header" "malformed arrow in header: diagnostic"
ok 0 "$FIX/must-pass-vtt-header-metadata.vtt" "WEBVTT header with Kind/Language lines passes"
ok 1 "$FIX/must-fail-vtt-header-other-arrow.vtt" "header followed by a => timing line and an over-long cue fails"
ok 1 "$FIX/must-fail-vtt-style-malformed-cue.vtt" "STYLE block hiding a malformed cue fails"
ok 1 "$FIX/must-fail-vtt-region-malformed-cue.vtt" "REGION block hiding a malformed cue fails"
ok 1 "$FIX/must-fail-srt-timing-as-text.srt" "a second timing line used as caption text fails"
ok 0 "$FIX/must-pass-vtt-times-in-text.vtt" "clock times inside caption text and a NOTE still pass"
ok 1 "$FIX/must-fail-vtt-unicode-line-separator.vtt" "a Unicode line separator does not count as a caption line"
ok 1 "$FIX/must-fail-vtt-timing-on-header-line.vtt" "timing text on the WEBVTT line itself fails"
ok 1 "$FIX/must-fail-vtt-note-unpadded-arrow.vtt" "unpadded => timing inside a NOTE block fails"
ok 1 "$FIX/must-fail-vtt-trailing-timing.vtt" "extra timing text after the end time fails"
ok 1 "$FIX/must-fail-srt-text-arrow-timing.srt" "a => timing line used as SRT caption text fails"
ok 1 "$FIX/must-fail-srt-huge-hours.srt" "an absurd hours value fails cleanly instead of crashing"
ok 0 "$FIX/must-pass-vtt-cue-settings.vtt" "WebVTT cue settings after the end time pass"
ok 1 "$FIX/must-fail-vtt-arrow-no-spaces.vtt" "WebVTT timing with no spaces around --> fails"
ok 1 "$FIX/must-fail-srt-arrow-no-spaces.srt" "SRT timing with no spaces around --> fails"
ok 1 "$FIX/must-fail-vtt-unknown-setting.vtt" "an unknown or invalid cue setting value fails"
ok 1 "$FIX/must-fail-vtt-identifier-timing.vtt" "a cue identifier that is really a broken timing line fails"
ok 0 "$FIX/must-pass-vtt-all-settings.vtt" "every valid WebVTT cue setting passes"
ok 1 "$FIX/must-fail-vtt-setting-size-150pct.vtt" "size over 100% fails"
ok 1 "$FIX/must-fail-vtt-setting-position-101pct.vtt" "position over 100% fails"
ok 1 "$FIX/must-fail-vtt-setting-line-negative-pct.vtt" "a negative line percentage fails"
ok 1 "$FIX/must-fail-vtt-setting-line-decimal.vtt" "a line number that is not a whole number fails"
ok 1 "$FIX/must-fail-vtt-setting-duplicate-align.vtt" "a repeated cue setting fails"
ok 0 "$FIX/must-pass-vtt-setting-edges.vtt" "edge values (0%, 100%, negative whole line numbers) pass"
ok 1 "$FIX/must-fail-srt-lt-gt-text-too-long.srt" "plain < and > in caption text are counted, not stripped as tags (length)"
ok 1 "$FIX/must-fail-srt-lt-gt-text-too-fast.srt" "plain < and > in caption text are counted, not stripped as tags (reading speed)"
ok 0 "$FIX/must-pass-vtt-tags-still-stripped.vtt" "real caption tags (<v>, <i>, <c.x>, <b>, timestamps) are still stripped"
ok 1 "$FIX/must-fail-vtt-nbsp-before-end.vtt" "a non-breaking space before the end time fails"
ok 1 "$FIX/must-fail-vtt-nbsp-before-start.vtt" "a non-breaking space before the start time fails"
ok 1 "$FIX/must-fail-srt-nbsp-in-timing.srt" "a non-breaking space in an SRT timing line fails"
ok 0 "$FIX/must-pass-vtt-nbsp-in-text.vtt" "a non-breaking space inside caption text is fine"
ok 1 "$FIX/must-fail-vtt-missing-header.vtt" "VTT without its header fails"
check_contains "$FIX/must-fail-vtt-missing-header.vtt" "missing or malformed WEBVTT header" "VTT without its header fails: diagnostic"
ok 1 "$FIX/must-fail-vtt-style-prefix.vtt" "STYLE prefix is not a metadata block"
check_contains "$FIX/must-fail-vtt-style-prefix.vtt" "missing or malformed timing line" "STYLE prefix is not a metadata block: diagnostic"
ok 1 "$FIX/must-fail-srt-missing-index.srt" "SRT cue without an index fails"
check_contains "$FIX/must-fail-srt-missing-index.srt" "missing or malformed cue index" "SRT cue without an index fails: diagnostic"
ok 1 "$FIX/must-fail-srt-metadata.srt" "SRT metadata block fails"
check_contains "$FIX/must-fail-srt-metadata.srt" "missing or malformed cue index" "SRT metadata block fails: diagnostic"
ok 1 "$FIX/must-fail-vtt-style-identifier.vtt" "STYLE cue identifier cannot hide an overlength line"
check_contains "$FIX/must-fail-vtt-style-identifier.vtt" "cue STYLE: line has 80 characters" "STYLE cue identifier cannot hide an overlength line: diagnostic"
ok 1 "$FIX/must-fail-vtt-region-identifier.vtt" "REGION cue identifier cannot hide an overlength line"
check_contains "$FIX/must-fail-vtt-region-identifier.vtt" "cue REGION: line has 80 characters" "REGION cue identifier cannot hide an overlength line: diagnostic"
ok 1 "$FIX/must-fail-vtt-note-identifier.vtt" "NOTE cue identifier cannot hide an overlength line"
check_contains "$FIX/must-fail-vtt-note-identifier.vtt" "cue NOTE: line has 80 characters" "NOTE cue identifier cannot hide an overlength line: diagnostic"
ok 1 "$FIX/must-fail-vtt-style-after-cue.vtt" "STYLE metadata after a cue fails"
check_contains "$FIX/must-fail-vtt-style-after-cue.vtt" "STYLE block after a cue" "STYLE metadata after a cue fails: diagnostic"
ok 1 "$FIX/must-fail-vtt-region-after-cue.vtt" "REGION metadata after a cue fails"
check_contains "$FIX/must-fail-vtt-region-after-cue.vtt" "REGION block after a cue" "REGION metadata after a cue fails: diagnostic"

ok 1 "$FIX/must-fail-srt-vtt-header.srt" "SRT extension cannot be overridden by a VTT header"
check_contains "$FIX/must-fail-srt-vtt-header.srt" "missing or malformed cue index" "SRT format bypass names the missing index"

ok 1 "$FIX/must-fail-srt-control-text.srt" "ASCII control characters in SRT text fail"
check_contains "$FIX/must-fail-srt-control-text.srt" "ASCII control character" "SRT controls name the text problem"
ok 1 "$FIX/must-fail-vtt-control-text.vtt" "ASCII controls inside VTT markup fail"
check_contains "$FIX/must-fail-vtt-control-text.vtt" "ASCII control character" "VTT controls name the text problem"
ok 0 "$FIX/must-pass-srt-text-whitespace.srt" "SRT tabs, CRLF and Unicode text pass"
ok 0 "$FIX/must-pass-vtt-text-whitespace.vtt" "VTT tabs, newlines and Unicode text pass"

TMP="$(mktemp -d)"
trap 'rm -r "$TMP"' EXIT
# Exercise every forbidden byte through the CLI, not only representative fixtures.
python3 - "$TMP" <<'PY'
import pathlib
import sys
root = pathlib.Path(sys.argv[1])
for code in [*range(9), 11, 12, *range(14, 32), 127]:
    (root / f"control-{code}.srt").write_text("1\n00:00:01,000 --> 00:00:05,000\nHi" + chr(code) + "there\n")
PY
for fixture in "$TMP"/control-*.srt; do
  ok 1 "$fixture" "rejects ${fixture##*/} in cue text"
done

# Only the skill folder is copied; no repository layout exists at the destination.
cp -R "$HERE/packs/video/skills/video-brief" "$TMP/installed video-brief"
SCRIPT="$TMP/installed video-brief/scripts/check-captions.py"
ok 0 "$FIX/must-pass.vtt" "standalone installed skill checker passes valid captions"
ok 1 "$FIX/must-fail-srt-control-text.srt" "standalone installed skill checker rejects controls"
SCRIPT="$HERE/packs/video/scripts/check-captions.py"
ok 0 "$FIX/must-pass.srt" "legacy repository entry point remains compatible"
ok 1 "$FIX/must-fail-srt-control-text.srt" "legacy entry point uses the current checker"

echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ] && exit 0 || exit 1
