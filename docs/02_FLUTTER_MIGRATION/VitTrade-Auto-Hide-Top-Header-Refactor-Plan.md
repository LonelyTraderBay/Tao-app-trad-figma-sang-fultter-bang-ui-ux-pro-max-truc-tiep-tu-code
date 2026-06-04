# VitTrade Auto-Hide Top Header Refactor Plan

Generated: 2026-06-02

This plan tracks the refactor for top headers / top app bars so routed screens
do not keep a fixed header on top when the page should behave like Home. The
goal is to make the codebase consistent, avoid missed screens, and preserve
enterprise-grade navigation, QA, and route coverage.

## Problem

The Home page already has a scroll-aware header:

```text
_CollapsibleHomeHeader
  -> hides when scrolling down
  -> returns when scrolling up or near top
```

Most other screens use this fixed pattern:

```text
Column
  -> VitHeader
  -> Expanded
       -> SingleChildScrollView
```

That means the header stays pinned at the top like the Launchpad screenshot.
For dense mobile trading screens, this wastes vertical space and makes the UI
feel inconsistent across modules.

## Current Inventory

Route-level audit result from the current Flutter router:

| Category | Routed screens | Meaning |
| --- | ---: | --- |
| Fixed `VitHeader` like Launchpad | 0 | No routed screen remains with accidental fixed-header behavior. |
| Shared / Home auto-hide header | 396 | Home plus migrated routes now use target behavior. |
| Custom header inside scroll | 4 | Already not fixed; review only. |
| No top header | 14 | Review only; no auto-hide header migration needed unless design requires one. |
| Total routed screens | 414 | Matches product capability inventory route coverage. |

## Fixed Header Scope By Feature

Every row below is a migration bucket. Do not mark a bucket complete until its
remaining fixed-header route count is zero or every exception is documented.

| Priority | Feature / module | Fixed-header routes | Route group / source area | Status |
| ---: | --- | ---: | --- | --- |
| 1 | Launchpad | 0 | `flutter_app/lib/app/router/route_groups/launchpad_routes.dart` | Complete - 24 migrated |
| 2 | P2P | 0 | `flutter_app/lib/app/router/route_groups/p2p_routes.dart` | Complete - 76 migrated |
| 3 | Earn / Savings | 0 | `flutter_app/lib/app/router/route_groups/earn_routes.dart` | Complete - 70 migrated |
| 4 | Trade / Bots / Copy / Margin | 0 | `flutter_app/lib/app/router/route_groups/trade_routes.dart` | Complete - 84 migrated |
| 5 | Wallet | 0 | `flutter_app/lib/app/router/route_groups/wallet_routes.dart` | Complete - 20 migrated |
| 6 | Markets | 0 | `flutter_app/lib/app/router/route_groups/markets_routes.dart` | Complete - 20 migrated |
| 7 | Predictions | 0 | `flutter_app/lib/app/router/route_groups/predictions_routes.dart` | Complete - 19 migrated |
| 8 | Arena | 0 | `flutter_app/lib/app/router/route_groups/arena_routes.dart` | Complete - 26 migrated |
| 9 | Profile | 0 | `flutter_app/lib/app/router/route_groups/profile_routes.dart` | Complete - 13 migrated |
| 10 | DCA | 0 | `flutter_app/lib/app/router/route_groups/dca_routes.dart` | Complete - 11 migrated |
| 11 | Auth | 0 | `flutter_app/lib/app/router/route_groups/auth_routes.dart` | Complete - 5 migrated |
| 12 | Referral | 0 | `flutter_app/lib/app/router/route_groups/utility_routes.dart` | Complete - 5 migrated |
| 13 | Admin | 0 | `flutter_app/lib/app/router/route_groups/admin_routes.dart` | Complete - 5 migrated |
| 14 | Cross-module | 0 | `flutter_app/lib/app/router/route_groups/utility_routes.dart` | Complete - 4 migrated |
| 15 | Dev / QA | 0 | `flutter_app/lib/app/router/route_groups/utility_routes.dart` | Complete - 4 migrated |
| 16 | Support | 0 | `flutter_app/lib/app/router/route_groups/support_routes.dart` | Complete - 3 migrated |
| 17 | Discovery | 0 | `flutter_app/lib/app/router/route_groups/utility_routes.dart` | Complete - 3 migrated |
| 18 | Onboarding | 0 | `flutter_app/lib/app/router/route_groups/auth_routes.dart` | Complete - 1 migrated |
| 19 | News | 0 | `flutter_app/lib/app/router/route_groups/home_routes.dart` | Complete - 1 migrated |
| 20 | Notifications | 0 | `flutter_app/lib/app/router/route_groups/utility_routes.dart` | Complete - 1 migrated |

## Screens Already Not In Fixed-Header Scope

These screens are not part of the fixed `VitHeader` migration. They still need
visual regression checks after the shared layout changes.

| Category | Routes | Required action |
| --- | ---: | --- |
| Home / shared auto-hide target behavior | 396 | Keep using the shared auto-hide behavior. |
| Custom header inside scroll | 4 | Review Trade and Markets custom headers for consistency; do not force `VitHeader` if custom behavior is intentional. |
| No top header | 14 | Check content padding, status bar, and bottom nav overlap only. |

Known non-fixed examples:

- `/home` uses the current collapsible Home header.
- `/trade` and `/trade/:pairId` use a custom Trade header inside the scrollable content.
- `/markets` uses a custom Market header inside the scrollable content.
- `/profile`, `/wallet`, `/trade/convert`, `/trade/bots`, and several analytics/detail screens have no standard top header.

## Target Architecture

Add one shared layout primitive and migrate pages through it.

Recommended name:

```text
flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart
```

Required API shape:

```dart
class VitAutoHideHeaderScaffold extends StatefulWidget {
  const VitAutoHideHeaderScaffold({
    required this.header,
    required this.child,
    this.bottomInset,
    this.semanticLabel,
    this.initiallyVisible = true,
    this.hideThreshold = 24,
    this.showAtTopThreshold = 8,
  });
}
```

Required behavior:

- Hide header when the user scrolls down after threshold.
- Show header when the user scrolls up.
- Show header when the scroll position is near top.
- Preserve `VitHeader` visual design, back button semantics, title/subtitle, and trailing actions.
- Preserve `ShellRenderMode.visualQaFrame` and native shell bottom padding.
- Avoid layout jumps when the header animates.
- Never hide critical sticky confirmation controls.
- Must work from 360 px width upward.

## Implementation Order

### Phase 0 - Build Audit Guardrail

Status: Complete

Create a route/header audit so every future pass is measurable.

Required files:

- `flutter_app/tool/top_header_behavior_audit.dart`
- `flutter_app/test/quality/top_header_behavior_guardrail_test.dart`

Required output:

```text
total_routed_screens=414
fixed_vit_header_remaining=<number>
auto_hide_header=<number>
custom_scroll_header=<number>
no_top_header=<number>
```

Acceptance:

- The audit maps routes to page classes.
- The audit handles `part` files.
- The audit handles `InternalSurfaceGate`.
- The audit handles `_AuthRouteShell`.
- The guardrail fails if a migrated route returns to fixed `VitHeader`.

### Phase 1 - Create Shared Auto-Hide Scaffold

Status: Complete

Create `VitAutoHideHeaderScaffold` and focused widget tests.

Required tests:

- Header visible at top.
- Header hides on downward scroll.
- Header returns on upward scroll.
- Header returns when scroll position is near top.
- Back button and trailing actions remain tappable.
- No content overlaps bottom nav at 360 x 800 and 440 x 956.

Acceptance:

- `flutter analyze` passes.
- Shared widget tests pass.
- No existing page behavior changes yet except pilot page.

### Phase 2 - Pilot On Launchpad

Status: Complete

Start with Launchpad because it is the screenshot case and has a manageable
24-route scope.

Required first route:

- `AppRoutePaths.launchpad`
- File: `flutter_app/lib/features/launchpad/presentation/pages/launchpad_page.dart`

Then migrate the remaining Launchpad fixed-header routes.

Launchpad acceptance:

- Header auto-hides like Home on `/launchpad`.
- Back button remains available after scroll up.
- Header actions remain available after scroll up.
- All Launchpad page tests pass.
- Screenshot evidence saved under:
  `flutter_app/run-artifacts/top-header-refactor/launchpad-auto-hide.png`

Latest verification:

- `fixed_vit_header_remaining=0`
- `auto_hide_header=396`
- Launchpad fixed-header routes: `0`
- `flutter test test/features/launchpad --reporter=compact` passes.
- `flutter test test/quality/top_header_behavior_guardrail_test.dart test/shared/layout/vit_auto_hide_header_scaffold_test.dart --reporter=compact` passes.

### Phase 3 - High-Volume Product Modules

Status: Complete

Migrate in this order:

1. P2P: 76 fixed-header routes.
2. Earn / Savings: 70 fixed-header routes.
3. Trade / Bots / Copy / Margin: 84 fixed-header routes.

Reason:

- These are the biggest sources of inconsistent top header behavior.
- They include many high-risk financial flows, so shared behavior must be
  verified carefully before migrating lower-risk modules.

Required checks for every module:

- Route still opens.
- Back route still works.
- Header title/subtitle/trailing action still render.
- Scroll down hides header.
- Scroll up returns header.
- Critical CTA, confirmation, support, and receipt controls are not hidden.
- Existing feature tests still pass.

Latest verification:

- P2P fixed-header routes: `0`.
- Earn / Savings fixed-header routes: `0`.
- Trade / Bots / Copy / Margin fixed-header routes: `0`.
- `flutter analyze lib/features/p2p/presentation/pages` passes.
- `flutter analyze lib/features/earn/presentation/pages` passes.
- `flutter analyze lib/features/trade/presentation/pages` passes.

### Phase 4 - Remaining Customer Modules

Status: Complete

Migrate:

1. Wallet: 20 fixed-header routes.
2. Markets: 20 fixed-header routes.
3. Predictions: 19 fixed-header routes.
4. Arena: 26 fixed-header routes.
5. Profile: 13 fixed-header routes.
6. DCA: 11 fixed-header routes.
7. Referral: 5 fixed-header routes.
8. Support: 3 fixed-header routes.
9. Discovery: 3 fixed-header routes.
10. News: 1 fixed-header route.
11. Notifications: 1 fixed-header route.

Acceptance:

- No customer-facing module remains with accidental fixed top header.
- Intentional exceptions are documented in the audit allowlist with reason.

Latest verification:

- Wallet, Markets, Predictions, Arena, Profile, DCA, Referral, Support,
  Discovery, News, and Notifications fixed-header routes: `0`.
- Customer module focused analyze pass completed with no issues.

### Phase 5 - Internal / Auth / Onboarding

Status: Complete

Migrate or explicitly exempt:

- Admin: 5 fixed-header routes.
- Dev / QA: 4 fixed-header routes.
- Cross-module internal operations: 4 fixed-header routes.
- Auth: 5 fixed-header routes.
- Onboarding: 1 fixed-header route.

Rule:

- Internal routes can be less polished than customer routes, but must not use a
  different header behavior without an explicit reason.
- Auth and onboarding can be exempt if the fixed header is part of a trust or
  progress step. Exemptions must be documented.

Latest verification:

- Admin, Dev / QA, Cross-module, Auth, and Onboarding fixed-header routes: `0`.
- No new exemption was required.
- Internal/auth/onboarding focused analyze pass completed with no issues.

### Screenshot Evidence

Saved under `flutter_app/run-artifacts/top-header-refactor/`:

- `home-auto-hide.png`
- `launchpad-auto-hide.png`
- `p2p-auto-hide.png`
- `earn-auto-hide.png`
- `trade-auto-hide.png`
- `wallet-auto-hide.png`
- `markets-auto-hide.png`
- `predictions-auto-hide.png`
- `arena-auto-hide.png`
- `profile-auto-hide.png`

## Per-Pass Checklist

Use this checklist for every feature bucket.

```text
[ ] Read route group file.
[ ] List all routes in bucket.
[ ] List all page files and part files.
[ ] Confirm current header classification.
[ ] Migrate one page first.
[ ] Run focused page test.
[ ] Verify scroll hide/show behavior.
[ ] Migrate remaining pages in the bucket.
[ ] Run all feature tests for the bucket.
[ ] Run top header behavior audit.
[ ] Update this plan's status/count.
[ ] Save screenshot evidence for at least one representative route.
```

## No-Missed-Screen Rule

A feature bucket is complete only when all three conditions are true:

1. The route/header audit reports zero accidental fixed headers for that bucket.
2. Every intentional exception is listed in the exception table.
3. Existing route coverage and navigation edge audits still pass.

Required commands from `flutter_app/`:

```bash
dart format .
flutter analyze
dart run tool/top_header_behavior_audit.dart --check
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter test --reporter=compact
```

## Exception Table

Only add an exception when fixed header behavior is intentional.

| Route | File | Reason | Approved status |
| --- | --- | --- | --- |
| `/home` | `flutter_app/lib/features/home/presentation/pages/home_page.dart` | Already uses target collapsible behavior. | Approved |

## Final Done Criteria

The refactor is complete only when:

- `fixed_vit_header_remaining=0` for all non-exempt routes.
- The total routed screen count remains 414 or the route inventory is updated
  with a clear reason.
- Home, Launchpad, P2P, Earn, Trade, Wallet, Markets, Predictions, Arena, and
  Profile have representative emulator screenshots.
- `flutter analyze` passes.
- Route coverage audit passes.
- Navigation edge audit passes.
- Full Flutter test suite passes.

Latest final verification:

- `dart format .` passes.
- `flutter analyze` passes.
- `dart run tool/top_header_behavior_audit.dart --check` passes with
  `fixed_vit_header_remaining=0`.
- `dart run tool/route_coverage_audit.dart --check` passes.
- `dart run tool/navigation_edge_audit.dart --check` passes.
- `flutter test --reporter=compact` passes with 1928 tests.
