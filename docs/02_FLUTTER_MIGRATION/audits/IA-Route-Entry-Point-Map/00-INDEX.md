# IA Route Entry Point Map — Index

Generated: 2026-07-13 · **Readiness pack updated: 2026-07-21**

## Readiness status (2026-07-21)

| Gate | Result |
|------|--------|
| Evidence pack | **SPEC DEPTH READY FOR P1** |
| Route + navigation audits | **PASS** |
| Implementation unblock | **CONDITIONAL** — see [UI-UX-Pre-Implementation-Gate.md](./UI-UX-Pre-Implementation-Gate.md) |
| **Execution playbook (chi tiết + tiến độ)** | [UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md](./UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md) |
| Short outline | [UI-UX-REORG-MASTER-PLAN.md](./UI-UX-REORG-MASTER-PLAN.md) |

> **Bắt đầu từ đây:** P0 **done** — mở [playbook](./UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md) → **STEP-P1.1** (Home product groups). Khuyến nghị **new chat** khi sang code (playbook §0.5 #4). D1–D6 đã khóa.

Generated: 2026-07-13  
Source: ``Flutter-Route-Coverage-Truth-Table.md`` (413 ``real_page`` routes)  
Phân loại + **Menu UI đề xuất** theo quy tắc IA (chỉnh tay khi product đổi).

## Legend — Phân loại

| Phân loại | Ý nghĩa |
|-----------|---------|
| **GIỮ** | Entry point — hiển thị nav / Home / header |
| **HUB** | Màn cấp 2 trong hub cha (tile / tab / section) |
| **ẨN** | Flow step, dynamic `:id`, receipt, confirm |
| **GOM** | Gộp menu Pháp lý & báo cáo / Nâng cao |
| **DEV** | Nội bộ / QA / admin |

## Legend — Menu UI đề xuất

| Vị trí menu | Mô tả |
|-------------|-------|
| **Bottom Nav → *** | 5 tab chính (Home, Markets, Trade, Wallet, Profile) |
| **Header → *** | Search, Notifications; News trên Home header |
| **Home Hero / Next action** | Nạp, Rút — CTA ưu tiên |
| **Home → Sản phẩm Giao dịch** | Spot-adjacent: Margin, Convert, P2P |
| **Home → Sản phẩm Pro** | Copy Trading, Bots |
| **Home → Sản phẩm Sinh lời** | Earn, Savings, DCA |
| **Home → Sản phẩm Khám phá** | Launchpad, Rewards, Topics |
| **Home → Discovery** | Card Predictions & Arena (tách biệt product) |
| **Trade terminal → *** | Spot terminal + Orders/Positions secondary (không phải tab hub) |
| **Earn / Savings hub → *** | Tile/tab trong hub Sinh lời |
| **Profile → *** | KYC, Bảo mật, Hỗ trợ, Pháp lý, Portfolio nâng cao |
| **— Flow / deep link** | Không menu — contextual navigation |
| **Ẩn — Dev/Admin** | Không production |

## Summary phân loại

| Phân loại | Số route |
|-----------|----------:|
| ẨN | 205 |
| DEV | 12 |
| GIỮ | 33 |
| GOM | 72 |
| HUB | 91 |
| **Tổng** | **413** |

## Top Menu UI (theo số route)

| Menu UI đề xuất | Số route |
|-----------------|----------:|
| — Flow / deep link (không menu) | 192 |
| Profile → Pháp lý & báo cáo | 39 |
| Earn → Tài liệu & rủi ro | 31 |
| Savings hub → Công cụ (tile/tab) | 15 |
| Ẩn — Dev/Admin | 12 |
| P2P hub → Express & đơn hàng | 11 |
| Markets hub → Công cụ & danh sách | 10 |
| DCA hub → Lịch & công cụ | 10 |
| Earn hub → Staking (tile/tab) | 8 |
| Bots hub → Công cụ & chiến lược | 6 |
| — Auth flow (không menu) | 6 |
| Copy hub → Công cụ & danh sách | 6 |
| Predictions hub → Danh mục & portfolio | 5 |
| Arena hub → Studio & thách đấu | 5 |
| Launchpad hub → Dự án & portfolio | 4 |
| — Markets → tap cặp | 3 |
| Margin hub → Công cụ | 2 |
| — Trade → chọn cặp Futures | 2 |

## 35 Entry Points (khái niệm nav)

| EP | Entry | Menu UI (nếu có route GIỮ) |
|----|-------|---------------------------|
| EP-01 | Home `/home` | Bottom Nav → Home |
| EP-02 | Markets `/markets` | Bottom Nav → Markets |
| EP-03 | Trade Spot `/trade` | Bottom Nav → Trade |
| EP-04 | Wallet `/wallet` | Bottom Nav → Wallet |
| EP-05 | Profile `/profile` | Bottom Nav → Profile |
| EP-06 | Search `/search` | Header → Tìm kiếm |
| EP-07 | Notifications `/notifications` | Header → Thông báo |
| EP-08 | Deposit `/wallet/deposit` | Home Hero + Wallet → Nạp |
| EP-09 | Withdraw `/wallet/withdraw` | Home Next action + Wallet → Rút |
| EP-10 | Futures `/trade/:pair/futures` | *(mode — không route tĩnh)* |
| EP-11 | Margin `/trade/margin` | Trade tab + Home Giao dịch |
| EP-12 | Convert `/trade/convert` | Home Giao dịch |
| EP-13 | Copy Trading `/trade/copy-trading` | Home Pro (Copy) |
| EP-14 | Bots `/trade/bots` | Home Pro (Bot) |
| EP-15 | Earn `/earn` | Home Sinh lời (Staking) |
| EP-16 | Savings `/earn/savings` | Home Sinh lời (Tiết kiệm) |
| EP-17 | P2P `/p2p` | Home Giao dịch (P2P) |
| EP-18 | DCA `/dca` | Home Sinh lời (DCA) |
| EP-19 | Launchpad `/launchpad` | Home Khám phá |
| EP-20 | Predictions `/markets/predictions` | Home Discovery Predictions |
| EP-21 | Arena `/arena` | Home Discovery Arena |
| EP-22 | Rewards `/rewards` | Home Khám phá (Rewards) |
| EP-23 | Referral `/referral` | Profile → Giới thiệu |
| EP-24 | Support `/support` | Profile → Hỗ trợ |
| EP-25 | Pair detail `/markets/pair/:id` | *(tap cặp — không menu)* |
| EP-26 | Orders `/trade/orders` | Trade terminal → header Lệnh (D5) |
| EP-27 | Positions `/trade/positions` | Trade terminal → header Vị thế (D5) |
| EP-28 | Staking dashboard `/earn/dashboard` | Earn hub dashboard |
| EP-29 | Savings portfolio `/earn/savings/portfolio` | Savings hub portfolio |
| EP-30 | News `/news` | Home header → Tin tức |
| EP-31 | Topics `/topics` | Home Khám phá (Topics) |
| EP-32 | Security `/settings/security` | Profile → Bảo mật |
| EP-33 | KYC `/profile/kyc` | Profile → KYC banner |
| EP-34 | Unified portfolio `/unified-portfolio` | Profile Portfolio nâng cao |
| EP-35 | Login `/auth/login` | Auth shell |

## Files by module

- [01-home.md](./01-home.md) — 2 routes
- [02-auth.md](./02-auth.md) — 7 routes
- [03-markets.md](./03-markets.md) — 22 routes
- [04-trade.md](./04-trade.md) — 59 routes
- [05-trade-compliance.md](./05-trade-compliance.md) — 30 routes
- [06-earn.md](./06-earn.md) — 70 routes
- [07-wallet.md](./07-wallet.md) — 21 routes
- [08-p2p.md](./08-p2p.md) — 79 routes
- [09-profile.md](./09-profile.md) — 14 routes
- [10-arena.md](./10-arena.md) — 25 routes
- [11-predictions.md](./11-predictions.md) — 18 routes
- [12-launchpad.md](./12-launchpad.md) — 24 routes
- [13-dca.md](./13-dca.md) — 13 routes
- [14-utility-cross-module.md](./14-utility-cross-module.md) — 21 routes
- [15-support.md](./15-support.md) — 3 routes
- [16-admin-dev.md](./16-admin-dev.md) — 5 routes
- [99-ALL-ROUTES.md](./99-ALL-ROUTES.md) — **413 routes (master)**
- [17-HOME-PROFILE-MENU-WIREFRAME.md](./17-HOME-PROFILE-MENU-WIREFRAME.md) — **wireframe text Home & Profile**

## Wireframes, specs & planning (readiness pack)

- [18-APP-SHELL-BOTTOM-NAV-SPEC.md](./18-APP-SHELL-BOTTOM-NAV-SPEC.md)
- [19-MARKETS-HUB-WIREFRAME.md](./19-MARKETS-HUB-WIREFRAME.md)
- [20-TRADE-HUB-WIREFRAME.md](./20-TRADE-HUB-WIREFRAME.md)
- [21-WALLET-HUB-WIREFRAME.md](./21-WALLET-HUB-WIREFRAME.md)
- [22-EARN-SAVINGS-HUB-WIREFRAME.md](./22-EARN-SAVINGS-HUB-WIREFRAME.md)
- [23-P2P-HUB-WIREFRAME.md](./23-P2P-HUB-WIREFRAME.md)
- [24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md](./24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md)
- [25-AUTH-ONBOARDING-SHELL-SPEC.md](./25-AUTH-ONBOARDING-SHELL-SPEC.md)
- [26-CROSS-SHELL-NAV-EDGE-MATRIX.md](./26-CROSS-SHELL-NAV-EDGE-MATRIX.md)
- [UX-Evidence-Matrix.csv](./UX-Evidence-Matrix.csv)
- [Pre-Implementation-Baseline-Snapshot.md](./Pre-Implementation-Baseline-Snapshot.md)
- [Reachability-Gap-Report.md](./Reachability-Gap-Report.md)
- [Button-Wiring-Baseline-Ledger.md](./Button-Wiring-Baseline-Ledger.md)
- [Sparse-Screen-Watchlist.md](./Sparse-Screen-Watchlist.md)
- [Hub-Content-Contract.md](./Hub-Content-Contract.md)
- [State-Coverage-by-Archetype.md](./State-Coverage-by-Archetype.md)
- [Visual-QA-Route-Manifest.md](./Visual-QA-Route-Manifest.md)
- [Home-Profile-IA-Delta-Checklist.md](./Home-Profile-IA-Delta-Checklist.md)
- [UI-UX-Pre-Implementation-Gate.md](./UI-UX-Pre-Implementation-Gate.md)
- [UI-UX-REORG-MASTER-PLAN.md](./UI-UX-REORG-MASTER-PLAN.md) — outline ngắn
- [UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md](./UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md) — **kế hoạch chi tiết + tracker tiến độ (51 STEP)**

> **Lưu ý:** **33** dòng GIỮ trong bảng route ↔ **35 EP** khái niệm (EP-10 Futures và EP-25 Pair không có route tĩnh). Menu UI chỉ hiển thị trên **GIỮ** + **HUB** + **GOM** — **ẨN** không xuất hiện menu.
