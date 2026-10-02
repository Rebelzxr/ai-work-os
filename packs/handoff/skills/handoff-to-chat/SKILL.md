---
name: handoff-to-chat
description: "Make a compact, redacted brief for a chat AI with a fixed answer format that can be checked locally."
---

# Handoff to a chat AI

Prepare the smallest useful brief for a chat AI that cannot inspect the workspace. Include only the context needed for the requested answer, label invented examples, and make the returned answer easy to bring back for local checking.

## Read first

- Read the core [handoff](../../../core/skills/handoff/SKILL.md) skill in the default `aiwos-core` pack for self-contained continuation notes. This dependency is not optional in the default setup.
- Read [docs/multi-agent.md](../../../../docs/multi-agent.md) and the shared `AGENTS.md`.
- Read the named source files locally before selecting any context to paste.

## Procedure

1. State the objective in one sentence.
2. List only the source facts needed to answer it, with a path and date for each fact. Separate facts, assumptions and questions.
3. Remove names, phone numbers, email addresses, tokens, account identifiers, private client details and unrelated history. Use labels such as `[PHONE REDACTED]` and `[TOKEN REDACTED]` when showing why a field was removed.
4. Give the chat AI a clear boundary: use only the supplied context, do not invent facts or outcomes, and say what is missing.
5. Add the fixed block below to the end of the brief:

   ```text
   ANSWER IN THIS FORMAT
   STATUS: VERIFIED | UNVERIFIED | BROKEN
   ANSWER: [short answer or draft]
   SOURCES USED: [source labels from this brief]
   ASSUMPTIONS: [none, or a labelled list]
   MISSING OR UNCHECKED: [none, or a labelled list]
   NEXT CHECK: [one local check a person can run]
   ```

6. Keep the final brief short enough to paste without carrying private history. Say what must be checked locally when the answer returns.

## Return shape

Return one copy-paste brief, followed by a private preparation note listing the local source paths that were used. The note is for the owner, not for the chat AI.

## Common stops

- The answer cannot be grounded in the supplied sources.
- Redaction would remove a fact that changes the result; ask the owner to provide a safe replacement.
- The request asks the chat AI to inspect local files or claim a live result it cannot see.
- The brief contains a secret, token, customer detail or direct contact information.

## Human approval

This skill prepares a brief and does not transmit it. A person decides where to paste it. A person also approves any send, post, publish, deploy, pay or delete action that appears in a returned draft.

## Shared foundation

Use the core [handoff](../../../core/skills/handoff/SKILL.md) and [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) skills in the default `aiwos-core` pack for self-contained context and checking the returned answer. These dependencies are not optional in the default setup. Do not copy the full core skill into the chat brief.
