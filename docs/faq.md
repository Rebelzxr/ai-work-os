# FAQ

**Does it work with Codex, Cursor or other agents, or only Claude Code?**
The rules (`AGENTS.md`), the board, packets, receipts and skills are plain files, so any agent that reads files can use them. Codex and Cursor read `AGENTS.md` natively. The hooks use Claude Code's hook system, so they only run in Claude Code.

**Do I need all the third-party skills?**
No. The OS works on its own. Start with none, and add one when you feel a specific gap. `./install-skills.sh` explains what each one is for.

**Is any of my data sent anywhere?**
No. Everything is local files and local shell scripts. The hooks read the command the agent is about to run, or the chat transcript file on your machine, and write only inside your workspace.

**How is this different from gstack or superpowers?**
Those give an agent roles and working methods. This is the layer around them: who decides what, one board, job hand-offs, receipts, evidence before claims, and hooks that stop dangerous commands. They work well together.

**Can a team use it?**
Yes. The "one writer per file" rule and job packets exist for that. Put the workspace in a shared git repo and keep `memory/TODO.md` short.

**Does it work on Windows?**
The hooks and scripts are bash, and the hooks also need `python3`. Use WSL or Git Bash.

**What if a hook blocks something I really want to run?**
That is the point of the hook: the agent stops and asks you. If a pattern is wrong for your work, edit the rules in `scripts/hooks/block-dangerous.py` in your workspace. If you keep a clone of this repo, add a must-allow case to its `tests/test-hooks.sh` so the change stays tested.

**Why do replies end with STATUS lines?**
Because "done" is the most expensive word an agent says. The line forces a choice between proof, a named gap, or a named failure with the next command.
