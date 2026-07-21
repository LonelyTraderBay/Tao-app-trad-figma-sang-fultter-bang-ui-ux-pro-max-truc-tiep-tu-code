# Wireframe text — Predictions + Arena + Discovery (EP-20 / EP-21)

Generated: 2026-07-21 · **STEP-P0.8 part A thickened**  
Nguồn:
- [`11-predictions.md`](./11-predictions.md) — **1 GIỮ + 5 HUB + 12 ẨN** (18 routes)
- [`10-arena.md`](./10-arena.md) — **1 GIỮ + 5 HUB + 1 GOM + 18 ẨN** (25 routes)
- [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) — Discovery section Home (canonical)
- [`19-MARKETS-HUB-WIREFRAME.md`](./19-MARKETS-HUB-WIREFRAME.md) — Markets footer shortcut only
- [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md) — `/arena*` → **Trade** (D1); `/markets/predictions*` → **Markets** (prefix `/markets`)
- Product boundaries: **AGENTS.md** (Prediction Markets vs Open Arena)
- Paths: `predictions_route_ids.dart`, `arena_route_ids.dart`
- Profile shortcuts: `/profile/predictions`, `/profile/arena` (aliases / surface links — không phải Discovery hub thứ hai)

Phạm vi: **hai sản phẩm tách biên** + **dedup Discovery** (Home canonical).  
Launchpad / Rewards / Topics thuộc «Sản phẩm Khám phá» (file 17) — **không** trộn vào Discovery Predictions/Arena trong file này.

---

## 0. Product boundary (LOCKED) — không đàm phán

| Surface | Currency / performance | History | Leaderboard language | **CẤM** |
|---------|------------------------|---------|----------------------|---------|
| **Predictions** (EP-20) | **Wallet balance**, positions, probability, receipt, **P/L** | Orders / receipts | Trading / prediction context | Casino / hype language |
| **Arena** (EP-21) | **Arena Points only**, points pool, completion | **Ledger entries** (points) | Fair play / completion | **payout, wallet, profit, stake-return**, PnL ví |

**Allowed bridges** (AGENTS.md): topic/category, event context, creator discovery, search/discovery, profile surfaces với **section tách rõ** — không merge số dư ví vào điểm Arena trên cùng một card.

### 0.1 Copy checklist (Arena wireframe — VERIFY)

Trong ASCII / labels Arena dưới đây **chỉ** dùng: Điểm Arena · sổ điểm · hoàn thành · fair play · thách đấu · studio.  
**Không** xuất hiện: ví, rút tiền, lợi nhuận, payout, stake-return, P/L ví.

Predictions được phép: số dư ví (context), vị thế, xác suất, biên lai, P/L.

---

## 1. Discovery dedup (Home / Markets / Profile)

| Location | Role | Được phép | Cấm |
|----------|------|-----------|-----|
| **Home › Discovery** | **Canonical** entry cards Predictions + Arena | 2 tiles GIỮ → hubs | Trộn với Sinh lời / Earn |
| **Markets footer** | **Shortcut only** → Predictions (và/hoặc Arena nếu đã có) | 1 dòng «Dự đoán» / deep | Second Discovery hub, duplicate grid |
| **Profile** | **Portfolio / My Arena shortcuts** | Link tới portfolio canonical + `/arena/my` | Discovery browse (breaking / search / studio browse) |

```text
Home (canonical Discovery)
  ├─ Predictions → /markets/predictions [GIỮ]
  └─ Arena       → /arena               [GIỮ]
        │
        ├─ Markets footer ──shortcut──► cùng GIỮ targets (không nhân đôi IA)
        └─ Profile ──portfolio links──► §3 canonical portfolios only
```

---

## 2. Active tab brief

| Path pattern | Active tab | Note |
|--------------|------------|------|
| `/markets/predictions`, `/markets/predictions/*` | **Markets** | `startsWith('/markets')` — file 18 |
| `/arena`, `/arena/*` | **Trade** | D1 secondary product |
| `/profile/predictions`, `/profile/arena` | **Profile** | Shortcut surfaces |

---

## 3. Canonical portfolio routes

| Product | Canonical portfolio | Page class | Phân loại | Secondary / shortcut |
|---------|---------------------|------------|-----------|----------------------|
| **Predictions** | `/markets/predictions/portfolio` | `PredictionsPortfolioPage` | **HUB** | Analyzer HUB; Profile `/profile/predictions` = shortcut **cùng đích hoặc thin wrapper** — **một** nguồn sự thật portfolio |
| **Arena** | `/arena/my` | `MyArenaPage` | **ẨN** (entry ổn định từ hub + Profile) | Ledger `/arena/ledger` = points history ẨN; **không** gọi là «ví» |

**Quyết định P0:**  
- Predictions portfolio canonical = **`/markets/predictions/portfolio`**.  
- Arena «của tôi» canonical = **`/arena/my`** (points / challenges joined — **không** wallet).  
- Profile rows chỉ **deep link** tới canonical — không invent portfolio thứ hai với copy ví trên Arena.

Related HUB (không thay portfolio):

| Product | Path | Role |
|---------|------|------|
| Predictions | `/markets/predictions/portfolio-analyzer` | Phân tích danh mục (HUB) |
| Predictions | `/markets/predictions/leaderboard` | BXH (HUB) |
| Arena | `/arena/leaderboard` | BXH fair play (HUB) |
| Arena | `/arena/ledger` | Sổ **điểm** (ẨN) |

---

## 4. ASCII wireframe @360×800

### 4.1 CURRENT — Home Discovery (excerpt từ file 17)

```
┌─────────────────────────────────────────────┐
│ … Home …                                    │
├─────────────────────────────────────────────┤
│ DISCOVERY                                   │
│  ┌──────────────┐  ┌──────────────┐         │
│  │  Predictions │  │    Arena     │         │
│  │  (wallet/PnL)│  │  (points)    │         │
│  └──────────────┘  └──────────────┘         │
├─────────────────────────────────────────────┤
│ [Home●] [Markets] [Trade] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

### 4.2 CURRENT — Predictions home (sketch)

```
┌─────────────────────────────────────────────┐
│ Dự đoán thị trường              [Tìm]       │  ← Markets tab active
│ Sự kiện · xác suất · vị thế ví              │
├─────────────────────────────────────────────┤
│ Hero / featured events                      │
│ Filters · breaking strip (nếu có)           │
│ Event list …                                │
├─────────────────────────────────────────────┤
│ (HUB portfolio / BXH / lịch — entry rải)    │
├─────────────────────────────────────────────┤
│ [Home] [Markets●] [Trade] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

### 4.3 CURRENT — Arena home (sketch)

```
┌─────────────────────────────────────────────┐
│ Open Arena                      [?]         │  ← Trade tab (D1)
│ Điểm Arena · thách đấu · studio             │
├─────────────────────────────────────────────┤
│ Hero points pool / modes                    │
│ Challenges list …                           │
├─────────────────────────────────────────────┤
│ (HUB studio / guide / BXH — entry rải)      │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

### 4.4 PROPOSED — Predictions hub (portfolio chrome rõ)

```
┌─────────────────────────────────────────────┐
│ Dự đoán                    [Tìm] [Danh mục] │  ← Danh mục → portfolio HUB
│ Ví · vị thế · xác suất                      │
├─────────────────────────────────────────────┤
│ Featured / filters / event list             │
├─────────────────────────────────────────────┤
│ CÔNG CỤ DỰ ĐOÁN (chip / overflow)           │
│  [Danh mục][Phân tích][BXH][Lịch sự kiện]   │
│  [Biểu đồ nâng cao] ← cần eventId (deep)    │
├─────────────────────────────────────────────┤
│ [Home] [Markets●] [Trade] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

### 4.5 PROPOSED — Arena hub (points-only; Studio drawer)

```
┌─────────────────────────────────────────────┐
│ Open Arena              [Của tôi] [Công cụ] │
│ Điểm Arena · hoàn thành thách đấu           │  ← KHÔNG «ví» / «lợi nhuận»
├─────────────────────────────────────────────┤
│ Hero — số Điểm · pool / modes               │
│ Danh sách thách đấu …                       │
├─────────────────────────────────────────────┤
│ (tools không stack card ví)                 │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘

┌─ Công cụ Arena ─────────────────────────────┐
│ Studio & thách đấu                          │
│  Hướng dẫn · Bảng xếp hạng                  │
│  Studio · Thư viện preset · Smart rules     │
│ (Governance gate = GOM → Profile Pháp lý)   │
└─────────────────────────────────────────────┘
```

### 4.6 PROPOSED — Markets footer shortcut (không nhân Discovery)

```
┌─ Markets hub (cuối trang) ──────────────────┐
│ …                                           │
│ Lối tắt                                     │
│  Dự đoán thị trường ›  → /markets/predictions│
│  (Arena › chỉ nếu cần — ưu tiên Home)       │
└─────────────────────────────────────────────┘
```

### 4.7 PROPOSED — Profile portfolio links (không browse Discovery)

```
┌─ Profile › Tài khoản / Portfolio ───────────┐
│ Danh mục Dự đoán ›  → /markets/predictions/portfolio
│ Arena của tôi ›     → /arena/my             │
│ (points / challenges — không số dư ví)      │
└─────────────────────────────────────────────┘
```

---

## 5. Section order

### 5.1 PredictionsHomePage

| # | Section | Proposed |
|--:|---------|----------|
| 1 | Header | Title + search + **Danh mục** (portfolio) |
| 2 | Hero / featured | Events nổi bật |
| 3 | Filters / breaking | Contextual |
| 4 | Event list | Primary scroll |
| 5 | Công cụ HUB | Chip row / overflow — 5 HUB |
| 6 | Bottom nav | **Markets** |

### 5.2 ArenaHomePage

| # | Section | Proposed |
|--:|---------|----------|
| 1 | Header | Title + **Của tôi** + **Công cụ** |
| 2 | Hero points | Điểm Arena / pool — **points-only copy** |
| 3 | Modes / challenges | Primary scroll |
| 4 | Tools | Drawer 5 HUB Studio & thách đấu |
| 5 | Bottom nav | **Trade** (D1) |

---

## 6. Cây GIỮ + HUB + GOM

### 6.1 Predictions (EP-20)

```text
PREDICTIONS
├─ [GIỮ] PredictionsHomePage → /markets/predictions
│  │  Entry: Home › Discovery (canonical); Markets footer shortcut
│  │
│  └─ Công cụ › Danh mục & portfolio [HUB ×5]
│     ├─ /markets/predictions/portfolio → PredictionsPortfolioPage
│     ├─ /markets/predictions/portfolio-analyzer → PredictionPortfolioAnalyzerPage
│     ├─ /markets/predictions/leaderboard → PredictionsLeaderboardPage
│     ├─ /markets/predictions/event-calendar → PredictionEventCalendarPage
│     └─ /markets/predictions/advanced-chart/:eventId → PredictionAdvancedChartPage
│
└─ ẨN (contextual)
   ├─ event/:eventId, receipt/:receiptId, tournament/:id
   ├─ search, breaking, activity, rewards, risk-calculator
   ├─ market-maker, social, tournaments, data-integration
   └─ (không menu Discovery thứ hai)
```

### 6.2 Arena (EP-21)

```text
ARENA
├─ [GIỮ] ArenaHomePage → /arena
│  │  Entry: Home › Discovery (canonical)
│  │
│  ├─ Của tôi → /arena/my [ẨN] MyArenaPage  ← canonical «portfolio» points
│  │
│  └─ Công cụ › Studio & thách đấu [HUB ×5]
│     ├─ /arena/guide → ArenaGuidePage
│     ├─ /arena/leaderboard → ArenaLeaderboardPage
│     ├─ /arena/studio → ArenaStudioPage
│     ├─ /arena/studio/presets → ArenaUniversalPresetLibraryPage
│     └─ /arena/studio/smart-rules → ArenaSmartRuleBuilderPage
│
├─ [GOM] /arena/studio/governance → ArenaGovernanceGatePage
│     └─ Profile › Pháp lý & báo cáo (không drawer Studio)
│
└─ ẨN (contextual) — points language only
   ├─ challenge/:id, join/:id, mode/:id, creator/:id
   ├─ ledger, ledger/entry/:id, points (nếu dùng)
   ├─ safety, blocked, my-reports, report/:caseId, trust/:userId
   ├─ resolution, verified, flow-map, bridge, ecosystem, production
   └─ CẤM copy: wallet / payout / profit / stake-return
```

### 6.3 GIỮ / HUB / GOM tables

#### Predictions GIỮ (1)

| Path | Page | Menu |
|------|------|------|
| `/markets/predictions` | `PredictionsHomePage` | Home › Discovery |

#### Predictions HUB (5)

| Path | Page | Label UI |
|------|------|----------|
| `/markets/predictions/portfolio` | `PredictionsPortfolioPage` | Danh mục |
| `/markets/predictions/portfolio-analyzer` | `PredictionPortfolioAnalyzerPage` | Phân tích danh mục |
| `/markets/predictions/leaderboard` | `PredictionsLeaderboardPage` | Bảng xếp hạng |
| `/markets/predictions/event-calendar` | `PredictionEventCalendarPage` | Lịch sự kiện |
| `/markets/predictions/advanced-chart/:eventId` | `PredictionAdvancedChartPage` | Biểu đồ nâng cao |

#### Arena GIỮ (1)

| Path | Page | Menu |
|------|------|------|
| `/arena` | `ArenaHomePage` | Home › Discovery |

#### Arena HUB (5)

| Path | Page | Label UI |
|------|------|----------|
| `/arena/guide` | `ArenaGuidePage` | Hướng dẫn |
| `/arena/leaderboard` | `ArenaLeaderboardPage` | Bảng xếp hạng |
| `/arena/studio` | `ArenaStudioPage` | Studio |
| `/arena/studio/presets` | `ArenaUniversalPresetLibraryPage` | Thư viện preset |
| `/arena/studio/smart-rules` | `ArenaSmartRuleBuilderPage` | Smart rules |

#### Arena GOM (1)

| Path | Page | Canonical |
|------|------|-----------|
| `/arena/studio/governance` | `ArenaGovernanceGatePage` | Profile › Pháp lý |

---

## 7. Current vs proposed

| Item | Current | Proposed |
|------|---------|----------|
| Discovery home | Có / đang làm dày ở 17 | **Canonical** — giữ 2 tiles |
| Markets | Có thể lẫn entry | **Footer shortcut only** |
| Profile | MyArena / predictions links | **Portfolio shortcuts only** — không browse |
| Predictions HUB | 5 routes; chrome yếu | Header Danh mục + chip tools |
| Arena HUB | 5 routes; chrome yếu | Drawer Studio & thách đấu |
| Arena governance | GOM trong map | Profile Pháp lý only |
| Boundary copy | Rủi ro mixed language | **Locked** §0 — points-only Arena |
| Portfolio canonical | Nhiều surface | §3 một canonical / product |

---

## 8. Empty / loading / error rules

| State | Predictions | Arena |
|-------|-------------|-------|
| **Loading** | Skeleton event list | Skeleton challenges + points hero |
| **Error** | `VitErrorState` + invalidate predictions provider | Invalidate arena home provider |
| **Empty events** | «Chưa có sự kiện» + CTA tìm / đổi filter | — |
| **Empty positions** | Portfolio empty + «Khám phá sự kiện» (wallet/PnL OK) | — |
| **Empty points / no joins** | — | «Chưa tham gia thách đấu» + CTA khám phá modes (**điểm**, không nạp ví) |
| **Empty ledger** | — | «Chưa có mục sổ điểm» |
| **Offline** | Banner + stale nếu có | Cùng |
| **Success order / join** | `showVitNoticeSheet` + receipt | Notice hoàn thành / điểm cộng — **không** «payout» |
| **Bridge surfaces** | Topic/event links OK | Creator/topic OK; **không** merge wallet row |

---

## 9. File mapping

| File / area | Responsibility |
|-------------|----------------|
| `features/predictions/.../predictions_home_page.dart` | Predictions GIỮ hub |
| `.../predictions_portfolio_page.dart` | Canonical portfolio |
| `.../prediction_portfolio_analyzer_page.dart` | HUB analyzer |
| `.../predictions_leaderboard_page.dart` | HUB BXH |
| `.../prediction_event_calendar_page.dart` | HUB calendar |
| `.../prediction_advanced_chart_page.dart` | HUB chart (eventId) |
| `features/arena/.../arena_home_page.dart` | Arena GIỮ hub |
| `.../my_arena_page.dart` | Canonical «Của tôi» |
| `.../arena_studio_page.dart` (+ presets, smart-rules) | HUB studio family |
| `.../arena_guide_page.dart`, `arena_leaderboard_page.dart` | HUB |
| `.../arena_governance_gate_page.dart` | GOM → Profile |
| `features/home/...` Discovery section | Canonical tiles (file 17) |
| `features/markets/...` footer | Shortcut only |
| `features/profile/...` | `/profile/predictions`, `/profile/arena` shortcuts |
| `app/providers/*predictions*`, `*arena*` | Controllers |
| **Proposed** | Arena tools drawer; Predictions hub chip row |

---

## 10. Open decisions

1. **Profile `/profile/predictions`:** redirect cứng tới `/markets/predictions/portfolio` hay page wrapper riêng? Đề xuất **redirect / shared page** — một canonical.  
2. **Markets footer có hiện Arena không?** Đề xuất: Predictions yes; Arena **chỉ Home** để tránh lẫn tab Markets vs D1 Trade.  
3. **Advanced chart HUB** không có `eventId` trên hub — luôn overflow «từ sự kiện» giống P2P ad-analytics.  
4. **`/arena/points` vs `/arena/my` vs ledger:** My = hub «của tôi»; ledger = history ẨN; points page nếu còn — alias hoặc gộp khi chạm code.  
5. Bridge Foundation / Ecosystem / Production pages: giữ ẨN / DEV-adjacent — không Discovery.

---

## 11. Gaps / reachability notes

| Gap | Severity | Note |
|-----|----------|------|
| Dual portfolio surfaces Predictions | **P2** | Chốt canonical §3 + Profile shortcut |
| Arena My vs Profile Arena | **P2** | Cùng `/arena/my` |
| HUB tools thiếu chrome | **P2** | STEP-P4 hub drawers |
| Governance GOM chưa Profile UI | **P2** | File 17 Pháp lý |
| Mixed wallet/points copy risk | **P0 product** | Guard khi chạm Arena UI; wireframe này points-only |
| Discovery duplicate Markets | P2 | Footer shortcut only |
| Active tab Predictions = Markets | OK | File 18 |
| Active tab Arena = Trade | OK | D1 |

---

## 12. Thống kê

| Module | GIỮ | HUB | GOM | ẨN | Tổng |
|--------|----:|----:|----:|---:|-----:|
| Predictions | 1 | 5 | 0 | 12 | 18 |
| Arena | 1 | 5 | 1 | 18 | 25 |

**Verify boundary:** §0 table + Arena ASCII không dùng payout/wallet/profit.  
**Verify Discovery dedup:** Home canonical; Markets shortcut; Profile portfolio only.  
**Verify portfolios:** Predictions `/markets/predictions/portfolio`; Arena `/arena/my`.
