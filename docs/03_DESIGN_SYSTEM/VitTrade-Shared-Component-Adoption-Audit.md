# VitTrade Shared Component Adoption Audit

**Generated:** 2026-06-18  
**Scope:** Flutter UI screens, feature presentation widgets, shared layout, and shared widgets.  
**Primary question:** Have all screens fully adopted the project shared components?

## Verdict

Not fully yet.

The app has strong shared-component adoption at the routed-screen level, especially for the Home UI rollout baseline: P0 module gates pass, strict typography has zero residual debt, and all 414 routed screens pass responsive and copy-boundary checks. However, the current repo cannot honestly be marked as "fully using all shared components" because body-component audit still reports 17 grade-B screens and 5 fullscreen Tool screens, token audit still reports residual root-page bundle debt in Launchpad, and shared widget/layout primitives themselves still contain token debt.

This is a partial-complete state:

- Screen shell/layout adoption is broad and stable.
- P0 routes are clean by the current guardrail.
- Many features still rely on local component-like widgets inside `presentation/widgets`.
- Launchpad remains the main route-bundle hotspot.
- Several shared primitives need their own cleanup before they can be considered a clean foundation.

## Evidence Commands

Run from `flutter_app/` unless stated otherwise:

```bash
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
```

The body-component artifacts were stale before this audit and were regenerated:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`

## Inventory Summary

| Area | Count |
| --- | ---: |
| Shared Dart files under `shared/layout` and `shared/widgets` | 44 |
| Public `Vit*` classes/enums found in shared layout/widgets | 85 |
| Feature presentation UI files scanned | 1,494 |
| Feature page files scanned | 607 |
| Entry screen files scanned | 390 |
| Routed screens in body-component audit | 414 |
| Token audit rows | 2,587 |

## Body Component Audit Status

`dart run tool/body_component_consistency_audit.dart --check` now reports current artifacts:

| Metric | Count |
| --- | ---: |
| Total routed screens | 414 |
| Grade A | 392 |
| Grade B | 17 |
| Grade Tool | 5 |
| Grade C/D | 0 |
| P0/P1 issues | 0 |
| P2 issues | 14 |
| P3 issues | 400 |

Status dimensions:

| Dimension | Current status |
| --- | --- |
| Layout | 413 pass, 1 warn |
| Surface | 409 pass, 5 warn |
| Controls | 413 pass, 1 warn |
| State | 404 pass, 10 warn |
| Financial safety | 212 pass, 200 not applicable, 2 warn |
| Responsive | 414 pass |
| Copy boundary | 414 pass |

## Non-A / Tool / P2 Routed Screens

These screens are the current body-component follow-up list.

| Feature | Screen | Grade | Priority | Main issue |
| --- | --- | --- | --- | --- |
| `arena` | `ArenaChallengeDetailPage` | B | P3 | acceptable polish debt |
| `arena` | `ArenaPredictionBridgeFoundationPage` | B | P3 | acceptable polish debt |
| `arena` | `ConnectedEcosystemProductionPage` | B | P3 | acceptable polish debt |
| `earn` | `SavingsAutoPilotPage` | B | P3 | acceptable polish debt |
| `earn` | `StakingProofOfReservesPage` | B | P3 | acceptable polish debt |
| `enterprise_states` | `EnterpriseStatesPage` | Tool | P3 | fullscreen manual visual QA |
| `launchpad` | `LaunchpadAddressBookPage` | B | P2 | surface consistency needs review |
| `launchpad` | `LaunchpadBatchClaimPage` | B | P2 | state coverage needs review |
| `launchpad` | `LaunchpadBridgeComparePage` | B | P2 | state coverage needs review |
| `launchpad` | `LaunchpadClaimReceiptPage` | B | P2 | state coverage needs review |
| `launchpad` | `LaunchpadDcaBuilderPage` | B | P2 | surface consistency needs review |
| `launchpad` | `LaunchpadDetailPage` | B | P2 | surface consistency needs review |
| `launchpad` | `LaunchpadEventLogPage` | B | P2 | state coverage needs review |
| `launchpad` | `LaunchpadLimitOrdersPage` | B | P2 | state coverage needs review |
| `launchpad` | `LaunchpadRebalancePage` | B | P2 | surface consistency needs review |
| `launchpad` | `LaunchpadReceiptPage` | B | P2 | financial safety needs manual review |
| `launchpad` | `LaunchpadSwapAggregatorPage` | B | P2 | state coverage needs review |
| `p2p` | `P2PChatPage` | Tool | P2 | fullscreen manual visual QA |
| `referral` | `ReferralHomePage` | B | P3 | acceptable polish debt |
| `trade` | `AdvancedChartPage` | Tool | P2 | fullscreen manual visual QA |
| `trade` | `FuturesPage` | Tool | P3 | fullscreen manual visual QA |
| `trade` | `TradingBotsPage` | Tool | P2 | fullscreen manual visual QA |

Feature-level body-component pressure:

| Feature | Screens | A | B | Tool | P2 | Shared refs | Custom body count |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `launchpad` | 24 | 13 | 11 | 0 | 11 | 445 | 437 |
| `trade` | 91 | 88 | 0 | 3 | 2 | 2,637 | 1,202 |
| `arena` | 26 | 23 | 3 | 0 | 0 | 638 | 440 |
| `earn` | 70 | 68 | 2 | 0 | 0 | 1,617 | 916 |
| `p2p` | 77 | 76 | 0 | 1 | 1 | 1,663 | 1,125 |
| `referral` | 5 | 4 | 1 | 0 | 0 | 98 | 96 |
| `enterprise_states` | 1 | 0 | 0 | 1 | 0 | 41 | 23 |

## Token Audit Status

`dart run tool/design_token_consistency_audit.dart --check` reports:

| Scope | Rows | Debt rows | Total debt | Non-pass rows |
| --- | ---: | ---: | ---: | ---: |
| `root_page` | 606 | 0 | 0 | 42 |
| `root_page_bundle_summary` | 389 | 12 | 343 | 79 |
| `feature_widget` | 1,548 | 170 | 1,118 | 291 |
| `shared_layout` | 11 | 9 | 73 | 9 |
| `shared_widget` | 33 | 29 | 111 | 30 |

Important passes:

- `p0_markets_debt=0`
- `p0_p2p_debt=0`
- `p0_profile_debt=0`
- `p0_trade_debt=0`
- `p0_wallet_debt=0`
- `strict_typography_gate=zero_residual pass`

Important residuals:

- `total_debt=1645`
- `scope_root_page_bundle_summary_debt=343`
- `scope_feature_widget_debt=1118`
- `scope_shared_layout_debt=73`
- `scope_shared_widget_debt=111`

## Root Page Bundle Debt

All current root-page bundle debt is in `launchpad`.

| Bundle | Debt | Status | Main debt type |
| --- | ---: | --- | --- |
| `launchpad_swap_aggregator_page.dart` | 37 | fail | local spacing/container/surface debt |
| `launchpad_abi_diff_page.dart` | 37 | fail | local spacing/container/surface debt |
| `launchpad_page.dart` | 35 | fail | local spacing/container/surface debt |
| `launchpad_event_log_page.dart` | 33 | fail | local spacing/container/surface debt |
| `launchpad_risk_analytics_page.dart` | 33 | exception | allowed `custompainter`, still debt-bearing |
| `launchpad_batch_claim_page.dart` | 30 | fail | local spacing/container/surface debt |
| `launchpad_address_book_page.dart` | 28 | fail | local spacing/container/surface debt |
| `launchpad_notif_sound_page.dart` | 27 | fail | local spacing/container/surface debt |
| `launchpad_performance_page.dart` | 25 | fail | local spacing/container/surface debt |
| `launchpad_limit_orders_page.dart` | 24 | fail | local spacing/container/surface debt |
| `launchpad_portfolio_page.dart` | 18 | fail | local spacing/container/surface debt |
| `launchpad_receipt_page.dart` | 16 | fail | local spacing/container/surface debt |

## Feature Widget Debt Hotspots

Feature-widget debt currently covers 132 unique files, 170 audit rows, and 1,118 total raw debt.

Top unique debt files by max per-row debt:

| File | Occurrences | Max debt | Raw sum debt |
| --- | ---: | ---: | ---: |
| `launchpad_abi_diff_entries.dart` | 2 | 22 | 44 |
| `launchpad_address_book_sheet_common.dart` | 2 | 21 | 42 |
| `launchpad_batch_claim_selection.dart` | 2 | 17 | 34 |
| `launchpad_event_log_misc_widgets.dart` | 2 | 17 | 34 |
| `launchpad_risk_report_common.dart` | 2 | 17 | 34 |
| `launchpad_abi_diff_summary.dart` | 2 | 15 | 30 |
| `launchpad_swap_aggregator_quotes.dart` | 2 | 15 | 30 |
| `launchpad_home_shared_widgets.dart` | 2 | 14 | 28 |
| `launchpad_notif_sound_categories.dart` | 2 | 14 | 28 |
| `launchpad_risk_tabs_overview.dart` | 2 | 14 | 28 |
| `launchpad_receipt_details_next_steps.dart` | 2 | 13 | 26 |
| `dca_overview_demo_metrics.dart` | 1 | 12 | 12 |
| `launchpad_notif_sound_footer.dart` | 2 | 11 | 22 |
| `launchpad_swap_aggregator_history_settings.dart` | 2 | 11 | 22 |
| `launchpad_swap_aggregator_input.dart` | 2 | 11 | 22 |
| `savings_notification_preferences_delivery.dart` | 1 | 11 | 11 |
| `staking_api_documentation_common.dart` | 1 | 11 | 11 |
| `staking_tax_guide_jurisdictions.dart` | 1 | 11 | 11 |

## Shared Foundation Debt

The shared layer is widely used, but it is not token-clean yet.

Shared layout debt:

| File | Debt | Status |
| --- | ---: | --- |
| `shared/layout/vit_status_bar.dart` | 24 | fail |
| `shared/layout/vit_phone_frame.dart` | 11 | fail |
| `shared/layout/vit_bottom_nav.dart` | 10 | fail |
| `shared/layout/vit_header.dart` | 8 | fail |
| `shared/layout/vit_page_content.dart` | 7 | fail |
| `shared/layout/vit_header_action_button.dart` | 6 | fail |
| `shared/layout/vit_page_layout.dart` | 3 | warn |
| `shared/layout/vit_top_chrome.dart` | 3 | warn |
| `shared/layout/vit_auto_hide_header_scaffold.dart` | 1 | warn |

Shared widget debt:

| File | Debt | Status |
| --- | ---: | --- |
| `shared/widgets/vit_module_components.dart` | 12 | fail |
| `shared/widgets/vit_tab_bar.dart` | 9 | fail |
| `shared/widgets/vit_status_pill.dart` | 8 | fail |
| `shared/widgets/vit_card.dart` | 7 | fail |
| `shared/widgets/vit_market_rows.dart` | 7 | fail |
| `shared/widgets/vit_high_risk_state_panel.dart` | 5 | fail |
| `shared/widgets/vit_icon_button.dart` | 5 | fail |
| `shared/widgets/vit_compact_product_card.dart` | 4 | warn |
| `shared/widgets/vit_empty_state.dart` | 4 | warn |
| `shared/widgets/vit_sheet_handle.dart` | 4 | warn |
| `shared/widgets/vit_skeleton.dart` | 4 | warn |
| `shared/widgets/vit_toggle_pill.dart` | 4 | warn |

## Most Used Shared Components

The high-use components confirm that the rollout did adopt the shared foundation broadly:

| Component | References | Files |
| --- | ---: | ---: |
| `VitCard` | 2,639 | 1,031 |
| `VitCardVariant` | 1,204 | 638 |
| `VitCardRadius` | 1,029 | 508 |
| `VitPageContent` | 510 | 407 |
| `VitContentPadding` | 485 | 382 |
| `VitPageLayout` | 399 | 393 |
| `VitAutoHideHeaderScaffold` | 385 | 382 |
| `VitCtaButton` | 381 | 276 |
| `VitHeader` | 374 | 370 |
| `VitPageVariant` | 369 | 361 |
| `VitPageSection` | 333 | 194 |
| `VitStatusPillStatus` | 327 | 135 |
| `VitCtaButtonVariant` | 286 | 164 |
| `VitStatusPillSize` | 211 | 145 |
| `VitHighRiskUiState` | 202 | 191 |
| `VitHighRiskStatePanel` | 198 | 191 |
| `VitStatusPill` | 178 | 123 |
| `VitTabItem` | 155 | 100 |
| `VitAccentPill` | 118 | 103 |
| `VitTabBar` | 100 | 100 |

## Unused or Rare Shared Components

Unused by feature presentation files:

- `VitAppShell`
- `VitBottomNav`
- `VitBottomNavDestination`
- `VitHeaderAction`
- `VitHeaderActionSize`
- `VitMarketTickerCard`
- `VitMetricDeltaPillSize`
- `VitPhoneFrame`
- `VitServiceTileDensity`
- `VitSkeletonRow`
- `VitStatusBar`

Rare, one reference each:

- `VitAnnouncementBanner`
- `VitAnnouncementBannerVariant`
- `VitCarouselDots`
- `VitCompactProductCard`
- `VitMarketPairRow`
- `VitMarketTickerData`
- `VitMarketTickerStrip`
- `VitRankedAssetRow`

Some unused components are expected because shell widgets can be consumed by app-level code instead of feature presentation files. Still, the rare/unused list should be reviewed before claiming the project is fully leveraging the shared component library.

## Practical Completion Criteria

To mark "all UI fully uses shared components" with evidence, require all of these:

1. Body-component audit has 0 grade-B routed screens, or every B/Tool screen has a documented accepted exception.
2. `scope_root_page_bundle_summary_debt=0`, or only documented exceptions remain.
3. `scope_feature_widget_debt=0` for all active routed-screen bundles.
4. `scope_shared_layout_debt=0` and `scope_shared_widget_debt=0`, or shared primitive exceptions are explicitly documented.
5. Launchpad P2 screens are either normalized or moved to a documented exception list.
6. Fullscreen Tool screens have manual visual QA evidence for safe close/back controls, safe areas, nonblank rendering, and financial-state boundaries.
7. Unused/rare shared components are either adopted, moved out of shared, or documented as app-shell/demo-only primitives.

## Recommended Cleanup Order

1. **Launchpad root bundles:** fix the 12 debt-bearing root bundles first, because they are the only remaining root-page bundle debt source.
2. **Shared foundation:** normalize `VitCard`, `VitTabBar`, `VitStatusPill`, `VitPageContent`, `VitHeader`, `VitBottomNav`, and related shared primitives so downstream screens inherit cleaner defaults.
3. **Launchpad P2 body screens:** address surface/state/financial safety warnings on the 11 Launchpad P2 screens.
4. **Fullscreen Tool screens:** document manual visual QA evidence for `EnterpriseStatesPage`, `P2PChatPage`, `AdvancedChartPage`, `FuturesPage`, and `TradingBotsPage`.
5. **Feature-widget debt:** reduce the 132 unique feature-widget debt files, prioritizing repeated Launchpad widgets used by multiple bundles.
6. **Rare/unused shared components:** decide whether to promote usage, keep as app-shell-only, or remove/deprecate later.

## Bottom Line

The Home UI rollout brought the app close at the screen-shell level, but the full shared-component adoption claim is not ready. The remaining work is concentrated and measurable: Launchpad route bundles, shared primitive token cleanup, fullscreen Tool manual QA, and feature-widget local surface cleanup.
