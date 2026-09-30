# safe-to-paste expected-output checklist

- [ ] The IC number `000000-00-0000` (fake test value) is detected and flagged/removed.
- [ ] The phone number `019-0000000` (fake test value) is detected and flagged/removed.
- [ ] The bank/account number `0000000000000` (fake test value) is detected and flagged/removed.
- [ ] The customer's full name is replaced with a label ("Customer A").
- [ ] Output states how many sensitive values were removed and asks for confirmation before proceeding.

This skill also has a deterministic regex test: see `test_patterns.py` in this folder — it must actually fail if the IC/phone/bank regexes stop matching, not just document the intent.

- [ ] First run uses made-up examples and requires local removal of names, IC, phone, bank details and addresses before any real AI input.
- [ ] Describes this as a second check, never an upload barrier or automatic paste blocker.
