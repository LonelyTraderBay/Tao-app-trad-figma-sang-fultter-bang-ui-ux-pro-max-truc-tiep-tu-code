# VitTrade Dark Professional Super-App Flow Architecture

Generated: 2026-06-02

This document rearranges the current 104 product flows into a target
dark professional crypto exchange / trading super-app order. It does
not replace the route inventory; it defines the intended product-flow
sequence that future implementation and QA should follow.

## Inputs

| Artifact | Role |
| --- | --- |
| `VitTrade-Product-Capability-Inventory.md` | Current product area, capability, flow, screen, route, and file inventory. |
| `VitTrade-Product-Capability-Inventory.csv` | Source data for the reorder matrix. |
| `VitTrade-Product-Flow-Professional-Exchange-Assessment.md` | Gap analysis against professional exchange expectations. |
| `VitTrade-Screen-Navigation-Edges.csv` | Current navigation edge baseline. |
| `docs/03_DESIGN_SYSTEM/Guidelines.md` | Trust-first, five-tab IA, dark theme, safety, and product-boundary rules. |

## Coverage Check

- Source routed screens represented: **414**.
- Source product flows represented: **104 / 104**.
- Product areas represented: **19 / 19**.
- Missing flow assignments: **0**.
- Machine-readable matrix: `docs/02_FLUTTER_MIGRATION/VitTrade-Dark-Professional-Flow-Reorder-Matrix.csv`.

## Dark Professional Flow Principles

1. Keep the five primary tabs: Home, Markets, Trade, Wallet, Profile.
2. Use Home as a calm command center: balances, alerts, next actions, search, and product entry points.
3. Use Markets for decision context before risk: watchlists, pair detail, research, prediction discovery, and trade CTA.
4. Use Trade for action surfaces: spot, futures, margin, convert, bots, copy, DCA, P2P, Earn, Launchpad, and Arena entry via a product hub.
5. Use Wallet for treasury: balances, funding, withdrawal, transfer, addresses, network status, approvals, and transaction status.
6. Use Profile for account readiness: KYC, security, API keys, subaccounts, limits, activity, and product summaries.
7. Every high-risk flow must follow: setup -> preview -> confirm -> receipt/status -> manage/history -> support/recovery.
8. Keep dark UI dense but calm: high contrast text, restrained accent color, visible state chips, skeleton loading, useful empty states, and clear error recovery.
9. Keep Prediction Markets and Open Arena separate: wallet/PnL/positions/receipts for Predictions, Arena Points/completion/ledger/fair-play for Arena.
10. Keep developer/admin/QA tooling gated and out of customer product IA.

## Target Global Journey

```text
Trust foundation
  -> Home command center
  -> Markets decision context
  -> Trading / automation / P2P / Earn / Launchpad action
  -> Wallet treasury and settlement
  -> Profile account readiness
  -> Support and recovery
  -> Gated operations and QA
```

## Target Layer Summary

| Order | Target Layer | Flows | Screens | Recommended Surface(s) | Product Areas |
| ---: | --- | ---: | ---: | --- | --- |
| 1 | Trust Foundation and Account Readiness | 8 | 23 | `Auth shell / Profile tab, Profile tab` | Identity and Access, Profile and Account |
| 2 | Home Command Center and Discovery | 5 | 6 | `Home tab` | Home and Discovery |
| 3 | Market Intelligence and Decision Context | 9 | 40 | `Markets tab` | Market Intelligence, Prediction Markets |
| 4 | Core Trading and Risk Execution | 7 | 22 | `Trade tab` | Margin and Advanced Trading, Trading Execution |
| 5 | Strategy Automation and Social Trading | 15 | 82 | `Trade tab product hub` | Copy Trading, Investment Automation, Trading Automation |
| 6 | Wallet, Treasury and Controls | 6 | 21 | `Wallet tab` | Wallet and Treasury |
| 7 | P2P Commerce, Escrow and Compliance | 10 | 77 | `Trade tab product hub` | P2P Trading |
| 8 | Yield, Savings and Token Access | 15 | 94 | `Trade tab product hub` | Earn and Savings, Launchpad and Token Access |
| 9 | Community, Points and Growth | 14 | 31 | `Home / Profile tab, Home / Trade product hub` | Growth and Rewards, Open Arena |
| 10 | Support, Recovery and Service Operations | 3 | 3 | `Profile tab / contextual support` | Support and Service |
| 11 | Gated Operations and Internal Tooling | 12 | 15 | `Admin gated, Dev gated` | Developer and QA Tooling, Enterprise Operations |

## Product Hub Order

Keep bottom navigation unchanged, but make the Trade/Home product hub present modules in this order:

| Rank | Hub Item | Why This Order |
| ---: | --- | --- |
| 1 | Spot / Convert / Futures | Core exchange action should be first and fastest. |
| 2 | Markets linked pair actions | Users often enter action after market decision context. |
| 3 | Margin / Advanced | High-risk pro mode near core trading but behind stronger warnings. |
| 4 | Trading Bots | Automation after the user understands the trading base. |
| 5 | Copy Trading | Social trading after risk/suitability education. |
| 6 | DCA / Auto-Invest | Lower-touch strategy automation. |
| 7 | Wallet funding shortcuts | Deposit/withdraw remains Wallet-owned but must be available contextually. |
| 8 | P2P | Separate escrow commerce with its own trust and dispute model. |
| 9 | Earn / Savings | Yield products after wallet readiness and risk education. |
| 10 | Launchpad | Token access after KYC, funding, eligibility, and risk checks. |
| 11 | Prediction Markets | Market-adjacent speculative flow with separate positions/receipts. |
| 12 | Open Arena | Points-only community mode, visually separated from wallet-value flows. |
| 13 | Rewards / Referral | Growth surface after core value flows. |
| 14 | Support | Contextual recovery entry visible from every high-risk flow. |

## Target Flow Reorder Matrix

| Target | Layer | Surface | Product Area | Capability | Flow | Screens | Lifecycle Stage |
| ---: | --- | --- | --- | --- | --- | ---: | --- |
| 001 | Trust Foundation and Account Readiness | `Auth shell / Profile tab` | Identity and Access | Identity and Onboarding | First-run onboarding | 1 | Trust gate / eligibility |
| 002 | Trust Foundation and Account Readiness | `Auth shell / Profile tab` | Identity and Access | Identity and Onboarding | Account access | 2 | Trust gate / eligibility |
| 003 | Trust Foundation and Account Readiness | `Auth shell / Profile tab` | Identity and Access | Identity and Onboarding | Authentication challenge and 2FA setup | 2 | Trust gate / eligibility |
| 004 | Trust Foundation and Account Readiness | `Auth shell / Profile tab` | Identity and Access | Identity and Onboarding | Password recovery | 2 | Trust gate / eligibility |
| 005 | Trust Foundation and Account Readiness | `Profile tab` | Profile and Account | Profile and Account Management | Profile, settings and activity | 4 | Operate / extend |
| 006 | Trust Foundation and Account Readiness | `Profile tab` | Profile and Account | Profile and Account Management | Identity, security and devices | 5 | Trust gate / eligibility |
| 007 | Trust Foundation and Account Readiness | `Profile tab` | Profile and Account | Profile and Account Management | API, subaccounts and VIP | 4 | Operate / extend |
| 008 | Trust Foundation and Account Readiness | `Profile tab` | Profile and Account | Profile and Account Management | Profile module summaries | 3 | Operate / extend |
| 009 | Home Command Center and Discovery | `Home tab` | Home and Discovery | Home, Discovery and Notifications | Home dashboard | 1 | Discover / orient |
| 010 | Home Command Center and Discovery | `Home tab` | Home and Discovery | Home, Discovery and Notifications | Unified search | 1 | Discover / orient |
| 011 | Home Command Center and Discovery | `Home tab` | Home and Discovery | Home, Discovery and Notifications | Topic discovery | 2 | Discover / orient |
| 012 | Home Command Center and Discovery | `Home tab` | Home and Discovery | Home, Discovery and Notifications | News feed | 1 | Discover / orient |
| 013 | Home Command Center and Discovery | `Home tab` | Home and Discovery | Home, Discovery and Notifications | Notification center | 1 | Discover / orient |
| 014 | Market Intelligence and Decision Context | `Markets tab` | Market Intelligence | Market Intelligence | Market discovery and watchlists | 5 | Discover / orient |
| 015 | Market Intelligence and Decision Context | `Markets tab` | Market Intelligence | Pair Intelligence | Pair and depth intelligence | 4 | Decide / analyze |
| 016 | Market Intelligence and Decision Context | `Markets tab` | Market Intelligence | Market Intelligence | Market research tools | 6 | Discover / orient |
| 017 | Market Intelligence and Decision Context | `Markets tab` | Market Intelligence | Market Intelligence | Market intelligence and insights | 7 | Decide / analyze |
| 018 | Market Intelligence and Decision Context | `Markets tab` | Prediction Markets | Prediction Market Discovery and Portfolio | Prediction market discovery | 3 | Discover / orient |
| 019 | Market Intelligence and Decision Context | `Markets tab` | Prediction Markets | Prediction Market Operations | Prediction event trading | 3 | Operate / extend |
| 020 | Market Intelligence and Decision Context | `Markets tab` | Prediction Markets | Prediction Market Discovery and Portfolio | Prediction portfolio and community | 4 | Monitor / manage |
| 021 | Market Intelligence and Decision Context | `Markets tab` | Prediction Markets | Prediction Market Operations | Prediction analytics and operations | 6 | Decide / analyze |
| 022 | Market Intelligence and Decision Context | `Markets tab` | Prediction Markets | Prediction Market Operations | Prediction tournaments | 2 | Operate / extend |
| 023 | Core Trading and Risk Execution | `Trade tab` | Trading Execution | Core Trading | Spot, pair, chart and convert execution | 4 | Setup / configure |
| 024 | Core Trading and Risk Execution | `Trade tab` | Trading Execution | Core Trading | Futures and leverage | 2 | Operate / extend |
| 025 | Core Trading and Risk Execution | `Trade tab` | Trading Execution | Core Trading | Order, position and settings management | 5 | Monitor / manage |
| 026 | Core Trading and Risk Execution | `Trade tab` | Trading Execution | Core Trading | Risk and execution quality tools | 3 | Setup / configure |
| 027 | Core Trading and Risk Execution | `Trade tab` | Margin and Advanced Trading | Margin / Advanced Trading | Margin trading surfaces | 3 | Setup / configure |
| 028 | Core Trading and Risk Execution | `Trade tab` | Margin and Advanced Trading | Margin / Advanced Trading | Advanced margin analytics | 4 | Decide / analyze |
| 029 | Core Trading and Risk Execution | `Trade tab` | Margin and Advanced Trading | Margin / Advanced Trading | Trader profile intelligence | 1 | Decide / analyze |
| 030 | Strategy Automation and Social Trading | `Trade tab product hub` | Trading Automation | Trading Bots | Bot onboarding, education and API docs | 7 | Trust gate / eligibility |
| 031 | Strategy Automation and Social Trading | `Trade tab product hub` | Trading Automation | Trading Bots | Bot strategy testing and optimization | 3 | Setup / configure |
| 032 | Strategy Automation and Social Trading | `Trade tab product hub` | Trading Automation | Trading Bots | Bot risk and security controls | 3 | Trust gate / eligibility |
| 033 | Strategy Automation and Social Trading | `Trade tab product hub` | Trading Automation | Trading Bots | Bot performance and reporting | 6 | Monitor / manage |
| 034 | Strategy Automation and Social Trading | `Trade tab product hub` | Copy Trading | Copy Trading | Copy discovery, education and settings | 10 | Discover / orient |
| 035 | Strategy Automation and Social Trading | `Trade tab product hub` | Copy Trading | Copy Trading | Copy provider onboarding and setup | 4 | Trust gate / eligibility |
| 036 | Strategy Automation and Social Trading | `Trade tab product hub` | Copy Trading | Copy Trading | Copy safety, governance and disputes | 4 | Recover / resolve |
| 037 | Strategy Automation and Social Trading | `Trade tab product hub` | Copy Trading | Copy Trading | Copy performance, attribution and audit | 4 | Monitor / manage |
| 038 | Strategy Automation and Social Trading | `Trade tab product hub` | Copy Trading | Copy Trading | Copy costs, KID and risk disclosures | 6 | Trust gate / eligibility |
| 039 | Strategy Automation and Social Trading | `Trade tab product hub` | Copy Trading | Copy Trading | Copy regulatory and product governance | 14 | Operate / extend |
| 040 | Strategy Automation and Social Trading | `Trade tab product hub` | Copy Trading | Copy Trading | Copy complaints, audit and inspection readiness | 7 | Monitor / manage |
| 041 | Strategy Automation and Social Trading | `Trade tab product hub` | Investment Automation | DCA / Auto-Invest | DCA overview and demo | 2 | Discover / orient |
| 042 | Strategy Automation and Social Trading | `Trade tab product hub` | Investment Automation | DCA / Auto-Invest | DCA schedule lifecycle | 2 | Setup / configure |
| 043 | Strategy Automation and Social Trading | `Trade tab product hub` | Investment Automation | DCA / Auto-Invest | DCA rebalance lifecycle | 4 | Setup / configure |
| 044 | Strategy Automation and Social Trading | `Trade tab product hub` | Investment Automation | DCA / Auto-Invest | DCA optimization and strategy tools | 6 | Setup / configure |
| 045 | Wallet, Treasury and Controls | `Wallet tab` | Wallet and Treasury | Wallet Management and Monitoring | Wallet overview, history and transaction detail | 4 | Discover / orient |
| 046 | Wallet, Treasury and Controls | `Wallet tab` | Wallet and Treasury | Wallet Money Movement | Deposit and pending deposit tracking | 3 | Submit / confirm / settle |
| 047 | Wallet, Treasury and Controls | `Wallet tab` | Wallet and Treasury | Wallet Money Movement | Withdraw and limit controls | 3 | Submit / confirm / settle |
| 048 | Wallet, Treasury and Controls | `Wallet tab` | Wallet and Treasury | Wallet Money Movement | Address book management | 2 | Setup / configure |
| 049 | Wallet, Treasury and Controls | `Wallet tab` | Wallet and Treasury | Wallet Money Movement | Asset, buy and transfer flows | 3 | Operate / extend |
| 050 | Wallet, Treasury and Controls | `Wallet tab` | Wallet and Treasury | Wallet Management and Monitoring | Wallet operations, gas, approvals and health | 6 | Operate / extend |
| 051 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Trading Lifecycle | P2P order lifecycle and chat | 9 | Submit / confirm / settle |
| 052 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Trading Lifecycle | P2P disputes and evidence | 5 | Recover / resolve |
| 053 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Merchant Operations | P2P ads, merchant and reputation operations | 13 | Operate / extend |
| 054 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Trust, Security and Payment Methods | P2P payment methods | 6 | Setup / configure |
| 055 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Trust, Security and Payment Methods | P2P KYC and verification | 8 | Trust gate / eligibility |
| 056 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Trust, Security and Payment Methods | P2P account security | 7 | Trust gate / eligibility |
| 057 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Trading | P2P escrow and balance | 2 | Submit / confirm / settle |
| 058 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Risk, Compliance and Wallet Operations | P2P wallet, dashboard and safety tools | 12 | Monitor / manage |
| 059 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Risk, Compliance and Wallet Operations | P2P compliance, limits and tax | 8 | Operate / extend |
| 060 | P2P Commerce, Escrow and Compliance | `Trade tab product hub` | P2P Trading | P2P Risk, Compliance and Wallet Operations | P2P insurance fund | 7 | Recover / resolve |
| 061 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Staking / Earn | Earn and staking entry | 2 | Operate / extend |
| 062 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Staking / Earn | Staking terms, risk and policy | 5 | Trust gate / eligibility |
| 063 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Staking / Earn | Staking operations and products | 6 | Setup / configure |
| 064 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Staking / Earn | Staking dashboard and history | 4 | Monitor / manage |
| 065 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Staking / Earn | Staking compliance, custody and risk controls | 15 | Operate / extend |
| 066 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Staking / Earn | Staking education and recommendations | 4 | Discover / orient |
| 067 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Staking / Earn | Staking community, governance and integrations | 10 | Operate / extend |
| 068 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Savings | Savings product and portfolio lifecycle | 6 | Monitor / manage |
| 069 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Savings | Savings education, risk and comparison | 6 | Discover / orient |
| 070 | Yield, Savings and Token Access | `Trade tab product hub` | Earn and Savings | Savings | Savings automation, analytics and planning | 12 | Decide / analyze |
| 071 | Yield, Savings and Token Access | `Trade tab product hub` | Launchpad and Token Access | Launchpad Portfolio and Staking | Launchpad overview, portfolio and staking | 4 | Discover / orient |
| 072 | Yield, Savings and Token Access | `Trade tab product hub` | Launchpad and Token Access | Launchpad Participation and Settlement | Launchpad IDO bridge, contract and receipt flow | 5 | Submit / confirm / settle |
| 073 | Yield, Savings and Token Access | `Trade tab product hub` | Launchpad and Token Access | Launchpad Participation and Settlement | Launchpad claim and receipt flow | 3 | Submit / confirm / settle |
| 074 | Yield, Savings and Token Access | `Trade tab product hub` | Launchpad and Token Access | Launchpad Operations and Risk Tools | Launchpad execution, automation and risk tools | 7 | Setup / configure |
| 075 | Yield, Savings and Token Access | `Trade tab product hub` | Launchpad and Token Access | Launchpad Operations and Risk Tools | Launchpad operations, notifications and address book | 5 | Discover / orient |
| 076 | Community, Points and Growth | `Home / Profile tab` | Growth and Rewards | Rewards and Referral | Rewards hub | 1 | Discover / orient |
| 077 | Community, Points and Growth | `Home / Profile tab` | Growth and Rewards | Rewards and Referral | Referral program home | 1 | Discover / orient |
| 078 | Community, Points and Growth | `Home / Profile tab` | Growth and Rewards | Rewards and Referral | Referral rules | 1 | Operate / extend |
| 079 | Community, Points and Growth | `Home / Profile tab` | Growth and Rewards | Rewards and Referral | Referral history | 1 | Monitor / manage |
| 080 | Community, Points and Growth | `Home / Profile tab` | Growth and Rewards | Rewards and Referral | Referral friend detail | 1 | Decide / analyze |
| 081 | Community, Points and Growth | `Home / Profile tab` | Growth and Rewards | Rewards and Referral | Referral rewards | 1 | Operate / extend |
| 082 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Open Arena Discovery and Management | Arena discovery, guide and production handoff | 4 | Discover / orient |
| 083 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Open Arena Gameplay and Creation | Arena creation studio | 4 | Operate / extend |
| 084 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Open Arena Gameplay and Creation | Arena mode, challenge and resolution flow | 4 | Operate / extend |
| 085 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Open Arena Gameplay and Creation | Arena creator, leaderboard and verified challenges | 3 | Decide / analyze |
| 086 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Open Arena Discovery and Management | My Arena management | 1 | Monitor / manage |
| 087 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Arena Safety, Trust and Ledger | Arena safety, moderation and reporting | 4 | Monitor / manage |
| 088 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Arena Safety, Trust and Ledger | Arena trust and points ledger | 3 | Monitor / manage |
| 089 | Community, Points and Growth | `Home / Trade product hub` | Open Arena | Arena Prediction Bridge | Arena and Prediction bridge | 2 | Operate / extend |
| 090 | Support, Recovery and Service Operations | `Profile tab / contextual support` | Support and Service | Support and Help | Help center | 1 | Operate / extend |
| 091 | Support, Recovery and Service Operations | `Profile tab / contextual support` | Support and Service | Support and Help | Support ticket center | 1 | Recover / resolve |
| 092 | Support, Recovery and Service Operations | `Profile tab / contextual support` | Support and Service | Support and Help | Announcements | 1 | Operate / extend |
| 093 | Gated Operations and Internal Tooling | `Admin gated` | Enterprise Operations | Enterprise Cross-Module Intelligence | Unified portfolio intelligence | 1 | Decide / analyze |
| 094 | Gated Operations and Internal Tooling | `Admin gated` | Enterprise Operations | Enterprise Cross-Module Intelligence | Smart alerts | 1 | Operate / extend |
| 095 | Gated Operations and Internal Tooling | `Admin gated` | Enterprise Operations | Enterprise Cross-Module Intelligence | Cross-module analytics | 1 | Decide / analyze |
| 096 | Gated Operations and Internal Tooling | `Admin gated` | Enterprise Operations | Enterprise Cross-Module Intelligence | Tax reporting | 1 | Monitor / manage |
| 097 | Gated Operations and Internal Tooling | `Admin gated` | Enterprise Operations | Admin and Analytics | Admin operations | 2 | Operate / extend |
| 098 | Gated Operations and Internal Tooling | `Admin gated` | Enterprise Operations | Admin and Analytics | Admin analytics dashboards | 3 | Decide / analyze |
| 099 | Gated Operations and Internal Tooling | `Admin gated` | Enterprise Operations | Enterprise Cross-Module Intelligence | Enterprise state patterns | 1 | Operate / extend |
| 100 | Gated Operations and Internal Tooling | `Dev gated` | Developer and QA Tooling | Developer and QA Tools | Route QA | 1 | Operate / extend |
| 101 | Gated Operations and Internal Tooling | `Dev gated` | Developer and QA Tooling | Developer and QA Tools | Design system QA | 1 | Operate / extend |
| 102 | Gated Operations and Internal Tooling | `Dev gated` | Developer and QA Tooling | Developer and QA Tools | Performance QA | 1 | Monitor / manage |
| 103 | Gated Operations and Internal Tooling | `Dev gated` | Developer and QA Tooling | Developer and QA Tools | Development showcase | 1 | Operate / extend |
| 104 | Gated Operations and Internal Tooling | `Dev gated` | Developer and QA Tooling | Developer and QA Tools | Copy trading card demo | 1 | Operate / extend |

## Flow-State Contract Required For High-Risk Products

Use this standard for Trading, Margin, Bots, Copy, Wallet, P2P, Earn, Savings, Launchpad, and Prediction Markets:

```text
entry
  -> eligibility_check
  -> setup_or_configuration
  -> risk_and_fee_preview
  -> explicit_confirmation
  -> submitted_state
  -> receipt_or_status_detail
  -> manage_or_history
  -> support_or_recovery
```

## Priority Implementation Passes

| Priority | Pass | Scope | Acceptance Signal |
| --- | --- | --- | --- |
| P0 | Product hub IA | Home/Trade/Profile hub ordering, product state chips, recents, next action. | A user can identify where each major product lives in under one scan. |
| P0 | High-risk flow state contracts | Trading, Wallet, P2P, Margin, Earn, Launchpad, Copy, Bots. | Each has documented setup/preview/confirm/receipt/manage/support states. |
| P0 | Contextual support | Withdrawal, P2P, KYC, staking, launchpad, security, order flows. | Support opens with attached product context and case timeline. |
| P1 | Dynamic route explainability | P2P, Earn, Launchpad, Discovery, Cross-module. | Route-bearing data has typed intent contracts and human-readable flow map. |
| P1 | Dark professional interaction polish | Loading, empty, error, offline, submitting, success, risk states. | Every high-risk page uses shared state primitives and no blank/frozen screens. |
| P2 | Admin/dev gating | Enterprise operations and QA tooling. | Internal surfaces cannot appear in customer IA without explicit gating. |

## Completion Rule

This architecture is complete only when every flow in the reorder matrix has:

- a stable target layer and surface;
- a clear lifecycle stage;
- a verified route/screen mapping;
- a high-risk state contract where money, escrow, security, leverage, automation, prediction, yield, or token access is involved;
- a contextual support/recovery path where the action can fail, be delayed, or be disputed.
