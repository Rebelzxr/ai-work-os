# How it works

![The loop](../assets/hero.svg)

## The rules file (`AGENTS.md`)
One short file every agent reads. It says who decides what, which actions always need the human, how work is handed over and how claims are proven. Claude Code reads it through `CLAUDE.md`; Codex, Cursor and most other agents read `AGENTS.md` directly. When you change your mind about a rule, write the new rule with a date. Merge those dated notes into the main text once a month.

## One board (`memory/TODO.md`)
The single answer to "what is going on". One row per outcome: who owns it, where it stands, the evidence and the exact next action. The "Context for next session" block at the top is what a fresh chat reads first (the SessionStart hook prints it). History does not live here. It lives in receipts and daily logs.

## Job packets and receipts (`dispatch/`)
When one agent hands work to another, or when a job is big enough to need a clear finish line, it gets a packet with the objective, the exact inputs, the files it may change, the acceptance checks and the stop conditions. The agent that does the work writes a receipt: what ran, what changed, the checks, the gaps and one STATUS line. Chat is optional; the files are the record. A packet can never approve a send, a spend or a deploy.

## Evidence before claims
Every task-shaped reply ends with `STATUS: VERIFIED`, `UNVERIFIED` or `BROKEN`, and the evidence in brackets. The `evidence-loop` skill has proof templates for the claims that most often go wrong: deployed, tests pass, bug fixed, pipeline ready, data migrated, messages sent. The builder never approves its own work; a fresh reviewer reads the actual files.

## Hooks (Claude Code)
![Hooks](../assets/hooks.svg)

Wired in `.claude/settings.json`, and they run on your machine:
- **SessionStart** prints the board's resume block and lane headings.
- **PreToolUse (Bash)** blocks one-way-door commands until you approve the exact command. The rules cover:
  - force pushes (`-f`, `--force`, `--force-with-lease`, `+branch`, `--mirror`);
  - `git reset --hard`, and discarding all local changes (`git checkout .`, `git checkout -f`, `git restore .`);
  - `git clean -f` (unless it is a dry run) and `git stash clear`;
  - `rm -rf` of `/`, a top-level folder, your home folder or `*`, any `rm` run with `sudo`, and `find ~ -delete` without a filter such as `-name` or `-mtime`;
  - `chmod -R 777`;
  - formatting or overwriting a disk (`mkfs`, `diskutil erase…`, `dd` to a device);
  - `DROP TABLE`/`DATABASE`/`SCHEMA` or `TRUNCATE` sent to a database client;
  - running downloaded code.

  `block-dangerous.py` reads the command roughly the way bash does: quotes, line continuations, subshells, `if`/`for` blocks, pipes, `$(...)`, backticks and heredocs. Then it checks each simple command against a short list of rules. Heredoc text counts as code only when a shell reads it (`bash <<EOF`, `source /dev/stdin <<EOF`, `cat <<EOF | sh`, `>(bash)`, or `ssh host` with no command of its own) or when the file it writes is run later in the same command. Otherwise it is data, except for any `$(...)` or backticks that bash would still run. A file written earlier is checked as bash unless its first line names another language, such as `#!/usr/bin/env python3`. SQL rules apply only to text that reaches a database client such as `sqlite3` or `psql`: its arguments, a heredoc or here-string, a file written earlier in the same command and passed with `<` or `-f`, or text that `echo`, `printf`, `cat <<EOF` or `cat` of such a file pipes into it. The same goes for shells: `cat deploy.sh | bash` is checked when `deploy.sh` was written or downloaded earlier in the command, and a group after a pipe (`curl ... | { cd /tmp && bash; }`) counts as part of that pipe. A commit message or a `grep` pattern that mentions dropping a table is fine. If the check crashes, nests too deeply or meets more than 200 heredocs, it blocks. Its bash reader is small, so unusual syntax can be misread without a warning; see the README's Limitations.
- **PreCompact** snapshots the board and notes it in today's log before the chat is compressed.
- **Stop** logs replies that sound finished but carry no STATUS line, so you can see how often that happens. It never blocks.

## Human gates
You keep money, pricing, strategy, anything sent or published, account actions and deleting shared data. Agents do everything reversible and local that your request needs, then ask once with everything ready: the exact version, the check results, what is still unproven, and one command or decision.

## Limits that keep it calm
- At most two production lanes at the same time, and at most two helper agents per job.
- One writer per file.
- No status chatter between agents. Results are shared once, in the receipt.
- Save the exact next action before a long wait, a handoff or the end of a session.
