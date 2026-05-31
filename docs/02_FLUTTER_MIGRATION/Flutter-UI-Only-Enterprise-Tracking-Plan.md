# Flutter UI-Only Enterprise Tracking Plan

Generated: 2026-05-30
Scope: theo doi va tiep tuc hardening VitTrade Flutter UI trong `flutter_app/`
khi backend that chua nam trong pham vi hien tai.

## 1. Dinh nghia dung cho giai doan nay

Trong giai doan nay, "enterprise-grade" duoc hieu la **enterprise-grade UI
frontend**, khong phai production enterprise-grade day du. Nghia la repo can
co UI structure, design system, routing, state presentation, mock/fail-closed
behavior, tests, QA evidence, accessibility va financial safety copy tot.

Khong tinh vao scope UI-only:

- Backend API that.
- Remote repositories production that.
- Staging/production credentials.
- Android/iOS store signing secrets.
- Hosted CI/store release artifact validation.
- Bat ky claim nao rang app da production-ready khi backend/release ops chua co.

Van duoc lam trong UI-only:

- Mock-data UI, fail-closed UI, empty/error/offline/submitting/success states.
- Controller/view-state cho presentation.
- Preview/confirm UI cho high-risk actions.
- Widget/integration tests bang mock/fake repositories.
- Manual/emulator smoke evidence.
- Accessibility/semantics, responsive layout, design-token cleanup.
- Route coverage va navigation polish.

## 2. Trang thai hien tai

| Hang muc | Trang thai hien tai | Danh gia UI-only |
| --- | --- | --- |
| Sequential backlog | Historical `33/35` packets `[x]`, `2/35` packets `[!]`; UI-only extension `10/10` packets `[x]` | Historical queue da xu ly het; UI-01 den UI-10 da dong cho UI-only scope. |
| Todo/In progress packets | `0` open or in-progress UI-only packets | UI-only extension closed. |
| Full local checks | S8-02 pass format/analyze/full test/route audit; UI-10 final format/analyze/focused tests/route audit pass | Tot. |
| Full test suite | `1841` tests pass | Tot cho UI/mock scope. |
| Route coverage | `417` entries, `414` real pages, `3` aliases | Tot, khong con placeholder route. |
| Page/widget data imports | `0` | Dat UI architecture boundary. |
| Controller mock/remote imports | `0` | Dat controller safety boundary. |
| Runtime `Colors.*` | `0` | Dat design-token guardrail. |
| Hardcoded color outside theme | `0` | Dat design-token guardrail. |
| Feature files > 600 lines | `239` | Con UI maintainability debt. |
| Feature files > 1200 lines | `0` | Dat UI-02; tiep tuc giu guardrail. |
| Page part-files | `217` | UI-03 first Trade batch reduced this from `218`; can giam tiep. |
| Manual high-risk smoke | UI-only text-entry harness pass | Address Add va P2P Payment Add da co Flutter `enterText` harness evidence; khong claim manual/emulator screenshot moi. |

Ket luan: UI frontend dang o muc **UI-only enterprise-grade va locally
verified** cho mock/fail-closed scope. Khong claim production enterprise-grade
cho den khi backend/release ops ben ngoai duoc dong.

## 3. Phan da dong va no can theo doi trong UI-only

### 3.1 Address Add manual/emulator confirmation

Status: `[x]`

Da dat:

- Address Add page co controller, validation, preview/confirm sheet va tests.
- Widget test `address_add_page_test.dart` cover validation, preview va confirm.
- Emulator da render duoc `SC-143` initial screen voi risk/agreement copy.
- UI-01 added `high_risk_text_entry_harness_test.dart`; Flutter `enterText`
  populates label/address, opens the preview sheet, taps confirm, and reaches
  `AddressSavedState`.

Khong claim trong UI-01:

- Khong co emulator/manual screenshot moi cho full preview/confirm path. Day la
  UI harness evidence, khong phai manual device evidence.

Resolution note:

- `adb shell input text` va keyevent khong day text vao Flutter text fields.
- UI-only blocker duoc dong bang Flutter `enterText` harness dang tin cay.

Manual release retake owner:

- QA manual operator, hoac Android emulator automation owner.

Manual release evidence condition:

- Neu can release/device evidence, chay manual interactive smoke tren
  emulator/device va chup screenshot/UI dump/logcat.

### 3.2 P2P Payment Add manual/emulator confirmation

Status: `[x]`

Da dat:

- P2P Payment Add page co option selection, account/owner fields, preview card,
  confirm dialog va tests.
- Widget test `p2p_payment_method_add_page_test.dart` cover validate, preview,
  confirm va navigation.
- Emulator da render duoc `SC-232`, chon duoc `Vietcombank`, account field co
  luc nhan duoc text.
- UI-01 added `high_risk_text_entry_harness_test.dart`; Flutter `enterText`
  populates account/owner fields, renders preview, opens confirm dialog, taps
  confirm, and leaves the add form.

Khong claim trong UI-01:

- Khong co emulator/manual screenshot moi cho confirm dialog. Day la UI harness
  evidence, khong phai manual device evidence.

Resolution note:

- Flutter text input qua IME bridge khong on dinh voi `adb shell input text`.
- Owner field co capitalization/text input behavior khac account field.
- UI-only blocker duoc dong bang Flutter `enterText` harness dang tin cay.

Manual release retake owner:

- QA manual operator, hoac Android emulator automation owner.

Manual release evidence condition:

- Neu can release/device evidence, chay manual interactive smoke va attach
  screenshot/UI dump/logcat.

## 4. Roadmap UI-only can lam tiep

### UI-01 - Dong QA text-entry blocker

Status: `[x]`

Goal:

- Bien 2 blocker manual smoke con lai thanh evidence that.

Scope:

- `docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md`
- `flutter_app/run-artifacts/`
- Neu chon integration-test harness: them test trong `flutter_app/integration_test/`
  hoac widget test focused neu repo da co pattern phu hop.

Implementation options:

1. Manual QA:
   - Build debug APK.
   - Install emulator/device.
   - Mo Address Add, nhap label/address, tick agreement, mo confirm sheet.
   - Mo P2P Payment Add, chon bank, nhap account/owner, mo confirm dialog.
   - Chup screenshot/UI dump/logcat.
   - Update checklist va backlog blocker.

2. Flutter QA harness:
   - Tao integration/widget test dung Flutter `enterText`, khong dung ADB text.
   - Cover exactly Address Add va P2P Payment Add confirmation.
   - Neu la debug-only hook, dam bao khong vao production runtime.

Tests:

```bash
flutter test test/features/wallet/address_add_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_payment_method_add_page_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:

- Co evidence cho Address Add confirm.
- Co evidence cho P2P Payment Add confirm.
- Checklist khong con noi 2 flow nay blocked vi text-entry.

Verification log:

- 2026-05-30: Added `flutter_app/test/quality/high_risk_text_entry_harness_test.dart`
  to cover Address Add `SC-143` and P2P Payment Add `SC-232` with Flutter
  `enterText`, preview, confirm, and post-confirm state/navigation evidence.
- 2026-05-30: Added stable key
  `AddressConfirmPreviewSheet.confirmButtonKey` and fixed Address Add saved
  state whitelist summary overflow found by the new harness at the 440x956 QA
  viewport.
- 2026-05-30: `dart format .` passed from `flutter_app/` (`1513` files,
  `0 changed` on final run).
- 2026-05-30: `flutter test test/quality/high_risk_text_entry_harness_test.dart test/features/wallet/address_add_page_test.dart test/features/p2p/p2p_payment_method_add_page_test.dart test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`23` tests).
- 2026-05-30: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- Evidence type: Flutter widget harness evidence only. No new manual/emulator
  screenshots or production/backend claims were made.

### UI-02 - Dua feature files >1200 ve 0

Status: `[x]`

Goal:

- Giam `Feature files > 1200 lines` tu `4` ve `0`.

Targets hien tai:

| File | Lines gan nhat | Huong xu ly |
| --- | ---: | --- |
| `lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` | `1249` | Tach widgets portfolio sections, filters, cards sang `presentation/widgets/`; derived state sang controller neu can. |
| `lib/features/predictions/presentation/pages/prediction_social_page.dart` | `1225` | Tach feed composer, post card, trending panels, moderation/report widgets. |
| `lib/features/trade/presentation/pages/trader_profile_page.dart` | `1225` | Tach performance summary, risk panels, copy/action sections; giu copy-risk boundary. |
| `lib/features/profile/presentation/pages/vip_page.dart` | `1224` | Tach VIP tier cards, benefit matrix, risk/disclaimer sections. |

Rules:

- Giu public page facade neu router/test dang import.
- Khong tao `presentation/pages/*_part_*.dart` moi.
- Widget reusable cho cung feature dat trong `presentation/widgets/`.
- Khong them `Colors.*`; mau moi phai vao theme token.

Tests:

```bash
dart format .
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:

- `>1200` = `0`.
- `>600` khong tang.
- Focused page tests pass.

Verification log:

- 2026-05-30: Extracted `PredictionsPortfolioArenaBridgeCard` to
  `lib/features/predictions/presentation/widgets/predictions_portfolio_bridge_card.dart`;
  `predictions_portfolio_page.dart` is now `1159` lines.
- 2026-05-30: Extracted social share/metric/sentiment painter widgets to
  `lib/features/predictions/presentation/widgets/prediction_social_support_widgets.dart`;
  `prediction_social_page.dart` is now `1091` lines.
- 2026-05-30: Extracted trader profile chart painters to
  `lib/features/trade/presentation/widgets/trader_profile_chart_painters.dart`;
  `trader_profile_page.dart` is now `1131` lines.
- 2026-05-30: Extracted VIP history widgets to
  `lib/features/profile/presentation/widgets/vip_history_widgets.dart`;
  `vip_page.dart` is now `1120` lines.
- 2026-05-30: Metrics after split: feature Dart files `>1200 = 0`,
  feature Dart files `>600 = 239`, page part-files `218`.
- 2026-05-30: `dart format .` passed from `flutter_app/` (`1517` files,
  `3 changed` on final run).
- 2026-05-30: `flutter test test/features/predictions/predictions_portfolio_page_test.dart test/features/predictions/prediction_social_page_test.dart test/features/trade/trader_profile_page_test.dart test/features/profile/vip_page_test.dart test/quality/product_copy_guardrails_test.dart test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`40` tests).
- 2026-05-30: `flutter analyze` passed with no issues.

### UI-03 - Giam page part-file debt

Status: `[x]`

Goal:

- Giam dan `presentation/pages/*_part_*.dart` tu `218` xuong moc moi.

Approach:

- Khong sua tat ca cung luc.
- Moi batch chon 1 feature co nhieu part files.
- Chuyen widget/cohort UI sang `presentation/widgets/`.
- Neu file chua logic derived state, chuyen sang `presentation/controllers/`.

Suggested batches:

| Batch | Feature | Expected work |
| --- | --- | --- |
| UI-03A | Trade | Chuyen chart/order/bot section part-files sang widgets. |
| UI-03B | P2P | Chuyen order/dashboard/merchant/insurance sections sang widgets. |
| UI-03C | Earn | Chuyen savings/staking part sections sang widgets. |
| UI-03D | Predictions | Chuyen event detail/chart/social sections sang widgets. |

Acceptance:

- Page part-files giam sau moi batch.
- Guardrail pass.
- Khong doi public routes.

Verification log:

- 2026-05-30: Converted Trade `convert_page_part_03.dart` into
  `lib/features/trade/presentation/widgets/convert_page_widgets.dart` and
  removed the page part directive from `convert_page.dart`.
- 2026-05-30: Kept the public `ConvertPage` facade and test keys stable by
  passing `ConvertPage.assetOptionKey` into `ConvertAssetSheet`.
- 2026-05-30: Fixed two Convert responsive overflows exposed by focused tests:
  mode-tab labels now flex/ellipsis, and the slippage header title flexes
  before the trailing control label.
- 2026-05-30: Metrics after batch: page part-files `218 -> 217`, Trade page
  part-files `34 -> 33`, feature Dart files `>1200 = 0`, feature Dart files
  `>600 = 239`.
- 2026-05-30: `dart format .` passed from `flutter_app/` (`1517` files,
  `0 changed` on final run).
- 2026-05-30: `flutter test test/features/trade/convert_page_test.dart test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`17` tests).
- 2026-05-30: `flutter analyze` passed with no issues.

### UI-04 - High-risk UI state depth

Status: `[x]`

Goal:

- Lam controller/view-state sau hon cho cac flow tai chinh/rui ro cao, trong
  UI-only scope.

Target flows:

| Module | Flow | UI state can co |
| --- | --- | --- |
| Wallet | Withdraw | draft, validation error, preview, confirming, submitted, failed, offline. |
| Wallet | Address Add | draft, network/address validation, agreement gate, preview, saved, failed. |
| Wallet | Token Approval | allowance review, revoke preview, confirm, revoked, failed. |
| P2P | Payment Add | method select, owner validation, preview, confirm, saved, failed. |
| P2P | Order/Escrow | payment proof, release confirm, dispute CTA, blocked states. |
| Trade | Order/Copy/Margin | suitability gate, risk preview, fee/limit copy, confirm, receipt. |
| Predictions | Order/Risk/Receipt | probability, max loss, fee, shares, receipt, portfolio impact. |
| Arena | Join/Governance/Report | points-only state, fair-play copy, report/appeal progress. |

Rules:

- UI-only: no real side effect.
- Mock/fail-closed behavior phai ro rang.
- High-risk copy phai co preview/confirm, fee/risk/limit/next-step.
- Arena van points-only.

Tests:

```bash
flutter test test/features/wallet/wallet_controller_test.dart test/features/p2p/p2p_controller_test.dart test/features/trade/trade_controller_test.dart test/features/predictions/predictions_controller_test.dart test/features/arena/arena_controller_test.dart --reporter=compact
flutter test test/features/arena/arena_join_page_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:

- Moi flow co focused controller/widget tests.
- Khong co page/widget data imports.

Verification log:

- 2026-05-30: Expanded Wallet, P2P, Trade, Predictions, and Arena high-risk
  UI status models to cover draft/validation/preview/confirming/submitted,
  success, error, and offline states, with busy/failure/preview helpers.
- 2026-05-30: Added status-aware validation/review helpers for Wallet
  Withdraw, Address Add, Token Approval; P2P Payment Add, Order payment,
  Dispute Evidence, Express Confirm; Trade order/copy/leverage/margin/futures/
  risk/bot intents; Prediction order/risk/receipt/portfolio actions; and Arena
  Join/Governance/Report points-only flows.
- 2026-05-30: Wired Arena Join through `arenaJoinControllerProvider` while
  preserving current route behavior and points-only copy.
- 2026-05-30: Added `p2p_flow_status.dart` so the P2P controller stayed under
  the large-file guardrail; feature files `>1200 = 0`, feature files
  `>600 = 239`, page part-files remain `217`.
- 2026-05-30: `dart format .` passed from `flutter_app/` (`1518` files,
  `0 changed` on final run).
- 2026-05-30: `flutter test test/features/wallet/wallet_controller_test.dart test/features/p2p/p2p_controller_test.dart test/features/trade/trade_controller_test.dart test/features/predictions/predictions_controller_test.dart test/features/arena/arena_controller_test.dart test/features/arena/arena_join_page_test.dart test/quality/product_copy_guardrails_test.dart test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`51` tests).
- 2026-05-30: `flutter analyze` passed with no issues.

### UI-05 - Responsive visual QA matrix

Status: `[x]`

Goal:

- Dam bao UI scan tot tren cac width can thiet cho app phone-first.

Viewports:

| Target | Width | Height |
| --- | ---: | ---: |
| Minimum phone | 360 | 800 |
| QA phone | 440 | 956 |
| Large phone | 480 | 1040 |

Priority routes:

- Home, Markets, Pair Detail, Trade, Wallet, Deposit, Profile.
- Prediction home/event/risk/receipt/portfolio.
- Arena home/challenge/join.
- Address Add, Withdraw, Token Approval.
- P2P Payment Add, P2P Order, P2P Dispute.
- Admin Home, Analytics Dashboard, Funnel Dashboard, A/B Test Dashboard.

Acceptance:

- No clipped primary CTA.
- No unreadable overflow.
- Headers, cards, controls keep stable layout.
- Evidence saved in checklist/report.

Verification log:

- 2026-05-31: Added `test/quality/responsive_visual_qa_matrix_test.dart`
  covering 25 priority routes at `360x800`, `440x956`, and `480x1040` through
  the real app router and `VitTradeApp` shell.
- 2026-05-31: Fixed responsive overflow found by the matrix in shared bottom
  nav/service/status-pill primitives plus Home, Markets, Wallet, Profile,
  Predictions, and Arena UI surfaces. Fixes constrained long labels, badges,
  pills, KPI rows, and high-risk action controls without changing route/data
  behavior.
- 2026-05-31: `dart format .` passed from `flutter_app/` (`1519` files,
  `0 changed` on final run).
- 2026-05-31: `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`
  passed (`3` viewport matrix tests).
- 2026-05-31: `flutter test test/features/home/home_page_test.dart test/features/markets/market_list_page_test.dart test/features/wallet/wallet_page_test.dart test/features/wallet/deposit_page_test.dart test/features/wallet/withdraw_page_test.dart test/features/wallet/wallet_token_approval_page_test.dart test/features/profile/profile_page_test.dart test/features/predictions/prediction_event_detail_page_test.dart test/features/predictions/prediction_order_receipt_page_test.dart test/features/predictions/predictions_portfolio_page_test.dart test/features/arena/arena_challenge_detail_page_test.dart test/quality/responsive_visual_qa_matrix_test.dart test/quality/product_copy_guardrails_test.dart test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`78` tests).
- 2026-05-31: `flutter analyze` passed with no issues.
- Evidence type: Flutter widget harness evidence only. No new manual/emulator
  screenshots, UI dumps, or production/backend claims were made.

### UI-06 - Admin dashboard UI hardening

Status: `[x]`

Goal:

- Lam admin dashboards dung chat operational enterprise UI: dense, scanable,
  khong marketing-style, co loading/empty/error/offline states.

Scope:

- `flutter_app/lib/features/admin/presentation/pages/admin_home.dart`
- `flutter_app/lib/features/admin/presentation/pages/analytics_dashboard.dart`
- `flutter_app/lib/features/admin/presentation/pages/funnel_dashboard.dart`
- `flutter_app/lib/features/admin/presentation/pages/ab_test_dashboard.dart`
- `flutter_app/lib/features/admin/presentation/controllers/admin_controller.dart`

Checklist:

- Dashboard metric cards co label, value, delta, timeframe.
- Tables/lists co empty state va loading skeleton.
- Charts co text fallback/semantic summary.
- Filter controls co selected state ro.
- Error/offline state khong blank.
- No hardcoded colors outside theme.
- No direct data imports from page/widget.

Tests:

```bash
flutter test test/features/admin --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:

- Admin focused tests pass.
- No layout overflow at 360/440/480 widths.

Verification log:

- 2026-05-31: Added `AdminDashboardLoadStatus` and state-aware view-state
  fields for Admin Home, Analytics, A/B Tests, and Funnel controllers.
- 2026-05-31: Added `admin_dashboard_state_content.dart` to render loading
  skeleton, empty state, error state, and offline cached-data banner through
  shared UI primitives instead of blank admin surfaces.
- 2026-05-31: Hardened Admin KPI cards with label/value/delta/timeframe,
  selected semantics for filters/selectable cards, chart semantic summaries,
  and empty fallbacks for event volume, event distribution, top events, recent
  events, and funnel dropout data.
- 2026-05-31: Split `AdminSettingsPage` to `admin_settings_page.dart`; Admin
  Home is now `504` lines, Analytics `596`, A/B Tests `583`, and the
  architecture large-file guardrail stays at or below baseline.
- 2026-05-31: `dart format .` passed from `flutter_app/` (`1522` files,
  `0 changed` on final run).
- 2026-05-31: `flutter test test/features/admin test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`31` tests).
- 2026-05-31: `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact --dart-define=RESPONSIVE_QA_ROUTE=admin`
  passed (`3` admin responsive viewport tests).
- 2026-05-31: `flutter analyze` passed with no issues.
- Evidence type: Flutter widget harness evidence only. No new manual/emulator
  screenshots, UI dumps, or backend/production claims were made.

### UI-07 - Accessibility and semantics pass

Status: `[x]`

Goal:

- Tang kha nang test/QA va support screen reader cho UI critical flows.

Scope priority:

- High-risk buttons: confirm, cancel, submit, revoke, withdraw, save address.
- Form fields: label, helper, error text.
- Tab/segmented controls.
- Dashboard charts/kpi cards.

Acceptance:

- Critical controls co semantic label/role ro.
- Error text gan voi field context.
- UIAutomator dump/doc evidence de doc flow de hon.

Verification log:

- 2026-05-31: Added `test/quality/accessibility_semantics_critical_flows_test.dart`
  covering high-risk controls and form semantics for Withdraw `SC-139`,
  Address Add `SC-143`, P2P Payment Add `SC-232`, Token Approval Revoke
  `SC-150`, Prediction Risk Calculator `SC-036`, and Admin KPI/chart surfaces.
- 2026-05-31: Added explicit `Semantics` labels/roles for custom
  GestureDetector/InkWell controls, text fields, selectors, toggles, icon-only
  actions, revoke/confirm/cancel buttons, prediction tabs/scenarios, and admin
  KPI/chart summaries. `VitInput` now carries optional explicit semantic labels
  plus hint/error context.
- 2026-05-31: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/features/wallet test/features/p2p test/features/predictions test/features/admin test/quality/product_copy_guardrails_test.dart test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`506` tests).
- 2026-05-31: `dart format .` passed (`1523` files, `0` changed).
- 2026-05-31: `flutter analyze` passed with no issues.
- Evidence type: Flutter widget harness evidence only. No new manual/emulator
  screenshots, UI dumps, backend APIs, or production claims were made.

### UI-08 - Copy and language consistency pass

Status: `[x]`

Goal:

- UI copy thong nhat giua tieng Viet/tieng Anh, khong dung hype/casino language,
  khong goi project production-ready khi chua co backend/release.

Rules:

- Arena: points-only. Cam wallet, payout, profit, stake-return language trong
  Arena user-facing copy.
- Predictions: duoc dung positions, probability, receipt, rewards, P/L; tranh
  hype/casino.
- Financial flows: preview/confirm, fee/risk/limit/next-step.
- Backend chua co: dung mock/fail-closed/local preview wording ro neu can.

Tests:

```bash
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:

- Guardrail pass.
- High-risk copy khong mau thuan voi UI-only scope.

Verification log:

- 2026-05-31: Scanned Arena, Prediction, Wallet, P2P, and UI-only readiness
  copy for prohibited financial/casino/production-ready terms. Arena page scan
  stayed points-only; only the legacy `/arena/production-ready` route string
  remains as a route identifier, not user-facing readiness copy.
- 2026-05-31: Replaced Prediction Risk Calculator `Payout` copy/model wording
  with `Settlement value` and `P/L` so Prediction Markets copy avoids
  casino-style payout language while preserving financial safety context.
- 2026-05-31: Extended `test/quality/product_copy_guardrails_test.dart` to
  prevent `payout` from returning to the Prediction Risk Calculator.
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/features/predictions/prediction_risk_calculator_page_test.dart test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`11` tests).
- 2026-05-31: `dart format lib/features/predictions/presentation/pages/prediction_risk_calculator_page.dart test/quality/product_copy_guardrails_test.dart`
  passed (`2` files, `0` changed).
- Evidence type: Flutter widget/static guardrail evidence only. No backend or
  production-readiness claims were made.

### UI-09 - Route and navigation UX polish

Status: `[x]`

Goal:

- Giu route coverage current va lam navigation/back behavior on dinh hon.

Scope:

- Router facade van giu `createAppRouter`, `appRouter`, `AppRoutePaths`,
  `AppRouteNames`.
- Khong tao route placeholder moi.
- Kiem tra back navigation o critical flows.

Tests:

```bash
flutter test test/app/router --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Acceptance:

- Route audit pass.
- Critical flow back navigation khong roi khoi shell sai cach.

Verification log:

- 2026-05-31: Added `test/app/router/critical_navigation_back_behavior_test.dart`
  to guard header back behavior for Withdraw `SC-139`, Address Add `SC-143`,
  Token Approval `SC-150`, P2P Payment Add `SC-232`, Prediction Risk Calculator
  `SC-036`, and Admin dashboards `SC-181` to `SC-183`.
- 2026-05-31: `flutter test test/app/router test/quality/route_coverage_guardrails_test.dart --reporter=compact`
  passed (`12` tests).
- 2026-05-31: `dart run tool/route_coverage_audit.dart --check` passed
  (`Route coverage artifact is current.`).
- 2026-05-31: `dart format test/app/router/critical_navigation_back_behavior_test.dart`
  passed (`1` file, `0` changed).

### UI-10 - Final UI-only readiness report

Status: `[x]`

Goal:

- Tao report rieng cho UI-only readiness, khong lap lai backend production
  readiness.

Scope:

- `docs/02_FLUTTER_MIGRATION/Flutter-Evidence-QA-Report.md`
- File plan nay.

Acceptance:

- Bao cao co 3 nhom ro:
  - UI done.
  - UI remaining.
  - Out-of-scope backend/release blockers.

Verification log:

- 2026-05-31: Updated `Flutter-Evidence-QA-Report.md` with final UI-only
  closeout groups: UI done, UI remaining, and out-of-scope backend/release
  blockers.
- 2026-05-31: `dart format .` passed from `flutter_app/` (`1524` files,
  `0` changed).
- 2026-05-31: `flutter analyze` passed from `flutter_app/`
  (`No issues found!`).
- 2026-05-31: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart test/quality/product_copy_guardrails_test.dart test/app/router test/quality/route_coverage_guardrails_test.dart test/quality/architecture_baseline_guardrails_test.dart test/features/predictions/prediction_risk_calculator_page_test.dart --reporter=compact`
  passed (`46` tests).
- 2026-05-31: `dart run tool/route_coverage_audit.dart --check` passed
  (`Route coverage artifact is current.`).

## 5. Tracking board de cap nhat

| ID | Work item | Status | Owner | Evidence/command | Next exact step |
| --- | --- | --- | --- | --- | --- |
| UI-01 | Dong Address Add/P2P text-entry smoke blockers | `[x]` | QA/manual or Flutter automation | `high_risk_text_entry_harness_test.dart` + checklist/report | Start UI-02 at `predictions_portfolio_page.dart`. |
| UI-02 | Dua 4 files >1200 ve 0 | `[x]` | Frontend | Format, focused page tests, architecture/copy guardrails, analyze | Start UI-03 with Trade page part-file debt. |
| UI-03 | Giam page part-file debt | `[x]` | Frontend | Convert tests, architecture guardrail, analyze | Start UI-04 with Wallet/P2P high-risk state depth. |
| UI-04 | High-risk UI state depth | `[x]` | Frontend/Product | Focused controller/page tests + copy/architecture guardrails + analyze | Start UI-05 responsive visual QA matrix. |
| UI-05 | Responsive visual QA matrix | `[x]` | QA/Frontend | `responsive_visual_qa_matrix_test.dart` + focused tests + checklist/report | Start UI-06 with admin dashboard UI hardening. |
| UI-06 | Admin dashboard UI hardening | `[x]` | Frontend | Admin tests + architecture guardrail + admin responsive matrix slice + analyze | Start UI-07 accessibility/semantics pass. |
| UI-07 | Accessibility/semantics pass | `[x]` | Frontend/QA | `accessibility_semantics_critical_flows_test.dart` + focused feature/guardrail tests + analyze | Start UI-08 copy consistency pass. |
| UI-08 | Copy consistency pass | `[x]` | Product/Frontend | Product copy guardrail + Prediction risk focused tests | Start UI-09 route/navigation UX polish. |
| UI-09 | Route/navigation UX polish | `[x]` | Frontend | Critical back-behavior router test + route guardrail + route audit | Start UI-10 readiness report. |
| UI-10 | UI-only readiness report | `[x]` | Docs/QA | Evidence report + final focused verification pass | UI-only extension closed; backend/release blockers remain external. |

## 6. Definition of Done cho moi UI packet

Moi UI packet chi duoc tick `[x]` khi:

- Scope da lam dung feature/layer.
- Dart code da format neu co sua Dart.
- Focused tests pass.
- Guardrail lien quan pass.
- Neu cham router: route audit pass.
- Neu cham high-risk copy/Arena/Prediction: product copy guardrail pass.
- Khong them backend fake, remote repo fake, React/Vite/Tailwind tooling.
- Khong them hardcoded color ngoai `lib/app/theme/`.
- Khong them `Colors.*` runtime trong `lib/`.
- Khong de page/widget import truc tiep `features/*/data`.
- Verification log ghi command that va ket qua that.

## 7. Command set de dung cho UI-only

Run from `flutter_app/`:

```bash
dart format .
flutter analyze
flutter test --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Focused commands thuong dung:

```bash
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/features/admin --reporter=compact
flutter test test/features/wallet/address_add_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_payment_method_add_page_test.dart --reporter=compact
```

## 8. Ket luan hanh dong tiep theo

Neu chi phat trien UI, thu tu nen lam la:

1. Dong 2 blocker QA text-entry bang manual evidence hoac Flutter harness.
2. Giam 4 file con tren 1200 lines ve 0.
3. Lam admin dashboard UI hardening vi day la surface dang duoc mo trong IDE.
4. Chay responsive visual QA matrix cho cac route priority.
5. Lam accessibility/semantics pass cho high-risk forms va dashboards.
6. Cap nhat UI-only readiness report.

Sau cac buoc nay, co the noi repo dat **UI-only enterprise-grade readiness**
manh hon, nhung van khong goi la production enterprise-grade cho den khi backend
va release ops duoc doi phu trach hoan tat.
