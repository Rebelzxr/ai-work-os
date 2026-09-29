---
name: site-loop
description: "Run a website change through brief, build, local preview, phone+desktop light+dark screenshot captures, a console-error check, and a preview deploy — stopping before any production deploy for the human to approve. Use when a website page or component has been built or changed and needs proof before it is called done."
---

# Site loop

Source: Dainer's published library guide "AI-assisted visual QA: Playwright captures at phone and desktop, light and dark" (<https://dainer-ai.biz/library>), and this repo's own `evidence-loop` skill (`packs/core/skills/evidence-loop/` — part of the optional `aiwos-core` pack) — if you installed `aiwos-core`, use its general evidence discipline together with this one's site-specific steps.

## What this produces

Evidence that a website change actually works: real screenshots at two viewports and two colour schemes, a console/page-error count, and (if the project has one) a preview-deploy URL — handed to a person or an agent to judge against the acceptance line, before anyone calls the change "done" or runs a production deploy.

## Before you start

- A web project that runs locally (`npm run dev` or equivalent) and Node.js.
- Playwright as a dev dependency: `npm i -D playwright && npx playwright install chromium` (or launch with `channel: "chrome"` to use an already-installed Chrome).
- The one sentence that describes what "done" looks like for this change (the acceptance line) — write it down before you start, not after you look at the screenshots.

## Steps

1. **Brief.** Write the acceptance line first: what must be true for this change to be finished (e.g. "the pricing card shows three tiers, no layout break under 400px, no new console errors").
2. **Build.** Make the change in the project's own files, following its existing conventions.
3. **Local preview.** Start the dev server in the foreground in its own terminal (or under a process manager you control), not backgrounded with `&` in the same shell — a backgrounded dev server is easy to forget and leave running after the loop finishes. Confirm it responds before capturing anything:
   ```bash
   npm run dev   # separate terminal/tab; leave it running only for this loop
   curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:PORT/
   ```
   A `200` means continue. Anything else means stop and fix the server first — every capture after that would just be a screenshot of an error page. When the loop is done (pass or fail), stop the dev server — don't leave it running in the background.
4. **Capture phone + desktop, light + dark.** Four screenshots minimum per changed page: 390×844 (phone) and 1440×900 (desktop), each in light and dark (`colorScheme` in a fresh Playwright browser context). Full-page capture on desktop; viewport capture on phone. Record any `pageerror` events raised during the run.
5. **Console-error check.** The capture script must listen for `pageerror` and console `error` events and report a count — zero unless the acceptance line allows otherwise.
6. **Preview deploy (if the project has one), only after the owner says yes.** Ask the owner before pushing anything or running a preview-deploy command — do not push or deploy first and explain after. Once they say yes: push to a non-production branch (never `main` or the repo's production branch) or run the project's own preview-deploy command (for example a Vercel preview). A preview deploy also waits for that yes; it is not exempt just because it isn't "production" in name. If the project has no preview-deploy step, skip this and say so in the result note.
   - **On a git-linked host (Vercel, Cloudflare Pages, Netlify, etc.), a push to the production branch IS a production deploy** — the host deploys it automatically, there is no separate "deploy" step to withhold. Treat pushing to that branch with the same approval gate as a manual production deploy, not as a lesser action.
7. **Result note.** One short file or message: acceptance line, the four (or more) screenshot file names, the error count, the preview URL if any, and a pass/fail judgment against the acceptance line — with the actual numbers and file names, not "looks good".
8. **Stop before production.** This skill never runs a production deploy, never assigns a production alias, and never pushes or merges to a production branch (see step 6 — on a git-linked host that push is the deploy). It hands the result note and screenshots to the person, who approves the production step themselves (see `packs/core/skills/evidence-loop`, part of the optional `aiwos-core` pack, for the general "evidence before claims" discipline this follows if you have it installed).

## Worked example

Acceptance line: "New pricing section renders on mobile and desktop, dark mode text is readable, no console errors."
→ Four captures: `pricing-light-1440.png`, `pricing-dark-1440.png`, `pricing-light-390.png`, `pricing-dark-390.png`.
→ Console check: 0 page errors, 0 console errors.
→ Preview deploy: asked the owner first, got a yes, pushed to a non-production branch — not `main`.
→ Result note: "Acceptance met: pricing renders correctly at both sizes and themes in the 4 screenshots above; 0 errors in either theme. Preview: <url>. Awaiting your approval to promote to production."

## Failure modes

- Do not claim a page "works" from a build success or a passing lint alone — that only proves the code compiles, not that the page renders correctly.
- Do not skip the dark-mode capture — a page that looks fine in light mode can have unreadable dark-mode text.
- Do not run or offer to run a production deploy, assign a production domain/alias, or push/merge to a production branch as part of this loop — on a git-linked host, that push is the production deploy.
- Do not push to a branch or run a preview-deploy command before the owner says yes — asking after the fact does not count.
- Do not report "no errors" without having actually listened for `pageerror`/console-error events in the capture script — an assumed clean run is not evidence.

## Human approval

**This skill runs local builds, local previews and (where the project supports it) a non-production preview deploy only. It never runs a production deploy, never changes a live domain or alias, and never merges to a production branch — a person reviews the result note and screenshots and approves the production step themselves.**
