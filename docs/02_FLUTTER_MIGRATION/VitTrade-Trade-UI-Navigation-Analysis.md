# VitTrade — Phân tích UI Trang Giao dịch và Liên kết Điều hướng

**Ngày:** 2026-07-01  
**Phạm vi:** Module `trade` (SC-048 hub), trang adjacent (Markets, Home, DCA, P2P, Profile, Portfolio), và bản đồ inbound/outbound.  
**Artifact liên quan:** [`VitTrade-Trade-Navigation-Edges.csv`](VitTrade-Trade-Navigation-Edges.csv)

---

## 1. Trang giao dịch chính

| Thuộc tính | Giá trị |
| --- | --- |
| Route mặc định | `/trade` |
| Screen ID | SC-048 (`TradePage`) |
| Biến thể cặp | `/trade/:pairId` — SC-049, cùng widget, `chartVariant: pairRoute` |
| Bottom nav | Tab **Giao dịch** → `VitBottomNavDestination.trade` |
| Query params | `?side=buy\|sell` (từ Pair Detail) |
| File | `flutter_app/lib/features/trade/presentation/pages/trade_page.dart` |
| Router | `flutter_app/lib/app/router/route_groups/trade_routes.dart` |

---

## 2. Cấu trúc UI TradePage (SC-048)

Layout: `VitTradeTerminalLayout` (`vit_trade_terminal_layout.dart`) — terminal kiểu Bybit.

### 2.1 Chrome (header → footer)

| Vùng | Widget | Hành vi |
| --- | --- | --- |
| Header | `VitTradeTerminalHeader` | Logo cặp, symbol; Back khi pair route; tap symbol → `/trade/{pairId}` |
| Ticker | `VitTradeTickerStrip` | Giá, % 24h, High/Low, Volume |
| Product tabs | `VitTradeProductTabs` | Spot / Futures / Margin / Convert + sheet **Thêm sản phẩm** |
| View mode | `VitTradeViewModeToggle` | **Charts** vs **Trade** |
| Portfolio dock | `VitTradePortfolioPanel` | Tab Vị thế / Lệnh mở / Lịch sử |
| High-risk | `VitHighRiskStatePanel` | Conditional khi `highRiskContractId != null` |

### 2.2 Body — hai chế độ

**Charts (`VitTradeViewMode.charts`):**
- `VitTradeChartPanel`
- Sub-tab **Sổ lệnh** (`VitOrderBookPanel`) / **Giao dịch** (`VitTradesTapePanel`)
- Form đặt lệnh phía dưới

**Trade (`VitTradeViewMode.trade`):**
- `VitTradeSplitPanel` — form + order book song song (compact)

### 2.3 Form đặt lệnh

| Thành phần | Primitive |
| --- | --- |
| MUA/BÁN | `VitSegmentedChoice` |
| Loại lệnh | Limit / Market / Stop-limit |
| Giá / Khối lượng | `VitInput` + tabular figures |
| Preset % | `VitPresetChipRow.percentBalance` |
| TP/SL | Switch trong `VitCard` inner |
| Preview | `VitFinancialSafetySummary` |
| Submit | `VitCtaButton` → `/trade/order-receipt` |

### 2.4 Product hub (điều hướng từ TradePage)

**Tab chính:** Spot → `/trade/{pairId}` · Convert → `/trade/convert` · Futures → `/trade/{pairId}/futures` · Margin → `/trade/margin`

**Overflow (11):** Bot, Copy, DCA, Wallet, P2P, Earn, Launchpad, Dự đoán, Arena, Rewards, Hỗ trợ

Nguồn: `trade_page_part_01.dart` — `_tradeHubItems()`.

---

## 3. Module Trade — ~95 route `/trade/*`

| Nhóm | Hub route | Số route (approx) | Ghi chú |
| --- | --- | ---: | --- |
| Spot / terminal | `/trade`, `/trade/:pairId` | 9 | order-receipt, orders-history, settings, export, convert, advanced-chart, positions |
| Futures | `/trade/:pairId/futures` | 2 | + leverage |
| Margin | `/trade/margin` | 7 | hub, analytics, demo |
| Trading bots | `/trade/bots` | 18 | compliance + analytics subtree |
| Copy trading | `/trade/copy-trading` | ~40 | provider flow + MiFID regulatory |
| Demo / risk | `/trade/risk-management` | 4 | execution-quality, advanced-tools, trader profile |

Chi tiết route → page: xem `trade_routes.dart` và CSV artifact.

---

## 4. Module adjacent — liên kết với Trade

### 4.1 Markets (inbound mạnh)

| Nguồn | Đích | Trigger |
| --- | --- | --- |
| Watchlist | `/trade/{pairId}` | Nút Trade trên từng cặp |
| Pair Detail | `/trade/{pairId}?side=buy\|sell` | CTA MUA/BÁN |
| Pair Detail | `/trade/advanced-chart/{pairId}` | Advanced chart |
| Market depth | accepts `/trade` as `returnTo` | Back navigation |

### 4.2 Home (inbound)

Quick actions trong `home_mock_data.dart`:

| Label | Route |
| --- | --- |
| Mua nhanh | `/trade/btcusdt` |
| Convert | `/trade/convert` |
| Margin | `/trade/margin` |
| Bot | `/trade/bots` |
| Copy Trade | `/trade/copy-trading` |
| Recent BTC/USDT | `/trade/btcusdt` |

### 4.3 Profile & Portfolio

| Nguồn | Đích |
| --- | --- |
| Profile shortcut Bot | `/trade/bots` |
| Profile shortcut Copy | `/trade/copy-trading` |
| Menu Lịch sử lệnh | `/trade/orders-history` |
| VIP CTA | `/trade/btcusdt` |
| Unified Portfolio card | `/trade` |

### 4.4 Notifications & DCA

| Nguồn | Đích | Hướng |
| --- | --- | --- |
| Trade notification | `/trade/orders-history` | Inbound |
| DCA back fallback | `/trade` | Inbound (khi không có history) |
| Trade overflow DCA | `/dca` | Outbound |

### 4.5 Predictions & Arena

| Module | Inbound → Trade | Outbound ← Trade |
| --- | --- | --- |
| Predictions | **Không** (UI) | `/markets/predictions` từ overflow |
| Arena | **Không** (UI; chỉ fixture flow map) | `/arena` từ overflow |

Đúng ranh giới AGENTS.md: Predictions (wallet/PnL) và Arena (points-only) tách biệt khỏi spot terminal.

---

## 5. DCA — chi tiết liên kết (13 route)

Module: `features/dca/` · Bottom nav highlight tab **Giao dịch** (cùng `/dca/*`).

| Route | Page | Liên kết Trade |
| --- | --- | --- |
| `/dca` | `DCAPage` (SC-169) | Back fallback → `/trade`; inbound từ Trade overflow |
| `/dca/portfolio-optimizer` | `DCAPortfolioOptimizer` | Nội bộ DCA |
| `/dca/dynamic-amount` | `DCADynamicAmount` | Nội bộ DCA |
| `/dca/backtester` | `DCABacktesterPage` | Nội bộ DCA |
| `/dca/multi-asset` | `DCAMultiAssetPage` | Nội bộ DCA |
| `/dca/performance-compare` | `DCAPerformanceComparePage` | Nội bộ DCA |
| `/dca/smart-rules` | `DCASmartRulesPage` | Nội bộ DCA |
| `/dca/rebalance/config` | `DCARebalanceConfig` | Nội bộ DCA |
| `/dca/rebalance/config001` | `DCARebalanceDashboard` | Nội bộ DCA |
| `/dca/rebalance/:configId/edit` | `DCARebalanceConfig` | Nội bộ DCA |
| `/dca/rebalance/:configId/history` | `DCARebalanceDashboard` | Nội bộ DCA |
| `/dca/schedule/config` | `DCAScheduleConfig` | Nội bộ DCA |
| `/dca/schedule/config001` | `DCAScheduleAnalytics` | Nội bộ DCA |

**UI DCA hub (SC-169):** overview card, tab Kế hoạch/Lịch sử, advanced tools grid (portfolio optimizer, backtester, smart rules, …). Không có link trực tiếp từ DCA sub-pages về spot terminal ngoài back fallback trên hub.

---

## 6. P2P — chi tiết liên kết (~70 route)

Module: `features/p2p/` · Bottom nav highlight tab **Giao dịch** (cùng `/p2p/*`).

**Không có inbound UI từ P2P → `/trade`** (grep toàn module p2p: zero `AppRoutePaths.trade`).

**Outbound từ Trade:** overflow tile P2P → `/p2p` (`P2PHomePage`).

### Luồng P2P core (liên quan giao dịch fiat/crypto)

| Route | Page | Vai trò |
| --- | --- | --- |
| `/p2p` | `P2PHomePage` | Hub P2P |
| `/p2p/express` | `P2PExpressPage` | Mua/bán nhanh |
| `/p2p/express/confirm` | `P2PExpressConfirmPage` | Xác nhận express |
| `/p2p/order/:orderId` | `P2POrderPage` | Chi tiết lệnh P2P |
| `/p2p/order/timeline/:orderId` | `P2POrderTimelinePage` | Timeline |
| `/p2p/order/rate/:orderId` | `P2POrderRatePage` | Đánh giá |
| `/p2p/order/cancel/:orderId` | `P2POrderCancelPage` | Hủy |
| `/p2p/order/proof/:orderId` | `P2POrderProofPage` | Chứng từ thanh toán |
| `/p2p/my-orders` | `P2PMyOrdersPage` | Lịch sử |
| `/p2p/order-book` | `P2POrderBookPage` | Sổ quảng cáo |
| `/p2p/chat/:orderId` | `P2PChatPage` | Chat escrow |
| `/p2p/escrow/:orderId` | `P2PEscrowDetailPage` | Escrow |
| `/p2p/dispute/:orderId` | `P2PDisputePage` | Tranh chấp |
| `/p2p/ad/:adId` | `P2PAdDetailPage` | Chi tiết quảng cáo |
| `/p2p/create` | `P2PCreateAdPage` | Tạo quảng cáo |

P2P là sản phẩm escrow fiat riêng; liên kết với Trade chỉ qua product hub overflow và shared bottom-nav tab highlight.

---

## 7. Bottom nav highlight

Tab **Giao dịch** active khi path thuộc:

- `/trade/*`
- `/dca/*`, `/p2p/*`, `/earn/*`, `/launchpad/*`, `/arena/*`

Tab **Thị trường** active: `/markets/*`, `/pair/*`.

Nguồn: `visual_qa_route_metadata.dart`, `app_router_test.dart`.

---

## 8. Visual QA SC-048 (360px)

| Viewport | View mode | Kết quả | Evidence |
| --- | --- | --- | --- |
| 360×800 | Charts (default) | Pass | `trade_page_test.dart` — buy side actionable in first viewport |
| 360×800 | Trade (split) | Pass | `trade_page_test.dart` — split panel + order book visible |

Test command: `flutter test test/features/trade/trade_page_test.dart --reporter=compact`

---

## 9. Kết luận phạm vi (confirm-scope)

Phân tích **đã bao gồm** P2P và DCA ở mức route + liên kết hub (không liệt kê từng sub-screen P2P compliance/KYC vì ngoài luồng spot terminal). Module trade nội bộ (~100 navigation edges) được trích trong CSV artifact.

| Metric | Giá trị |
| --- | ---: |
| Route `/trade/*` | ~95 |
| Inbound sources (UI) | 8 module (shell, home, markets, profile, portfolio, notifications, dca, onboarding) |
| Không inbound UI | predictions, arena, p2p |
| Navigation API | `context.go` / `context.push` (GoRouter) |
