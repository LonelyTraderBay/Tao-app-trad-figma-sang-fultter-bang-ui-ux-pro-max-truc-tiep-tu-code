# Flutter Large File Enterprise Refactor Tracking

Generated: 2026-05-31
Scope: theo doi viec tach/giam cac Dart file lon trong `flutter_app/lib/`
theo chuan VitTrade Flutter enterprise UI.

## 1. Muc tieu

Tai lieu nay dung de theo doi tung buoc refactor cac file lon. Muc tieu khong
phai doi UI hoac them feature moi, ma la:

- Giam file page/widget qua lon de de review, test va maintain.
- Giu page chi lam composition, routing shell, provider watch, va state handoff.
- Dua section/card/chart/form/sheet sang `presentation/widgets/`.
- Dua filter, draft, selection, calculation, va action orchestration sang
  `presentation/controllers/` hoac helper gan feature.
- Giu domain/data boundary dung theo `AGENTS.md`.
- Khong them React/Vite/root web tooling.
- Khong claim production enterprise-grade neu backend/release ops chua xong.

## 2. Baseline hien tai

Do tu `flutter_app/lib` ngay 2026-05-31:

| Metric | Value | Ghi chu |
| --- | ---: | --- |
| Dart files in `lib` | `1094` | Runtime source only. |
| Dart lines in `lib` | `462871` | Dem theo cach `Get-Content`. |
| Files `>1000` lines | `73` | Uu tien refactor. |
| Feature files `>600` lines | `239` | No maintainability con lai. |
| Feature files `>1200` lines | `0` | Guardrail hien tai tot, can giu. |

## 3. Chuan Enterprise-grade ap dung

### 3.1 Gioi han file muc tieu

| File type | Target | Hard guard | Ly do |
| --- | ---: | ---: | --- |
| `presentation/pages/*_page.dart` | `300-600` lines | `<900` lines | Page nen la route composition, khong chua toan bo UI. |
| `presentation/widgets/*.dart` | `150-500` lines | `<800` lines | Widget file nen chua mot nhom UI ro rang. |
| `presentation/controllers/*.dart` | `150-500` lines | `<800` lines | Controller nen gom state/intent, khong ve UI. |
| `domain/entities/*.dart` | `100-500` lines | `<800` lines | Chia theo aggregate/value object. |
| Painter/chart file | `100-400` lines | `<600` lines | Custom painter can co pham vi doc lap va testable. |

### 3.2 Nguyen tac tach file

- Tach theo product section, khong tach theo so dong may moc.
- Khong doi route name/path, public router API, provider API neu khong can.
- Private widget `_Foo` chi giu private neu no chi dung trong file moi.
- Widget/section can import tu page thi doi thanh public/internal name khong co
  underscore, vi Dart private theo file.
- Khong de page/widget import truc tiep `features/*/data`.
- Khong them `Colors.*` runtime trong `lib/`; dung theme tokens.
- High-risk Wallet/P2P/Prediction/Arena copy phai giu financial safety.
- Arena van points-only; Prediction khong dung copy casino/hype.
- Moi packet phai co verification log that truoc khi tick `[x]`.

### 3.3 Trang thai packet

| Marker | Nghia |
| --- | --- |
| `[ ]` | Chua bat dau. |
| `[~]` | Dang lam, da cham file. |
| `[x]` | Da xong va test pass. |
| `[!]` | Bi chan boi dependency/decision ben ngoai. |

Quy tac thuc thi:

1. Chi lam 1 packet tai mot thoi diem.
2. Truoc khi sua, doi status packet tu `[ ]` sang `[~]`.
3. Sau khi format/test/analyze pass, doi status sang `[x]`.
4. Neu packet bi chan, ghi ro blocker va doi sang `[!]`.
5. Khong dong packet neu chi moi tach file ma chua chay focused tests.

## 4. Tracking board

| ID | Priority | Status | Source file | Target outcome | Required verification |
| --- | --- | --- | --- | --- | --- |
| LG-01 | P0 | `[x]` | `wallet_token_approval_page.dart` | Page con `<600` lines; tabs/cards/history/settings tach widgets | Wallet token approval tests + semantics test + analyze |
| LG-02 | P0 | `[x]` | `predictions_portfolio_page.dart` | Page con `<600` lines; summary/tabs/positions/orders/history tach widgets | Prediction tests + product copy guardrail + analyze |
| LG-03 | P0 | `[x]` | `withdraw_page.dart` | Page con `<700` lines; form/preview/recent-address/network sections tach widgets | Wallet tests + semantics test + product copy guardrail |
| LG-04 | P1 | `[x]` | `transaction_reporting_page.dart` | Page con `<600` lines; reports/stats/search/actions tach widgets/controller | Trade focused tests + analyze |
| LG-05 | P1 | `[x]` | `market_depth_page.dart` | Chart/orderbook/whale widgets tach rieng | Markets focused tests + responsive matrix slice |
| LG-06 | P1 | `[x]` | `market_sectors_page.dart` | Distribution/controls/cards/table/detail tach widgets; filter helper tach | Markets focused tests + analyze |
| LG-07 | P1 | `[x]` | `execution_quality_demo_page.dart` | Demo page tach cards/tabs/sheets; xem lai ten `demo` | Trade focused tests + analyze |
| LG-08 | P1 | `[x]` | `live_market_data_analytics_widgets.dart` | Tach tab cards/chart painter thanh nhieu widget files | Trade/markets focused tests + analyze |
| LG-09 | P1 | `[x]` | `wallet_multi_manager_sections.dart` | Tach all-wallets/groups/activity/chart widgets | Wallet focused tests + analyze |
| LG-10 | P1 | `[x]` | `wallet_address_add_sections.dart` | Tach form inputs/selectors/preview/agreement sections | Address Add tests + semantics harness |
| LG-11 | P2 | `[x]` | `launchpad_rebalance_page.dart` | Tach hero/strategy/allocation/suggestions/confirm/painter | Launchpad focused tests + analyze |
| LG-12 | P2 | `[x]` | `launchpad_dca_builder_page.dart` | Tach builder form/summary/schedule/risk sections | Launchpad focused tests + analyze |
| LG-13 | P2 | `[x]` | `design_system_page.dart` | Tach dev-only token/color/cta/input/playground sections | Dev/design-system tests if any + analyze |
| LG-14 | P2 | `[x]` | `staking_dashboard_page.dart` | Tach dashboard cards/charts/state sections | Earn focused tests + analyze |
| LG-15 | P2 | `[x]` | `dca_backtester_page.dart` | Tach chart/painter/result/config widgets | DCA focused tests + analyze |
| LG-16 | P2 | `[x]` | `p2p_dispute_detail_page.dart` | Tach escalation/evidence/timeline/chat/actions | P2P focused tests + product copy guardrail |
| LG-17 | P2 | `[x]` | `unified_portfolio_dashboard.dart` | Tach cross-module panels; verify boundary copy | Cross-module tests + product copy guardrail |
| LG-18 | P2 | `[x]` | `arena_mode_detail_page.dart` | Tach mode hero/rules/join/leaderboard; points-only guard | Arena tests + product copy guardrail |
| LG-19 | P2 | `[x]` | `dca_entities.dart` | Chia domain entities theo aggregate va barrel export | Full analyze + DCA tests |
| LG-20 | P3 | `[~]` | Remaining `>1000` files | Batch reduce theo feature owner | Focused tests per feature |

## 5. Packet chi tiet

### LG-01 - Wallet Token Approval page split

Status: `[x]`

Source:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_token_approval_page.dart`
  (`1198` lines, 21 classes).
- Existing companion:
  `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart`

Why priority P0:

- Wallet approval revoke la high-risk financial/security surface.
- Page dang chua tabs, overview metrics, approval cards, history, settings, best
  practices trong cung mot file.
- UI-07 da them semantics; khi tach phai giu semantic labels.

Classes/sections to move:

| Current symbol/section | Suggested target file | Notes |
| --- | --- | --- |
| `_ApprovalTabs` | `wallet_token_approval_tabs.dart` | Public entry `WalletTokenApprovalTabs`. |
| `_ActiveApprovalsTab` | `wallet_token_active_approvals_tab.dart` | Giu approval list va revoke callbacks. |
| `_SecurityOverview`, `_OverviewMetric`, `_CriticalAlert` | `wallet_token_security_overview.dart` | Giu semantic summary. |
| `_ApprovalCard`, `_CategoryIcon`, `_ApprovalHeaderText`, `_RiskBadge`, `_ApprovalAmount`, `_ApprovalStat` | `wallet_token_approval_card.dart` | Co the giu private trong file moi neu chi card dung. |
| `_RevokeAllButton`, `_InfoNotice`, `_SectionLabel` | `wallet_token_approval_common.dart` | Shared small widgets. |
| `_HistoryTab`, `_HistoryMetric` | `wallet_token_approval_history_tab.dart` | Tach history-only. |
| `_SettingsTab`, `_SettingsRow`, `_BestPracticesCard` | `wallet_token_approval_settings_tab.dart` | Giu toggle semantics. |

Implementation steps:

1. Mark LG-01 `[~]`.
2. Read current page imports and tests touching `WalletTokenApprovalPage`.
3. Create new files under:
   `flutter_app/lib/features/wallet/presentation/widgets/`.
4. Move widgets section by section, starting from lowest dependency:
   common widgets, card widgets, overview, history, settings, tabs.
5. Replace page-local private widget references with public widget names.
6. Keep page file responsible only for:
   provider/controller watch, `VitPageLayout`, selected tab state, and revoke
   sheet orchestration.
7. Run:

```bash
dart format lib/features/wallet/presentation/pages/wallet_token_approval_page.dart lib/features/wallet/presentation/widgets
flutter test test/features/wallet --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter analyze
```

Acceptance:

- Source page `<600` lines.
- No semantic label regression for token approval/revoke.
- No direct data import from page/widgets.
- Revoke sheet behavior unchanged.

Verification log:

- 2026-05-31: Split `wallet_token_approval_page.dart` from `1198` lines to
  `117` lines. New widget files:
  `wallet_token_approval_common.dart` (`186` lines),
  `wallet_token_approval_tabs.dart` (`78` lines),
  `wallet_token_active_approvals_tab.dart` (`573` lines),
  `wallet_token_approval_history_tab.dart` (`139` lines), and
  `wallet_token_approval_settings_tab.dart` (`209` lines).
- 2026-05-31: `dart format lib/features/wallet/presentation/pages/wallet_token_approval_page.dart lib/features/wallet/presentation/widgets/wallet_token_approval_common.dart lib/features/wallet/presentation/widgets/wallet_token_approval_tabs.dart lib/features/wallet/presentation/widgets/wallet_token_active_approvals_tab.dart lib/features/wallet/presentation/widgets/wallet_token_approval_history_tab.dart lib/features/wallet/presentation/widgets/wallet_token_approval_settings_tab.dart`
  passed (`6` files, `3` changed).
- 2026-05-31: `flutter test test/features/wallet/wallet_token_approval_page_test.dart test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`9` tests).
- 2026-05-31: `flutter test test/features/wallet --reporter=compact`
  passed (`66` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: Metrics after LG-01: files `>1000` = `72`, feature files
  `>600` = `238`, feature files `>1200` = `0`.

### LG-02 - Predictions Portfolio page split

Status: `[x]`

Source:

- `flutter_app/lib/features/predictions/presentation/pages/predictions_portfolio_page.dart`
  (`1186` lines, 16 classes).

Why priority P0:

- Prediction Markets is financial-copy sensitive.
- Page mixes summary, tabs, active positions, open orders, receipts/history.

Target files:

| New file | Moves |
| --- | --- |
| `prediction_portfolio_summary.dart` | `_SummaryCard`, `_SummaryStat`, `_SharesNote`. |
| `prediction_portfolio_tabs.dart` | `_PortfolioTabs`, `_PortfolioTabButton`, `_CountBadge`. |
| `prediction_portfolio_positions.dart` | `_PositionsList`, `_PositionCard`, `_SmallMetric`. |
| `prediction_portfolio_orders.dart` | `_OpenOrdersSection`, `_OpenOrderCard`. |
| `prediction_portfolio_history.dart` | `_HistorySection`, `_ReceiptCard`, `_TinyBadge`. |

Implementation steps:

1. Mark LG-02 `[~]`.
2. Search product copy terms before edit:

```bash
rg -n "payout|stake return|casino|bet|profit" flutter_app/lib/features/predictions
```

3. Move widgets into `features/predictions/presentation/widgets/`.
4. Keep page responsible for tab state and snapshot selection only.
5. If any filtering/calculation grows, move to
   `features/predictions/presentation/controllers/`.
6. Run:

```bash
dart format lib/features/predictions/presentation/pages/predictions_portfolio_page.dart lib/features/predictions/presentation/widgets
flutter test test/features/predictions --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Acceptance:

- Page `<600` lines.
- Product copy guardrail pass.
- No Arena copy appears in Prediction portfolio.

Verification log:

- 2026-05-31: Copy pre-scan `rg -n "payout|stake return|casino|bet|profit" flutter_app/lib/features/predictions`
  found existing `profit` copy only in `predictions_leaderboard_page.dart`, not
  in `predictions_portfolio_page.dart`.
- 2026-05-31: Split `predictions_portfolio_page.dart` from `1186` lines to
  `149` lines. New widget files:
  `prediction_portfolio_common.dart` (`70` lines),
  `prediction_portfolio_summary.dart` (`294` lines),
  `prediction_portfolio_tabs.dart` (`151` lines),
  `prediction_portfolio_positions.dart` (`271` lines),
  `prediction_portfolio_orders.dart` (`214` lines), and
  `prediction_portfolio_history.dart` (`138` lines).
- 2026-05-31: `dart format lib/features/predictions/presentation/pages/predictions_portfolio_page.dart lib/features/predictions/presentation/widgets/prediction_portfolio_common.dart lib/features/predictions/presentation/widgets/prediction_portfolio_summary.dart lib/features/predictions/presentation/widgets/prediction_portfolio_tabs.dart lib/features/predictions/presentation/widgets/prediction_portfolio_positions.dart lib/features/predictions/presentation/widgets/prediction_portfolio_orders.dart lib/features/predictions/presentation/widgets/prediction_portfolio_history.dart`
  passed (`7` files, `2` changed).
- 2026-05-31: `flutter test test/features/predictions/predictions_portfolio_page_test.dart test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`19` tests) after fixing Unicode literals introduced during the split.
- 2026-05-31: `flutter test test/features/predictions --reporter=compact`
  passed (`85` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: Metrics after LG-02: files `>1000` = `71`, feature files
  `>600` = `237`, feature files `>1200` = `0`.

### LG-03 - Withdraw page split

Status: `[x]`

Source:

- `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart`
  (`1013` lines).

Why priority P0:

- Withdraw is high-risk financial flow.
- It has form input, network selection, recent address, amount controls,
  preview/confirmation, fee/risk copy, and semantics in one file.

Target files:

| New file | Moves |
| --- | --- |
| `withdraw_form_section.dart` | Address/amount inputs, scan QR, all amount button. |
| `withdraw_network_section.dart` | Network selector/options. |
| `withdraw_recent_addresses.dart` | Recent address rows and masking. |
| `withdraw_preview_sheet.dart` | Preview, fee/risk/limit, cancel/confirm actions. |
| `withdraw_safety_notice.dart` | Risk/fee/next-step copy panels. |

Implementation steps:

1. Mark LG-03 `[~]`.
2. Preserve all existing semantics labels from UI-07.
3. Move preview sheet last, after form sections compile.
4. Keep page responsible for controller state, form controllers, and submit
   intent only.
5. Run:

```bash
dart format lib/features/wallet/presentation/pages/withdraw_page.dart lib/features/wallet/presentation/widgets
flutter test test/features/wallet --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Acceptance:

- Page `<700` lines.
- Preview still shows amount, network, fees, limits, risk, masked address,
  cancel, and confirm.
- Semantics harness still passes.

Verification log:

- 2026-05-31: Split `withdraw_page.dart` from `1013` lines to `201`
  lines. New widget files:
  `withdraw_common.dart` (`71` lines),
  `withdraw_form_sections.dart` (`544` lines),
  `withdraw_network_picker.dart` (`118` lines), and
  `withdraw_preview_sheet.dart` (`161` lines).
- 2026-05-31: Updated high-risk product-copy guardrail target to scan the
  new withdraw widget files plus `wallet_controller.dart`, so safety copy can
  remain enforced after the page split.
- 2026-05-31: `dart format lib/features/wallet/presentation/pages/withdraw_page.dart lib/features/wallet/presentation/widgets/withdraw_common.dart lib/features/wallet/presentation/widgets/withdraw_form_sections.dart lib/features/wallet/presentation/widgets/withdraw_network_picker.dart lib/features/wallet/presentation/widgets/withdraw_preview_sheet.dart test/quality/product_copy_guardrails_test.dart`
  passed (`6` files checked, `2` changed).
- 2026-05-31: `flutter test test/features/wallet/withdraw_page_test.dart test/quality/accessibility_semantics_critical_flows_test.dart test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`24` tests).
- 2026-05-31: `flutter test test/features/wallet --reporter=compact`
  passed (`66` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: Metrics after LG-03: files `>1000` = `70`, feature files
  `>600` = `236`, feature files `>1200` = `0`.

### LG-04 - Transaction Reporting page split

Status: `[x]`

Source:

- `flutter_app/lib/features/trade/presentation/pages/transaction_reporting_page.dart`
  (`1196` lines, 18 classes).

Target files:

| New file | Moves |
| --- | --- |
| `transaction_reporting_notice.dart` | `_ComplianceNotice`, `_NoticePanel`. |
| `transaction_reporting_stats.dart` | `_StatsGrid`, `_StatCard`, `_StatsTab`, `_StatColumn`. |
| `transaction_reporting_filters.dart` | `_SearchField`, `_Tabs`, filter controls. |
| `transaction_report_card.dart` | `_ReportsSection`, `_ReportCard`, `_DetailValue`, chips. |
| `transaction_reporting_actions.dart` | `_QuickActions`, `_QuickActionCard`. |

Implementation steps:

1. Mark LG-04 `[~]`.
2. Move `_filteredReports` to controller/helper if it uses business filtering.
3. Keep page as provider watch + tab/search state + layout composition.
4. Run trade focused tests and analyze.

Acceptance:

- Page `<600` lines.
- No route/copy behavior changes.
- Search/filter behavior unchanged.

Verification log:

- 2026-05-31: Split `transaction_reporting_page.dart` from `1196` lines
  to `139` lines. New widget/helper files:
  `transaction_reporting_common.dart` (`101` lines),
  `transaction_reporting_notice.dart` (`123` lines),
  `transaction_reporting_stats.dart` (`268` lines),
  `transaction_reporting_filters.dart` (`128` lines),
  `transaction_reporting_reports.dart` (`424` lines), and
  `transaction_reporting_actions.dart` (`107` lines).
- 2026-05-31: Moved report filtering to
  `filterTransactionReports` in `transaction_reporting_common.dart`; page now
  handles provider watch, local tab/search/notice state, layout, and action
  handoff only.
- 2026-05-31: `dart format lib/features/trade/presentation/pages/transaction_reporting_page.dart lib/features/trade/presentation/widgets/transaction_reporting_common.dart lib/features/trade/presentation/widgets/transaction_reporting_notice.dart lib/features/trade/presentation/widgets/transaction_reporting_stats.dart lib/features/trade/presentation/widgets/transaction_reporting_filters.dart lib/features/trade/presentation/widgets/transaction_reporting_reports.dart lib/features/trade/presentation/widgets/transaction_reporting_actions.dart`
  passed (`7` files checked, `1` changed).
- 2026-05-31: `flutter test test/features/trade/transaction_reporting_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-31: `flutter test test/features/trade --reporter=compact`
  passed (`343` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-04
  page/widget files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-04: files `>1000` = `69`, feature files
  `>600` = `235`, feature files `>1200` = `0`.

### LG-05 - Market Depth page split

Status: `[x]`

Source:

- `flutter_app/lib/features/markets/presentation/pages/market_depth_page.dart`
  (`1184` lines, custom painter).

Target files:

| New file | Moves |
| --- | --- |
| `market_depth_tabs.dart` | `_DepthTabs`, `_UnderlinedTab`. |
| `market_depth_pair_summary.dart` | `_PairSummary`, `_DepthMiniStats`, `_MiniStat`. |
| `market_depth_chart.dart` | `_DepthChartCard`, `_DepthChartPainter`, `_LegendItem`, level chips. |
| `market_depth_order_book.dart` | `_OrderBookHeader`, rows, cells, mid price. |
| `market_depth_whales.dart` | `_WhaleWarningCard`, `_WhaleOrderCard`, `_WhaleSummary`. |

Implementation steps:

1. Mark LG-05 `[~]`.
2. Move painter to chart file first because it is visually isolated.
3. Move order book and whale sections.
4. Keep page responsible for selected tab and data snapshot.
5. Run:

```bash
dart format lib/features/markets/presentation/pages/market_depth_page.dart lib/features/markets/presentation/widgets
flutter test test/features/markets --reporter=compact
flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact
flutter analyze
```

Acceptance:

- Page `<600` lines.
- No layout overflow at 360 px in responsive matrix.

Verification log:

- 2026-05-31: Split `market_depth_page.dart` from `1184` lines to `109`
  lines. New widget/helper files:
  `market_depth_common.dart` (`153` lines),
  `market_depth_tabs.dart` (`101` lines),
  `market_depth_chart.dart` (`458` lines),
  `market_depth_order_book.dart` (`230` lines), and
  `market_depth_whale_alerts.dart` (`249` lines).
- 2026-05-31: Page now owns route/back behavior, provider watch, tab state,
  depth-level state, and view composition only. Chart painter, order book rows,
  and whale alert cards are isolated under `presentation/widgets/`.
- 2026-05-31: `dart format lib/features/markets/presentation/pages/market_depth_page.dart lib/features/markets/presentation/widgets/market_depth_common.dart lib/features/markets/presentation/widgets/market_depth_tabs.dart lib/features/markets/presentation/widgets/market_depth_chart.dart lib/features/markets/presentation/widgets/market_depth_order_book.dart lib/features/markets/presentation/widgets/market_depth_whale_alerts.dart`
  passed (`6` files checked).
- 2026-05-31: `flutter test test/features/markets/market_depth_page_test.dart --reporter=compact`
  passed (`8` tests) after correcting string encoding in the new widget files.
- 2026-05-31: `flutter test test/features/markets --reporter=compact`
  passed (`124` tests).
- 2026-05-31: `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`
  passed (`3` responsive viewport tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-05
  page/widget files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-05: files `>1000` = `68`, feature files
  `>600` = `234`, feature files `>1200` = `0`.

### LG-06 - Market Sectors page split

Status: `[x]`

Source:

- `flutter_app/lib/features/markets/presentation/pages/market_sectors_page.dart`
  (`1194` lines).

Target files:

| New file | Moves |
| --- | --- |
| `market_sector_distribution.dart` | `_SectorDistributionCard`, `_LegendItem`. |
| `market_sector_controls.dart` | `_SectorControls`, `_ChipButton`. |
| `market_sector_card.dart` | `_SectorCard`, `_SectorMetric`, `_DominanceBar`, coin chips. |
| `market_sector_comparison_table.dart` | `_SectorComparisonTable`, rows/cells/dividers. |
| `market_sector_detail_summary.dart` | `_SectorDetailSummary`, `_DetailMetric`, top coins. |
| `market_sector_filters.dart` | `_visibleSectors`, `_findSector`, `_coinsFor` if not pure UI. |

Implementation steps:

1. Mark LG-06 `[~]`.
2. Move helper functions only if they are pure and tested by page behavior.
3. Keep page responsible for selected sector/timeframe/sort state.
4. Run markets focused tests and analyze.

Acceptance:

- Page `<600` lines.
- Sector selection/filter/sort unchanged.

Verification log:

- 2026-05-31: Split `market_sectors_page.dart` from `1194` lines to
  `165` lines. New widget/helper files:
  `market_sector_common.dart` (`167` lines),
  `market_sector_distribution.dart` (`136` lines),
  `market_sector_controls.dart` (`117` lines),
  `market_sector_card.dart` (`275` lines),
  `market_sector_comparison_table.dart` (`192` lines), and
  `market_sector_detail_summary.dart` (`232` lines).
- 2026-05-31: Moved sort/filter/detail coin helpers into
  `market_sector_common.dart`; page now owns route/back behavior, provider
  watch, selected timeframe/sort state, and composition only.
- 2026-05-31: `dart format lib/features/markets/presentation/pages/market_sectors_page.dart lib/features/markets/presentation/widgets/market_sector_common.dart lib/features/markets/presentation/widgets/market_sector_distribution.dart lib/features/markets/presentation/widgets/market_sector_controls.dart lib/features/markets/presentation/widgets/market_sector_card.dart lib/features/markets/presentation/widgets/market_sector_comparison_table.dart lib/features/markets/presentation/widgets/market_sector_detail_summary.dart`
  passed (`7` files checked).
- 2026-05-31: `flutter test test/features/markets/market_sectors_page_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/features/markets --reporter=compact`
  passed (`124` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-06
  page/widget files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-06: files `>1000` = `67`, feature files
  `>600` = `233`, feature files `>1200` = `0`.

### LG-07 - Execution Quality demo page split

Status: `[x]`

Source:

- `flutter_app/lib/features/trade/presentation/pages/execution_quality_demo_page.dart`
  (`1197` lines, 28 classes).

Review decision first:

- If route is production-facing, consider renaming copy away from "demo" in a
  separate product decision packet.
- If route is dev/demo-only, confirm it belongs under `features/dev` or remains
  intentionally in Trade.

Target files:

| New file | Moves |
| --- | --- |
| `execution_quality_intro.dart` | `_IntroCard`, `_FeatureCard`, `_BenefitsCard`. |
| `execution_quality_progress.dart` | `_ProgressCard`, `_ParityCard`. |
| `execution_quality_tabs.dart` | `_QualityTabs`, tab content widgets. |
| `execution_quality_sheets.dart` | `_SlippageSheet`, `_ExecutionSheet`, `_AmendmentSheet`, sheet frame. |
| `execution_quality_common.dart` | buttons, tiles, pills, panel, row, toast. |

Implementation steps:

1. Mark LG-07 `[~]`.
2. Do not change product naming in same refactor unless tests demand it.
3. Move sheet widgets last because callbacks can be more fragile.
4. Run trade focused tests and analyze.

Acceptance:

- Page `<600` lines.
- All bottom sheets still open and close.

Verification log:

- 2026-05-31: Split `execution_quality_demo_page.dart` from `1197` lines
  to `219` lines. New widget/helper files:
  `execution_quality_common.dart` (`241` lines),
  `execution_quality_overview.dart` (`304` lines),
  `execution_quality_tabs.dart` (`193` lines), and
  `execution_quality_sheets.dart` (`316` lines).
- 2026-05-31: Kept the existing route/page name and visible "Execution
  Quality" copy unchanged. The "demo" naming concern remains a separate
  product decision packet, as requested by LG-07.
- 2026-05-31: Page now owns provider watch/read, selected tab state, toast
  state, route/back behavior, and sheet orchestration only.
- 2026-05-31: `dart format lib/features/trade/presentation/pages/execution_quality_demo_page.dart lib/features/trade/presentation/widgets/execution_quality_common.dart lib/features/trade/presentation/widgets/execution_quality_overview.dart lib/features/trade/presentation/widgets/execution_quality_tabs.dart lib/features/trade/presentation/widgets/execution_quality_sheets.dart`
  passed (`5` files checked, `1` changed).
- 2026-05-31: `flutter test test/features/trade/execution_quality_demo_page_test.dart --reporter=compact`
  passed (`5` tests) after correcting the amendment toast separator to `·`.
- 2026-05-31: `flutter test test/features/trade --reporter=compact`
  passed (`343` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-07
  page/widget files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-07: files `>1000` = `66`, feature files
  `>600` = `232`, feature files `>1200` = `0`.

### LG-08 - Live Market Data Analytics widget split

Status: `[x]`

Source:

- `flutter_app/lib/features/trade/presentation/widgets/live_market_data_analytics_widgets.dart`
  (`1194` lines).

Why priority:

- This is a widget aggregator, not a page, but it has pair card, tabs, multiple
  tab bodies, reusable card primitives, ratio bars, rows, and line painter.

Target files:

| New file | Moves |
| --- | --- |
| `live_market_pair_card.dart` | `LiveMarketPairCard`, `_LiveDot`, `_PairValue`. |
| `live_market_tabs.dart` | `LiveMarketUnderlineTabs`, `LiveMarketTabContent`, `_MarketTab`. |
| `live_market_interest_cards.dart` | Open interest, long/short, top traders, funding. |
| `live_market_liquidations.dart` | Liquidations tab, rows, source rows. |
| `live_market_sentiment.dart` | Sentiment tab and related cards. |
| `live_market_chart_painter.dart` | `_LinePainter`. |
| `live_market_common_widgets.dart` | Header, card shell, metric, chips, labels, toggles, ratio bar. |

Implementation steps:

1. Mark LG-08 `[~]`.
2. Preserve public exports expected by pages importing current file.
3. Either keep this file as a barrel-style export/composition file or update
   import sites directly. Prefer explicit imports unless many call sites exist.
4. Run trade/markets focused tests and analyze.

Acceptance:

- No file in this widget group `>800` lines.
- Existing importing pages compile without broad churn.

Verification log:

- 2026-05-31: Split `live_market_data_analytics_widgets.dart` from `1194`
  lines to a `7` line barrel export preserving existing public imports. New
  widget files:
  `live_market_common_widgets.dart` (`306` lines),
  `live_market_pair_card.dart` (`111` lines),
  `live_market_tabs.dart` (`94` lines),
  `live_market_interest_cards.dart` (`489` lines),
  `live_market_liquidations.dart` (`103` lines),
  `live_market_sentiment.dart` (`100` lines), and
  `live_market_chart_painter.dart` (`50` lines).
- 2026-05-31: `dart format lib/features/trade/presentation/widgets/live_market_data_analytics_widgets.dart lib/features/trade/presentation/widgets/live_market_common_widgets.dart lib/features/trade/presentation/widgets/live_market_pair_card.dart lib/features/trade/presentation/widgets/live_market_tabs.dart lib/features/trade/presentation/widgets/live_market_interest_cards.dart lib/features/trade/presentation/widgets/live_market_liquidations.dart lib/features/trade/presentation/widgets/live_market_sentiment.dart lib/features/trade/presentation/widgets/live_market_chart_painter.dart`
  passed (`8` files checked, `0` changed).
- 2026-05-31: `flutter test test/features/trade/live_market_data_analytics_page_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-31: `flutter test test/features/trade --reporter=compact`
  passed (`343` tests).
- 2026-05-31: `flutter test test/features/markets --reporter=compact`
  passed (`124` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-08
  widget files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-08: files `>1000` = `65`, feature files
  `>600` = `231`, feature files `>1200` = `0`.

### LG-09 - Wallet Multi Manager sections split

Status: `[x]`

Source:

- `flutter_app/lib/features/wallet/presentation/widgets/wallet_multi_manager_sections.dart`
  (`1168` lines).

Target files:

| New file | Moves |
| --- | --- |
| `wallet_manager_tabs.dart` | `WalletManagerTabs`. |
| `wallet_manager_all_wallets_tab.dart` | `WalletAllWalletsTab`, summary/distribution/wallet card. |
| `wallet_manager_groups_tab.dart` | `WalletGroupsTab`, group cards and rows. |
| `wallet_manager_activity_tab.dart` | `WalletActivityTab`, activity rows. |
| `wallet_manager_distribution_chart.dart` | `_DistributionPainter`, chart helpers. |
| `wallet_manager_common.dart` | badges, icon buttons, small labels. |

Implementation steps:

1. Mark LG-09 `[~]`.
2. Move chart painter first, then tabs one by one.
3. Keep public widgets stable for callers.
4. Run wallet focused tests and analyze.

Acceptance:

- No wallet manager widget file `>800` lines.
- Wallet overview/multi-manager route behavior unchanged.

Verification log:

- 2026-05-31: Split `wallet_multi_manager_sections.dart` from `1168`
  lines to a `6` line barrel export preserving the existing page import. New
  widget files:
  `wallet_manager_all_wallets_tab.dart` (`431` lines),
  `wallet_manager_common.dart` (`278` lines),
  `wallet_manager_groups_tab.dart` (`208` lines),
  `wallet_manager_activity_tab.dart` (`120` lines),
  `wallet_manager_distribution_chart.dart` (`109` lines), and
  `wallet_manager_tabs.dart` (`72` lines).
- 2026-05-31: `dart format lib/features/wallet/presentation/widgets/wallet_multi_manager_sections.dart lib/features/wallet/presentation/widgets/wallet_manager_common.dart lib/features/wallet/presentation/widgets/wallet_manager_tabs.dart lib/features/wallet/presentation/widgets/wallet_manager_distribution_chart.dart lib/features/wallet/presentation/widgets/wallet_manager_all_wallets_tab.dart lib/features/wallet/presentation/widgets/wallet_manager_groups_tab.dart lib/features/wallet/presentation/widgets/wallet_manager_activity_tab.dart`
  passed (`7` files checked, `1` changed).
- 2026-05-31: `flutter test test/features/wallet/wallet_multi_manager_page_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-31: `flutter test test/features/wallet --reporter=compact`
  passed (`66` tests).
- 2026-05-31: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-09
  widget files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-09: files `>1000` = `64`, feature files
  `>600` = `230`, feature files `>1200` = `0`.

### LG-10 - Wallet Address Add sections split

Status: `[x]`

Source:

- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_sections.dart`
  (`1116` lines).

Why priority:

- High-risk address addition flow; UI-01/UI-07 tests depend on semantics and
  confirmation behavior.

Target files:

| New file | Moves |
| --- | --- |
| `wallet_address_add_form.dart` | Label/address input sections. |
| `wallet_address_add_selectors.dart` | Network/asset selectors. |
| `wallet_address_add_agreement.dart` | Whitelist/agreement/risk controls. |
| `wallet_address_add_preview.dart` | Preview/confirm summary sections. |
| `wallet_address_add_common.dart` | Shared input/button/chip widgets. |

Implementation steps:

1. Mark LG-10 `[~]`.
2. Preserve `semanticLabel` use on all high-risk inputs/actions.
3. Move preview and agreement last.
4. Run Address Add tests and semantics harness.

Acceptance:

- No semantics regression for `SC-143`.
- Confirmation path still reaches saved state in UI harness.

Verification log:

- 2026-05-31: Split `wallet_address_add_sections.dart` from `1116`
  lines to a `5` line barrel export preserving the existing page import. New
  widget files:
  `wallet_address_add_common.dart` (`327` lines),
  `wallet_address_add_preview.dart` (`270` lines),
  `wallet_address_add_agreement.dart` (`245` lines),
  `wallet_address_add_form.dart` (`164` lines), and
  `wallet_address_add_selectors.dart` (`156` lines).
- 2026-05-31: Corrected address-add UI copy encoding during split so visible
  Vietnamese labels remained unchanged for the SC-143 harness.
- 2026-05-31: `dart format lib/features/wallet/presentation/widgets/wallet_address_add_sections.dart lib/features/wallet/presentation/widgets/wallet_address_add_common.dart lib/features/wallet/presentation/widgets/wallet_address_add_selectors.dart lib/features/wallet/presentation/widgets/wallet_address_add_agreement.dart lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart lib/features/wallet/presentation/widgets/wallet_address_add_form.dart`
  passed (`6` files checked, `2` changed).
- 2026-05-31: `flutter test test/features/wallet/address_add_page_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-31: `flutter test test/features/wallet --reporter=compact`
  passed (`66` tests).
- 2026-05-31: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-10
  widget files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-10: files `>1000` = `63`, feature files
  `>600` = `229`, feature files `>1200` = `0`.

### LG-11 - Launchpad Rebalance page split

Status: `[x]`

Source:

- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart`
  (`1186` lines, painter and calculation helpers).

Target files:

| New file | Moves |
| --- | --- |
| `launchpad_rebalance_hero.dart` | `_PortfolioHero`. |
| `launchpad_rebalance_strategy.dart` | `_StrategySection`, `_StrategyCard`. |
| `launchpad_rebalance_allocation.dart` | `_AllocationCard`, `_DonutBlock`, `_DonutPainter`. |
| `launchpad_rebalance_deviation.dart` | `_DeviationCard`, rows/bars. |
| `launchpad_rebalance_suggestions.dart` | `_SuggestionsSection`, `_SuggestionCard`. |
| `launchpad_rebalance_confirm_sheet.dart` | `_ConfirmSheet`, action row. |
| `launchpad_rebalance_calculations.dart` | `_assetsWithTargets`, `_suggestionsFor`. |

Implementation steps:

1. Mark LG-11 `[~]`.
2. Move calculation helpers only after widget split compiles.
3. Add focused tests if calculations are not already covered.
4. Run launchpad tests and analyze.

Acceptance:

- Page `<600` lines.
- Confirm sheet behavior unchanged.

Verification log:

- 2026-05-31: Split `launchpad_rebalance_page.dart` from `1186` lines to
  `196` lines. New widget/helper files:
  `launchpad_rebalance_suggestions.dart` (`195` lines),
  `launchpad_rebalance_confirm_sheet.dart` (`173` lines),
  `launchpad_rebalance_allocation.dart` (`155` lines),
  `launchpad_rebalance_summary.dart` (`152` lines),
  `launchpad_rebalance_calculations.dart` (`138` lines),
  `launchpad_rebalance_strategy.dart` (`122` lines),
  `launchpad_rebalance_deviation.dart` (`115` lines), and
  `launchpad_rebalance_hero.dart` (`67` lines).
- 2026-05-31: Page now owns provider read/watch, selected strategy state,
  footer route behavior, and confirm overlay visibility only.
- 2026-05-31: `dart format lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_calculations.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_hero.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_strategy.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_allocation.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_deviation.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_suggestions.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_summary.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_confirm_sheet.dart`
  passed (`9` files checked, `2` changed).
- 2026-05-31: `flutter test test/features/launchpad/launchpad_rebalance_page_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/features/launchpad --reporter=compact`
  passed (`121` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-11
  page/widget/helper files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-11: files `>1000` = `62`, feature files
  `>600` = `228`, feature files `>1200` = `0`.

### LG-12 - Launchpad DCA Builder page split

Status: `[x]`

Source:

- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart`
  (`1184` lines).

Target approach:

- Identify builder form, asset allocation, schedule, preview/summary, and risk
  copy sections.
- Move each section to `features/launchpad/presentation/widgets/`.
- Move draft validation/calculation to controller/helper if embedded in page.

Required verification:

```bash
dart format lib/features/launchpad
flutter test test/features/launchpad --reporter=compact
flutter analyze
```

Verification log:

- 2026-05-31: Split `launchpad_dca_builder_page.dart` from `1184` lines to
  `204` lines. New widget/helper files:
  `launchpad_dca_builder_create_form.dart` (`397` lines),
  `launchpad_dca_builder_strategies.dart` (`338` lines),
  `launchpad_dca_builder_history.dart` (`180` lines),
  `launchpad_dca_builder_common.dart` (`96` lines), and
  `launchpad_dca_builder_summary.dart` (`94` lines).
- 2026-05-31: Page now owns text controllers, active tab state, selected
  frequency, submit message, route/back behavior, and sticky CTA visibility.
- 2026-05-31: `dart format lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_common.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_summary.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_strategies.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_history.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_create_form.dart`
  passed (`6` files checked, `2` changed).
- 2026-05-31: `flutter test test/features/launchpad/launchpad_dca_builder_page_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/features/launchpad --reporter=compact`
  passed (`121` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-12
  page/widget/helper files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-12: files `>1000` = `61`, feature files
  `>600` = `227`, feature files `>1200` = `0`.

### LG-13 - Design System dev page split

Status: `[x]`

Source:

- `flutter_app/lib/features/dev/presentation/pages/design_system_page.dart`
  (`1181` lines).

Target files:

| New file | Moves |
| --- | --- |
| `design_system_hero.dart` | `_Hero`. |
| `design_system_tokens_section.dart` | token rows and token section. |
| `design_system_color_section.dart` | swatches. |
| `design_system_cta_section.dart` | CTA demos. |
| `design_system_input_section.dart` | input demos/wrappers. |
| `design_system_playground.dart` | playground, segment controls, chips. |

Acceptance:

- Dev page remains first-class but no single dev file `>800` lines.
- No design token regression.

Verification log:

- 2026-05-31: Split `design_system_page.dart` from `1181` lines to `193`
  lines. New widget/helper files:
  `design_system_playground.dart` (`361` lines),
  `design_system_input_section.dart` (`168` lines),
  `design_system_common.dart` (`150` lines),
  `design_system_section_header_section.dart` (`104` lines),
  `design_system_color_section.dart` (`86` lines),
  `design_system_cta_section.dart` (`83` lines),
  `design_system_tokens_section.dart` (`75` lines),
  `design_system_hero.dart` (`62` lines), and
  `design_system_footer.dart` (`42` lines).
- 2026-05-31: Page now owns playground controllers/toggles and route layout
  only; design token/color/CTA/input/section/playground rendering moved to
  feature widgets.
- 2026-05-31: `dart format lib/features/dev/presentation/pages/design_system_page.dart lib/features/dev/presentation/widgets/design_system_common.dart lib/features/dev/presentation/widgets/design_system_hero.dart lib/features/dev/presentation/widgets/design_system_tokens_section.dart lib/features/dev/presentation/widgets/design_system_color_section.dart lib/features/dev/presentation/widgets/design_system_cta_section.dart lib/features/dev/presentation/widgets/design_system_input_section.dart lib/features/dev/presentation/widgets/design_system_section_header_section.dart lib/features/dev/presentation/widgets/design_system_playground.dart lib/features/dev/presentation/widgets/design_system_footer.dart`
  passed (`10` files checked, `1` changed).
- 2026-05-31: `flutter test test/features/dev/design_system_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-31: `flutter test test/features/dev --reporter=compact`
  passed (`18` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-13
  page/widget/helper files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-13: files `>1000` = `60`, feature files
  `>600` = `226`, feature files `>1200` = `0`.

### LG-14 - Earn Staking dashboard split

Status: `[x]`

Source:

- `flutter_app/lib/features/earn/presentation/pages/staking_dashboard_page.dart`
  (`1167` lines).

Target approach:

- Split dashboard header, KPI cards, chart/painter widgets, positions/list,
  risk/insurance/status copy.
- Keep Earn copy separate from Wallet/Prediction/Arena.
- Run Earn focused tests and analyze.

Verification log:

- 2026-05-31: Split `staking_dashboard_page.dart` from `1167` lines to
  `148` lines. New widget/helper files:
  `staking_dashboard_common.dart` (`148` lines),
  `staking_dashboard_summary.dart` (`208` lines),
  `staking_dashboard_charts.dart` (`301` lines),
  `staking_dashboard_positions.dart` (`257` lines), and
  `staking_dashboard_actions.dart` (`208` lines).
- 2026-05-31: `dart format lib/features/earn/presentation/pages/staking_dashboard_page.dart lib/features/earn/presentation/widgets/staking_dashboard_common.dart lib/features/earn/presentation/widgets/staking_dashboard_summary.dart lib/features/earn/presentation/widgets/staking_dashboard_charts.dart lib/features/earn/presentation/widgets/staking_dashboard_positions.dart lib/features/earn/presentation/widgets/staking_dashboard_actions.dart`
  passed after correcting Vietnamese UI copy encoding introduced during the
  split.
- 2026-05-31: `flutter test test/features/earn/staking_dashboard_page_test.dart --reporter=compact`
  passed (`5` tests).
- 2026-05-31: `flutter test test/features/earn --reporter=compact` passed
  (`354` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-14
  page/widget/helper files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-14: files `>1000` = `59`, feature files
  `>600` = `225`, feature files `>1200` = `0`.

### LG-15 - DCA Backtester page split

Status: `[x]`

Source:

- `flutter_app/lib/features/dca/presentation/pages/dca_backtester_page.dart`
  (`1154` lines, painters).

Target approach:

- Split input/config panel, result summary, comparison chart, scenario list,
  painter file.
- Move calculations to controller/helper if page owns business logic.
- Run DCA tests and analyze.

Verification log:

- 2026-05-31: Split `dca_backtester_page.dart` from `1154` lines to `120`
  lines. New widget/helper files:
  `dca_backtester_common.dart` (`220` lines),
  `dca_backtester_tabs.dart` (`103` lines),
  `dca_backtester_setup.dart` (`350` lines),
  `dca_backtester_results.dart` (`233` lines),
  `dca_backtester_analysis.dart` (`152` lines), and
  `dca_backtester_charts.dart` (`153` lines).
- 2026-05-31: `dart format lib/features/dca/presentation/pages/dca_backtester_page.dart lib/features/dca/presentation/widgets/dca_backtester_common.dart lib/features/dca/presentation/widgets/dca_backtester_tabs.dart lib/features/dca/presentation/widgets/dca_backtester_setup.dart lib/features/dca/presentation/widgets/dca_backtester_results.dart lib/features/dca/presentation/widgets/dca_backtester_analysis.dart lib/features/dca/presentation/widgets/dca_backtester_charts.dart`
  passed.
- 2026-05-31: `flutter test test/features/dca/dca_backtester_page_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-31: `flutter test test/features/dca --reporter=compact` passed
  (`44` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-15
  page/widget/helper files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-15: files `>1000` = `58`, feature files
  `>600` = `224`, feature files `>1200` = `0`.

### LG-16 - P2P Dispute Detail page split

Status: `[x]`

Source:

- `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_detail_page.dart`
  (`1143` lines).

Target files:

| New file | Moves |
| --- | --- |
| `p2p_dispute_status_banner.dart` | `_StatusBanner`. |
| `p2p_dispute_escalation_card.dart` | `_EscalationCard`, `_LevelNode`. |
| `p2p_dispute_evidence_card.dart` | `_EvidenceCard`. |
| `p2p_dispute_timeline_card.dart` | `_TimelineCard`, timeline item. |
| `p2p_dispute_support_chat.dart` | `_SupportChatCard`, message bubble. |
| `p2p_dispute_actions_card.dart` | `_ActionsCard`, action tiles/buttons. |

Acceptance:

- Page `<600` lines.
- Message send/escalation local state unchanged.
- P2P payment/payment-method copy remains risk-aware.

Verification log:

- 2026-05-31: Split `p2p_dispute_detail_page.dart` from `1143` lines to
  `198` lines. New widget/helper files:
  `p2p_dispute_detail_common.dart` (`125` lines),
  `p2p_dispute_status_banner.dart` (`110` lines),
  `p2p_dispute_escalation_card.dart` (`257` lines),
  `p2p_dispute_evidence_card.dart` (`96` lines),
  `p2p_dispute_timeline_card.dart` (`108` lines),
  `p2p_dispute_support_chat.dart` (`206` lines), and
  `p2p_dispute_actions_card.dart` (`149` lines).
- 2026-05-31: `dart format lib/features/p2p/presentation/pages/p2p_dispute_detail_page.dart lib/features/p2p/presentation/widgets/p2p_dispute_detail_common.dart lib/features/p2p/presentation/widgets/p2p_dispute_status_banner.dart lib/features/p2p/presentation/widgets/p2p_dispute_escalation_card.dart lib/features/p2p/presentation/widgets/p2p_dispute_evidence_card.dart lib/features/p2p/presentation/widgets/p2p_dispute_timeline_card.dart lib/features/p2p/presentation/widgets/p2p_dispute_support_chat.dart lib/features/p2p/presentation/widgets/p2p_dispute_actions_card.dart`
  passed.
- 2026-05-31: `flutter test test/features/p2p/p2p_dispute_detail_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-31: `flutter test test/features/p2p --reporter=compact` passed
  (`311` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`) after removing
  one unused import from the support chat widget.
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-16
  page/widget/helper files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-16: files `>1000` = `57`, feature files
  `>600` = `223`, feature files `>1200` = `0`.

### LG-17 - Unified Portfolio Dashboard split

Status: `[x]`

Source:

- `flutter_app/lib/features/cross_module/presentation/pages/unified_portfolio_dashboard.dart`
  (`1141` lines, multiple painters).

Risk:

- Cross-module surfaces can accidentally blur Wallet, Prediction, Earn, Arena.
- Need explicit sections and copy boundaries.

Target approach:

- Split wallet, prediction, earn, risk, allocation, chart panels.
- Ensure Arena Points are not mixed into wallet/PnL copy.
- Run product copy guardrail.

Verification log:

- 2026-05-31: Split `unified_portfolio_dashboard.dart` from `1141` lines to
  `102` lines. New widget/helper files:
  `unified_portfolio_common.dart` (`219` lines),
  `unified_portfolio_tabs.dart` (`76` lines),
  `unified_portfolio_overview.dart` (`374` lines),
  `unified_portfolio_analysis.dart` (`216` lines),
  `unified_portfolio_history.dart` (`106` lines), and
  `unified_portfolio_painters.dart` (`150` lines).
- 2026-05-31: `dart format lib/features/cross_module/presentation/pages/unified_portfolio_dashboard.dart lib/features/cross_module/presentation/widgets/unified_portfolio_common.dart lib/features/cross_module/presentation/widgets/unified_portfolio_tabs.dart lib/features/cross_module/presentation/widgets/unified_portfolio_overview.dart lib/features/cross_module/presentation/widgets/unified_portfolio_analysis.dart lib/features/cross_module/presentation/widgets/unified_portfolio_history.dart lib/features/cross_module/presentation/widgets/unified_portfolio_painters.dart`
  passed.
- 2026-05-31: `flutter test test/features/cross_module/unified_portfolio_dashboard_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-31: `flutter test test/features/cross_module --reporter=compact`
  passed (`17` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\."` over the new LG-17
  page/widget/helper files found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-17: files `>1000` = `56`, feature files
  `>600` = `222`, feature files `>1200` = `0`.

### LG-18 - Arena Mode Detail page split

Status: `[x]`

Source:

- `flutter_app/lib/features/arena/presentation/pages/arena_mode_detail_page.dart`
  (`1139` lines).

Target approach:

- Split hero, rules, participation card, points pool, leaderboard, fair-play
  copy, completion states.
- Product copy must stay points-only:
  no `payout`, `wallet`, `profit`, `stake-return`.

Required verification:

```bash
dart format lib/features/arena
flutter test test/features/arena --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-05-31: Split `arena_mode_detail_page.dart` from `1139` lines to
  `174` lines. New widget/helper files:
  `arena_mode_detail_common.dart` (`91` lines),
  `arena_mode_detail_hero.dart` (`260` lines),
  `arena_mode_detail_rules.dart` (`114` lines),
  `arena_mode_detail_quality.dart` (`229` lines),
  `arena_mode_detail_actions.dart` (`40` lines),
  `arena_mode_detail_related.dart` (`220` lines), and
  `arena_mode_detail_prediction.dart` (`140` lines).
- 2026-05-31: `dart format lib/features/arena/presentation/pages/arena_mode_detail_page.dart lib/features/arena/presentation/widgets/arena_mode_detail_common.dart lib/features/arena/presentation/widgets/arena_mode_detail_hero.dart lib/features/arena/presentation/widgets/arena_mode_detail_rules.dart lib/features/arena/presentation/widgets/arena_mode_detail_quality.dart lib/features/arena/presentation/widgets/arena_mode_detail_actions.dart lib/features/arena/presentation/widgets/arena_mode_detail_related.dart lib/features/arena/presentation/widgets/arena_mode_detail_prediction.dart`
  passed.
- 2026-05-31: `flutter test test/features/arena/arena_mode_detail_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-31: `flutter test test/features/arena --reporter=compact` passed
  (`111` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\.|payout|wallet|profit|stake-return"`
  over the new LG-18 page/widget/helper files found no direct data imports,
  runtime `Colors.*`, or prohibited Arena financial-copy terms.
- 2026-05-31: Metrics after LG-18: files `>1000` = `55`, feature files
  `>600` = `221`, feature files `>1200` = `0`.

### LG-19 - DCA domain entities split

Status: `[x]`

Source:

- `flutter_app/lib/features/dca/domain/entities/dca_entities.dart`
  (`1112` lines).

Why special:

- This is not UI; it is domain model sprawl.
- Split can break many imports, so do after UI page/widget splits.

Suggested files:

| New file | Moves |
| --- | --- |
| `dca_common_entities.dart` | common enums, shared screen state. |
| `dca_overview_entities.dart` | overview/demo/dashboard entities. |
| `dca_rebalance_entities.dart` | rebalance target/config/dashboard entities. |
| `dca_schedule_entities.dart` | schedule strategy/time/preference entities. |
| `dca_portfolio_optimizer_entities.dart` | optimizer allocation/frontier/suggestion entities. |
| `dca_dynamic_amount_entities.dart` | dynamic strategy/volatility/config/history entities. |
| `dca_backtest_entities.dart` | backtest frequency/strategy/performance/result entities. |
| `dca_entities.dart` | Barrel export only, if compatible with existing imports. |

Implementation steps:

1. Mark LG-19 `[~]`.
2. Create new entity files under `features/dca/domain/entities/`.
3. Move classes by aggregate.
4. Keep `dca_entities.dart` as export barrel to avoid broad import churn.
5. Run:

```bash
dart format lib/features/dca/domain/entities
flutter test test/features/dca --reporter=compact
flutter analyze
```

Acceptance:

- Each domain entity file `<800` lines.
- Existing imports still compile through barrel.

Verification log:

- 2026-05-31: Split `dca_entities.dart` from `1112` lines to a `10` line
  export barrel. New aggregate files:
  `dca_common_entities.dart` (`9` lines),
  `dca_overview_entities.dart` (`191` lines),
  `dca_rebalance_entities.dart` (`147` lines),
  `dca_schedule_entities.dart` (`91` lines),
  `dca_portfolio_optimizer_entities.dart` (`93` lines),
  `dca_dynamic_amount_entities.dart` (`137` lines),
  `dca_backtest_entities.dart` (`120` lines),
  `dca_multi_asset_entities.dart` (`111` lines),
  `dca_performance_compare_entities.dart` (`115` lines), and
  `dca_smart_rule_entities.dart` (`107` lines).
- 2026-05-31: `dart format lib/features/dca/domain/entities` passed.
- 2026-05-31: Initial DCA test run caught `DcaScheduleOptionIcon` as a shared
  enum used by dynamic amount entities; moved it to
  `dca_common_entities.dart`.
- 2026-05-31: `flutter test test/features/dca --reporter=compact` passed
  (`44` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).
- 2026-05-31: `rg -n "features/.*/data|\bColors\." lib/features/dca/domain/entities`
  found no direct data imports or runtime `Colors.*`.
- 2026-05-31: Metrics after LG-19: files `>1000` = `54`, feature files
  `>600` = `220`, feature files `>1200` = `0`.

### LG-20 - Remaining `>1000` batch

Status: `[x]`

Purpose:

- Reduce all remaining files over 1000 lines after LG-01 to LG-19.

Remaining source list at baseline:

```text
1171 page   flutter_app/lib/features/markets/presentation/pages/derivatives_overview_page.dart
1167 page   flutter_app/lib/features/markets/presentation/pages/market_list_page.dart
1156 page   flutter_app/lib/features/earn/presentation/pages/staking_api_documentation_page.dart
1143 page   flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart
1138 widget flutter_app/lib/features/wallet/presentation/widgets/wallet_page_sections.dart
1137 page   flutter_app/lib/features/discovery/presentation/pages/topic_hub_page.dart
1136 page   flutter_app/lib/features/launchpad/presentation/pages/launchpad_notif_sound_page.dart
1131 page   flutter_app/lib/features/trade/presentation/pages/trader_profile_page.dart
1125 page   flutter_app/lib/features/trade/presentation/pages/dispute_resolution_page.dart
1120 page   flutter_app/lib/features/profile/presentation/pages/vip_page.dart
1118 page   flutter_app/lib/features/launchpad/presentation/pages/launchpad_swap_aggregator_page.dart
1117 page   flutter_app/lib/features/predictions/presentation/pages/prediction_data_integration_page.dart
1114 page   flutter_app/lib/features/trade/presentation/pages/copy_settings_page.dart
1112 page   flutter_app/lib/features/trade/presentation/pages/copy_performance_page.dart
1110 page   flutter_app/lib/features/profile/presentation/pages/api_key_create_page.dart
1106 page   flutter_app/lib/features/trade/presentation/pages/advanced_tools_demo_page.dart
1094 page   flutter_app/lib/features/trade/presentation/pages/risk_management_demo_page.dart
1092 page   flutter_app/lib/features/profile/presentation/pages/sub_account_page.dart
1091 page   flutter_app/lib/features/predictions/presentation/pages/prediction_social_page.dart
1090 page   flutter_app/lib/features/dca/presentation/pages/dca_performance_compare_page.dart
1084 page   flutter_app/lib/features/earn/presentation/pages/staking_insurance_fund_transparency_page.dart
1084 page   flutter_app/lib/features/earn/presentation/pages/savings_smart_suggestions_page.dart
1083 page   flutter_app/lib/features/earn/presentation/pages/savings_notification_preferences_page.dart
1081 page   flutter_app/lib/features/launchpad/presentation/pages/launchpad_abi_diff_page.dart
1075 page   flutter_app/lib/features/earn/presentation/pages/staking_tax_guide_page.dart
1070 page   flutter_app/lib/features/markets/presentation/pages/market_calendar_page.dart
1070 page   flutter_app/lib/features/earn/presentation/pages/staking_recommendations_page.dart
1069 page   flutter_app/lib/features/predictions/presentation/pages/prediction_risk_calculator_page.dart
1066 page   flutter_app/lib/features/predictions/presentation/pages/predictions_home_page.dart
1066 page   flutter_app/lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart
1062 page   flutter_app/lib/features/predictions/presentation/pages/prediction_portfolio_analyzer_page.dart
1060 page   flutter_app/lib/features/trade/presentation/pages/slippage_monitoring_page.dart
1059 other  flutter_app/lib/features/profile/data/repositories/mock_profile_repository.dart
1055 page   flutter_app/lib/features/earn/presentation/pages/staking_custody_page.dart
1051 page   flutter_app/lib/features/cross_module/presentation/pages/smart_alert_center.dart
1050 page   flutter_app/lib/features/earn/presentation/pages/staking_validator_selection_page.dart
1049 page   flutter_app/lib/features/trade/presentation/pages/best_execution_reports_page.dart
1044 page   flutter_app/lib/features/trade/presentation/pages/copy_safety_center_page.dart
1044 page   flutter_app/lib/features/trade/presentation/pages/arm_integration_status_page.dart
1043 page   flutter_app/lib/features/trade/presentation/pages/bot_performance_analytics_page.dart
1039 page   flutter_app/lib/features/trade/presentation/pages/bot_strategy_compare_page.dart
1033 page   flutter_app/lib/features/dca/presentation/pages/dca_overview_demo.dart
1031 page   flutter_app/lib/features/trade/presentation/pages/ex_ante_costs_page.dart
1027 widget flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_sections.dart
1026 page   flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_transfer_page.dart
1026 page   flutter_app/lib/features/markets/presentation/pages/market_heatmap_page.dart
1022 page   flutter_app/lib/features/markets/presentation/pages/comparison_tool_page.dart
1022 page   flutter_app/lib/features/arena/presentation/pages/arena_flow_map_page.dart
1015 page   flutter_app/lib/features/discovery/presentation/pages/unified_search_page.dart
1012 page   flutter_app/lib/features/trade/presentation/pages/copy_trading_v2_page.dart
1009 other  flutter_app/lib/app/router/app_route_paths.dart
1007 page   flutter_app/lib/features/earn/presentation/pages/savings_guide_page.dart
1007 page   flutter_app/lib/features/trade/presentation/pages/execution_venue_analysis_page.dart
1002 page   flutter_app/lib/features/earn/presentation/pages/staking_slashing_history_page.dart
```

Batch rules:

- Process by feature owner, not by raw line count only.
- Prefer 3-5 files per batch after LG-01 to LG-19 are complete.
- Each batch must lower `>1000` count or explain why not.
- Avoid touching router path constants unless there is a route-size-specific
  reason; `app_route_paths.dart` can remain larger if it is generated-style
  constants and stable.

Batch progress:

- 2026-05-31 Batch 1: Split
  `flutter_app/lib/features/earn/presentation/pages/staking_api_documentation_page.dart`
  from `1156` to `162` lines. New Earn presentation widget files:
  `staking_api_documentation_common.dart` (`223` lines),
  `staking_api_documentation_overview.dart` (`188` lines),
  `staking_api_documentation_endpoints.dart` (`215` lines),
  `staking_api_documentation_examples.dart` (`232` lines), and
  `staking_api_documentation_auth.dart` (`227` lines). Page now owns route,
  tab, selection, copy state, and layout composition only; widgets import
  domain entities and shared UI primitives, with no direct data imports or
  runtime `Colors.*`.
- 2026-05-31 Batch 1 verification: `dart format` passed; SC-379 focused test
  passed (`6` tests); Earn tests passed (`354` tests); architecture guardrail
  passed (`10` tests); `flutter analyze` passed. Metrics after batch:
  files `>1000` = `53`, feature files `>600` = `219`, feature files `>1200`
  = `0`.
- 2026-05-31 Batch 2: Split
  `flutter_app/lib/features/earn/presentation/pages/staking_tax_guide_page.dart`
  from `1075` to `119` lines and
  `flutter_app/lib/features/earn/presentation/pages/savings_guide_page.dart`
  from `1007` to `218` lines. New Earn presentation widget files max `395`
  lines. Both pages keep local tab/selection/form/modal state and route
  composition only; extracted widgets import domain entities and shared UI
  primitives, with no direct data imports or runtime `Colors.*`.
- 2026-05-31 Batch 2 verification: `dart format` passed; SC-356 focused test
  passed (`6` tests); SC-335 focused test passed (`5` tests); Earn tests
  passed (`354` tests); architecture guardrail passed (`10` tests);
  `flutter analyze` passed. Metrics after batch: files `>1000` = `51`,
  feature files `>600` = `217`, feature files `>1200` = `0`.
- 2026-05-31 Batch 3: Split
  `flutter_app/lib/features/earn/presentation/pages/staking_slashing_history_page.dart`
  from `1002` to `104` lines. New Earn presentation widget files max `283`
  lines. Page keeps tab state, repository snapshot lookup, and route/layout
  composition only; extracted widgets hold overview, history, statistics,
  prevention, painter, and shared helper UI. The split required adding the
  omitted trend painter back to the statistics widget file during focused
  compile verification.
- 2026-05-31 Batch 3 verification: `dart format` passed; SC-382 focused test
  passed (`5` tests); Earn tests passed (`354` tests); architecture guardrail
  passed (`10` tests); `flutter analyze` passed. Metrics after batch:
  files `>1000` = `50`, feature files `>600` = `216`, feature files `>1200`
  = `0`.
- 2026-05-31 Batch 4: Split
  `flutter_app/lib/features/earn/presentation/pages/savings_smart_suggestions_page.dart`
  from `1084` to `148` lines and
  `flutter_app/lib/features/earn/presentation/pages/savings_notification_preferences_page.dart`
  from `1083` to `203` lines. New Earn presentation widget files max `378`
  lines. Pages keep local tab/filter/toggle state and route/layout composition
  only; widgets hold summaries, filters, suggestion cards, trend/signal cards,
  notification sections, token switch, and shared helper UI.
- 2026-05-31 Batch 4 verification: `dart format` passed; SC-347 focused test
  passed (`6` tests); SC-345 focused test passed (`5` tests); Earn tests
  passed (`354` tests); architecture guardrail passed (`10` tests);
  `flutter analyze` passed. Metrics after batch: files `>1000` = `48`,
  feature files `>600` = `214`, feature files `>1200` = `0`.
- 2026-05-31 Batch 5: Split
  `flutter_app/lib/features/earn/presentation/pages/staking_custody_page.dart`
  from `1055` to `99` lines and
  `flutter_app/lib/features/earn/presentation/pages/staking_recommendations_page.dart`
  from `1070` to `179` lines. New Earn presentation widget files max `574`
  lines. Pages keep local feedback/amount state, repository lookup, modal
  launcher, and route/layout composition; widgets hold custody sections,
  recommendation profile/simulator/cards, strategy detail sheet, painter, and
  helper UI.
- 2026-05-31 Batch 5 verification: `dart format` passed; SC-375 focused test
  passed (`5` tests); SC-372 focused test passed (`5` tests); Earn tests
  passed (`354` tests); architecture guardrail passed (`10` tests);
  `flutter analyze` passed. Metrics after batch: files `>1000` = `46`,
  feature files `>600` = `212`, feature files `>1200` = `0`.
- 2026-05-31 Batch 6: Split
  `flutter_app/lib/features/earn/presentation/pages/staking_insurance_fund_transparency_page.dart`
  from `1084` to `103` lines and
  `flutter_app/lib/features/earn/presentation/pages/staking_validator_selection_page.dart`
  from `1050` to `189` lines. New Earn presentation widget files max `499`
  lines for insurance fund and `306` lines for validator selection. Pages keep
  tab/filter/detail state, repository lookup, and route/layout composition;
  widgets hold fund overview/claims/history, validator summary/filter/list,
  detail card, shared keys, sort labels, and helper UI. Validator selection was
  moved into `presentation/widgets/` public widget modules to avoid increasing
  tracked `presentation/pages/*_part_*.dart` debt.
- 2026-05-31 Batch 6 verification: `dart format` passed; SC-377 focused test
  passed (`5` tests); SC-362 focused test passed (`5` tests); Earn tests
  passed (`354` tests); architecture guardrail passed (`10` tests);
  `flutter analyze` passed. Guardrail grep for `features/*/data` imports and
  runtime `Colors.*` found no matches in touched files. Metrics after batch:
  files `>1000` = `44`, feature files `>600` = `210`, feature files `>1200`
  = `0`.
- 2026-05-31 Batch 7: Split
  `flutter_app/lib/features/markets/presentation/pages/derivatives_overview_page.dart`
  from `1171` to `142` lines and
  `flutter_app/lib/features/markets/presentation/pages/market_list_page.dart`
  from `1167` to `205` lines. New Markets presentation widget files max `457`
  lines for derivatives and `257` lines for market list. Pages keep local
  tab/sort/search/category/watchlist state and route/layout composition only;
  widgets hold tabs, overview cards, liquidation/perpetual cards, market
  header, filters, movers, tools, pair rows, discovery bridges, keys,
  painters, and formatting helpers.
- 2026-05-31 Batch 7 verification: `dart format` passed; SC-018 focused test
  passed (`5` tests); SC-008 focused test passed (`7` tests); Markets tests
  passed (`124` tests); architecture guardrail passed (`10` tests);
  `flutter analyze` passed. Guardrail grep for `features/*/data` imports and
  runtime `Colors.*` found no matches in touched Markets files. Metrics after
  batch: files `>1000` = `42`, feature files `>600` = `208`, feature files
  `>1200` = `0`.
- 2026-05-31 Batch 8: Split the remaining Markets `>1000` pages:
  `market_calendar_page.dart` from `1070` to `148` lines,
  `market_heatmap_page.dart` from `1026` to `157` lines, and
  `comparison_tool_page.dart` from `1022` to `165` lines. New Markets widget
  files max `376` lines. Pages keep local view/filter/selection/token state
  and route/layout composition only; widgets hold calendar tabs/filters/events,
  heatmap summary/controls/treemap/panels, comparison token picker/content,
  keys, painter, placement, and formatting helpers.
- 2026-05-31 Batch 8 verification: `dart format` passed; SC-017 focused test
  passed (`5` tests); SC-013 focused test passed (`5` tests); SC-016 focused
  test passed (`5` tests); Markets tests passed (`124` tests); architecture
  guardrail passed (`10` tests); `flutter analyze` passed after adding braces
  to the comparison add-token guard. Guardrail grep for `features/*/data`
  imports and runtime `Colors.*` found no matches in touched Markets files.
  Metrics after batch: files `>1000` = `39`, feature files `>600` = `205`,
  feature files `>1200` = `0`.
- 2026-05-31 Batch 9: Split Profile presentation pages:
  `vip_page.dart` from `1120` to `132` lines,
  `api_key_create_page.dart` from `1110` to `265` lines, and
  `sub_account_page.dart` from `1092` to `139` lines. New Profile widget
  chunks max `560` lines. Pages keep local tab/step/form/mask/expand state,
  provider reads, and route/layout composition; widgets hold VIP hero/overview/
  benefits, API key form/result, and sub-account summary/create/card sections.
- 2026-05-31 Batch 9 verification: `dart format` passed; SC-164 focused test
  passed (`4` tests); SC-162 focused test passed (`3` tests); SC-166 focused
  test passed (`4` tests); Profile tests passed (`38` tests); architecture
  guardrail passed (`10` tests); `flutter analyze` passed. Guardrail grep for
  `features/*/data` imports and runtime `Colors.*` found no matches in touched
  Profile files. Metrics after batch: files `>1000` = `36`, feature files
  `>600` = `202`, feature files `>1200` = `0`.
- 2026-05-31 Batch 10: Split
  `flutter_app/lib/features/profile/data/repositories/mock_profile_repository.dart`
  from `1059` to `215` lines. New data fixture part files max `447` lines:
  core profile fixtures, settings/activity/API fixtures, and VIP fixtures.
  Public `MockProfileRepository` methods and repository contract stayed
  unchanged.
- 2026-05-31 Batch 10 verification: `dart format` passed; Profile tests passed
  (`38` tests); architecture guardrail passed (`10` tests); `flutter analyze`
  passed. Runtime `Colors.*` grep found no matches in the split repository
  files. Metrics after batch: files `>1000` = `35`, feature files `>600` =
  `201`, feature files `>1200` = `0`.
- 2026-05-31 Batch 11: Split remaining Launchpad `>1000` pages:
  `launchpad_notif_sound_page.dart` from `1136` to `240` lines,
  `launchpad_swap_aggregator_page.dart` from `1118` to `198` lines, and
  `launchpad_abi_diff_page.dart` from `1081` to `181` lines. New Launchpad
  widget chunks max `444` lines. Pages keep local sound/category, swap tab,
  amount/slippage, ABI filter/expand/copy state and route/layout composition;
  widgets hold hero, controls, category cards, DEX quotes, history/settings,
  ABI summary, entry details, warning blocks, extensions, keys, and helpers.
- 2026-05-31 Batch 11 verification: `dart format` passed; SC-306/SC-314/SC-308
  focused tests passed (`16` tests); Launchpad tests passed (`121` tests);
  architecture guardrail passed (`10` tests); `flutter analyze` passed.
  Guardrail grep for `features/*/data` imports and runtime `Colors.*` found no
  matches in touched Launchpad files. Metrics after batch: files `>1000` =
  `32`, feature files `>600` = `198`, feature files `>1200` = `0`.
- 2026-05-31 Batch 12: Split remaining DCA `>1000` pages:
  `dca_performance_compare_page.dart` from `1090` to `166` lines and
  `dca_overview_demo.dart` from `1033` to `134` lines. New DCA widget chunks
  max `489` lines. Pages keep tab/loading/demo state, provider reads, route
  navigation, and layout composition; widgets hold comparison tabs, strategy
  cards, charts, analysis panels, overview preview, metrics, actions,
  skeleton, footer, and painters.
- 2026-05-31 Batch 12 verification: `dart format` passed; SC-178/SC-400
  focused tests passed (`8` tests); DCA tests passed (`44` tests);
  architecture guardrail passed (`10` tests); `flutter analyze` passed.
  Guardrail grep for `features/*/data` imports and runtime `Colors.*` found no
  matches in touched DCA files. Metrics after batch: files `>1000` = `30`,
  feature files `>600` = `196`, feature files `>1200` = `0`.
- 2026-05-31 Batch 13: Split remaining Discovery `>1000` pages:
  `topic_hub_page.dart` from `1137` to `145` lines and
  `unified_search_page.dart` from `1015` to `125` lines. New Discovery widget
  chunks max `490` lines. Pages keep topic/search/controller state, provider
  reads, route navigation, and layout composition; widgets hold topic rail,
  hero, bridge sections, prediction/arena/creator/search result cards,
  boundary disclosure, badges, CTA helpers, and avatars.
- 2026-05-31 Batch 13 verification: `dart format` passed; SC-284/SC-283
  focused tests passed (`10` tests); Discovery tests passed (`12` tests);
  product copy guardrail passed (`13` tests); architecture guardrail passed
  (`10` tests); `flutter analyze` passed. Guardrail grep for `features/*/data`
  imports and runtime `Colors.*` found no matches in touched Discovery files.
  Metrics after batch: files `>1000` = `28`, feature files `>600` = `194`,
  feature files `>1200` = `0`.
- 2026-05-31 Batch 14: Split
  `flutter_app/lib/features/cross_module/presentation/pages/smart_alert_center.dart`
  from `1051` to `109` lines. New Cross-module widget chunks max `354`
  lines. Page keeps active tab, channel overrides, provider read, navigation,
  and layout composition; widgets hold tabs, active alert summary/cards,
  history, settings channels/templates, module/status badges, small actions,
  and info panels.
- 2026-05-31 Batch 14 verification: `dart format` passed; SC-323 focused test
  passed (`3` tests); Cross-module tests passed (`17` tests); product copy
  guardrail passed (`13` tests); architecture guardrail passed (`10` tests);
  `flutter analyze` passed. Guardrail grep for `features/*/data` imports and
  runtime `Colors.*` found no matches in touched Cross-module files. Metrics
  after batch: files `>1000` = `27`, feature files `>600` = `193`, feature
  files `>1200` = `0`.
- 2026-05-31 Batch 15: Split
  `flutter_app/lib/features/arena/presentation/pages/arena_flow_map_page.dart`
  from `1022` to `166` lines. New Arena widget chunks max `333` lines. Page
  keeps expanded section, QA checkbox state, provider read, route navigation,
  and layout composition; widgets hold flow hero, route registry, group/node
  rows, shared component and handoff notes, QA checklist rows, disclaimer,
  labels, icons, and progress.
- 2026-05-31 Batch 15 verification: `dart format` passed; SC-197 focused test
  passed (`4` tests); Arena tests passed (`111` tests); product copy guardrail
  passed (`13` tests); architecture guardrail passed (`10` tests);
  `flutter analyze` passed. Guardrail grep for `features/*/data` imports and
  runtime `Colors.*` found no matches in touched Arena files. Metrics after
  batch: files `>1000` = `26`, feature files `>600` = `192`, feature files
  `>1200` = `0`.
- 2026-05-31 Batch 16: Split
  `flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_transfer_page.dart`
  from `1026` to `197` lines. New P2P widget chunks max `303` lines. Page
  keeps amount controller, selected asset, transfer type, confirm state,
  provider read, route navigation, and layout composition; widgets hold
  direction/wallet sides, asset tiles, amount input, quick percentages, fee and
  escrow notices, submit CTA, and confirmation panel.
- 2026-05-31 Batch 16 verification: `dart format` passed; SC-261 focused test
  passed (`5` tests); P2P tests passed (`311` tests); semantics critical flows
  passed (`6` tests); product copy guardrail passed (`13` tests); architecture
  guardrail passed (`10` tests); `flutter analyze` passed. Guardrail grep for
  `features/*/data` imports and runtime `Colors.*` found no matches in touched
  P2P files. Metrics after batch: files `>1000` = `25`, feature files `>600`
  = `191`, feature files `>1200` = `0`.
- 2026-05-31 Batch 17: Split remaining Wallet `>1000` files:
  `wallet_page_sections.dart` from `1138` to `22` lines,
  `wallet_buy_crypto_sections.dart` from `1027` to `19` lines, and
  `wallet_gas_optimizer_page.dart` from `1066` to `101` lines. The two section
  libraries now act as stable `part` facades, preserving existing imports.
  New Wallet widget chunks max `454` lines. Gas optimizer page keeps tab state,
  provider read, route navigation, and layout composition; widgets hold balance
  hero, DCA/tool grids, asset list/allocation, buy crypto input/payment/result
  flows, gas current/trend/tips cards, and painters.
- 2026-05-31 Batch 17 verification: `dart format` passed; SC-135/BuyCrypto/
  SC-149 focused tests passed (`11` tests); Wallet tests passed (`66` tests);
  semantics critical flows passed (`6` tests); product copy guardrail passed
  (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze`
  passed. Guardrail grep for `features/*/data` imports and runtime `Colors.*`
  found no matches in touched Wallet files. Metrics after batch: files `>1000`
  = `22`, feature files `>600` = `188`, feature files `>1200` = `0`.
- 2026-05-31 Batch 18: Split remaining Predictions `>1000` pages:
  `prediction_data_integration_page.dart` from `1117` to `169` lines,
  `prediction_social_page.dart` from `1091` to `152` lines,
  `prediction_risk_calculator_page.dart` from `1069` to `186` lines,
  `predictions_home_page.dart` from `1066` to `181` lines, and
  `prediction_portfolio_analyzer_page.dart` from `1062` to `115` lines. New
  Predictions widget chunks max `459` lines. Pages keep tab/filter/form/copy
  state, provider reads, route navigation, and layout composition; widgets hold
  source/API/webhook cards, social comments/analysis/share, risk calculator
  form/scenarios/guide, home filters/highlights/events, portfolio analytics,
  risk panels, and painters.
- 2026-05-31 Batch 18 verification: `dart format` passed; SC-027/SC-043/
  SC-040/SC-036/SC-038 focused tests passed (`23` tests); Predictions tests
  passed (`85` tests); product copy guardrail passed (`13` tests); semantics
  critical flows passed (`6` tests); architecture guardrail passed (`10`
  tests); `flutter analyze` passed. Guardrail grep for `features/*/data`
  imports and runtime `Colors.*` found no matches in touched Predictions files.
  Metrics after batch: files `>1000` = `17`, feature files `>600` = `183`,
  feature files `>1200` = `0`.
- 2026-05-31 Batch 19: Split Trade pages:
  `advanced_chart_page.dart` from `1143` to `129` lines,
  `trader_profile_page.dart` from `1131` to `118` lines,
  `dispute_resolution_page.dart` from `1125` to `194` lines, and
  `copy_settings_page.dart` from `1114` to `332` lines. New Trade widget chunks
  max `410` lines. Pages keep chart/trader/dispute/settings local state,
  controller/provider reads, route navigation, and layout composition; widgets
  hold chart header/toolbar/actions/painter, profile hero/tabs/trades/stats,
  complaint form/cases/timeline helpers, and copy settings sections.
- 2026-05-31 Batch 19 verification: `dart format` passed; SC-055/SC-087/
  SC-082/SC-067 focused tests passed (`19` tests); Trade tests passed (`343`
  tests); product copy guardrail passed (`13` tests); architecture guardrail
  passed (`10` tests); `flutter analyze` passed. Guardrail grep for
  `features/*/data` imports and runtime `Colors.*` found no matches in touched
  Trade files. Metrics after batch: files `>1000` = `13`, feature files `>600`
  = `179`, feature files `>1200` = `0`.
- 2026-05-31 Batch 20: Split Trade pages:
  `copy_performance_page.dart` from `1112` to `105` lines,
  `advanced_tools_demo_page.dart` from `1106` to `245` lines,
  `risk_management_demo_page.dart` from `1094` to `193` lines, and
  `slippage_monitoring_page.dart` from `1060` to `123` lines. New Trade widget
  chunks max `425` lines. Pages keep tab/sheet/toast/filter state, provider
  reads, route navigation, and layout composition; widgets hold copy
  performance summaries/details/charts, advanced tools overview/tabs/sheets,
  risk management overview/tabs/sheets, slippage stats/events/providers/
  history/alerts, and shared pills/panels.
- 2026-05-31 Batch 20 verification: `dart format` passed; SC-074/SC-062/
  SC-060/SC-098 focused tests passed (`16` tests); Trade tests passed (`343`
  tests); product copy guardrail passed (`13` tests); architecture guardrail
  passed (`10` tests); `flutter analyze` passed. Guardrail grep for
  `features/*/data` imports and runtime `Colors.*` found no matches in touched
  Trade files. Metrics after batch: files `>1000` = `9`, feature files `>600`
  = `175`, feature files `>1200` = `0`.
- 2026-05-31 Batch 21: Split Trade pages:
  `best_execution_reports_page.dart` from `1049` to `131` lines,
  `copy_safety_center_page.dart` from `1044` to `116` lines,
  `arm_integration_status_page.dart` from `1044` to `131` lines, and
  `bot_performance_analytics_page.dart` from `1043` to `125` lines. New Trade
  widget chunks max `431` lines. Pages keep tab/testing/timeframe/toast state,
  provider reads, route navigation, and layout composition; widgets hold best
  execution overview/current/archive panels, copy safety overview/metrics/tools/
  enforcement sections, ARM provider/SLA/action panels, bot performance charts,
  metrics, summaries, and painters.
- 2026-05-31 Batch 21 verification: `dart format` passed; SC-096/SC-083/
  SC-095/SC-124 focused tests passed (`15` tests); Trade tests passed (`343`
  tests); product copy guardrail passed (`13` tests); architecture guardrail
  passed (`10` tests); `flutter analyze` passed. Guardrail grep for
  `features/*/data` imports and runtime `Colors.*` found no matches in touched
  Trade files. Metrics after batch: files `>1000` = `5`, feature files `>600`
  = `171`, feature files `>1200` = `0`.
- 2026-05-31 Batch 22: Split final Trade `>1000` pages:
  `bot_strategy_compare_page.dart` from `1039` to `145` lines,
  `ex_ante_costs_page.dart` from `1031` to `112` lines,
  `copy_trading_v2_page.dart` from `1012` to `133` lines, and
  `execution_venue_analysis_page.dart` from `1007` to `145` lines. New Trade
  widget chunks max `440` lines. Pages keep local strategy/tab/sort/notice
  state, provider reads, route navigation, and layout composition; widgets hold
  strategy selection/metrics/painters, ex-ante overview/summary/breakdown/
  scenarios/actions, copy trading variant hero/list helpers, and execution
  venue summary/comparison/cost/speed/trend/common sections.
- 2026-05-31 Batch 22 verification: `dart format` passed; SC-126/SC-105/
  SC-064/SC-097 focused tests passed (`16` tests); Trade tests passed (`343`
  tests); product copy guardrail passed (`13` tests); architecture guardrail
  passed (`10` tests); `flutter analyze` passed. Guardrail grep for
  `features/*/data` imports and runtime `Colors.*` found no matches in touched
  Trade files. Metrics after Trade page batch: files `>1000` = `1`, feature
  files `>600` = `167`, feature files `>1200` = `0`.
- 2026-05-31 Batch 23: Split router constants by class to remove the final
  large Dart file. `app_route_paths.dart` moved `AppRouteNames` into
  `app_route_names.dart`; `app_route_paths.dart` dropped from `1009` to `550`
  lines and `app_route_names.dart` is `460` lines. Public `AppRouteNames` and
  `AppRoutePaths` API stayed in the same `app_router.dart` library.
- 2026-05-31 Batch 23 verification: `dart format` passed; router tests passed;
  `dart run tool/route_coverage_audit.dart --check` passed; architecture
  guardrail passed (`10` tests); `flutter analyze` passed; full
  `flutter test --reporter=compact` passed (`1866` tests). Final metrics:
  files `>1000` = `0`, feature files `>600` = `167`, feature files `>1200` =
  `0`.

## 6. Feature-level priority summary

| Feature | Files | Lines | Files `>600` | Files `>1000` | Priority |
| --- | ---: | ---: | ---: | ---: | --- |
| trade | `174` | `96327` | `62` | `19` | Highest volume; do staged batches. |
| earn | `170` | `82271` | `36` | `11` | Many page docs/guide style files; batch after high-risk. |
| wallet | `44` | `23409` | `18` | `7` | High-risk; prioritize LG-01/LG-03/LG-09/LG-10. |
| markets | `73` | `30869` | `12` | `7` | Chart/table-heavy; good split ROI. |
| predictions | `47` | `23241` | `14` | `6` | Financial-copy sensitive; prioritize before broad cleanup. |
| launchpad | `76` | `31645` | `11` | `5` | Good second wave. |
| profile | `20` | `10625` | `11` | `4` | Security/profile forms; avoid behavior churn. |
| dca | `39` | `15977` | `6` | `4` | Domain split requires care. |
| p2p | `131` | `64669` | `35` | `2` | High-risk but fewer `>1000`; dispute/wallet transfer first. |
| arena | `86` | `35919` | `11` | `2` | Product boundary sensitive; points-only checks required. |

## 7. Per-packet verification matrix

Always run from `flutter_app/`.

| Change type | Required commands |
| --- | --- |
| Any Dart edit | `dart format .`; `flutter analyze` |
| Wallet/P2P high-risk UI | Focused feature tests; `test/quality/accessibility_semantics_critical_flows_test.dart`; product copy guardrail when copy changes |
| Prediction/Arena UI | Focused feature tests; `test/quality/product_copy_guardrails_test.dart` |
| Router/navigation touched | `flutter test test/app/router --reporter=compact`; `dart run tool/route_coverage_audit.dart --check` |
| Shared widgets/theme touched | Focused feature tests plus responsive visual matrix slice |
| Domain split | Focused feature tests plus full analyze |

Recommended full packet close command:

```bash
dart format .
flutter analyze
flutter test --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Use full suite for broad/shared/domain/router changes. Use focused tests first
for narrow widget split packets.

## 8. Definition of Done

A packet is done only when:

- Status changed from `[~]` to `[x]`.
- Source file line count is below the target or the exception is documented.
- New files are in the right feature layer.
- Page remains route/layout composition only.
- No new direct page/widget imports from `features/*/data`.
- No new runtime `Colors.*` in `lib/`.
- No Product Boundary regression between Prediction Markets and Open Arena.
- High-risk confirmation copy remains explicit.
- Relevant tests pass and command output is recorded in the packet log.

## 9. Packet log

Append real command results here as work is completed.

| Date | Packet | Result | Commands/evidence |
| --- | --- | --- | --- |
| 2026-05-31 | Baseline | Created tracking file | Baseline scan found `73` files `>1000`, `239` feature files `>600`, and `0` feature files `>1200`. |
| 2026-05-31 | LG-01 | Passed | Split Token Approval page from `1198` to `117` lines; new widget files max `573` lines. `dart format` passed; token approval + semantics tests passed (`9` tests); wallet tests passed (`66` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `72`, feature files `>600` = `238`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-02 | Passed | Split Prediction Portfolio page from `1186` to `149` lines; new widget files max `294` lines. Product copy pre-scan found no portfolio-specific prohibited terms. `dart format` passed; portfolio + product-copy tests passed (`19` tests); predictions tests passed (`85` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `71`, feature files `>600` = `237`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-03 | Passed | Split Withdraw page from `1013` to `201` lines; new widget files max `544` lines. `dart format` passed; withdraw + semantics + product-copy tests passed (`24` tests); wallet tests passed (`66` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `70`, feature files `>600` = `236`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-04 | Passed | Split Transaction Reporting page from `1196` to `139` lines; new widget files max `424` lines. Report filtering moved to helper. `dart format` passed; transaction-reporting test passed (`4` tests); trade tests passed (`343` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `69`, feature files `>600` = `235`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-05 | Passed | Split Market Depth page from `1184` to `109` lines; new widget files max `458` lines. `dart format` passed; market-depth test passed (`8` tests); markets tests passed (`124` tests); responsive matrix passed (`3` viewport tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `68`, feature files `>600` = `234`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-06 | Passed | Split Market Sectors page from `1194` to `165` lines; new widget files max `275` lines. Sort/filter/detail coin helpers moved to common helper. `dart format` passed; market-sector test passed (`6` tests); markets tests passed (`124` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `67`, feature files `>600` = `233`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-07 | Passed | Split Execution Quality page from `1197` to `219` lines; new widget files max `316` lines. Kept "demo" naming unchanged pending product decision. `dart format` passed; execution-quality test passed (`5` tests); trade tests passed (`343` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `66`, feature files `>600` = `232`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-08 | Passed | Split Live Market Data Analytics widget barrel from `1194` to `7` lines; new widget files max `489` lines. Existing public import surface preserved through barrel exports. `dart format` passed; live-market test passed (`3` tests); trade tests passed (`343` tests); markets tests passed (`124` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `65`, feature files `>600` = `231`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-09 | Passed | Split Wallet Multi Manager widget barrel from `1168` to `6` lines; new widget files max `431` lines. Existing public import surface preserved through barrel exports. `dart format` passed; multi-manager test passed (`3` tests); wallet tests passed (`66` tests); semantics critical flows passed (`6` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `64`, feature files `>600` = `230`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-10 | Passed | Split Wallet Address Add widget barrel from `1116` to `5` lines; new widget files max `327` lines. Preserved SC-143 semantic labels and corrected Vietnamese UI copy encoding during split. `dart format` passed; address-add test passed (`3` tests); wallet tests passed (`66` tests); semantics critical flows passed (`6` tests); product-copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `63`, feature files `>600` = `229`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-11 | Passed | Split Launchpad Rebalance page from `1186` to `196` lines; new widget/helper files max `195` lines. Calculation helpers moved to a dedicated helper file, and page now owns state/composition only. `dart format` passed; rebalance test passed (`6` tests); launchpad tests passed (`121` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `62`, feature files `>600` = `228`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-12 | Passed | Split Launchpad DCA Builder page from `1184` to `204` lines; new widget/helper files max `397` lines. Page now owns controllers/tab/frequency/submit state only. `dart format` passed; DCA builder test passed (`6` tests); launchpad tests passed (`121` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `61`, feature files `>600` = `227`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-13 | Passed | Split Design System dev page from `1181` to `193` lines; new widget/helper files max `361` lines. Page now owns playground controller/toggle state only. `dart format` passed; design-system test passed (`4` tests); dev tests passed (`18` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `60`, feature files `>600` = `226`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-14 | Passed | Split Earn Staking Dashboard page from `1167` to `148` lines; new widget/helper files max `301` lines. Corrected Vietnamese UI copy encoding introduced during split. `dart format` passed; staking-dashboard test passed (`5` tests); earn tests passed (`354` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `59`, feature files `>600` = `225`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-15 | Passed | Split DCA Backtester page from `1154` to `120` lines; new widget/helper files max `350` lines. Page now owns tab/selection/result state and routing only. `dart format` passed; backtester test passed (`3` tests); DCA tests passed (`44` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `58`, feature files `>600` = `224`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-16 | Passed | Split P2P Dispute Detail page from `1143` to `198` lines; new widget/helper files max `257` lines. Message send/escalation local state and navigation keys preserved. `dart format` passed; dispute-detail test passed (`4` tests); P2P tests passed (`311` tests); product-copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `57`, feature files `>600` = `223`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-17 | Passed | Split Unified Portfolio Dashboard from `1141` to `102` lines; new widget/helper files max `374` lines. Page keeps route/tab/refresh orchestration while widgets keep Arena points-only copy separate from financial portfolio value. `dart format` passed; unified-portfolio test passed (`4` tests); cross-module tests passed (`17` tests); product-copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `56`, feature files `>600` = `222`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-18 | Passed | Split Arena Mode Detail page from `1139` to `174` lines; new widget/helper files max `260` lines. Points-only Arena copy and Prediction context boundary preserved. `dart format` passed; mode-detail test passed (`4` tests); Arena tests passed (`111` tests); product-copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `55`, feature files `>600` = `221`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-19 | Passed | Split DCA domain entities from one `1112` line file into a `10` line barrel and aggregate files max `191` lines. Shared enum dependency was corrected after focused compile failure. `dart format` passed; DCA tests passed (`44` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `54`, feature files `>600` = `220`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 1 | Passed | Split Staking API Documentation page from `1156` to `162` lines; new Earn widget files max `232` lines. Page keeps route/tab/selection/copy state only. `dart format` passed; SC-379 focused test passed (`6` tests); Earn tests passed (`354` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `53`, feature files `>600` = `219`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 2 | Passed | Split Staking Tax Guide page from `1075` to `119` lines and Savings Guide page from `1007` to `218` lines; new widget files max `395` lines. Pages keep local state and route/layout composition only. `dart format` passed; SC-356 focused test passed (`6` tests); SC-335 focused test passed (`5` tests); Earn tests passed (`354` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `51`, feature files `>600` = `217`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 3 | Passed | Split Staking Slashing History page from `1002` to `104` lines; new widget files max `283` lines. Re-added the trend painter to the statistics widget after focused compile caught the missing split segment. `dart format` passed; SC-382 focused test passed (`5` tests); Earn tests passed (`354` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `50`, feature files `>600` = `216`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 4 | Passed | Split Savings Smart Suggestions page from `1084` to `148` lines and Savings Notification Preferences page from `1083` to `203` lines; new widget files max `378` lines. Pages keep local tab/filter/toggle state only. `dart format` passed; SC-347 focused test passed (`6` tests); SC-345 focused test passed (`5` tests); Earn tests passed (`354` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `48`, feature files `>600` = `214`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 5 | Passed | Split Staking Custody page from `1055` to `99` lines and Staking Recommendations page from `1070` to `179` lines; new widget files max `574` lines. Pages keep local feedback/amount state and route/layout composition only. `dart format` passed; SC-375 focused test passed (`5` tests); SC-372 focused test passed (`5` tests); Earn tests passed (`354` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `46`, feature files `>600` = `212`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 6 | Passed | Split Staking Insurance Fund Transparency page from `1084` to `103` lines and Staking Validator Selection page from `1050` to `189` lines; new widget files max `499` lines. Pages keep local tab/filter/detail state and route/layout composition only; validator UI moved to `presentation/widgets/` public modules to keep page part-file debt flat. `dart format` passed; SC-377 focused test passed (`5` tests); SC-362 focused test passed (`5` tests); Earn tests passed (`354` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `44`, feature files `>600` = `210`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 7 | Passed | Split Derivatives Overview page from `1171` to `142` lines and Market List page from `1167` to `205` lines; new Markets widget files max `457` lines. Pages keep local tab/sort/search/category/watchlist state and route/layout composition only. `dart format` passed; SC-018 focused test passed (`5` tests); SC-008 focused test passed (`7` tests); Markets tests passed (`124` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `42`, feature files `>600` = `208`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 8 | Passed | Split Market Calendar page from `1070` to `148` lines, Market Heatmap page from `1026` to `157` lines, and Comparison Tool page from `1022` to `165` lines; new Markets widget files max `376` lines. Pages keep local view/filter/selection/token state and route/layout composition only. `dart format` passed; SC-017 focused test passed (`5` tests); SC-013 focused test passed (`5` tests); SC-016 focused test passed (`5` tests); Markets tests passed (`124` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `39`, feature files `>600` = `205`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 9 | Passed | Split VIP page from `1120` to `132` lines, API Key Create page from `1110` to `265` lines, and Sub Account page from `1092` to `139` lines; new Profile widget chunks max `560` lines. Pages keep local tab/step/form/mask/expand state and route/layout composition only. `dart format` passed; SC-164 focused test passed (`4` tests); SC-162 focused test passed (`3` tests); SC-166 focused test passed (`4` tests); Profile tests passed (`38` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `36`, feature files `>600` = `202`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 10 | Passed | Split Profile mock repository from `1059` to `215` lines; new data fixture part files max `447` lines. Public `MockProfileRepository` API stayed unchanged. `dart format` passed; Profile tests passed (`38` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `35`, feature files `>600` = `201`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 11 | Passed | Split Launchpad notification sound page from `1136` to `240` lines, swap aggregator page from `1118` to `198` lines, and ABI diff page from `1081` to `181` lines; new Launchpad widget chunks max `444` lines. Pages keep local state and route/layout composition only. `dart format` passed; SC-306/SC-314/SC-308 focused tests passed (`16` tests); Launchpad tests passed (`121` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `32`, feature files `>600` = `198`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 12 | Passed | Split DCA performance compare page from `1090` to `166` lines and overview demo from `1033` to `134` lines; new DCA widget chunks max `489` lines. Pages keep local state and route/layout composition only. `dart format` passed; SC-178/SC-400 focused tests passed (`8` tests); DCA tests passed (`44` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `30`, feature files `>600` = `196`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 13 | Passed | Split Discovery topic hub page from `1137` to `145` lines and unified search page from `1015` to `125` lines; new Discovery widget chunks max `490` lines. Pages keep local state and route/layout composition only. `dart format` passed; SC-284/SC-283 focused tests passed (`10` tests); Discovery tests passed (`12` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `28`, feature files `>600` = `194`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 14 | Passed | Split Cross-module smart alert center from `1051` to `109` lines; new Cross-module widget chunks max `354` lines. Page keeps local tab/channel state and route/layout composition only. `dart format` passed; SC-323 focused test passed (`3` tests); Cross-module tests passed (`17` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `27`, feature files `>600` = `193`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 15 | Passed | Split Arena flow map page from `1022` to `166` lines; new Arena widget chunks max `333` lines. Page keeps local section/QA state and route/layout composition only. `dart format` passed; SC-197 focused test passed (`4` tests); Arena tests passed (`111` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `26`, feature files `>600` = `192`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 16 | Passed | Split P2P wallet transfer page from `1026` to `197` lines; new P2P widget chunks max `303` lines. Page keeps local amount/asset/type/confirm state and route/layout composition only. `dart format` passed; SC-261 focused test passed (`5` tests); P2P tests passed (`311` tests); semantics critical flows passed (`6` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `25`, feature files `>600` = `191`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 17 | Passed | Split remaining Wallet large files: `wallet_page_sections.dart` from `1138` to `22` lines, `wallet_buy_crypto_sections.dart` from `1027` to `19` lines, and gas optimizer page from `1066` to `101` lines; new Wallet chunks max `454` lines. Existing section imports are preserved through part facades. `dart format` passed; focused Wallet tests passed (`11` tests); Wallet tests passed (`66` tests); semantics critical flows passed (`6` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `22`, feature files `>600` = `188`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 18 | Passed | Split remaining Predictions large pages: data integration `1117` to `169`, social `1091` to `152`, risk calculator `1069` to `186`, home `1066` to `181`, and portfolio analyzer `1062` to `115` lines; new Predictions chunks max `459` lines. Pages keep local state and route/layout composition only. `dart format` passed; focused Predictions tests passed (`23` tests); Predictions tests passed (`85` tests); product copy guardrail passed (`13` tests); semantics critical flows passed (`6` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `17`, feature files `>600` = `183`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 19 | Passed | Split Trade advanced chart `1143` to `129`, trader profile `1131` to `118`, dispute resolution `1125` to `194`, and copy settings `1114` to `332` lines; new Trade chunks max `410` lines. Pages keep local state and route/layout composition only. `dart format` passed; focused Trade tests passed (`19` tests); Trade tests passed (`343` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `13`, feature files `>600` = `179`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 20 | Passed | Split Trade copy performance `1112` to `105`, advanced tools demo `1106` to `245`, risk management demo `1094` to `193`, and slippage monitoring `1060` to `123` lines; new Trade chunks max `425` lines. Pages keep local state and route/layout composition only. `dart format` passed; focused Trade tests passed (`16` tests); Trade tests passed (`343` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `9`, feature files `>600` = `175`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 21 | Passed | Split Trade best execution reports `1049` to `131`, copy safety center `1044` to `116`, ARM integration status `1044` to `131`, and bot performance analytics `1043` to `125` lines; new Trade chunks max `431` lines. Pages keep local state and route/layout composition only. `dart format` passed; focused Trade tests passed (`15` tests); Trade tests passed (`343` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `5`, feature files `>600` = `171`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 22 | Passed | Split final Trade large pages: bot strategy compare `1039` to `145`, ex-ante costs `1031` to `112`, copy trading v2 `1012` to `133`, and execution venue analysis `1007` to `145` lines; new Trade chunks max `440` lines. Pages keep local state and route/layout composition only. `dart format` passed; focused Trade tests passed (`16` tests); Trade tests passed (`343` tests); product copy guardrail passed (`13` tests); architecture guardrail passed (`10` tests); `flutter analyze` passed. Metrics: files `>1000` = `1`, feature files `>600` = `167`, feature files `>1200` = `0`. |
| 2026-05-31 | LG-20 Batch 23 | Passed | Split router constants by class: `app_route_paths.dart` `1009` to `550` lines and new `app_route_names.dart` `460` lines. Public router facade stayed through `app_router.dart`. `dart format` passed; router tests passed; route coverage audit passed; architecture guardrail passed (`10` tests); `flutter analyze` passed; full Flutter test suite passed (`1866` tests). Final metrics: files `>1000` = `0`, feature files `>600` = `167`, feature files `>1200` = `0`. |

