# AI Top Header Screen-Level Consistency Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
screen-level top-header consistency work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Screen-Level-Consistency-Tracking-Plan.md`

Goal: make VitTrade's Flutter top headers feel like one enterprise-grade
mobile trading app by enforcing a screen-level IA contract, migrating the five
known product hub mismatches, upgrading the audit guardrail, and verifying the
result with tests and visual QA.

This is not a request to make another plan. It is a request to execute the
existing tracking plan in order.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute every open task in this plan, in order, until the top-header
screen-level consistency work is complete:

docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Screen-Level-Consistency-Tracking-Plan.md

The final product must make users feel that the whole app is visually
coherent:
- screens at the same IA level use the same top chrome archetype
- product module hubs look like same-level peers
- detail screens keep the smaller detail rhythm
- instrument/trading screens keep instrument context
- transaction flows stay safety-first
- module identity stays as accent only
- no local header palette, random padding, random font size, or one-off header
  composition is introduced
- static guardrails catch future screen-level/header mismatches

NON-NEGOTIABLE OUTCOME:
- Do not only analyze.
- Do not only create another prompt or plan.
- Execute the next open item from the tracking plan.
- Continue automatically to the next open item unless the user explicitly asks
  for one phase only.
- Process work in this exact order:
  1. THC-00 - Baseline And Scope
  2. THC-01 - Lock The Screen-Level Contract In Docs
  3. THC-02 - Upgrade The Static Audit Guardrail
  4. THC-03 - Migrate Product Module Hubs To `rootModule`
  5. THC-04 - Normalize Header Actions
  6. THC-05 - Format, Analyze, And Test
  7. THC-06 - Visual QA
  8. THC-07 - Review Gates
- Do not start later phases while earlier phases have failing tests, stale
  generated artifacts, undocumented exceptions, or open checklist items that
  affect correctness.
- If current scans differ from the tracking plan numbers, trust current source,
  update audit artifacts, and explain the drift before continuing.
- If all phases are complete, the final response must include:
  TOP HEADER SCREEN-LEVEL CONSISTENCY COMPLETE
- If forced to stop before all phases are complete, the final response must end
  with exactly:
  RESUME FROM: THC-<number> - <title>
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
9. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Screen-Level-Consistency-Tracking-Plan.md
10. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md
11. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv
12. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md
13. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.csv
14. docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md

If documents conflict, follow this order:
1. Current user instruction
2. AGENTS.md
3. `VitTrade-Top-Header-Screen-Level-Consistency-Tracking-Plan.md`
4. Flutter Native Design Standard
5. Flutter Module Identity Standard
6. Current Flutter source and tests

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Tests: `flutter_app/test/`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- Route groups: `flutter_app/lib/app/router/route_groups/`
- Shared layout primitives: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Audit tools: `flutter_app/tool/`
- Generated QA artifacts: `flutter_app/run-artifacts/`

ACTIVE SCREEN-LEVEL CONTRACT:

| Level | Screen type | Expected top chrome |
| --- | --- | --- |
| L0 | Home root | `rootBrand` |
| L0 | Auth entry | `authOnboarding` |
| L1 | Primary tab root: Markets, Wallet, Profile | `rootModule` |
| L1 | Product module hub: P2P, DCA, Launchpad, Earn, Arena, Prediction Markets, Rewards | `rootModule` |
| L1 | Trade instrument workspace | `instrument` |
| L1 | Utility hub: Search, News, Notifications, Support, Referral, Cross-module tools | `detail` |
| L2 | Section hub, utility detail, entity detail | `detail` |
| L2 | Instrument detail such as Pair Detail | `instrument` |
| L3 | Transaction flow: confirm, receipt, withdraw, deposit, add payment method | `detail` |
| L3 | Fullscreen tool: terminal chart, futures terminal, chat | `fullscreenTool` |

CURRENT KNOWN MISMATCHES TO FIX:

1. `/arena`
   - Page: `ArenaHomePage`
   - Current: `detail`
   - Expected: `rootModule`
   - File: `flutter_app/lib/features/arena/presentation/pages/arena_home_page_part_01.dart`

2. `/dca`
   - Page: `DCAPage`
   - Current: `detail`
   - Expected: `rootModule`
   - File: `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart`

3. `/earn`
   - Page: `StakingEarnPage`
   - Current: `detail`
   - Expected: `rootModule`
   - File: `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart`

4. `/earn/staking`
   - Page: `StakingEarnPage`
   - Current: `detail`
   - Expected: `rootModule`
   - File: `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart`

5. `/markets/predictions`
   - Page: `PredictionsHomePage`
   - Current: `detail`
   - Expected: `rootModule`
   - File: `flutter_app/lib/features/predictions/presentation/pages/predictions_home_page.dart`

NON-GOALS:
- Do not make every screen use the same header.
- Do not change `ConvertPage` to `rootModule`.
- Do not change receipts, confirmations, settings, history, or analytics pages
  to `rootModule`.
- Do not introduce per-module top-header backgrounds or local palettes.
- Do not change bottom navigation active colors.
- Do not alter route paths, repository contracts, provider contracts, business
  logic, high-risk flow semantics, or product copy unless required to preserve
  existing behavior after header migration.

ENTERPRISE-GRADE IMPLEMENTATION RULES:
- Read existing code before editing.
- Prefer shared primitives over local widgets.
- Use `VitTopChrome(type: VitTopChromeType.rootModule, ...)` for L1 product
  hubs.
- Preserve `VitAutoHideHeaderScaffold` behavior unless the plan explicitly
  requires changing behavior.
- Preserve existing back behavior exactly.
- Preserve keys used by widget tests.
- Preserve haptics and route callbacks.
- Preserve loading, empty, error, offline, submitting, and success states.
- Preserve financial safety behavior.
- Keep Arena points-only language.
- Keep Prediction Markets wallet/value/probability language separate from
  Arena.
- Keep module identity restrained to accents, icons, pills, borders, chart
  markers, and tab indicators.
- Do not add new local padding, radii, colors, font sizes, or one-off header
  layouts when shared tokens cover the need.
- Do not revert unrelated user changes in the working tree.

GLOBAL WORK LOOP:
Repeat this loop for every checklist section.

1. Inspect working tree:

   ```powershell
   git status --short
   ```

2. Re-open the active tracking plan:

   ```powershell
   Get-Content docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Screen-Level-Consistency-Tracking-Plan.md
   ```

3. Determine the first incomplete item.
   - Resume from the first unchecked item.
   - Do not skip checklist rows.
   - If an item is already complete, verify it with code or generated artifacts
     before marking it conceptually complete.

4. Before editing, state:
   - Current THC section and task.
   - Files to inspect.
   - Files likely to edit.
   - Tests/audits to run.
   - Expected risk and exception handling.

5. Re-scan current source before making changes:

   ```powershell
   cd flutter_app
   dart run tool/top_header_visual_archetype_audit.dart --check --strict
   dart run tool/top_header_action_audit.dart --check --strict
   rg -n "VitHeader\\(|VitTopChrome\\(|VitAutoHideHeaderScaffold\\(" lib tool test
   rg -n "ArenaHomePage|DCAPage|StakingEarnPage|PredictionsHomePage" lib test tool
   ```

6. Make tightly scoped edits.
   - Use shared widgets.
   - Keep imports clean.
   - Do not refactor unrelated UI.
   - Do not change strings or business behavior unless needed for compile/test.

7. Add or update focused tests.
   - Audit script changes require quality/audit tests where available.
   - Feature header migration requires feature widget tests or existing tests to
     assert the expected header/title/actions.
   - Shared primitive changes require shared layout tests.

8. Regenerate generated artifacts when audit output changes.

9. Run the required verification commands for the current section.

10. Update checklist status in the tracking plan only when the task is actually
    complete and verified.

THC-00 - BASELINE AND SCOPE:
Objective: confirm current audit baseline and scope before source changes.

Required work:
- Confirm routed-screen count and current top-header archetype baseline.
- Verify that only the five known L1 product hub mismatches are in current
  migration scope.
- Do not migrate UI in this section.

Commands:

```powershell
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/top_header_action_audit.dart --check --strict
```

Acceptance:
- Baseline is current.
- Any drift is explained and reflected in the plan/artifacts before moving on.

THC-01 - LOCK THE SCREEN-LEVEL CONTRACT IN DOCS:
Objective: make the IA-to-header mapping explicit in permanent project docs.

Required work:
- Add or link the screen-level contract summary in:
  - `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
  - or another linked top-header standard doc if more appropriate.
- Document action-density policy:
  - `rootModule`: max two visible primary actions before overflow unless
    documented.
  - `detail`: usually zero or one visible action.
  - transaction flows: safety actions only.
- Document module identity rule:
  - module identity is accent only.
  - no per-module header backgrounds.

Acceptance:
- A reviewer can open docs and understand which screen level maps to which
  header archetype.
- The docs explain why DCA/Arena/Earn/Predictions are product hubs, while
  Convert/Swap and receipts remain detail.

THC-02 - UPGRADE THE STATIC AUDIT GUARDRAIL:
Objective: make the audit detect screen-level/header mismatches.

Required file:
- `flutter_app/tool/top_header_visual_archetype_audit.dart`

Generated files:
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`

Required implementation:
- Add route `screenLevel` classification.
- Add `expectedArchetype`.
- Add mismatch detection, for example:
  - `screen_level_archetype_mismatch`
  - or a clear equivalent field.
- Add CSV columns for `screenLevel`, `expectedArchetype`, and mismatch.
- Add Markdown summary counts for screen-level mismatches.
- Make `--strict` fail when any screen-level mismatch exists.
- Keep existing checks for:
  - unclassified visual archetype
  - no-header without exception
  - hard-coded offline banner
  - header-local padding tokens
  - root module title drift

Important classification rules:
- `/arena`, `/dca`, `/earn`, `/earn/staking`, `/markets/predictions`,
  `/p2p`, `/launchpad`, `/rewards` are L1 product module hubs and must expect
  `rootModule`.
- `/markets`, `/wallet`, `/profile` are L1 primary tab roots and must expect
  `rootModule`.
- `/trade` and `/trade/:pairId` are instrument workspaces and must expect
  `instrument`.
- `PairDetailPage` may expect `instrument`.
- `ConvertPage`, receipts, confirmations, settings, history, analytics, and
  financial flows must expect `detail`.
- Search, News, Notifications, Support, Referral, and cross-module utility
  surfaces should not be promoted to product root unless product IA docs say so.

Verification:

```powershell
cd flutter_app
dart format tool
dart run tool/top_header_visual_archetype_audit.dart
dart run tool/top_header_visual_archetype_audit.dart --check --strict
flutter analyze
```

Expected interim behavior:
- If the audit is upgraded before UI migration, `--strict` may fail on the five
  known mismatches. That is acceptable only if the failure is documented and the
  next step is THC-03. After THC-03, strict mode must pass.

THC-03 - MIGRATE PRODUCT MODULE HUBS TO `rootModule`:
Objective: make all L1 product hubs visually peer-level.

Shared migration pattern:
- Replace `VitHeader(...)` with `VitTopChrome(type: VitTopChromeType.rootModule, ...)`.
- Preserve title, subtitle, back behavior, action callbacks, keys, haptics, and
  routes.
- Keep `VitAutoHideHeaderScaffold`.
- Add imports for `vit_top_chrome.dart` and `vit_header_action_button.dart` only
  as needed.
- Remove now-unused `vit_header.dart` imports only when safe.

Migrate in this order:

1. Arena hub
   - File: `flutter_app/lib/features/arena/presentation/pages/arena_home_page_part_01.dart`
   - Preserve `Open Arena`, subtitle, `_close`, search, guide, rewards,
     leaderboard, my-arena routes.
   - Arena copy must remain points-only.

2. DCA hub
   - File: `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart`
   - Parent imports: `flutter_app/lib/features/dca/presentation/pages/dca_page.dart`
   - Preserve title, subtitle, `_close`, create plan, pause, chart, history,
     sticky CTA, bottom inset, and sheet behavior.

3. Earn hub
   - File: `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart`
   - Preserve `snapshot.title`, `snapshot.subtitle`, `snapshot.backRoute`,
     products/positions tab behavior, high-risk panel, and bottom inset.
   - Both `/earn` and `/earn/staking` must share the same root module chrome.

4. Prediction Markets hub
   - File: `flutter_app/lib/features/predictions/presentation/pages/predictions_home_page.dart`
   - Preserve title, subtitle, back route to Markets, search action, filters,
     highlights, and event cards.
   - Prediction Markets must remain separated from Arena language.

5. Re-check already-correct hubs
   - Launchpad, P2P, Markets, Wallet, Profile, Rewards.
   - Do not change them unless action-density review requires it.

Focused test expectations:
- Existing widget tests for each touched feature should still pass.
- Add targeted assertions if existing tests do not cover top chrome title/action
  rendering.

Verification after each migrated batch:

```powershell
cd flutter_app
dart format <touched files>
flutter test <focused tests> --reporter=compact
flutter analyze
dart run tool/top_header_visual_archetype_audit.dart --check --strict
```

THC-04 - NORMALIZE HEADER ACTIONS:
Objective: ensure root module actions are visually manageable at phone width.

Required work:
- Review visible actions on:
  - Launchpad
  - P2P
  - DCA
  - Arena
  - Earn
  - Prediction Markets
- Confirm action density:
  - no root module should expose more than two visible primary actions unless
    documented
  - low-priority actions should be moved into overflow if needed
  - primary tone is reserved for true creation/add actions
  - neutral tools stay neutral
- Verify every visible action has a real `onPressed`.
- Do not introduce disabled/no-op visible header commands.

Commands:

```powershell
cd flutter_app
dart run tool/top_header_action_audit.dart --check --strict
rg -n "VitHeaderActionItem\\(" lib/features/arena lib/features/dca lib/features/earn lib/features/predictions lib/features/launchpad lib/features/p2p
```

Acceptance:
- Root module headers are scannable at 360 px.
- Action audit remains strict-clean.

THC-05 - FORMAT, ANALYZE, AND TEST:
Objective: verify implementation and generated artifacts.

Required commands:

```powershell
cd flutter_app
dart format .
dart run tool/top_header_visual_archetype_audit.dart
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

If full `flutter test` is too slow or blocked, run focused tests first and
report exactly what full verification remains. Do not mark completion criteria
done until either full tests pass or a legitimate environment blocker is
documented.

THC-06 - VISUAL QA:
Objective: verify actual screens, not just static checks.

Required screens:
- Home
- Markets
- Wallet
- Profile
- P2P
- Launchpad
- DCA
- Arena
- Earn
- Prediction Markets
- Convert / Swap
- Withdraw / Deposit / Receipt representative flow

Required checks:
- No status bar overlap.
- No notch/camera clipping.
- Root module titles use consistent scale.
- Detail screens keep smaller detail rhythm.
- Product hubs look peer-level.
- Convert/Swap remains detail.
- Financial flows remain detail/safety-first.
- Header text/actions do not collide at 360 px.
- Badges and action buttons are not clipped.
- Bottom nav is unaffected.
- Arena remains points-only.
- Prediction Markets remains wallet/value/probability context.

Preferred artifact location:

```text
flutter_app/run-artifacts/top_header_screen_level_consistency/
  report.md
  360_*.png
  390_*.png
  440_*.png
```

If emulator/device QA is not available, document the blocker and include the
static/widget-test evidence that was completed.

THC-07 - REVIEW GATES:
Objective: close the work only when enterprise-grade acceptance is satisfied.

Review each gate:
- Architecture: product hub pages use shared `VitTopChrome`.
- IA: L1 product hubs are visually peers.
- Financial safety: transaction flows remain detail/safety-first.
- Boundary clarity: Arena and Prediction Markets remain separate.
- Mobile fit: text/actions do not collide at 360 px.
- Audit: static audit catches future product-hub/detail mismatches.

Completion criteria:
- All five current product hub mismatches are migrated.
- The audit script records screen level and expected archetype.
- `--strict` fails if a future product hub uses `detail`.
- Generated audit Markdown and CSV are current.
- Flutter analyzer and tests pass for touched scope.
- Visual QA confirms root module consistency at phone width or a legitimate
  visual QA blocker is documented with remaining steps.

FINAL VERIFICATION BEFORE COMPLETE:

Run from `flutter_app/`:

```powershell
dart format --output=none --set-exit-if-changed .
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

FINAL RESPONSE FORMAT:
When all requested work for the current run is complete, report:
- THC sections completed
- files changed
- audit count changes
- tests and commands run with pass/fail results
- visual QA artifacts or blocker
- exceptions left, if any
- next THC section if work remains

If the full plan is complete, include:
TOP HEADER SCREEN-LEVEL CONSISTENCY COMPLETE

If work remains and you must stop, final line must be:
RESUME FROM: THC-<number> - <title>
````

