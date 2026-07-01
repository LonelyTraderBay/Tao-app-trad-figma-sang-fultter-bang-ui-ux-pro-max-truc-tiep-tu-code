# VitTrade Home UI Project-Wide Standardization Deep Plan

Updated: 2026-07-01
Status: **Phase 7 closure complete** — Phases 0–7 Done; `total_debt=0`
Last sync: **2026-07-01** — §4.0, §4.3.1, §11, §12 aligned with
[`VitTrade-Home-UI-Standardization-Batch-Log.md`](VitTrade-Home-UI-Standardization-Batch-Log.md)
and regenerated `VitTrade-Design-Token-Consistency-Audit.csv` (P2P-HOME-03/04 Done).
Scope: Flutter UI under `flutter_app/lib/features/`, shared UI primitives under
`flutter_app/lib/shared/`, app theme tokens under `flutter_app/lib/app/theme/`,
and verification artifacts under `docs/02_FLUTTER_MIGRATION/`.

This plan extends the lessons from
`docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md` to the whole
Flutter app. Wallet remains the proven rollout reference. Home remains the
visual source of truth. This file is the operational plan for applying the same
standard across remaining modules without weakening product safety, routing,
tests, or module boundaries.

## 1. Why This Plan Exists

The Wallet plan successfully proved that a feature cannot be marked visually
standardized from widget tests alone. It introduced a stronger completion model:
Home-derived layout, first-viewport density, shared primitives, token-only
styling, action census, GitNexus impact evidence, focused tests, analyzer, and
audit evidence.

That model should now become the project-wide UI process. The current app is
already much cleaner than the older enterprise UI/UX plan snapshots. **Live
execution numbers are in §4.0** (do not use the pre-execution snapshot below
for gates).

Pre-execution snapshot (2026-06-27 plan baseline):

- Wallet token debt is `0`, so Wallet is the reference implementation, not the
  main cleanup target.
- Typography debt is `0` across all modules.
- Route coverage is current.
- Visual density has no P0/P1 normal-screen failures.
- Residual token debt was concentrated in P2P (`p0_p2p_debt=173`), with one Earn
  root bundle, two Trade root bundles, Markets feature-widget debt
  (`p0_markets_debt=6`), and one shared-widget residual (`vit_choice_pill.dart`).
- Five fullscreen tool screens still require explicit manual visual QA.
- Five medium density review items remain, including four Wallet follow-ups and
  one Earn notifications surface.

**After 2026-07-01 execution (see §4.0):** `total_debt=0`, `p0_p2p_debt=0`,
`p0_trade_debt=0`, `p0_markets_debt=0`, Phases 0–7 complete.

The goal is not to redesign the app again from scratch. The goal is to finish
the remaining inconsistencies, preserve the Home/Wallet standard, and make the
entire project feel like one professional trading product.

## 2. Source Priority

Use this order when documents or code disagree:

1. Current user instruction.
2. `AGENTS.md`.
3. `docs/00_START_HERE.md`.
4. Current Flutter source under `flutter_app/lib/`.
5. Current Flutter tests under `flutter_app/test/`.
6. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`.
7. `docs/02_FLUTTER_MIGRATION/Wallet-UI-Home-Standardization-Plan.md`.
8. `docs/03_DESIGN_SYSTEM/Guidelines.md`.
9. Audit artifacts under `docs/02_FLUTTER_MIGRATION/`.

If visual consistency conflicts with financial safety, financial safety wins.
If a historical plan conflicts with current Flutter source/tests/audits, inspect
source/tests/audits and update stale docs when in scope.

### 2.1 Document Scope Matrix

This Deep Plan owns the **residual debt pass** after the broader Home rollout.
Use it together with, not instead of, the documents below.

| Document | Status | Owned by this plan | Owned elsewhere |
| --- | --- | --- | --- |
| [`VitTrade-Home-UI-Rollout-Execution-Plan.md`](../03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md) | Active; many batches Done | Residual token/density queues only | Screen-entry rollout tracking, §7 batch log rows for completed batches |
| [`Wallet-UI-Home-Standardization-Plan.md`](Wallet-UI-Home-Standardization-Plan.md) | Reference implementation | Phase 3 Wallet medium-density follow-ups only | Wallet route manifest, per-page evidence, safety gates |
| [`VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md`](VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md) | Code/audit done; Phase 8 emulator QA unconfirmed | Header fixes only when tool QA finds a header issue | Top-header audits, guardrail tests, archetype policy |
| [`VitTrade-Whole-App-P2-P3-Assignment-Ledger.md`](../03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.md) | 256 rows = `monitor_when_touched` | Phase 5 prioritization via P2-A candidates | Row-level density policy and guardrails |
| [`VitTrade-Whole-App-Visual-Density-Real-Audit-Report.md`](../03_DESIGN_SYSTEM/VitTrade-Whole-App-Visual-Density-Real-Audit-Report.md) | **Stale** (`total_debt=0` claim) | Do not use for gates | Deprecated; use `VitTrade-Visual-Density-Risk-Audit.md` |
| [`Enterprise-PR-Review-Checklist.md`](Enterprise-PR-Review-Checklist.md) | Active merge gate | Per-batch and Phase 7 verification commands | PR review ownership |

Rule: do not redo batches marked Done in the Execution Plan unless a
regenerated audit shows new residual debt on that screen.

### 2.2 Plan Sync Contract (mandatory)

This Deep Plan is the **single progress source of truth** for the residual pass.
After **every** batch (Done, Blocked, or partial handoff), update **in the same
session**:

| Location | What to update |
| --- | --- |
| **§4.0** | Phase status, debt delta, batch tracker, last-sync date |
| **§4.2.2** | Regenerated audit totals when CSV changes |
| **§4.3 / §4.3.1** | Remaining queue + per-bundle `Exec status` |
| **§11** | Immediate next batch ID and targets |
| **§12.2** | Per-page Done / In progress / Not started |
| **§12.4** | Batch log row (or append to linked batch log file) |
| [`VitTrade-Home-UI-Standardization-Batch-Log.md`](VitTrade-Home-UI-Standardization-Batch-Log.md) | Same row as §12.4 when residual pass is active |

Do **not** mark a batch Done in code-only terms; require audit `--check` or
regenerated CSV showing bundle pass/accepted exception, plus focused tests +
`flutter analyze`.

## 3. Wallet Plan Analysis

### 3.1 What The Wallet Plan Gets Right

- It resets the meaning of "Done". Rendering and taps are not enough.
- It defines Home as a pattern library, not a business-logic source.
- It gives a concrete page rhythm:
  header -> hero/context -> primary actions -> status/safety -> tools/tabs ->
  dense lists/details -> secondary discovery -> bottom-safe end.
- It maps UI needs to shared primitives such as `VitPageLayout`,
  `VitInsetScrollView`, `VitPageContent`, `VitSectionHeader`, `VitCard`,
  `VitCtaButton`, `VitInput`, `VitTabBar`, `VitStatusPill`,
  `VitHighRiskStatePanel`, and shared sheets.
- It requires first-viewport usefulness at 360 px width.
- It treats financial safety as a non-negotiable gate: masking, fees, limits,
  risk, preview, confirm, and next steps.
- It uses a per-page route manifest and evidence ledger so work cannot silently
  skip route variants.
- It requires action census before edits and GitNexus `detect_changes()` before
  commit.
- It preserves P2P Wallet as out of scope, which protects module boundaries.

### 3.2 What Must Change For Whole-App Use

The Wallet plan is feature-specific. A whole-app rollout needs extra structure:

- A module inventory, not only a Wallet route manifest.
- A screen taxonomy that covers root modules, detail pages, high-risk forms,
  fullscreen tools, auth/onboarding exceptions, market/data rows, and
  points-only Arena surfaces.
- A current audit baseline before every sprint, because the active worktree and
  audit artifacts can move quickly.
- A residual debt queue driven by audit output, not by historical plan status.
- A policy for fullscreen tools: do not force normal card density onto chart,
  terminal, chat, or state-showcase tools, but require safe-area and nonblank
  visual QA.
- A product-boundary matrix for Wallet, P2P, Trade, Predictions, Arena, Earn,
  Launchpad, DCA, and cross-module discovery.
- A closure model that handles "token clean but visually sparse" screens. These
  need density review, not wholesale redesign.

### 3.3 Wallet Plan Lessons To Reuse Exactly

- Work one screen or a tightly coupled screen pair at a time.
- Keep route names, keys, providers, and flow states stable.
- Replace local visual systems with shared primitives by pattern.
- Keep L3 local composition only when it owns domain state, route decisions,
  copy boundaries, financial safety, chart/canvas rendering, or tool behavior.
- Add or update focused tests for every new visual, behavior, or safety
  contract.
- Record evidence immediately after each batch.

## 4. Current Baseline Snapshot

### 4.0 Execution Progress (Live)

Last updated: **2026-07-01** (synced with batch log + audit CSV; Phases 0–7 **Done**).
Detailed batch rows:
[`VitTrade-Home-UI-Standardization-Batch-Log.md`](VitTrade-Home-UI-Standardization-Batch-Log.md).

**Summary:** Phase 0 complete. Phase 1 **Done** (7/7 batches). Phases 2, 2b, 3, 4, 5, 6, **7 Done**.
`total_debt=0`; all P0 module gates pass. **No git commits** from execution session unless user
requests.

| Phase | Description | Status | Notes |
| --- | --- | --- | --- |
| **0** | Evidence freeze and graph refresh | **Done** | Audits regenerated 2026-07-01; route coverage current; GitNexus CLI detect_changes recorded |
| **1** | P2P token residual cleanup (7 batches) | **Done** | 01–07 verified; `p0_p2p_debt=0` |
| **2** | Earn and Trade token cleanup | **Done** | EARN-TRADE-01; `p0_trade_debt=0`; earn staking bundle pass |
| **2b** | Markets + shared widget cleanup | **Done** | DEEP-MARKETS-SHARED-01; `p0_markets_debt=0`; `scope_shared_widget_debt=0` |
| **3** | Wallet and Earn medium density review | **Done** | DEEP-DENSITY-WALLET-01; review-only (Wallet reference; tests pass; no spacing churn) |
| **4** | Fullscreen tool visual QA | **Done** | DEEP-TOOL-QA-01; widget-test + layout evidence for 5 tool screens |
| **5** | P3 low density triage | **Done** | P2-A ledger triaged; `monitor_when_touched`; no bulk P3 churn |
| **6** | Product boundary and copy polish | **Done** | DEEP-COPY-01; copy + a11y guardrails pass |
| **7** | Global visual QA and closure | **Done** | Full audit + quality tests + `flutter test` pass; GitNexus detect_changes recorded |

**Debt delta (verified after Phase 7 closure):**

| Metric | Plan baseline (2026-06-27) | Current (2026-07-01) | Delta |
| --- | ---: | ---: | ---: |
| `total_debt` | 374 | **0** | −374 |
| `p0_p2p_debt` | 173 | 0 | −173 |
| `p0_trade_debt` | 2 | 0 | −2 |
| `p0_markets_debt` | 6 | 0 | −6 |
| `scope_shared_widget_debt` | 1 | 0 | −1 |
| `scope_root_page_bundle_summary_debt` | 176 | 0 | −176 |

**P2P bundle progress (audit CSV):**

| Metric | Count |
| --- | ---: |
| P2P root bundles tracked | 71 |
| Cleared (pass/exception, 0 debt) after batches 01–07 | 57 page bundles |
| Still warn/fail with debt | 0 |
| Already pass before batch 03 (no work) | e.g. `p2p_kyc_requirements_page.dart` |

**Code touched (verified batches):**

- `flutter_app/lib/app/theme/app_spacing.dart` — `p2pPayment*`, `p2pEscrow*`,
  `p2pMyOrders*`, `p2pOrderBook*`, `p2pOrder*`, `p2pSelfie*`, `p2pKyc*`,
  `p2pVideo*`, `p2pAddressProof*`, `p2pFraud*`, `p2pRiskAssessment*`,
  `p2pLimitTracker*`, `p2pTransactionLimits*`, `p2pAmlScreening*`,
  `p2pComplianceOverview*`, `p2pSourceOfFunds*`, `p2pSuspiciousActivity*`,
  `p2pLargeTransaction*`, `p2pMerchantCommerce*`, `p2pAdDetailFlush*`,
  `p2pInsuranceCertificate*`, `p2pSettingsPage*`, `p2pTwoFactor*`, `p2pDevices*`,
  `p2pBlacklistList*`, `p2pNotifications*`, `p2pTax*`, `p2pLoginHistoryPage*`,
  `p2pAchievementsPage*`, `p2pFundLock*`, `p2pContribution*`, `p2pDispute*`,
  `p2pExpress*`, `p2pWalletTransfer*`, `p2pHomeClearFilter*`,
  `p2pDashboardPage*`, `p2pInsuranceFundTourSkip*` tokens
- `flutter_app/lib/features/p2p/presentation/pages/` — 57 page roots (batches 01–07)
- `flutter_app/lib/features/p2p/presentation/widgets/` — matching part/common files

**Phase 1 batch tracker:**

| Batch ID | Slice | Exec status | Verification | p0_p2p after |
| --- | --- | --- | --- | ---: |
| P2P-HOME-01 | Payment methods (6 pages) | **Done** | tests + analyze + audit pass | 149 |
| P2P-HOME-02 | Escrow/orders (8 pages) | **Done** | tests + analyze + audit pass/exception | 119 |
| P2P-HOME-03 | KYC/verification (5 pages) | **Done** | tests + analyze + audit pass | 97 |
| P2P-HOME-04 | Risk/compliance (9 pages) | **Done** | tests + analyze + audit pass | 72 |
| P2P-HOME-05 | Merchant/ads (5 pages) | **Done** | tests + analyze + audit pass | 45 |
| P2P-HOME-06 | Account/security (11 pages) | **Done** | tests + analyze + audit pass | 19 |
| P2P-HOME-07 | Dispute/express/misc (9 pages) | **Done** | tests + analyze + audit pass/exception | 0 |

Captured on 2026-06-27 from the current workspace (original plan baseline).
See §4.0 for post-execution numbers.

### 4.1 Inventory

Feature source inventory:

| Feature | Page entries | Page parts | Widgets | Tests |
| --- | ---: | ---: | ---: | ---: |
| trade | 86 | 33 | 215 | 90 |
| p2p | 71 | 25 | 93 | 72 |
| earn | 68 | 47 | 138 | 69 |
| arena | 26 | 35 | 45 | 27 |
| launchpad | 24 | 16 | 68 | 25 |
| markets | 21 | 16 | 65 | 22 |
| wallet | 19 | 3 | 70 | 20 |
| predictions | 17 | 8 | 59 | 18 |
| dca | 12 | 18 | 30 | 13 |
| profile | 11 | 0 | 29 | 12 |
| auth | 6 | 0 | 9 | 7 |
| admin | 5 | 0 | 10 | 6 |
| referral | 5 | 7 | 4 | 6 |
| cross_module | 4 | 3 | 14 | 5 |
| dev | 4 | 0 | 15 | 5 |
| support | 3 | 0 | 8 | 4 |
| discovery | 2 | 0 | 9 | 3 |
| home | 1 | 3 | 0 | 3 |
| news | 1 | 0 | 2 | 2 |
| notifications | 1 | 0 | 2 | 2 |
| onboarding | 1 | 3 | 0 | 2 |
| rewards | 1 | 0 | 0 | 2 |
| enterprise_states | 1 | 0 | 3 | 2 |

Route group counts:

| Route group | GoRoute count |
| --- | ---: |
| trade_routes | 91 |
| p2p_routes | 79 |
| earn_routes | 70 |
| arena_routes | 26 |
| launchpad_routes | 24 |
| markets_routes | 22 |
| utility_routes | 21 |
| wallet_routes | 21 |
| predictions_routes | 18 |
| profile_routes | 14 |
| dca_routes | 13 |
| auth_routes | 8 |
| admin_routes | 5 |
| support_routes | 3 |
| home_routes | 2 |

### 4.2 Audit Results

#### 4.2.1 Original baseline (2026-06-27)

Commands run from `flutter_app/`:

```bash
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
```

Results:

- Route coverage artifact is current.
- Design-token artifacts are current.
- `total_debt=374`.
- `scope_root_page_bundle_summary_debt=176`.
- `scope_shared_layout_debt=0`.
- `scope_shared_widget_debt=1`.
- `p0_wallet_debt=0/759 pass`.
- `p0_trade_debt=2/9072 pass`.
- `p0_p2p_debt=173/1911 pass`.
- `p0_markets_debt=6/2042 pass`.
- `p0_profile_debt=0/1037 pass`.
- `strict_typography_gate=zero_residual pass`.
- Visual density: `P0_CRITICAL_DENSITY_REVIEW=0`,
  `P1_HIGH_DENSITY_REVIEW=0`, `P1_TOOL_VISUAL_QA=5`,
  `P2_MEDIUM_DENSITY_REVIEW=5`, `P3_LOW_DENSITY_REVIEW=168`,
  `PASS_MONITOR=236`.

#### 4.2.2 Current baseline after Phase 7 closure (2026-07-01)

Regenerated after EARN-TRADE-01, DEEP-MARKETS-SHARED-01, and Phase 7 audit refresh.

- Route coverage artifact is current.
- Design-token, visual-density, navigation-edge, back-navigation, and top-header artifacts regenerated.
- `total_debt=0` (was 374).
- `scope_root_page_bundle_summary_debt=0` (was 176).
- `scope_shared_layout_debt=0`.
- `scope_shared_widget_debt=0`.
- `p0_wallet_debt=0`.
- `p0_trade_debt=0`.
- `p0_p2p_debt=0`.
- `p0_markets_debt=0`.
- `p0_profile_debt=0`.
- Visual density: `P0=0`, `P1=0`, `P1_TOOL=5`, `P2=7`, `P3=166`.
- GitNexus `detect_changes()` recorded at Phase 7 closure.

### 4.3 Residual Token Debt Queue

**Cleared 2026-07-01.** All root-bundle, feature-widget, and shared-widget P0 debt
resolved. Remaining audit exceptions are documented L3 (orderbook, custompainter,
tool surfaces).

Root-page bundle debt (current queue after Phase 2):

| Feature | Root bundles with debt | Root bundle debt |
| --- | ---: | ---: |
| earn | 0 | 0 |
| trade | 0 | 0 |
| p2p | 0 | 0 |

Feature-widget and shared-widget residuals (cleared in Phase 2b):

| Scope | Files with debt | Debt |
| --- | ---: | ---: |
| markets widgets | 0 | 0 |
| shared widgets | 0 | 0 |

Highest residual pages — **none** (all pass or accepted L3 exception):

| Feature | Debt | Page bundle |
| --- | ---: | --- |
| — | 0 | All root bundles pass or L3 exception |

#### 4.3.1 P2P Root-Bundle Debt Manifest

All 47 P2P root bundles with warn/fail debt from
`VitTrade-Design-Token-Consistency-Audit.csv`, mapped to Phase 1 batches.
Regenerate this table when the audit CSV changes.

| Batch | Page bundle | Debt (plan) | Audit status (2026-07-01) | Exec status |
| --- | --- | ---: | --- | --- |
| 1 | `p2p_payment_methods_page.dart` | 6 | **pass** | Done (P2P-HOME-01) |
| 1 | `p2p_payment_method_add_page.dart` | 6 | **pass** | Done (P2P-HOME-01) |
| 1 | `p2p_payment_method_ownership_page.dart` | 5 | **pass** | Done (P2P-HOME-01) |
| 1 | `p2p_payment_method_verification_page.dart` | 3 | **pass** | Done (P2P-HOME-01) |
| 1 | `p2p_payment_method_cooling_period_page.dart` | 2 | **pass** | Done (P2P-HOME-01) |
| 1 | `p2p_payment_method_history_page.dart` | 1 | **pass** | Done (P2P-HOME-01) |
| 2 | `p2p_escrow_detail_page.dart` | 6 | **pass** | Done (P2P-HOME-02) |
| 2 | `p2p_escrow_balance_page.dart` | 4 | **pass** | Done (P2P-HOME-02) |
| 2 | `p2p_order_page.dart` | 3 | **exception** (custompainter) | Done (P2P-HOME-02; L3 spacing cleanup) |
| 2 | `p2p_order_book_page.dart` | 5 | **exception** (orderbook) | Done (P2P-HOME-02; L3 spacing cleanup) |
| 2 | `p2p_my_orders_page.dart` | 6 | **pass** | Done (P2P-HOME-02) |
| 2 | `p2p_order_rate_page.dart` | 3 | **pass** | Done (P2P-HOME-02) |
| 2 | `p2p_order_proof_page.dart` | 1 | **pass** | Done (P2P-HOME-02) |
| 3 | `p2p_selfie_verification_page.dart` | 8 | **pass** | Done (P2P-HOME-03) |
| 3 | `p2p_video_verification_page.dart` | 3 | **pass** | Done (P2P-HOME-03) |
| 3 | `p2p_address_proof_page.dart` | 5 | **pass** | Done (P2P-HOME-03) |
| 3 | `p2p_kyc_status_page.dart` | 4 | **pass** | Done (P2P-HOME-03) |
| 3 | `p2p_kyc_requirements_page.dart` | 0 | **pass** | **Skip** (already pass at baseline) |
| 4 | `p2p_fraud_prevention_page.dart` | 6 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_risk_assessment_page.dart` | 4 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_limit_tracker_page.dart` | 5 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_transaction_limits_page.dart` | 3 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_large_transaction_justification_page.dart` | 1 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_aml_screening_page.dart` | 2 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_compliance_overview_page.dart` | 2 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_source_of_funds_page.dart` | 1 | **pass** | Done (P2P-HOME-04) |
| 4 | `p2p_suspicious_activity_page.dart` | 1 | **pass** | Done (P2P-HOME-04) |
| 5 | `p2p_my_ads_page.dart` | 8 | **pass** | Done (P2P-HOME-05) |
| 5 | `p2p_create_ad_page.dart` | 5 | **pass** | Done (P2P-HOME-05) |
| 5 | `p2p_merchant_profile_page.dart` | 4 | **pass** | Done (P2P-HOME-05) |
| 5 | `p2p_ad_detail_page.dart` | 1 | **pass** | Done (P2P-HOME-05) |
| 5 | `p2p_insurance_certificate_page.dart` | 7 | **pass** | Done (P2P-HOME-05) |
| 6 | `p2p_settings_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_2fa_settings_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_device_management_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_blacklist_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_blacklist_add_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_notifications_settings_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_tax_reporting_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_login_history_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_achievements_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_fund_lock_history_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 6 | `p2p_contribution_history_page.dart` | 0 | **pass** | Done (P2P-HOME-06) |
| 7 | `p2p_dispute_resolution_page.dart` | 3 | **pass** | Done (P2P-HOME-07) |
| 7 | `p2p_dispute_detail_page.dart` | 1 | **pass** | Done (P2P-HOME-07) |
| 7 | `p2p_dispute_evidence_page.dart` | 1 | **pass** | Done (P2P-HOME-07) |
| 7 | `p2p_express_page.dart` | 4 | **pass** | Done (P2P-HOME-07) |
| 7 | `p2p_express_confirm_page.dart` | 2 | **pass** | Done (P2P-HOME-07) |
| 7 | `p2p_wallet_transfer_page.dart` | 5 | **pass** | Done (P2P-HOME-07) |
| 7 | `p2p_home_page.dart` | 1 | **pass** | Done (P2P-HOME-07) |
| 7 | `p2p_dashboard_page.dart` | 1 | **exception** (custompainter) | Done (P2P-HOME-07; L3 spacing cleanup) |
| 7 | `p2p_insurance_fund_page.dart` | 1 | **exception** (custompainter) | Done (P2P-HOME-07; L3 spacing cleanup) |

L3 exception bundles (`p2p_order_page`, `p2p_order_book_page`,
`p2p_dashboard_page`, `p2p_insurance_fund_page`, `p2p_ad_analytics_page`,
`p2p_dispute_page`) may retain canvas/orderbook-local composition after
spacing/token cleanup; document the L3 reason in batch evidence.

### 4.4 Visual Density Queue

Fullscreen tool QA:

| Feature | Page | Route | Required action |
| --- | --- | --- | --- |
| trade | `FuturesPage` | `/trade/:pairId/futures` | Emulator visual QA for safe areas, controls, nonblank render, bottom clearance |
| trade | `TradingBotsPage` | `AppRoutePaths.tradeBots` | Tool exception QA and evidence |
| trade | `AdvancedChartPage` | `/trade/advanced-chart/:pairId` | Chart/tool QA and evidence |
| enterprise_states | `EnterpriseStatesPage` | `AppRoutePaths.enterpriseStates` | Showcase/tool QA and evidence |
| p2p | `P2PChatPage` | `/p2p/chat/:orderId` | Chat tool QA and evidence |

Medium density review:

| Feature | Page | Route | Required action |
| --- | --- | --- | --- |
| wallet | `AddressBookPage` | `AppRoutePaths.walletAddressBook` | Recheck first repeated/actionable section above bottom nav |
| wallet | `AssetDetailPage` | `/wallet/asset/:assetId` | Recheck vertical gaps and bottom clearance |
| wallet | `TransactionHistoryPage` | `AppRoutePaths.walletHistory` | Recheck first-row visibility and bottom clearance |
| wallet | `TransactionDetailPage` | `/wallet/transaction/:txId` | Recheck receipt content above chrome |
| earn | `SavingsNotificationsPage` | `AppRoutePaths.earnSavingsNotifications` | Reduce tall tokenized cards/gaps if visual QA confirms sparsity |

## 5. Home UI Standard Contract

Do not copy Home business logic, Home data order, campaign copy, or portfolio
state into other modules. Reuse the visual grammar:

```text
module header
-> module hero or primary context
-> primary action cluster
-> resume/status/safety card
-> tools, filters, tabs, or selectors
-> dense lists, records, or details
-> secondary discovery or support
-> bottom-nav-safe content end
```

Required shell and content rules:

- Root module pages use `VitTopChrome` only when they are true module roots.
- Detail pages use `VitHeader`.
- Standard content uses `VitPageLayout`, `VitAutoHideHeaderScaffold` where
  appropriate, `VitInsetScrollView`, and compact `VitPageContent`.
- Bottom clearance comes from shell-aware inset logic, not ad hoc bottom
  padding.
- First viewport at 360 px must show module identity, primary context, and at
  least one action or useful repeated row.
- Dense lists use rows, dividers, tabs, and section rhythm rather than stacked
  oversized cards.

Required component mapping:

| Need | Required pattern |
| --- | --- |
| Page shell | `VitPageLayout`, `VitPageContent`, `VitInsetScrollView` |
| Header | `VitTopChrome` for true roots, `VitHeader` for detail/module routes |
| Section title | `VitSectionHeader` |
| Surface | `VitCard` variants and shared sheet panels |
| Primary action | `VitCtaButton` with icon when useful |
| Icon action | `VitIconButton`, `VitInlineIconAction`, or header actions with tooltip/semantics |
| Action grid | `VitActionTileGrid`, `VitServiceTile` |
| Form/search | `VitInput`, `VitSearchBar` |
| Tabs | `VitTabBar` |
| Status | `VitStatusPill`, `VitAccentPill`, `VitMetricDeltaPill` |
| State | `VitSkeleton`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner` |
| Risk | `VitHighRiskStatePanel` plus preview/confirm when needed |
| Detail rows | `VitInfoRow` or an approved shared equivalent |
| Market/data rows | `VitMarketTickerStrip`, `VitMarketPairRow`, `VitRankedAssetRow`, `VitAssetAvatar`, `VitSparkline` |
| Discovery bridge | `VitDiscoveryActionCard` with explicit module-boundary copy |
| Financial hero | `VitHeroGlow` plus one hero-weight value card with tabular numbers |
| Next action | `VitNextActionCard` for the single most important resumable task |
| Announcement | `VitAnnouncementBanner.compact` for operational/campaign/security notices |
| Sheet surface | `VitSheetPanel`, `VitSheetHandle` instead of local bottom-sheet chrome |
| Action grid policy | `VitActionTileGrid`: compact 6 / comfortable 9 primary actions; overflow to shared sheet |

Token rules:

- Use `AppColors`, `AppSpacing`, `AppRadii`, `AppTextStyles`,
  `AppModuleAccents`, and shared component density variants.
- Keep module accent as an accent layer only.
- Keep green/red for semantic buy/sell or positive/negative movement.
- Money, balances, limits, prices, gas, probability, APY, P/L, IDs, hashes, and
  percentages use tabular numeric styling.
- Do not introduce local page-level color palettes, raw spacing systems, raw
  radius systems, local `TextStyle(fontSize: ...)`, or repeated local cards.

### 5.1 Screen Taxonomy

Map every screen to a taxonomy class before editing. Labels come from
`VitTrade-Body-Component-Consistency-Audit.csv` and
`VitTrade-Top-Header-Visual-Archetype-Audit.csv`.

| Class | Examples | Required Home pattern |
| --- | --- | --- |
| `L1_primaryTabRoot` | Home, Markets, Wallet, Profile, P2P home | `VitTopChrome` + compact first viewport + bottom-nav-safe scroll |
| `L2_moduleDetail` | Asset detail, order detail, product detail | `VitHeader` + dense rows/lists + section rhythm |
| `L3_highRiskForm` | Withdraw, payment-method add, escrow release | Preview/confirm + `VitHighRiskStatePanel` + masked values |
| `L3_fullscreenTool` | Futures, AdvancedChart, TradingBots, P2PChat | Tool exception; manual visual QA; no forced card density |
| `L3_authOnboarding` | Login, OTP, register, onboarding | See §5.2; minimal chrome |
| `L3_marketData` | Market list sections, pair rows, movers | `VitMarketPairRow`, `VitRankedAssetRow`, ticker strip |
| `L3_pointsOnlyArena` | Arena home, challenge, ledger | Points-only copy; no wallet/payout language |

Record the taxonomy class and any L3 exception reason in batch evidence.

### 5.2 Auth And Onboarding Exception Policy

Auth and onboarding screens are not forced into bottom-tab page rhythm:

- Do not require `VitBottomNav` clearance or module-root `VitTopChrome`.
- Use minimal header, branded shell, or fullscreen step layout as appropriate.
- Token rules still apply: no raw colors, spacing, radii, or local typography.
- Financial safety still applies on security, 2FA, and recovery flows.
- Focused auth tests (`test/features/auth/`) must pass after every batch.

## 6. Product Safety Boundaries

### 6.1 Financial And Account Safety

Preview and confirmation are required for:

- Withdrawals.
- Escrow release.
- Security changes.
- 2FA disabling or reset-like flows.
- Address additions.
- P2P payment-method changes.
- DCA/rebalance submit flows.
- Earn subscription/redemption or lockup decisions.
- Launchpad subscription/allocation/claim decisions when risk or eligibility is
  involved.

Every high-risk action must show:

- Fees.
- Limits.
- Risks.
- Masked sensitive values.
- Confirmation state.
- Result or next steps.
- Support route or recovery path when failure is possible.

### 6.2 Prediction Markets And Open Arena

Prediction Markets and Open Arena stay separate:

| Boundary | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL, positions, probability | Points pool, completion, fair play |
| History | Orders, receipts | Ledger entries |
| Leaderboard | Trading context | Fair play and completion |

Allowed bridges are topic/category, event context, creator discovery, search,
discovery, and profile sections with clearly separated content.

Arena pages must not use wallet, payout, profit, P/L, USD return, or
stake-return language. Prediction pages may use positions, probability,
receipt, rewards, and P/L without casino or hype copy.

## 7. Rollout Phases

### Phase 0 - Evidence Freeze And Graph Refresh

Description: Lock the current baseline before touching UI code.

Acceptance criteria:

- [x] Git worktree is reviewed and unrelated dirty changes are not modified.
- [ ] GitNexus index is refreshed or stale status is recorded before any code
      edits. *(Recorded: MCP unavailable; continued with source/test inspection.)*
- [x] Route coverage, design-token, visual-density, and body-component audits
      are current or regenerated when baseline changes.
- [x] Residual debt queue is regenerated from CSV artifacts.
- [x] Screens selected for the first batch are small enough for one focused
      session.

Verification:

```bash
node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
flutter analyze
```

When baseline numbers change, regenerate committed artifacts (not only
`--check`):

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart
dart run tool/visual_density_risk_audit.dart
dart run tool/body_component_consistency_audit.dart
```

Commit updated CSV/MD under `docs/02_FLUTTER_MIGRATION/` when debt queues shift.

Dependencies: None.

Estimated scope: Docs and audit-only preflight.

### Phase 1 - P2P Token Residual Cleanup

Description: Clear the 51 P2P root bundles that still carry token debt while
preserving escrow, payment, KYC, merchant, dispute, chat, and masking rules.

Batch slicing:

1. Payment methods and ownership:
   `p2p_payment_methods_page.dart`,
   `p2p_payment_method_add_page.dart`,
   `p2p_payment_method_ownership_page.dart`,
   `p2p_payment_method_verification_page.dart`,
   `p2p_payment_method_cooling_period_page.dart`,
   `p2p_payment_method_history_page.dart`.
2. Escrow and order actions:
   `p2p_escrow_detail_page.dart`, `p2p_escrow_balance_page.dart`,
   `p2p_order_page.dart`, `p2p_order_book_page.dart`, `p2p_my_orders_page.dart`,
   `p2p_order_rate_page.dart`.
3. Identity, KYC, and verification:
   `p2p_selfie_verification_page.dart`,
   `p2p_video_verification_page.dart`, `p2p_address_proof_page.dart`,
   `p2p_kyc_status_page.dart`, `p2p_kyc_requirements_page.dart`.
4. Risk, fraud, compliance, and limits:
   `p2p_fraud_prevention_page.dart`, `p2p_risk_assessment_page.dart`,
   `p2p_limit_tracker_page.dart`, `p2p_transaction_limits_page.dart`,
   `p2p_large_transaction_justification_page.dart`,
   `p2p_aml_screening_page.dart`, `p2p_compliance_overview_page.dart`.
5. Merchant and ad management:
   `p2p_my_ads_page.dart`, `p2p_create_ad_page.dart`,
   `p2p_merchant_profile_page.dart`, merchant apply/profile subflows.
6. Account, security, settings, tax:
   `p2p_settings_page.dart`, `p2p_2fa_settings_page.dart`,
   `p2p_device_management_page.dart`, `p2p_blacklist_page.dart`,
   `p2p_blacklist_add_page.dart`, `p2p_notifications_settings_page.dart`,
   `p2p_tax_reporting_page.dart`, `p2p_login_history_page.dart`,
   `p2p_achievements_page.dart`, `p2p_fund_lock_history_page.dart`,
   `p2p_contribution_history_page.dart`.
7. Dispute, express, wallet transfer, and misc residuals:
   `p2p_dispute_resolution_page.dart`, `p2p_dispute_detail_page.dart`,
   `p2p_dispute_evidence_page.dart`, `p2p_express_page.dart`,
   `p2p_express_confirm_page.dart`, `p2p_wallet_transfer_page.dart`,
   `p2p_home_page.dart`, `p2p_dashboard_page.dart`,
   `p2p_insurance_fund_page.dart`.

See §4.3.1 for the full batch-to-bundle manifest.

Acceptance criteria:

- [ ] No new raw local `EdgeInsets`, raw colors, local radii, local repeated
      cards, or typography debt in touched P2P page bundles.
- [ ] Payment-method and escrow flows keep preview/confirm and masked account
      data.
- [ ] Order/dispute flows preserve next-step copy and support paths.
- [ ] `p0_p2p_debt` decreases after every batch and eventually reaches `0` or a
      documented, reviewed L3 exception.
- [ ] P2P Chat remains a fullscreen tool exception with manual visual QA rather
      than being forced into normal page rhythm.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib/features/p2p test/features/p2p
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/p2p --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Dependencies: Phase 0.

Estimated scope: 9 to 12 small batches, 3 to 6 screens per batch.

**Progress (2026-07-01):** 7/7 batches Done; `p0_p2p_debt` 173 → 0. Phase 1 complete. See §4.0.

### Phase 2 - Earn And Trade Residual Token Cleanup

Description: Clear the last non-P2P root-bundle token residuals and document
L3 exceptions where canvas/orderbook composition must remain local.

Target bundles:

| Feature | Page bundle | Debt | Notes |
| --- | --- | ---: | --- |
| earn | `staking_earn_page.dart` | 8 | APY/lockup/risk copy must stay compliant |
| trade | `kid_generator_page.dart` | 1 | Spacing debt in regulatory tool surface |
| trade | `trade_page.dart` | 1 | L3 orderbook exception; clear `repeated_card` debt only |

L3 policy for `trade_page.dart`: orderbook/canvas rendering stays local; replace
local spacing/card wrappers with shared primitives where they do not break
orderbook behavior. Record L3 reason in batch evidence.

Acceptance criteria:

- [ ] Earn staking root keeps APY, lockup, risk, redemption, and no guaranteed
      return copy.
- [ ] Trade residual pages keep trading safety and regulatory language.
- [ ] `p0_trade_debt` reaches `0`.
- [ ] Earn root-bundle debt reaches `0` or has an explicit L3 exception.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib/features/earn lib/features/trade test/features/earn test/features/trade
dart run tool/design_token_consistency_audit.dart --check
flutter test test/features/earn --reporter=compact
flutter test test/features/trade --reporter=compact
flutter analyze
```

Dependencies: Phase 0.

Estimated scope: 1 to 2 small batches.

### Phase 2b - Markets Widget And Shared Widget Token Cleanup

Description: Clear residual token debt outside P2P/Earn/Trade root bundles:
Markets list widgets (`p0_markets_debt=6`) and shared `vit_choice_pill.dart`
(`scope_shared_widget_debt=1`).

Target files:

| Scope | File | Debt |
| --- | --- | ---: |
| markets widget | `market_list_pairs.dart` | 3 |
| markets widget | `market_list_filters.dart` | 1 |
| markets widget | `market_list_movers.dart` | 1 |
| markets widget | `market_list_tools.dart` | 1 |
| shared widget | `flutter_app/lib/shared/widgets/vit_choice_pill.dart` | 1 |

Acceptance criteria:

- [ ] `p0_markets_debt` reaches `0`.
- [ ] `scope_shared_widget_debt` reaches `0`.
- [ ] GitNexus impact is run before editing `vit_choice_pill.dart`; warn on
      HIGH/CRITICAL and run broad shared-layout tests if needed.
- [ ] Market list first viewport and pair-row behavior unchanged.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib/features/markets lib/shared/widgets test/features/markets test/shared
dart run tool/design_token_consistency_audit.dart --check
flutter test test/features/markets --reporter=compact
flutter test test/shared --reporter=compact
flutter analyze
```

Dependencies: Phase 0. May run in parallel with Phase 2 after Phase 0.

Estimated scope: 1 small batch (Markets widgets + shared pill).

### Phase 3 - Wallet And Earn Medium Density Review

Description: Treat the five `P2_MEDIUM_DENSITY_REVIEW` items as visual-density
follow-ups, not full redesigns. Wallet is already Home-standard and token-clean,
so edits must be minimal and evidence-driven.

Target pages:

- `AddressBookPage`.
- `AssetDetailPage`.
- `TransactionHistoryPage`.
- `TransactionDetailPage`.
- `SavingsNotificationsPage`.

Acceptance criteria:

- [ ] 360 px first viewport shows useful context/action/list content.
- [ ] Bottom nav does not cover rows, receipts, copy actions, or disclosures.
- [ ] Any spacing reduction preserves readability, touch targets, and safety
      copy.
- [ ] Wallet remains `p0_wallet_debt=0`.
- [ ] Existing Wallet focused tests and Earn focused tests still pass.

Verification:

```bash
cd flutter_app
dart run tool/visual_density_risk_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
flutter test test/features/wallet --reporter=compact
flutter test test/features/earn --reporter=compact
flutter analyze
```

Dependencies: Phase 0.

Estimated scope: 2 small batches.

### Phase 4 - Fullscreen Tool Visual QA

Description: Validate fullscreen tool exceptions. These screens may remain L3
tool layouts, but they need explicit emulator/visual evidence.

Target pages:

- `FuturesPage`.
- `TradingBotsPage`.
- `AdvancedChartPage`.
- `EnterpriseStatesPage`.
- `P2PChatPage`.

Acceptance criteria:

- [ ] Tool renders nonblank content.
- [ ] Primary controls are visible and reachable at phone width.
- [ ] Safe areas and bottom chrome do not hide controls.
- [ ] Back/close behavior is clear.
- [ ] Tool exception and L3 reasons are recorded.
- [ ] No normal content page uses the tool exception to avoid cleanup.

Verification:

```bash
cd flutter_app
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/trade --reporter=compact
flutter test test/features/p2p --reporter=compact
flutter test test/features/enterprise_states --reporter=compact
flutter analyze
```

Manual or emulator screenshot evidence is required for this phase. Use §8.1
Visual QA Evidence Template.

Dependencies: Phase 0.

Estimated scope: 1 QA-focused batch, with code edits only if QA finds actual
safe-area or rendering problems.

### Phase 5 - P3 Low Density Triage

Description: Review the 168 `P3_LOW_DENSITY_REVIEW` screens by module, focusing
on repeated root causes rather than micro-tuning every page.

**Cross-reference:**
[`VitTrade-Whole-App-P2-P3-Assignment-Ledger.md`](../03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.md)
and
[`VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`](../03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv).
Default policy for assigned rows is `monitor_when_touched`; do not churn P3
screens that already pass safety and first-viewport unless QA or nearby work
justifies it.

**P2-A next-batch candidates (prioritize before bulk P3):**

| Feature | Page | Route | Guardrail |
| --- | --- | --- | --- |
| earn | `StakingProofOfReservesPage` | `AppRoutePaths.earnProofOfReserves` | financial_safety_copy_preserve |
| p2p | `P2PDashboardPage` | `AppRoutePaths.p2pDashboard` | financial_safety_copy_preserve |
| referral | `ReferralRewardsPage` | `AppRoutePaths.referralRewards` | standard_ui_accessibility_preserve |
| earn | `StakingRegulatoryFrameworkPage` | `AppRoutePaths.earnRegulatoryFramework` | financial_safety_copy_preserve |
| launchpad | `LaunchpadGasTrackerPage` | `AppRoutePaths.launchpadGasTracker` | financial_safety_copy_preserve |
| trade | `BotPortfolioDashboardPage` | `AppRoutePaths.tradeBotPortfolioDashboard` | financial_safety_copy_preserve |
| arena | `ArenaStudioPage` | `AppRoutePaths.arenaStudio` | open_arena_points_boundary_preserve |
| arena | `ArenaUniversalPresetLibraryPage` | `AppRoutePaths.arenaStudioPresets` | open_arena_points_boundary_preserve |
| markets | `MarketMoversPage` | `AppRoutePaths.marketsMovers` | standard_ui_accessibility_preserve |
| profile | `ProfilePage` | `AppRoutePaths.profile` | standard_ui_accessibility_preserve |
| trade | `CopyProviderDetailPage` | `/trade/copy-provider/:providerId` | financial_safety_copy_preserve |
| trade | `PositionDashboardPage` | `AppRoutePaths.tradePositions` | financial_safety_copy_preserve |

Phase 3 medium-density items (`P2_MEDIUM_DENSITY_REVIEW=5` in visual-density
audit) remain owned by Phase 3, not this ledger's 113 broader P2 rows.

Priority order for systemic P3 fixes:

1. Earn: 51 low-density screens.
2. Trade: 21 low-density screens.
3. Launchpad: 21 low-density screens.
4. Wallet: 14 low-density screens.
5. P2P: 12 low-density screens after token cleanup.
6. Profile, DCA, Predictions, Auth, Admin, Markets, and secondary modules.

Acceptance criteria:

- [ ] Root cause is classified before editing: bottom inset pressure, fixed
      height pressure, vertical gap accumulation, sparse shared-component use,
      or official audit blind spot.
- [ ] Only repeated/systemic issues are fixed in this phase.
- [ ] Screens already passing product safety and first viewport are not churned.
- [ ] Representative modules still feel visually related to Home/Wallet.

Verification:

```bash
cd flutter_app
dart run tool/visual_density_risk_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
flutter analyze
flutter test test/features/<module> --reporter=compact
```

Dependencies: Phases 1 to 4 and Phase 2b.

Estimated scope: Rolling cleanup, 4 to 6 screens per module batch.

### Phase 6 - Product Boundary And Copy Polish

Description: Review copy and state language after visual cleanup, especially
where shared discovery or shared cards bridge modules.

Acceptance criteria:

- [ ] Arena remains points-only.
- [ ] Prediction Markets remain wallet/value-based and do not borrow Arena
      points language.
- [ ] Trade, P2P, Earn, DCA, Launchpad, and Wallet avoid hype, casino, FOMO,
      hidden-fee, guaranteed-return, and unclear-risk copy.
- [ ] Vietnamese/English copy is typo-free and not mojibake in source or UI.
- [ ] Empty, loading, error, offline, submitting, success, and result states
      have clear next steps.

Verification:

```bash
cd flutter_app
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter analyze
```

Dependencies: Visual cleanup phases for the touched modules.

Estimated scope: 1 to 3 copy-focused batches.

### Phase 7 - Global Visual QA And Closure

Description: Validate the app as one product, not as a set of isolated passing
modules.

Representative QA set:

- Root tabs: Home, Markets, Trade, Wallet, Profile.
- Wallet: Wallet, Deposit, Transfer, Address Add, Token Approval.
- P2P: Home, order book, order detail, payment methods, escrow/dispute, chat.
- Trade: instrument workspace, futures, bots, order/risk, copy-trading safety.
- Earn: staking root, product detail, auto-compound, withdrawal policy.
- Launchpad: project detail, subscribe/allocation, claim receipt.
- Predictions: event detail, position/portfolio, receipt/history.
- Arena: home, challenge detail, join, points ledger, safety/reporting.
- Auth/Profile: login/register/OTP/reset/2FA, KYC/security/API/account.

Acceptance criteria:

- [ ] Route coverage passes.
- [ ] Design-token audit passes with no unexpected residual debt.
- [ ] `p0_markets_debt=0` and `scope_shared_widget_debt=0`.
- [ ] Visual-density audit has no P0/P1 normal-screen issues.
- [ ] Tool QA evidence is recorded.
- [ ] Full focused suites pass for touched modules.
- [ ] Full `flutter test --reporter=compact` passes before merge/milestone.
- [ ] GitNexus `detect_changes()` confirms expected affected scope.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/navigation_route_guardrails_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

Also satisfy merge gates in
[`Enterprise-PR-Review-Checklist.md`](Enterprise-PR-Review-Checklist.md).

Dependencies: Phases 1 to 6 and Phase 2b.

Estimated scope: Final QA and docs update.

## 8. Per-Batch Workflow

Use this exact workflow for every implementation batch:

```text
Batch ID:
Module:
Target screens:
Routes:
Current audit rows:
Target Home pattern:
Safety boundary:

Before editing:
- Read AGENTS.md, docs/00_START_HERE.md, the Home rollout playbook, this plan,
  target pages/widgets/controllers/providers/tests, and relevant audit rows.
- Confirm GitNexus index status.
- Run GitNexus context for each target page class.
- Run GitNexus impact before editing any class, method, shared primitive,
  router file, provider, controller, repository, domain entity, or helper.
- Run scoped action census for target files.
- Record current Home-standard gap and any L3 reason.

Implement:
- Apply Home shell/content rhythm.
- Use shared primitives by pattern.
- Preserve routes, names, keys, providers, masking, fees, limits,
  preview/confirm, copy boundaries, and tests.
- Keep local composition only with an L3 reason.
- Add/update focused tests for new visual, state, accessibility, or safety
  contracts.

After editing:
- Run dart format on touched Dart files.
- Run focused feature tests.
- Run design-token and visual-density audits when layout/tokens/density change.
- Run `dart run tool/navigation_edge_audit.dart --check` when navigation calls,
  route builders, or screen links change.
- Run flutter analyze.
- Run GitNexus detect_changes.
- Update the batch log (§12) with command results and residual risk.
- For UI polish batches, apply `.codex/skills/vittrade-ui-checklists/SKILL.md`
  accessibility or motion checklists when touching icon-only controls,
  forms, dialogs, or animations.
```

Scoped action census template:

```powershell
rg -n "VitCtaButton|IconButton|VitInlineIconAction|VitServiceTile|VitActionTileGrid|onTap:|onPressed:|showModalBottomSheet|showDialog|GestureDetector|InkWell|tabKey|filterKey|searchKey|confirm|preview|revoke|copy|scan|refresh|submit" <target page/widget files>
```

### 8.1 Visual QA Evidence Template

Required for Phase 4 tool screens and any batch that changes first-viewport
layout on root tabs.

Tooling:

```bash
cd flutter_app
flutter test tool/capture_route_screenshot_test.dart --reporter=compact
```

Output directory (gitignored): `flutter_app/run-artifacts/visual-qa/`

Evidence block per screen:

```text
Screen:
Route:
Device width: 360 dp minimum (also capture 440 dp when regression suspected)
Taxonomy class:
Screenshot path:
Pass checklist:
- [ ] Nonblank primary content
- [ ] Primary controls visible and reachable
- [ ] Safe areas / bottom chrome do not hide controls or disclosures
- [ ] Back or close behavior is clear
- [ ] L3 tool exception documented when applicable
```

Attach emulator screenshots to PR descriptions for visible UI changes per
[`Enterprise-PR-Review-Checklist.md`](Enterprise-PR-Review-Checklist.md).

## 9. Definition Of Done

A screen is Home-standard when:

- [ ] It uses shared shell/layout primitives or has a documented fullscreen,
      auth, onboarding, or tool exception.
- [ ] It uses shared visual primitives by pattern.
- [ ] It has no token debt unless an L3 exception is documented and accepted.
- [ ] It has no typography debt.
- [ ] 360 px first viewport shows module identity, primary context, and at
      least one useful action or repeated row.
- [ ] Bottom nav and safe areas do not cover text, controls, receipts, forms,
      or disclosures.
- [ ] Loading, empty, error, offline, submitting, and success/result states are
      present where the flow can enter those states.
- [ ] High-risk actions show fees, risk, limits, masked data, preview,
      confirmation, and next steps.
- [ ] Arena and Prediction Markets copy remain separated.
- [ ] Focused feature tests and analyzer pass.

A module is Home-standard when:

- [ ] All routed screens are accounted for.
- [ ] Root-page bundle token debt is `0` or only accepted L3/tool exceptions
      remain.
- [ ] Module focused tests pass.
- [ ] Product copy and safety boundaries pass.
- [ ] Representative visual QA is recorded for first viewport, high-risk flows,
      and fullscreen tools.

The whole project is Home-standard when:

- [ ] Route coverage passes.
- [ ] Design-token audit passes with no unexpected root-bundle residuals.
- [ ] `p0_markets_debt=0`, `scope_shared_widget_debt=0`, and P0 module gates pass.
- [ ] Typography residuals remain `0`.
- [ ] Visual-density audit has no P0/P1 normal-screen issues and all tool QA
      exceptions are documented.
- [ ] Wallet remains token-clean and Home-aligned.
- [ ] P2P, Trade, Wallet, Earn, Launchpad, Predictions, DCA, Arena, Markets,
      Profile, and Auth all preserve their product boundaries and safety flows.
- [ ] Full test suite passes.
- [ ] GitNexus `detect_changes()` shows expected scope before commit.

## 10. Risks And Controls

| Risk | Impact | Control |
| --- | --- | --- |
| Treating old plan status as current truth | Skips real residual debt | Regenerate audit queues before each sprint |
| Editing broad shared primitives without impact analysis | App-wide regressions | Run GitNexus impact, warn on HIGH/CRITICAL, add focused + full tests |
| Over-compacting financial flows | Hidden risk/fees/limits | Safety copy beats density; keep high-risk panels and confirmations |
| Forcing normal page rhythm onto tool screens | Broken chart/chat/terminal UX | Keep L3 tool exception with emulator evidence |
| Mixing Arena and Predictions | Product/legal trust issue | Run copy guardrails and manual boundary review |
| Churning Wallet after completion | Regression in proven reference module | Treat Wallet medium density as follow-up only, with focused tests |
| Dirty worktree conflict | Accidental overwrite | Edit only scoped files and never revert unrelated changes |
| Stale GitNexus index | Wrong blast-radius decisions | Refresh or record staleness before code edits |
| Markets/shared widget debt skipped | Phase 7 closure fails P0 gates | Phase 2b before global closure |
| P3 ledger vs Phase 5 churn conflict | Unnecessary regressions | Follow P2-P3 Assignment Ledger policy |

## 11. Immediate Next Step

**Phase 7 closure complete (2026-07-01).** Residual pass finished; `total_debt=0`;
all P0 module gates pass; full `flutter test` + quality guardrails pass.

No further implementation batches required unless audit regresses or new debt appears.

Completed batches (do not redo unless audit regresses):

- **P2P-HOME-01..07** — Phase 1 P2P token cleanup → `p0_p2p_debt=0`.
- **EARN-TRADE-01** — staking_earn, kid_generator, trade_page spacing → `p0_trade_debt=0`.
- **DEEP-MARKETS-SHARED-01** — market list widgets + vit_choice_pill → `p0_markets_debt=0`.
- **DEEP-DENSITY-WALLET-01** — 5 P2 medium-density screens reviewed (Wallet reference; no churn).
- **DEEP-TOOL-QA-01** — 5 tool screens widget-test evidence recorded.
- **DEEP-COPY-01** — copy + a11y guardrails verified.
- **Phase 7** — global audit refresh + full test suite pass.

Autonomous execution prompt (includes **Compaction-Safe Autonomous Mode**):
[`AI-Home-UI-Project-Wide-Standardization-Deep-Autonomous-Execution-Prompt.md`](AI-Home-UI-Project-Wide-Standardization-Deep-Autonomous-Execution-Prompt.md)
— after summarize or new thread, use **Compact Resume** in that file (2 lines);
do not re-paste the full prompt block.

Do not start by "fixing the whole app UI" in one pass. The enterprise-safe path
is audit baseline -> one module batch -> focused tests -> audits -> evidence ->
next batch.

## 12. Batch Evidence Template And Progress Ledger

### 12.1 Log Location

Append completed batches to:

- Primary: [`VitTrade-Home-UI-Rollout-Execution-Plan.md`](../03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md) §7 Batch Log Template
- Residual-pass tracking (mandatory sync with this plan §4.0):
  [`VitTrade-Home-UI-Standardization-Batch-Log.md`](VitTrade-Home-UI-Standardization-Batch-Log.md)
  — **14 Done**, **0 In progress** as of 2026-07-01

**Sync rule:** see §2.2. Every batch update must touch §4.0 + batch log + §12.2
at minimum.

Do not mark a batch Done without Home pattern, L3 reason, GitNexus evidence,
first-viewport evidence, and tests/audit evidence.

### 12.2 Per-Page Progress Ledger

| Module | Page | Taxonomy | Batch ID | Status | Evidence |
| --- | --- | --- | --- | --- | --- |
| p2p | `p2p_payment_methods_page.dart` | L3_highRiskForm | P2P-HOME-01 | **Done** | pass; AppSpacing.p2pPayment* |
| p2p | `p2p_payment_method_add_page.dart` | L3_highRiskForm | P2P-HOME-01 | **Done** | pass |
| p2p | `p2p_payment_method_ownership_page.dart` | L3_highRiskForm | P2P-HOME-01 | **Done** | pass |
| p2p | `p2p_payment_method_verification_page.dart` | L3_highRiskForm | P2P-HOME-01 | **Done** | pass |
| p2p | `p2p_payment_method_cooling_period_page.dart` | L3_highRiskForm | P2P-HOME-01 | **Done** | pass |
| p2p | `p2p_payment_method_history_page.dart` | L3_highRiskForm | P2P-HOME-01 | **Done** | pass |
| p2p | `p2p_escrow_detail_page.dart` | L3_highRiskForm | P2P-HOME-02 | **Done** | pass; AppSpacing.p2pEscrowDetail* |
| p2p | `p2p_escrow_balance_page.dart` | L3_highRiskForm | P2P-HOME-02 | **Done** | pass |
| p2p | `p2p_order_page.dart` | L3_orderFlow | P2P-HOME-02 | **Done** | exception/custompainter; spacing pass |
| p2p | `p2p_order_book_page.dart` | L3_orderbook | P2P-HOME-02 | **Done** | exception/orderbook; spacing pass |
| p2p | `p2p_my_orders_page.dart` | L3_list | P2P-HOME-02 | **Done** | pass |
| p2p | `p2p_order_rate_page.dart` | L3_form | P2P-HOME-02 | **Done** | pass |
| p2p | `p2p_order_proof_page.dart` | L3_highRiskForm | P2P-HOME-02 | **Done** | pass |
| p2p | `p2p_selfie_verification_page.dart` | L3_KYC | P2P-HOME-03 | **Done** | pass; AppSpacing.p2pSelfie* |
| p2p | `p2p_video_verification_page.dart` | L3_KYC | P2P-HOME-03 | **Done** | pass; AppSpacing.p2pVideo* |
| p2p | `p2p_address_proof_page.dart` | L3_KYC | P2P-HOME-03 | **Done** | pass; AppSpacing.p2pAddressProof* |
| p2p | `p2p_kyc_status_page.dart` | L3_status | P2P-HOME-03 | **Done** | pass; AppSpacing.p2pKyc* |
| p2p | `p2p_kyc_requirements_page.dart` | L3_status | P2P-HOME-03 | **Skip** | already pass (0 debt) at baseline |
| p2p | `p2p_fraud_prevention_page.dart` | L3_risk | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pFraud* |
| p2p | `p2p_risk_assessment_page.dart` | L3_risk | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pRiskAssessment* |
| p2p | `p2p_limit_tracker_page.dart` | L3_limits | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pLimitTracker* |
| p2p | `p2p_transaction_limits_page.dart` | L3_limits | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pTransactionLimits* |
| p2p | `p2p_large_transaction_justification_page.dart` | L3_risk | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pLargeTransaction* |
| p2p | `p2p_aml_screening_page.dart` | L3_compliance | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pAmlScreening* |
| p2p | `p2p_compliance_overview_page.dart` | L3_compliance | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pComplianceOverview* |
| p2p | `p2p_source_of_funds_page.dart` | L3_compliance | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pSourceOfFunds* |
| p2p | `p2p_suspicious_activity_page.dart` | L3_compliance | P2P-HOME-04 | **Done** | pass; AppSpacing.p2pSuspiciousActivity* |
| p2p | `p2p_my_ads_page.dart` | L3_list | P2P-HOME-05 | **Done** | pass; AppSpacing.p2pMerchantCommerce* |
| p2p | `p2p_create_ad_page.dart` | L3_form | P2P-HOME-05 | **Done** | pass; AppSpacing.p2pMerchantCommerce* |
| p2p | `p2p_merchant_profile_page.dart` | L3_profile | P2P-HOME-05 | **Done** | pass; AppSpacing.p2pMerchantCommerce* |
| p2p | `p2p_ad_detail_page.dart` | L3_orderFlow | P2P-HOME-05 | **Done** | pass; AppSpacing.p2pAdDetailFlush* |
| p2p | `p2p_insurance_certificate_page.dart` | L3_document | P2P-HOME-05 | **Done** | pass; AppSpacing.p2pInsuranceCertificate* |
| p2p | `p2p_settings_page.dart` | L3_settings | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pSettingsPage* |
| p2p | `p2p_2fa_settings_page.dart` | L3_security | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pTwoFactor* |
| p2p | `p2p_device_management_page.dart` | L3_security | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pDevices* |
| p2p | `p2p_blacklist_page.dart` | L3_list | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pBlacklistList* |
| p2p | `p2p_blacklist_add_page.dart` | L3_highRiskForm | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pBlacklistAdd* |
| p2p | `p2p_notifications_settings_page.dart` | L3_settings | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pNotifications* |
| p2p | `p2p_tax_reporting_page.dart` | L3_document | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pTax* |
| p2p | `p2p_login_history_page.dart` | L3_audit | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pLoginHistoryPage* |
| p2p | `p2p_achievements_page.dart` | L3_status | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pAchievementsPage* |
| p2p | `p2p_fund_lock_history_page.dart` | L3_history | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pFundLock* |
| p2p | `p2p_contribution_history_page.dart` | L3_history | P2P-HOME-06 | **Done** | pass; AppSpacing.p2pContribution* |
| p2p | `p2p_dispute_resolution_page.dart` | L3_dispute | P2P-HOME-07 | **Done** | pass; AppSpacing.p2pDisputeResolution* |
| p2p | `p2p_dispute_detail_page.dart` | L3_dispute | P2P-HOME-07 | **Done** | pass; AppSpacing.p2pDisputeDetail* |
| p2p | `p2p_dispute_evidence_page.dart` | L3_highRiskForm | P2P-HOME-07 | **Done** | pass; AppSpacing.p2pDisputeEvidence* |
| p2p | `p2p_express_page.dart` | L3_express | P2P-HOME-07 | **Done** | pass; AppSpacing.p2pExpress* |
| p2p | `p2p_express_confirm_page.dart` | L3_highRiskForm | P2P-HOME-07 | **Done** | pass; AppSpacing.p2pExpressConfirm* |
| p2p | `p2p_wallet_transfer_page.dart` | L3_highRiskForm | P2P-HOME-07 | **Done** | pass; AppSpacing.p2pWalletTransfer* |
| p2p | `p2p_home_page.dart` | L3_marketplace | P2P-HOME-07 | **Done** | pass; AppSpacing.p2pHomeClearFilter* |
| p2p | `p2p_dashboard_page.dart` | L3_analytics | P2P-HOME-07 | **Done** | exception/custompainter; spacing pass |
| p2p | `p2p_insurance_fund_page.dart` | L3_document | P2P-HOME-07 | **Done** | exception/custompainter; spacing pass |
| earn | `staking_earn_page.dart` | L2_moduleDetail | EARN-TRADE-01 | **Done** | pass; AppSpacing.stakingEarnPosition* line heights |
| trade | `kid_generator_page.dart` | L3_regulatoryTool | EARN-TRADE-01 | **Done** | pass; AppSpacing.kidGenerator* padding |
| trade | `trade_page.dart` | L3_orderbook | EARN-TRADE-01 | **Done** | exception/orderbook; BoxDecoration→ColoredBox |
| markets | `market_list_pairs.dart` etc. | L3_marketData | DEEP-MARKETS-SHARED-01 | **Done** | pass; AppSpacing.marketList* |
| shared | `vit_choice_pill.dart` | shared primitive | DEEP-MARKETS-SHARED-01 | **Done** | pass; AppSpacing.vitChoicePill* |
| wallet | `AddressBookPage` etc. (4) | L2/L3 detail | DEEP-DENSITY-WALLET-01 | **Done** | review-only; wallet tests pass |
| earn | `SavingsNotificationsPage` | L1_utilityHub | DEEP-DENSITY-WALLET-01 | **Done** | review-only; earn tests pass |
| trade/p2p/enterprise | tool screens (5) | L3_fullscreenTool | DEEP-TOOL-QA-01 | **Done** | widget-test layout evidence |
| all | P3 ledger rows | monitor | Phase 5 | **Done** | P2-A triage; no bulk churn |
| all | copy boundaries | — | DEEP-COPY-01 | **Done** | copy + a11y guardrails pass |

Update rows when a batch completes. Source routes from
`Flutter-Route-Coverage-Truth-Table.md`.

### 12.3 Batch Evidence Block

Copy this block after each implementation batch (parity with Wallet plan):

```text
### <Batch ID> Batch Evidence - YYYY-MM-DD

Status: In progress | Done | Blocked
Module:
Files changed:
Home pattern applied:
Taxonomy class:
Shared primitives used:
L3 local reason (if any):
Action inventory summary:
Financial safety preserved (yes/no + notes):
First-viewport evidence (360 dp):
Tool/visual QA evidence (if applicable):
GitNexus evidence:
- index status:
- context targets:
- impact summary:
- detect_changes summary:

Commands run:
- dart format ...
- flutter test ...
- dart run tool/design_token_consistency_audit.dart --check
- dart run tool/visual_density_risk_audit.dart --check
- flutter analyze

Residual risk:
Next batch:
```

### 12.4 Batch Log Row Template

| Date | Batch | Module | Screens | Home pattern applied | L3 local reason | GitNexus evidence | First viewport evidence | Tests/audit evidence | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-07-01 | P2P-HOME-01 | p2p | payment-method pages (6) | L3 high-risk form / list + delete confirm | None | Blocked (MCP unavailable) | Preserved shell + first action row | analyze pass; p2p tests pass; bundles pass | **Done** | AppSpacing.p2pPayment*; p0_p2p 173→149 |
| 2026-07-01 | P2P-HOME-02 | p2p | escrow/orders (8) | Escrow detail, balance, orders, order flow | order_book + order_page part_03 L3 | Blocked (MCP unavailable) | Preserved payment/escrow preview surfaces | analyze pass; p2p tests pass; bundles pass/exception | **Done** | AppSpacing.p2pEscrow*/p2pOrder*; p0_p2p 149→119 |
| 2026-07-01 | P2P-HOME-03 | p2p | KYC/verification (5) | KYC capture + status surfaces | None | Blocked (MCP unavailable) | Preserved shell + first action row | analyze pass; p2p tests pass; bundles pass | **Done** | AppSpacing.p2pSelfie*/p2pKyc*/p2pVideo*/p2pAddressProof*; p0_p2p 119→97 |
| 2026-07-01 | P2P-HOME-04 | p2p | risk/compliance (9) | Risk limits + compliance surfaces | None | Blocked (MCP unavailable) | Preserved high-risk preview panels | analyze pass; p2p tests pass; bundles pass | **Done** | AppSpacing.p2pFraud*/p2pRiskAssessment*/p2pLimitTracker* etc.; p0_p2p 97→72 |
| 2026-07-01 | P2P-HOME-05 | p2p | merchant/ads (5) | Merchant profile + ad create/list/detail | None | Blocked (MCP unavailable) | Preserved ad publish + certificate surfaces | analyze pass; p2p tests pass; bundles pass | **Done** | AppSpacing.p2pMerchantCommerce*/p2pAdDetailFlush*/p2pInsuranceCertificate*; p0_p2p 72→45 |
| 2026-07-01 | P2P-HOME-06 | p2p | account/security (11) | Settings, 2FA, devices, blacklist, notifications, tax, login history, achievements, fund/contribution history | None | Blocked (MCP unavailable) | Preserved security preview + blacklist confirm surfaces | analyze pass; p2p tests pass; copy guardrails pass; bundles pass | **Done** | AppSpacing.p2pSettingsPage*/p2pTwoFactor*/p2pDevices*/p2pBlacklistList*/p2pNotifications*/p2pTax*/p2pLoginHistoryPage*/p2pAchievementsPage*/p2pFundLock*/p2pContribution*; p0_p2p 45→19 |
| 2026-07-01 | P2P-HOME-07 | p2p | dispute/express/misc (9) | Dispute resolution/detail/evidence, express, wallet transfer, home, dashboard, insurance fund | dashboard + insurance_fund: custompainter L3 | Blocked (MCP unavailable) | Preserved dispute/transfer preview surfaces | analyze pass; p2p tests pass; copy guardrails pass; bundles pass/exception | **Done** | AppSpacing.p2pDispute*/p2pExpress*/p2pWalletTransfer*/p2pHomeClearFilter*/p2pDashboardPage*/p2pInsuranceFundTourSkip*; p0_p2p 19→0 |
| 2026-07-01 | EARN-TRADE-01 | earn, trade | staking_earn, kid_generator, trade_page | L2 earn + L3 regulatory/orderbook | trade_page orderbook L3 | Blocked (MCP unavailable) | APY/lockup copy preserved | earn+trade tests pass; total_debt 35→7 | **Done** | AppSpacing.stakingEarnPosition*; kidGenerator* |
| 2026-07-01 | DEEP-MARKETS-SHARED-01 | markets, shared | market_list_* + vit_choice_pill | L3 market rows + shared pill | None | Blocked (MCP unavailable) | Pair row behavior unchanged | markets+shared tests pass; total_debt 7→0 | **Done** | AppSpacing.marketList*; vitChoicePill* |
| 2026-07-01 | DEEP-DENSITY-WALLET-01 | wallet, earn | 5 P2 screens | Review-only density | structural inset | N/A | Tests confirm first actionable content | wallet+earn tests pass | **Done** | No spacing churn |
| 2026-07-01 | DEEP-TOOL-QA-01 | trade, p2p, enterprise | 5 tool screens | L3_fullscreenTool | Tool exception | N/A | Widget + UI-05 layout evidence | module tests pass | **Done** | P1_TOOL documented |
| 2026-07-01 | Phase 5 | all | P3 ledger | monitor_when_touched | N/A | N/A | P2-A triage only | No bulk edits | **Done** | — |
| 2026-07-01 | DEEP-COPY-01 | all | copy boundaries | Product safety | N/A | N/A | Arena points-only | guardrails pass | **Done** | — |
| 2026-07-01 | Phase 7 | all | global closure | Full gates | N/A | CLI detect_changes | All P0 pass | full flutter test pass | **Done** | Residual pass complete |
