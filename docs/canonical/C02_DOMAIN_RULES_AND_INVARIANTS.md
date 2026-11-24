# C02 — Domain Rules and Invariants

**Status:** Approved design baseline.  
**Purpose:** Own loyalty domain language, lifecycle, and invariants. Authorization details are in C06; operation contracts are in C05.

## Domain terms

- **Business / tenant:** The customer organization that owns a loyalty program, branches, staff memberships, customers, and loyalty history.
- **Branch:** A business location used for staff scope and event provenance.
- **Program:** One active stamp program per business in MVP.
- **Customer:** A person enrolled in one business program. A customer record is business-wide, not branch-owned.
- **Pass credential:** An opaque random identifier printed in a wallet pass or enrollment artifact that lets the authenticated app look up the customer. It grants no permission.
- **Stamp event:** An append-only record of a staff-confirmed stamp or later audited correction.
- **Reward:** The configured benefit after the customer reaches the program's stamp goal.
- **Reward issuance:** The customer's earned reward, with status available, redeemed, or revoked/corrected as defined below.
- **Audit event:** Durable provenance for privileged changes and corrections; distinct from technical application logs.

## Core lifecycle

```text
Business setup → program configured → customer enrolled → pass issued/updated
→ staff scans and verifies → staff confirms stamp → progress reaches goal
→ reward becomes available → staff confirms redemption
```

Enrollment and pass display do not mutate loyalty progress. A stamp is created only when a staff member explicitly confirms it in an authenticated session. A reward becomes available when accepted stamp events satisfy the configured goal. Redemption is a separate explicit event.

## Loyalty rules

- MVP has one active program per business. Program is shared across all active branches.
- A completed in-person visit earns one manually confirmed stamp. No purchase amount is required.
- The application permits multiple stamps for the same customer on one business day. Do not block, rate-limit by day, or silently deduplicate these events. Reports flag potential same-day duplicates for human review.
- Each accepted stamp must have business, branch, customer, staff actor, and server event time.
- The stamp goal and reward description are configured by an owner/manager. Reaching the goal creates an available reward; redemption does not happen automatically.
- Stamps and rewards cannot be transferred between customers in MVP.
- Optional expiration: disabled by default. If enabled, only an uncompleted stamp balance expires after a configured inactivity interval measured from the latest qualifying stamp. An earned reward remains available until redeemed unless an explicitly approved later rule changes this.
- Branches share progress and rewards. Branch label is not shown on MVP passes.
- A customer QR may be copied or printed. Possession supports lookup only and is never authorization to stamp or redeem.

## Corrections and audit

- Loyalty history is append-only. Do not delete a stamp or redemption to conceal a mistake.
- Owners/managers may correct mistaken activity with a reason and durable audit event. A correction must preserve the original event and identify the correcting actor and branch context.
- Branch staff cannot perform privileged corrections.
- A redeemed reward is historical. Any correction to redeemed activity requires owner/manager review and a reason; the exact compensation workflow is OPEN in C03 and should be handled conservatively until resolved.
- Preserve provenance if a branch or staff account becomes inactive. Inactivation prevents new use; it does not erase history.

## Concurrency and time

- The server/database is the source of truth. Stamp confirmation must be atomic with validation, event insertion, progress recomputation/update, reward eligibility, and audit as applicable.
- Do not use client timestamps to order or authorize stamp events. Store server event instants as `timestamptz`; report business dates in `America/Guatemala`.
- Mutations are online-only in MVP. No local offline queue or replay.
- Duplicate submissions from the same request must not create multiple stamps; use an idempotency key for retryable mutation commands. This does not prohibit a staff member from intentionally confirming a second distinct stamp.

## Money

Customer transactions and business billing do not occur in the application MVP. The only money rules are provisional SaaS pricing in C01. Businesses pay Apple directly for their own developer accounts.
