---
name: vittrade-minimal-review
description: >
  When reviewing a VitTrade batch diff for over-engineering — local widgets
  duplicating Vit* primitives, one-caller helpers, unnecessary wrappers, or
  speculative abstractions. Fire at batch completion gate, or when the user
  says minimal review, ponytail review, or review diff for bloat.
---

Review the current (or named) batch diff for unnecessary complexity. One
finding per line. Best outcome: shorter diff that still passes the plan gate.

## Format

`L<line>: <tag> <what>. <replacement>.` or `<file>:L<line>: ...`

Tags: `delete:` · `yagni:` · `shrink:` · `reuse-vit:` (name the Vit* widget).

## Do not flag

- Financial preview/confirm, masked sensitive data, risk copy.
- Required migration from local widget → shared primitive.
- Loading / empty / error / offline / submitting / success states the plan
  or `AGENTS.md` require.
- Guardrail tests under `flutter_app/test/quality/`.
- Arena points-only / Prediction Markets boundary copy fixes.
- Notice-ack migrations to `showVitNoticeSheet`.

## Scoring

End with `net: -<N> lines possible.` or `Lean already. Ship.`

## Batch gate

When invoked as part of `/vt-batch` or batch completion:

1. Findings only for **this batch's** diff.
2. Safe trims may be applied by `flutter-batch-builder` in the same turn;
   this skill reports — the builder edits.
3. Do not defer obvious wrapper deletes unless blocked.

## Gotchas

- Single-layer wrappers that only forward to `VitCard` / `VitCtaButton` are
  almost always `reuse-vit:` or `delete:`.
- Do not invent a new shared widget for a one-off layout — prefer inline.
- New pub dependencies are out of scope unless the task asked for them.

## Boundaries

Complexity only. Correctness / security → `code-review-and-quality` or
`/vt-review`. Whole-module debt → `flutter-architecture-sweep`.
