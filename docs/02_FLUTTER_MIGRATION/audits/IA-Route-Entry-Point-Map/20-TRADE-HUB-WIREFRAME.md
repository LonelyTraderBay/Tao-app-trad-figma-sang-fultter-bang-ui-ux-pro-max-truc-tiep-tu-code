# Wireframe text — Trade Hub / Spot Terminal (EP-03)

Generated: 2026-07-21  
Nguồn:
- [`04-trade.md`](./04-trade.md) — 7 GIỮ + 16 HUB + 8 GOM (module trade)
- [`05-trade-compliance.md`](./05-trade-compliance.md) — ~29 GOM (+1 ẨN) → **Profile › Pháp lý** canonical
- Locked **D5** (playbook §1.2): `/trade` = Spot **terminal-first**; Orders/Positions = **header actions** — **không** đề xuất Orders/Positions làm primary hub tabs thay terminal
- D1 (shell): secondary products (earn/p2p/arena/dca/launchpad/…) highlight **Trade** tab — chi tiết path matrix ở [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md)
- Production: `flutter_app/lib/features/trade/presentation/pages/hub/trade_page.dart` + `trade_page_state.dart`
- Product switcher: `flutter_app/lib/features/trade_core/presentation/widgets/trade_product_navigation.dart`
- Shell: `vit_trade_simple_shell.dart` → `VitTradeHubScaffold`
- Paths: `trade_route_ids.dart` — EP-26 = `/trade/orders-history`, EP-27 = `/trade/positions`

Phạm vi: **Bottom Nav → Giao dịch** + cây GIỮ/HUB/GOM thuộc trade family; compliance GOM gom Profile.

---

## 0. Quyết định khóa (D5) — không đàm phán trong wireframe này

| Layer | Role | Cấm |
|-------|------|-----|
| Primary body | Spot terminal (hero + form Mua/Bán + risk + snippet) | Thay body bằng tab «Lệnh / Vị thế» như hub |
| Product switcher | Spot / Futures / Margin / Convert / Bot | Đưa Orders/Positions vào hàng product tabs |
| Secondary chrome | **Header** «Lệnh» (EP-26) + «Vị thế» (EP-27) | Chỉ deep link / next-action (current) mà không có chrome ổn định |

---

## 1. ASCII wireframe @360×800

### 1.1 CURRENT (production — terminal-first, Orders/Positions yếu chrome)

```
┌─────────────────────────────────────────────┐
│ BTC/USDT                         [?]        │  ← Title = pair; headerActions = []
│ Giao dịch Spot                              │
│ [Spot●][Futures][Margin][Convert][Bot]      │  ← Product tabs (buildTradeProductNavigation)
├─────────────────────────────────────────────┤
│ HERO — giá / % / spark / H-L-V / số dư      │
├─────────────────────────────────────────────┤
│ [  MUA  ]  [  BÁN  ]                        │  ← VitSegmentedChoice
│ Số lượng …   [% presets]                    │
│ [ Xác nhận lệnh ]                           │
├─────────────────────────────────────────────┤
│ Đánh giá rủi ro (high-risk panel)           │
├─────────────────────────────────────────────┤
│ Tiếp theo — NextActionCard                  │
│  (có thể → orders-history / positions)      │
├─────────────────────────────────────────────┤
│ Tài sản của bạn              [Xem tất cả ›] │  ← chỉ khi có positions
│  (≤3 rows) / empty «Chưa có tài sản Spot»   │
├─────────────────────────────────────────────┤
│ Disclaimer rủi ro (micro)                   │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

**Inbound Orders/Positions hôm nay:** NextAction «Xem lệnh» / «Xem» + section «Xem tất cả» → `push` — **không** có header action ổn định.

### 1.2 PROPOSED (D5 — header Lệnh / Vị thế; terminal giữ nguyên)

```
┌─────────────────────────────────────────────┐
│ BTC/USDT ▾              [Lệnh] [Vị thế]     │  ← EP-26 / EP-27 header
│ Giao dịch Spot                              │
│ [Spot●][Futures][Margin][Convert][Bot]      │
├─────────────────────────────────────────────┤
│ HERO — giá / % / spark / số dư              │
├─────────────────────────────────────────────┤
│ [  MUA  ]  [  BÁN  ]                        │
│ Form số lượng + preview phí/trượt           │
│ [ Xác nhận lệnh ]                           │
├─────────────────────────────────────────────┤
│ Đánh giá rủi ro                             │
│ Tiếp theo (contextual)                      │
│ Tài sản của bạn → /trade/positions          │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

Công cụ Spot phụ (HUB): Advanced chart, Export — từ overflow / menu terminal (không thay tabs).

---

## 2. Section order (top → bottom) — Spot terminal

| # | Section | Widget / source | Ghi chú |
|--:|---------|-----------------|---------|
| 1 | Header | `VitTradeHubScaffold` / `VitTradeSimpleShell` | Title pair; **proposed:** Lệnh + Vị thế |
| 2 | Product switcher | `buildTradeProductNavigation` | Spot · Futures · Margin · Convert · Bot |
| 3 | Pair hero | `VitTradeSimpleHero` | Giá, %, spark, H/L/V, số dư khả dụng |
| 4 | Order form | `VitTradeSimpleOrderForm` | Mua/Bán, amount, % presets, confirm sheet |
| 5 | Risk panel | `VitHighRiskStatePanel` | Khi có `highRiskContractId` |
| 6 | Next action | `VitNextActionCard` | Contextual → orders / positions / onboarding |
| 7 | Positions snippet | `_SimplePositionsList` | Max 3; CTA «Xem tất cả» |
| 8 | Disclaimer | Text micro in shell | Rủi ro crypto |
| 9 | Bottom nav | App shell | Active = **Trade** |

Rhythm terminal: flush / trade shell (không dùng page rhythm compact Home).

---

## 3. Product switcher map

Nguồn: `_tradeHubItems` + `primaryIds` trong `trade_product_navigation.dart`.  
**STEP-P2.5 (2026-07-22):** nhãn L1 = vi-VN; chip **Rủi ro cao** trên Margin + Bot.

| Tab id | Label UI | Risk badge | Target | Phân loại đích |
|--------|----------|------------|--------|----------------|
| `spot` | Giao ngay | — | `/trade/:pairId` (default pair) | GIỮ terminal / ẨN pair deep link |
| `futures` | Phái sinh | — | `/trade/:pairId/futures` | ẨN flow |
| `margin` | Ký quỹ | **Rủi ro cao** | `/trade/margin` | **GIỮ** `MarginTradingPage` |
| `convert` | Chuyển đổi | — | `/trade/convert` | **GIỮ** `ConvertPage` |
| `bots` | Bot | **Rủi ro cao** | `/trade/bots` | **GIỮ** `TradingBotsPage` |

Thứ tự tabs (`primaryIds`): **spot → futures → margin → convert → bots**.  
Copy Trading **không** nằm trong switcher L1 (Home › Pro / Copy hub riêng). Overflow hiện không thêm Copy/Wallet (comment ARCH-A2).

---

## 4. Cây menu đầy đủ — GIỮ + HUB + GOM (Trade shell)

```text
TRADE TERMINAL (/trade) [EP-03] — GIỮ — TradePage
│
├─ Header (PROPOSED D5)
│  ├─ Lệnh → /trade/orders-history [GIỮ] OrdersHistoryPage [EP-26]
│  └─ Vị thế → /trade/positions [GIỮ] PositionDashboardPage [EP-27]
│
├─ Product switcher
│  ├─ Spot → /trade | /trade/:pairId
│  ├─ Futures → /trade/:pairId/futures [ẨN]
│  ├─ Margin → /trade/margin [GIỮ] ──► Margin hub
│  ├─ Convert → /trade/convert [GIỮ]
│  └─ Bot → /trade/bots [GIỮ] ──► Bots hub
│
├─ Spot tools (HUB)
│  ├─ Advanced chart → /trade/advanced-chart/:pairId [HUB] AdvancedChartPage
│  └─ Export lịch sử → /trade/export [HUB] TradeHistoryExportPage
│
├─ [Home Pro] Copy → /trade/copy-trading [GIỮ] ──► Copy hub
│
├─ GOM Bot (module 04) → Profile › Pháp lý (canonical menu)
│  ├─ BotApiDocumentationPage
│  ├─ BotEmergencyStopPage
│  ├─ BotRiskDashboardPage
│  ├─ BotRiskDisclosurePage
│  ├─ BotSuitabilityAssessmentPage
│  └─ BotTermsOfServicePage
│
├─ GOM Copy (module 04, hub-local exception)
│  ├─ CopyAuditLogPage → /trade/copy-audit-log/:copyId [GOM] Copy hub › Tuân thủ
│  └─ ProviderGovernancePage → tradeCopyProviderGovernance [GOM] Copy hub › Tuân thủ
│
└─ GOM Compliance pack (05-trade-compliance, ~29) → Profile › Pháp lý
   └─ (xem §4.4 — không liệt kê lại trên Trade chrome)
```

### 4.1 GIỮ (7) — từ `04-trade.md`

| Path | Page class | EP | Phân loại | Menu UI đề xuất |
|------|------------|-----|-----------|-----------------|
| `/trade` | `TradePage` | EP-03 | **GIỮ** | Bottom Nav → Trade (terminal) |
| `/trade/convert` | `ConvertPage` | EP-12 | **GIỮ** | Product tab + Home › Giao dịch |
| `/trade/margin` | `MarginTradingPage` | EP-11 | **GIỮ** | Product tab + Home › Giao dịch |
| `/trade/bots` | `TradingBotsPage` | EP-14 | **GIỮ** | Product tab + Home › Pro |
| `/trade/copy-trading` | `CopyTradingPage` | EP-13 | **GIỮ** | Home › Pro (Copy) — không L1 switcher |
| `/trade/orders-history` | `OrdersHistoryPage` | EP-26 | **GIỮ** | Trade header «Lệnh» (D5) |
| `/trade/positions` | `PositionDashboardPage` | EP-27 | **GIỮ** | Trade header «Vị thế» (D5) |

> INDEX EP label có thể ghi `/trade/orders`; path production = **`/trade/orders-history`**.

### 4.2 HUB — Spot tools (2)

| Path | Page class | Phân loại | Menu |
|------|------------|-----------|------|
| `/trade/advanced-chart/:pairId` | `AdvancedChartPage` | HUB | Trade › Công cụ Spot |
| `/trade/export` | `TradeHistoryExportPage` | HUB | Trade › Công cụ Spot |

### 4.3 HUB — Margin hub (2)

```text
Margin (/trade/margin) [GIỮ]
├─ /trade/margin/hub → MarginTradingHubPage [HUB]
└─ tradeMarginAdvancedAnalytics → AdvancedAnalyticsPage [HUB]
```

### 4.4 HUB — Copy hub (6 HUB + 2 GOM hub-local)

```text
Copy (/trade/copy-trading) [GIỮ]
├─ Công cụ & danh sách [HUB]
│  ├─ /trade/copy-performance/:copyId → CopyPerformancePage
│  ├─ /trade/copy-performance/:copyId/attribution → PerformanceAttributionPage
│  ├─ tradeCopyComparison → ProviderComparisonPage
│  ├─ tradeCopyLeaderboard → ProviderLeaderboardPage
│  ├─ tradeCopyNotifications → CopyNotificationsPage
│  └─ tradeCopyRiskAnalysis → PortfolioRiskAnalysisPage
└─ Tuân thủ & audit [GOM — giữ dưới Copy, không Profile]
   ├─ /trade/copy-audit-log/:copyId → CopyAuditLogPage
   └─ tradeCopyProviderGovernance → ProviderGovernancePage
```

### 4.5 HUB — Bots hub (6)

```text
Bots (/trade/bots) [GIỮ]
├─ tradeBotBacktesting → BotBacktestingPage [HUB]
├─ tradeBotFaq → BotFaqPage [HUB]
├─ tradeBotGuide → BotGuidePage [HUB]
├─ tradeBotHistory → BotHistoryPage [HUB]
├─ tradeBotPerformanceAnalytics → BotPerformanceAnalyticsPage [HUB]
└─ tradeBotPortfolioDashboard → BotPortfolioDashboardPage [HUB]
```

### 4.6 GOM — Bot (6) → Profile › Pháp lý

| Page class | AppRoutePaths key (04) | Menu canonical |
|------------|------------------------|----------------|
| `BotApiDocumentationPage` | `tradeBotApiDocumentation` | Profile → Pháp lý & báo cáo |
| `BotEmergencyStopPage` | `tradeBotEmergencyStop` | Profile → Pháp lý & báo cáo |
| `BotRiskDashboardPage` | `tradeBotRiskDashboard` | Profile → Pháp lý & báo cáo |
| `BotRiskDisclosurePage` | `tradeBotRiskDisclosure` | Profile → Pháp lý & báo cáo |
| `BotSuitabilityAssessmentPage` | `tradeBotSuitabilityAssessment` | Profile → Pháp lý & báo cáo |
| `BotTermsOfServicePage` | `tradeBotTermsOfService` | Profile → Pháp lý & báo cáo |

### 4.7 GOM — Trade compliance (~29 từ `05-trade-compliance.md`) → Profile › Pháp lý

Toàn bộ GOM trong bảng 05 (complaints, KID, CASS, best execution, regulatory reports, RIY, slippage, target market, margin market-data analytics, …) — **menu UI đề xuất = Profile → Pháp lý & báo cáo**.  
Không gắn tile trên Trade terminal. Copy-specific audit/governance trong §4.4 có thể ở lại Copy hub «Tuân thủ».

Một dòng ẨN trong 05: target-market `/:productId` deep link — không menu.

---

## 5. Current vs proposed

| Item | Current | Proposed (locked D5) |
|------|---------|----------------------|
| `/trade` body | Spot terminal | **Giữ** terminal-first |
| Orders / Positions as hub tabs | Không (đúng) | **Vẫn không** — cấm thay terminal |
| EP-26 / EP-27 chrome | NextAction + «Xem tất cả» only; `headerActions: []` | **Header** «Lệnh» + «Vị thế» persistent |
| Product switcher | Spot/Futures/Margin/Convert/Bot | Giữ 5 tabs |
| Copy entry | Home Pro; không L1 switcher | Giữ (không nhét vào product tabs) |
| Advanced chart / Export | HUB routes; entry yếu | Overflow / công cụ Spot — không primary tabs |
| Compliance GOM (~30) | Routes tồn tại | Profile › Pháp lý canonical |
| Secondary products tab highlight | Trade (D1 Option A) | Giữ; detail shell 18 |

---

## 6. Empty / loading / error rules

| State | UI hiện tại | Rule |
|-------|-------------|------|
| **Loading** | `VitSkeletonList` (`tradeScreenProvider.when`) | Full-page trước khi có snapshot |
| **Error** | `VitErrorState` — «Không tải được màn hình giao dịch» | Invalidate `tradeScreenProvider(pairId)` |
| **Empty positions** | `VitEmptyState` — «Chưa có tài sản Spot» | Trong section Tài sản; không chặn form |
| **Submit success** | `showVitNoticeSheet` success + receipt navigate | Không SnackBar; CTA «Tiếp tục giao dịch» |
| **Submit fail / offline** | Notice sheet error + risk panel state | Ở lại terminal |
| **Orders empty** | Trên `OrdersHistoryPage` (hub/list archetype) | Không đổi thành tab trên `/trade` |
| **High-risk busy** | Panel submitting / sticky form CTA | `VitStickyFooter` chỉ khi form in-progress |

---

## 7. File mapping (widget → section)

| File | Section / responsibility |
|------|--------------------------|
| `pages/hub/trade_page.dart` | `TradePage` widget + keys SC-048 |
| `widgets/hub/trade_page_state.dart` | `when()`, submit, next-action, section composition |
| `widgets/hub/vit_trade_simple_shell.dart` | Hub scaffold, product tabs inject, disclaimer |
| `widgets/hub/vit_trade_simple_hero.dart` | Pair hero |
| `widgets/hub/vit_trade_simple_order_form.dart` | Mua/Bán form + confirm |
| `trade_core/.../trade_product_navigation.dart` | Spot/Futures/Margin/Convert/Bot destinations |
| `trade_core/.../trade_module_layout.dart` | `tradeShellWithProductTabs` / hub scaffold |
| `trade_core/.../trade_high_risk_status_ui.dart` | Risk panel mapping |
| `app/providers/trade_controller_providers.dart` | Screen + order Notifier providers |

**Chrome D5 (STEP-P2.4 done):** `VitTradeSimpleShell.headerActions` — Lệnh → `tradeOrdersHistory` (EP-26), Vị thế → `tradePositions` (EP-27).

---

## 8. Open decisions

1. Label header: «Lệnh» vs «Lịch sử lệnh» (path vẫn `orders-history`)?  
2. Advanced chart / Export: overflow «⋯» trên terminal vs chỉ từ pair detail?  
3. Copy: có bao giờ vào product switcher overflow không? (hiện **không** — Home Pro)  
4. Futures L1: giữ ẨN pair flow hay promote GIỮ landing? (ngoài D5; không đổi trong P0 docs)

---

## 9. Gaps / reachability notes

| Gap | Severity | Note |
|-----|----------|------|
| EP-26/27 header action | **closed P2.4** | Persistent «Lệnh» + «Vị thế» trên Spot terminal |
| Spot HUB chart/export inbound yếu | P2 | Thêm overflow khi chạm terminal chrome |
| Compliance GOM (~29) không có Profile Pháp lý UI list | Cross-shell | Xem Profile wireframe / shell 18 — không list trên Trade |
| Path naming EP-26 | Docs | `/trade/orders-history` ≠ label `/trade/orders` trong một số INDEX row |
| D1 secondary highlight | OK | Earn/P2P/Arena/DCA/Launchpad → Trade tab; **không** redesign trong file này |

**Không gap D5-model:** body đã terminal-first; chỉ thiếu **persistent header** cho Orders/Positions.

---

## 10. Secondary products (D1) — brief

Khi user ở `/earn*`, `/p2p*`, `/arena*`, `/dca*`, `/launchpad*`, … bottom nav vẫn highlight **Trade** (Option A locked).  
Wireframe chi tiết từng product hub: Earn `22`, P2P `23`, Predictions/Arena `24`, shell matrix `18` / `26`. File `20` chỉ khẳng định: **không** nhầm các màn đó thành tab con của Spot terminal.

---

## 11. Thống kê menu-relevant (Trade family)

| Nguồn | GIỮ | HUB | GOM |
|-------|----:|----:|----:|
| `04-trade.md` | 7 | 16 | 8 |
| `05-trade-compliance.md` | 0 | 0 | 29 (+1 ẨN) |
| Copy hub-local GOM (giữ dưới Copy) | — | — | 2 (audit log, governance) |
| GOM → Profile Pháp lý (Bot 04 + hầu hết 05) | — | — | ~35 canonical menu |

Terminal root: **1 GIỮ** (`/trade`) + product GIỮ Convert/Margin/Bots/Copy + Orders/Positions secondary.
