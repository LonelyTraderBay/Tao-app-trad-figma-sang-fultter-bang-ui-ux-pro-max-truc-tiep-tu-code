# Whole-App P2/P3 Assignment Ledger

Date: 2026-06-20

Source: `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`

This ledger assigns every current `P2_MEDIUM_DENSITY_REVIEW` and `P3_LOW_DENSITY_REVIEW` row to a completion policy. No proactive code churn is required for these rows in the current pass; each row is explicitly tracked as `monitor_when_touched`, with high-score P2 rows marked as next-batch candidates.

## Totals

| Metric | Count |
| --- | ---: |
| Assigned rows | 256 |
| P2_MEDIUM_DENSITY_REVIEW | 113 |
| P3_LOW_DENSITY_REVIEW | 143 |
| `fixed_now` rows | 0 |
| `accepted_exception` rows | 0 |
| monitor_when_touched rows | 256 |

## Priority Bands

| Band | Count | Policy |
| --- | ---: | --- |
| P2-A next-batch candidate | 12 | Prioritize in the next proactive density batch. |
| P2-B medium monitor | 26 | Compact when touched or when QA shows regression. |
| P2-C standard monitor | 75 | Compact when touched or when QA shows regression. |
| P3 when-touched monitor | 143 | Monitor when touched; avoid churn. |

## Highest P2 Next-Batch Candidates

| Feature | Route | Page | Score | Guardrail |
| --- | --- | --- | ---: | --- |
| earn | AppRoutePaths.earnProofOfReserves | StakingProofOfReservesPage | 39 | financial_safety_copy_preserve |
| p2p | AppRoutePaths.p2pDashboard | P2PDashboardPage | 39 | financial_safety_copy_preserve |
| referral | AppRoutePaths.referralRewards | ReferralRewardsPage | 39 | standard_ui_accessibility_preserve |
| earn | AppRoutePaths.earnRegulatoryFramework | StakingRegulatoryFrameworkPage | 38 | financial_safety_copy_preserve |
| launchpad | AppRoutePaths.launchpadGasTracker | LaunchpadGasTrackerPage | 38 | financial_safety_copy_preserve |
| trade | AppRoutePaths.tradeBotPortfolioDashboard | BotPortfolioDashboardPage | 38 | financial_safety_copy_preserve |
| arena | AppRoutePaths.arenaStudio | ArenaStudioPage | 37 | open_arena_points_boundary_preserve |
| arena | AppRoutePaths.arenaStudioPresets | ArenaUniversalPresetLibraryPage | 37 | open_arena_points_boundary_preserve |
| markets | AppRoutePaths.marketsMovers | MarketMoversPage | 37 | standard_ui_accessibility_preserve |
| profile | AppRoutePaths.profile | ProfilePage | 37 | standard_ui_accessibility_preserve |
| trade | '/trade/copy-provider/:providerId' | CopyProviderDetailPage | 37 | financial_safety_copy_preserve |
| trade | AppRoutePaths.tradePositions | PositionDashboardPage | 37 | financial_safety_copy_preserve |

## Feature Distribution

| Feature | Assigned rows |
| --- | ---: |
| p2p | 66 |
| earn | 62 |
| trade | 23 |
| launchpad | 21 |
| arena | 15 |
| wallet | 14 |
| markets | 10 |
| predictions | 7 |
| dca | 6 |
| profile | 6 |
| admin | 5 |
| auth | 4 |
| cross_module | 3 |
| dev | 3 |
| discovery | 3 |
| referral | 3 |
| support | 3 |
| notifications | 1 |
| rewards | 1 |

## Guardrails

- Financial surfaces (`wallet`, `p2p`, `earn`, `launchpad`, `trade`) must preserve fees, limits, risk, masking, preview/confirm/receipt, and next-step copy when compacted later.
- Prediction Markets rows must preserve positions/probability/receipt/rewards/P/L language and avoid hype/casino copy.
- Open Arena rows must remain points-only and must not introduce payout, wallet, profit, or stake-return language.
- P3 rows are explicitly monitored, not forgotten; edit only when nearby feature work or QA evidence justifies it.

Full row-level ledger: `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`.
