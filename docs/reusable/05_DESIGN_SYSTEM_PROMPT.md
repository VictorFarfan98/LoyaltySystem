# Design System Prompt (ChatGPT)

Use after the product docs exist and the brand assets (brand book, logo) are uploaded to the ChatGPT project. Output becomes docs/canonical/14_DESIGN_SYSTEM.md. Example of the expected depth: Pelupet's 14_DESIGN_SYSTEM.md.

```text
Create the design system doc (14_DESIGN_SYSTEM.md) that Codex will follow to build this app's look and feel. Base it on the uploaded brand assets, the product docs and our conversations. Write exact, copyable rules, not descriptions. Stack per 00_ENGINEERING_STANDARDS (shadcn/ui, Tailwind, CSS variables in src/app/globals.css).

Include:
1. Brand essence (3–5 lines).
2. Tokens with exact values: colors (light/dark if applicable) as hex AND shadcn CSS variable names; typography (families with source/license, scale, weights, line heights, usage per text role); spacing; radius; shadows; borders; motion; breakpoints and layout widths.
3. Theme code: the exact globals.css variables block and Tailwind additions. If the app is multi-tenant with tenant branding, define how a tenant preset is applied.
4. Components: for each shadcn/ui component used, which variants when, sizes, brand styling, status badge colors for each domain state.
5. Layout patterns: app shell, page structure, forms, lists/tables, detail pages, dashboards, mobile/tablet behavior.
6. States: loading, empty, error, success, disabled.
7. Iconography, imagery and logo usage.
8. Voice and tone: per audience, button label style, error message style, languages, date/number/currency formats.
9. Accessibility: contrast, focus, touch targets.
10. Do / Don't list.
11. A /design reference page spec showing every token and component, built first and copied for every later screen.

Rules:
- Mark each item DECIDED (with source) or ASSUMED.
- Don't invent brand choices silently: unresolved items go in a final list formatted as OPEN register entries with proposed defaults (they will be moved into C03).
```
