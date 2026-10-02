# Copy-paste edition

## What to give it

- The question or small outcome: `[OBJECTIVE]`
- Cleaned source facts with labels and dates: `[FACTS]`
- The answer shape wanted: `[OUTPUT_SHAPE]`
- Any known limits or missing facts: `[LIMITS]`
- No names, phone numbers, emails, tokens, account identifiers or private customer details

## The prompt

```text
Answer this small, bounded question using only the supplied context.

OBJECTIVE: [OBJECTIVE]
FACTS:
[FACTS]
OUTPUT SHAPE: [OUTPUT_SHAPE]
LIMITS: [LIMITS]

Do not invent facts, contacts, prices, results or completed actions. Separate supplied facts from assumptions. If the context is not enough, say what is missing. Keep the answer useful and short.

ANSWER IN THIS FORMAT
STATUS: VERIFIED | UNVERIFIED | BROKEN
ANSWER: [short answer or draft]
SOURCES USED: [fact labels]
ASSUMPTIONS: [none, or a labelled list]
MISSING OR UNCHECKED: [none, or a labelled list]
NEXT CHECK: [one local check a person can run]
```

## What you get back

A compact answer with its source labels, assumptions, missing proof and one local next check.

## Check before you use it

- Confirm every fact was cleaned locally before it entered the brief.
- Check the returned answer against the original source files.
- Treat any claim of a live outcome as unchecked unless local evidence proves it.
- Keep the answer as a draft until the owner reviews it.

## Next job

Bring the answer back to the workspace and use `verify-return` in the default `aiwos-handoff` pack or the core `evidence-loop` in the default `aiwos-core` pack before relying on it.
