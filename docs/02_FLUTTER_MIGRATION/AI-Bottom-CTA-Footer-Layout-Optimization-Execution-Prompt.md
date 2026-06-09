# AI Bottom CTA Footer Layout Optimization Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
bottom CTA/footer layout optimization work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-CTA-Footer-Layout-Optimization-Tracking-Plan.md`

Goal: remove unnecessary fixed/floating bottom CTA bars that waste mobile
screen space, keep sticky footers where they are required for financial,
security, legal, or emergency flows, preserve all business behavior, and verify
that no content is hidden behind bottom navigation or fixed action surfaces.

This is not a request to create another plan. It is a request to execute the
existing tracking plan in order.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute every open task in this tracking plan, in order, until Bottom CTA
Footer Layout Optimization is complete:

docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-CTA-Footer-Layout-Optimization-Tracking-Plan.md

The final product must guarantee:
- Unnecessary fixed/floating bottom CTA bars are removed from DCA, Savings, and
  Launchpad settings screens listed in the plan.
- Primary actions that depend on user reading/selecting content are placed
  inline near the relevant content, summary, or form completion area.
- Sticky footers remain in high-risk financial, security, legal, and emergency
  flows where always-visible confirmation is intentional.
- `VitBottomNav` does not cover any modal, bottom sheet, CTA, or final content.
- Existing routes, providers, controllers, form state, haptics, validation,
  loading states, and preview/confirm semantics are preserved.
- Arena Studio remains inline after the earlier fix; do not regress it back to
  a sticky footer.
- Bottom sheet guardrail remains clean: no direct feature/app/shared
  `showModalBottomSheet` calls outside `shared/widgets/vit_bottom_sheet.dart`.

NON-NEGOTIABLE OUTCOME:
- Do not only analyze.
- Do not only create another prompt or plan.
- Execute the next open item from the tracking plan.
- Continue automatically to the next open item unless the user explicitly asks
  for one phase only.
- Keep edits tightly scoped to bottom CTA/footer placement and affected tests.
- Do not refactor shared `VitStickyFooter` in Phase 1 unless a specific
  acceptance criterion requires it.
- Do not rewrite app shell, bottom nav, router architecture, feature data,
  providers, business copy, theme systems, or unrelated layouts.
- Do not change high-risk financial/security/legal/emergency flows from sticky
  to inline unless the tracking plan is explicitly updated with rationale.
- Do not revert unrelated user changes in the working tree.
- Do not remove widget keys unless the relevant tests are updated in the same
  packet and the final behavior remains testable.
- Use existing VitTrade primitives and tokens:
  `VitCtaButton`, `VitCard`, `VitPageContent`, `VitPageLayout`,
  `VitAutoHideHeaderScaffold`, `VitHeader`, `VitHeaderActionItem`, and tokens
  from `flutter_app/lib/app/theme/`.
- Do not add landing-page styling, decorative blobs/orbs, new palettes, or
  unrelated visual effects.
- Process work in this exact order:
  1. BC-00 - Preflight, Current Audit, And Plan Sync
  2. BC-01 - DCA Home Floating Create Plan CTA
  3. BC-02 - DCA Rebalance Config Sticky Preview/Save
  4. BC-03 - DCA Dynamic Amount Floating Actions
  5. BC-04 - DCA Portfolio Optimizer Floating Actions
  6. BC-05 - Savings Auto Rebalance Duplicate Sticky CTA
  7. BC-06 - Launchpad Notification Sound Save Footer
  8. BC-07 - Deferred/Audit-Only Sticky Footer Verification
  9. BC-08 - Format, Analyze, Focused Tests
  10. BC-09 - Emulator/Visual QA
  11. BC-10 - Tracking Plan Update And Final Review
- Do not start a later packet while an earlier packet has failing focused
  tests, unresolved compile errors, stale checklist status, or unclear UX
  classification.
- If current scans differ from the tracking plan counts, trust current source,
  update the plan evidence, and explain the drift before continuing.
- If all packets are complete, the final response must include:
  BOTTOM CTA FOOTER OPTIMIZATION COMPLETE
- If forced to stop before all packets are complete, the final response must
  end with exactly:
  RESUME FROM: BC-<number> - <title>
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
9. docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md
10. docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-CTA-Footer-Layout-Optimization-Tracking-Plan.md
11. docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md
12. Source files listed in each packet below before editing that packet.

If documents conflict, follow this order:
1. Current user instruction
2. AGENTS.md
3. `VitTrade-Bottom-CTA-Footer-Layout-Optimization-Tracking-Plan.md`
4. Financial safety/product boundaries in AGENTS and design docs
5. Flutter Native Design Standard
6. Flutter Module Identity Standard
7. Current Flutter source and tests

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Tests: `flutter_app/test/`
- Generated QA artifacts: `flutter_app/run-artifacts/`
- App shell: `flutter_app/lib/shared/layout/vit_app_shell.dart`
- Bottom nav: `flutter_app/lib/shared/layout/vit_bottom_nav.dart`
- Shared page layout: `flutter_app/lib/shared/layout/vit_page_layout.dart`
- Bottom sheet helper: `flutter_app/lib/shared/widgets/vit_bottom_sheet.dart`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- Tracking plan:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-CTA-Footer-Layout-Optimization-Tracking-Plan.md`

PRODUCT SAFETY BOUNDARIES:
- Arena copy must remain points-only. Do not introduce payout, wallet, profit,
  stake-return, or casino-style language.
- Prediction Markets and Open Arena must remain separate.
- Wallet/P2P/copy-trading/launchpad financial actions must keep preview,
  confirmation, fee/risk/limit, and next-step semantics.
- Do not make high-risk actions less visible without explicit rationale and
  acceptance criteria.

PROBLEM CONTEXT:
The app uses `VitAppShell` with bottom navigation. Fixed or floating page-level
footers can reduce the usable mobile viewport or visually compete with
`VitBottomNav`. Arena Studio previously had a sticky `Tiep tuc` footer that
occupied the bottom of the screen even though the user had to read/select
content first. The correct pattern for that class of screen is an inline action
section near the relevant content or summary.

This optimization is not a blanket ban on sticky footers. Sticky footers are
still allowed when the action is intentionally always-visible for financial,
security, legal, or emergency reasons.

DESIGN RULES FOR THIS WORK:
- Phone-first from 360 px.
- One screen should not expose two primary CTAs for the same action.
- If a CTA depends on user reading/selecting content, place it after the
  relevant block or final summary.
- Secondary actions like share/settings/save should prefer header actions,
  compact icon buttons, or inline controls inside the relevant section.
- If a sticky footer remains, content must have enough bottom padding to scroll
  fully above it.
- Avoid nested cards. Do not put footer cards inside page-section cards.
- Keep text inside buttons short and non-overlapping on mobile.
- Icon-only actions need tooltip/semantics.
- Use theme tokens, not new local palettes.
- Keep dark professional crypto app tone.

BC-00 - PREFLIGHT, CURRENT AUDIT, AND PLAN SYNC:
Before editing:

```bash
cd flutter_app
git status --short
rg -n "VitStickyFooter\\(|_StickyActions|_FloatingActions|AddressSaveFooter|_SaveFooter|_SelectedRouteFooter|_StartFooter|_SubmissionFooter" lib/features lib/shared
rg -n "showModalBottomSheet\\(" lib test
rg -n "showVitBottomSheet" lib
rg -n "DCA|DCAPage|DCARebalance|DCADynamic|DCAPortfolio|SavingsAutoRebalance|LaunchpadNotif" test
rg -n "VitStickyFooter|_StickyActions|_FloatingActions|Positioned\\(" lib/features/arena
```

Expected baseline from the tracking plan:
- Direct `showModalBottomSheet` outside helper: 0
- `showVitBottomSheet` in feature code: 60
- `VitStickyFooter` in `flutter_app/lib/features`: 18
- Arena sticky CTA after Studio fix: 0 high-priority cases

If counts differ:
- inspect the drift
- trust current source
- update the tracking plan evidence before editing
- do not ignore newly discovered risky fixed footers

BC-01 - DCA HOME FLOATING CREATE PLAN CTA:
Read before editing:

```text
flutter_app/lib/features/dca/presentation/pages/dca_page.dart
flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart
flutter_app/lib/features/dca/presentation/pages/dca_page_part_03.dart
```

Problem:
- `Tao ke hoach moi` is currently positioned at the bottom of the page.
- The overview/hero already has create-plan actions, so the floating CTA is
  duplicated and wastes scroll space.

Implementation requirements:
- Remove the `Positioned` bottom CTA.
- Remove or reduce bottom inset that existed only for that floating CTA.
- Keep create-plan behavior and haptics intact.
- Keep `DCAPage.createPlanKey` testable. If the key moves, update tests.
- If the plans list can be empty, put a clear inline CTA in the empty state.
- Do not change DCA provider state, routes, history tab behavior, or create
  sheet internals unless required by the CTA move.

Acceptance:
- No `Positioned(bottom: stickyBottom)` create-plan CTA remains on DCA Home.
- Content scrolls naturally to the bottom without footer-reserved dead space.
- Create plan still opens the same sheet/flow.

BC-02 - DCA REBALANCE CONFIG STICKY PREVIEW/SAVE:
Read before editing:

```text
flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page.dart
flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page_part_01.dart
flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page_part_02.dart
flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page_part_03.dart
```

Problem:
- `_StickyActions` displays `Xem truoc` and `Luu cau hinh` as fixed bottom
  actions.
- The user must configure allocations/strategy first, so action belongs after
  the form or summary, not as an overlay.

Implementation requirements:
- Convert `_StickyActions` into an inline action section or replace it with an
  inline `_RebalanceActionSummary` at the end of the content.
- Remove `Positioned(bottom: stickyBottom)` for this action row.
- Recalculate bottom padding so it only accounts for bottom nav/safe area, not
  the removed CTA height.
- Keep disabled state when total allocation is not exactly 100%.
- Prefer one clear primary path: `Xem truoc` opens preview; final save happens
  inside the preview confirm sheet.
- Preserve `_PreviewSheet`, fee calculation, trade preview rows, confirm
  navigation, and keys:
  `DCARebalanceConfig.previewKey`, `saveKey`, `previewSheetKey`,
  `confirmSaveKey`.

Acceptance:
- No fixed `_StickyActions` overlay remains.
- Invalid total allocation cannot preview/save.
- Preview sheet is not covered by bottom nav.
- Existing DCA rebalance tests pass or are updated for the new inline location.

BC-03 - DCA DYNAMIC AMOUNT FLOATING ACTIONS:
Read before editing:

```text
flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page.dart
flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page_part_01.dart
flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page_part_02.dart
flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page_part_03.dart
flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page_part_04.dart
```

Problem:
- `_FloatingActions` contains a settings icon and `Ap dung chien luoc` at the
  bottom of the page.
- Settings already fits the header; apply belongs after strategy/explainer
  content.

Implementation requirements:
- Remove bottom `Positioned` `_FloatingActions`.
- Keep the existing header settings action.
- Place `Ap dung chien luoc` inline after `_StrategyExplainer` or
  `_DynamicDisclaimer`.
- Keep `DCADynamicAmount.applyKey` and `settingsKey`.
- Preserve route/snackbar behavior exactly.
- Remove bottom padding that was only needed for the floating row.

Acceptance:
- No `_FloatingActions` overlay remains in Dynamic Amount.
- Apply action remains easy to find at the end of strategy context.
- Mobile scroll reaches final content without dead space or overlap.

BC-04 - DCA PORTFOLIO OPTIMIZER FLOATING ACTIONS:
Read before editing:

```text
flutter_app/lib/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart
flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_floating_actions.dart
```

Problem:
- Floating row contains share, drift settings, and `Ap dung phan bo`.
- Share is already a header-level action pattern.
- Drift settings can live in `_DriftBanner` or header action.
- Apply belongs after optimizer/tab content.

Implementation requirements:
- Remove bottom `Positioned` `_FloatingActions`.
- Keep share behavior available through header action.
- Keep drift settings accessible through `_DriftBanner` or a compact header
  action using existing patterns.
- Place `Ap dung phan bo` inline after `_TabContent` or in the frontier summary.
- Preserve keys:
  `DCAPortfolioOptimizer.applyKey`,
  `DCAPortfolioOptimizer.driftSettingsKey`.
- Preserve route to `AppRoutePaths.dcaRebalanceConfig`.
- Remove only padding reserved for the floating row.

Acceptance:
- No optimizer floating action overlay remains.
- All tabs scroll correctly.
- Share/settings/apply do not duplicate or conflict.

BC-05 - SAVINGS AUTO REBALANCE DUPLICATE STICKY CTA:
Read before editing:

```text
flutter_app/lib/features/earn/presentation/pages/savings_auto_rebalance_page.dart
flutter_app/lib/features/earn/presentation/pages/savings_auto_rebalance_page_part_01.dart
flutter_app/lib/features/earn/presentation/pages/savings_auto_rebalance_page_part_02.dart
```

Problem:
- `_DriftStatusCard` already has inline `Xem truoc`.
- The page also adds sticky `Tai can bang ngay`.
- Both actions open the same preview, so this is duplicated and wastes space.

Implementation requirements:
- Remove sticky `VitStickyFooter` CTA from `SavingsAutoRebalancePage`.
- Keep one primary preview/rebalance action.
- Assign `SavingsAutoRebalancePage.previewButtonKey` to the remaining action.
- Improve prominence of the inline action only if needed, using existing tokens.
- Remove footer height from bottom inset when the sticky CTA is removed.
- Preserve preview sheet behavior and route/state semantics.

Acceptance:
- Only one preview/rebalance action remains.
- Preview still opens correctly.
- Tabs without action do not carry extra bottom padding.

BC-06 - LAUNCHPAD NOTIFICATION SOUND SAVE FOOTER:
Read before editing:

```text
flutter_app/lib/features/launchpad/presentation/pages/launchpad_notif_sound_page.dart
flutter_app/lib/features/launchpad/presentation/widgets/launchpad_notif_sound_footer.dart
```

Problem:
- Settings page uses a fixed save footer even when no high-risk action exists.
- Saved message can increase footer height and occupy the bottom of the screen.

Implementation requirements:
- Remove always-visible fixed save footer.
- Convert save UI into an inline action section at the end of settings content,
  or a compact dirty bar that appears only when `_hasChanges == true`.
- If using dirty bar, it must not appear when no changes exist and must not
  cover final content.
- Saved state should be an inline status or snackbar-like feedback, not a large
  persistent bottom surface.
- Preserve `_masterEnabled`, `_masterVolume`, `_vibrate`, `_doNotDisturb`,
  category state, preview sound behavior, `_hasChanges`, `_saved`, and save
  keys.

Acceptance:
- No fixed save footer is visible when there are no unsaved changes.
- Save remains obvious after the user changes a setting.
- Category/DND settings are not hidden by bottom nav or save UI.

BC-07 - DEFERRED/AUDIT-ONLY STICKY FOOTER VERIFICATION:
Do not convert the following unless the tracking plan is intentionally updated:

```text
flutter_app/lib/features/earn/presentation/pages/staking_suitability_assessment_page.dart
flutter_app/lib/features/earn/presentation/pages/staking_risk_score_calculator_page.dart
flutter_app/lib/features/trade/presentation/pages/provider_application_page.dart
flutter_app/lib/features/launchpad/presentation/pages/launchpad_swap_aggregator_page.dart
flutter_app/lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart
flutter_app/lib/features/launchpad/presentation/pages/launchpad_bridge_compare_page.dart
flutter_app/lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart
flutter_app/lib/features/launchpad/presentation/pages/launchpad_limit_orders_page.dart
flutter_app/lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart
flutter_app/lib/features/p2p/presentation/pages/p2p_ad_detail_page.dart
flutter_app/lib/features/p2p/presentation/pages/p2p_create_ad_page.dart
flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart
flutter_app/lib/features/wallet/presentation/pages/address_add_page.dart
flutter_app/lib/features/trade/presentation/pages/copy_configuration_page.dart
flutter_app/lib/features/trade/presentation/pages/copy_confirmation_page.dart
flutter_app/lib/features/trade/presentation/pages/bot_emergency_stop_page.dart
flutter_app/lib/features/trade/presentation/pages/dispute_resolution_page.dart
flutter_app/lib/features/trade/presentation/pages/complaint_submission_page.dart
flutter_app/lib/features/trade/presentation/pages/bot_optimization_page.dart
```

Verification requirements:
- Confirm each retained sticky footer has enough scroll bottom padding.
- Confirm no retained footer duplicates another primary CTA for the same action.
- Confirm disabled/loading states remain clear.
- Confirm financial/security/legal/emergency semantics are preserved.
- Document any suspicious case in the tracking plan instead of silently
  changing it.

BC-08 - FORMAT, ANALYZE, FOCUSED TESTS:
Run from `flutter_app/` after implementation:

```bash
dart format .
flutter analyze
flutter test test/quality/bottom_sheet_guardrail_test.dart --reporter=compact
flutter test test/features/dca --reporter=compact
flutter test test/features/earn --reporter=compact
flutter test test/features/launchpad --reporter=compact
```

Also run any more focused tests discovered in BC-00. If a module has no focused
tests for a changed screen, add or update tests where practical.

If shared layout or broad behavior was touched, run:

```bash
flutter test --reporter=compact
```

Do not ignore analyzer/test failures. If a failure is unrelated and pre-existing,
record the evidence and continue only if it does not hide a regression from this
work.

BC-09 - EMULATOR/VISUAL QA:
Use an Android emulator/device when available. Validate at least the changed
screens:

- DCA Home
- DCA Rebalance Config
- DCA Dynamic Amount
- DCA Portfolio Optimizer
- Savings Auto Rebalance
- Launchpad Notification Sound

For each screen:
- launch/navigate to the screen
- scroll to the bottom
- confirm final content is visible and not covered by `VitBottomNav`
- confirm primary CTA is inline or conditionally compact as intended
- confirm no duplicated primary CTA remains
- capture screenshots in `flutter_app/run-artifacts/` when layout changed
  materially

If emulator is unavailable, state that clearly in the final response and list
which visual checks were not performed.

BC-10 - TRACKING PLAN UPDATE AND FINAL REVIEW:
Update:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-CTA-Footer-Layout-Optimization-Tracking-Plan.md
```

Required updates:
- Mark each completed P1-P6 item as done.
- Add concise implementation notes under each completed item.
- Mark deferred/audit-only items with rationale if inspected.
- Update baseline counts if scans changed.
- Record commands/tests run and results.
- Record emulator/screenshot evidence paths if created.
- Record unresolved unrelated failures separately.

Before final response, re-run or re-check:

```bash
cd flutter_app
rg -n "showModalBottomSheet\\(" lib test
rg -n "VitStickyFooter\\(|_StickyActions|_FloatingActions" lib/features/dca lib/features/earn lib/features/launchpad
rg -n "VitStickyFooter|_StickyActions|_FloatingActions|Positioned\\(" lib/features/arena
```

Final response requirements:
- Summarize files changed.
- Summarize which P1-P6 items are complete.
- Summarize tests and emulator QA.
- Mention any skipped/deferred item and why.
- If complete, include:
  BOTTOM CTA FOOTER OPTIMIZATION COMPLETE
- If incomplete, final line must be:
  RESUME FROM: BC-<number> - <title>

````

