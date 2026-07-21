# Wireframe text — Earn / Savings Hub (EP-15 / EP-16 / EP-28 / EP-29)

Generated: 2026-07-21  
Nguồn:
- [`06-earn.md`](./06-earn.md) — 4 GIỮ + 23 HUB + **31 GOM** + 12 ẨN (70 routes)
- [`Hub-Content-Contract.md`](./Hub-Content-Contract.md) — CTA Earn/Savings = Stake / Gửi tiết kiệm; ≤3 major sections above fold; tile hub tone
- [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md) — **D1**: mọi `/earn*` highlight **Trade** (chi tiết matrix ở file 18; brief dưới §0)
- Dual entry Home › Sinh lời: Staking (`/earn`) + Tiết kiệm (`/earn/savings`) — xem [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md)
- Production Earn: `staking_earn_page.dart` (+ parts hero/products/positions)
- Production Savings: `savings_page.dart` (+ parts hero/products/positions/common) — tool insights hiện stacked cards dày
- Paths: `earn_route_ids` / `AppRoutePaths.earn*`

Phạm vi: **hai hub song song** (Staking vs Savings) + sheet **Tài liệu & rủi ro** gom **31 GOM**.  
Không redesign Spot terminal (file 20); Earn là secondary product dưới D1.

---

## 0. Active tab (D1) — brief

| Path prefix | Bottom nav highlight | Chi tiết |
|-------------|----------------------|----------|
| `/earn`, `/earn/*` (staking + savings) | **Trade** | Locked D1 Option A — **không** tạo tab Earn riêng |

Matrix đầy đủ path → tab: [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md). File này chỉ wireframe nội dung hub Earn/Savings.

---

## 1. ASCII wireframe @360×800

### 1.1 CURRENT — Staking Earn (`/earn`, `StakingEarnPage`)

```
┌─────────────────────────────────────────────┐
│ Earn / Stake                     [← Home]   │
│ (subtitle snapshot)                         │
├─────────────────────────────────────────────┤
│ HERO — tổng yield / vị thế tóm tắt          │
│ [ Tiết kiệm → /earn/savings ]               │  ← bridge CTA (copy fixture có thể thiếu dấu)
├─────────────────────────────────────────────┤
│ (optional) High-risk panel — contract Earn  │
├─────────────────────────────────────────────┤
│ [Sản phẩm●] [Vị thế (n)]                    │
│ [Tất cả][Cố định][Linh hoạt][DeFi]          │
│ Product cards … / Positions list …          │
├─────────────────────────────────────────────┤
│ Disclaimer yield (micro)                    │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│  ← D1 Trade
└─────────────────────────────────────────────┘
```

**Thiếu hôm nay:** grid HUB tiles (analytics/calendar/history/…); sheet Tài liệu & rủi ro (31 GOM); entry rõ EP-28 dashboard.

### 1.2 CURRENT — Savings (`/earn/savings`, `SavingsPage`)

```
┌─────────────────────────────────────────────┐
│ Tiết kiệm                        [← Earn]   │
├─────────────────────────────────────────────┤
│ HERO — APR / số dư tiết kiệm                │
│ [Sản phẩm●] [Của tôi (n)]                   │
│ Filters … + product / position lists        │
├─────────────────────────────────────────────┤
│ INSIGHTS / CÔNG CỤ — stacked cards dày      │
│  Portfolio · Guide · Export · DCA · …       │  ← nhiều card dọc (lệch Hub-Content-Contract)
│  Backtest · Autopilot · Ladder · What-if …  │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

### 1.3 PROPOSED — Staking hub (tile model, ≤3 above fold)

```
┌─────────────────────────────────────────────┐
│ Staking / Earn                   [←]        │
│ Sinh lời · stake có rủi ro validator        │
├─────────────────────────────────────────────┤
│ HERO — tổng đang stake + lãi ước tính       │
│ [  Stake ngay  ]  [  Dashboard › ]           │  ← primary + EP-28
│ [ Tiết kiệm › ]                             │  ← bridge EP-16
├─────────────────────────────────────────────┤
│ [Sản phẩm●] [Vị thế]                        │
│ Filter + list (giữ product-first)           │
├─────────────────────────────────────────────┤
│ CÔNG CỤ STAKING (tile grid — HUB only)      │
│  [Phân tích][Lịch lãi][Lịch sử][Hướng dẫn]  │
│  [FAQ][Gợi ý][Thông báo][Stake alias]       │
├─────────────────────────────────────────────┤
│ [ Tài liệu & rủi ro › ]  → sheet 5 cụm GOM  │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

### 1.4 PROPOSED — Savings hub (tools = tiles, không stack card)

```
┌─────────────────────────────────────────────┐
│ Tiết kiệm                        [← Earn]   │
│ Gửi tiết kiệm · lãi sản phẩm                │
├─────────────────────────────────────────────┤
│ HERO — số dư TK + APR                       │
│ [  Gửi tiết kiệm  ]  [  Portfolio › ]       │  ← EP-29
├─────────────────────────────────────────────┤
│ [Sản phẩm●] [Của tôi] + filters             │
├─────────────────────────────────────────────┤
│ CÔNG CỤ TIẾT KIỆM (tile/chip — HUB)         │
│  [Phân tích][Lịch sử][Mục tiêu][Thang lãi]  │
│  [So sánh][Gợi ý][What-if][Autopilot] …     │
│  [⋯ Thêm] → sheet phần HUB còn lại          │
├─────────────────────────────────────────────┤
│ (không nhét 31 GOM vào Savings — chỉ Staking│
│  sheet Pháp lý Earn; Savings risk = ẨN flow)│
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade●] [Wallet] [Profile]│
└─────────────────────────────────────────────┘
```

**Tone Hub-Content-Contract:** hero + primary CTA + một block list **hoặc** tools — tránh vừa list dày vừa 10+ stacked insight cards above fold. Tools = `VitServiceTile` / chip grid; **không** card-stack cho mỗi HUB.

---

## 2. Section order

### 2.1 Staking Earn (`StakingEarnPage`) — current → proposed

| # | Section | Current widget | Proposed |
|--:|---------|----------------|----------|
| 1 | Header | `VitTopChrome` | Giữ; subtitle vi-VN đủ dấu |
| 2 | Hero | `_EarnHero` | Giữ + CTA «Stake» rõ |
| 3 | Bridge Savings | `VitCtaButton` → savings | Giữ; sửa copy «Tiết kiệm» |
| 4 | High-risk panel | `VitHighRiskStatePanel` | Giữ khi có contract |
| 5 | Tabs sản phẩm/vị thế | `_MainTabs` | Giữ |
| 6 | Filters + list | `_FilterRow` / `_ProductList` | Giữ product-first |
| 7 | **Công cụ Staking (HUB tiles)** | — **thiếu** | **Thêm** grid HUB |
| 8 | **Tài liệu & rủi ro** | — **thiếu** | **Thêm** entry → sheet 31 GOM |
| 9 | Disclaimer | `_YieldDisclaimer` | Giữ |
| 10 | Bottom nav | Shell | Active **Trade** (D1) |

### 2.2 Savings (`SavingsPage`) — current → proposed

| # | Section | Current | Proposed |
|--:|---------|---------|----------|
| 1 | Header | `VitHeader` | Giữ |
| 2 | Hero | `_SavingsHero` | Giữ + CTA «Gửi tiết kiệm» |
| 3 | Tabs + filters + list | products / my | Giữ |
| 4 | Tool insights | **Stacked cards** (guide/export/backtest/…) | **Đổi** → tile/chip grid + overflow sheet |
| 5 | Portfolio entry | Button/insight → EP-29 | Primary secondary CTA trên hero |
| 6 | Bottom nav | Shell | Active **Trade** (D1) |

Rhythm hiện `VitPageRhythm.standard` (không phải tab root bottom-nav). Khi coi là hub secondary, ưu tiên **compact** + ≤3 section above fold theo Hub-Content-Contract.

---

## 3. Dual entry map (EP-15 / 16 / 28 / 29)

| EP | Path | Page class | Phân loại | Entry điểm |
|----|------|------------|-----------|------------|
| EP-15 | `/earn` | `StakingEarnPage` | **GIỮ** | Home › Sinh lời › Staking; deep link |
| EP-16 | `/earn/savings` | `SavingsPage` | **GIỮ** | Home › Sinh lời › Tiết kiệm; CTA từ Earn |
| EP-28 | `/earn/dashboard` | `StakingDashboardPage` | **GIỮ** | Earn hub › Dashboard |
| EP-29 | `/earn/savings/portfolio` | `SavingsPortfolioPage` | **GIỮ** | Savings hub › Portfolio |

Alias HUB: `/earn/staking` cũng `StakingEarnPage` (tile/tab trong Earn hub).

---

## 4. Cây menu đầy đủ — GIỮ + HUB + GOM

```text
EARN FAMILY
│
├─ STAKING HUB (/earn) [EP-15] — GIỮ — StakingEarnPage
│  ├─ Dashboard → /earn/dashboard [GIỮ] StakingDashboardPage [EP-28]
│  ├─ Bridge → /earn/savings [GIỮ] SavingsPage [EP-16]
│  │
│  ├─ Công cụ Staking [HUB tiles]
│  │  ├─ /earn/analytics → StakingAnalyticsPage [HUB]
│  │  ├─ /earn/calendar → StakingEarningsCalendarPage [HUB]
│  │  ├─ /earn/faq → StakingFAQPage [HUB]
│  │  ├─ /earn/guide → StakingGuidePage [HUB]
│  │  ├─ /earn/history → StakingHistoryPage [HUB]
│  │  ├─ /earn/notifications → StakingNotificationsPage [HUB]
│  │  ├─ /earn/recommendations → StakingRecommendationsPage [HUB]
│  │  └─ /earn/staking → StakingEarnPage [HUB] (alias landing)
│  │
│  ├─ Tài liệu & rủi ro → sheet (31 GOM) ──► §4.3
│  │
│  └─ ẨN flow (không menu hub)
│     ├─ /earn/auto-compound → StakingAutoCompoundPage
│     ├─ /earn/custody → StakingCustodyPage
│     ├─ /earn/insurance → StakingInsurancePage
│     ├─ /earn/staking-risk-assessment → StakingRiskAssessmentPage
│     └─ /earn/validator-selection → StakingValidatorSelectionPage
│
└─ SAVINGS HUB (/earn/savings) [EP-16] — GIỮ — SavingsPage
   ├─ Portfolio → /earn/savings/portfolio [GIỮ] SavingsPortfolioPage [EP-29]
   │
   ├─ Công cụ Tiết kiệm [HUB tiles]  ← tách khỏi Staking tiles
   │  ├─ /earn/savings/analytics → SavingsAnalyticsPage [HUB]
   │  ├─ /earn/savings/auto-pilot → SavingsAutoPilotPage [HUB]
   │  ├─ /earn/savings/backtest → SavingsBacktestPage [HUB]
   │  ├─ /earn/savings/comparison → SavingsComparisonPage [HUB]
   │  ├─ /earn/savings/export → SavingsExportPage [HUB]
   │  ├─ /earn/savings/faq → SavingsFAQPage [HUB]
   │  ├─ /earn/savings/goals → SavingsGoalPage [HUB]
   │  ├─ /earn/savings/guide → SavingsGuidePage [HUB]
   │  ├─ /earn/savings/history → SavingsHistoryPage [HUB]
   │  ├─ /earn/savings/ladder → SavingsLadderPage [HUB]
   │  ├─ /earn/savings/notifications → SavingsNotificationsPage [HUB]
   │  ├─ /earn/savings/rebalance → SavingsAutoRebalancePage [HUB]
   │  ├─ /earn/savings/recommendations → SavingsRecommendationsPage [HUB]
   │  ├─ /earn/savings/smart-suggestions → SavingsSmartSuggestionsPage [HUB]
   │  └─ /earn/savings/what-if → SavingsWhatIfPage [HUB]
   │
   └─ ẨN flow (không menu)
      ├─ auto-compound settings, dca, notification-preferences
      ├─ product sample, receipt, redeem/:id
      └─ risk-assessment (SavingsRiskAssessmentPage)
```

### 4.1 GIỮ (4)

| Path | Page class | EP | Menu |
|------|------------|-----|------|
| `/earn` | `StakingEarnPage` | EP-15 | Home › Sinh lời + Earn root |
| `/earn/dashboard` | `StakingDashboardPage` | EP-28 | Earn hub › Dashboard |
| `/earn/savings` | `SavingsPage` | EP-16 | Home › Sinh lời + bridge từ Earn |
| `/earn/savings/portfolio` | `SavingsPortfolioPage` | EP-29 | Savings hub › Portfolio |

### 4.2 HUB Staking vs Savings (tách rõ)

| Nhóm | Số HUB | UI |
|------|-------:|----|
| Staking hub tiles | 8 (analytics, calendar, faq, guide, history, notifications, recommendations, staking alias) | Chỉ trên `/earn` |
| Savings hub tools | 15 | Chỉ trên `/earn/savings` — **không** trộn tile Staking |

### 4.3 GOM — đủ **31** dưới sheet «Tài liệu & rủi ro» (Earn / Staking)

Grouped ~5 clusters. Mỗi dòng: path key · page class · **GOM**.

#### Cụm A — Pháp lý & điều khoản (6)

| # | Path (`AppRoutePaths`) | Page class |
|--:|------------------------|------------|
| 1 | `earnStakingTerms` | `StakingTermsPage` |
| 2 | `earnStakingRiskDisclosure` | `StakingRiskDisclosurePage` |
| 3 | `earnStakingWithdrawalPolicy` | `StakingWithdrawalPolicyPage` |
| 4 | `earnStakingTaxGuide` | `StakingTaxGuidePage` |
| 5 | `earnSuitabilityAssessment` | `StakingSuitabilityAssessmentPage` |
| 6 | `earnRegulatoryFramework` | `StakingRegulatoryFrameworkPage` |

#### Cụm B — Rủi ro validator & vận hành (8)

| # | Path | Page class |
|--:|------|------------|
| 7 | `earnRiskDashboard` | `StakingRiskDashboardPage` |
| 8 | `earnRiskScoreCalculator` | `StakingRiskScoreCalculatorPage` |
| 9 | `earnValidatorHealthMonitor` | `StakingValidatorHealthMonitorPage` |
| 10 | `earnSlashingHistory` | `StakingSlashingHistoryPage` |
| 11 | `earnContingencyPlan` | `StakingContingencyPlanPage` |
| 12 | `earnEmergencyActions` | `StakingEmergencyActionsPage` |
| 13 | `earnLiquidStaking` | `StakingLiquidStakingPage` |
| 14 | `earnMultiChain` | `StakingMultiChainPage` |

#### Cụm C — Minh bạch quỹ & báo cáo (6)

| # | Path | Page class |
|--:|------|------------|
| 15 | `earnProofOfReserves` | `StakingProofOfReservesPage` |
| 16 | `earnInsuranceFundTransparency` | `StakingInsuranceFundTransparencyPage` |
| 17 | `earnAuditReports` | `StakingAuditReportsPage` |
| 18 | `earnTransactionReporting` | `StakingTransactionReportingPage` |
| 19 | `earnDataExport` | `StakingDataExportPage` |
| 20 | `earnAdvancedOrders` | `StakingAdvancedOrdersPage` |

#### Cụm D — Developer / tích hợp (4)

| # | Path | Page class |
|--:|------|------------|
| 21 | `earnApiDocumentation` | `StakingApiDocumentationPage` |
| 22 | `earnDeveloperConsole` | `StakingDeveloperConsolePage` |
| 23 | `earnWebhooks` | `StakingWebhooksPage` |
| 24 | `earnThirdPartyIntegrations` | `StakingThirdPartyIntegrationsPage` |

#### Cụm E — Cộng đồng & quản trị (7)

| # | Path | Page class |
|--:|------|------------|
| 25 | `earnCommunityGovernance` | `StakingCommunityGovernancePage` |
| 26 | `earnForum` | `StakingForumPage` |
| 27 | `earnSocialFeed` | `StakingSocialFeedPage` |
| 28 | `earnProposals` | `StakingProposalsPage` |
| 29 | `earnVoting` | `StakingVotingPage` |
| 30 | `earnVotingProposalRoute` | `StakingVotingPage` (deep proposal) |
| 31 | `earnInstitutional` | `StakingInstitutionalPage` |

**Đếm:** 6+8+6+4+7 = **31 GOM** — khớp thống kê `06-earn.md`.

Sheet UI (proposed):

```
┌─ Tài liệu & rủi ro ─────────────────────────┐
│ A. Pháp lý & điều khoản          (6) ›      │
│ B. Rủi ro validator & vận hành   (8) ›      │
│ C. Minh bạch quỹ & báo cáo      (6) ›      │
│ D. Developer / tích hợp          (4) ›      │
│ E. Cộng đồng & quản trị          (7) ›      │
└─────────────────────────────────────────────┘
```

Mỗi cụm → list rows `VitActionTile` / nav list; **không** gắn 31 tile lên hub surface.

---

## 5. Current vs proposed

| Item | Current | Proposed |
|------|---------|----------|
| Hub model Staking | Product list-first; HUB tools yếu/không | Giữ list; **thêm** HUB tile grid + legal sheet |
| Hub model Savings | List + **stacked insight cards** | List + **tile/chip tools** (Hub-Content-Contract) |
| Staking vs Savings tools | Dễ lẫn cross-link | **Tách** tile sets; bridge CTA chỉ 1 chiều rõ |
| EP-28 Dashboard | Route GIỮ; entry mờ | Secondary CTA trên Earn hero |
| EP-29 Portfolio | Có button/insight | Hero secondary CTA |
| 31 GOM | Routes tồn tại; **không** sheet menu | Earn sheet «Tài liệu & rủi ro» 5 cụm |
| Active tab | Trade (D1) | **Giữ** — detail file 18 |
| Copy English residual | Một số panel/fixture | vi-VN khi chạm file (ngoài P0 docs) |

---

## 6. Empty / loading / error rules

| State | Staking (`StakingEarnPage`) | Savings (`SavingsPage`) |
|-------|----------------------------|-------------------------|
| **Loading** | `VitSkeletonList` + chrome «Đang tải…» | Cùng pattern |
| **Error** | `VitErrorState` + invalidate `stakingEarnSnapshotProvider` | Invalidate `savingsSnapshotProvider` / controller |
| **Empty products** | Empty trong `_ProductList` + CTA đổi filter | Empty + CTA bỏ filter |
| **Empty positions** | `_PositionsList` empty + «Khám phá sản phẩm» | Tab «Của tôi» empty + CTA gửi tiết kiệm |
| **High-risk** | Panel + preview/confirm trước stake | Savings risk pages = ẨN flow; confirm khi redeem/send |
| **Success** | `showVitNoticeSheet` | Cùng chuẩn notice-ack |
| **Legal sheet empty** | N/A hôm nay | Proposed: luôn list 31; offline = error trong sheet |

---

## 7. File mapping (widget → section)

| File | Section / responsibility |
|------|--------------------------|
| `pages/staking/staking_earn_page.dart` | Earn root composition, tabs, filters |
| `widgets/staking/staking_earn_hero_tabs.dart` | Hero + main tabs (part) |
| `widgets/staking/staking_earn_products.dart` | Product list (part) |
| `widgets/staking/staking_earn_positions_common.dart` | Positions + disclaimer (part) |
| `pages/staking/staking_dashboard_page.dart` | EP-28 dashboard |
| `pages/savings/savings_page.dart` | Savings root |
| `widgets/savings/savings_home_hero.dart` | Hero (part) |
| `widgets/savings/savings_home_products.dart` | Products (part) |
| `widgets/savings/savings_home_positions.dart` | My positions (part) |
| `widgets/savings/savings_home_common.dart` | Insight/tool cards (part) — **target trim → tiles** |
| `pages/savings/savings_portfolio_page.dart` | EP-29 |
| `app/providers/earn_controller_providers.dart` | Snapshots / controllers |
| **Proposed** | `…/earn_legal_risk_sheet.dart` (hoặc shared sheet) — 5 cụm × 31 GOM |

---

## 8. Open decisions

1. **Earn rhythm:** giữ `standard` hay chuyển `compact` cho hub secondary? Đề xuất: compact khi thêm tools section.  
2. **Visible Savings tiles:** bao nhiêu above fold (≤6) vs «⋯ Thêm» cho 15 HUB?  
3. **GOM institutional / developer:** có ẩn sau KYC/role gate trong sheet không? (mặc định: hiện đủ 31, soft = empty state trang đích).  
4. **Voting dual route** (`earnVoting` + `earnVotingProposalRoute`): một row sheet hay hai? Đề xuất **hai** để khớp 31.  
5. Sửa copy Earn CTA «Tiet kiem» → «Tiết kiệm» khi chạm code (không trong batch docs này).

---

## 9. Gaps / reachability notes

| Gap | Severity | Note |
|-----|----------|------|
| Legal/risk sheet UI missing | **P2** | 31 GOM không có menu inbound; STEP earn legal |
| Staking HUB tiles missing on `/earn` | **P2** | Analytics/calendar/… chỉ deep link / Home tree |
| Savings stacked cards vs tile contract | **P2** | Hub-Content-Contract density |
| EP-28 / EP-29 chrome yếu | P2 | Hero secondary CTAs |
| D1 Trade highlight trên `/earn*` | OK by lock | Chi tiết file **18** |
| ẨN validator-selection / custody / insurance | OK | Flow only; không promote |

---

## 10. Thống kê module Earn (từ `06-earn.md`)

| Phân loại | Số |
|-----------|---:|
| GIỮ | 4 |
| HUB | 23 |
| **GOM** | **31** (đủ trong §4.3) |
| ẨN | 12 |
| Tổng routes | 70 |

**Verify GOM in tree:** cụm A6 + B8 + C6 + D4 + E7 = **31** — tất cả xuất hiện trong §4.3.

**Separation reminder:** Staking hub tiles ≠ Savings hub tools; 31 GOM chỉ gắn Earn legal sheet (không nhân đôi dưới Savings).
