# Flutter Enterprise Navigation Optimization Tracking Plan

Generated: 2026-06-01

This plan tracks the navigation and screen-connection optimization work for
VitTrade. It is based on the current Flutter router and the generated
navigation edge audit.

## Source Of Truth

Use these files as the baseline before changing navigation:

| Artifact | Purpose |
| --- | --- |
| `flutter_app/lib/app/router/app_router.dart` | Public router facade. |
| `flutter_app/lib/app/router/app_route_paths.dart` | Canonical route path constants and route builders. |
| `flutter_app/lib/app/router/app_route_names.dart` | Canonical route names. |
| `flutter_app/lib/app/router/route_groups/` | Route ownership by module. |
| `flutter_app/lib/app/router/visual_qa_route_metadata.dart` | Bottom-nav active destination mapping and visual QA route metadata. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md` | Current router truth table. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Connection-Audit.md` | Human-readable navigation audit. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv` | Row-level navigation edge baseline. |

## Current Baseline

| Metric | Count |
| --- | ---: |
| Router declarations | 417 |
| Real pages | 414 |
| Redirect aliases | 3 |
| Navigation handlers scanned | 913 |
| Handlers with resolved static target | 431 |
| Dynamic route expressions | 345 |
| Back or close-modal handlers | 137 |

## Module Edge Baseline

Do not start optimization without checking this table against the latest CSV.
Any count change must be explained in the work log.

| Module | Total edges | Resolved targets | Dynamic route expressions | Back/modal handlers |
| --- | ---: | ---: | ---: | ---: |
| `p2p` | 181 | 79 | 96 | 6 |
| `trade` | 162 | 136 | 14 | 12 |
| `earn` | 155 | 0 | 112 | 43 |
| `arena` | 89 | 42 | 17 | 30 |
| `markets` | 51 | 45 | 4 | 2 |
| `wallet` | 45 | 26 | 3 | 16 |
| `launchpad` | 43 | 3 | 40 | 0 |
| `predictions` | 41 | 40 | 0 | 0 |
| `profile` | 32 | 18 | 2 | 12 |
| `dca` | 24 | 13 | 2 | 9 |
| `auth` | 23 | 20 | 0 | 3 |
| `discovery` | 16 | 2 | 14 | 0 |
| `referral` | 12 | 0 | 8 | 3 |
| `admin` | 7 | 5 | 2 | 0 |
| `support` | 7 | 0 | 7 | 0 |
| `dev` | 6 | 0 | 6 | 0 |
| `enterprise_states` | 6 | 0 | 6 | 0 |
| `cross_module` | 5 | 0 | 5 | 0 |
| `news` | 2 | 0 | 0 | 0 |
| `notifications` | 2 | 0 | 2 | 0 |
| `onboarding` | 2 | 0 | 2 | 0 |
| `app` | 1 | 0 | 1 | 0 |
| `home` | 1 | 0 | 1 | 0 |

## Optimization Principles

- Keep every existing reachable screen reachable unless a route is explicitly
  retired and documented.
- Replace raw route strings with `AppRoutePaths` or a typed navigation intent
  when the target is owned by the app.
- Keep route ownership in the correct route group. Avoid leaving real module
  routes in catch-all or placeholder groups.
- Every route-producing data object must have a contract test that proves its
  route exists in the router.
- Back behavior must be explicit for high-risk flows, nested flows, modal
  flows, and financial or security flows.
- Prediction Markets and Arena must remain separate namespaces.
- Arena points-only behavior must not be weakened when changing navigation.
- Navigation optimization must be incremental. Finish one module pass before
  starting the next high-risk module.

## No-Omission Protocol

Use this protocol for every optimization pass.

1. Run the baseline checks.
2. Filter `VitTrade-Screen-Navigation-Edges.csv` by one module.
3. Review every row in that module.
4. Classify each row as one of:
   - `static_route_ok`
   - `dynamic_route_needs_contract`
   - `raw_string_to_constant`
   - `back_or_modal_ok`
   - `wrong_route_group`
   - `missing_route_name`
   - `needs_ia_review`
   - `dead_or_noop_action`
5. Make only the scoped changes for that module.
6. Add or update tests for the changed route/data source.
7. Re-run audit commands.
8. Compare new counts with the baseline.
9. Record the result in the module checklist.

No row may be ignored because it is "only mock data". Mock routes define the
current UX contract and must stay valid.

## Required Commands

Run from `flutter_app/` unless noted otherwise.

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test test/app/router --reporter=compact
flutter test test/quality/navigation_route_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test --reporter=compact
```

For each navigation-heavy module, also run or add focused tests under:

```text
flutter_app/test/app/router/
flutter_app/test/features/<feature>/
flutter_app/test/quality/
```

## Work Phases

### NAVOPT-00 - Freeze And Reproduce Baseline

Status: Complete

Goal: ensure the team can reproduce the current navigation baseline before any
optimization changes.

Checklist:

- [x] Run `dart run tool/route_coverage_audit.dart --check`.
- [x] Confirm `VitTrade-Screen-Navigation-Connection-Audit.md` reflects current
      router counts.
- [x] Confirm `VitTrade-Screen-Navigation-Edges.csv` has 913 rows.
- [x] Confirm dynamic route expression count is 345.
- [x] Confirm back/modal handler count is 137.
- [x] Save any intentional baseline change in this plan before code edits.

Acceptance criteria:

- [x] Baseline counts are known.
- [x] Any drift is explained before optimization starts.

### NAVOPT-01 - Create Permanent Navigation Edge Audit Tool

Status: Complete

Goal: turn the current CSV extraction into a repeatable repo tool so edge
coverage does not depend on an ad-hoc script.

Recommended implementation:

- Add `flutter_app/tool/navigation_edge_audit.dart`.
- Output `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv`.
- Support `--check` mode like `route_coverage_audit.dart`.
- Classify edge rows into:
  - static AppRoutePaths target
  - raw literal target
  - dynamic target expression
  - modal/back close
  - unresolved target
- Include source file, line, module, method, target expression, normalized
  route, matched route page, and classification.

Checklist:

- [x] Add the tool.
- [x] Regenerate CSV with the tool.
- [x] Add `--check` mode.
- [x] Add a focused test or snapshot check for parsing representative route
      expressions.
- [x] Add CI command to `.github/workflows/flutter-ci.yml`.
- [x] Document usage in this plan or `docs/00_START_HERE.md`.

Acceptance criteria:

- [x] `dart run tool/navigation_edge_audit.dart --check` passes.
- [x] CSV generated by the tool matches the current baseline or every drift is
      explained.

### NAVOPT-02 - Route Constant And Typed Intent Standard

Status: Complete

Goal: reduce typo risk from raw route strings and dynamic route fragments.

Checklist:

- [x] Define a rule: UI should prefer `AppRoutePaths` over raw string routes.
- [x] Define when a data object may expose a route string.
- [x] For data-driven navigation, prefer a typed intent when the route requires
      parameters or query values.
- [x] Add lint or quality test to detect new raw absolute route strings in UI
      files.
- [x] Exempt intentional external links, samples, tests, and generated audit
      artifacts.

Candidate typed intent shapes:

```dart
sealed class NavigationIntent {
  const NavigationIntent();
}

final class AppRouteIntent extends NavigationIntent {
  const AppRouteIntent(this.path);
  final String path;
}

final class AppRouteBuilderIntent extends NavigationIntent {
  const AppRouteBuilderIntent(this.buildPath);
  final String Function() buildPath;
}
```

Adopted standard:

- UI navigation should use `AppRoutePaths`, `AppRouteNames`, or a typed
  `NavigationIntent`; direct raw absolute route strings are tracked debt.
- Data objects may expose a route string only when the route is backend-driven,
  mock-data-driven, or an accepted sample/deep-link contract. The consuming UI
  must keep that edge visible in `VitTrade-Screen-Navigation-Edges.csv`.
- Parameterized or query-bearing routes should move toward
  `AppRouteBuilderIntent` or an equivalent feature-specific typed intent before
  module cleanup is considered complete.
- The baseline guardrail is
  `flutter test test/quality/navigation_route_guardrails_test.dart --reporter=compact`.
  It allows the current 28 direct raw route literals and fails if that debt
  increases.
- External links, test files, generated audit artifacts, route declarations, and
  historical docs are outside this UI route-string guardrail.

Acceptance criteria:

- [x] New UI code cannot add raw app route strings without review.
- [x] Existing high-risk module routes are converted gradually by phase.

### NAVOPT-03 - Dynamic Route Contract Tests

Status: Complete

Goal: every `snapshot.*Route`, `item.route`, `module.route`, `tx.route`,
`tool.route`, and similar data-driven route must match a declared router path.

Checklist:

- [x] Add route matcher helper in router tests.
- [x] Extract all route-bearing domain/data objects for P2P.
- [x] Extract all route-bearing domain/data objects for Earn.
- [x] Extract all route-bearing domain/data objects for Launchpad.
- [x] Extract all route-bearing domain/data objects for Arena.
- [x] Extract all route-bearing domain/data objects for Discovery and
      Cross-module.
- [x] Verify route strings with query parameters by matching the path part and
      validating allowed query keys.
- [x] Fail tests on unknown route path.
- [x] Fail tests on missing required route parameter.

Acceptance criteria:

- [x] Dynamic route expressions can remain dynamic only when covered by a route
      contract test.
- [x] No route-bearing mock data points to a missing route.

### NAVOPT-04 - Bottom Navigation And Module IA Review

Status: Complete

Goal: make navigation hierarchy understandable as the app grows.

Current issue:

- `visual_qa_route_metadata.dart` maps many large modules to the `trade`
  bottom-nav destination: P2P, Earn, Arena, Launchpad, Support, Search,
  Notifications, Admin, DCA, Rewards, Dev, and Cross-module routes.

Checklist:

- [x] Document the intended top-level product hierarchy.
- [x] Decide whether bottom nav stays as 5 tabs.
- [x] If bottom nav stays, define a module launcher under `trade` or `home`.
- [x] Decide whether P2P, Earn, Arena, Launchpad, and Rewards need secondary
      navigation headers.
- [x] Update `_activeDestinationForPath` only after IA decision.
- [x] Add tests for active destination mapping.
- [x] Verify active tab with representative shell tests; emulator visual QA is
      required only when the visible bottom-nav design changes.

Representative routes to test:

| Module | Route | Expected active destination after decision |
| --- | --- | --- |
| Home | `/home` | Home |
| Markets | `/markets` | Markets |
| Pair detail | `/pair/btcusdt` | Markets |
| Trade | `/trade/btcusdt` | Trade |
| Wallet | `/wallet` | Wallet |
| Profile | `/profile` | Profile |
| P2P | `/p2p` | Trade |
| Earn | `/earn/staking` | Trade |
| Arena | `/arena` | Trade |
| Launchpad | `/launchpad` | Trade |
| Support | `/support` | Home |
| Search | `/search` | Home |
| Notifications | `/notifications` | Home |

Adopted IA decision:

- Keep the 5-tab bottom nav: Home, Markets, Trade, Wallet, Profile.
- Home owns general entry, news, search, topics, support, and notifications.
- Markets owns market discovery, pair detail, and Prediction Markets surfaces.
- Trade remains the Product Hub for action-heavy modules until secondary
  navigation is introduced: Trade, P2P, Earn, DCA, Arena, Launchpad, Rewards,
  Admin, Dev, and cross-module operational surfaces.
- Wallet owns wallet paths, and Profile owns profile paths.
- P2P, Earn, Arena, Launchpad, and Rewards still need module-level headers as
  their screen count grows; this is tracked in the module phases below.

Acceptance criteria:

- [x] Every route namespace has a documented active destination.
- [x] Active destination tests cover all major namespaces.

### NAVOPT-05 - Move Real Routes Out Of Placeholder Group

Status: Complete

Goal: route ownership must match module ownership.

Routes currently requiring ownership review:

| Current file | Route | Target | Proposed owner |
| --- | --- | --- | --- |
| `placeholder_routes.dart` | `/dca/rebalance/:configId/edit` | `DCARebalanceConfig` | `dca_routes.dart` |
| `placeholder_routes.dart` | `/dca/rebalance/:configId/history` | `DCARebalanceDashboard` | `dca_routes.dart` |
| `placeholder_routes.dart` | `/admin/settings` | `AdminSettingsPage` | `admin_routes.dart` |
| `placeholder_routes.dart` | `/trade/copy-trading/client-opt-up-request` | `ClientOptUpRequestPage` | `trade_routes.dart` |
| `placeholder_routes.dart` | `/settings/security` | `SecurityPage` | `profile_routes.dart` |
| `placeholder_routes.dart` | `/trade/copy-trading/regulatory-disclosures` alias | redirect | `trade_routes.dart` |

Checklist:

- [x] Move DCA routes.
- [x] Move Admin settings route.
- [x] Move Trade copy-trading route and alias.
- [x] Decide canonical owner for `/settings/security`.
- [x] Update route coverage truth table.
- [x] Update router tests.

Acceptance criteria:

- [x] `placeholder_routes.dart` contains only true placeholder or temporary
      compatibility routes.
- [x] No real feature page is hidden in placeholder ownership.

### NAVOPT-06 - Route Name Coverage

Status: Complete

Goal: every route that is used by product navigation, analytics, deep links, or
tests should have a stable `AppRouteNames` entry.

Routes requiring review because the truth table shows no name:

- [x] `/p2p/kyc/verify`
- [x] `/p2p/kyc/face-match`
- [x] `/p2p/security/whitelist`
- [x] `/settings/security/biometric`
- [x] `/settings/security/change-password`
- [x] `/p2p/tax-report/detailed/:year`
- [x] `/dca/rebalance/:configId/edit`
- [x] `/dca/rebalance/:configId/history`
- [x] `/admin/settings`
- [x] `/trade/copy-trading/client-opt-up-request`
- [x] `/trade/copy-trading/regulatory-disclosures` alias
- [x] `/settings/security`
- [x] `/markets/predictions/tournament/:tournamentId`
- [x] `/trade/copy-trading/target-market-definition/:productId`
- [x] `/trade/copy-trading/complaint-tracking/:complaintId`

Acceptance criteria:

- [x] Route names exist for all non-temporary product routes.
- [x] Redirect aliases are either intentionally unnamed or documented.

### NAVOPT-07 - Query Parameter And Deep Link Contract

Status: Complete

Goal: routes with query parameters must have documented supported keys and
fallback behavior.

Known query-route patterns:

- `/trade/<pairId>?side=buy`
- `/trade/<pairId>?side=sell`
- `/p2p/wallet/transfer?direction=from-main`
- `/p2p/wallet/transfer?direction=to-main`
- `/p2p/wallet/transfer?asset=<asset>&type=deposit`
- `/p2p/wallet/transfer?asset=<asset>&type=withdraw`
- `/p2p/escrow/balance?asset=<asset>`
- `/rewards?tab=arena`

Checklist:

- [x] Document allowed query keys for trade side.
- [x] Document allowed query keys for P2P wallet transfer.
- [x] Document allowed query keys for escrow balance.
- [x] Document allowed query keys for rewards tab.
- [x] Add tests for valid query values.
- [x] Add tests for invalid query fallback behavior.

Acceptance criteria:

- [x] Invalid query values do not crash.
- [x] Invalid query values have a safe default.
- [x] High-risk query-driven flows do not skip preview or confirmation.

### NAVOPT-08 - Back And Modal Behavior Audit

Status: Complete

Goal: distinguish true navigation from local modal closing and guarantee safe
fallbacks.

Checklist:

- [x] Review all 137 `back_or_close_modal` handlers.
- [x] Classify each as:
  - modal close
  - sheet result return
  - true back navigation
  - fallback to parent route
- [x] Ensure pages using `context.pop()` have fallback `context.go(...)` when
      deep-linked directly.
- [x] Ensure financial and security confirmations never close without clear
      next state.
- [x] Add tests for direct deep-link entry into high-risk pages.

Acceptance criteria:

- [x] No high-risk page relies only on stack pop.
- [x] Modal close buttons are not counted as screen-to-screen navigation.

Audit artifact:

- `VitTrade-Back-Modal-Behavior-Audit.csv` classifies all 137 handlers:
  55 fallback-to-parent route handlers, 73 modal close handlers, and 9 sheet
  result return handlers.

### NAVOPT-09 - Module Pass Order

Status: Complete

Work through modules in this order because it reduces highest route risk first.

| Order | Module | Reason | Required status |
| ---: | --- | --- | --- |
| 1 | P2P | Highest edge count, many financial/security flows | Complete |
| 2 | Earn | Highest dynamic count, many snapshot back routes | Complete |
| 3 | Launchpad | Almost all edges are dynamic | Complete |
| 4 | Trade | Critical financial routes, copy/margin/futures | Complete |
| 5 | Arena | Product boundary and points-only routing | Complete |
| 6 | Wallet | High-risk withdraw/address/transfer routes | Complete |
| 7 | Markets and Predictions | Pair/detail/trade bridge and prediction boundary | Complete |
| 8 | Profile and Auth | Security/account flows | Ready for NAVOPT-17 |
| 9 | DCA, Referral, Support, Discovery, Cross-module | Secondary route sources | Ready for NAVOPT-17 |
| 10 | Dev, Admin, Enterprise states, News, Notifications, Onboarding | Lower product risk but still must pass contract | Ready for NAVOPT-17 |

### NAVOPT-10 - P2P Module Checklist

Status: Complete

Baseline: 181 total edges, 79 resolved targets, 96 dynamic expressions,
6 back/modal handlers.

Checklist:

- [x] Verify express -> confirm -> order detail -> timeline/rate/cancel/proof.
- [x] Verify order detail -> chat -> dispute -> evidence -> resolution.
- [x] Verify ad/merchant/report/reviews/trading-level routes.
- [x] Verify payment method add, verification, ownership, cooling period, and
      history routes.
- [x] Verify insurance fund, certificate, score, policy, contribution history,
      and claim detail routes.
- [x] Verify escrow balance and escrow detail routes.
- [x] Verify KYC requirements/status/identity/address/selfie/video routes.
- [x] Verify security center/2FA/devices/anti-phishing/login-history/suspicious
      activity routes.
- [x] Verify P2P wallet transfer, history, fund-lock history routes.
- [x] Verify limits, compliance, AML, source of funds, large transaction, risk
      assessment, and tax reporting routes.
- [x] Verify settings, notifications, guide, blacklist, achievements, dashboard,
      order book, my ads, my orders.
- [x] Add dynamic route contract tests for all P2P snapshot routes.

Acceptance criteria:

- [x] P2P dynamic route count decreases or is fully covered by contract tests.
- [x] High-risk actions still preview and confirm.

Completion evidence:

- P2P audit remains stable at 181 total edges, 79 resolved targets,
  96 dynamic expressions, and 6 back/modal handlers.
- `dynamic_navigation_route_contract_test` covers route-bearing P2P data and
  query-key validation.
- `test/features/p2p` passed 313 tests, including payment-method preview and
  confirmation, order cancel/chat/escrow routing, wallet transfer query
  preselection, dispute evidence/resolution, KYC, security, compliance, tax,
  and insurance flows.

### NAVOPT-11 - Earn Module Checklist

Status: Complete

Baseline: 155 total edges, 0 resolved targets, 112 dynamic expressions,
43 back/modal handlers.

Checklist:

- [x] Verify Staking root and dashboard routes.
- [x] Verify terms, risk disclosure, risk assessment, withdrawal policy, and
      tax guide routes.
- [x] Verify history, analytics, earnings calendar, validator selection, and
      validator health routes.
- [x] Verify auto-compound, liquid staking, insurance, advanced orders,
      multichain, and institutional routes.
- [x] Verify guide, FAQ, notifications, recommendations, regulatory framework,
      audit reports, custody, suitability routes.
- [x] Verify proof of reserves, risk dashboard, slashing history, risk score,
      emergency actions, contingency plan.
- [x] Verify social feed, community governance, proposals, voting, forum,
      webhooks, data export, integrations, and developer console.
- [x] Verify Savings root, portfolio, history, guide, FAQ, notifications,
      recommendations, risk, comparison, auto-compound, goals, analytics,
      rebalance, preferences, DCA, suggestions, export, backtest, autopilot,
      ladder, what-if, product detail, redeem, and receipt.
- [x] Add contract tests for route-bearing Earn snapshots.

Acceptance criteria:

- [x] Earn does not rely on unverified snapshot routes.
- [x] Deep-linked Earn pages have safe back behavior.

Completion evidence:

- Earn audit remains stable at 155 total edges, 0 resolved targets,
  112 dynamic expressions, and 43 back/modal handlers.
- `dynamic_navigation_route_contract_test` covers route-bearing Earn data and
  reviewed query keys.
- `test/features/earn` passed 354 tests, including staking dashboard,
  risk/suitability, validator, governance, integration, savings product,
  redeem/receipt, and repeated header-back behavior to Earn/Staking/Savings
  parent routes.

### NAVOPT-12 - Launchpad Module Checklist

Status: Complete

Baseline: 43 total edges, 3 resolved targets, 40 dynamic expressions,
0 back/modal handlers.

Checklist:

- [x] Verify launchpad home, portfolio, performance, staking routes.
- [x] Verify IDO bridge, bridge compare, bridge order routes.
- [x] Verify contract, receipt, claim receipt, batch claim routes.
- [x] Verify notification sound, event log, ABI diff, address book, webhooks,
      gas tracker routes.
- [x] Verify rebalance, multisig, swap aggregator, limit orders, DCA builder,
      and risk analytics.
- [x] Verify detail route and route-bearing tool cards.
- [x] Add contract tests for all Launchpad snapshot routes.

Acceptance criteria:

- [x] Launchpad dynamic route expressions are tested or converted.

Completion evidence:

- Launchpad audit remains stable at 43 total edges, 3 resolved targets,
  40 dynamic expressions, and 0 back/modal handlers.
- `dynamic_navigation_route_contract_test` covers route-bearing Launchpad data.
- `test/features/launchpad` passed 121 tests, including home shortcuts, detail
  route, portfolio/positions, receipt/claim/batch claim, bridge, event log,
  ABI diff, webhooks, swap aggregator, DCA, risk analytics, and header-back
  behavior for Launchpad child pages.

### NAVOPT-13 - Trade Module Checklist

Status: Complete

Baseline: 162 total edges, 136 resolved targets, 14 dynamic expressions,
12 back/modal handlers.

Checklist:

- [x] Verify spot trade, pair route, order receipt, order history, positions,
      settings, export, convert.
- [x] Verify futures, leverage, advanced chart, margin, margin pair, margin hub,
      market data analytics, live market data analytics, advanced analytics.
- [x] Verify trading bots routes, risk disclosure, suitability, emergency stop,
      security settings, history, performance, backtesting, optimization, guide,
      FAQ, tax reporting, API docs.
- [x] Verify copy trading, V2, provider detail, assessment, configuration,
      confirmation, active copies, performance, attribution, comparison, audit.
- [x] Verify copy safety, governance, dispute, disclosures, transaction
      reporting, regulatory reports, ARM, best execution, venue analysis,
      slippage, client categorization.
- [x] Verify product governance, target market, client money, CASS,
      compensation, ex-ante costs, RIY, ex-post costs, KID, scenarios, risk
      indicator, complaints, ombudsman, audit trail, inspection ready.
- [x] Convert remaining raw route strings to `AppRoutePaths`.

Acceptance criteria:

- [x] No high-risk Trade flow loses preview, receipt, or audit route.

Completion evidence:

- Trade audit remains stable at 162 total edges, 136 resolved targets,
  14 dynamic expressions, and 12 back/modal handlers.
- Remaining raw Trade navigation strings in `trade_page_part_01.dart` were
  converted to `AppRoutePaths.tradePositions` and
  `AppRoutePaths.tradeSettings`; no direct `context.go('/...')` calls remain
  under `lib/features/trade`.
- `test/features/trade` passed 344 tests across spot, futures, margin, bots,
  copy trading, regulatory reporting, product governance, complaints, receipt,
  and audit surfaces.
- `navigation_route_guardrails_test`, router tests, navigation edge audit
  check, and `flutter analyze` passed.

### NAVOPT-14 - Arena Module Checklist

Status: Complete

Baseline: 89 total edges, 42 resolved targets, 17 dynamic expressions,
30 back/modal handlers.

Checklist:

- [x] Verify Arena home, guide, studio, smart rules, presets, governance.
- [x] Verify mode detail, challenge detail, join, resolution, creator,
      leaderboard, verified.
- [x] Verify flow map, safety, blocked users, reports, my arena, production,
      bridge, ecosystem.
- [x] Verify trust breakdown, ledger, ledger entry, report case.
- [x] Decide whether `/arena/points` stays as redirect to `/rewards?tab=arena`
      or becomes a canonical Arena points page.
- [x] Add product-copy guardrail coverage where navigation changes touch Arena
      labels.

Acceptance criteria:

- [x] Arena remains points-only.
- [x] Prediction route bridge does not mix wallet/PnL language into Arena.

Completion evidence:

- Arena audit remains stable at 89 total edges, 42 resolved targets,
  17 dynamic expressions, and 30 back/modal handlers.
- `/arena/points` intentionally stays as a redirect alias to
  `/rewards?tab=arena`; `arena_points_page_test` verifies it renders Arena
  Points inside the Rewards Hub.
- Arena direct raw route calls were removed from `arena_home_page_part_01.dart`
  and `arena_guide_page_part_01.dart` by using `AppRoutePaths`.
- `test/features/arena` passed 111 tests, including canonical Arena route
  edges, guide, safety, bridge, production/ecosystem, ledger, report, and
  points surfaces.
- `product_copy_guardrails_test` and
  `prediction_product_copy_guardrails_test` passed, preserving points-only and
  Prediction/Arena boundary copy.

### NAVOPT-15 - Wallet Module Checklist

Status: Complete

Baseline: 45 total edges, 26 resolved targets, 3 dynamic expressions,
16 back/modal handlers.

Checklist:

- [x] Verify wallet hub actions.
- [x] Verify deposit and asset-specific deposit.
- [x] Verify withdraw and asset-specific withdraw.
- [x] Verify transaction history and transaction detail.
- [x] Verify portfolio analytics, address book, add address, buy crypto,
      transfer, asset detail.
- [x] Verify multi-manager, gas optimizer, token approval, health score,
      pending deposits, limits, dust converter, network status.
- [x] Verify withdraw preview, transfer confirm, token revoke, and address add
      confirmations close safely.

Acceptance criteria:

- [x] Withdraw/address/transfer flows keep preview and confirmation.

Completion evidence:

- Wallet audit remains stable at 45 total edges, 26 resolved targets,
  3 dynamic expressions, and 16 back/modal handlers.
- The remaining direct support route in `transaction_detail_page.dart` was
  converted to `AppRoutePaths.support`.
- `test/features/wallet` passed 66 tests across wallet hub, deposit,
  withdraw, transfer, address book/add, transaction history/detail, approvals,
  health, limits, network, pending deposits, gas optimizer, and dust converter.
- `critical_navigation_back_behavior_test` covers withdraw, address add, and
  token approval safe parent-route back behavior.
- `p2p_wallet_product_copy_guardrails_test`, `product_copy_guardrails_test`,
  navigation edge audit check, navigation route guardrail, and
  `flutter analyze` passed.

### NAVOPT-16 - Markets And Predictions Checklist

Status: Complete

Checklist:

- [x] Verify Markets hub links and back behavior.
- [x] Verify pair detail to trade buy/sell query routes.
- [x] Verify token info, pair depth, advanced charts.
- [x] Verify Prediction Markets home/search/breaking/event/detail/portfolio/
      rewards/leaderboard/activity/receipt/risk/market maker/analyzer/calendar/
      social/advanced chart/tournaments/data integration.
- [x] Verify Prediction -> Arena bridge only uses allowed bridge concepts.

Acceptance criteria:

- [x] Markets to Trade bridge is intentional and tested.
- [x] Prediction Markets remains separate from Arena.

Completion evidence:

- Markets audit remains stable at 51 total edges, 45 resolved targets,
  4 dynamic expressions, and 2 back/modal handlers.
- Predictions audit remains stable at 41 total edges, 40 resolved targets,
  0 dynamic expressions, and 0 back/modal handlers.
- Markets route calls for predictions, arena, pair detail, trade pair, movers,
  sectors, and heatmap were converted to `AppRoutePaths`; no direct raw route
  calls remain under `lib/features/markets` or `lib/features/predictions`.
- `test/features/markets` passed 124 tests and `test/features/predictions`
  passed 85 tests.
- Router tests, navigation edge audit check, navigation route guardrail,
  Prediction copy guardrails, Arena/product copy guardrails, and
  `flutter analyze` passed.

### NAVOPT-17 - Smaller Module Checklist

Status: Complete

Checklist:

- [x] Auth: login, register, OTP, 2FA, forgot password, reset password,
      onboarding.
- [x] Profile: edit, KYC, security, settings, activity, API, VIP, devices,
      sub-accounts, profile predictions, profile arena.
- [x] DCA: root, optimizer, dynamic amount, backtester, multi-asset,
      performance, smart rules, rebalance, schedule config, schedule analytics.
- [x] Referral: home, history, rewards, rules, friend detail.
- [x] Support: support, help, announcements, chat/ticket route decision.
- [x] Discovery: search, topic hub, prediction/arena/entity route cards.
- [x] Cross-module: unified portfolio, analytics, smart alerts, tax reports.
- [x] Admin/dev/enterprise/news/notifications/onboarding route and back
      behavior.

Acceptance criteria:

- [x] All smaller modules have route contract coverage or documented static
      route targets.

Completion evidence:

- Smaller-module audit aggregate is 145 total edges, 60 resolved targets,
  57 dynamic expressions, and 28 back/modal handlers across admin, auth,
  cross-module, DCA, dev, discovery, enterprise states, home, news,
  notifications, onboarding, profile, referral, and support.
- Profile and Referral direct raw route calls were converted to
  `AppRoutePaths`.
- No direct raw route calls remain under the smaller module feature folders
  checked for NAVOPT-17.
- Focused tests passed:
  `test/features/auth test/features/profile test/features/dca test/features/referral`
  with 151 tests,
  `test/features/support test/features/discovery test/features/cross_module`
  with 45 tests, and
  `test/features/admin test/features/dev test/features/enterprise_states`
  plus `news`, `notifications`, `onboarding`, `rewards`, and `home` with
  75 tests.
- Router tests, dynamic route contract tests, critical back behavior tests,
  navigation edge audit check, navigation route guardrail, and
  `flutter analyze` passed.

## Final Definition Of Done

The navigation optimization is complete only when all items below are true:

- [x] `dart run tool/route_coverage_audit.dart --check` passes.
- [x] `dart run tool/navigation_edge_audit.dart --check` exists and passes.
- [x] Every route-bearing data object is covered by a route contract test.
- [x] Every product route has an owner route group.
- [x] No real feature page is left in `placeholder_routes.dart` unless
      intentionally documented.
- [x] Route names are complete for non-temporary product routes.
- [x] Query parameters have documented supported values and fallback behavior.
- [x] Bottom-nav active destination behavior is documented and tested.
- [x] P2P, Wallet, Trade, Earn, Arena, and Launchpad high-risk flows keep
      preview, confirmation, receipt, and safe back behavior where required.
- [x] `flutter analyze` passes.
- [x] Focused router tests pass.
- [x] Full `flutter test --reporter=compact` passes.
- [x] The plan status is updated with final counts and any accepted exceptions.

Final verification evidence:

- Final navigation edge counts remain stable at 913 handlers, 431 resolved
  targets, 345 dynamic expressions, and 137 back/modal handlers.
- `dart format --output=none --set-exit-if-changed .` passed with 0 changed
  files.
- `dart run tool/route_coverage_audit.dart --check` passed.
- `dart run tool/navigation_edge_audit.dart --check` passed.
- `flutter analyze` passed.
- `flutter test test/app/router test/quality --reporter=compact` passed.
- `flutter test --reporter=compact` passed with 1888 tests.

## Work Log

Use this section after each pass.

| Date | Phase | Module | Before edges | After edges | Dynamic before | Dynamic after | Tests | Notes |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- | --- |
| 2026-06-01 | Baseline | all | 913 | 913 | 345 | 345 | `route_coverage_audit --check` | Initial navigation optimization baseline. |
| 2026-06-01 | NAVOPT-00 | all | 913 | 913 | 345 | 345 | `route_coverage_audit --check`; CSV count check | Baseline reproduced: resolved 431, back/modal 137, no drift. |
| 2026-06-01 | NAVOPT-01 | all | 913 | 913 | 345 | 345 | `navigation_edge_audit --check`; `route_coverage_audit --check`; `dart analyze tool/navigation_edge_audit.dart`; `flutter analyze`; router tests; architecture guardrails; full tests | Permanent edge audit tool added; CSV regenerated with no baseline drift. |
| 2026-06-01 | NAVOPT-02 | all | 913 | 913 | 345 | 345 | `navigation_route_guardrails_test`; `navigation_intent_test` | Route constant and typed intent standard added; raw UI route literal debt capped at 28. |
| 2026-06-01 | NAVOPT-03 | p2p, earn, launchpad, arena, discovery, cross_module | 913 | 913 | 345 | 345 | `dynamic_navigation_route_contract_test` | Data-driven route contract test added; Launchpad detail receipt route fixed from missing `/launchpad/receipt/new` to declared sample receipt. |
| 2026-06-01 | NAVOPT-04 | app shell | 913 | 913 | 345 | 345 | `app_router_test` | Bottom-nav IA documented; search/news/support/notifications map to Home, pair detail maps to Markets, Product Hub modules remain under Trade. |
| 2026-06-01 | NAVOPT-05 | router ownership | 913 | 913 | 345 | 345 | route coverage audit; router tests; route coverage guardrail | Real DCA, Admin, Trade copy, and settings security routes moved out of placeholder ownership; truth table regenerated at 414 real pages and 3 aliases. |
| 2026-06-01 | NAVOPT-06 | router names | 913 | 913 | 345 | 345 | route name contract; router tests; route coverage audit | Stable names added for 14 product routes plus 1 redirect alias; truth table regenerated with names visible. |
| 2026-06-01 | NAVOPT-07 | trade, p2p, rewards | 913 | 913 | 345 | 345 | trade query tests; P2P query tests; rewards query tests | Query contract documented; invalid side/asset/type/direction/tab values fall back safely without skipping preview or confirmation. |
| 2026-06-01 | NAVOPT-08 | back/modal | 913 | 913 | 345 | 345 | back/modal audit CSV; critical back behavior tests | All 137 back/modal handlers classified; direct deep-link back fallback coverage expanded for P2P wallet transfer. |
| 2026-06-01 | NAVOPT-09 | module order | 913 | 913 | 345 | 345 | plan review | Module pass order confirmed; P2P remains first due edge count and financial/security risk. |
| 2026-06-01 | NAVOPT-10 | p2p | 181 | 181 | 96 | 96 | `flutter test test/features/p2p --reporter=compact`; `dynamic_navigation_route_contract_test` | P2P route graph verified end-to-end; dynamic route expressions remain accepted because all route-bearing P2P data is contract-tested and high-risk preview/confirmation flows still pass. |
| 2026-06-01 | NAVOPT-11 | earn | 155 | 155 | 112 | 112 | `flutter test test/features/earn --reporter=compact`; `dynamic_navigation_route_contract_test`; router/back tests | Earn route graph verified across Staking and Savings; dynamic snapshot routes are contract-tested and deep-linked pages keep parent-route back behavior. |
| 2026-06-01 | NAVOPT-12 | launchpad | 43 | 43 | 40 | 40 | `flutter test test/features/launchpad --reporter=compact`; `dynamic_navigation_route_contract_test`; router tests | Launchpad route-bearing tools, receipts, bridge, and detail routes verified; dynamic expressions remain accepted through contract coverage. |
| 2026-06-01 | NAVOPT-13 | trade | 162 | 162 | 14 | 14 | `flutter test test/features/trade --reporter=compact`; `navigation_route_guardrails_test`; router tests; `navigation_edge_audit --check`; `flutter analyze` | Trade route graph verified; remaining direct raw route calls in the Trade page quick nav were converted to `AppRoutePaths` without changing route behavior. |
| 2026-06-01 | NAVOPT-14 | arena | 89 | 89 | 17 | 17 | `flutter test test/features/arena --reporter=compact`; product copy guardrails; `navigation_edge_audit --check`; `flutter analyze` | Arena route graph verified; `/arena/points` remains a redirect alias to Rewards Hub with Arena tab selected, and Arena copy stays points-only. |
| 2026-06-01 | NAVOPT-15 | wallet | 45 | 45 | 3 | 3 | `flutter test test/features/wallet --reporter=compact`; back behavior tests; wallet/product copy guardrails; `navigation_edge_audit --check`; `flutter analyze` | Wallet high-risk routes verified; support edge uses `AppRoutePaths.support`, and withdraw/address/transfer confirmation behavior remains covered. |
| 2026-06-01 | NAVOPT-16 | markets, predictions | 92 | 92 | 4 | 4 | `flutter test test/features/markets --reporter=compact`; `flutter test test/features/predictions --reporter=compact`; router tests; copy guardrails; `navigation_edge_audit --check`; `flutter analyze` | Markets and Predictions graph verified; Markets bridge routes now use `AppRoutePaths`, and Prediction/Arena boundary copy remains guarded. |
| 2026-06-01 | NAVOPT-17 | smaller modules | 145 | 145 | 57 | 57 | focused smaller-module tests; router/back tests; `dynamic_navigation_route_contract_test`; `navigation_edge_audit --check`; `flutter analyze` | Auth, Profile, DCA, Referral, Support, Discovery, Cross-module, Admin, Dev, Enterprise states, News, Notifications, Onboarding, Rewards, and Home verified; remaining raw route calls in Profile/Referral were converted to `AppRoutePaths`. |
| 2026-06-01 | Final DoD | all | 913 | 913 | 345 | 345 | format check; route coverage audit; navigation edge audit; `flutter analyze`; router/quality tests; full `flutter test` | Navigation optimization complete; final full test suite passed with 1888 tests and no accepted exceptions. |
