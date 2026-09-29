---
name: onboard
description: "A short interview that fills the <angle brackets> in AGENTS.md and the first outcome row on memory/TODO.md. Use once, when a workspace is new, or when the user says \"onboard\", \"set me up\" or \"fill in AGENTS.md\". Asks one question at a time and shows a diff before writing."
---

# Onboard

Turns the placeholder workspace `setup.sh` copied into one filled-in AGENTS.md and one real first outcome. Five to seven short questions, one at a time. No hand-editing angle brackets.

## Rules first

- **Workspace only.** Only write inside the workspace this skill was run from (the folder holding this `AGENTS.md`). Refuse to write anywhere else, including a parent folder, `$HOME` directly, or another project's files. If asked to write outside the workspace, say so and stop. Before writing, check the target path with `<this skill's folder>/scripts/guard_workspace.py <workspace_root> <candidate_path>` — a non-zero exit means refuse and explain why.
- **One question at a time.** Do not dump the whole list at once. Wait for each answer before asking the next question.
- **Diff before write.** Once every answer is in, show the exact before/after text for each file (a unified diff or a clear before/after block) and ask for a yes before writing anything.
- **No invention.** If the user skips a question, leave that placeholder in place rather than guessing a value. Say plainly which placeholders are still open.
- **Idempotent.** Running this again on an already-filled AGENTS.md only changes the rows it's asked to change; it never blanks a filled-in field back to a placeholder without being told to.

## The interview

Ask these in order, one at a time, in plain language:

1. Your name (fills `<your name>` in AGENTS.md §1).
2. What this workspace is for, in one line (used for the AGENTS.md heading comment or a one-line note, if the template has one).
3. Which agent plans and writes for you, and which one builds/codes (fills the "Planner agent" / "Builder agent" row if the user's setup differs from the default Claude/Codex split).
4. Today's one outcome — the single thing that matters most right now (fills `<one outcome>` under "Context for next session" in `memory/TODO.md`).
5. Anything only you can decide right now (fills `<decisions only you can make>`).
6. Any external blocker you're waiting on (fills `<external blockers>`).
7. Name for the first active lane (fills `<Lane one>` — a short noun phrase, e.g. "Client work" or "Product launch").

## Writing the files

After the diff is approved:

- `AGENTS.md`: replace only the `<angle brackets>` the interview covered. Leave every other placeholder and all rule text untouched.
- `memory/TODO.md`: fill the "Context for next session" three lines and rename `<Lane one>` to the given name. Do not touch `<Lane two>` unless the user gave a second lane name. Leave the example outcome row as an example, or replace it with the real first outcome row if the user gave one.

## After writing

Tell the user what changed, which placeholders (if any) are still open, and suggest their next step is asking "what now".
