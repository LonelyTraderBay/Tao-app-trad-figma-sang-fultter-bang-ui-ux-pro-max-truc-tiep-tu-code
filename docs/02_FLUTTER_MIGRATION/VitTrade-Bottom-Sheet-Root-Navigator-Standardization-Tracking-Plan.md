# VitTrade Bottom Sheet Root Navigator Standardization Tracking Plan

Created: 2026-06-04

## Objective

Standardize every Flutter bottom sheet so it renders above `VitAppShell` and
cannot be covered by `VitBottomNav`.

The production issue was reproduced on Home: tapping `Xem them` opened a
bottom sheet from the page navigator, while `VitBottomNav` stayed above it in
the shell overlay. The Home sheet was fixed with `useRootNavigator: true`.

This plan tracks the app-wide fix so no screen is missed.

## Source Of Truth

- App shell: `flutter_app/lib/shared/layout/vit_app_shell.dart`
- Bottom nav: `flutter_app/lib/shared/layout/vit_bottom_nav.dart`
- Existing affected API: `showModalBottomSheet`
- Recommended new API: `showVitBottomSheet`

## Current Audit Summary

| Status | Count |
| --- | ---: |
| Total `showModalBottomSheet` calls in `flutter_app/lib` | 60 |
| Already safe with `useRootNavigator: true` | 12 |
| Missing `useRootNavigator: true` and at risk | 48 |
| Affected screens/widgets | 37 |

All risky cases are under the app `ShellRoute`, which renders `VitAppShell` with
bottom navigation unless a future route explicitly disables it.

## Final Execution Summary

Completed: 2026-06-04

| Status | Count |
| --- | ---: |
| Direct `showModalBottomSheet` calls in `flutter_app/lib` | 1 |
| Direct calls allowed by guardrail | 1 (`shared/widgets/vit_bottom_sheet.dart`) |
| Feature/shared callsites migrated to `showVitBottomSheet` | 60 |
| Remaining `useRootNavigator` occurrences outside helper | 0 |

Additional fix found during migration:

- `SavingsComparisonPage._addProduct` previously closed the picker with the
  page `context`. After root navigator migration, it now receives the
  `sheetContext` from the bottom sheet builder and pops the sheet route
  directly.

## Design Decision

Do not keep adding `useRootNavigator: true` manually forever. Introduce a shared
bottom sheet helper and migrate feature code to it.

Required behavior:

- `useRootNavigator: true` by default.
- Dark theme defaults use app tokens.
- Keeps caller control over `isScrollControlled`, `barrierColor`,
  `backgroundColor`, `shape`, `constraints`, `enableDrag`, and return type.
- Does not change sheet content semantics or business flow.
- Supports generic return values such as `bool`, `String`, and custom objects.
- Avoids new local palettes or per-feature modal styling where shared defaults
  are enough.

Suggested helper path:

```text
flutter_app/lib/shared/widgets/vit_bottom_sheet.dart
```

Suggested export path:

```text
flutter_app/lib/shared/widgets/widgets.dart
```

Suggested API shape:

```dart
Future<T?> showVitBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useRootNavigator = true,
  Color? backgroundColor,
  Color? barrierColor,
  ShapeBorder? shape,
  BoxConstraints? constraints,
  bool enableDrag = true,
  bool isDismissible = true,
});
```

## Implementation Phases

### Phase 1 - Shared Helper

- [x] Add `shared/widgets/vit_bottom_sheet.dart`.
- [x] Export helper from `shared/widgets/widgets.dart`.
- [x] Set `useRootNavigator: true` as the default.
- [x] Use app tokens for default modal barrier/background/shape.
- [x] Preserve return types with `Future<T?>`.
- [x] Add focused unit/widget test for helper defaults.

### Phase 2 - Guardrail

- [x] Add a quality test that scans `flutter_app/lib/features`,
  `flutter_app/lib/shared`, and `flutter_app/lib/app` for direct
  `showModalBottomSheet` usage.
- [x] Allow direct `showModalBottomSheet` only inside
  `shared/widgets/vit_bottom_sheet.dart`.
- [x] Make the test fail with file and line output for new direct calls.
- [x] Keep existing already-safe direct calls temporarily only if migration is
  split into phases; final state should have none outside helper.

### Phase 3 - High-Risk Financial Screens

Prioritize flows where a covered confirmation/action sheet could affect money,
wallet state, security, or irreversible user decisions.

| Done | Screen/widget | Route context | Call | File |
| --- | --- | --- | --- | --- |
| [x] | `WithdrawPage` | Wallet withdraw | `_openNetworkPicker` | `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart:196` |
| [x] | `WithdrawPage` | Wallet withdraw | `_showConfirmPreview` | `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart:231` |
| [x] | `TransferPage` | Wallet/P2P transfer | `_showWalletPicker` | `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart:215` |
| [x] | `TransferPage` | Wallet/P2P transfer | `_showAssetPicker` | `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart:254` |
| [x] | `TransferPage` | Wallet/P2P transfer | `_showConfirmSheet` | `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart:301` |
| [x] | `AddressAddPage` | Wallet address add | `_showConfirmPreview` | `flutter_app/lib/features/wallet/presentation/pages/address_add_page.dart:199` |
| [x] | `WalletTokenApprovalPage` | Token approval revoke | `_showRevokeSheet` | `flutter_app/lib/features/wallet/presentation/pages/wallet_token_approval_page.dart:113` |
| [x] | `DepositPage` | Wallet deposit | `_openNetworkPicker` | `flutter_app/lib/features/wallet/presentation/pages/deposit_page.dart:145` |
| [x] | `BuyCryptoPage` | Buy crypto | `_showCryptoPicker` | `flutter_app/lib/features/wallet/presentation/pages/buy_crypto_page.dart:158` |
| [x] | `WalletHealthScorePage` | Wallet health | `_showRecommendationSheet` | `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_01.dart:61` |

### Phase 4 - Earn And Savings Screens

| Done | Screen/widget | Call | File |
| --- | --- | --- | --- |
| [x] | `AutoCompoundSettingsPage` | `_openInfo` | `flutter_app/lib/features/earn/presentation/pages/auto_compound_settings_page_part_01.dart:124` |
| [x] | `AutoCompoundSettingsPage` | `_openSettings` | `flutter_app/lib/features/earn/presentation/pages/auto_compound_settings_page_part_01.dart:140` |
| [x] | `SavingsAutoPilotPage` | `_showActionDetail` | `flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page.dart:247` |
| [x] | `SavingsComparisonPage` | `_openPicker` | `flutter_app/lib/features/earn/presentation/pages/savings_comparison_page.dart:178` |
| [x] | `SavingsDCAPage` | `_openCreateSheet` | `flutter_app/lib/features/earn/presentation/pages/savings_dca_page.dart:131` |
| [x] | `SavingsGoalPage` | `_openCreateSheet` | `flutter_app/lib/features/earn/presentation/pages/savings_goal_page_part_01.dart:101` |
| [x] | `SavingsGoalPage` | `_openGoalDetail` | `flutter_app/lib/features/earn/presentation/pages/savings_goal_page_part_01.dart:126` |
| [x] | `SavingsGuidePage` | `_openTutorialSheet` | `flutter_app/lib/features/earn/presentation/pages/savings_guide_page.dart:107` |
| [x] | `SavingsLadderPage` | `_showConfirmSheet` | `flutter_app/lib/features/earn/presentation/pages/savings_ladder_page.dart:291` |
| [x] | `SavingsRecommendationsPage` | `_openStrategySheet` | `flutter_app/lib/features/earn/presentation/pages/savings_recommendations_page_part_01.dart:116` |
| [x] | `SavingsRecommendationsPage` | `_openCompareSheet` | `flutter_app/lib/features/earn/presentation/pages/savings_recommendations_page_part_01.dart:155` |
| [x] | `StakingAdvancedOrdersPage` | `_showCreateOrder` | `flutter_app/lib/features/earn/presentation/pages/staking_advanced_orders_page.dart:130` |
| [x] | `StakingEmergencyActionsPage` | `_showActionSheet` | `flutter_app/lib/features/earn/presentation/pages/staking_emergency_actions_page.dart:105` |
| [x] | `StakingGuidePage` | `_openTutorialSheet` | `flutter_app/lib/features/earn/presentation/pages/staking_guide_page.dart:118` |
| [x] | `StakingInstitutionalPage` | `_showCreateBatch` | `flutter_app/lib/features/earn/presentation/pages/staking_institutional_page.dart:129` |
| [x] | `StakingInsurancePage` | `_showPlan` | `flutter_app/lib/features/earn/presentation/pages/staking_insurance_page_part_01.dart:78` |
| [x] | `StakingInsurancePage` | `_showClaimForm` | `flutter_app/lib/features/earn/presentation/pages/staking_insurance_page_part_01.dart:88` |
| [x] | `StakingLiquidStakingPage` | `_showTokenDetail` | `flutter_app/lib/features/earn/presentation/pages/staking_liquid_staking_page_part_01.dart:113` |
| [x] | `StakingProofOfReservesPage` | `_openVerifySheet` | `flutter_app/lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_01.dart:72` |
| [x] | `StakingRecommendationsPage` | `_openStrategySheet` | `flutter_app/lib/features/earn/presentation/pages/staking_recommendations_page.dart:149` |
| [x] | `StakingRegulatoryFrameworkPage` | `_openLicenseSheet` | `flutter_app/lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart:118` |
| [x] | `StakingTransactionReportingPage` | `_openMethodSheet` | `flutter_app/lib/features/earn/presentation/pages/staking_transaction_reporting_page.dart:145` |
| [x] | `StakingTransactionReportingPage` | `_openExportSheet` | `flutter_app/lib/features/earn/presentation/pages/staking_transaction_reporting_page.dart:166` |
| [x] | `StakingWebhooksPage` | `_showCreateSheet` | `flutter_app/lib/features/earn/presentation/pages/staking_webhooks_page.dart:91` |
| [x] | `StakingWithdrawalPolicyPage` | `_openCalculator` | `flutter_app/lib/features/earn/presentation/pages/staking_withdrawal_policy_page_part_01.dart:73` |
| [x] | `StakingRiskScoreCalculatorPage` | `_RiskDropdown._showOptions` | `flutter_app/lib/features/earn/presentation/widgets/staking_risk_score_inputs.dart:178` |

### Phase 5 - Trade, Predictions, Arena, Referral

| Done | Feature | Screen/widget | Call | File |
| --- | --- | --- | --- | --- |
| [x] | Trade | `ConvertPage` | `_showAssetPicker` | `flutter_app/lib/features/trade/presentation/pages/convert_page.dart:238` |
| [x] | Trade | `BotSecuritySettingsPage` | `_showApiKeySheet` | `flutter_app/lib/features/trade/presentation/pages/bot_security_settings_page.dart:158` |
| [x] | Trade | `BotSecuritySettingsPage` | `_showIpSheet` | `flutter_app/lib/features/trade/presentation/pages/bot_security_settings_page.dart:169` |
| [x] | Trade | `CopyAuditLogPage` | `_showExportSheet` | `flutter_app/lib/features/trade/presentation/pages/copy_audit_log_page.dart:167` |
| [x] | Predictions | `PredictionsLeaderboardPage` | `_showPnlInfo` | `flutter_app/lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart:123` |
| [x] | Predictions | `PredictionsRewardsPage` | `_showRiskSheet` | `flutter_app/lib/features/predictions/presentation/pages/predictions_rewards_page.dart:146` |
| [x] | Arena | `ArenaChallengeDetailPage` | `_showActionSheet` | `flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page.dart:222` |
| [x] | Arena | `ArenaModeDetailPage` | `_showTrustSheet` | `flutter_app/lib/features/arena/presentation/pages/arena_mode_detail_page.dart:170` |
| [x] | Referral | `ReferralHomePage` | `_showShareSheet` | `flutter_app/lib/features/referral/presentation/pages/referral_home_page.dart:173` |
| [x] | Referral | `ReferralRewardsPage` | `_showExportSheet` | `flutter_app/lib/features/referral/presentation/pages/referral_rewards_page_part_01.dart:107` |
| [x] | Referral | `ReferralRewardsPage` | `_showReportSheet` | `flutter_app/lib/features/referral/presentation/pages/referral_rewards_page_part_01.dart:166` |
| [x] | Referral | `ReferralRewardsPage` | `_showDisputeHistorySheet` | `flutter_app/lib/features/referral/presentation/pages/referral_rewards_page_part_01.dart:218` |

### Phase 6 - Already Safe Calls To Migrate For Consistency

These already use `useRootNavigator: true`. Migrate them to the helper after
the risky list is complete so the final codebase has one bottom sheet API.

| Done | Screen | File |
| --- | --- | --- |
| [x] | `HomePage` | `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart:26` |
| [x] | `NewsPage` | `flutter_app/lib/features/news/presentation/pages/news_page.dart:145` |
| [x] | `AdvancedToolsDemoPage` | `flutter_app/lib/features/trade/presentation/pages/advanced_tools_demo_page.dart:187` |
| [x] | `AdvancedToolsDemoPage` | `flutter_app/lib/features/trade/presentation/pages/advanced_tools_demo_page.dart:210` |
| [x] | `AdvancedToolsDemoPage` | `flutter_app/lib/features/trade/presentation/pages/advanced_tools_demo_page.dart:233` |
| [x] | `ExecutionQualityDemoPage` | `flutter_app/lib/features/trade/presentation/pages/execution_quality_demo_page.dart:166` |
| [x] | `ExecutionQualityDemoPage` | `flutter_app/lib/features/trade/presentation/pages/execution_quality_demo_page.dart:185` |
| [x] | `ExecutionQualityDemoPage` | `flutter_app/lib/features/trade/presentation/pages/execution_quality_demo_page.dart:204` |
| [x] | `RiskManagementDemoPage` | `flutter_app/lib/features/trade/presentation/pages/risk_management_demo_page.dart:152` |
| [x] | `RiskManagementDemoPage` | `flutter_app/lib/features/trade/presentation/pages/risk_management_demo_page.dart:176` |
| [x] | `TradingBotsPage` | `flutter_app/lib/features/trade/presentation/pages/trading_bots_page.dart:178` |
| [x] | `DustConverterPage` | `flutter_app/lib/features/wallet/presentation/pages/dust_converter_page.dart:210` |

## Verification Plan

Run after each migration batch:

```bash
cd flutter_app
dart format .
flutter analyze
```

Focused tests by phase:

```bash
flutter test test/features/home --reporter=compact
flutter test test/features/wallet --reporter=compact
flutter test test/features/earn --reporter=compact
flutter test test/features/trade --reporter=compact
flutter test test/features/predictions --reporter=compact
flutter test test/features/arena --reporter=compact
flutter test test/features/referral --reporter=compact
flutter test test/shared --reporter=compact
```

Final guardrail:

```bash
flutter test test/quality --reporter=compact
```

Manual emulator smoke test:

- [x] Home `San pham > Xem them` sheet is not covered by bottom nav.
  Evidence: `flutter_app/run-artifacts/bottom_sheet_home_after.png`.
- [x] Wallet withdraw network picker is not covered.
  Evidence:
  `flutter_app/run-artifacts/bottom_sheet_withdraw_network_after.png`.
- [x] Wallet withdraw confirmation preview is not covered.
  Evidence:
  `flutter_app/run-artifacts/bottom_sheet_withdraw_preview_after.png`.
- [x] Android crash buffer was clean after smoke, and the app process remained
  running.

Remaining migrated feature sheets are covered by focused widget tests plus the
repository-wide guardrail that prevents any future direct page-navigator bottom
sheet calls.

Actual verification results:

- [x] `dart format` on all files touched by bottom sheet migration.
- [x] `flutter analyze`
- [x] `flutter test test/quality/bottom_sheet_guardrail_test.dart --reporter=compact`
- [x] `flutter test test/shared --reporter=compact`
- [x] `flutter test test/features/home --reporter=compact`
- [x] `flutter test test/features/wallet --reporter=compact`
- [x] `flutter test test/features/earn --reporter=compact`
- [x] `flutter test test/features/trade --reporter=compact`
- [x] `flutter test test/features/predictions --reporter=compact`
- [x] `flutter test test/features/arena --reporter=compact`
- [x] `flutter test test/features/referral --reporter=compact`
- [x] `flutter test test/features/news --reporter=compact`

Full `flutter test test/quality --reporter=compact` was also run. The new
bottom sheet guardrail passed, but the quality folder still has unrelated stale
artifact guardrails for back navigation and top header audits.

## Completion Criteria

- [x] No direct `showModalBottomSheet` calls remain outside
  `shared/widgets/vit_bottom_sheet.dart`.
- [x] All 48 risky calls are migrated.
- [x] All 12 already-safe calls are migrated for consistency.
- [x] Guardrail test fails on future direct `showModalBottomSheet` calls.
- [x] `flutter analyze` passes.
- [x] Focused feature tests pass.
- [x] Emulator smoke test confirms bottom nav no longer overlays representative
  root-navigator sheets.

## Notes

- Do not change transaction safety copy while migrating modal APIs.
- Do not weaken preview/confirm behavior for withdrawals, transfers, address
  additions, token approvals, or Earn risk flows.
- Keep Arena copy points-only.
- Keep Prediction Markets and Arena boundaries visually and semantically
  separate.
