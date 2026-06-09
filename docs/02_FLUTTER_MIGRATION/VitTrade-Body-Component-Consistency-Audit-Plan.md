# VitTrade Body Component Consistency Audit Plan

Updated: 2026-06-04

Scope: Flutter-only UI body consistency across all routed screens in
`flutter_app/lib/features/`.

This plan complements
`docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`.
The top-header audit verifies chrome/archetype consistency. This plan verifies
the content body: cards, sections, controls, states, typography, spacing,
financial safety, and responsive behavior.

## Objective

Make VitTrade UI visually and behaviorally consistent at the body component
level, not only at the top chrome level.

The target state:

- Every standard screen uses shared layout primitives.
- Every repeated surface uses shared card/panel treatment or an approved local
  exception.
- Search, tabs, inputs, buttons, banners, empty/error/loading states, and high
  risk flow panels use shared components.
- Domain boundaries remain visually clear: value/wallet/trading surfaces do not
  visually merge with Arena points-only surfaces.
- Every screen remains usable at 360 px and up, with no bottom-nav overlap,
  clipped text, hidden CTAs, or inconsistent spacing.

## Source Of Truth

- App source: `flutter_app/lib/`
- Screen pages: `flutter_app/lib/features/<feature>/presentation/pages/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Route inventory:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- Route coverage:
  `docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md`
- Design rules:
  `docs/03_DESIGN_SYSTEM/Guidelines.md`
- Native UI standard:
  `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`

## Current Baseline

Header/chrome status is clean:

```text
total_routed_screens=414
strict_visual_issues=0
screen_level_mismatches=0
uses_vit_top_chrome=20
status_banner_in_header=0
hard_coded_offline_banner=0
```

Preliminary body consistency scan:

| Feature | Pages | A | B | C | D | Tool | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| admin | 5 | 3 | 2 | 0 | 0 | 0 | Good baseline. |
| arena | 25 | 15 | 10 | 0 | 0 | 0 | Good baseline. |
| auth | 6 | 3 | 3 | 0 | 0 | 0 | Good baseline; auth entry remains special. |
| cross_module | 4 | 1 | 3 | 0 | 0 | 0 | Acceptable. |
| dca | 12 | 5 | 7 | 0 | 0 | 0 | Acceptable; existing dirty changes must be respected. |
| dev | 4 | 2 | 2 | 0 | 0 | 0 | Acceptable internal pages. |
| discovery | 2 | 0 | 2 | 0 | 0 | 0 | Acceptable. |
| earn | 68 | 38 | 30 | 0 | 0 | 0 | Strong baseline. |
| enterprise_states | 1 | 0 | 0 | 0 | 0 | 1 | Fullscreen tool exception. |
| home | 1 | 0 | 1 | 0 | 0 | 0 | Good, but root brand may keep custom body. |
| launchpad | 24 | 9 | 15 | 0 | 0 | 0 | Good baseline. |
| markets | 21 | 0 | 21 | 0 | 0 | 0 | Stable but chart/list bodies need visual QA. |
| news | 1 | 0 | 1 | 0 | 0 | 0 | Acceptable. |
| notifications | 1 | 0 | 1 | 0 | 0 | 0 | Acceptable. |
| onboarding | 1 | 0 | 1 | 0 | 0 | 0 | Acceptable special flow. |
| p2p | 72 | 23 | 47 | 1 | 0 | 1 | One page needs priority review. |
| predictions | 18 | 4 | 13 | 1 | 0 | 0 | Event detail needs priority review. |
| profile | 11 | 0 | 3 | 8 | 0 | 0 | Needs body consistency refactor. |
| referral | 5 | 1 | 4 | 0 | 0 | 0 | Acceptable. |
| rewards | 1 | 0 | 0 | 0 | 1 | 0 | Needs explicit review; likely route/page reuse issue. |
| support | 3 | 1 | 2 | 0 | 0 | 0 | Acceptable. |
| trade | 87 | 3 | 10 | 71 | 0 | 3 | Highest priority. |
| wallet | 19 | 0 | 2 | 17 | 0 | 0 | Root wallet improved; child pages remain priority. |

Grade meaning:

- `A`: strongly aligned with shared body primitives.
- `B`: acceptable body consistency; minor local custom widgets remain.
- `C`: body likely looks different; needs component normalization.
- `D`: missing or insufficient body implementation, or no shared primitives found.
- `Tool`: fullscreen workspace exception; must still pass tool-specific QA.

Baseline caveat:

- The current scan is a first-pass heuristic. It reads routed page files and
  page `part` files, then estimates consistency from shared primitive usage and
  local custom body patterns.
- The production audit tool must also walk feature-local imports under
  `features/<feature>/presentation/widgets/` because several pages delegate
  most body UI to child widgets.
- A low shared-component count is not automatically wrong for charts, maps,
  order books, chat, or fullscreen tools. Those pages need visual QA plus
  documented exceptions.
- A high shared-component count is not automatically safe. High-risk financial
  flows still need manual checks for preview, confirmation, fees, limits,
  masking, and success/error states.

Generated tool baseline after BCC-01 through BCC-04:

```text
generated=2026-06-04
total_routed_screens=414
grade_A=75
grade_B=143
grade_C=133
grade_D=58
grade_Tool=5
priority_P0=74
priority_P1=104
priority_P2=148
priority_P3=88
```

The generated baseline is stricter and more complete than the preliminary
heuristic because it now reads the top-header route inventory, routed page
files, page `part` files, direct feature-local widget imports, and the
`RewardsHubPage -> RewardsArenaPointsBridge -> ArenaPointsPage` delegation.
`RewardsHubPage` is no longer a D-grade page; the earlier D was a tooling false
positive caused by delegated body composition.

BCC-05 Wallet update:

```text
generated=2026-06-04
total_routed_screens=414
grade_A=76
grade_B=144
grade_C=138
grade_D=51
grade_Tool=5
priority_P0=72
priority_P1=104
priority_P2=148
priority_P3=90
wallet_D=0
```

Wallet D-grade routes were eliminated by normalizing major child-page surfaces
to `VitCard`, replacing Address Book raw search with `VitSearchBar`, and
tightening the audit tool so informational wallet pages are not treated as
transaction confirmation flows solely because their body mentions withdraw or
deposit destinations.

| Feature | Routes | A | B | C | D | Tool | Avg shared | Avg custom |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| admin | 5 | 4 | 1 | 0 | 0 | 0 | 12.6 | 19.2 |
| arena | 26 | 13 | 11 | 2 | 0 | 0 | 24.0 | 22.2 |
| auth | 6 | 0 | 4 | 1 | 1 | 0 | 8.8 | 20.3 |
| cross_module | 4 | 3 | 1 | 0 | 0 | 0 | 15.8 | 22.0 |
| dca | 14 | 5 | 6 | 1 | 2 | 0 | 20.0 | 21.1 |
| dev | 4 | 3 | 1 | 0 | 0 | 0 | 12.5 | 10.5 |
| discovery | 3 | 0 | 3 | 0 | 0 | 0 | 15.7 | 33.0 |
| earn | 70 | 28 | 25 | 17 | 0 | 0 | 21.8 | 17.1 |
| enterprise_states | 1 | 0 | 0 | 0 | 0 | 1 | 41.0 | 27.0 |
| home | 1 | 0 | 1 | 0 | 0 | 0 | 31.0 | 46.0 |
| launchpad | 24 | 9 | 6 | 9 | 0 | 0 | 18.1 | 25.5 |
| markets | 22 | 2 | 19 | 1 | 0 | 0 | 7.9 | 19.7 |
| news | 1 | 0 | 0 | 1 | 0 | 0 | 4.0 | 30.0 |
| notifications | 1 | 0 | 0 | 1 | 0 | 0 | 5.0 | 11.0 |
| onboarding | 1 | 1 | 0 | 0 | 0 | 0 | 33.0 | 35.0 |
| p2p | 77 | 0 | 44 | 30 | 2 | 1 | 16.3 | 20.6 |
| predictions | 19 | 4 | 8 | 7 | 0 | 0 | 13.4 | 30.2 |
| profile | 14 | 0 | 1 | 8 | 5 | 0 | 4.8 | 45.4 |
| referral | 5 | 0 | 4 | 1 | 0 | 0 | 17.0 | 25.6 |
| rewards | 1 | 1 | 0 | 0 | 0 | 0 | 40.0 | 34.0 |
| support | 3 | 2 | 1 | 0 | 0 | 0 | 12.3 | 18.3 |
| trade | 91 | 0 | 4 | 43 | 41 | 3 | 4.4 | 48.5 |
| wallet | 21 | 0 | 3 | 11 | 7 | 0 | 3.5 | 35.9 |

## Audit Artifacts To Create

Create these generated artifacts after the audit tool exists:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
flutter_app/tool/body_component_consistency_audit.dart
```

The Markdown artifact should summarize feature-level status and screen-level
findings. The CSV should be sortable by priority, feature, grade, and issue.

## Screen-Level Audit Columns

Each routed screen should produce one audit row with these fields:

| Column | Meaning |
| --- | --- |
| `feature` | Feature folder, e.g. `wallet`, `trade`, `p2p`. |
| `route` | Route path or `AppRoutePaths.*` constant. |
| `page` | Page class. |
| `page_file` | Source file. |
| `screen_level` | Existing level: L0/L1/L2/L3. |
| `archetype` | Existing visual archetype. |
| `body_grade` | A/B/C/D/Tool. |
| `layout_status` | pass/warn/fail for layout primitives. |
| `surface_status` | pass/warn/fail for shared cards/panels. |
| `controls_status` | pass/warn/fail for tabs/search/input/buttons. |
| `state_status` | pass/warn/fail for loading/empty/error/offline/success. |
| `financial_safety_status` | pass/warn/fail/not_applicable. |
| `responsive_status` | pass/warn/fail for 360 px and bottom nav. |
| `copy_boundary_status` | pass/warn/fail for financial/Arena/Prediction copy. |
| `shared_component_count` | Count of approved shared primitives. |
| `custom_body_count` | Count of local ad hoc body primitives. |
| `fixed_size_count` | Count of fixed heights/widths that may risk mobile. |
| `local_font_count` | Count of hardcoded `fontSize` or local font overrides. |
| `primary_issue` | Most important issue to fix first. |
| `recommended_action` | Specific migration recommendation. |
| `test_scope` | Focused tests to run after change. |

## Manual Screen Audit Worksheet

Use this worksheet for each page before changing code. The goal is to make the
review repeatable and to prevent a page from being marked consistent only
because it happens to use a shared scaffold.

```text
Feature:
Route:
Page class:
Page file:
Screen level:
Expected body pattern:
Current body grade:
Primary user task:
High-risk action present:
Financial safety required:
State coverage present:
Responsive risk:
Bottom chrome risk:
Domain copy boundary:
Shared primitives already used:
Local components to replace:
Approved local exceptions:
Recommended fix:
Focused test:
Visual QA route:
Final grade:
Reviewer notes:
```

Required manual checks:

1. Open the route definition and confirm the page is still routed.
2. Open the page file, its `part` files, and feature-local body widgets.
3. Identify the primary task of the screen before changing layout.
4. Mark whether the page is root, detail, transaction, utility, or tool.
5. Compare body structure against the screen-level contract.
6. Check if the page duplicates shared cards, buttons, tabs, inputs, search,
   banners, or states.
7. Check safe-area and bottom-nav padding at 360 px.
8. Check long labels, Vietnamese copy, numbers, and asset names for clipping.
9. Check empty, loading, error, offline, submitting, and success states.
10. Check financial safety rules when money, wallet, keys, escrow, leverage,
    automation, or irreversible actions are involved.
11. Check Prediction Markets and Arena copy boundaries.
12. Record the smallest safe refactor needed to reach A or B.

## Screen-Level Body Contracts

| Screen level | Body contract | Allowed exceptions |
| --- | --- | --- |
| L0 home root | `VitPageLayout`, `VitTopChrome.rootBrand`, `VitPageContent`, strong brand summary, product sections, bottom-nav-safe spacing. | Custom brand hero is allowed if it uses theme tokens and shared cards for product modules. |
| L0 auth entry | Auth-owned composition, shared inputs/buttons, clear validation states, no main-app bottom nav assumptions. | Custom onboarding visual rhythm is allowed. |
| L1 primary tab root | `VitTopChrome.rootModule`, `VitPageContent`, hero/summary card, sectioned body, shared search/tabs/actions. | Chart/list modules may keep domain widgets inside shared card surfaces. |
| L1 product module hub | Same as primary tab root, with product identity expressed by accent only. | Product-specific visualizations are allowed when tokenized and responsive. |
| L1 instrument workspace | `VitTopChrome.instrument`, dense trading body, order/chart/market panels, risk and action visibility. | Normal card rhythm can be reduced for high-density trading panels. |
| L1 utility hub | Detail chrome, shared search/filter/list patterns, no root-module hero unless the route behaves as a real hub. | Internal admin/dev tools may be simpler but must remain readable. |
| L2 detail/entity/detail hub | `VitHeader` or `VitTopChrome.detail`, `VitPageContent`, grouped `VitCard` sections, shared states. | Complex charts may stay custom inside shared containers. |
| L3 transaction flow | Detail chrome, explicit preview/confirm/result stages, `VitHighRiskStatePanel`, `VitStickyFooter` when useful. | None for high-risk safety content. |
| L3 fullscreen tool | Tool-owned canvas/chat/terminal layout, safe close/back action, visible status, safe-area controls. | Exempt from standard card layout only after documented QA. |

## Consistency Criteria

### 1. Layout Composition

Pass when:

- Standard screens use `VitPageLayout`.
- Scroll-heavy screens use `VitAutoHideHeaderScaffold` or a documented
  fullscreen exception.
- Content spacing uses `VitPageContent`, `VitPageSection`, or approved module
  section primitives.
- Bottom padding accounts for `DeviceMetrics.bottomChrome`,
  `DeviceMetrics.nativeBottomChrome`, and `MediaQuery.paddingOf(context).bottom`.

Warn when:

- The screen uses `SingleChildScrollView` plus manual `Column` and repeated
  `SizedBox(height: ...)` values.
- The screen has mixed content padding values such as 12, 13, 17, 18, 25 without
  a local reason.

Fail when:

- Content can be hidden behind bottom nav.
- Main screen has no shared layout primitive.
- Layout depends on fixed viewport assumptions.

### 2. Surfaces And Cards

Pass when:

- Main panels use `VitCard`.
- Hero financial cards use `VitCardVariant.hero`.
- Nested metrics use `VitCardVariant.inner` or `VitCardStat`.
- Borders, radii, and fills come from `AppColors`, `AppRadii`, and
  `AppSpacing`.

Warn when:

- Large `Container` blocks duplicate card styling.
- Local panel colors duplicate `AppColors.surface`, `surface2`, or custom alpha
  fills without being wrapped in a reusable component.

Fail when:

- A screen has many visually important `Container` cards and no `VitCard`.
- Card radius, border, elevation, and fill are materially different from the
  app standard.

### 3. Controls

Pass when:

- Search uses `VitSearchBar`.
- Forms use `VitInput`.
- Primary actions use `VitCtaButton`.
- Icon-only actions use `VitIconButton` or `VitHeaderActionButton`.
- Tabs use `VitTabBar` or a documented equivalent with the same tone and
  touch-target behavior.

Warn when:

- `GestureDetector` is used for tappable cards/buttons where `InkWell`,
  `VitCard.onTap`, or shared buttons would work.
- A local `TextField` duplicates `VitSearchBar` or `VitInput`.

Fail when:

- Controls lack visual feedback, semantics, or 44 px touch target.
- Filter/search/buttons sit under the bottom nav or outside the visible area.

### 4. State Coverage

Pass when:

- Loading uses `VitSkeleton` or a local skeleton matching it.
- Empty uses `VitEmptyState`.
- Error uses `VitErrorState`.
- Offline/cache uses `VitOfflineBanner` or `VitBanner`.
- High-risk flow states use `VitHighRiskStatePanel`.

Warn when:

- A page only implements the happy path.
- A local banner is visually similar but not shared.

Fail when:

- Networked or financial page has no empty/error/offline/submitting handling.
- High-risk flow has no preview/confirm/success/error state.

### 5. Financial Safety

Pass when high-risk flows show:

- Amount, asset, fee, network, limit, timing, and next step before submission.
- Preview before confirm.
- Confirm before irreversible action.
- Success/receipt state after submission.
- Masked sensitive data where appropriate.

Applies strongly to:

- Wallet: withdraw, deposit, address add, transfer, pending deposit, token
  approval.
- P2P: payment method add/change, escrow release, order proof, dispute,
  transfer.
- Trade: order submit, leverage, margin, copy trading configuration.
- Earn/Launchpad/DCA: staking, redeem, claim, rebalance, scheduled automation.

### 6. Domain Boundaries

Pass when:

- Arena uses points-only language.
- Prediction Markets uses positions/probability/receipt/PnL language.
- Wallet/Trade/P2P uses financial language with fees, limits, and risk.
- Cross-module bridges keep sections visually separated.

Fail when:

- Arena mentions wallet payout/profit/stake return.
- Prediction Markets and Arena performance language is visually or textually
  merged.
- P2P/Wallet/Trade high-risk copy sounds promotional or casino-like.

### 7. Responsive And Visual QA

Required viewport checks:

- 360 x 740 phone.
- 390 x 844 phone.
- 440 x 956 phone.
- Visual QA frame where relevant.

Pass when:

- No horizontal overflow.
- No bottom nav overlap.
- No clipped CTA labels.
- Text inside buttons/cards scales or wraps professionally.
- Sticky footer CTA, if present, does not hide form content.

## Audit Tool Plan

Build `flutter_app/tool/body_component_consistency_audit.dart`.

Implementation outline:

1. Locate repo/app root similarly to `top_header_visual_archetype_audit.dart`.
2. Parse route groups and reuse route/page extraction logic where possible.
3. Build a page index from `features/**/presentation/pages/*.dart`.
4. Include `part` files referenced by each page.
5. Count shared primitives:
   - `VitPageLayout`
   - `VitAutoHideHeaderScaffold`
   - `VitTopChrome`
   - `VitHeader`
   - `VitPageContent`
   - `VitCard`
   - `VitCtaButton`
   - `VitTabBar`
   - `VitSearchBar`
   - `VitInput`
   - `VitEmptyState`
   - `VitErrorState`
   - `VitOfflineBanner`
   - `VitBanner`
   - `VitSkeleton`
   - `VitHighRiskStatePanel`
   - `VitStickyFooter`
6. Count custom-risk primitives:
   - `Container(`
   - `GestureDetector(`
   - `TextField(`
   - `CustomPaint(`
   - `Positioned(`
   - `Stack(`
   - `SizedBox(height:`
   - `fontSize:`
   - `fontFamily:`
   - `BorderRadius.circular(`
7. Detect fixed-height risk:
   - `height: <number>` over 56 in non-icon widgets.
   - hardcoded bottom padding not including `DeviceMetrics` or `MediaQuery`.
8. Detect state coverage by searching for shared state components and provider
   state enums.
9. Detect financial safety components by route and feature.
10. Render Markdown and CSV.
11. Add `--check` mode to fail stale artifact.

## Scoring Rubric

The audit should not judge by counts alone. Counts provide the first signal,
then screen type adjusts severity.

### A

Criteria:

- Uses shared layout and body spacing.
- Main cards use `VitCard`.
- Controls use shared components.
- State coverage is present where needed.
- Custom widgets are small, domain-specific, and token-based.

Action:

- No refactor required.
- Visual smoke only when touched.

### B

Criteria:

- Layout and primary surfaces are consistent.
- Some local widgets remain but do not visibly diverge.
- No critical responsive or safety issue.

Action:

- Optional polish.
- Refactor only when touching the feature.

### C

Criteria:

- Body likely looks different from app standard.
- Many custom panels/controls or local font/spacing values.
- Shared layout exists but body sections are mostly local.

Action:

- Add to refactor backlog.
- Migrate surfaces and controls to shared primitives.

### D

Criteria:

- Missing body implementation, placeholder-only route, or no shared primitives.
- Serious visual or responsive mismatch.

Action:

- High priority.
- Must be resolved before visual consistency can be considered complete.

### Tool

Criteria:

- Fullscreen chart/chat/terminal workspace.

Action:

- Exempt from normal card layout.
- Must still pass tool-specific controls, safe area, action visibility, and
  nonblank visual QA.

## Prioritization

### P0: Create Audit Infrastructure

Deliverables:

- `body_component_consistency_audit.dart`
- Markdown artifact.
- CSV artifact.
- `--check` mode.
- Documentation of scoring rules.

Acceptance:

- Running the tool from `flutter_app/` writes stable artifacts.
- Running with `--check` passes when artifacts are current.

### P1: High-Impact Refactor Targets

Work these first because they are large, user-facing, and currently show many
custom body patterns.

| Feature | Pages |
| --- | --- |
| trade | `MarginTradingPage`, `MarketDataAnalyticsPage`, `ActiveCopiesPage`, `AdvancedAnalyticsPage`, `RegulatoryReportsDashboardPage`, `BotSecuritySettingsPage`, `BotGuidePage`, `RegulatoryDisclosuresPage`, `CopySafetyCenterPage`, `BotRiskDashboardPage`, `ExecutionVenueAnalysisPage`, `SlippageMonitoringPage`, `TraderProfilePage`, `ConvertPage`, `CopyTradingPage` |
| wallet | `WalletHealthScorePage`, `WalletGasOptimizerPage`, `PendingDepositsPage`, `AddressBookPage`, `DustConverterPage`, `NetworkStatusPage`, `PortfolioAnalyticsPage`, `WithdrawLimitsPage`, `DepositPage`, `AssetDetailPage`, `TransactionDetailPage`, `TransactionHistoryPage` |
| profile | `ProfilePage`, `SecurityPage`, `SubAccountPage`, `ApiManagementPage`, `DeviceManagementPage`, `SettingsPage`, `ActivityLogPage`, `KYCPage` |
| predictions | `PredictionEventDetailPage` |
| p2p | `P2PDisputeDetailPage` |
| rewards | `RewardsHubPage` |

### P2: Complex But Acceptable Screens

These should be audited after P1, or when feature work touches them.

| Feature | Pages |
| --- | --- |
| markets | `MarketDepthPage`, `TokenInfoPage`, `MarketHeatmapPage`, `MarketScreenerPage`, `SocialSentimentPage`, `PortfolioTrackerPage`, `WatchlistPage`, `MarketCalendarPage`, `ComparisonToolPage` |
| p2p | `P2PChatPage`, `P2POrderPage`, `P2PExpressConfirmPage`, `P2PEscrowDetailPage`, `P2PPaymentMethodAddPage`, `P2PKycStatusPage`, `P2PWalletPage`, `P2PWalletTransferPage` |
| trade | Remaining bot, copy trading, margin, risk, regulatory, order, and reporting pages |
| wallet | Remaining wallet utility and transaction pages |

### P3: Stable Screens

These are acceptable and can stay as-is unless touched:

- `admin`
- `arena`
- `auth`
- `cross_module`
- `dca`
- `dev`
- `discovery`
- `earn`
- `home`
- `launchpad`
- `news`
- `notifications`
- `onboarding`
- `referral`
- `support`

## Per-Feature Execution Plan

### Wallet

Current status:

- Root `WalletPage` has been improved to asset-first and now uses shared body
  primitives more strongly.
- Child pages remain inconsistent because many still have local body panels and
  transaction-specific custom controls.

Audit every wallet page:

| Page | Priority | Specific checks |
| --- | --- | --- |
| `WalletPage` | P2 | Confirm root remains asset-first, no bottom-nav overlap, `VitSearchBar` works, DCA/tools read as secondary. |
| `WalletHealthScorePage` | P1 | Replace custom score cards with `VitCard`; verify empty/error/offline states; check health chart sizing. |
| `WalletGasOptimizerPage` | P1 | Normalize current gas, trends, and tips panels; ensure chart does not overflow at 360 px. |
| `PendingDepositsPage` | P1 | Treat as transaction flow; add/verify preview, status, empty, error, and next step panels. |
| `AddressBookPage` | P1 | High-risk address management; standardize list rows, add/change states, and security warning. |
| `AddressAddPage` | P1 | Ensure preview/confirm exists; use `VitInput`, `VitCtaButton`, `VitHighRiskStatePanel`. |
| `DustConverterPage` | P1 | Normalize asset selection, confirmation, and result states. |
| `NetworkStatusPage` | P1 | Normalize status cards and legend; use shared banners for degraded networks. |
| `PortfolioAnalyticsPage` | P1 | Normalize charts/cards; guard zero totals; verify responsive chart. |
| `WithdrawLimitsPage` | P1 | High-risk support page; standardize limit cards and copy. |
| `DepositPage` | P1 | Verify QR/address safety, network selector, copy action, empty/error/offline. |
| `WithdrawPage` | P1 | Strict high-risk flow: amount, address, fee, risk, preview, confirm, receipt. |
| `TransferPage` | P1 | Standardize source/destination cards, confirm sheet, submitting/success states. |
| `AssetDetailPage` | P2 | Normalize asset hero, history, action row, and analytics cards. |
| `TransactionDetailPage` | P2 | Standardize receipt/detail rows and support actions. |
| `TransactionHistoryPage` | P2 | Normalize filters, empty state, rows, export action. |
| `WalletMultiManagerPage` | P2 | Normalize tabs, wallet distribution chart, grouped list. |
| `WalletTokenApprovalPage` | P2 | High-risk revoke flow; standardize revoke sheet and warning panels. |
| `BuyCryptoPage` | P2 | Normalize input/payment/result states and third-party risk copy. |

### Trade

Current status:

- Highest body inconsistency risk.
- Many pages use shared headers but custom body panels.
- Fullscreen tools are acceptable exceptions but still need visual QA.

Audit every trade cluster:

| Cluster | Priority | Pages |
| --- | --- | --- |
| Margin | P1 | `MarginTradingPage`, `MarginTradingHubPage`, `LeveragePage`, `AdvancedTradingDemoPage` |
| Analytics | P1 | `MarketDataAnalyticsPage`, `LiveMarketDataAnalyticsPage`, `AdvancedAnalyticsPage`, `PerformanceAttributionPage`, `ExecutionVenueAnalysisPage`, `ExecutionQualityDemoPage` |
| Copy trading | P1 | `ActiveCopiesPage`, `CopyTradingPage`, `CopyTradingV2Page`, `CopyConfigurationPage`, `CopyConfirmationPage`, `CopyProviderDetailPage`, `CopyPerformancePage`, `ProviderLeaderboardPage`, `ProviderComparisonPage`, `ProviderApplicationPage` |
| Regulation | P1 | `RegulatoryReportsDashboardPage`, `RegulatoryDisclosuresPage`, `RegulatoryInspectionReadyPage`, `TransactionReportingPage`, `BestExecutionReportsPage`, `AuditTrailPage`, `ClientCategorizationPage`, `ClientMoneyProtectionPage`, `CassReconciliationPage` |
| Bots | P1/P2 | `TradingBotsPage`, `BotRiskDashboardPage`, `BotSecuritySettingsPage`, `BotGuidePage`, `BotTaxReportingPage`, `BotApiDocumentationPage`, `BotPerformanceAnalyticsPage`, `BotPortfolioDashboardPage`, `BotBacktestingPage`, `BotOptimizationPage`, `BotDrawdownAnalyzerPage`, `BotEquityCurvePage`, `BotEmergencyStopPage`, `BotSuitabilityAssessmentPage`, `BotTermsOfServicePage`, `BotRiskDisclosurePage`, `BotFaqPage`, `BotHistoryPage`, `BotStrategyComparePage` |
| Orders | P2 | `TradePage`, `ConvertPage`, `OrderReceiptPage`, `OrdersHistoryPage`, `PositionDashboardPage`, `TradeHistoryExportPage`, `TradeSettingsPage` |
| Fullscreen tools | Tool | `AdvancedChartPage`, `FuturesPage` |

Trade-specific standards:

- Order forms must use consistent buy/sell tones.
- Risk controls must show fee, liquidation/margin risk, and confirmation.
- Copy trading must show suitability, costs, target market, and provider risk.
- Analytics pages should share chart card patterns and avoid unique local
  dashboard palettes.

### Profile

Current status:

- Many custom body widgets and local menu sections.
- Root profile is user-facing and should be brought closer to shared body
  primitives.

Audit pages:

| Page | Priority | Specific checks |
| --- | --- | --- |
| `ProfilePage` | P1 | Normalize hero, VIP, prediction/arena sections, product shortcuts, menu cards. |
| `SecurityPage` | P1 | High-risk security settings; require preview/confirm for sensitive changes. |
| `ApiManagementPage` | P1 | API key handling; mask secrets; standardize cards and create action. |
| `ApiKeyCreatePage` | P1 | High-risk create flow; use `VitInput`, `VitCtaButton`, preview/confirm. |
| `DeviceManagementPage` | P1 | Standardize device rows, revoke confirmation, empty/error states. |
| `SettingsPage` | P1 | Standardize settings rows and sections. |
| `KYCPage` | P1 | KYC state coverage and document upload status. |
| `EditProfilePage` | P2 | Use shared inputs and validation state. |
| `ActivityLogPage` | P2 | Standardize history rows and filters. |
| `SubAccountPage` | P2 | Standardize account cards and risk copy. |
| `VIPPage` | P2 | Normalize tier cards and progress visualization. |

### P2P

Current status:

- Mostly acceptable, but high-risk transaction/security pages need strict
  consistency.

Audit pages:

| Cluster | Priority | Pages |
| --- | --- | --- |
| Order/escrow | P1 | `P2POrderPage`, `P2PEscrowDetailPage`, `P2PExpressConfirmPage`, `P2POrderProofPage`, `P2POrderCancelPage`, `P2POrderRatePage`, `P2POrderTimelinePage` |
| Disputes | P1 | `P2PDisputeDetailPage`, `P2PDisputeEvidencePage`, `P2PDisputeResolutionPage`, `P2PDisputePage`, `P2PDisputesPage` |
| Chat | Tool/P1 | `P2PChatPage`; maintain fullscreen chat behavior but standardize banners/composer/actions. |
| Payment methods | P1 | `P2PPaymentMethodsPage`, `P2PPaymentMethodAddPage`, `P2PPaymentMethodVerificationPage`, `P2PPaymentMethodOwnershipPage`, `P2PPaymentMethodCoolingPeriodPage`, `P2PPaymentMethodHistoryPage` |
| KYC/security | P1/P2 | `P2PKycRequirementsPage`, `P2PKycStatusPage`, `P2PIdentityVerificationPage`, `P2PAddressProofPage`, `P2PSelfieVerificationPage`, `P2PVideoVerificationPage`, `P2PSecurityCenterPage`, `P2P2FASettingsPage`, `P2PDeviceManagementPage`, `P2PAntiPhishingCodePage`, `P2PLoginHistoryPage`, `P2PSuspiciousActivityPage` |
| Merchant/ads | P2 | `P2PAdDetailPage`, `P2PAdAnalyticsPage`, `P2PCreateAdPage`, `P2PMyAdsPage`, `P2PMerchantApplyPage`, `P2PMerchantProfilePage`, `P2PReportMerchantPage`, `P2PReviewsPage`, `P2PTradingLevelPage` |
| Compliance/wallet | P2 | `P2PWalletPage`, `P2PWalletTransferPage`, `P2PFundLockHistoryPage`, `P2PTransactionLimitsPage`, `P2PLimitTrackerPage`, `P2PComplianceOverviewPage`, `P2PAmlScreeningPage`, `P2PSourceOfFundsPage`, `P2PLargeTransactionJustificationPage`, `P2PRiskAssessmentPage`, `P2PTaxReportingPage` |

P2P-specific standards:

- Payment method changes require safety preview and confirmation.
- Escrow release/cancel/dispute flows must show next steps and risk.
- Chat must keep security banners visible without occluding composer.

### Markets

Current status:

- All pages currently grade acceptable, but chart/list-heavy screens should be
  visually QA'd because custom drawing is expected.

Audit pages:

| Page | Priority | Specific checks |
| --- | --- | --- |
| `MarketListPage` | P2 | Search/filter/list consistency, bottom nav clearance. |
| `PairDetailPage` | P2 | Instrument detail consistency; chart/order panels. |
| `MarketDepthPage` | P2 | Order book, depth chart, whale alerts. |
| `TokenInfoPage` | P2 | Tabs and detail sections. |
| `AdvancedChartsPage` | P2 | Tool exception if fullscreen; otherwise chart control consistency. |
| `PriceAlertsPage` | P2 | Alert form controls and empty states. |
| `MarketCalendarPage` | P2 | Filter controls and event cards. |
| `ComparisonToolPage` | P2 | Compare controls, table/card layout. |
| `MarketCorrelationsPage` | P2 | Matrix/chart readability. |
| `DerivativesOverviewPage` | P2 | Section hub consistency. |
| `MarketHeatmapPage` | P2 | Treemap sizing and mobile behavior. |
| `MarketMoversPage` | P2 | Filters and rows. |
| `MarketNewsPage` | P2 | News card/list consistency. |
| `MarketOverviewPage` | P2 | Dashboard card consistency. |
| `PortfolioTrackerPage` | P2 | Portfolio cards and state coverage. |
| `MarketScreenerPage` | P2 | Filter controls and result rows. |
| `MarketSectorsPage` | P2 | Sector cards/table. |
| `SocialSignalsPage` | P2 | Signal cards and copy boundaries. |
| `SocialSentimentPage` | P2 | Tabs/charts and empty states. |
| `TokenUnlocksPage` | P2 | Timeline/list cards. |
| `WatchlistPage` | P2 | Toolbar, rows, empty state. |

### Predictions

Current status:

- Root is acceptable.
- Event detail is the main risk because it has many panels and trading
  controls.

Audit pages:

| Page | Priority | Specific checks |
| --- | --- | --- |
| `PredictionsHomePage` | P2 | Search/filter/category/bridge cards. |
| `PredictionEventDetailPage` | P1 | Event header, probability chart, trade panel, order book, comments, Arena bridge. |
| `PredictionAdvancedChartPage` | P2 | Chart controls and mobile frame. |
| `PredictionOrderReceiptPage` | P1 | Receipt state and next steps. |
| `PredictionsPortfolioPage` | P2 | Positions/orders/history tabs. |
| `PredictionPortfolioAnalyzerPage` | P2 | Risk/performance charts. |
| `PredictionRiskCalculatorPage` | P2 | Form, scenario, risk result. |
| `PredictionMarketMakerPage` | P2 | Provide/positions/returns panels. |
| `PredictionsLeaderboardPage` | P2 | Ranking rows and filters. |
| `PredictionTournamentsPage` | P2 | Tournament list/detail states. |
| `PredictionsSearchPage` | P2 | Search state coverage. |
| `PredictionSocialPage` | P2 | Comments/share/report states. |
| `PredictionDataIntegrationPage` | P2 | API/webhook controls. |
| `PredictionEventCalendarPage` | P2 | Calendar controls and notifications. |
| `PredictionsRewardsPage` | P2 | Rewards copy and table. |
| `PredictionsGlobalActivityPage` | P2 | Feed rows. |
| `PredictionsBreakingPage` | P2 | Breaking/mover cards. |

### Earn

Current status:

- Strong baseline. Keep as reference for body consistency.

Audit focus:

- Use Earn as a benchmark for `VitCard`, `VitPageContent`, tabs, and high-risk
  panels.
- Check only complex transaction pages first:
  `SavingsRedeemPage`, `SavingsReceiptPage`, `SavingsRiskAssessmentPage`,
  `SavingsLadderPage`, `StakingWithdrawalPolicyPage`,
  `StakingSuitabilityAssessmentPage`, `StakingRiskAssessmentPage`.

### Launchpad

Current status:

- Good baseline, but some high-risk claim/bridge/order pages need safety review.

Audit focus:

- `LaunchpadBatchClaimPage`
- `LaunchpadBridgeOrderPage`
- `LaunchpadClaimReceiptPage`
- `LaunchpadDcaBuilderPage`
- `LaunchpadDetailPage`
- `LaunchpadReceiptPage`
- `LaunchpadRiskAnalyticsPage`
- `LaunchpadSwapAggregatorPage`
- `LaunchpadAddressBookPage`

### Arena

Current status:

- Good baseline.
- Main thing is domain boundary: points-only language.

Audit focus:

- `ArenaHomePage`
- `ArenaChallengeDetailPage`
- `ArenaJoinPage`
- `ArenaStudioPage`
- `ArenaLeaderboardPage`
- `ArenaPointsLedgerPage`
- `ArenaPointsEntryDetailPage`
- `ArenaSafetyCenterPage`
- `ArenaReportCasePage`
- `ArenaPredictionBridgeFoundationPage`

Arena checks:

- No payout/profit/wallet/stake-return language.
- Leaderboard reads as fair-play/completion.
- Prediction bridge remains visually separated from Arena points flow.

### DCA

Current status:

- Acceptable baseline.
- There are existing uncommitted DCA changes in the worktree; do not overwrite.

Audit focus:

- `DCAPage`
- `DCADynamicAmount`
- `DCARebalanceConfig`
- `DCARebalanceDashboard`
- `DCAPortfolioOptimizer`
- `DCAScheduleConfig`
- `DCAScheduleAnalytics`
- `DCABacktesterPage`
- `DCAMultiAssetPage`
- `DCAPerformanceComparePage`
- `DCASmartRulesPage`

### Rewards

Current status:

- BCC-04 confirmed the original D grade was a tool limitation.
- `RewardsHubPage` delegates to `RewardsArenaPointsBridge`, which renders
  `ArenaPointsPage` with a rewards snapshot override.
- `body_component_consistency_audit.dart` now includes that delegated source,
  and `RewardsHubPage` grades A in the generated artifact.

Audit focus:

- Keep the delegation documented in the generated audit artifact.
- If Rewards body changes later, preserve the Arena points-only boundary and
  rerun `dart run tool/body_component_consistency_audit.dart --check`.

## Standard Refactor Pattern

For every C/D page:

1. Preserve route, page class, keys, navigation behavior, and test semantics.
2. Replace outer body layout with:
   - `VitPageLayout`
   - `VitAutoHideHeaderScaffold` when applicable
   - `VitPageContent`
3. Replace large local panels with:
   - `VitCard`
   - `VitCardVariant.hero`
   - `VitCardVariant.inner`
4. Replace local controls with:
   - `VitSearchBar`
   - `VitTabBar`
   - `VitInput`
   - `VitCtaButton`
   - `VitIconButton`
5. Replace local banners/states with:
   - `VitBanner`
   - `VitOfflineBanner`
   - `VitEmptyState`
   - `VitErrorState`
   - `VitSkeleton`
   - `VitHighRiskStatePanel`
6. Remove unnecessary fixed heights.
7. Keep domain-specific custom painters only when needed, and wrap them in
   shared card surfaces.
8. Run focused tests and audits.

## Test And Verification Plan

For each batch:

```bash
cd flutter_app
dart format .
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/route_coverage_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

For focused feature batches:

```bash
flutter test test/features/wallet --reporter=compact
flutter test test/features/trade --reporter=compact
flutter test test/features/profile --reporter=compact
flutter test test/features/p2p --reporter=compact
```

Visual QA checklist:

- 360 px width root page.
- 360 px width highest-risk detail page.
- 440 px width root page.
- Visual QA frame for at least one route in each touched feature.
- Verify bottom nav does not cover controls.
- Verify long Vietnamese labels do not clip.
- Verify loading/empty/error/offline states if reachable.

## Definition Of Done

The body consistency project is complete when:

- Body consistency audit artifact exists and is current.
- `--check` mode passes.
- All routed pages are A/B/Tool, or have documented approved exceptions.
- No D-grade pages remain.
- C-grade pages are either fixed or explicitly accepted as complex domain
  exceptions.
- Wallet, Trade, Profile, P2P, Markets, and Predictions high-risk pages have
  passed focused visual QA.
- Existing header archetype audit remains clean.
- Route coverage remains current.
- `flutter analyze` passes.
- Focused feature tests pass.

## Recommended Batch Order

1. Build the body consistency audit tool and artifacts.
2. Fix or document `RewardsHubPage`. Completed in BCC-04 as a false positive
   caused by delegated body composition.
3. Finish Wallet child pages.
4. Refactor Profile root and security/API/device pages.
5. Refactor Trade P1 pages.
6. Refactor P2P high-risk order/payment/dispute pages.
7. Refactor Predictions event detail.
8. Visual QA Markets chart/list pages.
9. Polish remaining B-grade pages only when touched.

## Notes For Future Agents

- Do not revert unrelated dirty worktree changes.
- Do not regenerate obsolete React/Vite tooling.
- Keep app source under `flutter_app/`.
- Prefer shared primitives before local UI scaffolds.
- Preserve product boundaries between Prediction Markets and Open Arena.
- For high-risk financial changes, preview/confirm/success/error states are
  part of UI consistency, not optional polish.
