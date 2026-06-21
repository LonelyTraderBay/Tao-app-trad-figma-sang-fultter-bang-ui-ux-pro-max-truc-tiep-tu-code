# VitTrade Whole-App Compact First-Viewport Root-Cause Execution Plan

Generated: 2026-06-20

Scope: whole Flutter app visual-density root-cause rollout. This is an
execution plan for future AI implementation sessions. It is not itself a
production UI change.

## 0. Purpose

Use this file when fixing the recurring empty-space problem seen on Open Arena
and many other VitTrade screens.

The goal is not to make the app visually smaller everywhere. The goal is to
make each first viewport more useful while preserving:

- touch-safe controls,
- readable text,
- financial safety copy,
- Prediction Markets and Open Arena product boundaries,
- shared Flutter design-system primitives,
- current route and public API contracts.

## 1. Current Authoritative Baseline

Before starting any implementation batch, refresh the current numbers from
`flutter_app/`:

```powershell
dart run tool/route_coverage_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
```

Current verified baseline after the Open Arena compact pass:

| Metric | Count |
| --- | ---: |
| Real routed pages | 414 |
| Redirect aliases excluded | 3 |
| `P0_CRITICAL_DENSITY_REVIEW` | 0 |
| `P1_HIGH_DENSITY_REVIEW` | 0 |
| `P1_TOOL_VISUAL_QA` | 5 |
| `P2_MEDIUM_DENSITY_REVIEW` | 96 |
| `P3_LOW_DENSITY_REVIEW` | 144 |
| `PASS_MONITOR` | 169 |
| Non-pass rows needing tracking | 245 |

Fullscreen density baseline:

| Metric | Count |
| --- | ---: |
| `P1_fullscreen_tool_visual_qa` | 5 |
| `P2_visual_density_review` | 4 |
| `P3_followup_review` | 2 |
| `Pass_or_low_signal` | 403 |

Root-cause counts overlap because one screen can have multiple causes:

| Root cause | Current count |
| --- | ---: |
| `bottom_nav_inset_pressure` | 235 |
| `official_audit_blind_spot` | 96 |
| `shared_component_compliant_but_sparse` | 96 |
| `tokenized_fixed_height_pressure` | 58 |
| `very_high_tokenized_fixed_height_pressure` | 3 |
| `spacer_inside_cards` | 28 |
| `manual_content_density_bypass` | 18 |
| `vertical_gap_accumulation` | 9 |
| `very_high_vertical_gap_accumulation` | 3 |
| `root_top_chrome_first_viewport_cost` | 6 |
| `fullscreen_tool_manual_visual_qa` | 5 |
| `low_signal_monitor` | 3 |

Feature backlog, non-pass rows only:

| Feature | Non-pass rows |
| --- | ---: |
| p2p | 67 |
| earn | 62 |
| trade | 25 |
| launchpad | 21 |
| wallet | 14 |
| markets | 10 |
| predictions | 7 |
| profile | 6 |
| dca | 6 |
| admin | 5 |
| auth | 4 |
| cross_module | 3 |
| dev | 3 |
| discovery | 3 |
| referral | 3 |
| support | 3 |
| enterprise_states | 1 |
| notifications | 1 |
| rewards | 1 |

Open Arena is currently a reference area after its pass. Do not churn Open Arena
again unless a later audit or visual QA proves a regression.

## 2. Required Reading For Each AI Session

To save tokens, do not re-read every design document. Read only this minimum set:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. This execution plan
4. The current filtered CSV rows for the chosen batch
5. The target page/widget source and its focused test

Use these existing docs only when needed for a specific question:

- `docs/03_DESIGN_SYSTEM/VitTrade-Screen-Real-Estate-Optimization-Strategy.md`
- `docs/03_DESIGN_SYSTEM/VitTrade-Compact-First-Viewport-Density-Rollout-Report.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`
- `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`

## 3. Token-Saving AI Operating Protocol

Follow this protocol in every implementation session:

1. Work on one batch only: 1 shared primitive or 1-3 screens.
2. Never paste the whole CSV into the prompt. Filter it with PowerShell.
3. Read only the target files and focused tests.
4. Run GitNexus `impact(..., direction: "upstream")` before editing each
   function, class, method, page widget, or shared symbol.
5. Stop and report before editing if GitNexus risk is HIGH or CRITICAL.
6. Keep edits under about 5 files unless the user explicitly approves a broader
   shared refactor.
7. Prefer existing primitives: `VitPageLayout`, `VitPageContent`,
   `VitDensity.compact`, `VitContentGap.tight`, `VitCard`, `VitCtaButton`,
   `VitTabBar`, `AppSpacing`, and `AppTextStyles`.
8. Do not create a new design system.
9. Do not change routes, domain models, repository contracts, backend drafts, or
   public API while doing density work.
10. Use focused tests first, then broader checks at checkpoints.

Useful filtered commands:

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

## 4. Stop Rules

Stop the batch and report to the user when any of these happens:

- GitNexus impact risk is HIGH or CRITICAL.
- A shared primitive change would touch many unrelated product surfaces without
  a focused test strategy.
- A proposed compaction removes fee, risk, limit, security, identity, dispute,
  or confirmation copy.
- Arena copy starts using wallet, payout, profit, stake-return, P/L, casino, or
  hype language.
- Prediction Markets and Open Arena boundaries become mixed.
- A screen only passes by making text unreadable, reducing touch targets below
  safe mobile size, or hiding useful actions.
- Focused tests fail for reasons that are not understood.
- Audit numbers regress for P0/P1 regular density.

## 5. Definition Of Done

A screen or shared primitive is done only when all applicable items are true:

- First viewport shows useful content/action above bottom nav or sticky footer.
- Bottom-nav clearance is deliberate, not duplicated across local sections.
- Text remains readable at 360 px width and up.
- Controls remain touch-safe; compact controls should still preserve practical
  tap targets.
- Financial safety copy remains visible and understandable.
- Open Arena remains points-only.
- Prediction Markets retains trading/probability/PnL language separately from
  Arena points.
- Focused widget evidence covers at least one route label or semantic screen
  identifier plus one useful/actionable widget in the first viewport.
- `flutter analyze` passes for implementation checkpoints.
- Visual-density and fullscreen-density audits stay current.

Whole-program target:

- `P2_MEDIUM_DENSITY_REVIEW=0`
- `P3_LOW_DENSITY_REVIEW=0`
- `PASS_MONITOR=409`
- `P1_TOOL_VISUAL_QA=5` with emulator/widget evidence for the tool exceptions

## 6. Root-Cause Fix Recipes

Apply the matching recipe for each row. If a row has multiple causes, fix them
in this order: fullscreen exception, financial/product safety, root top chrome,
fixed height, Spacer, manual bypass, vertical gaps, bottom-nav clearance.

| Root cause | What it usually means | Correct fix | What not to do |
| --- | --- | --- | --- |
| `fullscreen_tool_manual_visual_qa` | The route is a tool workspace. | Keep fullscreen treatment; capture emulator/widget evidence for safe area, controls, and nonblank render. | Do not compact it like a content page. |
| `root_top_chrome_first_viewport_cost` | Header/hero/search stack consumes too much first viewport. | Reduce top-stack cost while preserving navigation and semantics. | Do not remove navigation or screen identity. |
| `tokenized_fixed_height_pressure` | Tokens such as card/tile/chart heights are too tall for content. | Reduce the relevant token or local extent after impact analysis; use compact density and realistic content lines. | Do not replace tokens with random raw numbers. |
| `very_high_tokenized_fixed_height_pressure` | The same fixed-height issue is severe or repeated. | Treat as priority P2; isolate the exact token(s) and add focused tests before broad rollout. | Do not bundle with unrelated UI refactors. |
| `spacer_inside_cards` | `Spacer()` or expansion is creating empty lower card area. | Replace with fixed small gaps, start-aligned columns, or compact row layout. | Do not keep fixed height plus Spacer. |
| `manual_content_density_bypass` | Page uses local body rhythm instead of shared primitives. | Migrate body rhythm to `VitPageContent` compact/tight and shared cards where valid. | Do not create another local wrapper. |
| `vertical_gap_accumulation` | Too many stacked `SizedBox` gaps or section handoffs. | Collapse adjacent gaps, group related sections, use `VitContentGap.tight`. | Do not globally delete all spacing. |
| `very_high_vertical_gap_accumulation` | The same gap issue is severe. | Fix section handoff and repeated child gaps first; then retest. | Do not shrink typography as a shortcut. |
| `bottom_nav_inset_pressure` | Bottom padding/inset is duplicated or too expensive. | Ensure only the scroll end or sticky footer owns bottom clearance; visible content must clear nav. | Do not hide content under the bottom nav. |
| `shared_component_compliant_but_sparse` | Screen uses shared components but still wastes first viewport. | Tune density, row height, card extent, and first-section ordering. | Do not abandon shared components. |
| `official_audit_blind_spot` | Static audit previously missed a sparse rendered first viewport. | Add widget/emulator evidence and first-viewport assertions. | Do not trust old pass claims without current evidence. |
| `low_signal_monitor` | Static signal is weak. | Monitor when touched; do not churn proactively unless QA confirms waste. | Do not spend a session on low-signal rows first. |

## 7. Implementation Order

### Phase 0 - Audit Sync And Queue Selection

Description: Refresh audit state and select one small batch.

Steps:

1. Run the three audit checks from Section 1.
2. Confirm route count remains `414`.
3. Generate the next queue with the filtered commands in Section 3.
4. Pick only one of these batch types:
   - one shared primitive,
   - one feature cluster of 1-3 P2 screens,
   - one root-cause cluster of 1-3 screens.

Acceptance criteria:

- Current audit totals are known.
- Batch scope is no larger than 1-3 screens or one shared symbol.
- The user can see what will be touched.

Verification:

```powershell
git status --short
dart run tool/visual_density_risk_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
```

### Phase 1 - Shared Foundation Guardrails

Description: Fix the source of repeated looseness only when the impact is
bounded and testable. This phase is high leverage but must be conservative.

Candidate symbols:

- `VitDensityMetrics` in `flutter_app/lib/app/theme/app_density.dart`
- `VitPageContent` in `flutter_app/lib/shared/layout/vit_page_content.dart`
- `VitPageLayout` in `flutter_app/lib/shared/layout/vit_page_layout.dart`
- `VitCard` in `flutter_app/lib/shared/widgets/vit_card.dart`
- feature-specific spacing tokens in `flutter_app/lib/app/theme/app_spacing.dart`

Steps:

1. Run GitNexus impact on the target shared symbol.
2. If risk is HIGH/CRITICAL, stop and ask for approval before editing.
3. Prefer adding or using existing compact density semantics over changing the
   default for every screen.
4. Add or update focused tests for at least two representative consumers when
   a shared primitive changes.
5. Run focused tests for those consumers before any whole-app checks.

Acceptance criteria:

- Shared changes are explicit, small, and density-scoped.
- No global typography shrink occurs.
- No financial or product-boundary copy changes.

Verification:

```powershell
dart format --output=none --set-exit-if-changed <touched Dart files>
flutter test <focused test files> --reporter=compact
flutter analyze
dart run tool/visual_density_risk_audit.dart --check
```

### Phase 2 - Fixed-Height Token Cleanup

Description: Remove empty lower card/tile areas caused by tall tokenized
heights, like the Open Arena template fix.

Priority:

1. `very_high_tokenized_fixed_height_pressure`
2. `tokenized_fixed_height_pressure` with P2 score >= 33
3. repeated feature tokens used by multiple P2 rows

Steps:

1. Filter rows by tokenized root cause.
2. For each chosen screen, inspect the token source in `AppSpacing` or the page.
3. Run GitNexus impact on the token or page widget.
4. Compare actual content height against the fixed extent.
5. Reduce the extent only to the smallest readable/touch-safe value.
6. If the tile has dynamic text, cap lines and use ellipsis.
7. Add first-viewport test assertions for card height and next useful section.

Acceptance criteria:

- Card/tile bottom void is visibly reduced.
- Content remains readable and not clipped.
- First useful section/action moves up.

Verification:

```powershell
flutter test <feature focused test> --reporter=compact
dart run tool/visual_density_risk_audit.dart --check
```

### Phase 3 - Spacer-Inside-Card Cleanup

Description: Remove layout expansion inside fixed-height cards.

Priority:

1. P2 rows with `spacer_inside_cards`
2. screens where cards visibly have large blank lower areas
3. shared widgets reused by multiple rows

Steps:

1. Filter rows matching `spacer_inside_cards`.
2. Inspect card body columns for `Spacer()`, `Expanded`, or loose `Flexible`.
3. Run GitNexus impact on the widget.
4. Replace expansion with small fixed gaps or start-aligned content.
5. Keep CTA/status rows visible when they are the useful first-viewport content.
6. Add a test asserting the next section/action is above bottom-nav clearance.

Acceptance criteria:

- No `Spacer()` remains inside the targeted fixed-height card.
- The card does not grow just to fill empty space.
- The first viewport contains more useful content without crowding.

Verification:

```powershell
rg "Spacer\\(" <touched files>
flutter test <focused test files> --reporter=compact
flutter analyze
```

### Phase 4 - Manual Content Density Migration

Description: Move local body rhythm back to shared compact primitives where
valid.

Priority:

1. P2 rows with `manual_content_density_bypass`
2. pages using local `SingleChildScrollView` plus repeated manual padding/gaps
3. utility/detail pages that should look like the rest of the app

Steps:

1. Filter rows matching `manual_content_density_bypass`.
2. Inspect the local scaffold/body composition.
3. Run GitNexus impact on the page widget.
4. Replace local rhythm with `VitPageContent(density: VitDensity.compact)` or
   `VitContentGap.tight` when the page is a root/list/action surface.
5. Keep `standard` density for content that needs careful reading.
6. Add first-viewport evidence.

Acceptance criteria:

- The page uses shared content rhythm where appropriate.
- First viewport shows the expected useful/actionable widget.
- No one-off local density wrapper is introduced.

Verification:

```powershell
flutter test <focused test files> --reporter=compact
flutter analyze
dart run tool/visual_density_risk_audit.dart --check
```

### Phase 5 - Bottom-Nav Clearance Standardization

Description: Reduce duplicated bottom clearance while keeping content/actions
safe above navigation.

Priority:

1. P2 rows where `bottom_nav_inset_pressure` combines with another real cause
2. pages with sticky footers or bottom CTAs
3. pages where the first useful row is partly hidden by bottom nav

Steps:

1. Filter rows matching `bottom_nav_inset_pressure`.
2. Inspect where bottom padding is applied.
3. Run GitNexus impact on the page/widget or shared layout symbol.
4. Ensure only the scroll end, sticky footer, or shell owns bottom clearance.
5. Remove duplicated local bottom padding only when visual safety remains.
6. Add a first-viewport or bottom-nav clearance assertion.

Acceptance criteria:

- Useful content/action is visible above bottom nav.
- There is no duplicated local and shell bottom padding.
- Sticky actions remain reachable and readable.

Verification:

```powershell
flutter test <focused test files> --reporter=compact
dart run tool/ui_fullscreen_density_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
```

### Phase 6 - Feature Rollout Queue

Description: Process remaining feature backlogs in P2-first order.

Use this feature order unless the user asks for a specific module:

1. P2P: 29 P2 rows, 67 non-pass rows total
2. Earn: 17 P2 rows, 62 non-pass rows total
3. Launchpad: 16 P2 rows, 21 non-pass rows total
4. Trade content pages: 10 P2 rows, 25 non-pass rows total
5. Markets/lists: 6 P2 rows, 10 non-pass rows total
6. DCA: 4 P2 rows, 6 non-pass rows total
7. Wallet: 3 P2 rows, 14 non-pass rows total
8. Cross-module, predictions, support: 2 P2 rows each
9. Admin, auth, discovery, referral, rewards: 1 P2 row each
10. P3 rows only when touched or when visual QA proves waste

Per-feature steps:

1. Filter the feature queue.
2. Pick the highest-score 1-3 P2 rows.
3. Apply the root-cause recipes.
4. Run focused tests for the feature.
5. Run audits.
6. Record moved counts in the final response.

Acceptance criteria:

- P2 count decreases or a justified static false positive is documented.
- No P0/P1 regular density rows are introduced.
- Feature tests pass.

Verification:

```powershell
flutter test test/features/<feature> --reporter=compact
flutter analyze
dart run tool/visual_density_risk_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
```

### Phase 7 - Fullscreen Tool Evidence

Description: Keep tool screens as tool screens and verify them visually.

Tool exception rows:

| Feature | Route | Page |
| --- | --- | --- |
| trade | `/trade/:pairId/futures` | `FuturesPage` |
| trade | `AppRoutePaths.tradeBots` | `TradingBotsPage` |
| trade | `/trade/advanced-chart/:pairId` | `AdvancedChartPage` |
| enterprise_states | `AppRoutePaths.enterpriseStates` | `EnterpriseStatesPage` |
| p2p | `/p2p/chat/:orderId` | `P2PChatPage` |

Steps:

1. Do not compact the tool like a normal content page.
2. Run focused widget tests if available.
3. Run emulator screenshot QA.
4. Verify safe areas, control reachability, nonblank tool workspace, and bottom
   controls.
5. Document evidence instead of forcing `PASS_MONITOR`.

Acceptance criteria:

- Tool workspace is intentionally dense and usable.
- There is no obvious blank workspace caused by layout mistakes.
- Screenshot evidence exists for future comparison.

## 8. Batch Template For Future AI Sessions

Use this exact outline in future implementation prompts or final reports:

```markdown
## Batch Scope
- Feature:
- Routes/pages:
- Root causes:
- Files likely touched:

## Pre-Edit Checks
- [ ] Current audit totals captured
- [ ] Git status checked
- [ ] GitNexus impact run for each target symbol
- [ ] HIGH/CRITICAL risk absent or user approved

## Implementation Steps
1. ...
2. ...
3. ...

## Focused Verification
- [ ] dart format on touched files
- [ ] focused widget tests
- [ ] flutter analyze if shared or broad
- [ ] visual density audit
- [ ] fullscreen density audit when relevant

## Results To Report
- Before priority/score:
- After priority/score:
- P2/P3/PASS delta:
- Tests run:
- Known residual risk:
```

## 9. Test Strategy

Use `test/helpers/first_viewport_test_utils.dart` when possible.

Each touched screen test should prove:

- route semantic label or screen identity is present,
- at least one useful/actionable widget is in the usable first viewport,
- relevant bottom-nav or sticky-footer clearance is safe,
- no financial-boundary copy regression occurs,
- Arena remains points-only when Arena code is touched.

Preferred focused test order:

```powershell
flutter test test/features/<feature>/<target_test>.dart --reporter=compact
flutter test test/features/<feature> --reporter=compact
flutter analyze
```

Run full `flutter test --reporter=compact` only after shared primitive changes,
router/shell changes, or several feature batches.

## 10. Commit/Review Hygiene

Before commit or handoff:

1. Run GitNexus `detect_changes()` per `AGENTS.md`.
2. Confirm changed files match the selected batch.
3. Do not revert unrelated dirty worktree changes.
4. Do not include generated logs, `build/`, `.dart_tool/`, `flutter_app/tmp/`,
   or `flutter_app/run-artifacts/`.
5. Summarize exact verification commands and audit deltas.

## 11. Human Approval Gates

Ask the user before proceeding when:

- a shared primitive change affects many unrelated modules,
- a financial confirmation screen needs copy/layout tradeoffs,
- a tool screen appears wasteful but compaction may reduce workspace quality,
- a P3 row would require broad churn,
- Open Arena or Prediction Markets boundary wording would change,
- the batch cannot be kept under the 1-3 screen guidance.

## 12. Completion Tracking

At the end of every batch, update the working notes or final response with:

- current `P2`, `P3`, and `PASS_MONITOR` counts,
- routes moved from P2/P3 to PASS,
- routes still flagged and why,
- tests run,
- emulator screenshot evidence when used,
- next recommended batch.

This keeps future AI sessions short: they can start from current audit numbers,
select the next filtered queue, and continue without rebuilding the whole mental
model.
