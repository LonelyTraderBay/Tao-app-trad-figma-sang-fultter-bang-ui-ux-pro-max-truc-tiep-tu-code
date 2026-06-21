# AI Enterprise-Grade UI Standardization Autonomous Execution Prompt

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the VitTrade enterprise-grade UI standardization plan automatically, in order,
without stopping midway, while using the available skills and MCP tools
efficiently and conserving context tokens.

This is an execution prompt. It is not a request to create another plan.

Plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Standardization-Plan.md
```

Primary audit inputs:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
flutter_app/run-artifacts/ui-ux-current-page-audit.md
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE

Execute this plan completely:

docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Standardization-Plan.md

Bring the whole Flutter app to one coherent enterprise-grade UI standard:

- 414 routed Flutter screens accounted for.
- Home is the visual baseline for dark app chrome, card rhythm, density,
  spacing, bottom navigation, and primary brand behavior.
- Shared Flutter primitives and theme tokens before local scaffolds.
- Consistent colors, surfaces, card treatment, spacing, radii, typography,
  density, and first-viewport usefulness across pages.
- Phone-first at 360 px and up.
- No unreviewed B/C/D body-grade pages.
- No unreviewed P2 density pages.
- Root page bundle token debt cleared or explicitly justified.
- Fullscreen tools documented with visual QA evidence.
- Financial safety, masking, preview/confirm, risk, fees, limits, and next
  steps preserved.
- Prediction Markets and Open Arena copy/currency/performance boundaries
  preserved.
- Final audit suite, `flutter analyze`, and focused/full tests pass.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT

- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which batch to run next when the plan defines the order.
- Do not jump to random screens.
- Do not stop after one screen, one module, one passing audit, or one passing
  test run if eligible work remains.
- Execute in this order:
  1. Phase 0 - Baseline and ledger setup.
  2. Phase 1 - Shared standard lock.
  3. Phase 2 - P0 visual consistency screens.
  4. Phase 3 - Module rollout.
  5. Phase 4 - Fullscreen tool QA.
  6. Phase 5 - Whole-app final gate.
- If a task is already complete, verify it from current source/audits/tests,
  record evidence, and continue.
- If one task is blocked but another eligible task remains, continue to the
  next eligible task.

NON-STOP CONTRACT

Keep executing automatically until exactly one of these stop conditions is true:

1. The full final gate in
   `VitTrade-Enterprise-Grade-UI-Standardization-Plan.md` passes.
2. A real blocker prevents all further progress after at least 3 concrete
   attempts and no eligible fallback batch remains.
3. A hard tool/platform failure prevents further commands or edits after the
   agent has already tried the next eligible path.
4. The user explicitly asks you to stop, pause, or change direction.

The following are not valid stopping reasons:

- A batch is complete.
- Focused tests passed.
- Full tests passed before the final plan gate is complete.
- The plan was updated.
- The next batch is ready.
- The remaining queue is large.
- The work is repetitive.
- Context is getting long; use Headroom and concise file reads.

If the final gate passes, end the final response with exactly:

```text
ENTERPRISE-GRADE UI STANDARDIZATION COMPLETE
```

If a valid stop condition forces an early handoff, end the final response with
exactly:

```text
RESUME FROM: <phase> - <exact next task/screen/module>
```

Do not write anything after the `RESUME FROM:` line.

MANDATORY READING BEFORE CODE EDITS

Read enough of these files to obey the current project rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
7. `docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Standardization-Plan.md`
8. `flutter_app/run-artifacts/ui-ux-current-page-audit.md`
9. Current audit CSV rows for the active batch only.
10. Current source files, direct local widgets, nearest shared primitives, and
    matching tests for the active batch only.

Do not load the entire repository into context. Use `rg`, GitNexus, CSV filters,
targeted file reads, and Headroom.

DOCUMENT PRECEDENCE

If documents disagree:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundaries win over visual cleanup.
5. `VitTrade-Enterprise-Grade-UI-Standardization-Plan.md` defines this work
   order.
6. Current generated audit artifacts define measurable status.
7. Older tracking docs that say "complete" are historical if the current
   2026-06-21 audit still reports debt or review queues.

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

SKILL ROUTING

Use the full available skill set selectively. "Use skills" means read the
relevant `SKILL.md` before applying that skill. Do not waste tokens by reading
unrelated skills.

Always use when applicable:

- `planning-and-task-breakdown`: maintain phase order, batch size, acceptance
  criteria, ledger, and checkpoints.
- `vittrade-ui-checklists`: translate UI polish into Flutter/VitTrade terms and
  preserve project constraints.
- `frontend-ui-engineering`: when editing any visible screen, layout, shared UI
  primitive, visual state, or interaction.
- `incremental-implementation`: when a batch touches more than one file.
- `test-driven-development`: when changing layout behavior, widget states,
  first viewport, controls, or safety/confirmation flows.
- `debugging-and-error-recovery`: when an audit, analyze command, test, build,
  simulator run, or route check fails.
- `code-review-and-quality`: before closing a module, a phase, or the final
  standardization gate.
- `security-and-hardening`: when touching P2P, wallet, withdrawal, address,
  payment-method, escrow, auth, KYC, API key, security, or other high-risk
  account/financial flows.
- `gitnexus-exploring`: when locating unfamiliar screen dependencies, flow
  ownership, or shared primitive usage.
- `gitnexus-impact-analysis`: before editing any Dart symbol.
- `ui-ux-pro-max`: when visual hierarchy, density, spacing, color usage, card
  treatment, or enterprise-grade polish is ambiguous.

Optional external checklist through `vittrade-ui-checklists`:

- Use `ibelick/baseline-ui` only for spacing, hierarchy, empty/loading/error
  state, and action clarity polish.
- Use `ibelick/fixing-accessibility` only for semantics, labels, focus, forms,
  dialogs, disabled states, validation, or icon-only controls.
- Use `ibelick/fixing-motion-performance` only for animation, shimmer,
  transition, or scroll-performance changes.
- Do not import web, React, Tailwind, Radix, shadcn, metadata, DOM, or browser
  assumptions into Flutter screens.

MCP / TOOL ROUTING

Use the available MCP/tools efficiently. Prefer the tool that gives the most
signal for the fewest tokens.

GitNexus MCP:

- Use `list_repos` once if repo targeting is unclear.
- Use `query` for unfamiliar concepts or route groups.
- Use `context` for each target screen class or shared primitive before editing.
- Use `impact({ direction: "upstream" })` before modifying any function, class,
  method, route, provider, controller, entity, repository contract, or shared
  primitive.
- If impact is HIGH or CRITICAL, warn, narrow scope, and prefer leaf/local
  widgets over shared/root symbols.
- Use `detect_changes()` before any commit, broad final handoff, or final gate.

Headroom MCP:

- Use Headroom to compress long audit output, large logs, GitNexus results,
  huge diffs, or long file excerpts.
- Retrieve by query only when needed.
- Do not use Headroom as source of truth for active source files; source on disk
  wins.

Shell:

- Use `rg` and `rg --files` first for search.
- Use PowerShell CSV filtering for audit rows.
- Use focused `Get-Content -TotalCount`, `Select-String`, and exact file reads.
- Use `dart format` on touched Dart files.
- Use `flutter analyze` and focused `flutter test` as required.

Patch/editing:

- Use `apply_patch` for manual file edits.
- Do not use destructive git commands.
- Do not revert unrelated dirty worktree changes.

Parallelism:

- Use `multi_tool_use.parallel` for independent file reads, `rg`, `Get-Content`,
  and non-mutating inspections.
- Do not run mutating commands in parallel.
- Do not run multiple Flutter test processes in parallel if they can contend
  for build locks.

Simulator / visual QA:

- Use available iOS/Android/simulator/browser tools only when they are relevant
  and available.
- For Flutter UI, prefer widget/responsive viewport tests first, then simulator
  evidence for fullscreen tool routes and high-risk representative screens.
- Do not recreate obsolete React/Vite/web screenshot tooling.

Codex Security:

- Do not run a full security scan for normal spacing cleanup.
- Use security skills/tools only if the batch touches a plausible security
  finding or changes sensitive account/financial behavior.

TOKEN-EFFICIENT OPERATING RULES

- Never read all 414 page files at once.
- Work one screen or one tight route family at a time.
- Prefer current audit CSV rows over long Markdown summaries.
- Prefer GitNexus relationship tools over broad manual greps.
- Read only:
  - the target page,
  - direct part files,
  - direct feature-local widgets,
  - the shared primitive being used/edited,
  - focused tests.
- Use Headroom for long command outputs before reasoning over them.
- Summarize evidence in the plan/ledger; do not paste huge logs.
- Keep user updates short.
- Do not rerun full `flutter test` after every small screen; run focused tests
  and audits per batch, then full tests at module/phase/final gates.
- Do not rerun `flutter pub get` unless dependencies or pubspec changed.

AUTONOMOUS EXECUTION LOOP

Repeat this loop until the final gate passes or a valid stop condition occurs:

```text
1. Refresh local truth:
   - inspect the standardization plan status
   - confirm audit artifacts are current
   - confirm 414 routed rows are still accounted for

2. Select the next eligible row:
   - Phase 0 before implementation
   - then Section 7 top immediate queue
   - then Section 8 surface consistency queue
   - then remaining root_page_bundle_summary debt by descending totalDebt
   - then visual-density P2 rows
   - then module rollout order: p2p, markets, trade, wallet, earn, launchpad,
     profile, predictions, arena, dca, auth, onboarding, notifications,
     support, discovery, cross_module, referral, rewards, news, admin, dev,
     enterprise_states, home

3. Explore only the active row:
   - read CSV row(s)
   - use GitNexus query/context
   - read target source and focused tests

4. Run impact checks:
   - before every Dart symbol edit
   - warn/narrow if HIGH or CRITICAL

5. Implement the smallest safe change:
   - shared primitives first
   - theme tokens first
   - preserve routes/providers/controllers/copy/safety
   - avoid broad shared changes unless justified

6. Verify:
   - format touched Dart files
   - design-token audit
   - body-component audit
   - visual-density audit
   - focused feature/widget tests
   - flutter analyze for substantial batches
   - broader tests when shared/router/high-risk behavior changed

7. Update ledger/evidence:
   - status
   - commands
   - GitNexus result
   - residual exception
   - next row

8. If another eligible row remains, start it immediately.
   Do not final between batches.
```

PHASE 0 - BASELINE AND LEDGER SETUP

Required actions:

```powershell
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
```

Confirm:

```powershell
$rows = Import-Csv ..\docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv
$rows.Count
# Expected: 414
```

Create/update a working ledger from:

```text
flutter_app/run-artifacts/ui-ux-current-page-audit.md
```

If the report is stale or missing, regenerate a merged report from the current
CSV artifacts before implementation. Do not block on making the report pretty;
the CSVs are authoritative.

PHASE 1 - SHARED STANDARD LOCK

Before broad rollout, confirm the cleanup vocabulary:

- normal content page: `VitPageLayout`, `VitPageContent`, `VitInsetScrollView`
- standard surfaces: `VitCard` with token padding/radius
- forms: `VitInput`, `VitCtaButton`, `VitHighRiskStatePanel`
- data lists: market row primitives, compact rows, tabular figures
- section rhythm: shared `VitSectionHeader` or established `VitPageContent`
  section patterns
- state handling: `VitSkeleton`, `VitEmptyState`, `VitErrorState`,
  `VitOfflineBanner`
- fullscreen tools: full workspace, visual QA, no generic compaction

Do not add a new component unless at least two screens need the same pattern or
the current shared primitive cannot safely express the standard.

PHASE 2 - P0 VISUAL CONSISTENCY SCREENS

Start with this exact queue:

1. `lib/features/markets/presentation/pages/social_signals_page.dart`
2. `lib/features/p2p/presentation/pages/p2p_home_page.dart`
3. `lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart`
4. `lib/features/markets/presentation/pages/social_sentiment_page.dart`
5. `lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart`
6. `lib/features/arena/presentation/pages/arena_production_ready_page.dart`
7. `lib/features/markets/presentation/pages/advanced_charts_page.dart`
8. `lib/features/arena/presentation/pages/arena_challenge_detail_page.dart`
9. `lib/features/markets/presentation/pages/market_news_page.dart`
10. `lib/features/p2p/presentation/pages/p2p_trading_level_page.dart`
11. `lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart`
12. `lib/features/markets/presentation/pages/market_screener_page.dart`
13. `lib/features/wallet/presentation/pages/dust_converter_page.dart`
14. `lib/features/earn/presentation/pages/savings_risk_assessment_page.dart`
15. `lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart`
16. `lib/features/earn/presentation/pages/staking_risk_assessment_page.dart`
17. `lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart`
18. `lib/features/earn/presentation/pages/savings_recommendations_page.dart`
19. `lib/features/earn/presentation/pages/staking_emergency_actions_page.dart`
20. `lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart`

Then continue by descending root page bundle token debt:

```powershell
Import-Csv ..\docs\02_FLUTTER_MIGRATION\VitTrade-Design-Token-Consistency-Audit.csv |
  Where-Object { $_.scope -eq 'root_page_bundle_summary' -and [int]$_.totalDebt -gt 0 -and $_.exception -eq 'no' } |
  Sort-Object {[int]$_.totalDebt} -Descending
```

PHASE 3 - MODULE ROLLOUT ORDER

After the immediate queue, finish modules in this order:

1. `p2p`
2. `markets`
3. `trade`
4. `wallet`
5. `earn`
6. `launchpad`
7. `profile`
8. `predictions`
9. `arena`
10. `dca`
11. `auth`
12. `onboarding`
13. `notifications`
14. `support`
15. `discovery`
16. `cross_module`
17. `referral`
18. `rewards`
19. `news`
20. `admin`
21. `dev`
22. `enterprise_states`
23. `home`

For each module:

- Filter all ledger rows for the module.
- Fix or classify every row.
- Run focused module tests.
- Run audits.
- Record module completion evidence.

PHASE 4 - FULLSCREEN TOOL QA

Do not compact these like normal pages:

- `EnterpriseStatesPage`
- `P2PChatPage`
- `AdvancedChartPage`
- `FuturesPage`
- `TradingBotsPage`

For each:

- Verify 360 px and representative device viewport.
- Confirm full workspace usage.
- Confirm controls are visible and reachable.
- Confirm no primary content is hidden by bottom nav, composer, or sticky
  footer.
- Capture screenshot, widget viewport assertion, or emulator QA artifact.
- Mark as `accepted_tool_exception` only with evidence.

PHASE 5 - FINAL GATE

Run:

```powershell
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
dart run tool/top_header_action_audit.dart
dart run tool/top_header_visual_archetype_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

From repo root:

```powershell
git diff --check
```

Run GitNexus:

```text
detect_changes(scope="all")
```

Final completion requires:

- 414 routed screens accounted for, unless routes intentionally changed and
  route tests/docs were updated.
- No unexpected B/C/D body-grade pages.
- No unreviewed `P2_MEDIUM_DENSITY_REVIEW` pages.
- `P3_LOW_DENSITY_REVIEW` rows fixed, accepted, or monitor-when-touched.
- Root-page-bundle token debt cleared or justified row by row.
- Fullscreen tool routes have evidence.
- `flutter analyze` passes.
- `flutter test --reporter=compact` passes.
- `git diff --check` passes.
- GitNexus `detect_changes()` has been recorded.

PER-SCREEN ACCEPTANCE CHECKLIST

For every routed screen:

- [ ] The route row is present in the 414-row ledger.
- [ ] The target page and direct widgets were read.
- [ ] GitNexus context/impact was run before Dart symbol edits.
- [ ] Page archetype is identified.
- [ ] Root cause is identified.
- [ ] Shared primitives are used where patterns match.
- [ ] Theme tokens are used; no new raw style debt.
- [ ] First viewport at 360 px is useful.
- [ ] Bottom nav/sticky controls do not hide primary content.
- [ ] Financial safety and masking are preserved where applicable.
- [ ] Arena and Prediction boundaries are preserved where applicable.
- [ ] Focused tests/audits pass.
- [ ] Ledger status and evidence are updated.

VERIFICATION COMMAND SELECTION

For a normal screen batch:

```powershell
cd flutter_app
dart format <touched dart files>
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/<feature> --reporter=compact
flutter analyze
```

For route/navigation changes:

```powershell
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter test test/app/router --reporter=compact
```

For shared primitive changes:

```powershell
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

For high-risk financial/security screens:

```powershell
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
flutter test test/features/<feature> --reporter=compact
```

For fullscreen/tool screens:

```powershell
dart run tool/top_header_visual_archetype_audit.dart --check
flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact
```

LEDGER EVIDENCE TEMPLATE

Append evidence after each batch:

```text
Batch:
Date:
Status:

Screens:
- 

Audit input:
- body grade:
- density priority:
- token debt:
- root causes:

Skills used:
- 

MCP/tools used:
- GitNexus:
- Headroom:
- simulator/browser:
- shell:

GitNexus:
- context target:
- impact target:
- risk:
- direct callers:
- affected processes:

Implementation:
- 

Safety / boundary review:
- financial safety:
- Arena / Prediction boundary:
- sensitive data masking:

Visual QA:
- viewport:
- route(s):
- result:
- artifact:

Verification:
- command:
- result:

Ledger update:
- status:
- residual exception:
- next row:
```

DIRTY WORKTREE RULES

- Assume unrelated existing changes belong to the user or previous generated
  work.
- Do not revert unrelated changes.
- Before editing a dirty file, inspect it and preserve unrelated work.
- Use small, scoped patches.
- Never use `git reset --hard` or destructive checkout commands.
- Run `git status --short` often enough to avoid confusion.

END-OF-TURN SELF-CHECK

Before sending any final response, answer:

1. Did the full final gate pass?
2. If not, are all remaining eligible tasks blocked after 3 concrete attempts?
3. If not, did a hard tool/platform failure prevent further commands after
   trying the next eligible path?
4. If not, did the user explicitly ask to stop?

If all answers are "no", do not final. Continue with the next eligible row.

FINAL ANSWER RULES

If the final gate passes:

- Summarize completed phases.
- Report final audit counts.
- Report key verification commands.
- End with exactly:

```text
ENTERPRISE-GRADE UI STANDARDIZATION COMPLETE
```

If a valid stop condition forces an early handoff:

- State the blocker and attempts made.
- End with exactly:

```text
RESUME FROM: <phase> - <exact next task/screen/module>
```

Do not write anything after the `RESUME FROM:` line.
````

