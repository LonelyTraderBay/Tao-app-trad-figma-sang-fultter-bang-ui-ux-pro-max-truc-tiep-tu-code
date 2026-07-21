# Wireframe text — Markets Hub (EP-02)

Generated: 2026-07-21  
Nguồn:
- [`03-markets.md`](./03-markets.md) — 1 GIỮ + 10 HUB (+ 11 ẨN / pair deep links)
- [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md) — active tab Markets cho `/markets*` và `/pair/*`
- Production: `flutter_app/lib/features/markets/presentation/pages/hub/market_list_page.dart`
- Widgets: `market_list_header.dart`, `market_list_tools.dart`, `market_list_movers.dart`, `market_list_pairs.dart`, `market_list_discover.dart`, `market_list_filters.dart`
- Paths: `flutter_app/lib/app/router/route_groups/markets_route_ids.dart`

Phạm vi shell: **Bottom Nav → Thị trường** (`/markets`, `MarketListPage`).  
Không thuộc phạm vi D1 (D1 = highlight Trade cho secondary products earn/p2p/arena/…). Markets chỉ chịu policy active-tab `/markets*` + `/pair/*`.

---

## 1. ASCII wireframe @360×800

### 1.1 CURRENT (production — list-first)

```
┌─────────────────────────────────────────────┐
│ Thị trường                                  │
│ Theo dõi thị trường · Cập nhật HH:MM        │
│              [Tổng quan] [Biến động] [Ngành]│  ← Header actions
├─────────────────────────────────────────────┤
│ [🔍 Tìm kiếm BTC, ETH...          ] [↕]    │  ← Search + sort toggle
│ [Tất cả] [Spot] [Futures] [Yêu thích] …     │  ← Category tabs
├─────────────────────────────────────────────┤
│ TOP MOVERS (strip — ẩn khi search/filter)   │
│  ┌────┐ ┌────┐ ┌────┐                       │
│  │BTC │ │ETH │ │SOL │ …                     │
│  └────┘ └────┘ └────┘                       │
├─────────────────────────────────────────────┤
│ CÔNG CỤ (horizontal chips — ẩn khi search)  │
│ [Bộ lọc][So sánh][Sự kiện][Phái sinh]…      │
├─────────────────────────────────────────────┤
│ Cặp · Giá · 24h                             │
│ BTC/USDT   67,543.21   +2.5%   ★            │
│ ETH/USDT   …                                │
│ … (list scroll)                             │
├─────────────────────────────────────────────┤
│ KHÁM PHÁ THÊM (footer shortcut only)        │
│  Predictions · Xác suất · Vị thế            │
│  Open Arena · Arena Points only             │
├─────────────────────────────────────────────┤
│ [Home] [Markets●] [Trade] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

### 1.2 PROPOSED (Phase 2 — đóng gap heatmap / watchlist)

Giữ list-first; **không** đổi thành tool-grid hub. Chỉ bổ sung 2 entry ổn định cho HUB thiếu inbound:

```
┌─────────────────────────────────────────────┐
│ Thị trường                                  │
│ Theo dõi thị trường · Cập nhật HH:MM        │
│     [Tổng quan] [Biến động] [Heatmap] [★]   │  ← Ngành ẨN → overflow/ẩn
├─────────────────────────────────────────────┤
│ [🔍 Tìm kiếm BTC, ETH...          ] [↕]    │
│ [Tất cả] [Spot] [Futures] [Yêu thích] …     │
├─────────────────────────────────────────────┤
│ TOP MOVERS …                                │
├─────────────────────────────────────────────┤
│ CÔNG CỤ (HUB-only chips; ẨN chips → sheet)  │
│ [Bộ lọc][So sánh][Sự kiện][Phái sinh]       │
│ [Danh mục][Phân tích][Heatmap][Watchlist]   │
├─────────────────────────────────────────────┤
│ Cặp list …                                  │
├─────────────────────────────────────────────┤
│ KHÁM PHÁ THÊM — Predictions | Arena         │
│  (shortcut; Home = Discovery canonical)     │
├─────────────────────────────────────────────┤
│ [Home] [Markets●] [Trade] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

---

## 2. Section order (top → bottom)

| # | Section | Widget / source | Ghi chú |
|--:|---------|-----------------|---------|
| 1 | Header chrome | `MarketListHeader` / `VitTopChrome` | Title «Thị trường»; 3 header actions |
| 2 | Search | `VitSearchBar` | Placeholder «Tìm kiếm BTC, ETH...» |
| 3 | Sort sheet (conditional) | `MarketListSortSheet` | Khi bật filter inline |
| 4 | Category tabs | `MarketListCategoryTabs` | Tất cả / Spot / Futures / Yêu thích… |
| 5 | Top movers (conditional) | `MarketListTopMovers` | Chỉ khi không search + category mặc định |
| 6 | Tool chips (conditional) | `MarketListTools` | Cùng điều kiện summary |
| 7 | Column header | `MarketListColumnHeader` | Cặp · giá · 24h |
| 8 | Pair list / empty | `MarketListPairList` / `VitEmptyState` | Tap → `/pair/:pairId` |
| 9 | Discover footer | `MarketListDiscoverMoreSection` | Predictions + Arena **shortcut only** |
| 10 | Bottom nav | App shell | Active = **Markets** |

Rhythm: `VitPageRhythm.compact` (tab root).

---

## 3. Cây menu đầy đủ — GIỮ + HUB (+ ghi chú ẨN)

Markets module **không có GOM**. Pair routes là ẨN (flow từ tap cặp).

```text
MARKETS (/markets) [EP-02] — GIỮ — MarketListPage
│
├─ Header actions
│  ├─ Tổng quan → /markets/overview [HUB] MarketOverviewPage
│  ├─ Biến động → /markets/movers [HUB] MarketMoversPage
│  └─ Ngành → /markets/sectors [ẨN] MarketSectorsPage  ← có UI nhưng ẨN trong IA
│
├─ Tool chips (MarketListTools → /markets/{route})
│  ├─ Bộ lọc → /markets/screener [HUB] MarketScreenerPage
│  ├─ So sánh → /markets/compare [HUB] ComparisonToolPage
│  ├─ Sự kiện → /markets/calendar [HUB] MarketCalendarPage
│  ├─ Phái sinh → /markets/derivatives [HUB] DerivativesOverviewPage
│  ├─ Tâm lý → /markets/social-sentiment [ẨN] SocialSentimentPage
│  ├─ Danh mục → /markets/portfolio-tracker [HUB] PortfolioTrackerPage
│  ├─ Tin tức → /markets/news [ẨN] MarketNewsPage
│  ├─ Phân tích → /markets/advanced-charts [HUB] AdvancedChartsPage
│  ├─ Unlock → /markets/unlocks [ẨN] TokenUnlocksPage
│  ├─ Tín hiệu → /markets/signals [ẨN] SocialSignalsPage
│  └─ Tương quan → /markets/correlations [ẨN] MarketCorrelationsPage
│
├─ Pair list → /pair/:pairId [ẨN] PairDetailPage
│  ├─ /pair/:pairId/depth [ẨN] MarketDepthPage
│  └─ /pair/:pairId/info [ẨN] TokenInfoPage
│
├─ Discover footer (shortcut — không phải Discovery canonical)
│  ├─ Prediction Markets → AppRoutePaths.marketsPredictions [shell khác]
│  └─ Open Arena → AppRoutePaths.arena [shell khác; Home = Discovery SO]
│
└─ HUB thiếu inbound UI trên trang list (đề xuất Phase 2)
   ├─ /markets/heatmap [HUB] MarketHeatmapPage — GAP
   └─ /markets/watchlist [HUB] WatchlistPage — GAP
```

### 3.1 Bảng inbound UI — từng HUB (verify STEP-P0.3)

| HUB page | Path | Inbound UI? | Widget / entry |
|----------|------|:-----------:|----------------|
| `AdvancedChartsPage` | `/markets/advanced-charts` | **yes** | `MarketListTools` chip «Phân tích» |
| `MarketCalendarPage` | `/markets/calendar` | **yes** | `MarketListTools` chip «Sự kiện» |
| `ComparisonToolPage` | `/markets/compare` | **yes** | `MarketListTools` chip «So sánh» |
| `DerivativesOverviewPage` | `/markets/derivatives` | **yes** | `MarketListTools` chip «Phái sinh» |
| `MarketHeatmapPage` | `/markets/heatmap` | **no** | — không header, không chip |
| `MarketMoversPage` | `/markets/movers` | **yes** | `MarketListHeader` action analytics «Biến động» |
| `MarketOverviewPage` | `/markets/overview` | **yes** | `MarketListHeader` action overview «Tổng quan» |
| `PortfolioTrackerPage` | `/markets/portfolio-tracker` | **yes** | `MarketListTools` chip «Danh mục» |
| `MarketScreenerPage` | `/markets/screener` | **yes** | `MarketListTools` chip «Bộ lọc» |
| `WatchlistPage` | `/markets/watchlist` | **no** | — tab «Yêu thích» chỉ lọc list local, **không** `context.go` watchlist |

**Tóm tắt gap inbound:** `marketsHeatmap`, `marketsWatchlist` (2/10 HUB).

### 3.2 GIỮ duy nhất

| Path | Page class | EP | Phân loại | Menu |
|------|------------|-----|-----------|------|
| `/markets` (`AppRoutePaths.markets`) | `MarketListPage` | EP-02 | **GIỮ** | Bottom Nav → Markets |

### 3.3 HUB đầy đủ (10)

| Path | Page class | Phân loại | Menu UI đề xuất |
|------|------------|-----------|-----------------|
| `/markets/advanced-charts` | `AdvancedChartsPage` | HUB | Markets hub → Công cụ |
| `/markets/calendar` | `MarketCalendarPage` | HUB | Markets hub → Công cụ |
| `/markets/compare` | `ComparisonToolPage` | HUB | Markets hub → Công cụ |
| `/markets/derivatives` | `DerivativesOverviewPage` | HUB | Markets hub → Công cụ |
| `/markets/heatmap` | `MarketHeatmapPage` | HUB | Markets hub → Công cụ (**gap inbound**) |
| `/markets/movers` | `MarketMoversPage` | HUB | Markets hub → Header |
| `/markets/overview` | `MarketOverviewPage` | HUB | Markets hub → Header |
| `/markets/portfolio-tracker` | `PortfolioTrackerPage` | HUB | Markets hub → Công cụ |
| `/markets/screener` | `MarketScreenerPage` | HUB | Markets hub → Công cụ |
| `/markets/watchlist` | `WatchlistPage` | HUB | Markets hub → Công cụ (**gap inbound**) |

### 3.4 ẨN (không menu; ghi nhận reachability)

Alerts, Correlations, Depth (module + pair), News, Sectors, Signals, SocialSentiment, Unlocks, pair detail/info/depth — deep link / flow only.  
**Lưu ý:** một số chip/header hiện **đẩy sang ẨN** (sectors, social-sentiment, news, unlocks, signals, correlations) — reconcile Phase 2 (giữ deep link hoặc nâng HUB / gom overflow).

---

## 4. Current vs proposed

| Item | Current | Proposed |
|------|---------|----------|
| Hub model | List-first + mid-scroll tool chips | **Giữ** list-first; không đổi thành tile-grid hub |
| Heatmap | Route HUB tồn tại; **0 inbound UI** trên `MarketListPage` | Thêm chip hoặc header action «Heatmap» |
| Watchlist | Route HUB tồn tại; tab «Yêu thích» ≠ `WatchlistPage` | Thêm chip/header «Watchlist» → `/markets/watchlist` |
| Header «Ngành» | Push `/markets/sectors` (ẨN) | Ẩn khỏi chrome chính hoặc overflow; không promote ẨN |
| Tool chips ẨN | 5 chip trỏ ẨN routes | Chips visible chỉ HUB; ẨN → sheet «Thêm» hoặc deep link |
| Discover footer | Predictions + Arena rows | **Giữ** shortcut; **Home** vẫn Discovery canonical |
| Active tab | Markets cho `/markets*`, `/pair/*` | Không đổi (không liên quan D1) |
| Pair tap | `/pair/:pairId` | Giữ ẨN flow |

---

## 5. Empty / loading / error rules

| State | UI hiện tại | Rule |
|-------|-------------|------|
| **Loading** | `VitSkeletonList` trong `listAsync.when(loading:)` | Full-page skeleton trước khi có snapshot |
| **Error** | `VitErrorState` — «Không tải được thị trường» + «Thử lại» | `ref.invalidate(marketListSnapshotProvider)` |
| **Empty pairs** | `VitEmptyState` — «Không tìm thấy "query"» hoặc «Không có kết quả» | CTA «Xóa bộ lọc» → `resetFilters` |
| **Offline** | Chưa riêng trên list hub | Theo chuẩn app: inline `VitBanner` nếu cần; không SnackBar toast |
| **Summary hide** | Top movers + tools ẩn khi searchActive hoặc category ≠ default | Giữ — tránh noise khi lọc |

Hub tool pages (Overview, Screener, …): mỗi trang tự chịu empty/error theo archetype list/detail — không nhân đôi rule trên list root trừ khi audit state coverage yêu cầu.

---

## 6. File mapping (widget → section)

| File | Section / responsibility |
|------|--------------------------|
| `pages/hub/market_list_page.dart` | Shell layout, `when()` gate, section composition |
| `widgets/hub/market_list_header.dart` | Title + header actions Overview / Movers / Sectors |
| `widgets/hub/market_list_filters.dart` | Category tabs + sort sheet |
| `widgets/hub/market_list_movers.dart` | Top movers strip |
| `widgets/hub/market_list_tools.dart` | Horizontal tool chips + route suffixes |
| `widgets/hub/market_list_pairs.dart` | Pair rows → `/pair/:id` |
| `widgets/hub/market_list_discover.dart` | Discover footer Predictions \| Arena |
| `widgets/hub/market_list_common.dart` | Keys, accents, shared helpers |
| `app/providers/market_controller_providers.dart` | `marketListSnapshotProvider`, list state Notifier |

---

## 7. Open decisions

1. **Heatmap entry:** chip trong `MarketListTools` vs header action (thay/đẩy «Ngành»)?  
2. **Watchlist entry:** chip riêng vs promote category «Yêu thích» thành navigate tới `WatchlistPage`?  
3. **ẨN chips:** remove khỏi strip hay gom «Thêm công cụ» sheet?  
4. Copy Discover rows: production còn label English «Prediction Markets» / «Open Arena» — align vi-VN khi chạm file (ngoài scope wireframe docs).

---

## 8. Gaps / reachability notes

| Gap | Severity | Note |
|-----|----------|------|
| `marketsHeatmap` no inbound | **P2** | STEP-P2.1 playbook |
| `marketsWatchlist` no inbound | **P2** | STEP-P2.1; favorite filter ≠ Watchlist route |
| Header/tools → ẨN routes | P2 reconcile | Sectors + 5 tool chips |
| Discover ≠ Discovery hub | OK by design | Home canonical; footer = shortcut |
| D1 | N/A | Markets không thuộc D1 secondary-product highlight |

**Active tab reminder:** mọi path `/markets…` và `/pair/…` highlight **Markets** (xem shell spec §3). Predictions dưới markets path cũng Markets — không đổi trong file này.

---

## 9. Thống kê shell Markets (menu-relevant)

| Phân loại | Số trong cây menu shell |
|-----------|------------------------:|
| GIỮ | 1 |
| HUB | 10 |
| GOM | 0 |
| Inbound HUB yes | 8 |
| Inbound HUB no | **2** (heatmap, watchlist) |
