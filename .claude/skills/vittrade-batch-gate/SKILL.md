---
name: vittrade-batch-gate
description: >
  When closing a VitTrade implementation batch — run the batch completion
  self-check (minimal-diff scan, domain audit if named, analyze + focused
  tests) and cite evidence. Fire at end of flutter-batch-builder work or
  when /vt-batch reaches the verify step.
---

# Batch completion gate

Do this before marking a batch complete (do not ask the user first):

1. **Diff scan** — invoke mindset of `vittrade-minimal-review` on this batch
   only; trim safe bloat inline if you are the builder.
2. **Domain** — if the plan named design domains, run their audit commands
   and guardrail tests (`vittrade-design-domain` / `/vt-audit`).
3. **Verify** — at minimum:
   - `cd flutter_app && flutter analyze` (or scoped analyze if documented)
   - focused `flutter test …` for touched modules
   - full `/vt-verify` when router, shared layout, or broad structure changed
4. **Cite evidence** in the completion message (commands + PASS).

## Refusal cases

- Do not mark complete if analyze/tests fail.
- Do not expand into the next batch in the same session — hand off.

## Gotchas

- PostToolUse already runs `dart format` on edits — do not re-format the
  whole tree unless `/vt-verify` requires the CI gate.
- Windows CRLF can fake format failures — check EOL before declaring FAIL.
