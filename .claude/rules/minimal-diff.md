---
paths:
  - "flutter_app/**"
---
# Minimal Diff (Ponytail-lite) — mirror of .cursor/rules/vittrade-minimal-diff.mdc

Shortest working diff that meets the active plan/prompt acceptance gate.

## Ladder (stop at the first rung that holds)

1. **Reuse codebase** — `Vit*` shared widgets and theme tokens before any
   local widget.
2. **Shortest diff** that passes the current batch gate and focused tests.
3. **No speculative code** — no one-caller abstraction, one-product factory,
   once-used helper, or new pub dependency unless explicitly requested.
4. **Deletion over addition** when replacing local duplicates with shared
   primitives.

## Never cut (quality floor)

- Input validation at trust boundaries; preview/confirm for financial,
  security, and P2P flows.
- Loading / empty / error / offline / submitting / success states the flow
  requires.
- Required tests and `test/quality/` guardrails.
- Open Arena points-only copy; Prediction Markets boundaries (AGENTS.md).

AGENTS.md and the active execution prompt **override YAGNI** — do not skip
required migration scope. Deliberate shortcut with a known ceiling:
`// ponytail: <ceiling> — <upgrade path>`.

End-of-batch self-check: run the `flutter-diff-trimmer` agent on the diff.
