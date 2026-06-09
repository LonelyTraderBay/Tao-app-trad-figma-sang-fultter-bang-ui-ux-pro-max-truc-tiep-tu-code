# AI Enterprise UI/UX Synchronization Autonomous Execution Prompt

Use this prompt in a fresh Codex/AI coding thread for the VitTrade Flutter repo.

Repository:

```text
C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code
```

## Mission

Execute the enterprise UI/UX synchronization master plan until the app meets the final acceptance gate.

Master plan:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Enterprise-UI-UX-Synchronization-Master-Plan.md
```

Product target:

- Flutter Enterprise-grade
- Dark professional
- Crypto exchange / trading super-app
- Phone-first at 360 px and up
- Financial-safety-first
- Consistent header, body layout, surfaces, controls, states, copy, and QA

## Non-Stop Execution Contract

This is the controlling rule for the whole run.

Do not stop after one screen, one batch, or one feature.

You must keep executing the loop below until exactly one of these stop conditions is true:

1. The full final acceptance gate is met.
2. A real blocker requires user input and remains after at least three concrete repair attempts.
3. The platform/context/tool limit forces a handoff.

A completed batch is not a valid final answer.
A reduced D/P0 count is not a valid final answer.
Large remaining scope is not a blocker.
Token pressure is not a blocker unless the platform actually forces the turn to end.
Remaining C/D/P0 rows are the next queue, not a reason to stop.

After every verified batch:

1. Regenerate or inspect the latest audit CSV.
2. Select the next highest-priority incomplete batch.
3. Continue implementation immediately in the same turn.

Only send a final response when the final acceptance gate is complete, a real blocker is proven, or a platform/context limit forces a resume handoff.

## Resume Handling

If the thread contains a line like:

```text
RESUME FROM: <phase> - <feature/batch/page group>
```

start there.

Resume rules:

1. Treat the marker as the active starting point.
2. Run preflight and read the current body audit CSV.
3. Check whether the named batch is still incomplete.
4. If incomplete, continue that batch.
5. If already complete, select the next highest-priority incomplete row from the current CSV.
6. Do not restart from the beginning unless the audit artifacts or master plan are missing.

Known latest handoff, if still relevant:

```text
RESUME FROM: BCC-07 Trade P0 - complete remaining P0 raw-control/financial pages: ProviderApplicationPage, ConvertPage, MarketDataAnalyticsPage, then review CopyTradingCardDemo/TradePage/FuturesPage P0 rows
```

Always trust the current generated audit over this example handoff.

## Final Acceptance Gate

The work is complete only when all items below are true:

1. Header audit is strict-clean:
   - `strict_visual_issues=0`
   - `screen_level_mismatches=0`
2. Body audit has no standard D screens.
3. Wallet is A/B only.
4. Profile is A/B only.
5. Trade is A/B only except documented Tool pages.
6. P2P is A/B only except documented Tool pages.
7. Predictions is A/B only.
8. Markets is A/B only.
9. Auth and DCA have no D screens.
10. Arena keeps points-only copy boundaries.
11. Prediction Markets and Open Arena remain visually and semantically separate.
12. High-risk financial flows have applicable preview, confirm, fee/risk/limit, masking, result, and next-step semantics.
13. Fullscreen tools are documented exceptions and pass manual/visual QA.
14. Focused tests for touched features pass.
15. `flutter analyze` passes.
16. Audit artifacts are current.

If the gate is complete, the final response must include exactly:

```text
ENTERPRISE UI/UX SYNCHRONIZATION COMPLETE
```

If the gate is not complete and the turn must end, the final response must end with exactly:

```text
RESUME FROM: <exact next phase/batch/page group>
```

No text is allowed after the `RESUME FROM:` line.

## Mandatory Preflight

Run from repo root unless noted.

```powershell
git status --short
cd flutter_app
dart run tool\body_component_consistency_audit.dart
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
```

Then inspect current body audit rows from repo root:

```powershell
Import-Csv -Path docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Sort-Object feature,body_grade,issue_priority,page |
  Format-Table feature,page,body_grade,issue_priority,layout_status,surface_status,controls_status,state_status,financial_safety_status,primary_issue -AutoSize
```

Do not assume old counts. Use the latest generated CSV.

## Mandatory Reading Before Edits

Read enough of these files to obey project rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`
7. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`
8. `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`
9. `docs/02_FLUTTER_MIGRATION/VitTrade-Enterprise-UI-UX-Synchronization-Master-Plan.md`
10. Current header/body audit artifacts
11. Page files, part files, direct feature widgets, and focused tests for the selected batch

## Source Of Truth

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
- Header audit tool: `flutter_app/tool/top_header_visual_archetype_audit.dart`
- Route audit tool: `flutter_app/tool/route_coverage_audit.dart`

Do not recreate React, Vite, npm, Tailwind, or old web screenshot tooling.

## Batch Selection Order

Use the current audit CSV, not memory.

Priority order:

1. Trade D
2. Trade P0/C
3. P2P D
4. P2P P0/C
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
15. Any remaining high-impact C/P0

Within each feature, prefer rows with:

- `missing_financial_safety_preview_confirm`
- `raw_controls_need_shared_primitives`
- `missing_shared_body_layout`
- `local_surfaces_need_vitcard`
- `missing_required_state_coverage`
- `responsive_or_bottom_chrome_risk`

Batch size:

- Trade/P2P large modules: 3 to 8 coherent screens per batch.
- Complex form/tool pages: 1 to 3 screens per batch if needed.
- Group by shared part files or nearby feature widgets.

## Autonomous Execution Loop

Repeat this loop until the final acceptance gate is complete.

### 1. Select

Read the current CSV and choose the next batch using the priority order above.

Before editing, write a short progress update:

```text
Next batch: <phase> - <feature/pages>. Reason: <primary audit issue>.
```

### 2. Inspect

Read:

- Page files for selected rows
- Direct `part` files
- Direct feature widget imports
- Existing focused tests
- Shared primitive APIs you intend to use

### 3. Implement

Use shared primitives before local UI:

Layout:

- `VitPageLayout`
- `VitAutoHideHeaderScaffold`
- `VitPageContent`
- `VitPageSection`

Surfaces:

- `VitCard`
- `VitCardStat`
- `VitServiceTile`
- `VitModuleHeroCard`
- `VitMetricCard`

Controls:

- `VitCtaButton`
- `VitIconButton`
- `VitInput`
- `VitSearchBar`
- `VitTabBar`
- `VitStatusPill`

States:

- `VitEmptyState`
- `VitErrorState`
- `VitOfflineBanner`
- `VitSkeleton`
- `VitHighRiskStatePanel`

Implementation rules:

- Preserve routes, providers, controller behavior, and widget keys.
- Preserve existing test-visible text unless a copy-boundary or safety fix requires change.
- If a test asserts a specific widget type, preserve the behavior and key; only change the test if the old assertion is no longer valid and the new UI is intentionally shared.
- Prefer `VitPageContent(fullBleed: true)` when the scroll view already provides horizontal padding.
- Replace repeated local `Container` panels with `VitCard`.
- Replace raw `TextField` with `VitInput`.
- Replace search fields with `VitSearchBar`.
- Replace primary action containers/buttons with `VitCtaButton`.
- Add `VitHighRiskStatePanel` for financial safety review, success, submitting, error, or offline states where applicable.
- Keep local UI only for small badges, pills, avatars, chart internals, canvas/tool internals, or approved one-off markers.
- Do not create new local palettes, spacing systems, decorative blobs, or marketing hero sections.
- Do not weaken financial safety to make layout cleaner.
- Do not revert unrelated dirty worktree changes.

### 4. Verify

For every batch:

```powershell
cd flutter_app
dart format <touched files or directories>
flutter analyze <touched files>
dart run tool\body_component_consistency_audit.dart
flutter test <focused tests> --reporter=compact
```

If shell/header/router/shared layout was touched, also run:

```powershell
cd flutter_app
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
```

Confirm each selected page became A/B or a documented Tool exception.

### 5. Repair

If verification fails:

1. Fix compile errors.
2. Fix analyzer warnings.
3. Fix focused test failures.
4. Fix audit regressions.
5. Fix layout overflow/bottom chrome issues.
6. Re-run verification.

Make at least three concrete repair attempts before declaring a real blocker.

### 6. Continue

After a verified batch:

1. Regenerate or inspect the current body audit.
2. Report a short progress update.
3. Select the next incomplete batch.
4. Continue immediately.

Do not ask whether to continue.
Do not send a final progress-only answer.

## Per-Screen Checklist

Use this checklist for every selected route.

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
[ ] VitPageLayout
[ ] VitAutoHideHeaderScaffold or approved tool exception
[ ] VitPageContent
[ ] No double padding
[ ] Bottom safe area handled

Header:
[ ] Correct archetype
[ ] Back behavior correct
[ ] Header actions limited
[ ] No embedded status banner in header

Surfaces:
[ ] Main panels use VitCard or approved shared surface
[ ] No repeated local card system
[ ] Theme tokens for border/radius/background
[ ] No incoherent nested cards

Controls:
[ ] Input uses VitInput
[ ] Search uses VitSearchBar
[ ] Primary CTA uses VitCtaButton
[ ] Icon action uses VitIconButton or header action
[ ] Tabs use VitTabBar where appropriate
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
[ ] Prediction copy stays probability/position/P/L oriented
[ ] Trading copy is sober and risk-aware

Verification:
[ ] Format
[ ] Audit improved or documented exception
[ ] Focused tests pass
[ ] Analyzer passes
```

## Financial Safety Standard

High-risk flows must include applicable:

- Preview before confirm
- Explicit confirmation
- Fee display
- Risk display
- Limit display
- Sensitive data masking
- Loading/submitting state
- Success/result state
- Error/failure state
- Offline state when network dependency matters
- Next steps after submission/result
- Danger/destructive styling for irreversible actions

High-risk examples:

- Withdraw / transfer / deposit address selection
- Address add/edit
- API key create/reveal/delete/regenerate
- Security/password/2FA changes
- P2P payment method, escrow release, cancel, dispute
- Trade order placement, close, reduce
- Margin/liquidation settings
- Copy trading provider/follower actions
- DCA/rebalance automation
- Earn subscribe/redeem/rebalance
- Launchpad subscribe/allocation
- Prediction order/position/receipt flows

## Copy Boundary Standard

Arena:

- Allowed: Arena Points, points pool, completion, fair play, challenge, creator, leaderboard
- Forbidden: wallet, payout, profit, stake return, casino, gamble, gambling, FOMO

Prediction Markets:

- Allowed: positions, probability, open orders, receipt, rewards, P/L
- Forbidden: casino, gamble, gambling, FOMO

Trading:

- Sober, factual, risk-aware
- No hidden fee language
- No hype or urgency pressure

## Feature Notes

Trade:

- Order/position/margin/copy flows must show risk and next step.
- Reports and analytics need loading/empty/error or high-risk review states.
- Fullscreen tools need safe close/back and safe areas.

P2P:

- Mask payment method data.
- Escrow release/cancel/dispute requires explicit confirmation.
- Evidence upload needs empty/loading/error/submitting/result states.

Earn:

- APY/yield must not imply guarantee.
- Lockup, redemption, fees, limits, and next steps must be visible.

Launchpad:

- Eligibility, allocation, subscription, vesting, and risk must be visible.
- Avoid hype/FOMO.

Predictions:

- Use probability, positions, open orders, receipt, P/L.
- Do not mix with Arena points-only language.

Arena:

- Points-only.
- No wallet/profit/payout/stake-return.

Auth:

- Auth chrome can be special.
- Inputs, CTA, validation, error, submitting, and success states still matter.

DCA:

- Automation and rebalance settings need preview, confirmation, risk, limits, and next step.

Markets:

- Dense chart/list UI is acceptable.
- Loading/empty/error states and instrument navigation must remain clear.

## Command Reference

Preflight:

```powershell
git status --short
cd flutter_app
dart run tool\body_component_consistency_audit.dart
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
```

Inspect Trade D/P0 rows:

```powershell
Import-Csv -Path docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Where-Object { $_.feature -eq 'trade' -and ($_.body_grade -eq 'D' -or $_.issue_priority -eq 'P0') } |
  Sort-Object body_grade,issue_priority,page |
  Format-Table route,page,page_file,body_grade,issue_priority,primary_issue,recommended_action,test_scope -AutoSize
```

Inspect one feature:

```powershell
Import-Csv -Path docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Where-Object { $_.feature -eq '<feature>' } |
  Sort-Object body_grade,issue_priority,page |
  Format-Table page,body_grade,issue_priority,layout_status,surface_status,controls_status,state_status,financial_safety_status,primary_issue -AutoSize
```

Verify touched feature:

```powershell
cd flutter_app
dart format lib\features\<feature>\presentation
flutter analyze lib\features\<feature>\presentation
dart run tool\body_component_consistency_audit.dart
flutter test test\features\<feature> --reporter=compact
```

Global final checks:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart --check
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

If full tests have unrelated failures, document exact failing tests and ensure all touched focused tests pass.

## Progress Update Format

Use this only as an intermediate progress update while continuing work:

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

Do not use this as the final answer unless the final acceptance gate is complete or a real blocker/context limit forces the run to end.

## Final Response Rules

If complete, final response must contain:

```text
ENTERPRISE UI/UX SYNCHRONIZATION COMPLETE
```

If not complete and the turn must end, final response must end with:

```text
RESUME FROM: <phase> - <feature/batch/page group>
```

The resume marker must be specific enough for the next run to continue without questions.

Good:

```text
RESUME FROM: BCC-07 Trade P0 - complete remaining P0 raw-control/financial pages: ProviderApplicationPage, ConvertPage, MarketDataAnalyticsPage
```

Bad:

```text
RESUME FROM: continue
RESUME FROM: next
RESUME FROM: UI work
```

## Begin Now

1. Read mandatory docs.
2. Run preflight.
3. Read current body audit CSV.
4. If a `RESUME FROM:` marker exists, continue from it.
5. Otherwise select the highest-priority incomplete batch.
6. Implement.
7. Verify.
8. Repair until verified or a real blocker is proven.
9. If verified and the final acceptance gate is still unmet, immediately select the next batch and continue.
10. Stop only for final completion, proven blocker, or platform/context/tool handoff.
