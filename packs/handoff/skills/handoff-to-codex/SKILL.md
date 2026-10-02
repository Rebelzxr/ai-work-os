---
name: handoff-to-codex
description: "Create a bounded AIW-OS work order for Codex and show a safe, exact command for a person to run."
---

# Handoff to Codex

Turn a requested local outcome into a small work order that Codex can run without the surrounding chat. This skill prepares the packet and command; it does not run a Codex job.

## Read first

- Read the core [job-packet](../../../core/skills/job-packet/SKILL.md) skill in the default `aiwos-core` pack and extend it rather than copying it. This dependency is not optional in the default setup.
- Read [docs/multi-agent.md](../../../../docs/multi-agent.md) and the shared `AGENTS.md`.
- Check `dispatch/LOCKS.md` and the target files before choosing a writer.

## Required input

Ask for or locate the exact workspace, objective, input paths, allowed write paths, acceptance checks, evidence to return and stop conditions. If any of those change the scope and are missing, stop and ask. Do not fill gaps with guesses.

## Procedure

1. Give the job a unique `JOB_ID` and a short `LANE`.
2. Write `dispatch/inbox/<lane>/<JOB_ID>.md` with these fields: `JOB_ID`, `LANE`, `OWNER: builder`, `WORKSPACE`, `OBJECTIVE`, `INPUTS`, `ALLOWED_WRITES`, `ACCEPTANCE`, `EVIDENCE` and `STOP_IF`.
3. Include the receipt path in `ALLOWED_WRITES` when the receiver is expected to write a receipt, and also `dispatch/receipts/<JOB_ID>.codex-output.md`, the file the command's `-o` flag writes (Codex's final message), so verify-return does not flag it as an unexpected change. Keep paths exact; do not use a broad folder when a file will do.
4. Show this command with the placeholders replaced by the real, approved paths:

   ```bash
   codex exec -C "[WORKSPACE]" -s workspace-write -o "[WORKSPACE]/dispatch/receipts/[JOB_ID].codex-output.md" "Read [WORKSPACE]/dispatch/inbox/[LANE]/[JOB_ID].md. Follow its allowed writes and stop conditions. Write the receipt at [WORKSPACE]/dispatch/receipts/[JOB_ID].receipt.md."
   ```

5. Tell the person whether the command needs `workspace-write`, a narrower sandbox, or a real non-Git exception. Do not add `--skip-git-repo-check` unless the selected workspace is actually outside Git. Add `--search` only when the packet explicitly calls for public live research.

## Return shape

Return the packet path, the exact command, the files the receiver may change, the acceptance checks, and the one condition that would make the receiver stop. State that the command has not been run.

## Common stops

- Missing acceptance criteria, workspace or input paths.
- A path that is outside the stated workspace or overlaps a live lock.
- A brief containing a secret, token, customer record or unredacted contact detail.
- A request that needs a public release, account change, payment or other human decision.

## Human approval

This skill only prepares a command. A person decides whether to run it. A person also approves any send, post, publish, deploy, pay or delete action; the packet cannot grant that approval.

## Shared foundation

Use the core [job-packet](../../../core/skills/job-packet/SKILL.md) and [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) skills in the default `aiwos-core` pack for packet fields and proof. These dependencies are not optional in the default setup; this skill adds Codex command details only.
