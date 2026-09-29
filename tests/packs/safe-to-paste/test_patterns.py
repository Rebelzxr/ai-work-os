#!/usr/bin/env python3
"""Deterministic regex test for the safe-to-paste skill's claimed detection patterns.
The three regexes below are hand-copied from SKILL.md's "Deterministic patterns this
skill's test checks for" section (not parsed out of that file at runtime) and must be
kept in sync with it by hand. They are asserted against a known-sensitive sample built
from obviously-fake test values (not real IC/phone/bank numbers) and must not match
harmless text. Exits 1 on any failure so this can fail for real, not just report."""
import re
import sys

IC_RE = re.compile(r"\d{6}-\d{2}-\d{4}")
PHONE_RE = re.compile(r"01\d[- ]?\d{3,4}[- ]?\d{4}")
BANK_RE = re.compile(r"(?<!\d)\d{10,16}(?!\d)")

SENSITIVE_SAMPLE = (
    "Customer Ahmad Bin Ismail, IC 000000-00-0000, phone 019-0000000, "
    "wants a quote. His maintenance bank account for refund is 0000000000000."
)

HARMLESS_SAMPLE = (
    "Deep cleaning is RM180-250 depending on size. We are open 9am-6pm, "
    "closed Sundays. Please bring your own bucket."
)

failures = []

if not IC_RE.search(SENSITIVE_SAMPLE):
    failures.append("IC regex failed to match a Malaysian-IC-shaped fake value in the sensitive sample")
if not PHONE_RE.search(SENSITIVE_SAMPLE):
    failures.append("Phone regex failed to match a local-phone-shaped fake value in the sensitive sample")
if not BANK_RE.search(SENSITIVE_SAMPLE):
    failures.append("Bank/account regex failed to match a 13-digit fake account number in the sensitive sample")

if IC_RE.search(HARMLESS_SAMPLE):
    failures.append("IC regex false-positived on harmless text")
if PHONE_RE.search(HARMLESS_SAMPLE):
    failures.append("Phone regex false-positived on harmless text")
if BANK_RE.search(HARMLESS_SAMPLE):
    failures.append("Bank regex false-positived on harmless text")

if failures:
    for f in failures:
        print("FAIL:", f)
    sys.exit(1)

print("PASS: safe-to-paste regex patterns matched sensitive sample and spared harmless text")
sys.exit(0)
