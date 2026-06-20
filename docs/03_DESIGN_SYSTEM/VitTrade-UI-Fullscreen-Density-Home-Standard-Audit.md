# VitTrade UI Fullscreen Density / Home Standard Audit

Generated: 2026-06-19

This audit checks a layer that the Shared Components body audit does not fully
cover: whether routed screens feel dense, full-width, and consistent with the
Home screen rhythm.

## Inputs

- Full route body inventory: `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`
- Full top-header inventory: `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Behavior-Audit.md`
- Visual archetype inventory: `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`
- Generated density CSV: `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`

## Home Baseline

Home is the visual density baseline:

- `VitPageLayout.flush` in native shell mode.
- `VitAutoHideHeaderScaffold`.
- `VitInsetScrollView`.
- `VitPageContent(padding: VitContentPadding.compact, gap: VitContentGap.defaultGap)`.
- Multiple stacked dense sections: announcement, portfolio, next action,
  ticker, products, discovery, market rows, trending, ranked lists.

Any remaining screen should either follow this dense rhythm or have a clear
exception such as auth entry or fullscreen tool.

## Current Pass/Fail Snapshot

Existing audits still pass structurally:

- Routed screens audited: 414.
- Body grades: A = 404, B = 5, Tool = 5.
- Header behavior: fixed header = 0, auto-hide header = 404,
  custom-scroll header = 4, no-top-header = 6.
- Visual archetype strict issues: 0.
- Header policy violations: 0.
- `flutter analyze`: pass.

But this does not mean every screen feels equally dense. The new density audit
flags 33 routes for visual review:

- P1 density refactor: 1 route.
- P1 fullscreen tool visual QA: 5 routes.
- P2 visual density review: 14 routes.
- P3 follow-up review: 13 routes.
- Pass or low signal: 381 routes.

## P1 - Must Review First

| Priority | Feature | Route/Page | Reason |
| --- | --- | --- | --- |
| P1 density refactor | onboarding | `OnboardingFlow` | Uses `VitContentPadding.relaxed` 6 times and `VitContentGap.relaxed` 3 times. Visually likely much looser than Home. |
| P1 fullscreen tool QA | enterprise_states | `EnterpriseStatesPage` | Fullscreen tool exception. Must be checked visually for true full-bleed use. |
| P1 fullscreen tool QA | p2p | `P2PChatPage` | Fullscreen tool exception with low shared count. Must be checked visually. |
| P1 fullscreen tool QA | trade | `AdvancedChartPage` | Fullscreen chart/tool exception. Must maximize workspace. |
| P1 fullscreen tool QA | trade | `FuturesPage` | Fullscreen trading tool exception. Must maximize workspace. |
| P1 fullscreen tool QA | trade | `TradingBotsPage` | Fullscreen tool exception. Must be checked for dense workspace behavior. |

## P2 - Visual Density Review

These routes are structurally pass/A or accepted exceptions, but source signals
show spacing/custom-body patterns that can make them feel less like Home:

| Feature | Route/Page | Main signal |
| --- | --- | --- |
| p2p | `P2PWalletTransferPage` | Custom body exceeds shared count by 9; few dense sections/cards. |
| arena | `ConnectedEcosystemProductionPage` | Body grade B; custom body exceeds shared count. |
| news | `NewsPage` | Relaxed padding and few dense sections/cards. |
| arena | `ArenaProductionReadyPage` | Custom body exceeds shared count by 14. |
| trade | `TradePage` / `/trade/:pairId` | Instrument route still has relaxed padding signals. |
| arena | `MyArenaPage` / `profileArena` | Relaxed padding and custom body exceeds shared count. |
| dca | `DCAOverviewDemo` | Loose gap and few dense sections/cards. |
| predictions | `PredictionTournamentDetailPage` | Relaxed padding signals. |
| predictions | `PredictionTournamentsPage` | Relaxed padding signals. |
| p2p | `P2PMerchantApplyPage` | Custom body exceeds shared count by 9. |
| markets | `AdvancedChartsPage` | Relaxed padding and custom body exceeds shared count. |
| launchpad | `LaunchpadWebhooksPage` | Custom body exceeds shared count by 9. |

## P3 - Follow-Up Review

These routes have lower static signals, but should still be visually sampled
when polishing the remaining app:

| Feature | Route/Page | Main signal |
| --- | --- | --- |
| auth | `ForgotPasswordPage` | Relaxed padding/gap. |
| auth | `OTPPage` | Relaxed padding/gap. |
| auth | `ResetPasswordPage` | Relaxed padding/gap. |
| earn | `StakingVotingPage` routes | Relaxed padding/gap. |
| p2p | `P2PWalletPage` | Custom body exceeds shared count and few dense sections/cards. |
| arena | `ArenaChallengeDetailPage` | Body grade B. |
| arena | `ArenaPredictionBridgeFoundationPage` | Body grade B. |
| earn | `SavingsAutoPilotPage` | Body grade B. |
| referral | `ReferralHomePage` | Body grade B. |
| p2p | `P2PTransactionLimitsPage` | Custom body exceeds shared count. |
| markets | `TokenUnlocksPage` | Relaxed padding and custom body exceeds shared count. |
| discovery | `UnifiedSearchPage` | Custom body exceeds shared count. |

## Required Remediation Rule

Before changing any Dart symbol, run GitNexus impact analysis on the target
symbol and report blast radius. Then update screens in this order:

1. P1 fullscreen tool surfaces: confirm each truly consumes available screen
   space, with tool-specific content full-bleed where appropriate.
2. P1/P2 relaxed spacing surfaces: convert relaxed padding/gaps to Home-like
   compact/default density unless the screen is auth/onboarding by design.
3. P2/P3 custom body surfaces: replace local repeated cards/rows/controls with
   shared components where the shared primitive exists.
4. Rerun `dart run tool/body_component_consistency_audit.dart --check`,
   `dart run tool/top_header_visual_archetype_audit.dart`, `flutter analyze`,
   and focused widget tests.

