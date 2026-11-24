# C04 — Data Model and Schema

**Status:** Conceptual schema approved for planning; SQL names/types are finalized during scaffold and migration design.  
**Purpose:** Own data entities, ownership, lifecycle, and structural integrity. C05 owns transaction boundaries; C06 owns RLS.

## Ownership and entity map

| Entity | Owner / key relationships | Lifecycle and notes |
|---|---|---|
| Business | Root tenant, stable `business_id` | Active → inactive/closed; no hard deletion while history exists |
| Branch | `business_id`; unique stable branch ID | Active → inactive; past events remain attributed |
| Staff user | Supabase Auth identity | One identity; may participate in one business per MVP |
| Business staff membership | `business_id`, `user_id`, role, optional branch scope | Active → suspended; role/scope changes audited |
| Loyalty program | `business_id`; one active program in MVP | Draft → active → paused/retired; changes should be versioned |
| Program version | Program, version number, goal/reward/expiration terms | Immutable snapshot once used for a stamp/reward |
| Customer | `business_id`; unique customer ID | Active → inactive; branch-independent profile |
| Customer contact | Customer; normalized phone, optional email, consent timestamps | Mutable current contact with relevant history/consent events |
| Pass credential | Customer and program; opaque random token hash; status | Issued → rotated/revoked; token is lookup-only |
| Stamp event | Business, branch, customer, staff, program version, server time, idempotency key | Append-only; valid or corrected by linked event |
| Reward definition | Program version; display label/description | Snapshot with program version |
| Reward issuance | Customer, program, qualifying event set/version | Available → redeemed or revoked/corrected; preserve history |
| Reward redemption event | Issuance, business, branch, customer, staff, server time | Append-only, idempotent command |
| Audit event | Business, actor, branch context, target, action, reason, time | Append-only security/business provenance |
| Tenant branding | Business; logo asset reference and visual settings | Draft → published; supports preview before publication |

## Structural integrity

- All tenant-owned rows carry `business_id` where practical.
- Composite foreign keys or equivalent constraints must prevent a branch, staff membership, program, customer, event, or reward from referencing a different business.
- Branch event attribution is mandatory for stamp, redemption, correction, and operational audit records. Business-wide admin actions may have a null branch context only when no branch is meaningful; record that action explicitly.
- A staff membership's optional branch scope must not be interpreted as global access when null. For the Marketing role, null branch assignment means business-wide aggregate report scope only.
- A pass token is generated with sufficient randomness, stored hashed where feasible, and separate from database primary keys. Store status/rotation metadata and never log raw tokens.
- Idempotency keys are unique within the authenticated actor/business operation scope and do not prevent distinct intentional stamps.
- Stamp/reward history is append-only. Corrections reference original events and retain the original record.
- Program versions snapshot goal, reward text, and expiration policy so later edits do not rewrite past eligibility.
- The report's same-day duplicate indicator is derived in Guatemala business time; it must not become a uniqueness constraint.

## Deactivation semantics

- Deactivate a branch or staff membership to prevent new operations; preserve historical event references.
- Deactivate a customer to prevent normal lookup/use; retain required history subject to the retention policy in OPEN-008.
- Retire or pause a program to stop new stamps; preserve existing balances and reward history for explicit resolution.

## Storage

Business logos are private tenant branding assets. Use opaque object paths and authorized upload/read flows from the engineering baseline. Wallet-specific pass images/fields may require public delivery according to provider requirements; verify the provider contract before deciding whether any derivative asset can be public. Do not put PII in object keys or pass tokens.

## Deliberately not schema decisions yet

Exact table names, enum encoding, token hashing algorithm, retention durations, and storage bucket policies are set in migrations after the repository and Wallet provider requirements are verified. No production customer data belongs in seed fixtures.
