---
name: handoff-to-claude
description: "Create a bounded AIW-OS work order for Claude Code and show a safe, exact command or fresh-session brief."
---

# Handoff to Claude Code

Prepare one self-contained work order for Claude Code. The packet is the source of truth; the current chat is not part of the receiver's context. This skill prepares the packet and command but does not run Claude Code.

## Read first

- Read the core [job-packet](../../../core/skills/job-packet/SKILL.md) skill in the default `aiwos-core` pack and extend it rather than copying it. This dependency is not optional in the default setup.
- Read [docs/multi-agent.md](../../../../docs/multi-agent.md) and the shared `AGENTS.md`.
- Check `dispatch/LOCKS.md`, the target files and the owning lane before writing a packet.

## Required input

Use the exact workspace, objective, input paths, allowed write paths, acceptance checks, evidence to return and stop conditions. If a required field is unknown, ask for it or stop. A plausible detail is not a supplied fact.

## Procedure

1. Give the job a unique `JOB_ID` and a short `LANE`.
2. Write `dispatch/inbox/<lane>/<JOB_ID>.md` with `JOB_ID`, `LANE`, `OWNER: builder`, `WORKSPACE`, `OBJECTIVE`, `INPUTS`, `ALLOWED_WRITES`, `ACCEPTANCE`, `EVIDENCE` and `STOP_IF`.
3. Include the receipt path in `ALLOWED_WRITES` if the receiving session must write one.
4. Show this command with the placeholders replaced by approved paths:

   ```bash
   (cd "[WORKSPACE]" && claude -p "Read dispatch/inbox/[LANE]/[JOB_ID].md. Follow its allowed writes and stop conditions. Write the receipt at dispatch/receipts/[JOB_ID].receipt.md.")
   ```

5. Also give a fresh-session version: open Claude Code at `[WORKSPACE]`, then paste `Read dispatch/inbox/[LANE]/[JOB_ID].md and execute only that packet.` A fresh interactive session may be preferable when the receiver needs to inspect local files step by step.

6. State that `-p/--print` is the non-interactive route checked in local help. Do not add permission-bypass options to make a packet fit.

## Return shape

Return the packet path, the exact `claude -p` command, the fresh-session instruction, the allowed files, the checks and the stop conditions. State that no Claude job was run by this skill.

## Common stops

- Missing acceptance criteria, a workspace, an input path or a receipt path.
- A live lock, a path outside the workspace or a request to edit an unlisted file.
- Private data, secrets, tokens or unredacted contacts in the packet or command.
- A request that depends on an account action or an external release.

## Human approval

This skill prepares a command or brief only. A person decides whether to run it. A person must approve any send, post, publish, deploy, pay or delete action, even if the receiver can technically perform it.

## Shared foundation

Use the core [job-packet](../../../core/skills/job-packet/SKILL.md) and [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) skills in the default `aiwos-core` pack for the packet contract and receipt proof. These dependencies are not optional in the default setup; add only Claude Code transport details here.
