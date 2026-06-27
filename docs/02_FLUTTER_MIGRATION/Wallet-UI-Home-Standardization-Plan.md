# Wallet UI Home Standardization Redesign Plan

Status: Reset for visual redesign; no Wallet page is complete until this plan's
visual, density, safety, and audit gates pass.
Owner: Codex / VitTrade UI workstream
Scope: `flutter_app/lib/features/wallet/`
Home baseline source:

- `flutter_app/lib/features/home/presentation/pages/home_page.dart`
- `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`
- `flutter_app/lib/features/home/presentation/pages/home_page_part_02.dart`
- `flutter_app/lib/features/home/presentation/pages/home_page_part_03.dart`
- `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
- `docs/03_DESIGN_SYSTEM/Guidelines.md`

## Purpose

This document replaces the previous optimistic Wallet checklist. The prior pass
proved that Wallet pages render and that many routes/actions have focused tests,
but it did not prove that the UI is visually aligned with Home. A page must not
be marked standardized only because `flutter test test/features/wallet` passes.

The goal of this plan is to redesign every Wallet screen so it follows Home's
mobile, dark, dense, trust-first UI system while preserving Wallet-specific
financial safety, masking, fees, limits, previews, confirmations, routes,
providers, tests, and product boundaries.

## Why The Previous Completion State Was Wrong

The previous file marked route pages as complete from functional test coverage.
That is insufficient because the tests mostly assert that widgets render, keys
exist, primary taps work, and confirmation surfaces open. They do not verify:

- Home-derived screen composition.
- `VitInsetScrollView` and shell-safe bottom clearance.
- `VitSectionHeader` rhythm.
- First-viewport usefulness at 360 px.
- Dense card/list hierarchy.
- Shared component adoption by pattern.
- Token-only spacing, radii, typography, and colors.
- Visual screenshot quality.
- Copy polish and typo-free Vietnamese/English text.
- Accessibility labels, focus, and semantics for all icon-only or high-risk
  controls.

Example: `TransferPage` passes its focused tests, but still uses local layout
constants, `SingleChildScrollView`, local section text, custom picker rows, and
a raw `TextField`; it also has copy issues in the confirmation sheet. This is a
functional pass, not a Home-standard visual pass.

## Source Priority

Use this priority order for every implementation batch:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/03_DESIGN_SYSTEM/Guidelines.md`
4. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
5. Current Home source files
6. Current Wallet source files
7. Shared primitives in `flutter_app/lib/shared/`
8. Theme tokens in `flutter_app/lib/app/theme/`
9. Wallet tests in `flutter_app/test/features/wallet/`

If visual consistency conflicts with financial safety, financial safety wins.

## Home Baseline To Extract And Reuse

Home is the pattern library. Do not copy Home business logic, data order,
campaign copy, routes, or portfolio state. Reuse the visual grammar.

### Home Page Contract

Use this page rhythm when a Wallet screen has matching needs:

```text
module header
-> module hero or primary context
-> primary action cluster
-> resume/status/safety card
-> tools, filters, tabs, or selectors
-> dense lists, records, or detail rows
-> secondary discovery or support
-> bottom-nav-safe content end
```

### Home Shell Contract

Home uses:

- `VitPageLayout`.
- `VitAutoHideHeaderScaffold`.
- `VitTopChrome` for true root Home behavior.
- `VitHeader` for module/detail pages.
- `VitInsetScrollView` for bottom-nav-safe scroll behavior.
- `VitPageContent(padding: VitContentPadding.compact)`.
- Shell-aware bottom clearance, not ad hoc bottom padding.

Wallet pages should use this shell unless a specific fullscreen/tool exception
is documented.

### Home Content Rhythm

Home content is compact and scan-first:

- A single hero/context area when needed.
- `VitSectionHeader` before meaningful sections.
- Compact vertical gaps from `AppSpacing`.
- Dense rows/lists for repeated information.
- One clear primary action cluster near the first viewport.
- Secondary actions in `VitActionTileGrid`, `VitServiceTile`, tabs, or sheets.
- No local card-inside-card stacks unless a real framed sub-surface is needed.

### Home Component Standards

Use shared primitives by pattern:

| Need | Required pattern |
| --- | --- |
| Page layout | `VitPageLayout`, `VitPageContent`, `VitInsetScrollView` |
| Header | `VitHeader` for Wallet routes; `VitTopChrome` only for true app roots |
| Section title | `VitSectionHeader` |
| Surface | `VitCard` variants with tokenized padding/radius |
| Primary action | `VitCtaButton` with icon when useful |
| Icon action | `VitIconButton` or `VitInlineIconAction` with tooltip/semantics |
| Action grid | `VitActionTileGrid` and `VitServiceTile` |
| Form field | `VitInput` before raw `TextField` |
| Tabs | `VitTabBar` |
| Status | `VitStatusPill`, `VitAccentPill`, `VitMetricDeltaPill` |
| State | `VitSkeleton`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner` |
| Risk | `VitHighRiskStatePanel` plus preview/confirm |
| Repeated detail rows | `VitInfoRow` or an approved shared equivalent |
| Bottom sheet | `VitSheetPanel`, `VitSheetHandle`, or `showVitBottomSheet` with shared content rhythm |

### Home Density And First Viewport

Home is useful in the first viewport. Wallet pages are not done if the first
viewport is mostly chrome, decorative hero space, vertical gaps, or oversized
cards while the first important action/list is below the fold.

Every Wallet screen must be checked at 360 px width:

- Module identity is visible.
- Main account/asset/transaction context is visible.
- At least one primary action or next step is visible.
- Text does not overflow.
- Bottom navigation does not cover controls, receipts, or disclosures.

### Home Token Rules

- Prefer `AppSpacing`, `AppRadii`, `AppTextStyles`, `AppColors`, and
  `AppModuleAccents.wallet`.
- Remove local spacing systems like `_walletGap = 8.0` when a token covers it.
- Use tabular numeric styling for money, amounts, percent, gas, limits, fees,
  confirmations, and balances.
- Use module accent as an accent layer only. Do not turn Wallet into a
  one-color blue/green surface.
- Do not use raw `Container`, `BoxDecoration`, raw `EdgeInsets`, raw
  `BorderRadius`, raw font sizes, or decorative local color constants in page
  bundles when shared primitives cover the need.

## Wallet Product And Safety Boundaries

- Prediction Markets and Open Arena remain separate from Wallet.
- `/p2p/wallet` remains out of scope.
- Preserve preview and confirmation for withdrawals, address add, token revoke,
  dust conversion, and other high-risk actions.
- Show fees, risk, limits, masked address/account data, and next steps before
  high-risk confirmation.
- Mask sensitive wallet addresses and account identifiers by default.
- Do not introduce hype, casino, payout, guaranteed profit, or hidden-fee copy.

## Required Workflow For Each Page

Before editing a page:

- Read this plan top to bottom.
- Read the target page, its widget parts, providers/controllers, and focused
  test.
- Run GitNexus `context` for the page class.
- Run GitNexus `impact(direction: upstream)` before editing any function,
  class, method, shared primitive, route, provider, controller, repository,
  value object, or helper.
- Run the nested action census for the target page and widgets.
- Record the current UI gap against the Home baseline.

Implementation rules:

- Work in the phase order below.
- Edit one screen or one tightly coupled screen pair per batch.
- Preserve routes, names, keys, providers, supported states, and safety flows.
- Prefer shared primitives; keep local composition only with an L3 reason.
- Add or update focused tests when behavior, layout contracts, states, or
  visual guardrails change.

After editing:

- Run `dart format` on touched Dart files.
- Run the focused page test.
- Run relevant Wallet tests for the batch.
- Run `flutter analyze`.
- Run design/density audits when first viewport, tokens, shared layout, or
  visual debt changes.
- Run GitNexus `detect_changes()` before commit.
- Update this plan with evidence.

Nested action census command:

```powershell
rg -n "VitCtaButton|IconButton|VitInlineIconAction|VitServiceTile|VitActionTileGrid|onTap:|onPressed:|showModalBottomSheet|showDialog|GestureDetector|InkWell|tabKey|filterKey|searchKey|confirm|preview|revoke|copy|scan|refresh|submit" flutter_app/lib/features/wallet/presentation/pages flutter_app/lib/features/wallet/presentation/widgets
```

## Verification Gates

Minimum code verification from `flutter_app/`:

```bash
dart format --output=none --set-exit-if-changed lib/features/wallet test/features/wallet
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test test/features/wallet --reporter=compact
```

Run these when navigation or broad shell behavior changes:

```bash
dart run tool/navigation_edge_audit.dart --check
flutter test --reporter=compact
```

Manual or emulator visual QA is required when a batch changes first viewport,
bottom chrome clearance, forms, sheets, dense rows, high-risk actions, or
responsive layout.

Do not mark a page `Done` until evidence exists for:

- Focused test.
- Wallet test subset.
- Analyzer.
- Token/density audit or documented reason why not applicable.
- 360 px first-viewport review.
- Action census reviewed.
- GitNexus impact and detect_changes recorded.

## Wallet Route Manifest

Expected route count: 21.
Expected primary page count: 19.
`DepositPage` and `WithdrawPage` each have generic and asset-scoped routes.

| # | Route | Route name | Page | Focused test | Redesign status |
| --- | --- | --- | --- | --- | --- |
| 1 | `/wallet` | `sc135Wallet` | `WalletPage` | `test/features/wallet/wallet_page_test.dart` | Done 2026-06-27; Home command-center/rootModule rhythm applied; 360x800 viewport evidence added; focused/Wallet/analyze/audits/full-suite pass |
| 2 | `/wallet/history` | `sc136TxHistory` | `TransactionHistoryPage` | `test/features/wallet/transaction_history_page_test.dart` | Done 2026-06-24; Home dense history rhythm applied; 360x800 first-row/export evidence pass |
| 3 | `/wallet/deposit` | `sc137Deposit` | `DepositPage` | `test/features/wallet/deposit_page_test.dart` | Done 2026-06-24; Home money-movement receive rhythm applied; 360x800 copy-address evidence pass |
| 4 | `/wallet/deposit/:asset` | `sc138DepositUsdt` | `DepositPage` | `test/features/wallet/deposit_page_test.dart` | Done 2026-06-24; asset-scoped selected asset preserved; focused test pass |
| 5 | `/wallet/withdraw` | `sc139Withdraw` | `WithdrawPage` | `test/features/wallet/withdraw_page_test.dart` | Done 2026-06-24; Home high-risk withdrawal rhythm applied; 360x800 form and preview evidence pass |
| 6 | `/wallet/withdraw/:asset` | `sc140WithdrawUsdt` | `WithdrawPage` | `test/features/wallet/withdraw_page_test.dart` | Done 2026-06-24; asset-scoped route preserved; preview/confirm safety evidence pass |
| 7 | `/wallet/transaction/:txId` | `sc141TransactionDetail` | `TransactionDetailPage` | `test/features/wallet/transaction_detail_page_test.dart` | Done 2026-06-24; Home receipt/detail rhythm applied; 360x800 copy action evidence pass |
| 8 | `/wallet/portfolio-analytics` | `sc142PortfolioAnalytics` | `PortfolioAnalyticsPage` | `test/features/wallet/portfolio_analytics_page_test.dart` | Done 2026-06-24; Home analytics rhythm applied; 360x800 period-selector evidence pass |
| 9 | `/wallet/address-book/add` | `sc143AddressAdd` | `AddressAddPage` | `test/features/wallet/address_add_page_test.dart` | Done 2026-06-24; Home high-risk address-add rhythm applied; 360x800 setup/preview/success-return evidence pass |
| 10 | `/wallet/address-book` | `sc144AddressBook` | `AddressBookPage` | `test/features/wallet/address_book_page_test.dart` | Done 2026-06-24; Home saved-address safety rhythm applied; 360x800 masked-address/copy/delete evidence pass |
| 11 | `/wallet/buy-crypto` | `sc145BuyCrypto` | `BuyCryptoPage` | `test/features/wallet/buy_crypto_page_test.dart` | Done 2026-06-24; Home buy/review/success rhythm applied; 360x800 input/review/submitting/success evidence pass |
| 12 | `/wallet/transfer` | `sc146Transfer` | `TransferPage` | `test/features/wallet/transfer_page_test.dart` | Done 2026-06-24; Home transfer rhythm applied; 360x800 amount/disabled/confirm evidence pass |
| 13 | `/wallet/asset/:assetId` | `sc147AssetDetail` | `AssetDetailPage` | `test/features/wallet/asset_detail_page_test.dart` | Done 2026-06-24; Home asset-detail rhythm applied; 360x800 action/period evidence pass |
| 14 | `/wallet/multi-manager` | `sc148MultiManager` | `WalletMultiManagerPage` | `test/features/wallet/wallet_multi_manager_page_test.dart` | Done 2026-06-27; Home multi-wallet management rhythm applied; 360x800 tabs/wallet/reveal evidence pass |
| 15 | `/wallet/gas-optimizer` | `sc149GasOptimizer` | `WalletGasOptimizerPage` | `test/features/wallet/wallet_gas_optimizer_page_test.dart` | Done 2026-06-27; Home gas-estimate rhythm applied; 360x800 comparison-row evidence pass |
| 16 | `/wallet/token-approval` | `sc150TokenApproval` | `WalletTokenApprovalPage` | `test/features/wallet/wallet_token_approval_page_test.dart` | Done 2026-06-24; Home token-approval risk rhythm applied; 360x800 approval/revoke evidence pass |
| 17 | `/wallet/health-score` | `sc151HealthScore` | `WalletHealthScorePage` | `test/features/wallet/wallet_health_score_page_test.dart` | Done 2026-06-27; Home advisory-health rhythm applied; 360x800 priority-recommendation/sheet/legend evidence pass |
| 18 | `/wallet/pending-deposits` | `sc152PendingDeposits` | `PendingDepositsPage` | `test/features/wallet/pending_deposits_page_test.dart` | Done 2026-06-24; Home pending-status rhythm applied; 360x800 status/copy/refresh evidence pass |
| 19 | `/wallet/limits` | `sc153WithdrawLimits` | `WithdrawLimitsPage` | `test/features/wallet/withdraw_limits_page_test.dart` | Done 2026-06-24; Home limit/KYC ladder rhythm applied; 360x800 current-tier/usage evidence pass |
| 20 | `/wallet/dust-converter` | `sc154DustConverter` | `DustConverterPage` | `test/features/wallet/dust_converter_page_test.dart` | Done 2026-06-24; Home dust-conversion preview rhythm applied; 2026-06-27 sticky CTA follow-up fixed inline-scroll footer; 360x800 asset/confirm evidence pass |
| 21 | `/wallet/network-status` | `sc155NetworkStatus` | `NetworkStatusPage` | `test/features/wallet/network_status_page_test.dart` | Done 2026-06-24; Home network-health rhythm applied; 360x800 filter/worst-network evidence pass |

Excluded P2P routes:

- `/p2p/wallet`
- `/p2p/wallet/transfer`
- `/p2p/wallet/fund-lock-history`
- `/p2p/wallet/history`

## Redesign Phase Order

| Phase | Scope | Why this order | Status |
| --- | --- | --- | --- |
| 0 | Evidence reset and audit baseline | Stop treating functional tests as visual completion | Done 2026-06-24 |
| 1 | Shared Wallet visual foundation | Remove repeated local shell/card/spacing patterns before page work | Done 2026-06-24 |
| 2 | Wallet hub | Root command center defines module rhythm for child pages | Done 2026-06-24 |
| 3 | Money movement | Highest financial risk: deposit, withdraw, transfer, buy crypto | Done 2026-06-24 |
| 4 | Asset and history | Dense data/list/detail rhythm depends on root and movement patterns | Done 2026-06-24 |
| 5 | Address and safety | Masking, destructive actions, KYC, approvals, pending deposits | Done 2026-06-24 |
| 6 | Wallet tools | Dust, network, multi-manager, gas, health | Done 2026-06-27; dust, network, multi-manager, gas, and health evidence recorded |
| 7 | Full verification and artifact update | Confirm real visual alignment, not just widget tests | Done 2026-06-27; final gates and full suite pass |

## Phase 0: Evidence Reset

Tasks:

- [x] Run route manifest check against `wallet_routes.dart`.
- [x] Run Wallet action census.
- [x] Run design-token and visual-density audits.
- [x] Run `flutter test test/features/wallet --reporter=compact`.
- [x] Capture current first-viewport screenshots or emulator notes for the
      highest-risk pages: `WalletPage`, `DepositPage`, `WithdrawPage`,
      `TransferPage`, `AddressAddPage`, `WalletTokenApprovalPage`.
- [x] Update every page row in this plan with actual evidence, not assumptions.

Acceptance:

- [x] Current visual debt is documented.
- [x] No page is marked `Done` from tests alone.
- [x] Every deferred item has a reason.

### Phase 0 Evidence - 2026-06-24

Baseline commands and results:

- `rg --files flutter_app/lib/features/wallet/presentation/pages`: 22 Dart page
  files found. This includes 19 primary page classes plus 3
  `WalletHealthScorePage` part files.
- Route manifest check against
  `flutter_app/lib/app/router/route_groups/wallet_routes.dart`: 21 Wallet
  routes present, including generic and asset-scoped `DepositPage` and
  `WithdrawPage`; P2P wallet routes remain excluded.
- Wallet action census:
  `rg -n "VitCtaButton|IconButton|VitInlineIconAction|VitServiceTile|VitActionTileGrid|onTap:|onPressed:|showModalBottomSheet|showDialog|GestureDetector|InkWell|tabKey|filterKey|searchKey|confirm|preview|revoke|copy|scan|refresh|submit" flutter_app/lib/features/wallet/presentation/pages flutter_app/lib/features/wallet/presentation/widgets`
  returned 760 matches. Per-page action census must still be rerun inside each
  page batch before edits.
- `dart run tool/route_coverage_audit.dart --check`: Pass;
  route coverage artifact is current.
- `dart run tool/design_token_consistency_audit.dart --check`: initially
  failed because markdown and CSV artifacts were stale. Regenerated with
  `dart run tool/design_token_consistency_audit.dart`, then reran
  `--check`: Pass. Current baseline: `total_debt=383`,
  `p0_wallet_debt=9/759 pass`, strict typography residuals `0`.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass; artifacts are
  current. Current baseline: `total_routed_screens=414`,
  `P0_CRITICAL_DENSITY_REVIEW=0`, `P1_HIGH_DENSITY_REVIEW=0`,
  `P1_TOOL_VISUAL_QA=5`, `P2_MEDIUM_DENSITY_REVIEW=1`,
  `P3_LOW_DENSITY_REVIEW=165`.
- `flutter test test/features/wallet --reporter=compact`: Pass, 83 tests.
- `flutter analyze`: Pass, no issues.
- GitNexus `detect_changes(scope: all)`: low risk, `changed_count=0`,
  `affected_count=0`, `changed_files=3`, no affected processes. The changed
  files are Phase 0 documentation/audit artifacts, not indexed Dart symbols.

First-viewport baseline:

- Existing 360x800 widget-test evidence is present for
  `WalletPage`, `DepositPage`, `WithdrawPage`, `TransferPage`,
  `TransactionHistoryPage`, `TransactionDetailPage`, `AssetDetailPage`,
  `PortfolioAnalyticsPage`, `AddressBookPage`, `AddressAddPage`,
  `BuyCryptoPage`, `PendingDepositsPage`, `WithdrawLimitsPage`,
  `WalletTokenApprovalPage`, `DustConverterPage`, `NetworkStatusPage`,
  `WalletMultiManagerPage`, `WalletGasOptimizerPage`, and
  `WalletHealthScorePage`.
- At Phase 0, `WalletPage`, `BuyCryptoPage`, `AddressAddPage`, and
  `WalletMultiManagerPage` did not have 360x800 first-viewport widget
  evidence. Their ordered redesign batches now close those gaps.
- Highest-risk Phase 0 pages: `DepositPage`, `WithdrawPage`, `TransferPage`,
  and `WalletTokenApprovalPage` have current 360x800 widget-test evidence.
  `WalletPage` and `AddressAddPage` have evidence gaps documented above and
  must not be marked complete from functional tests. `WalletPage` closes this
  gap in Phase 2 with page-specific first-viewport evidence.

Current visual debt summary:

- Wallet has functional baseline coverage, but this plan remains reset for
  visual redesign. No Wallet page is `Done`.
- Token debt remains in the Wallet scope (`p0_wallet_debt=9`) and must be
  reduced or specifically justified during the page batches.
- Existing first-viewport tests prove some actionable content reaches 360x800;
  they do not prove Home-standard rhythm, shared primitive adoption, or
  first-screen polish. Each page batch must still record Home pattern,
  action inventory, L3 local reasons, financial safety, GitNexus evidence, and
  verification commands.

## Phase 1: Shared Wallet Visual Foundation

Goal: create or identify the smallest set of Wallet-local adapters needed to
apply Home rhythm consistently without inventing a second design system.

Inspect:

- `flutter_app/lib/shared/layout/`
- `flutter_app/lib/shared/widgets/`
- `flutter_app/lib/app/theme/`
- `flutter_app/lib/features/wallet/presentation/widgets/`

Required decisions:

- [x] Standard Wallet page shell: `VitPageLayout` + `VitHeader` +
      `VitInsetScrollView` + `VitPageContent.compact`.
- [x] Standard Wallet section rhythm: `VitSectionHeader` + compact card/list.
- [x] Standard Wallet financial hero/context card.
- [x] Standard Wallet form card using `VitInput`.
- [x] Standard Wallet sheet panel using `VitSheetPanel`/shared sheet rhythm.
- [x] Standard Wallet dense row for transaction/address/asset records.
- [x] Standard Wallet high-risk preview block.

Do not add a shared abstraction unless at least two Wallet pages need the same
visual pattern and existing shared primitives cannot cover it.

### Phase 1 Foundation Evidence - 2026-06-24

Inspection commands:

- `rg --files flutter_app/lib/shared/layout flutter_app/lib/shared/widgets flutter_app/lib/app/theme flutter_app/lib/features/wallet/presentation/widgets`
- `rg -n "VitPageLayout|VitHeader|VitInsetScrollView|VitPageContent|VitSectionHeader|VitCard|VitInput|VitSheetPanel|showVitBottomSheet|VitInfoRow|VitHighRiskStatePanel|VitActionTileGrid|VitServiceTile|SingleChildScrollView|TextField|Container\(|BoxDecoration|EdgeInsets|BorderRadius\.circular" flutter_app/lib/features/wallet/presentation/pages flutter_app/lib/features/wallet/presentation/widgets`

Foundation decision:

- Do not add a new Wallet-local foundation abstraction yet. Existing shared
  primitives cover the required Home-standard patterns:
  `VitPageLayout`, `VitHeader`, `VitInsetScrollView`, `VitPageContent`,
  `VitSectionHeader`, `VitCard`, `VitInput`, `VitInfoRow`,
  `VitHighRiskStatePanel`, `VitActionTileGrid`, `VitServiceTile`,
  `VitSheetPanel`, and `showVitBottomSheet`.
- Standard Wallet page shell for subsequent batches:
  `VitPageLayout` -> `Column` with `VitHeader` -> `Expanded` +
  `VitInsetScrollView(bottomInset: scrollEndPadding)` ->
  `VitPageContent(padding: VitContentPadding.compact, density: VitDensity.compact)`
  unless a page has a documented fullscreen/tool exception.
- Standard section rhythm: `VitSectionHeader` followed by compact
  `VitCard`, dense rows, tabs, or shared state widgets. Local title `Text`
  widgets need an L3 reason or replacement.
- Standard financial hero/context card: one `VitCard(variant: hero)` or one
  compact context card per page, tabular numeric text, balance/address masking
  preserved.
- Standard form card: `VitInput` for editable text/amount/address/label fields
  before raw `TextField`; any raw field must document an L3 reason.
- Standard sheet panel: use `showVitBottomSheet` and `VitSheetPanel`/shared
  sheet rhythm, with `VitInfoRow` for repeated facts and clear cancel/confirm
  hierarchy.
- Standard dense records: prefer `VitInfoRow`, shared row components, or
  compact `VitCard` rows with text/icon status. Color-only status is not
  sufficient.
- Standard high-risk preview block: `VitHighRiskStatePanel` plus visible fee,
  limit, masked address/account, risk, next step, and explicit preview/confirm
  sequence.

Known page-level visual debt to resolve in ordered batches:

- Several pages still use local `SingleChildScrollView` wrappers instead of
  `VitInsetScrollView`; fix page-by-page with first-viewport evidence.
- `TransferPage` and withdrawal amount widgets still have raw `TextField`
  usage that must move to `VitInput` or receive a documented L3 reason in their
  page batches.
- Local padding constants and local surface helpers remain in page bundles such
  as `wallet_page_balance_sections.dart`, `wallet_transfer_sections.dart`,
  `transaction_detail_page_common.dart`, and
  `portfolio_analytics_common.dart`; replace or justify them only when their
  owning page is active.
- No route, provider, controller, or shared primitive was changed in Phase 1.
- GitNexus `detect_changes(scope: all)`: low risk, `changed_count=0`,
  `affected_count=0`, `changed_files=3`, no affected processes.

## Phase 2: Wallet Hub

### 2.1 `WalletPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_balance_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_asset_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_dca_tool_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_allocation_sections.dart`
- `flutter_app/test/features/wallet/wallet_page_test.dart`

Current risk:

- Root page can look like a collection of Wallet-specific cards rather than the
  Home command-center rhythm.
- First viewport may over-prioritize balance chrome and push tools/lists below
  the fold.
- Tool actions can drift from Home's `VitActionTileGrid`/`VitServiceTile`.

Redesign target:

- Follow Home command center: header -> financial hero -> primary money CTAs
  -> pending/safety/next action -> tabs/search/filter -> dense assets/tools.
- Use one hero-weight balance card only.
- Keep balance masking and money figures tabular.
- Use `VitActionTileGrid` for tool launchers.
- Use `VitSectionHeader` for Assets, Allocation, Tools, Pending deposits, and
  Recent activity as applicable.

Must fix:

- [x] Replace local root section headers with `VitSectionHeader`.
- [x] Normalize scroll to `VitInsetScrollView`.
- [x] Ensure first viewport at 360 px shows balance context and primary CTAs.
- [x] Ensure Deposit, Withdraw, Transfer, Buy, History, Address Book, Pending,
      Limits, Dust, Network, Analytics, Asset row taps all remain routed.
- [x] Add visual/density assertions or screenshot notes.

Optimization:

- Prioritize scan speed: fewer oversized cards, more dense rows.
- Group secondary tools by user task: money movement, safety, optimization.
- Use tabular figures and concise labels.

Verification:

- [x] `flutter test test/features/wallet/wallet_page_test.dart --reporter=compact`
- [x] 360 px first-viewport check.
- [x] Design-token and visual-density audit rows reviewed.

### WalletPage Batch Evidence - 2026-06-24

Status: Done.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_balance_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_asset_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_dca_tool_sections.dart`
- `flutter_app/test/features/wallet/wallet_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- Header -> financial hero -> primary money CTAs -> pending-deposit status ->
  Wallet tools -> asset/allocation controls and dense content -> DCA support.
- `VitTopChrome` root chrome was replaced with route-level `VitHeader`.
- Tool launchers stay in `VitActionTileGrid`/`VitServiceTile` and moved above
  asset tabs so the first scroll rhythm mirrors Home command-center density.

Shared primitives adopted:

- `VitPageLayout`, `VitHeader`, `VitAutoHideHeaderScaffold`,
  `VitInsetScrollView`, `VitPageContent` with `VitDensity.compact`,
  `VitSectionHeader`, `VitCard`, `VitCtaButton`, `VitActionTileGrid`, and
  `VitServiceTile`.
- Replaced Wallet-local compact padding constants in hero, breakdown, asset
  rows, and DCA cards with shared `VitDensity` padding.

L3 local reasons:

- Kept the `Material(color: AppColors.bg)` wrapper because `VitSearchBar` and
  text-input descendants require a Material ancestor in widget tests and
  runtime. This is shell glue, not a new visual surface.
- Kept page-specific Wallet section widgets because they encode Wallet data,
  route actions, and compact financial rows; local padding constants were
  removed where shared density covers the need.

Action inventory result:

- Scoped action census reviewed `wallet_page.dart` plus Wallet page section
  parts for `VitCtaButton`, `VitActionTileGrid`, `onTap`, `onPressed`,
  `tabKey`, `filterKey`, `searchKey`, `copy`, and route launchers.
- Preserved action keys and routes for Deposit, Withdraw, Transfer, Buy,
  History, Address Book, Pending deposits, Limits, Dust, Network, Analytics,
  and asset row navigation.

Financial safety result:

- Balance masking remains controlled by the existing visibility toggle.
- No money-movement preview/confirm logic, fee logic, limit logic, providers,
  repositories, or routes were changed in this batch.
- P2P Wallet routes remain excluded.

First-viewport evidence:

- Added `SC-135 first viewport exposes balance and primary actions` in
  `test/features/wallet/wallet_page_test.dart`.
- The test uses `VitFirstViewport.minimumPhone` (360x800), asserts the
  `SC-135 WalletPage` semantic route is in the first viewport, and verifies
  the balance plus Deposit and Withdraw actions are actionable without scroll.

GitNexus evidence:

- `context(name: "WalletPage", kind: "Class")`: direct caller `_walletRoutes`;
  tests and navigation regression suites import the page.
- `impact(target: "WalletPage", direction: "upstream")`: CRITICAL from
  route-root fan-out, direct callers 2, affected processes 0; user was warned
  before edits.
- `impact(target: "_WalletPageState", direction: "upstream")`: CRITICAL from
  route-root fan-out, direct callers 1, affected processes 0.
- Leaf widget impacts for `WalletBalanceHero`, `WalletDcaCard`,
  `WalletToolGrid`, `WalletAssetSection`, `_AssetRow`,
  `WalletSegmentedTabs`, `WalletAllocationCard`, `_HeroActionButton`,
  `_CompactActionChip`, `_BreakdownRow`, `_DcaStatCard`, and `_IconCircle`
  were LOW or direct-call local.
- `detect_changes(scope: all)`: low risk, `changed_count=12`,
  `affected_count=0`, `changed_files=10`, no affected processes.

Headroom refs: none.

Verification:

- `dart format flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart flutter_app/lib/features/wallet/presentation/widgets/wallet_page_balance_sections.dart flutter_app/lib/features/wallet/presentation/widgets/wallet_page_asset_sections.dart flutter_app/lib/features/wallet/presentation/widgets/wallet_page_dca_tool_sections.dart flutter_app/test/features/wallet/wallet_page_test.dart`: Pass.
- `flutter test test/features/wallet/wallet_page_test.dart --reporter=compact`:
  initially failed from a missing Material ancestor after the header/shell
  rewrite; fixed in current batch and reran Pass, 7 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 84 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart`: Regenerated stale
  current Wallet/UI artifact; Wallet debt improved to `p0_wallet_debt=3/759`.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact; P0 and P1 density review counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

## Phase 3: Money Movement Pages

### 3.1 `DepositPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/deposit_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/deposit_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/deposit_page_sections.dart`
- `flutter_app/test/features/wallet/deposit_page_test.dart`

Current risk:

- Deposit flow can feel like a standalone form instead of a Home-derived money
  task.
- Address/QR, network, copy, refresh, and warning may not have a clear
  hierarchy.

Redesign target:

- Header -> deposit context hero -> network selector -> address/QR card ->
  warning/safety card -> pending/recent next step.
- Copy and refresh are icon actions with tooltip/semantics.
- Network sheet uses shared sheet density and selected row treatment.

Must fix:

- [x] Normalize shell to Home page contract.
- [x] Use `VitSectionHeader` for Network, Deposit Address, Safety.
- [x] Ensure address copy state is visible and not confused with a completed
      deposit.
- [x] Keep asset-scoped route selected asset.
- [x] Add empty/loading/offline visual states if provider can expose them.

Optimization:

- Put the selected network and minimum confirmation facts close to the address.
- Keep warning compact but visually stronger than normal info.

Verification:

- [x] `flutter test test/features/wallet/deposit_page_test.dart --reporter=compact`
- [x] 360 px address/copy/QR check.

### DepositPage Batch Evidence - 2026-06-24

Status: Done.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/deposit_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/deposit_page_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/deposit_page_common.dart`
- `flutter_app/test/features/wallet/deposit_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- Page already used `VitPageLayout` and `VitHeader`, but content still used
  `SingleChildScrollView`, raw `AppSpacing.contentInsets`, local padding
  constants, local `_InfoRow`, custom bottom-sheet padding/title rhythm, and a
  card-in-card network option row.
- The previous first-viewport test used the wider default shell viewport, not
  `VitFirstViewport.minimumPhone`.

Home pattern applied:

- Header -> compact network context -> deposit address/QR and copy action ->
  safety warning/high-risk panel -> deposit details -> refresh next action.
- Address/QR stays above the warning block so the 360x800 first viewport can
  still reach the copy-address action while safety content follows immediately.
- Kept a compact network context instead of adding a large hero card because
  the deposit task is address-first and must preserve first-screen usefulness.

Shared primitives adopted:

- Replaced `SingleChildScrollView` with `VitInsetScrollView`.
- Used `VitPageContent(padding: VitContentPadding.compact, density:
  VitDensity.compact)`.
- Added `VitSectionHeader` for Network, Deposit Address, Safety, and Deposit
  Details.
- Replaced local `_InfoRow` with `VitInfoRow`.
- Replaced local card padding constants with `VitDensity.compact` or
  `VitDensity.tool`.
- Replaced the custom network picker sheet body with `VitSheetPanel`.
- Removed card-in-card from `_NetworkOption`; the selected row is one
  interactable `VitCard`.

L3 local reasons:

- `_QrCode` and `_QrPainter` remain local because the QR visualization is
  page-specific deposit address rendering. Its internal padding now uses shared
  `VitDensity.compact.cardPadding`.
- `_NetworkSelector`, `_WarningCard`, `_QrAddressCard`, `_DepositInfoCard`,
  `_RefreshButton`, and `_NetworkOption` remain local because they bind
  Wallet deposit network data, copy state, and route/test keys. Shared
  primitives are used inside them.

Action inventory result:

- Scoped census reviewed `networkSelectorKey`, network row `onTap`,
  `copyAddressKey`, `refreshKey`, `showVitBottomSheet`, `copy`, and `refresh`.
- Preserved generic `/wallet/deposit` and asset-scoped `/wallet/deposit/:asset`
  behavior, network switching, copy address, and refresh intent.

Financial safety result:

- Deposit address and network copy remain visible before any action.
- Fee, minimum deposit, confirmations, wrong-network warning, and
  unrecoverable-risk copy remain visible.
- Copy success now uses tooltip/semantics and a success CTA variant, but it
  still reads as address copied rather than deposit completed.
- No provider, repository, endpoint, asset selection, fee/minimum data, or
  financial flow logic changed.
- P2P Wallet routes remain excluded.

First-viewport evidence:

- Updated `SC-137 first viewport reaches copy address action` to pump
  `VitFirstViewport.minimumPhone` (360x800).
- Focused test verifies `SC-137 DepositPage` semantics and that
  `DepositPage.copyAddressKey` is actionable in the first viewport.

GitNexus evidence:

- `context(name: "DepositPage", kind: "Class")`: direct caller
  `_walletRoutes`, focused test import, no execution flows.
- `impact(target: "DepositPage", direction: "upstream")`: CRITICAL from
  route-root fan-out, direct callers 2, affected processes 0; user was warned
  before edits.
- `impact(target: "_DepositPageState", direction: "upstream")`: CRITICAL from
  route-root fan-out, direct callers 1, affected processes 0.
- Local widget/method impacts for `_NetworkSelector`, `_WarningCard`,
  `_QrAddressCard`, `_DepositInfoCard`, `_RefreshButton`, `_NetworkOption`,
  `_QrCode`, `_copyAddress`, and `_openNetworkPicker` were LOW or local-only.
  `_refreshDepositIntent` did not resolve in the graph and was not modified.
- `detect_changes(scope: all)`: low risk, `changed_count=23`,
  `affected_count=0`, `changed_files=14`, no affected processes. Output also
  includes prior `WalletPage`/audit changes still in the dirty worktree; scoped
  batch diff is limited to `DepositPage` files, test, plan, and visual-density
  artifact.

Headroom refs: none.

Verification:

- `dart format lib/features/wallet/presentation/pages/deposit_page.dart lib/features/wallet/presentation/widgets/deposit_page_sections.dart lib/features/wallet/presentation/widgets/deposit_page_common.dart test/features/wallet/deposit_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/deposit_page_test.dart --reporter=compact`:
  initially failed because the network selector overflowed by 4 px after
  switching to compact card density; fixed by using `VitDensity.tool` for that
  fixed-height selector and reran Pass, 5 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 84 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=3/759 pass`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact; P0 and P1 density review counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

### 3.2 `WithdrawPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_form_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_amount_actions.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_network_picker.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_preview_sheet.dart`
- `flutter_app/test/features/wallet/withdraw_page_test.dart`

Current risk:

- This is high risk and must not be judged by render tests only.
- Form sections, address input, network picker, amount shortcut, limits link,
  and preview may not read as one clear safety-first sequence.

Redesign target:

- Header -> withdrawal context -> asset/network/address -> amount/limits ->
  risk/fee preview -> CTA -> confirmation sheet.
- Use `VitInput` for address and amount where possible.
- Use `VitHighRiskStatePanel` before or directly adjacent to the CTA.
- Preview sheet must use shared sheet rhythm and tabular values.

Must fix:

- [x] Ensure no withdrawal can bypass preview.
- [x] Ensure disabled submit explains missing/invalid state.
- [x] Show fee, receive amount, network, masked address, limit, and audit note
      before confirm.
- [x] Give scan/address-book actions semantic labels.
- [x] Check 360 px overflow for long address/network labels.

Optimization:

- Collapse secondary helper text under field labels.
- Keep max/all amount control close to amount field.
- Use danger/warning styling only for real risk.

Verification:

- [x] `flutter test test/features/wallet/withdraw_page_test.dart --reporter=compact`
- [x] High-risk state guardrail if touched.
- [x] 360 px form and preview sheet check.

### WithdrawPage Batch Evidence - 2026-06-24

Status: Done.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_form_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_amount_actions.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_network_picker.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_preview_sheet.dart`
- `flutter_app/test/features/wallet/withdraw_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- `VitHeader` route chrome remains in place, with content rhythm changed to
  withdrawal balance context -> network selector -> destination/recent address
  controls -> amount -> safety review -> validation/CTA -> support.
- `VitInsetScrollView` and `VitPageContent(padding: compact)` replace the ad
  hoc scroll/content shell.
- Preview and network sheets now use the shared bottom-sheet rhythm.

Shared primitives adopted:

- `VitInsetScrollView`, `VitSectionHeader`, `VitInput`, `VitInfoRow`,
  `VitSheetPanel`, `VitHighRiskStatePanel`, `VitCard` density options, and the
  existing `VitCtaButton`/`VitChoicePill` action patterns.

L3 local reasons:

- Recent address rows remain local because they are page-specific selectable
  masked-address rows with existing keys and subtitle metadata.
- The blocked-preview notice remains local because it is a withdrawal-specific
  validation message, but it is built on `VitCard` with tokenized density.
- Confirm/cancel sheet actions remain local to preserve the existing
  `withdrawCancelConfirmKey` and `withdrawConfirmWithdrawKey` hierarchy.

Action inventory result:

- Preserved network selector, scan action, all-amount shortcut, support link,
  preview CTA, and confirmation/cancel actions.
- CTA is disabled until the controller validation passes; the disabled reason
  is visible and present in semantics/tooltip.

Financial safety result:

- No withdrawal can bypass preview; `_showConfirmPreview` is only reachable from
  the enabled CTA after controller validation.
- Preview sheet shows amount, network, fee, estimated receive amount, masked
  address, and the high-risk audit note before the confirm action.
- `VitHighRiskStatePanel` stays directly adjacent to the CTA area, and the
  controller/provider/repository contracts were not changed.

First-viewport evidence:

- `SC-139 first viewport reaches withdrawal controls` runs at
  `VitFirstViewport.minimumPhone` and asserts the 360 px first viewport reaches
  the withdrawal control sequence.
- `SC-139 valid withdrawal opens fee and risk preview sheet` also runs from the
  minimum phone viewport, enters address/amount, opens the sheet, and verifies
  fee, receive amount, masked address, cancel, and confirm controls.

GitNexus evidence:

- `context(WithdrawPage)` found the router, focused withdraw tests, app router,
  and accessibility-critical flow references; no execution flows were attached
  to the page itself.
- `impact(direction: upstream)` was run before edits. Route/page fan-out
  returned CRITICAL for `WithdrawPage`, `_WithdrawPageState`,
  `WithdrawNetworkSelector`, `WithdrawAddressInput`, `WithdrawNetworkPicker`,
  `WithdrawNetworkOption`, `WithdrawPreviewSheet`, and
  `WithdrawConfirmActionButton`; local form helpers such as
  `WithdrawAmountInput`, `WithdrawWarning`, `WithdrawNextButton`,
  `_openNetworkPicker`, and `_showConfirmPreview` were LOW.
- `detect_changes(scope: all)` after the batch returned low risk:
  `changed_count=37`, `affected_count=0`, `changed_files=20`, and
  `affected_processes=[]`. The broad changed-file count includes prior dirty
  WalletPage/DepositPage batch files; the scoped diff for this batch is the
  withdraw files and regenerated Wallet/UI audit artifacts above.

Headroom refs: detect=7551468eaf6e73940b809d9f.

Verification:

- `dart format lib/features/wallet/presentation/pages/withdraw_page.dart lib/features/wallet/presentation/widgets/withdraw_form_sections.dart lib/features/wallet/presentation/widgets/withdraw_amount_actions.dart lib/features/wallet/presentation/widgets/withdraw_network_picker.dart lib/features/wallet/presentation/widgets/withdraw_preview_sheet.dart test/features/wallet/withdraw_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/withdraw_page_test.dart --reporter=compact`:
  initially failed only in updated test expectations because the preview sheet
  introduced a second `Địa chỉ nhận` label and the support link moved below the
  first viewport; fixed by asserting the masked address and ensuring the
  support link is visible, then reran Pass, 9 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 86 tests.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart`: Regenerated stale
  Wallet/UI artifact; `p0_wallet_debt=2/759 pass`.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact; P0 and P1 density review counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

### 3.3 `TransferPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_wallet_cards.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_asset_amount.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_history_picker.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_confirm_sheet.dart`
- `flutter_app/test/features/wallet/transfer_page_test.dart`

Current risk:

- Functional tests pass, but UI is not truly Home-standard.
- Uses `SingleChildScrollView`, `VitPageContent.none`, local gaps, local card
  heights, local sheet padding, and local row composition.
- Amount uses raw `TextField` rather than `VitInput`.
- Recent transfers use a plain `Text` title instead of `VitSectionHeader`.
- CTA appears before the risk review panel, making safety copy feel secondary.
- Confirmation sheet has copy/detail polish gaps and should be visually
  reviewed.

Redesign target:

- Header -> transfer direction card -> asset/amount card -> fee/risk summary
  -> primary CTA -> recent transfers.
- Use `VitInsetScrollView`.
- Use `VitSectionHeader` for From/To, Amount, Review, Recent transfers.
- Use `VitInput` for amount.
- Move or integrate risk/fee review before the CTA or into a clear preview
  block.
- Sheet uses shared sheet panel, `VitInfoRow`, tabular values, and explicit
  cancel/confirm hierarchy.

Must fix:

- [x] Replace ad hoc scroll and local spacing with Home shell/tokens.
- [x] Replace raw amount `TextField` with `VitInput` or document why not.
- [x] Add field validation for empty, zero, and above available balance.
- [x] Reorder safety copy so the user sees it before committing.
- [x] Use shared selected-row treatment in wallet/asset pickers.
- [x] Fix copy typos and awkward transfer info copy.
- [x] Ensure first viewport shows source/destination and amount entry.

Optimization:

- Make transfer direction visually obvious with a compact connector or step
  treatment.
- Keep wallet balances secondary and tabular.
- Convert recent transfers into dense rows under a real section header.

Verification:

- [x] `flutter test test/features/wallet/transfer_page_test.dart --reporter=compact`
- [x] Add test for invalid amount/disabled explanation if implemented.
- [x] 360 px screenshot/viewport review.

### TransferPage Batch Evidence - 2026-06-24

Status: Done.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_wallet_cards.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_asset_amount.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_history_picker.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_confirm_sheet.dart`
- `flutter_app/test/features/wallet/transfer_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- `VitHeader` route chrome remains in place, with content rhythm changed to
  transfer direction -> asset/amount entry -> safety review -> validation/CTA
  -> recent transfers.
- `VitInsetScrollView` and `VitPageContent(padding: compact)` replace the ad
  hoc scroll/content shell.
- Wallet and asset pickers plus confirmation now use the shared bottom-sheet
  rhythm.

Shared primitives adopted:

- `VitInsetScrollView`, `VitSectionHeader`, `VitInput`, `VitInfoRow`,
  `VitSheetPanel`, `VitHighRiskStatePanel`, `VitCard` density options,
  `VitIconButton`, `VitChoicePill`, and `VitCtaButton`.

L3 local reasons:

- `TransferDirectionCard` remains local because the source/destination/swap
  cluster is a page-specific two-wallet selector that must preserve
  `fromWalletKey`, `toWalletKey`, and `swapKey` while keeping amount entry in
  the 360 px first viewport.
- The validation notice remains local because it is transfer-specific copy, but
  it is built on `VitCard` with shared density and semantic disabled state on
  the CTA.
- Confirm/cancel actions remain local to preserve the existing
  `sc146_transfer_confirm` key and explicit cancel/confirm hierarchy.

Action inventory result:

- Preserved source wallet selector, destination wallet selector, swap action,
  asset selector, max amount shortcut, disabled/enabled submit CTA, and
  confirm/cancel sheet actions.
- Scoped scan after cleanup found no `SingleChildScrollView`, raw `TextField`,
  legacy sheet shape, local `EdgeInsetsDirectional`, `RoundedRectangleBorder`,
  `TransferWalletCard`, or `TransferAssetCard` in the transfer page bundle.

Financial safety result:

- Empty, zero, and above-available amounts are blocked before preview with a
  visible disabled reason.
- Safety copy and `VitHighRiskStatePanel` appear before the submit CTA.
- Confirmation sheet shows source wallet, destination wallet, asset, amount,
  estimated fiat value, fee, and review note before the confirm action.
- Provider, repository, route path, route name, and public keys were preserved.

First-viewport evidence:

- `SC-146 first viewport reaches transfer amount field` runs at
  `VitFirstViewport.minimumPhone` and asserts the amount field is visible in
  the usable first viewport.
- `SC-146 disabled transfer explains invalid amount` also runs at the minimum
  phone viewport and proves invalid state does not open the confirmation sheet.

GitNexus evidence:

- `context(TransferPage)` found wallet router construction, focused transfer
  test import, app router import, and asset detail test references; no page
  execution flows were attached.
- `impact(direction: upstream)` before edits returned CRITICAL for
  `TransferPage` and `_TransferPageState` because of route/router fan-out
  (`direct=2` and `direct=1`, `processes_affected=0`). Widget and method
  impacts for transfer-specific classes and handlers were LOW/direct page-only.
- `detect_changes(scope: all)` after the batch returned low risk:
  `changed_count=85`, `affected_count=0`, `changed_files=27`, and
  `affected_processes=[]`. The broad count includes prior dirty
  WalletPage/DepositPage/WithdrawPage batch files plus current transfer files
  and regenerated Wallet/UI audit artifacts.

Headroom refs: detect=40d7dd6e4775b2b5f839d093.

Verification:

- `dart format lib/features/wallet/presentation/pages/transfer_page.dart lib/features/wallet/presentation/widgets/wallet_transfer_sections.dart lib/features/wallet/presentation/widgets/wallet_transfer_wallet_cards.dart lib/features/wallet/presentation/widgets/wallet_transfer_asset_amount.dart lib/features/wallet/presentation/widgets/wallet_transfer_history_picker.dart lib/features/wallet/presentation/widgets/wallet_transfer_confirm_sheet.dart test/features/wallet/transfer_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/transfer_page_test.dart --reporter=compact`:
  initially failed only for updated UI/test contracts: old history/balance copy,
  amount field keyed to the inner `VitInput` text field with a 22 px render
  height, and submit below the fold after moving safety before CTA. Fixed by
  tightening the transfer direction/asset+amount layout, preserving the asset
  selector key, ensuring off-screen actions are visible before tap, and
  asserting the minimum-phone viewport. Rerun Pass, 5 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 87 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart`: Regenerated stale
  Wallet/UI artifact; `p0_wallet_debt=1/759 pass`.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact; P0 and P1 density review counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

### 3.4 `BuyCryptoPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/buy_crypto_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_input_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_payment_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_result_sections.dart`
- `flutter_app/test/features/wallet/buy_crypto_page_test.dart`

Current risk:

- Multi-step input/review/success can visually drift from Home and money-flow
  safety.
- Preset amounts, payment methods, and review facts may not use a shared rhythm.

Redesign target:

- Header -> buy context -> crypto/amount input -> payment method -> fee/receive
  review -> confirm -> success receipt.
- Use `VitInput`, `VitChoicePill`, `VitInfoRow`, `VitCtaButton`, and shared
  success treatment.

Must fix:

- [x] Distinguish input, review, submitting, and success states visually.
- [x] Keep fees, receive amount, provider, and payment method visible before
      confirmation.
- [x] Ensure review back action is obvious.
- [x] Prevent confirm state from looking like initial input state.

Optimization:

- Use compact preset amount chips.
- Put provider trust/risk details near the payment method, not below the fold.

Verification:

- [x] `flutter test test/features/wallet/buy_crypto_page_test.dart --reporter=compact`
- [x] 360 px review/success check.

Status: Done.

### BuyCryptoPage Batch Evidence - 2026-06-24

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/buy_crypto_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_input_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_payment_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_result_sections.dart`
- `flutter_app/test/features/wallet/buy_crypto_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- `VitInsetScrollView` + compact `VitPageContent` replace the local scroll
  wrapper and ad hoc page padding.
- Input rhythm now follows zero-fee context -> amount/asset section -> payment
  method section -> fee/limit review -> CTA.
- Review state is visually separated by `VitHighRiskStatePanel`,
  `VitSectionHeader`, and compact `VitInfoRow` facts.
- Submitting state disables confirm/back actions and shows `Đang xử lý` before
  the success receipt.
- Success receipt uses the Wallet `VitHeader`, `VitInsetScrollView`, compact
  `VitPageContent`, and `VitCard` instead of centered raw padding.
- Crypto picker uses `showVitBottomSheet` + `VitSheetPanel` and compact
  selectable `VitCard` rows.

Shared primitives adopted:

- `VitInsetScrollView`, `VitPageContent`, `VitSectionHeader`, `VitInput`,
  `VitInfoRow`, `VitCard`, `VitCtaButton`, `VitHighRiskStatePanel`, and
  `VitSheetPanel`.

L3 local reasons:

- `_CryptoLogo` remains local because the crypto options use provider-specific
  symbol initials and color metadata that are not a reusable Wallet primitive.
- The short local delayed submit state remains local because this mock flow has
  no repository mutation endpoint; it exists only to make the current
  review -> submitting -> success transition visible and testable.

Action inventory result:

- Scoped action census found preset taps, payment-card taps, crypto picker row
  taps, confirm/back CTAs, wallet/buy-more CTAs, and `showVitBottomSheet`.
- Scoped raw visual scan found no `SingleChildScrollView`, raw `TextField`,
  `showModalBottomSheet`, `RoundedRectangleBorder`, `BorderRadius.circular`,
  `BoxDecoration`, raw `EdgeInsets`, or raw `Container` in the BuyCrypto page
  bundle.

Financial safety result:

- Review state keeps payment amount, receive amount, payment method, fee, and
  next-step risk copy visible before confirmation.
- Confirm/back actions are disabled while submitting.
- Existing route, provider, keys, fee copy, payment method selection, and
  success actions are preserved.
- No P2P Wallet routes or Prediction Markets/Open Arena copy were touched.

First-viewport evidence:

- `SC-145 first viewport reaches amount input` verifies the route semantic and
  keyed amount input at the minimum-phone viewport.
- `SC-145 review and success states work at 360 px` verifies review facts,
  submitting text, and success receipt/actions at the minimum-phone viewport.

GitNexus evidence:

- `context(BuyCryptoPage)`: route and focused-test usage only; no execution
  flows.
- Pre-edit impact: `BuyCryptoPage` and `_BuyCryptoPageState` reported
  CRITICAL from route/router fan-out; widget/build helpers were LOW. No
  affected execution flows were reported.
- Post-batch `detect_changes(scope=all)`: low risk,
  `changed_count=117`, `affected_count=0`, `changed_files=33`,
  `affected_processes=[]`. The broad count includes prior dirty
  WalletPage/DepositPage/WithdrawPage/TransferPage batch files plus current
  BuyCrypto files and regenerated visual-density artifacts.

Headroom refs: detect=4fcb741c6db500bf8acd7d19.

Verification:

- `dart format lib/features/wallet/presentation/pages/buy_crypto_page.dart lib/features/wallet/presentation/widgets/wallet_buy_crypto_sections.dart lib/features/wallet/presentation/widgets/wallet_buy_crypto_input_sections.dart lib/features/wallet/presentation/widgets/wallet_buy_crypto_payment_sections.dart lib/features/wallet/presentation/widgets/wallet_buy_crypto_result_sections.dart test/features/wallet/buy_crypto_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/buy_crypto_page_test.dart --reporter=compact`:
  Pass, 5 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 89 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=1/759 pass`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact; P0 and P1 density review counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

## Phase 4: Asset And History Pages

### 4.1 `TransactionHistoryPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/transaction_history_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_history_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_history_page_sections.dart`
- `flutter_app/test/features/wallet/transaction_history_page_test.dart`

Redesign target:

- Header -> compact filter/search/tabs -> dense transaction rows -> empty/offline
  states -> export notice.

Must fix:

- [x] Use `VitTabBar`/shared chips for filters.
- [x] Use dense rows rather than oversized cards.
- [x] Keep row tap route to transaction detail.
- [x] Export action must read as request/notice, not completed export.
- [x] Empty state must be meaningful.

Optimization:

- Group status, amount, asset, network, and date into scan-friendly row zones.
- Use status text/icon, not color only.

Verification:

- [x] `flutter test test/features/wallet/transaction_history_page_test.dart --reporter=compact`

Status: Done.

### TransactionHistoryPage Batch Evidence - 2026-06-24

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/transaction_history_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_history_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_history_page_sections.dart`
- `flutter_app/test/features/wallet/transaction_history_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- Replaced the page-level `SingleChildScrollView` and ad hoc padding with
  `VitInsetScrollView` plus compact `VitPageContent`.
- Added compact `VitSectionHeader` rhythm for filters, recent transactions,
  and date groups.
- Replaced the local horizontal filter chip row with `VitTabBar` while
  preserving `TransactionHistoryPage.filterKey`.
- Converted transaction rows to compact `VitCard` rows with tokenized
  spacing, status text/pill, amount, asset, network/hash zones, and the
  existing detail route tap.
- Replaced the snackbar export path with an inline request notice because the
  Wallet shell has no descendant `Scaffold`; the previous action could throw
  on tap.

Shared primitives adopted:

- `VitInsetScrollView`, `VitPageContent`, `VitSectionHeader`, `VitTabBar`,
  `VitCard`, `VitStatusPill`, and `VitEmptyState`.

L3 local reasons:

- `_TransactionMeta`, `_StatusMeta`, `_formatDate`, `_timePart`,
  `_formatAmount`, and `_formatNumber` remain local because they map the
  Wallet transaction snapshot into route-specific display metadata and compact
  amount formatting.
- `_ExportNotice` remains local because it is the route-specific export request
  acknowledgement for the current filtered count.

Action inventory result:

- Scoped action census found header export, inline export request, shared tab
  filters, and transaction-row taps to detail.
- Scoped raw visual scan found no `SingleChildScrollView`, raw `TextField`,
  `showModalBottomSheet`, `RoundedRectangleBorder`, `BorderRadius.circular`,
  `BoxDecoration`, raw `EdgeInsets`, or raw `Container` in the transaction
  history page bundle.

Financial safety result:

- Read-only transaction history behavior is preserved.
- Status is expressed with text and `VitStatusPill`, not color alone.
- Export copy now reads as a request acknowledgement, not a completed CSV
  export.
- Row navigation to `/wallet/transaction/:txId` is preserved.
- No P2P Wallet routes, Prediction Markets, or Open Arena surfaces were
  touched.

First-viewport evidence:

- `SC-136 first viewport reaches first transaction row` now uses
  `VitFirstViewport.minimumPhone` (`360x800`) and verifies the first row is
  actionable above bottom navigation.
- The focused baseline test verifies the Wallet shell, shared bottom nav,
  export request copy, date group, first row, amount, and status text.

GitNexus evidence:

- `context(TransactionHistoryPage)`: incoming router and focused-test imports;
  no execution flows.
- Pre-edit impact: `TransactionHistoryPage` and
  `_TransactionHistoryPageState` reported CRITICAL due route/router fan-out;
  direct callers were router/test and `processes_affected=0`. Page build,
  filter/group/export helpers, and row widgets were LOW.
- Post-batch `detect_changes(scope=all)`: low risk,
  `changed_count=142`, `affected_count=0`, `changed_files=37`,
  `affected_processes=[]`. The broad count includes prior dirty completed
  Wallet batches plus current transaction-history files and regenerated
  visual-density artifacts.

Headroom refs: detect=7e3b580980b37f646e02c43b.

Verification:

- `dart format lib/features/wallet/presentation/pages/transaction_history_page.dart lib/features/wallet/presentation/widgets/transaction_history_page_common.dart lib/features/wallet/presentation/widgets/transaction_history_page_sections.dart test/features/wallet/transaction_history_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/transaction_history_page_test.dart --reporter=compact`:
  initially failed because the previous snackbar export action had no
  descendant `Scaffold`; fixed with the inline export request notice. Rerun
  Pass, 6 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 90 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=1/759 pass`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact; P0 and P1 density review counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

### 4.2 `TransactionDetailPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/transaction_detail_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_detail_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_detail_page_sections.dart`
- `flutter_app/test/features/wallet/transaction_detail_page_test.dart`

Redesign target:

- Header -> transaction status hero -> key facts -> network/hash/address rows
  -> support/explorer actions -> missing state.

Must fix:

- [x] Use `VitInfoRow` for repeated facts.
- [x] Copy actions need tooltip/semantics and visible copied state.
- [x] Missing transaction state must use shared empty/error treatment.
- [x] Back route remains history.

Optimization:

- Keep amount/status first, technical hashes below.
- Mask addresses where appropriate.

Verification:

- [x] `flutter test test/features/wallet/transaction_detail_page_test.dart --reporter=compact`

Status: Done.

### TransactionDetailPage Batch Evidence - 2026-06-24

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/transaction_detail_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_detail_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/transaction_detail_page_sections.dart`
- `flutter_app/test/features/wallet/transaction_detail_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- Replaced the page-level `SingleChildScrollView` and ad hoc scroll padding
  with `VitInsetScrollView` plus compact `VitPageContent`.
- Applied the receipt/detail rhythm: transaction status hero, progress card,
  dense detail rows, explorer action, support action, and shared missing state.
- Kept the Wallet `VitHeader` shell and `/wallet/transaction/:txId` route
  contract intact.

Shared primitives adopted:

- `VitInsetScrollView`, `VitPageContent`, `VitCard`, `VitSectionHeader`,
  `VitInfoRow`, `VitStatusPill`, `VitIconButton`, `VitCtaButton`, and
  `VitEmptyState`.
- Removed the local `_VitCardSurface` wrapper and local raw spacing constants.
- Replaced the snackbar copy acknowledgement with inline `VitStatusPill`
  feedback because the page shell does not provide a descendant `Scaffold`.

L3 local reasons:

- `_ProgressRow` keeps a small local timeline composition because the shared
  primitive set does not yet include a vertical transaction timeline. It now
  uses existing Wallet/Home spacing tokens and status colors with text labels.
- `_maskSensitiveValue` is local to the detail row mapper because masking is
  a page-specific display transformation while preserving the original copy
  value.

Action inventory result:

- Actions after redesign: support CTA (`VitCtaButton`), copy actions
  (`VitIconButton`), and explorer action (`VitCard` action surface).
- No `showModalBottomSheet`, `showDialog`, `GestureDetector`, raw `InkWell`,
  snackbar, or local scaffold remains in the page bundle.
- Raw visual scan found no `SingleChildScrollView`, local `Container`,
  `BoxDecoration`, `BorderRadius.circular`, or local `EdgeInsets` in the
  target page bundle.

Financial safety result:

- Read-only transaction detail behavior is preserved.
- TxID copy and support route behavior are preserved; copy confirmation is now
  inline and test-covered.
- Address display mapping now masks long address values while preserving the
  original value for copy actions.
- Status/progress is expressed with labels and icons, not color alone.
- No P2P Wallet routes, Prediction Markets, or Open Arena surfaces were
  touched.

First-viewport evidence:

- `SC-141 first viewport reaches TxID copy action` now runs at
  `VitFirstViewport.minimumPhone` (`360x800`) and passes.
- `SC-141 copy action shows inline confirmation` verifies the copy feedback
  contract at `360x800`.
- Route semantics `SC-141 TransactionDetailPage` remain visible above the
  bottom navigation in the first viewport.

GitNexus evidence:

- `context(TransactionDetailPage)`: incoming route handler and focused test
  imports only; no execution flows.
- `impact(TransactionDetailPage, upstream)`: CRITICAL due router/test fan-out,
  direct callers 2, affected processes 0. User was warned before edits.
- `impact(build, _copyValue, _TransactionDetailContent, _SummaryCard,
  _ProgressCard, _ProgressRow, _DetailsCard, _DetailInfoRow, _ExplorerButton,
  _SupportButton, _MissingTransaction)`: LOW for individual page-local symbols.
- `detect_changes(scope=unstaged)`: medium because the dirty worktree includes
  prior Wallet batches, changed_count 173, changed_files 41, affected_count 1,
  affected process `Build -> FindByFlow`. Scoped diff for this batch is 6 files,
  221 insertions, 241 deletions.

Headroom refs: detect=83f53ee2ff5ec2d7864e232c.

Verification:

- `dart format lib/features/wallet/presentation/pages/transaction_detail_page.dart lib/features/wallet/presentation/widgets/transaction_detail_page_common.dart lib/features/wallet/presentation/widgets/transaction_detail_page_sections.dart test/features/wallet/transaction_detail_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/transaction_detail_page_test.dart --reporter=compact`:
  Pass, 6 tests. Initial copy-feedback assertion failed before the callback was
  made UI-immediate; fixed and rerun passed.
- `flutter test test/features/wallet --reporter=compact`: Pass, 92 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=1/759`.
- `dart run tool/visual_density_risk_audit.dart`: regenerated stale density
  artifacts after the tool requested regeneration; `P0_CRITICAL_DENSITY_REVIEW=0`
  and `P1_HIGH_DENSITY_REVIEW=0`.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

### 4.3 `AssetDetailPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/asset_detail_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/asset_detail_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/asset_detail_page_sections.dart`
- `flutter_app/test/features/wallet/asset_detail_page_test.dart`

Redesign target:

- Header -> asset hero with balance/value -> asset action cluster -> chart/time
  controls -> dense transactions.

Must fix:

- [x] Use one hero context card with tabular balance/value.
- [x] Deposit, withdraw, transfer, DCA routes preserve asset.
- [x] Period controls fit at 360 px.
- [x] Chart summary and transaction rows do not overflow.

Optimization:

- Use action tiles or compact CTA row matching Home density.
- Put market/portfolio context before long transaction history.

Verification:

- [x] `flutter test test/features/wallet/asset_detail_page_test.dart --reporter=compact`

Status: Done.

### AssetDetailPage Batch Evidence - 2026-06-24

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/asset_detail_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/asset_detail_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/asset_detail_page_sections.dart`
- `flutter_app/test/features/wallet/asset_detail_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- Replaced the page-level `SingleChildScrollView` and ad hoc padding with
  `VitInsetScrollView` plus compact `VitPageContent`.
- Reworked the page rhythm to asset hero, asset action cluster, chart period
  controls, chart, dense transaction list, and bottom-nav-safe content end.
- Kept the Wallet `VitHeader` shell and `/wallet/asset/:assetId` route
  contract intact.

Shared primitives adopted:

- `VitInsetScrollView`, `VitPageContent`, `VitCard`, `VitActionTileGrid`,
  `VitServiceTile`, `VitSectionHeader`, `VitTabBar`, `VitMetricDeltaPill`,
  `VitStatusPill`, `VitSparkline`, and `VitEmptyState`.
- Replaced local action tiles with Home-aligned service tiles.
- Replaced local period pills with `VitTabBar` segment controls.
- Replaced transaction status text/color-only treatment with `VitStatusPill`.

L3 local reasons:

- `_AssetActionGrid` uses a `LayoutBuilder` to derive the action tile aspect
  ratio from the available width and shared `serviceTileMinHeight`; this keeps
  four asset actions in one Home-style row without a local magic height at
  360 px.
- `_StatPill` remains page-local because the asset detail hero needs compact
  asset-specific balance facts while still using `VitCard` and spacing tokens.

Action inventory result:

- Actions after redesign: deposit/withdraw/transfer/DCA via `VitServiceTile`,
  period selection via `VitTabBar`, and transaction row navigation via
  `VitCard.onTap`.
- No `showModalBottomSheet`, `showDialog`, `GestureDetector`, raw `InkWell`,
  snackbar, or local scaffold is present in the page bundle.
- Raw visual scan found no `SingleChildScrollView`, local `Container`,
  `BoxDecoration`, `BorderRadius.circular`, or local `EdgeInsets` in the
  target page bundle.

Financial safety result:

- Read-only asset detail behavior is preserved.
- Deposit, withdraw, transfer, and DCA routes remain sourced from
  `snapshot.actions`, preserving asset-specific route parameters.
- Transaction row route to `/wallet/transaction/:txId` is preserved and
  test-covered.
- Positive/negative change and transaction status use text/icon context, not
  color alone.
- No P2P Wallet routes, Prediction Markets, or Open Arena surfaces were
  touched.

First-viewport evidence:

- `SC-147 first viewport reaches asset actions and period controls` runs at
  `VitFirstViewport.minimumPhone` (`360x800`) and passes.
- The 360 px assertion verifies the route semantic label, the deposit asset
  action, and the active chart period control are visible above bottom nav.
- Transaction row navigation remains covered in
  `SC-147 period, action, and transaction navigation work`.

GitNexus evidence:

- `context(AssetDetailPage)`: incoming route handler and focused test imports
  only; no execution flows.
- `impact(AssetDetailPage, upstream)`: CRITICAL due router/test fan-out,
  direct callers 2, affected processes 0. User was warned before edits.
- `impact(_AssetDetailPageState, upstream)`: CRITICAL due state/router fan-out,
  direct 1, affected processes 0.
- `impact(_assetScrollBottomInset, _AssetHero, _AssetLogo, _StatPill,
  _AssetActionGrid, _ActionTile, _PriceChartCard, _AssetTransactions,
  _AssetTransactionRow)`: LOW or no upstream dependents for page-local symbols.
- `detect_changes(scope=unstaged)`: medium because the dirty worktree includes
  prior Wallet batches, changed_count 194, changed_files 45, affected_count 1,
  affected process `Build -> FindByFlow`. Scoped diff for this batch is 6 files,
  192 insertions, 231 deletions.

Headroom refs: impact=580cfd9a863e7cd39e06f28f, detect=ef35a04083a9c286aa51adfd.

Verification:

- `dart format lib/features/wallet/presentation/pages/asset_detail_page.dart lib/features/wallet/presentation/widgets/asset_detail_page_common.dart lib/features/wallet/presentation/widgets/asset_detail_page_sections.dart test/features/wallet/asset_detail_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/asset_detail_page_test.dart --reporter=compact`:
  initially failed because compact service-tile aspect ratio overflowed at
  360 px and first-viewport evidence still targeted the transaction row. Fixed
  with width-derived service-tile min-height and action/period viewport
  evidence. Rerun Pass, 4 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 92 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=1/759`.
- `dart run tool/visual_density_risk_audit.dart`: regenerated stale density
  artifacts after the tool requested regeneration; `P0_CRITICAL_DENSITY_REVIEW=0`
  and `P1_HIGH_DENSITY_REVIEW=0`.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Remaining blockers: none.

### 4.4 `PortfolioAnalyticsPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/portfolio_analytics_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_summary_switcher.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_overview_chart.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_metrics_assets.dart`
- `flutter_app/test/features/wallet/portfolio_analytics_page_test.dart`

Redesign target:

- Header -> portfolio analytics summary -> period controls -> chart -> metrics
  and asset rows.

Must fix:

- [x] Period and summary controls use shared tabs/chips.
- [x] Positive/negative changes include text/icon context.
- [x] Chart and metric cards are dense and tokenized.
- [x] 360 px layout avoids clipped labels.

Optimization:

- Keep primary performance insight in first viewport.
- Push secondary breakdowns below the chart.

Verification:

- [x] `flutter test test/features/wallet/portfolio_analytics_page_test.dart --reporter=compact`
- [x] 360 px period selector and summary performance insight check.

Status: Done.

### PortfolioAnalyticsPage Batch Evidence - 2026-06-24

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/portfolio_analytics_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_summary_switcher.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_overview_chart.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_metrics_assets.dart`
- `flutter_app/test/features/wallet/portfolio_analytics_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- Page already used `VitPageLayout` and `VitHeader`, but content still used a
  local `SingleChildScrollView`, raw bottom padding constants, custom segmented
  view controls, `VitChoicePill` period controls, `_VitCardSurface`, custom
  metric rows, and a width-pressured quick-stat row.
- The focused test used a manual 440x956 viewport setup rather than the shared
  `VitFirstViewport.minimumPhone` evidence helper.

Home pattern applied:

- Header -> portfolio value hero -> view tabs -> period selector -> chart ->
  performance metrics -> dense asset allocation rows.
- The summary hero keeps total value and total return in the first viewport;
  the period selector is actionable at 360x800 before deeper chart/asset
  content.

Shared primitives adopted:

- `VitInsetScrollView`, compact `VitPageContent`, `VitTabBar`,
  `VitSectionHeader`, `VitCard`, `VitInfoRow`, and `VitMetricDeltaPill`.
- Replaced the custom view switcher and `VitChoicePill` period row with
  `VitTabBar` segment variants.
- Replaced local metric rows with `VitInfoRow` and direct `VitCard` surfaces.
- Replaced color-only asset change text with `VitMetricDeltaPill` positive and
  negative tone/icon semantics.

L3 local reasons:

- `_PortfolioAreaPainter` and its `CustomPaint` chart remain local because the
  chart is page-specific portfolio history rendering, not a reusable Wallet
  primitive.
- The asset allocation progress bar remains local because it visualizes each
  asset's portfolio share using asset-specific color metadata; text percentage
  and delta pill remain present so color is not the only state indicator.
- `_AssetAvatar` remains local because it renders symbol initials from Wallet
  asset metadata inside a shared `VitCard` shell.

Action inventory result:

- Scoped census reviewed view tab `onChanged`, period tab `onChanged`,
  `VitTabBar`, `VitMetricDeltaPill`, `VitInfoRow`, `VitSectionHeader`,
  `CustomPaint`, and `LinearProgressIndicator`.
- No money-movement submit, preview, confirm, copy, revoke, scan, route, sheet,
  dialog, provider, or repository actions were added or changed.

Financial safety result:

- Portfolio analytics remains read-only/local navigation state.
- No withdrawal, transfer, address-add, token revoke, dust conversion, fee,
  limit, masking, route, provider, or repository logic changed.
- P2P Wallet routes remain excluded.

First-viewport evidence:

- `SC-142 first viewport reaches period selector controls` now runs at
  `VitFirstViewport.minimumPhone` (360x800), asserts the
  `SC-142 PortfolioAnalyticsPage` route semantic label is visible, and verifies
  the active `1M` period selector is actionable in the first viewport.
- Focused shell test still verifies the Wallet header, bottom nav, portfolio
  value, overview tab, metrics section, and asset section.

GitNexus evidence:

- `context(PortfolioAnalyticsPage)` found route construction in
  `wallet_routes.dart`, app router import, and focused test imports; no
  page-specific execution flows were attached.
- `impact(target: "PortfolioAnalyticsPage", direction: "upstream")` returned
  CRITICAL from route/router fan-out (`impactedCount=254`, direct callers 2,
  affected processes 0); user was warned before edits.
- `impact(target: "_PortfolioAnalyticsPageState", direction: "upstream")`
  returned CRITICAL from state/router fan-out (`direct=1`, affected processes
  0). Local widget impacts for summary, view switcher, period selector, chart,
  metrics, assets, placeholder, and card-surface helpers were LOW or
  no-dependent.
- `detect_changes(scope: all)` after the batch returned medium risk:
  `changed_count=210`, `changed_files=51`, `affected_count=1`,
  affected process `Build -> FindByFlow`. The broad count is from the dirty
  worktree containing prior Wallet batches; scoped current-batch stat is 8
  files, 188 insertions, 258 deletions, and no route/provider/repository scope
  expansion.

Headroom refs: detect=a6b27cf78afa73ba5158986a.

Verification:

- `dart format lib/features/wallet/presentation/pages/portfolio_analytics_page.dart lib/features/wallet/presentation/widgets/portfolio_analytics_common.dart lib/features/wallet/presentation/widgets/portfolio_analytics_summary_switcher.dart lib/features/wallet/presentation/widgets/portfolio_analytics_overview_chart.dart lib/features/wallet/presentation/widgets/portfolio_analytics_metrics_assets.dart test/features/wallet/portfolio_analytics_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/portfolio_analytics_page_test.dart --reporter=compact`:
  Pass, 4 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 92 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=1/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts after the check requested regeneration; `P0_CRITICAL_DENSITY_REVIEW=0`
  and `P1_HIGH_DENSITY_REVIEW=0`.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <current batch files>`: Pass; only Git line-ending
  warnings for touched files.

Review result:

- Current-batch diff review found no blocking issues. Remaining L3 local
  composition is limited to chart painting, allocation progress, and
  asset-initial avatars with shared surrounding surfaces.

Remaining blockers: none.

## Phase 5: Address And Safety Pages

### 5.1 `AddressBookPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/address_book_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_controls.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_security.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_list.dart`
- `flutter_app/test/features/wallet/address_book_page_test.dart`

Redesign target:

- Header -> security summary -> search/filter -> saved address dense list ->
  destructive delete confirmation.

Must fix:

- [x] Saved addresses remain masked.
- [x] Copy, favorite, edit, delete all have tooltip/semantics.
- [x] Delete dialog uses destructive CTA styling.
- [x] Add address route remains `/wallet/address-book/add`.
- [x] Empty state includes add action.

Optimization:

- Use dense address rows; avoid oversized cards for every address.
- Keep security notice above list but compact.

Verification:

- [x] `flutter test test/features/wallet/address_book_page_test.dart --reporter=compact`

Status: Done.

### AddressBookPage Batch Evidence - 2026-06-24

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/address_book_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_controls.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_security.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_list.dart`
- `flutter_app/test/features/wallet/address_book_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- The page already had a Wallet header, but the body used
  `SingleChildScrollView`, root-local color/spacing/padding constants, local
  section headers, custom empty state composition, full wallet address text in
  saved rows, and fixed-height address stat/safety cards.
- First-viewport evidence existed from the baseline, but it did not prove
  masking or delete-confirmation safety.

Home pattern applied:

- Header -> whitelist/security summary -> compact address stats -> search and
  network filter -> favorites and all-address dense rows -> security support
  card -> high-risk state reminder.
- Replaced the local scroll wrapper with `VitInsetScrollView` and compact
  `VitPageContent` so the 360x800 first viewport reaches the first saved
  address copy action.
- Tightened the stats and security surfaces after audit feedback; refreshed
  density moved `AddressBookPage` from P1 score 43 to P2 score 38 and the
  global P1 density count back to 0.

Shared primitives adopted:

- `VitPageLayout`, `VitHeader`, `VitAutoHideHeaderScaffold`,
  `VitInsetScrollView`, `VitPageContent`, `VitSectionHeader`, `VitCard`,
  `VitSearchBar`, `VitChoicePill`, `VitStatusPill`, `VitIconButton`,
  `VitEmptyState`, `VitCtaButton`, and `VitHighRiskStatePanel`.
- Removed local `_AddAddressButton` and `_SectionTitle` in favor of shared
  header action and section-header primitives.

L3 local reasons:

- `_ShieldBadge` remains local because it conveys saved-address whitelist state
  inside a Wallet-specific row.
- `_maskAddress` remains local to this page bundle because the masking format
  is only used by the Address Book list and destructive confirmation in this
  batch.
- `_RoundActionButton` remains local as a thin adapter over `VitIconButton` to
  preserve row-specific favorite/edit/delete keys and variants.

Action inventory result:

- Scoped action census found add route, whitelist toggle, search key, network
  filters, copy, favorite, edit, delete, destructive dialog cancel/delete, and
  the existing high-risk panel text.
- No `SingleChildScrollView`, raw `TextField`, local `BoxDecoration`,
  `BorderRadius.circular`, raw `EdgeInsetsDirectional`, or raw local empty
  state composition remains in the Address Book page bundle.

Financial safety result:

- Saved wallet addresses are masked by default in rows and in destructive
  confirmation copy (`bc1qxy...0wlh` in the focused test).
- Full wallet address text is no longer rendered in the saved-address list.
- Delete confirmation uses a destructive `VitCtaButton`, shows the masked
  address before deletion, and preserves the cancel action.
- Add route remains `/wallet/address-book/add`; copy/favorite/edit/delete keys
  and provider-backed fixture behavior are preserved.
- No P2P Wallet routes, providers, repositories, withdrawal preview flows, or
  money-movement fee/limit logic were changed.

First-viewport evidence:

- `SC-144 first viewport reaches first address copy action` now runs with
  `VitFirstViewport.minimumPhone` and asserts the route semantic plus first
  address copy action at 360x800.
- `SC-144 renders address book baseline in Wallet shell` proves the full
  stored BTC address is not rendered and the masked address is visible.
- `SC-144 delete confirmation removes a masked saved address` proves the
  destructive dialog shows the masked address and removes the saved row only
  after confirming.

GitNexus evidence:

- `context(AddressBookPage)` found wallet router construction, app router
  import, focused test coverage, and critical navigation test references; no
  execution flows were attached.
- `impact(AddressBookPage, direction: upstream)`: CRITICAL from route/router
  fan-out, `direct=2`, `processes_affected=0`; user was warned before edits.
- `impact(_AddressBookPageState, direction: upstream)`: CRITICAL from
  route/router fan-out, `direct=1`, `processes_affected=0`.
- Local widget/method impacts for `_SearchBox`, `_WhitelistModeCard`,
  `_NetworkFilterBar`, `_AddressCard`, `_AddressStats`, `_SecurityTip`,
  `_CopyButton`, `_EmptyAddressState`, `_copyAddress`, `_toggleFavorite`,
  `_confirmDelete`, `_filteredAddresses`, `_RoundActionButton`,
  `_ShieldBadge`, `_MiniTag`, and containing `_AddressStats` after the density
  tightening were LOW or direct page-only.
- `detect_changes(scope: all)` after the batch returned medium risk because
  the dirty worktree still contains prior completed Wallet batches:
  `changed_count=233`, `affected_count=1`, `changed_files=56`; affected
  process is `Build -> FindByFlow`.
- Scoped Address Book diff stat: 7 files changed, 288 insertions, 328
  deletions.

Headroom refs: detect=1c0903c2f6bfc3853f9aac64.

Verification:

- `dart format lib/features/wallet/presentation/pages/address_book_page.dart lib/features/wallet/presentation/widgets/wallet_address_book_controls.dart lib/features/wallet/presentation/widgets/wallet_address_book_security.dart lib/features/wallet/presentation/widgets/wallet_address_book_list.dart test/features/wallet/address_book_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/address_book_page_test.dart --reporter=compact`:
  initially failed because the masked address appeared both in the row and the
  delete dialog; the assertion was tightened to the dialog copy. Rerun Pass,
  5 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 93 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current;
  `p0_wallet_debt=1/759 pass`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact after the Address Book layout change.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current;
  `P0_CRITICAL_DENSITY_REVIEW=0`, `P1_HIGH_DENSITY_REVIEW=0`,
  `AddressBookPage` score 38 (`P2_MEDIUM_DENSITY_REVIEW`).
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <AddressBook batch files>`: Pass, with only existing
  LF/CRLF working-copy warnings.

Remaining blockers: none.

### 5.2 `AddressAddPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/address_add_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_selectors.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_form.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_agreement.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart`
- `flutter_app/test/features/wallet/address_add_page_test.dart`

Redesign target:

- Header -> asset/network selectors -> address/label form -> agreement/risk ->
  preview -> success.

Must fix:

- [x] Use `VitInput` for label/address fields.
- [x] Paste/scan actions have semantic labels and feedback.
- [x] Cannot save without required fields and agreement.
- [x] Preview shows asset, network, masked address, risk note, and next step.
- [x] Success returns to address book.

Optimization:

- Keep risk/agreement close to the CTA.
- Make preview sheet visually distinct from the input state.

Verification:

- [x] `flutter test test/features/wallet/address_add_page_test.dart --reporter=compact`

Status: Done.

### AddressAddPage Batch Evidence - 2026-06-24

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/address_add_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_form.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_selectors.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_agreement.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart`
- `flutter_app/test/features/wallet/address_add_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv`

Current Home-standard gap before edit:

- The page used `SingleChildScrollView`, custom page padding, a single large
  form card, local input wrappers around raw `TextField`, custom icon-card
  paste/scan actions, custom preview rows, custom sheet padding/title rhythm,
  custom whitelist switch composition, an unused local footer, and a custom
  success layout.
- The focused test did not include 360x800 first-viewport evidence or the
  confirm -> success -> address-book return contract.

Home pattern applied:

- Header -> network/asset setup -> address label/address/memo fields ->
  whitelist and risk agreement -> masked preview -> high-risk review -> save
  CTA -> shared confirmation sheet -> shared success state.
- Replaced the page scroll with `VitInsetScrollView` and compact
  `VitPageContent`.
- Moved selectors above text entry so the first viewport shows the setup
  context before data entry, matching the plan order.
- Preview and success states now use shared sheet/state/info-row rhythm instead
  of local centered/card-only composition.

Shared primitives adopted:

- `VitInsetScrollView`, `VitPageContent`, `VitSectionHeader`, `VitInput`,
  `VitIconButton`, `VitTogglePill`, `VitHighRiskStatePanel`,
  `VitSheetPanel`, `VitInfoRow`, `VitCard`, and `VitCtaButton`.
- Removed raw local `TextField`, local input card wrappers, local network-dot
  `BoxDecoration`, local sheet padding/title surface, and unused
  `AddressSaveFooter`.

L3 local reasons:

- `AddressFieldLabel` remains local because it renders required/optional
  address-form labels with the existing required-star semantics.
- `maskWalletAddress` remains local because the address-add preview format is
  specific to this high-risk save flow and focused tests assert it.
- `AddressIconCircleButton` remains as a thin adapter over `VitIconButton` to
  keep paste/scan semantics close to the `VitInput` suffix API.

Action inventory result:

- Scoped action census found network/asset selector taps, paste action, scan
  feedback action, whitelist toggle, agreement toggle, save CTA, confirm CTA,
  and the shared bottom-sheet preview.
- Scoped raw-visual scan found no `SingleChildScrollView`, raw `TextField`,
  `BoxDecoration`, `BorderRadius.circular`, raw local sheet surface, or unused
  footer in the active Address Add bundle.

Financial safety result:

- Save remains disabled until label, address, and agreement are present.
- Preview/confirm flow is preserved before saving.
- Confirmation sheet shows label, network, asset, masked address, memo when
  present, whitelist state, and audit/risk note before the confirm action.
- Paste and scan actions keep semantic labels; scan still gives visible
  snackbar feedback.
- Success state returns to `/wallet/address-book`, now covered by focused
  test.
- No Wallet providers, repositories, route paths, fee/limit logic, withdrawal
  flows, or P2P Wallet routes were changed.

First-viewport evidence:

- `SC-143 first viewport reaches required address setup` runs with
  `VitFirstViewport.minimumPhone` and asserts the route semantic, default
  network selector, default asset selector, and label field in the usable
  first viewport at 360x800.
- `SC-143 confirmation saves then returns to address book` asserts the masked
  preview address (`TQnKxxx4d8eRh9Kf...Np7Yz123`), success state, and final
  `AddressBookPage` route after confirm.

GitNexus evidence:

- `context(AddressAddPage)` found wallet router construction, app router
  import, focused test coverage, address-book test import, and high-risk text
  entry harness import; no execution flows were attached to the page class.
- `impact(AddressAddPage, direction: upstream)`: CRITICAL from route/router
  fan-out, `direct=2`, `processes_affected=0`; user was warned before edits.
- `impact(_AddressAddPageState, direction: upstream)`: CRITICAL from
  route/router fan-out, `direct=1`, `processes_affected=0`.
- Helper impacts for `AddressAddForm`, `AddressNetworkGrid`,
  `AddressAssetSelector`, `AddressWhitelistCard`, `AddressWarningCard`,
  `AddressAgreementRow`, `AddressConfirmPreviewSheet`, `AddressPreviewPanel`,
  and `AddressSavedState` were LOW local/direct. `AddressTextInput`,
  `AddressWalletInput`, `AddressIconCircleButton`, and
  `AddressPrimaryActionButton` were MEDIUM because they are imported by the
  tightly coupled Address Add widget bundle, with no affected execution flows.
- `detect_changes(scope: all)` after the batch returned medium risk because
  the dirty worktree still contains prior completed Wallet batches:
  `changed_count=249`, `affected_count=1`, `changed_files=64`; affected
  process is `Build -> FindByFlow`.
- Scoped Address Add diff stat: 11 files changed, 420 insertions, 580
  deletions.

Headroom refs: detect=f8efe14c74f88843b2505d46.

Verification:

- `dart format lib/features/wallet/presentation/pages/address_add_page.dart lib/features/wallet/presentation/widgets/wallet_address_add_common.dart lib/features/wallet/presentation/widgets/wallet_address_add_form.dart lib/features/wallet/presentation/widgets/wallet_address_add_selectors.dart lib/features/wallet/presentation/widgets/wallet_address_add_agreement.dart lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart test/features/wallet/address_add_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/address_add_page_test.dart --reporter=compact`:
  initially failed only for new helper API mismatch and an over-broad masked
  preview matcher; fixed and reran Pass, 5 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 95 tests.
- `flutter analyze`: Pass.
- `dart run tool/design_token_consistency_audit.dart`: Regenerated stale
  current Wallet/UI artifact; `p0_wallet_debt=0/759 pass`.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale current
  Wallet/UI artifact; P0 and P1 density review counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `dart run tool/route_coverage_audit.dart --check`: Pass/current.
- `dart run tool/navigation_edge_audit.dart`: Regenerated stale navigation
  edge artifact after adding confirm-return evidence.
- `dart run tool/navigation_edge_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <AddressAdd batch files>`: Pass, with only existing
  LF/CRLF working-copy warnings.

Remaining blockers: none.

### 5.3 `PendingDepositsPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/pending_deposits_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/pending_deposits_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/pending_deposits_page_sections.dart`
- `flutter_app/test/features/wallet/pending_deposits_page_test.dart`

Redesign target:

- Header -> status summary -> refresh/filter tabs -> pending deposit dense rows
  -> empty state.

Must fix:

- [x] Pending status cannot look completed.
- [x] Confirmation count/status is readable.
- [x] Copy actions are accessible.
- [x] Refresh has visible feedback.

Optimization:

- Make required confirmations and elapsed time the row focus.
- Use status pill text plus icon.

Verification:

- [x] `flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact`

### PendingDepositsPage Batch Evidence - 2026-06-24

Status: Done 2026-06-24.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/pending_deposits_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/pending_deposits_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/pending_deposits_page_sections.dart`
- `flutter_app/test/features/wallet/pending_deposits_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Home pattern applied:

- Header -> high-risk status context -> pending summary -> refresh/filter
  controls -> dense deposit rows -> support/limits notice.
- Replaced the raw scroll/padding shell with `VitInsetScrollView` plus compact
  `VitPageContent`.
- Pending deposit detail rows now lead with required confirmations, submitted
  time, ETA, network, masked source address, and TxHash.

Shared primitives adopted:

- `VitHeader`, `VitPageLayout`, `VitInsetScrollView`, `VitPageContent`,
  `VitHighRiskStatePanel`, `VitCard`, `VitIconButton`, `VitStatusPill`,
  `VitInfoRow`, and `VitEmptyState`.
- Pending/processing/credited/failed statuses use status-pill text plus icon
  and status enum, not color alone.
- Copy, refresh, and filter controls have explicit `Semantics` labels.

L3 local reasons:

- `_SummaryBanner`, `_FilterChips`, `_DepositCard`, and
  `_ConfirmationProgress` remain route-local because they compose
  `WalletPendingDeposit`-specific confirmation progress, counts, filters, and
  copy state while using shared primitives for surfaces and controls.
- `_pendingGap`, `_pendingTinyGap`, and `_pendingInlineGap` are local aliases
  to `AppSpacing` tokens only; no raw local spacing, color palette, radius, or
  `BoxDecoration` remains in the Pending page bundle.

Action inventory result:

- `rg` action census found refresh (`VitIconButton`), filter pills
  (`VitStatusPill`), copy pills (`VitStatusPill` + `Clipboard.setData`), and
  `Semantics` wrappers.
- No `showDialog`, `showModalBottomSheet`, `GestureDetector`, `scan`,
  `revoke`, submit, or preview actions exist on this status-only page.

Financial safety result:

- No withdrawal, approval, revoke, address-add, or escrow action was introduced.
- Risk copy remains visible through `VitHighRiskStatePanel`; fee/minimum
  deposit/support copy remains in the information notice.
- Source addresses and TxHash values remain masked/abbreviated as provided by
  the Wallet repository fixtures. P2P Wallet routes remain excluded.

First-viewport evidence:

- `test/features/wallet/pending_deposits_page_test.dart` now uses
  `VitFirstViewport.minimumPhone` (360x800) for the first-viewport assertion.
- `SC-152 first viewport reaches first pending deposit` verifies the route
  semantic label and first deposit card are visible above bottom nav.
- Focused test also verifies readable confirmation label (`1/2 yêu cầu`),
  required-confirmation detail row, accessible copy semantics, and visible
  refresh feedback in the summary.

GitNexus evidence:

- `context(PendingDepositsPage)`: incoming wallet route construction and
  focused test imports; no execution-flow participation.
- `impact(PendingDepositsPage)`: CRITICAL route fan-out, direct callers 2,
  affected processes 0; risk warned before editing.
- `impact(_PendingDepositsPageState)`: CRITICAL route fan-out, direct callers
  1, affected processes 0.
- Internal Pending helper classes/functions: LOW risk, no affected processes.
- `impact(pumpPendingDeposits)` for the focused test helper returned
  `Target not found`, risk UNKNOWN; test edit was kept scoped to the focused
  Pending test.
- `detect_changes(scope=all)`: medium risk due existing dirty worktree from
  previous Wallet batches; `changed_count=284`, `changed_files=68`,
  `affected_count=1`, affected process `Build -> FindByFlow`.
- Scoped diff stat for this batch: 6 files changed, 310 insertions, 270
  deletions.
- Headroom refs: detect=`86ebfd5757e851b1beb25c39`.

Verification:

- `dart format lib/features/wallet/presentation/pages/pending_deposits_page.dart lib/features/wallet/presentation/widgets/pending_deposits_page_common.dart lib/features/wallet/presentation/widgets/pending_deposits_page_sections.dart test/features/wallet/pending_deposits_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact`:
  Pass, 5/5 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 96/96 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for this Wallet UI batch.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current,
  `P0_CRITICAL_DENSITY_REVIEW=0`, `P1_HIGH_DENSITY_REVIEW=0`.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <PendingDeposits batch files>`: Pass, with only LF/CRLF
  working-copy warnings.

Remaining blockers: none.

### 5.4 `WithdrawLimitsPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/withdraw_limits_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_sections.dart`
- `flutter_app/test/features/wallet/withdraw_limits_page_test.dart`

Redesign target:

- Header -> current limit summary -> usage bars -> KYC tier ladder -> FAQ.

Must fix:

- [x] KYC route remains clear and does not imply upgrade is complete.
- [x] Used daily/monthly limits remain visible.
- [x] Locked/current/available tiers are distinguishable beyond color.
- [x] FAQ rows are either expandable or clearly static.

Optimization:

- Keep current tier and usage in the first viewport.
- Use tabular money and concise limit labels.

Verification:

- [x] `flutter test test/features/wallet/withdraw_limits_page_test.dart --reporter=compact`

### WithdrawLimitsPage Batch Evidence - 2026-06-24

Status: Done.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/withdraw_limits_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_sections.dart`
- `flutter_app/test/features/wallet/withdraw_limits_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- Page already had Wallet route chrome, but content still used local scroll
  setup, local padding/color aliases, local progress/status treatment, and a
  snackbar-style KYC interaction that could imply completion instead of route
  navigation.
- Current tier, usage, warning, KYC ladder, and FAQ were present but did not
  fully use shared Home-density primitives or non-color-only tier status.

Home pattern applied:

- `VitHeader` -> current limit summary -> daily/monthly usage bars -> quick
  limits -> safety warning -> KYC tier ladder -> static FAQ -> high-risk
  support panel.
- The current tier card and usage bar are prioritized in the first viewport;
  lower-priority ladder/FAQ content follows in dense sections.

Shared primitives adopted:

- Replaced the ad hoc scroll/content shell with `VitInsetScrollView` and
  `VitPageContent(padding: VitContentPadding.compact, density:
  VitDensity.compact)`.
- Used `VitSectionHeader`, `VitCard` compact density, `VitStatusPill`,
  `VitInfoRow`-style row rhythm where applicable, and `VitHighRiskStatePanel`.
- Removed legacy local visual constants for background, borders, raw colors,
  scroll top padding, card padding, and fixed card heights.

L3 local reasons:

- `_CurrentTierCard`, `_LimitProgress`, `_QuickStats`, `_LimitWarning`,
  `_KycTierCard`, and `_FaqCard` remain local because they bind the Wallet
  limit model, KYC tier semantics, and focused test keys while composing shared
  primitives internally.
- `_LimitProgress` keeps a local progress-bar structure because there is no
  shared Wallet progress primitive that exposes both used/limit values and the
  percentage pill in the required compact layout.
- `_KycTierCard` keeps tokenized `BoxConstraints` to stabilize tier touch
  targets at 360 px; dimensions use `AppSpacing` tokens.

Action inventory result:

- Scoped action census after cleanup found one interactive action:
  `_KycTierCard.onTap` routes locked tiers to `AppRoutePaths.profileKyc`.
- No dialog, bottom sheet, confirm, preview, revoke, copy, scan, refresh, or
  submit actions are introduced on this route.

Financial safety result:

- Daily and monthly used/limit values remain visible in the current tier card.
- Locked, current, and available tiers are distinguished by text, icon, status
  pill, and semantics, not color alone.
- Locked KYC tiers now show `Xác minh KYC` and route to KYC without a success
  snackbar, so the UI does not imply the upgrade is complete.
- FAQ is explicitly labeled as static (`FAQ tĩnh`).
- No withdrawal transaction, provider, repository, fee, limit, masking, route,
  or P2P Wallet behavior changed.

First-viewport evidence:

- Updated `SC-153 first viewport reaches current tier usage` to run at
  `VitFirstViewport.minimumPhone` (360x800).
- Focused test verifies route semantics, `WithdrawLimitsPage.currentTierKey`,
  and `WithdrawLimitsPage.dailyUsageKey` are visible in the first viewport;
  monthly usage remains in the same current-tier section and is covered by the
  baseline render assertions.

GitNexus evidence:

- `context(name: "WithdrawLimitsPage", kind: "Class")`: direct wallet route
  construction, app router/test imports, no execution flows.
- `impact(target: "WithdrawLimitsPage", direction: "upstream")`: CRITICAL
  from route-root fan-out, direct callers 2, affected processes 0; user was
  warned before edits.
- Widget impacts for `_CurrentTierCard`, `_LimitProgress`, `_QuickStats`,
  `_KycTierCard`, `_LimitWarning`, `_FaqCard`, and `_formatUsd` were LOW or
  local-only. Test helper `pumpWithdrawLimits` did not resolve in the graph and
  was treated as UNKNOWN before modification.
- `detect_changes(scope: all)`: medium because the dirty worktree includes
  prior Wallet batches; summary `changed_count=303`, `changed_files=72`,
  `affected_count=1`, affected process `Build -> FindByFlow`.
- Scoped diff for this batch is limited to `WithdrawLimitsPage` files, focused
  test, the plan, and regenerated visual-density artifacts.

Headroom refs: detect=c3e4eb040a7ef6110cebd16b.

Verification:

- `dart format lib/features/wallet/presentation/pages/withdraw_limits_page.dart lib/features/wallet/presentation/widgets/withdraw_limits_page_common.dart lib/features/wallet/presentation/widgets/withdraw_limits_page_sections.dart test/features/wallet/withdraw_limits_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/withdraw_limits_page_test.dart --reporter=compact`:
  Pass, 4/4 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 96/96 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for this Wallet UI batch; P0 and P1 density review counts remain
  0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <WithdrawLimits batch files>`: Pass, with only LF/CRLF
  working-copy warnings.

Remaining blockers: none.

### 5.5 `WalletTokenApprovalPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_token_approval_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_tabs.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_active_approvals_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_history_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_settings_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_cards.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart`
- `flutter_app/test/features/wallet/wallet_token_approval_page_test.dart`

Redesign target:

- Header -> risk summary -> tabs -> approval rows -> revoke preview -> settings.

Must fix:

- [x] Active/history/settings tabs use `VitTabBar`.
- [x] Risk levels are text/icon/pill based, not color only.
- [x] Unlimited approvals are visually urgent.
- [x] Revoke all and individual revoke remain preview plus confirm.
- [x] Settings toggles are accessible.

Optimization:

- Prefer dense approval rows over bulky cards.
- Keep highest risk approvals above less urgent history/settings content.

Verification:

- [x] `flutter test test/features/wallet/wallet_token_approval_page_test.dart --reporter=compact`

### WalletTokenApprovalPage Batch Evidence - 2026-06-24

Status: Done.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_token_approval_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_active_approvals_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_cards.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_badges.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_history_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_settings_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart`
- `flutter_app/test/features/wallet/wallet_token_approval_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- The route already used Wallet chrome and `VitTabBar`, but the page still put
  tabs above risk context, used `SingleChildScrollView`, wrapped tab content in
  one large surface card, and encoded risk/unlimited state mostly through local
  colors.
- Revoke preview preserved the required data, but it rendered as one long text
  block instead of dense review rows with shared sheet rhythm.
- Scan-risk snackbar copy was mojibake.

Home pattern applied:

- `VitHeader` -> compact token approval risk summary -> high-risk review panel
  -> `VitTabBar` -> critical alert -> dense active approval rows -> revoke
  actions and safety notice.
- History and settings stay behind the same tabs but use compact shared
  surfaces so active risk remains the primary first-screen task.

Shared primitives adopted:

- Replaced the route scroll shell with `VitInsetScrollView` and
  `VitPageContent(padding: VitContentPadding.compact, density:
  VitDensity.compact)`.
- Replaced the oversized tab-content wrapper with direct dense sections.
- Replaced risk accent labels with `VitStatusPill` using text, icon, and status.
- Replaced the individual revoke icon card with `VitIconButton`.
- Replaced the revoke preview sheet body with `VitSheetPanel`,
  `VitHighRiskStatePanel`, `VitCard`, `VitInfoRow`, and shared CTA buttons.
- Settings/history cards now use compact `VitCard` density.

L3 local reasons:

- Token approval summary, active approval rows, history rows, settings rows,
  and revoke preview parsing remain local because they bind token-approval
  domain fields, route keys, and preview copy while composing shared
  primitives internally.
- `_TokenPreviewRow.fromLine` is local because the current controller exposes a
  structured newline preview string; parsing keeps this UI batch scoped without
  changing controller/domain contracts.
- Existing tokenized fixed sizes for tab height, icon boxes, and sheet buttons
  remain because they are Wallet token-approval touch-target constraints backed
  by `AppSpacing` tokens.

Action inventory result:

- Preserved active/history/settings tab switches, individual revoke, revoke all
  high-risk approvals, scan-risk settings action, and revoke sheet
  cancel/confirm.
- Scoped anti-pattern scan found no `SingleChildScrollView`, `BoxDecoration`,
  `BorderRadius.circular`, raw `EdgeInsets`, `RoundedRectangleBorder`,
  `VitAccentPill`, raw `AppSpacing.cardPadding` surface, or
  `showModalBottomSheet` in the token approval page bundle.

Financial safety result:

- Individual and bulk revoke still require preview plus confirm; no direct
  revoke is introduced.
- Preview shows spender, token, allowance, gas estimate/network fee note, and
  impact before confirmation.
- Unlimited approvals render as urgent error status pills with icon/text, and
  unused unlimited approval keeps its warning copy.
- Risk is visible through label, icon, status pill, semantics, and border, not
  color alone.
- Masked spender address remains visible; controller, repository, endpoint,
  action draft, route, and P2P Wallet scope are unchanged.

First-viewport evidence:

- Updated `SC-150 first viewport reaches approval controls` to run at
  `VitFirstViewport.minimumPhone` (360x800).
- Focused test verifies route semantics, active tab action, and the critical
  approval row are visible/actionable in the first viewport.

GitNexus evidence:

- `context(name: "WalletTokenApprovalPage", kind: "Class")`: direct wallet
  route construction, app router/test imports, no execution flows.
- `impact(target: "WalletTokenApprovalPage", direction: "upstream")`,
  `_WalletTokenApprovalPageState`, `WalletTokenApprovalTabs`, and
  `WalletTokenRevokeSheet`: CRITICAL from route/import fan-out, affected
  processes 0; user was warned before edits.
- Widget impacts for active/history/settings/summary/notice/sheet classes were
  mostly CRITICAL due the same route import chain with `processes_affected=0`;
  leaf `WalletTokenApprovalCard`, `WalletTokenRiskBadge`, and
  `WalletTokenApprovalAmount` were LOW. Test helper `pumpTokenApprovals` did
  not resolve and was treated as UNKNOWN before modification.
- Method impacts for `_contentForTab` and `_showRevokeSheet` were LOW;
  `_showScanRiskNotice` did not resolve and was treated as UNKNOWN before
  modification.
- `detect_changes(scope: all)`: medium because the dirty worktree includes
  prior Wallet batches; summary `changed_count=329`, `changed_files=81`,
  `affected_count=1`, affected process `Build -> FindByFlow`.
- Scoped diff for this batch is limited to token approval page/widgets,
  focused test, the plan, and regenerated visual-density artifacts.

Headroom refs: detect=7b1c56cd86f0ffe11fb625d3.

Verification:

- `dart format lib/features/wallet/presentation/pages/wallet_token_approval_page.dart lib/features/wallet/presentation/widgets/wallet_token_approval_common.dart lib/features/wallet/presentation/widgets/wallet_token_approval_tabs.dart lib/features/wallet/presentation/widgets/wallet_token_active_approvals_tab.dart lib/features/wallet/presentation/widgets/wallet_token_approval_history_tab.dart lib/features/wallet/presentation/widgets/wallet_token_approval_settings_tab.dart lib/features/wallet/presentation/widgets/wallet_token_approval_cards.dart lib/features/wallet/presentation/widgets/wallet_token_approval_badges.dart lib/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart test/features/wallet/wallet_token_approval_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/wallet_token_approval_page_test.dart --reporter=compact`:
  initially failed only because the updated sheet produced two valid
  `Unknown Contract` text matches; assertion was tightened to the exact sheet
  detail value and rerun Pass, 4/4 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 96/96 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for this Wallet UI batch; P0 and P1 density review counts remain
  0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <WalletTokenApproval batch files>`: Pass, with only
  LF/CRLF working-copy warnings.

Remaining blockers: none.

## Phase 6: Wallet Tool Pages

### 6.1 `DustConverterPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/dust_converter_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_hero.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_targets.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_assets.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_confirm.dart`
- `flutter_app/test/features/wallet/dust_converter_page_test.dart`

Redesign target:

- Header -> conversion summary -> target selector -> selectable dust list ->
  fee/receive preview -> confirm.

Must fix:

- [x] Fee and receive amount visible before confirmation.
- [x] Disabled state explains why conversion cannot continue.
- [x] Selected assets are distinguishable beyond color.
- [x] Confirmation cancel/submit are clearly separated.

Optimization:

- Use dense selectable rows; reserve hero emphasis for the total receive amount.

Verification:

- [x] `flutter test test/features/wallet/dust_converter_page_test.dart --reporter=compact`

### DustConverterPage Batch Evidence - 2026-06-24

Status: Done 2026-06-24.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/dust_converter_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_hero.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_targets.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_assets.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_confirm.dart`
- `flutter_app/test/features/wallet/dust_converter_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- The route had a Wallet header, risk copy, and conversion behavior, but the
  content still used a local `SingleChildScrollView`, raw bottom-clearance and
  sheet spacing constants, custom sheet shape/safe-area composition, local
  panel styling, and selected states that leaned too much on color.
- The focused first-viewport helper used a wider manual viewport and did not
  prove 360 px action reach. The confirm preview test proved the submit action
  but not the cancel/submit separation.

Home pattern applied:

- Header -> conversion receive hero -> target selector -> selectable dust rows
  -> fee/receive preview footer -> compact high-risk confirmation sheet ->
  success banner.
- The conversion CTA stays in the scroll content after the dust asset list
  while preserving `DustConverterPage.ctaKey`; the earlier sticky footer was
  removed after emulator review showed it could read as a stuck overlay above
  Wallet chrome.
- The confirmation sheet now separates cancel and destructive confirm actions
  and keeps fee, selected total, receive amount, and target asset visible before
  submission.

Shared primitives adopted:

- `VitPageLayout`, `VitHeader`, `VitInsetScrollView`, compact
  `VitPageContent`, compact `VitCard`, `VitStatusPill`,
  `VitHighRiskStatePanel`, `VitSheetPanel`, `showVitBottomSheet`,
  `VitInfoRow`, and `VitCtaButton`.
- Target, select-all, and asset rows use semantic selected/button state plus
  text/icon confirmation, so selection is not communicated by color alone.
- Preview detail rows in the sheet use `VitInfoRow` rather than local divider
  rows.

L3 local reasons:

- `_DustHero`, `_TargetSelector`, `_DustAssetList`, `_ConvertFooter`,
  `_PrimaryButton`, `_TokenLogo`, `_ConvertedBanner`, `_formatUsd`,
  `_formatAmount`, and `_sumUsd` remain route-local because they compose
  dust-conversion-specific totals, token logos, target asset metadata, and
  footer state while using shared surfaces and CTA primitives.
- `_dustGap`, `_dustTinyGap`, `_dustInlineGap`, `_dustHeroIconBox`,
  `_dustTokenLogo`, and `_dustFooterTopPad` remain as token aliases for the
  compact dust row/logo rhythm. No raw local radius, color palette, sheet
  shape, or scroll padding remains in the Dust Converter page bundle.

Action inventory result:

- Scoped action census found target selection, select-all, asset selection,
  disabled/enabled footer CTA, `showVitBottomSheet`, confirm-sheet cancel, and
  confirm submit actions.
- No copy, scan, refresh, route, revoke, provider, or repository actions were
  added or changed.

Financial safety result:

- Fee and receive amount are visible before confirmation in the footer and in
  the confirmation sheet.
- Disabled CTA copy explains that at least one dust balance must be selected.
- Confirmation shows selected asset count, selected value, network fee,
  receive amount, target asset, and risk copy before the destructive action.
- Cancel and confirm actions are separate keys, and success clears selection.
- No Wallet routes, providers, repositories, P2P Wallet flows, address masking,
  withdrawal limits, or token-revoke flows were changed.

First-viewport evidence:

- `SC-154 first viewport reaches first dust asset row` now runs with
  `VitFirstViewport.minimumPhone` (360x800), asserts the
  `SC-154 DustConverterPage` route semantic, verifies the first dust asset row
  is visible/actionable, and keeps the fee/receive footer reachable above the
  bottom nav.
- `SC-154 shows confirmation preview before converting dust` verifies both
  `DustConverterPage.confirmCancelKey` and `DustConverterPage.confirmButtonKey`
  are present in the preview sheet before the conversion completes.

GitNexus evidence:

- `context(DustConverterPage)` found wallet route construction, app router
  import, focused test imports, and no page-specific execution flows.
- `impact(target: "DustConverterPage", direction: "upstream")` and
  `impact(target: "_DustConverterPageState", direction: "upstream")` returned
  CRITICAL from router/import fan-out with affected processes 0; user was
  warned before edits.
- Method impacts for `_showConfirmSheet`, `_toggleAsset`, and the Dust page
  `build` method were LOW. Local widget/format helper impacts for hero,
  target, asset, footer, preview, banner, and formatting symbols were LOW or
  no-dependent.
- `detect_changes(scope: all)` after the batch returned medium risk because
  the dirty worktree still contains prior completed Wallet batches:
  `changed_count=356`, `affected_count=1`, `changed_files=87`; affected
  process is `Build -> FindByFlow`.
- Scoped Dust Converter diff/status was limited to the Dust page bundle,
  focused test, this plan, and regenerated visual-density artifacts.

Headroom refs: detect=fc367fe1cc64d5938e582d3c.

Verification:

- `dart format lib/features/wallet/presentation/pages/dust_converter_page.dart lib/features/wallet/presentation/widgets/wallet_dust_converter_hero.dart lib/features/wallet/presentation/widgets/wallet_dust_converter_targets.dart lib/features/wallet/presentation/widgets/wallet_dust_converter_assets.dart lib/features/wallet/presentation/widgets/wallet_dust_converter_confirm.dart test/features/wallet/dust_converter_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/dust_converter_page_test.dart --reporter=compact`:
  initially exposed a stale color alias compile error and a 360 px footer/nav
  hit-test issue; fixed and rerun Pass, 4/4 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 96/96 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for this Wallet UI batch; P0 and P1 density review counts remain
  0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <DustConverter batch files>`: Pass, with only LF/CRLF
  working-copy warnings.

### DustConverterPage Sticky CTA Follow-Up - 2026-06-27

Status: Done 2026-06-27.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/dust_converter_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_dust_converter_confirm.dart`
- `flutter_app/test/features/wallet/dust_converter_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- Real emulator review showed the conversion CTA as a fixed bottom footer with
  `AppColors.modalScrimStrong` behind it. That preserved the action but made the
  button read like a sticker attached to the viewport rather than a normal
  Wallet action inside the Home content rhythm.

Home pattern applied:

- Header -> conversion receive hero -> target selector -> selectable dust rows
  -> inline conversion CTA -> compact high-risk confirmation sheet -> success
  banner.
- The CTA now scrolls with the dust list, keeping the bottom navigation/FAB area
  visually clean at 360 px and on the Android emulator.

Shared primitives adopted:

- Preserved `VitPageLayout`, `VitHeader`, `VitInsetScrollView`, compact
  `VitPageContent`, compact `VitCard`, `VitHighRiskStatePanel`,
  `VitSheetPanel`, `showVitBottomSheet`, `VitInfoRow`, and `VitCtaButton`.
- Removed the local footer scrim wrapper; `_ConvertFooter` now delegates surface
  and CTA styling to the existing shared CTA primitive.

L3 local reasons:

- `_ConvertFooter` remains route-local because its enabled/disabled copy,
  selected count, target symbol, and bottom clearance are specific to the dust
  conversion flow. No new local radius, palette, sheet, input, or action-grid
  primitive was introduced.

Action inventory result:

- Scoped action inventory remains target selection, select-all, asset
  selection, enabled/disabled conversion CTA, `showVitBottomSheet`,
  confirm-sheet cancel, and confirm submit.
- No copy, scan, refresh, route, revoke, provider, repository, or navigation
  action changed.

Financial safety result:

- Preview/confirm is preserved. The confirmation sheet still shows selected
  asset count, selected value, network fee, receive amount, target asset, risk
  copy, and separate cancel/confirm actions before conversion.
- Disabled CTA copy still explains that at least one dust balance must be
  selected.

First-viewport evidence:

- `SC-154 first viewport reaches first dust asset row` continues to run at
  `VitFirstViewport.minimumPhone` (360x800), proving the first actionable dust
  row is visible without the fixed footer consuming the bottom viewport.
- The confirm-preview test now scrolls to `DustConverterPage.ctaKey` before
  tapping, matching the new inline CTA behavior.
- Android emulator follow-up: built and installed the debug APK on
  `emulator-5554`, then captured
  `flutter_app/tmp/vittrade_dust_converter_no_sticky.png` showing the selected
  first viewport without a sticky conversion footer, and
  `flutter_app/tmp/vittrade_dust_converter_inline_cta.png` showing the CTA as
  inline scroll content after the final dust row.

GitNexus evidence:

- `context(_DustConverterPageState)` found wallet route/test imports and no
  page-specific execution flows.
- `impact(target: "_DustConverterPageState", direction: "upstream")` returned
  CRITICAL from route/test fan-out with affected processes 0; user was warned
  before the scoped layout edit.
- `context(_ConvertFooter)` and
  `impact(target: "_ConvertFooter", direction: "upstream")` returned LOW/no
  upstream dependents.
- Focused test `main` impact for
  `test/features/wallet/dust_converter_page_test.dart` returned LOW/no upstream
  dependents.
- `detect_changes(scope: all)` returned medium risk because the dirty worktree
  still contains prior unstaged Wallet redesign/documentation batches:
  `changed_count=463`, `affected_count=1`, `changed_files=118`; affected
  process is `Build -> FindByFlow`.
- Scoped current-batch diff/status is limited to Dust Converter page/footer,
  focused test, and regenerated visual-density artifacts.

Headroom refs: detect=1689ba29677e4648f2405faf.

Verification:

- `dart format lib/features/wallet/presentation/pages/dust_converter_page.dart lib/features/wallet/presentation/widgets/wallet_dust_converter_confirm.dart test/features/wallet/dust_converter_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/dust_converter_page_test.dart --reporter=compact`:
  Pass, 4/4 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 100/100 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for the current Wallet UI follow-up; P0 and P1 density review
  counts remain 0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`:
  Pass.

Review result:

- Current-batch diff review found no blocking issues. Remaining local
  composition is dust-specific row/target/footer composition wrapped by shared
  Wallet primitives and tokenized spacing.

Remaining blockers: none.

### 6.2 `NetworkStatusPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/network_status_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/network_status_summary.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/network_status_cards_stats.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/network_status_legend_common.dart`
- `flutter_app/test/features/wallet/network_status_page_test.dart`

Redesign target:

- Header -> network health summary -> filter/refresh -> dense network cards ->
  legend.

Must fix:

- [x] Congestion, latency, fees, and confirmations are readable.
- [x] Network status is not color-only.
- [x] Refresh action has tooltip/semantic label and visible feedback.
- [x] Legend is compact and does not dominate first viewport.

Optimization:

- Put the worst network/most actionable status first if data supports it.
- Use status pills and tabular fee/latency values.

Verification:

- [x] `flutter test test/features/wallet/network_status_page_test.dart --reporter=compact`

### NetworkStatusPage Batch Evidence - 2026-06-24

Status: Done 2026-06-24.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/network_status_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/network_status_summary.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/network_status_cards_stats.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/network_status_legend_common.dart`
- `flutter_app/test/features/wallet/network_status_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

Current Home-standard gap before edit:

- The page already had a Wallet header and network risk context, but it used a
  local `SingleChildScrollView`, raw scroll/bottom-clearance constants, raw
  local spacing/sizing constants, a non-functional refresh snackbar in a shell
  without a descendant `Scaffold`, no real filter state, and data order that
  left the maintenance network last.
- Status and congestion were partly color-led, the legend used a larger custom
  icon grid, and first-viewport evidence used a wider manual viewport helper.

Home pattern applied:

- Header -> compact network availability risk context -> network health
  summary with refresh feedback -> status filter tabs -> worst-first network
  card list -> compact status legend -> data disclaimer.
- Networks now sort by actionable status first (`down`, then congested,
  degraded, then operational) and use congestion as a secondary sort.
- The read-only refresh action invalidates the provider and shows persistent
  in-card feedback instead of relying on a snackbar.

Shared primitives adopted:

- `VitPageLayout`, `VitHeader`, `VitAutoHideHeaderScaffold`,
  `VitInsetScrollView`, compact `VitPageContent`, `VitHighRiskStatePanel`,
  `VitTabBar`, `VitSectionHeader`, `VitCard`, `VitIconButton`,
  `VitStatusPill`, and `VitEmptyState`.
- Health state, availability, and legend entries use shared status pills with
  icon plus text. Congestion adds a text severity label next to the percentage.

L3 local reasons:

- `_SummaryCard`, `_NetworkFilterTabs`, `_NetworkCard`, `_StatsGrid`,
  `_CongestionBar`, `_AvailabilityChip`, `_NetworkNote`, `_LegendCard`,
  `_TokenLogo`, and network status helper functions remain route-local because
  they compose Wallet network-health metadata, status ordering, congestion
  labels, and read-only refresh/filter behavior.
- `_networkInlineGap`, `_networkTinyGap`, `_networkCardGap`, and size aliases
  remain as `AppSpacing` token aliases only. The congestion progress bar
  remains local because it visualizes `WalletNetworkInfo.congestionPct` with a
  text severity label and semantic description.

Action inventory result:

- Scoped action census found only refresh (`VitIconButton`), filter tabs
  (`VitTabBar` via `filterKey`), status text, and local helper references.
- No copy, scan, revoke, submit, preview, confirm, dialog, bottom sheet, route,
  provider contract, or repository actions were added or changed.

Financial safety result:

- Network status remains read-only advisory information.
- Fee, latency/confirmation, congestion, pending transaction count, deposit
  availability, and withdrawal availability stay visible in each network card.
- The risk reminder still tells users to review network availability before
  deposit or withdrawal actions.
- No withdrawal preview/confirm, address-add, token-revoke, dust-conversion,
  masking, route, provider, repository, or P2P Wallet behavior changed.

First-viewport evidence:

- `SC-155 first viewport reaches first network card` now runs with
  `VitFirstViewport.minimumPhone` (360x800), asserts the
  `SC-155 NetworkStatusPage` route semantic, verifies the status filter
  controls are actionable, and verifies the highest-risk `polygon` maintenance
  network card is visible/actionable in the first viewport.
- `SC-155 refresh and filters give visible feedback` verifies refresh feedback
  via `NetworkStatusPage.refreshFeedbackKey` and proves the maintenance filter
  shows `polygon` while removing `btc`.

GitNexus evidence:

- `context(NetworkStatusPage)` found wallet route construction, app router
  import, focused test import, and no page-specific execution flows.
- `impact(target: "NetworkStatusPage", direction: "upstream")` returned
  CRITICAL from route/router fan-out (`impactedCount=254`, direct callers 2,
  affected processes 0); user was warned before edits.
- `impact(target: "build", file_path: network_status_page.dart)` returned LOW.
  `_showNetworkRefreshNotice` and the test helper did not resolve and were
  treated as UNKNOWN before modification.
- Local widget/helper impacts for `_SummaryCard`, `_SummaryStat`,
  `_NetworkCard`, `_StatsGrid`, `_StatTile`, `_CongestionBar`,
  `_AvailabilityChip`, `_NetworkNote`, `_LegendCard`, `_LegendItem`,
  `_DisclaimerCard`, `_TokenLogo`, `_HealthPill`, `_healthLabel`,
  `_healthColor`, `_healthIcon`, `_congestionColor`, and `_formatInt` were LOW
  or no-dependent.
- `detect_changes(scope: all)` after the batch returned medium risk because
  the dirty worktree still contains prior completed Wallet batches:
  `changed_count=396`, `affected_count=1`, `changed_files=92`; affected
  process is `Build -> FindByFlow`.
- Scoped Network Status diff/status was limited to the Network Status page
  bundle, focused test, regenerated visual-density artifacts, and this plan.

Headroom refs: detect=be0d7552ac02aebf6fd3bb66.

Verification:

- `dart format lib/features/wallet/presentation/pages/network_status_page.dart lib/features/wallet/presentation/widgets/network_status_summary.dart lib/features/wallet/presentation/widgets/network_status_cards_stats.dart lib/features/wallet/presentation/widgets/network_status_legend_common.dart test/features/wallet/network_status_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/network_status_page_test.dart --reporter=compact`:
  initially exposed a `VitEmptyState` API mismatch, a 360 px summary stat
  overflow, and the stale snackbar feedback path; fixed and rerun Pass, 5/5
  tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 97/97 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for this Wallet UI batch; P0 and P1 density review counts remain
  0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <NetworkStatus batch files>`: Pass, with only LF/CRLF
  working-copy warnings.

Review result:

- Current-batch diff review found no blocking issues. The remaining local
  composition is network-health-specific card, filter, sorting, legend, and
  progress presentation wrapped in shared Wallet primitives.

Remaining blockers: none.

### 6.3 `WalletMultiManagerPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_multi_manager_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_tabs.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_all_wallets_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_groups_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_activity_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_distribution_chart.dart`
- `flutter_app/test/features/wallet/wallet_multi_manager_page_test.dart`

Redesign target:

- Header -> multi-wallet summary -> tabs -> dense wallet/group/activity rows ->
  security notice.

Must fix:

- [x] Sensitive wallet addresses remain masked by default.
- [x] Reveal/copy actions have explicit labels and semantics.
- [x] Add wallet action is not a no-op and has clear future state if deferred.
- [x] Tabs fit at 360 px.
- [x] Distribution chart does not push core actions below first viewport.

Optimization:

- Treat chart as secondary insight, not the first task.
- Keep all wallet rows dense and comparable.

Verification:

- [x] `flutter test test/features/wallet/wallet_multi_manager_page_test.dart --reporter=compact`

### WalletMultiManagerPage Batch Evidence - 2026-06-27

Status: Done 2026-06-27.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_tabs.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_all_wallets_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_groups_tab.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_manager_activity_tab.dart`
- `flutter_app/test/features/wallet/wallet_multi_manager_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md`

Current Home-standard gap before edit:

- The page had a Wallet header and masking state, but its tabs sat outside the
  shared scroll rhythm, content used a local `SingleChildScrollView`, the
  summary/chart pushed wallet actions down, and the add-wallet action relied on
  a transient snackbar path instead of a visible in-page deferred state.
- Reveal and copy controls were small custom card buttons without explicit
  tooltips/semantics. Wallet addresses were masked by default, but the focused
  test did not prove copy did not reveal a full address.

Home pattern applied:

- Header -> compact portfolio summary -> wallet privacy risk panel -> shared
  tabs -> all-wallet primary action cluster -> dense wallet rows -> security
  notice -> distribution chart.
- The distribution chart is now secondary discovery after the core wallet
  management work instead of appearing before wallet rows.
- The add-wallet action shows a persistent in-page deferred status:
  `Wallet creation is not connected yet.`

Shared primitives adopted:

- `VitPageLayout`, `VitHeader`, `VitAutoHideHeaderScaffold`,
  `VitInsetScrollView`, compact `VitPageContent`, `VitHighRiskStatePanel`,
  `VitTabBar`, `VitSectionHeader`, `VitCard`, `VitCtaButton`,
  `VitIconButton`, `VitStatusPill`, and `VitMetricDeltaPill`.

L3 local reasons:

- Wallet, group, activity, summary, distribution, asset-chip, and wallet-type
  icon compositions remain route-local because they render
  `WalletMultiManagerSnapshot`, per-wallet masking/reveal/copy state,
  distribution percentages, and wallet-group metadata that are specific to
  this Wallet tool.
- Local painter/chart logic remains in the route bundle because it visualizes
  the per-wallet portfolio distribution and is not a shared app primitive.

Action inventory result:

- Scoped action census found tabs via `VitTabBar`, add wallet via
  `VitCtaButton`, reveal/copy via `VitIconButton`, wallet-row selection via
  existing `VitCard.onTap`, and local state handlers for reveal/copy/deferred
  add-wallet status.
- No dialog, bottom sheet, route, provider, repository, preview, confirm,
  revoke, scan, or submit action was added or changed.

Financial safety result:

- Wallet addresses remain masked by default (`0x742d...0bEb`), and the focused
  test verifies the full address is absent before reveal and remains absent
  after copy.
- Reveal/copy controls now have explicit tooltips. Copying a masked wallet does
  not reveal the address in UI; reveal remains an explicit local action.
- The privacy risk panel remains before wallet controls. No withdrawal,
  address-add, token-revoke, dust-conversion, fee, limit, preview/confirm,
  provider, repository, route, or P2P Wallet behavior changed.

First-viewport evidence:

- `SC-148 first viewport reaches wallet controls` now runs with
  `VitFirstViewport.minimumPhone` (360x800), asserts the
  `SC-148 WalletMultiManagerPage` route semantic, verifies the shared tab
  control is actionable, and verifies the first wallet row plus reveal-address
  control are actionable in the first viewport.
- The focused test also verifies add-wallet deferred state via
  `WalletMultiManagerPage.addWalletNoticeKey`.

GitNexus evidence:

- `context(WalletMultiManagerPage)` found wallet route construction, app router
  import, focused test import, and no page-specific execution flows.
- `impact(target: "WalletMultiManagerPage", direction: "upstream")` returned
  CRITICAL from route/router fan-out (`impactedCount=254`, direct callers 2,
  affected processes 0); user was warned before edits.
- `_WalletMultiManagerPageState` impact returned CRITICAL from page ownership;
  `build`, `_contentForTab`, `_toggleReveal`, and `_copyWallet` impacts were
  LOW. `_showActionNotice` did not resolve and was treated as UNKNOWN before
  modification.
- Local widget impacts for `WalletManagerTabs`, `WalletAllWalletsTab`,
  `WalletGroupsTab`, `WalletActivityTab`, `WalletManagerDistributionCard`,
  `_DistributionPainter`, `_chartWallets`, `_PortfolioSummaryCard`,
  `_WalletCard`, `_WalletTypeIcon`, `WalletManagerTinyIconButton`,
  `WalletManagerAddWalletButton`, `WalletManagerSecurityNotice`, and
  `WalletManagerSectionLabel` were LOW or MEDIUM with no affected processes.
- `detect_changes(scope: all)` after the batch returned medium risk because
  the dirty worktree still contains prior completed Wallet batches:
  `changed_count=419`, `affected_count=1`, `changed_files=99`; affected
  process is `Build -> FindByFlow`.
- Scoped Wallet Multi Manager diff/stat was limited to this page bundle, its
  focused test, regenerated visual-density artifacts, and this plan.

Headroom refs: failure-log=b3505c28658533908e9a9719,
detect=8fc6c2174bb636e84f962212.

Verification:

- `dart format lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart lib/features/wallet/presentation/widgets/wallet_manager_all_wallets_tab.dart lib/features/wallet/presentation/widgets/wallet_manager_tabs.dart lib/features/wallet/presentation/widgets/wallet_manager_common.dart lib/features/wallet/presentation/widgets/wallet_manager_groups_tab.dart lib/features/wallet/presentation/widgets/wallet_manager_activity_tab.dart test/features/wallet/wallet_multi_manager_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/wallet_multi_manager_page_test.dart --reporter=compact`:
  initially exposed an unbounded `Spacer` in `_WalletCard`, then a 360 px
  summary overflow and off-screen add-wallet tap after the Home rhythm change;
  fixed and rerun Pass, 5/5 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 99/99 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for this Wallet UI batch; P0 and P1 density review counts remain
  0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Review result:

- Current-batch diff review found no blocking issues. The remaining local
  composition is multi-wallet-specific masking, group/activity, distribution,
  and wallet-row presentation wrapped in shared Wallet primitives.

Remaining blockers: none.

### 6.4 `WalletGasOptimizerPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_gas_optimizer_current.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_gas_optimizer_trends.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_gas_optimizer_tips.dart`
- `flutter_app/test/features/wallet/wallet_gas_optimizer_page_test.dart`

Redesign target:

- Header -> current recommendation -> speed selector -> fee comparison ->
  trends/tips tabs.

Must fix:

- [x] Gas recommendations do not imply guaranteed savings.
- [x] Fee levels are readable and not color-only.
- [x] Refresh action has accessible label and visible feedback.
- [x] Current/trends/tips use consistent tabs/sections.

Optimization:

- Put recommended speed and estimated fee in first viewport.
- Keep tips compact and action-oriented.

Verification:

- [x] `flutter test test/features/wallet/wallet_gas_optimizer_page_test.dart --reporter=compact`

### WalletGasOptimizerPage Batch Evidence - 2026-06-27

Status: Done 2026-06-27.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_gas_optimizer_current.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_gas_optimizer_trends.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_gas_optimizer_tips.dart`
- `flutter_app/test/features/wallet/wallet_gas_optimizer_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md`

Current Home-standard gap before edit:

- The page already used Wallet header chrome and some shared cards, but tabs
  were mounted outside the scroll rhythm, the content used a local
  `SingleChildScrollView` and `DeviceMetrics`, refresh/quick actions relied on
  a snackbar path, and copy such as `Good Time` / `Potential Saving` could read
  like guaranteed savings.
- Fee levels had labels and values, but the selected/recommended state leaned
  on border color and a local text badge; quick actions were local tappable
  cards instead of shared service/action primitives.

Home pattern applied:

- Header -> shared segmented tabs -> compact current gas estimate context ->
  speed selector with selected/recommended text state -> fee comparison rows ->
  visible refresh status.
- Trends and tips use the same compact page-section rhythm when selected from
  tabs, with advisory/historical copy instead of guaranteed savings language.

Shared primitives adopted:

- `VitPageLayout`, `VitHeader`, `VitAutoHideHeaderScaffold`,
  `VitInsetScrollView`, compact `VitPageContent`, `VitTabBar`,
  `VitSectionHeader`, `VitCard`, `VitCtaButton`, `VitStatusPill`,
  `VitAccentPill`, and `VitServiceTile`.

L3 local reasons:

- Gas status, speed level, comparison row, chart card, best-time, tip card,
  and quick-action compositions remain route-local because they render
  `WalletGasOptimizerSnapshot` fee estimates, historical gas charts, network
  activity, selected speed state, and advisory tip metadata specific to this
  Wallet tool.
- `_GasLineChartPainter`, `_NetworkBarChartPainter`, and `_withCommas` remain
  local because they are narrow visual formatting for gas history/activity
  data. Their raw canvas math is limited to `CustomPainter` chart geometry.

Action inventory result:

- Scoped action census found speed selection via existing `VitCard.onTap`,
  refresh via `VitCtaButton`, current/trends/tips via `VitTabBar`, and quick
  actions via `VitServiceTile`.
- No dialog, bottom sheet, route, provider, repository, preview, confirm,
  revoke, copy, scan, or submit action was added or changed.
- Scoped anti-pattern census found no `SingleChildScrollView`,
  `DeviceMetrics`, snackbar, raw `Container`, `BoxDecoration`, raw
  `EdgeInsets`, raw `BorderRadius.circular`, raw font sizes, or raw color
  palettes in the Gas Optimizer page bundle.

Financial safety result:

- Gas estimates remain read-only advisory information. The page now says fees
  are estimated, can change before confirmation, and users should confirm live
  fees before signing.
- Savings language was changed from `Good Time` / `Potential Saving` to
  historical or observed wording. Quick actions show a deferred state instead
  of implying connected execution.
- No withdrawal, address-add, token-revoke, dust-conversion, fee payment,
  limit, masking, preview/confirm, provider, repository, route, or P2P Wallet
  behavior changed.

First-viewport evidence:

- `SC-149 first viewport reaches gas comparison fee row` now runs with
  `VitFirstViewport.minimumPhone` (360x800), asserts the
  `SC-149 WalletGasOptimizerPage` route semantic, and verifies the first gas
  comparison fee row is visible in the first viewport.
- `SC-149 speed selection and secondary tabs are local` verifies refresh
  feedback via `WalletGasOptimizerPage.feedbackKey` and tab navigation to
  trends/tips after the redesign.

GitNexus evidence:

- `context(WalletGasOptimizerPage)` found wallet route construction, app
  router import, focused test import, and no page-specific execution flows.
- `impact(target: "WalletGasOptimizerPage", direction: "upstream")` returned
  CRITICAL from route/router fan-out (`impactedCount=254`, direct callers 2,
  affected processes 0); user was warned before edits.
- `_WalletGasOptimizerPageState` impact returned CRITICAL from page ownership;
  `build` and `_contentForTab` impacts were LOW. `_showGasNotice` did not
  resolve and was treated as UNKNOWN before modification.
- Local widget impacts for `_GasTabs`, `_CurrentGasTab`, `_GasStatusCard`,
  `_SectionLabel`, `_GasLevelCard`, `_RecommendedBadge`, `_ComparisonCard`,
  `_ComparisonRow`, `_RefreshButton`, `_TrendsTab`, `_ChartCard`,
  `_BestTimeCard`, `_TipsTab`, `_TipCard`, and `_QuickActionsCard` were LOW
  with no affected processes.
- `detect_changes(scope: all)` after the batch returned medium risk because
  the dirty worktree still contains prior completed Wallet batches:
  `changed_count=437`, `affected_count=1`, `changed_files=104`; affected
  process is `Build -> FindByFlow`.
- Scoped Gas Optimizer diff/stat was limited to this page bundle, its focused
  test, regenerated design-token and visual-density artifacts, and this plan.

Headroom refs: verification=8a48be6d15e70663b8ac0db9,
detect=758704ca67102f0a81977013.

Verification:

- `dart format lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart lib/features/wallet/presentation/widgets/wallet_gas_optimizer_current.dart lib/features/wallet/presentation/widgets/wallet_gas_optimizer_trends.dart lib/features/wallet/presentation/widgets/wallet_gas_optimizer_tips.dart test/features/wallet/wallet_gas_optimizer_page_test.dart`:
  Pass.
- `flutter test test/features/wallet/wallet_gas_optimizer_page_test.dart --reporter=compact`:
  initially exposed a test expectation update after adding a second
  `Standard` status pill; fixed and rerun Pass, 4/4 tests.
- `flutter test test/features/wallet --reporter=compact`: Pass, 99/99 tests.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: initially stale;
  regenerated. First regen exposed `p0_wallet_debt=4` from raw grid params in
  the quick-action rewrite; fixed with shared `VitServiceTile` list and token
  spacing. Final check Pass/current, `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale density
  artifacts for this Wallet UI batch; P0 and P1 density review counts remain
  0.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.

Review result:

- Current-batch diff review found no blocking issues. Remaining local
  composition is gas-estimate-specific charting, fee-level, comparison, and
  advisory tip presentation wrapped in shared Wallet primitives.

Remaining blockers: none.

### 6.5 `WalletHealthScorePage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page.dart`
- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_01.dart`
- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_02.dart`
- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_03.dart`
- `flutter_app/test/features/wallet/wallet_health_score_page_test.dart`

Redesign target:

- Header -> advisory score summary -> recommendation next action -> tabs ->
  chart/legend and recommendation detail sheet.

Must fix:

- [x] Health score is advisory, not absolute financial advice.
- [x] Recommendations are clear and actionable.
- [x] Chart/legend information is readable beyond color.
- [x] Recommendation sheet has clear close and CTA behavior.

Optimization:

- Put the most important health recommendation in the first viewport.
- Keep diversification/security sections dense and scannable.

Verification:

- [x] `flutter test test/features/wallet/wallet_health_score_page_test.dart --reporter=compact`

### WalletHealthScorePage Batch Evidence - 2026-06-27

Status: Done 2026-06-27.

Files changed:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page.dart`
- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_01.dart`
- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_02.dart`
- `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_03.dart`
- `flutter_app/test/features/wallet/wallet_health_score_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md`

Current Home-standard gap before edit:

- The page already used Wallet chrome and shared cards, but the tabs were
  fixed outside the scroll rhythm, content used a local
  `SingleChildScrollView` and `DeviceMetrics`, the highest-priority
  recommendation was below the overall score/tabs, and the recommendation
  sheet did not explicitly frame the score as advisory-only.
- Diversification legend rows included color swatches and names, but the
  visible percentage/value was not encoded in the legend text, making the
  chart too color-dependent for quick scanning.

Home pattern applied:

- Header -> compact advisory score summary -> priority recommendation in the
  first viewport -> shared segmented tabs -> dense overview/security/
  diversification sections -> recommendation advisory sheet -> bottom-safe
  scroll end.
- The top recommendation is now a primary context card before tabs; the
  overview tab shows remaining recommendations as secondary discovery.

Shared primitives adopted:

- `VitPageLayout`, `VitHeader`, `VitAutoHideHeaderScaffold`,
  `VitInsetScrollView`, compact `VitPageContent`, `VitTabBar`,
  `VitSectionHeader`, `VitCard`, `VitCtaButton`, `VitStatusPill`,
  `VitEmptyState`, `VitSheetPanel`, and `showVitBottomSheet`.

L3 local reasons:

- Score rings, metric rows, security checklist rows, allocation/chart rows,
  history trend, and recommendation cards remain page-local because they map
  Wallet health-score domain fields (`overallScore`, `metrics`,
  `priorityRecommendations`, `securityChecklist`, `assetDistribution`, and
  `history`) into dense advisory diagnostics that do not have a shared Wallet
  primitive.
- `_HealthScorePainter`, `_TrendChartPainter`, `_DiversificationPainter`,
  `_scoreColor`, `_statusColor`, and `_impactColor` remain local because they
  are narrow chart/status encodings for this health-score visualization.
  Legend labels now include values, so color is not the only indicator.

Action inventory result:

- Scoped action census found recommendation detail opening via
  `VitCard.onTap`, recommendation sheet close via `VitCtaButton`, and
  overview/security/diversification switching via shared `VitTabBar`.
- No route, provider, repository, confirm, preview, revoke, copy, scan,
  refresh, submit, or external integration action was added or changed.
- Scoped anti-pattern census found no `SingleChildScrollView`,
  `DeviceMetrics`, raw `Container`, `BoxDecoration`, raw `EdgeInsets`, raw
  `BorderRadius.circular`, raw font sizes, or new local color palette debt in
  the edited shell/tab/sheet areas. Remaining `Material`, tokenized
  `SizedBox`, chart `Color(slice.colorHex)`, and chart/status helpers are
  retained L3/data-driven rendering.

Financial safety result:

- Health score copy is advisory-only and explicitly states it is not financial
  advice in the recommendation sheet.
- No money movement, fee, limit, masking, address, approval, withdrawal,
  token-revoke, or preview/confirm flow was changed. P2P Wallet routes remain
  out of scope.

First-viewport evidence:

- `wallet_health_score_page_test.dart` pumps
  `VitFirstViewport.minimumPhone`/360 px evidence and asserts the priority
  recommendation (`WalletHealthScorePage.recommendationKey('r1')`, `Enable
  2FA`) is visible and actionable in the first viewport.
- The same focused test covers the advisory recommendation sheet close action
  (`sc151_health_score_sheet_close`) and diversification legend value text
  (`BTC 42%`, `Stablecoins 18%`).

GitNexus evidence:

- `context(WalletHealthScorePage)`: route construction through
  `wallet_routes.dart`, router import, and focused test import; no execution
  processes listed.
- `impact(WalletHealthScorePage, upstream)`: CRITICAL route/router fan-out
  (`impactedCount=254`, direct=2, processes affected=0); user was warned
  before edits.
- Additional upstream impact checks for `_WalletHealthScorePageState`,
  `_buildTab`, `_showRecommendationSheet`, `_HealthTabs`, `_OverviewTab`,
  `_OverallScoreCard`, `_RecommendationCard`, `_SecurityTab`,
  `_DiversificationTab`, `_AssetDistributionCard`, and `_SectionLabel`
  returned LOW/no process fan-out.
- `detect_changes(scope=all)`: medium risk because the dirty Wallet redesign
  worktree spans prior completed batches; affected process limited to
  `Build -> FindByFlow`. Scoped Health diff stat recorded separately.

Headroom refs: detect-changes=`715914579caa020b87f101d8`.

Verification:

- `dart format lib/features/wallet/presentation/pages/wallet_health_score_page.dart lib/features/wallet/presentation/pages/wallet_health_score_page_part_01.dart lib/features/wallet/presentation/pages/wallet_health_score_page_part_02.dart lib/features/wallet/presentation/pages/wallet_health_score_page_part_03.dart test/features/wallet/wallet_health_score_page_test.dart`:
  Pass, 5 files formatted, 0 changed after final rename.
- `flutter test test/features/wallet/wallet_health_score_page_test.dart --reporter=compact`:
  Pass, 5/5.
- `flutter test test/features/wallet --reporter=compact`: Pass, 100/100.
- `flutter analyze`: Pass, no issues.
- `dart run tool/design_token_consistency_audit.dart --check`: Pass/current,
  `p0_wallet_debt=0/759`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale
  Wallet/UI density artifacts as instructed by the tool.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current,
  `P0_CRITICAL_DENSITY_REVIEW=0`, `P1_HIGH_DENSITY_REVIEW=0`.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass.
- `git diff --check -- <Health batch files>`: Pass; only LF->CRLF warnings
  from the Windows worktree.

Review result:

- Current-batch diff review found no blocking issues. The page now follows the
  Home compact Wallet rhythm, first-viewport priority recommendation contract,
  advisory-only copy, and non-color-only chart legend requirements.

Remaining blockers: none.

## Per-Page Progress Ledger

Update this table only with evidence from the current redesign pass.

| Page | Route(s) | Pattern | Priority | Status | Evidence required before Done |
| --- | --- | --- | --- | --- | --- |
| `WalletPage` | `/wallet` | Financial command center | P0 | Done 2026-06-27 - Home command-center/rootModule rhythm applied; 360x800 widget viewport test added; top-header visual strict issue cleared; focused/Wallet/analyze/audits/full-suite pass | Evidence recorded in WalletPage Batch Evidence - 2026-06-24 and Phase 7 Final Verification - 2026-06-27 |
| `DepositPage` | `/wallet/deposit`, `/wallet/deposit/:asset` | Money movement receive flow | P0 | Done 2026-06-24 - Home receive rhythm applied; copy-address 360x800 widget evidence pass; asset-scoped route preserved; GitNexus detect low risk | Evidence recorded in DepositPage Batch Evidence - 2026-06-24 |
| `WithdrawPage` | `/wallet/withdraw`, `/wallet/withdraw/:asset` | High-risk withdrawal form | P0 | Done 2026-06-24 - Home high-risk withdrawal rhythm applied; disabled preview reason and fee/masked-address confirmation evidence pass; GitNexus detect low risk | Evidence recorded in WithdrawPage Batch Evidence - 2026-06-24 |
| `TransferPage` | `/wallet/transfer` | Internal transfer form | P0 | Done 2026-06-24 - Home internal-transfer rhythm applied; disabled amount reason and confirmation sheet evidence pass; GitNexus detect low risk | Evidence recorded in TransferPage Batch Evidence - 2026-06-24 |
| `BuyCryptoPage` | `/wallet/buy-crypto` | Buy/review/success flow | P0 | Done 2026-06-24 - Home buy/review/submitting/success rhythm applied; 360x800 input/review/success evidence pass; GitNexus detect low risk | Evidence recorded in BuyCryptoPage Batch Evidence - 2026-06-24 |
| `TransactionHistoryPage` | `/wallet/history` | Dense transaction list | P1 | Done 2026-06-24 - Home dense-history rhythm applied; 360x800 first-row evidence pass; export request notice fixed; GitNexus detect low risk | Evidence recorded in TransactionHistoryPage Batch Evidence - 2026-06-24 |
| `TransactionDetailPage` | `/wallet/transaction/:txId` | Receipt/detail page | P1 | Done 2026-06-24 - Home receipt/detail rhythm applied; 360x800 TxID copy evidence pass; inline copy confirmation and shared missing state test-covered; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in TransactionDetailPage Batch Evidence - 2026-06-24 |
| `AssetDetailPage` | `/wallet/asset/:assetId` | Asset detail hub | P1 | Done 2026-06-24 - Home asset-detail rhythm applied; 360x800 action/period evidence pass; asset CTAs and transaction route preserved; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in AssetDetailPage Batch Evidence - 2026-06-24 |
| `PortfolioAnalyticsPage` | `/wallet/portfolio-analytics` | Analytics summary | P1 | Done 2026-06-24 - Home analytics rhythm applied; 360x800 period-selector evidence pass; positive/negative deltas use shared pill context; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in PortfolioAnalyticsPage Batch Evidence - 2026-06-24 |
| `AddressBookPage` | `/wallet/address-book` | Saved address safety list | P0 | Done 2026-06-24 - Home saved-address safety rhythm applied; 360x800 masked copy/delete evidence pass; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in AddressBookPage Batch Evidence - 2026-06-24 |
| `AddressAddPage` | `/wallet/address-book/add` | High-risk address form | P0 | Done 2026-06-24 - Home high-risk address-add rhythm applied; 360x800 setup, masked preview, and success-return evidence pass; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in AddressAddPage Batch Evidence - 2026-06-24 |
| `PendingDepositsPage` | `/wallet/pending-deposits` | Pending status list | P1 | Done 2026-06-24 - Home pending-status rhythm applied; 360x800 status/copy/refresh evidence pass; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in PendingDepositsPage Batch Evidence - 2026-06-24 |
| `WithdrawLimitsPage` | `/wallet/limits` | Limit/KYC ladder | P1 | Done 2026-06-24 - Home limit/KYC ladder rhythm applied; 360x800 current-tier/usage evidence pass; KYC route stays navigational; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in WithdrawLimitsPage Batch Evidence - 2026-06-24 |
| `WalletTokenApprovalPage` | `/wallet/token-approval` | High-risk approval management | P0 | Done 2026-06-24 - Home token-approval risk rhythm applied; 360x800 active approval/revoke evidence pass; preview/confirm and risk-state review preserved; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in WalletTokenApprovalPage Batch Evidence - 2026-06-24 |
| `DustConverterPage` | `/wallet/dust-converter` | Conversion preview flow | P1 | Done 2026-06-24; follow-up Done 2026-06-27 - Home dust-conversion preview rhythm applied; sticky CTA removed into inline scroll content; 360x800 asset row and confirm-sheet evidence pass; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in DustConverterPage Batch Evidence - 2026-06-24 and Sticky CTA Follow-Up - 2026-06-27 |
| `NetworkStatusPage` | `/wallet/network-status` | Network health dashboard | P2 | Done 2026-06-24 - Home network-health rhythm applied; 360x800 filter and worst-network evidence pass; status not color-only; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in NetworkStatusPage Batch Evidence - 2026-06-24 |
| `WalletMultiManagerPage` | `/wallet/multi-manager` | Multi-wallet management | P1 | Done 2026-06-27 - Home multi-wallet management rhythm applied; 360x800 tabs/wallet/reveal evidence pass; masking, copy, and deferred add-wallet state verified; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in WalletMultiManagerPage Batch Evidence - 2026-06-27 |
| `WalletGasOptimizerPage` | `/wallet/gas-optimizer` | Gas recommendation tool | P2 | Done 2026-06-27 - Home gas-estimate rhythm applied; 360x800 comparison-row evidence pass; non-guaranteed fee copy and visible refresh feedback verified; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in WalletGasOptimizerPage Batch Evidence - 2026-06-27 |
| `WalletHealthScorePage` | `/wallet/health-score` | Advisory health score | P2 | Done 2026-06-27 - Home advisory-health rhythm applied; 360x800 priority recommendation, advisory sheet, and value legend evidence pass; GitNexus detect medium only because prior Wallet batches remain unstaged | Evidence recorded in WalletHealthScorePage Batch Evidence - 2026-06-27 |

## Implementation Batch Template

Use this for each coding turn:

```text
Read docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md.
Target page: <PAGE_NAME>.

Before editing:
- Read AGENTS.md, docs/00_START_HERE.md, Guidelines.md, Home rollout playbook.
- Read target page, widget parts, provider/controller, and focused test.
- Run GitNexus context for the target page class.
- Run GitNexus impact before editing any symbol.
- Run the Wallet action census for the target page.
- Record current Home-standard gap.

Implement:
- Apply Home shell/content rhythm.
- Use shared primitives by pattern.
- Preserve routes, keys, providers, masking, fees, limits, preview/confirm.
- Keep local composition only with an L3 reason.
- Add or update tests for any new visual/behavior contract.

After editing:
- Run dart format on touched Dart files.
- Run the focused page test.
- Run relevant Wallet tests.
- Run flutter analyze.
- Run design-token/visual-density audit when layout or tokens changed.
- Run GitNexus detect_changes before commit.
- Update this plan with evidence.
```

## Phase 7: Full Verification And Artifact Update

### Phase 7 Final Verification - 2026-06-27

Status: Done 2026-06-27.

Final artifact/code updates:

- `WalletPage` root route now uses `VitTopChrome(type:
  VitTopChromeType.rootModule)` so the primary Wallet tab root satisfies the
  strict top-header visual archetype audit. Child Wallet routes continue to
  use `VitHeader`, preserving the Wallet route header contract.
- `WithdrawNextButton` keeps the accessible label `Preview withdrawal` stable
  in enabled and disabled states; the disabled reason remains available through
  hint/tooltip copy. Preview/confirm remains blocked until valid address and
  amount input exist.
- `accessibility_semantics_critical_flows_test.dart` now enters a valid
  withdrawal address and amount before asserting the withdrawal preview sheet
  semantics, preserving the high-risk preview/confirm contract instead of
  weakening it.
- Regenerated stale audit artifacts only when the tool instructed it:
  back-navigation behavior, home-entry back navigation, top-header action,
  top-header visual archetype, and visual-density risk.

Final verification commands:

- `dart format --output=none --set-exit-if-changed lib/features/wallet test/features/wallet test/quality/accessibility_semantics_critical_flows_test.dart`:
  Pass, 128 files checked, 0 changed.
- `dart run tool/route_coverage_audit.dart --check`: Pass/current.
- `dart run tool/design_token_consistency_audit.dart --check`:
  Pass/current, `p0_wallet_debt=0/759`,
  `strict_typography_gate=zero_residual pass`.
- `dart run tool/visual_density_risk_audit.dart`: Regenerated stale artifact
  after Wallet root chrome update, as instructed by `--check`.
- `dart run tool/visual_density_risk_audit.dart --check`: Pass/current,
  `P0_CRITICAL_DENSITY_REVIEW=0`, `P1_HIGH_DENSITY_REVIEW=0`,
  `root_top_chrome_first_viewport_cost=11`.
- `flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  Pass, 2/2.
- `flutter analyze`: Pass, no issues.
- `flutter test test/features/wallet --reporter=compact`: Pass, 100/100.
- `flutter test test/quality --reporter=compact`: Pass, 56/56.
- `flutter test --reporter=compact`: Pass, 2379/2379.
- `flutter test test/features/wallet/wallet_page_test.dart --reporter=compact`:
  Pass, 7/7 after rootModule chrome update.
- `flutter test test/features/wallet/withdraw_page_test.dart --reporter=compact`:
  Pass, 9/9 after stable preview semantics update.

Audit results:

- Top-header visual archetype audit: `strict_visual_issues=0`,
  `screen_level_mismatches=0`, `uses_vit_top_chrome=20`.
- Top-header action audit: `migration_candidates=0`,
  `banned_icon_usages=0`, `custom_button_usages=0`,
  `action_groups_over_limit=0`.
- Back-navigation behavior audit: `strict_back_issues=0`.
- Home-entry back-navigation audit: `home_entry_back_rules=44`,
  `passed=44`, `failed=0`.

Financial safety and product boundaries:

- Withdraw preview/confirm, fees, limits, masked destination, disabled reason,
  and confirm/cancel semantics remain covered by focused Wallet and quality
  tests.
- Address add, token revoke, dust conversion, and other high-risk Wallet
  flows retain their preview/confirm evidence from page batches.
- P2P Wallet routes remain excluded from this Wallet redesign scope.

GitNexus final evidence:

- `detect_changes(scope=all)`: medium risk because the full ordered Wallet
  redesign worktree remains uncommitted across prior completed batches and
  regenerated audit artifacts. Summary: `changed_count=466`,
  `changed_files=118`, `affected_count=1`; affected process limited to
  `Build -> FindByFlow`.

Headroom refs: final-verification=`cecc7946436926972bc315ad`,
detect-changes=`2b6e44660de9d54e59e6af71`.

Remaining blockers: none.

## Definition Of Done

Wallet Home-standard redesign is complete only when:

- [x] All 21 Wallet routes are covered.
- [x] All 19 primary Wallet page classes are covered.
- [x] Every page has a completed action inventory.
- [x] Every page has a Home pattern classification.
- [x] Every local composition has an L3 reason or was replaced by shared
      primitives.
- [x] Every page passes focused tests.
- [x] Wallet focused test folder passes.
- [x] `flutter analyze` passes.
- [x] Route coverage passes.
- [x] Design-token audit passes or has documented unrelated artifact blockers.
- [x] Visual-density audit passes or has documented unrelated artifact blockers.
- [x] 360 px first-viewport review is recorded for every page.
- [x] High-risk flows preserve preview, confirm, fees, limits, masking, risk,
      and next-step copy.
- [x] P2P Wallet remains excluded.
- [x] GitNexus `detect_changes()` confirms the expected scope before commit.

## Current Known Blockers And Warnings

- No remaining blockers.
- The worktree intentionally contains the uncommitted Wallet redesign batches,
  regenerated audit artifacts, and the final quality-test harness update. Do
  not commit unless explicitly requested.
