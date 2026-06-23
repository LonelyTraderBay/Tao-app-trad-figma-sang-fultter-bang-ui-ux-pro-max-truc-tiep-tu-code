# Wallet UI Home Standardization Autonomous Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
Wallet UI Home-standard redesign from start to finish.

This is an execution prompt, not another planning prompt. It tells the agent to
follow `Wallet-UI-Home-Standardization-Plan.md` in order, use the available
skills and MCP tools efficiently, preserve financial safety, and keep working
until all Wallet pages are done, blocked with evidence, or explicitly deferred.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:

Execute the Wallet UI Home-standard redesign in strict order using:

docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md

The goal is to redesign every Wallet screen so it follows Home's mobile, dark,
dense, trust-first UI system while preserving Wallet-specific routes,
providers, keys, masking, fees, limits, risk copy, preview/confirm flows,
tests, and product boundaries.

THIS IS AN EXECUTION PROMPT:

- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not skip to a random Wallet page.
- Do not mark a page done because `flutter test test/features/wallet` passes.
- Do not stop in the middle of the ordered plan while unblocked Wallet work
  remains.
- Follow the phase order in `Wallet-UI-Home-Standardization-Plan.md`.
- Work one page or one tightly coupled page pair per batch.
- After each batch, verify, update the plan with evidence, then continue.
- Keep going until all 21 Wallet routes and 19 primary Wallet pages are
  `Done`, `Blocked` with precise evidence, or explicitly `Deferred` with a
  reason.

STOP ONLY WHEN:

- All Wallet pages are `Done`, `Blocked`, or `Deferred` in the plan.
- The same external blocker prevents progress for three consecutive attempts
  and no other eligible Wallet page remains unblocked.
- Required local tools are unavailable and every fallback has been tried.
- The user explicitly asks you to stop or pause.

If a test fails, diagnose and fix current-batch regressions before moving on.
If a failure is unrelated and pre-existing, document it with exact command,
failure, and why it does not invalidate the current Wallet batch.

LANGUAGE REQUIREMENT:

- Keep documentation updates and batch notes in English, matching the existing
  plan language.
- Keep user-facing progress/final summaries in the user's language unless the
  user asks otherwise.
- Do not translate Flutter UI product copy unless the active task explicitly
  includes copy cleanup for that screen.

MANDATORY READ BEFORE THE FIRST EDIT:

Read these once at the beginning of the run:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/03_DESIGN_SYSTEM/Guidelines.md`
4. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
5. `docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md`
6. `flutter_app/lib/features/home/presentation/pages/home_page.dart`
7. `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`
8. `flutter_app/lib/features/home/presentation/pages/home_page_part_02.dart`
9. `flutter_app/lib/features/home/presentation/pages/home_page_part_03.dart`
10. `flutter_app/lib/app/router/route_groups/wallet_routes.dart`

After the first edit, do not reread all global docs every batch unless they
changed. For later batches, read only the target page, directly related widget
parts, provider/controller, focused test, and any shared primitive you will
modify.

SKILL ROUTING FOR MAXIMUM EFFECT WITH MINIMUM TOKENS:

Use skills selectively. Do not read every skill file up front. Read the smallest
skill set that matches the current batch.

Always use these for Wallet UI batches:

- `vittrade-ui-checklists`: Flutter-safe UI checklist, Home/shared-component
  alignment, accessibility, density, high-risk controls.
- `frontend-ui-engineering`: production-quality layout, hierarchy, responsive
  behavior, accessibility, interaction states.
- `incremental-implementation`: when a batch touches more than one file.
- `test-driven-development`: when changing behavior, validation, state, or test
  expectations.
- `gitnexus-impact-analysis`: before edits to symbols, shared components,
  routes, providers, controllers, repositories, or helpers.

Use these only when triggered by the batch:

- `debugging-and-error-recovery`: any failing test, analyzer error, build
  issue, unexpected UI regression, or audit failure.
- `code-review-and-quality`: before marking a batch complete; use review stance
  against the current diff.
- `security-and-hardening`: high-risk money movement, address add, withdrawal,
  token approval, masking, sensitive data, or external integrations.
- `gitnexus-exploring`: unfamiliar page flow, ownership, route, or dependency
  graph.
- `gitnexus-debugging`: when tracing a failing flow or unexpected behavior.
- `gitnexus-refactoring`: only for symbol rename/extract/move. Do not do
  find-and-replace renames.
- `browser:control-in-app-browser` or `playwright`: only if browser visual QA
  is available and useful for localhost/web preview. Do not recreate obsolete
  web screenshot tooling.
- `build-ios-apps:*`: only if the user specifically requests simulator/device
  validation or the batch requires iOS runtime UI evidence.

Do not use unrelated plugins or skills merely because they exist. Token-saving
rule: use the minimum skill set that covers the current page, then proceed.

MCP AND TOOL ROUTING:

Use tools aggressively but efficiently.

- Use `multi_tool_use.parallel` for independent reads and searches.
- Use `rg` and `rg --files` before slower search commands.
- Use `apply_patch` for manual file edits.
- Use `mcp__gitnexus` tools for code intelligence:
  - `list_repos` if repo identity is unclear.
  - `query` for unfamiliar Wallet concepts.
  - `context` for every target page class before edits.
  - `impact` before editing any symbol, class, method, shared primitive,
    route, provider, controller, repository, value object, or helper.
  - `detect_changes` after a completed batch and before any commit.
- Use `mcp__headroom` for long outputs:
  - Compress long GitNexus outputs, test logs, analyzer logs, audit logs,
    diffs, or route reports.
  - Retrieve the hash before acting on compressed information.
  - Record useful hashes in the plan batch notes.
- Use shell commands for Flutter/Dart verification and source inspection.
- Use in-app browser or emulator tools only when they provide real visual QA
  evidence for first viewport, overflow, or interaction behavior.

HEADROOM POLICY:

Use Headroom for token economy, not as source of truth.

Compress:

- Long GitNexus `impact`, `context`, or `detect_changes` output.
- Long `flutter test`, `flutter analyze`, audit, or diff output.
- Long action census output after the important findings are written into the
  plan.

Do not compress instead of reading:

- The active target source file.
- The active focused test.
- The Wallet plan.
- Financial safety requirements.
- Current code before editing.

If Headroom is used, write durable evidence into the plan:

```text
Headroom refs: impact=<hash>, test-log=<hash>, audit=<hash>
```

GITNEXUS RULES:

This repo requires GitNexus impact analysis before editing any symbol.

Before the first edit:

1. Confirm the indexed repo when needed.
2. Use `context` for the target page class.
3. Use `query` when ownership or flow is unclear.
4. Use `impact(direction: upstream)` before editing each function, class, or
   method you will modify.
5. If impact returns HIGH or CRITICAL, warn the user briefly and explain the
   risk before editing. Route-page impact can be high because of router fan-out;
   still record it.

After each batch:

1. Run `detect_changes`.
2. If output is huge because of the dirty worktree, compress with Headroom and
   also record a scoped `git diff --stat -- <batch files>` summary.
3. Do not commit unless the user asked for a commit.

HOME BASELINE CONTRACT TO APPLY:

Use Home as visual foundation, not business logic.

Required rhythm:

```text
module header
-> module hero or primary context
-> primary action cluster
-> resume/status/safety card
-> tools, filters, tabs, or selectors
-> dense lists, records, or detail rows
-> secondary discovery or support
-> bottom-nav-safe content end
```

Required shared patterns:

- Page shell: `VitPageLayout`, `VitPageContent`, `VitInsetScrollView`.
- Header: `VitHeader` for Wallet routes; do not copy Home root brand chrome
  unless a page is truly app-root.
- Section title: `VitSectionHeader`.
- Surface: `VitCard` with tokenized padding/radius.
- Primary action: `VitCtaButton`.
- Icon action: `VitIconButton` or `VitInlineIconAction` with tooltip/semantics.
- Tool/action grid: `VitActionTileGrid`, `VitServiceTile`.
- Form field: `VitInput` before raw `TextField`.
- Tabs: `VitTabBar`.
- Status: `VitStatusPill`, `VitAccentPill`, `VitMetricDeltaPill`.
- State: `VitSkeleton`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`.
- Risk: `VitHighRiskStatePanel` plus preview/confirm.
- Repeated detail rows: `VitInfoRow` or approved shared equivalent.
- Bottom sheet: `VitSheetPanel`, `VitSheetHandle`, or `showVitBottomSheet`
  with shared content rhythm.

Hard UI rules:

- No new local scaffold, section header, card style, pill, input, tab, sheet
  surface, or action grid when a shared primitive covers it.
- No new raw local `Container`, `BoxDecoration`, raw `EdgeInsets`,
  `BorderRadius.circular`, raw font sizes, or local color palettes in Wallet
  page bundles unless a documented L3 reason exists.
- Keep dark theme baseline.
- Keep phone-first layout usable at 360 px and up.
- Do not use color as the only state indicator.
- Do not create card-in-card stacks unless a real framed sub-surface is needed.

WALLET SAFETY RULES:

- Preserve preview/confirm for withdrawals, address additions, token revoke,
  dust conversion, and any high-risk financial action.
- Show fee, risk, limit, masked account/address, and next step before high-risk
  confirmation.
- Mask wallet addresses and sensitive account data by default.
- `/p2p/wallet` and related P2P Wallet routes are out of scope.
- Do not introduce hype, casino, payout, guaranteed profit, or hidden-fee copy.

ORDER OF WORK:

Follow this exact order from the Wallet plan:

0. Evidence reset and audit baseline.
1. Shared Wallet visual foundation.
2. `WalletPage`.
3. Money movement pages:
   - `DepositPage`
   - `WithdrawPage`
   - `TransferPage`
   - `BuyCryptoPage`
4. Asset and history pages:
   - `TransactionHistoryPage`
   - `TransactionDetailPage`
   - `AssetDetailPage`
   - `PortfolioAnalyticsPage`
5. Address and safety pages:
   - `AddressBookPage`
   - `AddressAddPage`
   - `PendingDepositsPage`
   - `WithdrawLimitsPage`
   - `WalletTokenApprovalPage`
6. Wallet tools pages:
   - `DustConverterPage`
   - `NetworkStatusPage`
   - `WalletMultiManagerPage`
   - `WalletGasOptimizerPage`
   - `WalletHealthScorePage`
7. Full verification and artifact update.

BATCH SIZE:

- Default: one page per batch.
- Use one tightly coupled pair only when shared local widgets make separate
  edits unsafe or wasteful.
- Do not widen a batch just because neighboring files are dirty.
- Do not touch unrelated modules.

PER-PAGE EXECUTION LOOP:

For each page:

1. Read the plan section for that page.
2. Read page source, widget parts, provider/controller, and focused test.
3. Use GitNexus `context` and required `impact`.
4. Run or inspect action census for target files.
5. Write a short current-gap note against Home baseline.
6. Implement Home shell/content rhythm.
7. Replace matching local visuals with shared primitives.
8. Preserve all routes, keys, providers, masking, fees, limits, preview/confirm.
9. Add/update tests for changed layout/behavior/state contracts.
10. Format touched Dart files.
11. Run focused test.
12. Run relevant Wallet subset or full Wallet folder test.
13. Run `flutter analyze`.
14. Run token/density audits when layout/tokens/first viewport changed.
15. Run GitNexus `detect_changes`.
16. Update `Wallet-UI-Home-Standardization-Plan.md` with evidence.
17. Continue to the next page.

PHASE 0 COMMANDS:

From repo root:

```powershell
rg --files flutter_app/lib/features/wallet/presentation/pages
rg -n "VitCtaButton|IconButton|VitInlineIconAction|VitServiceTile|VitActionTileGrid|onTap:|onPressed:|showModalBottomSheet|showDialog|GestureDetector|InkWell|tabKey|filterKey|searchKey|confirm|preview|revoke|copy|scan|refresh|submit" flutter_app/lib/features/wallet/presentation/pages flutter_app/lib/features/wallet/presentation/widgets
```

From `flutter_app/`:

```bash
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/wallet --reporter=compact
flutter analyze
```

If an audit fails because artifacts are stale, classify it precisely. Regenerate
only when the tool's instructions say to and the artifact belongs to the current
Wallet/UI work. Do not churn unrelated artifacts casually.

REQUIRED VERIFICATION AFTER EACH CODE BATCH:

From `flutter_app/`:

```bash
dart format <touched Dart files>
flutter test <focused wallet test> --reporter=compact
flutter analyze
```

When any shared layout, token, first viewport, density, form, sheet, or
high-risk primitive changes:

```bash
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
```

When high-risk state primitives or financial preview/confirm flows change:

```bash
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
```

When route or navigation behavior changes:

```bash
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

Before final completion:

```bash
dart format --output=none --set-exit-if-changed lib/features/wallet test/features/wallet
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test test/features/wallet --reporter=compact
```

Run full `flutter test --reporter=compact` only after Wallet focused checks are
green or when shared primitives/navigation changed broadly.

VISUAL QA REQUIREMENT:

For every page, record 360 px first-viewport evidence in the plan. Evidence can
be:

- Emulator/device screenshot note.
- Widget-test viewport assertion.
- In-app browser/visual QA screenshot if a valid local target exists.
- A concise manual source-backed note when screenshot tooling is unavailable.

Do not mark the page `Done` without first-viewport evidence.

PLAN UPDATE RULE:

After each batch, update:

docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md

Record:

- Page status.
- Files changed.
- Home pattern applied.
- Shared primitives adopted.
- L3 local reasons.
- Action inventory result.
- Financial safety result.
- First-viewport evidence.
- GitNexus evidence.
- Headroom refs if used.
- Verification commands and result.
- Remaining blockers, if any.

STATUS DEFINITIONS:

- `Pending`: not yet redesigned under this plan.
- `In progress`: current page/batch has started but verification is incomplete.
- `Blocked`: cannot continue because of a precise external blocker; include
  evidence and attempted fallbacks.
- `Deferred`: intentionally postponed with reason.
- `Done`: all verification gates for that page passed and evidence is written.

DEFINITION OF DONE:

Wallet redesign is complete only when:

- All 21 Wallet routes are covered.
- All 19 primary Wallet page classes are covered.
- Every page has completed action inventory.
- Every page has Home pattern classification.
- Every local composition has an L3 reason or was replaced with shared
  primitives.
- Every page has focused test evidence.
- Wallet folder tests pass.
- `flutter analyze` passes.
- Route coverage passes.
- Design-token audit passes or blocker is documented precisely.
- Visual-density audit passes or blocker is documented precisely.
- 360 px first-viewport evidence is recorded for every page.
- High-risk flows preserve preview, confirm, fees, limits, masking, risk, and
  next-step copy.
- P2P Wallet remains excluded.
- GitNexus `detect_changes()` confirms expected scope before final commit.

DIRTY WORKTREE RULES:

The worktree may already contain unrelated changes.

- Never revert changes you did not make.
- Use scoped `git status --short -- <batch files>`.
- Use scoped `git diff -- <batch files>`.
- If `detect_changes` or tests show broad unrelated noise, classify it and keep
  the current batch scoped.
- Do not commit unless the user explicitly asks.

OUTPUT STYLE DURING EXECUTION:

- Keep progress updates short.
- Name the current page, current phase, and why the next action matters.
- Do not paste huge logs.
- Use Headroom for long logs.
- Final answer for each completed batch should include: page(s), key files,
  verification commands, pass/fail status, blockers, and next page.
````

## Quick Resume Command

Use this short version when continuing an already-started Wallet redesign run:

```text
Continue executing docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md.
Do not re-plan. Resume from the first page whose status is not Done/Blocked/Deferred.
Use GitNexus context/impact/detect_changes, Headroom for long outputs, and the
VitTrade UI/frontend/test/debug skills only as needed for the current page.
Preserve Wallet financial safety and routes. Update the plan after the batch.
Do not stop while unblocked Wallet pages remain.
```
