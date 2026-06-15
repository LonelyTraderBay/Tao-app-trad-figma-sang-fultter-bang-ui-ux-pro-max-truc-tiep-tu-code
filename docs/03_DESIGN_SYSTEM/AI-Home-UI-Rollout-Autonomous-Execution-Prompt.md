# AI Home UI Rollout Autonomous Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
Home UI rollout across the Flutter app from start to finish.

This prompt is not a request to create another plan. It is a request to execute
the existing rollout plan in strict order, without skipping screens, without
stopping at analysis, and without applying shared components blindly.

Use this prompt when the goal is:

- Apply Home as the visual foundation for other screens.
- Keep UI consistent through shared components, design tokens, and safety rules.
- Track every screen entry file so no screen is missed.
- Work in token-efficient batches.
- Continue through P0, P1, P2, and P3 until all eligible screens are `Done`,
  `Blocked`, or explicitly `Deferred` with a reason.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the Home UI rollout across the Flutter app using:

docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md
docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md

The goal is to make Home the UI foundation for the whole project while keeping
business logic, financial safety, routes, providers, copy boundaries, and
module identity intact.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT:

- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not skip directly to random screen edits.
- Do not ask the user which screen to do next; follow the execution plan.
- Do not stop while there are eligible `Not started` screens in the current
  priority group.
- Continue in order: P0 -> P1 -> P2 -> P3.
- If a screen is already compliant, verify it from source/tests, mark it `Done`,
  record evidence, and continue.
- If a screen is blocked by missing product/design decisions or a shared
  primitive gap, mark it `Blocked` with a precise reason and continue to the
  next eligible screen in the batch/module.
- If a screen is intentionally skipped because it is obsolete/internal/demo,
  mark it `Deferred` with the reason and continue.
- Do not mark a screen `Done` until code, tests/audits, and safety checks pass
  for that batch.

MANDATORY READ BEFORE EDITING:

Read enough of each file to follow current rules before the first edit:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-UX-Layer-Analysis-Report.md`
7. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
8. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md`
9. `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`
10. `flutter_app/lib/shared/widgets/widgets.dart`
11. Current source and tests for the active batch only.

If documents conflict:

1. Source code and financial safety rules win.
2. `AGENTS.md` and `docs/00_START_HERE.md` define repo execution rules.
3. `Guidelines.md` defines product/design principles.
4. `VitTrade-Home-UI-Rollout-Playbook.md` defines UI pattern rules.
5. `VitTrade-Home-UI-Rollout-Execution-Plan.md` defines rollout order,
   inventory, batch status, and verification.

CURRENT HOME BASELINE CONTRACT:

Before migrating any non-Home module, verify the current Home baseline from:

- `flutter_app/lib/features/home/presentation/pages/home_page.dart`
- `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`
- `flutter_app/lib/features/home/presentation/pages/home_page_part_02.dart`
- `flutter_app/lib/features/home/presentation/pages/home_page_part_03.dart`
- `flutter_app/test/features/home/home_page_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`

Treat these current Home decisions as the rollout contract:

- Home root-page bundle must remain `pass` with `totalDebt=0`.
- Home visual order is:
  compact announcement -> portfolio hero -> next action -> market ticker ->
  products -> recent -> discovery -> market/full lists.
- `HomeSurfaceOrder.productsBeforeRecent` is the default surface policy.
- `HomeDensityVariant.compact` applies at phone width `<= 480`.
- Compact Home shows `6` primary quick actions; comfortable Home shows `9`.
  Overflow actions go to the shared sheet through `VitActionTileGrid` and
  `VitSheetPanel`.
- Announcements render only when active and type is `campaign`, `security`, or
  `risk`. `info` announcements do not surface on Home.
- Campaign announcements may auto-hide for the session after the user scrolls
  past `96dp`. Security and risk announcements must not auto-hide because of
  scroll.
- The early market ticker uses `VitMarketTickerStrip` before the products
  section so trading discovery appears in the first viewport rhythm.
- Prediction Markets and Open Arena discovery keep local business copy but use
  shared visual primitives, especially `VitDiscoveryActionCard.compact`.
- Home tabs use text labels plus icons, never emoji labels.

Do not roll back these guardrails while migrating other modules:

- Do not reintroduce local Home visual classes such as `_Dot`,
  `_PortfolioGlow`, `_DiscoveryCard`, `_NextActionCard`, local section header,
  local avatar, local sparkline painter, or local status pill when shared
  primitives exist.
- Do not reintroduce `Container(`, `BoxDecoration(`, raw `EdgeInsets.*(`,
  `BorderRadius.circular(`, or `Radius.circular(` in the Home page bundle.
- Do not move `VitBottomNav` into `HomePage`; bottom navigation stays in the
  app shell.

CORE SHARED-COMPONENT RULE:

Do not force every screen to use every shared component.

Apply shared components by level:

- L0 - Token compliance: mandatory for every screen.
  Use `AppColors`, `AppSpacing`, `AppTextStyles`, `AppModuleAccents`.
  Do not introduce local palettes, random font sizes, raw spacing, raw radii,
  or local decoration in page bundles when tokens/shared primitives cover it.

- L1 - Shared layout: mandatory when matching shell/content/card/state exists.
  Prefer `VitPageLayout`, `VitPageContent`, `VitHeader`, `VitTopChrome`,
  `VitInsetScrollView`, `VitCard`, `VitCtaButton`, and shared state widgets.

- L2 - Pattern shared: mandatory when the UI pattern matches.
  Use `VitMarketPairRow`, `VitRankedAssetRow`, `VitMarketTickerStrip`,
  `VitActionTileGrid`, `VitServiceTile`, `VitDiscoveryActionCard`,
  `VitHighRiskStatePanel`, `VitInput`, `VitTabBar`, `VitStatusPill`,
  `VitAccentPill`, `VitAssetAvatar`, and `VitSparkline` when applicable.

- L3 - Domain local: allowed when the composition owns business boundaries,
  provider state, route logic, financial safety copy, or Arena points-only copy.
  If you keep a local composition, record why in the batch notes.

HARD PRODUCT AND SAFETY RULES:

- Do not change routes, providers, mock/remote repositories, or domain models
  unless required to fix a UI compile/test issue.
- Do not weaken masking for wallet, account, email, phone, address, or payment
  identifiers.
- Wallet/Trade/P2P must preserve fees, limits, risk copy, preview/confirm,
  and next-step language.
- Trade and Markets must use tabular figures for price, amount, percentage,
  volume, probability, P/L, APY, and balances.
- `AppColors.buy` and `AppColors.sell` are for semantic movement/side/state,
  not decoration.
- Prediction Markets may use positions, probability, receipts, rewards, and
  P/L. Do not merge this language with Arena.
- Arena is points-only. Never use wallet, payout, profit, stake-return, USD
  payout, or P/L language in Arena screens.
- Module pages must not copy `VitTopChromeType.rootBrand` from Home unless the
  screen is a true app-root surface.
- Do not use emojis as UI icons.
- Do not refactor unrelated layout/business logic during a UI migration batch.

AUTONOMOUS EXECUTION ORDER:

Follow the module priority order from the execution plan:

1. P0: `wallet`, `trade`, `p2p`
2. P1: `markets`, `profile`, `auth`, `onboarding`, `notifications`, `support`
3. P2: `predictions`, `arena`, `earn`, `dca`, `launchpad`
4. P3: `discovery`, `cross_module`, `referral`, `rewards`, `news`, `admin`,
   `dev`, `enterprise_states`
5. Keep `home` as the reference foundation; do not redesign Home unless a
   specific Home regression is found.

For each module:

1. Open the module row in `VitTrade-Home-UI-Rollout-Execution-Plan.md`.
2. Select the next 2-5 `Not started` screen entry files from the screen
   inventory.
3. Read only those screens, their local widgets, shared components they use,
   and related tests.
4. Map each screen to one playbook pattern:
   `command center`, `financial hero`, `market/data list`, `high-risk form`,
   `confirmation/receipt`, `profile/settings`, `points-only/social`, or
   `support/info`.
5. Apply L0 and L1. Apply L2 when the pattern matches. Keep L3 local only with
   a recorded reason.
6. Add/update focused tests when behavior or visible UI contract changes.
7. Run required focused verification.
8. Update the batch log/status in the execution plan.
9. Continue to the next batch in the same priority group.

BATCH SIZE:

- Default: 2-5 screen entry files.
- Use 2 screens for high-risk financial forms or screens with many local
  widgets.
- Use 3-5 screens for simple info/support/list pages.
- Do not include `*_part_*.dart` as separate screens. Treat them as part of the
  parent entry file.

DEFINITION OF DONE FOR A SCREEN:

A screen is `Done` only when:

- Its page bundle uses tokens/shared primitives according to L0/L1/L2/L3.
- It applies the closest Home baseline pattern or records why a different
  pattern is required.
- No matching shared primitive was ignored without a reason.
- Business logic, routes, providers, keys, masking, and safety copy are
  preserved.
- Loading, empty, error, offline, submitting, and success states are preserved
  or improved where the flow can enter those states.
- First viewport remains usable at 360dp; bottom chrome does not cover critical
  text or controls.
- Focused tests and required audits for the batch pass, or an external blocker
  is documented precisely.
- The execution plan batch log is updated.

REQUIRED VERIFICATION:

For every single-module UI batch, run from `flutter_app/`:

```bash
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test test/features/<module> --reporter=compact
```

For high-risk financial screens, also run relevant guardrails/tests:

```bash
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
```

For header/top-chrome changes, run relevant top-header guardrails:

```bash
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_action_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_global_access_policy_guardrail_test.dart --reporter=compact
```

For shared primitive or cross-module batches, run:

```bash
dart run tool/design_token_consistency_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Run responsive visual QA or emulator screenshot checks when a batch changes:

- first viewport hierarchy
- bottom nav/chrome clearance
- dense grids
- market rows
- high-risk forms
- hero cards
- shared layout primitives

TRACKING UPDATE REQUIREMENT:

After every completed batch, update:

docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md

Update the batch log with:

- Date
- Batch id
- Module
- Screens
- Home pattern applied
- L3 local reason, or `None`
- First viewport evidence
- Tests/audit evidence
- Status
- Notes, including any L3 local composition reasons

Also update module status if all screens in the module are complete, blocked,
or deferred.

DO NOT STOP EARLY:

Keep working until one of these is true:

- All eligible screens in P0, P1, P2, and P3 are `Done`, `Blocked`, or
  `Deferred`.
- The same external blocker prevents progress for three consecutive attempts
  and no other eligible screen remains unblocked.
- The user explicitly tells you to stop or pause.

If tests fail:

1. Diagnose whether the failure is caused by the current batch.
2. Fix current-batch regressions immediately.
3. If an audit artifact is stale, regenerate the required artifact with the
   matching tool, then rerun the guardrail.
4. If a failure is unrelated and pre-existing, document it in the batch notes,
   continue only if it does not invalidate the current batch, and do not hide
   the failure.

OUTPUT STYLE:

- Keep user updates short and concrete.
- Do not produce broad redesign essays.
- Do not paste huge source files into the response.
- Report completed batch, files changed, tests run, and next batch.
- When finalizing a large run, summarize module statuses and remaining blockers.
````

## First Batch Recommendation

Start with P0 Wallet:

```text
Batch id: P0.Wallet.01
Module: wallet
Screens:
- wallet_page.dart
- deposit_page.dart
- withdraw_page.dart
- transfer_page.dart

Why:
- They are financial entry points.
- They validate the Home financial command-center pattern.
- They exercise masking, money CTAs, high-risk forms, fee/risk/limit copy, and
  bottom chrome clearance early.
```
