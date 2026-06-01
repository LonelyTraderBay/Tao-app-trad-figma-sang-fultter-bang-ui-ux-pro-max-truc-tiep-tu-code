# AI Enterprise Grade Codebase Upgrade Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the full
enterprise-grade cleanup from:

- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Grade-Codebase-Upgrade-Tracker.md`

Goal: force the agent to work packet-by-packet in the correct order, refresh
inventory, edit only when needed, update the tracker, run verification, document
exceptions, and continue automatically until every packet is complete or a real
blocker is documented.

This prompt replaces older E900-only execution prompts. The E900 tracker and
Post-E900 guide are background references only; the active work source is the
Enterprise Grade tracker named above.

```text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Automatically execute every Enterprise Grade Codebase Upgrade packet in order
from:

docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Grade-Codebase-Upgrade-Tracker.md

The Enterprise Grade tracker is the only active execution tracker. Do not run
the old E900 packet board as the active work plan unless the Enterprise Grade
tracker explicitly tells you to inspect it for historical context.

This is an enterprise maintainability and architecture-quality pass. It is not
a redesign. Preserve product behavior, routing, existing UI intent, tests,
financial safety copy, accessibility semantics, provider contracts, repository
contracts, and module boundaries.

NON-NEGOTIABLE OUTCOME:
- Packets EG-00 through EG-12 must end as `[x]` or `[!]`.
- Do not stop after one packet.
- Do not only create a plan.
- Continue while any packet in the tracker is `[ ]` or `[~]`.
- Resume the first `[~]` packet before starting any `[ ]` packet.
- Mark the active packet `[~]` in the tracker before any code edit.
- Mark `[x]` only after required verification passes and notes are recorded.
- Use `[!]` only for a real blocker or intentional documented exception.
- If a packet is audit-only and requires no source edits, still run the required
  scans/checks, document the no-change rationale, and record command results
  before marking `[x]`.
- If forced to stop before all packets are complete, the final response must
  end with exactly:
  RESUME FROM: <packet-id> - <packet title>
  This must be the final line of the response, with no text after it.

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Grade-Codebase-Upgrade-Tracker.md
6. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md
7. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md
8. docs/03_DESIGN_SYSTEM/Guidelines.md when UI, layout, product copy, or
   financial safety copy is touched.

If these documents conflict, follow the current user instruction first, then
AGENTS.md, then the Enterprise Grade tracker, then current Flutter source and
tests.

SOURCE OF TRUTH:
- Flutter package: flutter_app/
- App source: flutter_app/lib/
- Tests: flutter_app/test/
- Public router facade: flutter_app/lib/app/router/app_router.dart
- Active tracker to update:
  docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Grade-Codebase-Upgrade-Tracker.md

ENTERPRISE TARGETS:
- Presentation pages:
  ideal 300-500 lines, soft review at 500+, hard target below 600.
- Presentation widgets:
  ideal 100-350 lines, soft review at 400+, hard target below 600.
- Controllers:
  ideal 100-300 lines, soft review at 350+, hard target below 500.
- Data repositories:
  ideal 200-500 lines, soft review at 500+, hard target below 900.
- Domain entities:
  ideal 100-500 lines, soft review at 500+, hard target below 800.
- Router files:
  ideal 100-450 lines, soft review at 500+, hard target below 700.
- Test files:
  ideal 100-600 lines, soft review at 700+, hard target below 900 unless
  deliberately documented as a suite root.
- Painter/chart files:
  ideal 100-350 lines, soft review at 400+, hard target below 600.

PACKET ORDER:
Process exactly in this order:

1. EG-00 - Inventory Refresh
2. EG-01 - Hard Guardrail Closure
3. EG-02 - Page Composition Audit
4. EG-03 - Widget Soft Cleanup
5. EG-04 - Painter And Chart Cleanup
6. EG-05 - Controller And Provider Responsibility Audit
7. EG-06 - Repository And Fixture Audit
8. EG-07 - Domain Entity Cohesion Audit
9. EG-08 - Router Facade And Route Group Audit
10. EG-09 - Test Suite Decomposition Audit
11. EG-10 - Architecture Boundary Audit
12. EG-11 - Product Boundary And Financial Safety Audit
13. EG-12 - Final Enterprise Verification

DO NOT SKIP A PACKET:
- Only skip a packet if it is marked `[!]` with a concrete reason, affected
  files, owner/unblock condition when applicable, and verification that the
  exception is safe.
- A local analyzer/test failure is not a blocker by itself. Debug and fix local
  failures before moving on.
- If a packet is large, split it into smaller implementation steps but keep the
  same packet `[~]` until all packet acceptance checks pass.

GITNEXUS REQUIREMENT:
Use GitNexus before blind extraction and after edits when available.

Preflight:
1. Check whether GitNexus MCP tools are available.
   - If available, read `gitnexus://repos`, repo context, clusters, and use
     `query`, `context`, `impact`, and `detect_changes`.
2. If MCP tools are not available, run from repo root:
   npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60
   npx -y gitnexus@latest status
3. If embeddings or install are too slow, retry:
   npx -y gitnexus@latest analyze . --skip-agents-md --skip-embeddings --worker-timeout 60
4. Do not set `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`; this skips Dart parsing.
5. Do not let GitNexus overwrite project instructions. Preserve AGENTS.md.
6. If GitNexus cannot run, continue with `rg`, Dart analyzer, focused tests,
   direct grep checks, and record the GitNexus failure in packet notes.

GLOBAL WORK LOOP:
Repeat this loop until every packet in the tracker is `[x]` or `[!]`.

1. From repo root, run:
   git status --short

2. Read:
   docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Grade-Codebase-Upgrade-Tracker.md

3. Choose the next packet:
   - Resume the first `[~]` packet.
   - If no `[~]` packet exists, start the first `[ ]` packet.
   - Do not start later packets while an earlier packet is open.

4. Mark the selected packet `[~]` in the tracker before source edits.
   For audit-only packets, mark `[~]` before tracker updates and scans.

5. Regenerate the current inventory from flutter_app/ using the exact
   `Scan Commands` section in the tracker. At minimum run scans for:
   - all Dart files above 900
   - presentation pages at or above 500
   - presentation widgets at or above 400
   - painter/chart files at or above 400
   - controllers at or above 350
   - data repositories at or above 400
   - domain entities at or above 500
   - router files at or above 500
   - test files at or above 700
   - presentation/shared direct data imports
   - runtime `Colors.*`

6. For the active packet, run symbol-boundary discovery on target files:
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <target-files>

7. Search tests and router/provider references before editing:
   rg -n "<ClassName>|<route-name>|<provider-name>|<visible-copy>" test lib

8. Identify stable behavior to preserve:
   - route paths and route names
   - GoRouter calls
   - Riverpod reads, watches, controllers, and providers
   - repository public methods and return types
   - public domain model constructors and fields
   - test keys and text expected by tests
   - loading, empty, error, offline, submitting, and success states
   - accessibility labels/semantics on high-risk flows
   - financial previews, fees, limits, warnings, and next steps
   - Prediction Markets wallet/PnL/probability/receipt wording
   - Open Arena points-only wording

9. Edit according to packet scope:
   - Keep page state, controllers, provider reads, keys, navigation, and
     top-level composition in pages.
   - Move visual sections, cards, rows, lists, sheets, tabs, legends, and
     painters to features/<feature>/presentation/widgets/.
   - Move repository fixtures to cohesive fixture files or part files under
     features/<feature>/data/repositories/.
   - Keep repository public APIs stable.
   - Keep domain contracts and value objects under features/<feature>/domain/.
   - Split domain entity files only by bounded context, value-object family, or
     public API clarity.
   - Split route groups only by cohesive route domain/sub-group while preserving
     public router facade APIs.
   - Split tests by behavior group or route group only when diagnosis improves.
   - Use `part` files only when preserving private local boundaries is cleaner
     than public widget imports.
   - Prefer package imports: package:vit_trade_flutter/...
   - Do not introduce presentation imports from features/*/data.
   - Do not introduce runtime `Colors.*`; use theme tokens.

10. Avoid bad cleanup:
    - Do not create arbitrary tiny files only to reduce line counts.
    - Do not split cohesive fail-closed logic without a clear policy/helper
      boundary.
    - Do not change copy, flows, routes, provider contracts, or test names just
      to make extraction easier.
    - Do not move data-layer dependencies into presentation widgets.
    - Do not combine Prediction Markets and Open Arena concepts.

11. Format touched Dart files:
    dart format <touched-dart-files>

12. Run required verification from flutter_app/:
    flutter analyze
    flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact

13. Run packet-specific tests from the verification matrix below.

14. Run direct grep on touched Dart files:
    rg -n "features/.*/data|\bColors\." <touched-dart-files>
    Expected: no new presentation-to-data imports and no new runtime Colors
    usage.

15. Re-count touched files and relevant inventory categories.

16. Run GitNexus post-edit analysis if available:
    - detect_changes({scope: "all"})
    - impact on changed public classes/providers/routes when risk is not
      obvious.
    If unavailable, record fallback with `rg`, analyzer, and test coverage.

17. Update the active packet notes in the tracker:
    - Status `[x]`, `[~]`, or `[!]`.
    - Before line counts.
    - After line counts.
    - Files reviewed.
    - Files split.
    - New files.
    - Exceptions and why they are safe.
    - Commands run and exact pass/fail results.
    - GitNexus findings or fallback reason.
    - For no-edit audit packets, record "No source edit required" plus the
      evidence that made the packet safe to close.

18. If all packet checks pass, mark the packet `[x]`.

19. Continue immediately to the next `[ ]` or `[~]` packet. Do not send a final
    answer while any packet remains `[ ]` or `[~]`, unless tool/context limits
    force a stop.

PACKET-SPECIFIC ACCEPTANCE:

EG-00 - Inventory Refresh:
- Run every scan command in the tracker.
- Update snapshot notes in the tracker if current counts differ.
- Do not edit source unless the tracker itself needs updated inventory notes.
- Mark `[x]` only when current counts are recorded and hard breaches are known.

EG-01 - Hard Guardrail Closure:
- Fix any hard breach found by EG-00 before soft cleanup.
- No Dart file above 900 lines.
- No presentation page at or above 600 lines.
- No presentation widget at or above 600 lines.
- No controller at or above 500 lines.
- No domain entity at or above 800 lines.
- No router file at or above 700 lines.
- No test file at or above 900 lines unless deliberately documented.

EG-02 - Page Composition Audit:
- Review all pages at 550-599 lines listed by current scan.
- Split only pages that still own visual sections instead of composition.
- Leave page `part` files alone if further split would create nested `part`
  complexity with no behavior benefit.
- Required tests: matching feature tests for every touched feature.

EG-03 - Widget Soft Cleanup:
- Review every presentation widget at or above 400 lines.
- Split multi-section widgets; document cohesive exceptions.
- Prioritize high-risk widgets in Wallet, P2P, Auth/Profile security, Trade,
  Earn, Predictions, and Arena before lower-risk display widgets.

EG-04 - Painter And Chart Cleanup:
- Review chart/painter files at or above 400 lines.
- Split calculations, legends, toolbars, data models, and painters only when
  responsibilities are mixed.
- Preserve rendering behavior, labels, semantics, and theme-token colors.

EG-05 - Controller And Provider Responsibility Audit:
- Review controllers at or above 350 lines.
- Keep public provider/controller contracts stable.
- Move only reusable formatting, mapping, or fixture-heavy helpers when found.

EG-06 - Repository And Fixture Audit:
- Review data repositories at or above 400 lines.
- Keep public repository APIs stable.
- Move large static fixtures before touching logic.
- Treat fail-closed repositories as cohesive unless a clear isolated boundary
  exists.

EG-07 - Domain Entity Cohesion Audit:
- Review domain entity files at or above 500 lines.
- Split only by bounded context or value-object family.
- Preserve constructors, fields, equality behavior, serialization helpers, and
  imports used by tests or repository mocks.

EG-08 - Router Facade And Route Group Audit:
- Review router files at or above 500 lines.
- Preserve public router facade: createAppRouter, appRouter, AppRoutePaths,
  and AppRouteNames.
- Do not change existing route paths or names.
- Required tests: router tests and analyzer.

EG-09 - Test Suite Decomposition Audit:
- Review test files at or above 700 lines.
- Split only when behavior grouping improves diagnosis.
- Preserve coverage and expectations.
- Run changed test files and any broader suite they support.

EG-10 - Architecture Boundary Audit:
- Presentation and shared UI must not import features/*/data.
- App-level provider aggregation may import feature data providers only as
  composition root.
- No runtime `Colors.*` in lib/.
- No repeated local scaffolds where shared primitives already exist.
- Fix violations or document safe exceptions.

EG-11 - Product Boundary And Financial Safety Audit:
- Verify high-risk flows still show preview/confirm.
- Verify fees, risk, limits, and next steps remain visible.
- Verify sensitive data remains masked.
- Verify Arena stays points-only.
- Verify Prediction Markets remains wallet/positions/probability/receipt/PnL
  oriented.
- Update product copy guardrails if safety copy moved to new files.

EG-12 - Final Enterprise Verification:
- Run final inventory scans.
- Confirm no packet remains `[ ]` or `[~]`.
- Confirm all hard gates are closed.
- Run required final commands.
- Record final inventory, commands, exceptions, and GitNexus/fallback notes.

REQUIRED VERIFICATION BY CHANGE TYPE:

Any Dart source edit:
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact

If a listed feature test directory or test file does not exist, do not invent a
new requirement. Run `Test-Path <path>` or `Get-ChildItem test/features` to
confirm, then run the closest relevant suite or document the test as not
applicable in the packet notes.

P2P:
flutter test test/features/p2p --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact

Wallet:
flutter test test/features/wallet --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact

Auth/profile security:
flutter test test/features/auth --reporter=compact
flutter test test/features/profile --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact

Trade/copy/bot/leverage/regulatory:
flutter test test/features/trade --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact

Earn/staking/savings:
flutter test test/features/earn --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact

Predictions:
flutter test test/features/predictions --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact

Arena:
flutter test test/features/arena --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact

Launchpad:
flutter test test/features/launchpad --reporter=compact

Markets:
flutter test test/features/markets --reporter=compact

DCA:
flutter test test/features/dca --reporter=compact

Discovery:
flutter test test/features/discovery --reporter=compact

Admin:
flutter test test/features/admin --reporter=compact

Support:
flutter test test/features/support --reporter=compact

Router/navigation:
flutter test test/app/router --reporter=compact
flutter analyze

Tests changed:
flutter test <changed-test-file> --reporter=compact
Run the broader feature or quality suite that the changed test protects.

Final required commands from flutter_app/:
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact

Run broad tests when router, shared widgets, or many feature modules were
touched:
flutter test --reporter=compact

ARCHITECTURE RULES:
- Treat flutter_app/ as the app package and source of truth.
- Do not recreate old React/Vite/Tailwind/root npm tooling.
- Keep app bootstrap, theme, router facade, and shell composition in app/.
- Keep non-UI cross-cutting boundaries in core/.
- Keep reusable UI primitives in shared/.
- Keep screen widgets under features/<feature>/presentation/pages/.
- Keep extracted UI under features/<feature>/presentation/widgets/.
- Keep repository contracts and value objects under domain/.
- Keep mock/remote implementations and Riverpod providers under data/.
- Prefer package:vit_trade_flutter/... imports across modules.
- Do not add presentation page/widget imports from features/*/data.
- Do not add runtime Colors.* in flutter_app/lib/.
- Do not add hardcoded Color(0x...) outside flutter_app/lib/app/theme/ unless
  already allowed by existing theme-token patterns.
- Keep dark theme baseline.
- Preserve phone-first layouts at 360 px and up.

PRODUCT SAFETY RULES:
- Wallet, P2P, Trade, Auth, Profile security, and high-risk flows must preserve
  preview, confirmation, fee/risk/limit/next-step copy, and accessibility
  semantics.
- Do not remove masking of sensitive account, wallet, email, phone, address, or
  security data.
- Arena must stay points-only. Do not use payout, wallet, profit, or
  stake-return language for Arena.
- Prediction Markets can use positions, probability, receipt, rewards, and P/L.
- Avoid hype, casino, guaranteed-return, or hidden-fee language.
- Cross-module pages must keep Prediction Markets and Open Arena separated.

GIT/WORKTREE SAFETY:
- The worktree may already be dirty.
- Do not revert or overwrite changes you did not make.
- Do not run git reset --hard.
- Do not run git checkout -- to discard files.
- Do not stage, commit, or push unless explicitly requested.
- Use apply_patch for manual edits.
- Avoid broad unrelated formatting churn.

TRACKER UPDATE FORMAT:
After each packet, update the packet notes with:
- status `[x]`, `[~]`, or `[!]`
- before line counts
- after line counts
- files reviewed
- files split
- new files created
- documented exceptions
- commands run and exact pass/fail results
- GitNexus findings or fallback reason
- if no edit was required, the audit evidence and "No source edit required"

BLOCKER RULE:
Only mark `[!]` if the packet cannot continue without external user input,
external state, or a deliberate documented exception. A test failure, analyzer
failure, or compile failure is not a blocker by itself. Debug and fix local
failures.

FINAL RESPONSE WHEN ALL PACKETS COMPLETE:
When EG-00 through EG-12 are all `[x]` or `[!]`, run final verification and
report:
- packets completed
- remaining hard breaches
- documented soft exceptions
- final verification commands and results
- path to the updated tracker

If all packets are complete, do not include a RESUME FROM line.
```
