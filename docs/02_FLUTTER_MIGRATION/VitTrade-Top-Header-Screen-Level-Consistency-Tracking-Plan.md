# VitTrade Top Header Screen-Level Consistency Tracking Plan

Updated: 2026-06-04

## Purpose

Make the top header feel consistent across the whole Flutter app by enforcing
one visible rule: screens at the same IA level use the same top chrome
archetype, action density, spacing, and title scale.

This plan complements:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`

## Current Baseline

Generated audit baseline:

```text
total_routed_screens=414
strict_visual_issues=0
screen_level_mismatches=0
uses_vit_top_chrome=20
detail=393
rootModule=11
fullscreenTool=5
instrument=3
authOnboarding=1
rootBrand=1
```

Manual screen-level review originally found five product hub mismatches. They
are now migrated and the static audit records `screenLevel`,
`expectedArchetype`, and `screenLevelMismatch` so future drift fails strict
mode.

## Screen-Level Contract

| Level | Screen type | Expected top chrome | User-visible rule |
| --- | --- | --- | --- |
| L0 | Home root | `rootBrand` | The app's global identity is strongest here. |
| L0 | Auth entry | `authOnboarding` | Auth entry owns onboarding chrome. |
| L1 | Primary tab root: Markets, Wallet, Profile | `rootModule` | Large module title and stable module actions. |
| L1 | Product module hub: P2P, DCA, Launchpad, Earn, Arena, Prediction Markets, Rewards | `rootModule` | Product entry points look like same-level hubs. |
| L1 | Trade instrument workspace | `instrument` | Pair selector, price/status, and trading context are primary. |
| L1 | Utility hub: Search, News, Notifications, Support, Referral, Cross-module tools | `detail` | Useful surfaces, but not product roots. |
| L2 | Section hub, utility detail, entity detail | `detail` | Standard title/subtitle with predictable back behavior. |
| L2 | Instrument detail such as Pair Detail | `instrument` | Market pair context stays visible. |
| L3 | Transaction flow: confirm, receipt, withdraw, deposit, add payment method | `detail` | Safety and next step clarity over decorative module identity. |
| L3 | Fullscreen tool: terminal chart, futures terminal, chat | `fullscreenTool` | Tool UI owns navigation and workspace chrome. |

## Current Mismatches To Fix

| Status | Route | Page | Current | Expected | File |
| --- | --- | --- | --- | --- | --- |
| [x] | `/arena` | `ArenaHomePage` | `rootModule` | `rootModule` | `flutter_app/lib/features/arena/presentation/pages/arena_home_page_part_01.dart` |
| [x] | `/dca` | `DCAPage` | `rootModule` | `rootModule` | `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart` |
| [x] | `/earn` | `StakingEarnPage` | `rootModule` | `rootModule` | `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart` |
| [x] | `/earn/staking` | `StakingEarnPage` | `rootModule` | `rootModule` | `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart` |
| [x] | `/markets/predictions` | `PredictionsHomePage` | `rootModule` | `rootModule` | `flutter_app/lib/features/predictions/presentation/pages/predictions_home_page.dart` |

## Non-Goals

- Do not make every screen use the same header.
- Do not change `ConvertPage` to `rootModule`; it is a detail transaction tool.
- Do not change receipts, confirmations, settings, history, or analytics pages
  to `rootModule`.
- Do not introduce per-module header backgrounds or local header palettes.
- Do not change bottom navigation active colors.

## Execution Checklist

### THC-00: Baseline And Scope

| Status | Task | Files / commands | Acceptance |
| --- | --- | --- | --- |
| [x] | Confirm current routed-screen count and archetype baseline. | `dart run tool/top_header_visual_archetype_audit.dart --check --strict` | Baseline is current and reports `414` routed screens. |
| [x] | Identify true IA-level mismatches. | CSV audit plus route/page inspection. | Only five L1 product hub mismatches remain in scope. |
| [x] | Attach this plan to the implementation PR or tracking issue. | This file. | Reviewers can track every task from this plan. |

### THC-01: Lock The Screen-Level Contract In Docs

| Status | Task | Files | Acceptance |
| --- | --- | --- | --- |
| [x] | Add the screen-level contract summary to the top-header audit docs. | `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md` or a linked standard doc. | Docs state which screen levels map to `rootBrand`, `rootModule`, `instrument`, `detail`, `fullscreenTool`, and `authOnboarding`. |
| [x] | Document action-density policy. | Same doc or top-header action audit docs. | `rootModule` allows max two visible primary actions before overflow; `detail` usually has zero or one; transaction flows keep safety actions only. |
| [x] | Document module identity rule. | `Flutter-Module-Identity-Standard.md` if needed. | Module identity is limited to accent, icon, pill, border, chart marker, or tab indicator. |

### THC-02: Upgrade The Static Audit Guardrail

| Status | Task | Files | Acceptance |
| --- | --- | --- | --- |
| [x] | Add screen-level classification to the audit script. | `flutter_app/tool/top_header_visual_archetype_audit.dart` | Each route gets `screenLevel`. |
| [x] | Add expected archetype calculation. | Same script. | Each route gets `expectedArchetype`. |
| [x] | Add mismatch detection. | Same script. | Each route gets `levelMismatch` or `screen_level_archetype_mismatch`. |
| [x] | Update CSV output columns. | `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv` | CSV includes `screenLevel`, `expectedArchetype`, and mismatch fields. |
| [x] | Update Markdown output columns. | `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md` | Markdown exposes screen-level mismatch counts. |
| [x] | Make strict mode fail on screen-level mismatches. | Audit script. | `--strict` fails while any product hub uses `detail`. |

### THC-03: Migrate Product Module Hubs To `rootModule`

| Status | Task | Files | Acceptance |
| --- | --- | --- | --- |
| [x] | Convert Arena hub header from `VitHeader` to `VitTopChrome.rootModule`. | `flutter_app/lib/features/arena/presentation/pages/arena_home_page_part_01.dart`, parent imports if needed. | `/arena` visually matches P2P/Launchpad title scale and surface. |
| [x] | Convert DCA hub header from `VitHeader` to `VitTopChrome.rootModule`. | `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart`, `dca_page.dart` imports. | `/dca` uses large module title and same back/action alignment as other hubs. |
| [x] | Convert Earn hub header from `VitHeader` to `VitTopChrome.rootModule`. | `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart` | `/earn` and `/earn/staking` share root module chrome. |
| [x] | Convert Prediction Markets hub header from `VitHeader` to `VitTopChrome.rootModule`. | `flutter_app/lib/features/predictions/presentation/pages/predictions_home_page.dart` | `/markets/predictions` looks like a product hub, not a detail page. |
| [x] | Keep Launchpad, P2P, Wallet, Profile, Markets, Rewards unchanged unless action-density review requires small adjustments. | Existing root module files. | Launchpad filter action now performs an active tab filter instead of haptic-only no-op. |

### THC-04: Normalize Header Actions

| Status | Task | Files | Acceptance |
| --- | --- | --- | --- |
| [x] | Review rootModule visible actions. | Launchpad, P2P, DCA, Arena, Earn, Predictions. | No root module exposes more than two visible primary actions unless there is a documented product reason. |
| [x] | Move low-priority module actions into overflow where needed. | Product hub pages and `VitHeaderActionType.more` usage if needed. | Header remains scannable at 360 px. |
| [x] | Check action tone consistency. | `VitHeaderActionItem` usage. | Primary tone is reserved for primary creation/add actions; neutral tools stay neutral. |
| [x] | Verify disabled/no-op actions are not displayed as active commands. | Header action rows. | Every visible action has a real `onPressed` or is intentionally hidden. |

### THC-05: Format, Analyze, And Test

| Status | Task | Command | Acceptance |
| --- | --- | --- | --- |
| [x] | Format touched Dart files. | `dart format .` from `flutter_app/` | Touched files pass `dart format --output=none --set-exit-if-changed`. |
| [x] | Regenerate top-header audit artifacts. | `dart run tool/top_header_visual_archetype_audit.dart` from `flutter_app/` | Markdown and CSV are current. |
| [x] | Run strict top-header audit. | `dart run tool/top_header_visual_archetype_audit.dart --check --strict` | Passes with zero screen-level mismatches. |
| [x] | Run route coverage audit. | `dart run tool/route_coverage_audit.dart --check` | Passes. |
| [x] | Run navigation edge audit. | `dart run tool/navigation_edge_audit.dart --check` | Passes. |
| [x] | Run analyzer. | `flutter analyze` | Passes. |
| [x] | Run focused tests for touched screens/audits. | `flutter test --reporter=compact` or focused subsets. | Full `flutter test --reporter=compact` passes. |

### THC-06: Visual QA

| Status | Screen | Required check | Acceptance |
| --- | --- | --- | --- |
| [x] | Home | Baseline `rootBrand`. | No accidental change. |
| [x] | Markets | Primary tab `rootModule`. | Still matches Wallet/Profile module chrome. |
| [x] | Wallet | Primary tab `rootModule`. | No accidental change. |
| [x] | Profile | Primary tab `rootModule`. | No accidental change. |
| [x] | P2P | Existing product hub `rootModule`. | Remains visually aligned. |
| [x] | Launchpad | Existing product hub `rootModule`. | Action density remains acceptable. |
| [x] | DCA | Migrated product hub. | Title size, subtitle, back placement, and surface match P2P/Launchpad. |
| [x] | Arena | Migrated product hub. | Header looks like product hub; Arena copy remains points-only. |
| [x] | Earn | Migrated product hub. | Header looks like product hub and risk copy remains clear. |
| [x] | Prediction Markets | Migrated product hub. | Header looks like product hub and prediction/wallet language stays separated from Arena. |
| [x] | Convert / Swap | Detail control screen. | Stays detail, not root module. |
| [x] | Withdraw / Deposit / Receipt | Financial flows. | Safety-focused detail header remains stable. |

### THC-07: Review Gates

| Status | Gate | Acceptance |
| --- | --- | --- |
| [x] | Architecture | Product hub pages use shared `VitTopChrome`, not local scaffolds. |
| [x] | IA | L1 product hubs are visually peers. |
| [x] | Financial safety | Transaction flows remain detail/safety-first. |
| [x] | Boundary clarity | Arena remains points-only; Prediction Markets remains wallet/value context. |
| [x] | Mobile fit | Header text/actions do not collide at 360 px. |
| [x] | Audit | Static audit catches future product-hub/detail mismatches. |

## Implementation Notes

- Prefer `VitTopChrome(type: VitTopChromeType.rootModule, ...)` for L1 product
  hubs.
- Preserve existing back behavior when migrating from `VitHeader`.
- Keep `VitAutoHideHeaderScaffold` behavior unless there is a separate product
  reason to change scrolling behavior.
- Keep title/subtitle source text unchanged unless copy quality is being
  reviewed separately.
- Do not add local padding, color, radius, or font-size constants to product
  pages; update shared tokens only if a real cross-app need appears.

## Completion Evidence

- Visual audit: `strict_visual_issues=0`, `screen_level_mismatches=0`,
  `uses_vit_top_chrome=20`, `rootModule=11`.
- Action audit: `action_groups_over_limit=0`,
  `migration_candidates=0`, `banned_icon_usages=0`.
- Visual QA artifacts:
  `flutter_app/run-artifacts/top_header_screen_level_consistency/`.
- Verification passed:
  `flutter analyze`, full `flutter test --reporter=compact`, route coverage,
  navigation edge, back navigation behavior, global access policy, visual
  archetype, and top-header action guardrails.

## Completion Criteria

This work is complete only when:

- All five current product hub mismatches are migrated.
- The audit script records screen level and expected archetype.
- `--strict` fails if a future product hub uses `detail`.
- The generated audit Markdown and CSV are current.
- Flutter analyzer and tests pass for the touched scope.
- Visual QA confirms root module consistency at phone width.
