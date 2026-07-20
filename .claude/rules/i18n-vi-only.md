---
paths:
  - "flutter_app/lib/features/**/presentation/**"
  - "flutter_app/lib/shared/**"
---
# Chính sách ngôn ngữ vi-VN-only (I18N-1, DEC-i18n Nhánh A)

- User-facing product copy is **Vietnamese with full diacritics, written
  inline** — no ARB/gen-l10n wrapping at this mock-UI stage (single-language
  product, backend not final). Upgrade path when a real second locale arrives:
  `flutter gen-l10n` per module (runtime locale already wired, I18N-2).
- **No NEW user-facing English strings** in the presentation layer. Ratchet:
  `flutter_app/test/quality/i18n_vi_only_guardrail_test.dart` + baseline
  `i18n_vi_only_baseline.txt` (line count = source of truth for remaining
  English debt; pay it down when touching a file — FIXING a baseline string
  means translating it, not rewording it in English).
- Heuristic gotcha: diacritic-free Vietnamese ("mua nhanh") has
  false-positived as English before. The guardrail only flags strings with
  ≥2 English marker words; write new copy with full diacritics and it is safe.
  Do not add special-case exemptions to the guardrail — rephrase the copy.
- Out of scope: technical labels (semanticIdentifier, route paths, Keys,
  package/API names).
