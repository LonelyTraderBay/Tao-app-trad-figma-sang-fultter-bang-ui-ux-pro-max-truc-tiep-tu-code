# Visual QA Route Manifest

Generated: 2026-07-21 · Expanded: STEP-P6.4  

Scope: all **33 GIỮ** entry points from [`99-ALL-ROUTES.md`](./99-ALL-ROUTES.md) / [`00-INDEX.md`](./00-INDEX.md).  
Evidence owner: Phase **P6** (STEP-P6.3 bottom-nav · P6.4 remaining GIỮ).

## Tier legend

| Tier | Meaning |
|------|---------|
| **P0** | Widget test + emulator @**360×800** (bottom-nav roots **must** include phone-first note) |
| **P1** | Spot / screenshot after parent hub redesign (HUB parents) |
| **P2** | Spot after legal GOM UI ships (Pháp lý / Earn sheet dependents) |

> Tiers + Evidence column filled in STEP-P6.3/P6.4. Automated phone QA: **65** flows @360×800 in `page_rhythm_phone_visual_qa_test.dart` (covers all 33 GIỮ).

## 33 GIỮ manifest

| # | EP | Path | Page class | Proposed Visual QA tier | @360×800 note | Evidence |
|--:|----|------|------------|-------------------------|---------------|----------|
| 1 | EP-01 | `/home` | `HomePage` | **P0** | **Bottom-nav root** — phone-first @360×800 required | phone QA flow 1 @360×800 |
| 2 | EP-02 | `/markets` | `MarketListPage` | **P0** | **Bottom-nav root** — phone-first @360×800 required | phone QA flow 43 @360×800 |
| 3 | EP-03 | `/trade` | `TradePage` | **P0** | **Bottom-nav root** — phone-first @360×800 required | phone QA flow 44 @360×800 |
| 4 | EP-04 | `/wallet` | `WalletPage` | **P0** | **Bottom-nav root** — phone-first @360×800 required | phone QA flow 33 @360×800 |
| 5 | EP-05 | `/profile` | `ProfilePage` | **P0** | **Bottom-nav root** — phone-first @360×800 required | phone QA flow 41 @360×800 |
| 6 | EP-06 | `/search` | `UnifiedSearchPage` | P0 | Header entry; compact first viewport | phone QA flow 45 @360×800 |
| 7 | EP-07 | `/notifications` | `NotificationsPage` | P0 | Header entry; empty state | phone QA flow 46 @360×800 |
| 8 | EP-08 | `/wallet/deposit` | `DepositPage` | P0 | High-risk form; preview path | phone QA flow 21 @360×800 |
| 9 | EP-09 | `/wallet/withdraw` | `WithdrawPage` | P0 | High-risk form; preview path | phone QA flow 20 @360×800 |
| 10 | EP-11 | `/trade/margin` | `MarginTradingPage` | P0 | Risk badge visible | phone QA flow 47 @360×800 |
| 11 | EP-12 | `/trade/convert` | `ConvertPage` | P0 | | phone QA flow 48 @360×800 |
| 12 | EP-13 | `/trade/copy-trading` | `CopyTradingPage` | P0 | | phone QA flow 49 @360×800 |
| 13 | EP-14 | `/trade/bots` | `TradingBotsPage` | P0 | | phone QA flow 50 @360×800 |
| 14 | EP-15 | `/earn` | `StakingEarnPage` | P0 | D1 Trade tab highlight | phone QA flow 51 @360×800 |
| 15 | EP-16 | `/earn/savings` | `SavingsPage` | P0 | D1 Trade tab highlight | phone QA flow 52 @360×800 |
| 16 | EP-17 | `/p2p` | `P2PHomePage` | P0 | ≤3-tap Express | phone QA flow 13 @360×800 |
| 17 | EP-18 | `/dca` | `DCAPage` | P0 | | phone QA flow 14 @360×800 |
| 18 | EP-19 | `/launchpad` | `LaunchpadPage` | P0 | | phone QA flow 53 @360×800 |
| 19 | EP-20 | `/markets/predictions` | `PredictionsHomePage` | P0 | Discovery SO from Home | phone QA flow 54 @360×800 |
| 20 | EP-21 | `/arena` | `ArenaHomePage` | P0 | Points-only copy | phone QA flow 5 @360×800 |
| 21 | EP-22 | `/rewards` | `RewardsHubPage` | P0 | | phone QA flow 12 @360×800 |
| 22 | EP-23 | `/referral` | `ReferralHomePage` | P0 | Profile menu + Profile tab | phone QA flow 55 @360×800 |
| 23 | EP-24 | `/support` | `SupportPage` | P0 | Profile menu | phone QA flow 56 @360×800 |
| 24 | EP-26 | `/trade/orders-history` | `OrdersHistoryPage` | P0 | After D5 header chrome | phone QA flow 57 @360×800 |
| 25 | EP-27 | `/trade/positions` | `PositionDashboardPage` | P0 | After D5 header chrome | phone QA flow 58 @360×800 |
| 26 | EP-28 | `/earn/dashboard` | `StakingDashboardPage` | P0 | | phone QA flow 59 @360×800 |
| 27 | EP-29 | `/earn/savings/portfolio` | `SavingsPortfolioPage` | P0 | | phone QA flow 60 @360×800 |
| 28 | EP-30 | `/news` | `NewsPage` | P0 | Home header News | phone QA flow 61 @360×800 |
| 29 | EP-31 | `/topics` | `TopicHubPage` | P0 | | phone QA flow 62 @360×800 |
| 30 | EP-32 | `/settings/security` | `SecurityPage` | P0 | High-risk | phone QA flow 63 @360×800 |
| 31 | EP-33 | `/profile/kyc` | `KYCPage` | P0 | From D2 banner | phone QA flow 64 @360×800 |
| 32 | EP-34 | `/unified-portfolio` | `UnifiedPortfolioDashboard` | P0 | Profile advanced | phone QA flow 9 @360×800 |
| 33 | EP-35 | `/auth/login` | `_AuthRouteShell` | P0 | Auth shell (no bottom nav) | phone QA flow 65 @360×800 |

**Count check:** 33 / 33 GIỮ. EP-10 (Futures mode) and EP-25 (pair detail) are not static GIỮ menu rows — excluded by design.

## Spot tiers (non-GIỮ / follow-ups)

| Tier | Who | When |
|------|-----|------|
| **P1** | HUB after parent redesign (e.g. Markets tools, Wallet D6 tiles) | After P2/P3 hub STEPs |
| **P2** | GOM after Profile Pháp lý / Earn legal sheet | After P1.4 / P3.2 |

## Exit

STEP-P6.3/P6.4 done: all 33 GIỮ have Visual QA tier + phone QA flow evidence before Phase 6 complete (`STEP-P6.5`).
