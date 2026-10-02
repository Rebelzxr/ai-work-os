# Weekly rhythm for one-person businesses

This is a light rhythm, not a demand to fill every block. Choose the smallest useful set of jobs for the week, keep a buffer after commitments, and save each result to the named file.

## Monday — choose and prepare

| Job | Reads | Writes | Person approval |
|---|---|---|---|
| `weekly-bottleneck-review` | `memory/TODO.md`, `context/business-brief.md`, the latest sales and delivery notes | `planning/weekly-review.md` | Choose three outcomes, time blocks and the stop-doing list |
| `what-now` | `memory/TODO.md`, named receipts | `planning/monday-brief.md` (the person saves the read-only answer) | Choose the one bottleneck and next action |
| `business-brief` | copied `context/business-brief.md` template, owner-supplied business facts | `context/business-brief.md` | Check prices, scope, proof and the AI boundary |
| `cash-check-and-forecast` **(coming)** | `finance/ledger.md`, `context/business-brief.md` | `finance/weekly-cash.md` | Check actual, expected and uncertain amounts |

## Tuesday — create demand

| Job | Reads | Writes | Person approval |
|---|---|---|---|
| `qualified-prospect-pack` | `context/business-brief.md`, `research/public-prospect-notes.md` | `sales/prospect-pack.md` | Check every public source, trigger, fit row and channel |
| `lead-triage` | `sales/clean-enquiries.md`, `context/business-brief.md` | `sales/triage.md` | Check categories and each draft reply |
| `content-from-real-work` | `marketing/real-work-note.md`, `context/business-brief.md` | `marketing/content-drafts.md` | Check proof, privacy and each channel draft |
| `customer-evidence-miner` **(coming)** | `marketing/evidence-notes.md` | `marketing/evidence-bank.md` | Choose which evidence is safe and useful to keep |

## Wednesday — advance and deliver

| Job | Reads | Writes | Person approval |
|---|---|---|---|
| `discovery-call-planner` | `context/business-brief.md`, `sales/prospect-pack.md`, `sales/call-notes-input.md` | `sales/call-plan.md` | Check the goal, eight questions and disqualifiers |
| `scope-proposal` | `context/business-brief.md`, `sales/discovery-notes.md`, `sales/rate-rules.md` | `sales/proposal-draft.md` | Check calculation, scope, terms and exclusions |
| `deal-follow-up` | `sales/deals.md`, `sales/proposal-draft.md`, `sales/discovery-notes.md` | `sales/follow-up-queue.md` | Check act / waiting / stop and recipient scope |
| `client-kickoff` | `sales/approved-scope.md`, `delivery/client-inputs.md` | `delivery/kickoff.md` | Check the consolidated request and milestones |

## Thursday — produce and check

| Job | Reads | Writes | Person approval |
|---|---|---|---|
| `deliverable-production` | `delivery/kickoff.md`, `delivery/sources/`, `sales/approved-scope.md` | `delivery/draft/`, `delivery/production-note.md` | Check the draft against scope before the gate |
| `quality-gate` | `delivery/draft/`, `delivery/production-note.md`, `sales/approved-scope.md` | `delivery/quality-gate.md` | Review evidence, then decide what happens after PASS / REVISE / BLOCKED |
| `site-loop` | `web/change-brief.md`, the web project files | `web/preview-evidence.md` | Check captures and console results before any preview or production action |
| `video-brief` | `video/real-work-note.md`, `context/business-brief.md` | `video/brief.md` | Check claims, source media and the handoff target |
| `support-resolution-desk` **(coming)** | `support/open-cases.md`, `context/business-brief.md` | `support/resolution-drafts.md` | Check policy source and every reply draft |

## Friday — close and learn

| Job | Reads | Writes | Person approval |
|---|---|---|---|
| `evidence-loop` | `delivery/quality-gate.md`, changed files and test output | `dispatch/receipts/<JOB_ID>.receipt.md` | Check the evidence and the final STATUS line |
| `follow-up-drafts` | `sales/follow-up-queue.md`, the approved useful-fact bank | `sales/follow-up-drafts.md` | Check every draft and decide which, if any, to send |
| `receivables-recovery` **(coming)** | `finance/invoices.md`, `finance/payments.md` | `finance/receivables-queue.md` | Match records and check each reminder before use |
| `proof-and-referral-builder` **(coming)** | `delivery/quality-gate.md`, approved result records | `customer-success/proof-drafts.md` | Confirm permission and every claim |
| `work-to-sop-builder` **(coming)** | `operations/completed-job.md`, `operations/second-example.md` | `operations/sop-draft.md` | Check the procedure on the second example |

## Daily and monthly loops

| Cadence | Job | Reads | Writes | Person approval |
|---|---|---|---|---|
| Daily | `deal-follow-up` | `sales/deals.md`, `sales/follow-up-queue.md` | `sales/follow-up-queue.md` | Check due rows, stops and the next action |
| Daily | `follow-up-drafts` | `sales/follow-up-queue.md`, approved useful facts | `sales/follow-up-drafts.md` | Read each draft before any message leaves the workspace |
| Daily | `scope-and-capacity-guard` **(coming)** | `sales/new-requests.md`, `context/business-brief.md` | `operations/scope-decisions.md` | Decide included, extra, unclear or stop |
| Weekly | `decision-stress-test` | `planning/decision.md`, `context/business-brief.md` | `planning/decision-check.md` | Choose proposal, smaller experiment or no action |
| Monthly | `profit-and-pricing-review` **(coming)** | `finance/month.md`, `context/business-brief.md` | `finance/pricing-review.md` | Approve any price or scope decision |
| When changing tools | `handoff` | `memory/TODO.md`, the current receipt | `memory/session-handoffs/YYYY-MM-DD-topic.md` | Check the handoff before a new session uses it |
| When using more than one AI | `handoff-to-codex` or `handoff-to-claude` | `dispatch/source-brief.md` | `dispatch/inbox/<lane>/<JOB_ID>.md` | Check allowed writes, acceptance and stop conditions |

Keep the source, date, approved version, unresolved items and next action with every handoff.
