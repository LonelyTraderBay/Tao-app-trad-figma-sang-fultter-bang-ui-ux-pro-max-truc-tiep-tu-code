# AI Button System Standardization Autonomous Execution Prompt

> **Shared contract:** [`docs/01_AI_RULES/AI_PROMPT_SHELL.md`](../01_AI_RULES/AI_PROMPT_SHELL.md)

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the VitTrade button system standardization plan automatically, in order, without
stopping midway, while using available skills, GitNexus MCP, focused Flutter
tests, Android emulator QA, and context-saving workflows efficiently.

This is an execution prompt. It is not a request to create another plan.

Plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Button-System-Standardization-Execution-Plan.md
```

Primary source files and folders:

```text
flutter_app/lib/app/theme/
flutter_app/lib/shared/layout/
flutter_app/lib/shared/widgets/
flutter_app/lib/features/
flutter_app/test/
flutter_app/tool/
docs/03_DESIGN_SYSTEM/
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo (repo root).

Follow docs/01_AI_RULES/AI_PROMPT_SHELL.md for shared rules, GitNexus, Headroom,
verification, and batch discipline.

PRIMARY OBJECTIVE

Execute this plan completely:

docs/03_DESIGN_SYSTEM/VitTrade-Button-System-Standardization-Execution-Plan.md

Standardize all button-like UI across the Flutter app into one coherent
enterprise-grade button system:

- Full-width and sticky CTAs.
- Buy, sell, destructive, warning, secondary, ghost, auth, and disabled actions.
- Header icon actions.
- Inline icon actions.
- Segmented controls.
- Choice, filter, payment, amount, percent, and status chips.
- Toggle/switch style controls.
- Card/tile actions built with InkWell or GestureDetector.
- Dialog actions in high-risk financial flows.
- All 378 current page files reviewed through a durable inventory.
- P2P Create Ad, P2P order/payment/escrow/dispute, Wallet, and Trade critical
  flows standardized first.
- Financial safety, route structure, module boundaries, providers, and domain
  contracts preserved unless a narrow, justified change is unavoidable.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT

- Do not create another plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which phase to run next when the plan defines the order.
- Do not jump to random pages.
- Do not stop after one page, one module, one passing audit, or one passing
  focused test if eligible work remains.
- If a task is already complete, verify it from current source/audits/tests,
  record evidence, and continue.
- If one task is blocked but another eligible task remains, continue to the
  next eligible task in the plan order.
- If a tool output is large, compress/summarize it and continue.

NON-STOP CONTRACT

Keep executing automatically until exactly one of these stop conditions is true:

1. Phase 6 final app-wide closure in
   `VitTrade-Button-System-Standardization-Execution-Plan.md` passes.
2. A real blocker prevents all further progress after at least 3 concrete
   recovery attempts and no eligible fallback task remains.
3. A hard tool/platform failure prevents further commands or edits after the
   agent has already tried the next eligible path.
4. GitNexus impact is HIGH or CRITICAL and the user has not acknowledged the
   risk.
5. The user explicitly asks you to stop, pause, or change direction.

The following are not valid stopping reasons:

- A phase is complete.
- Focused tests passed.
- Full tests passed before the final plan gate is complete.
- The next phase is ready.
- The route or page list is long.
- The work is repetitive.
- Context is getting long; use Headroom, targeted reads, and concise updates.
- One non-critical test fails; debug it and continue.

If the final gate passes, end the final response with exactly:

```text
BUTTON SYSTEM STANDARDIZATION COMPLETE
```

If a valid stop condition forces an early handoff, end the final response with
exactly:

```text
RESUME FROM: <phase> - <exact next task/page/widget>
```

Do not write anything after the `RESUME FROM:` line.

MANDATORY READING BEFORE CODE EDITS

Follow AI_PROMPT_SHELL.md, then read for the active batch only:

1. `docs/03_DESIGN_SYSTEM/VitTrade-Button-System-Standardization-Execution-Plan.md`
2. Current source files and tests for the active batch only.

Do not load the entire repository into context. Use GitNexus, targeted reads, and Headroom.

DOCUMENT PRECEDENCE

If documents disagree:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundaries win over visual cleanup.
5. `VitTrade-Button-System-Standardization-Execution-Plan.md` defines this
   work order.
6. Current generated audit artifacts define measurable status.
7. Older tracking docs that conflict with current Flutter source are historical.

SOURCE OF TRUTH

- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Feature pages: `flutter_app/lib/features/<feature>/presentation/pages/`
- Feature widgets: `flutter_app/lib/features/<feature>/presentation/widgets/`
- Tests: `flutter_app/test/`
- Generated QA artifacts: `flutter_app/run-artifacts/`

REQUIRED SKILLS

Use these skills when available, with progressive disclosure:

1. `planning-and-task-breakdown`
   - Use only to keep the existing plan sliced into small batches.
   - Do not produce a replacement plan.

2. `vittrade-ui-checklists`
   - Use for Flutter-safe UI rules, accessibility, disabled states, financial
     safety, shared primitives, density, and emulator QA expectations.

3. `frontend-ui-engineering`
   - Use when editing shared widgets or feature UI.
   - Keep the UI production-quality and phone-first.

4. `incremental-implementation`
   - Use for every multi-file batch.
   - Keep edits small, compile after each batch, and do not mix unrelated
     modules.

5. `test-driven-development`
   - Use when changing validation, disabled states, button enablement, or
     shared widget behavior.
   - Add/update focused tests before or alongside behavior changes.

6. `debugging-and-error-recovery`
   - Use when analyze, tests, build, emulator, or route/audit checks fail.
   - Fix root cause; do not hide failures.

7. `code-review-and-quality`
   - Use before final closure and before any broad shared primitive handoff.
   - Review for regressions, missing tests, and behavior drift.

8. `ui-ux-pro-max`
   - Use only for design-system direction when visual choices are unclear.
   - Keep VitTrade tokens and current Flutter source authoritative.

9. GitNexus skills
   - `gitnexus-exploring` for finding flows/pages/components.
   - `gitnexus-impact-analysis` before editing any symbol.
   - `gitnexus-refactoring` only if a real rename/extraction is required.

10. `test-android-apps:android-emulator-qa`
    - Use for emulator validation after visual behavior changes.
    - Capture screenshots for representative final screens.

Relevant skills should be read once per session and then applied. Do not spend
tokens re-reading unrelated skill bodies.

REQUIRED MCP AND TOOL USAGE

Use the available MCP/tools efficiently:

1. GitNexus MCP
   - `query()` to find button-related flows, shared widgets, and active pages.
   - `context()` to inspect `VitCtaButton`, `VitIconButton`,
     `VitHeaderActionButton`, `VitTabBar`, `VitTogglePill`, and active page
     symbols.
   - `impact({direction: "upstream"})` before editing any class/method/function.
   - `rename()` only for symbol renames. Never manual find/replace for renames.
   - `detect_changes({scope: "all"})` after implementation batches and before
     final response.

2. Headroom MCP
   - Use `headroom_compress` for large audit outputs, route lists, grep results,
     test logs, and inventory snapshots.
   - Retrieve only needed details with `headroom_retrieve`.

3. Shell
   - Use `rg` and `rg --files` before slower searches.
   - Use PowerShell from repo root or `flutter_app/` as appropriate.
   - Do not use destructive git commands.
   - Do not use shell writes for code/docs. Use `apply_patch` for manual edits.

4. Multi-tool parallelism
   - Use parallel reads for independent files, `rg`, `git status`, and test/audit
     discovery.
   - Do not parallelize commands that mutate the same files or build artifacts.

5. Android emulator QA
   - Use adb-driven build/install/launch/screenshot when UI visual behavior
     changes.
   - Prefer representative screens rather than exhaustive emulator screenshots
     for every page.

TOKEN-SAVING OPERATING MODE

Work in compact execution loops:

1. Read only the active plan section, active source files, active tests, and
   relevant shared primitive.
2. Prefer `rg` snippets with line numbers over opening huge files.
3. Use GitNexus to find symbols and blast radius instead of broad manual
   browsing.
4. Compress large outputs with Headroom.
5. Keep inventory summaries concise.
6. Do not paste long test logs into final responses; report command and result.
7. Do not re-run full app tests after every small page; run focused tests per
   batch, then full final gate.
8. Keep user updates short and specific.

INITIAL BASELINE COMMANDS

Run these before code edits:

```powershell
cd flutter_app
flutter pub get
flutter analyze
```

Run button usage inventory:

```powershell
cd flutter_app
rg -n "\b(VitCtaButton|VitIconButton|VitHeaderActionButton|VitTogglePill|VitTabBar|TextButton|IconButton|ElevatedButton|OutlinedButton|FilledButton|ActionChip|InkWell|GestureDetector)\b" lib --glob "*.dart"
```

Run page coverage inventory:

```powershell
cd ..
$root=(Resolve-Path .).Path
$pages=Get-ChildItem -Path "flutter_app\lib\features" -Recurse -Filter "*_page.dart" |
  Where-Object { $_.FullName -match "\\presentation\\pages\\" }
$pages | ForEach-Object { $_.FullName.Substring($root.Length+1) } | Sort-Object
"TOTAL_PAGES=$($pages.Count)"
```

Run local class inventory:

```powershell
cd flutter_app
rg -n "^(class|final class|enum)\s+[A-Za-z_][A-Za-z0-9_]*(Button|Chip|Toggle|Tab|Tabs)\b" lib\shared lib\features --glob "*.dart"
```

Create or refresh a working inventory under:

```text
flutter_app/run-artifacts/button-system-standardization-inventory.md
```

The inventory must include:

- Page/widget path.
- Feature module.
- Current button-like controls.
- Canonical replacement or keep reason.
- Financial risk level.
- Tests touched or test gap.
- Status: todo, in_progress, done, deferred.
- Notes.

Do not trust memory. Update the inventory after every batch.

CANONICAL BUTTON TAXONOMY

Map every button-like control to one of these families:

1. Primary CTA
   - `VitCtaButton`
   - final actions, form submit, trade action, publish action, continue action

2. Secondary CTA
   - `VitCtaButtonVariant.secondary`
   - `VitCtaButtonVariant.ghost`
   - preview, back, export, details, lower-emphasis route action

3. Destructive/Risk CTA
   - `VitCtaButtonVariant.danger`
   - `VitCtaButtonVariant.destructive`
   - `VitCtaButtonVariant.warning`
   - cancel, delete, revoke, blacklist, sell, risk review

4. Header icon action
   - `VitHeaderActionButton`
   - `VitHeaderActionItem`
   - search, notifications, filter, settings, export, share, add, refresh

5. Inline icon action
   - `VitIconButton`
   - `VitInlineIconAction`
   - copy, refresh, remove, edit, compact row action

6. Segmented control
   - `VitTabBar(variant: VitTabBarVariant.segment)` when suitable
   - Add shared `VitSegmentedControl` only if required and additive

7. Choice/filter/payment/amount/percent chip
   - Use shared chip primitive if present
   - If absent, create additive `VitChoicePill` or equivalent shared primitive
     before migrating local chip families

8. Toggle/switch
   - `VitTogglePill` plus row semantics where needed
   - Native `Switch` only when justified

9. Card/tile action
   - `VitCard(onTap: ...)`
   - `VitActionTileGrid`
   - `VitDiscoveryActionCard`
   - `VitNextActionCard`

10. Dialog action
   - `TextButton` may remain in simple dialogs if themed and justified
   - High-risk confirm/cancel must remain clear and risk-toned

IMPLEMENTATION ORDER

Follow this exact order. Do not jump around.

PHASE 0 - READ-ONLY AUDIT AND SAFETY SETUP

1. Read mandatory docs.
2. Run baseline commands.
3. Build the inventory.
4. Identify direct Material button usage.
5. Identify local `*Button`, `*Chip`, `*Toggle`, `*Tab`, `*Tabs` controls.
6. Classify by taxonomy.
7. Identify high-risk financial flows.
8. Do not edit code in this phase.

Checkpoint:

- Inventory exists.
- All current page files are accounted for.
- No code edits were made.

PHASE 1 - SHARED BUTTON FOUNDATION

Primary files:

```text
flutter_app/lib/shared/widgets/vit_cta_button.dart
flutter_app/lib/shared/widgets/vit_icon_button.dart
flutter_app/lib/shared/widgets/vit_tab_bar.dart
flutter_app/lib/shared/widgets/vit_toggle_pill.dart
flutter_app/lib/shared/widgets/widgets.dart
```

Possible additive files:

```text
flutter_app/lib/shared/widgets/vit_choice_pill.dart
flutter_app/lib/shared/widgets/vit_segmented_control.dart
```

Steps:

1. Run GitNexus impact for each shared symbol before editing.
2. Add only backward-compatible APIs.
3. If creating `VitChoicePill`, support:
   - selected/unselected
   - disabled
   - compact/standard density
   - primary/success/danger/warning/neutral tones
   - optional leading/trailing icon
   - single-select and multi-select usage
   - semantics label and selected state
4. If creating `VitSegmentedControl`, support:
   - tokenized height/radius/padding
   - equal-width and content-width modes
   - selected/unselected
   - buy/sell/primary/accent tones
   - no text overflow at 360 px
5. Add/update shared widget tests.
6. Export new shared widgets from `widgets.dart`.

Verification:

```powershell
cd flutter_app
dart format .
flutter test test/shared/widgets/vit_shared_widgets_test.dart --reporter=compact
flutter analyze
```

PHASE 2 - P0 FINANCIAL CRITICAL FLOWS

Process in this exact order:

1. P2P Create Ad
2. P2P order/payment/escrow/dispute
3. Wallet withdraw/deposit/transfer/address
4. Trade order entry/settings/futures/margin/copy

PHASE 2.1 - P2P CREATE AD PAGE

Files:

```text
flutter_app/lib/features/p2p/presentation/pages/p2p_create_ad_page.dart
flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_page_sections.dart
flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_choice_chips.dart
flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart
flutter_app/test/features/p2p/p2p_create_ad_page_test.dart
flutter_app/test/features/p2p/p2p_controller_test.dart
```

Required work:

- Replace local segment visual contract with canonical segment control.
- Replace local asset/currency/payment/window chips with canonical choice pill.
- Keep final sticky CTA as `VitCtaButton`.
- Add visible disabled reason near sticky CTA:
  - missing price
  - missing total amount
  - missing payment method
  - submitting state
- Distinguish payment method chips from payment-window chips.
- Preserve publish validation.
- Preserve confirmation dialog.
- Preserve escrow/risk review copy.

Acceptance:

- Initial disabled publish state explains why.
- Price + total + at least one payment method enables CTA.
- Payment window alone does not enable CTA.
- Buy/sell tone matches the app button system.
- No bottom-nav overlap at 360 px.

Verification:

```powershell
cd flutter_app
flutter test test/features/p2p/p2p_create_ad_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_controller_test.dart --reporter=compact
flutter analyze
```

PHASE 2.2 - P2P ORDER, ESCROW, PAYMENT, DISPUTE BATCH

Initial pages:

```text
p2p_order_page.dart
p2p_order_cancel_page.dart
p2p_order_proof_page.dart
p2p_order_rate_page.dart
p2p_payment_method_add_page.dart
p2p_payment_method_verification_page.dart
p2p_payment_method_ownership_page.dart
p2p_payment_method_cooling_period_page.dart
p2p_dispute_page.dart
p2p_dispute_detail_page.dart
p2p_dispute_evidence_page.dart
p2p_dispute_resolution_page.dart
p2p_escrow_detail_page.dart
p2p_escrow_balance_page.dart
```

Required work:

- Migrate local small buttons to shared primitives.
- Keep high-risk confirmation and evidence states.
- Use destructive tone for cancel/delete/revoke/blacklist.
- Use warning tone for suspicious/risk review.
- Add disabled reason where action is blocked.

Verification:

```powershell
cd flutter_app
flutter test test/features/p2p --reporter=compact
flutter analyze
dart run tool/visual_density_risk_audit.dart --check
```

PHASE 2.3 - WALLET CRITICAL BATCH

Initial pages:

```text
wallet_page.dart
deposit_page.dart
withdraw_page.dart
withdraw_limits_page.dart
transfer_page.dart
address_book_page.dart
address_add_page.dart
wallet_token_approval_page.dart
wallet_multi_manager_page.dart
transaction_detail_page.dart
transaction_history_page.dart
```

Required work:

- Standardize withdraw/deposit/transfer CTAs.
- Standardize copy, scan, refresh, add address, revoke, approve, details.
- Preserve address masking and confirmations.
- Do not hide fees/limits/risk copy.

Verification:

```powershell
cd flutter_app
flutter test test/features/wallet --reporter=compact
flutter analyze
```

PHASE 2.4 - TRADE CRITICAL BATCH

Initial pages:

```text
trade_page.dart
trade_settings_page.dart
futures_page.dart
leverage_page.dart
margin_trading_page.dart
margin_trading_hub_page.dart
order_receipt_page.dart
orders_history_page.dart
copy_trading_page.dart
copy_confirmation_page.dart
copy_provider_detail_page.dart
copy_settings_page.dart
```

Required work:

- Standardize buy/sell/order submit buttons.
- Standardize percent buttons, order type tabs, leverage controls, copy action
  buttons, and receipt copy/export actions.
- Preserve order confirmation and risk review.
- Keep trade page compact and bottom-nav safe.

Verification:

```powershell
cd flutter_app
flutter test test/features/trade --reporter=compact
flutter analyze
```

Checkpoint after Phase 2:

```powershell
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
flutter test test/features/p2p --reporter=compact
flutter test test/features/wallet --reporter=compact
flutter test test/features/trade --reporter=compact
```

PHASE 3 - P1 FULL P2P COMPLETION

Finish every P2P page listed in the plan.

Batch rules:

- Work 5 to 8 P2P pages per batch.
- Prefer pages with high direct Material/local button usage first.
- Update inventory after each page.
- Run P2P focused tests after each batch.

Verification after every P2P batch:

```powershell
cd flutter_app
flutter test test/features/p2p --reporter=compact
flutter analyze
```

PHASE 4 - P2 TRADE, WALLET, MARKETS, AUTH, PROFILE

Process modules in this order:

1. Remaining `trade` pages.
2. Remaining `wallet` pages.
3. `markets` pages.
4. `auth` pages.
5. `profile` pages.

Rules:

- One feature module at a time.
- Do not mix unrelated modules.
- Keep auth accessible.
- Keep security/profile destructive actions explicit.

PHASE 5 - P3 REMAINING PRODUCT MODULES

Process modules in this order:

1. `earn`
2. `launchpad`
3. `dca`
4. `predictions`
5. `arena`
6. `referral`, `support`, `news`, `notifications`, `discovery`, `rewards`
7. `admin`, `dev`, `enterprise_states`

Rules:

- Arena remains points-only.
- Predictions may use positions/probability/PnL; avoid hype.
- Earn/staking keeps lockup/risk disclosures.
- Launchpad keeps contract/security warnings.
- Dev pages may demonstrate components but must not define a second product
  button system.

PHASE 6 - FINAL APP-WIDE CLOSURE

Run:

```powershell
cd flutter_app
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Run GitNexus:

```text
detect_changes({scope: "all"})
```

Confirm changed symbols and affected flows match the button standardization
scope.

Run Android emulator QA on representative screens:

- Home
- Markets overview and one pair detail
- Trade page
- Wallet page and withdraw/deposit flow entry
- P2P create ad
- P2P order/dispute representative screen
- Profile/security representative screen

Capture screenshots into:

```text
flutter_app/run-artifacts/
```

HIGH-RISK FINANCIAL SAFETY RULES

Never weaken these flows:

- Withdrawals.
- Escrow release.
- P2P payment-method changes.
- P2P ad publishing.
- P2P dispute evidence and resolution.
- Address add/delete.
- API key/security settings.
- Copy trading confirmation.
- Futures/margin/leverage order actions.

For these flows:

- Disabled CTA must explain why when user action is blocked.
- CTA must show loading/submitting state while action is in progress.
- Confirmation must include risk/fee/limit/next step when relevant.
- Destructive actions must not use primary/success tone.

PER-EDIT SAFETY LOOP

For every file batch:

1. Read active source and test files.
2. Use GitNexus `context()` for important symbols.
3. Use GitNexus `impact()` before editing any class/method/function.
4. If impact is HIGH or CRITICAL, stop and warn the user.
5. Apply the smallest patch.
6. Format.
7. Run focused tests.
8. Run analyze.
9. Update inventory.
10. Continue to next eligible task.

CODE EDITING RULES

- Use `apply_patch` for manual edits.
- Do not use Python or shell redirection to write source files.
- Do not change unrelated files.
- Do not revert user changes.
- Do not run destructive git commands.
- Keep imports as `package:vit_trade_flutter/...` across modules.
- Prefer existing shared primitives and tokens.
- Add shared abstraction only when it removes real duplication and supports
  multiple screens.
- Do not create local palettes, spacing systems, radii, or button styles.

TESTING RULES

Use focused tests while in batches:

```powershell
flutter test test/shared/widgets/vit_shared_widgets_test.dart --reporter=compact
flutter test test/features/p2p --reporter=compact
flutter test test/features/wallet --reporter=compact
flutter test test/features/trade --reporter=compact
```

Use full tests only at major checkpoints/final gate unless shared widget changes
are broad enough to require earlier full coverage.

If a focused feature test directory does not exist:

1. Search for nearest page tests with `rg`.
2. Run relevant quality tests.
3. Document the test gap in inventory and final summary.

DEBUGGING RULES

If tests or analyze fail:

1. Read the first real error.
2. Use `debugging-and-error-recovery`.
3. Fix root cause.
4. Re-run the failing command.
5. Continue.

Do not ignore failing tests or audits. Do not remove tests to pass.

EMULATOR QA RULES

Use Android emulator QA after visual behavior changes to representative screens.

Typical flow:

```powershell
cd flutter_app
flutter build apk --debug
adb devices
adb -s <serial> install -r "build\app\outputs\flutter-apk\app-debug.apk"
adb -s <serial> shell monkey -p com.vittrade.vit_trade_flutter -c android.intent.category.LAUNCHER 1
adb -s <serial> shell screencap -p /sdcard/vittrade-button-system.png
adb -s <serial> pull /sdcard/vittrade-button-system.png "run-artifacts\vittrade-button-system.png"
```

Use `uiautomator dump` when selecting/tapping targets. Compute tap coordinates
from UI tree bounds, not screenshots.

REPORTING DURING WORK

Every 30 seconds or after meaningful milestones, report briefly:

- Current phase/batch.
- Files being touched.
- Tests/audits running.
- Any blocker and recovery path.

Keep updates concise. Do not paste large logs.

FINAL RESPONSE FORMAT

If complete:

- Summarize phases completed.
- List files changed by category.
- Report tests/audits/emulator QA.
- Report GitNexus `detect_changes()` result.
- Mention any deferred documented exceptions.
- End with exactly:

```text
BUTTON SYSTEM STANDARDIZATION COMPLETE
```

If blocked:

- State the blocker briefly.
- State recovery attempts.
- State the exact next task/page/widget.
- End with exactly:

```text
RESUME FROM: <phase> - <exact next task/page/widget>
```

Do not write anything after the `RESUME FROM:` line.
````

