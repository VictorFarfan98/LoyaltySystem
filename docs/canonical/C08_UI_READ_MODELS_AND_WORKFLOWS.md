# C08 — UI Read Models and Workflows

**Status:** MVP workflows approved; detailed visual tokens in C14.  
**Purpose:** Own pages, user goals, interactions, and responsive states.

## Staff workflow (primary, mobile)

```text
Sign in → choose/confirm assigned branch → scan pass → verify customer/progress
→ confirm stamp OR redeem available reward → show success and updated progress
```

Every operation is explicit. Scanning alone performs lookup only. No tablet, hover, or desktop-only action is required. Support camera scan and a manual code entry fallback for damaged/printed QR. If a scan cannot resolve, allow staff to search by customer name/phone only within their business and branch-authorized workflow.

### Scan/verify screen

- Primary user: branch staff.
- Goal: confidently identify the customer and see current loyalty state before acting.
- Read model: name, stamp count/goal, available reward, recent relevant event history.
- Actions: confirm one stamp; redeem available reward; return/rescan.
- Warnings: same-day duplicate signal is advisory and does not block the stamp; show prior event context when practical.
- States: camera permission denied, unsupported camera, scan not found, inactive customer, network failure, branch scope failure, repeated pending request, success.
- Responsive: phone-first, large camera/confirm controls, minimum 44×44 CSS px targets where practical. No hover-only actions.

## Enrollment and pass setup

- Printed QR and shareable link are available; QR is the emphasized action.
- Enrollment form asks for name and mobile; email optional; record separate consent choices.
- After enrollment, show add-to-Apple-Wallet and add-to-Google-Wallet actions when configured, plus a clear help path.
- Business setup wizard gathers business/branch identity, program goal/reward, branding, staff, and Wallet setup status.
- Owners/managers see a pass preview before publishing brand changes.
- Do not show branch labels on MVP passes.

## Owner/manager workspace

1. **Overview:** current program summary, recent stamp/redemption totals, branches, setup/Wallet readiness.
2. **Customers:** bounded business search and customer progress/activity; no broad PII export.
3. **Program:** goal/reward text and optional inactivity expiry; edits create a version and clearly preview impact.
4. **Pass appearance:** logo, colors, preview, save/publish; branch label omitted.
5. **Branches and staff:** create/deactivate branches and staff; assign roles and optional branch scope.
6. **Reports:** date/branch filters; stamps, reward issuance/redemption, active customers, potential same-day duplicate review.
7. **Audit history:** owner/manager view of corrections and privileged actions with actor, branch, time, and reason.

## Marketing/Social Media workspace

Read-only Reports page with aggregate business metrics and branch/date filters. No customer search, PII, stamp/redeem controls, program edit, staff management, or export in MVP. The full report scope is OPEN-004 for pilot validation.

## System states and accessibility

- Give clear loading, empty, success, validation, network, permission, and recoverable failure states.
- Use Spanish interface copy and stable API error codes; localized text belongs in the frontend.
- Provide keyboard/focus access for non-camera controls and manual entry fallback.
- On mutation timeout/unknown outcome, do not invite blind repeat with a new key; explain refresh/status check.
- Follow reusable responsive breakpoints and component rules. Use mobile-specific layout adaptation, not duplicated app trees.

## Lightweight page blueprints

### Staff scan

```text
[Business / branch context]                 [Sign out]
[Scan QR]  [Enter code]
-------------------------------------------
Customer: <name>
Progress: <current> / <goal>
Reward: <eligible / not yet>
[Confirm one stamp]   [Redeem reward]
[Recent activity / advisory duplicate signal]
```

### Owner reports

```text
[Date range] [Branch: All / branch]
[Stamps] [Rewards earned] [Rewards redeemed] [Active customers]
[Activity by day / branch]
[Potential duplicate stamps: review list]
```

These are content priorities, not final layout specifications; C14 owns final component and styling rules.
