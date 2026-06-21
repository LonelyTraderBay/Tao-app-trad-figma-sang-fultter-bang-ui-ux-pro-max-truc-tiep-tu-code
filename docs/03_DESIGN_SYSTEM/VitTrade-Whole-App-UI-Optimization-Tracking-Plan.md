# VitTrade Whole-App UI Optimization Tracking Plan

**Created:** 2026-06-19  
**Scope:** 414 routed Flutter screens across 23 features  
**Status:** Audit-backed progress is `complete`. Phase 0-4 regular
P0/P1 cleanup is complete; stale generated audit artifacts, analyzer warning,
known 360x800 responsive overflows, tool QA evidence, and P2/P3 assignment are
complete. Final broad audits, `flutter analyze`, and `flutter test` pass.
**Primary objective:** Optimize phone screen real estate and first-viewport
density across the whole project while preserving Flutter Enterprise-Grade
quality, financial safety, accessibility, and shared-component consistency.

## 0. How To Use This Plan

This file is the execution tracker for the next UI optimization pass.

It does not replace the shared-component adoption plan. The existing shared
component plan is complete for structural adoption. This plan adds the missing
quality gate: **first-viewport density and screen real estate optimization**.

Use this plan together with the full 414-screen matrix:

```text
flutter_app/run-artifacts/visual-density/whole_app_visual_density_root_cause_matrix.csv
```

The maintained official audit artifact is now:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md
```

The CSV is the complete current screen-level ledger. This Markdown file is the
human tracking plan: phases, priorities, acceptance criteria, and verification
gates.

Status legend:

| Status | Meaning |
| --- | --- |
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Complete |
| `[!]` | Blocked or needs decision |

## 0A. Reality Check - 2026-06-20

This section records the actual repo state checked on 2026-06-20. It overrides
older progress wording below when there is a conflict.

### 0A.1 Completion Estimate

**Overall implementation estimate:** `100% complete`.

This is a weighted execution estimate, not a raw checkbox count. The critical
screen-density work is much further along than the final release gate.

| Area | Weight | Actual status | Earned |
| --- | ---: | --- | ---: |
| Phase 0-2 governance, shared density foundation, reference slice | 35% | Complete and backed by files/tests listed below. | 35% |
| Phase 3 critical trade/markets/predictions P0/P1 cleanup | 20% | Regular P0/P1 count is now zero; trade tool routes have Android/widget QA evidence. | 20% |
| Phase 4 wallet/arena/DCA/launchpad/P2P/earn P0/P1 cleanup | 20% | Regular P0/P1 count is now zero; P2P/enterprise tool evidence is captured. | 20% |
| Phase 5 P2/P3 sweep and reference protection | 15% | All 256 P2/P3 rows are assigned in the row-level monitor ledger. | 15% |
| Phase 6 final verification/release gate | 10% | Broad audits, analyze, full tests, emulator/widget evidence, and docs closeout are complete. | 10% |
| **Total** | **100%** |  | **100%** |

Alternative views:

- Critical/high regular density backlog is `100%` retired: current P0 = `0`,
  current P1 = `0`.
- Strict pass/monitor rows are `154 / 414 = 37.2%`.
- Low-risk-or-better rows are `(154 PASS + 148 P3) / 414 = 72.9%`.
- Remaining non-pass audit queues are assigned: `5` documented tool QA routes,
  `107` P2 monitor rows, and `148` P3 monitor rows.

### 0A.2 Current Audit Snapshot

Verified with:

```bash
cd flutter_app
dart run tool/visual_density_risk_audit.dart --check
```

Result:

| Priority | Screens | Reality status |
| --- | ---: | --- |
| `P0_CRITICAL_DENSITY_REVIEW` | 0 | Complete |
| `P1_HIGH_DENSITY_REVIEW` | 0 | Complete |
| `P1_TOOL_VISUAL_QA` | 5 | Documented Android/widget QA evidence |
| `P2_MEDIUM_DENSITY_REVIEW` | 107 | Assigned in P2/P3 monitor ledger |
| `P3_LOW_DENSITY_REVIEW` | 148 | Assigned in P2/P3 monitor ledger |
| `PASS_MONITOR` | 154 | Current reference/pass queue |

Documented tool QA routes:

| Feature | Route | Page | Current score |
| --- | --- | --- | ---: |
| `trade` | `'/trade/:pairId/futures'` | `FuturesPage` | 104 |
| `trade` | `AppRoutePaths.tradeBots` | `TradingBotsPage` | 66 |
| `trade` | `'/trade/advanced-chart/:pairId'` | `AdvancedChartPage` | 42 |
| `enterprise_states` | `AppRoutePaths.enterpriseStates` | `EnterpriseStatesPage` | 31 |
| `p2p` | `'/p2p/chat/:orderId'` | `P2PChatPage` | 30 |

Highest remaining P2 rows by current score:

| Feature | Route | Page | Score |
| --- | --- | --- | ---: |
| `earn` | `AppRoutePaths.earnRegulatoryFramework` | `StakingRegulatoryFrameworkPage` | 38 |
| `launchpad` | `AppRoutePaths.launchpadStaking` | `LaunchpadStakingPage` | 36 |
| `p2p` | `AppRoutePaths.p2pKycAddress` | `P2PAddressProofPage` | 36 |
| `p2p` | `AppRoutePaths.p2pInsuranceScore` | `P2PInsuranceScorePage` | 36 |
| `arena` | `AppRoutePaths.arenaStudioGovernance` | `ArenaGovernanceGatePage` | 36 |
| `launchpad` | `AppRoutePaths.launchpadBridgeCompare` | `LaunchpadBridgeComparePage` | 36 |
| `launchpad` | `AppRoutePaths.launchpadLimitOrders` | `LaunchpadLimitOrdersPage` | 36 |
| `p2p` | `'/p2p/dispute/:orderId'` | `P2PDisputePage` | 35 |
| `p2p` | `AppRoutePaths.p2p` | `P2PHomePage` | 35 |
| `dca` | `AppRoutePaths.devDcaOverview` | `DCAOverviewDemo` | 35 |

### 0A.3 Verification Results

Commands run on 2026-06-20:

| Command | Result | Detail |
| --- | --- | --- |
| `dart run tool/visual_density_risk_audit.dart --check` | Pass | 414 routes, P0 `0`, P1 `0`, tool `5`, P2 `113`, P3 `150`, pass `146`. |
| `dart run tool/route_coverage_audit.dart --check` | Pass | Route coverage artifact is current. |
| `dart run tool/*audit*.dart --check` | Fail | 4 pass, 8 stale artifacts. Stale: back navigation behavior, body component consistency, design token consistency, home entry back navigation, navigation edge, top header action, top header global access policy, UI fullscreen density. |
| `dart format --output=none --set-exit-if-changed .` | Fail | Hits a missing `build/` intermediate directory; source-only check below gives the actionable signal. |
| `dart format --output=none --set-exit-if-changed lib test tool` | Fail/no diff | 140 source files would be formatted; no git diff was left by the check. |
| `flutter analyze` | Fail | 1 warning: optional parameter `height` is never provided in `profile_api_key_create_result.dart`. |
| `flutter test --reporter=compact` | Fail | `2212` passed, `6` failed. Failures are stale guardrail artifacts plus responsive overflow at 360x800. |

Follow-up on 2026-06-20:

- Regenerated stale artifacts for back navigation behavior, body component
  consistency, design token consistency, home entry back navigation,
  navigation edge, top header action, top header global access policy, and UI
  fullscreen density.
- Reran all 8 matching `--check` commands. Result: all artifacts current.
- Removed the unused `_TextInput.height` optional parameter in
  `profile_api_key_create_result.dart` while preserving
  `AppSpacing.inputHeight`. Verification passed:
  `dart format --output=none --set-exit-if-changed
  lib/features/profile/presentation/widgets/profile_api_key_create_result.dart`,
  `flutter analyze`, and
  `flutter test test/features/profile/api_key_create_page_test.dart
  --reporter=compact`.
- Fixed known 360x800 responsive overflows for Address Book, Prediction Event,
  and Arena Challenge. Also resolved the fresh ProfilePage P1 density
  regression exposed by regenerating the current visual-density audit. Current
  visual-density result: P0 `0`, P1 `0`, tool `5`, P2 `113`, P3 `143`, pass
  `153`. Verification passed: full
  `responsive_visual_qa_matrix_test.dart`, focused Address Book, Prediction
  Event, Arena Challenge, and Profile tests, `flutter analyze`, token/body
  audit checks, and `visual_density_risk_audit.dart --check`.
- Captured current Android emulator and 360x800 widget screenshot evidence for
  all 5 `P1_TOOL_VISUAL_QA` routes. Evidence is saved under
  `flutter_app/run-artifacts/whole_app_tool_visual_qa/`, with the summary in
  `flutter_app/run-artifacts/whole_app_tool_visual_qa/report.md`.
- Assigned all current P2/P3 rows to `monitor_when_touched` in
  `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`.
  Summary: 256 assigned rows, including 12 `P2-A next-batch candidate`, 26
  `P2-B medium monitor`, 75 `P2-C standard monitor`, and 143
  `P3 when-touched monitor`.
- Final release gate passed on 2026-06-20. Verification:
  all route/navigation/token/body/fullscreen/visual-density/header audit
  checks passed, `flutter analyze` reported no issues, and
  `flutter test --reporter=compact` passed with `2218` tests. `dart format
  --output=none --set-exit-if-changed .` still cannot be used as-is while the
  ignored `build/` tree contains a stale Gradle intermediate path; scoped Dart
  format on touched files passed, and source-format churn left no extra tracked
  file diffs outside the intended change set.
- GitNexus `detect_changes(scope=all)` reported risk `low`, `changed_files=24`,
  and `affected_processes=[]`.

Compact first-viewport P2-A implementation batch on 2026-06-20:

- Implemented the 12 `P2-A next-batch candidate` rows from
  `VitTrade-Compact-First-Viewport-Density-Rollout-Report.md`:
  `StakingProofOfReservesPage`, `P2PDashboardPage`, `ReferralRewardsPage`,
  `StakingRegulatoryFrameworkPage`, `LaunchpadGasTrackerPage`,
  `BotPortfolioDashboardPage`, `ArenaStudioPage`,
  `ArenaUniversalPresetLibraryPage`, `MarketMoversPage`,
  `CopyProviderDetailPage`, `PositionDashboardPage`, and `ProfilePage`.
- Added or retained focused first-viewport widget coverage for all 12 touched
  routes. The first viewport now reaches the intended useful section/action for
  each route, including reserve trend, P2P weekly volume, rewards chart, first
  license, gas chart, equity curve, arena template/domain pack, first mover
  row, copy-risk assessment CTA, first open position row, and profile product
  hub.
- Current visual-density audit after the batch:
  P0 `0`, P1 `0`, tool `5`, P2 `107`, P3 `148`, pass `154`.
- Rows moved out of P2: `P2PDashboardPage`, `ReferralRewardsPage`,
  `MarketMoversPage`, `CopyProviderDetailPage`, and `ProfilePage`.
  `BotPortfolioDashboardPage` moved to `PASS_MONITOR`.
- Rows still reported as P2 after practical compaction:
  `StakingProofOfReservesPage`, `StakingRegulatoryFrameworkPage`,
  `LaunchpadGasTrackerPage`, `ArenaStudioPage`,
  `ArenaUniversalPresetLibraryPage`, and `PositionDashboardPage`. These have
  passing first-viewport tests; remaining static signal is primarily shared
  typography line-height, tokenized tool/review surfaces, and bottom-inset
  references. Do not replace readable shared line-height tokens with raw values
  solely to lower the static score.

Responsive QA failures from the full test run:

- `Address Book` at 360x800: bottom overflow by `9.0` px.
- `Prediction Event` at 360x800: bottom overflow by `1.2` px, repeated in the
  route matrix.
- `Arena Challenge` at 360x800: right overflow by `14` px.

Full-suite guardrail failures:

- `back_navigation_behavior_guardrail_test.dart`: stale artifacts.
- `home_entry_back_navigation_guardrail_test.dart`: stale artifacts.
- `design_token_consistency_guardrail_test.dart`: stale artifacts.
- `top_header_action_guardrail_test.dart`: stale artifacts.
- `top_header_global_access_policy_guardrail_test.dart`: stale artifacts.
- `responsive_visual_qa_matrix_test.dart`: 360x800 overflows listed above.

## 1. Source Reports And Inputs

| Source | Purpose | How it is used in this plan |
| --- | --- | --- |
| `VitTrade-Screen-Real-Estate-Optimization-Strategy.md` | Defines the optimization philosophy and Enterprise-Grade screen-area standard. | Sets the target: first-viewport usefulness, not blindly smaller UI. |
| `VitTrade-Whole-App-Visual-Density-Root-Cause-Report.md` | Whole-app RCA over 414 screens. | Provides priority counts, feature summary, root-cause taxonomy. |
| `VitTrade-Visual-Density-Root-Cause-Analysis.md` | Deep Profile RCA. | Provides the minimal reproduction and viewport-budget model. |
| `VitTrade-Whole-App-Visual-Density-Real-Audit-Report.md` | Earlier real audit with emulator evidence. | Confirms official audit blind spot and Profile screenshot evidence. |
| `whole_app_visual_density_root_cause_matrix.csv` | Full screen-level route ledger. | Authoritative per-screen backlog for all 414 routes. |
| `VitTrade-Visual-Density-Risk-Audit.*` | Maintained official visual-density gate. | Current repeatable audit source for future implementation passes. |
| `VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md` | Completed Home/shared-component adoption baseline. | Confirms this optimization pass starts after shared component adoption. |

## 2. Baseline Snapshot

### 2.1 Official Structural Audit Baseline

| Metric | Current |
| --- | ---: |
| Routed screens | 414 |
| Features | 23 |
| Body grade A | 409 |
| Fullscreen Tool | 5 |
| Official density P1 | 5 |
| Official density P2 | 0 |
| Official pass / low signal | 409 |

Interpretation:

- Shared-component adoption is structurally healthy.
- The remaining issue is not "missing shared components".
- The remaining issue is that first-viewport density is not yet an enforced
  completion gate.

### 2.2 Visual Density Backlog

| Priority | Screens | Meaning |
| --- | ---: | --- |
| `P0_CRITICAL_DENSITY_REVIEW` | 19 | Highest-risk screens; refactor by archetype first. |
| `P1_HIGH_DENSITY_REVIEW` | 61 | High-risk screens; batch after P0 reference patterns. |
| `P1_TOOL_VISUAL_QA` | 5 | Fullscreen tools; manual emulator QA, not generic compaction. |
| `P2_MEDIUM_DENSITY_REVIEW` | 113 | Medium-risk screens; process after compact primitives are stable. |
| `P3_LOW_DENSITY_REVIEW` | 145 | Low-risk screens; monitor when touched. |
| `PASS_MONITOR` | 71 | Use as references and protect from unnecessary churn. |

### 2.3 Root-Cause Totals

| Root cause | Screens |
| --- | ---: |
| Official audit blind spot | 193 |
| Shared-component compliant but sparse | 193 |
| Tokenized fixed-height pressure | 133 |
| Vertical gap accumulation | 67 |
| Spacer-driven looseness | 59 |
| Manual content density bypass | 39 |
| Bottom-nav inset pressure | 380 |
| Root top chrome first-viewport cost | 11 |

### 2.4 Feature-Level Backlog

| Feature | Screens | Avg risk | Max | P0 | P1 | Tool | P2 | P3 | Pass | Execution band |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `trade` | 91 | 32.3 | 104 | 12 | 23 | 3 | 12 | 15 | 26 | Critical |
| `predictions` | 19 | 20.9 | 56 | 0 | 4 | 0 | 2 | 13 | 0 | Critical |
| `profile` | 14 | 8.4 | 31 | 0 | 0 | 0 | 1 | 1 | 12 | Critical reference |
| `markets` | 22 | 43.0 | 84 | 7 | 3 | 0 | 7 | 3 | 2 | Critical |
| `wallet` | 21 | 35.1 | 59 | 0 | 11 | 0 | 3 | 4 | 3 | High, financial safety |
| `arena` | 26 | 25.2 | 56 | 0 | 5 | 0 | 11 | 4 | 6 | High, domain boundary |
| `dca` | 14 | 17.5 | 43 | 0 | 1 | 0 | 4 | 3 | 6 | Medium/high |
| `launchpad` | 24 | 29.0 | 47 | 0 | 2 | 0 | 16 | 5 | 1 | Medium, financial safety |
| `p2p` | 77 | 23.5 | 45 | 0 | 3 | 1 | 30 | 36 | 7 | Broad medium |
| `earn` | 70 | 23.1 | 53 | 0 | 7 | 0 | 17 | 45 | 1 | Broad low/medium |
| Lower-risk modules | 36 | 22.1 | 52 | 0 | 2 | 0 | 10 | 16 | 7 | Monitor by matrix |

Lower-risk modules include `news`, `home`, `enterprise_states`, `support`,
`referral`, `rewards`, `cross_module`, `discovery`, `notifications`, `admin`,
`auth`, `dev`, and `onboarding`. They are still covered by the matrix and must
not be skipped.

### 2.5 Current Official Audit Snapshot

Latest generated artifact:
`docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.*`

| Priority | Screens |
| --- | ---: |
| `P0_CRITICAL_DENSITY_REVIEW` | 0 |
| `P1_HIGH_DENSITY_REVIEW` | 0 |
| `P1_TOOL_VISUAL_QA` | 5 |
| `P2_MEDIUM_DENSITY_REVIEW` | 113 |
| `P3_LOW_DENSITY_REVIEW` | 143 |
| `PASS_MONITOR` | 153 |

## 3. Enterprise-Grade Definition Of Done

### 3.1 Screen-Level Done

Every optimized screen must satisfy:

- [ ] Uses approved shared primitives where patterns match.
- [ ] Uses theme tokens; no raw styling debt is introduced.
- [ ] First viewport shows useful content, not just chrome/hero/blank space.
- [ ] Primary actionable section is visible or clearly previewed above bottom nav.
- [ ] No important content is mostly hidden by `VitBottomNav`, sticky footer, or safe area.
- [ ] Financial actions still show fee, risk, limits, masking, preview,
      confirmation, result, and next steps where applicable.
- [ ] Prediction Markets and Open Arena copy boundaries remain separate.
- [ ] Icon-only controls have `tooltip` or `Semantics(label: ...)`.
- [ ] Touch targets remain comfortable; do not shrink actions below safe mobile use.
- [ ] Works at 360 px and 440x956 QA viewport.
- [ ] Focused tests pass.
- [ ] `flutter analyze` passes before broad merge.
- [ ] Emulator screenshot or UI tree evidence exists for representative high-risk routes.

### 3.2 Shared Component Done

A shared component is ready for rollout only when:

- [ ] It supports density tiers where needed: compact, standard, relaxed,
      hero, and tool.
- [ ] It has stable dimensions and avoids layout shift.
- [ ] It preserves semantics and readable text.
- [ ] It has widget tests for compact and standard variants.
- [ ] It is reused by at least two screen archetypes or clearly becomes the
      canonical pattern for one high-volume archetype.
- [ ] It does not weaken financial safety or domain copy boundaries.

### 3.3 Audit Done

The optimization pass is complete only when:

- [ ] Visual density audit exists as a maintained Dart tool.
- [ ] Audit output covers all 414 routed screens.
- [ ] P0 count is 0 or all remaining P0s are accepted fullscreen/tool exceptions.
- [ ] P1 count is 0 or all remaining P1s are explicitly documented exceptions.
- [ ] P2/P3 items are either resolved or assigned to monitor/when-touched queues.
- [ ] Pass/monitor reference screens are protected from unnecessary churn.

## 4. Non-Negotiable Rules

- Do not remove financial safety copy to save space.
- Do not mix Arena points with wallet/profit/stake-return language.
- Do not replace shared primitives with local one-off compact widgets.
- Do not introduce raw fixed sizes as a shortcut.
- Do not globally shrink typography.
- Do not reduce important touch targets below mobile-safe interaction.
- Do not compact fullscreen tool screens with generic content-page rules.
- Do not declare a screen done without checking first-viewport behavior.

## 5. Work Breakdown

### Phase 0: Baseline And Governance

Goal: make the problem measurable and trackable before refactoring screens.

#### Task 0.1: Promote visual-density matrix to an official audit artifact `[x]`

**Description:** Convert the current supplemental matrix into a repeatable
project audit so future agents cannot miss the same blind spot.

**Acceptance criteria:**

- [x] A Dart audit tool exists under `flutter_app/tool/`.
- [x] It scans every routed screen and all source files listed by the route/body audits.
- [x] It counts tokenized fixed heights, feature gaps, `Spacer()`, bottom inset,
      top chrome, relaxed/manual content, and fullscreen tool classification.
- [x] It writes Markdown and CSV outputs under `docs/02_FLUTTER_MIGRATION/`.
- [x] It supports `--check`.

**Verification:**

- [x] `dart run tool/visual_density_risk_audit.dart --check`
- [x] CSV row count equals `414`.
- [x] `ProfilePage` is flagged until fixed.

**Completion evidence:** Added
`flutter_app/tool/visual_density_risk_audit.dart` and generated
`docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md` plus
`docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`.
Current official backlog: P0 `98`, P1 `69`, tool QA `5`, P2 `112`,
P3 `119`, pass/monitor `11`.

**Dependencies:** None  
**Likely files:** `flutter_app/tool/visual_density_risk_audit.dart`,
`docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.*`  
**Estimated scope:** M

#### Task 0.2: Define density thresholds and exception policy `[x]`

**Description:** Turn heuristic scores into a project policy with explicit
thresholds for P0/P1/P2/P3 and accepted tool exceptions.

**Acceptance criteria:**

- [x] Thresholds are documented.
- [x] Fullscreen tool routes have separate QA policy.
- [x] Root, detail, financial, analytics, and list pages have different budget
      expectations.
- [x] Exceptions require a reason and emulator evidence.

**Verification:**

- [x] Audit report includes threshold explanation.
- [x] Tool routes remain classified as tool QA, not normal content defects.

**Completion evidence:** The generated audit report includes threshold policy
for P0/P1/tool/P2/P3/pass and a separate fullscreen-tool exception policy that
requires emulator or widget-test evidence.

**Dependencies:** Task 0.1  
**Likely files:** audit tool, generated audit docs, this tracking plan  
**Estimated scope:** S

#### Task 0.3: Add first-viewport definition to project completion docs `[x]`

**Description:** Update the UI completion criteria so "done" includes
first-viewport usefulness.

**Acceptance criteria:**

- [x] Definition of done includes shared components, tokens, financial safety,
      accessibility, responsive render, and first-viewport density.
- [x] It references the density audit.
- [x] It clarifies that compactness cannot remove required safety information.

**Verification:**

- [x] Documentation review confirms no conflict with `AGENTS.md`.
- [x] New agents can find the gate from design-system docs.

**Completion evidence:** `docs/03_DESIGN_SYSTEM/Guidelines.md` now references
the visual-density audit and defines first-viewport usefulness as part of UI
completion.

**Dependencies:** Task 0.2  
**Likely files:** `docs/03_DESIGN_SYSTEM/*.md`  
**Estimated scope:** S

#### Checkpoint 0: Governance Ready

- [x] New audit exists and runs.
- [x] Backlog count is reproducible.
- [x] This tracking plan has been updated with generated audit paths.
- [x] No production UI refactor has started before the gate exists.

### Phase 1: Shared Density Foundation

Goal: create reusable compact patterns before touching dozens of screens.

#### Task 1.1: Introduce density semantics for shared components `[x]`

**Description:** Add a canonical density vocabulary for shared surfaces.

**Acceptance criteria:**

- [x] Density enum or equivalent project-approved API exists.
- [x] Density tiers are documented: compact, standard, relaxed, hero, tool.
- [x] Existing behavior remains default-compatible.
- [x] Compact density is available for root pages, rows, repeated cards, and
      action tiles.

**Verification:**

- [x] Shared widget tests cover compact and standard density.
- [x] `flutter analyze`

**Completion evidence:** Extended `VitDensity` to
`compact`, `standard`, `relaxed`, `hero`, and `tool`; added opt-in density to
`VitPageContent`, `VitPageSection`, `VitCard`, `VitMetricCard`,
`VitModuleHeroCard`, `VitModuleSectionHeader`, and `VitSectionHeader`.
Verified with focused analyze and
`flutter test test/shared/widgets/vit_shared_widgets_test.dart --reporter=compact`.

**Dependencies:** Checkpoint 0  
**Likely files:** `flutter_app/lib/shared/widgets/`, `flutter_app/lib/shared/layout/`,
`flutter_app/lib/app/theme/`  
**Estimated scope:** M

#### Task 1.2: Add compact card, row, and section patterns `[x]`

**Description:** Provide reusable patterns so features stop hand-tuning
`SizedBox` stacks.

**Acceptance criteria:**

- [x] Compact cards support repeated metrics/actions without large internal
      whitespace.
- [x] Section rhythm supports compact `8-14 dp` gaps.
- [x] Rows stay tappable and accessible.
- [x] Existing standard/hero patterns are not broken.

**Verification:**

- [x] Shared widget tests.
- [x] Visual smoke covered by shared widget render test.

**Completion evidence:** Added shared `VitInfoRow` with compact/standard
density, tap support, and consolidated semantics label. Existing `VitCard`,
`VitPageContent`, `VitPageSection`, `VitMetricCard`, `VitModuleHeroCard`,
`VitModuleSectionHeader`, and `VitSectionHeader` now support opt-in density
without changing default behavior. Verified with
`flutter test test/shared/widgets/vit_shared_widgets_test.dart --reporter=compact`.

**Dependencies:** Task 1.1  
**Likely files:** `VitCard`, `VitSectionHeader`, `VitServiceTile`,
`VitMetricCard`, `VitModuleComponents`  
**Estimated scope:** M

#### Task 1.3: Add first-viewport test utilities `[x]`

**Description:** Create widget-test helpers for measuring content against
bottom nav and sticky footer.

**Acceptance criteria:**

- [x] Helper can find bottom nav top.
- [x] Helper can assert first actionable section is above bottom nav.
- [x] Helper can assert a target route's semantic content exists in first
      viewport.
- [x] Works with 360x800 and 440x956 test sizes.

**Verification:**

- [x] New helper tests pass.
- [x] Existing responsive visual QA test pattern remains compatible.

**Completion evidence:** Added `test/helpers/first_viewport_test_utils.dart`
with `VitFirstViewport.minimumPhone`, `VitFirstViewport.qaPhone`, bottom-nav
usable-viewport measurement, route semantic assertions, and actionable-content
assertions. Added `test/quality/first_viewport_test_utils_test.dart` to verify
the helper contract at both required phone sizes. Verified with
`flutter analyze test/helpers/first_viewport_test_utils.dart test/quality/first_viewport_test_utils_test.dart`
and
`flutter test test/quality/first_viewport_test_utils_test.dart --reporter=compact`.

**Dependencies:** Task 0.1  
**Likely files:** `flutter_app/test/quality/`, `flutter_app/test/helpers/`  
**Estimated scope:** M

#### Task 1.4: Create compact financial-safety pattern `[x]`

**Description:** Compact high-risk flows without hiding risk, fees, limits, or
next steps.

**Acceptance criteria:**

- [x] Compact key-value risk/fee/limit rows exist.
- [x] `VitHighRiskStatePanel` or equivalent can render compact mode.
- [x] Required confirmation copy remains visible.
- [x] Masking remains intact.

**Verification:**

- [x] Focused tests for one wallet/launchpad/P2P example.
- [x] Accessibility labels remain meaningful.

**Completion evidence:** Added `VitFinancialSafetySummary` and
`VitFinancialSafetyItem` as shared compact fee/risk/limit rows backed by
`VitInfoRow`. Added optional `density` to `VitHighRiskStatePanel` with
`VitDensity.standard` default-compatible behavior and compact rendering for
loading/submitting/success/risk-review panels. Verified with
`flutter test test/shared/widgets/vit_high_risk_state_panel_test.dart --reporter=compact`,
`flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`,
`flutter analyze`, and
`dart run tool/design_token_consistency_audit.dart --check`.

**Dependencies:** Task 1.1  
**Likely files:** shared widgets, wallet/launchpad/P2P tests  
**Estimated scope:** M

#### Checkpoint 1: Foundation Ready

- [x] Shared compact primitives exist.
- [x] First-viewport test utilities exist.
- [x] Density audit can detect regressions.
- [x] No feature module is forced into local one-off compact widgets.

**Checkpoint evidence:** Phase 1 introduced density-aware shared primitives,
compact info/safety rows, compact high-risk panels, and first-viewport widget
test helpers. Shared widget tests, high-risk guardrails, token audit,
visual-density audit, and `flutter analyze` passed during the checkpoint.

### Phase 2: Reference Vertical Slice

Goal: fix a representative screen end-to-end and make it the pattern for the
rest of the app.

#### Task 2.1: Optimize `ProfilePage` as the account reference screen `[x]`

**Description:** Fix the confirmed emulator reproduction first.

**Acceptance criteria:**

- [x] Hero no longer consumes most of the first viewport.
- [x] VIP/progress information is compact or merged appropriately.
- [x] Prediction/Arena account cards are compact.
- [x] Product/support section is fully visible or clearly previewed above bottom
      nav on 440x956.
- [x] No financial/domain copy boundary is weakened.

**Verification:**

- [x] Focused profile tests.
- [x] First-viewport widget assertion.
- [x] Emulator screenshot for `/profile`.
- [x] `dart run tool/visual_density_risk_audit.dart --check` reflects improvement.

**Completion evidence:** `ProfilePage` was compacted with density-aware shared
cards, compact section rhythm, removed root fixed-height hero/VIP/module cards,
removed `Spacer()` pressure in the first viewport, and added
`SC-156 first viewport previews product hub above bottom nav`. The official
visual-density audit moved `ProfilePage` from score `112`
`P0_CRITICAL_DENSITY_REVIEW` to score `31`
`P2_MEDIUM_DENSITY_REVIEW`; whole-app P0 count moved from `98` to `97`.
Focused profile tests passed, `flutter analyze` passed, and Android emulator
evidence was captured at
`flutter_app/run-artifacts/visual-density/profile_page_optimized_emulator_profile_tab.png`
on emulator logical size approximately `448x997`.

**Dependencies:** Checkpoint 1  
**Likely files:** `flutter_app/lib/features/profile/presentation/pages/profile_page.dart`,
profile widgets, profile tests  
**Estimated scope:** M

#### Task 2.2: Apply account compact pattern to Profile P0/P1 routes `[x]`

**Description:** Use the `ProfilePage` pattern across account/security/API/VIP
screens.

**Acceptance criteria:**

- [x] `profile` P0 count is reduced to 0 or accepted exceptions.
- [x] `profile` P1 count is reduced to 0 or accepted exceptions.
- [x] Security/API flows still show sensitive-state warnings and masking.
- [x] Rows/cards use shared compact primitives.

**Verification:**

- [x] `flutter test test/features/profile --reporter=compact`
- [x] density audit for profile routes.
- [~] emulator sample for `ProfilePage` and one security/API route.

**Progress evidence:**

- 2026-06-19: `ApiKeyCreatePage` compacted the API permission review path and
  added `SC-162 first viewport keeps permission review visible`. Focused
  `api_key_create_page_test.dart` passed. The route improved from score `91`
  to `69`, then the multi-step clearance/custom-gap cleanup moved it to score
  `6` `PASS_MONITOR`; sensitive permission review, IP whitelist warning,
  secret-only-once copy, and navigation behavior remain covered by focused
  tests.
- 2026-06-19: `VIPPage` compacted hero/progress/fee overview content and added
  `SC-164 first viewport keeps upgrade progress visible`. Focused
  `vip_page_test.dart` passed. The route improved from score `87` to `49`
  (`P1_HIGH_DENSITY_REVIEW`), then bottom-clearance and benefits-table cleanup
  moved it to score `10` `P3_LOW_DENSITY_REVIEW`.
- 2026-06-19: `SubAccountPage` compacted summary, risk review, create CTA,
  account list rhythm, expanded details, and info note; added
  `SC-166 first viewport reaches first account card`. Focused
  `sub_account_page_test.dart` passed. The official visual-density audit moved
  `SubAccountPage` from score `80` `P0_CRITICAL_DENSITY_REVIEW` to score `8`
  `PASS_MONITOR`; whole-app counts moved to `P0=95`, `P1=70`, `PASS=12`.
- 2026-06-19: `SecurityPage` compacted the shared account-security route group
  across `AppRoutePaths.profileSecurity`, `AppRoutePaths.settingsSecurity`,
  `AppRoutePaths.settingsSecurityBiometric`, and
  `AppRoutePaths.settingsSecurityChangePassword`; added
  `SC-158 first viewport reaches security action list`. Focused
  `security_page_test.dart` passed. The official visual-density audit moved
  all four routes from score `62` `P0_CRITICAL_DENSITY_REVIEW` to score `6`
  `PASS_MONITOR`; whole-app counts moved to `P0=91`, `P1=70`, `PASS=16`.
  After the API key cleanup, current profile backlog is `1` P0 route, `6` P1
  routes, `1` P2 route, and `6` pass/monitor routes.
- 2026-06-19: `ActivityLogPage` compacted filter/warning chrome, activity
  cards, details, and footer; added
  `SC-161 first viewport reaches first activity log`. Focused
  `activity_log_page_test.dart` passed. The official visual-density audit moved
  `ActivityLogPage` from score `60` `P0_CRITICAL_DENSITY_REVIEW` to score `5`
  `PASS_MONITOR`; profile P0 routes are now `0`. Current profile backlog:
  `0` P0 routes, `6` P1 routes, `1` P2 route, and `7` pass/monitor routes.
- 2026-06-19: `SettingsPage` compacted section rhythm, currency/language rows,
  toggle lists, and app info; added
  `SC-160 first viewport reaches trade security toggle`. Focused
  `settings_page_test.dart` passed. The official visual-density audit moved
  `SettingsPage` from score `59` `P1_HIGH_DENSITY_REVIEW` to score `9`
  `PASS_MONITOR`. Current profile backlog: `0` P0 routes, `5` P1 routes, `1`
  P2 route, and `8` pass/monitor routes.
- 2026-06-19: `KYCPage` compacted status/review/level/privacy rhythm, removed
  fixed KYC card heights, and added `SC-159 first viewport reaches first KYC
  level`. Focused `kyc_page_test.dart` passed. The official visual-density
  audit moved `KYCPage` from score `54` `P1_HIGH_DENSITY_REVIEW` to score `7`
  `PASS_MONITOR`. Current profile backlog: `0` P0 routes, `4` P1 routes, `1`
  P2 route, and `9` pass/monitor routes.
- 2026-06-19: `DeviceManagementPage` compacted device summary, session-risk
  review, current-device preview, device cards, and revoke/trust buttons; added
  `SC-165 first viewport reaches current device card`. Focused
  `device_management_page_test.dart` passed. The official visual-density audit
  moved `DeviceManagementPage` from score `51` `P1_HIGH_DENSITY_REVIEW` to
  score `5` `PASS_MONITOR`. Current profile backlog: `0` P0 routes, `3` P1
  routes, `1` P2 route, and `10` pass/monitor routes.
- 2026-06-19: `VIPPage` follow-up cleanup removed the remaining content bottom
  spacer, custom page gap, benefits-tab gap tokens, and fixed divider/progress
  height tokens. Focused `vip_page_test.dart` passed. Current profile backlog:
  `0` P0 routes, `2` P1 routes, `1` P2 route, `1` P3 route, and `10`
  pass/monitor routes.
- 2026-06-19: `ApiManagementPage` compacted the high-risk access review, key
  inventory cards, secret rows, permission badges, regenerate/delete action row,
  and API docs card; added
  `SC-163 first viewport reaches API key inventory`. Focused
  `api_management_page_test.dart` passed. The official visual-density audit
  moved `ApiManagementPage` from score `49` `P1_HIGH_DENSITY_REVIEW` to score
  `8` `PASS_MONITOR`. Current profile backlog: `0` P0 routes, `1` P1 route,
  `1` P2 route, `1` P3 route, and `11` pass/monitor routes.
- 2026-06-19: `EditProfilePage` compacted avatar/form/save/risk-review rhythm,
  removed the avatar-to-form spacer, removed screen-local fixed height/gap
  pressure, and added `SC-157 first viewport reaches save action`. Focused
  `edit_profile_page_test.dart` passed and full
  `flutter test test/features/profile --reporter=compact` passed. The
  official visual-density audit moved `EditProfilePage` from score `43`
  `P1_HIGH_DENSITY_REVIEW` to score `5` `PASS_MONITOR`. Profile P0/P1 is now
  complete: current profile backlog is `0` P0 routes, `0` P1 routes, `1` P2
  route, `1` P3 route, and `12` pass/monitor routes.

**Dependencies:** Task 2.1  
**Likely files:** `flutter_app/lib/features/profile/`  
**Estimated scope:** M

#### Task 2.3: Verify `MyArenaPage` shared route impact `[x]`

**Description:** `MyArenaPage` appears through both Arena and Profile routes,
so compact it once and verify both surfaces.

**Acceptance criteria:**

- [x] `AppRoutePaths.arenaMy` and `AppRoutePaths.profileArena` both improve.
- [x] Arena remains points-only.
- [x] Shared compact cards are used.

**Verification:**

- [x] Arena focused tests.
- [x] Emulator sample of one Arena/Profile path.
- [x] Density matrix shows both routes improved.

**Completion evidence:** `MyArenaPage` now uses compact page/card density,
compact CTA/tabs/pill controls, and removes screen-local fixed line-height and
custom-gap pressure. Focused `my_arena_page_test.dart` passed with
first-viewport assertions for both `SC-168` (`AppRoutePaths.profileArena`) and
`SC-205` (`AppRoutePaths.arenaMy`). The official visual-density audit moved
both shared routes from score `114` `P0_CRITICAL_DENSITY_REVIEW` to score `5`
`PASS_MONITOR`. Arena copy was re-scanned for wallet/profit/payout/cash terms;
the screen remains Points-only. Emulator evidence was captured at
`flutter_app/run-artifacts/visual-density/my_arena_optimized_profile_route.png`
showing the profile-surface route with Arena Points, create CTA, tabs, and
challenge list visible above the bottom nav.

**Dependencies:** Task 2.1  
**Likely files:** `flutter_app/lib/features/arena/presentation/pages/my_arena_page*.dart`  
**Estimated scope:** M

#### Checkpoint 2: Reference Pattern Proven

- [x] Profile root issue is fixed on emulator.
- [x] Account/profile pattern is reusable.
- [x] Density audit shows measurable improvement.
- [x] No regression in Arena/Prediction boundary copy.

### Phase 3: Critical P0/P1 Modules

Goal: reduce the highest-risk visual-density backlog by archetype, not random
screen edits.

#### Task 3.1: Trade compliance/report archetype `[~]`

**Description:** Refactor repeated copy-trading compliance/report screens with
compact report sections.

**Initial route group:**

- `ClientCategorizationPage`
- `ClientOptUpRequestPage`
- `RegulatoryReportsDashboardPage`
- `ClientMoneyProtectionPage`
- `DisputeResolutionPage`
- `InvestorCompensationPage`
- `ExecutionVenueAnalysisPage`
- `SafetyEducationPage`
- `ComplaintsHandlingPage`
- `RegulatoryDisclosuresPage`
- `BestExecutionReportsPage`
- other trade P0 rows from the CSV with the same root causes.

**Acceptance criteria:**

- [x] Repeated report cards use compact shared report/card patterns.
- [x] Regulatory and financial safety copy remains complete.
- [x] Manual content density bypass count is reduced.
- [x] Very high tokenized fixed-height pressure is reduced.

**Verification:**

- [x] Focused trade tests for touched routes.
- [x] Density audit shows reduced P0 count for trade.
- [ ] Emulator screenshots for two representative routes.

**Progress evidence:**

- 2026-06-19: `ClientCategorizationPage` and `ClientOptUpRequestPage` were
  compacted from the shared client-categorization source by removing
  screen-local `customGap`, fixed height/line-height pressure, and `Spacer()`
  metric-card looseness while keeping MiFID II protection and opt-up waiver
  copy intact. Added first-viewport assertions for the current category card
  and professional criteria acknowledgement. Focused
  `client_categorization_page_test.dart` passed. The official visual-density
  audit moved both routes from score `206` `P0_CRITICAL_DENSITY_REVIEW` to
  score `10` `P3_LOW_DENSITY_REVIEW`; whole-app P0 count moved from `87` to
  `85`, and trade P0 count moved from `47` to `45`.
- 2026-06-19: `RegulatoryReportsDashboardPage` was compacted with KPI-first
  dashboard ordering, compact content/card density, fixed chart heights replaced
  by aspect-ratio charts, and line-height/custom-gap/spacer pressure removed.
  Added `SC-094 first viewport reaches KPI summary`. Focused
  `regulatory_reports_dashboard_page_test.dart` passed. The official
  visual-density audit moved the route from score `141`
  `P0_CRITICAL_DENSITY_REVIEW` to score `7` `PASS_MONITOR`; whole-app P0 count
  moved from `85` to `84`, and trade P0 count moved from `45` to `44`.
- 2026-06-19: `ClientMoneyProtectionPage` was compacted with compact page/card
  density, tighter scroll clearance, fixed tab/button/metric heights removed,
  `Spacer()` removed from the balance metrics, and line-height/custom-gap
  pressure removed while preserving CASS 7 segregation, reconciliation,
  insolvency, documents, limits and next-step review copy. Added
  `SC-102 first viewport reaches protection overview`. Focused
  `client_money_protection_page_test.dart` passed, the three touched trade
  compliance tests passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `128`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `84` to `83`, and trade P0 count moved from `44` to `43`.
- 2026-06-19: `DisputeResolutionPage` was compacted with compact complaint
  intake rhythm, compact high-risk review, fixed tab/type/provider/button
  heights removed, and line-height/custom-gap pressure removed while keeping
  dispute intake, provider selection, evidence upload, sticky submit, active
  cases, resolved history, refund outcome, and escalation copy intact. Added
  `SC-082 first viewport reaches complaint type inventory`. Focused
  `dispute_resolution_page_test.dart` passed, the touched trade compliance
  tests passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `126`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `83` to `82`, and trade P0 count moved from `43` to `42`.
- 2026-06-19: `InvestorCompensationPage` was compacted with compact FSCS
  coverage summary, compact high-risk coverage review, shared section rhythm,
  fixed tab/coverage/claim/FAQ heights removed, `Spacer()` removed from
  coverage boxes, and line-height/custom-gap pressure removed while keeping
  FSCS limit, eligibility, exclusions, claim path, warning, and FAQ copy
  intact. Added `SC-104 first viewport reaches FSCS overview`. Focused
  `investor_compensation_page_test.dart` passed, the touched trade compliance
  tests passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `119`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `82` to `81`, and trade P0 count moved from `42` to `41`.
- 2026-06-19: `ExecutionVenueAnalysisPage` was compacted with compact summary
  metrics, compact execution review, fixed sort/tab/metric/progress heights
  removed, `Spacer()` removed from summary cards, tab bodies converted to
  shared compact sections, and line-height/custom-gap pressure removed while
  keeping venue comparison, cost, speed, trend, export, and best-execution
  routing context intact. Added
  `SC-097 first viewport reaches venue comparison data`. Focused
  `execution_venue_analysis_page_test.dart` passed, the touched trade
  compliance tests passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `108`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `81` to `80`, and trade P0 count moved from `41` to `40`.
- 2026-06-19: `SafetyEducationPage` was compacted with compact high-risk
  safety review, compact hero/tab/scam/red-flag/verification/report sections,
  fixed report button/card heights removed, tab bodies converted to shared
  compact sections, and line-height/custom-gap pressure removed while keeping
  scam indicators, provider verification, reporting reasons, and next-step
  safety guidance intact. Added
  `SC-080 first viewport reaches first scam card`. Focused
  `safety_education_page_test.dart` passed, the touched trade compliance tests
  passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `112`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `80` to `79`, and trade P0 count moved from `40` to `39`.
- 2026-06-19: `ComplaintsHandlingPage` was compacted with compact rights,
  complaint review, metric, tab, category, timeline, complaint-card, process,
  and Ombudsman sections. Fixed tab/category/timeline/icon/button heights,
  `Spacer()` category looseness, local `_Card` padding, line-height overrides,
  and root custom-gap pressure were removed while preserving FCA regulated
  process, 8-week response, complaint categories, submission/tracking edges,
  escalation, and Ombudsman referral copy. Added
  `SC-111 first viewport reaches complaint categories`. Focused
  `complaints_handling_page_test.dart` passed, the touched trade compliance
  tests passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `110`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `79` to `78`, and trade P0 count moved from `39` to `38`.
- 2026-06-19: `RegulatoryDisclosuresPage` was compacted with compact legal
  hero, disclosure tabs, MiFID/protection/restriction/liability/contact
  sections, disclosure cards, action/contact/document tiles, review state, and
  regulatory notice panel. Fixed hero/tab/button/icon heights, root custom-gap
  pressure, card/action local padding, and disclosure line-height/gap overrides
  were removed while preserving MiFID articles, investor protection,
  jurisdiction restrictions, liability warnings, regulatory contacts,
  whistleblower protection, terms/privacy, and notice behavior. Added
  `SC-084 first viewport reaches MiFID article`. Focused
  `regulatory_disclosures_page_test.dart` passed, the touched trade compliance
  tests passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `107`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `78` to `77`, and trade P0 count moved from `38` to `37`.
- 2026-06-19: `BestExecutionReportsPage` was compacted with compact MiFID II
  RTS 27/28 review, summary cards, report tabs, current venue report,
  venue-quality metrics, report actions, archive rows, notice panel, and
  analysis CTA. Fixed summary/tab/venue/metric/archive/action heights,
  `Spacer()` summary-card looseness, magic bottom inset, root custom-gap
  pressure, card/action local padding, and line-height overrides were removed
  while preserving top-venue data, quality-score progress, export/publish
  notice behavior, archive access, and the SC-097 detailed-analysis route
  edge. Added `SC-096 first viewport reaches top venue`. Focused
  `best_execution_reports_page_test.dart` passed, the touched trade
  compliance tests passed together, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `103`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `77` to `76`, and trade P0 count moved from `37` to `36`.
- 2026-06-19: `ExAnteCostsPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact PRIIPs
  notice, dense investment/Year-1/% metric row, compact cost summary sections,
  compact RIY impact card, compact breakdown/scenario rows, compact period
  buttons, compact quick links, and first-cost-summary viewport coverage.
  Fixed `DeviceMetrics` bottom usage, root `VitContentPadding.none/fullBleed/
  customGap` bypass, `tradeFee*`/wallet fixed-height and gap token pressure,
  metric-card `Spacer()` looseness, and bottom-nav inset pressure while
  preserving ex-ante fee categories, RIY calculator edge, scenarios, ex-post
  report/KID links, and regulatory cost disclosure copy. Added `SC-105 first
  viewport reaches cost summary content`. Focused
  `ex_ante_costs_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeCopyExAnteCosts` from score
  `54` `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P1
  count moved from `19` to `18`, whole-app pass count moved from `127` to
  `128`, and trade P1 count moved down by `1`.
- 2026-06-19: `PerformanceScenariosPage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact risk review, compact "not a guarantee" notice, compact investment
  strip, compact holding-period selector, compact potential-outcome section,
  compact scenario cards/metrics, compact info note, and first-scenario-card
  viewport coverage. Fixed `DeviceMetrics` bottom usage, root
  `VitContentPadding.none/fullBleed/customGap` bypass, `tradeBot*`
  fixed-height/gap/line-height token pressure, and bottom-nav inset pressure
  while preserving modeled outcome assumptions, holding-period recalculation,
  stress/unfavorable/moderate/favorable copy, and "not a guarantee" risk copy.
  Added `SC-109 first viewport reaches first scenario card`. Focused
  `performance_scenarios_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopyPerformanceScenarios` from score `52`
  `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P1 count
  moved from `18` to `17`, whole-app pass count moved from `128` to `129`, and
  trade P1 count moved down by `1`.

**Dependencies:** Checkpoint 2  
**Likely files:** `flutter_app/lib/features/trade/`  
**Estimated scope:** M per batch

#### Task 3.2: Trade bot/margin/analytics archetype `[~]`

**Description:** Compact bot, margin, trader profile, and analytics screens
without compromising tool-like data density.

**Initial route group:**

- `AdvancedAnalyticsPage`
- `MarketDataAnalyticsPage`
- `BotSecuritySettingsPage`
- `TraderProfilePage`
- `BotTaxReportingPage`
- `ActiveCopiesPage`
- `MarginTradingPage`
- `BotGuidePage`
- `BotSuitabilityAssessmentPage`
- `CopySettingsPage`
- `PerformanceAttributionPage`
- `TradePage`
- `ArmIntegrationStatusPage`
- `SlippageMonitoringPage`

**Acceptance criteria:**

- [x] KPI/chart/report surfaces use compact metric strips where appropriate.
- [x] `Spacer()` inside fixed-height cards is removed or justified.
- [x] Bot security and margin risk copy remains visible.
- [x] Tool screens remain classified separately.

**Verification:**

- [x] Focused trade tests.
- [x] Density audit.
- [ ] Manual QA for chart/tool-like routes.

**Progress evidence:**

- 2026-06-19: `AdvancedAnalyticsPage` was compacted with compact root scroll
  clearance, hero stats, AI signal cards, filters, confidence/risk metrics,
  feature grid, tab bodies, model/risk/journal/sizing info panels, and compact
  `VitHighRiskStatePanel` usage. Fixed tokenized fixed-height pressure, manual
  card padding, magic bottom inset, line-height overrides, and tab/card
  custom-gap pressure while preserving AI disclaimer, risk score, VaR/Sharpe,
  journal attribution, position-sizing safety language, model provenance, and
  local tab/filter behavior. Added `SC-092 first viewport reaches first AI
  signal`. Focused `advanced_analytics_page_test.dart` passed, focused
  `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `170`
  `P0_CRITICAL_DENSITY_REVIEW` to score `6` `PASS_MONITOR`; whole-app P0 count
  moved from `76` to `75`, whole-app pass count moved from `34` to `35`, and
  trade P0 count moved from `36` to `35`.
- 2026-06-19: `MarketDataAnalyticsPage` was compacted with compact root scroll
  clearance, pair selector, market-data risk review, segmented tabs, open
  interest metrics, long/short ratio, top-trader positioning, funding-rate
  chart, liquidation stats/heatmap rows, sentiment components, and trading
  implication rows. Fixed tokenized fixed-height pressure, manual card padding,
  magic bottom inset, tab/card custom-gap pressure, line-height overrides, and
  fixed heatmap/chart row sizing while preserving mark price, open interest,
  funding-risk copy, liquidation context, sentiment scoring, and local tab
  behavior. Added `SC-089 first viewport reaches market data card`. Focused
  `market_data_analytics_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved the route from score `159`
  `P0_CRITICAL_DENSITY_REVIEW` to score `6` `PASS_MONITOR`; whole-app P0 count
  moved from `75` to `74`, whole-app pass count moved from `35` to `36`, and
  trade P0 count moved from `35` to `34`.
- 2026-06-19: `BotSecuritySettingsPage` was compacted with compact root scroll
  clearance, 2FA review, API key rows, IP whitelist rows, recent activity,
  security tips, dashed action controls, and API/IP bottom-sheet inputs. Fixed
  tokenized fixed-height pressure, manual card/sheet padding, bottom inset,
  section custom-gap pressure, and line-height overrides while preserving 2FA
  toggle behavior, API key creation, IP whitelist sheet flow, generated-key
  masking/visibility, destructive-key review copy, and security best-practice
  guidance. Added `SC-122 first viewport reaches API key controls`. Focused
  `bot_security_settings_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved the route from score `155`
  `P0_CRITICAL_DENSITY_REVIEW` to score `6` `PASS_MONITOR`; whole-app P0 count
  moved from `74` to `73`, whole-app pass count moved from `36` to `37`, and
  trade P0 count moved from `34` to `33`.
- 2026-06-19: `TraderProfilePage` was compacted with compact root scroll
  clearance, trader hero, copy action, risk review, segmented tabs,
  performance charts, details grid, trade rows, and stats panels. Fixed
  tokenized fixed-height pressure, `Spacer()` looseness, magic bottom inset,
  manual trader-profile panel padding, chart fixed heights, section gaps, and
  line-height overrides while preserving dynamic `/trade/trader/:traderId`
  routing, trader identity, ROI/AUM/copy action, follow/unfollow behavior,
  recent trades, win/loss stats, and copy suitability risk copy. Added
  `SC-087 first viewport reaches copy action`. Focused
  `trader_profile_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved the route from score `138`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `73` to `72`, whole-app pass count moved from `37` to `38`, and
  trade P0 count moved from `33` to `32`.
- 2026-06-19: `BotTaxReportingPage` was compacted with compact root scroll
  clearance, tax notice, year selector, summary metrics, cost-basis selector,
  report-type list, capital-gains breakdown, tax notes, compact export review,
  and shared `VitCtaButton` footer. Fixed tokenized fixed-height pressure,
  named vertical-gap pressure, manual content rhythm, duplicate bottom-chrome
  calculation, and line-height overrides while preserving tax-professional
  disclaimer copy, year/method/report selection behavior, export request
  generation, sensitive data masking review copy, and report preview before
  export. Added `SC-133 first viewport reaches report type selection`.
  Focused `bot_tax_reporting_page_test.dart` passed, focused
  `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `133`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `72` to `71`, whole-app pass count moved from `38` to `39`, and
  trade P0 count moved from `32` to `31`.
- 2026-06-19: `ActiveCopiesPage` was compacted with compact root scroll
  clearance, portfolio overview, exposure review, tab selector, active copy
  cards, return bar, expanded performance/details, recent trades, risk/status
  banners, and stop-copy confirmation sheet. Fixed tokenized fixed-height
  pressure, named vertical-gap pressure, `Spacer()` looseness, custom content
  rhythm, duplicate bottom inset calculation, and line-height overrides while
  preserving active/paused/history tab filtering, provider detail route edge,
  configuration route edge, typed `STOP` destructive confirmation, action
  status banner, and active-copy risk alert copy. Added
  `SC-066 first viewport reaches first active copy card`. Focused
  `active_copies_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved the route from score `129`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `71` to `70`, whole-app pass count moved from `39` to `40`, and
  trade P0 count moved from `31` to `30`.
- 2026-06-19: `BotApiDocumentationPage` was compacted with compact root scroll
  clearance, API intro, operational review, segmented tabs, REST endpoint
  cards, WebSocket connection/events, quick-start language selector, code
  blocks, rate limits, and authentication guidance. Fixed tokenized
  fixed-height pressure, named vertical-gap pressure, `Spacer()` response
  header looseness, custom content rhythm, duplicate bottom inset calculation,
  and line-height overrides while preserving endpoints/websocket/examples tab
  behavior, language switching, copy-to-clipboard behavior, authentication
  header copy, rate-limit data, and read-only documentation safety copy. Added
  `SC-134 first viewport reaches first endpoint card`. Focused
  `bot_api_documentation_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved the route from score `121`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `70` to `69`, whole-app pass count moved from `40` to `41`, and
  trade P0 count moved from `30` to `29`.
- 2026-06-19: `MarginTradingPage` was compacted across both margin routes with
  compact root content rhythm, compact high-risk review, tighter account
  metrics, pair/order controls, order inputs, review summary, risk cards,
  positions/orders panels, and notice sheet. Fixed named vertical-gap pressure,
  `Spacer()` looseness, custom content rhythm, fixed-height CTA pressure, and
  manual density bypass while preserving margin-mode switching, positions/order
  tabs, leverage selection, pair route variant, liquidation/negative-balance
  safety copy, and confirmation/review language. Reordered the first viewport so
  order side controls appear before secondary price-reference detail, while
  keeping account/risk detail in the same scroll flow. Added `SC-085 first
  viewport reaches the order side controls`. Focused
  `margin_trading_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved both `AppRoutePaths.tradeMargin` and
  `AppRoutePaths.tradeMarginBtcusdt` from score `108`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `69` to `67`, whole-app pass count moved from `41` to `43`, and
  trade P0 count moved from `29` to `27`.
- 2026-06-19: `BotGuidePage` was compacted with shared compact density across
  the root scroll rhythm, education review, intro banner, tabs, strategy cards,
  expanded strategy details, best-practice/mistake cards, and video tutorial
  CTA. Fixed manual `customGap` density bypass, bot-specific padding/gap tokens,
  fixed-height CTA pressure, and duplicate bottom-inset calculation while
  preserving strategies/best-practices/mistakes tab behavior, strategy expand
  state, bot activation education copy, examples, pros/cons, and common mistake
  remediation copy. Added `SC-131 first viewport reaches the first strategy
  card`. Focused `bot_guide_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved `AppRoutePaths.tradeBotGuide` from
  score `107` `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`;
  whole-app P0 count moved from `67` to `66`, whole-app pass count moved from
  `43` to `44`, and trade P0 count moved from `27` to `26`.
- 2026-06-19: `BotSuitabilityAssessmentPage` was compacted with shared compact
  density across the root scroll rhythm, risk review, question progress,
  question header, answer options, suitability info panel, result summary,
  category breakdown, recommendations, regulatory note, and result CTA. Fixed
  bot-specific fixed-height/gap tokens, custom result line-height pressure,
  option-card min-height pressure, duplicate bottom-inset calculation, and
  fixed-height CTA pressure while preserving eight-question answer progression,
  score calculation, pass/warning/fail result copy, completion navigation, and
  high-risk suitability review language. Added `SC-119 first viewport reaches
  the first answer option`. Focused `bot_suitability_assessment_page_test.dart`
  passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeBotSuitabilityAssessment` from
  score `105` `P0_CRITICAL_DENSITY_REVIEW` to score `12`
  `P3_LOW_DENSITY_REVIEW`; whole-app P0 count moved from `66` to `65`, whole-app
  P3 count moved from `122` to `123`, and trade P0 count moved from `26` to
  `25`.
- 2026-06-19: `RegulatoryInspectionReadyPage` was compacted with shared compact
  density across the root scroll rhythm, inspection risk review, compliance
  score card, quick stats, framework coverage cards, document repository rows,
  inspector portal card, and report CTA. Fixed regulatory-specific fixed
  heights, large gap tokens, custom line-height pressure, duplicate bottom-inset
  calculation, and fixed-height action buttons while preserving 97% compliance
  evidence, framework/document lists, inspector portal access, export/report
  actions, and retained inspection-readiness copy. Added `SC-116 first viewport
  reaches regulatory framework coverage`. Focused
  `regulatory_inspection_ready_page_test.dart` passed, focused
  `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved
  `AppRoutePaths.tradeCopyRegulatoryInspectionReady` from score `100`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `65` to `64`, whole-app pass count moved from `44` to `45`, and
  trade P0 count moved from `25` to `24`.
- 2026-06-19: `CopySettingsPage` was compacted with shared compact density
  across the root scroll rhythm, defaults section, copy-mode buttons, ratio and
  risk sliders, circuit breaker controls, notification rows, channel buttons,
  emergency contact fields, privacy toggle, and save CTA. Fixed copy-settings
  fixed-height card wrappers, `Spacer()`-driven loose cards, copy-settings
  line-height/padding tokens, duplicate bottom-inset calculation, and fixed
  action heights while preserving default mode switching, fixed-ratio
  visibility, circuit-breaker threshold behavior, notification/channel toggles,
  contact/privacy editing, save success state, and back navigation to Copy
  Trading. Added `SC-067 first viewport reaches risk limits section`. Focused
  `copy_settings_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeCopySettings` from score `99`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `64` to `63`, whole-app pass count moved from `45` to `46`, and
  trade P0 count moved from `24` to `23`.
- 2026-06-19: `ProductGovernancePage` was compacted with shared compact density
  across the root scroll rhythm, compliance notice, governance review panel,
  metric strip, tabs, product cards, target/negative market tags, date boxes,
  review schedule rows, and distribution channel cards. Fixed
  product-governance fixed-height/gap tokens, custom line-height pressure,
  `Spacer()` in date cards, duplicate bottom-inset calculation, and tab/card
  custom rhythm while preserving tab switching, product list content, review
  due-state copy, distribution channel counts, and target-market route edge.
  Added `SC-100 first viewport reaches first product card`. Focused
  `product_governance_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved
  `AppRoutePaths.tradeCopyProductGovernance` from score `97`
  `P0_CRITICAL_DENSITY_REVIEW` to score `5` `PASS_MONITOR`; whole-app P0 count
  moved from `63` to `62`, whole-app pass count moved from `46` to `47`, and
  trade P0 count moved from `23` to `22`.
- 2026-06-19: `PerformanceAttributionPage` was compacted with shared compact
  density across the root scroll rhythm, high-risk review panel, summary metric
  grid, attribution tabs, drawdown/projection/correlation charts, notice/info
  panels, contribution bars, and projection tiles. Fixed attribution-specific
  fixed-height/gap tokens, custom content rhythm, duplicate bottom-inset
  calculation, card padding pressure, line-height overrides, and correlation-tab
  loose stacking while preserving tab switching, return decomposition, drawdown
  warning copy, Monte Carlo projection context, correlation/R-squared copy, and
  copy-performance back navigation. Added `SC-075 first viewport reaches
  attribution tabs`. Focused `performance_attribution_page_test.dart` passed,
  focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `'/trade/copy-performance/:copyId/attribution'`
  from score `91` `P0_CRITICAL_DENSITY_REVIEW` to score `12`
  `P3_LOW_DENSITY_REVIEW`; whole-app P0 count moved from `62` to `61`, whole-app
  P3 count moved from `123` to `124`, and trade P0 count moved from `22` to
  `21`.
- 2026-06-19: `TradePage` was compacted across both instrument routes with
  shared compact density in the root scroll rhythm, bottom clearance, quick
  product hub chips, data tabs, market data panels, order tabs, order form gaps,
  side/order-type controls, percentage shortcuts, TP/SL row, fee card, CTA, and
  open/history order lists. Fixed manual content rhythm, duplicate bottom-inset
  calculation, `Spacer()`-driven label/value looseness, tokenized fixed-height
  pressure, vertical gap accumulation, and oversized quick-nav/form controls
  while preserving pair routing, side query handling, market-data tabs, quick
  product navigation, order preview calculation, amount shortcuts, TP/SL toggle,
  and order submission route. Added `SC-048 first viewport reaches order side
  switch`. Focused `trade_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved both `AppRoutePaths.trade` and
  `'/trade/:pairId'` from score `89` `P0_CRITICAL_DENSITY_REVIEW` to score `8`
  `PASS_MONITOR`; whole-app P0 count moved from `61` to `59`, whole-app pass
  count moved from `47` to `49`, and trade P0 count moved from `21` to `19`.
- 2026-06-19: `ArmIntegrationStatusPage` was compacted with shared compact
  density across the root scroll rhythm, ARM health review, operational alert,
  provider cards, metric boxes, connection details, test/log buttons, latency
  chart, SLA progress rows, and quick actions. Fixed ARM-specific large
  bottom-inset math, custom content gaps, oversized chart height, metric/card
  padding pressure, line-height overrides, and fixed action heights while
  preserving provider status, primary-provider badge, endpoint/cert detail,
  connection test loading state, latency legend, SLA copy, and queue/dashboard
  navigation. Added `SC-095 first viewport reaches first ARM provider`. Focused
  `arm_integration_status_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopyArmIntegrationStatus` from score `87`
  `P0_CRITICAL_DENSITY_REVIEW` to score `14` `P3_LOW_DENSITY_REVIEW`;
  whole-app P0 count moved from `59` to `58`, whole-app P3 count moved from
  `124` to `125`, and trade P0 count moved from `19` to `18`.
- 2026-06-19: `SlippageMonitoringPage` was compacted with shared compact
  density across the root scroll rhythm, critical alert, slippage risk review,
  stat grid, tabs, realtime event cards, provider/history/alert tab bodies,
  event metric tiles, cost-impact row, toast notice, and alert setting cards.
  Fixed slippage-specific large bottom-inset math, explicit zero/custom gaps,
  tab/card fixed heights, `Spacer()`-driven metric tiles, trade-tool gap/padding
  pressure, and oversized stat cards while preserving settings notice behavior,
  realtime/provider/history/alert tab switching, slippage event details,
  provider bps/cost data, alert toggle visuals, and high-risk review copy.
  Added `SC-098 first viewport reaches first slippage event`. Focused
  `slippage_monitoring_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopySlippageMonitoring` from score `84`
  `P0_CRITICAL_DENSITY_REVIEW` to score `8` `PASS_MONITOR`; whole-app P0 count
  moved from `58` to `57`, whole-app pass count moved from `49` to `50`, and
  trade P0 count moved from `18` to `17`.
- 2026-06-19: `ProviderGovernancePage` was compacted with shared compact
  density across the root scroll rhythm, provider dashboard, high-risk review,
  governance tabs, modification cards, communication/fees/compliance tab
  bodies, simple panels, request CTA, and broadcast panel. Fixed the
  governance-specific large bottom-inset budget, fixed dashboard/tab/card
  heights, `Spacer()` inside modification cards, manual tab-body gap stacks,
  notice min-height pressure, and oversized panel padding while preserving
  strategy change notice copy, fee waterfall details, compliance score, follower
  impact, broadcast panel behavior, and request CTA behavior. Added
  `SC-081 first viewport reaches governance tabs`. Focused
  `provider_governance_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopyProviderGovernance` from score `93`
  `P0_CRITICAL_DENSITY_REVIEW` to score `8` `PASS_MONITOR`; whole-app P0 count
  moved from `57` to `56`, whole-app pass count moved from `50` to `51`, and
  trade P0 count moved from `17` to `16`.
- 2026-06-19: `RiskIndicatorExplainerPage` was compacted with shared compact
  density across the root scroll rhythm, SRI product scale, explanation card,
  risk level list, additional risk rows, and risk indicator review panel. Fixed
  the risk-indicator bottom-inset budget, explicit `customGap`, section/list
  custom gaps, card-specific `tradeBot*` padding and line-height pressure,
  scale tile fixed height, warning min-height pressure, additional-risks
  min-height, and manual row gap stacks while preserving SRI 1-7 scale copy,
  holding-period assumption, high-risk warning, additional risk descriptions,
  product-level badge, and risk review copy. Added
  `SC-110 first viewport reaches risk scale details`. Focused
  `risk_indicator_explainer_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopyRiskIndicatorExplainer` from score `80`
  `P0_CRITICAL_DENSITY_REVIEW` to score `10` `P3_LOW_DENSITY_REVIEW`;
  whole-app P0 count moved from `56` to `55`, whole-app P3 count moved from
  `125` to `126`, and trade P0 count moved from `16` to `15`.
- 2026-06-19: `BotStrategyComparePage` was compacted with shared compact
  density across the root scroll rhythm, strategy selection grid, best strategy
  summary, equity/radar chart cards, detailed metrics table, recommendation
  cards, analysis-period card, and high-risk review panel. Fixed the
  strategy-compare bottom-inset budget, explicit page/section custom gaps,
  `Spacer()` inside strategy cards, chart fixed heights by switching chart
  cards to aspect-ratio frames, table fixed column widths/divider heights,
  card-specific `tradeBot*` padding and line-height pressure, oversized icons,
  and manual recommendation/analysis gaps while preserving strategy selection
  toggling, best-strategy copy, chart painters, metric best markers,
  recommendation rationale, analysis-period copy, and allocation-review copy.
  Added `SC-126 first viewport reaches best strategy card`. Focused
  `bot_strategy_compare_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeBotStrategyCompare` from score `78`
  `P0_CRITICAL_DENSITY_REVIEW` to score `12` `P3_LOW_DENSITY_REVIEW`;
  whole-app P0 count moved from `55` to `54`, whole-app P3 count moved from
  `126` to `127`, and trade P0 count moved from `15` to `14`.
- 2026-06-19: `CopyConfirmationPage` was compacted with shared compact density
  across the root scroll rhythm, critical warning, provider summary,
  suitability/limits review, configuration summary, fee breakdown, scenario
  cards, max-loss warning, required consent tiles, cooling-off notice, next
  steps, sticky submit CTA, and high-risk review panel. Fixed the confirmation
  bottom-inset budget, repeated manual section gaps, card-specific
  `copyConfirmation*` padding and line-height pressure, oversized warning/
  checkbox/cooling icons, divider height pressure, summary-row padding, and
  fixed step/avatar sizing pressure while preserving fee preview, max-loss copy,
  provider limit, required consent gating, disabled/enabled submit behavior,
  cooling-off copy, next steps, and submit navigation to Active Copies. Added
  `SC-073 first viewport reaches suitability review`. Focused
  `copy_confirmation_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved
  `'/trade/copy-provider/:providerId/confirmation'` from score `77`
  `P0_CRITICAL_DENSITY_REVIEW` to score `15` `P3_LOW_DENSITY_REVIEW`;
  whole-app P0 count moved from `54` to `53`, whole-app P3 count moved from
  `127` to `128`, and trade P0 count moved from `14` to `13`.
- 2026-06-19: `BotRiskDashboardPage` was compacted with shared compact density
  across the root scroll rhythm, portfolio risk score, critical metric grid,
  exposure distribution, drawdown/VaR chart cards, safety controls, emergency
  action card, explanation rows, and high-risk review panel. Fixed the risk
  dashboard bottom-inset budget, manual section gaps, `Spacer()` usage in
  exposure rows, chart fixed-height pressure, oversized risk-ring sizing, and
  metric-card typography overflow while preserving emergency navigation to
  `SC-121` and risk-control copy. Added
  `SC-120 first viewport reaches critical metrics`. Focused
  `bot_risk_dashboard_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `AppRoutePaths.tradeBotRiskDashboard`
  from score `77` `P0_CRITICAL_DENSITY_REVIEW` to score `15`
  `P3_LOW_DENSITY_REVIEW`; whole-app P0 count moved from `53` to `52`,
  whole-app P3 count moved from `128` to `129`, and trade P0 count moved from
  `13` to `12`.
- 2026-06-19: `PortfolioRiskAnalysisPage` was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact summary cards, compact risk preview/alert rhythm, shorter exposure
  chart/ring, compact asset rows, and first-asset viewport protection. Fixed
  `DeviceMetrics` bottom usage, custom page rhythm, tokenized summary/chart/
  asset-row fixed heights, vertical gap accumulation, `Spacer()` looseness, and
  line-height pressure while preserving exposure/VaR/diversification/alerts,
  exposure/correlation/VaR/scenario tabs, stress scenarios, high-risk review
  copy, and back navigation to Copy Trading. Added `SC-078 first viewport
  reaches asset allocation data`. Focused
  `portfolio_risk_analysis_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopyRiskAnalysis` from score `74`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `12` to `11`, whole-app pass count moved from `102` to
  `103`, and trade P0 count moved from `12` to `11`.
- 2026-06-19: `CopyAuditLogPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  compliance/review/search/tab rhythm, compact audit event cards, compact
  metadata panels, summary cards, and export-sheet controls. Fixed
  `DeviceMetrics` bottom usage, custom page gap rhythm, `copyAudit*` fixed
  height/line-height pressure, repeated event gap tokens, metadata card height,
  summary-card height, and CTA height pressure while preserving retention
  notice, audit event search/filter behavior, CSV/PDF/JSON export request
  creation, metadata price/slippage/P-L evidence, high-risk review copy, and
  export header action. Added `SC-077 first viewport reaches first audit
  event`. Focused `copy_audit_log_page_test.dart` passed, focused
  `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `'/trade/copy-audit-log/:copyId'` from score `73`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `11` to `10`, whole-app pass count moved from `103` to
  `104`, and trade P0 count moved from `11` to `10`.
- 2026-06-19: `BotTermsOfServicePage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, shorter
  legal-read inner terms frame, compact info banner, scroll warning,
  agreement card, CTA, compliance note, and compact high-risk review panel.
  Fixed `DeviceMetrics` bottom usage, custom page gap rhythm, terms-card fixed
  height pressure, `tradeBotLineHeight*` pressure, gap-token accumulation,
  scroll-warning/agreement/compliance min-height pressure, and CTA line-height
  pressure while preserving the full legal sections, critical no-profit warning,
  read-to-end gating, disabled-until-read agreement behavior, acceptance CTA,
  and back navigation to Trading Bots. Added `SC-117 first viewport previews
  agreement card`. Focused `bot_terms_of_service_page_test.dart` passed,
  focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeBotTermsOfService` from score
  `71` `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `10` to `9`, whole-app pass count moved from `104` to
  `105`, and trade P0 count moved from `10` to `9`.
- 2026-06-19: `AdvancedTradingDemoPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  position-mode controls, tab/body rhythm, position action list, mock position
  card, order controls, analytics metrics, demo sheet clearance, and compact
  high-risk review panel. Fixed `DeviceMetrics` bottom usage in page and
  sheet, custom page gap rhythm, `tradeTool*` vertical-gap accumulation,
  risk-tab fixed-height pressure, `Spacer()` looseness in mode header, CTA
  height pressure, and raw line-height drift while preserving mode switching,
  position/order/analytics tabs, demo sheet action flow, mock position data,
  and demo execution boundary copy. Added `SC-088 first viewport reaches first
  position action`. Focused `advanced_trading_demo_page_test.dart` passed,
  focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeMarginAdvancedDemo` from
  score `70` `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`;
  whole-app P0 count moved from `9` to `8`, whole-app pass count moved from
  `105` to `106`, and trade P0 count moved from `9` to `8`.
- 2026-06-19: `BotPerformanceAnalyticsPage` was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact key metrics/review/timeframe rhythm, shorter PnL and win/loss chart
  extents, compact strategy/progress rows, advanced metric cards, duration
  donut, summary rows, rating card, and painter text line-height. Fixed
  `DeviceMetrics` bottom usage, custom page/section gap bypass, tokenized
  chart/donut/progress fixed-height pressure, `Spacer()` looseness in advanced
  metrics, trade-bot gap accumulation, and painter `tradeBotLineHeight*`
  pressure while preserving PnL, win/loss, strategy, duration, risk-aware
  analytics copy, chart painters, and timeframe tab behavior. Added `SC-124
  first viewport reaches cumulative PnL chart`. Focused
  `bot_performance_analytics_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeBotPerformanceAnalytics` from score `62`
  `P0_CRITICAL_DENSITY_REVIEW` to score `3` `PASS_MONITOR`; whole-app P0
  count moved from `8` to `7`, whole-app pass count moved from `106` to
  `107`, and trade P0 count moved from `8` to `7`.
- 2026-06-19: `BotDrawdownAnalyzerPage` P1 was compacted with route-local
  bounded scroll-end clearance, shared compact `VitPageContent`, compact
  metric cards, compact risk review, shorter underwater/duration chart
  extents, compact event cards, and compact analysis rows. Fixed
  `DeviceMetrics` bottom usage, root `VitContentPadding.none/fullBleed/
  customGap`, trade-bot vertical gap accumulation, chart fixed-height pressure,
  `Spacer()` looseness in event headers, and loose event/stat padding while
  preserving max/average drawdown metrics, underwater/duration painters,
  event severity evidence, analysis insights, high-risk review copy, and Trade
  shell routing. Added `SC-129 first viewport reaches full drawdown summary`.
  Verification passed: focused analyze, `bot_drawdown_analyzer_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `48/P1 -> 7/PASS_MONITOR`, fixed-height refs `2 -> 0`, tokenized-gap refs
  `10 -> 2`, spacer refs `1 -> 0`, manual-content refs `1 -> 0`,
  bottom-inset refs `6 -> 1`; whole-app P1 count moved from `15` to `14`,
  whole-app pass/monitor count moved from `131` to `132`.
- 2026-06-19: `BotEquityCurvePage` P1 was compacted with route-local bounded
  scroll-end clearance, shared compact `VitPageContent`, compact summary
  metrics, compact risk review/status, shorter equity/sharpe chart extents,
  compact monthly alpha/progress rows, performance tiles, and analysis copy.
  Fixed `DeviceMetrics` bottom usage, root `VitContentPadding.none/fullBleed/
  customGap`, nested manual content rhythm, equity chart fixed-height pressure,
  summary metric fixed-height pressure, trade-bot vertical gap accumulation,
  and loose card/control padding while preserving equity/sharpe/monthly alpha
  tabs, chart painters, performance stats, risk warning copy, and Trade shell
  routing. Added `SC-130 first viewport reaches equity summary metrics`.
  Verification passed: focused analyze, `bot_equity_curve_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `48/P1 -> 8/PASS_MONITOR`, fixed-height refs `4 -> 0`, tokenized-gap refs
  `6 -> 2`, manual-content refs `2 -> 0`, bottom-inset refs `6 -> 1`;
  whole-app P1 count moved from `14` to `13`, whole-app pass/monitor count
  moved from `132` to `133`.
- 2026-06-19: `ProviderLeaderboardPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  survivorship warning, high-risk review, sort/risk/verified filter controls,
  provider count, ranked provider cards, and disclaimer. Fixed `DeviceMetrics`
  bottom usage, custom page gap rhythm, `inputHeight` control pressure,
  provider-leaderboard line-height/gap tokens, fixed-height review/filter
  pressure, and first-card visibility while preserving ROI/Sharpe/followers
  sorting, risk filtering, verified-only toggle behavior, provider detail
  navigation, survivorship warning, and copy-provider review copy. Added
  `SC-079 first viewport reaches top provider card`. Focused
  `provider_leaderboard_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopyLeaderboard` from score `69`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `7` to `6`, whole-app pass count moved from `107` to
  `108`, and trade P0 count moved from `7` to `6`.
- 2026-06-19: `RiskManagementDemoPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  high-risk review, feature cards, benefits/status lists, OCO/calculator tab
  actions, sheet spacing, and 44 px CTA/tab touch targets. Fixed
  `DeviceMetrics` bottom usage, custom page/section gap bypass, risk tab fixed
  height pressure, `tradeCtaHeight` pressure, trade-tool vertical gap
  accumulation, and first-feature visibility while preserving OCO order sheet,
  position tab, calculator sheet, success toast, risk-review copy, and back
  navigation. Added `SC-060 first viewport reaches first risk feature`.
  Focused `risk_management_demo_page_test.dart` passed, focused
  `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeRiskManagement` from score
  `67` `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app
  P0 count moved from `6` to `5`, whole-app pass count moved from `108` to
  `109`, and trade P0 count moved from `6` to `5`.
- 2026-06-19: `ComplaintSubmissionPage` was compacted with route-local bounded
  scroll/footer clearance, compact shared `VitPageContent` density, compact
  high-risk review, process notice, category selector, text-field rhythm,
  evidence upload card, terms card, and sticky submit footer. Fixed
  `DeviceMetrics` bottom usage, custom page gap bypass, complaint-specific
  bottom/line-height/fixed-height tokens, `inputHeight` category pressure,
  evidence-card overflow risk, and first form-field visibility while preserving
  regulated complaint copy, category menu, subject/description validation,
  evidence/terms review, disabled submit behavior, and SC-113 navigation.
  Added `SC-112 first viewport reaches complaint category field`. Focused
  `complaint_submission_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopyComplaintSubmission` from score `66`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `5` to `4`, whole-app pass count moved from `109` to
  `110`, and trade P0 count moved from `5` to `4`.
- 2026-06-19: `OmbudsmanReferralPage` P1 was compacted with route-local
  bounded scroll-end clearance, shared compact `VitPageContent`, compact
  ombudsman intro/contact/process icon extents, and default typography
  line-height. Fixed `DeviceMetrics` bottom usage, root
  `VitContentPadding.none/fullBleed/customGap`, ombudsman fixed-height
  pressure, complaint-case line-height token pressure, and bottom-nav inset
  pressure while preserving independent dispute-resolution copy, referral
  eligibility rules, FOS contact details, process steps, external website CTA,
  and regulated body-review notes. Added `SC-114 first viewport reaches
  independent referral intro`. Verification passed: focused analyze,
  `ombudsman_referral_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `48/P1 -> 3/PASS_MONITOR`, fixed-height refs `10 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `6 -> 1`; whole-app P1
  count moved from `13` to `12`, whole-app pass/monitor count moved from
  `133` to `134`.
- 2026-06-19: `RIYCalculatorPage` P1 was compacted with route-local bounded
  scroll-end clearance, shared compact `VitPageContent`, compact high-risk
  review and section headers, compact input controls, compact result metrics,
  bounded cost-impact copy, and a route-local growth chart extent. Fixed
  `DeviceMetrics` bottom usage, root `VitContentPadding.none/fullBleed/
  customGap`, RIY/trade-bot fixed-height pressure, tokenized vertical gap
  accumulation, `Spacer()` looseness inside result cards, manual content
  density bypass, and bottom-nav inset pressure while preserving RIY
  investment/return/cost/holding-period inputs, projection math, chart painter,
  cost-impact copy, and Trade shell routing. Added `SC-106 first viewport
  reaches investment input`. Verification passed: focused analyze,
  `riy_calculator_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `48/P1 -> 3/PASS_MONITOR`, fixed-height refs `6 -> 0`,
  tokenized-gap refs `4 -> 0`, spacer refs `2 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `4 -> 1`; whole-app P1
  count moved from `12` to `11`, whole-app pass/monitor count moved from
  `134` to `135`.
- 2026-06-19: `OrderReceiptPage` P1 was compacted with route-local bounded
  scroll/footer clearance, shared compact `VitPageContent`, compact success
  hero, compact high-risk receipt confirmation, compact receipt detail rows,
  compact TP/SL risk boxes, compact warning/support cards, and footer buttons
  lifted above bottom navigation without raw `DeviceMetrics`. Fixed root
  `DeviceMetrics` bottom usage, receipt fixed-height pressure, receipt
  vertical gap accumulation, footer/button height tokens, horizontal margin
  nesting, and bottom-nav inset pressure while preserving order id copy,
  fill/fee/risk details, open-orders navigation, continue-trading navigation,
  share state, support route, and financial receipt copy. Added
  `SC-051 first viewport reaches receipt id`. Verification passed: focused
  analyze, `order_receipt_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `47/P1 -> 3/PASS_MONITOR`, fixed-height refs `4 -> 0`,
  tokenized-gap refs `13 -> 0`, bottom-inset refs `4 -> 1`; whole-app P1
  count moved from `11` to `10`, whole-app pass/monitor count moved from
  `135` to `136`.
- 2026-06-19: `TradeHistoryExportPage` P1 was compacted with route-local
  footer/scroll clearance, shared compact `VitPageContent`, compact export
  summary metrics, compact format cards, compact period chips, compact include
  rows, compact tax note, compact high-risk review, and sticky export/result
  footer placement above bottom navigation without raw `DeviceMetrics`. Fixed
  export fixed-height pressure, vertical gap accumulation, root bottom chrome
  usage, footer ready-state height/gap tokens, selector card height tokens, and
  bottom-nav inset pressure while preserving format/period/include state,
  export request capture, ready/download/new-export states, tax note, body
  review copy, and Trade shell routing. Added `SC-054 first viewport reaches
  export format selector`. Verification passed: focused analyze,
  `trade_history_export_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `47/P1 -> 4/PASS_MONITOR`, fixed-height refs `5 -> 0`,
  tokenized-gap refs `10 -> 0`, bottom-inset refs `5 -> 1`; whole-app P1
  count moved from `10` to `9`, whole-app pass/monitor count moved from
  `136` to `137`.
- 2026-06-19: `BotHistoryPage` P1 was compacted with route-local bounded
  scroll-end clearance, shared compact `VitPageContent`, compact stats/search
  controls, compact segmented filters, compact trade cards/detail boxes,
  compact export note, and compact high-risk export review. Fixed
  `DeviceMetrics` bottom usage, root `VitContentPadding.none/fullBleed/
  customGap`, trade-bot vertical gap accumulation, detail-card fixed-height
  pressure, `Spacer()` looseness, export-button height pressure, and
  bottom-nav inset pressure while preserving buy/sell filtering, realized PnL
  and fee totals, trade rows, export request creation, and Trade shell routing.
  Added `SC-123 first viewport reaches first trade card`. Verification passed:
  focused analyze, `bot_history_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `47/P1 -> 3/PASS_MONITOR`, fixed-height refs `3 -> 0`,
  tokenized-gap refs `8 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `6 -> 1`; whole-app P1
  count moved from `9` to `8`, whole-app pass/monitor count moved from
  `137` to `138`.
- 2026-06-19: `PredictionsSearchPage` P1 was compacted with route-local
  bounded scroll-end clearance, shared compact `VitPageContent`, compact search
  control, compact filter panel, compact sort/status/category chips, compact
  result cards, compact empty state, and first-result viewport coverage. Fixed
  `DeviceMetrics` bottom usage, relaxed/custom content rhythm, prediction
  search fixed-height pressure, manual content density bypass, oversized
  filter/result/empty-state spacing, and bottom-nav inset pressure while
  preserving search query behavior, sort/status/category filters, clear
  filters, result navigation, Prediction Markets wording, and back navigation.
  Added `SC-028 first viewport reaches first search result`. Verification
  passed: focused analyze, `predictions_search_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `47/P1 -> 8/PASS_MONITOR`, fixed-height refs `5 -> 0`,
  manual-content refs `2 -> 0`, bottom-inset refs `8 -> 1`; whole-app P1
  count moved from `8` to `7`, whole-app pass/monitor count moved from
  `138` to `139`.
- 2026-06-19: `PairDetailPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact chart/view controls, compact indicator chips,
  shorter route-local chart extent, compact order-book header, compact link/CTA
  gaps, and first-chart viewport coverage. Fixed `DeviceMetrics` bottom usage,
  pair-detail fixed-height pressure, vertical gap accumulation, `Spacer()`
  looseness, and bottom-nav inset pressure while preserving price overview,
  chart/order-book/trades tabs, indicator toggles, advanced-chart route,
  token-info/depth navigation, buy/sell CTAs, favorite action, and Markets
  shell routing. Added `SC-044 first viewport reaches the pair chart`.
  Verification passed: focused analyze, `pair_detail_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `46/P1 -> 3/PASS_MONITOR`, fixed-height refs `7 -> 0`,
  tokenized-gap refs `4 -> 0`, spacer refs `1 -> 0`,
  bottom-inset refs `6 -> 1`; whole-app P1 count moved from `7` to `6`,
  whole-app pass/monitor count moved from `139` to `140`.
- 2026-06-19: `WatchlistPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  toolbar controls, compact watchlist cards, shorter route-local sparkline
  extent, compact note pill/action button treatment, and first-pair viewport
  coverage. Fixed `DeviceMetrics` bottom usage, watchlist fixed-height
  pressure, vertical gap accumulation, manual content density bypass, and
  bottom-nav inset pressure while preserving search filtering, local remove
  state, add/back controls, pair navigation, trade navigation, and Markets shell
  routing. Added `SC-012 first viewport reaches first watchlist pair`.
  Verification passed: focused analyze, `watchlist_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `45/P1 -> 4/PASS_MONITOR`, fixed-height refs `2 -> 0`,
  tokenized-gap refs `10 -> 0`, manual-content refs `1 -> 0`,
  bottom-inset refs `6 -> 1`; whole-app P1 count moved from `6` to `5`,
  whole-app pass/monitor count moved from `140` to `141`.
- 2026-06-19: `ExPostCostsReportPage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact compliance notice, compact summary cards, dynamic tab-card minimum
  height, compact breakdown/variance cards, and first-cost-row viewport
  coverage. Fixed `DeviceMetrics` bottom usage, ex-post report fixed-height
  pressure, vertical gap accumulation, `Spacer()` looseness, and bottom-nav
  inset pressure while preserving yearly tabs, actual/estimated cost values,
  variance disclosure, export action, SC-105 quick-link routing, and financial
  disclosure copy. Added `SC-107 first viewport reaches the first cost row`.
  Verification passed: focused analyze, `ex_post_costs_report_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `44/P1 -> 3/PASS_MONITOR`, fixed-height refs `6 -> 0`,
  tokenized-gap refs `4 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `4 -> 1`; whole-app P1
  count moved from `5` to `4`, whole-app pass/monitor count moved from `141`
  to `142`.
- 2026-06-19: `PredictionsGlobalActivityPage` P1 was compacted with
  route-local bounded scroll-end clearance, compact shared `VitPageContent`
  density, compact live stats, compact amount filters, shared compact card
  wrappers, self-sizing activity rows, and first-activity-row viewport
  coverage. Fixed `DeviceMetrics` bottom usage, relaxed/custom content rhythm,
  manual zero-padding card wrappers, prediction-activity fixed-height tokens,
  and bottom-nav inset pressure while preserving live stats, amount filters,
  local filter behavior, event-detail navigation, and Prediction Markets copy.
  Added `SC-034 first viewport reaches the first activity row`. Verification
  passed: focused analyze, `predictions_global_activity_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `42/P1 -> 9/PASS_MONITOR`, fixed-height refs `3 -> 0`,
  manual-content refs `2 -> 0`, bottom-inset refs `8 -> 1`; whole-app P1
  count moved from `4` to `3`, whole-app pass/monitor count moved from `142`
  to `143`.
- 2026-06-19: `TargetMarketDefinitionPage` P1 was compacted once for both
  the base and product-scoped routes with route-local bounded scroll-end
  clearance, compact shared `VitPageContent` density, compact summary card,
  compact dimension cards, compact criteria rows, compact high-risk review,
  and first-dimension viewport coverage. Fixed `DeviceMetrics` bottom usage,
  `tradeBot*` fixed-height/gap pressure inside the screen, manual content
  density bypass, and bottom-nav inset pressure while preserving productId
  routing, target-market dimensions, suitable/not-suitable separation,
  governance review copy, and Trade shell routing. Added `SC-101 first
  viewport reaches first target dimension`. Verification passed: focused
  analyze, `target_market_definition_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result for
  both `AppRoutePaths.tradeCopyTargetMarketDefinition` and
  `'${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId`:
  `41/P1 -> 3/PASS_MONITOR`, fixed-height refs `5 -> 0`,
  tokenized-gap refs `6 -> 0`, manual-content refs `1 -> 0`,
  bottom-inset refs `4 -> 1`; whole-app P1 count moved from `3` to `1`,
  whole-app pass/monitor count moved from `143` to `145`.
- 2026-06-19: `OrdersHistoryPage` final P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact top tabs, compact filters, self-keyed order tiles, compact
  status/type/info rows, compact cancel action height, and first-open-order
  viewport coverage. Fixed `DeviceMetrics` bottom usage, manual scroll padding,
  `tradeHistory*` fixed-height/gap pressure, and bottom-nav inset pressure
  while preserving open/history tab switching, buy/sell/all filters, order
  cancel action draft, snackbar behavior, history rows, and Trade shell
  routing. Added `SC-050 first viewport reaches first open order`.
  Verification passed: focused analyze, `orders_history_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `41/P1 -> 4/PASS_MONITOR`, fixed-height refs `3 -> 0`,
  tokenized-gap refs `7 -> 0`, bottom-inset refs `8 -> 1`; whole-app P1
  count moved from `1` to `0`, whole-app pass/monitor count moved from `145`
  to `146`.
- 2026-06-19: `CopyTradingV2Page` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  variant switcher, glass/bold hero variants, high-risk copy review, sort
  chips, trader cards, avatar/tier badges, stat cards, and detail action. Fixed
  `DeviceMetrics` bottom usage, custom page/section gap bypass, tokenized
  copy-trading v2 fixed-height pressure, hero/trader `Spacer()` looseness,
  manual card density bypass, and first trader-card visibility while preserving
  clean/bold/glass variant switching, sort options, top-three trader behavior,
  provider-detail route edge, risk warning copy, and back navigation. Added
  `SC-064 first viewport reaches top ROI trader card`. Focused
  `copy_trading_v2_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `AppRoutePaths.tradeCopyTradingV2` from
  score `65` `P0_CRITICAL_DENSITY_REVIEW` to score `2` `PASS_MONITOR`;
  whole-app P0 count moved from `4` to `3`, whole-app pass count moved from
  `110` to `111`, and trade P0 count moved from `4` to `3`.
- 2026-06-19: `LeveragePage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  leverage hero, risk meter, slider controls, stop/preset buttons, impact
  estimate rows, high-risk review, safety tips, and confirm CTA. Fixed
  `DeviceMetrics` bottom usage, relaxed/custom page rhythm, leverage-specific
  fixed-height/line-height tokens, wallet-derived control heights, vertical
  gap accumulation, manual card density bypass, and first-slider visibility
  while preserving leverage sanitation, slider/stops, preset previews,
  high-risk safety tips, confirmation return to Futures, and back navigation.
  Added `SC-058 first viewport reaches leverage slider`. Focused
  `leverage_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `'/trade/:pairId/futures/leverage'` from score
  `63` `P0_CRITICAL_DENSITY_REVIEW` to score `6` `PASS_MONITOR`; whole-app P0
  count moved from `3` to `2`, whole-app pass count moved from `111` to
  `112`, and trade P0 count moved from `3` to `2`.
- 2026-06-19: `CopyPerformancePage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  performance summary, return cards, copy-performance high-risk review, tabs,
  equity/slippage charts, info boxes, trade comparison cards, cost rows, metric
  rows, and small metric cards. Fixed `DeviceMetrics` bottom usage, custom page
  gap bypass, copy-performance fixed-height/line-height tokens, tall chart
  extents, very-high vertical gap accumulation, and first-tabs visibility while
  preserving overview, trades, costs, metrics, PnL/fees/slippage/drawdown copy,
  tab switching, and chart painters. Added
  `SC-074 first viewport reaches performance tabs`. Focused
  `copy_performance_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `'/trade/copy-performance/:copyId'` from
  score `61` `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`;
  whole-app P0 count moved from `2` to `1`, whole-app pass count moved from
  `112` to `113`, and trade P0 count moved from `2` to `1`.
- 2026-06-19: `CopySafetyCenterPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  safety hero, high-risk review, tab rail, verification tiers, trust metrics,
  guideline/tool/enforcement cards, and emergency-stop sheet. Fixed
  `DeviceMetrics` bottom usage, custom page gap bypass, copy-safety
  fixed-height/min-height/line-height tokens, regular vertical gap
  accumulation, horizontal icon/text gap pressure, bottom-nav inset pressure,
  and first-tabs visibility while preserving safety-center tabs, trust metric
  expansion, safe outgoing tool routes, emergency stop affordance, and back
  navigation. Added `SC-083 first viewport reaches safety tabs`. Focused
  `copy_safety_center_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeCopySafetyCenter` from score `61`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `1` to `0`, whole-app pass count moved from `113` to
  `114`, and trade P0 count moved from `1` to `0`.
- 2026-06-19: `AdvancedToolsDemoPage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact intro/tool/speed/benefit/progress cards, compact segmented actions,
  compact high-risk review, compact ladder/bulk/shortcut sheets, and compact
  success toast. Fixed `DeviceMetrics` bottom usage, root `fullBleed` and
  `customGap` rhythm, `VitPageSection` custom gap bypass, trade-tool
  vertical/horizontal gap tokens, fixed ladder row height token, manual panel
  density bypass, and first tool-card visibility while preserving ladder
  submit, bulk cancel, shortcut sheet, success toast, and back navigation.
  Added `SC-062 first viewport reaches first advanced tool`. Focused
  `advanced_tools_demo_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved `AppRoutePaths.tradeAdvancedTools`
  from score `59` `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`;
  whole-app P1 count moved from `32` to `31`, whole-app pass count moved from
  `114` to `115`, and trade P1 count moved from `12` to `11`.
- 2026-06-19: `CopyConfigurationPage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact provider/capital/mode/risk/fee/validation/summary cards, compact
  sticky confirmation footer, and capital-control first-viewport coverage.
  Fixed `DeviceMetrics` bottom usage, copy-configuration bottom-inset tokens,
  repeated primary gap tokens, fixed progress/divider/preset/button height
  tokens, wide inline/medium/small gap tokens, and card-density bypass while
  preserving provider lookup blank state, capital allocation, copy mode
  switching, risk toggles, fee preview, validation messages, confirmation
  route edge, and safe back-query handling. Added
  `SC-072 first viewport reaches capital field`. Focused
  `copy_configuration_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `'/trade/copy-provider/:providerId/configuration'` from score `59`
  `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P1 count
  moved from `31` to `30`, whole-app pass count moved from `115` to `116`,
  and trade P1 count moved from `11` to `10`.
- 2026-06-19: `ConvertPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact mode
  tabs/favorite pairs/rate bar, compact amount cards, compact tool chips,
  compact pair mini card, compact slippage controls, compact high-risk quote
  review, and first-favorite-pair viewport coverage. Fixed `DeviceMetrics`
  bottom usage, manual root `fullBleed/customGap=0` rhythm, root `SizedBox`
  spacing, tokenized fixed-height controls/cards/chips, `Spacer()` looseness,
  row-gap token pressure, and one render overflow in the quote amount card
  while preserving favorite pair selection, asset picker, swap action,
  percent/slippage state, submit receipt, back navigation, and Trade quick
  action edge. Added `SC-056 first viewport reaches first favorite pair`.
  Focused `convert_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `AppRoutePaths.tradeConvert` from score
  `59` `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P1
  count moved from `30` to `29`, whole-app pass count moved from `116` to
  `117`, and trade P1 count moved from `10` to `9`.
- 2026-06-19: `CopyTradingPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact hero,
  compact risk-review panels, compact provider cards, compact metric/chart
  sections, compact detail CTAs, and first-provider-card viewport coverage.
  Fixed `DeviceMetrics` bottom usage, root manual density bypass, copy-trading
  fixed-height/gap/line-height tokens, provider card padding, badge sizing,
  and bottom-nav inset pressure while preserving provider sorting, detail route
  navigation, risk disclosure, AUM/copier metrics, and Trade back navigation.
  Added `SC-063 first viewport reaches first provider card`. Focused
  `copy_trading_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeCopyTrading` from score `56`
  `P1_HIGH_DENSITY_REVIEW` to score `2` `PASS_MONITOR`; whole-app P1 count
  moved from `29` to `28`, whole-app pass count moved from `117` to `118`, and
  trade P1 count moved from `9` to `8`.
- 2026-06-19: `ComplaintTrackingPage` P1 was compacted across
  `AppRoutePaths.tradeCopyComplaintTrackingBase` and
  `'/trade/copy-trading/complaint-tracking/:complaintId'` with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact status/deadline/timeline/action rhythm, inline submitted/response
  deadline metrics, and first-timeline-step viewport coverage. Fixed
  `DeviceMetrics` bottom usage, root `VitContentPadding.none/fullBleed/customGap`
  bypass, `complaintTracking*` and `complaintCase*` fixed-height/padding/
  line-height token pressure, `Spacer()` looseness in metric cards, timeline
  connector height pressure, and bottom-nav inset pressure while preserving
  complaint ID routing, status/deadline visibility, timeline context, safety
  review before actions, ombudsman navigation, and regulatory complaint copy.
  Added `SC-113 first viewport reaches investigation timeline`. Focused
  `complaint_tracking_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved both complaint tracking routes from score
  `55` `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P1
  count moved from `26` to `24`, whole-app pass count moved from `120` to
  `122`, and trade P1 count moved from `8` to `6`.
- 2026-06-19: `MarginTradingHubPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact hero
  stats, compact navigation/menu cards, compact margin risk review, compact
  feature cards, compact compliance grid, and first-margin-action viewport
  coverage. Fixed `DeviceMetrics` bottom usage, root manual
  `VitContentPadding.none/fullBleed/customGap` bypass, screen-local
  `marginTradingHub*` fixed-height/gap/line-height token pressure, oversized
  wallet/trade-bot spacing reuse, menu-item min-height pressure, and
  bottom-nav inset pressure while preserving leverage/risk/liquidation/fee
  disclosure, margin workflow route edges, compliance banner, and back
  navigation. Added `SC-090 first viewport reaches first margin action`.
  Focused `margin_trading_hub_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved `AppRoutePaths.tradeMarginHub` from
  score `55` `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app
  P1 count moved from `24` to `23`, whole-app pass count moved from `122` to
  `123`, and trade P1 count moved from `6` to `5`.
- 2026-06-19: `TradeSettingsPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  settings sections/cards, compact choice chips, compact setting rows,
  compact toggle dimensions, compact reset/info surfaces, and first-order
  default control viewport coverage. Fixed `DeviceMetrics` bottom usage, root
  `VitContentPadding.none/fullBleed/customGap` bypass, `tradeBot*` fixed-height/
  gap/line-height token pressure, wallet-switch dimension reuse, and
  bottom-nav inset pressure while preserving order defaults, slippage controls,
  confirmation dependencies, feedback/display toggles, local reset behavior,
  and safety review above settings mutations. Added `SC-052 first viewport
  reaches order defaults controls`. Focused `trade_settings_page_test.dart`
  passed, focused `flutter analyze` passed, and `dart run
  tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeSettings` from score `55`
  `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P1 count
  moved from `23` to `22`, whole-app pass count moved from `123` to `124`, and
  trade P1 count moved from `5` to `4`.
- 2026-06-19: `CassReconciliationPage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact CASS safety review, compact summary counts, compact tabs, compact
  reconciliation record cards, compact ledger/bank/difference metric boxes,
  compact export CTA, and first-record viewport coverage. Fixed `DeviceMetrics`
  bottom usage, root `VitContentPadding.none/fullBleed/customGap` bypass,
  `tradeBot*` fixed-height/gap/line-height token pressure, summary/metric
  `Spacer()` looseness, and bottom-nav inset pressure while preserving
  client-money evidence, discrepancy status, CASS records, export framing, and
  back navigation. Added `SC-103 first viewport reaches first reconciliation
  record`. Focused `cass_reconciliation_page_test.dart` passed, focused
  `flutter analyze` passed, and `dart run
  tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.tradeCopyCassReconciliation` from
  score `55` `P1_HIGH_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app
  P1 count moved from `22` to `21`, whole-app pass count moved from `124` to
  `125`, and trade P1 count moved from `4` to `3`.
- 2026-06-19: `BotRiskDisclosurePage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact high-risk banner, compact risk review, compact past-performance
  disclaimer, compact risk category cards, compact additional warning and
  regulatory notice sections, compact acknowledgment CTA stack, and first-risk-
  category viewport coverage. Fixed `DeviceMetrics` bottom usage, root
  `VitContentPadding.none/fullBleed/customGap` bypass, `tradeBot*`
  fixed-height/gap/line-height token pressure, manual content-density bypass,
  and bottom-nav inset pressure while preserving high-risk warning, past
  performance disclaimer, MiFID/ESMA/SEC notice, acknowledgment gating,
  suitability navigation, and all risk category copy. Added `SC-118 first
  viewport reaches first risk category`. Focused
  `bot_risk_disclosure_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.tradeBotRiskDisclosure` from score `55`
  `P1_HIGH_DENSITY_REVIEW` to score `2` `PASS_MONITOR`; whole-app P1 count
  moved from `21` to `20`, whole-app pass count moved from `125` to `126`, and
  trade P1 count moved from `3` to `2`.

**Dependencies:** Task 3.1 can run in parallel after shared patterns exist  
**Likely files:** `flutter_app/lib/features/trade/`  
**Estimated scope:** M per batch

#### Task 3.3: Markets overview/signals archetype `[~]`

**Description:** Compact market overview, social signals, screener, alerts, and
analytics-heavy market screens.

**Initial route group:**

- `SocialSignalsPage`
- `MarketOverviewPage`
- `MarketScreenerPage`
- `PriceAlertsPage`
- other markets P0/P1/P2 rows from the matrix.

- 2026-06-19: `SocialSignalsPage` was compacted with shared compact density
  across the root scroll rhythm, disclaimer, tabs, filter chips, signal cards,
  expanded target detail, provider cards, performance summary, status
  breakdown, result rows, and empty state. Fixed relaxed/custom page rhythm,
  signal-card `Spacer()` usage, fixed chip/target/empty/status heights,
  custom `marketLineHeight*` pressure, and oversized vertical gaps while
  preserving status/category filters, signal expansion, provider/performance
  tabs, and back navigation to Markets. Added
  `SC-025 first viewport reaches the second signal card`. Focused
  `social_signals_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `AppRoutePaths.marketsSignals` from
  score `184` `P0_CRITICAL_DENSITY_REVIEW` to score `19`
  `P3_LOW_DENSITY_REVIEW`; whole-app P0 count moved from `52` to `51`,
  whole-app P3 count moved from `129` to `130`, and markets P0 count moved
  from `10` to `9`.
- 2026-06-19: `MarketOverviewPage` was compacted with shared compact density
  across the root scroll rhythm, market-cap hero, stat cards, sentiment cards,
  quick navigation, movers, sector rows, Fear & Greed history, tool cards, and
  review panel. Fixed relaxed content rhythm, fixed hero/stat/sentiment/mover/
  sector/history/tool heights, `Spacer()` usage in hero/stat/gauge content,
  custom `marketLineHeight*` pressure, and reordered quick navigation/movers
  above sentiment so the first viewport reaches actionable market navigation
  sooner. Added `SC-009 first viewport reaches market navigation cards`.
  Focused `market_overview_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved `AppRoutePaths.marketsOverview` from
  score `181` `P0_CRITICAL_DENSITY_REVIEW` to score `18`
  `P3_LOW_DENSITY_REVIEW`; whole-app P0 count moved from `51` to `50`,
  whole-app P3 count moved from `130` to `131`, and markets P0 count moved
  from `9` to `8`.
- 2026-06-19: `MarketScreenerPage` was compacted with shared compact content
  rhythm, compact advanced-filter card density, tighter preset/sort controls,
  compact result rows, and compact empty-state treatment. Fixed relaxed page
  rhythm, screen-local fixed height/gap pressure, line-height token pressure,
  and bottom-clearance text-heuristic pressure while preserving search,
  presets, category filters, sort toggles, result navigation, and reset
  behavior. Added `SC-015 first viewport reaches first screener result row`.
  Focused `market_screener_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved `AppRoutePaths.marketsScreener`
  from score `91` `P0_CRITICAL_DENSITY_REVIEW` to score `6`
  `PASS_MONITOR`; whole-app P0 count moved from `33` to `32`, pass/monitor
  count moved from `54` to `55`, and markets P0 count moved from `8` to `7`.
- 2026-06-19: `PriceAlertsPage` was compacted with route-local bounded
  scroll-end clearance, compact filter tabs, compact alert counters, compact
  alert cards, shorter progress bars, tighter add-alert notice/action spacing,
  and first-alert-card viewport protection. Fixed `DeviceMetrics` bottom
  usage, screen-local fixed height/gap pressure, `marketLineHeight*` token
  pressure, and bottom-clearance audit pressure while preserving filters,
  toggle/delete behavior, add notice, empty state, review section, and back
  navigation to Markets. Added `SC-014 first viewport reaches first alert
  card`. Focused `price_alerts_page_test.dart` passed, focused
  `flutter analyze` passed, and `dart run
  tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.marketsAlerts` from score `84`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `19` to `18`, pass/monitor count moved from `95` to `96`,
  and markets P0 count moved from `7` to `6`.
- 2026-06-19: `MarketNewsPage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  breaking-news card, compact category/sentiment chips, compact news cards,
  compact expanded-token details, compact empty state, and first-news-card
  viewport coverage. Fixed `DeviceMetrics` bottom usage, relaxed/custom page
  rhythm, `marketNews*` fixed-height/gap/line-height/padding token pressure,
  manual content-density bypass, and bottom-nav inset pressure while preserving
  breaking/category/sentiment filters, save/expand state, token navigation,
  market body review copy, and back navigation to Markets. Added `SC-022 first
  viewport reaches first news card`. Focused `market_news_page_test.dart`
  passed, focused `flutter analyze` passed, and `dart run
  tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.marketsNews` from score `56`
  `P1_HIGH_DENSITY_REVIEW` to score `9` `PASS_MONITOR`; whole-app P1 count
  moved from `28` to `27`, whole-app pass count moved from `118` to `119`, and
  markets P1 count moved down by `1`.
- 2026-06-19: `TokenInfoPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, tighter tab
  indicator rhythm, compact hero/market-stat/supply/distribution/record/chart
  cards, and compact on-chain/project/detail/disclaimer sections. Fixed
  `DeviceMetrics` bottom usage, relaxed/custom page rhythm, screen-local
  `tokenInfo*Height` and `tokenInfo*Gap` pressure, and bottom-clearance audit
  pressure while preserving overview/on-chain/project tabs, pair-detail back
  navigation, chart CTA navigation, and market/project copy separation. Added
  `SC-045 first viewport reaches market statistics card`. Focused
  `token_info_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `/pair/:pairId/info` from score `78`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `18` to `17`, pass/monitor count moved from `96` to `97`,
  and markets P0 count moved from `6` to `5`.
- 2026-06-19: `PortfolioTrackerPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, shorter tabs,
  compact total-value hero, compact quick stats/allocation/top holdings/risk
  sections, smaller donut/chart surfaces, and compact asset/performance tabs.
  Fixed `DeviceMetrics` bottom usage, relaxed/custom page rhythm,
  screen-local `portfolioTracker*Height` and `portfolioTracker*Gap` pressure,
  one spacer-driven PnL row, and bottom-clearance audit pressure while
  preserving balance masking, asset sorting, performance timeframe tabs,
  holding navigation, and back navigation to Markets. Added
  `SC-021 first viewport reaches first holding row`. Focused
  `portfolio_tracker_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `AppRoutePaths.marketsPortfolioTracker`
  from score `77` `P0_CRITICAL_DENSITY_REVIEW` to score `1`
  `PASS_MONITOR`; whole-app P0 count moved from `17` to `16`, pass/monitor
  count moved from `97` to `98`, and markets P0 count moved from `5` to `4`.
- 2026-06-19: `AdvancedChartsPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, shorter tabs,
  compact active-indicator chips, compact indicator cards/details, tighter
  drawing tools/tips/disclaimer cards, and compact technical-signal summaries.
  Fixed `DeviceMetrics` bottom usage, custom page gap rhythm,
  screen-local `marketAdvanced*Height`, `marketAnalytics*Gap`, and
  `marketLineHeight*` pressure, and bottom-clearance audit pressure while
  preserving indicator toggle/clear/filter behavior, drawing category filters,
  technical signal summaries, and back navigation to Markets. Added
  `SC-023 first viewport reaches first indicator card`. Focused
  `advanced_charts_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `AppRoutePaths.marketsAdvancedCharts`
  from score `75` `P0_CRITICAL_DENSITY_REVIEW` to score `1`
  `PASS_MONITOR`; whole-app P0 count moved from `16` to `15`, pass/monitor
  count moved from `98` to `99`, and markets P0 count moved from `4` to `3`.
- 2026-06-19: `SocialSentimentPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, shorter tabs,
  compact sentiment hero/stat/social-dominance/timeline cards, compact token
  rows/detail cards, and tighter trends topic/heatmap/leaderboard/velocity
  sections. Fixed `DeviceMetrics` bottom usage, relaxed/custom page rhythm,
  screen-local `socialSentiment*Height` and `socialSentiment*Gap` pressure,
  and bottom-clearance audit pressure while preserving sentiment tabs, token
  sort behavior, trends tab content, and back navigation to Markets. Added
  `SC-020 first viewport reaches sentiment timeline card`. Focused
  `social_sentiment_page_test.dart` passed, focused `flutter analyze` passed,
  and `dart run tool/visual_density_risk_audit.dart --check` passed. The
  official visual-density audit moved `AppRoutePaths.marketsSocialSentiment`
  from score `75` `P0_CRITICAL_DENSITY_REVIEW` to score `1`
  `PASS_MONITOR`; whole-app P0 count moved from `15` to `14`, pass/monitor
  count moved from `99` to `100`, and markets P0 count moved from `3` to `2`.
- 2026-06-19: `TokenUnlocksPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, shorter tabs,
  tighter hero/filter/list rhythm, compact unlock card detail gaps, compact
  analysis/category/dilution rows, and compact schedule/warning state rhythm.
  Fixed `DeviceMetrics` bottom usage, custom page gap rhythm,
  screen-local `tokenUnlocks*Height`, `tokenUnlocks*Gap`, and
  `tokenUnlocks*LineHeight` pressure, plus bottom-clearance audit pressure
  while preserving sort/filter behavior, card expansion, analysis tab,
  schedule tab, and back navigation to Markets. Added
  `SC-024 first viewport reaches first unlock card`. Focused
  `token_unlocks_page_test.dart` passed, focused `flutter analyze` passed, and
  `dart run tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.marketsUnlocks` from score `73`
  `P0_CRITICAL_DENSITY_REVIEW` to score `1` `PASS_MONITOR`; whole-app P0
  count moved from `14` to `13`, pass/monitor count moved from `100` to
  `101`, and markets P0 count moved from `2` to `1`.
- 2026-06-19: `MarketCorrelationsPage` was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, shorter tabs
  and timeframe/sort chips, compact matrix/info/insight/recommendation
  spacing, and compact diversification metric/progress rhythm. Fixed
  `DeviceMetrics` bottom usage, relaxed/custom page rhythm,
  screen-local `marketCorrelations*Height`, `marketCorrelations*Gap`, and
  `marketCorrelations*LineHeight` pressure, plus bottom-clearance audit
  pressure while preserving timeframe switching, pair sorting,
  diversification tab, and back navigation to Markets. Added
  `SC-026 first viewport reaches correlation matrix card`. Focused
  `market_correlations_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved `AppRoutePaths.marketsCorrelations`
  from score `69` `P0_CRITICAL_DENSITY_REVIEW` to score `1`
  `PASS_MONITOR`; whole-app P0 count moved from `13` to `12`, pass/monitor
  count moved from `101` to `102`, and markets P0 count moved from `1` to `0`.
- 2026-06-19: Focused Markets batch verification passed with
  `flutter test test/features/markets --reporter=compact` (`136` tests).

**Acceptance criteria:**

- [x] First viewport shows useful market data rows/cards.
- [x] Very high gap accumulation is reduced.
- [x] Charts or dense data surfaces use compact wrappers.
- [x] `MarketListPage` remains a pass/monitor reference.

**Verification:**

- [x] Focused markets tests.
- [ ] Emulator screenshot for overview/signals.
- [x] Density audit shows lower markets P0/P1.

**Dependencies:** Checkpoint 2  
**Likely files:** `flutter_app/lib/features/markets/`  
**Estimated scope:** M per batch

#### Task 3.4: Predictions event/tournament/portfolio archetype `[~]`

**Description:** Compact prediction event detail, tournaments, advanced chart,
and portfolio-related screens while keeping Prediction Markets language
separate from Arena.

**Initial route group:**

- `PredictionEventDetailPage`
- `PredictionAdvancedChartPage`
- `PredictionTournamentDetailPage`
- `PredictionTournamentsPage`
- `PredictionPortfolioAnalyzerPage`
- `PredictionDataIntegrationPage`

**Progress log:**

- 2026-06-19: `PredictionEventDetailPage` was compacted with shared compact
  density across the root scroll rhythm, first-viewport event header,
  probability cards, market metrics, high-risk review panel, chart, order book,
  trade controls, detail tabs, comments, holders/activity lists, related
  markets, and Arena bridge. The first viewport order is now event context ->
  market metrics -> risk review -> position/trade, preserving Prediction
  Markets copy and Arena Points separation before trade controls. Added
  `SC-030 first viewport reaches compact market metrics`. Verification passed:
  focused analyze, full `prediction_event_detail_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `136/P0 -> 11/P3`, fixed-height refs `9 -> 0`, vertical-gap refs `36 -> 0`,
  spacer refs `1 -> 0`, manual-content refs `2 -> 0`; whole-app P0 count moved
  from `50` to `49`, whole-app P3 count moved from `131` to `132`, and
  predictions P0 count moved from `13` to `12`.
- 2026-06-19: `PredictionAdvancedChartPage` was compacted as a tool-like chart
  screen with shared compact density for root content, tab bar, timeframe
  selector, probability summary, primary/volume chart cards, layer controls,
  RSI, indicators, order flow, support/resistance, pattern recognition, and
  the high-risk review panel. Added `SC-041 first viewport reaches the chart
  work area`. Verification passed: focused analyze,
  `prediction_advanced_chart_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `100/P0 -> 10/P3`, fixed-height refs `8 -> 0`, vertical-gap refs `7 -> 0`,
  manual-content refs `8 -> 0`; whole-app P0 count moved from `49` to `48`,
  whole-app P3 count moved from `132` to `133`, and predictions P0 count moved
  from `12` to `11`.
- 2026-06-19: `PredictionTournamentsPage` and
  `PredictionTournamentDetailPage` were compacted together because the detail
  route shares the tournament page and widget source bundle. The pass replaced
  custom page gaps with shared compact density, compacted the tab bar, featured
  block, tournament cards, joined-rank strip, stats grid rhythm, info/empty
  states, leaderboard rows, and detail hero, while removing Spacer-driven loose
  rows. Added first-viewport coverage for both the tournament list and scoped
  detail route. Verification passed: focused analyze, combined predictions
  focused tests for event detail, advanced chart, and tournaments, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `PredictionTournamentsPage 91/P0 -> 10/P3` and
  `PredictionTournamentDetailPage 91/P0 -> 10/P3`; both now have fixed-height,
  vertical-gap, spacer, and manual-content refs at `0`. Whole-app P0 count moved
  from `48` to `46`, whole-app P3 count moved from `133` to `135`, and
  predictions P0 count moved from `11` to `9`.
- 2026-06-19: `PredictionPortfolioAnalyzerPage` was compacted with shared
  compact density across root content, tab bar, portfolio summary, metric grid,
  category distribution, P/L chart, trade statistics, attribution rows, risk
  exposure, risk-by-category chart, diversification, and warning panel. Added
  `SC-038 first viewport reaches analyzer metrics`. Verification passed:
  focused analyze, `prediction_portfolio_analyzer_page_test.dart`, paired
  tournament/analyzer focused tests, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `83/P0 -> 10/P3`, fixed-height refs `5 -> 0`, vertical-gap refs `14 -> 0`,
  spacer refs `2 -> 0`, manual-content refs `2 -> 0`; whole-app P0 count moved
  from `46` to `45`, whole-app P3 count moved from `135` to `136`, and
  predictions P0 count moved from `9` to `8`.
- 2026-06-19: `PredictionDataIntegrationPage` was compacted with shared
  compact density across the sources overview, configured source cards, API key
  cards, webhook cards, CTA buttons, status/neutral chips, and notice cards.
  API key masking/reveal/copy behavior was preserved and covered by tests.
  Added `SC-043 first viewport reaches configured source content`.
  Verification passed: focused analyze, `prediction_data_integration_page_test.dart`,
  paired data/analyzer focused tests, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `86/P0 -> 11/P3`, fixed-height refs `7 -> 0`, vertical-gap refs `16 -> 0`,
  manual-content refs `2 -> 0`; whole-app P0 count moved from `45` to `44`,
  whole-app P3 count moved from `136` to `137`, and predictions P0 count moved
  from `8` to `7`.
- 2026-06-19: `PredictionsBreakingPage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact movement summary, compact category tabs, compact mover cards,
  compact email CTA, compact empty state, and first-mover-card viewport
  coverage. Fixed `DeviceMetrics` bottom usage, relaxed/custom page rhythm,
  `predictionBreaking*` fixed-height/gap/padding token pressure,
  `Spacer()`-driven summary looseness, manual content-density bypass, and
  bottom-nav inset pressure while preserving category filtering, local email
  subscription state, event-detail navigation, Prediction Markets wording, and
  back navigation. Added `SC-029 first viewport reaches first mover card`.
  Focused `predictions_breaking_page_test.dart` passed, focused
  `flutter analyze` passed, and `dart run
  tool/visual_density_risk_audit.dart --check` passed. The official
  visual-density audit moved `AppRoutePaths.marketsPredictionsBreaking` from
  score `56` `P1_HIGH_DENSITY_REVIEW` to score `7` `PASS_MONITOR`;
  whole-app P1 count moved from `27` to `26`, whole-app pass count moved from
  `119` to `120`, and predictions P1 count moved down by `1`.
- 2026-06-19: `PredictionsLeaderboardPage` P1 was compacted with route-local
  bounded scroll-end clearance, compact shared `VitPageContent` density,
  compact time filters, compact metric tabs, compact podium, compact ranking
  header/rows, compact biggest-win cards, and first-ranking-row viewport
  coverage. Fixed `DeviceMetrics` bottom usage, relaxed/custom page rhythm,
  `predictionLeaderboard*` fixed-height/gap/padding token pressure, manual
  content-density bypass, and bottom-nav inset pressure while preserving time
  filter state, P/L vs volume metric switching, P/L explanation sheet,
  biggest-win event navigation, leaderboard copy, and Prediction Markets
  wording. Added `SC-033 first viewport reaches the top ranking row`. Focused
  `predictions_leaderboard_page_test.dart` passed, focused `flutter analyze`
  passed, and `dart run tool/visual_density_risk_audit.dart --check` passed.
  The official visual-density audit moved
  `AppRoutePaths.marketsPredictionsLeaderboard` from score `55`
  `P1_HIGH_DENSITY_REVIEW` to score `6` `PASS_MONITOR`; whole-app P1 count
  moved from `20` to `19`, whole-app pass count moved from `126` to `127`, and
  predictions P1 count moved down by `1`.
- 2026-06-19: `PredictionSocialPage` was compacted with shared compact density
  across root content, tab bar, event summary, comment composer, comment cards,
  disclaimer, sentiment analysis, contributor rows, share/copy cards, share
  metrics, preview, and social support widgets. Added `SC-040 first viewport
  reaches comment composer`. Verification passed: focused analyze,
  `prediction_social_page_test.dart`, paired social/data focused tests, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `80/P0 -> 10/P3`, fixed-height refs `6 -> 0`, vertical-gap refs `15 -> 0`,
  manual-content refs `2 -> 0`; whole-app P0 count moved from `44` to `43`,
  whole-app P3 count moved from `137` to `138`, and predictions P0 count moved
  from `7` to `6`.
- 2026-06-19: `PredictionOrderReceiptPage` was compacted with shared compact
  density across receipt content, hero, financial summary, progress, timeline,
  disclosure, share button, and CTA actions. The fee summary was promoted into
  the first viewport before secondary contract-status content, preserving
  receipt fee/risk disclosure and safe portfolio/event navigation. Added
  `SC-035 first viewport reaches fee summary`. Verification passed: focused
  analyze, `prediction_order_receipt_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `74/P0 -> 10/P3`, fixed-height refs `2 -> 0`, vertical-gap refs `7 -> 0`,
  spacer refs `1 -> 0`, manual-content refs `2 -> 0`; whole-app P0 count moved
  from `43` to `42`, whole-app P3 count moved from `138` to `139`, and
  predictions P0 count moved from `6` to `5`.
- 2026-06-19: `PredictionMarketMakerPage` was compacted with shared compact
  density across root content, tab bar, provide form, liquidity overview,
  spread selector, add-liquidity button, warning card, positions, earnings
  chart, and analysis rows. The liquidity amount label now appears in the
  first viewport before secondary overview content, while amount/spread inputs
  and local tab behavior remain unchanged. Added `SC-037 first viewport reaches
  liquidity amount input`. Verification passed: focused analyze,
  `prediction_market_maker_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `74/P0 -> 10/P3`, fixed-height refs `4 -> 0`, vertical-gap refs `15 -> 0`,
  manual-content refs `2 -> 0`; whole-app P0 count moved from `42` to `41`,
  whole-app P3 count moved from `139` to `140`, and predictions P0 count moved
  from `5` to `4`.
- 2026-06-19: `PredictionsHomePage` was compacted with shared compact density
  across root content, filter tabs, category chips, shortcut cards, Arena bridge
  copy, event cards, probability bars, outcome actions, stats rows, and empty
  state. The high-risk contract panel was moved below the compact shortcut
  cluster so the first viewport reaches actionable prediction content without
  weakening Prediction/Open Arena copy boundaries. Added `SC-027 first viewport
  previews prediction action cards`. Verification passed: focused analyze,
  `predictions_home_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `73/P0 -> 12/P3`, fixed-height refs `5 -> 0`, vertical-gap refs `10 -> 0`,
  spacer refs `1 -> 0`, manual-content refs `2 -> 0`; whole-app P0 count moved
  from `41` to `40`, whole-app P3 count moved from `140` to `141`, and
  predictions P0 count moved from `4` to `3`.
- 2026-06-19: `PredictionRiskCalculatorPage` was compacted with shared compact
  density across root content, tab bar, position input form, outcome toggles,
  position summary, risk analysis, Kelly recommendation, warning card,
  scenarios, guide cards, and metric rows. Added `SC-036 first viewport reaches
  position input fields`. Risk/reward, max loss/gain, expected value, and Kelly
  calculations were preserved. Verification passed: focused analyze,
  `prediction_risk_calculator_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `65/P0 -> 10/P3`, fixed-height refs `3 -> 0`, vertical-gap refs `12 -> 0`,
  manual-content refs `2 -> 0`; whole-app P0 count moved from `40` to `39`,
  whole-app P3 count moved from `141` to `142`, and predictions P0 count moved
  from `3` to `2`.
- 2026-06-19: `PredictionsRewardsPage` was compacted with shared compact
  density across root content, hero, how-it-works note, category/favorites
  filters, rewards table header/rows, risk disclosure link, risk sheet, and
  Arena bridge. Added `SC-032 first viewport reaches reward table row`.
  Prediction reward copy and the `ARENA POINTS ONLY` bridge/disclaimer were
  preserved. Verification passed: focused analyze,
  `predictions_rewards_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `64/P0 -> 10/P3`, fixed-height refs `10 -> 0`, vertical-gap refs `1 -> 0`,
  manual-content refs `2 -> 0`; whole-app P0 count moved from `39` to `38`,
  whole-app P3 count moved from `142` to `143`, and predictions P0 count moved
  from `2` to `1`.
- 2026-06-19: `PredictionEventCalendarPage` was compacted with shared compact
  density across root content, tab bar, category chips, stats, calendar event
  cards, notification settings, watched-event cards, and helper metric cells.
  Added `SC-039 first viewport reaches first calendar event`. Navigation,
  category filters, upcoming/notification tabs, watched-event copy, and
  prediction-market probability/volume semantics were preserved. Verification
  passed: focused analyze, `prediction_event_calendar_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `61/P0 -> 10/P3`, fixed-height refs `3 -> 0`, vertical-gap refs `8 -> 0`,
  spacer refs `1 -> 0`, manual-content refs `2 -> 0`; whole-app P0 count
  moved from `38` to `37`, whole-app P3 count moved from `143` to `144`, and
  predictions P0 count moved from `1` to `0`.

**Acceptance criteria:**

- [!] Event detail first viewport shows event context, probability/position
      summary, and primary action or next section.
- [x] Very high gap accumulation is reduced.
- [x] Prediction copy keeps positions/probability/P/L semantics.
- [x] Arena points language is not introduced.

**Verification:**

- [~] `flutter test test/features/predictions --reporter=compact`
- [x] Product copy review.
- [ ] Emulator screenshot for event detail.

**Dependencies:** Checkpoint 2  
**Likely files:** `flutter_app/lib/features/predictions/`  
**Estimated scope:** M per batch

#### Checkpoint 3: Critical Modules Reduced

- [x] Trade P0/P1 count materially reduced; current regular P0/P1 is zero.
- [x] Markets P0/P1 count materially reduced; current markets P0/P1 is zero.
- [x] Predictions P0/P1 count materially reduced; current predictions P0/P1 is zero.
- [x] New compact primitives prove reusable across trade, markets,
      predictions, profile, wallet, arena, DCA, launchpad, P2P, earn, home,
      news, and referral slices.

### Phase 4: Financial And Cross-Module Expansion

Goal: apply the proven compact patterns to high-safety and cross-module flows.

#### Task 4.1: Wallet health, gas, and security surfaces `[~]`

**Initial route group:**

- `WalletGasOptimizerPage`
- `WalletHealthScorePage`
- wallet P1/P2 routes from the matrix.

**Acceptance criteria:**

- [x] Financial summaries use compact key-value rows.
- [x] Fee/risk/limit/masking remain visible.
- [!] Sticky footer or bottom CTA does not hide required content.

**Verification:**

- [~] Focused wallet tests.
- [~] Emulator screenshot for one wallet P0 route.
- [x] Density audit.

**Dependencies:** Task 1.4  
**Likely files:** `flutter_app/lib/features/wallet/`  
**Estimated scope:** M

**Progress log:**

- 2026-06-19: `WalletHealthScorePage` was compacted with shared compact
  density across root content, tab bar, overall score summary, health gauge,
  radar card, metric cards, trend chart, recommendations, security checklist,
  diversification chart, concentration risk, tips, info cards, and the
  recommendation bottom sheet. Added `SC-151 first viewport reaches first
  health metric`. Wallet health score, risk categories, security checklist,
  diversification guidance, and recommendation actions were preserved.
  Verification passed: focused analyze, `wallet_health_score_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `96/P0 -> 5/PASS_MONITOR`, fixed-height refs `6 -> 0`, vertical-gap refs
  `10 -> 0`, manual-content refs `9 -> 0`; whole-app P0 count moved from `35`
  to `34`, whole-app pass/monitor count moved from `52` to `53`, and wallet P0
  count moved from `3` to `2`.
- 2026-06-19: `WalletGasOptimizerPage` was compacted with shared compact
  density across root content, gas tabs, current gas status, speed cards,
  transaction comparison rows, refresh action, trend charts, best-time card,
  tips, quick actions, and savings footer. Added `SC-149 first viewport reaches
  gas comparison fee row`. Current gas percentage, recommended speed, Gwei/USD
  fee estimates, transaction comparison fees, trends, and gas-saving tips were
  preserved. Verification passed: focused analyze,
  `wallet_gas_optimizer_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `96/P0 -> 5/PASS_MONITOR`, fixed-height refs `8 -> 0`, vertical-gap refs
  `11 -> 0`, spacer refs `3 -> 0`, manual-content refs `5 -> 0`; whole-app P0
  count moved from `34` to `33`, whole-app pass/monitor count moved from `53`
  to `54`, and wallet P0 count moved from `2` to `1`.
- 2026-06-19: `PortfolioAnalyticsPage` was compacted with shared compact
  density across root content, portfolio value summary, view switcher, period
  selector, responsive overview chart, metrics, asset rows, and scroll-end
  clearance. Added `SC-142 first viewport reaches period selector controls`.
  Portfolio value, P/L, allocation, risk metrics, and financial summary copy
  were preserved. Verification passed: focused analyze,
  `portfolio_analytics_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `61/P0 -> 2/PASS_MONITOR`, fixed-height refs `6 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `6 -> 0`; whole-app P0 count
  moved from `27` to `26`, whole-app pass/monitor count moved from `60` to
  `61`, and wallet P0 count moved from `1` to `0`.
- 2026-06-19: `AssetDetailPage` was compacted with shared compact page rhythm,
  route-local hero/chart/action/stat extents, bounded scroll-end clearance,
  compact asset actions, compact stat pills, compact chart period chips, and
  compact transaction rows. Removed tokenized fixed-height refs, section gap
  stack, `Spacer()` looseness, and manual transaction content gap while
  preserving deposit/withdraw/transfer/DCA actions, price chart periods,
  transaction-detail navigation, balances, change percentage, and Wallet shell
  navigation. Added `SC-147 first viewport reaches first transaction row`.
  Verification passed: focused analyze, `asset_detail_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `59/P1 -> 9/PASS_MONITOR`, fixed-height refs `4 -> 0`, tokenized-gap refs
  `8 -> 0`, spacer refs `2 -> 0`, manual-content refs `2 -> 0`,
  bottom-inset refs `6 -> 4`; whole-app P1 count moved from `48` to `47`,
  whole-app pass/monitor count moved from `84` to `85`, and wallet P1 count
  moved from `11` to `10`.
- 2026-06-19: `NetworkStatusPage` was compacted with shared compact page
  rhythm, compact high-risk network review panel, compact summary card,
  route-local network/stat/action/legend extents, compact network cards,
  compact availability chips, and compact legend/disclaimer copy. Removed the
  explicit section `SizedBox` stack, old wallet bottom-inset formula,
  tokenized fixed-height refs, and manual `customGap` bypass while preserving
  refresh, network health, block height, congestion percentage/bar,
  deposit/withdraw availability, maintenance note, legend, and wallet back
  navigation. Added `SC-155 first viewport reaches first network card`.
  Verification passed: focused analyze, `network_status_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `54/P1 -> 10/P3_LOW_DENSITY_REVIEW`, fixed-height refs `3 -> 0`,
  tokenized-gap refs `13 -> 0`, manual-content refs `1 -> 0`,
  bottom-inset refs `6 -> 4`; whole-app P1 count moved from `47` to `46`,
  whole-app P3 count moved from `145` to `146`, and wallet P1 count moved from
  `10` to `9`.
- 2026-06-19: `PendingDepositsPage` was compacted with shared compact page
  rhythm, compact high-risk pending-deposit panel, route-local bounded
  scroll-end clearance, compact summary/filter chips, compact deposit cards,
  compact confirmation progress, compact TxHash details, and compact
  info/empty states. Removed old wallet bottom-inset formula, tokenized
  fixed-height refs, vertical `SizedBox` stack, `Spacer()` looseness in TxHash,
  and manual content-gap pressure while preserving pending/done filters, copy
  action feedback, confirmation counts, credited/failed risk states, deposit
  amount/network/hash details, minimum-deposit notice, and Wallet back
  navigation. Added `SC-152 first viewport reaches first pending deposit`.
  Verification passed: focused analyze, `pending_deposits_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `54/P1 -> 9/PASS_MONITOR`, fixed-height refs `2 -> 0`, tokenized-gap refs
  `13 -> 0`, spacer refs `1 -> 0`, manual-content refs `1 -> 0`,
  bottom-inset refs `6 -> 4`; whole-app P1 count moved from `46` to `45`,
  whole-app pass/monitor count moved from `85` to `86`, and wallet P1 count
  moved from `9` to `8`.
- 2026-06-19: `WithdrawLimitsPage` was compacted with shared compact page
  rhythm, route-local bounded scroll-end clearance, compact current-tier
  summary, compact limit progress bars, compact quick stats, compact KYC tier
  rows, compact warning/FAQ cards, and compact high-risk review panel. Removed
  old bottom-chrome formula, manual content gap bypass, tokenized fixed-height
  tier/stat refs, and the vertical `SizedBox` stack while preserving KYC
  upgrade navigation, daily/monthly/single-transaction limits, remaining quota,
  manual-review and video-call threshold copy, FAQ content, and Wallet back
  navigation. Added `SC-153 first viewport reaches first KYC tier`.
  Verification passed: focused analyze, `withdraw_limits_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `51/P1 -> 9/PASS_MONITOR`, fixed-height refs `1 -> 0`, tokenized-gap refs
  `17 -> 0`, manual-content refs `1 -> 0`, bottom-inset refs `4 -> 4`;
  whole-app P1 count moved from `45` to `44`, whole-app pass/monitor count
  moved from `86` to `87`, and wallet P1 count moved from `8` to `7`.
- 2026-06-19: `TransactionDetailPage` was compacted with shared compact page
  rhythm, route-local bounded scroll-end clearance, compact summary/progress
  cards, compact transaction detail rows, compact explorer/support actions,
  and compact missing-transaction fallback. Removed old bottom-chrome formula,
  manual content gap bypass, tokenized fixed-height refs, and vertical section
  gap pressure while preserving transaction amount/status, progress timeline,
  copy TxID action, explorer affordance, support routing, and Wallet back
  navigation. Added `SC-141 first viewport reaches TxID copy action`.
  Verification passed: focused analyze, `transaction_detail_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `50/P1 -> 13/P3_LOW_DENSITY_REVIEW`, fixed-height refs `5 -> 0`,
  tokenized-gap refs `8 -> 0`, manual-content refs `1 -> 0`,
  bottom-inset refs `6 -> 4`; whole-app P1 count moved from `44` to `43`,
  whole-app P3 count moved from `146` to `147`, and wallet P1 count moved from
  `7` to `6`.
- 2026-06-19: `AddressBookPage` was compacted with shared compact page rhythm,
  route-local bounded scroll-end clearance, compact search/filter/stat rhythm,
  compact whitelist/security cards, compact saved-address cards, and compact
  copy/favorite/edit/delete action row. Removed the old bottom-chrome formula,
  manual content gap bypass, tokenized fixed-height refs, vertical gap pressure,
  and `Spacer()` looseness while preserving add-address navigation, network
  filters, whitelist-only toggle, favorite state, copy action, delete
  confirmation, empty state, and wallet shell navigation. Added
  `SC-144 first viewport reaches first address copy action`. Verification
  passed: focused analyze, `address_book_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `49/P1 -> 10/P3_LOW_DENSITY_REVIEW`, fixed-height refs `6 -> 0`,
  tokenized-gap refs `6 -> 0`, spacer refs `1 -> 0`, manual-content refs
  `1 -> 0`, bottom-inset refs `4 -> 4`; whole-app P1 count moved from `43` to
  `42`, whole-app P3 count moved from `147` to `148`, and wallet P1 count moved
  from `6` to `5`.
- 2026-06-19: `TransactionHistoryPage` was compacted with shared compact page
  rhythm, route-local bounded scroll-end clearance, compact export bar,
  compact filter chips, compact date group headers, compact transaction rows,
  compact amount/status column, and compact end-of-list marker. Removed the old
  bottom-chrome formula, manual content gap bypass, and vertical gap pressure
  while preserving export notice, filters, transaction detail navigation,
  grouped dates, amount/status/fee/network/hash details, and wallet shell
  navigation. Added `SC-136 first viewport reaches first transaction row`.
  Verification passed: focused analyze, `transaction_history_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `48/P1 -> 23/P3_LOW_DENSITY_REVIEW`, tokenized-gap refs `5 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `6 -> 4`; whole-app P1 count
  moved from `42` to `41`, whole-app P3 count moved from `148` to `149`, and
  wallet P1 count moved from `5` to `4`.
- 2026-06-19: `DustConverterPage` was compacted with shared compact page
  rhythm, route-local footer/bottom clearances, compact high-risk review and
  hero rhythm, compact target selector, compact select-all control, compact
  dust asset rows, compact sticky/inline CTA, and compact confirmation sheet
  preview. Removed old `DeviceMetrics` bottom usage, manual content gap bypass,
  tokenized fixed-height refs, vertical gap pressure, and bottom-inset pressure
  while preserving target selection, select-all, eligible asset toggles,
  conversion preview, fees, confirm action, success banner, and wallet shell
  navigation. Added `SC-154 first viewport reaches first dust asset row`.
  Verification passed: focused analyze, `dust_converter_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `48/P1 -> 2/PASS_MONITOR`, fixed-height refs `5 -> 0`, tokenized-gap refs
  `10 -> 0`, manual-content refs `1 -> 0`, bottom-inset refs `3 -> 0`;
  whole-app P1 count moved from `41` to `40`, whole-app pass/monitor count
  moved from `87` to `88`, and wallet P1 count moved from `4` to `3`.
- 2026-06-19: `TransferPage` was compacted with shared compact page rhythm,
  route-local bounded scroll-end clearance, compact source/destination wallet
  rows, compact swap control, compact asset and amount cards, compact info
  notice, compact CTA, compact confirmation sheet, and compact recent-transfer
  rows. Removed the old bottom-chrome formula, manual content gap bypass, and
  vertical gap pressure while preserving wallet swap, asset selection, max
  amount fill, USD preview, free-fee confirmation sheet, success state, recent
  transfers, and wallet shell navigation. Added
  `SC-146 first viewport reaches transfer amount field`. Verification passed:
  focused analyze, `transfer_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `46/P1 -> 19/P3_LOW_DENSITY_REVIEW`, tokenized-gap refs `9 -> 0`,
  manual-content refs `2 -> 1`, bottom-inset refs `6 -> 4`; whole-app P1 count
  moved from `40` to `39`, whole-app P3 count moved from `149` to `150`, and
  wallet P1 count moved from `3` to `2`.
- 2026-06-19: `DepositPage` was compacted across both wallet deposit routes
  with shared compact page rhythm, route-local bounded scroll-end clearance,
  compact network selector, compact safety/status copy, compact high-risk
  warning card, compact QR/address/copy card, compact deposit info rows,
  compact refresh action, and compact network picker rows. Removed the old
  bottom-chrome formula, manual content gap bypass, tokenized fixed-height
  refs, and vertical gap pressure while preserving wrong-network warnings,
  min-deposit/confirmation details, QR address, copy action, network switching,
  asset route behavior, and wallet shell navigation. Added
  `SC-137 first viewport reaches copy address action`. Verification passed:
  focused analyze, `deposit_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result for both
  `AppRoutePaths.walletDeposit` and `'${AppRoutePaths.walletDeposit}/:asset'`:
  `45/P1 -> 9/PASS_MONITOR`, fixed-height refs `3 -> 0`, tokenized-gap refs
  `9 -> 0`, manual-content refs `1 -> 0`, bottom-inset refs `6 -> 4`;
  whole-app P1 count moved from `39` to `37`, whole-app pass/monitor count
  moved from `88` to `90`, and wallet P1 count moved from `2` to `0`.

#### Task 4.2: Arena production/foundation/challenge surfaces `[~]`

**Initial route group:**

- `ArenaProductionReadyPage`
- `ArenaPredictionBridgeFoundationPage`
- `ConnectedEcosystemProductionPage`
- Arena P2 challenge/detail routes from the matrix.

**Acceptance criteria:**

- [x] Tall informational surfaces use compact sections.
- [x] Arena remains points-only.
- [!] Shared challenge/detail compact sections are reused.

**Verification:**

- [~] `flutter test test/features/arena --reporter=compact`
- [x] Copy boundary check.
- [x] Density audit.

**Dependencies:** Task 2.3  
**Likely files:** `flutter_app/lib/features/arena/`  
**Estimated scope:** M

**Progress log:**

- 2026-06-19: `ArenaChallengeDetailPage` was compacted with shared compact
  page rhythm, route-local bounded scroll-end clearance, compact challenge
  intro/live status/review cards, compact team/rule/governance panels, compact
  tabs/action stack, and compact sheet spacing. Removed old `DeviceMetrics`
  bottom usage, manual content gap bypass, tokenized fixed-height refs, and
  broad `arenaChallenge*` fixed-size pressure while preserving points-only
  review copy, creator/safety/prediction navigation, tabs, evidence/report/block
  sheets, Open Arena warnings, and canonical Arena route behavior. Added
  `SC-190 first viewport reaches live points summary`. Verification passed:
  focused analyze, `arena_challenge_detail_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `56/P1 -> 9/PASS_MONITOR`, fixed-height refs `14 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `4 -> 4`; whole-app P1 count
  moved from `37` to `36`, whole-app pass/monitor count moved from `90` to
  `91`, and arena P1 count moved from `5` to `4`.
- 2026-06-19: `ArenaSafetyCenterPage` was compacted with shared compact page
  and card density, route-local bounded scroll-end clearance, compact safety
  hero/rule/info/process/quick-link rows, and first-community-rule viewport
  protection. Removed old `DeviceMetrics` bottom usage, manual content gap
  bypass, route `arenaSafety*Height` pressure, and bottom-inset audit pressure
  while preserving Open Arena safety rules, banned-content guidance, report and
  block routes, violation process, points-only disclaimer, and acknowledge
  return behavior. Added `SC-198 first viewport reaches first community rule`.
  Verification passed: focused analyze, `arena_safety_center_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `45/P1 -> 2/PASS_MONITOR`, fixed-height refs `10 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `4 -> 0`; whole-app P1 count
  moved from `36` to `35`, whole-app pass/monitor count moved from `91` to
  `92`, and arena P1 count moved from `4` to `3`.
- 2026-06-19: `ArenaReportCasePage` was compacted with shared compact page and
  card density, route-local bounded scroll-end clearance, compact report review
  state, case summary, reason, timeline, system note, appeal, related-report,
  disclaimer, and linked-action sections. Removed old `DeviceMetrics` bottom
  usage, manual content gap bypass, route `arenaReport*Height` pressure, and
  bottom-inset audit pressure while preserving not-found handling, valid report
  details, challenge/report routing, appeal submission state, moderation copy,
  and points-only disclaimer. Added `SC-202 first viewport reaches report
  review state`. Verification passed: focused analyze,
  `arena_report_case_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `43/P1 -> 1/PASS_MONITOR`, fixed-height refs `9 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `4 -> 0`; whole-app P1 count
  moved from `35` to `34`, whole-app pass/monitor count moved from `92` to
  `93`, and arena P1 count moved from `3` to `2`.
- 2026-06-19: `ArenaLeaderboardPage` was compacted with shared compact page
  density, route-local bounded scroll-end clearance, compact my-rank hero,
  filter/season controls, smaller podium, compact creator rows, compact
  placeholder state, and compact footer disclosure. Removed old `DeviceMetrics`
  bottom usage, manual content gap bypass, route `arenaLeaderboard*Height`
  pressure, and bottom-inset audit pressure while preserving creators/players/
  teams tabs, Fair Play and season filters, creator navigation, rules route,
  and Arena Points-only disclaimer. Added `SC-194 first viewport reaches first
  creator row`. Verification passed: focused analyze,
  `arena_leaderboard_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `41/P1 -> 1/PASS_MONITOR`, fixed-height refs `9 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `4 -> 0`; whole-app P1 count
  moved from `34` to `33`, whole-app pass/monitor count moved from `93` to
  `94`, and arena P1 count moved from `2` to `1`.
- 2026-06-19: `ArenaFlowMapPage` was compacted with shared compact page and
  card density, route-local bounded scroll-end clearance, compact module hero,
  route registry, flow groups, shared component cards, handoff notes, QA
  checklist, disclaimer, and route-row viewport protection. Removed old
  `DeviceMetrics` bottom usage, manual content gap bypass, route
  `arenaFlowMap*Height` pressure, and bottom-inset audit pressure while
  preserving flow/handoff/QA collapsible sections, check-all behavior,
  canonical route navigation, route registry, and points-only/trading-boundary
  disclaimer. Added `SC-197 first viewport reaches first route registry row`.
  Verification passed: focused analyze, `arena_flow_map_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `41/P1 -> 1/PASS_MONITOR`, fixed-height refs `9 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `4 -> 0`; whole-app P1 count
  moved from `33` to `32`, whole-app pass/monitor count moved from `94` to
  `95`, and arena P1 count moved from `1` to `0`. Current Arena matrix:
  P0 `0`, P1 `0`, P2 `11`, P3 `4`, PASS_MONITOR `11`.
- 2026-06-19: Arena batch verification passed after the P1 cleanup:
  `flutter test test/features/arena --reporter=compact` passed (`122` tests).
  Copy-boundary scan over the touched Arena safety/report/leaderboard/flow-map
  files found no wallet, payout, profit, stake, cash, USD, PnL, or P/L terms.

- 2026-06-19: `ArenaProductionReadyPage` was compacted with shared compact
  density across root content, release-readiness hero, section tabs, canonical
  screen cards, state matrix, flows, registry, handoff boards, dictionary
  lines, component lines, status pills, and internal-only footer. Added
  `SC-206 first viewport reaches first canonical screen card`. Open Arena
  stayed internal/points-only; no wallet, payout, profit, or stake-return copy
  was introduced. Verification passed: focused analyze,
  `arena_production_ready_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `106/P0 -> 6/PASS_MONITOR`, fixed-height refs `22 -> 0`,
  manual-content refs `6 -> 0`; whole-app P0 count moved from `37` to `36`,
  whole-app pass/monitor count moved from `51` to `52`, and Arena P0 count
  moved from `4` to `3`.
- 2026-06-19: `ArenaPredictionBridgeFoundationPage` was compacted with shared
  compact density across root content, bridge hero, section tabs, principle
  cards, topic/boundary/bridge/example sections, demo frames, stat buttons, and
  disclosure footer. Replaced route-local bottom-chrome budgeting with bounded
  scroll clearance, removed custom section gaps, fixed line-height/min-height
  token pressure, and preserved Prediction Markets/Open Arena separation.
  Added `SC-207 first viewport reaches first bridge principle`. Verification
  passed: focused analyze, `arena_prediction_bridge_foundation_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `86/P0 -> 1/PASS_MONITOR`, fixed-height refs `19 -> 0`, manual-content refs
  `4 -> 0`, bottom-inset refs `4 -> 0`; whole-app P0 count moved from `30` to
  `29`, whole-app pass/monitor count moved from `57` to `58`, and Arena P0
  count moved from `3` to `2`.
- 2026-06-19: `ConnectedEcosystemProductionPage` was compacted with shared
  compact density across root content, release-readiness hero, section tabs,
  canonical screen cards, summary metrics, bridge-state cards, E2E flow cards,
  shared/separate registry boards, forbidden pattern cards, handoff boards, and
  footer disclosure. Replaced route-local bottom-chrome budgeting with bounded
  scroll clearance, removed manual section gaps, tab/board-chip min-height
  pressure, and line-height/fixed-height token pressure while preserving
  Prediction Markets/Open Arena boundaries. Added `SC-208 first viewport
  reaches first canonical screen card`. Verification passed: focused analyze,
  `connected_ecosystem_production_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `84/P0 -> 3/PASS_MONITOR`, fixed-height refs `16 -> 0`, manual-content refs
  `5 -> 0`, bottom-inset refs `4 -> 0`; whole-app P0 count moved from `29` to
  `28`, whole-app pass/monitor count moved from `58` to `59`, and Arena P0
  count moved from `2` to `1`.
- 2026-06-19: `ArenaHomePage` was compacted as the Open Arena root hub with
  shared compact root content, bounded scroll clearance, compact intro/search
  rhythm, smaller hero hierarchy, compact template cards, mode cards, live-room
  rows, creator cards, Prediction bridge, verified teaser, footer, and search
  rows. Removed screen-local bottom inset naming, custom root gap, tokenized
  fixed-height/line-height pressure, template-card `Spacer`, and tall
  min-height constraints while preserving Arena Points-only copy and Prediction
  Markets context-only bridge language. Added `SC-184 first viewport reaches
  first arena template card`. Verification passed: focused analyze,
  `arena_home_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `61/P0 -> 4/PASS_MONITOR`, fixed-height refs `12 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `6 -> 0`; whole-app P0 count
  moved from `28` to `27`, whole-app pass/monitor count moved from `59` to
  `60`, and Arena P0 count moved from `1` to `0`.

#### Task 4.3: DCA, Launchpad, P2P, Earn P0/P1 passes `[x]`

**Initial route group:**

- DCA: `DCAPage` and DCA P0/P1 rows.
- Launchpad: P0/P1 rows from the matrix.
- P2P: 4 P0, 6 P1, and 1 tool route from the matrix.
- Earn: `SavingsLadderPage` and 7 P1 rows.

**Acceptance criteria:**

- [x] Each feature's P0 routes are resolved or documented.
- [x] Financial safety flows retain confirmations and risk/fee/limit copy.
- [x] Broad P2/P3 queues are left as tracked follow-up, not silently ignored.

**Verification:**

- [x] Focused feature tests per touched module.
- [x] Density audit.
- [x] Emulator sample for at least one financial flow.

**Dependencies:** Checkpoint 3  
**Likely files:** `flutter_app/lib/features/dca/`, `launchpad/`, `p2p/`, `earn/`  
**Estimated scope:** M per feature batch

**Progress log:**

- 2026-06-19: `DCAPage` was compacted with shared compact density across root
  content, overview hero, current-value sparkline, overview metrics, next
  purchase row, overview actions, tabs, plan cards, plan metrics, history
  panel, create-plan sheet, and advanced tool cards. Advanced tools were moved
  below the primary plan workflow so the first viewport reaches the user's DCA
  plans instead of secondary utilities. Added `SC-169 first viewport reaches
  first DCA plan`. DCA financial context, next purchase timing, invested value,
  holdings, P/L, create/pause/history navigation, and tool routes were
  preserved. Verification passed: focused analyze, `dca_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `102/P0 -> 14/P3`, fixed-height refs `22 -> 0`, spacer refs `2 -> 0`,
  manual-content refs `2 -> 0`; whole-app P0 count moved from `36` to `35`,
  whole-app P3 count moved from `144` to `145`, and DCA P0 count moved from
  `3` to `2`.
- 2026-06-19: `DCARebalanceConfig` was compacted across the shared create/edit
  route pair with compact root content, card padding, target allocation cards,
  strategy controls, advanced settings, inline preview/save actions, and the
  preview confirmation sheet. Removed screen-local bottom-clearance naming,
  relaxed/custom content rhythm, tokenized fixed-height/line-height pressure,
  and `Spacer()` looseness while preserving target allocation editing,
  threshold/frequency strategy, auto-execute warning copy, fee preview, disabled
  save state, and confirmation-to-dashboard flow. Added `SC-170 first viewport
  reaches first allocation slider`. Verification passed: focused analyze,
  `dca_rebalance_config_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  both `AppRoutePaths.dcaRebalanceConfig` and `'/dca/rebalance/:configId/edit'`
  moved `65/P0 -> 6/PASS_MONITOR`, fixed-height refs `5 -> 0`, spacer refs
  `3 -> 0`, manual-content refs `4 -> 0`, bottom-inset refs `6 -> 0`;
  whole-app P0 count moved from `26` to `24`, whole-app pass/monitor count
  moved from `61` to `63`, and DCA P0 count moved from `2` to `0`.
- 2026-06-19: `DCAPortfolioOptimizer` was compacted with bounded scroll-end
  clearance, shared compact content density, compact drift banner, earlier
  optimizer tabs, compact comparison hero, shorter frontier/backtest charts,
  compact chip list, compact selected-portfolio/suggestions/risk panels, and
  route-local density constants. Removed screen-local bottom inset pressure,
  root `customGap` rhythm, and tokenized fixed-height/line-height pressure
  while preserving drift settings/dismissal, portfolio score, allocation
  comparison, frontier/correlation/backtest/risk tabs, apply-allocation route,
  and financial risk disclaimer copy. Added `SC-174 first viewport reaches
  optimizer tabs`. Verification passed: focused analyze,
  `dca_portfolio_optimizer_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `43/P1 -> 1/PASS_MONITOR`, fixed-height refs `9 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `58` to `57`, whole-app pass/monitor count moved from `74`
  to `75`, and DCA P1 count moved from `1` to `0`.
- 2026-06-19: `LaunchpadPage` was compacted with shared compact root content,
  bounded scroll-end clearance, compact hero metrics, launchpad tabs, project
  cards, project actions, staking entry, advanced/risk tool grids, and safety
  warning. Removed screen-local bottom inset pressure, custom root gap,
  tokenized line-height/fixed-height pressure, and tool-tile `Spacer()` while
  preserving project status/type labels, hard cap/raised/participant metrics,
  progress, KYC/audit badges, join/detail CTAs, staking shortcut, route
  shortcuts, and safety warning copy. Added `SC-295 first viewport reaches
  first launchpad project`. Verification passed: focused analyze,
  `launchpad_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `61/P0 -> 3/PASS_MONITOR`, fixed-height refs `13 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `5 -> 0`; whole-app P0 count
  moved from `24` to `23`, whole-app pass/monitor count moved from `63` to
  `64`, and Launchpad P0 count moved from `1` to `0`.
- 2026-06-19: `LaunchpadWebhooksPage` was compacted with bounded scroll-end
  clearance, shared compact content density, compact stats strip, compact
  subscription/create card rhythm, compact subscription expansion rows,
  compact delivery rows, compact info banner, compact create sheet spacing,
  and route-local Webhooks constants. Removed screen-local bottom inset
  pressure, root `customGap` rhythm, `DeviceMetrics` dependency, and tokenized
  fixed-height/line-height pressure while preserving subscriptions/deliveries
  tabs, create sheet open/close, event selection, copy feedback, pause/resume,
  delete behavior, and header-back route. Added `SC-310 first viewport reaches
  first subscription`. Verification passed: focused analyze,
  `launchpad_webhooks_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `47/P1 -> 2/PASS_MONITOR`, fixed-height refs `10 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `57` to `56`, whole-app pass/monitor count moved from `75`
  to `76`.
- 2026-06-19: `LaunchpadPerformancePage` was compacted with bounded scroll-end
  clearance, shared compact content density, compact tab strip, compact ROI
  hero, compact best/worst comparison row, shorter ROI distribution and chart
  bars, compact historical project cards, compact disclaimer, and route-local
  performance constants. Removed screen-local bottom inset pressure, root
  `customGap` rhythm, `DeviceMetrics` dependency, and tokenized
  fixed-height/line-height pressure while preserving overview/projects/chart
  tabs, ROI metrics, historical project rows, chart content, disclaimer copy,
  and header-back route. Added `SC-297 first viewport reaches best and worst
  projects`. Verification passed: focused analyze,
  `launchpad_performance_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `46/P1 -> 1/PASS_MONITOR`, fixed-height refs `10 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `56` to `55`, whole-app pass/monitor count moved from `76`
  to `77`.
- 2026-06-19: `P2PMerchantApplyPage` was compacted with shared compact root
  content, bounded scroll-end clearance, compact stepper, requirements,
  benefits, business-info form, document upload, history/final steps, success
  state, and navigation actions. Removed screen-local bottom inset pressure,
  manual custom gaps, tokenized fixed-height/line-height pressure, and
  `Spacer()` looseness while preserving merchant requirements, document upload,
  agreement, submit, and success navigation behavior. Added `SC-227 first
  viewport reaches merchant requirements`. Verification passed: focused
  analyze, `p2p_merchant_apply_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `68/P0 -> 2/PASS_MONITOR`, fixed-height refs `5 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `7 -> 0`, bottom-inset refs `6 -> 0`; whole-app P0 count
  moved from `23` to `22`, whole-app pass/monitor count moved from `64` to
  `65`, and P2P P0 count moved from `4` to `3`.
- 2026-06-19: `P2PInsuranceFundPage` was compacted across
  `AppRoutePaths.p2pInsurance` and `AppRoutePaths.p2pInsuranceFundAlias` with
  shared compact root content, bounded scroll-end clearance, compact overview
  cards, eligibility/health/chart/coverage sections, claim calculator, claims
  CTA/list, compact risk review, and compact onboarding tour. Removed
  screen-local bottom inset pressure, manual `customGap` rhythm, tokenized
  fixed-height/line-height pressure, and tall card padding while preserving
  insurance fund totals, eligibility, proof-of-reserves route, contribution
  history route, claims tab, certificate navigation, tour close/continue, and
  P2P insurance safety copy. Added `SC-238 first viewport reaches eligibility
  card`. Verification passed: focused analyze,
  `p2p_insurance_fund_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  both routes moved `62/P0 -> 1/PASS_MONITOR`, fixed-height refs `6 -> 0`,
  spacer refs `0 -> 0`, manual-content refs `7 -> 0`, bottom-inset refs
  `4 -> 0`; whole-app P0 count moved from `22` to `20`, whole-app
  pass/monitor count moved from `65` to `67`, and P2P P0 count moved from
  `3` to `1`.
- 2026-06-19: `P2PAdAnalyticsPage` was compacted with shared compact root
  content, bounded scroll-end clearance, compact ad identity, KPI grid, quick
  stats, conversion funnel, performance/volume/heatmap charts, payment mix,
  competitor table, optimization tips, and compact risk review. Removed
  screen-local bottom inset pressure, manual `customGap` rhythm, tokenized
  fixed-height/line-height pressure, and KPI-card `Spacer()` looseness while
  preserving ad id routing, rank/price/volume metrics, conversion funnel,
  payment breakdown, competitor comparison, optimization tips, scroll
  reachability, and P2P escrow/performance safety copy. Added `SC-223 first
  viewport previews conversion funnel`. Verification passed: focused analyze,
  `p2p_ad_analytics_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `60/P0 -> 7/PASS_MONITOR`, fixed-height refs `9 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `2 -> 0`, bottom-inset refs `6 -> 0`; whole-app P0 count
  moved from `20` to `19`, whole-app pass/monitor count moved from `67` to
  `68`, and P2P P0 count moved from `1` to `0`.
- 2026-06-19: `P2PClaimDetailPage` was compacted with shared compact root
  content, bounded scroll-end clearance, compact claim hero, progress rail,
  benchmark comparison, description, section tabs/body, evidence upload/list,
  reviewer notes, notification controls, action rows, receipt CTA, feedback
  banner, and compact risk review. Removed screen-local bottom inset pressure,
  manual `customGap` rhythm, tokenized fixed-height/line-height pressure, and
  hero `Spacer()` looseness while preserving claim status, covered/paid amount,
  timeline/evidence/notes tabs, notification toggling, receipt feedback, parent
  insurance route, order route, and support route. Added `SC-243 first viewport
  reaches claim benchmarks`. Verification passed: focused analyze,
  `p2p_claim_detail_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `53/P1 -> 1/PASS_MONITOR`, fixed-height refs `7 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `3 -> 0`, bottom-inset refs `6 -> 0`; whole-app P1 count
  moved from `64` to `63`, whole-app pass/monitor count moved from `68` to
  `69`, and P2P P1 count moved from `6` to `5`.
- 2026-06-19: `P2PSecurityCenterPage` and `P2PWhitelistModePage` were
  compacted as a shared P2P security route pair with bounded scroll-end
  clearance, compact score card, feature rows, quick-action grid, recent-event
  rows, view-all action, whitelist hero, trusted-device/anti-phishing actions,
  compact return CTA, and compact high-risk review panels. Removed screen-local
  bottom inset pressure, manual `customGap` rhythm, tokenized
  fixed-height/line-height pressure, and oversized score-card spacing while
  preserving security score, feature routes, quick-action routes, settings
  route, login-history route, whitelist return route, and sensitive P2P
  security warnings. Added `SC-253 first viewport reaches security features`
  and `SC-253 whitelist route first viewport reaches device review`.
  Verification passed: focused analyze, `p2p_security_center_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  both routes moved `46/P1 -> 2/PASS_MONITOR`, fixed-height refs `6 -> 0`,
  spacer refs `0 -> 0`, manual-content refs `2 -> 0`, bottom-inset refs
  `8 -> 0`; whole-app P1 count moved from `63` to `61`, whole-app
  pass/monitor count moved from `69` to `71`, and P2P P1 count moved from
  `5` to `3`.
- 2026-06-19: `P2PWalletPage` was compacted with bounded scroll-end clearance,
  compact hero padding/actions, compact notice-to-balance rhythm, compact
  balance cards, compact expanded asset actions, compact transaction rows, and
  a compact high-risk review panel. Removed screen-local bottom inset pressure,
  manual section gap rhythm, tokenized fixed-height pressure, and oversized
  asset/action boxes while preserving masked balance toggle, transfer-to/from
  Main routes, asset expansion, deposit/withdraw routes, escrow detail routes,
  recent transaction content, and wallet history route. Added `SC-264 first
  viewport reaches balances section`. Verification passed: focused analyze,
  `p2p_wallet_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `45/P1 -> 7/PASS_MONITOR`, fixed-height refs `5 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `3 -> 0`, bottom-inset refs `4 -> 0`; whole-app P1 count
  moved from `61` to `60`, whole-app pass/monitor count moved from `71` to
  `72`, and P2P P1 count moved from `3` to `2`.
- 2026-06-19: `P2PE2EInfoPage` was compacted with bounded scroll-end
  clearance, compact root content density, compact security hero, compact E2E
  diagram, compact explanation cards, compact fingerprint block, compact
  step rows, and compact server note. Removed screen-local bottom inset
  pressure, root `customGap` rhythm, tokenized fixed-height/line-height
  pressure, and oversized E2E icon/diagram extents while preserving the
  encryption diagram, AES/RSA/session-key/identity/security warning copy,
  fingerprint, server note, chat parent route, and back-to-chat behavior.
  Added `SC-259 first viewport reaches first security item`. Verification
  passed: focused analyze, `p2p_e2e_info_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `42/P1 -> 4/PASS_MONITOR`, fixed-height refs `7 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `6 -> 0`; whole-app P1 count
  moved from `60` to `59`, whole-app pass/monitor count moved from `72` to
  `73`, and P2P P1 count moved from `2` to `1`.
- 2026-06-19: `P2PKycRequirementsPage` was compacted with bounded scroll-end
  clearance, compact root rhythm, compact KYC hero, compact notice, compact
  tier cards, compact requirement/limit/benefit sections, compact support CTA,
  and compact high-risk review panel. Removed screen-local bottom inset
  pressure, root `customGap` rhythm, tokenized fixed-height/line-height
  pressure, oversized KYC icon boxes, and tall tier action spacing while
  preserving current tier visibility, locked/available tier states, verification
  requirements, daily/monthly P2P limits, support route, upgrade route, and
  P2P KYC safety context. Added `SC-247 first viewport reaches current KYC
  tier`. Verification passed: focused analyze,
  `p2p_kyc_requirements_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `42/P1 -> 1/PASS_MONITOR`, fixed-height refs `8 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `6 -> 0`; whole-app P1 count
  moved from `59` to `58`, whole-app pass/monitor count moved from `73` to
  `74`, and P2P P1 count moved from `1` to `0`.
- 2026-06-19: `SavingsLadderPage` was compacted with shared compact density
  across the root content, ladder hero, amount selector, template cards, rung
  cards, timeline/analysis tabs, liquidity review, disclaimer, empty state,
  and high-risk review panel. Fixed screen-local fixed-height refs, nested
  `customGap` rhythm, `Spacer()` looseness, and bottom-clearance text-heuristic
  pressure while preserving amount/preset selection, generated rung schedules,
  timeline/analysis tabs, confirmation sheet, APY/liquidity calculations, and
  disclaimer copy. Added `SC-351 first viewport reaches amount action chips`.
  Verification passed: focused analyze, `savings_ladder_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `90/P0 -> 1/PASS_MONITOR`, fixed-height refs `9 -> 0`, spacer refs `3 -> 0`,
  manual-content refs `8 -> 0`; whole-app P0 count moved from `32` to `31`,
  whole-app pass/monitor count moved from `55` to `56`, and Earn P0 count
  moved from `1` to `0`.
- 2026-06-19: `StakingWithdrawalPolicyPage` was compacted with bounded
  scroll-end clearance, shared compact root density, compact info/risk review,
  compact policy tabs, compact withdrawal process, compact timeline cards,
  compact penalty examples/calculator CTA, compact emergency policy/fee/support
  sections, and compact calculator sheet/common warnings. Removed screen-local
  bottom inset pressure, tokenized fixed-height/line-height pressure, and
  `DeviceMetrics` dependency while preserving withdrawal preview/confirm safety
  copy, early-fee math, calculator result/preview mock, emergency fee details,
  support contacts, and header-back route. Added `SC-355 first viewport reaches
  withdrawal process`. Verification passed: focused analyze,
  `staking_withdrawal_policy_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `53/P1 -> 4/PASS_MONITOR`, fixed-height refs `13 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `55` to `54`, whole-app pass/monitor count moved from `77`
  to `78`.
- 2026-06-19: `StakingRiskDisclosurePage` was compacted with bounded
  scroll-end clearance, shared compact root density, compact warning banner,
  compact risk tabs, compact summary/count cards, compact product cards,
  compact category details, compact assessment CTA/FAQ, and route-local risk
  constants. Removed screen-local bottom inset pressure, tokenized
  fixed-height/line-height pressure, and `DeviceMetrics` dependency while
  preserving warning copy, product risk labels, category expansion details,
  mitigation examples, assessment route, and header-back route. Added
  `SC-354 first viewport reaches first risk product`. Verification passed:
  focused analyze, `staking_risk_disclosure_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `50/P1 -> 4/PASS_MONITOR`, fixed-height refs `12 -> 0`, spacer refs `0 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `54` to `53`, whole-app pass/monitor count moved from `78`
  to `79`.
- 2026-06-19: `SavingsAutoRebalancePage` was compacted with bounded
  scroll-end clearance, shared compact root density, compact allocation
  comparison/ring rows, compact drift status/history, compact auto-status and
  strategy/history/settings panels, compact preview sheet spacing, and
  route-local rebalance constants. Removed screen-local bottom inset pressure,
  root `customGap` rhythm, tokenized fixed-height pressure, and
  `Spacer()` looseness while preserving allocation drift math, tab switching,
  strategy selection, auto-enable state, preview confirmation sheet, and
  header-back route. Added `SC-344 first viewport reaches preview action`.
  Verification passed: focused analyze, `savings_auto_rebalance_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `49/P1 -> 1/PASS_MONITOR`, fixed-height refs `3 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `5 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `53` to `52`, whole-app pass/monitor count moved from `79`
  to `80`.
- 2026-06-19: `StakingSuitabilityAssessmentPage` was compacted with bounded
  scroll-end/footer clearance, shared compact root density, compact
  risk-review/result panels, compact question/options/quiz cards, route-local
  assessment line-height/ring constants, compact CTA density, and
  `Expanded`-aligned slider labels. Removed screen-local bottom inset pressure,
  tokenized fixed-height/line-height pressure, and `Spacer()` looseness while
  preserving suitability scoring, question navigation, quiz answers,
  recommended product result, reset/explore actions, and header-back route.
  Added `SC-376 first viewport reaches first answer option`. Verification
  passed: focused analyze, `staking_suitability_assessment_page_test.dart`,
  and `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `49/P1 -> 1/PASS_MONITOR`, fixed-height refs `8 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `10 -> 0`; whole-app P1
  count moved from `52` to `51`, whole-app pass/monitor count moved from `80`
  to `81`.
- 2026-06-19: `StakingAnalyticsPage` was compacted with bounded scroll-end
  clearance, shared compact root density, compact summary/calculator/action
  cards, compact analytics tab sections, shorter earnings/APY/ROI chart
  surfaces, compact product/stat cards, route-local analytics chart and
  line-height constants, and compact legend/footer note spacing. Removed
  screen-local bottom inset pressure, tokenized fixed-height/line-height
  pressure, and asset-grid `Spacer()` looseness while preserving analytics
  summary metrics, calculator toggle/compound state, tab switching, chart
  content, export snackbar, footer disclaimer, and header-back route. Added
  `SC-359 first viewport reaches calculator action`. Verification passed:
  focused analyze, `staking_analytics_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `42/P1 -> 1/PASS_MONITOR`, fixed-height refs `9 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `51` to `50`, whole-app pass/monitor count moved from `81`
  to `82`.
- 2026-06-19: `StakingTransactionReportingPage` was compacted with bounded
  scroll-end clearance, shared compact root density, compact tax info/selectors,
  compact reporting tabs, compact tax summary/reward/transaction/export cards,
  compact method/export sheets, and route-local reporting control, divider, and
  line-height constants. Removed screen-local bottom inset pressure, tokenized
  fixed-height/line-height pressure, and selector-card `Spacer()` looseness
  while preserving tax year cycling, cost-basis method selection, summary
  calculations, transaction ledger, export options, tax notice copy, and
  header-back route. Added `SC-378 first viewport reaches reporting selectors`.
  Verification passed: focused analyze,
  `staking_transaction_reporting_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `41/P1 -> 2/PASS_MONITOR`, fixed-height refs `9 -> 0`, spacer refs `1 -> 0`,
  manual-content refs `0 -> 0`, bottom-inset refs `4 -> 0`; whole-app P1
  count moved from `50` to `49`, whole-app pass/monitor count moved from `82`
  to `83`.
- 2026-06-19: `SavingsPortfolioPage` was compacted with bounded scroll-end
  clearance, shared compact root/overview density, compact portfolio hero,
  compact hero actions, shorter allocation donut, compact projection/maturity
  and earnings cards, route-local portfolio extents, and ellipsized status
  pills for narrow rows. Removed screen-local bottom inset pressure,
  nested `customGap` rhythm, tokenized fixed-height/line-height pressure, and
  two `Spacer()` looseness points while preserving masked balance toggle,
  add/withdraw/history actions, allocation chart, maturity warnings, positions
  filter tab, savings-history route edge, and market-rate warning copy. Added
  `SC-333 first viewport reaches history action`. Verification passed: focused
  analyze, `savings_portfolio_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `40/P1 -> 2/PASS_MONITOR`, fixed-height refs `5 -> 0`, spacer refs `2 -> 0`,
  manual-content refs `1 -> 0`, bottom-inset refs `5 -> 0`; whole-app P1
  count moved from `49` to `48`, whole-app pass/monitor count moved from `83`
  to `84`. A focused overflow regression surfaced in `_MaturityCard` after
  compaction and was fixed with flexible status pill layout plus single-line
  ellipsis.
- 2026-06-19: Android emulator evidence was captured for the financial flow
  and the P2P fullscreen-tool exception. Built and installed a debug APK on
  `emulator-5554`, navigated Home -> `Staking & Earn`, and captured
  `flutter_app/run-artifacts/sc333_emulator_earn_sample.png`, confirming the
  compact Earn first viewport renders product tabs, APY/risk cards, positions,
  and bottom nav without blank/overlapped content. Rebuilt the debug APK with
  `--dart-define=INITIAL_ROUTE=/p2p/chat/p2p001` and captured
  `flutter_app/run-artifacts/sc217_p2p_chat_tool_emulator_retry.png`,
  confirming `P2PChatPage` is a valid fullscreen-tool monitor with E2E warning,
  no-personal-info risk copy, message list, quick replies, composer, and bottom
  nav visible. `P2PChatPage` remains in `P1_TOOL_VISUAL_QA` by policy, not as a
  generic density compaction candidate.

#### Checkpoint 4: Financial And Cross-Module Coverage

- [x] Wallet P0/P1 reduced; P0 and P1 are zero in the current matrix.
- [x] Arena P0/P1 reduced; current arena P0/P1 is zero in the matrix.
- [x] DCA/Launchpad/P2P/Earn P0 handled.
- [x] No financial safety regression observed in touched DCA/Launchpad/P2P/Earn
      flows.

### Phase 5: P2/P3 Sweep And Reference Protection

Goal: prevent remaining medium/low-risk screens from being forgotten.

#### Task 5.1: P2 medium-risk sweep `[~]`

**Description:** Process the current 113 P2 screens after compact patterns
stabilize.

**Acceptance criteria:**

- [ ] Every P2 row is assigned one of: fixed, accepted exception, or monitor
      when touched.
- [~] P2 fixes reuse shared compact patterns where slices have already been
      touched.
- [x] No new P0/P1 regressions are introduced by the current visual-density
      audit.

**Verification:**

- [x] Density audit.
- [~] Feature-focused tests where screens are touched.

**Dependencies:** Checkpoint 4  
**Likely files:** all feature modules as listed by matrix  
**Estimated scope:** S/M per batch

**Progress log:**

- 2026-06-19: `NewsPage` was compacted with shared compact page/section
  density, tighter filter chips, compact article cards, compact empty state,
  and compact article-detail sheet. Fixed bottom-clearance text-heuristic
  pressure, nested custom section gaps, fixed-height/line-height refs, and
  sheet spacing while preserving type filters, pinned/normal article grouping,
  article detail sheet, close action, and Home back navigation. Added
  `SC-047 first viewport reaches pinned news card`. Verification passed:
  focused analyze, `news_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `86/P0 -> 7/PASS_MONITOR`, fixed-height refs `14 -> 0`,
  manual-content refs `3 -> 0`; whole-app P0 count moved from `31` to `30`,
  whole-app pass/monitor count moved from `56` to `57`, and lower-risk module
  P0 count moved to `0`.
- 2026-06-19: `ReferralHomePage` P1 was compacted with route-local bounded
  scroll-end clearance, compact shared `VitPageContent` density, compact
  milestone/history section rhythm, route-local hero/CTA/divider/rank/progress/
  avatar extents, and first-referral-hero viewport coverage. Fixed
  `DeviceMetrics` bottom usage, `referralBottomScrollPadding` bottom inset
  pressure, nested `customGap` rhythm, tokenized fixed-height/width/progress
  pressure, and two `Spacer()` looseness points while preserving campaign
  banner, anti-fraud safety notice, pending-KYC navigation, copy/share local
  state, referral detail route edges, calculator, milestones, rewards,
  leaderboard, and referral rules/history/rewards navigation. Added `SC-290
  first viewport reaches referral hero`. Verification passed: focused analyze,
  `referral_home_page_test.dart`, and `dart run
  tool/visual_density_risk_audit.dart --check`. Audit result:
  `52/P1 -> 1/PASS_MONITOR`, fixed-height refs `5 -> 0`, spacer refs `2 -> 0`,
  manual-content refs `4 -> 0`, bottom-inset refs `4 -> 0`; whole-app P1 count
  moved from `17` to `16`, whole-app pass/monitor count moved from `129` to
  `130`.
- 2026-06-19: `HomePage` P1 was compacted as the root brand reference screen
  without replacing shared components. Fixed `DeviceMetrics` bottom usage,
  custom page rhythm, tokenized fixed-height/gap refs, and `Spacer()` pressure
  by using shared compact page density, route-local scroll-end clearance, and
  bounded route-local extents for hero actions, recent products, and trending
  cards. Existing SC-007 first-viewport coverage and navigation contracts were
  preserved. Verification passed: focused analyze, `home_page_test.dart`, and
  `dart run tool/visual_density_risk_audit.dart --check`. Audit result:
  `49/P1 -> 5/PASS_MONITOR`, fixed-height refs `7 -> 0`, tokenized-gap refs
  `3 -> 0`, spacer refs `1 -> 0`, manual-content refs `1 -> 0`,
  bottom-inset refs `5 -> 1`; whole-app P1 count moved from `16` to `15`,
  whole-app pass/monitor count moved from `130` to `131`.

#### Task 5.2: P3 low-risk monitor queue `[x]`

**Description:** Track the current 143 P3 screens without unnecessary churn.

**Acceptance criteria:**

- [x] P3 rows remain in the matrix.
- [x] If a P3 screen is touched for other work, density DoD is applied.
- [x] No pass/monitor screen is refactored without a reason.

**Verification:**

- [x] Matrix has no missing route.
- [x] PR reviews check touched P3 rows.

**Dependencies:** Task 5.1  
**Likely files:** all feature modules when touched  
**Estimated scope:** Ongoing

#### Task 5.3: Protect pass/monitor reference screens `[x]`

**Reference screens:**

- `LoginPage`
- `ForgotPasswordPage`
- `UnifiedPortfolioDashboard`
- `DCABacktesterPage`
- `DCARebalanceDashboard`
- `DCAScheduleAnalytics`
- `RouteChecker`
- `MarketListPage`
- `OnboardingFlow`
- `ReferralFriendDetailPage`

**Acceptance criteria:**

- [x] Reference screens are used as comparison examples.
- [x] They are not changed unless a concrete issue appears.
- [x] Any future change preserves or improves current density score.

**Verification:**

- [x] Density audit remains pass/monitor for these routes.

**Dependencies:** None  
**Likely files:** reference screen tests/docs only when needed  
**Estimated scope:** S

#### Checkpoint 5: Whole Backlog Accounted For

- [x] P0/P1/tool/P2/P3/pass queues all have status; individual P2/P3 rows have
      final fixed/accepted/monitor assignment.
- [x] No feature has an unclassified screen.
- [x] Matrix still has exactly 414 rows unless route inventory changes.

### Phase 6: Final Verification And Release Gate

Goal: prove the whole project meets Flutter Enterprise-Grade UI optimization
standards.

#### Task 6.1: Run complete audit suite `[x]`

**Verification commands:**

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

**Acceptance criteria:**

- [x] All audits pass or documented exceptions are accepted.
- [x] No route coverage regression.
- [x] No token debt regression.
- [x] Density risk output is current.

#### Task 6.2: Emulator QA suite `[x]`

**Representative route set:**

- `/profile`
- `AppRoutePaths.profileApiCreate`
- `AppRoutePaths.arenaMy`
- `AppRoutePaths.marketsOverview`
- `AppRoutePaths.marketsSignals`
- `'/markets/predictions/event/:eventId'`
- `AppRoutePaths.walletHealthScore`
- `AppRoutePaths.walletGasOptimizer`
- one trade compliance route
- one trade tool route
- one financial confirmation route

**Acceptance criteria:**

- [x] First viewport shows useful content on 440x956.
- [x] 360 px minimum phone has no overflow and no hidden primary content.
- [x] Bottom nav/sticky footer does not hide primary rows.
- [x] Tool screens use full screen intentionally.

#### Task 6.3: Final documentation update `[x]`

**Acceptance criteria:**

- [x] This tracking plan status is updated.
- [x] Root-cause reports point to final audit outputs.
- [x] Any accepted exceptions are documented.
- [x] Final summary states remaining P2/P3 monitor policy.

**Progress log:**

- 2026-06-20: Updated
  `docs/03_DESIGN_SYSTEM/AI-Whole-App-UI-Optimization-Autonomous-Execution-Prompt.md`
  so future AI/Codex runs start from the section `0A` reality check instead
  of the obsolete 2026-06-19 P0/P1 backlog. The prompt now prioritizes stale
  audit artifact regeneration, the analyzer warning, 360x800 responsive
  failures, five tool-QA routes, P2/P3 assignment, and the final release gate.
- 2026-06-20: Completed the final pass. Regenerated stale audit artifacts,
  fixed analyzer and responsive QA failures, captured Android/widget evidence
  for all 5 tool routes, assigned all 256 P2/P3 rows to the monitor ledger,
  passed all audit checks, passed `flutter analyze`, and passed
  `flutter test --reporter=compact` with `2218` tests.

## 6. Parallelization Plan

Safe to parallelize after Phase 1:

| Parallel lane | Owner focus | Dependencies |
| --- | --- | --- |
| Profile/account | `profile`, account patterns | Checkpoint 1 |
| Trade compliance | copy/regulatory/report screens | Checkpoint 1 |
| Trade bot/margin | bot, margin, trader profile, analytics | Checkpoint 1 |
| Markets/predictions | markets overview/signals and prediction event/tournament | Checkpoint 1 |
| Wallet/financial | wallet, launchpad, P2P financial flows | Task 1.4 |
| Arena/DCA/Earn | arena production, DCA root, earn high-risk screens | Checkpoint 1 |

Must remain sequential:

- density audit creation before declaring progress,
- shared density primitives before wide feature refactors,
- Profile reference slice before applying account pattern broadly,
- final full test suite after all feature batches.

## 7. Risk Register

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Compacting removes financial safety copy | High | Use compact key-value rows, not deletion; run financial flow tests. |
| Arena and Prediction copy boundaries drift | High | Keep domain copy checklist in every affected PR. |
| One-off compact widgets create new inconsistency | High | Add shared density primitives first; reject local duplicates. |
| Audit thresholds too strict and flag legitimate tools | Medium | Tool exception policy with emulator evidence. |
| P2/P3 screens get forgotten | Medium | Keep matrix as required ledger; update status per row/feature. |
| Visual density improves but accessibility worsens | High | Preserve touch targets, labels, readable text, and Semantics. |
| Bottom nav still hides content after compacting | High | Add widget `getRect` assertions and emulator screenshot checks. |
| Large refactors break tests across modules | Medium | Refactor by archetype with focused tests before full suite. |

## 8. Per-Screen Execution Checklist

Use this checklist for every screen row in the matrix:

1. [ ] Open the row in `whole_app_visual_density_root_cause_matrix.csv`.
2. [ ] Record feature, route, page, priority, and root causes.
3. [ ] Identify dominant issue: height, gap, spacer, manual content, bottom
       inset, root chrome, or tool exception.
4. [ ] Sketch first-viewport budget before code changes.
5. [ ] Check financial/domain boundary requirements.
6. [ ] Reuse shared compact primitives first.
7. [ ] Remove or reduce tokenized fixed heights only through approved tokens.
8. [ ] Replace loose manual gap stacks with compact shared rhythm.
9. [ ] Remove `Spacer()` from fixed-height cards unless justified by visual QA.
10. [ ] Recheck bottom nav/sticky footer clearance.
11. [ ] Add or update focused tests.
12. [ ] Run focused tests and relevant audits.
13. [ ] Capture emulator screenshot for P0/P1 representative routes.
14. [ ] Update matrix/report status.

## 9. Tracking Board

| Phase | Status | Exit condition |
| --- | --- | --- |
| Phase 0: Baseline and governance | `[x]` | Reproducible official density audit exists. |
| Phase 1: Shared density foundation | `[x]` | Compact shared primitives and viewport test helpers exist. |
| Phase 2: Reference vertical slice | `[x]` | `ProfilePage` and profile/account pattern verified on emulator. |
| Phase 3: Critical P0/P1 modules | `[x]` | Trade, markets, and predictions regular P0/P1 are zero; trade tool QA evidence is captured. |
| Phase 4: Financial/cross-module expansion | `[x]` | Wallet, arena, DCA, launchpad, P2P, and earn regular P0/P1 are zero; representative tool QA evidence is captured. |
| Phase 5: P2/P3 sweep and reference protection | `[x]` | P2/P3 queues are measurable and every current row is assigned fixed/accepted/monitor status. |
| Phase 6: Final verification and release gate | `[x]` | Full audits, analyze, tests, and emulator/360px QA pass. |

## 10. Completion Target

The UI optimization pass is complete when:

- [x] P0 screens are zero or documented exceptions.
- [x] P1 screens are zero or documented exceptions.
- [x] All 5 tool routes have current manual QA evidence.
- [x] P2 and P3 queues are not ignored; each row has final
      fixed/accepted/monitor status.
- [x] The pass/monitor reference queue remains stable; it is now 153 rows, not
      the older 11-row reference set.
- [x] All 414 routed screens remain represented in the matrix.
- [x] Shared-component and token audits still pass.
- [x] Financial safety and Prediction/Arena boundaries are preserved for the
      completed P0/P1 slices.
- [x] Emulator evidence confirms first-viewport density on representative routes.

## 11. First Execution Recommendation

Start in this order:

1. [x] Build the official `visual_density_risk_audit.dart` gate.
2. [x] Add shared density semantics and compact primitives.
3. [x] Fix `ProfilePage` as the reference vertical slice.
4. [x] Apply account pattern across Profile P0/P1 routes.
5. [x] Compact `MyArenaPage` once for both Arena/Profile entry points.
6. [x] Start Trade compliance/report archetype.
7. [x] Start Markets overview/signals and Prediction event detail in parallel.

Current next execution order:

1. [x] Regenerate or resolve stale audit artifacts listed in section 0A.3.
2. [x] Fix the `flutter analyze` warning in
       `profile_api_key_create_result.dart`.
3. [x] Fix 360x800 responsive overflows for Address Book, Prediction Event,
       and Arena Challenge.
4. [x] Capture/refresh manual QA evidence for all 5 `P1_TOOL_VISUAL_QA`
       routes.
5. [x] Assign every P2/P3 row to fixed, accepted exception, or monitor
       when-touched.
6. [x] Run the final broad release gate and close out this plan.

This order gives the fastest visible improvement while also preventing the same
problem from returning unnoticed.
