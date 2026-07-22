# Wireframe text — Wallet Hub (EP-04)

Generated: 2026-07-21  
Nguồn:
- [`07-wallet.md`](./07-wallet.md) — 3 GIỮ + 2 HUB + 16 ẨN (21 routes)
- Locked **D6** (playbook §1.2): promote **history**, **address-book**, **health-score** lên hub tools visible; phần còn lại → overflow
- [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md) — active tab **Wallet** cho mọi `/wallet*`
- [`Hub-Content-Contract.md`](./Hub-Content-Contract.md) — CTA ví = Nạp/Rút; ≤3 section above-fold
- Production: `flutter_app/lib/features/wallet/presentation/pages/hub/wallet_page.dart`
- Widgets: `wallet_page_sections.dart`, `wallet_page_balance_sections.dart`, fixtures `mock_wallet_repository_home_operations_fixtures.dart`
- Paths: `flutter_app/lib/app/router/route_groups/wallet_route_ids.dart`

Phạm vi: **Bottom Nav → Ví** (`/wallet`, `WalletPage`) + dual entry Nạp/Rút với Home (EP-08/09).  
Không thuộc D1 (D1 = Trade highlight cho secondary earn/p2p/…).

---

## 0. Quyết định khóa (D6) — không đàm phán trong wireframe này

| Entry | Path | IA class hôm nay (`07-wallet.md`) | Proposed hub UI | Ghi chú |
|-------|------|-----------------------------------|-----------------|---------|
| Lịch sử giao dịch | `/wallet/history` | **HUB** | **Visible** tile/chip «Lịch sử» | Hiện chôn trong overflow «Thêm thao tác» |
| Sổ địa chỉ | `/wallet/address-book` | **ẨN** | **Visible** tile «Sổ địa chỉ» | **Proposed class bump** ẨN → HUB (IA table chưa đổi) |
| Điểm sức khỏe ví | `/wallet/health-score` | **ẨN** | **Visible** tile «Sức khỏe ví» | **Proposed class bump** ẨN → HUB (IA table chưa đổi) |
| Còn lại (gas, multi-manager, token-approval, buy, transfer, dust, limits, network, pending, …) | xem §3.4 | ẨN / flow | **Overflow** sheet «Thêm» | Không promote lên strip chính |

> D6 chỉ khóa **3 promote visible**. Việc cập nhật cột «Phân loại» trong `07-wallet.md` cho address-book / health-score là follow-up P2 reconcile — wireframe này ghi **proposed class bump** rõ ràng.

---

## 1. ASCII wireframe @360×800

### 1.1 CURRENT (pre-D6 — superseded 2026-07-22 P2.7)

```
┌─────────────────────────────────────────────┐
│ Ví                                          │
│ Số dư minh bạch · bảo mật đa lớp            │
├─────────────────────────────────────────────┤
│ HERO — Tổng tài sản          [👁 ẩn/hiện]  │
│  PnL 24h …                                  │
│  [  Nạp tiền  ]  [  Rút tiền  ]  [⋯]       │  ← primary; ⋯ = Thêm thao tác
├─────────────────────────────────────────────┤
│ (optional) Nạp đang chờ — status card       │
├─────────────────────────────────────────────┤
│ TÀI SẢN                      [Phân tích ›]  │  → /wallet/portfolio-analytics
│ [🔍 Tìm…] [Ẩn số dư nhỏ]                    │
│ [Tài sản●] [Phân bổ]                        │
│ USDT … / BTC … / …                          │
│ (hint portfolio)                            │
├─────────────────────────────────────────────┤
│ CÔNG CỤ VÍ (grid — fixtures hiện tại)       │
│  [Nạp đang chờ] [Hạn mức rút]               │
│  [Dọn dust]     [Trạng thái mạng]           │  ← toàn ẨN trong IA
├─────────────────────────────────────────────┤
│ MUA ĐỊNH KỲ — card DCA (cross-module)       │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade] [Wallet●] [Profile]│
└─────────────────────────────────────────────┘
```

**Overflow «Thêm thao tác» hôm nay** (sau khi loại deposit/withdraw): Mua · Chuyển · **Lịch sử** — history HUB bị chôn.

### 1.2 PROPOSED = PRODUCTION (D6 — STEP-P2.7 done)

```
┌─────────────────────────────────────────────┐
│ Ví                                          │
│ Số dư minh bạch · bảo mật đa lớp            │
├─────────────────────────────────────────────┤
│ HERO — Tổng tài sản          [👁]           │
│  [  Nạp tiền  ]  [  Rút tiền  ]             │  ← EP-08 / EP-09 (giữ dual Home)
├─────────────────────────────────────────────┤
│ (optional) Nạp đang chờ                     │
├─────────────────────────────────────────────┤
│ TÀI SẢN                      [Phân tích ›]  │  HUB portfolioAnalytics
│ [Tài sản●] [Phân bổ] + search/filter        │
│ Asset list …                                │
├─────────────────────────────────────────────┤
│ CÔNG CỤ VÍ (visible ≤4 — D6)                │
│  [Lịch sử] [Sổ địa chỉ] [Sức khỏe ví] [⋯]  │
│   HUB↑      bump→HUB       bump→HUB   overflow│
├─────────────────────────────────────────────┤
│ MUA ĐỊNH KỲ — card DCA (giữ / thu gọn)      │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade] [Wallet●] [Profile]│
└─────────────────────────────────────────────┘
```

**Overflow «Thêm» (proposed):** Mua crypto · Chuyển nội bộ · Nạp đang chờ · Hạn mức rút · Dọn dust · Trạng thái mạng · Tối ưu gas · Multi-manager · Token approval · (các ẨN khác).

---

## 2. Section order (top → bottom)

Nguồn production: `WalletPage` `data:` branch trong `wallet_page.dart`.

| # | Section | Widget / source | Ghi chú |
|--:|---------|-----------------|---------|
| 0 | Header chrome | `VitTopChrome` rootModule | Title «Ví»; subtitle minh bạch |
| 1 | Unavailable banner (cond.) | `WalletUnavailableBanner` | Khi `WalletScreenState.error` trong snapshot |
| 2 | Balance hero | `WalletBalanceHero` | Tổng + 24h + Nạp/Rút + `onShowMore` |
| 3 | Pending deposits (cond.) | `WalletPendingDepositStatusCard` | Chỉ khi `pendingCount > 0` |
| 4 | Tài sản | `VitPageSection` + search/tabs/list/allocation | Action «Phân tích» → portfolio analytics |
| 5 | Công cụ ví | `WalletToolGrid` | **D6:** đổi dataset visible tools |
| 6 | Mua định kỳ | `WalletDcaCard` | Cross-link DCA; không phải wallet GIỮ |
| 7 | Bottom nav | App shell | Active = **Wallet** |

Rhythm: `VitPageRhythm.compact` (tab root).  
Hub-Content-Contract: hero Nạp/Rút + Tài sản + Công cụ = 3 major above-fold; DCA dưới fold OK.

---

## 3. Cây menu đầy đủ — GIỮ + HUB (+ ẨN / proposed bump)

```text
WALLET (/wallet) [EP-04] — GIỮ — WalletPage
│
├─ Hero CTA (dual entry với Home)
│  ├─ Nạp tiền → /wallet/deposit [GIỮ] DepositPage [EP-08]
│  │    └─ /wallet/deposit/:asset [ẨN] DepositPage (chọn asset)
│  │    └─ /wallet/pending-deposits [ẨN] PendingDepositsPage
│  └─ Rút tiền → /wallet/withdraw [GIỮ] WithdrawPage [EP-09]
│       └─ /wallet/withdraw/:asset [ẨN] WithdrawPage
│       └─ /wallet/limits [ẨN] WithdrawLimitsPage
│
├─ Tài sản
│  ├─ /wallet/asset/:assetId [ẨN] AssetDetailPage
│  ├─ /wallet/transaction/:txId [ẨN] TransactionDetailPage
│  └─ Phân tích → /wallet/portfolio-analytics [HUB] PortfolioAnalyticsPage
│
├─ Công cụ ví — VISIBLE (D6 LOCKED)
│  ├─ Lịch sử → /wallet/history [HUB] TransactionHistoryPage
│  ├─ Sổ địa chỉ → /wallet/address-book [ẨN→proposed HUB] AddressBookPage
│  │    └─ Thêm địa chỉ → /wallet/address-book/add [ẨN] AddressAddPage
│  └─ Sức khỏe ví → /wallet/health-score [ẨN→proposed HUB] WalletHealthScorePage
│
├─ Công cụ ví — OVERFLOW (không promote)
│  ├─ Mua → /wallet/buy-crypto [ẨN] BuyCryptoPage
│  ├─ Chuyển → /wallet/transfer [ẨN] TransferPage
│  ├─ Nạp đang chờ → /wallet/pending-deposits [ẨN]
│  ├─ Hạn mức rút → /wallet/limits [ẨN]
│  ├─ Dọn dust → /wallet/dust-converter [ẨN] DustConverterPage
│  ├─ Trạng thái mạng → /wallet/network-status [ẨN] NetworkStatusPage
│  ├─ Tối ưu gas → /wallet/gas-optimizer [ẨN] WalletGasOptimizerPage
│  ├─ Multi-manager → /wallet/multi-manager [ẨN] WalletMultiManagerPage
│  └─ Token approval → /wallet/token-approval [ẨN] WalletTokenApprovalPage
│
└─ Cross-module (không đếm wallet GIỮ)
   └─ DCA card → /dca (Home/Trade family)
```

### 3.1 GIỮ (3)

| Path | Page class | EP | Phân loại | Menu UI đề xuất |
|------|------------|-----|-----------|-----------------|
| `/wallet` | `WalletPage` | EP-04 | **GIỮ** | Bottom Nav → Wallet |
| `/wallet/deposit` | `DepositPage` | EP-08 | **GIỮ** | Home Hero + Wallet Hero «Nạp» |
| `/wallet/withdraw` | `WithdrawPage` | EP-09 | **GIỮ** | Home Next/Hero + Wallet Hero «Rút» |

### 3.2 HUB (2 hôm nay + 2 proposed bump)

| Path | Page class | Phân loại | Menu |
|------|------------|-----------|------|
| `/wallet/history` | `TransactionHistoryPage` | **HUB** | Wallet › Công cụ ví «Lịch sử» (D6 promote visible) |
| `/wallet/portfolio-analytics` | `PortfolioAnalyticsPage` | **HUB** | Wallet › Tài sản header «Phân tích» |
| `/wallet/address-book` | `AddressBookPage` | **ẨN** → **proposed HUB** | Wallet › Công cụ ví «Sổ địa chỉ» |
| `/wallet/health-score` | `WalletHealthScorePage` | **ẨN** → **proposed HUB** | Wallet › Công cụ ví «Sức khỏe ví» |

### 3.3 Dual entry EP-08 / EP-09

| Flow | Home | Wallet | Active tab khi vào flow |
|------|------|--------|-------------------------|
| Nạp | Hero CTA | Hero CTA | **Wallet** (`/wallet/deposit*`) |
| Rút | Hero / Next action | Hero CTA | **Wallet** (`/wallet/withdraw*`) |

Cả hai entry **giữ** — không gỡ Home; Wallet là canonical hub cho tài sản + tools.

### 3.4 ẨN còn lại (overflow / deep link — không menu chính)

Deposit/:asset, Withdraw/:asset, AssetDetail, TransactionDetail, AddressAdd, BuyCrypto, DustConverter, GasOptimizer, Limits, MultiManager, NetworkStatus, PendingDeposits, TokenApproval, Transfer — **reachability qua overflow hoặc in-flow**, không strip D6.

---

## 4. Current vs proposed

| Item | Current | Proposed (locked D6) |
|------|---------|----------------------|
| History inbound | Overflow «Thêm thao tác» only | **Visible** tool «Lịch sử» |
| Address book | Không có trên hub (ẨN) | **Visible** tool; **proposed class bump** → HUB |
| Health score | Không có trên hub (ẨN) | **Visible** tool; **proposed class bump** → HUB |
| Tool grid fixtures | pending / limits / dust / network (ẨN) | Đẩy sang overflow; strip = 3 D6 (+ overflow tile) |
| Portfolio analytics | Section action «Phân tích» | **Giữ** (đã HUB inbound) |
| Nạp / Rút | Hero primary | **Giữ**; dual Home+Wallet |
| Buy / Transfer | Overflow | **Giữ** overflow (không D6) |
| Gas / multi / approval | Không trên hub | Overflow only |
| Active tab | Wallet cho `/wallet*` | Không đổi |
| Hub model | Balance-first + tools | **Giữ** balance-first; chỉ đổi tool visibility |

---

## 5. Empty / loading / error rules

| State | UI hiện tại | Rule |
|-------|-------------|------|
| **Loading** | `VitSkeletonList` trong `walletSnapshotProvider.when(loading:)` | Full-page skeleton trước snapshot |
| **Error** | `VitErrorState` — «Không tải được dữ liệu ví» + «Thử lại» | `ref.invalidate(walletSnapshotProvider)` |
| **Unavailable soft** | `WalletUnavailableBanner` khi screen state error trong data | Không thay error full-page nếu snapshot vẫn có |
| **Empty assets** | List rỗng sau filter | Empty copy trong list + CTA bỏ filter / nạp |
| **Pending = 0** | Ẩn `WalletPendingDepositStatusCard` | Giữ |
| **Offline** | Theo app banner chuẩn | Không SnackBar toast cho lỗi ví |
| **Overflow empty** | `_showMoreActions` return sớm nếu không còn action | Giữ |

### 5.1 Financial preview notes (AGENTS.md)

| Flow | Preview / confirm bắt buộc | UI note |
|------|----------------------------|---------|
| **Rút** (`WithdrawPage`) | Preview phí, mạng, hạn mức, địa chỉ đã mask; confirm trước submit | Success/error → `showVitNoticeSheet`; không StickyFooter post-success |
| **Nạp** (`DepositPage`) | Mạng + địa chỉ + memo/tag; cảnh báo sai mạng | Pending deposits card trên hub khi có |
| **Thêm địa chỉ** (`AddressAddPage`) | Preview địa chỉ + mạng + nhãn; confirm trước lưu | Mask khi list lại trong address book |
| **Chuyển / Buy** (overflow) | Cùng chuẩn preview khi chạm flow | Không nâng lên visible D6 |

---

## 6. File mapping (widget → section)

| File | Section / responsibility |
|------|--------------------------|
| `pages/hub/wallet_page.dart` | Shell, `when()` gate, section composition, overflow sheet |
| `widgets/hub/wallet_page_balance_sections.dart` | `WalletBalanceHero`, CTA Nạp/Rút |
| `widgets/hub/wallet_page_sections.dart` | Search/filter, tabs, asset list, allocation, tool grid, DCA, pending |
| `widgets/hub/wallet_unavailable_banner.dart` | Soft unavailable |
| `data/fixtures/mock_wallet_repository_home_operations_fixtures.dart` | `_walletTools`, `_walletActions` (dataset D6 sẽ đổi) |
| `app/providers/wallet_controller_providers.dart` | `walletSnapshotProvider`, pending deposits |
| `app/router/route_groups/wallet_route_ids.dart` | Path constants |

**Proposed chrome change (Phase 2 / STEP-P2.7):** cập nhật `_walletTools` (hoặc mapping UI) → history + address-book + health-score; move ops tools vào overflow actions.

---

## 7. Open decisions

1. **Tile thứ 4 visible:** chỉ «⋯ Thêm» hay thêm «Phân tích» vào grid (hiện đã có section action)? Đề xuất mặc định: **⋯ only** — tránh trùng inbound portfolio.  
2. **IA table bump:** cập nhật `07-wallet.md` address-book + health-score từ ẨN → HUB trong cùng PR P2 hay PR docs riêng?  
3. **DCA card trên Wallet:** giữ cross-sell hay chuyển Home › Sinh lời only? (ngoài D6; mặc định **giữ** đến khi audit density).  
4. Label health: «Sức khỏe ví» vs «Điểm sức khỏe» — chọn một trước Visual QA.

---

## 8. Gaps / reachability notes

| Gap | Severity | Note |
|-----|----------|------|
| `walletHistory` buried in overflow | **P2 / D6** | STEP-P2.7 — promote visible |
| `address-book` / `health-score` no hub inbound | **P2 / D6** | Promote + proposed class bump |
| Tool grid trỏ ẨN ops | P2 reconcile | Đẩy overflow; align IA |
| Soft English residual trên một số wallet tool pages | i18n | Ngoài scope wireframe; vi-VN khi chạm file |
| Active tab | OK | Mọi `/wallet*` → **Wallet** (shell 18) |

**D6 promote list (locked):**

1. `walletHistory` → `/wallet/history` · `TransactionHistoryPage`  
2. `walletAddressBook` → `/wallet/address-book` · `AddressBookPage` (**proposed HUB**)  
3. `walletHealthScore` → `/wallet/health-score` · `WalletHealthScorePage` (**proposed HUB**)

---

## 9. Thống kê shell Wallet (menu-relevant)

| Phân loại | Số trong `07-wallet.md` | Sau D6 UI (không đổi file 07 trừ bump) |
|-----------|------------------------:|----------------------------------------|
| GIỮ | 3 | 3 |
| HUB (IA hôm nay) | 2 | 2 + **2 proposed bump** (address-book, health-score) |
| GOM | 0 | 0 |
| ẨN | 16 | 14 nếu bump 2 route; còn lại overflow |
| Visible hub tools (D6) | — | **3** (+ overflow) |

**Active tab reminder:** mọi path `/wallet…` highlight **Wallet**. Deposit/Withdraw từ Home vẫn Wallet khi đã `go` vào flow.
