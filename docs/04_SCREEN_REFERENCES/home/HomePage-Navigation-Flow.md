# VitTrade HomePage - Navigation Flow Report
## Báo cáo luồng điều hướng từ Trang Chủ

---

## 📍 TỔNG QUAN HỆ THỐNG NAVIGATION

### Route Prefix System (useRoutePrefix)

```
┌─────────────────────────────────────────────────────────────┐
│                    SHELL CONTEXT                            │
├─────────────────────────────────────────────────────────────┤
│  Phone (Mobile)    │  ''        │  /home, /wallet           │
│  Tablet            │  '/t'      │  /t/home, /t/wallet       │
│  Web (Desktop)     │  '/w'      │  /w/home, /w/wallet       │
│  Responsive        │  '/r'      │  /r/home, /r/wallet       │
└─────────────────────────────────────────────────────────────┘
```

**Tất cả routes trong báo cáo này được viết dưới dạng:** `${prefix}/path`
- Ví dụ: `${prefix}/wallet` → `/wallet`, `/t/wallet`, `/w/wallet`, `/r/wallet`

---

## 🗺️ SƠ ĐỒ NAVIGATION TỔNG THỂ

```
┌───────────────────────────────────────────────────────────────────────┐
│                         VITTRADE HOMEPAGE                             │
│                         (${prefix}/home)                              │
└───────────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
   ┌────▼────┐               ┌──────▼──────┐            ┌──────▼──────┐
   │ HEADER  │               │   CONTENT   │            │   BOTTOM    │
   │ ACTIONS │               │   SECTIONS  │            │    NAV      │
   └────┬────┘               └──────┬──────┘            └─────────────┘
        │                           │
   ┌────┴────┐               ┌──────┴──────┐
   │         │               │             │
┌──▼──┐   ┌──▼──┐      ┌────▼────┐   ┌────▼────┐
│Search│   │Notif│      │Portfolio│   │ Quick   │
│      │   │     │      │  Card   │   │Actions  │
└──┬───┘   └──┬──┘      └────┬────┘   └────┬────┘
   │          │              │             │
   │          │         ┌────┴────┐   ┌────┴────┐
   │          │         │  Nạp    │   │13 dịch  │
   │          │         │  Rút    │   │vụ khác  │
   │          │         │  Ví     │   │         │
   │          │         └────┬────┘   └────┬────┘
   │          │              │             │
   │          │              │             │
┌──▼──┐   ┌──▼──┐      ┌────▼────┐   ┌────▼────┐
│Search│   │Notif│      │ Wallet  │   │ Topics  │
│Page  │   │Page │      │ Section │   │ Launch  │
│      │   │     │      │         │   │ P2P...  │
└──────┘   └─────┘      └─────────┘   └─────────┘

   ┌─────────────────────────────────────────────────────────────┐
   │                      MARKET SECTION                          │
   │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐            │
   │  │  Hot    │ │ Gainers │ │ Losers  │ │   New   │            │
   │  │  Tab    │ │   Tab   │ │   Tab   │ │   Tab   │            │
   │  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘            │
   │       │           │           │           │                 │
   │       └───────────┴─────┬─────┴───────────┘                 │
   │                         │                                   │
   │                    ┌────▼────┐                              │
   │                    │  Pair   │                              │
   │                    │ Details │                              │
   │                    └─────────┘                              │
   └─────────────────────────────────────────────────────────────┘

   ┌─────────────────────────────────────────────────────────────┐
   │                    TRENDING SECTION                          │
   │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                   │
   │  │BTC  │ │ETH  │ │BNB  │ │SOL  │ │XRP  │  → Horizontal     │
   │  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘     Scroll        │
   │       ↓         ↓         ↓         ↓         ↓             │
   │    Pair Detail Page (same as market)                        │
   └─────────────────────────────────────────────────────────────┘

   ┌─────────────────────────────────────────────────────────────┐
   │                  TOP GAINERS/LOSERS                          │
   │  ┌─────────────┐         ┌─────────────┐                    │
   │  │ Top Tăng Giá│         │ Top Giảm Giá│                    │
   │  │ 3 items     │         │ 3 items     │                    │
   │  └──────┬──────┘         └──────┬──────┘                    │
   │         ↓                       ↓                           │
   │      Pair Detail Page (same)                                │
   └─────────────────────────────────────────────────────────────┘
```

---

## 🔗 CHI TIẾT CÁC ROUTES TỪ HOMEPAGE

### 1. HEADER ACTIONS (2 routes)

```
┌─────────────────────────────────────────────────────────────────────┐
│ HEADER BUTTONS                                                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  [🔍 Search] ────────────────────────► ${prefix}/search             │
│  │                                                                   │
│  │   Page: UnifiedSearchPage.tsx                                     │
│  │   Chức năng: Tìm kiếm toàn cục (coins, pairs, topics)            │
│  │   File: src/app/pages/discovery/UnifiedSearchPage.tsx            │
│  │                                                                   │
│  └─── Related Pages ──────────────────────────────────────────────   │
│       ${prefix}/pair/${id} → Chi tiết cặp giao dịch                 │
│       ${prefix}/topics → Khám phá chủ đề                            │
│                                                                      │
│  [🔔 Bell + Badge] ──────────────────► ${prefix}/notifications      │
│  │                                                                   │
│  │   Page: NotificationsPage.tsx                                     │
│  │   Chức năng: Danh sách thông báo người dùng                      │
│  │   File: src/app/pages/notifications/NotificationsPage.tsx        │
│  │                                                                   │
└─────────────────────────────────────────────────────────────────────┘
```

### 2. PORTFOLIO CARD ACTIONS (3 routes)

```
┌─────────────────────────────────────────────────────────────────────┐
│ PORTFOLIO CARD (${prefix}/home - embedded)                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Tổng tài sản: $54,276.79                                    │   │
│  │  PnL: +$1,842 (3.52%)                                        │   │
│  │                                                              │   │
│  │  ┌──────────────┬──────────────┬──────────────┐              │   │
│  │  │     NẠP     │     RÚT      │      VÍ      │              │   │
│  │  │     ⬇️       │      ⬆️       │      👛      │              │   │
│  │  └──────┬───────┴──────┬───────┴──────┬───────┘              │   │
│  │         │              │              │                       │   │
│  │         ▼              ▼              ▼                       │   │
│  │  ${prefix}/wallet    ${prefix}/wallet   ${prefix}/wallet      │   │
│  │  /deposit/usdt      /withdraw/usdt    (main)                  │   │
│  │         │              │              │                       │   │
│  │         │              │              │                       │   │
│  │    DepositPage    WithdrawPage   WalletPage                   │   │
│  │         │              │              │                       │   │
│  │         ▼              ▼              ▼                       │   │
│  │  src/app/pages/wallet/...                                     │   │
│  │  - DepositPage.tsx                                            │   │
│  │  - WithdrawPage.tsx                                           │   │
│  │  - WalletPage.tsx                                             │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  Related Wallet Pages (sub-navigation):                             │
│  ├── ${prefix}/wallet/deposit/:asset      (DepositPage)             │
│  ├── ${prefix}/wallet/withdraw/:asset     (WithdrawPage)            │
│  ├── ${prefix}/wallet/transfer            (TransferPage)            │
│  ├── ${prefix}/wallet/buy-crypto          (BuyCryptoPage)           │
│  ├── ${prefix}/wallet/address-book        (AddressBookPage)         │
│  ├── ${prefix}/wallet/tx-history          (TransactionHistoryPage)  │
│  └── ${prefix}/wallet/asset/:id           (AssetDetailPage)         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 3. QUICK ACTIONS GRID (13 routes)

```
┌─────────────────────────────────────────────────────────────────────┐
│ QUICK ACTIONS GRID - 13 DỊCH VỤ                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────┬──────────────────┬──────────────────┐        │
│  │   🔍 Khám phá    │   ⚡ Mua nhanh    │   🔄 Convert     │        │
│  │   ${prefix}/topics    │   ${prefix}/trade     │   ${prefix}/trade     │        │
│  │                  │   /btcusdt       │   /convert       │        │
│  │   TopicHubPage   │   TradePage      │   ConvertPage    │        │
│  └────────┬─────────┴─────────┬────────┴─────────┬────────┘        │
│           │                   │                  │                  │
│  ┌────────▼─────────┬─────────▼────────┬─────────▼────────┐        │
│  │   📊 P2P         │   🚀 Launchpad   │   🏦 Staking     │        │
│  │   ${prefix}/p2p         │   ${prefix}/launchpad    │   ${prefix}/earn      │        │
│  │                  │                  │   /staking       │        │
│  │   P2PHomePage    │   LaunchpadPage  │   StakingPage    │        │
│  └────────┬─────────┴─────────┬────────┴─────────┬────────┘        │
│           │                   │                  │                  │
│  ┌────────▼─────────┬─────────▼────────┬─────────▼────────┐        │
│  │   📅 Mua định kỳ │   🤖 Bot         │   📋 Copy Trade  │        │
│  │   ${prefix}/dca         │   ${prefix}/trade     │   ${prefix}/trade     │        │
│  │                  │   /bots          │   /copy-trading  │        │
│  │   DCAPage        │   TradingBotsPage│   CopyTradingPage│        │
│  └────────┬─────────┴─────────┬────────┴─────────┬────────┘        │
│           │                   │                  │                  │
│  ┌────────▼─────────┬─────────▼────────┬─────────▼────────┐        │
│  │   💰 Tiết kiệm   │   🎁 Phần thưởng │   📈 Margin      │        │
│  │   ${prefix}/earn      │   ${prefix}/rewards      │   ${prefix}/trade     │        │
│  │   /savings       │                  │   /margin        │        │
│  │   SavingsPage    │   RewardsHubPage │   MarginPage     │        │
│  └────────┬─────────┴─────────┬────────┴──────────────────┘        │
│           │                   │                                     │
│  ┌────────▼─────────┐         │                                     │
│  │   🎉 Giới thiệu  │         │                                     │
│  │   ${prefix}/referral    │         │                                     │
│  │                  │         │                                     │
│  │   ReferralHomePage│        │                                     │
│  └──────────────────┘         │                                     │
│                               │                                     │
└───────────────────────────────┴─────────────────────────────────────┘
```

#### Chi tiết 13 Quick Action Routes:

| # | Icon | Label | Route | Page File | Module |
|---|------|-------|-------|-----------|--------|
| 1 | 🔍 | Khám phá | `${prefix}/topics` | TopicHubPage.tsx | discovery |
| 2 | ⚡ | Mua nhanh | `${prefix}/trade/btcusdt` | TradePage.tsx | trade |
| 3 | 🔄 | Convert | `${prefix}/trade/convert` | ConvertPage.tsx | trade |
| 4 | 📊 | P2P | `${prefix}/p2p` | P2PHomePage.tsx | p2p |
| 5 | 🚀 | Launchpad | `${prefix}/launchpad` | LaunchpadPage.tsx | launchpad |
| 6 | 🏦 | Staking | `${prefix}/earn/staking` | StakingPage.tsx | earn |
| 7 | 📅 | Mua định kỳ | `${prefix}/dca` | DCAPage.tsx | dca |
| 8 | 🤖 | Bot | `${prefix}/trade/bots` | TradingBotsPage.tsx | trade/bots |
| 9 | 📋 | Copy Trade | `${prefix}/trade/copy-trading` | CopyTradingPage.tsx | trade |
| 10 | 💰 | Tiết kiệm | `${prefix}/earn/savings` | SavingsPage.tsx | earn |
| 11 | 🎁 | Phần thưởng | `${prefix}/rewards` | RewardsHubPage.tsx | rewards |
| 12 | 📈 | Margin | `${prefix}/trade/margin` | MarginTradingPage.tsx | trade |
| 13 | 🎉 | Giới thiệu | `${prefix}/referral` | ReferralHomePage.tsx | referral |

### 4. MARKET SECTION (2 + dynamic routes)

```
┌─────────────────────────────────────────────────────────────────────┐
│ MARKET SECTION                                                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Thị trường                              [Xem tất cả ❯]      │   │
│  │                                    │                         │   │
│  │                                    └──► ${prefix}/markets     │   │
│  │                                         MarketListPage       │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐                   │
│  │ 🔥 Hot  │ │📈 Tăng  │ │📉 Giảm  │ │ 🆕 Mới  │                   │
│  │  Tab    │ │  Tab    │ │  Tab    │ │  Tab    │                   │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘                   │
│       │           │           │           │                          │
│       └───────────┴─────┬─────┴───────────┘                          │
│                         │                                             │
│  ┌──────────────────────┼─────────────────────────────────────┐     │
│  │                      ▼                                     │     │
│  │  ┌──────────────────────────────────────────────────────┐  │     │
│  │  │ BTC/USDT                                $43,250 +2.5%│  │     │
│  │  │ ETH/USDT                                $2,680  +1.8%│  │     │
│  │  │ BNB/USDT                                  $315  -0.5%│  │     │
│  │  │ ...                                                  │  │     │
│  │  └────────────────────┬─────────────────────────────────┘  │     │
│  │                       │                                     │     │
│  │                       ▼ (click any row)                     │     │
│  │              ${prefix}/pair/${pair.id}                      │     │
│  │                       │                                     │     │
│  │                       ▼                                     │     │
│  │               PairDetailPage.tsx                            │     │
│  │               src/app/pages/market/                         │     │
│  └───────────────────────┼─────────────────────────────────────┘     │
│                          │                                            │
│  Dynamic Routes:         │                                            │
│  - ${prefix}/pair/btcusdt                                            │
│  - ${prefix}/pair/ethusdt                                            │
│  - ${prefix}/pair/bnbusdt                                            │
│  - ${prefix}/pair/solusdt                                            │
│  - ... (tất cả các cặp trong CRYPTO_PAIRS)                           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 5. TRENDING SECTION (1 + dynamic routes)

```
┌─────────────────────────────────────────────────────────────────────┐
│ TRENDING SECTION                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  ⚡ Xu hướng                            [Xem tất cả ❯]      │   │
│  │                                    │                         │   │
│  │                                    └──► ${prefix}/markets     │   │
│  │                                         (same as above)      │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  Horizontal Scroll:                                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │   BTC    │ │   ETH    │ │   BNB    │ │   SOL    │ │   XRP    │  │
│  │ $43,250  │ │ $2,680   │ │  $315    │ │  $98     │ │  $0.62   │  │
│  │  +2.5%   │ │  +1.8%   │ │  -0.5%   │ │  +5.2%   │ │  +0.3%   │  │
│  │    │     │ │    │     │ │    │     │ │    │     │ │    │     │  │
│  │    └─────┼─┘    └─────┼─┘    └─────┼─┘    └─────┼─┘    └─────┘  │
│  │          │            │            │            │                │
│  │          └────────────┴─────┬──────┴────────────┘                │
│  │                             │                                     │
│  │                             ▼                                     │
│  │                   ${prefix}/pair/${pair.id}                      │
│  │                                                             │
│  │                   (Same destination as Market List)         │
│  │                   PairDetailPage                            │
│  └─────────────────────────────────────────────────────────────┘     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 6. TOP GAINERS/LOSERS (2 + dynamic routes)

```
┌─────────────────────────────────────────────────────────────────────┐
│ TOP GAINERS & LOSERS                                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────┐  ┌──────────────────────────────┐ │
│  │ 📈 Top tăng giá              │  │ 📉 Top giảm giá              │ │
│  │        [Xem tất cả ❯]        │  │        [Xem tất cả ❯]        │ │
│  │              │               │  │              │               │ │
│  │              ▼               │  │              ▼               │ │
│  │      ${prefix}/markets       │  │      ${prefix}/markets       │ │
│  │                              │  │                              │ │
│  │  🥇 ETH  +8.42%              │  │  1.  SHIB  -5.23%            │ │
│  │  🥈 SOL  +6.18% ────────────┼──┼──► ${prefix}/pair/ethusdt    │ │
│  │  🥉 BNB  +4.75% ────────────┼──┼──► ${prefix}/pair/solusdt    │ │
│  │                              │  │                              │ │
│  │  (All click to PairDetail)   │  │  (All click to PairDetail)   │ │
│  └──────────────────────────────┘  └──────────────────────────────┘ │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📊 TỔNG HỢP ROUTES

### Tổng số routes từ HomePage: 25+ routes

| Category | Count | Routes |
|----------|-------|--------|
| Header Actions | 2 | /search, /notifications |
| Portfolio | 3 | /wallet, /wallet/deposit/usdt, /wallet/withdraw/usdt |
| Quick Actions | 13 | /topics, /trade/btcusdt, /trade/convert, /p2p, /launchpad, /earn/staking, /dca, /trade/bots, /trade/copy-trading, /earn/savings, /rewards, /trade/margin, /referral |
| Market | 2 | /markets, /pair/:id |
| Trending | 1 | /pair/:id (same) |
| Top Gainers/Losers | 2 | /markets, /pair/:id (same) |

### Route Patterns:

| Pattern | Description | Example |
|---------|-------------|---------|
| `${prefix}/home` | Trang chủ | /home, /t/home |
| `${prefix}/search` | Tìm kiếm | /search |
| `${prefix}/notifications` | Thông báo | /notifications |
| `${prefix}/wallet` | Ví chính | /wallet |
| `${prefix}/wallet/deposit/:asset` | Nạp tiền | /wallet/deposit/usdt |
| `${prefix}/wallet/withdraw/:asset` | Rút tiền | /wallet/withdraw/usdt |
| `${prefix}/trade/:pair` | Giao dịch | /trade/btcusdt |
| `${prefix}/trade/convert` | Chuyển đổi | /trade/convert |
| `${prefix}/trade/bots` | Bot trading | /trade/bots |
| `${prefix}/trade/copy-trading` | Copy trade | /trade/copy-trading |
| `${prefix}/trade/margin` | Margin | /trade/margin |
| `${prefix}/p2p` | P2P trading | /p2p |
| `${prefix}/earn/staking` | Staking | /earn/staking |
| `${prefix}/earn/savings` | Tiết kiệm | /earn/savings |
| `${prefix}/launchpad` | Launchpad | /launchpad |
| `${prefix}/dca` | Mua định kỳ | /dca |
| `${prefix}/rewards` | Phần thưởng | /rewards |
| `${prefix}/referral` | Giới thiệu | /referral |
| `${prefix}/topics` | Khám phá | /topics |
| `${prefix}/markets` | Danh sách thị trường | /markets |
| `${prefix}/pair/:id` | Chi tiết cặp | /pair/btcusdt |

---

## 🗂️ PHÂN CẤP MODULE

### Module Structure:

```
src/app/pages/
├── market/
│   ├── HomePage.tsx                 (Trang chủ - BẠN ĐANG Ở ĐÂY)
│   ├── PairDetailPage.tsx           (Chi tiết cặp)
│   └── MarketListPage.tsx           (Danh sách thị trường)
│
├── wallet/
│   ├── WalletPage.tsx               (Ví chính)
│   ├── DepositPage.tsx              (Nạp tiền)
│   └── WithdrawPage.tsx             (Rút tiền)
│
├── trade/
│   ├── TradePage.tsx                (Giao dịch)
│   ├── ConvertPage.tsx              (Chuyển đổi)
│   ├── MarginTradingPage.tsx        (Margin)
│   ├── CopyTradingPage.tsx          (Copy trading)
│   └── bots/
│       └── TradingBotsPage.tsx      (Bot)
│
├── earn/
│   ├── SavingsPage.tsx              (Tiết kiệm)
│   └── StakingPage.tsx              (Staking)
│
├── p2p/
│   └── P2PHomePage.tsx              (P2P)
│
├── launchpad/
│   └── LaunchpadPage.tsx            (Launchpad)
│
├── dca/
│   └── DCAPage.tsx                  (DCA)
│
├── rewards/
│   └── RewardsHubPage.tsx           (Phần thưởng)
│
├── referral/
│   └── ReferralHomePage.tsx         (Giới thiệu)
│
├── discovery/
│   └── TopicHubPage.tsx             (Khám phá)
│
├── notifications/
│   └── NotificationsPage.tsx        (Thông báo)
│
└── markets/
    └── MarketOverviewPage.tsx       (Thị trường)
```

---

## 🔄 NAVIGATION FLOW DIAGRAM (Sequence)

```
User Action                    Navigation                    Destination
─────────────────────────────────────────────────────────────────────────
Click 🔍 Search        →      navigate(prefix/search)       →   SearchPage
Click 🔔 Bell          →      navigate(prefix/notifications)→   NotifPage

Click "Nạp"            →      navigate(prefix/wallet/       →   DepositPage
                             deposit/usdt)
                             
Click "Rút"            →      navigate(prefix/wallet/       →   WithdrawPage
                             withdraw/usdt)
                             
Click "Ví"             →      navigate(prefix/wallet)       →   WalletPage

Click 🔍 Khám phá      →      navigate(prefix/topics)       →   TopicHub
Click ⚡ Mua nhanh      →      navigate(prefix/trade/btcusdt)→   TradePage
Click 🔄 Convert        →      navigate(prefix/trade/convert)→   ConvertPage
Click 📊 P2P            →      navigate(prefix/p2p)          →   P2PPage
Click 🚀 Launchpad      →      navigate(prefix/launchpad)    →   Launchpad
Click 🏦 Staking        →      navigate(prefix/earn/staking) →   StakingPage
Click 📅 DCA            →      navigate(prefix/dca)          →   DCAPage
Click 🤖 Bot            →      navigate(prefix/trade/bots)   →   BotsPage
Click 📋 Copy Trade    →      navigate(prefix/trade/copy-   →   CopyPage
                             trading)
Click 💰 Tiết kiệm      →      navigate(prefix/earn/savings) →   SavingsPage
Click 🎁 Phần thưởng    →      navigate(prefix/rewards)      →   RewardsPage
Click 📈 Margin         →      navigate(prefix/trade/margin) →   MarginPage
Click 🎉 Giới thiệu    →      navigate(prefix/referral)      →   ReferralPage

Click "Xem tất cả"     →      navigate(prefix/markets)       →   MarketsList
(Market/Trending/
Top Gainers/Losers)

Click Pair Row         →      navigate(prefix/pair/${id})    →   PairDetail
(Market/Trending/
Top Gainers/Losers)
```

---

## 📝 CODE REFERENCES

### HomePage Navigation Code:

```typescript
// Header Actions (lines 395, 403)
navigate(`${prefix}/search`)
navigate(`${prefix}/notifications`)

// Portfolio Actions (lines 195, 211, 228)
navigate(`${prefix}/wallet/deposit/usdt`)
navigate(`${prefix}/wallet/withdraw/usdt`)
navigate(`${prefix}/wallet`)

// Quick Actions (lines 255-267)
const actions = [
  { label: 'Khám phá', action: () => navigate(`${prefix}/topics`) },
  { label: 'Mua nhanh', action: () => navigate(`${prefix}/trade/btcusdt`) },
  { label: 'Convert', action: () => navigate(`${prefix}/trade/convert`) },
  { label: 'P2P', action: () => navigate(`${prefix}/p2p`) },
  { label: 'Launchpad', action: () => navigate(`${prefix}/launchpad`) },
  { label: 'Staking', action: () => navigate(`${prefix}/earn/staking`) },
  { label: 'Mua định kỳ', action: () => navigate(`${prefix}/dca`) },
  { label: 'Bot', action: () => navigate(`${prefix}/trade/bots`) },
  { label: 'Copy Trade', action: () => navigate(`${prefix}/trade/copy-trading`) },
  { label: 'Tiết kiệm', action: () => navigate(`${prefix}/earn/savings`) },
  { label: 'Phần thưởng', action: () => navigate(`${prefix}/rewards`) },
  { label: 'Margin', action: () => navigate(`${prefix}/trade/margin`) },
  { label: 'Giới thiệu', action: () => navigate(`${prefix}/referral`) },
];

// Market Section (lines 438, 470)
navigate(`${prefix}/markets`)
navigate(`${prefix}/pair/${pair.id}`)

// Trending Section (lines 532, 540)
navigate(`${prefix}/markets`)
navigate(`${prefix}/pair/${pair.id}`)

// Top Gainers (lines 585, 591)
navigate(`${prefix}/markets`)
navigate(`${prefix}/pair/${pair.id}`)

// Top Losers (lines 637, 643)
navigate(`${prefix}/markets`)
navigate(`${prefix}/pair/${pair.id}`)
```

---

## 🎯 KEY INSIGHTS

1. **Central Hub**: HomePage là trung tâm điều hướng đến 13+ module chức năng khác nhau

2. **Reused Destinations**: 
   - `${prefix}/markets` được sử dụng 4 lần (Market, Trending, Top Gainers, Top Losers)
   - `${prefix}/pair/${id}` được sử dụng 4 lần (cùng các section trên)

3. **Shell-Aware**: Tất cả routes đều sử dụng `useRoutePrefix()` để hỗ trợ multiple shells (phone, tablet, web, responsive)

4. **Dynamic Routes**: 
   - `/pair/:id` nhận dynamic pair ID (btcusdt, ethusdt, v.v.)
   - `/wallet/deposit/:asset` và `/wallet/withdraw/:asset` nhận asset symbol

5. **Deep Linking**: Mỗi Quick Action điều hướng trực tiếp đến chức năng cụ thể

---

*Report generated for navigation analysis and implementation planning*
