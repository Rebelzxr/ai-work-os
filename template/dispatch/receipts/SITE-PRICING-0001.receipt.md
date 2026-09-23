JOB_ID: SITE-PRICING-0001 · owner builder · example receipt

## What changed
- `src/app/page.tsx`: pricing section added from `docs/pricing-copy.md`.
- `src/app/pricing.css`: layout for three plan cards.
- Commit `a1b2c3d`.

## Checks
- `npx tsc --noEmit`: exit 0.
- `npx eslint src/app/page.tsx`: 0 errors.
- Browser at 1280px and 375px: section renders, no horizontal scroll, all three prices match the copy file.

## Not done
- Not deployed. Deploys are the human's decision.

STATUS: VERIFIED (evidence: tsc exit 0, eslint 0 errors, prices match copy at 1280px and 375px, commit a1b2c3d; not deployed)
