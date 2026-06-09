# AI Enterprise UI/UX Synchronization Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
enterprise UI/UX synchronization work from:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Enterprise-UI-UX-Synchronization-Master-Plan.md`

This is not a request to create another plan. It is a request to execute the
existing master plan automatically, in priority order, until the app reaches the
defined enterprise UI/UX completion criteria. The prompt is written for
continuous execution: a verified batch is a checkpoint, not a stopping point.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the enterprise UI/UX synchronization master plan from:

docs/02_FLUTTER_MIGRATION/VitTrade-Enterprise-UI-UX-Synchronization-Master-Plan.md

The product target is:
- Flutter Enterprise-grade
- Dark professional
- Crypto exchange
- Trading super-app
- Phone-first at 360 px and up
- Financial-safety-first
- Consistent header, body layout, surfaces, controls, states, copy, and QA

FINAL SUCCESS CRITERIA:
The job is complete only when all of the following are true:

1. Header audit remains strict-clean:
   - `strict_visual_issues=0`
   - `screen_level_mismatches=0`
2. Body audit has no standard D screens.
3. Wallet remains A/B only.
4. Profile remains A/B only.
5. Trade is A/B only except documented Tool pages.
6. P2P is A/B only except documented Tool pages.
7. Predictions is A/B only.
8. Markets is A/B only.
9. Auth and DCA have no D screens.
10. Arena keeps points-only copy boundaries.
11. Prediction Markets and Open Arena remain visually and semantically separate.
12. High-risk financial flows have preview, confirm, fee/risk/limit, masking,
    result, and next-step semantics where applicable.
13. Fullscreen tools are documented exceptions and pass manual/visual QA.
14. Focused tests for touched features pass.
15. `flutter analyze` passes.
16. Audit artifacts are current.

CONTINUOUS COMPLETION CONTRACT:
This is the most important operating rule in this prompt.

- Treat the work as a continuous multi-batch execution run.
- A single completed batch is not a valid stopping point.
- After every verified batch, immediately regenerate or inspect the current
  audit, select the next highest-priority incomplete batch, and continue
  implementation in the same assistant turn.
- Do not send a final answer just to report progress while any final success
  criterion is still unmet.
- Use short progress updates while working; reserve the final response only for:
  1. full completion,
  2. a real blocker that requires user input, or
  3. an unavoidable platform/context/tool limit.
- If the platform, context window, or tool runtime prevents continuing, emit the
  exact `RESUME FROM:` marker described below. The next AI run must continue
  from that marker and must not restart from the beginning.
- Time pressure, token pressure, large remaining scope, or "one batch finished"
  is not a blocker.
- Remaining C/D screens are not a blocker. They are the next work queue.
- A real blocker exists only when the same blocking condition remains after at
  least three concrete repair attempts, or when required user/business input is
  genuinely unavailable from local repo context.

RESUME INPUT HANDLING:
If the conversation or user message contains a line like:

```text
RESUME FROM: <phase> - <feature/batch/page group>
```

then do this:

1. Treat that marker as the active starting point.
2. Run preflight and read the current audit CSV.
3. Verify whether the named batch is still incomplete.
4. If it is incomplete, continue that batch.
5. If it is already complete, move to the next highest-priority incomplete item
   from the current audit.
6. Do not re-plan the entire project unless the master plan or audit artifact is
   missing.

NON-NEGOTIABLE EXECUTION RULES:
- Do not only analyze.
- Do not create another plan instead of executing the plan.
- Do not stop after one screen, one batch, or one module unless the user
  explicitly asked for that limited scope only.
- Continue automatically from the next highest-priority incomplete item.
- Work in small, verifiable batches.
- Prefer 5 to 8 screens per batch for large modules such as Trade and P2P.
- Finish and verify the current batch, then continue to the next batch without
  waiting for user approval.
- Do not make broad unrelated refactors.
- Do not revert unrelated dirty worktree changes.
- Preserve existing routes, widget keys, providers, controllers, and behavior.
- Use `apply_patch` for manual file edits.
- Use shared VitTrade primitives before creating local UI.
- Keep dark theme as the baseline.
- Do not recreate React, Vite, npm, Tailwind, or obsolete web screenshot tools.
- Do not introduce new local palettes, local spacing systems, decorative blobs,
  marketing hero sections, or unrelated visual effects.
- Do not weaken financial safety to make a page look cleaner.
- If a test fails because a key or behavior moved, prefer preserving the key and
  behavior instead of editing the test.

MANDATORY READ BEFORE EDITING:
Read enough of each document to follow the active rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`
7. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`
8. `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`
9. `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
10. `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.md`
11. `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`
12. `docs/02_FLUTTER_MIGRATION/VitTrade-Enterprise-UI-UX-Synchronization-Master-Plan.md`
13. Existing tests for the feature being edited.
14. Page and widget source files for the selected batch.

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Screen pages: `flutter_app/lib/features/<feature>/presentation/pages/`
- Feature widgets: `flutter_app/lib/features/<feature>/presentation/widgets/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Public router import: `flutter_app/lib/app/router/app_router.dart`
- Tests: `flutter_app/test/`
- Body audit tool: `flutter_app/tool/body_component_consistency_audit.dart`
- Header audit:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- Body audit:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`
- Master plan:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Enterprise-UI-UX-Synchronization-Master-Plan.md`

CURRENT BASELINE TO VERIFY AT START:
Run or inspect current artifacts. Do not assume stale values.

Recent snapshot example only; do not treat this as fixed truth:

```text
Header:
total_routed_screens=414
strict_visual_issues=0
screen_level_mismatches=0
detail=393
rootModule=11
fullscreenTool=5
instrument=3
authOnboarding=1
rootBrand=1

Body:
grade_A=80
grade_B=178
grade_C=109
grade_D=42
grade_Tool=5
```

Recent completed work:
- Wallet is A/B only.
- Profile is A/B only.
- First BCC-07 Trade copy-trading D batch completed:
  `CopyTradingPage`, `CopyEducationPage`, `CopySafetyCenterPage`,
  `CopySettingsPage`.

If the current audit differs, trust the latest generated audit and update your
batch selection accordingly.

Known continuation target if the current audit still matches the recent work:

```text
RESUME FROM: BCC-07 Trade P0 - continue Trade D batch with ActiveCopiesPage, CopyAuditLogPage, DisputeResolutionPage
```

APPROVED SHARED PRIMITIVES:
Use these before local UI:

- Layout:
  `VitAppShell`, `VitPageLayout`, `VitAutoHideHeaderScaffold`,
  `VitPageContent`, `VitPageSection`
- Header:
  `VitTopChrome`, `VitHeader`, `VitHeaderActionItem`
- Navigation:
  `VitBottomNav`, route-safe back helpers
- Surfaces:
  `VitCard`, `VitCardStat`, `VitServiceTile`, `VitModuleHeroCard`,
  `VitMetricCard`
- Controls:
  `VitCtaButton`, `VitIconButton`, `VitInput`, `VitSearchBar`, `VitTabBar`,
  `VitStatusPill`
- States:
  `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`, `VitSkeleton`,
  `VitHighRiskStatePanel`

LOCAL UI IS ALLOWED ONLY FOR:
- Small badges, pills, avatars, icon markers, or micro decorations inside a
  shared card.
- Domain-specific chart, candle, order book, canvas, or fullscreen tool UI.
- Approved fullscreen tool exceptions.
- A one-off visual marker that does not become a repeated card/panel system.

UI/UX STANDARD:
- Phone-first at 360 px and up.
- Dark professional, high contrast, low-light friendly.
- Operational and dense, not marketing-like.
- Use theme tokens from `flutter_app/lib/app/theme/`.
- Avoid nested cards unless a shared inner-card variant explicitly supports the
  hierarchy.
- Avoid fixed widths and fragile fixed heights unless they are stable UI
  elements such as toolbars, compact stats, or controls.
- Avoid text clipping in cards, buttons, tabs, filters, and footers.
- Keep labels scan-friendly and decision-oriented.
- No hype, casino, FOMO, hidden fee, or misleading risk copy.

FINANCIAL SAFETY STANDARD:
High-risk flows must include the applicable items below:

- Preview before confirm.
- Explicit confirmation.
- Fee display.
- Risk display.
- Limit display.
- Sensitive data masking.
- Loading/submitting state.
- Success/result state.
- Error/failure state.
- Offline state when network dependency matters.
- Next steps after submission/result.
- Danger/destructive styling for irreversible actions.

High-risk examples:
- Withdraw
- Transfer
- Deposit address/network selection
- Address add/edit
- API key create/reveal/delete/regenerate
- Security/password/2FA changes
- P2P payment method changes
- P2P escrow release/cancel/dispute
- Trade order placement/close/reduce
- Margin/liquidation-related settings
- Copy trading provider/follower actions
- DCA/rebalance automation
- Earn subscribe/redeem/rebalance
- Launchpad subscribe/allocation
- Prediction order/position/receipt flows

COPY BOUNDARY STANDARD:
- Arena must remain points-only.
- Arena allowed language: Arena Points, points pool, completion, fair play,
  challenge, creator, leaderboard.
- Arena forbidden language: wallet, payout, profit, stake return, casino,
  gamble, gambling, FOMO.
- Prediction Markets may use positions, probability, open orders, receipt,
  rewards, and P/L.
- Trading copy must be sober, factual, and risk-aware.

AUTOMATIC EXECUTION LOOP:
Repeat this loop until final success criteria are met.

1. Preflight:
   - Check dirty worktree.
   - Identify unrelated changes and ignore them.
   - Run or inspect body/header/route audit.
   - Confirm Wallet and Profile remain A/B.

2. Select next batch:
   - Use current CSV, not memory.
   - Choose the highest-priority incomplete feature in this order:
     1. Trade D
     2. Trade C
     3. P2P D
     4. P2P C
     5. Earn C
     6. Launchpad C
     7. Predictions C
     8. DCA D
     9. Auth D/C
     10. Markets C
     11. Arena C
     12. News C
     13. Notifications C
     14. Any remaining D
     15. Any remaining high-impact C
   - For Trade and P2P, choose 5 to 8 screens per batch.
   - Prefer screens with `primary_issue` equal to:
     - `missing_financial_safety_preview_confirm`
     - `raw_controls_need_shared_primitives`
     - `missing_shared_body_layout`
     - `local_surfaces_need_vitcard`
     - `missing_required_state_coverage`
   - Group pages by feature and nearby widgets to keep each batch coherent.

3. Read before editing:
   - Page files for selected rows.
   - Direct `part` files.
   - Direct feature widget imports.
   - Existing focused tests.
   - Shared primitive APIs you intend to use.

4. Implement:
   - Add or verify `VitPageContent`.
   - Use `fullBleed: true` when the surrounding scroll view already supplies
     horizontal page padding.
   - Convert repeated local card/panel wrappers to `VitCard`.
   - Replace raw `TextField` with `VitInput`.
   - Replace repeated local search with `VitSearchBar`.
   - Replace primary action containers with `VitCtaButton`.
   - Replace icon action containers with `VitIconButton` when appropriate.
   - Add shared empty/error/offline/loading/submitting/success states.
   - Add `VitHighRiskStatePanel` where safety review is required.
   - Preserve all existing keys used by tests.
   - Preserve navigation semantics and route fallback behavior.
   - Avoid broad theme changes unless required by a shared component gap.

5. Verify the batch:
   - Format touched files.
   - Run focused analyzer if helpful.
   - Regenerate body audit.
   - Confirm selected pages improved to A/B or are documented Tool exceptions.
   - Run focused feature tests.
   - Run `flutter analyze`.
   - Run header and route audit checks if shell/header/router/shared layout was
     touched.

6. Repair:
   - Fix compile errors first.
   - Fix analyzer warnings second.
   - Fix focused test failures third.
   - Fix audit regressions fourth.
   - Fix layout overflow or bottom overlap before moving on.

7. Update status:
   - Summarize pages fixed in a short progress update, not a final answer.
   - Record remaining C/D counts for the feature.
   - If feature target is not complete, continue next batch for that feature.
   - If feature target is complete, move to next feature.
   - Do not ask the user whether to continue unless a real blocker exists.
   - Do not stop after this step; return to step 1 or step 2 immediately.

8. Stop only when:
   - The whole app meets final success criteria, or
   - There is a real blocker that has repeated after at least three concrete
     repair attempts and requires user input, or
   - The platform/context/tool limit forces the turn to end.

9. If the turn must end before full completion:
   - Verify the latest completed batch as much as possible.
   - Regenerate the audit if code changes were made.
   - Identify the exact next incomplete phase/batch/page group from the current
     audit.
   - End the final response with the exact `RESUME FROM:` marker and no text
     after it.

MULTI-BATCH TURN REQUIREMENT:
Within one AI turn, do as many complete verify-and-repair batches as feasible.
The minimum acceptable stopping point is not "one batch done"; the minimum is:

```text
all final success criteria met
```

or:

```text
RESUME FROM: <exact next phase/batch/page group>
```

Use the resume marker only when the turn cannot continue because of a real
blocker or unavoidable platform/context/tool limit.

COMMANDS:

Use PowerShell-compatible commands. Do not use `&&`.

Preflight:

```powershell
git status --short
cd flutter_app
dart run tool\body_component_consistency_audit.dart
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
```

Inspect current priority rows from repo root:

```powershell
Import-Csv -Path docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Where-Object { $_.feature -eq 'trade' -and $_.body_grade -eq 'D' } |
  Select-Object route,page,page_file,primary_issue,recommended_action,test_scope |
  Format-Table -AutoSize
```

Inspect next feature by grade:

```powershell
Import-Csv -Path docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Where-Object { $_.feature -eq '<feature>' } |
  Sort-Object body_grade,issue_priority,page |
  Format-Table page,body_grade,issue_priority,layout_status,surface_status,controls_status,state_status,financial_safety_status,primary_issue -AutoSize
```

Format touched feature:

```powershell
cd flutter_app
dart format lib\features\<feature>\presentation
```

Regenerate audit:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
```

Focused tests:

```powershell
cd flutter_app
flutter test test\features\<feature> --reporter=compact
```

Global checks:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart --check
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
flutter analyze
```

Full test for final milestone:

```powershell
cd flutter_app
flutter test --reporter=compact
```

If full test has unrelated failures, document exact failing tests and ensure all
touched feature tests pass.

PHASE ORDER:

Phase 0 - Baseline lock:
- Verify audits current.
- Confirm Wallet/Profile remain A/B.
- Confirm current C/D counts.

Phase 1 - BCC-07 Trade P0:
- Eliminate Trade D pages first.
- Then reduce Trade C pages.
- Preserve instrument/tool density where justified.
- Add financial safety semantics for order, position, margin, copy trading,
  risk, receipt, and report flows.
- Document fullscreen tools.

Phase 2 - BCC-08 P2P P0:
- Eliminate P2P D pages.
- Reduce P2P C pages.
- Normalize offer, payment, escrow, dispute, merchant, KYC, and chat-related
  flows.
- Add payment masking, counterparty risk, escrow status, evidence states, and
  confirm-before-release/cancel semantics.

Phase 3 - BCC-09 Earn P1:
- Reduce Earn C pages.
- Normalize savings/staking/strategy/auto-rebalance/history/disclosure pages.
- Add APY/yield, lockup, redemption, fee, limit, and result semantics.

Phase 4 - BCC-10 Launchpad P1:
- Reduce Launchpad C pages.
- Normalize project detail, subscription, allocation, eligibility,
  notification, vesting, and result states.
- Remove hype/FOMO copy if found.

Phase 5 - BCC-11 Predictions P1:
- Reduce Predictions C pages.
- Normalize event detail, order, position, receipt, and history states.
- Preserve Prediction vs Arena copy boundary.

Phase 6 - BCC-12 Residuals:
- Fix DCA D pages.
- Fix Auth D/C pages.
- Fix Markets C.
- Fix Arena C with points-only copy check.
- Fix News and Notifications C.

Phase 7 - Final QA:
- Run global audit checks.
- Run analyzer.
- Run full or focused test suite as appropriate.
- Run emulator/visual QA for layout-heavy pages and fullscreen tools when
  available.
- Confirm acceptance criteria.

PER-SCREEN CHECKLIST:
Use this for every selected route before marking it complete.

```text
Feature:
Route:
Page:
Page file:
Current grade:
Target grade:
Primary issue:
High-risk action:

Layout:
[ ] `VitPageLayout`
[ ] `VitAutoHideHeaderScaffold` or approved tool exception
[ ] `VitPageContent`
[ ] No double padding
[ ] Bottom safe area handled

Header:
[ ] Correct archetype
[ ] Back behavior correct
[ ] Header actions limited
[ ] No embedded status banner in header

Surfaces:
[ ] Main panels use `VitCard` or approved shared surface
[ ] No repeated local card system
[ ] Theme tokens for border/radius/background
[ ] No incoherent nested cards

Controls:
[ ] Input uses `VitInput`
[ ] Search uses `VitSearchBar`
[ ] Primary CTA uses `VitCtaButton`
[ ] Icon action uses `VitIconButton` or header action
[ ] Tabs use `VitTabBar`
[ ] Keys preserved

States:
[ ] Loading
[ ] Empty
[ ] Error
[ ] Offline when applicable
[ ] Submitting when applicable
[ ] Success/result when applicable

Financial safety:
[ ] Preview
[ ] Confirm
[ ] Fee
[ ] Risk
[ ] Limit
[ ] Masking
[ ] Next step
[ ] Destructive confirmation

Responsive:
[ ] 360 px safe
[ ] Text does not overflow
[ ] CTA/footer not hidden by bottom nav
[ ] Keyboard does not hide form completion path

Copy:
[ ] No casino/gamble/FOMO
[ ] Arena points-only if Arena
[ ] Prediction copy stays value/probability/P/L oriented
[ ] Trading copy is sober and risk-aware

Verification:
[ ] Format
[ ] Audit improved or justified exception
[ ] Focused tests pass
[ ] Analyzer passes
```

FEATURE-SPECIFIC MUST-NOT-MISS NOTES:

Trade:
- Order entry must show risk and confirmation where applicable.
- Position close/reduce must not be ambiguous.
- Margin and liquidation language must be visible and sober.
- Copy trading provider/follower flows must disclose role, risk, limits, and
  next step.
- Reports and analytics must have loading/empty/error states.
- Fullscreen chart/trading tools need safe close/back, safe areas, and visual
  evidence.

P2P:
- Payment method data must be masked.
- Escrow release/cancel/dispute must require explicit confirmation.
- Dispute evidence upload needs empty/loading/error/submitting/result states.
- Counterparty risk and completion status should be scan-friendly.
- Payment instructions must be clear and not hidden behind bottom surfaces.

Earn:
- Yield/APY must not be presented as guaranteed unless product copy explicitly
  says so and docs support it.
- Lockup, redemption, fees, limits, and next steps must be visible.
- Auto-rebalance changes need preview and confirmation.

Launchpad:
- Eligibility, allocation, subscription, vesting, and risk must be visible.
- Avoid hype and urgency language.
- Result states must explain next steps.

Predictions:
- Use probability, position, open orders, receipt, P/L language.
- Avoid casino/gamble/FOMO.
- Do not mix with Arena points-only language.

Arena:
- Points-only.
- No wallet/profit/payout/stake-return.
- Fair play/completion/leaderboard copy is allowed.

Auth:
- Auth entry can keep special chrome.
- Forms still need shared inputs, CTA, validation, error, submitting, and
  success states.
- Password/2FA flows are high risk.

DCA:
- Automation changes need preview and confirmation.
- Rebalance settings must expose risk, limits, and next steps.

Markets:
- Chart/list pages can be dense.
- Loading/empty/error states must exist.
- Instrument navigation must remain clear.

PROGRESS REPORTING:
After each batch, report this as a short progress update while continuing work.
Do not use this report as the final answer unless the whole master plan is
complete or a real blocker/context limit forces the turn to end.

```text
Batch:
Feature:
Pages changed:
Before:
After:
Tests:
Analyzer:
Audits:
Remaining:
Next batch:
```

If you cannot complete the whole master plan in one run, your final response
must end with exactly:

```text
RESUME FROM: <phase> - <feature/batch/page group>
```

No text after that line.

The `RESUME FROM:` value must be specific enough for the next AI run to start
without asking follow-up questions. Good examples:

```text
RESUME FROM: BCC-07 Trade P0 - continue Trade D batch with ActiveCopiesPage, CopyAuditLogPage, DisputeResolutionPage
RESUME FROM: BCC-08 P2P P0 - next P2P D rows by current audit CSV
RESUME FROM: BCC-12 Residuals - Auth D/C cleanup after DCA D pages are clear
```

Bad examples:

```text
RESUME FROM: continue
RESUME FROM: next
RESUME FROM: UI work
```

If the whole master plan is complete, your final response must include exactly:

```text
ENTERPRISE UI/UX SYNCHRONIZATION COMPLETE
```

BEGIN NOW:
1. Read the master plan.
2. Run preflight.
3. Select the next incomplete batch from the current body audit CSV.
4. Implement the batch.
5. Verify it.
6. If verification fails, repair until the batch passes or a real blocker is
   proven after at least three concrete attempts.
7. If verification passes and final success criteria are still unmet, do not
   stop. Immediately select the next incomplete batch and continue.
8. Continue automatically until final success criteria are met, or until a real
   blocker/platform limit forces a `RESUME FROM:` handoff.
````
