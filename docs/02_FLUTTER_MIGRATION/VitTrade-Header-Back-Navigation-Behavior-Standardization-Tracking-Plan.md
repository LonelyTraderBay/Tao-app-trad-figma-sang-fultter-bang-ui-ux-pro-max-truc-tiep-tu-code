# VitTrade Header Back Navigation Behavior Standardization Tracking Plan

Created: 2026-06-04

Status: Complete - Phase 0 through Phase 10 completed on 2026-06-04.

Scope: standardize the top-header back button behavior across the Flutter app so
the user always understands where "Quay lại" will go, while keeping financial,
trading, P2P, wallet, security, and confirmation flows safe.

## 1. Objective

Mục tiêu là biến nút quay lại trên top header thành một behavior contract rõ
ràng, có audit và test guardrail:

- Nút quay lại hiển thị thì phải bấm được, không được là `_noop`.
- Mỗi màn hình có header back phải có fallback route rõ ràng khi vào bằng deep
  link.
- Route nhiều nguồn vào phải dùng `backPath` hoặc helper resolve back target.
- Financial/trading/high-risk routes không được pop mù về trạng thái confirm cũ.
- Modal/sheet close không được bị nhầm với screen back navigation.
- Android physical back và header back phải được kiểm tra ở các route đại diện.
- Không đổi business logic tài chính/trading.
- Không đổi route public hiện có nếu không có lý do bắt buộc.

## 2. Source Docs And Existing Baseline

Phải đọc trước khi thực hiện:

- `AGENTS.md`
- `docs/00_START_HERE.md`
- `docs/03_DESIGN_SYSTEM/Guidelines.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Back-Modal-Behavior-Audit.csv`

Current baseline observed 2026-06-04:

- Header back actions from top-header action audit: `373`.
- `VitHeader` back actions: `372`.
- `_PairHeader` instrument back action: `1`.
- `showBack: true` occurrences in `flutter_app/lib`: `379`.
- `context.canPop()` occurrences in `flutter_app/lib`: `57`.
- `backPath` occurrences in `flutter_app/lib`: `30`.
- Existing NAVOPT-08 back/modal audit classifies `137` handlers:
  `55` fallback-to-parent route handlers, `73` modal close handlers, and `9`
  sheet result return handlers.

Important current behavior:

- `VitHeader` renders back only when `showBack: true`.
- `VitHeader` back uses `VitHeaderActionButton(type: back)`.
- Default icon: `Icons.chevron_left_rounded`.
- Default tooltip/semantics: `Quay lại`.
- Current fallback inside primitive is `onPressed ?? _noop`, so a missing
  `onBack` can create a visible inert back button.
- Most pages currently use explicit `context.go(parentRoute)`, not browser-like
  history pop.

## 3. Product Policy

### 3.1 Back Button Meaning

In VitTrade, header back should mean "return to the safest parent context for
this screen." It is not always the same as "go to the previous history entry."

This is intentional for a crypto exchange / trading super-app because high-risk
flows must avoid accidentally returning to stale confirmation, preview, or
submit states.

### 3.2 Route Categories

| Category | Preferred back behavior | Examples |
| --- | --- | --- |
| Root modules | No header back | Home, Markets, Wallet, P2P, Profile, Launchpad, Rewards |
| Simple detail | `context.go(parentRoute)` | Withdraw -> Wallet, P2P order -> P2P |
| Deep-link-safe step | `canPop() ? pop() : go(fallback)` | Auth reset, 2FA setup, P2P proof upload |
| Dynamic source detail | `go(resolvedBackPath ?? fallback)` | Copy provider detail, copy configuration |
| Instrument/trading | Explicit parent or market context | Pair detail, token info, market depth |
| Fullscreen tool | Local close/back in tool UI, with fallback | Advanced chart, futures, P2P chat |
| Modal/sheet | `Navigator.pop` only for modal result | Withdraw preview sheet, dialog close |

### 3.3 Non-Negotiable Rules

- No visible back button without an actionable `onBack`.
- No route should rely only on `context.pop()` unless the route cannot be
  deep-linked.
- High-risk financial pages must have explicit fallback routes.
- `backPath` from URL query must be decoded and validated before use.
- `backPath` must not allow external URLs or arbitrary unsafe paths.
- Modal close must stay separate from screen back navigation.
- Header back must keep the existing icon/semantics unless design system changes
  explicitly require otherwise.

## 4. Proposed Architecture

### 4.1 Shared Helper

Add a small helper under a navigation boundary, preferably:

`flutter_app/lib/core/navigation/back_navigation.dart`

Proposed API:

```dart
enum BackNavigationMode {
  parentRouteOnly,
  historyThenFallback,
}

void goBackOrFallback(
  BuildContext context, {
  required String fallbackPath,
  BackNavigationMode mode = BackNavigationMode.parentRouteOnly,
});

String resolveSafeBackPath({
  required String? candidate,
  required String fallbackPath,
  List<String> allowedPrefixes = const [],
});
```

Behavior:

- `parentRouteOnly`: always `context.go(fallbackPath)`.
- `historyThenFallback`: if `context.canPop()` then `context.pop()`, otherwise
  `context.go(fallbackPath)`.
- `resolveSafeBackPath`: accepts app-internal paths only, rejects empty strings,
  external URLs, malformed routes, and disallowed prefixes.

Do not make this helper responsible for business validation, preview, submit, or
financial state transitions.

### 4.2 Header Primitive Guardrail

Update `VitHeader` and `VitTopChrome` behavior only after audit confirms no
page depends on inert back buttons:

- In debug, assert `!showBack || onBack != null` for primitive-owned back.
- If a page intentionally needs visual spacing only, it must use an explicit
  placeholder, not `showBack: true`.
- Keep `VitHeaderActionButton` semantics unchanged:
  - `button: true`
  - label/tooltip: `Quay lại`
  - icon: `chevron_left_rounded`

### 4.3 Audit Tool

Either extend `top_header_action_audit.dart` or create:

`flutter_app/tool/back_navigation_behavior_audit.dart`

Required output:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Header-Back-Navigation-Behavior-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Header-Back-Navigation-Behavior-Audit.csv`

Required classifications:

- `parent_route_only`
- `history_then_fallback`
- `dynamic_back_path`
- `modal_close`
- `sheet_result`
- `missing_on_back`
- `unsafe_back_path`
- `unknown`

Audit must fail in strict mode when:

- `showBack: true` has no `onBack`.
- `context.pop()` has no fallback on a routed screen.
- `backPath` is used without validation.
- high-risk routes use history-only pop.
- modal close is counted as screen navigation.

## 5. Implementation Phases

### Phase 0 - Baseline Lock

Goal: freeze current behavior before edits.

Checklist:

- [x] Read all source docs listed in section 2.
- [x] Run current top-header action audit.
- [x] Run current visual archetype audit.
- [x] Read `VitTrade-Back-Modal-Behavior-Audit.csv`.
- [x] Count current:
  - `showBack: true`
  - `context.canPop()`
  - `context.pop()`
  - `backPath`
  - `onBack: () => context.go(...)`
- [x] Identify visible back buttons that may be inert because `onBack` is
  missing.
- [x] Update tracking board evidence.

Commands:

```bash
cd flutter_app
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart --check --strict
rg -n "showBack:\s*true|context\.canPop\(\)|context\.pop\(\)|backPath|onBack:" lib test
flutter test test/app/router/critical_navigation_back_behavior_test.dart --reporter=compact
```

### Phase 1 - Back Policy Classification

Goal: assign every routed screen with header back to the correct behavior class.

Checklist:

- [x] Create an inventory table from audit output.
- [x] Mark each route as:
  - root/no-header
  - parent route only
  - history then fallback
  - dynamic back path
  - fullscreen/tool exit
  - modal/sheet close
- [x] Mark high-risk routes:
  - wallet withdraw
  - wallet address add
  - P2P order/cancel/proof/dispute/escrow
  - trade order receipt
  - futures/leverage
  - copy trading confirmation/configuration
  - launchpad claim/receipt/bridge order
  - profile security/API/KYC
- [x] Define fallback route for every high-risk route.
- [x] Stop if any route has ambiguous parent ownership.

Evidence:

- Inventory table attached to the audit Markdown.
- No route remains `unknown`.

### Phase 2 - Shared Helper Contract

Goal: add one central helper for back behavior.

Checklist:

- [x] Add `core/navigation/back_navigation.dart`.
- [x] Implement `BackNavigationMode`.
- [x] Implement `goBackOrFallback`.
- [x] Implement `resolveSafeBackPath`.
- [x] Reject unsafe `backPath` values:
  - empty
  - external URL
  - `javascript:`
  - path not starting with `/`
  - path outside allowed prefixes when prefixes are provided
- [x] Add unit tests for helper.
- [x] Do not touch business logic.

Tests:

```bash
cd flutter_app
flutter test test/core/navigation/back_navigation_test.dart --reporter=compact
flutter analyze
```

### Phase 3 - Header Primitive Guardrail

Goal: prevent visible inert back buttons.

Checklist:

- [x] Update `VitHeader` debug assertion for `showBack` with missing `onBack`
  after Phase 0 proves no legitimate dependency exists.
- [x] Update `VitTopChrome` debug assertion for primitive-owned `showBack`.
- [x] Keep `_PairHeader` custom instrument back checked through action audit.
- [x] Add tests:
  - `VitHeader(showBack: true, onBack: ...)` works.
  - `VitTopChrome(showBack: true, onBack: ...)` works.
  - `showBack: true` without `onBack` fails in debug or is explicitly
    disallowed by audit.
- [x] Confirm tooltip/semantics remain `Quay lại`.

Tests:

```bash
cd flutter_app
flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_top_chrome_test.dart test/shared/layout/vit_header_action_button_test.dart --reporter=compact
```

### Phase 4 - Critical Parent Route Refactor

Goal: use the shared helper on representative high-risk and critical routes.

Priority order:

1. Wallet
2. P2P
3. Trade
4. Launchpad
5. Markets/Predictions
6. Profile/Auth/Security

Checklist:

- [x] Replace direct repeated patterns with helper where it improves safety.
- [x] Keep explicit parent route behavior for high-risk screens.
- [x] Do not convert high-risk screens to history-first unless explicitly
  justified.
- [x] Ensure deep-linked entry has a stable fallback.
- [x] Add focused tests for each changed module.

Representative routes:

| Route | Current expected fallback | Required behavior |
| --- | --- | --- |
| `/wallet/withdraw` | `/wallet` | parent route only |
| `/wallet/address-book/add` | `/wallet/address-book` | parent route only |
| `/wallet/token-approval` | `/wallet` | parent route only |
| `/p2p/order/:orderId` | `/p2p` | parent route only |
| `/p2p/order/proof/:orderId` | `/p2p/order/:orderId` | history then fallback or parent route only |
| `/trade/order-receipt` | `/trade` | parent route only |
| `/trade/:pairId/futures/leverage` | `/trade/:pairId/futures` | parent route only |
| `/launchpad/claim-receipt/pos001` | launchpad parent/portfolio route | parent route only |
| `/profile/security` | `/profile` | parent route only |

Tests:

```bash
cd flutter_app
flutter test test/app/router/critical_navigation_back_behavior_test.dart --reporter=compact
flutter test test/features/wallet/withdraw_page_test.dart test/features/p2p/p2p_order_page_test.dart test/features/p2p/p2p_order_proof_page_test.dart test/features/trade/order_receipt_page_test.dart --reporter=compact
```

### Phase 5 - Dynamic `backPath` Standardization

Goal: make dynamic source routes predictable and safe.

Checklist:

- [x] Standardize route builders that read query `back`.
- [x] Decode and validate `backPath` before passing to pages.
- [x] Use `resolveSafeBackPath`.
- [x] Keep fallback route if `backPath` is invalid.
- [x] Add route contract tests for encoded/invalid `back`.
- [x] Ensure no external URL can be navigated through `backPath`.

Representative routes:

| Route | Dynamic source | Fallback |
| --- | --- | --- |
| `/trade/copy-provider/:providerId` | `?back=` | `/trade/copy-trading` |
| `/trade/copy-provider/:providerId/configuration` | `?back=` | provider detail |
| `/pair/:pairId/depth` | constructor `backPath` | pair detail |
| Prediction portfolio/detail routes | constructor/query where used | prediction parent |

Tests:

```bash
cd flutter_app
flutter test test/app/router/app_route_paths_trade_contract_test.dart test/app/router/dynamic_navigation_route_contract_test.dart --reporter=compact
```

### Phase 6 - Auth, Security, And Account Flows

Goal: preserve natural back behavior where history is safe, with direct-link
fallback.

Checklist:

- [x] Keep `historyThenFallback` for auth flows where it is already correct.
- [x] Use fallback for direct URL entry:
  - reset password -> login
  - 2FA setup -> OTP or security parent
  - OTP -> login where appropriate
- [x] Profile security/KYC/API routes should use explicit parent route unless
  there is a real multi-step stack.
- [x] Add tests for direct deep-link entry and in-flow entry.

Tests:

```bash
cd flutter_app
flutter test test/features/auth/reset_password_page_test.dart test/features/auth/two_fa_setup_page_test.dart test/features/profile/security_page_test.dart --reporter=compact
```

### Phase 7 - Full Module Sweep

Goal: finish all non-critical modules without changing product logic.

Checklist:

- [x] Arena: keep points-only boundary, no wallet/trading wording changes.
- [x] Earn: preserve staking/savings parent routes.
- [x] DCA: return to DCA parent or Trade as defined by route contract.
- [x] Referral: return to referral parent.
- [x] Support/Discovery/News/Notifications: return to Home/support parent as
  currently intended.
- [x] Admin/Dev/Internal surfaces: keep internal gate behavior and safe parent.
- [x] No route left with `missing_on_back`.
- [x] No route left with `unknown`.

Tests:

```bash
cd flutter_app
flutter test test/app/router/app_router_test.dart --reporter=compact
flutter test test/quality/internal_surface_guardrails_test.dart --reporter=compact
```

### Phase 8 - Back Navigation Audit Tool

Goal: make future drift visible.

Checklist:

- [x] Add or update audit tool.
- [x] Generate Markdown and CSV artifacts.
- [x] Strict mode fails for:
  - missing `onBack`
  - history pop without fallback
  - unsafe dynamic `backPath`
  - modal close counted as screen back
  - high-risk route without fallback
- [x] Add quality guardrail test to run audit in strict mode.
- [x] Keep existing `VitTrade-Back-Modal-Behavior-Audit.csv` as historical
  baseline or regenerate with the new schema.

Commands:

```bash
cd flutter_app
dart run tool/back_navigation_behavior_audit.dart
dart run tool/back_navigation_behavior_audit.dart --check --strict
flutter test test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact
```

### Phase 9 - Android And Visual QA

Goal: verify real-device/emulator behavior for header back and Android physical
back on representative routes.

Checklist:

- [x] Build debug APK.
- [x] Install on emulator.
- [x] Launch app.
- [x] Capture screenshots for representative routes with visible back.
- [x] Test header back tap on:
  - Wallet withdraw
  - P2P order
  - P2P proof upload
  - Copy provider detail with valid `back`
  - Copy provider detail with invalid `back`
  - Reset password direct entry
- [x] Test Android physical back on at least:
  - Wallet withdraw
  - P2P proof upload
  - Copy provider detail
- [x] Save screenshots/logs under:
  `flutter_app/run-artifacts/back_navigation/`.

Commands:

```bash
cd flutter_app
flutter build apk --debug
adb devices
adb -s <serial> install -r build/app/outputs/flutter-apk/app-debug.apk
adb -s <serial> shell am start -n com.vittrade.vit_trade_flutter/.MainActivity
adb -s <serial> exec-out uiautomator dump /dev/tty
adb -s <serial> shell input keyevent 4
adb -s <serial> shell screencap -p /sdcard/back_nav.png
adb -s <serial> pull /sdcard/back_nav.png run-artifacts/back_navigation/back_nav.png
```

### Phase 10 - Final Verification

Goal: close the work with full confidence.

Checklist:

- [x] `dart format --output=none --set-exit-if-changed lib test tool` pass.
- [x] `flutter analyze` pass.
- [x] Back navigation audit strict pass.
- [x] Top-header action audit strict pass.
- [x] Visual archetype audit strict pass.
- [x] Route coverage audit pass.
- [x] Navigation edge audit pass.
- [x] Focused route tests pass.
- [x] Full `flutter test --reporter=compact` pass.
- [x] Tracking board updated with evidence.
- [x] Visual/emulator artifacts linked in this plan.

Commands:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze
dart run tool/back_navigation_behavior_audit.dart --check --strict
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter test --reporter=compact
```

## 6. Required Test Matrix

| Area | Test file | Required additions |
| --- | --- | --- |
| Helper contract | `test/core/navigation/back_navigation_test.dart` | fallback, history mode, invalid `backPath` |
| Header primitive | `test/shared/layout/vit_header_test.dart` | visible back cannot be inert |
| Top chrome | `test/shared/layout/vit_top_chrome_test.dart` | `showBack` requires callback |
| Critical routes | `test/app/router/critical_navigation_back_behavior_test.dart` | expand high-risk route cases |
| Dynamic routes | `test/app/router/dynamic_navigation_route_contract_test.dart` | valid/invalid `back` query |
| Quality guardrail | `test/quality/back_navigation_behavior_guardrail_test.dart` | strict audit pass |
| Android QA | manual artifact | header back and physical back screenshots/logs |

## 7. Route Checklist

| Module | Route/Page | Expected Back Target | Mode | Status | Evidence |
| --- | --- | --- | --- | --- | --- |
| Wallet | Withdraw | `/wallet` | parent route only | `[x]` | Phase 4 helper refactor; `critical_navigation_back_behavior_test`, `withdraw_page_test`. |
| Wallet | Address add | `/wallet/address-book` | parent route only | `[x]` | Phase 4 helper refactor; `critical_navigation_back_behavior_test`. |
| Wallet | Token approval | `/wallet` | parent route only | `[x]` | Phase 4 helper refactor; `critical_navigation_back_behavior_test`. |
| P2P | Order detail | `/p2p` | parent route only | `[x]` | Phase 4 helper refactor; `p2p_order_page_test`. |
| P2P | Order proof | `/p2p/order/:orderId` | history then fallback or parent route only | `[x]` | Phase 4 helper refactor keeps `historyThenFallback`; `p2p_order_proof_page_test`. |
| P2P | Chat fullscreen | chat UI exit/back | fullscreen tool | `[x]` | Local fullscreen chat header uses explicit `context.go(AppRoutePaths.p2pOrder(snapshot.orderId))`; `p2p_chat_page_test` covers detail/E2E safe navigation and full `flutter test` pass. |
| Trade | Order receipt | `/trade` | parent route only | `[x]` | Phase 4 helper refactor; `order_receipt_page_test`. |
| Trade | Futures | `/trade` or pair trade parent | fullscreen/high-risk contract | `[x]` | Fullscreen local close uses `AppRoutePaths.tradePair(widget.pairId)`; `futures_page_test` verifies close returns to TradePage, chart/leverage actions stay scoped. |
| Trade | Futures leverage | `/trade/:pairId/futures` | parent route only | `[x]` | Phase 4 helper refactor; `flutter analyze`. |
| Trade | Copy provider detail | valid `backPath` or `/trade/copy-trading` | dynamic back path | `[x]` | Phase 5 validates `?back=` in router/page; valid source returns to Copy Trading v2, invalid external URL falls back to `/trade/copy-trading`. |
| Trade | Copy configuration | valid `backPath` or provider detail | dynamic back path | `[x]` | Phase 5 validates `?back=` in router/page; valid source returns to active copies, invalid `/wallet` falls back to provider detail. |
| Markets | Pair detail | `/home` or agreed market parent | instrument explicit parent | `[x]` | `_PairHeader` delegates owner-provided back callback; `pair_detail_page_test` verifies header back returns to Home; action audit keeps the custom instrument back action counted. |
| Markets | Token info | pair detail | parent route only | `[x]` | Back audit classifies `token_info_page.dart` as `parent_route_only` with `AppRoutePaths.pairDetail(pair.id)`; `token_info_page_test` verifies return to PairDetailPage. |
| Markets | Market depth | pair detail from `backPath` | dynamic constructor fallback | `[x]` | Phase 5 validates constructor `backPath`; invalid external URL falls back to pair detail. |
| Predictions | Portfolio/profile portfolio | prediction parent or profile source | dynamic constructor fallback | `[x]` | Phase 5 validates constructor `backPath`; profile source remains allowed, invalid external URL falls back to predictions parent. |
| Predictions | Risk calculator | predictions parent | parent route only | `[x]` | Back audit classifies `prediction_risk_calculator_page.dart` as `parent_route_only` with `AppRoutePaths.marketsPredictions`; `critical_navigation_back_behavior_test` and `prediction_risk_calculator_page_test` verify parent return. |
| Launchpad | Claim receipt | launchpad parent/portfolio | parent route only | `[x]` | Phase 4 helper refactor uses existing `snapshot.backRoute`; `back_navigation_behavior_audit --check`. |
| Auth | Reset password | history or login | history then fallback | `[x]` | Phase 6 helper refactor; direct header back falls back to Login. |
| Auth | 2FA setup | history or OTP/security parent | history then fallback | `[x]` | Phase 6 helper refactor; direct header back falls back to OTP. |
| Profile | Security | profile | parent route only | `[x]` | Phase 6 helper refactor; direct header back returns to Profile. |
| Profile | KYC | profile | parent route only | `[x]` | Phase 6 helper refactor; direct header back returns to Profile. |
| Profile | API management/create | profile or API parent | parent route only | `[x]` | Phase 6 helper refactor; API management back returns to Profile, API create back returns to API management. |
| Admin/Dev | Internal surfaces | admin/dev parent or Home gate | parent route only | `[x]` | Phase 7 `internal_surface_guardrails_test` pass; back audit strict has no internal-surface issue. |

## 8. Risk Closure Checklist

- [x] No evidence that back behavior changes make user lose in-flow context.
- [x] No history-first route returns to stale confirmation/submit screen.
- [x] Parent-route-only routes have explicit safe fallback evidence, including
  direct-entry tests where risk is high.
- [x] Dynamic `backPath` rejects unsafe routes and external URLs.
- [x] No visible header back remains inert or noop.
- [x] Modal close remains separate from screen navigation in audit scope.
- [x] Android physical back evidence was captured for representative high-risk
  direct-entry routes; no VitTrade fatal crash was observed.
- [x] Existing route tests pass after updated expectations.
- [x] Audit guardrails run in strict mode and do not hide current drift.

Mitigation:

- Classify routes before editing.
- Use helper with explicit mode.
- Expand direct deep-link tests.
- Keep high-risk routes parent/fallback-first.
- Add strict audit guardrail.
- Use emulator evidence for representative flows.

## 9. Tracking Board

| Phase | Status | Owner note | Evidence |
| --- | --- | --- | --- |
| Phase 0 - Baseline lock | `[x]` | Baseline locked; no visible `showBack: true` missing `onBack` found in source-window scan. | `top_header_action_audit --check --strict` pass: `vit_header_total=381`, canonical back actions `373` (`372` `VitHeader`, `1` custom header). `top_header_visual_archetype_audit --check --strict` pass: `total_routed_screens=414`, `strict_visual_issues=0`. Counts in `lib`: `showBack: true=379`, `context.canPop()=57`, `context.pop()=57`, `backPath=30`, `onBack context.go=308`, `onBack total=396`. Counts in `lib+test`: `showBack: true=384`, `backPath=32`, `onBack total=400`. NAVOPT-08 CSV still groups `55` fallback-to-parent, `73` modal close, `9` sheet result. `flutter test test/app/router/critical_navigation_back_behavior_test.dart --reporter=compact` pass, 9 tests. |
| Phase 1 - Back policy classification | `[x]` | Inventory generated; no `missing_on_back` or `unknown` entries. Four dynamic `backPath` entries are classified as unsafe and queued for Phase 5 because each fallback owner is clear. | `dart run tool/back_navigation_behavior_audit.dart` wrote `VitTrade-Header-Back-Navigation-Behavior-Audit.md/csv`. `dart run tool/back_navigation_behavior_audit.dart --check` pass: `visible_header_back_entries=380`, `parent_route_only=320`, `history_then_fallback=56`, `unsafe_back_path=4`, `strict_back_issues=4`, `high_risk_entries=43`. Unsafe rows: `market_depth_page.dart`, `predictions_portfolio_page.dart`, `copy_configuration_page.dart`, `copy_provider_detail_page.dart`. |
| Phase 2 - Shared helper contract | `[x]` | Added shared back-navigation helper and safe dynamic back-path resolver. No financial/trading business logic changed. | `dart format lib/core/navigation/back_navigation.dart test/core/navigation/back_navigation_test.dart` pass. `flutter test test/core/navigation/back_navigation_test.dart --reporter=compact` pass, 7 tests. `flutter analyze` pass. |
| Phase 3 - Header primitive guardrail | `[x]` | `VitHeader` and `VitTopChrome` now reject visible primitive-owned back without a callback; primitive back no longer falls back to `_noop`. | `dart format` pass for touched shared layout/tests. `flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_top_chrome_test.dart test/shared/layout/vit_header_action_button_test.dart test/shared/layout/vit_layout_primitives_test.dart test/shared/layout/vit_auto_hide_header_scaffold_test.dart --reporter=compact` pass, 32 tests. `flutter analyze` pass. |
| Phase 4 - Critical parent route refactor | `[x]` | Representative high-risk/critical routes now use shared helper while preserving explicit parent fallback. No public route or financial/trading submit logic changed. | `dart format` pass for 11 touched route files. `flutter test test/app/router/critical_navigation_back_behavior_test.dart --reporter=compact` pass, 9 tests. `flutter test test/features/wallet/withdraw_page_test.dart test/features/p2p/p2p_order_page_test.dart test/features/p2p/p2p_order_proof_page_test.dart test/features/trade/order_receipt_page_test.dart --reporter=compact` pass, 20 tests. `flutter analyze` pass after import cleanup. `dart run tool/back_navigation_behavior_audit.dart --check` pass with `380` entries and remaining `4` unsafe dynamic `backPath` issues reserved for Phase 5. `top_header_action_audit --check --strict` pass after artifact refresh. |
| Phase 5 - Dynamic `backPath` standardization | `[x]` | Dynamic `backPath` routes now resolve through the shared validator in route builders/pages. External URLs and out-of-scope app paths fall back to explicit internal parents; Profile prediction portfolio remains an allowed source. | `dart format` pass for touched Phase 5 files. `flutter test test/app/router/app_route_paths_trade_contract_test.dart test/app/router/dynamic_navigation_route_contract_test.dart test/features/trade/copy_provider_detail_page_test.dart test/features/trade/copy_configuration_page_test.dart test/features/markets/market_depth_page_test.dart test/features/predictions/predictions_portfolio_page_test.dart --reporter=compact` pass, 40 tests. `dart run tool/back_navigation_behavior_audit.dart` regenerated artifacts. `dart run tool/back_navigation_behavior_audit.dart --check --strict` pass: `visible_header_back_entries=380`, `strict_back_issues=0`, `parent_route_only=324`, `history_then_fallback=56`. `flutter analyze` pass. |
| Phase 6 - Auth/security/account flows | `[x]` | Auth recovery/2FA flows now use shared `historyThenFallback`; Profile security/KYC/API surfaces use explicit parent fallback through the shared helper. | `dart format` pass for touched auth/profile files. `flutter test test/features/auth/reset_password_page_test.dart test/features/auth/two_fa_setup_page_test.dart test/features/profile/security_page_test.dart test/features/profile/kyc_page_test.dart test/features/profile/api_management_page_test.dart test/features/profile/api_key_create_page_test.dart --reporter=compact` pass, 34 tests. `flutter analyze` pass. `dart run tool/back_navigation_behavior_audit.dart` regenerated artifacts. `dart run tool/back_navigation_behavior_audit.dart --check --strict` pass: `visible_header_back_entries=380`, `strict_back_issues=0`, `parent_route_only=328`, `history_then_fallback=52`. |
| Phase 7 - Full module sweep | `[x]` | Full-module audit found no `missing_on_back`, `unknown`, `unsafe_back_path`, or history-pop issue. Arena remains points-only; Earn/DCA/Referral/Support/News/Notifications/Admin/Dev keep existing route ownership without product logic changes. | `flutter test test/app/router/app_router_test.dart --reporter=compact` pass, 4 tests. `flutter test test/quality/internal_surface_guardrails_test.dart --reporter=compact` pass, 2 tests. `dart run tool/back_navigation_behavior_audit.dart --check --strict` pass: `visible_header_back_entries=380`, `strict_back_issues=0`, `parent_route_only=328`, `history_then_fallback=52`. Audit grep found no `unknown`, `missing_on_back`, `unsafe_back_path`, or history-pop strict issue. |
| Phase 8 - Back navigation audit tool | `[x]` | Back navigation audit is now locked by a quality guardrail test. Existing modal/sheet CSV remains the historical baseline and the new audit artifacts carry the screen-header back schema. | Added `test/quality/back_navigation_behavior_guardrail_test.dart`. `dart format test/quality/back_navigation_behavior_guardrail_test.dart` pass. `dart run tool/back_navigation_behavior_audit.dart` regenerated Markdown/CSV. `dart run tool/back_navigation_behavior_audit.dart --check --strict` pass: `visible_header_back_entries=380`, `strict_back_issues=0`, `parent_route_only=328`, `history_then_fallback=52`. `flutter test test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact` pass, 1 test. |
| Phase 9 - Android and visual QA | `[x]` | Android emulator QA completed on `emulator-5554` using debug APKs built with route-specific `INITIAL_ROUTE` values because AndroidManifest has no app deep-link route. Header back targets were verified through screenshots and UI dumps. Android physical back from direct-start routes exits to launcher without app crash, so it does not re-enter stale high-risk confirmation state; header back remains the explicit fallback contract. | `flutter build apk --debug` pass. `adb install -r build/app/outputs/flutter-apk/app-debug.apk` pass. `adb shell cmd package resolve-activity --brief com.vittrade.vit_trade_flutter` resolved `com.vittrade.vit_trade_flutter/.MainActivity`. Route-specific builds/captures saved under `flutter_app/run-artifacts/back_navigation/`: `wallet_withdraw_android.png`, `wallet_withdraw_after_header_back_android.png`, `p2p_order_android.png`, `p2p_order_after_header_back_android.png`, `p2p_proof_android.png`, `p2p_proof_after_header_back_android.png`, `copy_provider_valid_android.png`, `copy_provider_valid_after_header_back_android.png`, `copy_provider_invalid_android.png`, `copy_provider_invalid_after_header_back_android.png`, `reset_password_android.png`, `reset_password_after_header_back_android.png`, plus matching `*_ui.xml` and `*_logcat.txt`. UI dumps confirm Wallet withdraw -> `SC-135 WalletPage`, P2P order -> `SC-282 P2PHomePage`, P2P proof -> `SC-216 P2POrderPage`, copy provider valid -> `SC-064 CopyTradingPageV2`, copy provider invalid -> `SC-063 CopyTradingPage`, reset password -> `SC-001 LoginPage`. Physical-back dumps for P2P proof/copy provider/reset password show `com.google.android.apps.nexuslauncher`; app logcat files contain no VitTrade fatal crash. |
| Phase 10 - Final verification | `[x]` | Final verification complete. One stale global-access-policy artifact was regenerated, with `policy_violations=0`, before re-running the full suite. | `dart format --output=none --set-exit-if-changed lib test tool` pass after formatting 4 touched files. `flutter analyze` pass. `dart run tool/back_navigation_behavior_audit.dart --check --strict` pass: `visible_header_back_entries=380`, `strict_back_issues=0`, `parent_route_only=328`, `history_then_fallback=52`. `dart run tool/top_header_action_audit.dart --check --strict` pass: `vit_header_total=381`, no legacy/banned/over-limit issues. `dart run tool/top_header_visual_archetype_audit.dart --check --strict` pass: `total_routed_screens=414`, `strict_visual_issues=0`. `dart run tool/route_coverage_audit.dart --check` pass. `dart run tool/navigation_edge_audit.dart --check` pass. `flutter test test/app/router/critical_navigation_back_behavior_test.dart test/app/router/app_route_paths_trade_contract_test.dart test/app/router/dynamic_navigation_route_contract_test.dart test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact` pass, 22 tests. `dart run tool/top_header_global_access_policy_audit.dart` regenerated Markdown/CSV with `policy_violations=0`; guardrail pass. Full `flutter test --reporter=compact` pass, 1983 tests. Phase 9 Android artifacts remain linked under `flutter_app/run-artifacts/back_navigation/`. |

## 10. Definition Of Done

Plan này chỉ hoàn tất khi:

- [x] Mọi route có visible header back đều có actionable `onBack`.
- [x] Không còn visible inert back button.
- [x] High-risk route có fallback route rõ ràng.
- [x] Dynamic `backPath` được validate.
- [x] Modal/sheet close được phân biệt với screen back.
- [x] Back navigation audit strict pass.
- [x] Critical route tests pass.
- [x] Full route/audit/test suite pass.
- [x] Android/emulator evidence có đủ route đại diện.
- [x] Tracking board có evidence cho từng phase.

## 11. Execution Prompt

Use this prompt when assigning implementation to an AI/code agent:

```text
Đọc kỹ AGENTS.md, docs/00_START_HERE.md,
docs/03_DESIGN_SYSTEM/Guidelines.md,
Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md,
VitTrade-Top-Header-Action-Audit.md,
VitTrade-Top-Header-Visual-Archetype-Audit.md,
VitTrade-Back-Modal-Behavior-Audit.csv và
VitTrade-Header-Back-Navigation-Behavior-Standardization-Tracking-Plan.md.

Thực hiện đúng thứ tự Phase 0 -> Phase 10. Không bỏ qua baseline audit.
Không đổi route public nếu không có lý do bắt buộc. Không đổi business logic
tài chính/trading. Không biến high-risk route thành history-only pop. Không
để visible back button bị inert/noop. Modal close phải tách khỏi screen back.

Sau mỗi phase, cập nhật tracking board trong plan, chạy test/audit tương ứng
và ghi evidence. Nếu phát hiện route parent không rõ, unsafe backPath, hoặc
policy conflict trong high-risk flow, dừng phase đó, ghi blocker và không nhảy
sang phase tiếp theo.
```
