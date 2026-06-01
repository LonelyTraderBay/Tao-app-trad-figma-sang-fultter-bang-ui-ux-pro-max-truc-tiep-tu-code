# AI Enterprise Clean Codebase Master Plan Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
long-term clean-code work from:

- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Clean-Codebase-Master-Plan.md`

Goal: force the agent to follow the master plan in order, execute one complete
batch at a time, continue automatically to the next open batch until the plan is
complete, keep every file tracked through the manifest, update the plan after
each batch, run verification, document exceptions, and preserve VitTrade
enterprise Flutter architecture while the codebase continues to grow.

This prompt is for ongoing enterprise maintainability. It is not a redesign
prompt and it is not a request to invent new product behavior.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the clean-code and enterprise-standardization work from this active
master plan, one complete batch at a time, in the exact order defined there,
until every phase, batch, and target row is complete or has a documented
exception:

docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Clean-Codebase-Master-Plan.md

The objective is to keep the Flutter codebase clean, scalable, and ready for
many future features. Preserve product behavior, routing, repository contracts,
provider contracts, tests, financial safety copy, accessibility semantics, and
module boundaries.

ACTIVE TRACKING FILES:
- Master execution plan:
  docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Clean-Codebase-Master-Plan.md
- Complete file-level ledger:
  docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-100-Percent-File-Action-Manifest.csv
- Historical large-file tracker:
  docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md

NON-NEGOTIABLE OUTCOME:
- Do not only create a plan.
- Do not stop after inspecting files.
- Execute the next open phase/batch from the master plan.
- After a batch is verified and marked `[x]`, immediately select and execute
  the next open batch unless the user explicitly asked for only one batch.
- Work in phase order: Phase 0, Phase 1, Phase 2, Phase 3, Phase 4, Phase 5,
  then Phase 6.
- Resume any existing `[~]` item before starting a new `[ ]` item.
- Mark the active batch `[~]` before source edits.
- Mark `[x]` only after required verification passes and the plan records
  before/after line counts, new files, commands, results, and notes.
- Mark `[!]` only for a real blocker or an intentional documented exception.
- Do not skip a file listed in the active batch.
- Do not use stale hardcoded batch names from this prompt if the master plan has
  already advanced. The master plan is the active source of truth.
- If current scan results differ from the plan, trust the current scan, update
  the plan, and explain the change in the batch notes.
- If all work is complete, the final response must include:
  MASTER PLAN COMPLETE
- If forced to stop before all open work is complete, the final response must
  end with exactly:
  RESUME FROM: <phase/batch-id> - <title>
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
9. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Clean-Codebase-Master-Plan.md
10. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-100-Percent-File-Action-Manifest.csv
11. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md
    only for historical context when needed.

If documents conflict, follow the current user request first, then AGENTS.md,
then the Clean Codebase Master Plan, then current Flutter source and tests.

SOURCE OF TRUTH:
- Flutter package: flutter_app/
- App source: flutter_app/lib/
- Tests: flutter_app/test/
- Public router facade: flutter_app/lib/app/router/app_router.dart
- Shared layout primitives: flutter_app/lib/shared/
- Theme tokens: flutter_app/lib/app/theme/

ENTERPRISE TARGETS:
- presentation/pages/*.dart:
  preferred 200-500 lines, soft review >500, hard limit >900.
- presentation/widgets/*.dart:
  preferred 80-350 lines, soft review >400, hard limit >600.
- presentation/controllers/*.dart:
  preferred 80-300 lines, soft review >350, hard limit >500.
- domain/entities/*.dart:
  split by cohesive bounded context, soft review >500, hard limit >800.
- data/repositories/mock_*.dart:
  preferred 200-500 lines, soft review >500, hard limit >900.
- app/router/*.dart:
  preferred 100-500 lines, soft review >500, hard limit >700.
- test/**/*.dart:
  preferred 80-350 lines, soft review >400, hard limit >600.

GLOBAL WORK LOOP:
Default mode is FULL-SEQUENTIAL execution. Repeat this loop until every phase,
batch, and target row in the master plan is `[x]` or `[!]`. If the user
explicitly says "one batch only", complete exactly one batch, update the plan,
and stop with the next `RESUME FROM` line.

1. From repo root, run:
   git status --short

2. Read the master plan:
   docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Clean-Codebase-Master-Plan.md

3. Select the next work item:
   - Resume the first `[~]` phase or batch.
   - If none exists, start the first `[ ]` item in phase order.
   - Start with Phase 0 if the baseline is stale.
   - Otherwise use the "Next Recommended Batch" section if it points to open
     work.
   - If "Next Recommended Batch" is stale, start the next incomplete row in the
     earliest open phase table.
   - Do not start Phase 2 while Phase 1 has open P1 items unless the user
     explicitly asks for a later phase.
   - Do not rely on a batch name hardcoded in this prompt when the master plan
     shows that batch is already `[x]`.

4. Before editing source, update the master plan:
   - Mark the selected phase/batch/item `[~]`.
   - Add or update a batch section using the "Batch Template" in the plan.
   - List all target files.
   - Record current line counts.
   - If the plan does not already contain a concrete batch for the next open
     rows, create the next sequential batch ID:
     EClean-02, EClean-03, EClean-04, and so on.
   - Keep each batch small enough to verify reliably. Prefer 1-2 large widget
     files, one page-part group, one router group, or one test-suite split per
     batch.

5. Refresh inventory from the current workspace. Run at minimum:

   ```powershell
   $root=(Resolve-Path flutter_app).Path
   $files=Get-ChildItem flutter_app/lib,flutter_app/test -Recurse -Filter *.dart |
     ForEach-Object {
       [pscustomobject]@{
         Rel=$_.FullName.Substring($root.Length+1)
         Lines=(Get-Content $_.FullName).Count
       }
     }
   $files | Sort-Object Lines -Descending | Select-Object -First 100
   ```

   Production threshold scan:

   ```powershell
   $root=(Resolve-Path flutter_app).Path
   Get-ChildItem flutter_app/lib -Recurse -Filter *.dart |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       if ($lines -gt 500) {
         [pscustomobject]@{Lines=$lines; Rel=$rel}
       }
     } |
     Sort-Object Lines -Descending
   ```

   Test threshold scan:

   ```powershell
   $root=(Resolve-Path flutter_app).Path
   Get-ChildItem flutter_app/test -Recurse -Filter *.dart |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       if ($lines -gt 400) {
         [pscustomobject]@{Lines=$lines; Rel=$rel}
       }
     } |
     Sort-Object Lines -Descending
   ```

6. Verify target files exist in the CSV manifest. If a target file or new file
   is missing from the manifest, update the manifest or record a clear
   follow-up in the active batch before marking the batch complete.

7. Inspect target class boundaries before editing:

   ```powershell
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <target-files>
   ```

8. Search references before editing:

   ```powershell
   rg -n "<ClassName>|<route-name>|<provider-name>|<visible-copy>" flutter_app/lib flutter_app/test
   ```

9. Identify behavior that must not change:
   - route paths and route names
   - GoRouter calls
   - Riverpod reads, watches, providers, and controllers
   - repository public methods and return types
   - public domain constructors, fields, equality, and value objects
   - test keys and visible text expected by tests
   - loading, empty, error, offline, submitting, and success states
   - accessibility labels and semantics on critical flows
   - financial preview, fee, risk, limit, warning, and next-step copy
   - Prediction Markets wallet/PnL/probability/receipt wording
   - Open Arena points-only wording

10. Edit by phase rules:

    Phase 1 - Widget cleanup:
    - Split files over 480 lines first.
    - Move unrelated visible sections into sibling widget files.
    - Keep tiny shared primitives local only if they are not reused elsewhere.
    - Target 250-350 lines per large widget file where practical.

    Phase 2 - Page part debt cleanup:
    - Keep route state, provider reads, navigation, text controllers, form keys,
      focus nodes, and top-level composition in pages.
    - Move visual sections, cards, lists, tabs, sheets, legends, and painters to
      features/<feature>/presentation/widgets/.
    - Prefer public widget files when the section is reusable or independently
      testable.
    - Use `part` files only when preserving private APIs is safer and existing
      architecture already accepts that pattern.

    Phase 3 - Domain entity boundary review:
    - Do not churn entity files only for line count.
    - Split only by clear bounded context such as orders, positions, risk,
      savings, staking, P2P disputes, P2P payments, Arena points, or governance.
    - Preserve public constructors, fields, and import surfaces unless tests and
      call sites are updated deliberately.

    Phase 4 - Router cleanup:
    - Preserve `createAppRouter`, `appRouter`, `AppRoutePaths`, and
      `AppRouteNames`.
    - Keep route splits under flutter_app/lib/app/router/route_groups/.
    - Run router contract and coverage tests after any route changes.

    Phase 5 - Test suite cleanup:
    - Split tests by behavior group, route group, or guardrail concern.
    - Do not weaken assertions to make a split pass.
    - Keep test names specific and behavior-focused.

    Phase 6 - Future feature onboarding standard:
    - Enforce the enterprise feature layout:
      domain/entities, domain/repositories, data/fixtures, data/providers,
      data/repositories, presentation/controllers, presentation/pages,
      presentation/widgets.
    - Add route, domain contract, mock/fail-closed repository, provider,
      controller, page, widgets, and focused tests in that order.

11. Use existing project patterns:
    - Prefer package imports: package:vit_trade_flutter/...
    - Reuse shared layout primitives before local scaffolds:
      VitAppShell, VitPageLayout, VitPageContent, VitHeader, VitBottomNav,
      VitCard, VitCtaButton, VitInput, VitTabBar, VitEmptyState,
      VitErrorState, VitOfflineBanner.
    - Use theme tokens from flutter_app/lib/app/theme/.
    - Keep dark theme as the baseline.
    - Support phone-first layouts at 360 px and up.

12. Avoid bad cleanup:
    - Do not create arbitrary tiny files only to reduce line count.
    - Do not move data-layer dependencies into presentation.
    - Do not introduce direct presentation imports from features/*/data.
    - Do not introduce new runtime Colors.* usage.
    - Do not combine Prediction Markets and Open Arena concepts.
    - Do not change product copy, route names, provider names, or behavior just
      to make extraction easier.
    - Do not revert unrelated user changes.

13. Format touched Dart files:

    ```bash
    cd flutter_app
    dart format <touched-dart-files>
    ```

14. Run direct architecture smell scans on touched source:

    ```powershell
    rg -n "features/.*/data|\bColors\." <touched-source-files>
    ```

    Expected: no new matches. If existing matches remain outside touched areas,
    do not churn unrelated code; record the scope.

15. Run required verification for the changed area.

    Any Dart edit:

    ```bash
    cd flutter_app
    flutter analyze
    flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
    ```

    Router changes:

    ```bash
    flutter test test/app/router --reporter=compact
    flutter test test/quality/route_coverage_guardrails_test.dart --reporter=compact
    flutter analyze
    ```

    Financial copy, Trade, Earn, Wallet, P2P, Predictions, or Arena changes:

    ```bash
    flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
    ```

    High-risk Wallet, P2P, Auth, withdrawal, security, address, escrow, or
    payment-method changes:

    ```bash
    flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
    ```

    Feature-focused tests:

    ```bash
    flutter test test/features/<feature> --reporter=compact
    ```

16. If verification fails:
    - Do not mark the batch complete.
    - Read the failing output.
    - Fix the root cause.
    - Re-run the failed command.
    - Record the failure and final passing command in the batch log.
    - Do not proceed to the next batch until the active batch passes or is
      marked `[!]` with a real exception.

17. After edits, re-run line counts for touched files and record before/after
    counts in the master plan.

18. Update the master plan:
    - Mark completed target rows `[x]`.
    - Mark the batch `[x]` only when all required checks pass.
    - Add new files.
    - Add exact verification commands and results.
    - Add any exception or deferred reason.
    - If the CSV manifest was updated, mention it.
    - Update "Next Recommended Batch" to point at the next open batch.
    - If all rows in a phase are complete, mark the phase `[x]`.
    - If all phases are complete, mark the full plan complete in the notes.

19. Final response format:
    - Summarize changed files and why.
    - List verification commands and pass/fail result.
    - Mention any skipped/deferred item with reason.
    - If all plan work is complete, include:
      MASTER PLAN COMPLETE
    - If work remains and the run must stop because of context, tooling, or a
      real blocker, end with:
      RESUME FROM: <phase/batch-id> - <title>

PHASE ORDER FROM THE MASTER PLAN:
1. Phase 0 - Baseline Lock
2. Phase 1 - Highest-Value Widget Cleanup
3. Phase 2 - Page Part Debt Cleanup
4. Phase 3 - Domain Entity Boundary Review
5. Phase 4 - Router And Route Contract Cleanup
6. Phase 5 - Test Suite Cleanup
7. Phase 6 - Future Feature Onboarding Standard

DYNAMIC NEXT-BATCH RULE:
Do not hardcode the first batch from this prompt. Always read the current
"Next Recommended Batch" section in:

docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Clean-Codebase-Master-Plan.md

If the recommended batch is already complete, select the next open item by this
priority:

1. Any `[~]` batch or row.
2. Phase 0 baseline lock if stale or failing.
3. Phase 1 P1 widget cleanup rows, top to bottom.
4. Phase 2 page part debt rows, top to bottom.
5. Phase 3 domain entity boundary rows, only when a clear domain split is
   justified.
6. Phase 4 router rows.
7. Phase 5 test suite rows.
8. Phase 6 future-feature onboarding standard.

After each completed batch, rewrite the "Next Recommended Batch" section so
the next AI run resumes from the correct next batch without reading old chat
context.

DEFINITION OF DONE:
A batch is done only when:
- Target files are below preferred or documented soft-review thresholds.
- Public route, provider, domain, and repository contracts remain stable.
- Tests cover changed behavior.
- Financial copy and product boundaries remain correct.
- `flutter analyze` passes.
- Architecture guardrails pass.
- The master plan records before/after counts, new files, commands, results,
  and exceptions.
````
