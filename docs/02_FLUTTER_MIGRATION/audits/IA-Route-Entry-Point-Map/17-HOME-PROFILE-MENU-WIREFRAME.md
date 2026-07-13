# Wireframe text — Cây menu Home & Profile

Generated: 2026-07-13  
Nguồn: cột **Menu UI đề xuất** trong [`99-ALL-ROUTES.md`](./99-ALL-ROUTES.md)  
Phạm vi: **Home shell** + **Profile shell** (§1–2); **cây menu đầy đủ 196 route** GIỮ/HUB/GOM (§6).

---

## 1. Home — Wireframe tổng thể (360×800, phone-first)

```
┌─────────────────────────────────────────────┐
│ [Avatar] VitTrade          [🔍] [🔔] [📰] │  ← Header: Search, Notifications, News
├─────────────────────────────────────────────┤
│ HERO — Tổng tài sản + PnL 24h               │
│  [  Nạp tiền  ]  [  Rút tiền  ]             │  ← Hero CTA (EP-08, EP-09)
├─────────────────────────────────────────────┤
│ NEXT ACTION (1 card contextual)              │  ← Ví dụ: hoàn tất rút USDT
├─────────────────────────────────────────────┤
│ HÀNH ĐỘNG NHANH (4 ô — tier compact)         │  ← Chỉ 4 ô visible; "Xem thêm" mở sheet
│  [Mua nhanh] [Convert] [Nạp/Rút] [P2P]       │
├─────────────────────────────────────────────┤
│ SẢN PHẨM — Giao dịch          [Xem tất cả ›] │
│  ┌──────┐ ┌──────┐ ┌──────┐                  │
│  │Margin│ │Convert│ │ P2P  │                  │
│  └──────┘ └──────┘ └──────┘                  │
├─────────────────────────────────────────────┤
│ SẢN PHẨM — Pro                [Xem tất cả ›] │
│  ┌──────────┐ ┌──────────┐                  │
│  │Copy Trade│ │   Bot    │  (badge rủi ro)   │
│  └──────────┘ └──────────┘                  │
├─────────────────────────────────────────────┤
│ SẢN PHẨM — Sinh lời           [Xem tất cả ›] │
│  ┌────────┐ ┌─────────┐ ┌─────┐             │
│  │ Staking│ │Tiết kiệm│ │ DCA │             │
│  └────────┘ └─────────┘ └─────┘             │
├─────────────────────────────────────────────┤
│ SẢN PHẨM — Khám phá           [Xem tất cả ›] │
│  ┌──────────┐ ┌────────┐ ┌────────┐          │
│  │Launchpad │ │Rewards │ │ Topics │          │
│  └──────────┘ └────────┘ └────────┘          │
├─────────────────────────────────────────────┤
│ DISCOVERY (product boundary)                 │
│  ┌─────────────────┐ ┌─────────────────┐    │
│  │  Predictions    │ │     Arena       │    │
│  │  (wallet/PnL)   │ │  (points only)  │    │
│  └─────────────────┘ └─────────────────┘    │
├─────────────────────────────────────────────┤
│ THỊ TRƯỜNG (watchlist / movers — existing)   │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade] [Wallet] [Profile]  │  ← Bottom Nav (5 tab)
└─────────────────────────────────────────────┘
```

### 1.1 Home — Cây menu đầy đủ (chỉ route có menu)

```text
HOME (/home) [EP-01]
│
├─ Header
│  ├─ Tìm kiếm (/search) [EP-06, GIỮ]
│  ├─ Thông báo (/notifications) [EP-07, GIỮ]
│  └─ Tin tức (/news) [EP-30, GIỮ]
│
├─ Hero CTA
│  ├─ Nạp tiền (/wallet/deposit) [EP-08, GIỮ]
│  └─ Rút tiền (/wallet/withdraw) [EP-09, GIỮ]
│
├─ Hành động nhanh (sheet "Xem thêm" — tối đa 9 ô standard)
│  ├─ [compact 4] Mua nhanh → /trade (Bottom Nav Trade)
│  ├─ Convert → /trade/convert
│  ├─ Nạp/Rút → /wallet
│  └─ P2P → /p2p
│
├─ Sản phẩm › Giao dịch
│  ├─ p2p → `AppRoutePaths.p2p` [GIỮ]
│  ├─ tradeConvert → `AppRoutePaths.tradeConvert` [GIỮ]
│  ├─ tradeMargin → `AppRoutePaths.tradeMargin` [GIỮ]
│  │
│  └─ [tap Margin] ──► Margin hub (/trade/margin) [EP-11]
│       ├─ AdvancedAnalyticsPage [HUB]
│       ├─ MarginTradingHubPage [HUB]
│
├─ Sản phẩm › Pro
│  ├─ tradeBots → `AppRoutePaths.tradeBots` [GIỮ]
│  ├─ tradeCopyTrading → `AppRoutePaths.tradeCopyTrading` [GIỮ]
│  │
│  ├─ [tap Copy] ──► Copy Trading hub
│  │    ├─ CopyAuditLogPage [GOM] → `'/trade/copy-audit-log/:copyId'`
│  │    ├─ CopyPerformancePage [HUB] → `'/trade/copy-performance/:copyId'`
│  │    ├─ PerformanceAttributionPage [HUB] → `'/trade/copy-performance/:copyId/attribution'`
│  │    ├─ ProviderComparisonPage [HUB] → `AppRoutePaths.tradeCopyComparison`
│  │    ├─ ProviderLeaderboardPage [HUB] → `AppRoutePaths.tradeCopyLeaderboard`
│  │    ├─ CopyNotificationsPage [HUB] → `AppRoutePaths.tradeCopyNotifications`
│  │    ├─ ProviderGovernancePage [GOM] → `AppRoutePaths.tradeCopyProviderGovernance`
│  │    ├─ PortfolioRiskAnalysisPage [HUB] → `AppRoutePaths.tradeCopyRiskAnalysis`
│  └─ [tap Bot] ──► Bots hub
│       ├─ BotBacktestingPage [HUB]
│       ├─ BotFaqPage [HUB]
│       ├─ BotGuidePage [HUB]
│       ├─ BotHistoryPage [HUB]
│       ├─ BotPerformanceAnalyticsPage [HUB]
│       ├─ BotPortfolioDashboardPage [HUB]
│
├─ Sản phẩm › Sinh lời
│  ├─ dca → `AppRoutePaths.dca` [GIỮ]
│  ├─ earn → `AppRoutePaths.earn` [GIỮ]
│  ├─ earnSavings → `AppRoutePaths.earnSavings` [GIỮ]
│  │
│  ├─ [tap Staking/Earn] ──► Earn hub
│  │    ├─ StakingAnalyticsPage [HUB]
│  │    ├─ StakingEarningsCalendarPage [HUB]
│  │    ├─ StakingDashboardPage [GIỮ]
│  │    ├─ StakingFAQPage [HUB]
│  │    ├─ StakingGuidePage [HUB]
│  │    ├─ StakingHistoryPage [HUB]
│  │    ├─ StakingNotificationsPage [HUB]
│  │    ├─ StakingRecommendationsPage [HUB]
│  │    ├─ StakingEarnPage [HUB]
│  │    └─ Dashboard → earnDashboard [GIỮ, EP-28]
│  │    └─ Tài liệu & rủi ro (sheet Pháp lý Earn) — 31 màn GOM
│  ├─ [tap Savings] ──► Savings hub
│  │    ├─ SavingsAnalyticsPage [HUB]
│  │    ├─ SavingsAutoPilotPage [HUB]
│  │    ├─ SavingsBacktestPage [HUB]
│  │    ├─ SavingsComparisonPage [HUB]
│  │    ├─ SavingsExportPage [HUB]
│  │    ├─ SavingsFAQPage [HUB]
│  │    ├─ SavingsGoalPage [HUB]
│  │    ├─ SavingsGuidePage [HUB]
│  │    ├─ SavingsHistoryPage [HUB]
│  │    ├─ SavingsLadderPage [HUB]
│  │    ├─ SavingsNotificationsPage [HUB]
│  │    ├─ SavingsPortfolioPage [GIỮ]
│  │    ├─ SavingsAutoRebalancePage [HUB]
│  │    ├─ SavingsRecommendationsPage [HUB]
│  │    ├─ SavingsSmartSuggestionsPage [HUB]
│  │    ├─ SavingsWhatIfPage [HUB]
│  └─ [tap DCA] ──► DCA hub
│       ├─ DCARebalanceConfig [HUB]
│       ├─ DCARebalanceDashboard [HUB]
│       ├─ DCABacktesterPage [HUB]
│       ├─ DCAPerformanceComparePage [HUB]
│       ├─ DCAPortfolioOptimizer [HUB]
│       ├─ DCARebalanceConfig [HUB]
│       ├─ DCARebalanceDashboard [HUB]
│       ├─ DCAScheduleAnalytics [HUB]
│       ├─ DCAScheduleConfig [HUB]
│       ├─ DCASmartRulesPage [HUB]
│
├─ Sản phẩm › Khám phá
│  ├─ launchpad → `AppRoutePaths.launchpad` [GIỮ]
│  ├─ rewards → `AppRoutePaths.rewards` [GIỮ]
│  ├─ topics → `AppRoutePaths.topics` [GIỮ]
│  └─ [tap Launchpad] ──► Launchpad hub
│       ├─ LaunchpadPerformancePage [HUB]
│       ├─ LaunchpadPortfolioPage [HUB]
│       ├─ LaunchpadRebalancePage [HUB]
│       ├─ LaunchpadRiskAnalyticsPage [HUB]
│
├─ Discovery (tách section — không trộn Sinh lời)
│  ├─ arena → `AppRoutePaths.arena` [GIỮ]
│  ├─ marketsPredictions → `AppRoutePaths.marketsPredictions` [GIỮ]
│  ├─ [tap Predictions] ──► Predictions hub
│  │    ├─ PredictionAdvancedChartPage [HUB]
│  │    ├─ PredictionEventCalendarPage [HUB]
│  │    ├─ PredictionsLeaderboardPage [HUB]
│  │    ├─ PredictionsPortfolioPage [HUB]
│  │    ├─ PredictionPortfolioAnalyzerPage [HUB]
│  └─ [tap Arena] ──► Arena hub
│       ├─ ArenaGuidePage [HUB]
│       ├─ ArenaLeaderboardPage [HUB]
│       ├─ ArenaStudioPage [HUB]
│       ├─ ArenaUniversalPresetLibraryPage [HUB]
│       ├─ ArenaSmartRuleBuilderPage [HUB]
│
└─ Bottom Nav (rời Home)
   ├─ Markets (/markets) [EP-02]
   ├─ Trade (/trade) [EP-03] ──► tab Lệnh, Vị thế, công cụ Spot
   ├─ Wallet (/wallet) [EP-04]
   └─ Profile (/profile) [EP-05] ──► xem §2
```

---

## 2. Profile — Wireframe tổng thể

```
┌─────────────────────────────────────────────┐
│ ← Profile                    [⚙ Cài đặt]   │
├─────────────────────────────────────────────┤
│ [Avatar] User · VIP tier                     │
│ ┌─────────────────────────────────────────┐ │
│ │ ⚠ Hoàn tất KYC để nâng hạn mức  [Xác minh]│ │  ← Banner EP-33
│ └─────────────────────────────────────────┘ │
├─────────────────────────────────────────────┤
│ TÀI KHOẢN                                    │
│  Chỉnh sửa hồ sơ · Thiết bị · API · Sub-acct │  ← ẨN flow từ đây
│  VIP · Hoạt động · Arena của tôi             │
├─────────────────────────────────────────────┤
│ BẢO MẬT                                      │
│  Bảo mật & 2FA (/settings/security) [EP-32]  │
├─────────────────────────────────────────────┤
│ PORTFOLIO NÂNG CAO                           │
│  Tổng quan đa module (/unified-portfolio)    │
│  Analytics · Cảnh báo thông minh · Thuế      │
├─────────────────────────────────────────────┤
│ GIỚI THIỆU & PHẦN THƯỞNG                     │
│  Mời bạn bè (/referral) [EP-23]              │
├─────────────────────────────────────────────┤
│ HỖ TRỢ                                       │
│  Trung tâm hỗ trợ (/support) [EP-24]         │
├─────────────────────────────────────────────┤
│ PHÁP LÝ & BÁO CÁO              [Mở rộng ▼]  │  ← GOM 39+ route
│  (compliance, audit, khiếu nại, MiFID II…)   │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade] [Wallet] [Profile]  │
└─────────────────────────────────────────────┘
```

### 2.1 Profile — Cây menu đầy đủ

```text
PROFILE (/profile) [EP-05, GIỮ]
│
├─ Banner / Entry trực tiếp
│  └─ KYC (/profile/kyc) [EP-33, GIỮ]
│
├─ Tài khoản (flow — không EP riêng, mở từ Profile)
│  ├─ ActivityLogPage → `AppRoutePaths.profileActivity` [ẨN]
│  ├─ ApiManagementPage → `AppRoutePaths.profileApi` [ẨN]
│  ├─ ApiKeyCreatePage → `AppRoutePaths.profileApiCreate` [ẨN]
│  ├─ MyArenaPage → `AppRoutePaths.profileArena` [ẨN]
│  ├─ DeviceManagementPage → `AppRoutePaths.profileDevices` [ẨN]
│  ├─ EditProfilePage → `AppRoutePaths.profileEdit` [ẨN]
│  ├─ SettingsPage → `AppRoutePaths.profileSettings` [ẨN]
│  ├─ SubAccountPage → `AppRoutePaths.profileSubAccounts` [ẨN]
│  ├─ VIPPage → `AppRoutePaths.profileVip` [ẨN]
│  └─ Predictions portfolio (profile) [HUB]
│
├─ Bảo mật
│  └─ Security (/settings/security) [EP-32, GIỮ]
│
├─ Portfolio nâng cao [EP-34]
│  ├─ Unified Portfolio Dashboard [GIỮ]
│  ├─ CrossModuleAnalytics [HUB]
│  ├─ SmartAlertCenter [HUB]
│  └─ Tax reports [ẨN — flow từ hub thuế]
│
├─ Giới thiệu [EP-23]
│  ├─ Referral home [GIỮ]
│  └─ ReferralHistoryPage [HUB]
│
├─ Hỗ trợ [EP-24]
│  ├─ Support home [GIỮ]
│
└─ Pháp lý & báo cáo (GOM — accordion / search trong Profile)
   ├─ Copy / Trade compliance (29)
   │  ├─ ComplaintTrackingPage
   │  ├─ ArmIntegrationStatusPage
   │  ├─ AuditTrailPage
   │  ├─ BestExecutionReportsPage
   │  ├─ CassReconciliationPage
   │  ├─ ClientCategorizationPage
   │  ├─ ClientMoneyProtectionPage
   │  ├─ ClientOptUpRequestPage
   │  ├─ ComplaintsHandlingPage
   │  ├─ ComplaintSubmissionPage
   │  ├─ ComplaintTrackingPage
   │  ├─ ExAnteCostsPage
   │  ├─ ExecutionVenueAnalysisPage
   │  ├─ ExPostCostsReportPage
   │  ├─ InvestorCompensationPage
   │  ├─ KIDGeneratorPage
   │  ├─ OmbudsmanReferralPage
   │  ├─ PerformanceScenariosPage
   │  ├─ ProductGovernancePage
   │  ├─ RegulatoryDisclosuresPage
   │  ├─ RegulatoryInspectionReadyPage
   │  ├─ RegulatoryReportsDashboardPage
   │  ├─ RiskIndicatorExplainerPage
   │  ├─ RIYCalculatorPage
   │  ├─ SlippageMonitoringPage
   │  ├─ TargetMarketDefinitionPage
   │  ├─ TransactionReportingPage
   │  ├─ LiveMarketDataAnalyticsPage
   │  ├─ MarketDataAnalyticsPage
   ├─ Bots compliance (6)
   │  ├─ BotApiDocumentationPage
   │  ├─ BotEmergencyStopPage
   │  ├─ BotRiskDashboardPage
   │  ├─ BotRiskDisclosurePage
   │  ├─ BotSuitabilityAssessmentPage
   │  ├─ BotTermsOfServicePage
   ├─ P2P / Launchpad / Arena (4)
   │  ├─ ArenaGovernanceGatePage
   │  ├─ LaunchpadWebhooksPage
   │  ├─ P2PInsuranceFundPage
   │  ├─ P2PInsuranceFundPage
```

---

## 3. So sánh với `home_mock_data.dart` (hiện tại)

| | Code hiện tại | Wireframe đề xuất |
|---|---------------|-------------------|
| Quick actions | 17 mục, 6–9 visible | 4 compact + sheet; sản phẩm theo **4 nhóm** |
| Nhóm sản phẩm | Phẳng — không nhóm | Giao dịch / Pro / Sinh lời / Khám phá |
| Discovery | Lẫn trong quick actions | Section riêng (Predictions + Arena) |
| Hỗ trợ / Giới thiệu | Trên Home quick actions | Chuyển **Profile** (giảm clutter Home) |
| Compliance (39 route) | Không có menu | Profile › Pháp lý & báo cáo (accordion) |
| Earn legal (31 route) | Rải rác | Earn hub › Tài liệu & rủi ro (sheet) |

### 3.1 Mapping quick action → nhóm wireframe

| Quick action (mock) | Route | Nhóm wireframe |
|---------------------|-------|----------------|
| Mua nhanh | `/trade/btcusdt` | Hành động nhanh → Trade tab |
| Convert | `/trade/convert` | Sản phẩm Giao dịch |
| Nạp/Rút | `/wallet` | Hero + Wallet |
| P2P | `/p2p` | Sản phẩm Giao dịch |
| Mua định kỳ | `/dca` | Sản phẩm Sinh lời |
| Staking | `/earn/staking` | Sản phẩm Sinh lời → Earn hub |
| Tiết kiệm | `/earn/savings` | Sản phẩm Sinh lời |
| Launchpad | `/launchpad` | Sản phẩm Khám phá |
| Dự đoán | `/markets/predictions` | Discovery |
| Arena | `/arena` | Discovery |
| Phần thưởng | `/rewards` | Sản phẩm Khám phá |
| Hỗ trợ | `/support` | **Profile** (đề xuất dời) |
| Margin | `/trade/margin` | Sản phẩm Giao dịch |
| Bot | `/trade/bots` | Sản phẩm Pro |
| Copy Trade | `/trade/copy-trading` | Sản phẩm Pro |
| Khám phá | `/topics` | Sản phẩm Khám phá |
| Giới thiệu | `/referral` | **Profile** (đề xuất dời) |

---

## 4. Thống kê menu

| Phạm vi | Route có menu (GIỮ+HUB+GOM) |
|---------|----------------------------:|
| **Toàn app** (§6 — đầy đủ) | **196** |
| Home + hub con (§1) | ~144 |
| Profile + legal GOM (§2) | ~48 |
| **ẨN** (không trên menu) | 205 |
| **DEV** (ẩn production) | 12 |

---

## 5. Ghi chú triển khai (không code — chỉ IA)

1. **Home không cần thêm route** — chỉ tái cấu trúc UI shell + `home_mock_data` group labels.
2. **"Xem tất cả"** mở bottom sheet hoặc full-screen grid — không push 17 route lên Home.
3. **Pháp lý & báo cáo** nên có search + nhóm theo module (Copy, Bots, P2P, Earn).
4. **Futures** (EP-10) không có route tĩnh — entry qua Trade tab chọn cặp hoặc Markets › Derivatives.
5. **Support + Referral** trên Home hiện tại → dời Profile giúp Home còn ~11 product tiles thay vì 17 ô phẳng.


---

## 6. Cây menu text đầy đủ — 196 route (GIỮ / HUB / GOM)

> Liệt kê **toàn bộ** route có vị trí menu. ẨN (205) và DEV (12) **không** có trong cây này.
> Nguồn: [99-ALL-ROUTES.md](./99-ALL-ROUTES.md) — 196 dòng.

### 6.0 Tổng quan shell

```text
VitTrade App
├─ Global Header ............. Search, Notifications, News (3 GIỮ)
├─ Bottom Nav (5 tab) ........ Home · Markets · Trade · Wallet · Profile
├─ Home product sections ..... 13 GIỮ + hub drill-down
├─ Tab hubs .................. Markets(10) · Trade(4) · Wallet(2) · Margin(2) · ...
├─ Product hubs .............. Earn(8+31GOM) · Savings(15) · P2P(11) · DCA(10) · ...
└─ Profile registry .......... KYC · Security · Portfolio · Legal(39 GOM) · Support
```

### A. GLOBAL HEADER (mọi tab) (3)

```text
[GIỮ] NewsPage → news (EP-30)
[GIỮ] NotificationsPage → notifications (EP-07)
[GIỮ] UnifiedSearchPage → search (EP-06)
```

### B. BOTTOM NAV → HOME (EP-01) (1)

```text
[GIỮ] HomePage → home (EP-01)
```

### C. HOME — Hero & Next action (2)

```text
[GIỮ] DepositPage → walletDeposit (EP-08)
[GIỮ] WithdrawPage → walletWithdraw (EP-09)
```

### D. HOME — Sản phẩm Giao dịch (3)

```text
[GIỮ] P2PHomePage → p2p (EP-17)
[GIỮ] ConvertPage → tradeConvert (EP-12)
[GIỮ] MarginTradingPage → tradeMargin (EP-11)
```

### E. HOME — Sản phẩm Pro (2)

```text
[GIỮ] TradingBotsPage → tradeBots (EP-14)
[GIỮ] CopyTradingPage → tradeCopyTrading (EP-13)
```

### F. HOME — Sản phẩm Sinh lời (3)

```text
[GIỮ] DCAPage → dca (EP-18)
[GIỮ] StakingEarnPage → earn (EP-15)
[GIỮ] SavingsPage → earnSavings (EP-16)
```

### G. HOME — Sản phẩm Khám phá (3)

```text
[GIỮ] LaunchpadPage → launchpad (EP-19)
[GIỮ] RewardsHubPage → rewards (EP-22)
[GIỮ] TopicHubPage → topics (EP-31)
```

### H. HOME — Discovery (2)

```text
[GIỮ] ArenaHomePage → arena (EP-21)
[GIỮ] PredictionsHomePage → marketsPredictions (EP-20)
```

### I. BOTTOM NAV → MARKETS (EP-02) (1)

```text
[GIỮ] MarketListPage → markets (EP-02)
```

### J. MARKETS HUB — Công cụ & danh sách (10)

```text
[HUB] AdvancedChartsPage → marketsAdvancedCharts (EP-02)
[HUB] MarketCalendarPage → marketsCalendar (EP-02)
[HUB] ComparisonToolPage → marketsCompare (EP-02)
[HUB] DerivativesOverviewPage → marketsDerivatives (EP-02)
[HUB] MarketHeatmapPage → marketsHeatmap (EP-02)
[HUB] MarketMoversPage → marketsMovers (EP-02)
[HUB] MarketOverviewPage → marketsOverview (EP-02)
[HUB] PortfolioTrackerPage → marketsPortfolioTracker (EP-02)
[HUB] MarketScreenerPage → marketsScreener (EP-02)
[HUB] WatchlistPage → marketsWatchlist (EP-02)
```

### K. BOTTOM NAV → TRADE (EP-03) (1)

```text
[GIỮ] TradePage → trade (EP-03)
```

### L. TRADE HUB — Lệnh & Vị thế & Spot (4)

```text
[HUB] AdvancedChartPage → /trade/advanced-chart/:pairId (EP-03)
[HUB] TradeHistoryExportPage → tradeExport (EP-03)
[GIỮ] OrdersHistoryPage → tradeOrdersHistory (EP-26)
[GIỮ] PositionDashboardPage → tradePositions (EP-27)
```

### M. MARGIN HUB (2)

```text
[HUB] AdvancedAnalyticsPage → tradeMarginAdvancedAnalytics (EP-11)
[HUB] MarginTradingHubPage → tradeMarginHub (EP-11)
```

### N. COPY TRADING HUB (8)

```text
[GOM] CopyAuditLogPage → /trade/copy-audit-log/:copyId (EP-13)
[HUB] CopyPerformancePage → /trade/copy-performance/:copyId (EP-13)
[HUB] PerformanceAttributionPage → /trade/copy-performance/:copyId/attribution (EP-13)
[HUB] ProviderComparisonPage → tradeCopyComparison (EP-13)
[HUB] ProviderLeaderboardPage → tradeCopyLeaderboard (EP-13)
[HUB] CopyNotificationsPage → tradeCopyNotifications (EP-13)
[GOM] ProviderGovernancePage → tradeCopyProviderGovernance (EP-13)
[HUB] PortfolioRiskAnalysisPage → tradeCopyRiskAnalysis (EP-13)
```

### O. BOTS HUB (6)

```text
[HUB] BotBacktestingPage → tradeBotBacktesting (EP-14)
[HUB] BotFaqPage → tradeBotFaq (EP-14)
[HUB] BotGuidePage → tradeBotGuide (EP-14)
[HUB] BotHistoryPage → tradeBotHistory (EP-14)
[HUB] BotPerformanceAnalyticsPage → tradeBotPerformanceAnalytics (EP-14)
[HUB] BotPortfolioDashboardPage → tradeBotPortfolioDashboard (EP-14)
```

### P. BOTTOM NAV → WALLET (EP-04) (1)

```text
[GIỮ] WalletPage → wallet (EP-04)
```

### Q. WALLET HUB — Dịch vụ ví (2)

```text
[HUB] TransactionHistoryPage → walletHistory (EP-04)
[HUB] PortfolioAnalyticsPage → walletPortfolioAnalytics (EP-04)
```

### R. EARN / STAKING HUB (9)

```text
[HUB] StakingAnalyticsPage → earnAnalytics (EP-15)
[HUB] StakingEarningsCalendarPage → earnCalendar (EP-15)
[GIỮ] StakingDashboardPage → earnDashboard (EP-28)
[HUB] StakingFAQPage → earnFAQ (EP-15)
[HUB] StakingGuidePage → earnGuide (EP-15)
[HUB] StakingHistoryPage → earnHistory (EP-15)
[HUB] StakingNotificationsPage → earnNotifications (EP-15)
[HUB] StakingRecommendationsPage → earnRecommendations (EP-15)
[HUB] StakingEarnPage → earnStaking (EP-15)
```

### S. EARN — Tài liệu & rủi ro (GOM) (31)

```text
[GOM] StakingAdvancedOrdersPage → earnAdvancedOrders (EP-15)
[GOM] StakingApiDocumentationPage → earnApiDocumentation (EP-15)
[GOM] StakingAuditReportsPage → earnAuditReports (EP-15)
[GOM] StakingCommunityGovernancePage → earnCommunityGovernance (EP-15)
[GOM] StakingContingencyPlanPage → earnContingencyPlan (EP-15)
[GOM] StakingDataExportPage → earnDataExport (EP-15)
[GOM] StakingDeveloperConsolePage → earnDeveloperConsole (EP-15)
[GOM] StakingEmergencyActionsPage → earnEmergencyActions (EP-15)
[GOM] StakingForumPage → earnForum (EP-15)
[GOM] StakingInstitutionalPage → earnInstitutional (EP-15)
[GOM] StakingInsuranceFundTransparencyPage → earnInsuranceFundTransparency (EP-15)
[GOM] StakingLiquidStakingPage → earnLiquidStaking (EP-15)
[GOM] StakingMultiChainPage → earnMultiChain (EP-15)
[GOM] StakingProofOfReservesPage → earnProofOfReserves (EP-15)
[GOM] StakingProposalsPage → earnProposals (EP-15)
[GOM] StakingRegulatoryFrameworkPage → earnRegulatoryFramework (EP-15)
[GOM] StakingRiskDashboardPage → earnRiskDashboard (EP-15)
[GOM] StakingRiskScoreCalculatorPage → earnRiskScoreCalculator (EP-15)
[GOM] StakingSlashingHistoryPage → earnSlashingHistory (EP-15)
[GOM] StakingSocialFeedPage → earnSocialFeed (EP-15)
[GOM] StakingRiskDisclosurePage → earnStakingRiskDisclosure (EP-15)
[GOM] StakingTaxGuidePage → earnStakingTaxGuide (EP-15)
[GOM] StakingTermsPage → earnStakingTerms (EP-15)
[GOM] StakingWithdrawalPolicyPage → earnStakingWithdrawalPolicy (EP-15)
[GOM] StakingSuitabilityAssessmentPage → earnSuitabilityAssessment (EP-15)
[GOM] StakingThirdPartyIntegrationsPage → earnThirdPartyIntegrations (EP-15)
[GOM] StakingTransactionReportingPage → earnTransactionReporting (EP-15)
[GOM] StakingValidatorHealthMonitorPage → earnValidatorHealthMonitor (EP-15)
[GOM] StakingVotingPage → earnVoting (EP-15)
[GOM] StakingVotingPage → earnVotingProposalRoute (EP-15)
[GOM] StakingWebhooksPage → earnWebhooks (EP-15)
```

### T. SAVINGS HUB (16)

```text
[HUB] SavingsAnalyticsPage → earnSavingsAnalytics (EP-16)
[HUB] SavingsAutoPilotPage → earnSavingsAutoPilot (EP-16)
[HUB] SavingsBacktestPage → earnSavingsBacktest (EP-16)
[HUB] SavingsComparisonPage → earnSavingsComparison (EP-16)
[HUB] SavingsExportPage → earnSavingsExport (EP-16)
[HUB] SavingsFAQPage → earnSavingsFAQ (EP-16)
[HUB] SavingsGoalPage → earnSavingsGoals (EP-16)
[HUB] SavingsGuidePage → earnSavingsGuide (EP-16)
[HUB] SavingsHistoryPage → earnSavingsHistory (EP-16)
[HUB] SavingsLadderPage → earnSavingsLadder (EP-16)
[HUB] SavingsNotificationsPage → earnSavingsNotifications (EP-16)
[GIỮ] SavingsPortfolioPage → earnSavingsPortfolio (EP-29)
[HUB] SavingsAutoRebalancePage → earnSavingsRebalance (EP-16)
[HUB] SavingsRecommendationsPage → earnSavingsRecommendations (EP-16)
[HUB] SavingsSmartSuggestionsPage → earnSavingsSmartSuggestions (EP-16)
[HUB] SavingsWhatIfPage → earnSavingsWhatIf (EP-16)
```

### U. P2P HUB (11)

```text
[HUB] P2PAdAnalyticsPage → /p2p/ad-analytics/:adId (EP-17)
[HUB] P2PComplianceOverviewPage → p2pComplianceOverview (EP-17)
[HUB] P2PContributionHistoryPage → p2pContributionHistory (EP-17)
[HUB] P2PDashboardPage → p2pDashboard (EP-17)
[HUB] P2PExpressPage → p2pExpress (EP-17)
[HUB] P2PGuidePage → p2pGuide (EP-17)
[HUB] P2PPaymentMethodHistoryPage → p2pPaymentMethodHistory (EP-17)
[HUB] P2PLoginHistoryPage → p2pSecurityLoginHistory (EP-17)
[HUB] P2PNotificationsSettingsPage → p2pSettingsNotifications (EP-17)
[HUB] P2PFundLockHistoryPage → p2pWalletFundLockHistory (EP-17)
[HUB] P2PFundLockHistoryPage → p2pWalletHistory (EP-17)
```

### V. DCA HUB (10)

```text
[HUB] DCARebalanceConfig → /dca/rebalance/:configId/edit (EP-18)
[HUB] DCARebalanceDashboard → /dca/rebalance/:configId/history (EP-18)
[HUB] DCABacktesterPage → dcaBacktester (EP-18)
[HUB] DCAPerformanceComparePage → dcaPerformanceCompare (EP-18)
[HUB] DCAPortfolioOptimizer → dcaPortfolioOptimizer (EP-18)
[HUB] DCARebalanceConfig → dcaRebalanceConfig (EP-18)
[HUB] DCARebalanceDashboard → dcaRebalanceDashboard (EP-18)
[HUB] DCAScheduleAnalytics → dcaScheduleAnalytics (EP-18)
[HUB] DCAScheduleConfig → dcaScheduleConfig (EP-18)
[HUB] DCASmartRulesPage → dcaSmartRules (EP-18)
```

### W. LAUNCHPAD HUB (4)

```text
[HUB] LaunchpadPerformancePage → launchpadPerformance (EP-19)
[HUB] LaunchpadPortfolioPage → launchpadPortfolio (EP-19)
[HUB] LaunchpadRebalancePage → launchpadRebalance (EP-19)
[HUB] LaunchpadRiskAnalyticsPage → launchpadRiskAnalytics (EP-19)
```

### X. PREDICTIONS HUB (5)

```text
[HUB] PredictionAdvancedChartPage → /markets/predictions/advanced-chart/:eventId (EP-20)
[HUB] PredictionEventCalendarPage → marketsPredictionsEventCalendar (EP-20)
[HUB] PredictionsLeaderboardPage → marketsPredictionsLeaderboard (EP-20)
[HUB] PredictionsPortfolioPage → marketsPredictionsPortfolio (EP-20)
[HUB] PredictionPortfolioAnalyzerPage → marketsPredictionsPortfolioAnalyzer (EP-20)
```

### Y. ARENA HUB (5)

```text
[HUB] ArenaGuidePage → arenaGuide (EP-21)
[HUB] ArenaLeaderboardPage → arenaLeaderboard (EP-21)
[HUB] ArenaStudioPage → arenaStudio (EP-21)
[HUB] ArenaUniversalPresetLibraryPage → arenaStudioPresets (EP-21)
[HUB] ArenaSmartRuleBuilderPage → arenaStudioSmartRules (EP-21)
```

### Z. DISCOVERY — TOPICS (1)

```text
[HUB] TopicHubPage → topicCrypto (EP-31)
```

### AA. BOTTOM NAV → PROFILE (EP-05) (1)

```text
[GIỮ] ProfilePage → profile (EP-05)
```

### AB. PROFILE — KYC & Bảo mật (2)

```text
[GIỮ] KYCPage → profileKyc (EP-33)
[GIỮ] SecurityPage → settingsSecurity (EP-32)
```

### AC. PROFILE — Cài đặt & tài khoản (1)

```text
[HUB] PredictionsPortfolioPage → profilePredictions (EP-05)
```

### AD. PROFILE — Portfolio nâng cao (3)

```text
[HUB] CrossModuleAnalytics → crossModuleAnalytics (EP-34)
[HUB] SmartAlertCenter → smartAlerts (EP-34)
[GIỮ] UnifiedPortfolioDashboard → unifiedPortfolio (EP-34)
```

### AE. PROFILE — Giới thiệu (2)

```text
[GIỮ] ReferralHomePage → referral (EP-23)
[HUB] ReferralHistoryPage → referralHistory (EP-23)
```

### AF. PROFILE — Hỗ trợ (1)

```text
[GIỮ] SupportPage → support (EP-24)
```

### AG. PROFILE — Pháp lý & báo cáo (GOM) (39)

```text
[GOM] ComplaintTrackingPage → /trade/copy-trading/complaint-tracking/:complaintId (EP-13)
[GOM] ArenaGovernanceGatePage → arenaStudioGovernance (EP-21)
[GOM] LaunchpadWebhooksPage → launchpadWebhooks (EP-19)
[GOM] P2PInsuranceFundPage → p2pInsurance (EP-17)
[GOM] P2PInsuranceFundPage → p2pInsuranceFundAlias (EP-17)
[GOM] BotApiDocumentationPage → tradeBotApiDocumentation (EP-14)
[GOM] BotEmergencyStopPage → tradeBotEmergencyStop (EP-14)
[GOM] BotRiskDashboardPage → tradeBotRiskDashboard (EP-14)
[GOM] BotRiskDisclosurePage → tradeBotRiskDisclosure (EP-14)
[GOM] BotSuitabilityAssessmentPage → tradeBotSuitabilityAssessment (EP-14)
[GOM] BotTermsOfServicePage → tradeBotTermsOfService (EP-14)
[GOM] ArmIntegrationStatusPage → tradeCopyArmIntegrationStatus (EP-13)
[GOM] AuditTrailPage → tradeCopyAuditTrail (EP-13)
[GOM] BestExecutionReportsPage → tradeCopyBestExecutionReports (EP-13)
[GOM] CassReconciliationPage → tradeCopyCassReconciliation (EP-13)
[GOM] ClientCategorizationPage → tradeCopyClientCategorization (EP-13)
[GOM] ClientMoneyProtectionPage → tradeCopyClientMoneyProtection (EP-13)
[GOM] ClientOptUpRequestPage → tradeCopyClientOptUpRequest (EP-13)
[GOM] ComplaintsHandlingPage → tradeCopyComplaintsHandling (EP-13)
[GOM] ComplaintSubmissionPage → tradeCopyComplaintSubmission (EP-13)
[GOM] ComplaintTrackingPage → tradeCopyComplaintTrackingBase (EP-13)
[GOM] ExAnteCostsPage → tradeCopyExAnteCosts (EP-13)
[GOM] ExecutionVenueAnalysisPage → tradeCopyExecutionVenueAnalysis (EP-13)
[GOM] ExPostCostsReportPage → tradeCopyExPostCostsReport (EP-13)
[GOM] InvestorCompensationPage → tradeCopyInvestorCompensation (EP-13)
[GOM] KIDGeneratorPage → tradeCopyKidGenerator (EP-13)
[GOM] OmbudsmanReferralPage → tradeCopyOmbudsmanReferral (EP-13)
[GOM] PerformanceScenariosPage → tradeCopyPerformanceScenarios (EP-13)
[GOM] ProductGovernancePage → tradeCopyProductGovernance (EP-13)
[GOM] RegulatoryDisclosuresPage → tradeCopyRegulatoryDisclosures (EP-13)
[GOM] RegulatoryInspectionReadyPage → tradeCopyRegulatoryInspectionReady (EP-13)
[GOM] RegulatoryReportsDashboardPage → tradeCopyRegulatoryReportsDashboard (EP-13)
[GOM] RiskIndicatorExplainerPage → tradeCopyRiskIndicatorExplainer (EP-13)
[GOM] RIYCalculatorPage → tradeCopyRiyCalculator (EP-13)
[GOM] SlippageMonitoringPage → tradeCopySlippageMonitoring (EP-13)
[GOM] TargetMarketDefinitionPage → tradeCopyTargetMarketDefinition (EP-13)
[GOM] TransactionReportingPage → tradeCopyTransactionReporting (EP-13)
[GOM] LiveMarketDataAnalyticsPage → tradeMarginLiveMarketDataAnalytics (EP-13)
[GOM] MarketDataAnalyticsPage → tradeMarginMarketDataAnalytics (EP-13)
```

### AH. AUTH SHELL (1)

```text
[GIỮ] _AuthRouteShell → authLogin (EP-35)
```

### 6.99 Thống kê

| Phân loại | Số route trong cây |
|-----------|-------------------:|
| GIỮ | 33 |
| GOM | 72 |
| HUB | 91 |
| **Tổng liệt kê** | **196** (unique) / **196** (source) |

### 6.100 Index theo Menu UI (alphabetical)

| Menu UI đề xuất | GIỮ | HUB | GOM | Tổng |
|-----------------|----:|----:|----:|-----:|
| — Auth shell (Login) |  | 0 | 0 | 1 |
| Arena hub → Studio & thách đấu | 0 | 5 | 0 | 5 |
| Bots hub → Công cụ & chiến lược | 0 | 6 | 0 | 6 |
| Bottom Nav → Home |  | 0 | 0 | 1 |
| Bottom Nav → Markets |  | 0 | 0 | 1 |
| Bottom Nav → Profile |  | 0 | 0 | 1 |
| Bottom Nav → Trade |  | 0 | 0 | 1 |
| Bottom Nav → Wallet |  | 0 | 0 | 1 |
| Copy hub → Công cụ & danh sách | 0 | 6 | 0 | 6 |
| Copy hub → Tuân thủ & audit | 0 | 0 | 2 | 2 |
| DCA hub → Lịch & công cụ | 0 | 10 | 0 | 10 |
| Discovery → Topic hub | 0 |  | 0 | 1 |
| Earn → Tài liệu & rủi ro | 0 | 0 | 31 | 31 |
| Earn hub → Staking (tile/tab) | 0 | 8 | 0 | 8 |
| Earn hub → Staking dashboard |  | 0 | 0 | 1 |
| Header → Thông báo |  | 0 | 0 | 1 |
| Header → Tìm kiếm |  | 0 | 0 | 1 |
| Home → Discovery Arena |  | 0 | 0 | 1 |
| Home → Discovery Predictions |  | 0 | 0 | 1 |
| Home → Sản phẩm Giao dịch |  | 0 | 0 | 1 |
| Home → Sản phẩm Giao dịch (P2P) |  | 0 | 0 | 1 |
| Home → Sản phẩm Khám phá (Launchpad) |  | 0 | 0 | 1 |
| Home → Sản phẩm Khám phá (Rewards) |  | 0 | 0 | 1 |
| Home → Sản phẩm Khám phá (Topics) |  | 0 | 0 | 1 |
| Home → Sản phẩm Pro (Bot) |  | 0 | 0 | 1 |
| Home → Sản phẩm Pro (Copy) |  | 0 | 0 | 1 |
| Home → Sản phẩm Sinh lời (DCA) |  | 0 | 0 | 1 |
| Home → Sản phẩm Sinh lời (Staking) |  | 0 | 0 | 1 |
| Home → Sản phẩm Sinh lời (Tiết kiệm) |  | 0 | 0 | 1 |
| Home header → Tin tức |  | 0 | 0 | 1 |
| Home Hero + Wallet → Nạp |  | 0 | 0 | 1 |
| Home Next action + Wallet → Rút |  | 0 | 0 | 1 |
| Launchpad hub → Dự án & portfolio | 0 | 4 | 0 | 4 |
| Margin hub → Công cụ | 0 | 2 | 0 | 2 |
| Markets hub → Công cụ & danh sách | 0 | 10 | 0 | 10 |
| P2P hub → Express & đơn hàng | 0 | 11 | 0 | 11 |
| Predictions hub → Danh mục & portfolio | 0 | 5 | 0 | 5 |
| Profile → Analytics & báo cáo thuế | 0 | 2 | 0 | 2 |
| Profile → Bảo mật |  | 0 | 0 | 1 |
| Profile → Cài đặt & tài khoản | 0 |  | 0 | 1 |
| Profile → Giới thiệu |  | 0 | 0 | 1 |
| Profile → Hỗ trợ |  | 0 | 0 | 1 |
| Profile → KYC (banner) |  | 0 | 0 | 1 |
| Profile → Pháp lý & báo cáo | 0 | 0 | 39 | 39 |
| Profile → Portfolio nâng cao |  | 0 | 0 | 1 |
| Referral hub → Lịch sử & thưởng | 0 |  | 0 | 1 |
| Savings hub → Công cụ (tile/tab) | 0 | 15 | 0 | 15 |
| Savings hub → Portfolio |  | 0 | 0 | 1 |
| Trade hub → Công cụ Spot | 0 | 2 | 0 | 2 |
| Trade hub → Lệnh & lịch sử |  | 0 | 0 | 1 |
| Trade hub → Vị thế |  | 0 | 0 | 1 |
| Trade tab + Home → Sản phẩm Giao dịch |  | 0 | 0 | 1 |
| Wallet hub → Dịch vụ ví | 0 | 2 | 0 | 2 |

---

Liên kết: [`00-INDEX.md`](./00-INDEX.md) · [`99-ALL-ROUTES.md`](./99-ALL-ROUTES.md)
