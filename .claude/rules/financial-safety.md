---
paths:
  - "flutter_app/lib/features/**"
---
# Financial Safety & Product Boundaries

Authority: root `AGENTS.md` (this rule is the lazy-load reminder, not a fork).
Guardrails: `product_copy_guardrails_test.dart`,
`p2p_wallet_product_copy_guardrails_test.dart`,
`prediction_product_copy_guardrails_test.dart`, `money_copy_guardrail_test.dart`,
`high_risk_state_primitives_guardrail_test.dart` (all under
`flutter_app/test/quality/`).

## High-risk flows

- Preview **and** confirm: withdrawals, escrow release, security changes,
  address additions, P2P payment-method changes.
- Show fees, risk, limits, and next steps BEFORE the high-risk confirmation.
- Mask sensitive account / wallet / email / phone / address data.
- High-risk flow state uses `TradeHighRiskFlowStatus`; high-risk screens carry
  `highRiskContractId` coverage in tests.

## Prediction Markets ⇄ Open Arena separation

| Boundary | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL / positions | Points pool / completion |
| History | Orders / receipts | Ledger entries |
| Leaderboard | Trading context | Fair play / completion |

- Arena copy is **points-only**: never payout / wallet / profit / stake-return
  language. Prediction Markets may use positions, probability, receipt,
  rewards, P/L — no hype or casino language.
- Allowed bridges only: topic/category, event context, creator discovery,
  search/discovery, profile surfaces with clearly separated sections.
