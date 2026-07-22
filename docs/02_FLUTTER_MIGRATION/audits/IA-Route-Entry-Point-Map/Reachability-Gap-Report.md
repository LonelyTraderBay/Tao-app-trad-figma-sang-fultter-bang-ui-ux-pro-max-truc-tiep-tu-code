# Reachability Gap Report

Generated: 2026-07-21 · Expanded: STEP-P0.10  

Sources: [`19`](./19-MARKETS-HUB-WIREFRAME.md), [`20`](./20-TRADE-HUB-WIREFRAME.md), [`21`](./21-WALLET-HUB-WIREFRAME.md), [`22`](./22-EARN-SAVINGS-HUB-WIREFRAME.md), [`17`](./17-HOME-PROFILE-MENU-WIREFRAME.md), [`18`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md), playbook D1–D6.

## Acceptance

- Zero **HUB** without inbound UI **or** a documented exception.
- Legal GOM UIs (Profile 39 / Earn 31) ship **or** explicit deferral with owner STEP.
- GIỮ chrome gaps (Orders/Positions, News, Wallet promotes) closed by owner STEP before Phase exit.

## Gap table

| Gap ID | Route / path | Page class | Class | Current inbound | Exception? | Owner STEP | Status |
|--------|--------------|------------|-------|-----------------|------------|------------|--------|
| RG-01 | `/markets/heatmap` | `MarketHeatmapPage` | HUB | **none** on `MarketListPage` (no chip/header) | No — must add inbound | **P2.1** | open |
| RG-02 | `/markets/watchlist` | `WatchlistPage` | HUB | **none** — tab «Yêu thích» filters local list only; does not `go` watchlist | No — favorite ≠ Watchlist route | **P2.1** | open |
| RG-03 | `/trade/orders-history` | `OrdersHistoryPage` | GIỮ | Reachable by path; **not** persistent Trade terminal chrome | No — D5 = header «Lệnh» | **P2.4** | open (D5 lock) |
| RG-04 | `/trade/positions` | `PositionDashboardPage` | GIỮ | Reachable by path; **not** persistent Trade terminal chrome | No — D5 = header «Vị thế» | **P2.4** | open (D5 lock) |
| RG-05 | `/wallet/history` | `TransactionHistoryPage` | HUB | Buried in overflow «Thêm thao tác» | No — D6 promote visible | **P2.7** | open (D6 lock) |
| RG-06 | `/wallet/address-book` (proposed HUB bump) | Address-book page | HUB↑ | No hub tile | No — D6 promote | **P2.7** | open (D6 lock) |
| RG-07 | `/wallet/health-score` (proposed HUB bump) | Health-score page | HUB↑ | No hub tile | No — D6 promote | **P2.7** | open (D6 lock) |
| RG-08 | Profile › Pháp lý & báo cáo (**39** GOM) | accordion host on `ProfilePage` | GOM | Routes exist; **UI accordion absent** | No — must ship menu | **P1.4** | open |
| RG-09 | Earn › Tài liệu & rủi ro (**31** GOM) | sheet on `StakingEarnPage` | GOM | `StakingEarnPage` sheet + `EarnLegalCatalog` (5 cụm) | — | **P3.2** | **closed** 2026-07-22 |
| RG-10 | `/news` | `NewsPage` | GIỮ | Spec = Home header [📰]; verify production header action | No if missing in code | **P1.2** | open / verify |
| RG-11 | Markets Discover footer vs Home Discovery | `MarketListDiscoverMoreSection` → Predictions / Arena | HUB shortcut | Footer = **shortcut only**; Home = Discovery **canonical** | **Yes** — by design (not a missing inbound) | P2.x (docs only) | **accepted exception** |
| RG-12 | `/referral` + D1 Trade highlight | `ReferralHomePage` | GIỮ | Canonical menu = Profile › Giới thiệu; path may still highlight **Trade** (D1 Option A) | **Tension** — menu Profile vs tab Trade | **P1.3** + shell D1 | open tension |
| RG-13 | Support / Referral still on Home quick actions (legacy) | `SupportPage` / `ReferralHomePage` | GIỮ | Dual entry risk if Home tiles remain | No — move off Home → Profile | **P1.1** / **P1.3** | open |

## Exception register

| Gap ID | Why accepted | Revisit |
|--------|--------------|---------|
| RG-11 | Discover footer on Markets is intentional shortcut; Discovery SO = Home | Only if product moves Discovery off Home |
| RG-12 | D1 locks secondary-product Trade highlight; Referral **menu home** stays Profile | Clarify chrome copy in P1; do not invent Referral tab |

## Owner STEP map (quick)

| Phase | Gaps |
|-------|------|
| P1 | RG-08, RG-10, RG-12, RG-13 |
| P2 | RG-01, RG-02, RG-03, RG-04, RG-05, RG-06, RG-07 |
| P3 | RG-09 |

## Exit criteria (program)

When all non-exception rows = `done` or deferred with written product sign-off in playbook.
