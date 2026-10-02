# Copy-paste edition

## What to give it

- The artifact or a cleaned copy: `[ARTIFACT]`
- Acceptance criteria: `[CRITERIA]`
- Fresh evidence and result lines: `[EVIDENCE]`
- Known limits: `[LIMITS]`
- A model or provider different from the producer

## The prompt

```text
Review the supplied artifact as a read-only independent reviewer.

ARTIFACT:
[ARTIFACT]

ACCEPTANCE CRITERIA:
[CRITERIA]

EVIDENCE:
[EVIDENCE]

LIMITS:
[LIMITS]

Do not edit files. Judge only what the artifact, criteria and evidence support. Do not use the producer's chat history and do not fill gaps with guesses.

Return exactly:
VERDICT: PASS or FIX
REASONS: [numbered reasons tied to the criteria]
EVIDENCE CHECK: [what is proved and what is not]
FIXES: [specific changes, or NONE]
NEXT CHECK: [one command or inspection]
```

## What you get back

A read-only `PASS` or `FIX` verdict, reasons tied to the criteria, evidence gaps and one next check.

## Check before you use it

- Confirm the reviewer is different from the producer.
- Remove private history, secrets, tokens and unrelated files.
- Check that the evidence is fresh for the artifact being judged.
- Inspect every `FIX` reason before deciding what to change.

## Next job

Record the review beside the job evidence. If it says `FIX`, repair and run `verify-return` in the default `aiwos-handoff` pack again; if it says `PASS`, keep the human release gate separate.
