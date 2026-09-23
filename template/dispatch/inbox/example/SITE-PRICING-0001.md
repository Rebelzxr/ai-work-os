JOB_ID: SITE-PRICING-0001
LANE: example
OWNER: builder
OBJECTIVE: Add a pricing section to the homepage using the approved copy in docs/pricing-copy.md.
INPUTS: docs/pricing-copy.md, src/app/page.tsx
ALLOWED_WRITES: src/app/page.tsx, src/app/pricing.css, dispatch/receipts/SITE-PRICING-0001.receipt.md
ACCEPTANCE: Section renders at 1280px and 375px with no horizontal scroll; prices match the copy file exactly; type check and lint pass.
EVIDENCE: Commands and results, screenshots at both widths, the commit hash.
STOP_IF: The copy file is missing, a price is unclear, or the change needs a deploy (deploys are the human's call).
