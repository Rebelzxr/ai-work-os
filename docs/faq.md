# FAQ

**Does it work with Codex, Cursor or other agents, or only Claude Code?**
The rules (`AGENTS.md`), the board, packets, receipts and skills are plain files, so any agent that reads files can use them. Codex and Cursor read `AGENTS.md` natively. The hooks use Claude Code's hook system, so they only run in Claude Code.

**Do I need all the third-party skills?**
No. The OS works on its own. Start with none, and add one when you feel a specific gap. `./install-skills.sh` explains what each one is for.

**Is any of my data sent anywhere?**
The kit itself sends no customer messages or drafts. But the AI tool you run it in sends your prompts and the files it reads to its model provider. Local files do not mean a local AI session. Start with made-up examples; remove names, IC, phone numbers, bank details and addresses locally before any real input. `safe-to-paste` is a second check, not an upload barrier.

Network exceptions: `doctor.sh` calls `gh auth status` (contacts GitHub, reports authentication state only); `install-skills.sh --run` starts a network installer after confirmation; clone, update and plugin/skill installation commands contact their hosts. Other installed tools and the AI provider have their own policies.

**Is it free?**
The kit is free under MIT. Claude Code or Codex may need a paid plan; other tools or services may cost extra.

**Are the skills tested?**
Script tests run actual code for hooks, setup/backups, task selection, onboarding guards, doctor configuration and caption lint. Structural checks inspect skill frontmatter, script paths, safety wording and example checklists. A sample regex test checks made-up identifiers, not real uploads. None of those tests measure AI skill output quality or prove a draft quote is correct. The live onboarding interview and all runtime/plugin combinations are not covered. Always check the generated draft against your source facts before manually sending.

**Do I need the thinking pack?**
No. Setup starts with core, business, marketing, web and video (17 skills). Add the 7 thinking tools only when needed: `./setup.sh ~/my-work --link-skills --pack thinking` (plus `--codex` for Codex).

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
