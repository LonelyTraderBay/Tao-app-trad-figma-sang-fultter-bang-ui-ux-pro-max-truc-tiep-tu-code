# AI A-Grade Body Component Upgrade Autonomous Execution Prompt

Use this prompt when an AI coding agent must execute the A-grade body component upgrade plan for VitTrade without stopping after a single batch. The agent must work step by step until the plan is complete, a real blocker is proven, or the environment forces a handoff.

## Mission

You are working inside the VitTrade Flutter enterprise mono-repo.

Your mission is to execute:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-A-Grade-Body-Component-Upgrade-Plan.md
```

until every standard routed screen reaches Grade A under the body component consistency audit.

The target product standard is:

```text
Flutter enterprise-grade
Dark professional
Crypto exchange / trading super-app
Phone-first
Financially safe
Shared component driven
Consistent body UI/UX across every feature
```

Do not treat this as an analysis-only task. You must inspect code, edit code, run audits/tests, update the plan, and continue to the next batch automatically.

## Non-Stop Execution Contract

Continue working automatically through the plan in order.

You must not stop after:

- Completing one feature.
- Completing one batch.
- Fixing only the easiest pages.
- Producing only recommendations.
- Running only the audit.
- Creating only documentation.
- Asking the user what to do next when the plan already defines the next step.

You may stop only when one of these is true:

1. Final acceptance gates are all passed.
2. A real blocker prevents progress after at least 3 concrete attempts.
3. The runtime, token, or context limit forces a handoff.
4. The user explicitly asks you to stop or change direction.

If you must hand off because of limits, your final line must be exactly:

```text
RESUME FROM: <phase> - <feature/batch/page group>
```

Do not write anything after that line.

If the work is complete, include this exact completion line:

```text
A-GRADE BODY COMPONENT UPGRADE COMPLETE
```

## Final Acceptance Gates

The work is not complete until all gates below are true.

### Gate 1 - Body Grade Target

Run the body component consistency audit and confirm:

```text
total_routed_screens = 414
grade_A = 409
grade_B = 0
grade_C = 0
grade_D = 0
grade_Tool = 5
P0 = 0
P1 = 0
```

Tool pages may remain `Tool`. All non-tool routed screens must be `A`.

### Gate 2 - No Body Warnings Or Fails

Every standard screen must have:

```text
warning_count = 0
fail_count = 0
shared_component_count >= 5
custom_body_count <= 35
```

No standard screen may retain:

- `layout_status`
- `surface_status`
- `state_status`
- `controls_status`
- `financial_safety_status`
- `high_custom_body_count`
- `partial_shared_body_layout`
- `surface_consistency_needs_review`
- `state_coverage_needs_review`
- `financial_safety_needs_manual_review`

### Gate 3 - Header And Navigation Still Clean

Header and navigation quality must not regress:

```text
strict_visual_issues = 0
screen_level_mismatches = 0
route_coverage_issues = 0
back_navigation_behavior_issues = 0
home_entry_back_navigation_issues = 0
```

### Gate 4 - Financial And Product Boundaries Preserved

All high-risk financial flows must still include preview, fees, risk, limits, confirmation, submitting, success/error/offline states where relevant.

Arena must remain points-only. Do not introduce wallet, profit, payout, or stake-return language into Arena.

Prediction Markets and Open Arena must remain separate product surfaces.

### Gate 5 - Verification Passes

Before declaring completion, run:

```powershell
cd flutter_app
flutter analyze
flutter test --reporter=compact
```

Both must pass.

## Required Context To Read First

Before making edits, read these files:

```text
AGENTS.md
docs/00_START_HERE.md
docs/02_FLUTTER_MIGRATION/VitTrade-A-Grade-Body-Component-Upgrade-Plan.md
docs/02_FLUTTER_MIGRATION/AI-Enterprise-UI-UX-Synchronization-Autonomous-Execution-Prompt.md
```

Then inspect the current audit scripts and artifacts:

```text
flutter_app/tool/body_component_consistency_audit.dart
flutter_app/tool/top_header_visual_archetype_audit.dart
flutter_app/tool/route_coverage_audit.dart
flutter_app/run-artifacts/body_component_consistency_audit/
flutter_app/run-artifacts/top_header_visual_archetype_audit/
```

If artifact paths differ, locate them with `rg --files flutter_app/run-artifacts`.

## Source Of Truth

Use this repo structure:

```text
flutter_app/lib/app/
flutter_app/lib/core/
flutter_app/lib/features/<feature>/
flutter_app/lib/shared/
flutter_app/test/
```

Screen widgets belong under:

```text
flutter_app/lib/features/<feature>/presentation/pages/
```

Shared UI belongs under:

```text
flutter_app/lib/shared/
```

Use package imports:

```dart
package:vit_trade_flutter/...
```

Do not recreate obsolete root web tooling. Do not depend on old React/Vite/Tailwind baselines.

## Mandatory Preflight

Run these commands before selecting the first batch:

```powershell
git status --short
cd flutter_app
dart run tool\body_component_consistency_audit.dart
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
```

Then extract the current B inventory from the body audit artifact.

Record:

- Grade counts.
- B pages grouped by feature.
- Warning types by page.
- Pages with `custom_body_count > 35`.
- Pages with `shared_component_count < 5`.
- High-risk financial pages.

Use this known baseline from the plan if the artifact still matches:

```text
total_routed_screens = 414
grade_A = 105
grade_B = 304
grade_C = 0
grade_D = 0
grade_Tool = 5
P0 = 0
P1 = 0
```

Known B inventory:

```text
trade = 81
p2p = 74
earn = 31
wallet = 21
markets = 20
launchpad = 14
predictions = 12
arena = 12
profile = 11
dca = 9
auth = 6
referral = 5
discovery = 3
admin = 1
cross_module = 1
dev = 1
home = 1
support = 1
```

Known primary issue distribution:

```text
surface_consistency_needs_review = 142
partial_shared_body_layout = 97
none = 36
state_coverage_needs_review = 23
financial_safety_needs_manual_review = 6
```

Use current audit output over these numbers if the repo has changed.

## Batch Selection Order

Always choose the next batch by risk and audit impact.

### Phase 1 - Remove Explicit Warnings

Fix pages with warning/fail statuses before working on only score-based B pages.

Order:

1. `financial_safety_status`
2. `controls_status`
3. `state_status`
4. `layout_status`
5. `surface_status`

Feature priority inside each warning type:

```text
p2p
trade
wallet
earn
markets
launchpad
predictions
arena
profile
dca
auth
referral
discovery
admin/cross_module/dev/home/support
```

### Phase 2 - Reduce High Custom Body Count

After warnings are removed, fix pages that still fail A because `custom_body_count > 35`.

Order:

1. `custom_body_count >= 70`
2. `custom_body_count 50-69`
3. `custom_body_count 36-49`

Prioritize dashboards, high-frequency trading screens, wallet flows, and P2P flows first.

### Phase 3 - Increase Shared Component Count

After custom count is controlled, fix pages still below:

```text
shared_component_count >= 5
```

Use real shared primitives, not artificial component insertion.

### Phase 4 - Feature Completion Sweep

After warning, custom-count, and shared-count batches are mostly clear, sweep each feature until no B remains.

Feature sweep order:

1. P2P
2. Trade
3. Wallet
4. Earn
5. Markets
6. Launchpad
7. Predictions
8. Arena
9. Profile
10. DCA
11. Auth
12. Referral
13. Discovery
14. Admin / cross-module / dev / home / support

Do not move to Profile before completing Wallet, unless the current audit proves Wallet already has no B pages.

## Autonomous Execution Loop

Repeat this loop until final acceptance is reached.

### Step 1 - Select Batch

Choose a concrete page group using the batch selection order.

Keep each batch small enough to verify cleanly:

```text
3-8 related pages
or 1-3 complex financial/trading pages
or 1 shared primitive plus its direct consumers
```

Do not batch unrelated features together.

### Step 2 - Inspect Code

For every selected page, inspect:

- Page file.
- Local widgets.
- Shared components already used.
- Theme tokens.
- Controller/provider state.
- Existing tests.
- Audit warning reason.

Use `rg` first for search.

### Step 3 - Classify The Upgrade Pattern

Assign one or more patterns:

```text
A1 layout primitive adoption
A2 surface consistency
A3 state coverage
A4 financial safety UI
A5 controls/input normalization
A6 custom body count reduction
A7 shared component count increase
```

### Step 4 - Implement

Make narrowly scoped edits.

Use shared layout primitives first:

```text
VitAppShell
VitPageLayout
VitPageContent
VitHeader
VitBottomNav
VitCard
VitCtaButton
VitInput
VitTabBar
```

Use theme tokens from:

```text
flutter_app/lib/app/theme/
```

Prefer existing shared widgets over new abstractions.

Only add a new shared component when:

- At least 2-3 pages need the same pattern, or
- The pattern is an enterprise body primitive, or
- It removes real repeated custom body code.

Do not add decorative wrapper layers just to satisfy the audit.

### Step 5 - Format

Format touched Dart files:

```powershell
cd flutter_app
dart format <touched files>
```

Use `dart format .` only when the touched surface is broad.

### Step 6 - Audit The Batch

Run:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
```

Confirm selected pages improved.

If a page remains B, inspect the exact remaining reason and fix it before moving on unless it belongs to a later planned pattern.

### Step 7 - Focused Verification

Run focused tests for touched features.

Examples:

```powershell
cd flutter_app
flutter test test/features/wallet --reporter=compact
flutter test test/features/p2p --reporter=compact
flutter test test/features/trade --reporter=compact
```

If the touched files affect shared layout, router, theme, or app shell, also run:

```powershell
flutter analyze
```

### Step 8 - Update The Plan

Update:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-A-Grade-Body-Component-Upgrade-Plan.md
```

Record:

- Batch ID.
- Pages touched.
- Before grade.
- After grade.
- Remaining issue, if any.
- Commands run.
- Next batch.

### Step 9 - Continue

Return to Step 1 automatically.

Do not wait for user confirmation unless a true blocker exists.

## A-Grade Upgrade Patterns

### A1 - Layout Primitive Adoption

Use when audit reports:

```text
partial_shared_body_layout
layout_status
```

Expected actions:

- Wrap body in `VitPageLayout` / `VitPageContent` where the page pattern supports it.
- Keep header and shell ownership unchanged.
- Normalize padding, section spacing, scroll behavior, and safe-area behavior.
- Remove local scaffold-like body containers where shared layout already exists.
- Avoid nested card-in-card layouts.

Do not replace a specialized trading canvas or chart surface with a generic card if that would reduce usability.

### A2 - Surface Consistency

Use when audit reports:

```text
surface_consistency_needs_review
surface_status
```

Expected actions:

- Replace repeated custom panels with `VitCard` or established shared surface widgets.
- Use consistent background, border, radius, divider, and elevation tokens.
- Normalize list rows, metric panels, sections, empty panels, and action strips.
- Keep high-density trading surfaces compact and scan-friendly.

### A3 - State Coverage

Use when audit reports:

```text
state_coverage_needs_review
state_status
```

Expected actions:

- Add real loading state.
- Add real empty state.
- Add real error state.
- Add real offline/unavailable state where relevant.
- Add submitting/progress state where an action is asynchronous.
- Add success/confirmation state where the workflow needs feedback.

Do not add fake unreachable states. Wire states to existing controller/provider data where possible.

### A4 - Financial Safety UI

Use when audit reports:

```text
financial_safety_needs_manual_review
financial_safety_status
```

Expected actions:

- Add preview before confirmation.
- Show fees, limits, risk, network, settlement, lockup, or next steps where applicable.
- Mask sensitive account, address, wallet, email, and phone data.
- Require explicit confirmation for withdrawals, escrow release, address additions, security changes, and P2P payment-method changes.
- Preserve existing business logic.

Do not use casino/hype language. Do not weaken guardrails.

### A5 - Controls/Input Normalization

Use when audit reports:

```text
controls_status
```

Expected actions:

- Replace custom text fields with `VitInput` where compatible.
- Replace custom CTAs with `VitCtaButton` where compatible.
- Use toggles/checkboxes/segmented controls for binary or mode settings.
- Use tabs for view switching.
- Use icons in tool buttons where the design system already supports them.
- Keep hit areas phone-safe.

### A6 - Custom Body Count Reduction

Use when a page is B only because `custom_body_count > 35`.

Inspect and reduce repeated raw Flutter body constructs:

```text
Container(
DecoratedBox(
GestureDetector(
InkWell(
TextField(
CustomPaint(
Stack(
Positioned(
SizedBox(height:
Padding(
BorderRadius.circular(
fontSize:
fontFamily:
```

Preferred reductions:

- Move repeated metric rows into existing shared metric/list components.
- Replace custom cards with `VitCard`.
- Replace repeated section wrappers with shared section components.
- Replace repeated CTA/input code with shared buttons/inputs.
- Use theme tokens instead of inline color/spacing/radius/font values.

Do not hide raw widget usage in a private local helper if the screen remains visually inconsistent.

### A7 - Shared Component Count Increase

Use when a page is B because `shared_component_count < 5`.

Expected actions:

- Use shared primitives that genuinely express the page structure.
- Use `VitPageLayout`, `VitPageContent`, `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`, shared state/empty/error widgets, shared list rows, or shared metric widgets where appropriate.
- Prefer shared primitives already used in neighboring A pages.

Do not add invisible or semantically pointless shared components.

## Feature-Specific Guidance

### P2P

P2P screens must feel like operational finance tools.

Priorities:

- Clear buyer/seller role separation.
- Escrow status visible.
- Payment method safety visible.
- Dispute, release, cancel, and confirmation flows protected.
- List rows and offer cards consistent.
- Avoid wallet/profit language where the screen is only payment-method or order workflow.

High-risk pages need A4 review.

### Trade

Trade screens must remain dense, fast, and scannable.

Priorities:

- Do not over-card chart/order-book areas.
- Normalize order forms, metrics, order lists, and history rows.
- Keep buy/sell action hierarchy clear.
- Show risk, fees, margin/liquidation/position details where relevant.
- Preserve chart and trading interactivity.

Use compact shared components, not marketing-style cards.

### Wallet

Wallet screens must feel highly consistent with financial safety.

Priorities:

- Deposit, withdrawal, transfer, address book, approval, token detail, and history pages must share body structure.
- Address and account data must be masked where appropriate.
- Deposit/withdrawal must show network, fee, limits, time, risk, confirmation, and next steps.
- Approval and transfer flows must have clear preview and confirmation states.

Wallet pages are high priority and should be completed before Profile.

### Earn

Earn screens must clearly show product terms.

Priorities:

- APR/APY, lockup, redemption, risk, expected timing, and terms visible.
- Product cards and portfolio rows consistent.
- Subscribe/redeem flows must preview and confirm.
- Avoid promotional-only hierarchy.

### Markets

Markets screens must support scanning and comparison.

Priorities:

- Token rows, watchlists, movers, filters, and sort controls consistent.
- Empty and loading states present.
- Price movement indicators consistent with theme.
- Avoid overusing large cards where dense rows are expected.

### Launchpad

Launchpad screens must communicate eligibility, allocation, timeline, and risk.

Priorities:

- Campaign cards consistent.
- Detail pages show phases, requirements, limits, dates, and confirmation.
- Participation flows use preview and success states.

### Predictions

Prediction Markets must stay separate from Arena.

Priorities:

- Use trading language: positions, probability, receipt, rewards, P/L.
- Show market status, settlement, risk, and receipts.
- Keep order/position/history cards consistent.
- Avoid casino language.

### Arena

Arena must remain points-only.

Priorities:

- Use points, pool, completion, leaderboard, and fair-play language.
- Never use payout, wallet, profit, or stake-return language.
- Event cards, challenge rows, and leaderboards consistent.
- Completion and result states clear.

### Profile

Profile should be completed after Wallet unless Profile has blocking shared primitives needed earlier.

Priorities:

- Security, identity, preferences, referrals, and settings surfaces consistent.
- Sensitive data masked.
- Security changes previewed/confirmed.
- List rows and setting controls normalized.

## Editing Rules

Use the existing codebase style.

Do not revert user changes.

Do not run destructive Git commands.

Use shared primitives and theme tokens.

Keep edits scoped to the selected batch.

Do not introduce unrelated refactors.

Do not add root web tooling.

Do not create visual styles that conflict with the dark professional exchange baseline.

Do not degrade 360 px phone layout.

## Documentation Rules

After every completed batch, update the A-grade plan file with a short factual entry.

Use this format:

```markdown
### <Batch ID> - <Feature/Page Group>

- Scope: <pages>
- Before: <grades/warnings>
- Changes: <brief>
- After: <grades/warnings>
- Verification: <commands>
- Remaining: <none or exact next issue>
```

Keep the plan useful as a live tracker. Do not rewrite the entire document after every small batch.

## Verification Commands

Use these commands during execution.

### Body Audit

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
```

### Header Strict Audit

```powershell
cd flutter_app
dart run tool\top_header_visual_archetype_audit.dart --check --strict
```

### Route Coverage

```powershell
cd flutter_app
dart run tool\route_coverage_audit.dart --check
```

### Navigation Audits

Run these if the repo has the scripts:

```powershell
cd flutter_app
dart run tool\top_header_action_audit.dart
dart run tool\top_header_global_access_policy_audit.dart
dart run tool\back_navigation_behavior_audit.dart
dart run tool\home_entry_back_navigation_audit.dart
```

If a script name differs, locate it with:

```powershell
rg --files tool | rg "header|navigation|back|route|audit"
```

### Focused Tests

Run feature tests for touched modules:

```powershell
cd flutter_app
flutter test test/features/<feature> --reporter=compact
```

If there is no feature test directory, run the nearest page/widget/controller test. If no focused test exists, note the gap and run `flutter analyze`.

### Full Verification

Before final completion:

```powershell
cd flutter_app
flutter analyze
flutter test --reporter=compact
```

## Failure Handling

If a command fails:

1. Read the failure.
2. Identify whether it is caused by your changes.
3. Fix it if it is related.
4. Re-run the failed command.
5. Continue.

Do not declare completion with failing analyze, failing tests, stale audit artifacts, or remaining B pages.

If an unrelated pre-existing failure blocks full verification:

- Prove it is unrelated with focused commands or git diff.
- Record it in the plan.
- Continue with all possible scoped verification.
- Do not claim full completion unless final acceptance gates are met.

## Final Report Requirements

When all acceptance gates pass, provide a concise final report containing:

- Final body grade counts.
- Features upgraded.
- Audit commands passed.
- Analyze/test result.
- Any residual non-blocking notes.
- Exact completion line:

```text
A-GRADE BODY COMPONENT UPGRADE COMPLETE
```

If handoff is required before completion, provide:

- What was completed.
- Current body grade counts.
- Current failing/warning categories.
- Exact next batch.
- Commands last run.
- Final line exactly:

```text
RESUME FROM: <phase> - <feature/batch/page group>
```

Do not write anything after the `RESUME FROM` line.
