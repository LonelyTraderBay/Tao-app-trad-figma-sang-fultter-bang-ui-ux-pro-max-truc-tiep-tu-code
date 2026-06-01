# AI Enterprise Navigation Optimization Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
navigation and screen-connection optimization work from:

- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md`

Goal: force the agent to follow the navigation optimization plan in exact
order, review every route and navigation edge, avoid missing any button or
screen connection, update the tracking plan after each pass, run verification,
document exceptions, and keep the VitTrade Flutter codebase enterprise-grade as
the product grows.

This prompt is for navigation architecture, route contracts, screen
connectivity, bottom navigation behavior, route ownership, and high-risk flow
back behavior. It is not a redesign prompt and it is not a request to invent new
product behavior.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the navigation and screen-connection optimization work from this active
tracking plan, in exact order, until every NAVOPT phase is complete or has a
documented exception:

docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md

The objective is to make VitTrade navigation enterprise-grade:
- no missed screen connections
- no unverified data-driven routes
- no accidental route string typos
- clear route ownership
- stable bottom-nav active destination behavior
- safe back behavior for high-risk financial/security flows
- preserved Prediction Markets and Arena boundaries
- preserved existing reachable screens and product behavior

ACTIVE TRACKING FILES:
- Execution plan:
  docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md
- Human-readable navigation audit:
  docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Connection-Audit.md
- Row-level edge audit:
  docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv
- Router truth table:
  docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md
- Current router source:
  flutter_app/lib/app/router/app_router.dart
  flutter_app/lib/app/router/app_route_paths.dart
  flutter_app/lib/app/router/app_route_names.dart
  flutter_app/lib/app/router/route_groups/
  flutter_app/lib/app/router/visual_qa_route_metadata.dart

NON-NEGOTIABLE OUTCOME:
- Do not only create a plan.
- Do not stop after inspection.
- Execute the next open NAVOPT phase from the tracking plan.
- Continue automatically to the next open phase unless the user explicitly says
  "one phase only" or "one module only".
- Process phases in this exact order:
  1. NAVOPT-00 - Freeze And Reproduce Baseline
  2. NAVOPT-01 - Create Permanent Navigation Edge Audit Tool
  3. NAVOPT-02 - Route Constant And Typed Intent Standard
  4. NAVOPT-03 - Dynamic Route Contract Tests
  5. NAVOPT-04 - Bottom Navigation And Module IA Review
  6. NAVOPT-05 - Move Real Routes Out Of Placeholder Group
  7. NAVOPT-06 - Route Name Coverage
  8. NAVOPT-07 - Query Parameter And Deep Link Contract
  9. NAVOPT-08 - Back And Modal Behavior Audit
  10. NAVOPT-09 - Module Pass Order
  11. NAVOPT-10 - P2P Module Checklist
  12. NAVOPT-11 - Earn Module Checklist
  13. NAVOPT-12 - Launchpad Module Checklist
  14. NAVOPT-13 - Trade Module Checklist
  15. NAVOPT-14 - Arena Module Checklist
  16. NAVOPT-15 - Wallet Module Checklist
  17. NAVOPT-16 - Markets And Predictions Checklist
  18. NAVOPT-17 - Smaller Module Checklist
- Resume any `Status: In progress` phase before starting a `Status: Not started`
  phase.
- Mark the active phase `Status: In progress` before code edits.
- Mark a phase `Status: Complete` only after acceptance criteria and required
  verification pass.
- Mark a phase `Status: Blocked` only for a real blocker or intentional
  documented exception.
- Do not skip any row in `VitTrade-Screen-Navigation-Edges.csv`.
- Do not skip dynamic routes because they come from mock data. Mock data defines
  the current UX contract.
- If the current CSV count differs from the plan, trust the current scan,
  update the plan baseline, and explain the drift in the Work Log before code
  edits.
- If all work is complete, the final response must include:
  NAVIGATION OPTIMIZATION COMPLETE
- If forced to stop before every open phase is complete, the final response
  must end with exactly:
  RESUME FROM: <NAVOPT-id> - <title>
  This must be the final line, with no text after it.

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md
6. docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Connection-Audit.md
7. docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv
8. docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md
9. docs/03_DESIGN_SYSTEM/Guidelines.md when UI navigation, labels, bottom nav,
   product copy, or high-risk flows are touched.

If documents conflict, follow the current user instruction first, then
AGENTS.md, then the navigation tracking plan, then current Flutter source and
tests.

SOURCE OF TRUTH:
- Flutter package: flutter_app/
- App source: flutter_app/lib/
- Tests: flutter_app/test/
- Public router facade: flutter_app/lib/app/router/app_router.dart
- Route paths: flutter_app/lib/app/router/app_route_paths.dart
- Route names: flutter_app/lib/app/router/app_route_names.dart
- Route groups: flutter_app/lib/app/router/route_groups/
- Bottom-nav active mapping:
  flutter_app/lib/app/router/visual_qa_route_metadata.dart
- Edge audit CSV:
  docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv

BASELINE TO PRESERVE OR EXPLAIN:
- Router declarations: 417
- Real pages: 414
- Redirect aliases: 3
- Navigation handlers scanned: 913
- Resolved static targets: 431
- Dynamic route expressions: 345
- Back or close-modal handlers: 137

MODULE RISK ORDER:
Use this order for module passes and focused contract tests:
1. p2p
2. earn
3. launchpad
4. trade
5. arena
6. wallet
7. markets and predictions
8. profile and auth
9. dca, referral, support, discovery, cross_module
10. dev, admin, enterprise_states, news, notifications, onboarding

GLOBAL WORK LOOP:
Repeat this loop until every NAVOPT phase in the tracking plan is complete or
blocked with a documented exception.

1. From repo root, run:

   ```powershell
   git status --short
   ```

2. Read the active tracking plan:

   ```powershell
   Get-Content docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md
   ```

3. Select the next phase:
   - Resume the first `Status: In progress` NAVOPT phase.
   - If none exists, start the first `Status: Not started` NAVOPT phase.
   - Do not start a later NAVOPT phase while an earlier phase is open.
   - If the plan and this prompt disagree, the plan wins.

4. Before source edits, update the tracking plan:
   - Set the selected phase to `Status: In progress`.
   - Add a short work note under `Work Log` with date, phase, module, current
     baseline counts, and intended scope.
   - If the phase is module-specific, list the module rows to be reviewed from
     `VitTrade-Screen-Navigation-Edges.csv`.

5. Reproduce current baseline counts.

   Until NAVOPT-01 creates the permanent Dart audit tool, use PowerShell:

   ```powershell
   $csv = Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv
   $total = $csv.Count
   $resolved = ($csv | Where-Object { $_.normalized_target }).Count
   $dynamic = ($csv | Where-Object { $_.notes -eq 'dynamic_route_expression' }).Count
   $pop = ($csv | Where-Object { $_.notes -eq 'back_or_close_modal' }).Count
   "total=$total resolved=$resolved dynamic=$dynamic pop=$pop"
   $csv | Group-Object module | Sort-Object Count -Descending |
     Select-Object Name, Count
   ```

   After NAVOPT-01, use:

   ```powershell
   dart run tool/navigation_edge_audit.dart --check
   ```

6. Always run router truth-table check before route edits:

   ```powershell
   Push-Location flutter_app
   dart run tool/route_coverage_audit.dart --check
   Pop-Location
   ```

7. Filter the active module rows from the CSV.

   Example:

   ```powershell
   $module = "p2p"
   Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv |
     Where-Object { $_.module -eq $module } |
     Sort-Object source_file, {[int]$_.line} |
     Format-Table module, source_file, line, kind, target_expression,
       normalized_target, target_screen, notes -Wrap
   ```

8. Review every row in scope. Classify each row as exactly one of:
   - static_route_ok
   - dynamic_route_needs_contract
   - raw_string_to_constant
   - back_or_modal_ok
   - wrong_route_group
   - missing_route_name
   - needs_ia_review
   - dead_or_noop_action

9. Search before editing:

   ```powershell
   rg -n "context\\.go|context\\.push|context\\.replace|context\\.pop|Navigator\\.of\\(context\\)|Navigator\\.pop|routePath|backRoute|\\.route\\b" flutter_app/lib
   rg -n "AppRoutePaths|AppRouteNames|GoRoute|ShellRoute|redirect:" flutter_app/lib/app/router flutter_app/test/app/router
   ```

   For a focused module:

   ```powershell
   rg -n "context\\.go|context\\.push|context\\.replace|context\\.pop|Navigator|routePath|backRoute|\\.route\\b" flutter_app/lib/features/<feature>
   rg -n "<RoutePathName>|<PageClass>|<SnapshotClass>|<EntityClass>" flutter_app/lib flutter_app/test
   ```

10. Identify behavior that must not change:
    - route paths unless explicitly planned
    - route names unless adding missing names
    - deep-link behavior
    - bottom-nav active destination unless NAVOPT-04 is active
    - high-risk preview and confirmation flows
    - wallet, withdrawal, address, escrow, KYC, security, P2P payment-method,
      Trade, margin, futures, copy-trading, Earn, and Launchpad safety copy
    - Prediction Markets and Arena product boundaries
    - Arena points-only wording
    - tests, keys, visible labels, semantics, and accessibility behavior

11. Make the smallest correct change:
    - For raw route strings, prefer `AppRoutePaths`.
    - For data-driven routes, add contract tests first or in the same change.
    - For wrong route ownership, move declarations to the correct route group
      without changing the path.
    - For missing route names, add `AppRouteNames` entries and route contract
      coverage.
    - For bottom-nav active mapping, update tests and document the IA decision.
    - For query routes, document allowed query keys and add invalid-value tests.
    - For `context.pop()` on deep-linkable pages, add safe fallback route when
      needed.

12. Update tests:
    - Add or update router tests under `flutter_app/test/app/router/`.
    - Add feature route/data contract tests under
      `flutter_app/test/features/<feature>/`.
    - Add quality guardrail tests under `flutter_app/test/quality/` when
      introducing reusable navigation standards.
    - Add product copy guardrail tests when Arena, Prediction, Trade, Wallet,
      P2P, rewards, or high-risk copy changes.

13. Regenerate or verify audits:

    ```powershell
    Push-Location flutter_app
    dart run tool/route_coverage_audit.dart --check
    if (Test-Path tool/navigation_edge_audit.dart) {
      dart run tool/navigation_edge_audit.dart --check
    }
    Pop-Location
    ```

14. Run formatting and focused verification:

    ```powershell
    Push-Location flutter_app
    dart format --output=none --set-exit-if-changed .
    flutter analyze
    flutter test test/app/router --reporter=compact
    Pop-Location
    ```

    For high-risk or broad changes, also run:

    ```powershell
    Push-Location flutter_app
    flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
    flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
    flutter test --reporter=compact
    Pop-Location
    ```

15. Update the tracking plan after verification:
    - Mark completed checklist items.
    - Set the NAVOPT phase to `Status: Complete` only after acceptance criteria
      pass.
    - If incomplete, keep `Status: In progress`.
    - If blocked, set `Status: Blocked` and record exact blocker, affected
      files, remaining work, and unblock condition.
    - Add Work Log row with before/after edge counts, dynamic counts, tests,
      and notes.

16. Continue automatically:
    - If the user asked for full execution, select the next open NAVOPT phase
      and repeat.
    - If the user asked for one phase/module only, stop after verification and
      end with the next `RESUME FROM` line.

PHASE-SPECIFIC INSTRUCTIONS:

NAVOPT-00 - Freeze And Reproduce Baseline
- Audit only unless baseline files are stale.
- Confirm row counts from CSV.
- Confirm route truth table is current.
- If counts drift, update the plan baseline before any source edits.
- Do not mark complete until the baseline is reproducible.

NAVOPT-01 - Create Permanent Navigation Edge Audit Tool
- Add `flutter_app/tool/navigation_edge_audit.dart`.
- The tool must scan `flutter_app/lib` and output:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv`.
- It must support `--check`.
- It must classify static route targets, raw literal targets, dynamic route
  expressions, modal/back closes, unresolved targets, and matched route pages.
- Prefer structured parsing where practical. Regex is acceptable only if tests
  cover representative route expression forms.
- Add focused tests for parser behavior if the repo has an established tool
  test pattern.
- Add CI command only after the tool is stable.

NAVOPT-02 - Route Constant And Typed Intent Standard
- Define the project rule for route strings.
- Add guardrail test to prevent new raw absolute app route strings in UI files.
- Exempt route definitions, tests, docs, generated audit artifacts, and
  intentional external links.
- Do not mass-convert every route in one change. Convert high-risk and touched
  code first.

NAVOPT-03 - Dynamic Route Contract Tests
- Build a reusable route matcher test helper.
- Validate route-bearing data objects in P2P, Earn, Launchpad, Arena,
  Discovery, Cross-module, Wallet, Markets, Predictions, Trade, Profile, Auth,
  DCA, Referral, Support, Admin, Dev, Enterprise states, News, Notifications,
  and Onboarding.
- Query strings must match path plus allowed query keys.
- Unknown route paths must fail tests.

NAVOPT-04 - Bottom Navigation And Module IA Review
- Do not casually change UX behavior.
- First document current active destination mapping.
- Decide and document whether `/pair/*` belongs to Markets or Trade.
- Decide and document whether P2P, Earn, Arena, Launchpad, Rewards, Support,
  Search, Notifications, Admin, DCA, Dev, and Cross-module routes stay under
  Trade active destination or use another approach.
- Add active-destination tests for representative namespaces.
- If UI behavior changes, validate with emulator screenshots.

NAVOPT-05 - Move Real Routes Out Of Placeholder Group
- Move real module routes to correct route groups.
- Preserve route paths exactly unless an explicit migration is documented.
- Candidate routes:
  - `/dca/rebalance/:configId/edit`
  - `/dca/rebalance/:configId/history`
  - `/admin/settings`
  - `/trade/copy-trading/client-opt-up-request`
  - `/trade/copy-trading/regulatory-disclosures` alias
  - `/settings/security`
- Update route truth table and router tests.

NAVOPT-06 - Route Name Coverage
- Add route names for non-temporary product routes that currently lack names.
- Keep naming sequence and local style consistent with `AppRouteNames`.
- Add tests that named routes resolve.
- Redirect aliases may remain unnamed only if documented.

NAVOPT-07 - Query Parameter And Deep Link Contract
- Document and test valid query values for:
  - `/trade/<pairId>?side=buy`
  - `/trade/<pairId>?side=sell`
  - `/p2p/wallet/transfer?direction=from-main`
  - `/p2p/wallet/transfer?direction=to-main`
  - `/p2p/wallet/transfer?asset=<asset>&type=deposit`
  - `/p2p/wallet/transfer?asset=<asset>&type=withdraw`
  - `/p2p/escrow/balance?asset=<asset>`
  - `/rewards?tab=arena`
- Invalid query values must not crash.
- Invalid query values must use a safe default.
- Query routes must not skip high-risk previews or confirmations.

NAVOPT-08 - Back And Modal Behavior Audit
- Review all `back_or_close_modal` rows.
- Classify each as modal close, sheet result return, true back navigation, or
  fallback to parent route.
- Deep-linkable pages must not rely only on stack pop.
- High-risk pages must not close without a clear next state.

NAVOPT-09 - Module Pass Order
- This is the transition gate into module-by-module work.
- Confirm the module order in the plan.
- Confirm all previous foundational phases are complete before starting P2P.

NAVOPT-10 - P2P Module Checklist
- Review every P2P CSV row.
- Cover express, order lifecycle, chat, dispute, ads, merchant, payment
  methods, insurance, escrow, KYC, security, wallet, limits, compliance, tax,
  settings, guide, blacklist, dashboard, achievements, order book, my ads, and
  my orders.
- P2P financial/security routes require preview/confirmation where relevant.

NAVOPT-11 - Earn Module Checklist
- Review every Earn CSV row.
- Earn currently has many dynamic snapshot routes. Contract tests are required.
- Cover Staking and Savings separately.
- Deep-linked Earn pages need safe back behavior.

NAVOPT-12 - Launchpad Module Checklist
- Review every Launchpad CSV row.
- Launchpad dynamic routes must be tested or converted.
- Preserve claim, receipt, bridge, contract, and risk flows.

NAVOPT-13 - Trade Module Checklist
- Review every Trade CSV row.
- Cover spot, futures, margin, bots, copy-trading, compliance, disclosures,
  reporting, complaint, and audit flows.
- Do not weaken financial safety copy or receipt/audit routes.

NAVOPT-14 - Arena Module Checklist
- Review every Arena CSV row.
- Arena must remain points-only.
- Decide canonical handling for `/arena/points`.
- Prediction bridge must stay within allowed bridge concepts.

NAVOPT-15 - Wallet Module Checklist
- Review every Wallet CSV row.
- Withdraw, address, transfer, approval, and transaction routes require special
  safety review.
- Preserve preview and confirmation sheets.

NAVOPT-16 - Markets And Predictions Checklist
- Review Markets and Predictions CSV rows.
- Pair detail to Trade bridge must be intentional and tested.
- Prediction Markets and Arena must stay separate.

NAVOPT-17 - Smaller Module Checklist
- Review Auth, Profile, DCA, Referral, Support, Discovery, Cross-module, Admin,
  Dev, Enterprise states, News, Notifications, and Onboarding.
- Do not ignore small modules. Every edge must be classified or tested.

FINAL DEFINITION OF DONE:
Navigation optimization is complete only when:
- every NAVOPT phase is `Status: Complete` or `Status: Blocked` with a safe
  documented exception
- `dart run tool/route_coverage_audit.dart --check` passes
- `dart run tool/navigation_edge_audit.dart --check` exists and passes
- every route-bearing data object is covered by a route contract test
- every product route has an owner route group
- no real feature page is left in `placeholder_routes.dart` unless explicitly
  documented
- route names are complete for non-temporary product routes
- query parameters have documented supported values and fallback behavior
- bottom-nav active destination behavior is documented and tested
- P2P, Wallet, Trade, Earn, Arena, and Launchpad high-risk flows keep required
  preview, confirmation, receipt, and safe back behavior
- `flutter analyze` passes
- focused router tests pass
- full `flutter test --reporter=compact` passes
- the Work Log records final before/after counts and accepted exceptions

FINAL RESPONSE FORMAT:
When stopping, summarize:
- completed NAVOPT phase(s)
- files changed
- verification commands and results
- current edge counts
- next phase

If all phases are complete, include:
NAVIGATION OPTIMIZATION COMPLETE

If any phase remains open, end with exactly:
RESUME FROM: <NAVOPT-id> - <title>
````
