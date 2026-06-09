# AI Body Component Consistency Audit Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
body component consistency audit and remediation work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit-Plan.md`

Goal: make VitTrade UI consistent at the body component level across all
routed Flutter screens. This means cards, sections, controls, search, tabs,
forms, state components, financial safety panels, responsive behavior, and
domain copy must align with the shared VitTrade design system.

This is not a request to create another plan. It is a request to execute the
existing body consistency plan in order.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the body component consistency audit and remediation plan from:

docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit-Plan.md

The final product must guarantee:
- Every routed Flutter screen has a body consistency grade: A, B, C, D, or Tool.
- All D-grade pages are fixed or documented as false positives with evidence.
- C-grade pages are either refactored to A/B or recorded as approved complex
  domain exceptions with clear rationale.
- Standard screens use shared VitTrade layout/body primitives.
- Repeated cards, panels, tabs, forms, search, CTAs, banners, and states use
  shared components unless an exception is documented.
- Financial, security, escrow, wallet, leverage, copy-trading, address, API key,
  withdrawal, deposit, payment-method, and automation flows keep preview,
  confirmation, fee/risk/limit, masking, next-step, success, and error states.
- Prediction Markets and Open Arena stay visually and semantically separate.
- Arena remains points-only. Do not introduce payout, wallet, profit, stake
  return, casino, or hype language into Arena.
- All refactored screens remain usable at 360 px width and up.
- No body content, final form field, CTA, modal, bottom sheet, or error state is
  hidden behind `VitBottomNav` or sticky action surfaces.
- Existing routes, providers, controllers, keys, tests, domain behavior, and
  navigation semantics are preserved.

NON-NEGOTIABLE OUTCOME:
- Do not only analyze.
- Do not only create another prompt or plan.
- Start by reading the existing plan, then execute the next open item.
- Continue automatically to the next open item unless the user explicitly asks
  for one phase only.
- Keep edits tightly scoped to body consistency, audit tooling, generated audit
  artifacts, and directly affected tests.
- Do not rewrite app shell, router architecture, business state, repositories,
  theme systems, or unrelated layouts.
- Do not recreate React, Vite, npm, Tailwind, or obsolete web screenshot tools.
- Do not revert unrelated dirty worktree changes.
- Do not remove widget keys unless tests are updated in the same change packet
  and the final behavior remains testable.
- Use existing shared primitives before creating local UI scaffolds:
  `VitAppShell`, `VitPageLayout`, `VitPageContent`, `VitHeader`,
  `VitBottomNav`, `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`,
  `VitSearchBar`, `VitBanner`, `VitOfflineBanner`, `VitEmptyState`,
  `VitErrorState`, `VitSkeleton`, `VitHighRiskStatePanel`, and
  `VitStickyFooter`.
- Use theme tokens from `flutter_app/lib/app/theme/`.
- Keep dark theme as the active baseline.
- Do not introduce new palettes, decorative blobs, gradient orbs, landing-page
  composition, marketing hero sections, or unrelated visual effects.
- If all packets are complete, the final response must include:
  BODY COMPONENT CONSISTENCY AUDIT COMPLETE
- If forced to stop before all packets are complete, the final response must
  end with exactly:
  RESUME FROM: BCC-<number> - <title>
  This must be the final line, with no text after it.

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/03_DESIGN_SYSTEM/Guidelines.md
6. docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md
7. docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md
8. docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md
9. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md
10. docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md
11. docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit-Plan.md
12. docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md
13. Source files listed in each packet before editing that packet.

If documents conflict, follow this order:
1. Current user instruction
2. AGENTS.md
3. `VitTrade-Body-Component-Consistency-Audit-Plan.md`
4. Financial safety and product boundaries in AGENTS and design docs
5. Flutter Native Design Standard
6. Flutter Module Identity Standard
7. Current Flutter source and tests

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Screen pages: `flutter_app/lib/features/<feature>/presentation/pages/`
- Feature widgets: `flutter_app/lib/features/<feature>/presentation/widgets/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- Tests: `flutter_app/test/`
- Generated QA artifacts: `flutter_app/run-artifacts/`
- Body consistency plan:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit-Plan.md`
- Header route inventory:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`

CURRENT BASELINE TO VERIFY:
The top-header audit is expected to be clean:

```text
total_routed_screens=414
strict_visual_issues=0
screen_level_mismatches=0
uses_vit_top_chrome=20
status_banner_in_header=0
hard_coded_offline_banner=0
```

Preliminary body consistency risk from the plan:
- `trade`: 87 pages, 71 C-grade, 3 Tool, highest priority.
- `wallet`: 19 pages, 17 C-grade, root wallet improved, child pages remain
  priority.
- `profile`: 11 pages, 8 C-grade, root/security/API/device/settings need
  component normalization.
- `p2p`: 72 pages, mostly acceptable, but one C-grade and high-risk escrow,
  payment, dispute, KYC, and wallet flows need strict review.
- `predictions`: 18 pages, one C-grade, event detail is the main risk.
- `markets`: 21 pages, all B-grade, but chart/list pages need visual QA.
- `rewards`: one D-grade, first confirm if this is a false positive, route
  reuse, placeholder, or real missing shared body implementation.

GRADE DEFINITIONS:
- A: shared layout, shared surfaces, shared controls, needed states, tokenized
  domain widgets, no meaningful body inconsistency.
- B: acceptable body consistency; minor local widgets remain but do not visibly
  diverge.
- C: body likely looks different from app standard; many local panels, controls,
  fonts, spacing, or state gaps.
- D: missing body implementation, placeholder-only route, no shared primitives,
  or serious body consistency issue.
- Tool: fullscreen chart/chat/terminal/workspace exception. Tool pages are
  exempt from normal card rhythm but must pass safe area, controls, visibility,
  nonblank visual QA, and state behavior.

DESIGN RULES FOR THIS WORK:
- Phone-first from 360 px.
- Use existing VitTrade primitives and tokens.
- Keep the interface quiet, dense, professional, and operational.
- Do not build marketing sections or landing-page heroes.
- Do not use nested cards.
- Do not put cards inside cards unless the existing shared component explicitly
  supports inner card variants.
- Do not let labels clip in cards, buttons, tabs, filters, or sticky footers.
- Do not scale font size with viewport width.
- Keep letter spacing at 0 unless existing tokens already define otherwise.
- Use icon buttons for icon actions and keep tooltips/semantics.
- Forms must use shared validation, error, disabled, submitting, and success
  states when the flow needs them.
- High-risk actions must never become less explicit just to make a page look
  cleaner.

BODY CONTRACT BY SCREEN LEVEL:
- L0 home root: `VitPageLayout`, `VitTopChrome.rootBrand`,
  `VitPageContent`, brand/product summary, shared product cards, bottom-nav-safe
  spacing.
- L0 auth entry: auth-owned visual rhythm is allowed, but use shared inputs,
  CTAs, validation states, and no main-app bottom-nav assumptions.
- L1 primary tab root: `VitTopChrome.rootModule`, `VitPageContent`, hero or
  summary card, sectioned body, shared search/tabs/actions.
- L1 product module hub: same as primary tab root; product identity must be
  accent-only.
- L1 instrument workspace: `VitTopChrome.instrument`, dense chart/order/market
  panels, clear risk/action visibility; standard card rhythm may be reduced.
- L1 utility hub: detail chrome, shared search/filter/list patterns.
- L2 detail/entity/section hub: `VitHeader` or `VitTopChrome.detail`,
  `VitPageContent`, grouped `VitCard` sections, shared states.
- L3 transaction flow: detail chrome, preview/confirm/result stages,
  `VitHighRiskStatePanel`, `VitStickyFooter` only when useful and safe.
- L3 fullscreen tool: tool-owned layout, safe close/back action, visible status,
  safe-area controls, documented exception.

PROCESS WORK IN THIS EXACT ORDER:
1. BCC-00 - Preflight, Current Audit, And Plan Sync
2. BCC-01 - Build Body Component Consistency Audit Tool
3. BCC-02 - Generate Markdown And CSV Audit Artifacts
4. BCC-03 - Manual Triage For C, D, And Tool Pages
5. BCC-04 - Resolve Rewards D-Grade Page
6. BCC-05 - Wallet Child Page Consistency Pass
7. BCC-06 - Profile Root, Security, API, Device, And Settings Pass
8. BCC-07 - Trade P1 Body Consistency Pass
9. BCC-08 - P2P High-Risk Order, Payment, Dispute, And KYC Pass
10. BCC-09 - Prediction Event Detail And Receipt Pass
11. BCC-10 - Markets Chart/List Visual QA Pass
12. BCC-11 - Remaining C/D Pages And Approved Exceptions
13. BCC-12 - Format, Analyze, Tests, Audits, Visual QA, And Final Docs

Do not start a later packet while an earlier packet has failing focused tests,
unresolved compile errors, stale checklist status, or unclear UX
classification.

BCC-00 - PREFLIGHT, CURRENT AUDIT, AND PLAN SYNC:
Before editing:

```bash
cd flutter_app
git status --short
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/route_coverage_audit.dart --check
rg -n "VitPageLayout|VitAutoHideHeaderScaffold|VitPageContent|VitCard|VitCtaButton|VitTabBar|VitSearchBar|VitInput|VitEmptyState|VitErrorState|VitOfflineBanner|VitBanner|VitSkeleton|VitHighRiskStatePanel|VitStickyFooter" lib/features lib/shared
rg -n "Container\\(|GestureDetector\\(|TextField\\(|CustomPaint\\(|Positioned\\(|Stack\\(|SizedBox\\(height:|fontSize:|fontFamily:|BorderRadius\\.circular\\(" lib/features
rg -n "withdraw|deposit|address|escrow|payment method|leverage|margin|copy|api key|2fa|kyc|confirm|preview|receipt" lib/features
rg -n "payout|profit|wallet|stake return|casino|gamble" lib/features/arena
```

Expected behavior:
- Trust current source if counts differ from the plan.
- Update the plan evidence when current scans have drifted.
- Do not modify unrelated dirty worktree files.
- Identify any existing generated or untracked audit docs before creating new
  ones.

BCC-01 - BUILD BODY COMPONENT CONSISTENCY AUDIT TOOL:
Create or update:

```text
flutter_app/tool/body_component_consistency_audit.dart
```

Tool requirements:
- Follow the style and app-root discovery pattern of existing Flutter tools,
  especially `top_header_visual_archetype_audit.dart`.
- No new package dependency unless absolutely necessary.
- Parse the route inventory from:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- Reuse route/page/screen-level/archetype/page-file data from that inventory.
- Read each routed page file.
- Include page `part` files.
- Include direct feature-local body widgets imported from:
  `features/<feature>/presentation/widgets/`
- Produce stable output sorted by feature, page file, and route.
- Support normal generation mode.
- Support `--check` mode that fails when generated artifacts are stale.

Audit row fields:
- feature
- route
- page
- page_file
- screen_level
- archetype
- body_grade
- layout_status
- surface_status
- controls_status
- state_status
- financial_safety_status
- responsive_status
- copy_boundary_status
- shared_component_count
- custom_body_count
- fixed_size_count
- local_font_count
- primary_issue
- recommended_action
- test_scope

Shared primitives to count:
- `VitPageLayout`
- `VitAutoHideHeaderScaffold`
- `VitTopChrome`
- `VitHeader`
- `VitPageContent`
- `VitPageSection`
- `VitCard`
- `VitCardStat`
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

Custom-risk primitives to count:
- `Container(`
- `GestureDetector(`
- `TextField(`
- `CustomPaint(`
- `Positioned(`
- `Stack(`
- `SizedBox(height:`
- `height: <number>` over 56 where it looks layout-critical
- `width: <number>` where it can risk 360 px overflow
- `fontSize:`
- `fontFamily:`
- `BorderRadius.circular(`
- hardcoded colors outside app theme tokens
- hardcoded bottom padding that does not include `DeviceMetrics` or
  `MediaQuery.paddingOf(context).bottom`

Safety detection:
- Mark wallet, P2P, trade, earn, launchpad, DCA, profile security, API key,
  device, KYC, withdrawal, deposit, address, escrow, payment-method, leverage,
  margin, copy-trading, staking, redeem, claim, rebalance, and automation flows
  as candidates for financial/security safety review.
- Do not mark them safe only by keyword count.
- A page can be `financial_safety_status=warn` until manual review confirms
  preview/confirm/result states.

Grading rules:
- Use counts as signals, not final truth.
- Tool pages can be `Tool` only if screen level or route behavior clearly
  indicates fullscreen chart/chat/terminal/workspace.
- D pages must be rare and explainable.
- Pages that delegate UI to imported widgets must include those widgets before
  grading.

BCC-02 - GENERATE MARKDOWN AND CSV AUDIT ARTIFACTS:
Create or update:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
```

Markdown artifact must include:
- Timestamp/date.
- Inputs read.
- Header audit summary.
- Feature-level grade table.
- Screen-level grade counts.
- P0/P1/P2/P3 issue counts.
- D-grade pages.
- C-grade pages.
- Tool exceptions.
- High-risk financial/security pages needing manual review.
- Domain copy boundary warnings.
- Recommended batch order.
- Verification commands.

CSV artifact must be sortable and include all audit row fields.

After generation:

```bash
cd flutter_app
dart format tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
```

BCC-03 - MANUAL TRIAGE FOR C, D, AND TOOL PAGES:
For every D page, C page, and Tool page, fill the worksheet from the plan:

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

Minimum manual checks:
- Open the route definition and confirm the page is routed.
- Open the page file, `part` files, and feature-local body widgets.
- Identify the primary task before changing layout.
- Check if the page is root, detail, transaction, utility, or tool.
- Check duplicate local cards, controls, tabs, inputs, search, banners, and
  states.
- Check safe-area and bottom-nav padding at 360 px.
- Check long labels, Vietnamese copy, numbers, and asset names for clipping.
- Check loading, empty, error, offline, submitting, and success states.
- Check financial safety if money, wallet, keys, escrow, leverage, automation,
  or irreversible actions are involved.
- Check Prediction Markets and Arena copy boundaries.

BCC-04 - RESOLVE REWARDS D-GRADE PAGE:
Read before editing:

```text
flutter_app/lib/features/rewards/presentation/pages/rewards_hub_page.dart
```

Requirements:
- First determine whether the D grade is a real issue or audit-tool false
  positive caused by delegation, route reuse, placeholder composition, or file
  structure.
- If false positive, improve the audit tool and document the exception.
- If real, refactor the body to use shared layout and body primitives.
- Add or verify loading/empty/error/offline states if the flow needs them.
- Keep route behavior and product copy unchanged unless it violates design or
  safety rules.

BCC-05 - WALLET CHILD PAGE CONSISTENCY PASS:
Root wallet has already been improved, but child pages remain priority.

Read before editing the wallet batch:

```text
flutter_app/lib/features/wallet/presentation/pages/
flutter_app/lib/features/wallet/presentation/widgets/
flutter_app/test/features/wallet/
```

Priority pages:
- `WalletHealthScorePage`
- `WalletGasOptimizerPage`
- `PendingDepositsPage`
- `AddressBookPage`
- `AddressAddPage`
- `DustConverterPage`
- `NetworkStatusPage`
- `PortfolioAnalyticsPage`
- `WithdrawLimitsPage`
- `DepositPage`
- `WithdrawPage`
- `TransferPage`
- `AssetDetailPage`
- `TransactionDetailPage`
- `TransactionHistoryPage`
- `WalletMultiManagerPage`
- `WalletTokenApprovalPage`
- `BuyCryptoPage`

Wallet requirements:
- Asset, balance, history, network, and analytics panels use `VitCard` or a
  documented domain widget inside a shared surface.
- Search uses `VitSearchBar`.
- Forms use `VitInput`.
- Primary actions use `VitCtaButton`.
- Withdraw, transfer, address add, token approval, deposit address copy, and
  payment flows show risk, fee, limit, network, preview, confirm, and result
  where applicable.
- Sensitive addresses and account data are masked where appropriate.
- QR/address/copy controls do not overflow at 360 px.
- Lists have empty and error states.

Focused verification:

```bash
cd flutter_app
flutter test test/features/wallet --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
```

BCC-06 - PROFILE ROOT, SECURITY, API, DEVICE, AND SETTINGS PASS:
Read before editing:

```text
flutter_app/lib/features/profile/presentation/pages/
flutter_app/lib/features/profile/presentation/widgets/
flutter_app/test/features/profile/
```

Priority pages:
- `ProfilePage`
- `SecurityPage`
- `ApiManagementPage`
- `ApiKeyCreatePage`
- `DeviceManagementPage`
- `SettingsPage`
- `KYCPage`
- `EditProfilePage`
- `ActivityLogPage`
- `SubAccountPage`
- `VIPPage`

Profile requirements:
- Root profile hero, account status, VIP, shortcuts, and product sections use
  shared cards/sections.
- Security changes require clear risk, preview/confirm, and result states.
- API keys must remain masked and never expose secrets.
- Device revoke/delete flows need confirmation.
- Settings rows use consistent surfaces, icons, dividers, and touch targets.
- KYC has loading, submitted, rejected, pending, and success states where the
  feature supports them.

Focused verification:

```bash
cd flutter_app
flutter test test/features/profile --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
```

BCC-07 - TRADE P1 BODY CONSISTENCY PASS:
Read before editing:

```text
flutter_app/lib/features/trade/presentation/pages/
flutter_app/lib/features/trade/presentation/widgets/
flutter_app/test/features/trade/
```

P1 clusters:
- Margin: `MarginTradingPage`, `MarginTradingHubPage`, `LeveragePage`,
  `AdvancedTradingDemoPage`
- Analytics: `MarketDataAnalyticsPage`, `LiveMarketDataAnalyticsPage`,
  `AdvancedAnalyticsPage`, `PerformanceAttributionPage`,
  `ExecutionVenueAnalysisPage`, `ExecutionQualityDemoPage`
- Copy trading: `ActiveCopiesPage`, `CopyTradingPage`, `CopyTradingV2Page`,
  `CopyConfigurationPage`, `CopyConfirmationPage`, `CopyProviderDetailPage`,
  `CopyPerformancePage`, `ProviderLeaderboardPage`,
  `ProviderComparisonPage`, `ProviderApplicationPage`
- Regulation: `RegulatoryReportsDashboardPage`,
  `RegulatoryDisclosuresPage`, `RegulatoryInspectionReadyPage`,
  `TransactionReportingPage`, `BestExecutionReportsPage`, `AuditTrailPage`,
  `ClientCategorizationPage`, `ClientMoneyProtectionPage`,
  `CassReconciliationPage`
- Bots: `TradingBotsPage`, `BotRiskDashboardPage`,
  `BotSecuritySettingsPage`, `BotGuidePage`, `BotTaxReportingPage`,
  `BotApiDocumentationPage`, `BotPerformanceAnalyticsPage`,
  `BotPortfolioDashboardPage`, `BotBacktestingPage`,
  `BotOptimizationPage`, `BotDrawdownAnalyzerPage`, `BotEquityCurvePage`,
  `BotEmergencyStopPage`, `BotSuitabilityAssessmentPage`,
  `BotTermsOfServicePage`, `BotRiskDisclosurePage`, `BotFaqPage`,
  `BotHistoryPage`, `BotStrategyComparePage`
- Orders: `TradePage`, `ConvertPage`, `OrderReceiptPage`,
  `OrdersHistoryPage`, `PositionDashboardPage`, `TradeHistoryExportPage`,
  `TradeSettingsPage`
- Tool exceptions: `AdvancedChartPage`, `FuturesPage`

Trade requirements:
- Do not flatten dense trading workspaces into marketing cards.
- Order, leverage, margin, copy trading, and bot control actions must show risk,
  cost, suitability, fee, limit, preview, confirmation, and result states where
  applicable.
- Buy/sell tones must be consistent and tokenized.
- Chart and order book widgets may remain custom but must sit in shared
  surfaces unless they are documented fullscreen tools.
- Regulatory and reporting pages should use consistent dashboard cards, tables,
  filters, and states.

Focused verification:

```bash
cd flutter_app
flutter test test/features/trade --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
```

BCC-08 - P2P HIGH-RISK ORDER, PAYMENT, DISPUTE, AND KYC PASS:
Read before editing:

```text
flutter_app/lib/features/p2p/presentation/pages/
flutter_app/lib/features/p2p/presentation/widgets/
flutter_app/test/features/p2p/
```

P1 clusters:
- Order/escrow: `P2POrderPage`, `P2PEscrowDetailPage`,
  `P2PExpressConfirmPage`, `P2POrderProofPage`, `P2POrderCancelPage`,
  `P2POrderRatePage`, `P2POrderTimelinePage`
- Disputes: `P2PDisputeDetailPage`, `P2PDisputeEvidencePage`,
  `P2PDisputeResolutionPage`, `P2PDisputePage`, `P2PDisputesPage`
- Chat: `P2PChatPage`
- Payment methods: `P2PPaymentMethodsPage`, `P2PPaymentMethodAddPage`,
  `P2PPaymentMethodVerificationPage`, `P2PPaymentMethodOwnershipPage`,
  `P2PPaymentMethodCoolingPeriodPage`, `P2PPaymentMethodHistoryPage`
- KYC/security: `P2PKycRequirementsPage`, `P2PKycStatusPage`,
  `P2PIdentityVerificationPage`, `P2PAddressProofPage`,
  `P2PSelfieVerificationPage`, `P2PVideoVerificationPage`,
  `P2PSecurityCenterPage`, `P2P2FASettingsPage`,
  `P2PDeviceManagementPage`, `P2PAntiPhishingCodePage`,
  `P2PLoginHistoryPage`, `P2PSuspiciousActivityPage`

P2P requirements:
- Escrow release/cancel/dispute actions must show risk and next steps.
- Payment method add/change requires preview, confirmation, and masked sensitive
  data.
- Chat can remain tool-like, but security banners, composer, attachment
  controls, and bottom safe area must not overlap.
- KYC/security flows must use consistent form, upload, review, rejected, and
  success states.

Focused verification:

```bash
cd flutter_app
flutter test test/features/p2p --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
```

BCC-09 - PREDICTION EVENT DETAIL AND RECEIPT PASS:
Read before editing:

```text
flutter_app/lib/features/predictions/presentation/pages/
flutter_app/lib/features/predictions/presentation/widgets/
flutter_app/test/features/predictions/
```

Priority pages:
- `PredictionEventDetailPage`
- `PredictionOrderReceiptPage`
- `PredictionsPortfolioPage`
- `PredictionPortfolioAnalyzerPage`
- `PredictionRiskCalculatorPage`
- `PredictionMarketMakerPage`

Prediction requirements:
- Keep Prediction Markets language: positions, probability, receipt, rewards,
  PnL. Avoid hype or casino language.
- Keep Arena bridge sections visually separated from prediction trading.
- Event detail body should align event header, probability chart, trading panel,
  order book, comments, activity, and bridge modules into consistent surfaces.
- Order receipt must show next steps and result state.

Focused verification:

```bash
cd flutter_app
flutter test test/features/predictions --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
```

BCC-10 - MARKETS CHART/LIST VISUAL QA PASS:
Read before editing:

```text
flutter_app/lib/features/markets/presentation/pages/
flutter_app/lib/features/markets/presentation/widgets/
flutter_app/test/features/markets/
```

QA pages:
- `MarketListPage`
- `PairDetailPage`
- `MarketDepthPage`
- `TokenInfoPage`
- `AdvancedChartsPage`
- `PriceAlertsPage`
- `MarketCalendarPage`
- `ComparisonToolPage`
- `MarketCorrelationsPage`
- `DerivativesOverviewPage`
- `MarketHeatmapPage`
- `MarketMoversPage`
- `MarketNewsPage`
- `MarketOverviewPage`
- `PortfolioTrackerPage`
- `MarketScreenerPage`
- `MarketSectorsPage`
- `SocialSignalsPage`
- `SocialSentimentPage`
- `TokenUnlocksPage`
- `WatchlistPage`

Markets requirements:
- Chart/list-heavy pages may keep custom charts when needed.
- Filters, search, watchlist controls, rows, empty states, and error states
  should use shared patterns.
- Heatmaps, matrices, order books, and advanced charts must not overflow or
  render blank at 360 px.
- Instrument detail pages must preserve instrument chrome/body expectations.

BCC-11 - REMAINING C/D PAGES AND APPROVED EXCEPTIONS:
After the priority batches:
- Re-run the audit tool.
- Review all remaining C and D rows.
- Fix straightforward C pages by replacing local surfaces/controls/states.
- Document approved exceptions in the generated Markdown artifact.
- Keep `admin`, `arena`, `auth`, `cross_module`, `dca`, `dev`, `discovery`,
  `earn`, `home`, `launchpad`, `news`, `notifications`, `onboarding`,
  `referral`, and `support` stable unless the audit shows a real issue.
- Use Earn and Launchpad as references for consistent `VitCard`,
  `VitPageContent`, tabs, and high-risk panels.
- Do not change DCA files with unrelated dirty user work unless required for
  this task; work with current changes rather than reverting them.

BCC-12 - FORMAT, ANALYZE, TESTS, AUDITS, VISUAL QA, AND FINAL DOCS:
Required verification from `flutter_app/`:

```bash
cd flutter_app
dart format .
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/route_coverage_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Focused tests for touched batches:

```bash
flutter test test/features/wallet --reporter=compact
flutter test test/features/profile --reporter=compact
flutter test test/features/trade --reporter=compact
flutter test test/features/p2p --reporter=compact
flutter test test/features/predictions --reporter=compact
flutter test test/features/markets --reporter=compact
```

Visual QA requirements:
- Check 360 x 740.
- Check 390 x 844.
- Check 440 x 956.
- Check one root page per touched feature.
- Check one highest-risk detail/transaction page per touched feature.
- Check fullscreen tool routes if they are touched.
- Verify no horizontal overflow.
- Verify no bottom nav overlap.
- Verify final content can scroll above sticky footers.
- Verify long labels and asset names do not clip.
- Verify loading/empty/error/offline/submitting/success states where reachable.

FINAL DOCUMENTATION:
Update or create these artifacts:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit-Plan.md
```

The final Markdown artifact must state:
- final grade distribution
- fixed pages
- remaining approved exceptions
- high-risk flows verified
- visual QA performed
- commands run
- commands not run and why

DEFINITION OF DONE:
- Body consistency audit artifact exists and is current.
- `body_component_consistency_audit.dart --check` passes.
- Top-header visual archetype audit remains clean.
- Route coverage audit remains clean.
- All routed pages are A/B/Tool, or have documented approved exceptions.
- No unexplained D-grade page remains.
- No unresolved P0/P1 body consistency issue remains.
- Wallet, Trade, Profile, P2P, Markets, and Predictions high-risk pages have
  passed focused review.
- `flutter analyze` passes.
- Focused tests for touched modules pass.
- Full `flutter test --reporter=compact` passes unless blocked by pre-existing
  unrelated failures that are documented with evidence.

FINAL RESPONSE FORMAT:
Lead with what changed and the current status.
Include:
- files changed
- audit grade summary
- high-priority pages fixed or documented
- verification commands run
- any commands not run and why
- remaining risks or approved exceptions

If complete, include this exact line:
BODY COMPONENT CONSISTENCY AUDIT COMPLETE

If incomplete, end with exactly:
RESUME FROM: BCC-<number> - <title>
````
