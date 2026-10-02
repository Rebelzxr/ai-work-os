# Working with more than one AI tool

AIW-OS keeps several tools in one workspace by giving them the same rules, one writer for each file, and a proof loop that is independent of chat history.

## The shared rules file

Put the rules that apply to every tool in `AGENTS.md`. Claude Code enters through `CLAUDE.md`, which imports or points to the same rules. Codex reads `AGENTS.md` directly. A chat AI cannot read the local folder unless a person pastes a small, cleaned brief into that chat.

Keep private records, secrets, customer identifiers and account details out of a chat brief. Point an agent at an approved local file when the agent has permission to read it; do not paste the whole workspace just to give it context.

## One writer per file

Before work begins, read `dispatch/LOCKS.md`. The owner records one lease line with the lane, exact files, start time and expiry. A second agent must not edit a file covered by a live lease. If the lease is unclear or expired but the owner may still be active, stop and resolve ownership first.

The lock is a coordination note, not proof that work happened. The receipt and the changed files are the evidence.

## Work order to receipt to verification

Use this loop for a cross-tool job:

1. The person or current owner writes `dispatch/inbox/<lane>/<JOB_ID>.md` with the objective, exact inputs, allowed writes, acceptance checks, evidence to return and stop conditions.
2. The receiving tool reads the packet and the shared rules before touching a file. It stays inside `ALLOWED_WRITES`, records what it checked, and writes `dispatch/receipts/<JOB_ID>.receipt.md` with one honest `STATUS` line.
3. The sender opens the actual changed files and receipt, reruns the important checks, and compares the result with the packet. A returned “done” message is not proof.
4. When the work matters, a different model receives only the artifact and evidence for a read-only review. It returns `PASS` or `FIX` with reasons. The producer does not grade its own work.

The existing core `job-packet`, `handoff` and `evidence-loop` skills remain the shared foundation. The Handoff pack adds transport-specific packets and return checks; it does not copy those core templates. Use `receive-handoff` on the receiving side, `verify-return` on the sending side, and `cross-model-review` when an independent judgement is needed.

## Which job to use

| Need | Job | Main result |
|---|---|---|
| Give Codex a bounded local task | `handoff-to-codex` | Work order plus a person-runnable `codex exec` command |
| Give Claude Code the same kind of task | `handoff-to-claude` | Work order plus a person-runnable `claude -p` command or fresh-session brief |
| Give a chat AI a small context packet | `handoff-to-chat` | Redacted copy-paste brief and fixed answer format |
| Act as the receiving tool | `receive-handoff` | Scoped work and a receipt |
| Check another tool’s result | `verify-return` | File/test comparison and a verified status |
| Ask another model for a read-only opinion | `cross-model-review` | Scored `PASS` or `FIX` with reasons |
| Choose the week around a real bottleneck | `weekly-bottleneck-review` | Three outcomes, capacity-fit blocks, buffer and stop list |
| Pressure-test a material choice | `decision-stress-test` | Three options, what must be true and one reversible next step |

Use core `what-now` for the daily bottleneck. `weekly-bottleneck-review` links to it and adds a weekly capacity view; it does not replace the daily job.

## Boundaries

- A work order describes permission; it does not grant permission for anything outside its allowed files.
- A local draft is not a live result. A person keeps approval for anything that reaches a customer, changes an account, spends money, changes pricing, or removes shared data.
- The dangerous-command hook runs in Claude Code only today. Other tools still have to follow `AGENTS.md`; the absence of a hook is not extra permission.
- A chat AI cannot inspect local files, locks, tests or receipts on its own. Give it only the needed, cleaned context, then bring its answer back for local checking.
- Keep at most two production lanes and two helper agents per job. If two jobs need the same file, sequence them or split the file scope.

## CLI facts checked locally

Checked on 2026-10-02 with help output only; no model job was run.

```text
codex --version
codex-cli 0.154.0

claude --version
2.1.284 (Claude Code)
```

The following lines were present in the local help output:

```text
codex --help
exec              Run Codex non-interactively [aliases: e]
-s, --sandbox <SANDBOX_MODE>
-C, --cd <DIR>
--search          Enable live web search. When enabled, the native Responses `web_search` tool is available

codex exec --help
-s, --sandbox <SANDBOX_MODE>
-C, --cd <DIR>
--skip-git-repo-check
-o, --output-last-message <FILE>

claude --help
-p, --print       Print response and exit (useful for pipes).
```

`--search` was verified as a top-level Codex flag in `codex --help`. Use it only when the packet explicitly needs live research. `-C` selects the workspace, `-s` selects the sandbox, `-o` saves the last response, and `--skip-git-repo-check` is only for a real non-Git directory. Do not put secrets, tokens or customer data in any of these command arguments.

## A small handoff example

```text
JOB_ID: SITE-COPY-0007
LANE: site
OWNER: builder
WORKSPACE: [workspace path]
OBJECTIVE: Compare the supplied page copy with the approved brief and list mismatches.
INPUTS: docs/page-copy.md, docs/approved-brief.md
ALLOWED_WRITES: dispatch/receipts/SITE-COPY-0007.receipt.md
ACCEPTANCE: Every mismatch has a source path and line; no copy is changed.
EVIDENCE: Commands, result lines and the receipt status.
STOP_IF: A source is missing, a fact conflicts, or a requested file is outside the listed paths.
```

The builder would return a receipt, not a promise in chat. The sender then checks the files and reruns the named comparison.
