# AGENTS.md — <App name>

<Describe the repository and intended users in two or three lines.>

## Source of truth

C00 owns navigation, readiness and precedence. Canonical project decisions govern implementation; R00 supplies engineering defaults.

## Work a task

- Read only the task's cited sections/rule IDs and relevant implementation. Reuse unchanged context; copy the referenced pattern.
- Resolve routine details within approved contracts. Batch missing product/security/data-retention decisions or material conflicts with recommendations before dependent work.
- Never modify canonical docs unless the task explicitly requests it.
- Run every verification command and named case in the task.
- Update docs/codex/PROGRESS.md and end with the R04 Task completion report.
- A task authorizes only its own scope; verify dependencies before starting.

## Execution policy

<Define branch/commit/PR/CI ownership once here. State the database lifecycle and reset boundaries. Task prompts reference this policy; never infer CI success or disposable data. R04 owns verification/reporting defaults.>

Apply R04's Token-efficiency preflight before every prompt handoff/task, including relevant supported configuration. Every prompt handoff and saved task header must name the recommended model, reasoning effort and escalation tier, with a short rationale in the handoff. These are standing instructions, not dependent on a chat reminder.

## Architecture

- Thin Route Handler → Controller → Service → explicit repository/capability (R00 §3).
- One authoritative RPC for an atomic business operation; audit in the same transaction (R00 §6).
- Preserve caller JWT, RLS and scoped permissions; no normal service-role business path (R00 §§7–8).
- Server data, forms and transient state have distinct owners (R00 §§10–14).
- Semantic CSS Modules and shared primitives; project design tokens (R00 §§15–16).
- No sensitive logs; meaningful success/denial/rollback tests (R00 §§19–20).

## Reference implementations

See docs/codex/PROGRESS.md.

## Current checkpoint

See C00 Readiness.

Never read docs/archive/ or docs/chatgpt-sources/ during implementation.
