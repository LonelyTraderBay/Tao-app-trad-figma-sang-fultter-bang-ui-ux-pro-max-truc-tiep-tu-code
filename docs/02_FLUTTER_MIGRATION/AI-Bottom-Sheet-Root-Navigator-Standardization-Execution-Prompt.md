# AI Bottom Sheet Root Navigator Standardization Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
bottom-sheet standardization work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md`

Goal: make every Flutter bottom sheet render above `VitAppShell` and
`VitBottomNav`, remove direct feature-level `showModalBottomSheet` usage, and
add a guardrail so the issue cannot return.

This is not a request to make another plan. It is a request to execute the
existing tracking plan in order.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute every open task in this plan, in order, until bottom-sheet root
navigator standardization is complete:

docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md

The final product must guarantee:
- Bottom sheets are never covered by `VitBottomNav`.
- Feature code does not call `showModalBottomSheet` directly.
- All bottom sheets use one shared VitTrade API.
- Existing visual style, business flow, return values, haptics, and safety
  confirmation semantics are preserved.
- Future direct `showModalBottomSheet` calls are caught by a guardrail test.

NON-NEGOTIABLE OUTCOME:
- Do not only analyze.
- Do not only create another prompt or plan.
- Execute the next open item from the tracking plan.
- Continue automatically to the next open item unless the user explicitly asks
  for one phase only.
- Keep implementation tightly scoped to bottom-sheet modal routing and the
  shared helper.
- Do not rewrite unrelated top headers, router behavior, feature data, product
  copy, theme systems, or layouts.
- Do not revert unrelated user changes in the working tree.
- Preserve every sheet's existing return type and caller behavior.
- Preserve all preview/confirm flows for withdrawals, transfers, address
  additions, token approvals, Earn risk flows, P2P, trading, Arena, and
  Prediction Markets.
- Keep Arena points-only language.
- Keep Prediction Markets and Arena boundaries separate.
- Process work in this exact order:
  1. BS-00 - Baseline Audit
  2. BS-01 - Shared Helper
  3. BS-02 - Guardrail Test
  4. BS-03 - High-Risk Wallet/Financial Migration
  5. BS-04 - Earn And Savings Migration
  6. BS-05 - Trade, Predictions, Arena, Referral Migration
  7. BS-06 - Already-Safe Calls Migration
  8. BS-07 - Format, Analyze, And Focused Tests
  9. BS-08 - Emulator Smoke Test
  10. BS-09 - Tracking Plan Update And Final Review
- Do not start later phases while earlier phases have failing focused tests,
  stale checklist items, or unresolved API issues.
- If current scans differ from the tracking plan counts, trust current source,
  update the tracking plan evidence, and explain the drift before continuing.
- If all phases are complete, the final response must include:
  BOTTOM SHEET STANDARDIZATION COMPLETE
- If forced to stop before all phases are complete, the final response must end
  with exactly:
  RESUME FROM: BS-<number> - <title>
  This must be the final line, with no text after it.

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md
6. docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md
7. docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md
8. docs/03_DESIGN_SYSTEM/Guidelines.md
9. docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md
10. docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md

If documents conflict, follow this order:
1. Current user instruction
2. AGENTS.md
3. VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md
4. Flutter Native Design Standard
5. Flutter Module Identity Standard
6. Current Flutter source and tests

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Tests: `flutter_app/test/`
- App shell: `flutter_app/lib/shared/layout/vit_app_shell.dart`
- Bottom nav: `flutter_app/lib/shared/layout/vit_bottom_nav.dart`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Shared widget exports: `flutter_app/lib/shared/widgets/widgets.dart`
- Route shell: `flutter_app/lib/app/router/route_groups/root_routes.dart`
- Tracking plan:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md`

PROBLEM CONTEXT:
`VitAppShell` renders page content and then renders `VitBottomNav` above it in
a `Stack`. A `showModalBottomSheet` opened from a page-local navigator can sit
under that bottom-nav overlay. This was reproduced on Home where `Sản phẩm >
Xem thêm` opened a bottom sheet that was partially covered by `VitBottomNav`.

Correct behavior is to open app bottom sheets on the root navigator:

```dart
useRootNavigator: true,
```

The professional fix is not to manually add this forever. Create a shared
VitTrade bottom-sheet helper, migrate all call sites, and add a guardrail.

BS-00 - BASELINE AUDIT:
Run a fresh scan before editing:

```bash
cd flutter_app
rg -n "showModalBottomSheet" lib test
rg -n "useRootNavigator" lib test
```

Expected baseline from the tracking plan:
- 60 `showModalBottomSheet` calls in `flutter_app/lib`
- 12 already safe with `useRootNavigator: true`
- 48 missing `useRootNavigator: true`
- 37 affected screens/widgets

If counts differ:
- inspect the drift
- trust current source
- update the tracking plan counts/checklist before migrating
- do not ignore newly discovered direct calls

BS-01 - SHARED HELPER:
Create:

```text
flutter_app/lib/shared/widgets/vit_bottom_sheet.dart
```

Export it from:

```text
flutter_app/lib/shared/widgets/widgets.dart
```

Implement a generic helper similar to:

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
  bool useSafeArea = false,
});
```

Implementation requirements:
- Internally call `showModalBottomSheet<T>`.
- Default `useRootNavigator` must be `true`.
- Preserve generic return types such as `String`, `bool`, and custom objects.
- Pass through caller-provided `backgroundColor`, `barrierColor`, `shape`,
  `constraints`, `isScrollControlled`, `enableDrag`, `isDismissible`, and
  `useSafeArea`.
- Do not force `isScrollControlled: true` globally; preserve caller behavior.
- Use app theme tokens for defaults only where existing calls omit values.
- Do not create local hard-coded palettes if app tokens exist.
- Keep the helper small and boring. It is infrastructure, not a visual rewrite.

Add focused tests for helper behavior. The test should verify at least:
- the helper can open and close a sheet
- the helper returns a typed value
- the helper default is root-navigator safe, either by API shape or by a
  guarded implementation check if widget-level introspection is awkward

BS-02 - GUARDRAIL TEST:
Add a quality test, suggested path:

```text
flutter_app/test/quality/bottom_sheet_guardrail_test.dart
```

Guardrail requirements:
- Scan `flutter_app/lib/app`, `flutter_app/lib/features`, and
  `flutter_app/lib/shared`.
- Fail if `showModalBottomSheet` appears outside
  `flutter_app/lib/shared/widgets/vit_bottom_sheet.dart`.
- Report file and line for every violation.
- Allow comments/docs only if they are not Dart source in scanned paths.
- Final state should have zero direct feature-level calls.

Do not weaken the guardrail by adding broad allowlists. The helper file should
be the only allowlisted Dart source.

BS-03 - HIGH-RISK WALLET/FINANCIAL MIGRATION:
Migrate every Wallet item listed in Phase 3 of the tracking plan.

Rules for each call:
- Replace `showModalBottomSheet<T>` with `showVitBottomSheet<T>`.
- Preserve `await`, assigned variables, generic types, and return handling.
- Preserve all existing parameters unless intentionally replaced by helper
  defaults.
- Preserve `Navigator.of(context).pop(...)` behavior inside sheet content.
- Preserve financial preview/confirm content and copy.
- Do not change route paths, repository calls, provider reads, controller
  state, validators, or submission behavior.
- After this batch, run focused Wallet tests.

BS-04 - EARN AND SAVINGS MIGRATION:
Migrate every Earn/Savings/Staking item listed in Phase 4 of the tracking plan.

Rules:
- Preserve calculators, pickers, strategy sheets, risk disclosures,
  recommendations, and confirmation semantics.
- Do not change Earn/Savings financial safety language.
- For `staking_risk_score_inputs.dart`, migrate `_RiskDropdown._showOptions`
  because it is used by `StakingRiskScoreCalculatorPage`.
- After this batch, run focused Earn tests.

BS-05 - TRADE, PREDICTIONS, ARENA, REFERRAL MIGRATION:
Migrate every item listed in Phase 5 of the tracking plan.

Rules:
- Convert asset picker must still return selected symbol correctly.
- Bot security sheets must preserve API key/IP allowlist safety information.
- Copy audit export must preserve audit/export semantics.
- Prediction sheets must keep market/probability/PnL language.
- Arena sheets must keep points-only language.
- Referral sheets must preserve share/export/report/dispute behavior.
- After this batch, run focused Trade, Predictions, Arena, and Referral tests.

BS-06 - ALREADY-SAFE CALLS MIGRATION:
Migrate the 12 already-safe calls listed in Phase 6 of the tracking plan.

Reason:
- They already have `useRootNavigator: true`, but final codebase should have
  one bottom-sheet API and no direct feature-level `showModalBottomSheet`.

Rules:
- Preserve existing explicit `useRootNavigator: true` behavior through helper
  defaults.
- Do not regress Home `Sản phẩm > Xem thêm`.
- Do not regress News article sheets.
- Do not regress existing Trade demo sheets and Wallet dust converter confirm
  sheet.

BS-07 - FORMAT, ANALYZE, AND FOCUSED TESTS:
Run:

```bash
cd flutter_app
dart format .
flutter analyze
flutter test test/shared --reporter=compact
flutter test test/features/home --reporter=compact
flutter test test/features/wallet --reporter=compact
flutter test test/features/earn --reporter=compact
flutter test test/features/trade --reporter=compact
flutter test test/features/predictions --reporter=compact
flutter test test/features/arena --reporter=compact
flutter test test/features/referral --reporter=compact
flutter test test/quality --reporter=compact
```

If a focused feature directory does not exist or contains no tests, state that
explicitly and run the closest available tests for changed files.

BS-08 - EMULATOR SMOKE TEST:
If an Android emulator is available, install and launch the app:

```bash
cd flutter_app
flutter devices
flutter run -d <android-emulator-id> --debug --no-resident
```

Use `adb` UI-tree inspection or manual checks for representative sheets:
- Home `Sản phẩm > Xem thêm`
- Wallet withdraw network picker
- Wallet withdraw confirmation
- Wallet transfer wallet picker
- Wallet transfer confirmation
- Earn savings/staking representative create/detail sheet
- Convert asset picker
- Referral share/report sheet
- Arena challenge action sheet

Pass criteria:
- The sheet is visually above bottom nav.
- Bottom nav is not visible as an overlay on the sheet.
- The bottom action/last row is reachable.
- Sheet close/selection still works.

BS-09 - TRACKING PLAN UPDATE AND FINAL REVIEW:
Update:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md
```

Required updates:
- Mark completed checklist items.
- Update audit counts.
- Mention helper path and guardrail test path.
- Record tests run and emulator smoke-test result.
- If any item remains incomplete, leave it unchecked and explain why.

FINAL REVIEW CHECKLIST:
- No direct `showModalBottomSheet` calls outside the helper:

```bash
rg -n "showModalBottomSheet" flutter_app/lib flutter_app/test
```

- `showVitBottomSheet` is exported and used by feature code.
- Guardrail test catches future direct calls.
- All 48 risky calls migrated.
- All 12 already-safe direct calls migrated.
- `flutter analyze` passes.
- Focused tests pass.
- Emulator smoke test is complete or the lack of emulator is clearly stated.

FINAL RESPONSE REQUIREMENTS:
If complete, include:

BOTTOM SHEET STANDARDIZATION COMPLETE

Also summarize:
- files created
- major files migrated by feature
- guardrail added
- tests run
- emulator smoke-test result

If blocked or incomplete, end with exactly:

RESUME FROM: BS-<number> - <title>
````

