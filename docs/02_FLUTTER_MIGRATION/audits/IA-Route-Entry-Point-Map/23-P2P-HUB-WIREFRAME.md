# Wireframe text — P2P Hub / Marketplace (EP-17)

Generated: 2026-07-21 · **STEP-P0.7 thickened**  
Nguồn:
- [`08-p2p.md`](./08-p2p.md) — **1 GIỮ + 11 HUB + 2 GOM + 65 ẨN** (79 routes)
- [`Hub-Content-Contract.md`](./Hub-Content-Contract.md) — marketplace = list/hero first; tools = drawer/sheet, không tile-stack above fold
- [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md) — **D1**: mọi `/p2p*` highlight **Trade**
- Entry Home: [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) — Sản phẩm › Giao dịch › P2P
- Production: `flutter_app/lib/features/p2p/presentation/pages/hub/p2p_home_page.dart` (+ parts state / offer list / common)
- Express: `pages/hub/p2p_express_page.dart`
- Paths: `p2p_route_ids.dart` / `AppRoutePaths.p2p*`

Phạm vi: **Marketplace (quảng cáo + Express + tạo tin + đơn)** vs **Công cụ P2P (drawer / sheet ~11 HUB)**; insurance **GOM → Profile › Pháp lý**.  
Không redesign Spot terminal (file 20). P2P là secondary product dưới D1.

---

## 0. Active tab (D1) + dual-axis model

| Path prefix | Bottom nav highlight | Chi tiết |
|-------------|----------------------|----------|
| `/p2p`, `/p2p/*` | **Trade** | Locked D1 Option A — **không** tạo tab P2P riêng |

| Axis | Role | Surface |
|------|------|---------|
| **Marketplace** | Mua/Bán P2P qua danh sách tin, Express, tạo tin, đơn hàng | Body chính `P2PHomePage` |
| **Công cụ P2P** | Dashboard, Express hub entry, guide, payment history, compliance overview, fund-lock history, security login history, notifications, ad analytics | Header overflow / drawer / sheet «Công cụ» — **không** thay body marketplace |

**Quy tắc:** ẨN flows (chat, dispute, escrow, KYC steps, order proof/rate/cancel…) chỉ mở **contextual** từ order/ad/merchant — **không** gắn menu hub L1.

---

## 1. ASCII wireframe @360×800

### 1.1 CURRENT (production — marketplace-first; HUB tools yếu)

```
┌─────────────────────────────────────────────┐
│ P2P                          [+] [Đơn]      │  ← create + my-orders header
│ Giao dịch ngang hàng                        │
├─────────────────────────────────────────────┤
│ (optional) KYC banner / high-risk panel     │
├─────────────────────────────────────────────┤
│ Quick hub — stats + [Express] […actions]    │  ← quickHubKey (Express nổi)
├─────────────────────────────────────────────┤
│ [Mua●] [Bán]          asset rail · fiat     │
│ [Tìm kiếm…]                    [Bộ lọc]     │
├─────────────────────────────────────────────┤
│ DANH SÁCH TIN (ads)                         │
│  Merchant · giá · hạn mức · PTTT · CTA      │
│  / empty «Chưa có tin phù hợp»              │
├─────────────────────────────────────────────┤
│ Link Hướng dẫn · disclaimer escrow (micro)  │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│  ← D1 Trade
└─────────────────────────────────────────────┘
```

**Thiếu hôm nay:** drawer/sheet «Công cụ» gom đủ **11 HUB**; insurance vẫn có thể lộ từ deep link / compliance chứ chưa canonical Profile Pháp lý; My Ads / Order Book / Wallet P2P là ẨN — dễ lẫn nếu promote nhầm lên L1.

### 1.2 PROPOSED (marketplace body + Công cụ drawer)

```
┌─────────────────────────────────────────────┐
│ P2P                    [+] [Đơn] [Công cụ]  │  ← + = Tạo tin; Đơn; drawer HUB
│ Mua/Bán ngang hàng · ký quỹ escrow          │
├─────────────────────────────────────────────┤
│ HERO / QUICK — Express nổi bật              │
│ [  Express nhanh  ]  [  Tạo tin › ]         │  ← ≤3-tap primaries
│ (optional) KYC / high-risk                  │
├─────────────────────────────────────────────┤
│ [Mua●] [Bán] + asset + fiat + search/filter │
│ DANH SÁCH TIN …                             │
├─────────────────────────────────────────────┤
│ (không stack 11 tool cards trên body)       │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘

┌─ Công cụ P2P (drawer / sheet) ──────────────┐
│ Express & đơn hàng                          │
│  Express · Dashboard · Hướng dẫn            │
│  Lịch sử PT · Lịch sử khóa quỹ (×2 alias)   │
│  Thông báo P2P · Lịch sử đăng nhập          │
│  Tuân thủ tổng quan · Đóng góp bảo hiểm*    │
│  Phân tích tin (từ tin của tôi / deep)      │
│ * contribution-history = HUB; fund insurance │
│   page = GOM → Profile Pháp lý (không ở đây)│
└─────────────────────────────────────────────┘
```

---

## 2. Section order (top → bottom) — `P2PHomePage`

| # | Section | Widget / source | Current | Proposed |
|--:|---------|-----------------|---------|----------|
| 1 | Header | `VitTopChrome` / `VitHeader` | Title + create + my-orders | + overflow «Công cụ» |
| 2 | KYC / risk | Banner + `VitHighRiskStatePanel` | Có khi contract | Giữ |
| 3 | Quick hub | `quickHubKey` stats + Express CTAs | Express + vài action | Hero: **Express** + **Tạo tin**; bỏ tool clutter |
| 4 | Trade tabs | Mua / Bán (`VitSegmentedChoice`) | Có | Giữ |
| 5 | Asset / fiat rails | Chip rows | Có | Giữ |
| 6 | Search + filter | `VitInput` + filter sheet | Có | Giữ |
| 7 | Ad list | `p2p_home_offer_list` | Marketplace core | Giữ — primary scroll |
| 8 | Guide link + escrow micro | Footer links | Guide = HUB route | Guide cũng trong drawer |
| 9 | Bottom nav | App shell | Active **Trade** (D1) | Giữ |

Rhythm: hub secondary — ưu tiên `VitPageRhythm.standard` / compact khi thêm drawer; **không** biến body thành tile grid công cụ.

---

## 3. User paths ≤3 tap (VERIFY STEP-P0.7)

Giả định user đã ở shell (Home). Mỗi path **≤ 3 tap** tới màn đích.

### 3.1 Express

| Tap | UI | Route |
|----:|----|-------|
| 1 | Home › Sản phẩm Giao dịch › **P2P** | `/p2p` |
| 2 | Hub › **Express nhanh** (quick hub / CTA) | `/p2p/express` |
| 3 | (optional) Confirm amount | `/p2p/express/confirm` — ẨN flow |

**Alternate từ drawer:** `/p2p` → Công cụ → Express = vẫn ≤3 (mở drawer + tap Express).

### 3.2 Create offer (Tạo tin)

| Tap | UI | Route |
|----:|----|-------|
| 1 | Home › **P2P** | `/p2p` |
| 2 | Header **[+]** / CTA «Tạo tin» | `/p2p/create` (ẨN wizard — OK, không menu L1) |
| 3 | Bước form tiếp theo trong wizard | cùng flow |

### 3.3 My orders (Đơn của tôi)

| Tap | UI | Route |
|----:|----|-------|
| 1 | Home › **P2P** | `/p2p` |
| 2 | Header **[Đơn]** | `/p2p/my-orders` (ẨN list — entry ổn định từ hub chrome) |
| 3 | Tap một đơn | `/p2p/order/:orderId` (ẨN detail) |

**Không** yêu cầu đi qua Markets/Trade terminal trước khi vào P2P — entry canonical = Home › Giao dịch › P2P (file 17).

---

## 4. Cây menu đầy đủ — GIỮ + HUB + GOM (+ ẨN tóm tắt)

```text
P2P FAMILY (EP-17)
│
├─ [GIỮ] P2PHomePage → /p2p
│  │
│  ├─ MARKETPLACE (body)
│  │  ├─ Express CTA → /p2p/express [HUB]
│  │  ├─ Tạo tin → /p2p/create [ẨN]
│  │  ├─ Đơn của tôi → /p2p/my-orders [ẨN]  ← chrome ổn định
│  │  ├─ Tap tin → /p2p/ad/:adId [ẨN]
│  │  └─ Filters / search (local state)
│  │
│  └─ CÔNG CỤ P2P (drawer) — 11 HUB ──► §4.2
│
├─ [GOM] Bảo hiểm quỹ → Profile › Pháp lý ──► §4.3
│
└─ ẨN flows (contextual only) ──► §4.4
```

### 4.1 GIỮ (1)

| Path | Page class | EP | Menu |
|------|------------|-----|------|
| `/p2p` | `P2PHomePage` | EP-17 | Home › Sản phẩm Giao dịch › P2P |

### 4.2 HUB — đủ **11** dưới «Express & đơn hàng / Công cụ»

Nguồn: `08-p2p.md` cột «P2P hub → Express & đơn hàng».

| # | Path | Page class | UI label (vi-VN) | Entry |
|--:|------|------------|------------------|-------|
| 1 | `/p2p/express` | `P2PExpressPage` | Express nhanh | Hero CTA **và** drawer |
| 2 | `/p2p/dashboard` | `P2PDashboardPage` | Bảng điều khiển | Drawer |
| 3 | `/p2p/guide` | `P2PGuidePage` | Hướng dẫn P2P | Drawer (+ micro link footer) |
| 4 | `/p2p/compliance/overview` | `P2PComplianceOverviewPage` | Tuân thủ tổng quan | Drawer |
| 5 | `/p2p/insurance/contribution-history` | `P2PContributionHistoryPage` | Lịch sử đóng góp | Drawer (lịch sử — **không** = fund legal page) |
| 6 | `/p2p/payment-method/history` | `P2PPaymentMethodHistoryPage` | Lịch sử phương thức TT | Drawer |
| 7 | `/p2p/security/login-history` | `P2PLoginHistoryPage` | Lịch sử đăng nhập P2P | Drawer |
| 8 | `/p2p/settings/notifications` | `P2PNotificationsSettingsPage` | Thông báo P2P | Drawer |
| 9 | `/p2p/wallet/fund-lock-history` | `P2PFundLockHistoryPage` | Lịch sử khóa quỹ | Drawer |
| 10 | `/p2p/wallet/history` | `P2PFundLockHistoryPage` | Lịch sử ví P2P (alias) | Drawer — cùng page class |
| 11 | `/p2p/ad-analytics/:adId` | `P2PAdAnalyticsPage` | Phân tích tin | Từ **tin của tôi** / deep link — liệt kê trong drawer group «Từ tin» khi có `adId` |

**Đếm HUB = 11** — khớp `08-p2p.md`.

### 4.3 GOM — **2** → Profile › Pháp lý & báo cáo

| Path | Page class | Canonical menu |
|------|------------|----------------|
| `/p2p/insurance` | `P2PInsuranceFundPage` | Profile › Pháp lý (không drawer Công cụ) |
| `/p2p/insurance-fund` | `P2PInsuranceFundPage` | Alias cùng page — **GOM** |

Related ẨN insurance (certificate / score / policy / claim/:id) mở từ fund page hoặc order context — **không** menu L1.

### 4.4 ẨN — nhóm theo flow (không menu hub)

| Nhóm | Ví dụ path | Mở từ |
|------|------------|-------|
| Order lifecycle | `/p2p/order/:id`, timeline, proof, rate, cancel, chat | My orders / Express confirm |
| Dispute | `/p2p/dispute*`, `/p2p/disputes` | Order đang tranh chấp |
| Escrow | `/p2p/escrow/:orderId`, `/p2p/escrow/balance` | Order / wallet P2P |
| Ads seller | `/p2p/my-ads`, `/p2p/create`, ad detail/analytics | Header create / seller tools |
| Merchant | `/p2p/merchant/:id`, report, apply, trading-level, reviews | Ad row / profile merchant |
| Payment methods | add / list / verification / ownership / cooling | Settings P2P / create offer gate |
| KYC P2P | `/p2p/kyc/*` | Banner KYC / limit gate |
| Security P2P | center, 2fa, devices, anti-phishing, whitelist, suspicious | Security center ẨN; login-history = HUB |
| Wallet P2P | `/p2p/wallet`, transfer | Contextual; histories = HUB |
| Limits / AML / tax / fraud / blacklist / achievements / order-book / settings / e2e | các path còn lại trong `08-p2p.md` | Deep / gate / next-action |
| Settings security alias | `/settings/security/biometric`, `change-password` | P2P security bridge → Profile security family |

---

## 5. Current vs proposed

| Item | Current | Proposed |
|------|---------|----------|
| Hub model | Marketplace list + Express quick | **Giữ** marketplace; tools → **drawer** |
| 11 HUB | Routes tồn tại; entry rải / deep | Gom «Công cụ» + Express hero |
| Create / My orders | Header actions | **Giữ** chrome ≤3-tap |
| Insurance fund | GOM trong map; UI có thể lẫn tool | **Chỉ** Profile › Pháp lý |
| Contribution history | HUB | Ở drawer (lịch sử), tách khỏi fund GOM |
| Ad analytics | HUB parametrized | Không tile mồ côi; từ tin / deep |
| Active tab | Trade (D1) | **Giữ** — matrix file 18 |
| 65 ẨN | Đúng contextual | Không promote lên L1 |

---

## 6. Empty / loading / error rules

| State | Hub (`P2PHomePage`) | Express (`P2PExpressPage`) |
|-------|---------------------|----------------------------|
| **Loading** | Skeleton list + chrome | Skeleton form + hero |
| **Error** | `VitErrorState` + invalidate home provider; CTA «Thử lại» | Invalidate `p2pExpressProvider` |
| **Offline** | Banner offline + stale ads nếu còn cache (`offlineKey`) | Không submit Express; notice |
| **Empty ads** | `emptyKey` — «Chưa có tin phù hợp» + nới filter / đổi Mua-Bán | N/A |
| **Empty orders** | Trên `/p2p/my-orders` — empty + CTA Express / marketplace | — |
| **KYC gate** | Banner → KYC ẨN flow | Block confirm nếu thiếu KYC |
| **High-risk** | `VitHighRiskStatePanel` khi có contract | Preview/confirm trước Express confirm |
| **Success** | `showVitNoticeSheet` sau tạo tin / hoàn tất đơn | Sau confirm Express |
| **Dispute / escrow** | Không empty trên hub; vào từ order | — |

Financial safety: mọi thay đổi PTTT, giải phóng escrow, hủy đơn — **preview/confirm** trước khi commit (AGENTS.md).

---

## 7. File mapping (widget → section)

| File | Section / responsibility |
|------|--------------------------|
| `pages/hub/p2p_home_page.dart` | Hub composition, keys, shell clearance |
| `widgets/hub/p2p_home_page_state.dart` | Header actions, AsyncValue, offline/error |
| `widgets/hub/p2p_home_offer_list.dart` | Ad rows, empty, menus |
| `widgets/hub/p2p_home_page_common.dart` | Quick hub, rails, shared chips |
| `pages/hub/p2p_express_page.dart` | Express HUB |
| `widgets/hub/p2p_express_*` | Hero, form, merchant rows |
| `pages/.../p2p_dashboard_page.dart` (và siblings HUB) | Drawer targets |
| `pages/.../p2p_insurance_fund_page.dart` | GOM legal — Profile inbound |
| `app/providers/p2p_controller_providers.dart` | Snapshots / controllers |
| `app/router/route_groups/p2p_routes.dart` | Route table |
| **Proposed** | `p2p_tools_drawer.dart` / sheet — list 11 HUB |

---

## 8. Open decisions

1. **Drawer vs bottom sheet «Công cụ»:** đề xuất sheet (mobile-first) giống Earn legal sheet; drawer nếu cần persistent groups.  
2. **Ad analytics trong drawer:** ẩn khi user chưa có tin, hay luôn hiện + empty state trang đích? Đề xuất: nhóm «Từ tin của tôi» chỉ khi `my-ads` ≠ empty.  
3. **Hai alias fund-lock history** (`fund-lock-history` vs `wallet/history`): một row drawer hay hai? Đề xuất **hai rows** để khớp 11 HUB audit; copy phân biệt «Khóa quỹ» vs «Lịch sử ví P2P».  
4. **My orders / Create** phân loại ẨN nhưng chrome ổn định — có nâng lên HUB trong audit sau không? P0: **giữ ẨN** + header entry (đủ ≤3 tap).  
5. Copy Express production còn «Express Trade» English — sửa vi-VN khi chạm code (ngoài batch docs).

---

## 9. Gaps / reachability notes

| Gap | Severity | Note |
|-----|----------|------|
| Công cụ drawer UI missing | **P2** | 11 HUB thiếu inbound ổn định — STEP-P3.6 |
| Insurance GOM chưa gắn Profile Pháp lý UI | **P2** | Canonical file 17 GOM list |
| Express English residual | P3 | i18n when touch |
| HUB ad-analytics cần `adId` | OK | Không fake tile không context |
| D1 Trade trên `/p2p*` | OK by lock | File **18** |
| 65 ẨN không menu | OK | Contextual only |

---

## 10. Thống kê module P2P (từ `08-p2p.md`)

| Phân loại | Số |
|-----------|---:|
| GIỮ | 1 |
| **HUB** | **11** (đủ §4.2) |
| **GOM** | **2** (insurance + alias → Pháp lý) |
| ẨN | 65 |
| Tổng routes | 79 |

**Verify HUB in tree:** Express + Dashboard + Guide + Compliance overview + Contribution history + Payment history + Login history + Notifications + Fund-lock history + Wallet history + Ad analytics = **11**.

**Verify ≤3-tap:** Express · Tạo tin · Đơn của tôi — §3.

**Verify D1:** `/p2p/my-orders`, `/p2p/express`, … → bottom nav **Trade**.
