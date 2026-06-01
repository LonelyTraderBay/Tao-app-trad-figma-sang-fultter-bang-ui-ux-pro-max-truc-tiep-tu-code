# VitTrade Product Flow Professional Exchange Assessment

Generated: 2026-06-02

This assessment uses the current Product Capability Inventory to evaluate
whether VitTrade's screen flows are connected like a professional crypto
exchange / trading super-app. It reviews product flow maturity, not only route
existence.

## Source Baseline

| Source | Purpose |
| --- | --- |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Product-Capability-Inventory.md` | Product Area > Module > Capability > Flow > Screen/Route inventory. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Product-Capability-Inventory.csv` | Machine-readable capability/screen table. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Connection-Audit.md` | Human-readable screen connection audit. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv` | Row-level navigation handler audit. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Navigation-Optimization-Tracking-Plan.md` | Navigation optimization status and module verification history. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Dark-Professional-Super-App-Flow-Architecture.md` | Target reordered flow architecture for dark professional exchange IA. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Dark-Professional-Flow-Reorder-Matrix.csv` | Machine-readable target order for all 104 product flows. |
| `docs/03_DESIGN_SYSTEM/Guidelines.md` | Internal product, IA, safety, and copy standards. |

## Current Measured State

| Metric | Count | Assessment Meaning |
| --- | ---: | --- |
| Product areas | 19 | Broad enough for super-app scope. |
| Product capabilities | 33 | Capabilities are separated beyond router group/folder names. |
| Product flows | 104 | Strong flow inventory coverage. |
| Routed product screens | 414 | Large exchange-grade surface area. |
| Redirect-only routes | 3 | Not counted as screens. |
| Navigation handlers scanned | 913 | Large route graph already audited. |
| Static/resolved navigation targets | 431 | Strong direct route clarity. |
| Dynamic route expressions | 345 | Acceptable only because route-bearing data is contract-tested; still a UX audit risk. |
| Back/modal handlers | 137 | Expected for deep financial flows; must stay guarded by tests. |

## Professional Exchange Flow Rubric

A crypto exchange / professional trading super-app flow should satisfy these
checks:

1. Clear entry hub: the user can discover the feature from Home, bottom nav,
   search, module hub, or contextual CTA.
2. List/search/filter to detail: discovery screens lead to a specific asset,
   order, provider, campaign, challenge, or product detail.
3. Action setup: the user can configure the action with amount, asset, side,
   network, payment method, strategy, leverage, validator, or allocation.
4. Risk and limit preview: high-risk actions show fees, limits, warnings,
   settlement rules, cooldowns, liquidation/slashing/escrow risks, and next
   steps before submission.
5. Explicit confirmation: irreversible or financial/security changes require a
   clear confirm step.
6. Status, receipt, and history: after submission, the user can see outcome,
   pending state, history, audit trail, and how to recover from failure.
7. Recovery and support path: failed or disputed states link to support,
   appeals, evidence, cancellation, or safe retry.
8. Deep-link and back safety: direct route entry has deterministic back/fallback
   behavior.
9. Boundary clarity: wallet-balance products, prediction-market products, P2P
   escrow, and Arena points-only products remain semantically separate.
10. Pro affordances: charts, order types, risk dashboards, exports, APIs,
    analytics, alerts, reports, and audit logs are available without hiding the
    beginner path.

## Overall Verdict

VitTrade is already strong at the router and screen-inventory level. It has the
screen breadth expected from a large crypto exchange, and the main financial
modules already include many enterprise-grade safety surfaces.

However, it should not yet be treated as "fully finished" at professional
trading super-app level. The current state is best described as:

**Enterprise route graph: mostly complete. Product-flow sequencing: strong in
high-risk modules, but still needs formal flow-state contracts and IA cleanup.**

The biggest remaining issues are not missing routes. They are:

1. Some critical flows have routes for receipt/history/risk, but the inventory
   does not prove a mandatory runtime sequence such as setup -> preview ->
   confirm -> submitted -> receipt -> monitor/cancel.
2. 345 navigation handlers use dynamic route expressions. These are currently
   contract-tested, but they make manual product review harder because the
   target route is hidden behind `snapshot.*Route`, `item.route`, `module.route`,
   or similar data.
3. Too many product areas sit under the active bottom-nav bucket "Trade". This
   matches the current five-tab IA rule, but a super-app this large needs a
   clearer product launcher or secondary module hub so P2P, Earn, Launchpad,
   Arena, Copy, Bots, Margin, and Support do not feel like one giant trading
   bucket.
4. Support and account recovery are thinner than the financial surface area.
   Professional exchange apps need contextual support from order, withdrawal,
   P2P dispute, KYC, payment-method, and security flows.

## Product Area Assessment

| Product Area | Screens | Flow Maturity | Current Verdict | Main Gap |
| --- | ---: | --- | --- | --- |
| Identity and Access | 7 | Medium | Basic auth, OTP, 2FA, password recovery, onboarding exist. | Need stronger connection from onboarding/account state into KYC, security, device trust, and trading eligibility gates. |
| Home and Discovery | 6 | Medium | Home links to many modules and quick services. | Super-app IA is dense; add stronger product hub/recents/recommended next steps instead of relying on a large Trade bucket. |
| Market Intelligence | 22 | High | Markets, pair detail, watchlist, research, alerts, charts, signals, correlations are well represented. | Ensure every market detail has clear CTA to spot, futures, prediction, alert, watchlist, and portfolio context. |
| Prediction Markets | 18 | High | Discovery, event detail, portfolio, receipt, rewards, activity, risk tools, and Arena bridge exist. | Confirm order-preview/confirmation is mandatory before a prediction position is created; inventory proves receipt, not the full runtime guard. |
| Trading Execution | 14 | High | Spot/pair, convert, futures, leverage, order receipt, order history, positions, settings, export, risk and execution quality exist. | Add or enforce explicit order preview/confirm for high-risk order types and futures leverage changes. |
| Trading Automation | 19 | High | Bots have terms, risk disclosure, suitability, risk dashboard, emergency stop, security, history, performance, backtest, optimization, API docs. | Activation/pause/stop should be modeled as a formal state machine with confirmation and receipt/audit events. |
| Copy Trading | 49 | Very High | Discovery, education, provider detail, assessment, configuration, confirmation, active copies, performance, audit, disputes, disclosures, governance, complaints are extensive. | Reduce IA sprawl and ensure "copy now" cannot bypass suitability, risk cap, cost disclosure, and confirmation. |
| Margin and Advanced Trading | 8 | Medium | Margin hub, pair route, trader profile, advanced analytics, market data analytics exist. | Needs stricter margin-specific safety path: eligibility, collateral transfer, leverage/mode confirmation, liquidation education, margin call recovery. |
| P2P Trading | 77 | Very High | Strong coverage: express, confirm, order detail, chat, proof, cancel, rate, disputes, evidence, resolution, ads, merchant, payment, KYC, security, escrow, limits, compliance, tax, insurance. | Dynamic routes are heavy; preserve route contract tests and add explicit P2P order state diagram so payment/release/appeal paths cannot diverge. |
| Wallet and Treasury | 21 | High | Wallet, history, deposit, pending deposits, withdraw, limits, address book/add, transfer, buy, asset detail, network status, approvals, gas, health score exist. | Withdraw/address-book flows need mandatory preview, address confirmation, network mismatch warnings, cooldown/hold messaging, and receipt/status. |
| Earn and Savings | 70 | High | Staking and savings have terms, risk, policy, tax, history, validator, auto-compound, liquid staking, insurance, dashboard, analytics, reserves, community, integrations, developer console. | The area is route-rich but needs clearer product lifecycle groups and mandatory suitability/risk gates before staking/redeem/advanced actions. |
| Investment Automation | 14 | Medium-High | DCA has overview, strategy tools, optimizer, dynamic amount, backtest, multi-asset, rebalance, schedule config, analytics. | Add formal create/edit/pause/cancel/receipt/history state flow; current inventory is strong on tools but less explicit on lifecycle governance. |
| Launchpad and Token Access | 24 | Medium-High | Overview, portfolio, staking, IDO bridge, contract, receipt, claim, batch, gas, rebalance, multisig, swap, limit, DCA, risk, detail exist. | 40 of 43 Launchpad edges are dynamic in the nav audit; route-bearing launchpad data needs especially strong typed contracts and flow diagrams. |
| Open Arena | 25 | High | Discovery, guide, studio, challenge, join, resolution, creator, leaderboard, verified, flow map, safety, reports, my arena, bridge, ecosystem, ledger exist. | Keep Arena points-only boundaries visible on every bridge and profile surface; avoid wallet/profit/stake language. |
| Growth and Rewards | 6 | Medium | Referral home, history, rewards, rules, friend detail, rewards hub exist. | Add abuse/fraud/eligibility/expiry states if rewards become financially material. |
| Profile and Account | 16 | High | Profile, edit, KYC, security, devices, settings, VIP, subaccounts, API create, activity, prediction/arena summaries exist. | Profile should become the global account eligibility control plane: KYC level, withdrawal status, security score, API permission state, trading restrictions. |
| Support and Service | 3 | Low-Medium | Support, help, announcements exist. | Too thin for a professional exchange. Need ticket detail, chat, case timeline, attached order/tx context, status, escalation, and support from high-risk flows. |
| Enterprise Operations | 10 | Medium | Admin dashboards, settings, cross-module analytics, alerts, tax, unified portfolio exist. | Good internal/admin direction; keep separated from retail user flows. |
| Developer and QA Tooling | 5 | High for QA | Route checker, performance monitor, showcase, design system, demo exist. | Not a customer product flow; keep out of production IA unless dev-gated. |

## Critical Flow Findings

### 1. Trading Execution

Current route sequence supports a professional trading foundation:

```text
Markets / Pair detail -> Trade pair -> Order receipt -> Orders history
Trade pair -> Futures -> Leverage
Trade -> Positions / Settings / Export
Trade -> Risk management / Execution quality / Advanced tools
```

Assessment:

- Good: market-to-trade and pair-to-trade flows exist.
- Good: receipt, history, positions, settings, export, risk tools exist.
- Gap: a routed order preview/confirmation screen is not visible in the
  capability inventory. If confirmation is handled inside the `TradePage`, it
  should still have a tested mandatory guard for market/limit/stop/futures
  actions.
- Gap: futures leverage change should be a high-risk flow with current leverage,
  proposed leverage, liquidation warning, margin mode, fee/funding context, and
  explicit confirmation.

Recommended target flow:

```text
Pair detail
  -> Trade ticket
  -> Order preview
  -> Confirm order
  -> Submitted/receipt
  -> Open orders or positions
  -> Modify/cancel/close
  -> History/export/support
```

### 2. Trading Bots

Current bot route set is unusually complete for safety:

```text
Bots home -> Terms -> Risk disclosure -> Suitability
Bots -> Backtesting / Strategy compare / Optimization
Bots -> Risk dashboard / Emergency stop / Security settings
Bots -> History / Performance analytics / Tax / API docs
```

Assessment:

- Strong: suitability, risk disclosure, emergency stop, and security settings
  exist.
- Gap: activation, pause, stop, parameter edit, and emergency stop should be
  modeled as explicit state transitions, not just pages.

Recommended state contract:

```text
draft -> suitability_passed -> configured -> preview -> active
active -> paused
active -> emergency_stopped
active -> terminated
any_active_state -> audit_log/history/performance
```

### 3. Copy Trading

Current copy trading flow is the closest to professional-grade:

```text
Copy hub -> Provider detail -> Assessment -> Configuration -> Confirmation
Confirmation -> Active copies -> Performance -> Attribution -> Audit log
Copy hub -> Education / Safety / Disputes / Regulatory disclosures
Copy compliance -> Governance / Costs / Complaints / Inspection readiness
```

Assessment:

- Very strong: copy flow has onboarding, assessment, configuration,
  confirmation, active copy management, performance, audit, complaints,
  regulatory and product governance.
- Gap: ensure user cannot deep-link directly into configuration/confirmation
  without provider context, suitability state, risk cap, and cost disclosure.
- Gap: 49 screens are appropriate for compliance depth but need a clearer
  sub-navigation model inside Copy Trading.

### 4. Margin and Advanced Trading

Current margin route set:

```text
Trade -> Margin
Margin -> Pair margin route
Margin -> Hub / Advanced demo / Market data / Live market data / Advanced analytics
Margin -> Trader profile
```

Assessment:

- Good: enough route surface for advanced market data and analytics.
- Gap: margin is high-risk but has fewer explicit safety flows than Bots,
  Copy, P2P, Wallet, or Earn.

Recommended additions or enforced guards:

- Margin eligibility and risk assessment.
- Collateral transfer preview.
- Cross/isolated mode explanation and confirmation.
- Leverage confirmation.
- Liquidation price preview.
- Margin call recovery path.
- Borrow/repay history and receipt.

### 5. P2P Trading

P2P is highly mature in route coverage:

```text
P2P home -> Express -> Confirm -> Order detail
Order detail -> Timeline / Chat / Proof / Cancel / Rate / Dispute
Dispute -> Detail -> Evidence -> Resolution
P2P -> Ads / Merchant / Report / Reviews / Payment methods
P2P -> KYC / Security / Escrow / Wallet / Limits / Compliance / Tax / Insurance
```

Assessment:

- Very strong: P2P has order lifecycle, chat, proof, cancellation, dispute,
  evidence, resolution, merchant, payment method, KYC, security, escrow,
  compliance, tax, and insurance flows.
- Strong: this matches the expected P2P exchange pattern where order status,
  chat, payment proof, appeal/dispute, and escrow are all first-class.
- Gap: 96 P2P dynamic route expressions mean the product contract depends on
  snapshot/data route fields. Existing contract tests make this acceptable, but
  future work must not weaken those tests.

Recommended P2P state machine:

```text
quote_selected
  -> confirmation
  -> order_created
  -> waiting_payment
  -> payment_marked
  -> proof_uploaded
  -> release_pending
  -> completed

exception branches:
waiting_payment -> canceled
payment_marked -> dispute_opened -> evidence_submitted -> resolution -> completed/canceled
```

### 6. Wallet and Withdrawals

Current wallet route set:

```text
Wallet -> Deposit / Deposit asset / Pending deposits
Wallet -> Withdraw / Withdraw asset / Limits
Wallet -> Address book -> Add address
Wallet -> History -> Transaction detail
Wallet -> Transfer / Buy crypto / Asset detail / Network status
Wallet -> Token approval / Gas optimizer / Health score
```

Assessment:

- Good: wallet has core money movement, asset detail, network, approval, and
  health screens.
- Gap: withdrawal confirmation should be non-bypassable and must include
  address verification, network match, fee, minimum, limit, cooldown/hold, and
  final receipt/status.
- Gap: address add should be treated like a security change with confirmation
  and possible hold/cooling period.

Recommended target flow:

```text
Wallet -> Withdraw asset
  -> Address selection / address add
  -> Network and amount setup
  -> Fee/limit/risk preview
  -> 2FA/security confirmation
  -> Submitted receipt
  -> Pending/completed transaction detail
  -> Support if delayed/failed
```

### 7. Earn and Savings

Current Earn/Savings coverage is broad:

```text
Earn/Staking -> Terms / Risk / Withdrawal policy / Tax
Earn/Staking -> Validator / Auto-compound / Liquid staking / Insurance
Earn/Staking -> Dashboard / Analytics / History / Calendar
Earn/Staking -> Proof of reserves / Risk dashboard / Slashing / Emergency actions
Savings -> Portfolio / Product / Redeem / Receipt / History
Savings -> Goals / Rebalance / DCA / Backtest / Auto-pilot / Ladder / What-if
```

Assessment:

- Strong: risk, policy, dashboard, history, reserves, validator health, and
  emergency actions exist.
- Gap: the area has 70 screens and many dynamic route expressions, so it needs
  stronger sub-hubs and lifecycle state grouping.
- Gap: staking, redeem, auto-compound, rebalance, and savings ladder should each
  have setup -> preview -> confirm -> receipt -> manage/history.

### 8. Launchpad and Token Access

Current launchpad route set:

```text
Launchpad -> Portfolio / Performance / Staking
Launchpad -> IDO bridge / Contract / Receipt / Claim
Launchpad -> Batch / Bridge / Gas / Rebalance / Multisig / Swap / Limit / DCA / Risk / Detail
```

Assessment:

- Good: launchpad has participation, settlement, claim, risk, and operational
  tools.
- Gap: launchpad navigation is heavily dynamic. The route graph is tested, but
  product review needs a canonical launchpad flow diagram.

Recommended flow:

```text
Campaign discovery
  -> Campaign detail
  -> Eligibility/KYC/region check
  -> Terms and risk
  -> Allocation setup
  -> Preview/confirm
  -> Receipt
  -> Vesting/claim schedule
  -> Claim
  -> Portfolio/history/support
```

### 9. Prediction Markets and Open Arena Boundary

Current boundary is mostly correct:

```text
Prediction Markets: /markets/predictions...
Open Arena: /arena...
Arena points alias: /arena/points -> /rewards?tab=arena
Allowed bridges: topics, creator discovery, event context, profile summaries
```

Assessment:

- Good: namespace separation is clear.
- Good: inventory keeps Prediction Markets and Arena as separate Product Areas.
- Gap: every bridge screen must visually and semantically preserve currency
  boundary: Prediction uses wallet/PnL/positions/receipts; Arena uses points,
  completion, ledger, and fair-play language.

### 10. Support and Recovery

Current support route set:

```text
Support -> Help -> Announcements
```

Assessment:

- This is the weakest area relative to the size and risk of the app.
- A professional exchange needs support to be contextual, not only a generic
  help center.

Recommended support model:

```text
Support home
  -> ticket list
  -> ticket detail / timeline
  -> create ticket with context
  -> attach order/withdrawal/P2P/KYC/API case
  -> chat/escalation
  -> resolution survey
```

High-risk screens should link into support with context:

- Withdrawal transaction detail.
- Deposit pending detail.
- P2P dispute/order detail.
- KYC rejected or pending status.
- API key/security incident.
- Staking/redeem failure.
- Launchpad claim failure.
- Copy trading complaint/dispute.

## Cross-App IA Assessment

The app follows the current internal IA rule: five primary tabs only.

```text
Home
Markets
Trade
Wallet
Profile
```

This is acceptable as a mobile baseline. The issue is that many distinct
product businesses become active under the Trade tab:

- Spot trading.
- Futures and margin.
- Convert.
- DCA.
- Earn/Savings.
- P2P.
- Launchpad.
- Copy Trading.
- Trading Bots.
- Arena.
- Support.
- Rewards.
- Admin/dev/cross-module surfaces.

Recommendation:

Keep the five bottom tabs, but add a stronger second-level product launcher or
"Product Hub" under Home/Trade:

```text
Trade tab
  -> Trade terminal
  -> Copy
  -> Bots
  -> P2P
  -> Earn
  -> Launchpad
  -> DCA
  -> Margin
  -> Arena
```

Each tile should show product state, not only a route:

- Available / restricted / KYC required.
- Balance or buying power where relevant.
- Active orders/positions/copies/bots.
- Pending disputes/withdrawals/claims.
- Risk alerts.

## Required Improvement Backlog

### P0 - Must Have Before Real Money Release

| Area | Work |
| --- | --- |
| Trading | Enforce order preview/confirmation for spot, futures, leverage, and margin actions. |
| Wallet | Enforce withdraw preview, address verification, network warning, 2FA/security confirmation, and receipt/status. |
| P2P | Maintain explicit state machine for payment, proof, escrow release, cancellation, dispute, evidence, and resolution. |
| Account | Centralize eligibility gates: KYC, 2FA, device trust, withdrawal hold, account restrictions. |
| Support | Add contextual case/ticket flows for withdrawal, P2P, KYC, staking, launchpad, and security incidents. |

### P1 - Needed For Professional Super-App UX

| Area | Work |
| --- | --- |
| IA | Add a second-level Product Hub so large modules do not all feel hidden under Trade. |
| Dynamic routes | Keep contract tests and migrate high-risk data route fields toward typed navigation intents. |
| Earn/Savings | Split into clear lifecycle hubs: discover, subscribe, manage, redeem, history, risk. |
| Launchpad | Add canonical campaign lifecycle diagram and enforce eligibility/risk/receipt/claim sequence. |
| Copy/Bots | Add formal state machines for activation, pause, termination, emergency stop, and audit. |

### P2 - Polish And Scale

| Area | Work |
| --- | --- |
| Search | Make search aware of products, markets, orders, tickets, campaigns, and help topics. |
| Notifications | Route alerts to the exact product state that needs action. |
| Profile | Show account readiness dashboard: verification, security, limits, active restrictions, API state. |
| Analytics | Add per-product empty/loading/error/offline contracts in QA docs. |
| QA | Add product-flow golden paths for P0 flows, not just route existence tests. |

## Final Assessment

VitTrade already has enough screens and route connections to look like a large
crypto exchange / trading super-app. The strongest areas are P2P, Copy Trading,
Trading Bots, Wallet, Earn/Savings, Markets, and Prediction/Arena separation.

The project should now move from "screen coverage" to "flow-state correctness".
The next enterprise-grade milestone is to document and test each high-risk
feature as a state machine:

```text
discover -> setup -> preview -> confirm -> submitted -> receipt/status -> manage/history -> support/recovery
```

Once those state machines are enforced by tests and UI review, the app will be
much closer to professional exchange quality.

## External Benchmark References

- Coinbase Advanced documents professional order types such as stop-limit and
  bracket orders, including explicit order confirmation and risk mitigation
  behavior.
- Kraken requires adding and confirming a cryptocurrency withdrawal address
  before use, and documents withdrawal holds after certain security changes.
- Bybit P2P appeal guidance emphasizes order status, chat, appeal stages,
  limitations, evidence, and platform intervention.
- Binance P2P capability guidance separates P2P from spot/futures/deposits,
  and treats order timeline, appeal status, evidence, complaint flow, and
  merchant/ad management as dedicated P2P capabilities.
