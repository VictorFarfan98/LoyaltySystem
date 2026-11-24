# ChatGPT Project Setup

## Sources to upload
- New project: 06_REUSABLE_ENGINEERING_FRAMEWORK.md from any existing repo's docs/chatgpt-sources/, plus brand assets if any.
- Existing project: prepare the 6 source bundles when making a planning handoff, then replace old uploads. Do not regenerate/upload for every implementation or progress edit; Codex uses repository sections, never these copies.

## Project instructions (generic)

```text
This project designs [APP NAME].

The repository is the source of truth; the uploaded source bundles are generated copies. Newer uploads override earlier chat content. Precedence when docs conflict: latest C03 DEC ledger decision → C02 domain rules → C01 product requirements → subsystem docs → technical blueprints → C10 plan → reusable baseline (00_ENGINEERING_STANDARDS).

Rules:
- Stack and engineering conventions come from 00_ENGINEERING_STANDARDS (default: Supabase + Vercel + Next.js; Route Handler → Controller → Service → Repository → one PostgreSQL RPC per business operation; shadcn/ui + Tailwind). Don't re-discuss them unless I ask or the domain truly needs an exception; record exceptions in C03.
- Your role: product and design decisions, canonical docs, roadmap, milestone reviews. Codex implements. Don't write implementation task prompts; Codex generates them per milestone in R04 format.
- Design wide, build thin: decide tenancy, roles/permissions, RLS approach, RPC conventions, entities and lifecycles, time, money, locale, deletion/audit, files, notifications, environments, seeds and testing up front, so no implementation task leaves a design decision to a small model.
- Each fact lives in exactly one doc (per 02_PROJECT_SPEC_TEMPLATE). Every decision becomes a C03 DEC entry; every unknown becomes an OPEN item with a proposed default.
- Fewer turns: batch known consequential questions with proposed defaults; use judgment for routine details inside approved contracts. Deliver changed sections or edited artifacts without reprinting unchanged files.
- Tell me when this chat should be checkpointed (~30–40 turns, topic change, or signs of forgetting).

App-specific notes:
[3–6 lines]
```

## Kickoff prompt (new app, first chat)

```text
I want to design a new application using my reusable engineering baseline (06_REUSABLE_ENGINEERING_FRAMEWORK.md in this project's sources).

Treat 00_ENGINEERING_STANDARDS as the default for stack, architecture, code organization, frontend state, API/RPC conventions, Supabase/RLS, styling, testing and deployment, including §25 scaffold defaults. Don't re-discuss those unless this product has a concrete reason to differ.

The idea: [what it is, who it's for, the problem, must-haves, constraints, brand assets if any]

Process (minimize turns):
1. Using 01_NEW_PROJECT_DOMAIN_DISCOVERY_CHECKLIST, ask ALL discovery questions in one numbered, grouped list, each with a proposed default. Classify unknowns per its §18. No docs yet.
2. After my answers, give a one-page design summary: tenancy, actors and permission matrix, core entities and lifecycles, invariants, money rules, scheduling/time, media, read models, the Milestone 1 thin slice. Wait for approval.
3. Produce the canonical docs per 02_PROJECT_SPEC_TEMPLATE (merge docs freely for a small app; add subsystem docs only where complexity requires), AGENTS.md from AGENTS_TEMPLATE, C03 with DEC ledger and OPEN register, and C10 as a full one-line roadmap per 03_HOW_TO_USE_THIS_TEMPLATE Step 6. Each fact in exactly one doc.
4. Then run 05_DESIGN_SYSTEM_PROMPT to produce 14_DESIGN_SYSTEM.md.
5. Suggest 3–6 app-specific lines for my project instructions.
Recommend a checkpoint whenever this chat gets long.
```

## Checkpoint prompt (any long chat)

```text
Checkpoint. Before I start a fresh chat:
1. List every decision from this chat not yet in the docs, as C03 DEC ledger entries, each naming its owning doc.
2. List every unresolved item as OPEN entries with proposed defaults.
3. Give only changed replacement sections, or paths to edited artifacts; do not repeat unchanged files.
4. Give a 5–10 line "where we are / what's next" note to paste as the first message of the next chat.
```

## Decisions → repo
Decisions reach the repo through R03 Step 7.6. Regenerate/re-upload bundles when preparing the next planning handoff.
