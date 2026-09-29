---
name: evidence-loop
description: "Use before saying work is done, fixed, deployed, passing, sent, migrated or ready. Picks the matching proof template, runs the checks on the current version, and ends the reply with one honest STATUS line. Also use to check another agent's \"done\" claim."
---

# Evidence loop: prove it before you claim it

A claim is only as good as the check behind it. "Tests pass" from the agent that wrote the tests, a 200 response, or a screenshot of the wrong page are the usual ways work gets called done when it is not.

## The rule

1. Name the exact claim you are about to make.
2. Pick the matching template below.
3. Run its checks against the **current** version, not an earlier run.
4. Keep the raw output (command, exit code, the lines that matter) in the job receipt.
5. End with exactly one line:
   - `STATUS: VERIFIED (evidence: <what ran and what it showed>)`
   - `STATUS: UNVERIFIED (cannot test because <specific gap>)`
   - `STATUS: BROKEN (failure: <what failed>. Next step: <exact command>)`

Scope the claim to the evidence. "Works locally" is not "live". "The build passed" is not "users can use it".

## Template 1: deployed (website or app)

- Record the exact commit or version you deployed.
- Fetch every changed route on the live address and check it shows the new content (search for a string that only exists in the new version), not just the homepage.
- Check the browser console on the key pages for errors.
- Check one phone width and one desktop width.
- If there is a health endpoint, fetch it.
- Say what was not checked (for example "payment flow not exercised").

## Template 2: tests pass

- Run the full suite, not a filtered subset, and quote the summary line.
- Ask whether the tests were written in the same session as the code. If so, they prove the code matches the author's understanding, not that it is right. Add one check from the user's side: run the real command or open the real page.
- Name any critical path with no test.

## Template 3: bug fixed

- Reproduce the bug first and keep the failing output.
- Apply the fix, run the same reproduction, and show it now passes.
- Run the nearby tests for regressions.
- If you could not reproduce it, say so. A fix for a bug you never saw is UNVERIFIED.

## Template 4: pipeline or automation ready

- Run it end to end on real or realistic input, not a stub.
- Check the full batch pass rate, not one happy example.
- Look for silent fallbacks: steps that "succeed" by skipping work.
- Pick three outputs at random and check them by hand against their inputs.
- Confirm what happens when an input is missing or a service is down.

## Template 5: data moved or migrated

- Back up first (for SQLite use `.backup`, never copy a live file).
- Compare row counts before and after, table by table.
- Spot-check records by hand, including the oldest and newest.
- Confirm the app reads the new location.

## Template 6: messages sent or content published

- Only after the human approved the exact content, audience and account.
- Count what was actually sent or posted, from the platform's own record.
- Check for bounces, failures or duplicates.
- Link to the live post or the send log.

## Checking another agent's claim

Do not accept its status text. Open the files, run the checks yourself, and write your own STATUS line from what you saw.
