# AI Home Entry Back Navigation Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
Home-entry back-navigation work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Home-Entry-Back-Navigation-Tracking-Plan.md`

Goal: make every Home-origin navigation entry return to Home on header back,
while preserving correct feature-parent back behavior for deeper screens and
safe direct/deep-link fallback behavior.

This is not a request to make another plan. It is a request to execute the
existing tracking plan in order.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute every open task in this plan, in order, until the Home-entry
back-navigation work is complete:

docs/02_FLUTTER_MIGRATION/VitTrade-Home-Entry-Back-Navigation-Tracking-Plan.md

The final product must make navigation from Home predictable:
- If the user taps a Home product/function card, header back on the first
  destination returns to Home.
- If the user drills deeper inside that feature, header back returns to the
  feature parent or child parent, not directly to Home.
- If the same route is opened directly, by deep link, bottom nav, notification,
  or another module, it still has a safe fallback route.
- High-risk financial, trading, P2P, wallet, security, submit, preview,
  confirmation, receipt, and dirty-form behavior is not weakened.

NON-NEGOTIABLE OUTCOME:
- Do not only analyze.
- Do not only create another prompt or plan.
- Execute the next open item from the tracking plan.
- Continue automatically to the next open item unless the user explicitly asks
  for one phase only.
- Keep implementation tightly scoped to Home-entry back behavior.
- Do not rewrite unrelated top-header visual polish, text mojibake, theme
  tokens, router names, route coverage, or product copy unless required by this
  task.
- Preserve user/unrelated changes in the dirty worktree. Do not revert files
  you did not intentionally change.
- Process work in this exact order:
  1. HEB-00 - Baseline Freeze
  2. HEB-01 - Home Navigation Intent Cleanup
  3. HEB-02 - Entry Screen Back Handlers
  4. HEB-03 - Home Entry Route Matrix Tests
  5. HEB-04 - Audit Guardrail Extension
  6. HEB-05 - Verification
  7. HEB-06 - Tracking Plan Update And Final Review
- Do not start later phases while earlier phases have failing focused tests,
  stale generated artifacts, undocumented exceptions, or open checklist items
  that affect correctness.
- If current scans differ from the tracking plan findings, trust current source,
  update the plan/audit evidence, and explain the drift before continuing.
- If all phases are complete, the final response must include:
  HOME ENTRY BACK NAVIGATION COMPLETE
- If forced to stop before all phases are complete, the final response must end
  with exactly:
  RESUME FROM: HEB-<number> - <title>
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
9. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md
10. docs/02_FLUTTER_MIGRATION/VitTrade-Header-Back-Navigation-Behavior-Standardization-Tracking-Plan.md
11. docs/02_FLUTTER_MIGRATION/VitTrade-Home-Entry-Back-Navigation-Tracking-Plan.md
12. docs/02_FLUTTER_MIGRATION/VitTrade-Header-Back-Navigation-Behavior-Audit.md
13. docs/02_FLUTTER_MIGRATION/VitTrade-Header-Back-Navigation-Behavior-Audit.csv
14. docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md

If documents conflict, follow this order:
1. Current user instruction
2. AGENTS.md
3. VitTrade-Home-Entry-Back-Navigation-Tracking-Plan.md
4. VitTrade-Header-Back-Navigation-Behavior-Standardization-Tracking-Plan.md
5. Flutter Native Design Standard
6. Flutter Module Identity Standard
7. Current Flutter source and tests

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Tests: `flutter_app/test/`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- Route paths: `flutter_app/lib/app/router/app_route_paths.dart`
- Route groups: `flutter_app/lib/app/router/route_groups/`
- Home data: `flutter_app/lib/features/home/data/home_mock_data.dart`
- Home page: `flutter_app/lib/features/home/presentation/pages/home_page.dart`
- Home navigation helper: `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`
- Shared back helper: `flutter_app/lib/core/navigation/back_navigation.dart`
- Shared top chrome/header: `flutter_app/lib/shared/layout/`
- Audit tools: `flutter_app/tool/`
- Generated QA docs: `docs/02_FLUTTER_MIGRATION/`

ACTIVE BACK-NAVIGATION CONTRACT:

| User path | Header back should do |
| --- | --- |
| `Home -> Entry screen` | Return to `Home`. |
| `Home -> Entry screen -> Child screen` | Return to `Entry screen` or the child parent. |
| `Direct/deep link -> Entry screen` | Use safe fallback parent. |
| `Bottom nav -> Root module` | Do not create artificial Home back behavior. |
| `High-risk form/confirm screen` | Preserve confirmation/discard/safe fallback behavior. |

PREFERRED TECHNICAL PATTERN:

Home should preserve real history for Home-origin entries:

```dart
context.push(path);
```

Entry screens that can be reached from Home and directly should use:

```dart
goBackOrFallback(
  context,
  fallbackPath: AppRoutePaths.<safeParent>,
  mode: BackNavigationMode.historyThenFallback,
)
```

This allows:
- Home-origin route: `context.canPop()` is true, so header back pops to Home.
- Direct/deep-link route: `context.canPop()` is false, so header back goes to
  the explicit safe parent.

CURRENT KNOWN MISMATCHES TO FIX:

1. Home navigation helper
   - File: `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`
   - Current: `_go(String path)` uses `context.go(path)`.
   - Required: preserve Home history for feature/product entries, normally with
     `context.push(path)`.

2. Convert
   - File: `flutter_app/lib/features/trade/presentation/pages/convert_page.dart`
   - Current: back goes to `AppRoutePaths.trade`.
   - Required: pop Home if entered from Home; fallback Trade if direct.

3. Margin
   - File: `flutter_app/lib/features/trade/presentation/pages/margin_trading_page.dart`
   - Current: back goes to `AppRoutePaths.trade`.
   - Required: pop Home if entered from Home; fallback Trade if direct.

4. Trading Bots
   - File: `flutter_app/lib/features/trade/presentation/pages/trading_bots_page.dart`
   - Current: back goes to `AppRoutePaths.trade`.
   - Required: pop Home if entered from Home; fallback Trade if direct.

5. Copy Trading
   - File: `flutter_app/lib/features/trade/presentation/pages/copy_trading_page.dart`
   - Current: back goes to `AppRoutePaths.trade`.
   - Required: pop Home if entered from Home; fallback Trade if direct.

6. DCA
   - File: `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart`
   - Current: `_close` pops if possible, fallback Trade.
   - Required: verify direct fallback decision, then ensure Home-origin pop
     returns Home.

7. Wallet
   - File: `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart`
   - Current: root Wallet header has no visible Home-return back.
   - Required: decide and implement source-aware Home-return behavior without
     breaking bottom-nav Wallet root behavior.

8. Savings
   - File: `flutter_app/lib/features/earn/presentation/pages/savings_page.dart`
   - Current: back goes to `snapshot.backRoute`, currently Earn.
   - Required: pop Home if entered from Home; fallback Earn if direct.

9. Predictions
   - File: `flutter_app/lib/features/predictions/presentation/pages/predictions_home_page.dart`
   - Current: back goes to Markets.
   - Required: pop Home if entered from Home; fallback Markets if direct.

ROWS THAT MUST BE REVIEWED:
Use section 5 of the tracking plan as the checklist. Every HEB row must end as
one of:
- Done
- Deferred with reason
- Out of scope with reason

Do not omit:
- Home header Search
- Home header Notifications
- Home next action
- Home recent products
- every `HomeQuickAction`
- Home discovery cards
- Home market list actions
- Home pair rows/cards

PHASE HEB-00 - BASELINE FREEZE:

Do this before editing:
1. Run `git status --short`.
2. Read all documents listed above.
3. Inspect the current Home outgoing routes.
4. Run focused baseline commands from `flutter_app/`:

```bash
dart run tool/back_navigation_behavior_audit.dart --check
flutter test test/core/navigation/back_navigation_test.dart --reporter=compact
flutter test test/features/home/home_page_test.dart --reporter=compact
```

5. If the back-navigation audit artifacts are missing or stale, regenerate only
   the relevant artifacts and note that in the tracking plan.
6. Do not proceed if baseline failures are unrelated and block this work;
   document them and continue only if the task can be safely isolated.

PHASE HEB-01 - HOME NAVIGATION INTENT CLEANUP:

Goal: Home-origin feature entries must preserve Home in navigation history.

Steps:
1. Inspect `HomePage` navigation call sites.
2. Split navigation intent if needed:
   - feature/product entry: push
   - bottom-nav/root-tab style navigation: keep go if appropriate
3. Update Home helper naming so future readers understand the difference.
4. Prefer `AppRoutePaths` constants over raw strings when practical and scoped.
5. Do not change unrelated Home layout, copy, spacing, or visual style.

PHASE HEB-02 - ENTRY SCREEN BACK HANDLERS:

Goal: entry screens reached from Home should be source-aware.

For each changed page:
1. Import `package:vit_trade_flutter/core/navigation/back_navigation.dart` if
   not already available.
2. Replace parent-only back with `goBackOrFallback(... historyThenFallback)`
   where the screen can be reached from Home and directly.
3. Keep safe fallback as the feature parent unless the tracking plan records a
   different decision.
4. Keep high-risk confirmations and dirty-form behavior intact.
5. Do not convert child pages that should always return to feature parent.

Required handlers:
- Convert -> fallback Trade
- Margin -> fallback Trade
- Trading Bots -> fallback Trade
- Copy Trading -> fallback Trade
- DCA -> fallback from decision log
- Savings -> fallback `snapshot.backRoute`
- Predictions -> fallback Markets
- Withdraw next-action -> preserve safety, pop Home only when safe
- Trade pair from Home -> add or preserve source-aware back affordance
- Wallet root from Home -> implement source-aware behavior without breaking
  bottom nav/direct root semantics

PHASE HEB-03 - HOME ENTRY ROUTE MATRIX TESTS:

Goal: every meaningful Home-entry rule is covered by focused tests.

Add or update tests under `flutter_app/test/features/home/` or another suitable
focused location.

Required Home-origin tests:
- Home -> Convert -> Back returns Home
- Home -> Margin -> Back returns Home
- Home -> Bot -> Back returns Home
- Home -> Copy Trade -> Back returns Home
- Home -> DCA -> Back returns Home
- Home -> Wallet or Wallet entry route -> Back returns Home if source-aware
  back is displayed
- Home -> Savings -> Back returns Home
- Home -> Predictions -> Back returns Home
- Home -> P2P -> Back returns Home
- Home -> Launchpad -> Back returns Home
- Home -> Arena -> Back returns Home
- Home -> Rewards -> Back returns Home
- Home -> Support -> Back returns Home
- Home -> Topics -> Back returns Home
- Home -> Referral -> Back returns Home

Required direct-entry fallback tests:
- Direct Convert -> Back returns Trade
- Direct Margin -> Back returns Trade
- Direct Bot -> Back returns Trade
- Direct Copy Trade -> Back returns Trade
- Direct Savings -> Back returns Earn
- Direct Predictions -> Back returns Markets

Required deeper-flow protection test:
- Home -> P2P -> P2P child -> Back returns P2P child parent, not Home.

Use stable page types or stable keys. Avoid fragile localized text when the file
currently contains mojibake.

PHASE HEB-04 - AUDIT GUARDRAIL EXTENSION:

Goal: make Home-entry back behavior machine-checkable.

Implement one of:
1. Extend `flutter_app/tool/back_navigation_behavior_audit.dart`, or
2. Add `flutter_app/tool/home_entry_back_navigation_audit.dart`.

The audit must:
- Parse all Home outgoing route sources listed in the tracking plan.
- Emit one row per HEB item or per concrete route source.
- Detect missing Home-entry rows.
- Classify each row as:
  - `home_entry_history_ok`
  - `home_entry_parent_only`
  - `home_entry_missing_back`
  - `home_entry_high_risk_needs_review`
  - `home_entry_decision_required`
- Generate:
  - `docs/02_FLUTTER_MIGRATION/VitTrade-Home-Entry-Back-Navigation-Audit.md`
  - `docs/02_FLUTTER_MIGRATION/VitTrade-Home-Entry-Back-Navigation-Audit.csv`
- Add a strict quality test if a new audit tool is created.

If audit automation becomes too large for this pass, document the deferment
with a concrete reason and keep test coverage complete.

PHASE HEB-05 - VERIFICATION:

Run from `flutter_app/`:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/back_navigation_behavior_audit.dart --check --strict
dart run tool/navigation_edge_audit.dart --check
dart run tool/route_coverage_audit.dart --check
flutter analyze
flutter test test/core/navigation/back_navigation_test.dart --reporter=compact
flutter test test/features/home/home_page_test.dart --reporter=compact
flutter test test/app/router/critical_navigation_back_behavior_test.dart --reporter=compact
flutter test test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact
flutter test --reporter=compact
```

If a Home-entry audit tool is added, also run:

```bash
dart run tool/home_entry_back_navigation_audit.dart --check --strict
flutter test test/quality/home_entry_back_navigation_guardrail_test.dart --reporter=compact
```

PHASE HEB-06 - TRACKING PLAN UPDATE AND FINAL REVIEW:

Before final response:
1. Update `VitTrade-Home-Entry-Back-Navigation-Tracking-Plan.md`.
2. Mark each HEB row as Done, Deferred with reason, or Out of scope with reason.
3. Update decision log for DEC-001 through DEC-004.
4. Update work log with files changed and verification results.
5. Run `git diff --stat`.
6. Review touched files for unrelated churn.
7. Summarize only user-relevant changes.

SAFETY RULES:
- Never weaken wallet withdrawal, address add, P2P payment method, P2P order,
  escrow, dispute, copy-trading confirmation, futures/leverage, launchpad
  claim/receipt, profile security/API/KYC, or auth safety behavior.
- Never use external URL or unvalidated query back targets.
- Never rely on history-only pop for a deep-linkable high-risk screen.
- Never count modal close as screen back.
- Never remove existing route constants or public router facade API.
- Never alter Prediction Markets vs Open Arena product boundaries.

FINAL RESPONSE REQUIREMENTS:
- Start with the completion status.
- List the files changed.
- List the verification commands run and whether they passed.
- Call out any deferred HEB rows with exact reason.
- If all required phases are complete, include:
  HOME ENTRY BACK NAVIGATION COMPLETE
- If not complete, final line must be:
  RESUME FROM: HEB-<number> - <title>
````

