# VitTrade Remaining Shared Components Migration Plan

**Created:** 2026-06-19
**Status:** Complete
**Owner:** Codex / VitTrade UI migration
**Scope:** Remaining non-A routed screens plus fullscreen Tool screens that need
shared-component adoption review, manual visual QA, or explicit L3 exception
evidence.

## 1. Purpose

This file tracks the remaining work needed to move the whole Flutter app toward
the VitTrade shared-component standard:

- every matching screen pattern uses shared layout, shared widgets, and theme
  tokens;
- local composition remains only when it is a justified L3 domain, tool, or
  product-boundary exception;
- Home remains the visual baseline for app chrome, dark surfaces, card rhythm,
  CTA treatment, state handling, and bottom-nav-safe layout;
- the result remains Flutter enterprise-grade, phone-first, financial-safety
  aware, and consistent across all modules.

The older implementation plan can still record the previous completion state:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md
```

This file is the forward-looking tracker for eliminating or proving the
remaining Grade B / Tool rows from the latest screen audit.

## 2. Current Baseline

Latest local audit snapshot used for this plan:

```text
flutter_app/run-artifacts/shared-component-screen-audit-summary-2026-06-19.md
flutter_app/run-artifacts/shared-component-routed-screen-audit-2026-06-19.csv
flutter_app/run-artifacts/shared-component-page-file-coverage-2026-06-19.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv
```

Current measured state:

| Metric | Count |
| --- | ---: |
| Routed screens audited | 414 |
| Page/part source files covered | 607 |
| Unmapped page files | 0 |
| Grade A routed screens | 404 |
| Grade B routed screens | 5 |
| Fullscreen Tool screens | 5 |
| Token debt | 0 |
| Navigation edges audited | 883 |

Current conclusion:

- The route inventory is complete for current source.
- The token audit is clean.
- Shared-component adoption is high, but not yet strict-100 percent by routed
  body grade because 5 screens remain Grade B and 5 screens are fullscreen Tool
  exceptions.

## 3. Enterprise Standard

Apply this standard before marking any remaining screen complete.

### L0 Token Compliance

- Use `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadii`, `AppDensity`,
  `DeviceMetrics`, and `AppModuleAccents`.
- Do not add raw hex colors, local palettes, local font sizes, local font
  families, raw radii, or one-off spacing systems.
- Keep `AppColors.buy` and `AppColors.sell` semantic only.

### L1 Shared Layout

- Prefer `VitPageLayout`, `VitPageContent`, and `VitInsetScrollView`.
- Use `VitHeader`, `VitTopChrome`, or the existing shell behavior only where
  the screen needs that chrome pattern.
- Keep phone-first layout valid at 360 dp and up.
- Respect status bar, keyboard, safe areas, and bottom-nav clearance.

### L2 Shared Patterns

Use the matching shared primitive before keeping a local equivalent:

| Need | Shared primitive |
| --- | --- |
| Card/surface | `VitCard`, `VitHeroGlow` |
| CTA/action | `VitCtaButton`, `VitIconButton`, `VitInlineIconAction` |
| Section header | `VitSectionHeader` |
| Tabs | `VitTabBar` |
| Form/search | `VitInput`, `VitSearchBar` |
| Status/pills | `VitStatusPill`, `VitAccentPill`, `VitMetricDeltaPill` |
| High-risk flow | `VitHighRiskStatePanel`, `VitOfflineBanner`, `VitErrorState` |
| Loading/empty/error | `VitSkeleton`, `VitEmptyState`, `VitErrorState` |
| Bottom sheet | `VitBottomSheet`, `VitSheetHandle` |
| Action grid | `VitActionTileGrid`, `VitServiceTile` |
| Market/data rows | `VitMarketTickerStrip`, `VitMarketPairRow`, `VitRankedAssetRow`, `VitAssetAvatar`, `VitSparkline` |
| Discovery card | `VitDiscoveryActionCard` |

### L3 Allowed Local Composition

Local widgets may remain only when one of these reasons is documented in the
screen task:

- domain-specific state visualization that no shared component currently
  covers;
- fullscreen tool canvas, chart, chat, or workspace behavior;
- provider or route state wiring;
- financial safety copy, fee/risk/limit disclosure, masking, preview,
  confirmation, receipt, or next-step logic;
- Prediction Markets / Open Arena boundary clarity.

## 4. Product Safety Rules

- Arena stays points-only. Do not introduce wallet, payout, USD profit, P/L, or
  stake-return language into Arena.
- Prediction Markets may use positions, probability, orders, receipt, rewards,
  and P/L. Do not mix Arena Points into Prediction Markets.
- Wallet, Trade, P2P, Earn, DCA, Launchpad, and Prediction flows must preserve
  previews, confirmations, masking, fee/risk/limit copy, loading, submitting,
  success, empty, offline, and error states.
- High-risk actions require explicit preview and confirmation.
- Icon-only controls need tooltips or semantic labels.

## 5. Work Queue

Priority order:

1. P2 fullscreen Tool screens with lower shared usage or high navigation risk.
2. P3 Grade B routed screens with high custom-body count.
3. P3 fullscreen Tool screens after critical tool flows are documented.
4. Final cross-audit verification and docs closure.

### Summary Queue

| ID | Status | Priority | Module | Screen | Grade | Shared | Custom | Target outcome |
| --- | --- | --- | --- | --- | --- | ---: | ---: | --- |
| RSC-01 | Tool accepted | P2 | p2p | `P2PChatPage` | Tool | 9 | 7 | Shared actions/pills applied; fullscreen chat exception documented with visual QA. |
| RSC-02 | Tool accepted | P3 | trade | `AdvancedChartPage` | Tool | 22 | 10 | Chart canvas accepted as L3; toolbar, actions, and sheet surface standardized with visual QA. |
| RSC-03 | Tool accepted | P3 | trade | `TradingBotsPage` | Tool | 54 | 26 | Bot state primitives and action controls standardized; fullscreen bot-tool exception documented with visual QA. |
| RSC-04 | Deferred | P3 | arena | `ArenaPredictionBridgeFoundationPage` | B | 47 | 45 | Shared bridge chips/actions/surfaces applied; remaining Grade B accepted as bridge-boundary L3 visualization. |
| RSC-05 | Deferred | P3 | referral | `ReferralHomePage` | B | 58 | 43 | Shared referral cards/pills/banners/metrics/headers applied; remaining Grade B accepted as referral reward/progress/ledger L3 composition. |
| RSC-06 | Deferred | P3 | earn | `SavingsAutoPilotPage` | B | 65 | 45 | Shared status/action pills, CTA, sheet surface, section headers, and high-risk callout applied; remaining Grade B accepted as savings automation L3 composition. |
| RSC-07 | Deferred | P3 | arena | `ConnectedEcosystemProductionPage` | B | 38 | 40 | Shared ecosystem status/tab/chip primitives applied; remaining Grade B accepted as bridge-registry L3 visualization. |
| RSC-08 | Deferred | P3 | arena | `ArenaChallengeDetailPage` | B | 68 | 37 | Shared sheet surface, warning banners, and action controls applied; remaining Grade B accepted as challenge-detail L3 composition. |
| RSC-09 | Done | P3 | earn | `StakingProofOfReservesPage` | A | 57 | 34 | Shared tabs, banners, sheet surface, CTA controls, and status pills applied; proof/audit semantics preserved. |
| RSC-10 | Tool accepted | P3 | enterprise_states | `EnterpriseStatesPage` | Tool | 46 | 22 | Shared state tabs/banners applied; enterprise-state showcase accepted as fullscreen Tool with visual QA. |
| RSC-11 | Tool accepted | P3 | trade | `FuturesPage` | Tool | 44 | 21 | Futures risk panels and empty action tightened with shared primitives; fullscreen trading tool exception documented with visual QA. |

## 6. Per-Screen Tasks

### RSC-01: P2PChatPage

**Files likely touched:**

```text
flutter_app/lib/features/p2p/presentation/pages/p2p_chat_page.dart
flutter_app/test/features/p2p/
```

**Intent:** Keep the chat experience fullscreen/tool-like, but adopt shared
safe-area chrome, icon actions, sheet handles, empty/error/offline states, and
message action affordances where the patterns match.

**Acceptance criteria:**

- [x] Chat workspace keeps keyboard-safe layout and route back behavior.
- [x] Header/back/action controls use shared chrome or documented L3 reason.
- [x] Empty, offline, sending, failed-message, and blocked-user states are
  covered by shared state primitives or explicit local reasons.
- [x] P2P payment, escrow, and identity copy remain unchanged.
- [x] Body audit row is Grade A or Tool with a documented fullscreen exception.

**Verification:**

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
flutter test test/features/p2p --reporter=compact
flutter analyze
```

**Manual QA:**

- [x] Emulator screenshot at 360 dp or equivalent phone size.
- [x] Keyboard open/close.
- [x] Back/close behavior.
- [x] Nonblank rendering and no overlap with status/nav bars.

### RSC-02: AdvancedChartPage

**Files likely touched:**

```text
flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart
flutter_app/lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart
flutter_app/test/features/trade/advanced_chart_page_test.dart
```

**Intent:** Preserve the fullscreen chart/tool canvas while moving toolbar,
actions, status pills, sheets, and safe exit behavior to shared primitives where
appropriate.

**Acceptance criteria:**

- [x] Chart canvas remains local L3 tool UI with a documented reason.
- [x] Toolbar actions use `VitIconButton`, `VitInlineIconAction`, or documented
  chart-specific local controls.
- [x] Bottom sheets, handles, state panels, and error/offline surfaces use
  shared primitives.
- [x] Pro-trading risk copy and order safety states remain unchanged.
- [x] Tool exception has manual visual QA evidence.

**Verification:**

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
flutter test test/features/trade/advanced_chart_page_test.dart --reporter=compact
flutter test test/features/trade --reporter=compact
flutter analyze
```

**Manual QA:**

- [x] Chart renders nonblank.
- [x] Header/toolbar controls remain tappable.
- [x] No text overlap in landscape-like dense chart states if supported.
- [x] Exit/back behavior is clear.

### RSC-03: TradingBotsPage

**Files likely touched:**

```text
flutter_app/lib/features/trade/presentation/pages/trading_bots_page.dart
flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_01.dart
flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_02.dart
flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_03.dart
flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_04.dart
flutter_app/test/features/trade/
```

**Intent:** Re-evaluate whether this should remain Tool grade. Convert repeated
bot cards, CTA rows, risk panels, tabs, status chips, and section headers to
shared primitives while preserving bot-risk disclosures.

**Acceptance criteria:**

- [x] Repeated cards use `VitCard` or documented bot-specific local cards.
- [x] Risk, emergency stop, and suitability surfaces use
  `VitHighRiskStatePanel` or documented local reasons.
- [x] Tabs and filter chips use `VitTabBar`, `VitTogglePill`, or documented
  domain-specific controls.
- [x] Bot copy remains financial-safety-first and avoids hype.
- [x] Body audit row becomes Grade A where practical, or Tool exception is
  justified with manual QA.

**Verification:**

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
flutter test test/features/trade --reporter=compact
flutter analyze
```

### RSC-04: ArenaPredictionBridgeFoundationPage

**Files likely touched:**

```text
flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page.dart
flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_01.dart
flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_02.dart
flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_03.dart
flutter_app/test/features/arena/
```

**Intent:** Reduce custom bridge sections while preserving explicit separation
between Arena Points and Prediction Markets wallet/value language.

**Acceptance criteria:**

- [x] Bridge cards use `VitCard`, `VitSectionHeader`, `VitStatusPill`, and
  `VitDiscoveryActionCard` where matching.
- [x] Arena copy remains points-only.
- [x] Prediction copy remains probability/position oriented.
- [x] Any local bridge visualization has an L3 boundary reason.
- [x] Body audit row improves to Grade A or has a narrower documented L3 reason.

**Verification:**

```bash
cd flutter_app
flutter test test/features/arena --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

### RSC-05: ReferralHomePage

**Files likely touched:**

```text
flutter_app/lib/features/referral/presentation/pages/referral_home_page.dart
flutter_app/lib/features/referral/presentation/pages/referral_home_page_part_01.dart
flutter_app/lib/features/referral/presentation/pages/referral_home_page_part_02.dart
flutter_app/lib/features/referral/presentation/pages/referral_home_page_part_03.dart
flutter_app/lib/features/referral/presentation/pages/referral_home_page_part_04.dart
flutter_app/test/features/referral/referral_home_page_test.dart
```

**Intent:** Normalize repeated referral cards, reward summaries, CTA blocks, and
section structure with shared components without introducing hype or dark
patterns.

**Acceptance criteria:**

- [x] Referral hero and summary surfaces use shared card/hero primitives.
- [x] CTA rows use `VitCtaButton`, `VitInlineIconAction`, or shared action
  tiles.
- [x] Reward and history sections keep truthful terms and no FOMO language.
- [x] Empty/error/loading states use shared primitives where applicable.
- [x] Body audit row improves to Grade A or records a precise L3 reason.

**Verification:**

```bash
cd flutter_app
flutter test test/features/referral/referral_home_page_test.dart --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

### RSC-06: SavingsAutoPilotPage

**Files likely touched:**

```text
flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page.dart
flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page_part_01.dart
flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page_part_02.dart
flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page_part_03.dart
flutter_app/test/features/earn/
```

**Intent:** Normalize autopilot recommendation, risk, state, and action blocks
with shared components while preserving Earn suitability and risk disclosure.

**Acceptance criteria:**

- [x] Hero, summary, and recommendation cards use `VitCard` variants and shared
  section headers.
- [x] Risk/suitability areas use `VitHighRiskStatePanel` or a documented Earn
  domain reason.
- [x] Toggles, tabs, and CTA controls use shared primitives where matching.
- [x] Fees, lockup, yield, risk, and next-step copy remain visible.
- [x] Body audit row improves to Grade A or records a narrower L3 reason.

**Verification:**

```bash
cd flutter_app
flutter test test/features/earn --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

### RSC-07: ConnectedEcosystemProductionPage

**Files likely touched:**

```text
flutter_app/lib/features/arena/presentation/pages/connected_ecosystem_production_page.dart
flutter_app/lib/features/arena/presentation/pages/connected_ecosystem_production_page_part_01.dart
flutter_app/lib/features/arena/presentation/pages/connected_ecosystem_production_page_part_02.dart
flutter_app/lib/features/arena/presentation/pages/connected_ecosystem_production_page_part_03.dart
flutter_app/test/features/arena/
```

**Intent:** Normalize ecosystem status, route, and canonical screen cards with
shared components while preserving cross-module boundary clarity.

**Acceptance criteria:**

- [x] Canonical screen cards and production-readiness sections use shared card,
  status, section, and action primitives.
- [x] Any ecosystem-specific diagram/local visualization has an L3 reason.
- [x] Arena/Prediction/wallet boundaries remain visually and semantically
  separated.
- [x] Body audit row improves to Grade A or records narrower exceptions.

**Verification:**

```bash
cd flutter_app
flutter test test/features/arena --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

### RSC-08: ArenaChallengeDetailPage

**Files likely touched:**

```text
flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page.dart
flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page_part_01.dart
flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page_part_02.dart
flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page_part_03.dart
flutter_app/test/features/arena/arena_challenge_detail_page_test.dart
```

**Intent:** Polish the remaining custom challenge detail sections while keeping
Arena points-only performance, leaderboard, rule, and completion semantics.

**Acceptance criteria:**

- [x] Challenge hero, rule/status panels, participant rows, and action areas use
  shared primitives where matching.
- [x] Arena Points copy is preserved.
- [x] No wallet, payout, profit, stake-return, or USD payout wording appears.
- [x] Local challenge-specific visualization has an L3 reason.
- [x] Body audit row improves to Grade A or records precise accepted local
  composition reasons.

**Verification:**

```bash
cd flutter_app
flutter test test/features/arena/arena_challenge_detail_page_test.dart --reporter=compact
flutter test test/features/arena --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

### RSC-09: StakingProofOfReservesPage

**Files likely touched:**

```text
flutter_app/lib/features/earn/presentation/pages/staking_proof_of_reserves_page.dart
flutter_app/lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_01.dart
flutter_app/lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_02.dart
flutter_app/lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_03.dart
flutter_app/test/features/earn/
```

**Intent:** Normalize proof, reserves, audit status, and transparency sections
with shared components while preserving trust and verification semantics.

**Acceptance criteria:**

- [x] Reserve metric cards and proof status rows use shared card/status
  primitives.
- [x] Audit, proof, and custody copy remains precise and trust-first.
- [x] Any proof visualization or chart keeps an L3 reason.
- [x] Loading/error/empty states use shared primitives where applicable.
- [x] Body audit row improves to Grade A or records a narrower exception.

**Verification:**

```bash
cd flutter_app
flutter test test/features/earn --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

### RSC-10: EnterpriseStatesPage

**Files likely touched:**

```text
flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart
flutter_app/lib/features/enterprise_states/presentation/widgets/enterprise_states_hero_tabs.dart
flutter_app/test/features/enterprise_states/enterprise_states_page_test.dart
```

**Intent:** Confirm the enterprise-state showcase behaves as a tool/demo
surface while using shared state primitives wherever the page is demonstrating
real app states.

**Acceptance criteria:**

- [x] State examples use `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`,
  `VitSkeleton`, and `VitHighRiskStatePanel` where matching.
- [x] Showcase/demo-only composition is documented as L3 Tool surface.
- [x] Safe areas, back/close behavior, and nonblank rendering are manually
  verified.
- [x] Body audit remains Tool with evidence or improves without losing demo
  coverage.

**Verification:**

```bash
cd flutter_app
flutter test test/features/enterprise_states/enterprise_states_page_test.dart --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

### RSC-11: FuturesPage

**Files likely touched:**

```text
flutter_app/lib/features/trade/presentation/pages/futures_page.dart
flutter_app/lib/features/trade/presentation/pages/futures_page_part_01.dart
flutter_app/lib/features/trade/presentation/pages/futures_page_part_02.dart
flutter_app/lib/features/trade/presentation/pages/futures_page_part_03.dart
flutter_app/test/features/trade/
```

**Intent:** Keep the futures trading surface pro-grade while moving repeated
cards, tabs, risk panels, and action areas to shared primitives where possible.

**Acceptance criteria:**

- [x] Risk/margin/leverage panels use `VitHighRiskStatePanel` or documented
  futures-specific local composition.
- [x] Tabs, cards, status pills, and CTA groups use shared primitives.
- [x] Margin, liquidation, fee, leverage, and order-risk copy remains visible.
- [x] Tool exception has manual visual QA or body audit improves to Grade A.

**Verification:**

```bash
cd flutter_app
flutter test test/features/trade --reporter=compact
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

## 7. Batch Workflow

Run this workflow for each RSC task.

1. Refresh local truth:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

2. Read only the target page, part files, local widgets, and focused tests.
3. Use GitNexus before code edits:

```text
context({name: "<target screen class>"})
impact({target: "<target screen class>", direction: "upstream"})
```

4. If GitNexus returns HIGH or CRITICAL, narrow the edit and record the direct
   callers/processes before proceeding.
5. Migrate only matching patterns to shared primitives.
6. Keep L3 local composition only with a written reason.
7. Run focused tests and audits.
8. Run `detect_changes({scope: "all"})` before committing or broad handoff.
9. Update this tracker row status and evidence.

## 8. Status Values

Use these statuses in the queue:

| Status | Meaning |
| --- | --- |
| Todo | Not started. |
| In progress | Source inspection or implementation has started. |
| Blocked | Three concrete attempts failed and no safe route around the blocker exists. |
| Grade A | Body audit reports Grade A after migration. |
| Tool accepted | Fullscreen Tool exception remains, with manual visual QA and L3 reasons. |
| Deferred | Intentional product or platform decision, with owner and reason. |

## 9. Evidence Template

Add a batch log entry here after each task.

```text
Batch:
Date:
Status:
Screen:
Files:
Shared components applied:
L3 local reasons:
GitNexus evidence:
Tests/audits:
Before grade/shared/custom:
After grade/shared/custom:
Manual visual QA:
Notes:
```

Batch: RSC-01
Date: 2026-06-19
Status: Tool accepted
Screen: `P2PChatPage`
Files:
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_chat_header_banners.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_chat_composer_actions.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_chat_page.dart` (format only)
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_chat_messages.dart` (format only)
Shared components applied:
- `VitStatusPill` for E2E encryption and quick-reply/status chips.
- `VitIconButton` for compact header detail action.
- `VitInlineIconAction` inside chat composer/header round icon affordances to add consistent semantics and tooltips while preserving the fullscreen chat hit targets.
L3 local reasons:
- Fullscreen chat workspace, message bubbles, reply carousel, risk/E2E safety banners, and keyboard-aware composer remain local because they are route-specific P2P chat/tool behavior with escrow/payment safety copy.
GitNexus evidence:
- `context(P2PChatPage)`: direct incoming route/test references only; no execution-flow membership reported.
- `impact(P2PChatPage, upstream)`: transitive CRITICAL because the route graph imports the page. Narrowed to `maxDepth: 1`, which returned LOW with 2 direct callers and no affected processes.
- Private target widgets (`_RoundIconButton`, `_SmallHeaderButton`, `_ReplyChip`, `_EncryptionPill`, `_ChatComposer`, risk/E2E banners) returned LOW/0 direct affected processes before edit.
- `detect_changes(scope: all)`: low risk and no affected processes, but the report includes many pre-existing dirty worktree files, so it is recorded as broad-worktree evidence rather than RSC-01-only scope.
Tests/audits:
- `flutter test test/features/p2p/p2p_chat_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/p2p --reporter=compact`: passed, 315 tests; log at `flutter_app/run-artifacts/p2p-suite-rsc01.log`.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
Before grade/shared/custom: Tool / 2 / 7
After grade/shared/custom: Tool / 9 / 7
Manual visual QA:
- `flutter_app/run-artifacts/p2p-chat-rsc01.png`: chat route nonblank, status/nav safe, shared header and composer controls visible.
- `flutter_app/run-artifacts/p2p-chat-rsc01-keyboard.png`: input focused without composer/status/nav overlap.
- `flutter_app/run-artifacts/p2p-chat-rsc01-after-back.png`: Android back closes input overlay and stays on chat route.
- `flutter_app/run-artifacts/p2p-chat-rsc01-header-back.png`: header back returns to P2P order detail route.
- `flutter_app/run-artifacts/p2p-chat-rsc01-ui.xml`: semantic labels/tooltips present for back, detail, E2E, image attach, send, and quick replies.
Notes:
- P2P payment, escrow, order id, identity, and E2E copy were preserved.

Batch: RSC-02
Date: 2026-06-19
Status: Tool accepted
Screen: `AdvancedChartPage`
Files:
- `flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart`
- `flutter_app/lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart`
- `flutter_app/lib/features/trade/presentation/widgets/advanced_chart_area_actions.dart`
Shared components applied:
- `VitIconButton` now handles chart-type controls with explicit tooltips.
- `VitStatusPill` now handles the indicator trigger badge/count.
- `VitCtaButton` now handles buy/sell action buttons.
- `VitSheetSurface` keeps the indicator sheet aligned with shared sheet styling, with tokenized bottom-nav clearance.
L3 local reasons:
- Chart canvas and `_AdvancedTradeChartPainter` remain local because this is a fullscreen pro chart workspace.
- The compact timeframe rail remains a chart-specific local wrapper around `VitCard`; attempting to use `VitTabBar` would either introduce a test hit-target warning or require a high-risk shared-widget change.
- Indicator option rows remain local because they encode chart-indicator color swatches and toggle state specific to the chart tool.
GitNexus evidence:
- `context(AdvancedChartPage)`: direct route/test references only; no execution-flow membership.
- `impact(AdvancedChartPage, upstream)`: transitive CRITICAL through route/navigation graph; narrowed to `maxDepth: 1`, LOW with 2 direct callers and no affected processes.
- `_ChartToolbar`, `_TimeframeButton`, `_ChartTypeButton`, `_TradeActionButton`, `_IndicatorSheet`, and `_IndicatorOption`: LOW/0 affected processes before edit.
- `impact(VitTabBar, upstream)`: CRITICAL with 102 direct users; no shared global edit was made.
- `detect_changes(scope: all)`: low risk and no affected processes, but the dirty worktree is broad and includes many pre-existing changes.
Tests/audits:
- `flutter test test/features/trade/advanced_chart_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/trade --reporter=compact`: passed, 350 tests; log at `flutter_app/run-artifacts/trade-suite-rsc02.log`.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: Tool / 24 / 9, issue priority P2
After grade/shared/custom: Tool / 22 / 10, issue priority P3
Manual visual QA:
- `flutter_app/run-artifacts/advanced-chart-rsc02.png`: chart route nonblank, toolbar visible, canvas framed, no status/nav overlap.
- `flutter_app/run-artifacts/advanced-chart-rsc02-sheet.png`: indicator sheet opens with shared handle/surface and bottom-nav clearance; `Volume` row visible.
- `flutter_app/run-artifacts/advanced-chart-rsc02-after-close.png`: close action returns to chart route.
- `flutter_app/run-artifacts/advanced-chart-rsc02-back.png`: back action returns to the Trade pair route.
- `flutter_app/run-artifacts/advanced-chart-rsc02-sheet-ui.xml`: semantic labels present for close, chart type controls, indicator trigger, buy/sell, alert, and timeframe controls.
Notes:
- Shared count decreased because generic `VitCard` wrappers were replaced by more specific shared controls; the audit priority improved from P2 to P3 and layout/surface/controls all pass.

Batch: RSC-03
Date: 2026-06-19
Status: Tool accepted
Screen: `TradingBotsPage`
Files:
- `flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_02.dart`
- `flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_03.dart`
Shared components applied:
- `VitCtaButton` now handles bot pause/resume actions with success/warning variants.
- `VitIconButton` now handles bot settings and delete compact actions with explicit Vietnamese tooltips.
- `VitBanner` now handles the bot suitability/risk information surface.
- `VitEmptyState` now handles the no-bots state and route-to-strategy action.
L3 local reasons:
- The fullscreen bot management workspace remains Tool grade because it combines live bot lists, strategy cards, create-bot sheet state, and financial-risk acknowledgement flow.
- Bot cards and strategy cards keep local structure where they bind bot status, allocations, projected ranges, and strategy suitability copy that does not map cleanly to one existing shared primitive.
- The success toast remains local to preserve the create-bot confirmation copy and route-specific close behavior.
GitNexus evidence:
- `context(TradingBotsPage)`: direct route/test imports only; no execution-flow membership.
- `impact(TradingBotsPage, upstream)`: transitive CRITICAL through route graph; narrowed to `maxDepth: 1`, LOW with 2 direct callers and no affected processes.
- `_BotActionButton`, `_BotCard`, `_EmptyBots`, `_CreateBotSheet`, `_SuccessToast`, and `_BotInfoCard`: LOW/0 affected processes before edit.
- `detect_changes(scope: all)`: low risk and no affected processes, but the dirty worktree is broad and includes pre-existing RSC batches and user changes.
Tests/audits:
- `flutter test test/features/trade/trading_bots_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/trade --reporter=compact`: passed, 350 tests; log at `flutter_app/run-artifacts/trade-suite-rsc03.log`.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart`: refreshed navigation edge artifacts.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: Tool / 57 / 29, issue priority P2
After grade/shared/custom: Tool / 54 / 26, issue priority P3
Manual visual QA:
- `flutter_app/run-artifacts/trading-bots-rsc03.png`: bot route nonblank, header/hero/list visible, shared settings/delete controls visible.
- `flutter_app/run-artifacts/trading-bots-rsc03-strategies.png`: strategy tab nonblank, performance card and create-bot CTA visible.
- `flutter_app/run-artifacts/trading-bots-rsc03-sheet.png`: create-bot sheet opens with risk acknowledgement and disabled submit state.
- `flutter_app/run-artifacts/trading-bots-rsc03-sheet-checked.png`: risk acknowledgement enables `Khởi chạy DCA Bot`.
- `flutter_app/run-artifacts/trading-bots-rsc03-success.png`: success toast appears after bot creation.
- `flutter_app/run-artifacts/trading-bots-rsc03-android-back.png`: Android back leaves the app from the route, proving no route trap after the flow.
- `flutter_app/run-artifacts/trading-bots-rsc03-ui.xml`, `trading-bots-rsc03-strategies-ui.xml`, `trading-bots-rsc03-sheet-ui.xml`, `trading-bots-rsc03-sheet-checked-ui.xml`, and `trading-bots-rsc03-success-ui.xml`: semantic labels/tooltips present for bot actions, tabs, risk acknowledgement, submit, and success close behavior.
Notes:
- Bot financial safety copy and risk acknowledgement flow were preserved.
- Body audit now reports state/surface/controls/layout/responsive/copy-boundary checks as passing for this Tool row.

Batch: RSC-04
Date: 2026-06-19
Status: Deferred - Grade B with accepted L3 boundary reason
Screen: `ArenaPredictionBridgeFoundationPage`
Files:
- `flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_01.dart`
- `flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_02.dart`
- `flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_03.dart`
Shared components applied:
- `VitStatusPill` now handles the section tabs while preserving tab keys and horizontal scrolling.
- `VitStatusPill` now handles topic chips and bridge disclosure badges.
- `VitCard` now wraps the dual profile module stat actions with shared tap/radius/border behavior.
- `VitCard` now wraps demo frames instead of local `Material`/shape surfaces.
L3 local reasons:
- The page remains Grade B because the audit counts repeated vertical spacing and bridge-specific demo/boundary visualization tokens; all substatus checks pass and `primary_issue` is `none`.
- `_ToneIcon`, `_InfoRow`, `_MiniMetric`, and demo/boundary frame composition remain local because they encode explicit Arena-vs-Prediction separation rules and mandatory boundary disclosure examples.
- The screen is documentation-like product governance UI, not a transactional flow; forcing generic discovery cards would reduce clarity around points-only and prediction-position boundaries.
GitNexus evidence:
- `context(ArenaPredictionBridgeFoundationPage)`: direct route/test references only; no execution-flow membership.
- `impact(ArenaPredictionBridgeFoundationPage, upstream)`: transitive CRITICAL through route graph; narrowed to `maxDepth: 1`, LOW with 2 direct callers and no affected processes.
- `_BridgeTabPill`, `_TopicChip`, `_BridgeBadge`, `_ModuleStatButton`, and `_DemoFrame`: LOW/0 affected processes before edit.
- `detect_changes(scope: all)`: low risk and no affected processes, but dirty worktree remains broad due prior batches and user changes.
Tests/audits:
- `flutter test test/features/arena/arena_prediction_bridge_foundation_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/arena --reporter=compact`: passed, 111 tests; log at `flutter_app/run-artifacts/arena-suite-rsc04.log`.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: B / 25 / 45
After grade/shared/custom: B / 47 / 45, issue priority P3, `primary_issue=none`
Manual visual QA:
- `flutter_app/run-artifacts/arena-bridge-rsc04-principles.png`: principles baseline nonblank with shared tab pills and bottom-nav clearance.
- `flutter_app/run-artifacts/arena-bridge-rsc04-topics.png`: topics tab nonblank; shared topic chips are tappable buttons.
- `flutter_app/run-artifacts/arena-bridge-rsc04-boundary.png`: boundary tab preserves explicit Arena/Prediction disclosure copy.
- `flutter_app/run-artifacts/arena-bridge-rsc04-bridge.png`: bridge tab preserves separated profile actions and mandatory badge examples.
- `flutter_app/run-artifacts/arena-bridge-rsc04-examples.png`: examples tab preserves correct/blocked bridge usage frames and no wallet/PnL leakage into Arena examples.
- `flutter_app/run-artifacts/arena-bridge-rsc04-back.png`: header back returns to `SC-184 ArenaHomePage`.
- Matching `arena-bridge-rsc04-*.xml` files confirm tabs, topic chips, headings, and back semantics are present.
Notes:
- Arena copy stayed points-only and Prediction copy stayed probability/position oriented.
- Remaining Grade B is intentionally documented as L3 bridge-boundary visualization rather than migrated mechanically by hiding spacing tokens.

Batch: RSC-05
Date: 2026-06-19
Status: Deferred - Grade B with accepted L3 referral reason
Screen: `ReferralHomePage`
Files:
- `flutter_app/lib/features/referral/presentation/pages/referral_home_page_part_01.dart`
- `flutter_app/lib/features/referral/presentation/pages/referral_home_page_part_03.dart`
- `flutter_app/lib/features/referral/presentation/pages/referral_home_page_part_04.dart`
Shared components applied:
- `VitCard` now wraps the campaign banner and extra reward strip while preserving the campaign key, border, and dark promotional surface.
- `VitBanner` now handles non-dense warning/info referral notices where the shared banner palette matches.
- `VitCard` now wraps dense/custom notice surfaces that still need referral-specific background and border colors.
- `VitStatusPill` now handles the compact copy-code action.
- `VitAccentPill` now handles repeated tiny referral status chips.
- `VitMetricCard` now handles calculator and month-stat metric boxes.
- `VitModuleSectionHeader` now handles section titles with no read-only trailing text.
L3 local reasons:
- The page remains Grade B because the audit still counts referral-specific reward/progress/ledger composition and repeated vertical spacing tokens as custom body pressure; all substatus checks pass and `primary_issue=none`.
- `_HeroMetric`, `_SocialProofPill`, `_MilestoneCard`, `_PendingCommissionCard`, `_RewardCard`, `_LeaderboardRow`, `_DetailLinkRow`, `_StepRow`, `_CampaignHistoryCard`, `_HistoryDatum`, `_IconBubble`, `_InlineIconText`, `_ProgressBar`, and `_Avatar` remain local because they bind referral code, KYC bonus, commission, progress, leaderboard, campaign history, and read-only local navigation semantics that do not map cleanly to a single existing shared primitive.
- `_SectionTitle` keeps a local trailing-text path only where the UI needs a read-only right-side value; existing shared section headers expose action labels, not static metric labels.
GitNexus evidence:
- `context(ReferralHomePage)`: direct route/test imports only; no execution-flow membership.
- `impact(ReferralHomePage, upstream, maxDepth: 1)`: LOW with 2 direct callers (`_discoveryAndReferralRoutes`, `app_router.dart`) and no affected processes.
- `_CampaignBanner`, `_TinyPill`, `_CompactAction`, `_SectionTitle`, `_MetricBox`, and `_NoticeCard`: LOW/0 affected processes before edit.
- `detect_changes(scope: all)`: low risk and no affected processes, but the dirty worktree is broad and includes pre-existing user/RSC changes, so it is recorded as broad-worktree evidence.
Tests/audits:
- `flutter test test/features/referral/referral_home_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/referral --reporter=compact`: passed, 23 tests.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: B / 36 / 44
After grade/shared/custom: B / 58 / 43, issue priority P3, `primary_issue=none`
Manual visual QA:
- `flutter_app/run-artifacts/referral-home-rsc05.png`: visual-QA frame route `/referral` is nonblank; header/status/nav safe; campaign banner, safety notice, pending KYC card, hero, copy CTA, and bottom nav show without overlap.
Notes:
- Referral copy, code/link copy behavior, share sheet behavior, pending-KYC navigation, detail-link navigation, and no-FOMO product language were preserved.

Batch: RSC-06
Date: 2026-06-19
Status: Deferred - Grade B with accepted L3 savings automation reason
Screen: `SavingsAutoPilotPage`
Files:
- `flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page_part_01.dart`
- `flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page_part_03.dart`
Shared components applied:
- `VitStatusPill` now handles the AutoPilot status control while preserving `SavingsAutoPilotPage.statusButtonKey` and toggle behavior.
- `VitCtaButton` now handles the overview `Xem tất cả` action.
- `VitSheetSurface` now wraps the action detail bottom sheet.
- `VitAccentPill` now handles action/module/status chips.
- `VitStatusPill` now handles selectable budget choices.
- `VitModuleSectionHeader` now handles AutoPilot section headers.
- `VitHighRiskStatePanel` now handles the AutoPilot risk review/disclaimer callout.
L3 local reasons:
- The page remains Grade B because the audit still counts savings automation risk parameters, progress indicators, dense action rows, module rows, and repeated vertical spacing as custom body pressure; all substatus checks pass, `financial_safety_status=pass`, and `primary_issue=none`.
- `_RiskParameter`, `_MetricGrid`, `_ModuleTile`, `_ApprovalCard`, `_ActionTile`, `_ModeCard`, `_BudgetCard`, `_SwitchRow`, `_IconBadge`, and helper mapping functions remain local because they bind savings automation rules, approval state, DCA/rebalance/switch-product actions, and Earn suitability/risk controls that do not map cleanly to a single shared primitive.
GitNexus evidence:
- `context(SavingsAutoPilotPage)`: direct route/test imports only; no execution-flow membership.
- `impact(SavingsAutoPilotPage, upstream, maxDepth: 1)`: LOW with 2 direct callers (`_earnRoutes`, `app_router.dart`) and no affected processes.
- `_StatusButton`, `_SmallPill`, `_ChoicePill`, `_SectionTitle`, `_ActionDetailSheet`, `_InfoCallout`, and `_OverviewTab`: LOW/0 affected processes before edit.
- `detect_changes(scope: all)`: low risk and no affected processes, but dirty worktree remains broad due prior batches and user changes.
Tests/audits:
- `flutter test test/features/earn/savings_autopilot_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/earn --reporter=compact`: passed; log at `flutter_app/run-artifacts/earn-suite-rsc06.log`.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: B / 46 / 45
After grade/shared/custom: B / 65 / 45, issue priority P3, `financial_safety_status=pass`, `primary_issue=none`
Manual visual QA:
- `flutter_app/run-artifacts/savings-autopilot-rsc06.png`: visual-QA frame route `/earn/savings/autopilot` is nonblank; header/status/nav safe; hero status pill, tabs, metric grid, module list, and bottom nav show without overlap.
Notes:
- Savings automation copy, approval queue behavior, approve/skip actions, settings mode/budget changes, DCA route navigation, and Earn risk disclaimer remained visible.

### Batch RSC-07: ConnectedEcosystemProductionPage

Status: Deferred - Grade B accepted with L3 bridge-registry reason.

Shared component changes:
- `VitStatusPill` now handles the primary ecosystem section tabs and Dev/QA
  handoff board chips while preserving existing widget keys and tap behavior.
- `VitStatusPill` now handles production/readiness status labels.
- `VitAccentPill` now handles local mini pills for sources, bridge components,
  route registry values, forbidden UX severity, and QA severity labels with
  semantic status mapping.
L3 local reasons:
- The page remains Grade B because the audit still counts connected ecosystem
  timeline rows, canonical route cards, registry rows, handoff rows, route
  disclosure text, and flow connector visuals as custom body pressure; all
  substatus checks pass, `financial_safety_status=not_applicable`, and
  `primary_issue=none`.
- `_FlowStepRow`, `_RegistryBoard`, `_RegistryItemRow`,
  `_ForbiddenPatternCard`, `_HandoffCard`, `_HandoffRow`, `_SummaryMetric`,
  `_InfoLine`, `_SmallTextAction`, `_TintIcon`, and route/status helper
  functions remain local because they encode Arena/Prediction boundary
  semantics, bridge handoff registry details, and route-flow visuals that do
  not map cleanly to a single shared primitive.
GitNexus evidence:
- `context(ConnectedEcosystemProductionPage)`: direct route/test imports only;
  no execution-flow membership.
- `impact(ConnectedEcosystemProductionPage, upstream, maxDepth: 1)`: LOW with 2
  direct callers (`_arenaExtendedRoutes`, `app_router.dart`) and no affected
  processes.
- `_TabPill`, `_BoardChip`, `_StatusPill`, `_MiniPill`,
  `_SmallTextAction`, and `_SummaryMetric`: LOW/0 affected processes before
  edit.
- `detect_changes(scope: all)`: low risk and no affected processes, but dirty
  worktree remains broad due prior batches and user changes.
Tests/audits:
- `flutter test test/features/arena/connected_ecosystem_production_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/arena --reporter=compact`: passed.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with
  `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit
  artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: B / 21 / 40
After grade/shared/custom: B / 38 / 40, issue priority P3,
`financial_safety_status=not_applicable`, `primary_issue=none`
Manual visual QA:
- `flutter_app/run-artifacts/arena-ecosystem-rsc07.png`: visual-QA frame route
  `/arena/ecosystem` is nonblank; header, hero, shared tabs, canonical cards,
  status pills, bottom nav, and cross-module bridge copy render without
  first-viewport overlap.
Notes:
- Arena points-only and Prediction Markets boundary copy remained separated;
  wallet/financial merge language was not introduced.

### Batch RSC-08: ArenaChallengeDetailPage

Status: Deferred - Grade B accepted with L3 challenge-detail composition reason.

Shared component changes:
- `VitSheetSurface` now wraps challenge action sheets.
- `VitBanner` now handles challenge warning/footer banners.
- `VitCtaButton` now handles secondary challenge actions and the community
  rules link.
L3 local reasons:
- The page remains Grade B because the audit still counts live countdown,
  team/member chips, rule rows, participant/activity rows, progress bars,
  prediction-context bridge detail, and creator/safety route cards as custom
  body pressure; all substatus checks pass,
  `financial_safety_status=not_applicable`, and `primary_issue=none`.
- `_LiveStatusCard`, `_RewardCard`, `_TeamsSection`, `_TeamCard`,
  `_MemberChip`, `_RuleSummaryCard`, `_GovernanceCard`, `_ClarityCard`,
  `_CreatorCard`, `_SafetyLinkCard`, `_RulesList`, `_ParticipantsPanel`,
  `_ActivityPanel`, `_PredictionBridgeCard`, `_SafetySnapshotCard`,
  `_SummaryRow`, `_InfoCard`, `_InlineAction`, `_StatColumn`, `_LiveDot`,
  `_SmallIcon`, `_IconBubble`, and `_InitialBadge` remain local because they
  encode challenge-specific scoring, Arena Points, team identity, rules,
  evidence, safety, and cross-module market-context semantics.
GitNexus evidence:
- `context(ArenaChallengeDetailPage)`: direct route/test imports only; no
  execution-flow membership.
- `impact(ArenaChallengeDetailPage, upstream, maxDepth: 1)`: LOW with 2 direct
  callers (`_arenaCoreRoutes`, `app_router.dart`) and no affected processes.
- `_showActionSheet`: LOW with 4 direct sheet callers and no affected
  processes.
- `_InfoBanner`, `_SecondaryAction`, and `_CommunityRulesLink`: LOW/0 affected
  processes before edit.
- `detect_changes(scope: all)`: low risk and no affected processes, but dirty
  worktree remains broad due prior batches and user changes.
Tests/audits:
- `flutter test test/features/arena/arena_challenge_detail_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/arena --reporter=compact`: passed.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with
  `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit
  artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart`: regenerated navigation artifact.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: B / 58 / 37
After grade/shared/custom: B / 68 / 37, issue priority P3,
`financial_safety_status=not_applicable`, `primary_issue=none`
Manual visual QA:
- `flutter_app/run-artifacts/arena-challenge-detail-rsc08.png`: visual-QA frame
  route `/arena/challenge/ch003` is nonblank; header, status pills, challenge
  title, live status card, points-only review, pool/action cards, and bottom nav
  render without first-viewport text overlap.
Notes:
- Arena Points copy stayed points-only; no wallet, payout, profit, stake-return,
  or USD payout wording was introduced.

### Batch RSC-09: StakingProofOfReservesPage

Status: Done - upgraded to Grade A.

Shared component changes:
- `VitBanner` now handles the proof-of-reserves info banner.
- `VitTabBar` now handles Overview / By Asset / Verify tabs while preserving
  test keys.
- `VitCtaButton` now handles verify, submit, close, and audit report actions.
- `VitSheetSurface` now wraps the Merkle proof verification sheet.
- `VitAccentPill` now handles proof/audit status pills with semantic status
  mapping.
L3 local reasons:
- `_ReserveProgressPainter` and `_ReserveTrendPainter` remain local because
  they render reserve-ratio proof visualizations.
- `_SmallMetric`, `_InnerMetric`, `_AssetReserveCard`,
  `_AuditReportCard`, `_VerificationStepCard`, `_TextInput`, `_HashCard`,
  `_SheetTitle`, `_ReserveProgress`, and proof formatting helpers remain local
  because they bind reserve amounts, liabilities, Merkle hashes, wallet
  addresses, and proof-specific verification semantics.
GitNexus evidence:
- `context(StakingProofOfReservesPage)`: direct route/test imports only; no
  execution-flow membership.
- `impact(StakingProofOfReservesPage, upstream, maxDepth: 1)`: LOW with 2
  direct callers (`_earnRoutes`, `app_router.dart`) and no affected processes.
- `_ReserveTabs`, `_InfoBanner`, `_VerifyTab`, `_AuditReportCard`,
  `_VerifySheet`, `_VerifySheetState`, `_form`, `_proofView`, and
  `_StatusPill`: LOW/0 affected processes before edit except `_form` and
  `_proofView`, each with 1 direct caller (`_VerifySheetState.build`) and no
  affected processes.
- `detect_changes(scope: all)`: low risk and no affected processes, but dirty
  worktree remains broad due prior batches and user changes.
Tests/audits:
- `flutter test test/features/earn/staking_proof_of_reserves_page_test.dart --reporter=compact`: passed.
- `flutter test test/features/earn --reporter=compact`: passed.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with
  `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit
  artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed with
  `grade_A=404`, `grade_B=5`.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart`: regenerated navigation artifact.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: B / 41 / 36
After grade/shared/custom: A / 57 / 34, issue priority P3,
`financial_safety_status=not_applicable`, `primary_issue=none`
Manual visual QA:
- `flutter_app/run-artifacts/staking-proof-reserves-rsc09.png`: visual-QA frame
  route `/earn/proof-of-reserves` is nonblank; info banner, shared tabs,
  reserve card, custom chart, proof metrics, and bottom nav render without
  first-viewport overlap.
Notes:
- Proof/audit/verification copy remained explicit and non-promissory.

### Batch RSC-10: EnterpriseStatesPage

Status: Tool accepted - shared demo controls tightened while preserving the
fullscreen enterprise-state showcase.

Shared component changes:
- `VitTabBar` now handles the A / B / C state-kit section selector while
  preserving the existing section test keys.
- `VitBanner` now handles the implementation reference banner.
- Existing shared state primitives remain the center of the preview kit:
  `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`, `VitSkeleton`,
  `VitSkeletonList`, and `VitCtaButton`.
L3 local reasons:
- The phone-frame preview, state-demo canvas, reference tiles, and visual
  showcase layout remain local because this screen is itself a fullscreen UI
  state demonstration tool.
- The local preview cards bind mock enterprise state examples to product copy
  and visual QA references rather than representing reusable app content.
GitNexus evidence:
- `context(EnterpriseStatesPage)`: direct route/test imports only; no
  execution-flow membership.
- `impact(EnterpriseStatesPage, upstream, maxDepth: 1)`: LOW with 2 direct
  callers (`_utilityRoutes`, `app_router.dart`) and no affected processes.
- `_SectionTabs`, `_SectionTabButton`, and `_ReferenceBanner`: LOW/0 affected
  processes before edit.
Tests/audits:
- `flutter test test/features/enterprise_states --reporter=compact`: passed.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with
  `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit
  artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart`: regenerated navigation artifact.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: Tool / 41 / 23
After grade/shared/custom: Tool / 46 / 22, issue priority P3,
`financial_safety_status=not_applicable`,
`primary_issue=fullscreen_tool_manual_visual_qa_required`
Manual visual QA:
- `flutter_app/run-artifacts/enterprise-states-rsc10.png`: visual-QA frame
  route `/enterprise-states` is nonblank; shared section tabs, state preview,
  status pills, showcase copy, and bottom nav render without first-viewport
  overlap at 440 x 956.
Notes:
- The Tool grade is accepted because the page is a fullscreen UI-state demo
  surface; matching shared state primitives are already used where the examples
  map to real app states.

### Batch RSC-11: FuturesPage

Status: Tool accepted - futures trading surface preserved with narrower local
composition.

Shared component changes:
- `VitBanner` now handles the futures high-risk warning copy in the trade tab.
- A second `VitHighRiskStatePanel` now handles the futures order-review
  checklist summary alongside the existing margin-review panel.
- The orders empty-state action now uses `VitCtaButton` instead of a local
  `TextButton`.
L3 local reasons:
- Long/Short side switching, order type switching, percentage sizing, TP/SL
  toggles, preview rows, position cards, and account metric rows remain local
  because they are tightly bound to futures order-entry, margin, liquidation,
  and P/L semantics.
- The screen remains Tool grade because it is a dense pro-trading fullscreen
  workflow with margin/leverage review rather than a normal content page.
GitNexus evidence:
- `context(FuturesPage)`: direct route/test imports only; no execution-flow
  membership.
- `impact(FuturesPage, upstream, maxDepth: 1)`: LOW with 2 direct callers
  (`_tradeRoutes`, `app_router.dart`) and no affected processes.
- `_RiskWarning`, `_FuturesSafetyChecklist`, and `_OrdersTab`: LOW/0 affected
  processes before edit.
Tests/audits:
- `flutter test test/features/trade/futures_page_test.dart --reporter=compact`:
  passed.
- `flutter test test/features/trade --reporter=compact`: passed with 350 tests.
- `flutter analyze`: passed.
- `dart run tool/design_token_consistency_audit.dart --check`: passed with
  `total_debt=0`.
- `dart run tool/body_component_consistency_audit.dart`: regenerated audit
  artifacts.
- `dart run tool/body_component_consistency_audit.dart --check`: passed.
- `dart run tool/route_coverage_audit.dart --check`: passed.
- `dart run tool/navigation_edge_audit.dart --check`: passed.
Before grade/shared/custom: Tool / 44 / 23
After grade/shared/custom: Tool / 44 / 21, issue priority P3,
`financial_safety_status=pass`,
`primary_issue=fullscreen_tool_manual_visual_qa_required`
Manual visual QA:
- `flutter_app/run-artifacts/futures-rsc11.png`: visual-QA frame route
  `/trade/btcusdt/futures` is nonblank; header close/chart actions, shared tabs,
  market stats, side/order controls, margin input, TP/SL actions, submit
  disabled state, high-risk panels, and bottom navigation render at 440 x 956.
Notes:
- Futures copy still exposes margin, leverage, liquidation, fees, TP/SL, order
  side, and risk of losing margin before opening a position.

## 10. Final Acceptance Gates

The remaining migration is complete only when all gates pass:

- [x] `dart run tool/design_token_consistency_audit.dart --check` passes with
  `total_debt=0`.
- [x] `dart run tool/body_component_consistency_audit.dart --check` passes.
- [x] Every current Grade B screen is Grade A, or has a precise accepted L3
  reason that cannot be represented by an existing shared primitive.
- [x] Every Tool screen has manual visual QA evidence and a documented
  fullscreen/tool exception.
- [x] `dart run tool/route_coverage_audit.dart --check` passes.
- [x] `dart run tool/navigation_edge_audit.dart --check` passes.
- [x] Focused module tests for every touched screen pass.
- [x] `flutter analyze` passes.
- [x] Full `flutter test --reporter=compact` passes after broad shared
  primitive or route/shell changes.
- [x] Product boundaries remain intact:
  - Arena points-only language.
  - Prediction Markets trading/probability language.
  - P2P escrow/payment safety.
  - Earn/staking risk and suitability disclosure.
  - Trade leverage/futures/bot risk disclosure.

## 11. Closure

Remaining shared-component migration is complete. `RSC-01 P2PChatPage`, `RSC-02
AdvancedChartPage`, `RSC-03 TradingBotsPage`, `RSC-04
ArenaPredictionBridgeFoundationPage`, `RSC-05 ReferralHomePage`, `RSC-06
SavingsAutoPilotPage`, `RSC-07 ConnectedEcosystemProductionPage`,
`RSC-08 ArenaChallengeDetailPage`, `RSC-09 StakingProofOfReservesPage`,
`RSC-10 EnterpriseStatesPage`, and `RSC-11 FuturesPage` have shared
controls/surfaces applied, documented L3 reasons where needed, and visual QA
evidence recorded where required. Final design token, body, route coverage,
navigation edge, analyzer, focused module, and full Flutter test gates passed.
