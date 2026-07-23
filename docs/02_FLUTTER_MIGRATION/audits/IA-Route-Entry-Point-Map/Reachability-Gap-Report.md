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
| RG-01 | `/markets/heatmap` | `MarketHeatmapPage` | HUB | `MarketListTools` chip «Bản đồ nhiệt» | — | **P2.1** | **closed** 2026-07-22 |
| RG-02 | `/markets/watchlist` | `WatchlistPage` | HUB | `MarketListTools` chip «Theo dõi» (≠ tab Yêu thích local) | — | **P2.1** | **closed** 2026-07-22 |
| RG-03 | `/trade/orders-history` | `OrdersHistoryPage` | GIỮ | Trade Spot header «Lệnh» (D5) | — | **P2.4** | **closed** 2026-07-22 |
| RG-04 | `/trade/positions` | `PositionDashboardPage` | GIỮ | Trade Spot header «Vị thế» (D5) | — | **P2.4** | **closed** 2026-07-22 |
| RG-05 | `/wallet/history` | `TransactionHistoryPage` | HUB | Wallet › Công cụ «Lịch sử» (D6 visible) | — | **P2.7** | **closed** 2026-07-22 |
| RG-06 | `/wallet/address-book` (proposed HUB bump) | Address-book page | HUB↑ | Wallet › Công cụ «Sổ địa chỉ» | — | **P2.7** | **closed** 2026-07-22 |
| RG-07 | `/wallet/health-score` (proposed HUB bump) | Health-score page | HUB↑ | Wallet › Công cụ «Sức khỏe ví» | — | **P2.7** | **closed** 2026-07-22 |
| RG-08 | Profile › Pháp lý & báo cáo (**39** GOM) | accordion host on `ProfilePage` | GOM | `_LegalAccordionSection` + `ProfileLegalCatalog` (search + 5 nhóm) | — | **P1.4** | **closed** 2026-07-22 |
| RG-09 | Earn › Tài liệu & rủi ro (**31** GOM) | sheet on `StakingEarnPage` | GOM | `StakingEarnPage` sheet + `EarnLegalCatalog` (5 cụm) | — | **P3.2** | **closed** 2026-07-22 |
| RG-10 | `/news` | `NewsPage` | GIỮ | Home header News → `/news` (`home_header.dart`) | — | **P1.2** | **closed** 2026-07-22 (verify) |
| RG-11 | Markets Discover footer vs Home Discovery | `MarketListDiscoverMoreSection` → Predictions / Arena | HUB shortcut | Footer = **shortcut only**; Home = Discovery **canonical** | **Yes** — by design (not a missing inbound) | P2.x (docs only) | **accepted exception** |
| RG-12 | `/referral` + Profile tab chrome | `ReferralHomePage` | GIỮ | Profile › Giới thiệu; `_activeDestinationForPath` → **profile** (carved out of D1 Trade) | — | **P1.3** + shell chrome | **closed** 2026-07-23 |
| RG-13 | Support / Referral still on Home quick actions (legacy) | `SupportPage` / `ReferralHomePage` | GIỮ | Removed from Home quick actions (`home_mock_data`); menu = Profile | — | **P1.1** / **P1.3** | **closed** 2026-07-22 (verify) |

## Exception register

| Gap ID | Why accepted | Revisit |
|--------|--------------|---------|
| RG-11 | Discover footer on Markets is intentional shortcut; Discovery SO = Home | Only if product moves Discovery off Home |

## Owner STEP map (quick)

| Phase | Gaps |
|-------|------|
| P1 | RG-08 closed; RG-10/12/13 **closed** |
| P2 | RG-01, RG-02, RG-03, RG-04, RG-05, RG-06, RG-07 |
| P3 | RG-09 |

## Exit criteria (program)

When all non-exception rows = `done` or deferred with written product sign-off in playbook.
