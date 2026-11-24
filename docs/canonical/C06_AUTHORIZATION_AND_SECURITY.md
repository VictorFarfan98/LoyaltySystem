# C06 — Authorization and Security

**Status:** Security constraints approved; auth provider configuration remains an implementation decision under the engineering baseline.  
**Purpose:** Own authentication, roles, tenant/branch scope, and pass security.

## Authentication

- Staff authentication is required for every staff workspace and mutation.
- There is no customer login in MVP.
- No public staff self-registration. An owner/manager provisions staff; invitation/password recovery and session details remain OPEN-005.
- The app must not expose Supabase service-role, Auth Admin, signing, or database secrets to the browser.
- QR lookup may occur only in an authenticated staff app context; a customer cannot mutate by scanning their own pass.

## Roles

| Role | Business scope | Branch scope | Allowed capabilities |
|---|---|---|---|
| Owner | One business | All branches | Configure program/branding; manage branches/staff; operate all loyalty workflows; correct events; view all reports |
| Manager | One business | All branches unless explicitly narrowed | Manage program/branding and staff as granted; operate loyalty workflows; correct events; view reports |
| Branch staff | One business | One or more assigned branches | Search/scan, verify customer, confirm stamp, redeem available reward at assigned branch |
| Marketing / Social Media Manager | One business | No branch assignment required | Read aggregate business reports only; no customer-level export, operational lookup, stamp, redemption, staff or program changes |
| Platform administrator | Platform-level support | Explicitly selected business context | Technical support and tenant administration, with audited access; do not assume ordinary business operation permissions |

Null branch assignment has role-specific meaning. It is not a blanket permission. For Marketing it means aggregate reporting across the business only. For other roles, grant all-branch access only explicitly.

## Authorization invariants

- Resolve business from authenticated membership and request context; never trust tenant/branch identifiers alone.
- Verify active membership and role on every protected operation.
- Verify branch belongs to the business and is active. Branch staff must be assigned to the branch used for an event.
- Verify customer, program, pass, reward and event all belong to the authenticated business.
- Frontend permission checks improve UX only. Controllers/Services may reject early, but RLS and authoritative mutation operations enforce security.
- RLS remains enabled on tenant-owned tables. Cross-tenant reads and writes deny by default.
- Audit actor, business, branch context, operation, target, reason where required, request ID, and server time. Keep technical logs separate from audit history.
- Platform support access must be scoped, attributable, and logged. Do not create a silent support bypass.

## Pass token security

- Pass QR identifier is a lookup credential, not an authorization credential.
- Do not expose a database primary key as the durable public pass token. Use a distinct random opaque token; store/hash/rotate it according to implementation details.
- Require an authenticated staff session and valid branch scope before returning a customer/progress lookup.
- Return only the minimum data needed for verification: customer display name, progress, reward eligibility, and limited recent activity. Do not return phone/email by default.
- Never log raw pass tokens or include them in analytics, error details, or URLs visible to third parties where avoidable.
- A token can be revoked/rotated by an owner/manager support flow; rotation must not erase customer history.

## Privacy and tenant assets

- Enrollment collects minimal data; email is optional under the proposed default. Marketing consent is separate from program participation.
- Do not expose customer lists to Marketing role unless a later approved decision requires it.
- Branding storage uses tenant authorization, opaque keys, signed access where applicable, and no PII in paths.
- Privacy notice, data retention, account closure, and deletion workflow remain OPEN-008 and must be settled before production onboarding.

## Wallet account ownership

Each business owns its Apple Developer account and pays Apple directly. Any enrollment/setup assistance or account access needs explicit authorization and must be revocable. Document the business's owner contact, granted access, assets/certificates, renewal responsibility, and exit/handover process. Confirm current Apple/Google account and issuer requirements before go-live; do not promise a particular account flow until verified.
