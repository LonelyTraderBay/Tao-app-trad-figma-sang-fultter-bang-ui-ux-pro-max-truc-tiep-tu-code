# Cross-Shell Navigation Edge Matrix

Generated: 2026-07-21 · **STEP-P0.9 thickened**  
Sources: [`99-ALL-ROUTES.md`](./99-ALL-ROUTES.md) (33 GIỮ), [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md), hub wireframes `17`–`25`, D1–D6 locks.

## Legend

| Field | Values |
|-------|--------|
| `nav_kind` | `go` · `push` · `sheet` · `deep_link` · `auth_shell` · `header` · `hero` · `bottom_nav` |
| `active_tab` | `home` · `markets` · `trade` · `wallet` · `profile` · `none` |
| `back_fallback` | path hoặc `pop_or_<parent>` |

**Verify:** bảng §1 đếm **33** GIỮ. EP-10 Futures + EP-25 Pair **không** có route tĩnh GIỮ — giải thích ở §3.

---

## 1. Full GIỮ edge table (33 rows)

| # | EP | Target path (logical) | Page | Source (canonical menu) | nav_kind | back_fallback | active_tab | Notes |
|--:|----|----------------------|------|-------------------------|----------|---------------|------------|-------|
| 1 | EP-01 | `/home` | `HomePage` | Bottom Nav | `bottom_nav` / `go` | — (root) | home | Tab root |
| 2 | EP-30 | `/news` | `NewsPage` | Home header Tin tức | `header` / `push` | `pop_or_/home` | home | RG-10 chrome |
| 3 | EP-35 | `/auth/login` | `_AuthRouteShell` | Auth shell | `auth_shell` | — | **none** | Ngoài shell (file 25) |
| 4 | EP-02 | `/markets` | `MarketListPage` | Bottom Nav | `bottom_nav` / `go` | — | markets | Tab root |
| 5 | EP-03 | `/trade` | `TradePage` | Bottom Nav | `bottom_nav` / `go` | — | trade | Spot terminal (D5) |
| 6 | EP-14 | `/trade/bots` | `TradingBotsPage` | Home › Pro (Bot) | `push` | `pop_or_/home` hoặc `/trade` | trade | |
| 7 | EP-12 | `/trade/convert` | `ConvertPage` | Home › Giao dịch | `push` | `pop_or_/home` | trade | Cũng từ Trade product switcher |
| 8 | EP-13 | `/trade/copy-trading` | `CopyTradingPage` | Home › Pro (Copy) | `push` | `pop_or_/home` | trade | |
| 9 | EP-11 | `/trade/margin` | `MarginTradingPage` | Home › Giao dịch + Trade switcher | `push` / `go` | `pop_or_/trade` | trade | |
| 10 | EP-26 | `/trade/orders-history` | `OrdersHistoryPage` | Trade terminal **header Lệnh** (D5) | `header` / `push` | `pop_or_/trade` | trade | Menu UI 99 còn chữ “hub” — **override D5** |
| 11 | EP-27 | `/trade/positions` | `PositionDashboardPage` | Trade terminal **header Vị thế** (D5) | `header` / `push` | `pop_or_/trade` | trade | D5 |
| 12 | EP-15 | `/earn` | `StakingEarnPage` | Home › Sinh lời | `push` | `pop_or_/home` | **trade** | D1 |
| 13 | EP-28 | `/earn/dashboard` | `StakingDashboardPage` | Earn hub dashboard | `push` | `pop_or_/earn` | trade | D1 |
| 14 | EP-16 | `/earn/savings` | `SavingsPage` | Home › Sinh lời | `push` | `pop_or_/home` | trade | D1 |
| 15 | EP-29 | `/earn/savings/portfolio` | `SavingsPortfolioPage` | Savings hub portfolio | `push` | `pop_or_/earn/savings` | trade | D1 |
| 16 | EP-04 | `/wallet` | `WalletPage` | Bottom Nav | `bottom_nav` / `go` | — | wallet | Tab root |
| 17 | EP-08 | `/wallet/deposit` | `DepositPage` | Home Hero **+** Wallet Nạp | `hero` / `push` | `pop_or_/wallet` hoặc `/home` | wallet | Dual entry |
| 18 | EP-09 | `/wallet/withdraw` | `WithdrawPage` | Home Next **+** Wallet Rút | `hero` / `push` | `pop_or_/wallet` hoặc `/home` | wallet | Dual entry; preview bắt buộc |
| 19 | EP-17 | `/p2p` | `P2PHomePage` | Home › Giao dịch (P2P) | `push` | `pop_or_/home` | **trade** | D1 · ≤3-tap Express |
| 20 | EP-05 | `/profile` | `ProfilePage` | Bottom Nav | `bottom_nav` / `go` | — | profile | Tab root |
| 21 | EP-33 | `/profile/kyc` | `KYCPage` | Profile KYC **banner** (D2) | `push` | `pop_or_/profile` | profile | + row phụ |
| 22 | EP-32 | `/settings/security` | `SecurityPage` | Profile › Bảo mật | `push` | `pop_or_/profile` | profile | |
| 23 | EP-21 | `/arena` | `ArenaHomePage` | Home › Discovery Arena | `push` | `pop_or_/home` | **trade** | D1 · points-only |
| 24 | EP-20 | `/markets/predictions` | `PredictionsHomePage` | Home › Discovery Predictions | `push` | `pop_or_/home` | **markets** | Prefix `/markets` → Markets tab |
| 25 | EP-19 | `/launchpad` | `LaunchpadPage` | Home › Khám phá | `push` | `pop_or_/home` | **trade** | D1 |
| 26 | EP-18 | `/dca` | `DCAPage` | Home › Sinh lời | `push` | `pop_or_/home` | **trade** | D1 |
| 27 | EP-07 | `/notifications` | `NotificationsPage` | Header Thông báo | `header` / `push` | `pop_or_/home` | home | |
| 28 | EP-23 | `/referral` | `ReferralHomePage` | Profile › Giới thiệu | `push` | `pop_or_/profile` | **profile** | RG-12 closed 2026-07-23 |
| 29 | EP-22 | `/rewards` | `RewardsHubPage` | Home › Khám phá | `push` | `pop_or_/home` | **trade** | D1 |
| 30 | EP-06 | `/search` | `UnifiedSearchPage` | Header Tìm kiếm | `header` / `push` | `pop_or_/home` | home | |
| 31 | EP-31 | `/topics` | `TopicHubPage` | Home › Khám phá | `push` | `pop_or_/home` | home | Explicit home mapping |
| 32 | EP-34 | `/unified-portfolio` | `UnifiedPortfolioDashboard` | Profile › Portfolio nâng cao | `push` | `pop_or_/profile` | **trade** | D1-ish utility |
| 33 | EP-24 | `/support` | `SupportPage` | Profile › Hỗ trợ | `push` | `pop_or_/profile` | home | Explicit `/support` → Home tab |

**Count = 33.**

---

## 2. HUB family rules (không liệt kê từng HUB)

| Family | Parent GIỮ | Inbound UI pattern | active_tab | Owner wireframe |
|--------|------------|--------------------|------------|-----------------|
| Markets tools (10 HUB) | `/markets` | Tool chips / header — **except** heatmap+watchlist gap | markets | `19` |
| Trade Margin / Copy / Bots HUB | EP-11/13/14 | Hub tiles / lists under product | trade | `20` |
| Wallet services | `/wallet` | Tools strip; D6 promote 3 | wallet | `21` |
| Earn Staking HUB + 31 GOM | `/earn` | Hub tiles + legal sheet | trade | `22` |
| Savings tools HUB | `/earn/savings` | Savings tool grid | trade | `22` |
| P2P Express & orders (~11 HUB) | `/p2p` | Marketplace + Công cụ drawer | trade | `23` |
| Predictions hub | `/markets/predictions` | Pred hub tiles | markets | `24` |
| Arena studio HUB | `/arena` | Arena hub (points) | trade | `24` |
| DCA / Launchpad HUB | `/dca`, `/launchpad` | Product hubs | trade | module maps `12`/`13` |

Canonical portfolios: Predictions = `/markets/predictions/portfolio`; Arena = `/arena/my` (Profile aliases redirect/deep-link here).

---

## 3. Missing EP static routes (by design)

| EP | Concept | Why not in §1 |
|----|---------|---------------|
| EP-10 | Futures mode `/trade/:pair/futures` | Mode trên terminal — không route tĩnh GIỮ |
| EP-25 | Pair detail `/pair/:pairId` | Tap cặp — ẨN / deep link |

---

## 4. GOM canonical homes (no duplicate menus)

| Bucket | Parent UI | ~Count | Canonical only |
|--------|-----------|-------:|----------------|
| Profile → Pháp lý & báo cáo | `/profile` accordion | 39 | Yes — không nhân đôi trên Home |
| Earn → Tài liệu & rủi ro | `/earn` sheet | 31 | Yes — không nhân đôi dưới Savings |
| Copy → Tuân thủ / audit (subset) | `/trade/copy-trading` | ~2+ | Copy-specific only; bulk compliance → Profile |
| P2P insurance legal | Profile Pháp lý | (subset) | Không ở P2P marketplace surface |

---

## 5. Reselect / dual-entry rules

| Rule | Spec |
|------|------|
| Tab reselect | `context.go(tab.routePath)` → root tab |
| Deposit/Withdraw | Dual Home + Wallet — **giữ** |
| Discovery | Home **canonical**; Markets footer = shortcut (RG-11 exception) |
| Support / Referral | Menu = Profile; **gỡ** khỏi Home quick actions (P1.1) |
| Predictions active_tab | **markets** (path prefix), dù entry từ Home Discovery |

---

## 6. Known gaps (pointer → Reachability report)

Chi tiết: [`Reachability-Gap-Report.md`](./Reachability-Gap-Report.md) RG-01…RG-13.

---

## 7. Verify checklist (STEP-P0.9)

- [x] GIỮ rows = **33**
- [x] EP-10/25 explained
- [x] HUB family rule block present
- [x] GOM homes không trùng Home
- [x] D1/D5/D6 reflected on active_tab / nav_kind
