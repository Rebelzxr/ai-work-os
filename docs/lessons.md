# Lessons from running it

These come from running this system on a real one-person business every day. Each one changed a rule, a hook or a habit in this repo.

## 1. Keep guards narrow, or they get switched off
The first version of the dangerous-command hook matched "curl, then anything, then sh". It blocked harmless pipes like `curl ... | sed ...` and even commands that only **wrote a file** mentioning those words. A guard that cries wolf teaches you to bypass it.
**Now:** every pattern has must-block and must-allow tests (`tests/test-hooks.sh`). The hook reads a command roughly the way bash does instead of matching raw text, so a commit message that mentions a dangerous command is fine, but the same command inside a subshell or after a line break is still caught. It blocks if the check crashes. Several rounds of independent review found ways to slip past earlier versions (heredocs, process substitution, subshells, line breaks, `sudo sh -c`, printf escapes, a script downloaded then run) and false alarms on everyday commands; each one is now a test.

## 2. Keep the AI model out of the critical path
A daily job that needed a model to pick the news stopped the day the model's quota ran out. Nothing was published, and nothing said why.
**Now:** plain code does the essential step. A model may polish the result, and any failure falls back to the plain version. Ask of every automation: "what happens when the model is unavailable?"

## 3. One source of truth for skills across agents
Two agents (Claude and Codex) each had their own copy of the same writing skill. An old copy in a project folder quietly shadowed the updated one.
**Now:** each skill lives in one place and every agent gets a symlink (`setup.sh --link-skills --codex`). Update once, and everyone sees it.

## 4. Know exactly what is live before you deploy
Two branches of the same site existed at once: one ready to release, one holding half-finished work. A deploy from the wrong folder would have shipped both.
**Now:** release from a known base, record the deployed commit in the receipt, and check the live address after every deploy (the `evidence-loop` skill's deploy template).

## 5. A fresh reviewer finds what the author cannot
An article that the author had already checked scored 8.4 out of 10 from an independent reviewer. The reviewer caught a misread contract clause and two claims that went beyond what was tested. After fixes it scored 9.3.
**Now:** anything public, anything about money and any shared rule change gets a review by a fresh agent that reads the files, not the author's summary.

## 6. Test prompts like code
Prompts for invoice checking were tested on made-up documents with deliberate traps: a wrong subtotal, a smudged number, a duplicate. The first run caught every trap but also raised false alarms. The fix was one rule, proven by a second run.
**Now:** a prompt that others will use gets sample inputs, a real run, and the raw output kept.

## 7. The board grows unless you prune it
Rows on `TODO.md` slowly turned into paragraphs of history, and a fresh session had to read all of it.
**Now:** one row per outcome, a few lines each. History goes into receipts and daily logs, and the board links to them.

## 8. Dated overrides pile up in the rules file
Every "from today, do this instead" added a dated section to `AGENTS.md`. After a few weeks, the reader had to work out which rule was current.
**Now:** merge overrides into the main text once a month and move the old wording to an archive.

## 9. Scan before anything goes public
Private work lives right next to public work. Absolute paths, emails and client names leak through examples and screenshots more often than through code.
**Now:** a privacy scan runs before every public push, then a fresh reviewer reads the repo, and a new repo is pushed private first and made public after a final check.

## 10. Make approval cheap, not optional
The human keeps sends, spend and deploys. That only works if saying yes is quick: the agent prepares everything and hands over one command or one decision.
**Now:** "ask once, with everything ready" is step 5 of `WORKFLOW.md`.
