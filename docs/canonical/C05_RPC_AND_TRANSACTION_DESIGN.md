# C05 — RPC and Transaction Design

**Status:** Operation contracts approved; exact PostgreSQL signatures and grants are scaffold-time design work.  
**Purpose:** Define authoritative mutation behavior. C02 owns invariants; C06 owns authorization.

## Mutation rules

- Mutations preserve the verified caller identity. Never accept `staff_user_id` as authority from the client; derive it from the session.
- Server/database validates business membership, role, active status, branch assignment, customer/program ownership, and operation eligibility.
- Every successful stamp or redemption commits the event, derived progress/reward effects, audit provenance, and idempotency outcome atomically.
- Expected domain outcomes use stable codes. Do not expose SQL/PostgREST text.
- Mutations are online only. Client cancellation does not imply rollback after a request reaches the server.

## Required operations

Names are semantic placeholders; exact schema/function signatures are finalized during implementation. Proposed API schema follows reusable baseline §25.

| Operation | Inputs from caller | Atomic responsibilities | Success result / important failures |
|---|---|---|---|
| `api.enroll_customer` | business enrollment code, name, phone, optional email, consent choices, request key | Validate business/program; create or safely identify customer; create pass credential; record consent | Enrollment summary and enrollment/pass link; `DUPLICATE_CUSTOMER_REVIEW`, `PROGRAM_UNAVAILABLE` |
| `api.lookup_customer_by_pass` | raw pass token, authorized session/branch context | Hash/resolve token; verify business and staff visibility; return minimal customer/progress/reward projection | Customer name, progress, eligibility; `PASS_NOT_FOUND`, `CUSTOMER_INACTIVE`, `FORBIDDEN` |
| `api.record_stamp` | customer ID, branch ID, idempotency key | Verify active staff and branch; insert one explicit stamp; update derived progress and create reward issuance when goal reached; add audit event | Updated progress/eligibility and event ID; `FORBIDDEN`, `BRANCH_INACTIVE`, `CUSTOMER_INACTIVE`, `PROGRAM_PAUSED` |
| `api.redeem_reward` | reward issuance ID, branch ID, idempotency key | Verify staff scope and availability; append redemption and audit; update projection | Redemption receipt and updated progress; `REWARD_NOT_AVAILABLE`, `FORBIDDEN` |
| `api.correct_loyalty_event` | target event, correction action, required reason, idempotency key | Verify owner/manager; append correction and audit; recalculate derived progress/reward state atomically | Corrected projection; `REASON_REQUIRED`, `FORBIDDEN`, `REDEMPTION_REVIEW_REQUIRED` |
| `api.update_program` | typed program settings, expected version | Verify owner/manager; validate goal/reward/expiration; create next immutable version | New version and effective date; `VERSION_CONFLICT`, `INVALID_PROGRAM_SETTINGS` |
| `api.update_branding` | typed branding fields and asset references, expected version | Verify owner/manager; validate uploaded assets; save draft/published version | Preview/published pass summary; `INVALID_ASSET`, `VERSION_CONFLICT` |

## Idempotency and replay

For mutation retries, a repeated idempotency key from the same actor/business/operation returns the original outcome and must not duplicate effects. A different key represents a separate confirmed business action and may create another same-day stamp. The UI should disable the confirm control while a request is pending and show whether the outcome is known or needs refresh.

## Security implementation

- Prefer invoker-security functions with RLS where sufficient. Use `SECURITY DEFINER` only when a transaction requires controlled access beyond caller RLS; set a safe search path, schema-qualify references, revoke default execution, and grant narrowly.
- Every privileged mutation checks authorization inside the database operation, not only the UI, Route Handler, or Service.
- Reads may use RLS-protected views/tables or query RPCs according to C07 sensitivity and shape.
- Validate atomic rollback in pgTAP: if any event/audit/progress/reward step fails, none of the transaction commits.

## Reward and correction behavior

The first version of a program configuration is snapshotted with each stamp/reward. When a stamp goal is met, the transaction creates an available reward issuance exactly once for that completed set of qualifying stamps. Redemption is a separate immutable event. If a correction changes eligibility, preserve the reward history and require the correction rules in C02; do not silently delete a redeemed reward.
