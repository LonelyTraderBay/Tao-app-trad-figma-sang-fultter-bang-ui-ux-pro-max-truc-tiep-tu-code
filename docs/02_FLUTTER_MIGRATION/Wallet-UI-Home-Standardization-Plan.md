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
| 1 | `/wallet` | `sc135Wallet` | `WalletPage` | `test/features/wallet/wallet_page_test.dart` | Pending visual redesign |
| 2 | `/wallet/history` | `sc136TxHistory` | `TransactionHistoryPage` | `test/features/wallet/transaction_history_page_test.dart` | Pending visual redesign |
| 3 | `/wallet/deposit` | `sc137Deposit` | `DepositPage` | `test/features/wallet/deposit_page_test.dart` | Pending visual redesign |
| 4 | `/wallet/deposit/:asset` | `sc138DepositUsdt` | `DepositPage` | `test/features/wallet/deposit_page_test.dart` | Pending visual redesign |
| 5 | `/wallet/withdraw` | `sc139Withdraw` | `WithdrawPage` | `test/features/wallet/withdraw_page_test.dart` | Pending visual redesign |
| 6 | `/wallet/withdraw/:asset` | `sc140WithdrawUsdt` | `WithdrawPage` | `test/features/wallet/withdraw_page_test.dart` | Pending visual redesign |
| 7 | `/wallet/transaction/:txId` | `sc141TransactionDetail` | `TransactionDetailPage` | `test/features/wallet/transaction_detail_page_test.dart` | Pending visual redesign |
| 8 | `/wallet/portfolio-analytics` | `sc142PortfolioAnalytics` | `PortfolioAnalyticsPage` | `test/features/wallet/portfolio_analytics_page_test.dart` | Pending visual redesign |
| 9 | `/wallet/address-book/add` | `sc143AddressAdd` | `AddressAddPage` | `test/features/wallet/address_add_page_test.dart` | Pending visual redesign |
| 10 | `/wallet/address-book` | `sc144AddressBook` | `AddressBookPage` | `test/features/wallet/address_book_page_test.dart` | Pending visual redesign |
| 11 | `/wallet/buy-crypto` | `sc145BuyCrypto` | `BuyCryptoPage` | `test/features/wallet/buy_crypto_page_test.dart` | Pending visual redesign |
| 12 | `/wallet/transfer` | `sc146Transfer` | `TransferPage` | `test/features/wallet/transfer_page_test.dart` | Pending visual redesign |
| 13 | `/wallet/asset/:assetId` | `sc147AssetDetail` | `AssetDetailPage` | `test/features/wallet/asset_detail_page_test.dart` | Pending visual redesign |
| 14 | `/wallet/multi-manager` | `sc148MultiManager` | `WalletMultiManagerPage` | `test/features/wallet/wallet_multi_manager_page_test.dart` | Pending visual redesign |
| 15 | `/wallet/gas-optimizer` | `sc149GasOptimizer` | `WalletGasOptimizerPage` | `test/features/wallet/wallet_gas_optimizer_page_test.dart` | Pending visual redesign |
| 16 | `/wallet/token-approval` | `sc150TokenApproval` | `WalletTokenApprovalPage` | `test/features/wallet/wallet_token_approval_page_test.dart` | Pending visual redesign |
| 17 | `/wallet/health-score` | `sc151HealthScore` | `WalletHealthScorePage` | `test/features/wallet/wallet_health_score_page_test.dart` | Pending visual redesign |
| 18 | `/wallet/pending-deposits` | `sc152PendingDeposits` | `PendingDepositsPage` | `test/features/wallet/pending_deposits_page_test.dart` | Pending visual redesign |
| 19 | `/wallet/limits` | `sc153WithdrawLimits` | `WithdrawLimitsPage` | `test/features/wallet/withdraw_limits_page_test.dart` | Pending visual redesign |
| 20 | `/wallet/dust-converter` | `sc154DustConverter` | `DustConverterPage` | `test/features/wallet/dust_converter_page_test.dart` | Pending visual redesign |
| 21 | `/wallet/network-status` | `sc155NetworkStatus` | `NetworkStatusPage` | `test/features/wallet/network_status_page_test.dart` | Pending visual redesign |

Excluded P2P routes:

- `/p2p/wallet`
- `/p2p/wallet/transfer`
- `/p2p/wallet/fund-lock-history`
- `/p2p/wallet/history`

## Redesign Phase Order

| Phase | Scope | Why this order | Status |
| --- | --- | --- | --- |
| 0 | Evidence reset and audit baseline | Stop treating functional tests as visual completion | Pending |
| 1 | Shared Wallet visual foundation | Remove repeated local shell/card/spacing patterns before page work | Pending |
| 2 | Wallet hub | Root command center defines module rhythm for child pages | Pending |
| 3 | Money movement | Highest financial risk: deposit, withdraw, transfer, buy crypto | Pending |
| 4 | Asset and history | Dense data/list/detail rhythm depends on root and movement patterns | Pending |
| 5 | Address and safety | Masking, destructive actions, KYC, approvals, pending deposits | Pending |
| 6 | Wallet tools | Dust, network, multi-manager, gas, health | Pending |
| 7 | Full verification and artifact update | Confirm real visual alignment, not just widget tests | Pending |

## Phase 0: Evidence Reset

Tasks:

- [ ] Run route manifest check against `wallet_routes.dart`.
- [ ] Run Wallet action census.
- [ ] Run design-token and visual-density audits.
- [ ] Run `flutter test test/features/wallet --reporter=compact`.
- [ ] Capture current first-viewport screenshots or emulator notes for the
      highest-risk pages: `WalletPage`, `DepositPage`, `WithdrawPage`,
      `TransferPage`, `AddressAddPage`, `WalletTokenApprovalPage`.
- [ ] Update every page row in this plan with actual evidence, not assumptions.

Acceptance:

- [ ] Current visual debt is documented.
- [ ] No page is marked `Done` from tests alone.
- [ ] Every deferred item has a reason.

## Phase 1: Shared Wallet Visual Foundation

Goal: create or identify the smallest set of Wallet-local adapters needed to
apply Home rhythm consistently without inventing a second design system.

Inspect:

- `flutter_app/lib/shared/layout/`
- `flutter_app/lib/shared/widgets/`
- `flutter_app/lib/app/theme/`
- `flutter_app/lib/features/wallet/presentation/widgets/`

Required decisions:

- [ ] Standard Wallet page shell: `VitPageLayout` + `VitHeader` +
      `VitInsetScrollView` + `VitPageContent.compact`.
- [ ] Standard Wallet section rhythm: `VitSectionHeader` + compact card/list.
- [ ] Standard Wallet financial hero/context card.
- [ ] Standard Wallet form card using `VitInput`.
- [ ] Standard Wallet sheet panel using `VitSheetPanel`/shared sheet rhythm.
- [ ] Standard Wallet dense row for transaction/address/asset records.
- [ ] Standard Wallet high-risk preview block.

Do not add a shared abstraction unless at least two Wallet pages need the same
visual pattern and existing shared primitives cannot cover it.

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

- [ ] Replace local root section headers with `VitSectionHeader`.
- [ ] Normalize scroll to `VitInsetScrollView`.
- [ ] Ensure first viewport at 360 px shows balance context and primary CTAs.
- [ ] Ensure Deposit, Withdraw, Transfer, Buy, History, Address Book, Pending,
      Limits, Dust, Network, Analytics, Asset row taps all remain routed.
- [ ] Add visual/density assertions or screenshot notes.

Optimization:

- Prioritize scan speed: fewer oversized cards, more dense rows.
- Group secondary tools by user task: money movement, safety, optimization.
- Use tabular figures and concise labels.

Verification:

- [ ] `flutter test test/features/wallet/wallet_page_test.dart --reporter=compact`
- [ ] 360 px first-viewport check.
- [ ] Design-token and visual-density audit rows reviewed.

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

- [ ] Normalize shell to Home page contract.
- [ ] Use `VitSectionHeader` for Network, Deposit Address, Safety.
- [ ] Ensure address copy state is visible and not confused with a completed
      deposit.
- [ ] Keep asset-scoped route selected asset.
- [ ] Add empty/loading/offline visual states if provider can expose them.

Optimization:

- Put the selected network and minimum confirmation facts close to the address.
- Keep warning compact but visually stronger than normal info.

Verification:

- [ ] `flutter test test/features/wallet/deposit_page_test.dart --reporter=compact`
- [ ] 360 px address/copy/QR check.

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

- [ ] Ensure no withdrawal can bypass preview.
- [ ] Ensure disabled submit explains missing/invalid state.
- [ ] Show fee, receive amount, network, masked address, limit, and audit note
      before confirm.
- [ ] Give scan/address-book actions semantic labels.
- [ ] Check 360 px overflow for long address/network labels.

Optimization:

- Collapse secondary helper text under field labels.
- Keep max/all amount control close to amount field.
- Use danger/warning styling only for real risk.

Verification:

- [ ] `flutter test test/features/wallet/withdraw_page_test.dart --reporter=compact`
- [ ] High-risk state guardrail if touched.
- [ ] 360 px form and preview sheet check.

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

- [ ] Replace ad hoc scroll and local spacing with Home shell/tokens.
- [ ] Replace raw amount `TextField` with `VitInput` or document why not.
- [ ] Add field validation for empty, zero, and above available balance.
- [ ] Reorder safety copy so the user sees it before committing.
- [ ] Use shared selected-row treatment in wallet/asset pickers.
- [ ] Fix copy typos and awkward transfer info copy.
- [ ] Ensure first viewport shows source/destination and amount entry.

Optimization:

- Make transfer direction visually obvious with a compact connector or step
  treatment.
- Keep wallet balances secondary and tabular.
- Convert recent transfers into dense rows under a real section header.

Verification:

- [ ] `flutter test test/features/wallet/transfer_page_test.dart --reporter=compact`
- [ ] Add test for invalid amount/disabled explanation if implemented.
- [ ] 360 px screenshot/viewport review.

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

- [ ] Distinguish input, review, submitting, and success states visually.
- [ ] Keep fees, receive amount, provider, and payment method visible before
      confirmation.
- [ ] Ensure review back action is obvious.
- [ ] Prevent confirm state from looking like initial input state.

Optimization:

- Use compact preset amount chips.
- Put provider trust/risk details near the payment method, not below the fold.

Verification:

- [ ] `flutter test test/features/wallet/buy_crypto_page_test.dart --reporter=compact`
- [ ] 360 px review/success check.

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

- [ ] Use `VitTabBar`/shared chips for filters.
- [ ] Use dense rows rather than oversized cards.
- [ ] Keep row tap route to transaction detail.
- [ ] Export action must read as request/notice, not completed export.
- [ ] Empty state must be meaningful.

Optimization:

- Group status, amount, asset, network, and date into scan-friendly row zones.
- Use status text/icon, not color only.

Verification:

- [ ] `flutter test test/features/wallet/transaction_history_page_test.dart --reporter=compact`

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

- [ ] Use `VitInfoRow` for repeated facts.
- [ ] Copy actions need tooltip/semantics and visible copied state.
- [ ] Missing transaction state must use shared empty/error treatment.
- [ ] Back route remains history.

Optimization:

- Keep amount/status first, technical hashes below.
- Mask addresses where appropriate.

Verification:

- [ ] `flutter test test/features/wallet/transaction_detail_page_test.dart --reporter=compact`

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

- [ ] Use one hero context card with tabular balance/value.
- [ ] Deposit, withdraw, transfer, DCA routes preserve asset.
- [ ] Period controls fit at 360 px.
- [ ] Chart summary and transaction rows do not overflow.

Optimization:

- Use action tiles or compact CTA row matching Home density.
- Put market/portfolio context before long transaction history.

Verification:

- [ ] `flutter test test/features/wallet/asset_detail_page_test.dart --reporter=compact`

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

- [ ] Period and summary controls use shared tabs/chips.
- [ ] Positive/negative changes include text/icon context.
- [ ] Chart and metric cards are dense and tokenized.
- [ ] 360 px layout avoids clipped labels.

Optimization:

- Keep primary performance insight in first viewport.
- Push secondary breakdowns below the chart.

Verification:

- [ ] `flutter test test/features/wallet/portfolio_analytics_page_test.dart --reporter=compact`

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

- [ ] Saved addresses remain masked.
- [ ] Copy, favorite, edit, delete all have tooltip/semantics.
- [ ] Delete dialog uses destructive CTA styling.
- [ ] Add address route remains `/wallet/address-book/add`.
- [ ] Empty state includes add action.

Optimization:

- Use dense address rows; avoid oversized cards for every address.
- Keep security notice above list but compact.

Verification:

- [ ] `flutter test test/features/wallet/address_book_page_test.dart --reporter=compact`

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

- [ ] Use `VitInput` for label/address fields.
- [ ] Paste/scan actions have semantic labels and feedback.
- [ ] Cannot save without required fields and agreement.
- [ ] Preview shows asset, network, masked address, risk note, and next step.
- [ ] Success returns to address book.

Optimization:

- Keep risk/agreement close to the CTA.
- Make preview sheet visually distinct from the input state.

Verification:

- [ ] `flutter test test/features/wallet/address_add_page_test.dart --reporter=compact`

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

- [ ] Pending status cannot look completed.
- [ ] Confirmation count/status is readable.
- [ ] Copy actions are accessible.
- [ ] Refresh has visible feedback.

Optimization:

- Make required confirmations and elapsed time the row focus.
- Use status pill text plus icon.

Verification:

- [ ] `flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact`

### 5.4 `WithdrawLimitsPage`

Files:

- `flutter_app/lib/features/wallet/presentation/pages/withdraw_limits_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_common.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_sections.dart`
- `flutter_app/test/features/wallet/withdraw_limits_page_test.dart`

Redesign target:

- Header -> current limit summary -> usage bars -> KYC tier ladder -> FAQ.

Must fix:

- [ ] KYC route remains clear and does not imply upgrade is complete.
- [ ] Used daily/monthly limits remain visible.
- [ ] Locked/current/available tiers are distinguishable beyond color.
- [ ] FAQ rows are either expandable or clearly static.

Optimization:

- Keep current tier and usage in the first viewport.
- Use tabular money and concise limit labels.

Verification:

- [ ] `flutter test test/features/wallet/withdraw_limits_page_test.dart --reporter=compact`

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

- [ ] Active/history/settings tabs use `VitTabBar`.
- [ ] Risk levels are text/icon/pill based, not color only.
- [ ] Unlimited approvals are visually urgent.
- [ ] Revoke all and individual revoke remain preview plus confirm.
- [ ] Settings toggles are accessible.

Optimization:

- Prefer dense approval rows over bulky cards.
- Keep highest risk approvals above less urgent history/settings content.

Verification:

- [ ] `flutter test test/features/wallet/wallet_token_approval_page_test.dart --reporter=compact`

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

- [ ] Fee and receive amount visible before confirmation.
- [ ] Disabled state explains why conversion cannot continue.
- [ ] Selected assets are distinguishable beyond color.
- [ ] Confirmation cancel/submit are clearly separated.

Optimization:

- Use dense selectable rows; reserve hero emphasis for the total receive amount.

Verification:

- [ ] `flutter test test/features/wallet/dust_converter_page_test.dart --reporter=compact`

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

- [ ] Congestion, latency, fees, and confirmations are readable.
- [ ] Network status is not color-only.
- [ ] Refresh action has tooltip/semantic label and visible feedback.
- [ ] Legend is compact and does not dominate first viewport.

Optimization:

- Put the worst network/most actionable status first if data supports it.
- Use status pills and tabular fee/latency values.

Verification:

- [ ] `flutter test test/features/wallet/network_status_page_test.dart --reporter=compact`

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

- [ ] Sensitive wallet addresses remain masked by default.
- [ ] Reveal/copy actions have explicit labels and semantics.
- [ ] Add wallet action is not a no-op and has clear future state if deferred.
- [ ] Tabs fit at 360 px.
- [ ] Distribution chart does not push core actions below first viewport.

Optimization:

- Treat chart as secondary insight, not the first task.
- Keep all wallet rows dense and comparable.

Verification:

- [ ] `flutter test test/features/wallet/wallet_multi_manager_page_test.dart --reporter=compact`

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

- [ ] Gas recommendations do not imply guaranteed savings.
- [ ] Fee levels are readable and not color-only.
- [ ] Refresh action has accessible label and visible feedback.
- [ ] Current/trends/tips use consistent tabs/sections.

Optimization:

- Put recommended speed and estimated fee in first viewport.
- Keep tips compact and action-oriented.

Verification:

- [ ] `flutter test test/features/wallet/wallet_gas_optimizer_page_test.dart --reporter=compact`

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

- [ ] Health score is advisory, not absolute financial advice.
- [ ] Recommendations are clear and actionable.
- [ ] Chart/legend information is readable beyond color.
- [ ] Recommendation sheet has clear close and CTA behavior.

Optimization:

- Put the most important health recommendation in the first viewport.
- Keep diversification/security sections dense and scannable.

Verification:

- [ ] `flutter test test/features/wallet/wallet_health_score_page_test.dart --reporter=compact`

## Per-Page Progress Ledger

Update this table only with evidence from the current redesign pass.

| Page | Route(s) | Pattern | Priority | Status | Evidence required before Done |
| --- | --- | --- | --- | --- | --- |
| `WalletPage` | `/wallet` | Financial command center | P0 | Pending | Focused test, 360 px screenshot, token/density audit, action census, GitNexus detect |
| `DepositPage` | `/wallet/deposit`, `/wallet/deposit/:asset` | Money movement receive flow | P0 | Pending | Focused test, QR/address viewport, sheet review, safety copy review |
| `WithdrawPage` | `/wallet/withdraw`, `/wallet/withdraw/:asset` | High-risk withdrawal form | P0 | Pending | Focused test, high-risk preview review, 360 px form/sheet review |
| `TransferPage` | `/wallet/transfer` | Internal transfer form | P0 | Pending | Focused test, invalid amount test, 360 px form/sheet review, copy polish |
| `BuyCryptoPage` | `/wallet/buy-crypto` | Buy/review/success flow | P0 | Pending | Focused test, review/success visual review, fee/provider copy |
| `TransactionHistoryPage` | `/wallet/history` | Dense transaction list | P1 | Pending | Focused test, filter/list density review |
| `TransactionDetailPage` | `/wallet/transaction/:txId` | Receipt/detail page | P1 | Pending | Focused test, copy/support/missing state review |
| `AssetDetailPage` | `/wallet/asset/:assetId` | Asset detail hub | P1 | Pending | Focused test, asset CTAs, chart/row density review |
| `PortfolioAnalyticsPage` | `/wallet/portfolio-analytics` | Analytics summary | P1 | Pending | Focused test, chart/period control 360 px review |
| `AddressBookPage` | `/wallet/address-book` | Saved address safety list | P0 | Pending | Focused test, destructive dialog review, masking review |
| `AddressAddPage` | `/wallet/address-book/add` | High-risk address form | P0 | Pending | Focused test, preview/agreement review, masking review |
| `PendingDepositsPage` | `/wallet/pending-deposits` | Pending status list | P1 | Pending | Focused test, status/copy/empty state review |
| `WithdrawLimitsPage` | `/wallet/limits` | Limit/KYC ladder | P1 | Pending | Focused test, tier state review, KYC route review |
| `WalletTokenApprovalPage` | `/wallet/token-approval` | High-risk approval management | P0 | Pending | Focused test, revoke preview, risk-state review |
| `DustConverterPage` | `/wallet/dust-converter` | Conversion preview flow | P1 | Pending | Focused test, fee/receive/confirm review |
| `NetworkStatusPage` | `/wallet/network-status` | Network health dashboard | P2 | Pending | Focused test, status-not-color-only review |
| `WalletMultiManagerPage` | `/wallet/multi-manager` | Multi-wallet management | P1 | Pending | Focused test, masking/reveal/copy review |
| `WalletGasOptimizerPage` | `/wallet/gas-optimizer` | Gas recommendation tool | P2 | Pending | Focused test, non-guaranteed savings copy |
| `WalletHealthScorePage` | `/wallet/health-score` | Advisory health score | P2 | Pending | Focused test, advisory/copy/chart review |

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

## Definition Of Done

Wallet Home-standard redesign is complete only when:

- [ ] All 21 Wallet routes are covered.
- [ ] All 19 primary Wallet page classes are covered.
- [ ] Every page has a completed action inventory.
- [ ] Every page has a Home pattern classification.
- [ ] Every local composition has an L3 reason or was replaced by shared
      primitives.
- [ ] Every page passes focused tests.
- [ ] Wallet focused test folder passes.
- [ ] `flutter analyze` passes.
- [ ] Route coverage passes.
- [ ] Design-token audit passes or has documented unrelated artifact blockers.
- [ ] Visual-density audit passes or has documented unrelated artifact blockers.
- [ ] 360 px first-viewport review is recorded for every page.
- [ ] High-risk flows preserve preview, confirm, fees, limits, masking, risk,
      and next-step copy.
- [ ] P2P Wallet remains excluded.
- [ ] GitNexus `detect_changes()` confirms the expected scope before commit.

## Current Known Blockers And Warnings

- The worktree has many unrelated uncommitted changes. Do not treat broad git
  status noise as evidence for or against Wallet visual work.
- Prior full `dart format .`, navigation audit, and full test suite failures
  were tied to stale/generated artifacts outside the immediate Wallet visual
  pass. Re-run and classify them again before final commit.
- Passing `flutter test test/features/wallet --reporter=compact` is necessary
  but not sufficient for UI standardization.
- Do not mark `UI standardized: Yes` unless this plan's verification gates are
  satisfied.
