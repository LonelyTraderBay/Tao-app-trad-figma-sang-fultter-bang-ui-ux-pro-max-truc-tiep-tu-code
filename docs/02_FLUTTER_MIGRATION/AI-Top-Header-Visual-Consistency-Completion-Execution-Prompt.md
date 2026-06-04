# AI Top Header Visual Consistency Completion Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
visual consistency work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md`

Goal: force the agent to follow the plan in exact order, without skipping any
phase, checklist, audit artifact, offline/data-freshness rule, route exception,
test, or emulator QA requirement. This is a completion prompt for making
VitTrade top headers meet **Dark professional / crypto exchange / trading
super-app** standards at the visual skeleton level.

This prompt is not a request to make a new plan. It is a request to execute the
existing plan end to end.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute every phase in this plan, in exact order, until the top-header visual
consistency work is complete or every remaining exception is documented and
guarded:

docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md

The final product must feel like one professional crypto exchange / trading
super-app:
- one visual top-chrome system
- one consistent root module rhythm
- one consistent detail header rhythm
- one consistent instrument/trading header rhythm
- no root title floating separately in content when it is page identity
- no arbitrary local header padding/font/height
- no hard-coded offline banner in normal online screens
- offline/cached data states handled safely
- all exceptions explicitly allowlisted and audited
- action/icon standardization preserved from the previous top-header plan

NON-NEGOTIABLE OUTCOME:
- Do not only analyze.
- Do not only create a prompt or plan.
- Do not stop after inspection.
- Execute the next open phase from the plan.
- Continue automatically to the next open phase unless the user explicitly says
  "one phase only" or "one packet only".
- Process phases in this exact order:
  1. Phase 0 - Lock visual baseline
  2. Phase 1 - Define `VitTopChrome`
  3. Phase 2 - Migrate Home to `rootBrand`
  4. Phase 3 - Migrate root module headers
  5. Phase 4 - Normalize instrument headers
  6. Phase 5 - Classify and fix `no_top_header` routes
  7. Phase 6 - Status banner and data freshness cleanup
  8. Phase 7 - Add strict visual guardrail
  9. Phase 8 - Emulator visual QA
- Do not start Phase 2 before Phase 0 and Phase 1 are complete and verified.
- Do not start a later phase while an earlier phase has missing artifacts,
  failing tests, or undocumented exceptions.
- If current scans differ from numbers in the plan, trust current scans, update
  audit artifacts, and explain the drift before migration.
- If all phases are complete, the final response must include:
  TOP HEADER VISUAL CONSISTENCY COMPLETE
- If forced to stop before all phases are complete, the final response must end
  with exactly:
  RESUME FROM: Phase <number> - <title>
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
9. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md
10. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md
11. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Behavior-Audit.md
12. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md
13. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.csv
14. docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv

If documents conflict, follow this order:
1. Current user instruction
2. AGENTS.md
3. The visual consistency completion plan
4. The dark professional standardization plan
5. Flutter source and tests

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Tests: `flutter_app/test/`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- Shared layout primitives: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Generated QA artifacts: `flutter_app/run-artifacts/`

IMPORTANT EXISTING PRIMITIVES:
- Existing top header:
  `flutter_app/lib/shared/layout/vit_header.dart`
- Existing action primitive:
  `flutter_app/lib/shared/layout/vit_header_action_button.dart`
- Existing auto-hide primitive:
  `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart`
- Existing offline banner:
  `flutter_app/lib/shared/widgets/vit_offline_banner.dart`

CURRENT BASELINE TO PRESERVE OR EXPLAIN:
- `vit_header_total` around 383
- `vit_header_with_custom_trailing` should remain 0
- `vit_header_with_legacy_action` should remain 0
- `banned_icon_usages` should remain 0
- `custom_button_usages` should remain 0
- `action_groups_over_limit` should remain 0
- routed screens around 414
- `fixed_vit_header_remaining` should remain 0
- `auto_hide_header` around 397
- `custom_scroll_header` around 4 before visual migration
- `no_top_header` around 13 before classification

If any number differs, re-run the audits, trust current source, update artifacts,
and explain the drift.

CORE DESIGN CONTRACT:
- Dark theme is the active baseline.
- Use theme tokens from `flutter_app/lib/app/theme/`.
- No random local colors for top header.
- No random local typography for top header.
- No arbitrary top-header `Padding.fromLTRB(20, x, 20, y)` once
  `VitTopChrome` covers that case.
- No top-header `fontSize: 30` in root module header unless explicitly
  allowlisted.
- No UI elements overlap at 360px width.
- No root module title should live directly in content when it is page identity.
- Do not weaken `VitHeaderActionButton`.
- Do not weaken action audit guardrails.
- Do not regress auto-hide behavior.
- Do not change route paths, product copy, repository contracts, provider
  contracts, or feature business logic unless the phase explicitly requires a
  guarded state change.

VISUAL ARCHETYPES TO IMPLEMENT AND ENFORCE:
Every routed screen must be classified as exactly one:

1. `detail`
   - Most routed detail/subpage screens.
   - Uses `VitAutoHideHeaderScaffold` + `VitTopChrome(type: detail)` or
     equivalent wrapper around `VitHeader`.
   - Detail header rhythm: 52px min height, 17px title, 12px subtitle, 40x40
     back/action buttons, max 3 right actions.

2. `rootBrand`
   - Home only.
   - Keeps brand title `VitTrade`.
   - Uses shared root top-chrome rhythm.
   - Actions use canonical search and notifications.

3. `rootModule`
   - Root modules such as Markets, Wallet, Profile, P2P, Launchpad, Rewards.
   - Title size around 26/27, not 30 without exception.
   - Shared safe area, top padding, bottom padding, surface, action placement.
   - Offline/status banner below header, in content flow.

4. `instrument`
   - Trade and Pair detail.
   - Allows pair selector, logo, price/change, favorite/share.
   - Same top chrome metrics, height, surface, padding, and semantics.
   - Pair selector must have `Semantics(button: true)`.

5. `fullscreenTool`
   - Chart fullscreen, terminal workspace, chat, futures, leverage, convert, bot
     workspace if genuinely fullscreen.
   - Must be allowlisted.
   - Must provide clear back/close/navigation replacement.

6. `authOnboarding`
   - Login/onboarding/welcome flows.
   - Must be allowlisted.
   - Must not become a precedent for financial/root module screens.

OFFLINE AND DATA FRESHNESS CONTRACT:
Do not treat "offline" as one state. Implement and audit these four states
where relevant:

1. `onlineLive`
   - Data is fresh/live.
   - No `VitOfflineBanner`.

2. `offlineWithCache`
   - Network is unavailable but cached/stale data is displayed.
   - Show `VitOfflineBanner` below header.
   - Copy must communicate "latest data" or last update timestamp.

3. `offlineNoCache`
   - Network unavailable and no reliable cache exists.
   - Do not render stale data as if live.
   - Use full error/empty state with retry.

4. `reconnecting`
   - App is retrying after prior data existed.
   - Use light info/reconnecting state if needed.

Offline rules:
- Never hard-code `VitOfflineBanner` in normal online screens.
- Never put `VitOfflineBanner` inside top header.
- Never use cached-data banner for `offlineNoCache`.
- Keep `VitOfflineBanner` as a shared safety component; do not delete it.
- For financial actions such as trade submit, withdrawal, transfer, P2P escrow,
  address change, or security change, offline must disable or guard the action.
- P2P home is a known issue: it currently places a hard-coded
  `VitOfflineBanner` in `header: Column`. Fix it by making the banner
  state-driven and moving it below the header.

GLOBAL WORK LOOP:
Repeat this loop for every phase.

1. From repo root, inspect working tree:

   ```powershell
   git status --short
   ```

2. Open the active plan:

   ```powershell
   Get-Content docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md
   ```

3. Determine the next phase:
   - Resume the first incomplete phase.
   - Do not skip checklists.
   - Before marking a phase complete, compare the phase checklist line by line
     against completed work.
   - Any skipped checklist item must have a documented exception and reason.

4. Before editing source, state:
   - Phase number and title.
   - Files to inspect.
   - Files likely to edit.
   - Tests to add/update.
   - Audits to run.
   - Expected risk and exception handling.

5. Re-scan current source before editing:

   ```powershell
   cd flutter_app
   dart run tool/top_header_behavior_audit.dart --check
   dart run tool/top_header_action_audit.dart --check --strict
   rg -n "VitHeader\\(|VitTopChrome\\(|VitAutoHideHeaderScaffold\\(|header:\\s*Column|VitOfflineBanner\\(" lib tool test
   rg -n "_HomeHeader|MarketListHeader|_PairHeader|_TradeHeader|fontSize:\\s*30|Padding\\.fromLTRB\\(20," lib/features lib/shared
   ```

6. Preserve behavior:
   - Preserve routes.
   - Preserve callbacks.
   - Preserve keys unless deliberately updating tests.
   - Preserve haptics.
   - Preserve loading, empty, error, offline, submitting, and success states.
   - Preserve Prediction Markets and Open Arena product boundaries.

7. Edit only the active phase scope.
   - Use shared primitives.
   - Use `apply_patch` or equivalent careful code edits.
   - Do not refactor unrelated content.
   - Do not revert unrelated user changes.

8. Add or update focused tests.
   - Shared primitive work requires shared layout tests.
   - Feature migration requires feature widget tests.
   - Audit tool work requires quality guardrail tests.
   - Offline/banner work must test online and offline/stale states.

9. Run phase verification.
   - Always run format/analyze for touched files.
   - Run focused tests.
   - Run audits relevant to the phase.
   - Run full tests when shared layout, audit guardrail, or many feature headers
     changed.

10. Update generated artifacts and docs.
    - Update visual audit artifacts if counts or route classifications changed.
    - Update action/behavior audit artifacts if affected.
    - Record exceptions.
    - Continue to next phase unless user requested a pause.

PHASE 0 - LOCK VISUAL BASELINE:
Objective: create an exact visual-archetype inventory before UI edits.

Required work:
- Run current behavior audit.
- Run current action audit.
- Add `flutter_app/tool/top_header_visual_archetype_audit.dart`.
- Generate:
  - `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
  - `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`
- Audit every route with:
  - route path
  - page class
  - page file
  - detected archetype
  - `VitHeader` usage
  - `VitTopChrome` usage
  - custom header class
  - no-header reason
  - status banner placement
  - status banner render condition
  - hard-coded vs state-driven offline banner
  - action count
  - exception reason
- Capture current known issues:
  - 4 custom scroll headers
  - 13 no-top-header routes
  - P2P stacked hard-coded offline banner
  - Wallet/Profile root title in content
  - Markets title size drift

Do not migrate UI in Phase 0.

Verification:

```powershell
cd flutter_app
dart format tool
dart run tool/top_header_behavior_audit.dart --check
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart
flutter analyze
```

PHASE 1 - DEFINE `VitTopChrome`:
Objective: create the shared visual skeleton primitive.

Required files:
- `flutter_app/lib/shared/layout/vit_top_chrome.dart`
- `flutter_app/lib/shared/layout/vit_header.dart`
- `flutter_app/test/shared/layout/vit_top_chrome_test.dart`
- `flutter_app/test/shared/layout/vit_header_test.dart`

Required implementation:
- Add `VitTopChromeType`.
- Add `VitTopChrome`.
- Implement `detail`.
- Implement `rootBrand`.
- Implement `rootModule`.
- Implement `instrument`.
- Keep `fullscreenTool` and `authOnboarding` as classification helpers if no
  shared render is needed.
- Reuse `VitHeader`, `VitHeaderActionButton`, and theme tokens.
- Lock height, padding, action gap, surface, title sizes, and semantics.
- Do not add local colors or arbitrary typography.
- Do not break existing `VitHeader` behavior.

Required tests:
- `detail` matches `VitHeader` baseline expectations.
- `rootBrand` renders brand title and actions at 360px without overflow.
- `rootModule` renders title/subtitle/actions with max 3 actions.
- `instrument` accepts selector/body/trailing and keeps stable height.
- Long title + 3 actions does not overflow at width 360.
- Semantics remain available.

Verification:

```powershell
cd flutter_app
dart format lib/shared/layout test/shared/layout
flutter test test/shared/layout/vit_top_chrome_test.dart --reporter=compact
flutter test test/shared/layout/vit_header_test.dart --reporter=compact
flutter analyze
```

PHASE 2 - MIGRATE HOME TO `rootBrand`:
Objective: keep Home as brand chrome while using shared root top-chrome rhythm.

Required file:
- `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`

Required work:
- Replace `_HomeHeader` visual body with `VitTopChrome(type: rootBrand)`.
- Preserve title `VitTrade`.
- Preserve search route `/search`.
- Preserve notifications route `/notifications`.
- Preserve notification badge.
- Preserve collapse/auto-hide behavior.
- Do not change Home content, portfolio card, discovery, market sections, or
  bottom nav behavior.

Required tests:
- Search tap navigates correctly.
- Notification tap navigates correctly.
- Badge renders.
- Header hide/show still works.
- 360px layout has no overlap.

Verification:

```powershell
cd flutter_app
dart format lib/features/home/presentation/pages test/features/home
flutter test test/features/home --reporter=compact
flutter analyze
dart run tool/top_header_visual_archetype_audit.dart --check
```

PHASE 3 - MIGRATE ROOT MODULE HEADERS:
Objective: make Markets, Wallet, Profile, P2P, Launchpad, and Rewards share one
root module top-chrome rhythm.

Execute in this order:
1. Markets
2. Wallet
3. Profile
4. P2P home
5. Launchpad
6. Rewards

Markets required files:
- `flutter_app/lib/features/markets/presentation/pages/market_list_page.dart`
- `flutter_app/lib/features/markets/presentation/widgets/market_list_header.dart`

Markets work:
- Replace `MarketListHeader` local row with `VitTopChrome(rootModule)`.
- Title `Thị trường` uses root title size, not `fontSize: 30`.
- Preserve overview, movers/analytics, sectors actions.
- Preserve routes and max 3 actions.

Wallet required file:
- `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart`

Wallet work:
- Move `Ví tài sản` page identity into `VitTopChrome(rootModule)`.
- Remove duplicated content top title spacing.
- Preserve wallet balance hero, tool grid, tabs, search/filter, bottom inset.
- Search/filter remains content control, not top-header action.

Profile required file:
- `flutter_app/lib/features/profile/presentation/pages/profile_page.dart`

Profile work:
- Move `Tài khoản` page identity into `VitTopChrome(rootModule)`.
- Content starts from profile hero.
- Preserve referral copy, edit profile, product hub, logout, bottom inset.
- Do not mix Prediction/Arena language.

P2P required file:
- `flutter_app/lib/features/p2p/presentation/pages/p2p_home_page_part_01.dart`

P2P work:
- Header must be only `VitTopChrome(rootModule)` or wrapped `VitHeader`.
- Remove `header: Column` containing hard-coded `VitOfflineBanner`.
- Add state-driven offline/data freshness handling:
  - `onlineLive`: no banner
  - `offlineWithCache`: banner below header
  - `offlineNoCache`: full error/empty state, no stale offer list as live data
  - `reconnecting`: light info/reconnecting state
- Preserve `P2PHomePage.offlineKey`.
- Preserve create and my-orders/history routes.
- Disable/guard financial actions if offline state disallows creating offers or
  orders.

Launchpad and Rewards work:
- Audit root route files first.
- Migrate true root module page identity to `VitTopChrome(rootModule)`.
- Keep detail/subpages as `detail`.
- Do not change financial copy or product boundaries.

Verification after each root module batch:

```powershell
cd flutter_app
dart format <touched files>
flutter test <focused tests> --reporter=compact
flutter analyze
dart run tool/top_header_visual_archetype_audit.dart --check
dart run tool/top_header_action_audit.dart --check --strict
```

PHASE 4 - NORMALIZE INSTRUMENT HEADERS:
Objective: normalize Trade and Pair detail without damaging trading usability.

Required files:
- `flutter_app/lib/features/trade/presentation/pages/trade_page_part_01.dart`
- `flutter_app/lib/features/markets/presentation/widgets/pair_detail_header_widgets.dart`
- `flutter_app/lib/features/markets/presentation/pages/pair_detail_page.dart`

Trade work:
- Wrap `_TradeHeader` with `VitTopChrome(type: instrument)`.
- Preserve pair selector and route `AppRoutePaths.tradePair(pair.id)`.
- Add or verify `Semantics(button: true)` for pair selector.
- Preserve logo, price, change percent, order form, quick nav, data tabs.
- Price/change must not overflow at 360px.

Pair detail work:
- Wrap `_PairHeader` with `VitTopChrome(type: instrument)`.
- Preserve canonical back, favorite on/off, share.
- Preserve selector semantics and center layout.
- Use shared surface/border/padding metrics.

Verification:

```powershell
cd flutter_app
dart format lib/features/trade lib/features/markets
flutter test test/features/trade test/features/markets --reporter=compact
flutter analyze
dart run tool/top_header_visual_archetype_audit.dart --check
```

PHASE 5 - CLASSIFY AND FIX `no_top_header` ROUTES:
Objective: no route remains unclassified.

Routes to review from current behavior audit:
- `LoginPage`
- `DCARebalanceDashboard`
- `DCAScheduleAnalytics`
- `EnterpriseStatesPage`
- `P2PChatPage`
- `ProfilePage`
- `FuturesPage`
- `LeveragePage`
- `AdvancedChartPage`
- `TradingBotsPage`
- `ConvertPage`
- `WalletPage`

Required work:
- For each route, decide:
  - migrate to `detail`
  - migrate to `rootModule`
  - classify as `fullscreenTool`
  - classify as `authOnboarding`
- Add top chrome where needed.
- Add allowlist reason where not adding top chrome.
- If fullscreen/no-header, verify there is clear back/close/navigation.
- Record every decision in visual audit artifacts.

Verification:

```powershell
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter analyze
```

PHASE 6 - STATUS BANNER AND DATA FRESHNESS CLEANUP:
Objective: banner/status never appears as a second top header, and offline
banner never appears in online state.

Required work:
- Scan all banner uses:

  ```powershell
  rg -n "header:\\s*Column|VitOfflineBanner\\(" flutter_app/lib
  ```

- For every `VitOfflineBanner`, document:
  - header or content placement
  - hard-coded or state-gated
  - online/offline-with-cache/offline-no-cache/reconnecting behavior
- Move banners out of header.
- Replace hard-coded banners with conditional render.
- Use full error/empty state for `offlineNoCache`.
- Keep timestamp/latest-data copy for `offlineWithCache`.
- Guard or disable financial actions when offline state disallows continuing.

Required tests:
- P2P online state has no offline banner.
- P2P offline-with-cache state has banner below header.
- P2P offline-no-cache state does not render stale offer list as live data.
- Topic Hub and Unified Search banner behavior remains correct.
- High-risk offline state still communicates read-only or blocked action.

Verification:

```powershell
cd flutter_app
dart format <touched files>
flutter test test/features/p2p test/features/discovery test/shared/widgets --reporter=compact
flutter analyze
dart run tool/top_header_visual_archetype_audit.dart --check
```

PHASE 7 - ADD STRICT VISUAL GUARDRAIL:
Objective: prevent future visual drift.

Required files:
- `flutter_app/tool/top_header_visual_archetype_audit.dart`
- `flutter_app/test/quality/top_header_visual_archetype_guardrail_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`

Guardrail must fail when:
- route has no archetype
- root module title is directly in content instead of `VitTopChrome`
- `header: Column` contains `VitOfflineBanner` without allowlist
- `VitOfflineBanner` appears in normal page without state gate
- offline banner appears in `onlineLive`
- `offlineNoCache` renders cached-data banner
- custom header class appears outside allowlist
- top header title uses unapproved `fontSize: 30`
- top header uses local `Padding.fromLTRB(20, ..., 20, ...)` outside primitive
- no-header route lacks exception reason
- instrument selector lacks `Semantics(button: true)`

Verification:

```powershell
cd flutter_app
dart format tool test/quality
dart run tool/top_header_visual_archetype_audit.dart --check
flutter test test/quality/top_header_visual_archetype_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_action_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter analyze
```

PHASE 8 - EMULATOR VISUAL QA:
Objective: verify actual UI, not only tests.

Required viewports:
- 360 x 800
- 390 x 844
- 440 x 956

Required routes:
- `/home`
- `/markets`
- `/trade`
- `/wallet`
- `/profile`
- `/p2p`
- `/launchpad`
- `/rewards`
- `/notifications`
- `/markets/BTCUSDT` or current pair detail equivalent
- `/trade/BTCUSDT` if current route supports pair param

Required screenshot checks:
- no status bar overlap
- no notch/camera clipping
- root title sizes look consistent
- Markets title no longer looks oversized against Wallet/Profile/Home
- P2P online screenshot has no offline banner
- P2P offline QA screenshot, if available, has banner below header
- instrument headers match app rhythm
- action buttons have consistent size/radius/color
- badges are not clipped
- no horizontal overflow
- auto-hide still works
- bottom nav unaffected

Artifacts:

```text
flutter_app/run-artifacts/top_header_visual_qa/
  360_home.png
  360_markets.png
  360_trade.png
  360_wallet.png
  360_profile.png
  360_p2p.png
  390_*.png
  440_*.png
  report.md
```

Emulator commands:

```powershell
cd flutter_app
flutter build apk --debug
adb devices
adb -s <serial> install -r build/app/outputs/flutter-apk/app-debug.apk
adb -s <serial> shell am start -n com.vittrade.vit_trade_flutter/.MainActivity
```

FINAL VERIFICATION BEFORE COMPLETE:
Run from `flutter_app/`:

```powershell
dart format --output=none --set-exit-if-changed .
dart run tool/top_header_behavior_audit.dart --check
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart --check
flutter analyze
flutter test test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart test/quality/top_header_visual_archetype_guardrail_test.dart --reporter=compact
flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_header_action_button_test.dart test/shared/layout/vit_top_chrome_test.dart --reporter=compact
flutter test --reporter=compact
```

FINAL RESPONSE FORMAT:
When all requested work for the current run is complete, report:
- phases completed
- files changed
- audit count changes
- tests and commands run with results
- emulator artifacts if captured
- exceptions left, if any
- next phase if work remains

If the full plan is complete, include:
TOP HEADER VISUAL CONSISTENCY COMPLETE

If work remains and you must stop, final line must be:
RESUME FROM: Phase <number> - <title>
````

