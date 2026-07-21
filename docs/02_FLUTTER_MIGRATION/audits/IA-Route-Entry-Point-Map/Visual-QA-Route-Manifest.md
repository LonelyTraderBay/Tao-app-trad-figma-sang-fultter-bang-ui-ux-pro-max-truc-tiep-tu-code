# Visual QA Route Manifest

Generated: 2026-07-21 · Expanded: STEP-P0.10  

Scope: all **33 GIỮ** entry points from [`99-ALL-ROUTES.md`](./99-ALL-ROUTES.md) / [`00-INDEX.md`](./00-INDEX.md).  
Evidence owner: Phase **P6** (STEP-P6.3 bottom-nav · P6.4 remaining GIỮ).

## Tier legend

| Tier | Meaning |
|------|---------|
| **P0** | Widget test + emulator @**360×800** (bottom-nav roots **must** include phone-first note) |
| **P1** | Spot / screenshot after parent hub redesign (HUB parents) |
| **P2** | Spot after legal GOM UI ships (Pháp lý / Earn sheet dependents) |

> Proposed tiers below are **planning**; automated evidence lands in P6. Today ~43 automated flows vs 413 routes.

## 33 GIỮ manifest

| # | EP | Path | Page class | Proposed Visual QA tier | @360×800 note |
|--:|----|------|------------|-------------------------|---------------|
| 1 | EP-01 | `/home` | `HomePage` | **P0** | **Bottom-nav root** — phone-first @360×800 required |
| 2 | EP-02 | `/markets` | `MarketListPage` | **P0** | **Bottom-nav root** — phone-first @360×800 required |
| 3 | EP-03 | `/trade` | `TradePage` | **P0** | **Bottom-nav root** — phone-first @360×800 required |
| 4 | EP-04 | `/wallet` | `WalletPage` | **P0** | **Bottom-nav root** — phone-first @360×800 required |
| 5 | EP-05 | `/profile` | `ProfilePage` | **P0** | **Bottom-nav root** — phone-first @360×800 required |
| 6 | EP-06 | `/search` | `UnifiedSearchPage` | P0 | Header entry; compact first viewport |
| 7 | EP-07 | `/notifications` | `NotificationsPage` | P0 | Header entry; empty state |
| 8 | EP-08 | `/wallet/deposit` | `DepositPage` | P0 | High-risk form; preview path |
| 9 | EP-09 | `/wallet/withdraw` | `WithdrawPage` | P0 | High-risk form; preview path |
| 10 | EP-11 | `/trade/margin` | `MarginTradingPage` | P0 | Risk badge visible |
| 11 | EP-12 | `/trade/convert` | `ConvertPage` | P0 | |
| 12 | EP-13 | `/trade/copy-trading` | `CopyTradingPage` | P0 | |
| 13 | EP-14 | `/trade/bots` | `TradingBotsPage` | P0 | |
| 14 | EP-15 | `/earn` | `StakingEarnPage` | P0 | D1 Trade tab highlight |
| 15 | EP-16 | `/earn/savings` | `SavingsPage` | P0 | D1 Trade tab highlight |
| 16 | EP-17 | `/p2p` | `P2PHomePage` | P0 | ≤3-tap Express |
| 17 | EP-18 | `/dca` | `DCAPage` | P0 | |
| 18 | EP-19 | `/launchpad` | `LaunchpadPage` | P0 | |
| 19 | EP-20 | `/markets/predictions` | `PredictionsHomePage` | P0 | Discovery SO from Home |
| 20 | EP-21 | `/arena` | `ArenaHomePage` | P0 | Points-only copy |
| 21 | EP-22 | `/rewards` | `RewardsHubPage` | P0 | |
| 22 | EP-23 | `/referral` | `ReferralHomePage` | P0 | Profile menu + D1 Trade tension |
| 23 | EP-24 | `/support` | `SupportPage` | P0 | Profile menu |
| 24 | EP-26 | `/trade/orders-history` | `OrdersHistoryPage` | P0 | After D5 header chrome |
| 25 | EP-27 | `/trade/positions` | `PositionDashboardPage` | P0 | After D5 header chrome |
| 26 | EP-28 | `/earn/dashboard` | `StakingDashboardPage` | P0 | |
| 27 | EP-29 | `/earn/savings/portfolio` | `SavingsPortfolioPage` | P0 | |
| 28 | EP-30 | `/news` | `NewsPage` | P0 | Home header News |
| 29 | EP-31 | `/topics` | `TopicHubPage` | P0 | |
| 30 | EP-32 | `/settings/security` | `SecurityPage` | P0 | High-risk |
| 31 | EP-33 | `/profile/kyc` | `KYCPage` | P0 | From D2 banner |
| 32 | EP-34 | `/unified-portfolio` | `UnifiedPortfolioDashboard` | P0 | Profile advanced |
| 33 | EP-35 | `/auth/login` | `_AuthRouteShell` | P0 | Auth shell (no bottom nav) |

**Count check:** 33 / 33 GIỮ. EP-10 (Futures mode) and EP-25 (pair detail) are not static GIỮ menu rows — excluded by design.

## Spot tiers (non-GIỮ / follow-ups)

| Tier | Who | When |
|------|-----|------|
| **P1** | HUB after parent redesign (e.g. Markets tools, Wallet D6 tiles) | After P2/P3 hub STEPs |
| **P2** | GOM after Profile Pháp lý / Earn legal sheet | After P1.4 / P3.2 |

## Exit

All 33 GIỮ have Visual QA tier + evidence before Phase 6 complete (`STEP-P6.5`).
