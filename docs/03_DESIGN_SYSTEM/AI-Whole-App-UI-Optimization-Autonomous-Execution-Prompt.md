# AI Whole-App UI Optimization Autonomous Execution Prompt

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the Whole-App UI Optimization Tracking Plan automatically, in order, without
stopping after partial progress.

This prompt is not a request to create another plan. It is a request to execute
the existing optimization plan, conserve context, use the most relevant
available skills and MCP tools, keep moving through the ordered phases, and
stop only at a real completion gate or a proven blocker.

Plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-UI-Optimization-Tracking-Plan.md
```

Primary evidence and references:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Screen-Real-Estate-Optimization-Strategy.md
docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-Visual-Density-Root-Cause-Report.md
docs/03_DESIGN_SYSTEM/VitTrade-Visual-Density-Root-Cause-Analysis.md
docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-Visual-Density-Real-Audit-Report.md
flutter_app/run-artifacts/visual-density/whole_app_visual_density_root_cause_matrix.csv
docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md
docs/03_DESIGN_SYSTEM/Guidelines.md
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE

Execute the Whole-App UI Optimization Tracking Plan:

docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-UI-Optimization-Tracking-Plan.md

Bring the whole Flutter app to the project UI optimization standard:

- Flutter Enterprise-Grade.
- Dark professional crypto trading super-app.
- Phone-first at 360 px and up.
- Home screen as the visual density and shared-component baseline.
- First-viewport usefulness as a completion gate.
- Shared component driven before local scaffolds.
- Density-aware shared components and token governance.
- Tokenized colors, typography, spacing, radii, surfaces, controls, and states.
- Financial-safety-first.
- Prediction Markets and Open Arena copy/currency boundaries remain separate.
- Accessibility, semantics, touch targets, and responsive behavior preserved.
- No regressions in routes, providers, domain behavior, masking, safety copy,
  business logic, tests, or navigation edges.

CURRENT RESUME BASELINE - 2026-06-20

Start from the latest reality check in section `0A` of:

docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-UI-Optimization-Tracking-Plan.md

Do not restart Phase 0-4 unless a fresh audit proves the reality check is
wrong. The current state is:

```text
overall_completion_estimate=75%
routed_screens=414
P0_CRITICAL_DENSITY_REVIEW=0
P1_HIGH_DENSITY_REVIEW=0
P1_TOOL_VISUAL_QA=5
P2_MEDIUM_DENSITY_REVIEW=113
P3_LOW_DENSITY_REVIEW=150
PASS_MONITOR=146
```

Regular P0/P1 remediation is complete. The remaining work is to close release
gates, finish manual tool QA, assign P2/P3 rows, and prove the whole app with
current audits, analyzer, tests, and viewport evidence.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT

- Do not create another plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which phase, module, screen, or batch to run next when
  the tracking plan defines the order.
- Do not jump to random screens.
- Execute the remaining work in this order unless fresh audits prove a different
  earlier dependency is broken:
  1. Regenerate or resolve stale generated audit artifacts.
  2. Fix the `flutter analyze` warning in
     `profile_api_key_create_result.dart`.
  3. Fix 360x800 responsive overflows for Address Book, Prediction Event, and
     Arena Challenge.
  4. Capture/refresh manual QA evidence for all 5 `P1_TOOL_VISUAL_QA` routes.
  5. Assign every P2/P3 row to fixed, accepted exception, or monitor
     when-touched.
  6. Run Phase 6 full verification and update final documentation.
- Within each phase, execute tasks in order unless a fresh audit proves a task
  is already complete or a dependency forces another eligible task first.
- If a task is already complete, verify it from source, audits, and tests, mark
  it complete with evidence, and continue.
- If a task is blocked, make at least 3 concrete attempts to resolve it or route
  around it before marking blocked.
- If one task is blocked but another eligible task remains, continue to the next
  eligible task.
- Do not stop after one file, one screen, one component, one phase, one audit
  pass, one test pass, one emulator screenshot, or one plan update.
- Do not mark final completion until the full completion target in the tracking
  plan passes.

NON-STOP CONTRACT

Keep executing automatically until exactly one of these stop conditions is true:

1. The full completion target in
   `VitTrade-Whole-App-UI-Optimization-Tracking-Plan.md` passes.
2. A real blocker prevents all further progress after at least 3 concrete
   attempts and no eligible fallback task or batch remains.
3. A hard platform/tool failure prevents further commands or edits after the
   agent has already tried to continue the next eligible task.
4. The user explicitly asks you to stop or change direction.

A completed task is not a valid final answer if more eligible work remains.
A completed phase is not a valid final answer if the next phase is eligible.
Large remaining scope is not a blocker.
Token pressure is not a blocker.
Use focused reads, generated CSV filters, GitNexus, Headroom compression, and
concise updates to keep working.

VOLUNTARY HANDOFFS ARE FORBIDDEN

- Do not stop because a batch is complete.
- Do not stop because focused tests passed.
- Do not stop because full tests passed.
- Do not stop because the plan was updated.
- Do not stop because the next task is ready.
- Do not stop because the answer would be a clean progress summary.
- Do not stop because the remaining queue is long.
- Do not stop because the work feels repetitive.
- Do not stop after writing `RESUME FROM:` unless a valid stop condition above
  is actually true.

If another eligible task exists, the next action is to start that task, not to
tell the user where to resume.

If all completion targets pass, end the final response with exactly:

```text
WHOLE-APP UI OPTIMIZATION COMPLETE
```

Only if a valid stop condition forces the turn to end before completion, end the
final response with exactly:

```text
RESUME FROM: <phase> - <exact next task/screen/route group>
```

Do not write anything after the `RESUME FROM:` line.

AUTONOMOUS EXECUTION LOOP

Run this loop continuously:

```text
while whole-app UI optimization is not complete:
  1. Refresh local truth:
     - read the current checkpoint in the tracking plan
     - read only the relevant source reports and matrix rows for the active task
     - confirm current audit status and git status
  2. Select the next eligible task:
     - use the phase/task order from the tracking plan
     - use the 414-screen matrix for route-level priority
     - skip completed rows only when fresh audits or plan evidence prove they
       are complete or accepted exceptions
  3. Perform pre-edit safety:
     - use GitNexus query/context for unfamiliar code
     - run GitNexus impact(direction: "upstream") before editing any Dart
       function, class, method, shared component, or route-sensitive symbol
     - if impact is HIGH or CRITICAL, report the risk and narrow the change
       before proceeding
  4. Implement incrementally:
     - keep each change small and testable
     - prefer shared primitives and tokens
     - preserve financial safety, accessibility, and domain boundaries
     - avoid one-off compact widgets
  5. Verify the active slice:
     - run targeted format/analyze/tests/audits
     - run emulator or widget viewport QA when the task touches visible layout
     - fix failures before moving on
  6. Update the tracking plan:
     - mark task status and evidence
     - record commands/tests/audit deltas
     - update next eligible task
  7. Continue:
     - if another eligible task remains, start it immediately
     - do not final unless a valid stop condition is true
```

END-OF-TURN GUARD

Before sending any final response, perform this self-check:

1. Did the full completion target pass?
2. If not, is every remaining eligible task blocked after 3 concrete attempts?
3. If not, did a hard platform/tool failure prevent further commands or edits
   after trying to start the next eligible task?
4. If not, did the user explicitly stop or redirect the work?
5. If not, have I already started the next eligible task after updating the
   plan for the previous task?

If answers 1-4 are "no", do not final. Continue.
If answer 5 is "no", do not final. Start the next eligible task now.

LANGUAGE REQUIREMENT

- Keep docs, plan updates, evidence notes, technical summaries, and generated
  report text in English.
- Keep code symbols, component names, commands, route names, audit fields, and
  test names exactly as they appear in source.
- Do not translate Flutter UI business copy unless the active task explicitly
  asks for localization.

MANDATORY READING BEFORE CODE EDITS

Read enough of these files to obey current project rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-UI-Optimization-Tracking-Plan.md`
7. `docs/03_DESIGN_SYSTEM/VitTrade-Screen-Real-Estate-Optimization-Strategy.md`
8. `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-Visual-Density-Root-Cause-Report.md`
9. `docs/03_DESIGN_SYSTEM/VitTrade-Visual-Density-Root-Cause-Analysis.md`
10. `flutter_app/run-artifacts/visual-density/whole_app_visual_density_root_cause_matrix.csv`
11. `docs/03_DESIGN_SYSTEM/VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md`
12. `flutter_app/lib/shared/widgets/widgets.dart`
13. Current source files, local widgets, shared primitives, and focused tests
    for the active task only.

Do not load the full repository into context. Use `rg`, GitNexus, generated CSV
filters, and focused file reads.

DOCUMENT PRECEDENCE

If documents conflict:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundary rules win over visual cleanup.
5. `VitTrade-Whole-App-UI-Optimization-Tracking-Plan.md` defines this work order.
6. `VitTrade-Screen-Real-Estate-Optimization-Strategy.md` defines the
   optimization standard.
7. `VitTrade-Whole-App-Visual-Density-Root-Cause-Report.md` and the matrix
   define the current measurable backlog.
8. `VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md` defines
   the completed shared-component baseline.
9. Generated audits define current measurable status.

SOURCE OF TRUTH

- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Feature screens: `flutter_app/lib/features/<feature>/presentation/pages/`
- Feature widgets: `flutter_app/lib/features/<feature>/presentation/widgets/`
- Tests: `flutter_app/test/`
- Public router facade: `flutter_app/lib/app/router/app_router.dart`
- Tracking plan:
  `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-UI-Optimization-Tracking-Plan.md`
- Density matrix:
  `flutter_app/run-artifacts/visual-density/whole_app_visual_density_root_cause_matrix.csv`
- Generated audits:
  `docs/02_FLUTTER_MIGRATION/`

Do not recreate obsolete React, Vite, npm, Tailwind, or old web screenshot
tooling.

MANDATORY PREFLIGHT

From repo root:

```powershell
git status --short
node .gitnexus/run.cjs status
```

MCP connectivity:

```text
GitNexus MCP: list_repos
Headroom MCP: headroom_stats
```

From `flutter_app/`:

```powershell
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
```

If `visual_density_risk_audit.dart` already exists, also run:

```powershell
dart run tool/visual_density_risk_audit.dart --check
```

If generated artifacts are stale, regenerate them with the matching tool and
rerun the `--check` command before selecting the next task.

CURRENT EXPECTED BASELINE

The latest checked baseline is the 2026-06-20 reality check from tracking-plan
section `0A`:

```text
routed_screens=414
features=23
P0_CRITICAL_DENSITY_REVIEW=0
P1_HIGH_DENSITY_REVIEW=0
P1_TOOL_VISUAL_QA=5
P2_MEDIUM_DENSITY_REVIEW=113
P3_LOW_DENSITY_REVIEW=150
PASS_MONITOR=146
official_audit_blind_spot=113
shared_component_compliant_but_sparse=113
tokenized_fixed_height_pressure=73
vertical_gap_accumulation=16
spacer_driven_looseness=33
manual_content_density_bypass=18
bottom_nav_inset_pressure=311
root_top_chrome_first_viewport_cost=11
```

If fresh audits disagree, trust fresh audits and update the tracking plan before
continuing. Never use the older 2026-06-19 P0/P1 backlog as the starting queue.

SKILL ROUTING

Use the smallest relevant skill set for the active task. Read each selected
`SKILL.md` completely before applying it.

Always use when applicable:

- `planning-and-task-breakdown`: preserve phase order, task dependencies,
  acceptance criteria, checkpoints, and tracking status.
- `vittrade-ui-checklists`: translate UI density, accessibility, loading,
  empty/error states, motion, financial safety, and domain-boundary guidance
  into Flutter/VitTrade terms.
- `frontend-ui-engineering`: when editing visible screens, shared layout, or
  shared widgets.
- `incremental-implementation`: whenever a task touches more than one file.
- `test-driven-development`: when behavior, widget expectations, states, or
  audit behavior changes.
- `debugging-and-error-recovery`: when commands fail, tests fail, analyzer
  fails, emulator QA differs from expectation, or audit results are stale.
- `code-review-and-quality`: before claiming completion of a broad phase or
  final completion.
- `security-and-hardening`: when touching financial, wallet, withdrawal,
  security, API key, account, P2P, escrow, address, or payment-method flows.
- `gitnexus-exploring`: when locating unfamiliar flows, screen structure, or
  shared component usage.
- `gitnexus-impact-analysis`: before editing any Dart symbol.
- `ui-ux-pro-max`: when visual hierarchy, density, spacing, screen rhythm, or
  component choice is ambiguous.

Optional external UI checklist through `vittrade-ui-checklists`:

- Use `ibelick/baseline-ui` only for spacing, hierarchy, empty-state, and
  visual polish.
- Use `ibelick/fixing-accessibility` only for semantics, focus, forms,
  dialogs, disabled states, validation, or icon-only controls.
- Use `ibelick/fixing-motion-performance` only for animations, transitions,
  shimmer/skeleton, or scroll performance.
- Do not import web, React, Tailwind, Radix, shadcn, metadata, DOM, or browser
  implementation assumptions into Flutter screens.

MCP / TOOL ROUTING

Use available tools efficiently. Do not call irrelevant tools just to say they
were used.

- Use shell commands for `rg`, `dart format`, audit scripts, `flutter analyze`,
  `flutter test`, emulator commands, and generated artifact checks.
- Use GitNexus MCP before code edits:
  - `query` for unfamiliar flows.
  - `context` for target symbols.
  - `impact(direction: "upstream")` before modifying any function, class,
    method, shared component, or route-sensitive symbol.
  - Warn and narrow scope if impact is HIGH or CRITICAL.
  - `detect_changes()` before any commit or final broad handoff.
- Use Headroom MCP for token control:
  - Compress huge audit outputs, long logs, or large file excerpts.
  - Retrieve only the needed slice by query.
- Use `update_plan` when available to keep current phase/task visible.
- Use Android emulator QA when available for visual viewport evidence.
- Use iOS simulator MCP only if the task specifically targets iOS simulator
  verification or available project setup makes it useful.
- Use Codex Security MCP only if the task introduces or touches a plausible
  security-sensitive finding. Do not run a full security scan for normal visual
  spacing work unless the user asks.
- Use browser/Playwright only for web-rendered artifacts. This is a Flutter app;
  do not recreate obsolete React/Vite/web screenshot tooling.

TOKEN-EFFICIENT OPERATING RULES

- Prefer `rg` and generated CSV filters over reading entire directories.
- Prefer exact route rows from
  `whole_app_visual_density_root_cause_matrix.csv` over reading all reports.
- Prefer `Get-Content -TotalCount`, targeted `Select-String`, and exact file
  slices over full-file reads.
- Read only active batch screen files, directly imported local widgets, nearest
  shared primitives, and matching tests.
- Use GitNexus to locate relationships instead of broad manual exploration.
- Summarize command outputs in plan evidence; do not paste huge logs.
- Store large outputs with Headroom when needed.
- Keep user updates short and meaningful.
- Do not re-read unchanged large docs after every task; record the checkpoint
  and refresh only the section or CSV rows needed.

EDITING RULES

- Use `apply_patch` for manual edits.
- Do not use Python or shell write tricks to edit normal source/docs unless a
  generator script is intentionally being run.
- Do not revert user changes.
- Do not use destructive git commands.
- Before editing any Dart symbol, run GitNexus impact analysis.
- If impact is HIGH or CRITICAL, warn, narrow scope, and proceed only with a
  clearly safe minimal change.
- Keep docs and code ASCII unless the file already uses non-ASCII or business
  copy requires it.
- Add comments sparingly and only where they clarify non-obvious logic.

VISUAL DENSITY RULES

Optimize for first-viewport usefulness, not blindly smaller UI.

Required principles:

- Root pages must show meaningful content above bottom nav.
- Repeated cards should generally use compact density.
- Section gaps should use compact rhythm when the page is a dense fintech
  surface.
- Avoid stacking tall hero + tall summary + tall cards before actions.
- Avoid `Spacer()` inside fixed-height cards unless visual QA proves it is
  necessary.
- Replace manual gap stacks with shared section/card rhythm where possible.
- Bottom inset and sticky footer space must be budgeted against visible content.
- Fullscreen tools are intentional exceptions and require manual visual QA.

Do not:

- globally shrink typography,
- remove safety copy,
- remove touch comfort,
- replace shared primitives with local compact clones,
- introduce raw fixed sizes,
- hide important content behind bottom nav,
- compact charts/tools with generic content-page rules.

FINANCIAL SAFETY AND PRODUCT BOUNDARIES

Financial screens must remain explicit even when compact:

- show fees,
- show risks,
- show limits,
- show lockup/network/address details where applicable,
- mask sensitive values,
- preserve preview/confirm/receipt states,
- preserve next steps after high-risk actions.

Prediction Markets:

- may use positions, probability, receipt, rewards, and P/L;
- must avoid hype/casino language.

Open Arena:

- must stay points-only;
- must not use payout, wallet, profit, or stake-return language.

WORK QUEUE

Follow the tracking plan, but start from the 2026-06-20 reality check. Phases
0-2 are complete. Phases 3-4 have regular P0/P1 at zero, but still have open
verification/tool QA/responsive issues. Phase 5 and Phase 6 remain active.

Current next execution order:

```text
1. Regenerate or resolve stale audit artifacts:
   - back_navigation_behavior_audit.dart
   - body_component_consistency_audit.dart
   - design_token_consistency_audit.dart
   - home_entry_back_navigation_audit.dart
   - navigation_edge_audit.dart
   - top_header_action_audit.dart
   - top_header_global_access_policy_audit.dart
   - ui_fullscreen_density_audit.dart

2. Fix analyzer warning:
   - lib/features/profile/presentation/widgets/profile_api_key_create_result.dart
   - optional parameter `height` in `_TextInput` is never provided

3. Fix responsive QA failures at 360x800:
   - Address Book: bottom overflow by 9.0 px
   - Prediction Event: bottom overflow by 1.2 px
   - Arena Challenge: right overflow by 14 px

4. Capture/refresh manual QA evidence for all P1_TOOL_VISUAL_QA routes:
   - '/trade/:pairId/futures' -> FuturesPage, score 104
   - AppRoutePaths.tradeBots -> TradingBotsPage, score 66
   - '/trade/advanced-chart/:pairId' -> AdvancedChartPage, score 42
   - AppRoutePaths.enterpriseStates -> EnterpriseStatesPage, score 31
   - '/p2p/chat/:orderId' -> P2PChatPage, score 30

5. Process remaining P2/P3 queues:
   - assign each row to fixed, accepted exception, or monitor when-touched
   - prioritize highest P2 scores first
   - do not churn PASS_MONITOR rows without evidence

6. Run full release gate and final docs update.
```

Highest remaining P2 rows by current score:

```text
ReferralRewardsPage, AppRoutePaths.referralRewards, score 39
P2PDashboardPage, AppRoutePaths.p2pDashboard, score 39
StakingProofOfReservesPage, AppRoutePaths.earnProofOfReserves, score 39
BotPortfolioDashboardPage, AppRoutePaths.tradeBotPortfolioDashboard, score 38
LaunchpadGasTrackerPage, AppRoutePaths.launchpadGasTracker, score 38
StakingRegulatoryFrameworkPage, AppRoutePaths.earnRegulatoryFramework, score 38
CopyProviderDetailPage, '/trade/copy-provider/:providerId', score 37
PositionDashboardPage, AppRoutePaths.tradePositions, score 37
MarketMoversPage, AppRoutePaths.marketsMovers, score 37
ArenaStudioPage, AppRoutePaths.arenaStudio, score 37
```

Use the current official audit CSV for every per-screen decision:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv
```

Use the older root-cause matrix only for historical context or when the current
audit CSV does not include a field needed for root-cause explanation.

PER-SCREEN EXECUTION CHECKLIST

For every active screen row:

1. Open only that row in the matrix.
2. Record feature, route, page, priority, score, and root causes.
3. Find page file and directly imported widgets.
4. Use GitNexus query/context if unfamiliar.
5. Run GitNexus impact before editing Dart symbols.
6. Sketch first-viewport budget.
7. Identify dominant issue:
   - tokenized fixed height,
   - vertical gap stack,
   - `Spacer()`,
   - manual content density bypass,
   - bottom inset,
   - root top chrome,
   - fullscreen tool exception.
8. Implement the smallest reusable fix using shared primitives/tokens.
9. Preserve safety, accessibility, and domain boundaries.
10. Run focused format/analyze/tests/audits.
11. Capture emulator or widget viewport evidence for P0/P1 reference routes.
12. Update the tracking plan and audit evidence.
13. Continue to the next eligible task.

VERIFICATION COMMANDS

Use focused checks first, then broaden.

Common focused commands from `flutter_app/`:

```powershell
dart format --output=none --set-exit-if-changed <touched files>
flutter analyze
flutter test <focused test files> --reporter=compact
```

Audit commands from `flutter_app/`:

```powershell
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
```

Final broad commands:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --reporter=compact
```

If a command fails:

1. Switch to debugging-and-error-recovery.
2. Capture the minimal failure excerpt.
3. Fix the root cause.
4. Rerun the failing command.
5. Continue; do not hand off unless valid stop conditions are met.

PLAN UPDATE REQUIREMENTS

After each task:

- update task status,
- add date and command evidence,
- update audit counts when changed,
- record files touched,
- record any accepted exception,
- record next eligible task,
- preserve the full 414-screen accounting.

After each phase:

- run the checkpoint in the tracking plan,
- use code-review-and-quality before claiming phase completion,
- update the Tracking Board,
- start the next eligible phase immediately unless a valid stop condition is
  true.

FINAL COMPLETION GATE

Do not declare completion until all are true:

- P0 screens are zero or documented exceptions.
- P1 screens are zero or documented exceptions.
- All 5 tool routes have current manual QA evidence.
- P2 and P3 queues are not ignored; each row has fixed/accepted/monitor status.
- The pass/monitor queue remains stable; current checked count is 146 unless fresh audits change it.
- All 414 routed screens remain represented in the matrix.
- Shared-component and token audits pass.
- Route and navigation audits pass.
- Financial safety and Prediction/Arena boundaries are preserved.
- Emulator evidence confirms first-viewport density on representative routes.
- `flutter analyze` passes.
- `flutter test --reporter=compact` passes or any remaining failures are
  documented as pre-existing and unrelated with evidence.

FINAL RESPONSE FORMAT

If complete:

- summarize phases completed,
- list key audit/test evidence,
- list remaining accepted exceptions if any,
- end with:

```text
WHOLE-APP UI OPTIMIZATION COMPLETE
```

If forced to stop by a valid stop condition:

- summarize only the blocker and evidence,
- include the exact next eligible task,
- end with exactly:

```text
RESUME FROM: <phase> - <exact next task/screen/route group>
```

Do not write anything after the `RESUME FROM:` line.
````
