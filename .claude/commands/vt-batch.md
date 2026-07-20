---
description: Orchestrate one VitTrade batch — Plan (if needed) → Build → Trim review → Verify
argument-hint: "[domain:] <batch description or file list>"
allowed-tools: Agent, Skill, Read, Bash(cd flutter_app && *), Bash(git status *), Bash(git diff *), Bash(git status), Bash(git diff)
---

# /vt-batch

User request / batch scope: $ARGUMENTS

You are the **orchestrator** only. Prefer Agent + Skill tools; keep this
context clean. Follow `.claude/rules/session-discipline.md`.

## Step 0 — Scope

If `$ARGUMENTS` is empty or ambiguous, use AskUserQuestion once to pin:

- design domain(s) if any (page-rhythm, notice-acknowledgement, …)
- file list or module path
- “plan only” vs “implement one batch”

If the work clearly spans **>~10 files** or multiple modules and no batch
plan exists yet, go to Step 1. If a concrete 5–10 file batch is already
named, skip to Step 2.

## Step 1 — Plan (optional)

Invoke Agent `flutter-batch-planner` with the user request. Expect an ordered
list of batches (5–10 files each) and domain tags. Present Batch 1 to the
user; **implement only Batch 1** unless they explicitly say otherwise.

## Step 2 — Build

Invoke Agent `flutter-batch-builder` with:

- exact file list
- domain(s)
- constraint: one batch only; self-verify before return

(Builder preloads `vittrade-minimal-review`, `vittrade-design-domain`,
`vittrade-batch-gate`, `vittrade-ui-checklists`.)

## Step 3 — Trim review

Invoke Agent `flutter-diff-trimmer` on the batch diff. Relay findings to the
builder only if there are actionable `delete:` / `reuse-vit:` items; otherwise
continue.

## Step 4 — Verify

- Always run Skill `vittrade-batch-gate` mindset, then either:
  - focused analyze + tests named by the builder, or
  - slash `/vt-verify` when structural/router/shared changed
- If the batch touched high-risk wallet/P2P/security UI, also run Skill
  `vittrade-product-verify`.

## Step 5 — Report

Return a compact handoff:

```
Batch: <name>
Files: …
Domains: …
Verify: PASS|FAIL (cite commands)
Trim: Lean already | N findings (summary)
Next: new chat for Batch N+1 | done
```

Do **not** start Batch 2 in this session.
