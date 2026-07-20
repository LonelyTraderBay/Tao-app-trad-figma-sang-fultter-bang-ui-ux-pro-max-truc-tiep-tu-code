---
paths:
  - "flutter_app/tool/**"
  - "flutter_app/test/quality/**"
---
# Audit Tools & Quality Guardrails

`flutter_app/tool/*_audit.dart` + `flutter_app/test/quality/*` are the
enforcement layer for the ~24 design-consistency domains
(`docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md`).

## Gotchas that have caused real regressions

- Audit tools hardcode symbol names as **literal strings** — after renaming
  any router class/function or widget the audits match on, grep
  `flutter_app/tool/` for the OLD name and update matchers.
- Baselines are **ratchets**: line count only goes down. Never append to
  `i18n_vi_only_baseline.txt` or peers to silence a failure — fix the source.
  The `Color(0x` ratchet counts `test/` too.
- Cross-OS: audits must produce byte-identical artifacts on Windows and Linux
  CI — sort explicitly, normalize path separators, write LF line endings
  explicitly (the repo-wide `eol=lf` `.gitattributes` fix sits on unmerged
  branch b7b5c0d0 — until it lands, tools must not rely on git normalization),
  never depend on filesystem enumeration order. Full checklist: memory
  `feedback_cross_os_ci_nondeterminism` (10 bug classes).
- Regenerated artifacts (CSV/MD under `docs/02_FLUTTER_MIGRATION/audits/`) are
  outputs — regenerate via the tool, do not hand-edit.

## When a quality guardrail test fails

Prefer the saved workflow `.claude/workflows/fix-quality-guardrails.js`
(discovers failing `test/quality/` tests, regens stale artifacts, fixes real
violations, verifies, reviews) — propose it to the user first (1-line confirm).
