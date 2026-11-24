# C01 — Product Requirements

**Status:** Approved MVP scope.  
**Purpose:** Define what the managed loyalty service provides. Domain invariants live in C02; authorization lives in C06.

## Product and audience

The service lets small businesses offer a branded digital stamp-card experience without needing developers or dedicated hardware. Initial prospects are Skin Solutions (four branches) and Glossing (one branch). The product emphasizes a polished Spanish-language experience and responsive, hands-on setup and support.

Businesses are the paying organizations. Customers receive loyalty passes; business owners and staff operate a responsive web app on their phones. No tablet is required.

## MVP requirements

1. Create separate business workspaces with branches, staff, program settings, customer records, and branding.
2. Let a customer enroll from a business QR code or link and add a branded pass to Apple Wallet or Google Wallet.
3. Let authenticated staff scan a customer pass using a mobile browser, verify the customer and progress, then explicitly confirm one stamp for a visit.
4. Show the customer's name, stamp progress, and reward eligibility before confirmation.
5. Let authorized staff confirm a reward redemption and show the updated pass progress/eligibility.
6. Allow an owner/manager to configure a stamp goal, reward description, pass appearance, and optional inactivity expiration for an incomplete stamp balance.
7. Let owners/managers review branch-filterable loyalty activity reports. Marketing/social media staff may view aggregate reports without operational permissions.
8. Preserve event history with staff, branch, customer, and event time attribution. Allow duplicate stamps; make same-customer same-business-day patterns reportable for human review.
9. Provide a pass preview before publishing branding changes.
10. Support printed enrollment QR codes and a shareable enrollment link; prioritize the QR in the workflow.

## Out of scope for MVP

- Reseller/wholesale pricing, reseller portals, partner commissions, and automated billing.
- Customer accounts/passwords, native customer apps, public scan-to-stamp mutation, or offline stamp queueing.
- POS/payment processing, invoices, appointment integrations, or purchase-value-based stamp rules.
- Points, tiers, multiple simultaneous programs, campaign automation, marketing messaging, customer exports, and advanced segmentation.
- Branch labels on wallet passes.

## Commercial hypothesis

Direct price is provisional at **Q299 per branch per month plus a setup fee**. This means Q1,196/month for Skin Solutions at four branches and Q299/month for Glossing at one branch, before setup. The setup fee amount and final willingness-to-pay remain pilot questions. Apple account fees are paid by each business directly to Apple. Reseller pricing is explicitly deferred from MVP; revisit after validating direct pricing and support effort.

## Geography and language

- Initial market: Guatemala.
- Staff interface and customer enrollment: Spanish.
- Currency for displayed business prices: GTQ.
- Business timezone: `America/Guatemala`.
- Use Guatemala-local business dates for daily reports and same-day review flags.

## Success criteria for pilot

- Staff can enroll or find a customer, scan a pass, verify progress, and confirm a stamp on a phone without a tablet.
- Wallet passes display the configured business branding and current progress/reward eligibility.
- Owners can understand setup and operate branch reports with hands-on support.
- No loyalty mutation can be performed from a customer QR scan without an authenticated authorized staff session.
- Pilot feedback informs support burden, setup pricing, direct monthly pricing, and any changes to enrollment/expiration rules.
