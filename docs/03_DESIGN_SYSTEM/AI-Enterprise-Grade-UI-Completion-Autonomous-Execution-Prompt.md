# AI Enterprise-Grade UI Completion Autonomous Execution Prompt

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the Enterprise-Grade UI Completion Tracking Plan automatically, in order, until
the remaining UI density/fullscreen/shared-component polish is complete.

This prompt is not a request to create another plan. It is a request to execute
the existing tracking plan, keep moving between batches, use the available
skills and MCP tools efficiently, conserve tokens, and stop only at a real
completion gate or proven blocker.

Plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md
```

Primary audit inputs:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv
docs/03_DESIGN_SYSTEM/VitTrade-UI-Fullscreen-Density-Home-Standard-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Behavior-Audit.md
docs/03_DESIGN_SYSTEM/Guidelines.md
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE

Execute the Enterprise-Grade UI Completion Tracking Plan:

docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md

Bring every remaining flagged UI surface to the project standard:

- Flutter enterprise-grade.
- Dark professional crypto trading super-app.
- Phone-first at 360 px and up.
- Home screen as visual density and shared-chrome baseline.
- Shared component driven before local scaffolds.
- Tokenized color, typography, spacing, radius, density, surfaces, and states.
- Fullscreen/tool surfaces use available workspace appropriately.
- Financial-safety-first.
- Prediction Markets and Open Arena copy and currency boundaries remain separate.
- No regressions in routes, providers, business logic, masking, safety copy, or tests.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT

- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which batch to run next when the tracking plan defines the order.
- Do not jump to random screens.
- Do not stop after one file, one screen, one batch, one feature, one passing audit, or one passing test run.
- Execute in this order: P0 open guardrails -> P1 -> P2 -> P3 -> P4.
- If a task is already complete, verify it from source/audits/tests, mark it complete with evidence, and continue.
- If a task is blocked, make at least 3 concrete attempts to resolve it or route around it before marking it blocked.
- If one task is blocked but another eligible task remains, continue to the next eligible task.
- Do not mark completion until the final completion gate in the tracking plan passes.

NON-STOP CONTRACT

Keep executing automatically until exactly one of these stop conditions is true:

1. The full Final Completion Gate in
   `VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md` passes.
2. A real blocker prevents all further progress after at least 3 concrete
   attempts and no eligible fallback batch remains.
3. A hard platform/tool failure prevents further commands or edits after the
   agent has already tried to continue the next eligible batch.
4. The user explicitly asks you to stop or change direction.

A completed batch is not a valid final answer if more eligible work remains.
Large remaining scope is not a blocker.
Token pressure is not a blocker.
Use concise updates, Headroom compression, focused file reads, generated audit
CSVs, and refreshed plan state to keep working.

VOLUNTARY HANDOFFS ARE FORBIDDEN

- Do not stop because a batch is complete.
- Do not stop because focused tests passed.
- Do not stop because full tests passed.
- Do not stop because the plan was updated.
- Do not stop because the next batch is ready.
- Do not stop because the answer would be a clean progress summary.
- Do not stop because the remaining queue is long.
- Do not stop because the work feels repetitive.
- Do not stop after writing `RESUME FROM:` unless a valid stop condition above
  is actually true.

If another eligible batch exists, the next action is to start that batch, not
to tell the user where to resume.

If work is complete, include this exact final line:

```text
ENTERPRISE-GRADE UI COMPLETION COMPLETE
```

Only if a valid stop condition forces the turn to end before completion, end
the final response with exactly:

```text
RESUME FROM: <priority> - <exact next task/screen/route group>
```

Do not write anything after the `RESUME FROM:` line.

MANDATORY READING BEFORE CODE EDITS

Read enough of these files to obey current project rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md`
7. `docs/03_DESIGN_SYSTEM/VitTrade-UI-Fullscreen-Density-Home-Standard-Audit.md`
8. `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`
9. `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`
10. `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`
11. `flutter_app/lib/shared/widgets/widgets.dart`
12. Current source files, local widgets, shared primitives, and tests for the
    active batch only.

Do not load the full repository into context. Use `rg`, GitNexus, targeted file
reads, and audit CSV filters to locate only the active batch.

DOCUMENT PRECEDENCE

If documents conflict:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundary rules win over visual cleanup.
5. `VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md` defines this
   work order.
6. `VitTrade-UI-Fullscreen-Density-Home-Standard-Audit.md` defines the current
   density/fullscreen risk queue.
7. `Guidelines.md` and shared Flutter source define design-system standards.
8. Generated audits define current measurable status.

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

Use the smallest relevant skill set for the active batch. Read each selected
`SKILL.md` completely before applying it.

Always use when applicable:

- `planning-and-task-breakdown`: track priority order, checkpoints, and
  acceptance criteria.
- `vittrade-ui-checklists`: translate UI polish, density, accessibility,
  loading/empty/error, and motion guidance into Flutter/VitTrade terms.
- `frontend-ui-engineering`: when editing user-facing screen/layout/widget code.
- `incremental-implementation`: when a batch touches more than one file.
- `test-driven-development`: when behavior, states, or widget expectations
  change.
- `debugging-and-error-recovery`: when commands fail, tests fail, analyzer
  fails, or runtime UI differs from expectation.
- `code-review-and-quality`: before claiming completion of any broad phase or
  final completion.
- `security-and-hardening`: when touching high-risk financial, address, P2P,
  withdrawal, security, account, escrow, or payment-method flows.
- `gitnexus-exploring`: when locating flows or unfamiliar screen structure.
- `gitnexus-impact-analysis`: before editing any Dart symbol.
- `ui-ux-pro-max`: when visual hierarchy, spacing, density, screen rhythm, or
  component choice is ambiguous.

Optional external UI checklist through `vittrade-ui-checklists`:

- Use `ibelick/baseline-ui` only for spacing/hierarchy/empty-state polish.
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
  and `flutter test`.
- Use GitNexus MCP before code edits:
  - `query` for unfamiliar flows.
  - `context` for target symbols.
  - `impact(direction: "upstream")` before modifying any function, class,
    method, or shared symbol.
  - Warn and narrow scope if impact is HIGH or CRITICAL.
  - `detect_changes()` before any commit or final broad handoff.
- Use Headroom MCP for token control:
  - Compress huge audit outputs, long logs, or large file excerpts.
  - Retrieve only the needed slice by query.
- Use `update_plan` when available to keep current batch progress visible.
- Use Android/iOS simulator MCP only when available and useful for visual QA.
  If not available, record that simulator visual QA could not be run and use
  Flutter widget/responsive tests plus source-level visual checks.
- Use Codex Security MCP only if a task introduces or touches a plausible
  security-sensitive finding. Do not run a full security scan for normal visual
  spacing work unless the user asks.
- Use browser/Playwright only for web-rendered artifacts. This is a Flutter app;
  do not recreate obsolete React/Vite/web screenshot tooling.

TOKEN-EFFICIENT OPERATING RULES

- Prefer `rg` and generated CSV filters over reading entire directories.
- Prefer `Get-Content -TotalCount`, targeted `Select-String`, and exact file
  slices over full-file reads.
- Read only the active batch screen, directly imported local widgets, nearest
  shared primitives, and matching tests.
- Use GitNexus to locate relationships instead of broad manual exploration.
- Summarize command outputs in the plan; do not paste huge logs.
- Store large outputs with Headroom when needed.
- Keep user updates short.
- Do not re-read unchanged large docs after every batch; record the last
  relevant checkpoint and refresh only the section or CSV rows needed.
- Do not run full tests after every tiny batch unless shared primitives,
  router, provider behavior, financial flows, or broad layout behavior changed.
  Use focused tests per batch and full tests at phase/final gates.

AUTONOMOUS EXECUTION LOOP

Run this loop continuously:

```text
while Final Completion Gate is not complete:
  1. Refresh local truth:
     - read current tracking plan status
     - read density CSV rows for highest open priority
     - confirm whether the next task still has measurable signal
  2. Select the next eligible task:
     - P0 open guardrails first
     - then P1
     - then P2
     - then P3
     - then P4
     - skip only tasks that are verified complete or have accepted documented exceptions
  3. Explore only the active batch:
     - use rg/GitNexus to find source, local widgets, shared primitives, tests
     - read focused files
  4. Run GitNexus safety checks before code edits:
     - context/query as needed
     - impact upstream for every edited symbol
     - warn/narrow if high risk
  5. Implement the smallest safe UI change:
     - use shared primitives first
     - preserve tokens, copy, routes, providers, financial safety
     - keep fullscreen tools full-bleed/workspace-oriented
  6. Verify:
     - dart format on touched files
     - relevant audit commands
     - focused feature/widget tests
     - flutter analyze
     - broader tests only when batch risk requires it
  7. Update the tracking plan:
     - mark completed task
     - add batch evidence
     - update audit counts or exception reason
     - record next task
  8. Run `git diff --check` for touched docs/code.
  9. If another eligible task remains, immediately begin it.
     Do not send a final answer between batches.
```

BATCH SELECTION ORDER

Start with the current open queue in:

`docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md`

Current intended order:

1. P0.3 Define visual QA evidence format.
2. P0.4 Decide whether to automate density audit.
3. P1.A.1 `OnboardingFlow`.
4. P1.B.1 `EnterpriseStatesPage`.
5. P1.B.2 `P2PChatPage`.
6. P1.B.3 `AdvancedChartPage`.
7. P1.B.4 `FuturesPage`.
8. P1.B.5 `TradingBotsPage`.
9. P2.1 through P2.11 in plan order.
10. P3.1 through P3.12 in plan order.
11. P4.1 through P4.5.

UI IMPLEMENTATION RULES

- Home is the density and chrome baseline.
- Prefer `VitPageLayout`, `VitPageContent`, `VitInsetScrollView`,
  `VitAutoHideHeaderScaffold`, `VitHeader`, and `VitTopChrome` over local page
  scaffolds.
- Prefer `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`,
  `VitSectionHeader`, `VitStatusPill`, `VitEmptyState`, `VitErrorState`,
  `VitOfflineBanner`, `VitSkeleton`, `VitDiscoveryActionCard`, market rows,
  and high-risk primitives over local equivalents.
- Use `VitContentPadding.compact` or `defaultPadding` and
  `VitContentGap.defaultGap` unless the screen has a documented reason for
  relaxed density.
- Do not make data-heavy screens sparse, over-centered, or max-width constrained
  without a product reason.
- Do not put normal content inside unnecessary nested cards.
- Do not add a new palette, spacing system, radius system, or typography scale.
- Do not weaken financial disclosures to save space.
- Do not mix Arena Points language with wallet/profit/PnL/stake-return copy.
- Do not make fullscreen tool pages look like ordinary padded article pages.

FINANCIAL SAFETY RULES

Preserve or improve safety for:

- Withdrawals.
- Escrow release.
- Security changes.
- Address additions.
- P2P payment-method changes.
- Trading/futures/high-risk confirmations.

For high-risk flows:

- Show fees, limits, risk, status, and next steps before confirmation.
- Mask sensitive wallet, address, phone, email, and account data.
- Keep CTA hierarchy clear.
- Do not hide risk or confirmation copy to make a layout denser.

VERIFICATION COMMANDS

Run from `flutter_app/` unless noted otherwise.

Baseline per implementation batch:

```bash
dart format <touched dart files>
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
flutter test test/features/<feature> --reporter=compact
flutter analyze
```

Header/fullscreen/tool batches:

```bash
dart run tool/top_header_action_audit.dart
dart run tool/top_header_visual_archetype_audit.dart
flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact
```

Route/navigation-sensitive batches:

```bash
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

Final broad gate:

```bash
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/top_header_action_audit.dart
dart run tool/top_header_visual_archetype_audit.dart
flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

Run `git diff --check` from the repo root before any final answer.

PLAN UPDATE FORMAT

After every completed batch, update:

`docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md`

Use this evidence block:

```text
Batch:
Date:
Status:

Scope:
- 

Skills / MCP:
- skills:
- GitNexus:
- Headroom:
- simulator/browser:

GitNexus:
- impact target:
- risk:
- direct callers:
- affected processes:

Implementation:
- 

Visual QA:
- viewport:
- route(s):
- result:
- screenshot/artifact:

Verification:
- command:
- result:

Residual exception:
- none / reason:

Next:
- 
```

DIRTY WORKTREE RULES

- Assume unrelated existing changes belong to the user or previous generated
  work.
- Do not revert unrelated files.
- Before editing a file, inspect it and preserve unrelated changes.
- Use `apply_patch` for manual edits.
- Do not use destructive git commands.
- Run `git status --short` often enough to avoid confusion.
- Run GitNexus `detect_changes()` before committing or claiming a broad final
  state.

END-OF-TURN GUARD

Before sending any final response, perform this self-check:

1. Did the full Final Completion Gate pass?
2. If not, is every remaining eligible task blocked after 3 concrete attempts?
3. If not, did a hard platform/tool failure prevent further commands or edits
   after trying to start the next eligible task?
4. If not, did the user explicitly stop or redirect the work?
5. If not, have I already started the next eligible task after updating the
   plan for the previous batch?

If answers 1-4 are "no", do not final. Continue with the next task.
If answer 5 is "no", do not final. Start the next eligible task now.

FINAL ANSWER RULES

If and only if the final completion gate passes:

- Summarize completed phases.
- Report final audit counts.
- Report key verification commands and results.
- End with exactly:

```text
ENTERPRISE-GRADE UI COMPLETION COMPLETE
```

If a valid stop condition forces an early handoff:

- Briefly state the blocker and attempts made.
- End with exactly:

```text
RESUME FROM: <priority> - <exact next task/screen/route group>
```

Do not write anything after that line.
````

