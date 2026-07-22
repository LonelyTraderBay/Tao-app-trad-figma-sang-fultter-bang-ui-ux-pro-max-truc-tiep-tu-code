# Hub Content Contract

Generated: 2026-07-21 · Expanded: STEP-P0.10  

Tier-A hubs = primary composition surfaces users land on from bottom nav, Home product tiles, or Discovery. Wireframes: `18`–`24`, `17`.

## Global rules (all Tier-A hubs)

| Rule | Requirement |
|------|-------------|
| Rhythm | Tab roots / hub roots: `VitPageRhythm.compact` |
| Above-fold jobs | **≤3** major jobs / sections in first viewport |
| Empty | Headline + primary CTA + secondary link |
| High-risk | Preview/confirm + `showVitNoticeSheet` (not SnackBar toast) |
| Boundaries | Arena = **points-only**; Predictions may use wallet/PnL; copy **vi-VN đủ dấu** |
| Forbidden sparse | Single tall empty card; spacer-only first screen; hero with no CTA; stacked “tool cards” with no primary action |

## Tier-A hub table

| Hub | Path (root) | ≤3 above-fold jobs | CTA rules | Forbidden sparse patterns | Wireframe |
|-----|-------------|--------------------|-----------|---------------------------|-----------|
| **Home** | `/home` | (1) Next action / portfolio pulse (2) Product groups (3) Discovery Predictions+Arena | Primary **Nạp**; secondary Rút; product tiles ≤1 tap to GIỮ | Flat 17-tile grid without groups; Support/Referral as Home quick actions | [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) |
| **Markets** | `/markets` | (1) Pair list + search/filter (2) Tool strip HUB (3) Discover footer shortcut | Primary = **tap pair**; tools = chips not full-page blanks | Heatmap/Watchlist orphan (no inbound); Discover presented as Discovery SO | [`19-MARKETS-HUB-WIREFRAME.md`](./19-MARKETS-HUB-WIREFRAME.md) |
| **Trade terminal** | `/trade` | (1) Chart + book (2) Order ticket Mua/Bán (3) Header Lệnh/Vị thế (D5) | Primary **Mua/Bán**; Orders/Positions = header, **not** hub tabs | Converting `/trade` into Orders hub-tab; missing D5 chrome | [`20-TRADE-HUB-WIREFRAME.md`](./20-TRADE-HUB-WIREFRAME.md) |
| **Wallet** | `/wallet` | (1) Balances (2) Nạp/Rút (3) D6 tools: history, address-book, health-score | Primary **Nạp/Rút** with preview; D6 visible; rest overflow | History only in overflow; ops ẨN tools as primary strip | [`21-WALLET-HUB-WIREFRAME.md`](./21-WALLET-HUB-WIREFRAME.md) |
| **Profile** | `/profile` | (1) Identity + KYC banner (D2) (2) Account sections (3) Pháp lý accordion entry | KYC banner → `/profile/kyc`; Support/Referral under Profile | Missing Pháp lý (39); KYC only buried without banner | [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) |
| **Earn** | `/earn` | (1) Stake / products (2) Hub tiles (analytics…) (3) Tài liệu & rủi ro sheet | Primary **Stake**; legal = sheet entry (31 GOM) | Empty stack of insight cards; no legal sheet | [`22-EARN-SAVINGS-HUB-WIREFRAME.md`](./22-EARN-SAVINGS-HUB-WIREFRAME.md) |
| **Savings** | `/earn/savings` | (1) Gửi tiết kiệm (2) Portfolio entry (3) Tools grid (not card stack) | Primary **Gửi tiết kiệm**; tools = tile/chip + overflow | Tall stacked tool cards (WhatIf/Guide/…) as first viewport only | [`22-EARN-SAVINGS-HUB-WIREFRAME.md`](./22-EARN-SAVINGS-HUB-WIREFRAME.md) |
| **P2P** | `/p2p` | (1) Marketplace Express (2) Tạo tin (3) Đơn hàng ≤3-tap | Primary **Express / Tạo tin**; insurance → Pháp lý not hub hero | Express buried >3 taps; insurance as primary hub chrome | [`23-P2P-HUB-WIREFRAME.md`](./23-P2P-HUB-WIREFRAME.md) |
| **Predictions** | `/markets/predictions` | (1) Event discovery (2) Category/portfolio entry (3) Trade event CTA | Primary **Trade event**; wallet/PnL OK | Casino/hype copy; Arena points language | [`24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md`](./24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md) |
| **Arena** | `/arena` | (1) Join / challenges (2) Studio entry (3) Fair-play / points pool | Primary **Join**; **points-only** (no payout/wallet/profit stake-return) | Wallet/PnL copy; sparse studio presets as hub root | [`24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md`](./24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md) |

## Shell note

Bottom-nav active tab matrix + D1 Trade highlight for secondary products: [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md).
