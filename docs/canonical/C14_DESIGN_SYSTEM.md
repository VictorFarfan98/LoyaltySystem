# C14 — Provisional Design System

**Status:** Provisional; final visual identity awaits brand name/assets (OPEN-011).  
**Purpose:** Give Codex safe visual defaults for functional MVP work without inventing the service brand. This document must be revised after brand assets and design decisions exist.

## Brand and product feel

- The service should feel clear, trustworthy, polished, and easy for nontechnical owners and busy staff.
- Staff screens prioritize speed, legibility, and confidence at the point of service.
- Customer wallet passes reflect each business's own brand; the platform UI remains visually neutral.
- Use warm, respectful Spanish copy; avoid technical language in customer and business-owner flows.

## Status of decisions

| Item | Status | Rule |
|---|---|---|
| Spanish first, Guatemala locale | DECIDED — C01 | Staff and enrollment UI start in Spanish |
| Tenant pass branding and preview | DECIDED — user discovery | Show business logo/colors/program/reward and preview before publish |
| No branch label on pass | DECIDED — user discovery | Exclude from MVP pass layout |
| Platform product name/logo | OPEN — OPEN-011 | Do not invent a final name or logo |
| Exact color/typeface identity | OPEN — OPEN-011 | Use neutral accessible shadcn semantic tokens until assets/identity are selected |
| Light/dark mode | ASSUMED | Light theme for MVP; preserve semantic token structure for future dark theme |

## Semantic token implementation

Use CSS custom properties in `src/app/globals.css` and map shadcn/ui tokens to them. Token names and semantic roles are DECIDED by the engineering baseline; exact brand values below are ASSUMED temporary neutral placeholders and must not be presented as final identity.

```css
:root {
  --background: 0 0% 100%;
  --foreground: 222 20% 12%;
  --card: 0 0% 100%;
  --card-foreground: 222 20% 12%;
  --popover: 0 0% 100%;
  --popover-foreground: 222 20% 12%;
  --primary: 222 24% 22%;
  --primary-foreground: 0 0% 100%;
  --secondary: 210 20% 96%;
  --secondary-foreground: 222 24% 22%;
  --muted: 210 20% 96%;
  --muted-foreground: 215 12% 42%;
  --accent: 210 20% 94%;
  --accent-foreground: 222 24% 22%;
  --destructive: 0 72% 45%;
  --destructive-foreground: 0 0% 100%;
  --border: 214 18% 88%;
  --input: 214 18% 88%;
  --ring: 222 24% 35%;
  --radius: 0.625rem;
  --success: 150 55% 34%;
  --warning: 36 90% 42%;
  --error: 0 72% 45%;
  --info: 205 75% 42%;
}
```

These HSL placeholders are neutral accessibility-oriented scaffolding, not business pass colors. Tenant colors are applied only to the wallet pass using validated branding fields; do not let tenant-selected colors alter staff permission or status semantics.

## Typography, layout, and components

- Use the system sans-serif stack until a licensed brand typeface is selected; do not add a font dependency just for branding.
- Use shadcn/ui primitives and semantic CSS Modules per the engineering baseline. Avoid long utility strings in feature JSX.
- Establish clear hierarchy: page title, section title, body, label, helper text, and high-emphasis numeric progress. Use tabular numerals for progress and report figures where supported.
- Phone-first staff workflows: large readable customer name, prominent progress, clear single primary confirmation action, and a visible manual QR/code fallback.
- Frequent controls should target approximately 44×44 CSS px. Never rely on hover for primary action.
- Use Dialog/AlertDialog only for short confirmations; use Sheet for contextual details/editing on wide layouts and full-width or bottom-sheet patterns on phones where appropriate.
- Use status colors only with text/icon labels; color alone must not convey reward eligibility or failure.
- Use lucide-react icons if the scaffold confirms the proposed default. Keep iconography restrained and consistent.

## Pass appearance and preview

- Business logo, business-selected primary color, program name, reward description, stamp progress, and reward eligibility are the MVP content hierarchy.
- No branch label in MVP.
- Preview must show both the current pass and draft appearance before publish. Clearly indicate that provider-specific layouts may differ slightly.
- Confirm contrast and legibility on phone screens and wallet dark/light surfaces. Do not allow arbitrary low-contrast colors to make key text unreadable; provide an accessible fallback.
- Apple and Google pass-specific fields/assets depend on verified provider requirements (OPEN-001).

## Voice, date, number, and accessibility

- Write Spanish copy for Guatemala in direct, friendly language. Buttons start with clear verbs, e.g. “Confirmar sello”, “Canjear recompensa”, “Guardar cambios”.
- Errors explain what happened and the next action; never show raw database/provider errors.
- Format dates in Guatemala locale/timezone and currency as GTQ where displayed.
- Meet WCAG AA contrast for normal text, visible keyboard focus, accessible labels, camera permission help, and a manual scan fallback.

## Do / Don't

**Do:** make staff progress and the next action obvious; keep owner setup guided; show branding previews; preserve semantic tokens; label every status.  
**Don't:** invent a platform brand, add branch labels, use tenant colors for security signals, use color-only status, expose technical error text, or make primary phone actions hover-dependent.

## Future design reference page

After selecting product identity, create `/design` as the first polished UI screen. It should show semantic color tokens, typography roles, buttons, inputs, cards, tables, dialogs/sheets, status badges, alerts, loading/empty/error states, camera permission states, and a wallet pass preview using synthetic tenant branding. Update this file with exact hex values, font source/license, spacing/radius/shadow/motion values, and theme code before broad feature UI implementation.
