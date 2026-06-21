# AI Trade UI Redesign Autonomous Execution Prompt

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the VitTrade Trade UI redesign plan automatically, in order, without stopping
midway, while using the available skills and MCP tools efficiently and
conserving context tokens.

This is an execution prompt. It is not a request to create another plan.

Plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Trade-UI-Redesign-Enterprise-Execution-Plan.md
```

Primary source files:

```text
flutter_app/lib/app/router/app_router.dart
flutter_app/lib/app/router/route_groups/trade_routes.dart
flutter_app/lib/app/router/app_route_paths.dart
flutter_app/lib/app/router/app_route_names.dart
flutter_app/lib/features/trade/
flutter_app/lib/shared/
flutter_app/lib/app/theme/
flutter_app/test/features/trade/
flutter_app/test/app/router/
flutter_app/test/quality/
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE

Execute this plan completely:

docs/03_DESIGN_SYSTEM/VitTrade-Trade-UI-Redesign-Enterprise-Execution-Plan.md

Redesign the Trade hub and every related `/trade` route into one coherent
Flutter enterprise-grade trading experience:

- 91 Trade GoRoute entries accounted for.
- 90 builder routes and 1 redirect route preserved unless deliberately changed.
- 16 direct navigation targets from the main Trade page verified and polished.
- Core Trade, Futures, Margin, Trading Bots, Risk/Execution tools, Copy Trading,
  and Compliance pages redesigned under one visual contract.
- Dark Flutter-native baseline preserved.
- Shared VitTrade primitives and theme tokens used before local widgets.
- Trade identity kept as an accent layer only.
- Phone-first layout works at 360 px and up.
- First viewport contains useful/actionable trading content.
- Loading, empty, error, offline, submitting, and success states are present
  where the flow needs them.
- High-risk Trade, futures, margin, bot, and copy-trading flows show preview,
  fees, limits, risk, and next steps before confirmation.
- Prediction Markets and Open Arena boundaries remain separate.
- Final audits, route checks, focused/full tests, analyze, and emulator/device
  visual QA pass.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT

- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which phase to run next when the plan defines the order.
- Do not jump to random pages.
- Do not stop after one page, one route group, one passing audit, or one passing
  test run if eligible work remains.
- If a task is already complete, verify it from current source/audits/tests,
  record evidence, and continue.
- If one task is blocked but another eligible task remains, continue to the
  next eligible task.
- If a tool output is large, compress/summarize it and continue.

NON-STOP CONTRACT

Keep executing automatically until exactly one of these stop conditions is true:

1. Phase 10 final gate in
   `VitTrade-Trade-UI-Redesign-Enterprise-Execution-Plan.md` passes.
2. A real blocker prevents all further progress after at least 3 concrete
   recovery attempts and no eligible fallback phase/task remains.
3. A hard tool/platform failure prevents further commands or edits after the
   agent has already tried the next eligible path.
4. GitNexus impact is HIGH or CRITICAL and the user has not acknowledged the
   risk.
5. The user explicitly asks you to stop, pause, or change direction.

The following are not valid stopping reasons:

- A phase is complete.
- Focused tests passed.
- Full tests passed before the final plan gate is complete.
- The next phase is ready.
- The route list is long.
- The work is repetitive.
- Context is getting long; use Headroom, targeted reads, and concise updates.
- One non-critical test fails; debug it with the debugging skill and continue.

If the final gate passes, end the final response with exactly:

```text
TRADE UI REDESIGN COMPLETE
```

If a valid stop condition forces an early handoff, end the final response with
exactly:

```text
RESUME FROM: <phase> - <exact next task/route/page>
```

Do not write anything after the `RESUME FROM:` line.

MANDATORY READING BEFORE CODE EDITS

Read enough of these files to obey the current project rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`
6. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`
7. `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`
8. `docs/03_DESIGN_SYSTEM/Guidelines.md`
9. `docs/03_DESIGN_SYSTEM/VitTrade-Trade-UI-Redesign-Enterprise-Execution-Plan.md`
10. Current source files and tests for the active phase only.

Do not load the entire repository into context. Use `rg`, GitNexus, targeted
file reads, route filters, and Headroom.

DOCUMENT PRECEDENCE

If documents disagree:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundaries win over visual cleanup.
5. `VitTrade-Trade-UI-Redesign-Enterprise-Execution-Plan.md` defines this work
   order.
6. Current generated audit artifacts define measurable status.
7. Older tracking docs that conflict with current Flutter source are historical.

SOURCE OF TRUTH

- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- Trade route group: `flutter_app/lib/app/router/route_groups/trade_routes.dart`
- Theme tokens: `flutter_app/lib/app/theme/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Trade pages: `flutter_app/lib/features/trade/presentation/pages/`
- Trade widgets: `flutter_app/lib/features/trade/presentation/widgets/`
- Trade controllers: `flutter_app/lib/features/trade/presentation/controllers/`
- Trade data/repository mocks: `flutter_app/lib/features/trade/data/`
- Tests: `flutter_app/test/`
- QA artifacts: `flutter_app/run-artifacts/`

SKILL ROUTING

Use the full available skill set selectively. "Use skills" means read the
relevant `SKILL.md` before applying that skill. Do not waste tokens by reading
unrelated skills.

Always use when applicable:

- `planning-and-task-breakdown`: maintain phase order, route coverage,
  acceptance criteria, checkpoints, and exact next task.
- `vittrade-ui-checklists`: translate UI polish into Flutter/VitTrade terms,
  preserve design tokens, shared widgets, financial safety, and domain
  boundaries.
- `ui-ux-pro-max`: use for design-system direction when visual hierarchy,
  density, color usage, typography, card treatment, or enterprise-grade polish
  is ambiguous.
- `frontend-ui-engineering`: when editing any visible screen, layout, shared UI
  primitive, responsive behavior, interaction, or state.
- `incremental-implementation`: when a batch touches more than one file.
- `test-driven-development`: when changing layout behavior, widget states,
  route behavior, controls, risk previews, or confirmation flows.
- `debugging-and-error-recovery`: when audits, analyze, tests, emulator runs,
  or builds fail.
- `code-review-and-quality`: before closing a route group, phase, or final gate.
- `security-and-hardening`: when touching sensitive financial/account behavior,
  confirmation flows, risk controls, copy-trading capital allocation, bot
  emergency stop, leverage, margin, or settings/security surfaces.
- `gitnexus-exploring`: when locating unfamiliar screen dependencies, flow
  ownership, controllers, repositories, route graph, or shared primitive usage.
- `gitnexus-impact-analysis`: before editing any Dart symbol.
- `build-ios-apps:ios-debugger-agent` or Android emulator QA skills/tools when
  visual validation on a simulator/emulator is needed and available.

Optional external checklist through `vittrade-ui-checklists`:

- Use `ibelick/baseline-ui` only for spacing, hierarchy, empty/loading/error
  state, and action clarity polish.
- Use `ibelick/fixing-accessibility` only for semantics, labels, focus, forms,
  dialogs, disabled states, validation, or icon-only/high-risk controls.
- Use `ibelick/fixing-motion-performance` only for animation, shimmer,
  transition, or scroll-performance changes.
- Do not import web, React, Tailwind, Radix, shadcn, metadata, DOM, or browser
  assumptions into Flutter screens.

MCP / TOOL ROUTING

Use available MCP/tools efficiently. Prefer the tool that gives the most signal
for the fewest tokens.

GitNexus MCP:

- Use `list_repos` once only if repo targeting is unclear.
- Use `query` for unfamiliar concepts, route groups, controllers, or flows.
- Use `context` for each target screen class, controller, repository, route
  helper, or shared primitive before editing.
- Use `impact({ direction: "upstream" })` before modifying any function, class,
  method, route, provider, controller, entity, repository contract, or shared
  primitive.
- If impact is HIGH or CRITICAL, warn, narrow scope, prefer leaf/local widgets,
  and wait for user acknowledgement before editing that symbol.
- Use `detect_changes()` before any commit, final handoff, or final gate.

Headroom MCP:

- Use Headroom to compress long audit output, large logs, GitNexus results,
  huge diffs, or long file excerpts.
- Retrieve by query only when needed.
- Do not use Headroom as source of truth for active source files; source on disk
  wins.

Shell:

- Use `rg` and `rg --files` first for search.
- Use PowerShell filters for route/test/audit rows.
- Use focused `Get-Content`, `Select-String`, `git diff`, `git status`, and
  exact file reads.
- Use `dart format` on touched Dart files.
- Use focused `flutter test` before broad full-suite tests.

Patch/editing:

- Use `apply_patch` for manual file edits.
- Keep patches small and scoped.
- Do not use destructive git commands.
- Do not revert unrelated dirty worktree changes.

Parallelism:

- Use `multi_tool_use.parallel` for independent file reads, `rg`, `Get-Content`,
  and other non-mutating inspections.
- Do not run mutating commands in parallel.
- Do not run multiple Flutter test processes in parallel if they can contend
  for build locks.

Simulator / emulator / visual QA:

- Use widget tests and responsive viewport tests first.
- Use emulator/device evidence for representative screens, high-risk flows,
  fullscreen chart/tool routes, and final visual QA.
- Store screenshots/videos under `flutter_app/run-artifacts/`.
- Do not recreate obsolete React/Vite/web screenshot tooling.

Codex Security:

- Do not run a full security scan for normal UI spacing/card cleanup.
- Use security skills/tools only if the batch touches plausible security
  findings or sensitive account/financial behavior.

TOKEN-EFFICIENT OPERATING RULES

- Never read all Trade files at once.
- Work one phase, route group, or tight route family at a time.
- Read only:
  - the active page,
  - its direct part files,
  - its direct feature-local widgets,
  - the shared primitive being used or edited,
  - the focused tests,
  - the controller/provider/repository only if needed for behavior.
- Prefer GitNexus relationship tools over broad manual greps.
- Prefer focused tests over full `flutter test` until phase/final gates.
- Do not rerun `flutter pub get` unless dependencies or `pubspec.yaml` changed.
- Compress large command output with Headroom.
- Keep user updates concise and only include high-signal progress.
- Record evidence in the plan or a small tracking note instead of pasting huge
  logs into the chat.

AUTONOMOUS EXECUTION LOOP

Repeat this loop until Phase 10 passes or a valid stop condition occurs:

```text
1. Refresh local truth:
   - check git status
   - read the active phase in the Trade redesign plan
   - inspect current route/source/test state for that phase only

2. Select next eligible task:
   - follow Phase 0 through Phase 10 in exact order
   - within each phase, follow the route groups and tests listed in the plan
   - if a task is already complete, verify it and continue

3. Explore only the active task:
   - use GitNexus query/context
   - read target page, part files, widgets, and focused tests
   - read shared primitive source only if using or editing it

4. Run impact checks:
   - before every Dart symbol edit
   - warn/narrow if HIGH or CRITICAL

5. Implement the smallest safe vertical slice:
   - shared primitives first
   - theme tokens first
   - preserve routes, providers, controllers, copy, and safety behavior
   - avoid broad shared changes unless justified by multiple pages

6. Verify:
   - format touched Dart files
   - focused tests listed for the active phase
   - route/navigation audits when navigation changes
   - design-token and density audits for UI changes
   - analyze for substantial batches

7. Record evidence:
   - files changed
   - skills used
   - MCP/tools used
   - GitNexus impact summary
   - commands and results
   - screenshots/artifacts if visual QA was run
   - exact next phase/task

8. If another eligible task remains, start it immediately.
   Do not final between phases.
```

PHASE ORDER

Execute in this exact order:

1. Phase 0 - Baseline and route audit.
2. Phase 1 - Trade UI contract and component mapping.
3. Phase 2 - Foundation components for Trade.
4. Phase 3 - Core Trade root, pair, and advanced chart.
5. Phase 4 - Order lifecycle and core utility pages.
6. Phase 5 - Futures, leverage, margin, and market data.
7. Phase 6 - Trading bots.
8. Phase 7 - Copy trading and provider journey.
9. Phase 8 - Copy safety, compliance, reports, and regulatory pages.
10. Phase 9 - Cross-module direct navigation polish.
11. Phase 10 - Full QA and final hardening.

PHASE 0 - BASELINE AND ROUTE AUDIT

Required actions:

```powershell
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
```

Confirm:

- `trade_routes.dart` still has 91 Trade `GoRoute` entries.
- Main `TradePage` still has 16 direct navigation targets.
- Existing tests for Trade are discoverable under `flutter_app/test/features/trade/`.
- No source edits have been made before baseline evidence is collected.

PHASE 1 - TRADE UI CONTRACT AND COMPONENT MAPPING

Required actions:

- Map current Trade UI patterns to existing shared primitives.
- Identify repeated local card, header, metric, info row, action tile, risk
  notice, empty/error/loading, and confirmation patterns.
- Decide which patterns can use existing shared widgets and which truly need
  Trade-local widgets.
- Define first-viewport expectations for root Trade, pair, convert, futures,
  margin, bots, copy trading, and compliance pages.

Do not create new components before this mapping is clear.

PHASE 2 - FOUNDATION COMPONENTS FOR TRADE

Add only the smallest reusable Trade UI layer needed by the next phase.

Candidate components, only when justified:

- `TradeMarketHeader`
- `TradeOrderTicket`
- `TradeRiskNotice`
- `TradeMetricStrip`
- `TradeActionTile`
- `TradeStatusBanner`
- `TradeComplianceListSection`
- `TradeEmptyOrLoadingState`

Rules:

- Prefer `flutter_app/lib/features/trade/presentation/widgets/`.
- Use `flutter_app/lib/shared/widgets/` only if the pattern is truly reusable
  beyond Trade.
- Add focused widget tests for new component states.
- Avoid speculative abstraction.

PHASE 3 - CORE TRADE ROOT, PAIR, AND ADVANCED CHART

Routes:

- `/trade`
- `/trade/:pairId`
- `/trade/advanced-chart/:pairId`

Required outcomes:

- Root Trade becomes a compact command center.
- Pair route shares the same visual system as root Trade.
- Advanced chart entry and page align with Trade header/action patterns.
- Order ticket, market summary, quick actions, recent orders, and receipt access
  are visually coherent.
- Buy/sell states use semantic tokens.

Focused verification:

```powershell
cd flutter_app
flutter test test/features/trade/trade_page_test.dart --reporter=compact
flutter test test/features/trade/advanced_chart_page_test.dart --reporter=compact
flutter test test/app/router/app_route_paths_trade_contract_test.dart --reporter=compact
dart run tool/navigation_edge_audit.dart --check
```

PHASE 4 - ORDER LIFECYCLE AND CORE UTILITY PAGES

Routes:

- `AppRoutePaths.tradeOrderReceipt`
- `AppRoutePaths.tradeOrdersHistory`
- `AppRoutePaths.tradePositions`
- `AppRoutePaths.tradeSettings`
- `AppRoutePaths.tradeExport`
- `AppRoutePaths.tradeConvert`

Required outcomes:

- Receipt shows status, order details, fees/limits, and next actions.
- History and positions use compact rows, filters, empty/offline/error states.
- Settings and export use clear sections and safe controls.
- Convert shows rate, fee, limit, preview, and confirmation.

Run the focused tests listed in the plan for these pages.

PHASE 5 - FUTURES, LEVERAGE, MARGIN, AND MARKET DATA

Routes:

- `/trade/:pairId/futures`
- `/trade/:pairId/futures/leverage`
- `AppRoutePaths.tradeMargin`
- `AppRoutePaths.tradeMarginBtcusdt`
- `/trade/trader/:traderId`
- `AppRoutePaths.tradeMarginAdvancedDemo`
- `AppRoutePaths.tradeMarginMarketDataAnalytics`
- `AppRoutePaths.tradeMarginHub`
- `AppRoutePaths.tradeMarginLiveMarketDataAnalytics`
- `AppRoutePaths.tradeMarginAdvancedAnalytics`

Required outcomes:

- Futures, leverage, and margin are explicitly risk-aware.
- Liquidation, fees, limits, and leverage impact are not hidden.
- Market data and analytics pages are dense but readable on phone.
- Trader profile uses neutral surfaces and Trade accents only where meaningful.

Run the focused tests listed in the plan for this phase.

PHASE 6 - TRADING BOTS

Routes:

- `AppRoutePaths.tradeBots`
- All `AppRoutePaths.tradeBot*` routes in the plan.

Required outcomes:

- Bots hub communicates active bots, risk, performance, and next action clearly.
- Risk dashboard, emergency stop, security, and suitability pages are
  safety-first.
- Analytics and backtesting pages use compact metrics, chart cards, filters,
  empty states, and mobile-readable layouts.
- Emergency stop and security actions are confirmable and accessible.

Run the focused bot tests listed in the plan.

PHASE 7 - COPY TRADING AND PROVIDER JOURNEY

Routes:

- Copy trading hub/version/education/active/settings/notifications.
- Provider application/detail/assessment/configuration/confirmation.
- Copy performance, attribution, and audit log.

Required outcomes:

- Provider journey feels continuous from detail through confirmation.
- Capital, allocation, fees, drawdown, risk, and exit/next steps appear before
  confirmation.
- Safe back-path behavior is preserved.
- Active copy performance and audit history are readable on phone.

Run the focused copy-trading tests listed in the plan.

PHASE 8 - COPY SAFETY, COMPLIANCE, REPORTS, AND REGULATORY PAGES

Routes:

- Remaining copy safety, provider comparison, leaderboard, governance,
  regulatory, reports, transaction, execution, client protection, costs, KID,
  RIY, complaints, ombudsman, audit, and inspection pages.

Required outcomes:

- Compliance pages are calm, dense, and trustworthy.
- Reports use filters, summary metrics, compact rows, empty/offline states.
- Forms have validation, semantics, and clear next actions.
- Legal/risk copy is visible and never hidden behind decorative layout.

Run the focused compliance/report tests listed in the plan.

PHASE 9 - CROSS-MODULE DIRECT NAVIGATION POLISH

Targets from Trade quick actions:

- DCA
- Wallet
- P2P
- Earn/Staking
- Launchpad
- Prediction Markets
- Arena
- Rewards
- Support

Required outcomes:

- Quick actions use shared navigation primitives and `AppRoutePaths`.
- Cross-module actions are visually secondary to core Trade actions.
- Arena remains points-only.
- Prediction Markets remains separate from Arena.

Verification:

```powershell
cd flutter_app
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact
dart run tool/navigation_edge_audit.dart --check
```

PHASE 10 - FULL QA AND FINAL HARDENING

Run:

```powershell
cd flutter_app
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/app/router --reporter=compact
flutter test test/quality/navigation_route_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
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

Representative emulator/device QA routes:

- `/trade`
- `/trade/btcusdt`
- `/trade/order-receipt`
- `/trade/orders-history`
- `/trade/convert`
- `/trade/btcusdt/futures`
- `/trade/btcusdt/futures/leverage`
- `/trade/margin`
- `/trade/bots`
- `/trade/bots/risk-dashboard`
- `/trade/bots/emergency-stop`
- `/trade/copy-trading`
- `/trade/copy-provider/provider001`
- `/trade/copy-provider/provider001/configuration`
- `/trade/copy-provider/provider001/confirmation`
- `/trade/copy-trading/regulatory-disclosures`
- `/trade/copy-trading/transaction-reporting`

PER-PAGE ACCEPTANCE CHECKLIST

For every touched page:

- [ ] The route is represented in the 91-route manifest.
- [ ] The target page and direct widgets were read.
- [ ] GitNexus context/impact was run before Dart symbol edits.
- [ ] Shared layout primitives are used before local scaffolds.
- [ ] Theme tokens are used; no new raw style debt.
- [ ] Dark baseline and neutral surfaces are preserved.
- [ ] Trade accent is limited to icons, badges, focus, charts, buy/sell, and
      warnings.
- [ ] First viewport at 360 px is useful.
- [ ] Text does not overlap controls.
- [ ] Tap targets are usable.
- [ ] Icon-only controls have tooltips or semantics.
- [ ] Loading, empty, error, offline, submitting, and success states exist
      where the flow needs them.
- [ ] High-risk actions preview fee/risk/limit/next step.
- [ ] No hype, casino, FOMO, or hidden-risk copy is introduced.
- [ ] Prediction Markets and Arena boundaries are preserved.
- [ ] Focused tests and relevant audits pass.

VERIFICATION COMMAND SELECTION

For a normal screen batch:

```powershell
cd flutter_app
dart format <touched dart files>
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/trade/<focused_test>.dart --reporter=compact
flutter analyze
```

For route/navigation changes:

```powershell
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter test test/app/router --reporter=compact
```

For shared primitive changes:

```powershell
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

For high-risk financial/security screens:

```powershell
cd flutter_app
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact
flutter test test/features/trade/<focused_test>.dart --reporter=compact
```

EVIDENCE TEMPLATE

Record concise evidence after each phase or route family:

```text
Phase:
Date:
Status:

Routes/pages:
-

Skills used:
-

MCP/tools used:
- GitNexus:
- Headroom:
- simulator/emulator:
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

Next:
-
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

1. Did Phase 10 final gate pass?
2. If not, are all remaining eligible tasks blocked after 3 concrete recovery
   attempts?
3. If not, did a hard tool/platform failure prevent further commands after
   trying the next eligible path?
4. If not, did GitNexus HIGH/CRITICAL impact require user acknowledgement?
5. If not, did the user explicitly ask to stop?

If all answers are "no", do not final. Continue with the next eligible task.

FINAL ANSWER RULES

If the final gate passes:

- Summarize completed phases.
- Report final audit/test commands and results.
- Report emulator/device QA artifacts.
- End with exactly:

```text
TRADE UI REDESIGN COMPLETE
```

If a valid stop condition forces an early handoff:

- State the blocker and attempts made.
- End with exactly:

```text
RESUME FROM: <phase> - <exact next task/route/page>
```

Do not write anything after the `RESUME FROM:` line.
````
