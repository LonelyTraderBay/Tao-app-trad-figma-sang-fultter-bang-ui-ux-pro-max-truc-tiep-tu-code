---
paths:
  - "flutter_app/lib/features/**/presentation/**"
  - "flutter_app/lib/shared/widgets/**"
  - "flutter_app/lib/app/theme/**"
---
# UI Visual Standards (lazy-loaded for presentation work)

Full audit-domain map (~24 domains, what enforces each, exact local command):
`docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` — read it before
creating a new page. Visual token contract: root `DESIGN.md`. AGENTS.md wins on
product/financial rules.

## Reuse ladder

Shared primitives before any local widget: `VitAppShell`, `VitPageLayout`,
`VitPageContent`, `VitHeader`, `VitBottomNav`, `VitCard`, `VitCtaButton`,
`VitInput`, `VitTabBar`, `VitSegmentedChoice`, `VitPresetChipRow`,
`VitSectionHeader`, `VitTaskCard`, `VitServiceTile`, `VitAccentIconBox`,
`VitCommunityRulesLink`, `VitStatusPill`. Theme tokens only
(`AppColors`, `AppSpacing`, `AppRadii`, `AppTextStyles`); dark theme is the
baseline; phone-first at 360 px.

## Domain contracts (standard doc → verify command, run from flutter_app/)

| Domain | Standard | Verify |
| --- | --- | --- |
| Page rhythm | `standards/Page-Rhythm-Standard.md` | `dart run tool/page_rhythm_audit.dart --check` + `flutter test test/quality/page_rhythm_audit_sync_guardrail_test.dart test/quality/page_rhythm_spacing_scale_guardrail_test.dart` (phone QA: `page_rhythm_phone_visual_qa_test.dart`) |
| Content width | `standards/Page-Content-Width-Standard.md` | `dart run tool/page_content_width_audit.dart --check` |
| Card tiles | `standards/Card-Tile-Standard.md` | `dart run tool/card_tile_audit.dart --check --strict-full` |
| Segment pills | `standards/Segment-Pill-Standard.md` | `dart run tool/segment_pill_audit.dart --check --strict-full` |
| Scroll auto-hide | `standards/Scroll-Auto-Hide-Standard.md` | `flutter test test/quality/scroll_auto_hide_guardrail_test.dart` |
| Service tile badges | `standards/Service-Tile-Badge-Standard.md` | `flutter test test/quality/service_tile_badge_guardrail_test.dart` |
| Task cards | `standards/Task-Card-Standard.md` | `flutter test test/quality/task_card_guardrail_test.dart` |
| Accent icon boxes | `standards/Accent-Icon-Box-Standard.md` | `flutter test test/quality/accent_icon_box_guardrail_test.dart` |
| Notice acknowledgement | `standards/Notice-Acknowledgement-Standard.md` | `flutter test test/quality/notice_acknowledgement_guardrail_test.dart` |

(`standards/` = `docs/02_FLUTTER_MIGRATION/standards/`.)

## Hard rules (P0 in audits)

- Tab roots use `VitPageRhythm.compact`; major sections are direct
  `VitPageContent` children; no `SizedBox(height: AppSpacing.x*)` rhythm gaps.
- Never wrap `VitTabBar`/`VitSegmentedTabBar` in `VitCard`/`DecoratedBox` —
  pills draw their own outline. Binary/2–4-option toggles use
  `VitSegmentedChoice`; preset rows use `VitPresetChipRow`.
- No local `_SegmentButton` / `_FilterButton` / `_AccentIcon` /
  `_CommunityRules*` duplicates — delete after migrating to shared widgets.
- Radius: only `AppRadii` tokens (`inputRadius` 14 controls, `cardRadius` 16,
  `cardLargeRadius` 24 hero, `smRadius` 8 micro, `pillRadius` 999). No
  `BorderRadius.circular()` outside `app_radii.dart`; `mdRadius` /
  `headerActionRadius` are legacy — do not use for new UI.
- Include loading / empty / error / offline / submitting / success states where
  the flow needs them.
- Post-action acknowledgements use `showVitNoticeSheet` only — not `SnackBar`,
  not `Positioned` success toasts, not sticky Share+Continue. Sticky footers
  stay valid only for in-progress form/wizard CTAs.
