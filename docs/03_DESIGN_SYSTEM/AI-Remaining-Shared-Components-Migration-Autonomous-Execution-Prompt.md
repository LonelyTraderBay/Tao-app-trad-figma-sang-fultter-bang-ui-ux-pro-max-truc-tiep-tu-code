# AI Remaining Shared Components Migration Autonomous Execution Prompt

Use this prompt in a fresh AI/Codex coding thread when the agent must execute
the remaining shared-component migration work automatically, in order, without
stopping after partial progress.

This prompt is not a request to create another plan. It is a request to execute
the plan below until completion or a proven blocker.

Plan to execute:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Remaining-Shared-Components-Migration-Plan.md
```

Supporting evidence:

```text
flutter_app/run-artifacts/shared-component-screen-audit-summary-2026-06-19.md
flutter_app/run-artifacts/shared-component-routed-screen-audit-2026-06-19.csv
flutter_app/run-artifacts/shared-component-page-file-coverage-2026-06-19.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv
```

Copy the prompt below into AI/Codex:

````text
You are working in the VitTrade Flutter enterprise mono-repo:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:

Execute the remaining shared-component migration plan:

docs/03_DESIGN_SYSTEM/VitTrade-Remaining-Shared-Components-Migration-Plan.md

The target standard is:

- Flutter enterprise-grade.
- Dark professional crypto trading super-app.
- Phone-first at 360 px and up.
- Home UI standard as the visual baseline.
- Shared component driven.
- Tokenized colors, typography, spacing, radii, density, surfaces, controls,
  and states.
- Financial-safety-first.
- Prediction Markets and Open Arena kept separate.
- No regressions in routes, providers, business logic, masking, safety copy,
  tests, or navigation edges.

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT:

- Do not create another plan instead of doing the work.
- Do not only analyze and stop.
- Do not ask the user which screen to run next when the plan defines the order.
- Do not jump to random screens.
- Execute RSC-01 -> RSC-02 -> RSC-03 -> RSC-04 -> RSC-05 -> RSC-06 ->
  RSC-07 -> RSC-08 -> RSC-09 -> RSC-10 -> RSC-11, unless a freshly generated
  audit proves a row is already complete or the plan has been updated with a
  newer queue.
- If a task is already complete, verify it from source/audits/tests, update the
  plan with evidence, and continue.
- If a task is blocked, make at least 3 concrete attempts to resolve or route
  around it before marking blocked.
- If one task is blocked but another eligible task remains, continue to the
  next eligible task.
- Do not stop after one file, one screen, one audit pass, one test pass, or one
  plan update.

NON-STOP CONTRACT:

Keep executing automatically until exactly one stop condition is true:

1. The full final acceptance gates in
   `VitTrade-Remaining-Shared-Components-Migration-Plan.md` pass.
2. Every remaining eligible screen is blocked after at least 3 concrete
   attempts per screen.
3. A hard platform/tool failure prevents further commands or edits after the
   agent has already tried to start the next eligible screen.
4. The user explicitly asks you to stop or change direction.

A completed screen is not a valid final answer if another eligible screen
remains. A clean progress summary is not a stop condition. Token pressure is
not a stop condition; use focused reads, CSVs, Headroom compression, and compact
plan updates to continue.

If all final acceptance gates pass, end the final response with exactly:

```text
REMAINING SHARED COMPONENT MIGRATION COMPLETE
```

Only if a valid stop condition forces the turn to end before completion, end
the final response with exactly:

```text
RESUME FROM: <RSC id> - <screen name>
```

Do not write anything after the `RESUME FROM:` line.

MANDATORY READING BEFORE EDITS:

Read only enough to obey current project rules and the active screen task:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Remaining-Shared-Components-Migration-Plan.md`
7. `flutter_app/lib/shared/widgets/widgets.dart`
8. Shared layout/widget implementation files only when the active screen needs
   their API details.
9. Target screen page, part files, local widgets, and focused tests only for
   the active RSC task.

Do not load the full repository into context. Use `rg`, GitNexus, generated
CSV audits, and focused file reads.

DOCUMENT PRECEDENCE:

If documents conflict:

1. Current user request wins.
2. `AGENTS.md` and `docs/00_START_HERE.md` define execution constraints.
3. Flutter source and tests define actual behavior.
4. Financial safety and product boundary rules win over visual cleanup.
5. `VitTrade-Remaining-Shared-Components-Migration-Plan.md` defines this work
   order.
6. Generated audits define current measurable status.
7. Older completion notes in
   `VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md` are
   historical unless refreshed by current audits.

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
- Current tracker: `docs/03_DESIGN_SYSTEM/VitTrade-Remaining-Shared-Components-Migration-Plan.md`
- Generated audits: `docs/02_FLUTTER_MIGRATION/` and
  `flutter_app/run-artifacts/`

Do not recreate obsolete React, Vite, npm, Tailwind, or old web screenshot
tooling.

MANDATORY PREFLIGHT:

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
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

If a generated artifact is stale, regenerate it with the matching tool and
rerun the `--check` command before selecting the next screen.

CURRENT EXPECTED BASELINE:

The 2026-06-19 audit snapshot reports:

```text
routed_screens=414
page_files_covered=607
unmapped_page_files=0
grade_A=403
grade_B=6
grade_Tool=5
token_debt=0
navigation_edges=883
```

If fresh audits disagree, trust the fresh audits and update the plan before
continuing.

WORK QUEUE:

Use this queue unless the plan or fresh audits prove a different next eligible
screen:

```text
RSC-01 P2PChatPage
RSC-02 AdvancedChartPage
RSC-03 TradingBotsPage
RSC-04 ArenaPredictionBridgeFoundationPage
RSC-05 ReferralHomePage
RSC-06 SavingsAutoPilotPage
RSC-07 ConnectedEcosystemProductionPage
RSC-08 ArenaChallengeDetailPage
RSC-09 StakingProofOfReservesPage
RSC-10 EnterpriseStatesPage
RSC-11 FuturesPage
```

AUTONOMOUS EXECUTION LOOP:

Repeat this loop until a stop condition is true:

```text
while final acceptance gates are not complete:
  1. Refresh local truth:
     - read the current tracker queue and status rows
     - read the active screen row from the generated routed-screen audit CSV
     - check route/navigation/design-token/body audit freshness
  2. Select the next eligible RSC task:
     - use the tracker order
     - skip only if fresh audits and tracker evidence prove completion
     - otherwise execute the row
  3. Read focused source:
     - target page
     - listed part files
     - local widgets imported by the target
     - focused tests for that module/screen
  4. Use GitNexus before code edits:
     - context({name: "<screen class>"})
     - impact({target: "<screen class>", direction: "upstream"})
     - use maxDepth=1 or summaryOnly when the symbol is broad
     - warn and narrow scope if HIGH or CRITICAL risk appears
  5. Implement the smallest safe shared-component migration:
     - convert matching local cards, pills, tabs, inputs, CTAs, section headers,
       state panels, sheets, and action grids to shared primitives
     - preserve route/provider/business behavior
     - preserve financial safety and product boundaries
     - keep L3 local composition only with a written reason
  6. Verify:
     - format touched Dart files
     - run focused tests
     - run required audits
     - run flutter analyze
     - use emulator/manual QA for Tool screens and first-viewport/layout changes
  7. Use GitNexus after edits:
     - detect_changes({scope: "all"})
     - record affected symbols/processes or transport limitation
  8. Update the tracker:
     - screen status
     - shared components applied
     - L3 local reasons
     - before/after grade/shared/custom counts
     - tests/audits
     - manual visual QA evidence
     - exact next RSC target
  9. Run:
     git diff --check -- docs/03_DESIGN_SYSTEM/VitTrade-Remaining-Shared-Components-Migration-Plan.md
  10. If another eligible RSC task remains, start it immediately.
```

SKILL AND MCP ROUTING:

Use every currently available skill/MCP capability when it helps the active
screen, but do not waste tokens by invoking unrelated tools. "Use all
available" means discover and apply the relevant capability at the right phase.

Required or expected:

1. `vittrade-ui-checklists`
   - Use for Flutter-safe UI migration, shared-component mapping,
     accessibility, responsive behavior, motion caution, and product-boundary
     checks.

2. `planning-and-task-breakdown`
   - Use the tracker tasks as the active ordered plan.
   - Keep each batch small enough to verify in one focused session.

3. `test-driven-development`
   - Use when changing behavior, route state, form/state logic, risk panels,
     or tests.
   - Prefer existing focused tests before adding new tests.

4. `debugging-and-error-recovery`
   - Use when analyzer/tests/audits fail and the cause is unclear.

5. `code-review-and-quality`
   - Use before marking a screen complete.
   - Review correctness, architecture, security/product safety, performance,
     and verification evidence.

6. `security-and-hardening`
   - Use for P2P, Trade, Earn, Wallet-like high-risk controls, masking,
     sensitive identifiers, financial copy, or confirmation flows.

7. GitNexus MCP
   - Use `list_repos` once at preflight.
   - Use `query` when discovering unfamiliar flow context.
   - Use `context` and `impact` before editing any symbol/class/method.
   - Use `detect_changes` after edits and before any commit/handoff.
   - If GitNexus MCP fails but CLI status is healthy, retry a small number of
     times, record the limitation, and continue with source/audit/test fallback.

8. Headroom MCP
   - Use only to compress long GitNexus output, audit logs, test logs, or long
     diffs.
   - Store hashes in the tracker only when the compressed output matters for
     handoff.
   - Do not use Headroom as source of truth for source files or audits.

9. Android emulator QA / visual QA
   - Use for Tool screens, keyboard/safe-area behavior, charts/canvas/chat
     surfaces, and first-viewport layout changes.
   - Capture screenshots under `flutter_app/run-artifacts/`.
   - Verify nonblank rendering, safe close/back controls, and no overlap.

10. `tool_search`
    - Use only when the prompt requires a capability that is not already in the
      visible tool list.

11. `multi_tool_use.parallel`
    - Use for independent reads/checks such as `git status`, focused `rg`,
      reading multiple docs, and audit summaries.

Do not use unrelated Data Analytics, Canva, OpenAI API, image generation,
documents, spreadsheets, or presentation tools unless the active screen
explicitly needs that capability.

TOKEN-EFFICIENT EXECUTION RULES:

- Read the tracker sections and active screen files, not the whole repo.
- Prefer generated CSVs for status instead of manual source-wide scans.
- Use `rg` and `rg --files`; avoid broad recursive dumps.
- Use GitNexus `summaryOnly` or `maxDepth=1` first for broad symbols.
- Use Headroom for long logs instead of pasting them into context.
- Redirect long test output to `flutter_app/run-artifacts/*.log` when useful,
  then summarize pass/fail and first relevant failure only.
- Do not paste large source files into plan updates or final responses.
- Keep updates concise and factual.
- Use the same verification command only when it provides new evidence.
- Batch one high-risk screen at a time; group only tiny, tightly coupled fixes.

IMPLEMENTATION RULES:

- Use `apply_patch` for manual code and docs edits.
- Do not revert unrelated dirty worktree changes.
- Do not change route paths, providers, repository contracts, domain objects,
  or business logic unless required by the active migration and verified by
  tests.
- Preserve widget keys used by tests.
- Preserve masking for wallet, account, email, phone, address, payment methods,
  and sensitive identifiers.
- Preserve fees, limits, risk copy, preview, confirmation, submitting,
  success/error/offline, receipt, and next-step states.
- Do not remove labels/disclosures to reduce visual debt.
- Do not add decorative blobs, unrelated gradients, marketing hero sections,
  unrelated animations, or noisy nested cards.
- Do not introduce emojis as UI icons.
- Use accessible labels/tooltips for icon-only controls.
- Use responsive constraints instead of fixed viewport-size assumptions.

PRODUCT SAFETY RULES:

- Arena is always points-only.
- Prediction Markets may use positions, probability, orders, receipt, rewards,
  and P/L.
- P2P must preserve escrow/payment/identity safety language.
- Earn/staking must preserve risk, lockup, suitability, proof, and custody
  language.
- Trade/futures/bots must preserve leverage, liquidation, margin, suitability,
  emergency stop, fee, and order-risk disclosures.
- High-risk actions must preview risks and require explicit confirmation.

VERIFICATION BY SCREEN TYPE:

For every screen:

```powershell
cd flutter_app
dart format <touched dart files>
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

For route/navigation-sensitive work:

```powershell
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

For P2P:

```powershell
flutter test test/features/p2p --reporter=compact
```

For Trade:

```powershell
flutter test test/features/trade --reporter=compact
```

For Arena:

```powershell
flutter test test/features/arena --reporter=compact
```

For Earn:

```powershell
flutter test test/features/earn --reporter=compact
```

For Referral:

```powershell
flutter test test/features/referral/referral_home_page_test.dart --reporter=compact
```

For Enterprise States:

```powershell
flutter test test/features/enterprise_states/enterprise_states_page_test.dart --reporter=compact
```

For broad shared primitive, router, shell, or cross-module changes:

```powershell
flutter test --reporter=compact
```

MANUAL VISUAL QA FOR TOOL SCREENS:

Tool screens require manual emulator/device evidence before completion:

- `P2PChatPage`
- `AdvancedChartPage`
- `TradingBotsPage`
- `EnterpriseStatesPage`
- `FuturesPage`

Minimum visual QA:

```text
device/emulator:
route/screen:
screenshot path:
nonblank render:
safe area:
back/close:
keyboard/tool controls if relevant:
overlap check:
notes:
```

TRACKER UPDATE REQUIREMENT:

After every verified RSC task, update:

```text
docs/03_DESIGN_SYSTEM/VitTrade-Remaining-Shared-Components-Migration-Plan.md
```

Update at least:

- Summary Queue status.
- Per-screen evidence or batch log.
- Before/after grade/shared/custom counts.
- Shared components applied.
- L3 local reasons.
- GitNexus evidence.
- Tests/audits.
- Manual visual QA evidence for Tool screens.
- Current next action.

Then run:

```powershell
git diff --check -- docs/03_DESIGN_SYSTEM/VitTrade-Remaining-Shared-Components-Migration-Plan.md
```

END-OF-TURN GUARD:

Before sending a final response, answer this internally:

1. Did all final acceptance gates pass?
2. If not, is every remaining eligible RSC task blocked after 3 attempts?
3. If not, did a hard platform/tool failure prevent further commands/edits
   after trying to start the next eligible task?
4. If not, did the user explicitly stop or redirect the work?
5. If not, have I already started the next eligible RSC task after updating the
   tracker for the previous one?

If answers 1-4 are "no", do not final. Continue.
If answer 5 is "no", do not final. Start the next eligible RSC task now.

OUTPUT STYLE:

- Give short progress updates while working.
- Keep docs, evidence, and technical summaries in English.
- Keep user-facing final summaries concise.
- Mention files changed, tests/audits run, GitNexus evidence, visual QA
  evidence, and next task.
- Do not paste huge logs.
- Do not use a final response as a progress update while work remains.

START NOW:

1. Run mandatory preflight.
2. Read the required docs.
3. Resolve the current queue from the tracker and fresh audits.
4. Start `RSC-01 P2PChatPage` unless fresh evidence marks it complete.
5. Use GitNexus context/impact before edits.
6. Implement, verify, visually QA if required, and update the tracker.
7. Continue directly to the next eligible RSC task.
8. Keep going until the final acceptance gates pass or a valid stop condition
   forces handoff.
````

## Resume Hint

At the time this prompt was created, the tracker recommends starting with:

```text
RSC-01 - P2PChatPage
```

Current verified audit snapshot at creation:

```text
routed_screens=414
page_files_covered=607
unmapped_page_files=0
grade_A=403
grade_B=6
grade_Tool=5
token_debt=0
navigation_edges=883
```

This hint is informational only. A future run must trust the tracker plus fresh
generated audits over this embedded snapshot.

