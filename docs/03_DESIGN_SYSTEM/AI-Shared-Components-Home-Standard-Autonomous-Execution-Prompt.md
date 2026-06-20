# AI Shared Components Home Standard Autonomous Execution Prompt

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the Shared Components Home Standard implementation plan automatically until the
project reaches the Flutter enterprise-grade UI standard.

This prompt is not a request to create another plan. It is a request to execute
the existing plan in order, conserve context, use the most relevant available
skills/tools, and keep working until completion or a proven blocker.

Plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md
```

Related evidence:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Shared-Component-Adoption-Audit.md
docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md
docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:

Execute the Shared Components Home Standard implementation plan:

docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md

The target standard is:

- Flutter enterprise-grade
- Dark professional crypto trading super-app
- Phone-first at 360 px and up
- Home UI standard as the visual baseline
- Shared component driven
- Tokenized colors, typography, spacing, radii, density, surfaces, and states
- Financial-safety-first
- Prediction Markets and Open Arena kept separate
- No regressions in routes, providers, business logic, masking, safety copy, or tests

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT:

- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which batch to run next when the plan defines the order.
- Do not jump to random screens.
- Do not stop after one file, one screen, one component, one batch, or one feature.
- Execute P0 -> P1 -> P2 -> P3 -> P4 from the plan.
- If a task is already complete, verify it from source/audits/tests, mark it complete with evidence, and continue.
- If a task is blocked, make at least 3 concrete attempts to resolve or route around it before marking blocked.
- If one task is blocked but another eligible task remains, continue to the next eligible task.
- Do not mark completion until the final acceptance gates pass.

NON-STOP CONTRACT:

Keep executing automatically until exactly one of these stop conditions is true:

1. The full Definition of Done in the implementation plan passes.
2. A real blocker prevents all further progress after at least 3 concrete attempts.
3. A hard platform/tool failure prevents further commands or edits after the
   agent has already tried to continue the next eligible batch.
4. The user explicitly asks you to stop or change direction.

A completed batch is not a valid final answer if more eligible work remains.
Two, three, or many completed batches are still not a valid final answer if
more eligible work remains.
Large remaining scope is not a blocker.
Token pressure is not a blocker. Use concise updates, Headroom compression,
focused file reads, and refreshed plan state to keep working. Only a hard
platform/tool failure that prevents further work is a valid handoff reason.

VOLUNTARY HANDOFFS ARE FORBIDDEN:

- Do not stop because a batch is complete.
- Do not stop because full tests passed.
- Do not stop because the plan was updated.
- Do not stop because the next batch is "ready".
- Do not stop because the answer would be a clean progress summary.
- Do not stop because the remaining queue is long.
- Do not stop because the work feels repetitive.
- Do not stop after writing `RESUME FROM:` unless a valid stop condition above
  is actually true.

If another eligible batch exists, the next action is to start that batch, not
to tell the user where to resume.

If work is complete, include this exact final line:

```text
SHARED COMPONENT HOME STANDARD COMPLETE
```

Only if a valid stop condition forces the turn to end before completion, end
the final response with exactly:

```text
RESUME FROM: <priority> - <exact next batch/component/screen group>
```

Do not write anything after the `RESUME FROM:` line.

AUTONOMOUS EXECUTION LOOP:

Run this loop continuously. Do not ask for permission between loop iterations
when the plan and audits already define the next eligible batch.

```text
while Definition of Done is not complete:
  1. Refresh the local truth:
     - read Section 0 and Section 13 of the implementation plan
     - read the latest generated audit CSV rows needed for the next batch
     - confirm whether the recorded next batch still has measurable debt
  2. Select the next eligible batch:
     - use Section 13 if it is current
     - otherwise use the latest audit CSV sorted by priority, scope, and debt
     - skip completed rows only when the audit row is pass/zero-debt or the
       plan records an accepted exception
  3. Execute the full batch workflow:
     - GitNexus context/impact before code edits
     - implement the smallest safe code change
     - format, audit, focused tests, analyzer, and required broad tests
     - GitNexus detect_changes after edits
  4. Update the implementation plan immediately:
     - Section 0 current checkpoint
     - evidence table / batch log
     - Section 13 next recommendation
     - changed audit counts
  5. Run `git diff --check` for the touched plan/doc files.
  6. If another eligible batch remains, begin that batch immediately:
     - refresh its audit row
     - read the target file
     - run GitNexus context/impact before edits
     - continue implementation when impact review is complete
     Do not send a final response between batches.
```

After a verified batch, the next action is always to start the next eligible
batch unless a stop condition is already true. A progress summary is not a stop
condition. Passing `flutter analyze` or the full test suite is not a stop
condition. Updating the plan is not a stop condition.

After updating the plan, immediately prove continuation by doing at least the
first read/impact step for the next eligible batch. If that cannot happen,
record the concrete hard failure in the plan and final response.

END-OF-TURN GUARD:

Before sending any final response, perform this explicit self-check:

1. Did the full Definition of Done pass?
2. If not, is every remaining eligible batch blocked after 3 concrete attempts?
3. If not, did a hard platform/tool failure prevent further commands or edits
   after I tried to start the next eligible batch?
4. If not, did the user explicitly stop or redirect the work?
5. If not, have I already started the next eligible batch after updating the
   plan for the previous batch?

If answers 1-4 are "no", do not final. Continue with the next batch. If answer
5 is "no", do not final; start the next eligible batch now.

LANGUAGE REQUIREMENT:

- Keep docs, batch logs, plan updates, evidence notes, and technical summaries in English.
- Keep code symbols, component names, commands, paths, audit fields, and test names exactly as they appear in source.
- Do not translate Flutter UI business copy unless the active task explicitly asks for localization.

MANDATORY READING BEFORE EDITS:

Read enough of these files to obey current project rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md`
7. `docs/03_DESIGN_SYSTEM/VitTrade-Shared-Component-Adoption-Audit.md`
8. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
9. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md`
10. `flutter_app/lib/shared/widgets/widgets.dart`
11. Current source files, local widgets, shared primitives, and tests for the active batch only.

Do not load the full repository into context. Use `rg`, GitNexus, focused file reads,
and generated audit CSVs to locate only the active batch.

DOCUMENT PRECEDENCE:

If documents conflict:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundary rules win over visual cleanup.
5. `VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md` defines this work order.
6. `VitTrade-Home-UI-Rollout-Playbook.md` defines Home-derived UI patterns.
7. Generated audits define current measurable status.

SOURCE OF TRUTH:

- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Feature screens: `flutter_app/lib/features/<feature>/presentation/pages/`
- Feature widgets: `flutter_app/lib/features/<feature>/presentation/widgets/`
- Tests: `flutter_app/test/`
- Public router facade: `flutter_app/lib/app/router/app_router.dart`
- Generated QA/audit docs: `docs/02_FLUTTER_MIGRATION/`

Do not recreate obsolete React, Vite, npm, Tailwind, or old web screenshot tooling.

CURRENT VERIFIED RESUME STATE:

This prompt must not be treated as the permanent source of resume truth. The
implementation plan and freshly generated audits are authoritative.

At the time this prompt was updated on 2026-06-18, the plan reports:

```text
Last verified: P3.Feature.21 savings_guide_tutorials.dart
Next batch: P3.Feature.22 savings_notification_preferences_summary.dart
total_debt=254
feature_widget_debt=254
feature-widget files with debt=73
scope_shared_layout_debt=0
scope_shared_widget_debt=0
scope_root_page_bundle_summary_debt=0
```

Before acting, verify this state from:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
```

If the plan and this prompt disagree, trust the plan. If the generated audit
CSV and the plan disagree, trust the freshly generated audit CSV and update the
plan before or during the next verified batch. Do not resume from an old hardcoded
hint when Section 0 or Section 13 records a newer batch.

SKILL AND TOOL ROUTING:

Use all relevant available skills/tools, but do not invoke unrelated skills just
because they exist. "Use all available skills" means:

- Discover and use the best relevant skill/tool for the current subtask.
- Read each selected `SKILL.md` fully before following it.
- Use the smallest useful skill set for the active batch.
- Avoid broad, repeated, or decorative searches that waste context.
- Record any unavailable requested capability as a note and continue with the best local fallback.

Mandatory or expected skill/tool usage:

1. GitNexus skills/tools:
   - Use GitNexus for code exploration, context, impact, and change detection.
   - Use `gitnexus-cli` or the local `.gitnexus/run.cjs` wrapper for status/analyze when needed.
   - Use `list_repos`, `query`, `context`, `impact`, and `detect_changes` as described below.

2. Headroom:
   - Use Headroom only to compress long GitNexus output, test logs, audit logs,
     route reports, diffs, or previous-batch evidence.
   - Retrieve compressed hashes before acting on compressed information.
   - Never treat Headroom as the source of truth for source files, tests, audits,
     financial safety, or this prompt.

3. UI/UX design skills:
   - Use `ui-ux-pro-max` when the batch requires visual design judgment,
     shared-component mapping, Flutter UI guidance, accessibility, responsive
     layout, or Home-style interpretation.
   - Run the design-system search once near the start of the run, not every batch:
     `fintech crypto trading enterprise dark mobile dashboard shared components`
   - Run the Flutter stack guideline search once near the start of the run:
     `flutter enterprise shared components theme tokens responsive accessibility`
   - Persist the resulting guidance in plan notes or Headroom if the output is long.

4. Debugging/refactoring skills:
   - Use GitNexus debugging when tests/analyzer fail and the cause is unclear.
   - Use GitNexus refactoring/rename only for deliberate symbol renames or
     structural refactors. Do not use find-and-replace for renames.

5. Visual QA/browser/emulator skills:
   - Use visual QA tools only when a batch changes first viewport hierarchy,
     bottom chrome clearance, dense grids, market rows, high-risk forms, shared
     layout primitives, or fullscreen Tool screens.
   - Prefer automated audit/test evidence first; use emulator/screenshot evidence
     when layout behavior cannot be proven by tests/audits.

Do not use unrelated data analytics, presentation, document, GitHub, security,
plugin, or image-generation skills unless the active batch explicitly needs them.

TOKEN-EFFICIENT EXECUTION RULES:

- Read only source files involved in the current batch.
- Use `rg --files` and `rg` instead of broad recursive dumps.
- Use generated CSVs for status instead of manually scanning every screen.
- Use GitNexus `query`/`context` to target the dependency graph, then inspect
  actual source from disk.
- Use Headroom for long logs; store durable facts in the plan.
- Keep batch size small enough to verify.
- Do not rerun full test suite after every tiny docs-only change.
- Do not paste huge source files into responses or docs.
- Do not update unrelated docs or formatting.

MANDATORY PREFLIGHT:

From repo root:

```powershell
git status --short
node .gitnexus/run.cjs status
```

Then check MCP connectivity:

```text
GitNexus MCP: list_repos
Headroom MCP: headroom_stats
```

Expected current MCP state from the latest verified run:

- GitNexus CLI/index can be healthy even when the GitNexus MCP transport is not
  connected in the current Codex thread.
- If `node .gitnexus/run.cjs status` reports the current commit as up-to-date
  but GitNexus MCP returns `Transport closed`, retry MCP a small number of
  times, record the limitation, and continue with source/audit/test fallback.
- For each code-edit batch while MCP is unavailable, make one `context` attempt,
  one `impact` attempt for each edited symbol/class, and one post-change
  `detect_changes` attempt. If all return the same transport failure, do not
  waste tokens repeating identical MCP calls in that batch.
- If GitNexus MCP works again, resume the normal `context` -> `impact` ->
  `detect_changes` workflow and record real graph evidence.

If GitNexus is stale, missing, corrupt, or unreliable:

```powershell
node .gitnexus/run.cjs analyze
```

Then confirm the indexed repository:

```text
GitNexus MCP: list_repos
```

From `flutter_app/`, regenerate or check current audits:

```powershell
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
```

If body-component artifacts are stale:

```powershell
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
```

Before selecting a batch, inspect the current plan sections:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md
  - 6. Current Audit Baseline
  - 7. Priority Roadmap
  - 8. Module Tracking Matrix
  - 9. Batch Workflow
  - 12. Definition Of Done For Full Adoption
  - 13. Current Next Batch Recommendation
```

Always trust freshly generated audit artifacts over historical counts in docs.

HOME COLOR STANDARD:

Home is the baseline, but code must use repo tokens instead of hardcoded hex.

Use:

- `AppColors.bg` for app dark baseline.
- `AppColors.surface`, `surface2`, `surface3` for surfaces.
- `AppColors.primary` for Home/trust accent.
- `AppColors.primarySoft` for soft warning/wallet/earn accents.
- `AppColors.accent` for markets/predictions/cross-module tech accent.
- `AppColors.text1`, `text2`, `text3` for readable hierarchy.
- `AppColors.buy` and `AppColors.sell` only for semantic movement/side/state.
- `AppModuleAccents` for module identity.
- `AppTextStyles` and `AppTextStyles.tabularFigures` for numbers.
- `AppSpacing`, `AppRadii`, `AppDensity`, and device metrics instead of raw local values.

Do not hardcode Home colors into feature screens.
Do not create local palettes.
Do not make a module one-color.

HOME COMPONENT STANDARD:

Use Home as a pattern library, not business logic to copy.

Home rhythm:

```text
compact announcement
-> financial/context hero
-> next action or primary CTA
-> ticker/status strip when useful
-> action launcher/tools
-> recent/resume section
-> discovery/cross-module section
-> dense lists or records
-> bottom-nav-safe content end
```

Shared mapping:

- Page shell: `VitPageLayout`, `VitPageContent`, `VitInsetScrollView`
- Header/chrome: `VitHeader`, `VitTopChrome`, `VitAutoHideHeaderScaffold`
- Surface/card: `VitCard`, `VitHeroGlow`
- CTA/action: `VitCtaButton`, `VitIconButton`, `VitInlineIconAction`
- Action launcher: `VitActionTileGrid`, `VitServiceTile`
- Text hierarchy: `AppTextStyles`, `VitSectionHeader`
- State/status: `VitStatusPill`, `VitAccentPill`, `VitMetricDeltaPill`
- High-risk state: `VitHighRiskStatePanel`, `VitOfflineBanner`, `VitErrorState`
- Forms/search: `VitInput`, `VitSearchBar`
- Tabs: `VitTabBar`
- Market/data: `VitMarketTickerStrip`, `VitMarketPairRow`,
  `VitRankedAssetRow`, `VitAssetAvatar`, `VitSparkline`
- Loading/empty/error: `VitSkeleton`, `VitEmptyState`, `VitErrorState`
- Discovery: `VitDiscoveryActionCard`
- Bottom sheet: `VitBottomSheet`, `VitSheetHandle`

Do not build a local equivalent when a shared primitive covers the same visual pattern.

ENFORCEMENT LEVELS:

- L0 token compliance: mandatory for every screen/component.
- L1 shared layout: mandatory when matching shell/card/state/header needs exist.
- L2 shared pattern: mandatory when specialized pattern exists.
- L3 local domain composition: allowed only for provider state, route logic,
  domain copy, safety copy, canvas/tool UI, or Arena/Prediction boundary.

Every remaining local composition must have a recorded L3 reason.

PRIORITY ORDER:

Execute the remaining plan in this priority order, but start from the current
verified checkpoint rather than restarting at P0:

1. P0 - Shared Foundation Cleanup
2. P1 - Launchpad Root Bundle Normalization
3. P2 - Routed Screen Body Grade Cleanup
4. P3 - Feature Widget Debt Reduction
5. P4 - Rare And Unused Shared Component Review

Do not repeat a lower-priority phase that is already verified complete unless a
fresh audit reintroduces measurable debt for that phase. If P0/P1/P2 are
complete or accepted with evidence, continue P3. If P3 reaches zero debt or all
remaining rows have accepted L3 reasons, continue P4.

Batch selection algorithm:

1. Read Section 0 of the plan for `Completed through` and `Next batch to execute`.
2. Read Section 13 for the current ordered queue.
3. Regenerate or check audits when the audit files are stale.
4. Validate the proposed next row:
   - If the row has debt or open work, execute it.
   - If the row is already pass/zero-debt, mark/confirm it and continue to the
     next row.
   - If the row is blocked, record the blocker and continue to the next eligible
     row in the same priority phase.
5. If Section 13 is stale, build the queue from the latest audit CSV:
   - P0/P1/P2 before P3/P4 when any open debt exists there.
   - Within P3, use feature-widget rows with `totalDebt > 0`, highest debt first,
     then stable path order, unless the plan records a better dependency order.
6. Never select a random screen just because it is nearby in source. Selection
   must be explainable from the plan or the latest audit.

Current verified queue begins with:

```text
P3.Feature.22 savings_notification_preferences_summary.dart
```

If that line is stale, trust Section 13 and the latest audit CSV instead.

BATCH SIZE:

- Shared primitive cleanup: 1 to 3 shared files per batch.
- High-risk financial or fullscreen Tool pages: 1 to 2 screens per batch.
- Standard screen cleanup: 2 to 5 screens per batch.
- Feature widget debt cleanup: 1 to 8 closely related widget files per batch.
- Rare/unused review: 5 to 10 components per decision batch.

Batch size is a verification boundary, not a stopping boundary. Prefer one
high-debt file per P3 batch when each batch requires full audit/analyze/full
suite evidence. Group multiple files only when they are tightly coupled,
share tests, and can be verified without increasing risk. After verifying one
batch, continue to the next batch automatically.

When choosing between small and large batches, optimize for:

1. Preserving route/provider/business behavior.
2. Keeping GitNexus impact review understandable.
3. Keeping focused tests obvious.
4. Leaving the plan in a truthful resume state after every batch.
5. Reducing measurable audit debt steadily.

GITNEXUS WORKFLOW:

Before editing any symbol:

1. Use `context` for the target class/function/component.
2. Use `impact({direction: "upstream"})` before modifying any function, class,
   method, shared primitive, route, provider, controller, entity, repository
   contract, or helper.
3. If impact is HIGH or CRITICAL, warn in the batch notes and narrow the edit.
4. Inspect direct callers/consumers from source before changing shared behavior.

After edits:

1. Run focused tests/audits.
2. Run `detect_changes({scope: "all"})`.
3. Record affected symbols/processes in the batch log.

Never rename with text search. Use GitNexus rename support for true symbol renames.

IMPLEMENTATION RULES:

- Use `apply_patch` for manual edits.
- Do not revert unrelated dirty worktree changes.
- Do not change route paths, provider ownership, domain objects, repositories,
  or business logic unless required by compile/test failures caused by the batch.
- Preserve widget keys where tests or routes depend on them.
- Preserve masking for wallet, account, email, phone, address, and payment identifiers.
- Preserve fees, limits, risk copy, preview, confirmation, submitting,
  success/error/offline, receipt, and next-step states.
- Do not remove labels/disclosures to reduce visual debt.
- Do not add decorative blobs, random gradients, marketing hero sections,
  unrelated animations, or noisy card nesting.
- Do not use emojis as UI icons.
- Use Semantics or accessible labels when replacing tap targets or custom controls.
- Use responsive constraints/LayoutBuilder-style patterns instead of fixed viewport sizes.

PRODUCT SAFETY RULES:

- Wallet, Trade, P2P, Earn, DCA, Launchpad, and Prediction flows must keep
  financial safety visible.
- Arena is always points-only. Do not introduce wallet, payout, profit,
  stake-return, USD payout, or P/L language into Arena.
- Prediction Markets may use positions, probability, open orders, receipt,
  rewards, and P/L.
- Prediction Markets and Open Arena must remain visually and semantically separate.
- `AppColors.buy` and `AppColors.sell` are semantic, not decorative.

VERIFICATION BY BATCH TYPE:

For docs-only plan/prompt updates:

```powershell
git diff --check -- <touched docs>
```

For shared primitive batches:

```powershell
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/features/home/home_page_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

For single-module feature batches:

```powershell
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter test test/features/<module> --reporter=compact
flutter analyze
```

For high-risk financial screens:

```powershell
cd flutter_app
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
```

For header/top-chrome/navigation changes:

```powershell
cd flutter_app
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_action_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_global_access_policy_guardrail_test.dart --reporter=compact
```

For broad or uncertain shared changes, run the full suite:

```powershell
cd flutter_app
flutter test --reporter=compact
```

If a generated audit artifact is stale, regenerate it with the matching tool,
then rerun the check command.

PLAN UPDATE REQUIREMENT:

After every verified batch, update:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md
```

This update is mandatory even when the code change is small. The next agent or
next compacted turn must be able to resume from the plan without reading the
entire thread history.

Always update these plan areas when applicable:

1. Header `Last verified`.
2. Section 0 `Current Progress Checkpoint`.
3. Current queue table in Section 0.
4. Verified execution snapshot or evidence table.
5. Batch log in chronological order.
6. Section 12 Definition of Done checkboxes only when a gate truly changes.
7. Section 13 Current Next Batch Recommendation.

Update the relevant status rows from `[ ] Todo` or `[ ] Review` to a truthful
state such as:

- `[x] Done`
- `[!] Blocked`
- `[~] Deferred`
- `[>] In progress`

Add or update a batch record with:

```text
Batch:
Date:
Agent:
Scope:
Home pattern applied:
Shared components applied:
L3 local reasons:
GitNexus evidence:
Headroom refs:
Tests/audits:
Before debt:
After debt:
Manual visual QA:
Notes:
```

If audit counts changed materially, update the Current Audit Baseline section.
If the next best batch changed, update Current Next Batch Recommendation.

Immediately after editing this plan, run:

```powershell
git diff --check -- docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md
```

For docs-only prompt/plan updates, this diff check is the required verification.
For code batches, this diff check is required in addition to code audits/tests.

The plan update must include the exact next resume target. Use the same target
in the final `RESUME FROM:` line if the turn is forced to end before the full
Definition of Done passes.

DEFINITION OF DONE:

The project is complete only when all are true:

- `scope_root_page_bundle_summary_debt=0`, or only documented accepted exceptions remain.
- `scope_feature_widget_debt=0`, or every remaining row is documented L3 domain local.
- `scope_shared_layout_debt=0`, or documented shared primitive exceptions remain.
- `scope_shared_widget_debt=0`, or documented shared primitive exceptions remain.
- Body-component audit has 0 Grade B rows, or every Grade B row has an accepted exception.
- All Tool screens have manual visual QA evidence.
- P0/P1 issue counts remain 0.
- Strict typography gate remains pass.
- P0 module gates for markets, P2P, profile, trade, and wallet remain pass.
- Rare/unused shared components have keep/adopt/deprecate decisions.
- Home baseline remains unchanged or intentionally updated with tests/docs.
- `flutter analyze` passes.
- Required focused tests pass.
- Full suite passes for broad shared primitive changes.

FAILURE HANDLING:

If tests or audits fail:

1. Determine whether the failure is caused by the current batch.
2. Fix current-batch regressions immediately.
3. If a generated artifact is stale, regenerate and rerun.
4. If the failure is unrelated and pre-existing, document it clearly and continue
   only if it does not invalidate the current batch.
5. Do not hide failures by weakening audit tools or tests.

OUTPUT STYLE:

- Give short progress updates while working.
- Do not paste large source files or huge logs into user responses.
- Report files changed, tests/audits run, GitNexus evidence, Headroom refs, and next batch.
- Final response must be concise unless a blocker requires detail.
- Do not use a final response as a progress update when another eligible batch
  can still be started in the same turn.
- Reporting the next batch is not a substitute for starting it. If the next
  batch is known and not blocked, continue with that batch instead of ending.
- If forced to hand off, state what was completed and make the final line the
  exact `RESUME FROM:` target from the updated plan.

START NOW:

1. Run mandatory preflight.
2. Read the required docs.
3. Resolve the current resume point from Section 0, Section 13, and latest audits.
4. Select the next eligible batch from the resolved queue.
5. Use GitNexus context/impact before edits.
6. Implement and verify.
7. Update the plan and run required diff checks.
8. Return to step 3 automatically.
9. Continue until the Definition of Done passes or a valid stop condition forces
   handoff.
````

## Resume Hint

At the time this prompt was last updated, the implementation plan recommends
resuming with:

```text
P3.Feature.22 savings_notification_preferences_summary.dart:
flutter_app/lib/features/earn/presentation/widgets/savings_notification_preferences_summary.dart
```

Current verified audit state at this update:

```text
total_debt=254
feature_widget_debt=254
feature-widget files with debt=73
shared/root debt=0
```

This hint is informational only. Before acting in a future session, rerun the
preflight and trust Section 0/Section 13 of the implementation plan plus the
latest generated audits over this hint.
