# Shared Component Extraction — Wave S0–S3

**Status:** DONE (2026-07-14)  
**Goal:** Replace duplicated local `_Foo` UI with shared `Vit*` primitives; extract only when ≥3 call sites share the same layout.

## Wave S0 — Replace only (no new widgets) ✅

| Local | Shared target | Done |
| --- | --- | --- |
| Thin `_StatusPill` → inline `VitStatusPill` | launchpad swap, trade_terminal tools, referral rewards | ✅ |
| `_Tabs` → inline `VitTabBar` / `VitSegmentedTabBar` | all trade_compliance + launchpad thin wrappers | ✅ |
| `_SortChip` → `VitChoicePill` | position dashboard, referral history/rewards | ✅ |
| `_MetricCard` → `VitMetricCard` | deferred when layout ≠ accent-bar form | skipped (non-goals) |

## Wave S1 — P0 shared ✅

| Widget | File | Pilots |
| --- | --- | --- |
| `VitInfoCallout` | `vit_info_callout.dart` | earn staking/savings info banners |
| `VitProgressBar` (`progress:`) | `vit_progress_bar.dart` | p2p selfie, bots suitability, rewards hub + existing call sites |
| `VitKeyValueRow` | `vit_key_value_row.dart` | trade_copy confirm, staking history; `VitInfoRow` for denser rows |

## Wave S2 — P1 shared ✅

| Widget | File | Pilots |
| --- | --- | --- |
| `VitLegendItem` | `vit_legend_item.dart` | staking multi-chain, savings what-if / rebalance |
| `VitStepList` / `VitStepItem` | `vit_step_list.dart` | staking governance |
| `VitFaqAccordion` (tile) + `VitFaqList` | `vit_faq_accordion.dart` | p2p/referral tiles; support list |
| `VitStatsGrid` / `VitStatCell` | `vit_stats_grid.dart` | staking advanced orders |

## Wave S3 — Format + preview/confirm ✅

| API | File | Pilots |
| --- | --- | --- |
| `VitFormat` | `shared/utils/vit_format.dart` | profile email mask, referral USD |
| `showVitPreviewConfirmSheet` | `vit_preview_confirm_sheet.dart` | wallet dust converter + widget test |

## Exit criteria

- [x] New widgets exported from `shared/widgets/widgets.dart`
- [x] Pilot migrations landed
- [x] `dart analyze` clean on shared + migrated modules
- [x] Focused test: `showVitPreviewConfirmSheet returns true on confirm`

## Follow-up sweep (2026-07-14) — `_InfoBanner` / ProgressBar ✅

- Removed all remaining `_InfoBanner` locals (earn staking, dca, launchpad, bots terms, arena→`VitBanner`, p2p merchant).
- Removed library `ProgressBar`, `_ProgressTrack`, `_ProgressLine` across savings portfolio, p2p hub/kyc/reviews/claim, trade bots risk, profile VIP, rewards hub.
- **Intentional keep:** `provider_application_progress_intro.dart` `_ProgressBars` (segmented multi-step, not a linear track).
- **Skipped shape mismatch:** trade_copy / predictions `_InfoBox` (bullet lists / accent body text).

## Non-goals (still out of scope)

- Rewrite every icon-stack `_MetricCard` into `VitMetricCard`
- Merge Arena / Predictions product formatters into `VitFormat`
- New pub dependencies
