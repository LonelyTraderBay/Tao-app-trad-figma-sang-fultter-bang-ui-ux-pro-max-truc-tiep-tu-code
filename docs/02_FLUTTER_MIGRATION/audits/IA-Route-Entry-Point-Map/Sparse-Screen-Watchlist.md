# Sparse Screen Watchlist

Generated: 2026-07-21 · Expanded: STEP-P0.10  

Source: [`VitTrade-Visual-Density-Risk-Audit.md`](../VitTrade-Visual-Density-Risk-Audit.md) (2026-06-19) — **`P0_CRITICAL_DENSITY_REVIEW` = 13**.  
Owner phase for density fixes: **P5** (playbook STEP-P5.2 / P5.3).

## Summary

| Metric | Value |
|--------|------:|
| P0 sparse routes | **13** |
| Batches | 6 (5 product + 1 DEV exception-candidate) |
| Owner Phase | **P5** |
| Regenerate audit | Before P5.1 (`STEP-P5.1`) |

## All 13 P0 routes

| # | Batch ID | Path | Page class | Feature | Score | Owner Phase | Fix STEP | Notes |
|--:|----------|------|------------|---------|------:|-------------|---------|-------|
| 1 | EARN-LEGAL-DENSITY | `/earn/staking/withdrawal-policy` | `StakingWithdrawalPolicyPage` | earn | 79 | **P5** | P5.2 | GOM legal; also inbound via Earn sheet (P3.2) |
| 2 | PRED-DETAIL-DENSITY | `/markets/predictions/event/:eventId` | `PredictionEventDetailPage` | predictions | 75 | **P5** | P5.3 | Detail archetype; not hub |
| 3 | EARN-LEGAL-DENSITY | `/earn/staking/tax-guide` | `StakingTaxGuidePage` | earn | 71 | **P5** | P5.2 | |
| 4 | EARN-LEGAL-DENSITY | `/earn/proof-of-reserves` | `StakingProofOfReservesPage` | earn | 70 | **P5** | P5.2 | |
| 5 | DEV-EXC | `/enterprise-states` | `EnterpriseStatesPage` | enterprise_states | 70 | **P5** | P5.1 / defer | **Exception-candidate** (DEV/QA surface) |
| 6 | EARN-LEGAL-DENSITY | `/earn/insurance` | `StakingInsurancePage` | earn | 69 | **P5** | P5.2 | |
| 7 | EARN-LEGAL-DENSITY | `/earn/api-documentation` | `StakingApiDocumentationPage` | earn | 68 | **P5** | P5.2 | |
| 8 | SAVINGS-TOOLS-DENSITY | `/earn/savings/whatif` | `SavingsWhatIfPage` | earn/savings | 67 | **P5** | P5.3 | |
| 9 | ARENA-STUDIO-DENSITY | `/arena/studio/presets` | `ArenaUniversalPresetLibraryPage` | arena | 65 | **P5** | P5.3 | Points-only copy |
| 10 | SAVINGS-TOOLS-DENSITY | `/earn/savings/recommendations` | `SavingsRecommendationsPage` | earn/savings | 63 | **P5** | P5.3 | |
| 11 | DCA-TOOLS-DENSITY | `/dca/backtester` | `DCABacktesterPage` | dca | 61 | **P5** | P5.3 | |
| 12 | SAVINGS-TOOLS-DENSITY | `/earn/savings/guide` | `SavingsGuidePage` | earn/savings | 61 | **P5** | P5.3 | |
| 13 | ARENA-STUDIO-DENSITY | `/arena/studio/smart-rules` | `ArenaSmartRuleBuilderPage` | arena | 60 | **P5** | P5.3 | |

## Batch roll-up

| Batch ID | Count | Page classes | Owner Phase | Playbook STEP |
|----------|------:|--------------|-------------|----------------|
| EARN-LEGAL-DENSITY | 5 | `StakingWithdrawalPolicyPage`, `StakingTaxGuidePage`, `StakingProofOfReservesPage`, `StakingInsurancePage`, `StakingApiDocumentationPage` | P5 | **P5.2** |
| SAVINGS-TOOLS-DENSITY | 3 | `SavingsWhatIfPage`, `SavingsRecommendationsPage`, `SavingsGuidePage` | P5 | **P5.3** |
| ARENA-STUDIO-DENSITY | 2 | `ArenaUniversalPresetLibraryPage`, `ArenaSmartRuleBuilderPage` | P5 | **P5.3** |
| PRED-DETAIL-DENSITY | 1 | `PredictionEventDetailPage` | P5 | **P5.3** |
| DCA-TOOLS-DENSITY | 1 | `DCABacktesterPage` | P5 | **P5.3** |
| DEV-EXC | 1 | `EnterpriseStatesPage` | P5 | Document exception or exclude from product gate |

## Fix contract (P5)

- Compact first viewport; reduce tall tokenized gaps; first actionable section above bottom-nav inset.
- Prefer shared `Vit*` + `VitPageRhythm` — no one-off density wrappers.
- After fixes: regenerate density audit; P0 count must drop or each remaining row has signed exception.

## Related

- Hub density / blank hubs → Phase P2–P3 (not this ledger).
- State empty/error on list hubs → **P5.4**.
