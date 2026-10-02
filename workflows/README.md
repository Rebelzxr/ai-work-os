# Workflow format

A workflow is a short weekly route through repeatable jobs. It names the input file, the output file and the point where the person decides. It is a map, not an unattended schedule.

## One row

Use this shape for every step:

| Day or cadence | Job | Reads | Writes | Person approval |
|---|---|---|---|---|
| Monday | `job-name` | `path/to/input.md` | `path/to/output.md` | What the person checks or decides |

## Rules

- Name the job exactly as its skill folder does.
- Give paths relative to the workspace. Use the real source file, not a vague label such as “the notes”.
- Name one output file even when the job also returns a short answer in the session. For a read-only job, say that the person saves the answer to the named file.
- Mark a job that is not in this version as **coming**. Do not write as if a coming job can run.
- Keep drafts, source facts and review evidence separate.
- Put the person approval in the row where it happens: source choice, scope, rate, message, quality result, release or other outside action.
- A workflow never grants permission to contact, publish, deploy, spend, change an account or delete data.
