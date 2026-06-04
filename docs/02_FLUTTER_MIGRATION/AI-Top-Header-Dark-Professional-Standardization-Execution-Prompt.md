# AI Top Header Dark Professional Standardization Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
top-header standardization work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md`

Goal: force the agent to follow the plan in exact order, avoid skipping any
audit row or custom header, standardize top-header actions through shared
primitives, preserve existing product behavior, update audits and tests after
each packet, and keep VitTrade aligned with **Dark professional / crypto
exchange / trading super-app** standards.

This prompt is for top-header design-system standardization. It is not a
general redesign prompt, not a request to invent new product behavior, and not
a request to change routes, product copy, backend contracts, or feature
boundaries.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the top-header dark-professional standardization work from this active
plan, in exact order, until every packet is complete or has a documented
exception:

docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md

The objective is to make every top header feel like one professional crypto
exchange / trading super-app:
- one canonical top-header action catalog
- one shared top-header action button primitive
- consistent icon choices for the same function
- consistent size, radius, surface, border, badge, tooltip, and semantics
- no accidental local header button style drift
- no top-header action rows with more than 3 actions unless explicitly allowed
- status/offline banners kept separate from action buttons
- auto-hide top-header behavior preserved
- product boundaries preserved, especially Prediction Markets vs Open Arena

NON-NEGOTIABLE OUTCOME:
- Do not only create a plan.
- Do not stop after inspection.
- Execute the next open packet from the standardization plan.
- Continue automatically to the next open packet unless the user explicitly
  says "one packet only" or "one phase only".
- Process packets in this exact order:
  1. Packet 1 - Baseline action audit
  2. Packet 2 - Add `VitHeaderActionButton`
  3. Packet 3 - Add `VitHeader.actions` API
  4. Packet 4 - Migrate Home + Notifications
  5. Packet 5 - Migrate Markets + Pair detail
  6. Packet 6 - Migrate Launchpad + P2P home
  7. Packet 7 - Migrate Wallet/Profile high-traffic headers
  8. Packet 8 - Migrate remaining custom trailing
  9. Packet 9 - Strict guardrail enforcement
  10. Packet 10 - Emulator visual QA
- Do not start Packet 4 before Packets 1-3 are complete and verified.
- Do not start a later packet while an earlier packet is incomplete, stale, or
  failing verification.
- Resume any existing in-progress packet before starting a new packet.
- Mark a packet complete only after its acceptance criteria, audit, tests, and
  required verification pass.
- Mark a packet blocked only for a real blocker or a deliberate documented
  exception.
- Do not skip any current `VitHeader.trailing` custom usage.
- Do not skip Home, Markets, Trade, Pair detail, Launchpad, P2P, Wallet,
  Profile, Notifications, or Rewards visual checks.
- If current scans differ from numbers in the plan, trust the current scan,
  update the audit artifact, and explain the drift before code migration.
- If all work is complete, the final response must include:
  TOP HEADER STANDARDIZATION COMPLETE
- If forced to stop before all packets are complete, the final response must
  end with exactly:
  RESUME FROM: Packet <number> - <title>
  This must be the final line, with no text after it.

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/03_DESIGN_SYSTEM/Guidelines.md
6. docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md
7. docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md
8. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md
9. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Behavior-Audit.md
10. docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv

If documents conflict, follow the current user instruction first, then
AGENTS.md, then the top-header standardization plan, then current Flutter source
and tests.

SOURCE OF TRUTH:
- Flutter package: flutter_app/
- Runtime source: flutter_app/lib/
- Tests: flutter_app/test/
- Shared layout primitives: flutter_app/lib/shared/layout/
- Shared widgets: flutter_app/lib/shared/widgets/
- Theme tokens: flutter_app/lib/app/theme/
- Router facade: flutter_app/lib/app/router/app_router.dart
- Existing auto-hide primitive:
  flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart
- Existing top-header primitive:
  flutter_app/lib/shared/layout/vit_header.dart
- Existing icon button primitive:
  flutter_app/lib/shared/widgets/vit_icon_button.dart
- Existing offline banner:
  flutter_app/lib/shared/widgets/vit_offline_banner.dart

BASELINE TO PRESERVE OR EXPLAIN:
- Routed screens in top-header audit: about 414
- `VitHeader(...)` usages in `flutter_app/lib`: about 383
- Header `showBack: true` usages: about 375
- Header custom `trailing` usages: about 42
- Top-header icon/state variants: about 29
- Fixed top headers remaining: 0

If any number differs, do not force the old number. Re-scan and update the
audit notes.

CANONICAL ACTION CATALOG:
Use this canonical action catalog unless the plan is intentionally updated:

- `back` -> `Icons.chevron_left_rounded` -> `Quay lại`
- `close` -> `Icons.close_rounded` -> `Đóng`
- `search` -> `Icons.search_rounded` -> `Tìm kiếm`
- `notifications` -> `Icons.notifications_none_rounded` -> `Thông báo`
- `filter` -> `Icons.tune_rounded` -> `Bộ lọc`
- `settings` -> `Icons.settings_outlined` -> `Cài đặt`
- `export` -> `Icons.download_rounded` -> `Xuất dữ liệu`
- `share` -> `Icons.share_outlined` -> `Chia sẻ`
- `favoriteOn` -> `Icons.star_rounded` -> `Bỏ theo dõi`
- `favoriteOff` -> `Icons.star_border_rounded` -> `Theo dõi`
- `add` -> `Icons.add_rounded` -> `Tạo mới`
- `history` -> `Icons.history_rounded` -> `Lịch sử`
- `analytics` -> `Icons.bar_chart_rounded` -> `Phân tích`
- `portfolio` -> `Icons.business_center_outlined` -> `Portfolio`
- `overview` -> `Icons.monitor_heart_outlined` -> `Tổng quan`
- `sectors` -> `Icons.layers_rounded` -> `Ngành`
- `refresh` -> `Icons.refresh_rounded` -> `Làm mới`
- `help` -> `Icons.help_outline_rounded` -> `Hướng dẫn`
- `emergency` -> `Icons.error_outline_rounded` -> `Khẩn cấp`
- `more` -> `Icons.more_vert_rounded` -> `Thêm`

BANNED OR REPLACED TOP-HEADER ICONS:
Do not keep these icons in top-header actions unless they are explicitly
documented as an exception:

- Replace `Icons.ios_share_rounded` with `Icons.share_outlined`.
- Replace `Icons.file_download_outlined` with `Icons.download_rounded`.
- Replace `Icons.filter_alt_outlined` with `Icons.tune_rounded`.
- Replace `Icons.favorite_rounded` with `Icons.star_rounded`.
- Replace `Icons.favorite_border_rounded` with `Icons.star_border_rounded`.
- Replace `Icons.add` with `Icons.add_rounded`.
- Replace `Icons.person_add_alt_1_rounded` with `Icons.add_rounded` or move it
  out of top header into content if the domain-specific icon matters.
- Replace `Icons.chevron_right_rounded` in top header with `more` or a content
  CTA. Chevron-right is not a canonical top-header action.

VISUAL AND ACCESSIBILITY CONTRACT:
- Default header action target: 40x40.
- Header icon size: 18-20.
- Header action radius: 10.
- Header action gap: 6-8.
- Header right side: at most 3 actions. Use `more` for additional actions.
- Every action must have tooltip and semantics.
- Disabled/loading states must be visible and not tappable.
- Badge must not shift layout or be clipped.
- Use theme tokens only. Do not add `Color(0x...)` outside
  `flutter_app/lib/app/theme/`.
- Do not use `Colors.*` in runtime `lib`.
- Buy/sell colors are only for financial state, not normal navigation actions.
- Warning/danger tones are only for actual warning/high-risk actions.
- Offline/status banners remain `VitOfflineBanner` or `VitBanner`, placed below
  the header or in content flow, not inside header action rows.

PRODUCT BOUNDARIES:
- Prediction Markets and Open Arena must stay separate.
- Arena must remain points-only. Do not introduce wallet, payout, profit, PnL,
  or stake-return language into Arena/Rewards surfaces.
- Prediction Markets may use positions, probability, receipt, rewards, and P/L.
- Do not change product copy unless the header migration requires a tooltip or
  semantic label.
- Do not change route paths, route names, repository contracts, provider
  contracts, or backend/API drafts unless the active packet explicitly requires
  an audit-only update.

GLOBAL WORK LOOP:
Repeat this loop until all packets are complete or blocked with documented
exceptions.

1. From repo root, run:

   ```powershell
   git status --short
   ```

2. Read the active plan:

   ```powershell
   Get-Content docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md
   ```

3. Determine the next packet:
   - Resume the first in-progress packet if the plan or docs show one.
   - Otherwise start the first incomplete packet in numeric order.
   - If the plan lacks explicit status markers, create or update an execution
     log in the plan or a companion audit document before editing source.
   - Never start a later packet while earlier packet outputs are missing.

4. Before source edits, state the packet scope:
   - Packet number and title.
   - Target files.
   - Existing tests to run.
   - New tests or audit artifacts expected.
   - Risks and exceptions.

5. Re-scan relevant current state before editing:

   ```powershell
   rg -n "VitHeader\\(|trailing:|VitHeaderAction|IconButton\\(|VitIconButton\\(|InkWell\\(|GestureDetector\\(" flutter_app/lib/shared flutter_app/lib/features flutter_app/lib/app -g "*.dart"
   rg -n "_TradeHeader|MarketListHeader|_CollapsibleHomeHeader|_PairHeader|HeaderActions|HeaderButton" flutter_app/lib/features flutter_app/lib/shared -g "*.dart"
   ```

6. Preserve behavior:
   - Search references for every target callback, key, visible label, route, and
     widget type before editing.
   - Preserve test keys unless deliberately updating tests.
   - Preserve HapticFeedback calls where present.
   - Preserve GoRouter navigation targets.
   - Preserve all loading, empty, error, offline, submitting, and success
     states.

7. Edit only the active packet scope.
   - Use shared primitives.
   - Do not refactor unrelated widgets.
   - Do not normalize all formatting in unrelated files.
   - Do not revert unrelated user changes.

8. Add or update focused tests.
   - Shared primitive changes require shared layout/widget tests.
   - Feature migrations require feature widget tests for visible actions and
     navigation callbacks.
   - Audit-tool changes require quality guardrail tests.

9. Run verification for the packet.
   Minimum:

   ```powershell
   cd flutter_app
   dart format <touched dart files>
   flutter analyze
   ```

   Run focused tests for touched modules. If shared layout, header primitive,
   action primitive, audit guardrail, or many feature headers changed, run:

   ```powershell
   flutter test --reporter=compact
   ```

10. Update docs/audits:
    - Update action audit artifacts if counts change.
    - Update the plan or execution log with packet status, files changed,
      commands run, results, exceptions, and next packet.
    - Do not mark complete until verification is green or exception is
      documented.

11. Continue to the next packet unless the user explicitly requested only one
    packet.

PACKET 1 - BASELINE ACTION AUDIT:
Objective: freeze the current top-header action inventory before migration.

Required work:
- Create or update an audit tool, preferably:
  `flutter_app/tool/top_header_action_audit.dart`.
- Generate at least one human-readable artifact:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md`.
- CSV is recommended if row-level tracking is useful:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.csv`.
- Inventory all `VitHeader(...)` calls.
- Inventory all `trailing:` usages.
- Inventory `VitHeaderAction.*` usages.
- Inventory custom top headers:
  Home, Trade, Markets, Pair detail, Launchpad header actions.
- Inventory direct top-header icon usages and classify:
  canonical, banned, unknown, or exception.
- Inventory local button implementations in top-header scope:
  `IconButton`, `VitIconButton`, `InkWell`, `GestureDetector`, custom
  `_Header*Button`.
- Record file path, line number, action guess, icon, tooltip if discoverable,
  and whether migration is required.
- Add a guardrail test skeleton if feasible:
  `flutter_app/test/quality/top_header_action_guardrail_test.dart`.

Acceptance criteria:
- Audit reports current counts.
- Audit identifies every known custom trailing usage or documents why it cannot.
- No source UI migration is done in this packet except audit/test code.
- Guardrail is non-strict or allowlisted if migration has not started.

Verification:

```powershell
cd flutter_app
dart format tool test/quality
dart run tool/top_header_behavior_audit.dart
dart run tool/top_header_action_audit.dart
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_action_guardrail_test.dart --reporter=compact
flutter analyze
```

PACKET 2 - ADD `VitHeaderActionButton`:
Objective: create the canonical top-header action primitive.

Required files:
- Add `flutter_app/lib/shared/layout/vit_header_action_button.dart`.
- Add `flutter_app/test/shared/layout/vit_header_action_button_test.dart`.

Required behavior:
- Define `VitHeaderActionType`.
- Define `VitHeaderActionTone`.
- Define action catalog type -> icon, fallback tooltip, default tone.
- Render 40x40 default action button.
- Support active state.
- Support disabled state.
- Support loading state if needed.
- Support `badgeCount`.
- Tooltip is always present.
- Semantics label is always present.
- Use only `AppColors`, `AppSpacing`, `AppRadii`, and `AppTextStyles` tokens.
- Do not replace `VitIconButton`; this primitive is specifically for top
  header.

Required tests:
- Every key action type renders the expected icon.
- `badgeCount` renders and caps at `99+`.
- Disabled action does not call callback.
- Loading action does not call callback.
- Tooltip/semantics label exists.
- Default visual target is 40x40.
- Active tone does not resize the button.

Verification:

```powershell
cd flutter_app
dart format lib/shared/layout/vit_header_action_button.dart test/shared/layout/vit_header_action_button_test.dart
flutter test test/shared/layout/vit_header_action_button_test.dart --reporter=compact
flutter analyze
```

PACKET 3 - ADD `VitHeader.actions` API:
Objective: upgrade `VitHeader` while keeping old pages working.

Required files:
- Update `flutter_app/lib/shared/layout/vit_header.dart`.
- Add/update `flutter_app/test/shared/layout/vit_header_test.dart`.

Required API:
- Add `VitHeaderActionItem`.
- Add `actions: List<VitHeaderActionItem>`.
- Render action rows using `VitHeaderActionButton`.
- Keep legacy `trailing` support.
- If `trailing != null`, legacy trailing may still render during migration.
- Keep existing `action: VitHeaderAction.*` compatibility temporarily.
- Keep `showBack`, `title`, `subtitle`, `variant`, and `transparent` behavior.

Required tests:
- Title/subtitle render unchanged.
- Back button render/tap unchanged.
- `actions` render one, two, and three action buttons.
- `trailing` legacy still works.
- `actions.length > 3` is handled as specified by the plan.
- Header fits at width 360 with three actions.

Verification:

```powershell
cd flutter_app
dart format lib/shared/layout/vit_header.dart test/shared/layout/vit_header_test.dart
flutter test test/shared/layout/vit_header_action_button_test.dart --reporter=compact
flutter test test/shared/layout/vit_header_test.dart --reporter=compact
flutter analyze
```

PACKET 4 - MIGRATE HOME + NOTIFICATIONS:
Objective: standardize the most visible global chrome actions.

Required review:
- `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`
- `flutter_app/lib/features/notifications/presentation/pages/notifications_page.dart`
- Existing home and notifications tests.

Required migration:
- Replace Home search local action with canonical `search`.
- Replace Home notification local action with canonical `notifications`.
- Preserve badge count behavior.
- Preserve `/search` and `/notifications` navigation.
- Preserve `VitTrade` title layout.
- Ensure Notifications page action usage does not drift from catalog.

Required tests:
- Home search action navigates to search route.
- Home notifications action navigates to notifications route.
- Badge renders and is not clipped.
- Header still behaves with auto-hide if applicable.

Verification:

```powershell
cd flutter_app
dart format <touched files>
flutter test test/features/home/home_page_test.dart --reporter=compact
flutter test test/features/notifications/notifications_page_test.dart --reporter=compact
flutter analyze
```

PACKET 5 - MIGRATE MARKETS + PAIR DETAIL:
Objective: standardize market top chrome and pair-detail trading actions.

Required review:
- `flutter_app/lib/features/markets/presentation/widgets/market_list_header.dart`
- `flutter_app/lib/features/markets/presentation/widgets/pair_detail_header_widgets.dart`
- `flutter_app/lib/features/markets/presentation/pages/market_list_page.dart`
- `flutter_app/lib/features/markets/presentation/pages/pair_detail_page.dart`

Required migration:
- Market overview uses canonical `overview`.
- Market movers/performance uses canonical `analytics` or documented market
  variant if the catalog has one.
- Market sectors uses canonical `sectors`.
- Pair detail back uses canonical `back`.
- Pair selector remains domain-specific but gets button semantics.
- Favorite uses `favoriteOn/favoriteOff` with star icons.
- Share uses `share`.
- Remove or stop using local `_HeaderActionButton` if no longer needed.

Required tests:
- Market overview/movers/sectors routes still navigate correctly.
- Pair detail back route still works.
- Pair detail favorite toggles.
- Pair detail share action remains visible and semantic.
- Pair selector route remains correct.

Verification:

```powershell
cd flutter_app
dart format <touched files>
flutter test test/features/markets --reporter=compact
flutter analyze
```

PACKET 6 - MIGRATE LAUNCHPAD + P2P HOME:
Objective: standardize major module header actions.

Required review:
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_home_header_widgets.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_home_page_part_01.dart`
- Other P2P header files if they are directly tied to home flow.

Required migration:
- Launchpad filter uses canonical `filter`.
- Launchpad performance uses canonical `analytics`.
- Launchpad portfolio uses canonical `portfolio`.
- P2P create/add uses canonical `add`.
- P2P history uses canonical `history`.
- Preserve all keys used by tests or update tests intentionally.
- Preserve haptics and routes.

Required tests:
- Launchpad filter/performance/portfolio actions still work.
- P2P create/history actions still route correctly.
- Header has no more than 3 actions.

Verification:

```powershell
cd flutter_app
dart format <touched files>
flutter test test/features/launchpad/launchpad_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_home_page_test.dart --reporter=compact
flutter analyze
```

PACKET 7 - MIGRATE WALLET/PROFILE HIGH-TRAFFIC HEADERS:
Objective: standardize finance/security adjacent header actions.

Required review:
- Wallet address book/add/export/history header controls.
- Wallet transaction history export header.
- Profile/security/settings/API management header controls.

Required migration:
- Add address uses canonical `add`.
- Export/download uses canonical `export`.
- Settings uses canonical `settings`.
- History uses canonical `history`.
- Security/high-risk actions must use appropriate warning/danger tone only when
  the action itself is high risk.
- Preserve financial safety preview/confirm flows.

Required tests:
- Focused wallet/profile tests for touched pages.
- Ensure no financial route or high-risk copy changed unexpectedly.

Verification:

```powershell
cd flutter_app
dart format <touched files>
flutter test test/features/wallet --reporter=compact
flutter test test/features/profile --reporter=compact
flutter analyze
```

PACKET 8 - MIGRATE REMAINING CUSTOM TRAILING:
Objective: reduce custom `VitHeader.trailing` to zero or explicit exceptions.

Required work:
- Run the top-header action audit.
- For every remaining custom trailing:
  - identify file and line
  - identify action function
  - map to canonical type
  - migrate to `VitHeader.actions` or `VitHeaderActionButton`
  - preserve callbacks, keys, haptics, and routes
  - add/update tests
- For every exception:
  - document why it must remain custom
  - document why it is still visually compliant
  - add it to the guardrail allowlist

Known local classes to review:
- `_SettingsButton`
- `_HeaderSettingsButton`
- `_LoadingToggle`
- `_HeaderShareButton`
- `_AddButton`
- `_RefreshButton`
- `LaunchpadDcaHeaderCreateButton`
- `_HeaderCreateButton`
- `_MarketplaceButton`
- `_DownloadButton`
- `_HeaderChartButton`
- `_HeaderHistoryButton`
- `_FilterButton`
- `_CreateButton`
- `_HeaderAddButton`
- `_HeaderDownloadButton`
- `_HeaderExportButton`
- `_HeaderEmergencyButton`
- `_ExportHeaderButton`
- `_SettingsAction`
- `_DownloadAction`
- `_AddAddressButton`

Verification:

```powershell
cd flutter_app
dart run tool/top_header_action_audit.dart
dart format <touched files>
flutter test <focused tests> --reporter=compact
flutter analyze
```

PACKET 9 - STRICT GUARDRAIL ENFORCEMENT:
Objective: prevent regression after migration.

Required work:
- Make `top_header_action_audit.dart` strict.
- Make `top_header_action_guardrail_test.dart` fail on:
  - banned top-header icons
  - unexpected local header button implementations
  - top-header action rows with more than 3 actions
  - missing tooltip/semantics where statically detectable
  - missing audit artifact updates
- Keep explicit allowlist for real custom controls:
  - Home custom chrome if still custom
  - Trade pair selector
  - Pair detail selector
  - Any documented domain-specific header control

Verification:

```powershell
cd flutter_app
dart run tool/top_header_action_audit.dart --check
flutter test test/quality/top_header_action_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter analyze
```

PACKET 10 - EMULATOR VISUAL QA:
Objective: prove the final UI works on a real emulator.

Required emulator routes/screens:
- `/home`
- `/markets`
- `/trade`
- `/wallet`
- `/profile`
- `/rewards`
- `/launchpad`
- `/p2p`
- `/notifications`
- pair detail route such as BTC/USDT if available from current router/data

Required viewport/device review:
- 360px width or nearest emulator equivalent
- 390px width or nearest emulator equivalent
- 440px width or current visual QA frame

Required checks:
- Header does not overlap status bar.
- Title does not collide with actions.
- Badge is visible and not clipped.
- Right action row has at most 3 actions.
- Header auto-hide still works.
- Offline banner appears below header/content flow.
- Bottom nav is unaffected.
- Dark surface hierarchy remains professional.
- No module shows random icon style drift.

Commands:

```powershell
cd flutter_app
flutter build apk --debug
adb devices
adb -s <serial> install -r build\app\outputs\flutter-apk\app-debug.apk
adb -s <serial> shell am start -n com.vittrade.vit_trade_flutter/.MainActivity
```

Capture screenshots into:

```text
flutter_app/run-artifacts/top-header-standardization/
```

Final verification before marking complete:

```powershell
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/top_header_behavior_audit.dart
dart run tool/top_header_action_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

FINAL RESPONSE FORMAT:
When all requested work for the current run is complete, report:
- packet(s) completed
- files changed
- audit count changes
- tests/commands run and results
- exceptions left, if any
- next packet if work remains

If the full plan is complete, include:
TOP HEADER STANDARDIZATION COMPLETE

If work remains and you must stop, final line must be:
RESUME FROM: Packet <number> - <title>
````

