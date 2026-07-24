# Flutter Manual Smoke Checklist

Generated: 2026-05-31  
Scope: release-blocking manual QA checklist for VitTrade Flutter.

## Status

This is the committed smoke checklist artifact for manual/emulator QA. Record a
dated run below each time the checklist is executed on a device or emulator.
The 2026-05-26 remediation run is a basic install/launch smoke, not the full
release-blocking multi-flow checklist.

## Preconditions

- Run from `flutter_app/`.
- `flutter pub get`, `dart format --output=none --set-exit-if-changed .`,
  `flutter analyze`, and `flutter test --reporter=compact` are green.
- Debug APK builds with `flutter build apk --debug`.
- Use a clean app install or reset app data before the run.
- Use mock data only for development smoke. Production-like smoke must pass
  `APP_ENV=staging` or `APP_ENV=production` and a real `API_BASE_URL`.

## Required Flows

| Flow | Route / Entry | Checks | Evidence |
| --- | --- | --- | --- |
| Home | Bottom nav Home | Home shell loads, portfolio/status cards render, bottom nav state is stable. | Screenshot + notes |
| Markets | Bottom nav Markets | Market overview, pair list, and pair detail navigation render without overflow at 360 px width. | Screenshot + notes |
| Trade | Bottom nav Trade | Trade shell loads, order controls are visible, confirmation/risk copy is present before any high-risk action. | Screenshot + notes |
| Wallet | Bottom nav Wallet | Wallet overview masks sensitive data, balances/cards load, receive/send actions navigate correctly. | Screenshot + notes |
| Profile | Bottom nav Profile | Profile shell, security, device, and KYC entry points render with back navigation. | Screenshot + notes |
| Prediction | Markets > Predictions | Prediction home, event detail, risk calculator, order receipt, and portfolio routes remain separated from Arena. | Screenshot + notes |
| Arena | Open Arena entry | Arena surfaces use Arena Points only; no wallet/payout/profit/stake-return reward copy appears. | Screenshot + notes |
| Withdraw | Wallet > Withdraw | Preview shows amount, network, fees, limits, risk, masked address, and explicit confirmation. | Screenshot + notes |
| Address Add | Wallet > Address Add | Address form validates network/address, shows risk copy, masks sensitive destination where applicable. | Screenshot + notes |
| P2P Payment Add | P2P > Payment Method Add | Payment method add flow previews account data, ownership risk, limits, and confirmation. | Screenshot + notes |
| Token Approval Revoke | Wallet > Token Approvals | Revoke sheet shows spender, token, allowance, gas/impact review copy, cancel and confirm actions. | Screenshot + notes |

## Viewports

| Target | Width | Height | Notes |
| --- | ---: | ---: | --- |
| Minimum phone | 360 | 800 | No text overflow or clipped primary controls. |
| QA phone | 440 | 956 | Matches current widget-test baseline viewport. |
| Large phone | 480 | 1040 | Dense screens still scan cleanly. |

## Run Log

| Date | Build | Device | Tester | Result | Notes |
| --- | --- | --- | --- | --- | --- |
| 2026-05-26 | Not executed | Not executed | Codex | Checklist prepared | P2 ops artifact added; emulator/device execution still required for release evidence. |
| 2026-05-26 | `build/app/outputs/flutter-apk/app-debug.apk` | `emulator-5554` Android 17 API 37 | Codex | Basic launch smoke passed | Installed with `adb install -r`, launched `com.vittrade.vit_trade_flutter/.MainActivity`, observed `SC-007 HomePage` / `VitTrade` / bottom nav in UI dump, captured `flutter_app/run-artifacts/enterprise-remediation-20260526/smoke-home.png`, `smoke-home-ui.xml`, `smoke-logcat.txt`, and empty `smoke-crash-logcat.txt`. Full release-blocking flow checklist still required. |
| 2026-05-26 | `build/app/outputs/flutter-apk/app-debug.apk` | `emulator-5554` Android 17 API 37 | Codex | Basic launch smoke passed | Route-remediation verification run: installed with `adb install -r`, launched `com.vittrade.vit_trade_flutter/.MainActivity`, confirmed current focus on `MainActivity`, observed `SC-007 HomePage` / `VitTrade` / bottom nav in UI dump, captured `flutter_app/run-artifacts/enterprise-route-remediation-20260526T-smoke/launch.png`, `ui_dump.xml`, `window_focus.txt`, and `logcat_tail.txt`. No app `FATAL EXCEPTION` or app ANR signature found in captured log tail. Full release-blocking flow checklist still required. |
| 2026-05-27 | `build/app/outputs/flutter-apk/app-debug.apk` | `emulator-5554` Android 17 API 37 | Codex | Wallet smoke partially passed with Address Add automation blocker | Artifacts in `flutter_app/run-artifacts/wallet-smoke-20260527T112318/`. Build and reinstall passed. Confirmed Home `SC-007`, Wallet overview `SC-135`, Withdraw preview with amount, network, fee, masked destination, limit/risk copy, and explicit confirmation, Address Book `SC-144`, and Address Add initial `SC-143` risk/agreement copy. Address Add completion blocked because focused Flutter `EditText` fields did not accept `adb shell input text` or keyevent text, leaving the label counter at `0/30`; manual interactive smoke or a reliable emulator text-entry hook is required. Token Approval direct route confirmed `SC-150`, active approvals, and revoke sheet with spender, token, allowance, gas estimate, impact copy, Cancel, and Confirm. Crash buffer was empty. |
| 2026-05-30 | `build/app/outputs/flutter-apk/app-debug.apk` | `emulator-5554` Android 17 API 37 | Codex | Preconditions passed; smoke run prepared | `flutter pub get`, `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test --reporter=compact`, and `flutter build apk --debug` passed. `adb devices` reported `emulator-5554 device`; `flutter devices` reported the emulator plus desktop/web targets. Full flow execution starts in S7-02. |
| 2026-05-31 | Flutter widget harness | `flutter_test` `360x800`, `440x956`, `480x1040` | Codex | Responsive visual QA matrix passed | `test/quality/responsive_visual_qa_matrix_test.dart` covers 25 priority routes across Home, Markets, Trade, Wallet, Profile, Prediction, Arena, P2P, and Admin. UI-harness evidence only; no new emulator screenshots or UI dumps claimed. |
| 2026-05-30 | `build/app/outputs/flutter-apk/app-debug.apk` | `emulator-5554` Android 17 API 37 | Codex | Core navigation smoke passed | Artifacts in `flutter_app/run-artifacts/core-smoke-20260530T202735/`. Confirmed Home `SC-007`, Markets `SC-008`, pair detail `SC-044`, Trade `SC-048`, Wallet `SC-135`, Deposit `SC-138`, Profile `SC-156`, Profile settings/device entry, and clean KYC `SC-159` with app back returning to Profile. Clean Profile/KYC evidence uses `profile-kyc-retake-*`; earlier accidental Lens captures in the folder are superseded. Crash buffers were empty. |
| 2026-05-30 | `build/app/outputs/flutter-apk/app-debug.apk` | `emulator-5554` Android 17 API 37 | Codex | High-risk smoke partially passed with text-entry blockers | Artifacts in `flutter_app/run-artifacts/high-risk-smoke-20260530T204000/`. Passed Prediction `SC-027`/`SC-030`/`SC-031`/`SC-035`/`SC-036`, Arena `SC-184`/`SC-190`/`SC-191` points-only review, Withdraw retake with amount/network/fee/masked address plus `Cancel` and `Confirm withdraw`, and Token Approval revoke sheet with spender/token/allowance/gas/impact plus `Cancel`/`Confirm`. During smoke, Withdraw preview was fixed to add explicit confirmation actions, then APK was rebuilt/reinstalled and retaken. Address Add `SC-143` and P2P Payment Add `SC-232` initial screens rendered, but adb text entry could not complete required form fields (`0/30` label on Address Add; P2P owner field stayed empty), so manual interactive QA or a reliable Flutter text-entry hook is required. `flutter analyze`, focused wallet/prediction/p2p/arena controller tests, and product copy guardrail passed; crash buffers were empty. |
| 2026-05-30 | Flutter widget harness | `flutter_test` 440x956 viewport | Codex | UI-only text-entry harness passed | Added `test/quality/high_risk_text_entry_harness_test.dart` and ran it with the focused Address Add, P2P Payment Add, and product-copy tests. Address Add `SC-143` used Flutter `enterText` for label/address, opened the preview sheet, tapped the confirm action, and reached saved state. P2P Payment Add `SC-232` used Flutter `enterText` for account/owner, rendered preview and confirmation, tapped confirm, and left the add form. This is UI harness evidence only; it does not claim new manual/emulator screenshots. Commands passed: `dart format .`; `flutter test test/quality/high_risk_text_entry_harness_test.dart test/features/wallet/address_add_page_test.dart test/features/p2p_account/p2p_payment_method_add_page_test.dart test/quality/product_copy_guardrails_test.dart --reporter=compact`; `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`. |
| 2026-05-31 | Flutter widget harness | `flutter_test` 440x956 viewport | Codex | Accessibility semantics harness passed | Added `test/quality/accessibility_semantics_critical_flows_test.dart` for critical semantic labels/roles across Withdraw `SC-139`, Address Add `SC-143`, P2P Payment Add `SC-232`, Token Approval Revoke `SC-150`, Prediction Risk Calculator `SC-036`, and Admin KPI/chart surfaces. This is UI harness evidence only; no new manual/emulator screenshots or UI dumps are claimed. Commands passed: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`; focused Wallet/P2P/Predictions/Admin tests plus product-copy and architecture guardrails (`506` tests); `dart format .`; `flutter analyze`. |
| 2026-05-31 | Flutter widget/static harness | `flutter_test` 440x956 viewport | Codex | Copy and navigation guardrails passed | UI-08 replaced Prediction Risk Calculator payout wording with `Settlement value`/`P/L` and extended product-copy guardrails. UI-09 added `test/app/router/critical_navigation_back_behavior_test.dart` for critical header-back routes. This is UI/static harness evidence only; no new manual/emulator screenshots or UI dumps are claimed. Commands passed: product-copy guardrail (`13` tests), Prediction risk + accessibility focused tests (`11` tests), router + route guardrail tests (`12` tests), and `dart run tool/route_coverage_audit.dart --check`. |
| 2026-05-31 | Flutter docs/static harness | `flutter_test` focused suite | Codex | UI-only readiness closeout passed | UI-10 closed the final UI-only report and synced the tracking plan/evidence report into three groups: UI done, UI remaining, and out-of-scope backend/release blockers. This is docs/static harness evidence only; no new manual/emulator screenshots or UI dumps are claimed. Commands passed: `dart format .` (`1524` files, `0` changed); `flutter analyze`; focused UI/router/guardrail tests (`46` tests); `dart run tool/route_coverage_audit.dart --check`. |
