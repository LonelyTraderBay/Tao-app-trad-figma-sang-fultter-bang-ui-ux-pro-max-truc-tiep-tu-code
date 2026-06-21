# AI Whole-App Compact First-Viewport Root-Cause Autonomous Execution Prompt

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the whole-app compact first-viewport root-cause plan automatically, in order,
without stopping after partial progress.

This prompt is not a request to create another plan. It is a request to execute
the existing plan, conserve context, use the most relevant available skills and
MCP tools, keep moving through the ordered phases, and stop only at a real
completion gate or proven blocker.

Primary plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-Compact-First-Viewport-Root-Cause-Execution-Plan.md
```

Primary supporting references:

```text
AGENTS.md
docs/00_START_HERE.md
docs/03_DESIGN_SYSTEM/VitTrade-Screen-Real-Estate-Optimization-Strategy.md
docs/03_DESIGN_SYSTEM/VitTrade-Compact-First-Viewport-Density-Rollout-Report.md
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv
docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE

Execute the Compact First-Viewport root-cause plan:

docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-Compact-First-Viewport-Root-Cause-Execution-Plan.md

Fix the recurring empty-space and first-viewport waste problem across the
Flutter app at the root-cause level, not by random one-off page tweaks.

The work is complete only when the whole-app density target is reached or every
remaining row has a current fixed / accepted-exception / monitor-when-touched
status with evidence.

CURRENT VERIFIED BASELINE - 2026-06-20

Start from the current checked baseline in the plan:

```text
real_routed_pages=414
redirect_aliases_excluded=3
P0_CRITICAL_DENSITY_REVIEW=0
P1_HIGH_DENSITY_REVIEW=0
P1_TOOL_VISUAL_QA=5
P2_MEDIUM_DENSITY_REVIEW=96
P3_LOW_DENSITY_REVIEW=144
PASS_MONITOR=169
non_pass_rows_needing_tracking=245
P1_fullscreen_tool_visual_qa=5
P2_visual_density_review=4
P3_followup_review=2
Pass_or_low_signal=403
```

If fresh audits disagree, trust fresh audits, update your working notes, and
continue from the fresh state.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT

- Do not create another plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which batch to run when the execution plan defines the
  order.
- Do not jump to random screens.
- Do not stop after one file, one screen, one feature, one audit pass, one test
  pass, one emulator screenshot, or one plan update.
- If a task is already complete, verify it with current source/audits/tests,
  record evidence, and continue to the next eligible task.
- If one task is blocked but another eligible task remains, continue to the
  next eligible task.

NON-STOP CONTRACT

Keep executing automatically until exactly one of these stop conditions is true:

1. The whole-app completion target in the execution plan is achieved.
2. A real blocker prevents all further progress after at least 3 concrete
   attempts and no eligible fallback task or batch remains.
3. A hard platform/tool failure prevents further commands or edits after trying
   to continue with the next eligible task.
4. The user explicitly asks you to stop or change direction.

Large remaining scope is not a blocker.
Token pressure is not a blocker.
A completed batch is not a final answer if another eligible batch remains.

If all completion targets pass, end the final response with exactly:

```text
COMPACT FIRST-VIEWPORT ROOT-CAUSE ROLLOUT COMPLETE
```

Only if a valid stop condition forces the turn to end before completion, end
the final response with exactly:

```text
RESUME FROM: <phase> - <exact next task/screen/route group>
```

Do not write anything after the `RESUME FROM:` line.

MANDATORY READING BEFORE CODE EDITS

Read only the minimum necessary context:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-Compact-First-Viewport-Root-Cause-Execution-Plan.md`
4. The filtered CSV rows for the active batch
5. The target page/widget source and focused test files

Read these only when needed:

- `docs/03_DESIGN_SYSTEM/VitTrade-Screen-Real-Estate-Optimization-Strategy.md`
- `docs/03_DESIGN_SYSTEM/VitTrade-Compact-First-Viewport-Density-Rollout-Report.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`
- `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`

Do not load the whole repo into context. Use `rg`, GitNexus, CSV filters, and
focused file reads.

DOCUMENT PRECEDENCE

If documents conflict:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundary rules win over visual cleanup.
5. The compact first-viewport execution plan defines this work order.
6. Fresh generated audits define current measurable status.

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
- Current visual density audit:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`
- Current fullscreen density audit:
  `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`

Do not recreate obsolete React, Vite, npm, Tailwind, or old web screenshot
tooling.

MANDATORY PREFLIGHT

From repo root:

```powershell
git status --short
```

From `flutter_app/`:

```powershell
dart run tool/route_coverage_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
```

Use these only when the active batch touches relevant surfaces:

```powershell
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
```

MCP connectivity:

```text
GitNexus MCP: list_repos
Headroom MCP: headroom_stats
```

If artifacts are stale, regenerate them with the matching tool and rerun the
`--check` command before selecting the next task.

SKILL ROUTING

Use the smallest relevant skill set for the active task. Read each selected
`SKILL.md` completely before applying it. Do not call irrelevant skills just to
say they were used.

Always use when applicable:

- `planning-and-task-breakdown`: preserve phase order, acceptance criteria,
  checkpoints, and batch size.
- `frontend-ui-engineering`: when editing visible Flutter screens, shared
  layout, shared widgets, spacing, hierarchy, or first-viewport behavior.
- `vittrade-ui-checklists`: translate UI polish, accessibility, motion,
  loading/empty/error states, financial safety, and product-boundary guidance
  into Flutter/VitTrade terms.
- `incremental-implementation`: when a batch touches more than one file.
- `test-driven-development`: when widget expectations, first-viewport tests, or
  audit behavior changes.
- `debugging-and-error-recovery`: when analyzer, tests, audits, emulator QA, or
  build commands fail.
- `code-review-and-quality`: before claiming a phase or final completion.
- `security-and-hardening`: when touching wallet, withdrawal, account security,
  API key, P2P escrow, address, payment-method, KYC, or other sensitive flows.
- `gitnexus-exploring`: when locating unfamiliar flows, screen structure, or
  shared component usage.
- `gitnexus-impact-analysis`: before editing any Dart symbol.
- `ui-ux-pro-max`: when visual hierarchy, density, spacing, or component choice
  is ambiguous.

External UI checklist through `vittrade-ui-checklists`:

- Use `ibelick/baseline-ui` only for spacing, hierarchy, empty-state, and
  visual polish.
- Use `ibelick/fixing-accessibility` only for semantics, focus, forms,
  dialogs, disabled states, validation, or icon-only controls.
- Use `ibelick/fixing-motion-performance` only for animations, transitions,
  shimmer/skeleton, or scroll performance.
- Do not import web, React, Tailwind, Radix, shadcn, DOM, or browser
  implementation assumptions into Flutter screens.

MCP AND TOOL ROUTING

Use available tools efficiently:

- Use shell commands for `rg`, `dart format`, audit scripts,
  `flutter analyze`, `flutter test`, emulator commands, and generated artifact
  checks.
- Use GitNexus MCP before code edits:
  - `query` for unfamiliar flows.
  - `context` for target symbols.
  - `impact(direction: "upstream")` before modifying any function, class,
    method, shared component, or route-sensitive symbol.
  - Warn and narrow scope if impact is HIGH or CRITICAL.
  - `detect_changes()` before any commit or final broad handoff.
- Use Headroom MCP for token control:
  - compress huge audit outputs, large logs, or long file excerpts;
  - retrieve only the needed slice by query.
- Use `update_plan` when available to keep the active phase/task visible.
- Use Android emulator QA when visible viewport evidence is needed.
- Use iOS simulator MCP only if the active task specifically targets iOS
  simulator verification.
- Use Codex Security MCP only if the active task introduces or touches a
  plausible security-sensitive finding. Do not run a full security scan for
  normal spacing work unless asked.
- Use browser/Playwright only for web-rendered artifacts. This is a Flutter
  app; do not recreate obsolete web tooling.

TOKEN-EFFICIENT OPERATING RULES

- Work on one batch only: 1 shared primitive or 1-3 screens.
- Prefer `rg` and CSV filters over reading entire directories.
- Prefer exact route rows from
  `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`.
- Prefer `Get-Content -TotalCount`, targeted `Select-String`, exact file
  slices, and direct tests over broad reads.
- Read only active batch screen files, directly imported widgets, nearest
  shared primitives, and matching tests.
- Use GitNexus to locate relationships instead of broad manual exploration.
- Summarize command outputs; do not paste huge logs.
- Compress large outputs with Headroom when needed.
- Keep user updates short and meaningful.
- Do not re-read unchanged large docs after every task.

USEFUL CSV FILTERS

Run from repo root:

```powershell
# Current priority counts.
Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv |
  Group-Object visual_density_priority |
  Sort-Object Name |
  Select-Object Name,Count |
  Format-Table -AutoSize

# Highest-score P2 queue.
Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv |
  Where-Object {$_.visual_density_priority -eq 'P2_MEDIUM_DENSITY_REVIEW'} |
  Sort-Object {[int]$_.visual_density_risk_score} -Descending |
  Select-Object -First 20 feature,route,page,visual_density_risk_score,root_causes,source_files |
  Format-Table -AutoSize

# Feature-specific queue.
Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv |
  Where-Object {$_.feature -eq 'p2p' -and $_.visual_density_priority -ne 'PASS_MONITOR'} |
  Sort-Object visual_density_priority,{[int]$_.visual_density_risk_score} -Descending |
  Select-Object feature,route,page,visual_density_priority,visual_density_risk_score,root_causes,source_files |
  Format-Table -AutoSize

# Root-cause-specific queue.
Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv |
  Where-Object {$_.root_causes -match 'spacer_inside_cards'} |
  Select-Object feature,route,page,visual_density_priority,visual_density_risk_score,root_causes,source_files |
  Format-Table -AutoSize
```

EDITING RULES

- Use `apply_patch` for manual edits.
- Do not use Python or shell write tricks for normal source/docs edits.
- Do not revert user changes.
- Do not use destructive git commands.
- Before editing any Dart symbol, run GitNexus impact analysis.
- If impact is HIGH or CRITICAL, warn, narrow scope, and proceed only with a
  clearly safe minimal change or after user approval if risk remains.
- Keep docs and code ASCII unless the file already uses non-ASCII or business
  copy requires it.
- Add comments sparingly and only where they clarify non-obvious logic.

VISUAL DENSITY RULES

Optimize first-viewport usefulness, not blindly smaller UI.

Required principles:

- Root pages must show meaningful content above bottom nav.
- Repeated cards should generally use compact density.
- Section gaps should use compact rhythm on dense fintech surfaces.
- Avoid stacking tall hero + tall summary + tall cards before actions.
- Avoid `Spacer()` inside fixed-height cards unless visual QA proves it is
  necessary.
- Replace manual gap stacks with shared section/card rhythm where possible.
- Bottom inset and sticky footer space must be budgeted against visible content.
- Fullscreen tools are intentional exceptions and require visual QA evidence.

Do not:

- globally shrink typography,
- remove safety copy,
- remove touch comfort,
- replace shared primitives with local compact clones,
- introduce random raw fixed sizes,
- hide important content behind bottom nav,
- compact chart/trading/chat tools with generic content-page rules.

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
- must not use payout, wallet, profit, stake-return, P/L, casino, or hype
  language.

ROOT-CAUSE EXECUTION ORDER

Follow this order from the execution plan:

```text
Phase 0 - Audit Sync And Queue Selection
Phase 1 - Shared Foundation Guardrails
Phase 2 - Fixed-Height Token Cleanup
Phase 3 - Spacer-Inside-Card Cleanup
Phase 4 - Manual Content Density Migration
Phase 5 - Bottom-Nav Clearance Standardization
Phase 6 - Feature Rollout Queue
Phase 7 - Fullscreen Tool Evidence
```

Default feature rollout order:

```text
1. P2P
2. Earn
3. Launchpad
4. Trade content pages
5. Markets/lists
6. DCA
7. Wallet
8. Cross-module, Predictions, Support
9. Admin, Auth, Discovery, Referral, Rewards
10. P3 rows only when touched or when visual QA proves waste
```

Root-cause fix order inside a row:

```text
1. fullscreen exception
2. financial/product safety
3. root top chrome
4. fixed height
5. Spacer/expansion
6. manual density bypass
7. vertical gaps
8. bottom-nav clearance
```

PER-BATCH LOOP

Repeat this loop continuously:

```text
while rollout is not complete:
  1. Refresh local truth:
     - git status
     - relevant audit checks
     - filtered CSV rows for active batch
  2. Select next eligible batch:
     - one shared primitive OR 1-3 screens
     - P2 before P3
     - highest real root-cause impact first
  3. Pre-edit safety:
     - GitNexus query/context if unfamiliar
     - GitNexus impact(direction: "upstream") before editing Dart symbols
     - stop/warn only for HIGH/CRITICAL or true blockers
  4. Implement smallest root-cause fix:
     - shared primitive or token where safe
     - page-local fix only when shared fix would be too broad
     - preserve safety, readability, touch targets, and boundaries
  5. Verify:
     - dart format on touched files
     - focused widget tests
     - flutter analyze for shared/broad batches
     - density audits
     - emulator/widget viewport evidence when visual proof is needed
  6. Record evidence:
     - before/after priority and score
     - routes moved
     - tests run
     - residual static false positives if any
  7. Continue immediately to the next eligible batch unless a valid stop
     condition is true.
```

PER-SCREEN CHECKLIST

For every active screen:

1. Record feature, route, page, priority, score, and root causes.
2. Find page file and directly imported widgets.
3. Read the focused test or create/update one where feasible.
4. Use GitNexus query/context if unfamiliar.
5. Run GitNexus impact before editing target Dart symbols.
6. Identify the dominant cause:
   - tokenized fixed height,
   - vertical gap stack,
   - `Spacer()`,
   - manual content density bypass,
   - bottom inset,
   - root top chrome,
   - fullscreen tool exception.
7. Implement the smallest reusable fix.
8. Add/adjust first-viewport assertions using existing helpers when possible.
9. Run focused verification.
10. Continue.

TEST STRATEGY

Use `test/helpers/first_viewport_test_utils.dart` when possible.

Each touched screen test should prove:

- route semantic label or screen identity is present,
- at least one useful/actionable widget is in the usable first viewport,
- relevant bottom-nav or sticky-footer clearance is safe,
- no financial-boundary copy regression occurs,
- Arena remains points-only when Arena code is touched.

Focused test order from `flutter_app/`:

```powershell
dart format --output=none --set-exit-if-changed <touched Dart files>
flutter test <focused test files> --reporter=compact
flutter test test/features/<feature> --reporter=compact
flutter analyze
dart run tool/visual_density_risk_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
```

Run full test suite only after shared primitive changes, router/shell changes,
financial safety changes, or several feature batches:

```powershell
flutter test --reporter=compact
```

FULLSCREEN TOOL ROUTES

Do not compact these like normal content pages. Verify workspace use:

```text
trade /trade/:pairId/futures -> FuturesPage
trade AppRoutePaths.tradeBots -> TradingBotsPage
trade /trade/advanced-chart/:pairId -> AdvancedChartPage
enterprise_states AppRoutePaths.enterpriseStates -> EnterpriseStatesPage
p2p /p2p/chat/:orderId -> P2PChatPage
```

Evidence required:

- safe areas are correct,
- controls are reachable,
- workspace is nonblank,
- bottom controls/nav are not hiding useful content,
- screenshot/widget evidence is recorded.

STOP RULES

Stop the current batch and report only when:

- GitNexus impact remains HIGH/CRITICAL after narrowing,
- a shared primitive change would affect many unrelated surfaces without a
  focused test strategy,
- compaction would remove or weaken financial safety copy,
- Arena/Prediction boundaries would be mixed,
- a screen only passes by making text unreadable or touch targets unsafe,
- all eligible work is blocked after 3 concrete attempts,
- the user explicitly stops or redirects the work.

FINAL COMPLETION GATE

Do not declare completion until all are true:

- `P2_MEDIUM_DENSITY_REVIEW=0`
- `P3_LOW_DENSITY_REVIEW=0`
- `PASS_MONITOR=409`
- `P1_TOOL_VISUAL_QA=5` has current evidence or accepted tool exceptions
- route count remains `414`
- no P0/P1 regular density rows are introduced
- `flutter analyze` passes
- focused and required broad tests pass
- visual-density and fullscreen-density audits pass
- financial safety and Prediction/Arena boundaries are preserved
- changed files match selected batches

COMMIT / HANDOFF HYGIENE

Before a commit or broad final handoff:

1. Run GitNexus `detect_changes()` per `AGENTS.md`.
2. Confirm changed files match selected batches.
3. Do not revert unrelated dirty worktree changes.
4. Do not include generated logs, `build/`, `.dart_tool/`, `flutter_app/tmp/`,
   or `flutter_app/run-artifacts/`.
5. Summarize exact verification commands and audit deltas.

FINAL RESPONSE FORMAT

If complete:

- summarize phases completed,
- list audit/test evidence,
- list accepted exceptions if any,
- end with:

```text
COMPACT FIRST-VIEWPORT ROOT-CAUSE ROLLOUT COMPLETE
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
