# VitTrade Home UI Project-Wide Standardization Deep Plan

Updated: 2026-06-27
Status: Planning contract for the next UI synchronization pass
Scope: Flutter UI under `flutter_app/lib/features/`, shared UI primitives under
`flutter_app/lib/shared/`, app theme tokens under `flutter_app/lib/app/theme/`,
and verification artifacts under `docs/02_FLUTTER_MIGRATION/`.

This plan extends the lessons from
`docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md` to the whole
Flutter app. Wallet remains the proven rollout reference. Home remains the
visual source of truth. This file is the operational plan for applying the same
standard across remaining modules without weakening product safety, routing,
tests, or module boundaries.

## 1. Why This Plan Exists

The Wallet plan successfully proved that a feature cannot be marked visually
standardized from widget tests alone. It introduced a stronger completion model:
Home-derived layout, first-viewport density, shared primitives, token-only
styling, action census, GitNexus impact evidence, focused tests, analyzer, and
audit evidence.

That model should now become the project-wide UI process. The current app is
already much cleaner than the older enterprise UI/UX plan snapshots, but the
latest audits still show residual work:

- Wallet token debt is `0`, so Wallet is the reference implementation, not the
  main cleanup target.
- Typography debt is `0` across all modules.
- Route coverage is current.
- Visual density has no P0/P1 normal-screen failures.
- Residual token debt is concentrated in P2P, with one Earn root bundle and two
  Trade root bundles still showing root-page bundle debt.
- Five fullscreen tool screens still require explicit manual visual QA.
- Five medium density review items remain, including four Wallet follow-ups and
  one Earn notifications surface.

The goal is not to redesign the app again from scratch. The goal is to finish
the remaining inconsistencies, preserve the Home/Wallet standard, and make the
entire project feel like one professional trading product.

## 2. Source Priority

Use this order when documents or code disagree:

1. Current user instruction.
2. `AGENTS.md`.
3. `docs/00_START_HERE.md`.
4. Current Flutter source under `flutter_app/lib/`.
5. Current Flutter tests under `flutter_app/test/`.
6. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`.
7. `docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md`.
8. `docs/03_DESIGN_SYSTEM/Guidelines.md`.
9. Audit artifacts under `docs/02_FLUTTER_MIGRATION/`.

If visual consistency conflicts with financial safety, financial safety wins.
If a historical plan conflicts with current Flutter source/tests/audits, inspect
source/tests/audits and update stale docs when in scope.

## 3. Wallet Plan Analysis

### 3.1 What The Wallet Plan Gets Right

- It resets the meaning of "Done". Rendering and taps are not enough.
- It defines Home as a pattern library, not a business-logic source.
- It gives a concrete page rhythm:
  header -> hero/context -> primary actions -> status/safety -> tools/tabs ->
  dense lists/details -> secondary discovery -> bottom-safe end.
- It maps UI needs to shared primitives such as `VitPageLayout`,
  `VitInsetScrollView`, `VitPageContent`, `VitSectionHeader`, `VitCard`,
  `VitCtaButton`, `VitInput`, `VitTabBar`, `VitStatusPill`,
  `VitHighRiskStatePanel`, and shared sheets.
- It requires first-viewport usefulness at 360 px width.
- It treats financial safety as a non-negotiable gate: masking, fees, limits,
  risk, preview, confirm, and next steps.
- It uses a per-page route manifest and evidence ledger so work cannot silently
  skip route variants.
- It requires action census before edits and GitNexus `detect_changes()` before
  commit.
- It preserves P2P Wallet as out of scope, which protects module boundaries.

### 3.2 What Must Change For Whole-App Use

The Wallet plan is feature-specific. A whole-app rollout needs extra structure:

- A module inventory, not only a Wallet route manifest.
- A screen taxonomy that covers root modules, detail pages, high-risk forms,
  fullscreen tools, auth/onboarding exceptions, market/data rows, and
  points-only Arena surfaces.
- A current audit baseline before every sprint, because the active worktree and
  audit artifacts can move quickly.
- A residual debt queue driven by audit output, not by historical plan status.
- A policy for fullscreen tools: do not force normal card density onto chart,
  terminal, chat, or state-showcase tools, but require safe-area and nonblank
  visual QA.
- A product-boundary matrix for Wallet, P2P, Trade, Predictions, Arena, Earn,
  Launchpad, DCA, and cross-module discovery.
- A closure model that handles "token clean but visually sparse" screens. These
  need density review, not wholesale redesign.

### 3.3 Wallet Plan Lessons To Reuse Exactly

- Work one screen or a tightly coupled screen pair at a time.
- Keep route names, keys, providers, and flow states stable.
- Replace local visual systems with shared primitives by pattern.
- Keep L3 local composition only when it owns domain state, route decisions,
  copy boundaries, financial safety, chart/canvas rendering, or tool behavior.
- Add or update focused tests for every new visual, behavior, or safety
  contract.
- Record evidence immediately after each batch.

## 4. Current Baseline Snapshot

Captured on 2026-06-27 from the current workspace.

### 4.1 Inventory

Feature source inventory:

| Feature | Page entries | Page parts | Widgets | Tests |
| --- | ---: | ---: | ---: | ---: |
| trade | 86 | 33 | 215 | 90 |
| p2p | 71 | 25 | 93 | 72 |
| earn | 68 | 47 | 138 | 69 |
| arena | 26 | 35 | 45 | 27 |
| launchpad | 24 | 16 | 68 | 25 |
| markets | 21 | 16 | 65 | 22 |
| wallet | 19 | 3 | 70 | 20 |
| predictions | 17 | 8 | 59 | 18 |
| dca | 12 | 18 | 30 | 13 |
| profile | 11 | 0 | 29 | 12 |
| auth | 6 | 0 | 9 | 7 |
| admin | 5 | 0 | 10 | 6 |
| referral | 5 | 7 | 4 | 6 |
| cross_module | 4 | 3 | 14 | 5 |
| dev | 4 | 0 | 15 | 5 |
| support | 3 | 0 | 8 | 4 |
| discovery | 2 | 0 | 9 | 3 |
| home | 1 | 3 | 0 | 3 |
| news | 1 | 0 | 2 | 2 |
| notifications | 1 | 0 | 2 | 2 |
| onboarding | 1 | 3 | 0 | 2 |
| rewards | 1 | 0 | 0 | 2 |
| enterprise_states | 1 | 0 | 3 | 2 |

Route group counts:

| Route group | GoRoute count |
| --- | ---: |
| trade_routes | 91 |
| p2p_routes | 79 |
| earn_routes | 70 |
| arena_routes | 26 |
| launchpad_routes | 24 |
| markets_routes | 22 |
| utility_routes | 21 |
| wallet_routes | 21 |
| predictions_routes | 18 |
| profile_routes | 14 |
| dca_routes | 13 |
| auth_routes | 8 |
| admin_routes | 5 |
| support_routes | 3 |
| home_routes | 2 |

### 4.2 Audit Results

Commands run from `flutter_app/`:

```bash
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
```

Results:

- Route coverage artifact is current.
- Design-token artifacts are current.
- `total_debt=374`.
- `scope_root_page_bundle_summary_debt=176`.
- `scope_shared_layout_debt=0`.
- `scope_shared_widget_debt=1`.
- `p0_wallet_debt=0/759 pass`.
- `p0_trade_debt=2/9072 pass`.
- `p0_p2p_debt=173/1911 pass`.
- `p0_markets_debt=6/2042 pass`.
- `p0_profile_debt=0/1037 pass`.
- `strict_typography_gate=zero_residual pass`.
- Visual density: `P0_CRITICAL_DENSITY_REVIEW=0`,
  `P1_HIGH_DENSITY_REVIEW=0`, `P1_TOOL_VISUAL_QA=5`,
  `P2_MEDIUM_DENSITY_REVIEW=5`, `P3_LOW_DENSITY_REVIEW=168`,
  `PASS_MONITOR=236`.

### 4.3 Residual Token Debt Queue

Root-page bundle debt is concentrated here:

| Feature | Root bundles with debt | Root bundle debt |
| --- | ---: | ---: |
| p2p | 51 | 166 |
| earn | 1 | 8 |
| trade | 2 | 2 |

Highest residual pages:

| Feature | Debt | Page bundle |
| --- | ---: | --- |
| p2p | 8 | `p2p_my_ads_page.dart` |
| earn | 8 | `staking_earn_page.dart` |
| p2p | 8 | `p2p_selfie_verification_page.dart` |
| p2p | 7 | `p2p_insurance_certificate_page.dart` |
| p2p | 6 | `p2p_blacklist_page.dart` |
| p2p | 6 | `p2p_payment_methods_page.dart` |
| p2p | 6 | `p2p_payment_method_add_page.dart` |
| p2p | 6 | `p2p_fraud_prevention_page.dart` |
| p2p | 6 | `p2p_escrow_detail_page.dart` |
| p2p | 6 | `p2p_my_orders_page.dart` |

### 4.4 Visual Density Queue

Fullscreen tool QA:

| Feature | Page | Route | Required action |
| --- | --- | --- | --- |
| trade | `FuturesPage` | `/trade/:pairId/futures` | Emulator visual QA for safe areas, controls, nonblank render, bottom clearance |
| trade | `TradingBotsPage` | `AppRoutePaths.tradeBots` | Tool exception QA and evidence |
| trade | `AdvancedChartPage` | `/trade/advanced-chart/:pairId` | Chart/tool QA and evidence |
| enterprise_states | `EnterpriseStatesPage` | `AppRoutePaths.enterpriseStates` | Showcase/tool QA and evidence |
| p2p | `P2PChatPage` | `/p2p/chat/:orderId` | Chat tool QA and evidence |

Medium density review:

| Feature | Page | Route | Required action |
| --- | --- | --- | --- |
| wallet | `AddressBookPage` | `AppRoutePaths.walletAddressBook` | Recheck first repeated/actionable section above bottom nav |
| wallet | `AssetDetailPage` | `/wallet/asset/:assetId` | Recheck vertical gaps and bottom clearance |
| wallet | `TransactionHistoryPage` | `AppRoutePaths.walletHistory` | Recheck first-row visibility and bottom clearance |
| wallet | `TransactionDetailPage` | `/wallet/transaction/:txId` | Recheck receipt content above chrome |
| earn | `SavingsNotificationsPage` | `AppRoutePaths.earnSavingsNotifications` | Reduce tall tokenized cards/gaps if visual QA confirms sparsity |

## 5. Home UI Standard Contract

Do not copy Home business logic, Home data order, campaign copy, or portfolio
state into other modules. Reuse the visual grammar:

```text
module header
-> module hero or primary context
-> primary action cluster
-> resume/status/safety card
-> tools, filters, tabs, or selectors
-> dense lists, records, or details
-> secondary discovery or support
-> bottom-nav-safe content end
```

Required shell and content rules:

- Root module pages use `VitTopChrome` only when they are true module roots.
- Detail pages use `VitHeader`.
- Standard content uses `VitPageLayout`, `VitAutoHideHeaderScaffold` where
  appropriate, `VitInsetScrollView`, and compact `VitPageContent`.
- Bottom clearance comes from shell-aware inset logic, not ad hoc bottom
  padding.
- First viewport at 360 px must show module identity, primary context, and at
  least one action or useful repeated row.
- Dense lists use rows, dividers, tabs, and section rhythm rather than stacked
  oversized cards.

Required component mapping:

| Need | Required pattern |
| --- | --- |
| Page shell | `VitPageLayout`, `VitPageContent`, `VitInsetScrollView` |
| Header | `VitTopChrome` for true roots, `VitHeader` for detail/module routes |
| Section title | `VitSectionHeader` |
| Surface | `VitCard` variants and shared sheet panels |
| Primary action | `VitCtaButton` with icon when useful |
| Icon action | `VitIconButton`, `VitInlineIconAction`, or header actions with tooltip/semantics |
| Action grid | `VitActionTileGrid`, `VitServiceTile` |
| Form/search | `VitInput`, `VitSearchBar` |
| Tabs | `VitTabBar` |
| Status | `VitStatusPill`, `VitAccentPill`, `VitMetricDeltaPill` |
| State | `VitSkeleton`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner` |
| Risk | `VitHighRiskStatePanel` plus preview/confirm when needed |
| Detail rows | `VitInfoRow` or an approved shared equivalent |
| Market/data rows | `VitMarketTickerStrip`, `VitMarketPairRow`, `VitRankedAssetRow`, `VitAssetAvatar`, `VitSparkline` |
| Discovery bridge | `VitDiscoveryActionCard` with explicit module-boundary copy |

Token rules:

- Use `AppColors`, `AppSpacing`, `AppRadii`, `AppTextStyles`,
  `AppModuleAccents`, and shared component density variants.
- Keep module accent as an accent layer only.
- Keep green/red for semantic buy/sell or positive/negative movement.
- Money, balances, limits, prices, gas, probability, APY, P/L, IDs, hashes, and
  percentages use tabular numeric styling.
- Do not introduce local page-level color palettes, raw spacing systems, raw
  radius systems, local `TextStyle(fontSize: ...)`, or repeated local cards.

## 6. Product Safety Boundaries

### 6.1 Financial And Account Safety

Preview and confirmation are required for:

- Withdrawals.
- Escrow release.
- Security changes.
- 2FA disabling or reset-like flows.
- Address additions.
- P2P payment-method changes.
- DCA/rebalance submit flows.
- Earn subscription/redemption or lockup decisions.
- Launchpad subscription/allocation/claim decisions when risk or eligibility is
  involved.

Every high-risk action must show:

- Fees.
- Limits.
- Risks.
- Masked sensitive values.
- Confirmation state.
- Result or next steps.
- Support route or recovery path when failure is possible.

### 6.2 Prediction Markets And Open Arena

Prediction Markets and Open Arena stay separate:

| Boundary | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL, positions, probability | Points pool, completion, fair play |
| History | Orders, receipts | Ledger entries |
| Leaderboard | Trading context | Fair play and completion |

Allowed bridges are topic/category, event context, creator discovery, search,
discovery, and profile sections with clearly separated content.

Arena pages must not use wallet, payout, profit, P/L, USD return, or
stake-return language. Prediction pages may use positions, probability,
receipt, rewards, and P/L without casino or hype copy.

## 7. Rollout Phases

### Phase 0 - Evidence Freeze And Graph Refresh

Description: Lock the current baseline before touching UI code.

Acceptance criteria:

- [ ] Git worktree is reviewed and unrelated dirty changes are not modified.
- [ ] GitNexus index is refreshed or stale status is recorded before any code
      edits.
- [ ] Route coverage, design-token, and visual-density audits are current.
- [ ] Residual debt queue is regenerated from CSV artifacts.
- [ ] Screens selected for the first batch are small enough for one focused
      session.

Verification:

```bash
node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
```

Dependencies: None.

Estimated scope: Docs and audit-only preflight.

### Phase 1 - P2P Token Residual Cleanup

Description: Clear the 51 P2P root bundles that still carry token debt while
preserving escrow, payment, KYC, merchant, dispute, chat, and masking rules.

Batch slicing:

1. Payment methods and ownership:
   `p2p_payment_methods_page.dart`,
   `p2p_payment_method_add_page.dart`,
   `p2p_payment_method_ownership_page.dart`,
   `p2p_payment_method_verification_page.dart`,
   `p2p_payment_method_cooling_period_page.dart`,
   `p2p_payment_method_history_page.dart`.
2. Escrow and order actions:
   `p2p_escrow_detail_page.dart`, `p2p_escrow_balance_page.dart`,
   `p2p_order_page.dart`, `p2p_order_book_page.dart`, `p2p_my_orders_page.dart`,
   `p2p_order_rate_page.dart`.
3. Identity, KYC, and verification:
   `p2p_selfie_verification_page.dart`,
   `p2p_video_verification_page.dart`, `p2p_address_proof_page.dart`,
   `p2p_kyc_status_page.dart`, `p2p_kyc_requirements_page.dart`.
4. Risk, fraud, compliance, and limits:
   `p2p_fraud_prevention_page.dart`, `p2p_risk_assessment_page.dart`,
   `p2p_limit_tracker_page.dart`, `p2p_transaction_limits_page.dart`,
   `p2p_large_transaction_justification_page.dart`,
   `p2p_aml_screening_page.dart`, `p2p_compliance_overview_page.dart`.
5. Merchant and ad management:
   `p2p_my_ads_page.dart`, `p2p_create_ad_page.dart`,
   `p2p_merchant_profile_page.dart`, merchant apply/profile subflows.
6. Account, security, settings, tax:
   `p2p_settings_page.dart`, `p2p_2fa_settings_page.dart`,
   `p2p_device_management_page.dart`, `p2p_blacklist_page.dart`,
   `p2p_notifications_settings_page.dart`, `p2p_tax_reporting_page.dart`.

Acceptance criteria:

- [ ] No new raw local `EdgeInsets`, raw colors, local radii, local repeated
      cards, or typography debt in touched P2P page bundles.
- [ ] Payment-method and escrow flows keep preview/confirm and masked account
      data.
- [ ] Order/dispute flows preserve next-step copy and support paths.
- [ ] `p0_p2p_debt` decreases after every batch and eventually reaches `0` or a
      documented, reviewed L3 exception.
- [ ] P2P Chat remains a fullscreen tool exception with manual visual QA rather
      than being forced into normal page rhythm.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib/features/p2p test/features/p2p
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/p2p --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Dependencies: Phase 0.

Estimated scope: 8 to 12 small batches, 3 to 6 screens per batch.

### Phase 2 - Earn And Trade Residual Token Cleanup

Description: Clear the last non-P2P root-bundle token residuals:
`staking_earn_page.dart` and two Trade bundles.

Acceptance criteria:

- [ ] Earn staking root keeps APY, lockup, risk, redemption, and no guaranteed
      return copy.
- [ ] Trade residual pages keep trading safety and regulatory language.
- [ ] `p0_trade_debt` reaches `0`.
- [ ] Earn root-bundle debt reaches `0` or has an explicit L3 exception.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib/features/earn lib/features/trade test/features/earn test/features/trade
dart run tool/design_token_consistency_audit.dart --check
flutter test test/features/earn --reporter=compact
flutter test test/features/trade --reporter=compact
flutter analyze
```

Dependencies: Phase 0.

Estimated scope: 1 to 2 small batches.

### Phase 3 - Wallet And Earn Medium Density Review

Description: Treat the five `P2_MEDIUM_DENSITY_REVIEW` items as visual-density
follow-ups, not full redesigns. Wallet is already Home-standard and token-clean,
so edits must be minimal and evidence-driven.

Target pages:

- `AddressBookPage`.
- `AssetDetailPage`.
- `TransactionHistoryPage`.
- `TransactionDetailPage`.
- `SavingsNotificationsPage`.

Acceptance criteria:

- [ ] 360 px first viewport shows useful context/action/list content.
- [ ] Bottom nav does not cover rows, receipts, copy actions, or disclosures.
- [ ] Any spacing reduction preserves readability, touch targets, and safety
      copy.
- [ ] Wallet remains `p0_wallet_debt=0`.
- [ ] Existing Wallet focused tests and Earn focused tests still pass.

Verification:

```bash
cd flutter_app
dart run tool/visual_density_risk_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
flutter test test/features/wallet --reporter=compact
flutter test test/features/earn --reporter=compact
flutter analyze
```

Dependencies: Phase 0.

Estimated scope: 2 small batches.

### Phase 4 - Fullscreen Tool Visual QA

Description: Validate fullscreen tool exceptions. These screens may remain L3
tool layouts, but they need explicit emulator/visual evidence.

Target pages:

- `FuturesPage`.
- `TradingBotsPage`.
- `AdvancedChartPage`.
- `EnterpriseStatesPage`.
- `P2PChatPage`.

Acceptance criteria:

- [ ] Tool renders nonblank content.
- [ ] Primary controls are visible and reachable at phone width.
- [ ] Safe areas and bottom chrome do not hide controls.
- [ ] Back/close behavior is clear.
- [ ] Tool exception and L3 reasons are recorded.
- [ ] No normal content page uses the tool exception to avoid cleanup.

Verification:

```bash
cd flutter_app
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/trade --reporter=compact
flutter test test/features/p2p --reporter=compact
flutter test test/features/enterprise_states --reporter=compact
flutter analyze
```

Manual or emulator screenshot evidence is required for this phase.

Dependencies: Phase 0.

Estimated scope: 1 QA-focused batch, with code edits only if QA finds actual
safe-area or rendering problems.

### Phase 5 - P3 Low Density Triage

Description: Review the 168 `P3_LOW_DENSITY_REVIEW` screens by module, focusing
on repeated root causes rather than micro-tuning every page.

Priority order:

1. Earn: 51 low-density screens.
2. Trade: 21 low-density screens.
3. Launchpad: 21 low-density screens.
4. Wallet: 14 low-density screens.
5. P2P: 12 low-density screens after token cleanup.
6. Profile, DCA, Predictions, Auth, Admin, Markets, and secondary modules.

Acceptance criteria:

- [ ] Root cause is classified before editing: bottom inset pressure, fixed
      height pressure, vertical gap accumulation, sparse shared-component use,
      or official audit blind spot.
- [ ] Only repeated/systemic issues are fixed in this phase.
- [ ] Screens already passing product safety and first viewport are not churned.
- [ ] Representative modules still feel visually related to Home/Wallet.

Verification:

```bash
cd flutter_app
dart run tool/visual_density_risk_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
flutter analyze
flutter test test/features/<module> --reporter=compact
```

Dependencies: Phases 1 to 4.

Estimated scope: Rolling cleanup, 4 to 6 screens per module batch.

### Phase 6 - Product Boundary And Copy Polish

Description: Review copy and state language after visual cleanup, especially
where shared discovery or shared cards bridge modules.

Acceptance criteria:

- [ ] Arena remains points-only.
- [ ] Prediction Markets remain wallet/value-based and do not borrow Arena
      points language.
- [ ] Trade, P2P, Earn, DCA, Launchpad, and Wallet avoid hype, casino, FOMO,
      hidden-fee, guaranteed-return, and unclear-risk copy.
- [ ] Vietnamese/English copy is typo-free and not mojibake in source or UI.
- [ ] Empty, loading, error, offline, submitting, success, and result states
      have clear next steps.

Verification:

```bash
cd flutter_app
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter analyze
```

Dependencies: Visual cleanup phases for the touched modules.

Estimated scope: 1 to 3 copy-focused batches.

### Phase 7 - Global Visual QA And Closure

Description: Validate the app as one product, not as a set of isolated passing
modules.

Representative QA set:

- Root tabs: Home, Markets, Trade, Wallet, Profile.
- Wallet: Wallet, Deposit, Transfer, Address Add, Token Approval.
- P2P: Home, order book, order detail, payment methods, escrow/dispute, chat.
- Trade: instrument workspace, futures, bots, order/risk, copy-trading safety.
- Earn: staking root, product detail, auto-compound, withdrawal policy.
- Launchpad: project detail, subscribe/allocation, claim receipt.
- Predictions: event detail, position/portfolio, receipt/history.
- Arena: home, challenge detail, join, points ledger, safety/reporting.
- Auth/Profile: login/register/OTP/reset/2FA, KYC/security/API/account.

Acceptance criteria:

- [ ] Route coverage passes.
- [ ] Design-token audit passes with no unexpected residual debt.
- [ ] Visual-density audit has no P0/P1 normal-screen issues.
- [ ] Tool QA evidence is recorded.
- [ ] Full focused suites pass for touched modules.
- [ ] Full `flutter test --reporter=compact` passes before merge/milestone.
- [ ] GitNexus `detect_changes()` confirms expected affected scope.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

Dependencies: Phases 1 to 6.

Estimated scope: Final QA and docs update.

## 8. Per-Batch Workflow

Use this exact workflow for every implementation batch:

```text
Batch ID:
Module:
Target screens:
Routes:
Current audit rows:
Target Home pattern:
Safety boundary:

Before editing:
- Read AGENTS.md, docs/00_START_HERE.md, the Home rollout playbook, this plan,
  target pages/widgets/controllers/providers/tests, and relevant audit rows.
- Confirm GitNexus index status.
- Run GitNexus context for each target page class.
- Run GitNexus impact before editing any class, method, shared primitive,
  router file, provider, controller, repository, domain entity, or helper.
- Run scoped action census for target files.
- Record current Home-standard gap and any L3 reason.

Implement:
- Apply Home shell/content rhythm.
- Use shared primitives by pattern.
- Preserve routes, names, keys, providers, masking, fees, limits,
  preview/confirm, copy boundaries, and tests.
- Keep local composition only with an L3 reason.
- Add/update focused tests for new visual, state, accessibility, or safety
  contracts.

After editing:
- Run dart format on touched Dart files.
- Run focused feature tests.
- Run design-token and visual-density audits when layout/tokens/density change.
- Run flutter analyze.
- Run GitNexus detect_changes.
- Update the batch log or plan evidence with command results and residual risk.
```

Scoped action census template:

```powershell
rg -n "VitCtaButton|IconButton|VitInlineIconAction|VitServiceTile|VitActionTileGrid|onTap:|onPressed:|showModalBottomSheet|showDialog|GestureDetector|InkWell|tabKey|filterKey|searchKey|confirm|preview|revoke|copy|scan|refresh|submit" <target page/widget files>
```

## 9. Definition Of Done

A screen is Home-standard when:

- [ ] It uses shared shell/layout primitives or has a documented fullscreen,
      auth, onboarding, or tool exception.
- [ ] It uses shared visual primitives by pattern.
- [ ] It has no token debt unless an L3 exception is documented and accepted.
- [ ] It has no typography debt.
- [ ] 360 px first viewport shows module identity, primary context, and at
      least one useful action or repeated row.
- [ ] Bottom nav and safe areas do not cover text, controls, receipts, forms,
      or disclosures.
- [ ] Loading, empty, error, offline, submitting, and success/result states are
      present where the flow can enter those states.
- [ ] High-risk actions show fees, risk, limits, masked data, preview,
      confirmation, and next steps.
- [ ] Arena and Prediction Markets copy remain separated.
- [ ] Focused feature tests and analyzer pass.

A module is Home-standard when:

- [ ] All routed screens are accounted for.
- [ ] Root-page bundle token debt is `0` or only accepted L3/tool exceptions
      remain.
- [ ] Module focused tests pass.
- [ ] Product copy and safety boundaries pass.
- [ ] Representative visual QA is recorded for first viewport, high-risk flows,
      and fullscreen tools.

The whole project is Home-standard when:

- [ ] Route coverage passes.
- [ ] Design-token audit passes with no unexpected root-bundle residuals.
- [ ] Typography residuals remain `0`.
- [ ] Visual-density audit has no P0/P1 normal-screen issues and all tool QA
      exceptions are documented.
- [ ] Wallet remains token-clean and Home-aligned.
- [ ] P2P, Trade, Wallet, Earn, Launchpad, Predictions, DCA, Arena, Markets,
      Profile, and Auth all preserve their product boundaries and safety flows.
- [ ] Full test suite passes.
- [ ] GitNexus `detect_changes()` shows expected scope before commit.

## 10. Risks And Controls

| Risk | Impact | Control |
| --- | --- | --- |
| Treating old plan status as current truth | Skips real residual debt | Regenerate audit queues before each sprint |
| Editing broad shared primitives without impact analysis | App-wide regressions | Run GitNexus impact, warn on HIGH/CRITICAL, add focused + full tests |
| Over-compacting financial flows | Hidden risk/fees/limits | Safety copy beats density; keep high-risk panels and confirmations |
| Forcing normal page rhythm onto tool screens | Broken chart/chat/terminal UX | Keep L3 tool exception with emulator evidence |
| Mixing Arena and Predictions | Product/legal trust issue | Run copy guardrails and manual boundary review |
| Churning Wallet after completion | Regression in proven reference module | Treat Wallet medium density as follow-up only, with focused tests |
| Dirty worktree conflict | Accidental overwrite | Edit only scoped files and never revert unrelated changes |
| Stale GitNexus index | Wrong blast-radius decisions | Refresh or record staleness before code edits |

## 11. Immediate Next Step

Start with Phase 0, then Phase 1 P2P residual cleanup.

Recommended first implementation batch:

```text
Batch ID: P2P-HOME-01
Target module: p2p
Target screens:
- p2p_payment_methods_page.dart
- p2p_payment_method_add_page.dart
- p2p_payment_method_ownership_page.dart
- p2p_payment_method_verification_page.dart

Reason:
- P2P owns almost all remaining root-page bundle token debt.
- Payment-method changes are high-risk and must inherit Wallet's safety
  preview/confirm/masking discipline.
- The batch is coherent, testable, and small enough to complete with focused
  verification.
```

Do not start by "fixing the whole app UI" in one pass. The enterprise-safe path
is audit baseline -> one module batch -> focused tests -> audits -> evidence ->
next batch.
