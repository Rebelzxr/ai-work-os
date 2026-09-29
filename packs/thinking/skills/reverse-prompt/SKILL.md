---
name: reverse-prompt
description: "Before starting a build request, ask a short round of targeted clarifying questions instead of guessing the ambiguous parts. Use for non-trivial build requests; skip when the ask already says 'just do it' or is a small, unambiguous fix."
---

# Reverse prompt

Clean-room skill: asking clarifying questions before building is a widely-used pattern across many independent tools and write-ups (not a single source), assembled here as its own step rather than folded silently into the build.

The name comes from working backward from the ambiguity in a request to the specific questions that would resolve it, before spending effort building the wrong thing.

## When to use

Non-trivial build requests: a new feature, script, skill, refactor, or integration where more than one reasonable interpretation exists. Skip it when the requester has said "just do it," the fix is under a handful of lines, or it's a pure config change with one obvious answer.

## Steps

1. Read the request and list every place it could reasonably mean two different things (scope, format, audience, what "done" looks like, what happens on an edge case).
2. Turn each ambiguity into one specific, answerable question — not "what do you want?" but "should X include Y, or only Z?"
3. Ask them together, in one round, not one at a time. Two or three targeted questions beat a dozen vague ones.
4. If the requester says "your call" or doesn't answer, make the smallest reasonable assumption, state it plainly in the output, and proceed — don't block on a question nobody wants to answer.

## Worked example

Request: "add a search bar to the dashboard."
Ambiguities: search over what (all records, or just the current tab)? Live-filter or submit-to-search? Should it persist across page reloads?
Questions asked together: "Should search cover every record or just what's on the current tab? And should results filter as you type, or only after pressing enter?"

## Failure modes

- Do not ask a question the request already answered — re-reading first prevents this.
- Do not ask more than a handful of questions in one round; that pushes the cost back onto the requester instead of removing it.
- Silence on a question is not permission to guess the highest-effort interpretation — default to the smaller, safer build and say so.
