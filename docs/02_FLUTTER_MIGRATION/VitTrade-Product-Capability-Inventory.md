# VitTrade Product Capability Inventory

This inventory is generated from the active Flutter router and maps each routed screen into product-level capabilities. It deliberately avoids treating a router file or folder as a product capability when that module contains multiple user-facing capabilities.

## Counting Rules

- Screen count uses named `GoRoute` entries with a `builder` in `flutter_app/lib/app/router/route_groups/`.
- Redirect-only routes are tracked separately and are not counted as screens.
- Technical module is derived from the resolved source file under `flutter_app/lib/features/<module>/...`, not only from the router group.
- Flow is a product workflow grouping inside a capability; it may contain one or more routed screens.

## Executive Summary

- Product areas: **19**.
- Product capabilities: **33**.
- Product flows: **104**.
- Renderable routed screens: **414**.
- Redirect-only routes: **3**.
- Machine-readable CSV: `docs/02_FLUTTER_MIGRATION/VitTrade-Product-Capability-Inventory.csv`.

## Product Area Summary

| Product Area | Capabilities | Flows | Screens | Technical Modules |
| --- | ---: | ---: | ---: | --- |
| Identity and Access | 1 | 4 | 7 | `auth`, `onboarding` |
| Home and Discovery | 1 | 5 | 6 | `discovery`, `home`, `news`, `notifications` |
| Market Intelligence | 2 | 4 | 22 | `markets` |
| Prediction Markets | 2 | 5 | 18 | `predictions` |
| Trading Execution | 1 | 4 | 14 | `trade` |
| Trading Automation | 1 | 4 | 19 | `trade` |
| Copy Trading | 1 | 7 | 49 | `trade` |
| Margin and Advanced Trading | 1 | 3 | 8 | `trade` |
| P2P Trading | 5 | 10 | 77 | `p2p` |
| Wallet and Treasury | 2 | 6 | 21 | `wallet` |
| Earn and Savings | 2 | 10 | 70 | `earn` |
| Investment Automation | 1 | 4 | 14 | `dca` |
| Launchpad and Token Access | 3 | 5 | 24 | `launchpad` |
| Open Arena | 4 | 8 | 25 | `arena` |
| Growth and Rewards | 1 | 6 | 6 | `referral`, `rewards` |
| Profile and Account | 1 | 4 | 16 | `arena`, `predictions`, `profile` |
| Support and Service | 1 | 3 | 3 | `support` |
| Enterprise Operations | 2 | 7 | 10 | `admin`, `cross_module`, `enterprise_states` |
| Developer and QA Tooling | 1 | 5 | 5 | `dev`, `trade` |
| **Total** | **33** | **104** | **414** |  |

## Capability Summary

| Product Area | Technical Module(s) | Feature / Capability | Flows | Screens |
| --- | --- | --- | ---: | ---: |
| Identity and Access | `auth`, `onboarding` | Identity and Onboarding | 4 | 7 |
| Home and Discovery | `discovery`, `home`, `news`, `notifications` | Home, Discovery and Notifications | 5 | 6 |
| Market Intelligence | `markets` | Market Intelligence | 3 | 18 |
| Market Intelligence | `markets` | Pair Intelligence | 1 | 4 |
| Prediction Markets | `predictions` | Prediction Market Discovery and Portfolio | 2 | 7 |
| Prediction Markets | `predictions` | Prediction Market Operations | 3 | 11 |
| Trading Execution | `trade` | Core Trading | 4 | 14 |
| Trading Automation | `trade` | Trading Bots | 4 | 19 |
| Copy Trading | `trade` | Copy Trading | 7 | 49 |
| Margin and Advanced Trading | `trade` | Margin / Advanced Trading | 3 | 8 |
| P2P Trading | `p2p` | P2P Trading Lifecycle | 2 | 14 |
| P2P Trading | `p2p` | P2P Merchant Operations | 1 | 13 |
| P2P Trading | `p2p` | P2P Trust, Security and Payment Methods | 3 | 21 |
| P2P Trading | `p2p` | P2P Risk, Compliance and Wallet Operations | 3 | 27 |
| P2P Trading | `p2p` | P2P Trading | 1 | 2 |
| Wallet and Treasury | `wallet` | Wallet Management and Monitoring | 2 | 10 |
| Wallet and Treasury | `wallet` | Wallet Money Movement | 4 | 11 |
| Earn and Savings | `earn` | Staking / Earn | 7 | 46 |
| Earn and Savings | `earn` | Savings | 3 | 24 |
| Investment Automation | `dca` | DCA / Auto-Invest | 4 | 14 |
| Launchpad and Token Access | `launchpad` | Launchpad Portfolio and Staking | 1 | 4 |
| Launchpad and Token Access | `launchpad` | Launchpad Participation and Settlement | 2 | 8 |
| Launchpad and Token Access | `launchpad` | Launchpad Operations and Risk Tools | 2 | 12 |
| Open Arena | `arena` | Open Arena Discovery and Management | 2 | 5 |
| Open Arena | `arena` | Open Arena Gameplay and Creation | 3 | 11 |
| Open Arena | `arena` | Arena Safety, Trust and Ledger | 2 | 7 |
| Open Arena | `arena` | Arena Prediction Bridge | 1 | 2 |
| Growth and Rewards | `referral`, `rewards` | Rewards and Referral | 6 | 6 |
| Profile and Account | `arena`, `predictions`, `profile` | Profile and Account Management | 4 | 16 |
| Support and Service | `support` | Support and Help | 3 | 3 |
| Enterprise Operations | `admin` | Admin and Analytics | 2 | 5 |
| Enterprise Operations | `cross_module`, `enterprise_states` | Enterprise Cross-Module Intelligence | 5 | 5 |
| Developer and QA Tooling | `dev`, `trade` | Developer and QA Tools | 5 | 5 |

## Redirect-Only Routes

| Router Group | Route Name | Path | Target Expression |
| --- | --- | --- | --- |
| `arena_routes.dart` | `(unnamed)` | `/arena/points` | `'${AppRoutePaths.rewards}?tab=arena'` |
| `auth_routes.dart` | `(unnamed)` | `/` | `AppRoutePaths.home` |
| `trade_routes.dart` | `sc412TradeCopyRegulatoryDisclosuresAlias` | `/trade/copy-trading/regulatory-disclosures` | `AppRoutePaths.tradeCopyRegulatoryDisclosures` |

## Detailed Inventory

## Product Area: Identity and Access

### Feature / Capability: Identity and Onboarding

- Technical module(s): `auth`, `onboarding`
- Flow count: **4**
- Screen count: **7**

#### Flow: Account access (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-001 | `sc001Login` | `/auth/login` | `LoginPage` | `flutter_app/lib/features/auth/presentation/pages/login_page.dart` |
| SC-002 | `sc002Register` | `/auth/register` | `RegisterPage` | `flutter_app/lib/features/auth/presentation/pages/register_page.dart` |

#### Flow: Authentication challenge and 2FA setup (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-003 | `sc003Otp` | `/auth/otp` | `OTPPage` | `flutter_app/lib/features/auth/presentation/pages/otp_page.dart` |
| SC-004 | `sc004TwoFaSetup` | `/auth/2fa-setup` | `TwoFASetupPage` | `flutter_app/lib/features/auth/presentation/pages/two_fa_setup_page.dart` |

#### Flow: Password recovery (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-005 | `sc005ForgotPassword` | `/auth/forgot-password` | `ForgotPasswordPage` | `flutter_app/lib/features/auth/presentation/pages/forgot_password_page.dart` |
| SC-006 | `sc006ResetPassword` | `/auth/reset-password` | `ResetPasswordPage` | `flutter_app/lib/features/auth/presentation/pages/reset_password_page.dart` |

#### Flow: First-run onboarding (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-397 | `sc397Onboarding` | `/onboarding` | `OnboardingFlow` | `flutter_app/lib/features/onboarding/presentation/pages/onboarding_flow.dart` |

## Product Area: Home and Discovery

### Feature / Capability: Home, Discovery and Notifications

- Technical module(s): `discovery`, `home`, `news`, `notifications`
- Flow count: **5**
- Screen count: **6**

#### Flow: Home dashboard (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-007 | `sc007Home` | `/home` | `HomePage` | `flutter_app/lib/features/home/presentation/pages/home_page.dart` |

#### Flow: News feed (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-047 | `sc047News` | `/news` | `NewsPage` | `flutter_app/lib/features/news/presentation/pages/news_page.dart` |

#### Flow: Unified search (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-283 | `sc283UnifiedSearch` | `/search` | `UnifiedSearchPage` | `flutter_app/lib/features/discovery/presentation/pages/unified_search_page.dart` |

#### Flow: Topic discovery (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-284 | `sc284TopicHub` | `/topics` | `TopicHubPage` | `flutter_app/lib/features/discovery/presentation/pages/topic_hub_page.dart` |
| SC-285 | `sc285TopicCrypto` | `/topic/crypto` | `TopicHubPage` | `flutter_app/lib/features/discovery/presentation/pages/topic_hub_page.dart` |

#### Flow: Notification center (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-291 | `sc291Notifications` | `/notifications` | `NotificationsPage` | `flutter_app/lib/features/notifications/presentation/pages/notifications_page.dart` |

## Product Area: Market Intelligence

### Feature / Capability: Market Intelligence

- Technical module(s): `markets`
- Flow count: **3**
- Screen count: **18**

#### Flow: Market discovery and watchlists (5 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-008 | `sc008MarketList` | `/markets` | `MarketListPage` | `flutter_app/lib/features/markets/presentation/pages/market_list_page.dart` |
| SC-009 | `sc009MarketOverview` | `/markets/overview` | `MarketOverviewPage` | `flutter_app/lib/features/markets/presentation/pages/market_overview_page.dart` |
| SC-010 | `sc010MarketMovers` | `/markets/movers` | `MarketMoversPage` | `flutter_app/lib/features/markets/presentation/pages/market_movers_page.dart` |
| SC-011 | `sc011MarketSectors` | `/markets/sectors` | `MarketSectorsPage` | `flutter_app/lib/features/markets/presentation/pages/market_sectors_page.dart` |
| SC-012 | `sc012Watchlist` | `/markets/watchlist` | `WatchlistPage` | `flutter_app/lib/features/markets/presentation/pages/watchlist_page.dart` |

#### Flow: Market research tools (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-013 | `sc013MarketHeatmap` | `/markets/heatmap` | `MarketHeatmapPage` | `flutter_app/lib/features/markets/presentation/pages/market_heatmap_page.dart` |
| SC-014 | `sc014PriceAlerts` | `/markets/alerts` | `PriceAlertsPage` | `flutter_app/lib/features/markets/presentation/pages/price_alerts_page.dart` |
| SC-015 | `sc015MarketScreener` | `/markets/screener` | `MarketScreenerPage` | `flutter_app/lib/features/markets/presentation/pages/market_screener_page.dart` |
| SC-016 | `sc016ComparisonTool` | `/markets/compare` | `ComparisonToolPage` | `flutter_app/lib/features/markets/presentation/pages/comparison_tool_page.dart` |
| SC-017 | `sc017MarketCalendar` | `/markets/calendar` | `MarketCalendarPage` | `flutter_app/lib/features/markets/presentation/pages/market_calendar_page.dart` |
| SC-026 | `sc026MarketCorrelations` | `/markets/correlations` | `MarketCorrelationsPage` | `flutter_app/lib/features/markets/presentation/pages/market_correlations_page.dart` |

#### Flow: Market intelligence and insights (7 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-018 | `sc018DerivativesOverview` | `/markets/derivatives` | `DerivativesOverviewPage` | `flutter_app/lib/features/markets/presentation/pages/derivatives_overview_page.dart` |
| SC-020 | `sc020SocialSentiment` | `/markets/social-sentiment` | `SocialSentimentPage` | `flutter_app/lib/features/markets/presentation/pages/social_sentiment_page.dart` |
| SC-021 | `sc021PortfolioTracker` | `/markets/portfolio-tracker` | `PortfolioTrackerPage` | `flutter_app/lib/features/markets/presentation/pages/portfolio_tracker_page.dart` |
| SC-022 | `sc022MarketNews` | `/markets/news` | `MarketNewsPage` | `flutter_app/lib/features/markets/presentation/pages/market_news_page.dart` |
| SC-023 | `sc023AdvancedCharts` | `/markets/advanced-charts` | `AdvancedChartsPage` | `flutter_app/lib/features/markets/presentation/pages/advanced_charts_page.dart` |
| SC-024 | `sc024TokenUnlocks` | `/markets/unlocks` | `TokenUnlocksPage` | `flutter_app/lib/features/markets/presentation/pages/token_unlocks_page.dart` |
| SC-025 | `sc025SocialSignals` | `/markets/signals` | `SocialSignalsPage` | `flutter_app/lib/features/markets/presentation/pages/social_signals_page.dart` |

### Feature / Capability: Pair Intelligence

- Technical module(s): `markets`
- Flow count: **1**
- Screen count: **4**

#### Flow: Pair and depth intelligence (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-019 | `sc019MarketDepth` | `/markets/depth` | `MarketDepthPage` | `flutter_app/lib/features/markets/presentation/pages/market_depth_page.dart` |
| SC-044 | `sc044PairDetail` | `/pair/:pairId` | `PairDetailPage` | `flutter_app/lib/features/markets/presentation/pages/pair_detail_page.dart` |
| SC-045 | `sc045TokenInfo` | `/pair/:pairId/info` | `TokenInfoPage` | `flutter_app/lib/features/markets/presentation/pages/token_info_page.dart` |
| SC-046 | `sc046PairDepth` | `/pair/:pairId/depth` | `MarketDepthPage` | `flutter_app/lib/features/markets/presentation/pages/market_depth_page.dart` |

## Product Area: Prediction Markets

### Feature / Capability: Prediction Market Discovery and Portfolio

- Technical module(s): `predictions`
- Flow count: **2**
- Screen count: **7**

#### Flow: Prediction market discovery (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-027 | `sc027PredictionsHome` | `/markets/predictions` | `PredictionsHomePage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_home_page.dart` |
| SC-028 | `sc028PredictionsSearch` | `/markets/predictions/search` | `PredictionsSearchPage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_search_page.dart` |
| SC-029 | `sc029PredictionsBreaking` | `/markets/predictions/breaking` | `PredictionsBreakingPage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_breaking_page.dart` |

#### Flow: Prediction portfolio and community (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-031 | `sc031PredictionsPortfolio` | `/markets/predictions/portfolio` | `PredictionsPortfolioPage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` |
| SC-032 | `sc032PredictionsRewards` | `/markets/predictions/rewards` | `PredictionsRewardsPage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_rewards_page.dart` |
| SC-033 | `sc033PredictionsLeaderboard` | `/markets/predictions/leaderboard` | `PredictionsLeaderboardPage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart` |
| SC-034 | `sc034PredictionsGlobalActivity` | `/markets/predictions/activity` | `PredictionsGlobalActivityPage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_global_activity_page.dart` |

### Feature / Capability: Prediction Market Operations

- Technical module(s): `predictions`
- Flow count: **3**
- Screen count: **11**

#### Flow: Prediction event trading (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-030 | `sc030PredictionEventDetail` | `/markets/predictions/event/:eventId` | `PredictionEventDetailPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` |
| SC-035 | `sc035PredictionOrderReceipt` | `/markets/predictions/receipt/:receiptId` | `PredictionOrderReceiptPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_order_receipt_page.dart` |
| SC-041 | `sc041PredictionAdvancedChart` | `/markets/predictions/advanced-chart/:eventId` | `PredictionAdvancedChartPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_advanced_chart_page_part_01.dart` |

#### Flow: Prediction analytics and operations (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-036 | `sc036PredictionRiskCalculator` | `/markets/predictions/risk-calculator` | `PredictionRiskCalculatorPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_risk_calculator_page.dart` |
| SC-037 | `sc037PredictionMarketMaker` | `/markets/predictions/market-maker` | `PredictionMarketMakerPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_market_maker_page.dart` |
| SC-038 | `sc038PredictionPortfolioAnalyzer` | `/markets/predictions/portfolio-analyzer` | `PredictionPortfolioAnalyzerPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_portfolio_analyzer_page.dart` |
| SC-039 | `sc039PredictionEventCalendar` | `/markets/predictions/event-calendar` | `PredictionEventCalendarPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart` |
| SC-040 | `sc040PredictionSocial` | `/markets/predictions/social` | `PredictionSocialPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_social_page.dart` |
| SC-043 | `sc043PredictionDataIntegration` | `/markets/predictions/data-integration` | `PredictionDataIntegrationPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_data_integration_page.dart` |

#### Flow: Prediction tournaments (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-042 | `sc042PredictionTournaments` | `/markets/predictions/tournaments` | `PredictionTournamentsPage` | `flutter_app/lib/features/predictions/presentation/pages/prediction_tournaments_page.dart` |
| SC-414 | `sc414PredictionTournamentDetail` | `/markets/predictions/tournament/:tournamentId` | `PredictionTournamentDetailPage` | `flutter_app/lib/features/predictions/presentation/widgets/prediction_tournaments_detail.dart` |

## Product Area: Trading Execution

### Feature / Capability: Core Trading

- Technical module(s): `trade`
- Flow count: **4**
- Screen count: **14**

#### Flow: Spot, pair, chart and convert execution (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-048 | `sc048Trade` | `/trade` | `TradePage` | `flutter_app/lib/features/trade/presentation/pages/trade_page.dart` |
| SC-049 | `sc049TradePair` | `/trade/:pairId` | `TradePage` | `flutter_app/lib/features/trade/presentation/pages/trade_page.dart` |
| SC-055 | `sc055AdvancedChart` | `/trade/advanced-chart/:pairId` | `AdvancedChartPage` | `flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart` |
| SC-056 | `sc056Convert` | `/trade/convert` | `ConvertPage` | `flutter_app/lib/features/trade/presentation/pages/convert_page.dart` |

#### Flow: Order, position and settings management (5 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-050 | `sc050OrdersHistory` | `/trade/orders-history` | `OrdersHistoryPage` | `flutter_app/lib/features/trade/presentation/pages/orders_history_page.dart` |
| SC-051 | `sc051OrderReceipt` | `/trade/order-receipt` | `OrderReceiptPage` | `flutter_app/lib/features/trade/presentation/pages/order_receipt_page.dart` |
| SC-052 | `sc052TradeSettings` | `/trade/settings` | `TradeSettingsPage` | `flutter_app/lib/features/trade/presentation/pages/trade_settings_page.dart` |
| SC-053 | `sc053PositionDashboard` | `/trade/positions` | `PositionDashboardPage` | `flutter_app/lib/features/trade/presentation/pages/position_dashboard_page.dart` |
| SC-054 | `sc054TradeHistoryExport` | `/trade/export` | `TradeHistoryExportPage` | `flutter_app/lib/features/trade/presentation/pages/trade_history_export_page.dart` |

#### Flow: Futures and leverage (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-057 | `sc057Futures` | `/trade/:pairId/futures` | `FuturesPage` | `flutter_app/lib/features/trade/presentation/pages/futures_page.dart` |
| SC-058 | `sc058Leverage` | `/trade/:pairId/futures/leverage` | `LeveragePage` | `flutter_app/lib/features/trade/presentation/pages/leverage_page.dart` |

#### Flow: Risk and execution quality tools (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-060 | `sc060RiskManagement` | `/trade/risk-management` | `RiskManagementDemoPage` | `flutter_app/lib/features/trade/presentation/pages/risk_management_demo_page.dart` |
| SC-061 | `sc061ExecutionQuality` | `/trade/execution-quality` | `ExecutionQualityDemoPage` | `flutter_app/lib/features/trade/presentation/pages/execution_quality_demo_page.dart` |
| SC-062 | `sc062AdvancedTools` | `/trade/advanced-tools` | `AdvancedToolsDemoPage` | `flutter_app/lib/features/trade/presentation/pages/advanced_tools_demo_page.dart` |

## Product Area: Trading Automation

### Feature / Capability: Trading Bots

- Technical module(s): `trade`
- Flow count: **4**
- Screen count: **19**

#### Flow: Bot onboarding, education and API docs (7 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-059 | `sc059TradingBots` | `/trade/bots` | `TradingBotsPage` | `flutter_app/lib/features/trade/presentation/pages/trading_bots_page.dart` |
| SC-117 | `sc117BotTermsOfService` | `/trade/bots/terms-of-service` | `BotTermsOfServicePage` | `flutter_app/lib/features/trade/presentation/pages/bot_terms_of_service_page.dart` |
| SC-118 | `sc118BotRiskDisclosure` | `/trade/bots/risk-disclosure` | `BotRiskDisclosurePage` | `flutter_app/lib/features/trade/presentation/pages/bot_risk_disclosure_page.dart` |
| SC-119 | `sc119BotSuitabilityAssessment` | `/trade/bots/suitability-assessment` | `BotSuitabilityAssessmentPage` | `flutter_app/lib/features/trade/presentation/pages/bot_suitability_assessment_page.dart` |
| SC-131 | `sc131BotGuide` | `/trade/bots/guide` | `BotGuidePage` | `flutter_app/lib/features/trade/presentation/pages/bot_guide_page.dart` |
| SC-132 | `sc132BotFaq` | `/trade/bots/faq` | `BotFaqPage` | `flutter_app/lib/features/trade/presentation/pages/bot_faq_page.dart` |
| SC-134 | `sc134BotApiDocumentation` | `/trade/bots/api-documentation` | `BotApiDocumentationPage` | `flutter_app/lib/features/trade/presentation/pages/bot_api_documentation_page.dart` |

#### Flow: Bot risk and security controls (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-120 | `sc120BotRiskDashboard` | `/trade/bots/risk-dashboard` | `BotRiskDashboardPage` | `flutter_app/lib/features/trade/presentation/pages/bot_risk_dashboard_page.dart` |
| SC-121 | `sc121BotEmergencyStop` | `/trade/bots/emergency-stop` | `BotEmergencyStopPage` | `flutter_app/lib/features/trade/presentation/pages/bot_emergency_stop_page.dart` |
| SC-122 | `sc122BotSecuritySettings` | `/trade/bots/security-settings` | `BotSecuritySettingsPage` | `flutter_app/lib/features/trade/presentation/pages/bot_security_settings_page.dart` |

#### Flow: Bot performance and reporting (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-123 | `sc123BotHistory` | `/trade/bots/history` | `BotHistoryPage` | `flutter_app/lib/features/trade/presentation/pages/bot_history_page.dart` |
| SC-124 | `sc124BotPerformanceAnalytics` | `/trade/bots/performance-analytics` | `BotPerformanceAnalyticsPage` | `flutter_app/lib/features/trade/presentation/pages/bot_performance_analytics_page.dart` |
| SC-128 | `sc128BotPortfolioDashboard` | `/trade/bots/portfolio-dashboard` | `BotPortfolioDashboardPage` | `flutter_app/lib/features/trade/presentation/pages/bot_portfolio_dashboard_page.dart` |
| SC-129 | `sc129BotDrawdownAnalyzer` | `/trade/bots/drawdown-analyzer` | `BotDrawdownAnalyzerPage` | `flutter_app/lib/features/trade/presentation/pages/bot_drawdown_analyzer_page.dart` |
| SC-130 | `sc130BotEquityCurve` | `/trade/bots/equity-curve` | `BotEquityCurvePage` | `flutter_app/lib/features/trade/presentation/pages/bot_equity_curve_page.dart` |
| SC-133 | `sc133BotTaxReporting` | `/trade/bots/tax-reporting` | `BotTaxReportingPage` | `flutter_app/lib/features/trade/presentation/pages/bot_tax_reporting_page.dart` |

#### Flow: Bot strategy testing and optimization (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-125 | `sc125BotBacktesting` | `/trade/bots/backtesting` | `BotBacktestingPage` | `flutter_app/lib/features/trade/presentation/pages/bot_backtesting_page.dart` |
| SC-126 | `sc126BotStrategyCompare` | `/trade/bots/strategy-compare` | `BotStrategyComparePage` | `flutter_app/lib/features/trade/presentation/pages/bot_strategy_compare_page.dart` |
| SC-127 | `sc127BotOptimization` | `/trade/bots/optimization` | `BotOptimizationPage` | `flutter_app/lib/features/trade/presentation/pages/bot_optimization_page.dart` |

## Product Area: Copy Trading

### Feature / Capability: Copy Trading

- Technical module(s): `trade`
- Flow count: **7**
- Screen count: **49**

#### Flow: Copy discovery, education and settings (10 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-063 | `sc063CopyTrading` | `/trade/copy-trading` | `CopyTradingPage` | `flutter_app/lib/features/trade/presentation/pages/copy_trading_page.dart` |
| SC-064 | `sc064CopyTradingV2` | `/trade/copy-trading/v2` | `CopyTradingV2Page` | `flutter_app/lib/features/trade/presentation/pages/copy_trading_v2_page.dart` |
| SC-065 | `sc065CopyEducation` | `/trade/copy-trading/education` | `CopyEducationPage` | `flutter_app/lib/features/trade/presentation/pages/copy_education_page.dart` |
| SC-066 | `sc066ActiveCopies` | `/trade/copy-trading/active` | `ActiveCopiesPage` | `flutter_app/lib/features/trade/presentation/pages/active_copies_page.dart` |
| SC-067 | `sc067CopySettings` | `/trade/copy-trading/settings` | `CopySettingsPage` | `flutter_app/lib/features/trade/presentation/pages/copy_settings_page.dart` |
| SC-068 | `sc068CopyNotifications` | `/trade/copy-trading/notifications` | `CopyNotificationsPage` | `flutter_app/lib/features/trade/presentation/pages/copy_notifications_page.dart` |
| SC-069 | `sc069ProviderApplication` | `/trade/copy-provider-apply` | `ProviderApplicationPage` | `flutter_app/lib/features/trade/presentation/pages/provider_application_page.dart` |
| SC-076 | `sc076ProviderComparison` | `/trade/copy-trading/comparison` | `ProviderComparisonPage` | `flutter_app/lib/features/trade/presentation/pages/provider_comparison_page.dart` |
| SC-079 | `sc079ProviderLeaderboard` | `/trade/copy-trading/leaderboard` | `ProviderLeaderboardPage` | `flutter_app/lib/features/trade/presentation/pages/provider_leaderboard_page.dart` |
| SC-080 | `sc080SafetyEducation` | `/trade/copy-trading/safety` | `SafetyEducationPage` | `flutter_app/lib/features/trade/presentation/pages/safety_education_page.dart` |

#### Flow: Copy provider onboarding and setup (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-070 | `sc070CopyProviderDetail` | `/trade/copy-provider/:providerId` | `CopyProviderDetailPage` | `flutter_app/lib/features/trade/presentation/pages/copy_provider_detail_page.dart` |
| SC-071 | `sc071PreCopyAssessment` | `/trade/copy-provider/:providerId/assessment` | `PreCopyAssessmentPage` | `flutter_app/lib/features/trade/presentation/pages/pre_copy_assessment_page.dart` |
| SC-072 | `sc072CopyConfiguration` | `/trade/copy-provider/:providerId/configuration` | `CopyConfigurationPage` | `flutter_app/lib/features/trade/presentation/pages/copy_configuration_page.dart` |
| SC-073 | `sc073CopyConfirmation` | `/trade/copy-provider/:providerId/confirmation` | `CopyConfirmationPage` | `flutter_app/lib/features/trade/presentation/pages/copy_confirmation_page.dart` |

#### Flow: Copy performance, attribution and audit (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-074 | `sc074CopyPerformance` | `/trade/copy-performance/:copyId` | `CopyPerformancePage` | `flutter_app/lib/features/trade/presentation/pages/copy_performance_page.dart` |
| SC-075 | `sc075PerformanceAttribution` | `/trade/copy-performance/:copyId/attribution` | `PerformanceAttributionPage` | `flutter_app/lib/features/trade/presentation/pages/performance_attribution_page.dart` |
| SC-077 | `sc077CopyAuditLog` | `/trade/copy-audit-log/:copyId` | `CopyAuditLogPage` | `flutter_app/lib/features/trade/presentation/pages/copy_audit_log_page.dart` |
| SC-078 | `sc078PortfolioRiskAnalysis` | `/trade/copy-trading/risk-analysis` | `PortfolioRiskAnalysisPage` | `flutter_app/lib/features/trade/presentation/pages/portfolio_risk_analysis_page.dart` |

#### Flow: Copy safety, governance and disputes (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-081 | `sc081ProviderGovernance` | `/trade/copy-provider-governance` | `ProviderGovernancePage` | `flutter_app/lib/features/trade/presentation/pages/provider_governance_page.dart` |
| SC-082 | `sc082DisputeResolution` | `/trade/copy-dispute-resolution` | `DisputeResolutionPage` | `flutter_app/lib/features/trade/presentation/pages/dispute_resolution_page.dart` |
| SC-083 | `sc083CopySafetyCenter` | `/trade/copy-safety-center` | `CopySafetyCenterPage` | `flutter_app/lib/features/trade/presentation/pages/copy_safety_center_page.dart` |
| SC-084 | `sc084RegulatoryDisclosures` | `/trade/copy-regulatory-disclosures` | `RegulatoryDisclosuresPage` | `flutter_app/lib/features/trade/presentation/pages/regulatory_disclosures_page.dart` |

#### Flow: Copy regulatory and product governance (14 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-093 | `sc093TransactionReporting` | `/trade/copy-trading/transaction-reporting` | `TransactionReportingPage` | `flutter_app/lib/features/trade/presentation/pages/transaction_reporting_page.dart` |
| SC-094 | `sc094RegulatoryReportsDashboard` | `/trade/copy-trading/regulatory-reports-dashboard` | `RegulatoryReportsDashboardPage` | `flutter_app/lib/features/trade/presentation/pages/regulatory_reports_dashboard_page.dart` |
| SC-095 | `sc095ArmIntegrationStatus` | `/trade/copy-trading/arm-integration-status` | `ArmIntegrationStatusPage` | `flutter_app/lib/features/trade/presentation/pages/arm_integration_status_page.dart` |
| SC-096 | `sc096BestExecutionReports` | `/trade/copy-trading/best-execution-reports` | `BestExecutionReportsPage` | `flutter_app/lib/features/trade/presentation/pages/best_execution_reports_page.dart` |
| SC-097 | `sc097ExecutionVenueAnalysis` | `/trade/copy-trading/execution-venue-analysis` | `ExecutionVenueAnalysisPage` | `flutter_app/lib/features/trade/presentation/pages/execution_venue_analysis_page.dart` |
| SC-098 | `sc098SlippageMonitoring` | `/trade/copy-trading/slippage-monitoring` | `SlippageMonitoringPage` | `flutter_app/lib/features/trade/presentation/pages/slippage_monitoring_page.dart` |
| SC-099 | `sc099ClientCategorization` | `/trade/copy-trading/client-categorization` | `ClientCategorizationPage` | `flutter_app/lib/features/trade/presentation/pages/client_categorization_page.dart` |
| SC-100 | `sc100ProductGovernance` | `/trade/copy-trading/product-governance` | `ProductGovernancePage` | `flutter_app/lib/features/trade/presentation/pages/product_governance_page.dart` |
| SC-101 | `sc101TargetMarketDefinition` | `/trade/copy-trading/target-market-definition` | `TargetMarketDefinitionPage` | `flutter_app/lib/features/trade/presentation/pages/target_market_definition_page.dart` |
| SC-102 | `sc102ClientMoneyProtection` | `/trade/copy-trading/client-money-protection` | `ClientMoneyProtectionPage` | `flutter_app/lib/features/trade/presentation/pages/client_money_protection_page.dart` |
| SC-103 | `sc103CassReconciliation` | `/trade/copy-trading/cass-reconciliation` | `CassReconciliationPage` | `flutter_app/lib/features/trade/presentation/pages/cass_reconciliation_page.dart` |
| SC-104 | `sc104InvestorCompensation` | `/trade/copy-trading/investor-compensation` | `InvestorCompensationPage` | `flutter_app/lib/features/trade/presentation/pages/investor_compensation_page.dart` |
| SC-411 | `sc411ClientOptUpRequest` | `/trade/copy-trading/client-opt-up-request` | `ClientOptUpRequestPage` | `flutter_app/lib/features/trade/presentation/pages/client_categorization_page_part_01.dart` |
| SC-415 | `sc415TargetMarketDefinitionDetail` | `/trade/copy-trading/target-market-definition/:productId` | `TargetMarketDefinitionPage` | `flutter_app/lib/features/trade/presentation/pages/target_market_definition_page.dart` |

#### Flow: Copy costs, KID and risk disclosures (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-105 | `sc105ExAnteCosts` | `/trade/copy-trading/ex-ante-costs` | `ExAnteCostsPage` | `flutter_app/lib/features/trade/presentation/pages/ex_ante_costs_page.dart` |
| SC-106 | `sc106RiyCalculator` | `/trade/copy-trading/riy-calculator` | `RIYCalculatorPage` | `flutter_app/lib/features/trade/presentation/pages/riy_calculator_page.dart` |
| SC-107 | `sc107ExPostCostsReport` | `/trade/copy-trading/ex-post-costs-report` | `ExPostCostsReportPage` | `flutter_app/lib/features/trade/presentation/pages/ex_post_costs_report_page.dart` |
| SC-108 | `sc108KidGenerator` | `/trade/copy-trading/kid-generator` | `KIDGeneratorPage` | `flutter_app/lib/features/trade/presentation/pages/kid_generator_page.dart` |
| SC-109 | `sc109PerformanceScenarios` | `/trade/copy-trading/performance-scenarios` | `PerformanceScenariosPage` | `flutter_app/lib/features/trade/presentation/pages/performance_scenarios_page.dart` |
| SC-110 | `sc110RiskIndicatorExplainer` | `/trade/copy-trading/risk-indicator-explainer` | `RiskIndicatorExplainerPage` | `flutter_app/lib/features/trade/presentation/pages/risk_indicator_explainer_page.dart` |

#### Flow: Copy complaints, audit and inspection readiness (7 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-111 | `sc111ComplaintsHandling` | `/trade/copy-trading/complaints-handling` | `ComplaintsHandlingPage` | `flutter_app/lib/features/trade/presentation/pages/complaints_handling_page.dart` |
| SC-112 | `sc112ComplaintSubmission` | `/trade/copy-trading/complaint-submission` | `ComplaintSubmissionPage` | `flutter_app/lib/features/trade/presentation/pages/complaint_submission_page.dart` |
| SC-113 | `sc113ComplaintTracking` | `/trade/copy-trading/complaint-tracking` | `ComplaintTrackingPage` | `flutter_app/lib/features/trade/presentation/pages/complaint_tracking_page.dart` |
| SC-114 | `sc114OmbudsmanReferral` | `/trade/copy-trading/ombudsman-referral` | `OmbudsmanReferralPage` | `flutter_app/lib/features/trade/presentation/pages/ombudsman_referral_page.dart` |
| SC-115 | `sc115AuditTrail` | `/trade/copy-trading/audit-trail` | `AuditTrailPage` | `flutter_app/lib/features/trade/presentation/pages/audit_trail_page.dart` |
| SC-116 | `sc116RegulatoryInspectionReady` | `/trade/copy-trading/regulatory-inspection-ready` | `RegulatoryInspectionReadyPage` | `flutter_app/lib/features/trade/presentation/pages/regulatory_inspection_ready_page.dart` |
| SC-416 | `sc416ComplaintTrackingDetail` | `/trade/copy-trading/complaint-tracking/:complaintId` | `ComplaintTrackingPage` | `flutter_app/lib/features/trade/presentation/pages/complaint_tracking_page.dart` |

## Product Area: Margin and Advanced Trading

### Feature / Capability: Margin / Advanced Trading

- Technical module(s): `trade`
- Flow count: **3**
- Screen count: **8**

#### Flow: Margin trading surfaces (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-085 | `sc085MarginTrading` | `/trade/margin` | `MarginTradingPage` | `flutter_app/lib/features/trade/presentation/pages/margin_trading_page.dart` |
| SC-086 | `sc086MarginTradingPair` | `/trade/margin/btcusdt` | `MarginTradingPage` | `flutter_app/lib/features/trade/presentation/pages/margin_trading_page.dart` |
| SC-090 | `sc090MarginTradingHub` | `/trade/margin/hub` | `MarginTradingHubPage` | `flutter_app/lib/features/trade/presentation/pages/margin_trading_hub_page.dart` |

#### Flow: Trader profile intelligence (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-087 | `sc087TraderProfile` | `/trade/trader/:traderId` | `TraderProfilePage` | `flutter_app/lib/features/trade/presentation/pages/trader_profile_page.dart` |

#### Flow: Advanced margin analytics (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-088 | `sc088AdvancedTradingDemo` | `/trade/margin/advanced-demo` | `AdvancedTradingDemoPage` | `flutter_app/lib/features/trade/presentation/pages/advanced_trading_demo_page.dart` |
| SC-089 | `sc089MarketDataAnalytics` | `/trade/margin/market-data-analytics` | `MarketDataAnalyticsPage` | `flutter_app/lib/features/trade/presentation/pages/market_data_analytics_page.dart` |
| SC-091 | `sc091LiveMarketDataAnalytics` | `/trade/margin/live-market-data-analytics` | `LiveMarketDataAnalyticsPage` | `flutter_app/lib/features/trade/presentation/pages/live_market_data_analytics_page.dart` |
| SC-092 | `sc092AdvancedAnalytics` | `/trade/margin/advanced-analytics` | `AdvancedAnalyticsPage` | `flutter_app/lib/features/trade/presentation/pages/advanced_analytics_page.dart` |

## Product Area: P2P Trading

### Feature / Capability: P2P Trading Lifecycle

- Technical module(s): `p2p`
- Flow count: **2**
- Screen count: **14**

#### Flow: P2P order lifecycle and chat (9 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-210 | `sc210P2PExpressConfirm` | `/p2p/express/confirm` | `P2PExpressConfirmPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_express_confirm_page.dart` |
| SC-211 | `sc211P2PExpress` | `/p2p/express` | `P2PExpressPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_express_page.dart` |
| SC-212 | `sc212P2POrderTimeline` | `/p2p/order/timeline/:orderId` | `P2POrderTimelinePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_timeline_page.dart` |
| SC-213 | `sc213P2POrderRate` | `/p2p/order/rate/:orderId` | `P2POrderRatePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_rate_page.dart` |
| SC-214 | `sc214P2POrderCancel` | `/p2p/order/cancel/:orderId` | `P2POrderCancelPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_cancel_page.dart` |
| SC-215 | `sc215P2POrderProof` | `/p2p/order/proof/:orderId` | `P2POrderProofPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_proof_page.dart` |
| SC-216 | `sc216P2POrder` | `/p2p/order/:orderId` | `P2POrderPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_page.dart` |
| SC-217 | `sc217P2PChat` | `/p2p/chat/:orderId` | `P2PChatPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_chat_page.dart` |
| SC-281 | `sc281P2PMyOrders` | `/p2p/my-orders` | `P2PMyOrdersPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_my_orders_page.dart` |

#### Flow: P2P disputes and evidence (5 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-218 | `sc218P2PDisputeDetail` | `/p2p/dispute/detail/:disputeId` | `P2PDisputeDetailPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_detail_page.dart` |
| SC-219 | `sc219P2PDisputeEvidence` | `/p2p/dispute/evidence/:disputeId` | `P2PDisputeEvidencePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_evidence_page.dart` |
| SC-220 | `sc220P2PDisputeResolution` | `/p2p/dispute/resolution/:disputeId` | `P2PDisputeResolutionPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_resolution_page.dart` |
| SC-221 | `sc221P2PDispute` | `/p2p/dispute/:orderId` | `P2PDisputePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_page.dart` |
| SC-222 | `sc222P2PDisputes` | `/p2p/disputes` | `P2PDisputesPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_disputes_page.dart` |

### Feature / Capability: P2P Merchant Operations

- Technical module(s): `p2p`
- Flow count: **1**
- Screen count: **13**

#### Flow: P2P ads, merchant and reputation operations (13 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-223 | `sc223P2PAdAnalytics` | `/p2p/ad-analytics/:adId` | `P2PAdAnalyticsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_ad_analytics_page.dart` |
| SC-224 | `sc224P2PAdDetail` | `/p2p/ad/:adId` | `P2PAdDetailPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_ad_detail_page.dart` |
| SC-225 | `sc225P2PMyAds` | `/p2p/my-ads` | `P2PMyAdsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_my_ads_page.dart` |
| SC-226 | `sc226P2PCreateAd` | `/p2p/create` | `P2PCreateAdPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_create_ad_page.dart` |
| SC-227 | `sc227P2PMerchantApply` | `/p2p/merchant-apply` | `P2PMerchantApplyPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_merchant_apply_page.dart` |
| SC-228 | `sc228P2PMerchantProfile` | `/p2p/merchant/:merchantId` | `P2PMerchantProfilePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_merchant_profile_page.dart` |
| SC-229 | `sc229P2PReportMerchant` | `/p2p/report/:merchantId` | `P2PReportMerchantPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_report_merchant_page.dart` |
| SC-230 | `sc230P2PTradingLevel` | `/p2p/trading-level` | `P2PTradingLevelPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_trading_level_page.dart` |
| SC-231 | `sc231P2PReviews` | `/p2p/reviews` | `P2PReviewsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_reviews_page.dart` |
| SC-274 | `sc274P2PDashboard` | `/p2p/dashboard` | `P2PDashboardPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_dashboard_page.dart` |
| SC-278 | `sc278P2PNotificationsSettings` | `/p2p/settings/notifications` | `P2PNotificationsSettingsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_notifications_settings_page.dart` |
| SC-279 | `sc279P2PSettings` | `/p2p/settings` | `P2PSettingsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_settings_page.dart` |
| SC-280 | `sc280P2PGuide` | `/p2p/guide` | `P2PGuidePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_guide_page.dart` |

### Feature / Capability: P2P Trust, Security and Payment Methods

- Technical module(s): `p2p`
- Flow count: **3**
- Screen count: **21**

#### Flow: P2P payment methods (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-232 | `sc232P2PPaymentMethodAdd` | `/p2p/payment-method/add` | `P2PPaymentMethodAddPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart` |
| SC-233 | `sc233P2PPaymentMethodVerification` | `/p2p/payment-method/verification/:methodId` | `P2PPaymentMethodVerificationPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_verification_page.dart` |
| SC-234 | `sc234P2PPaymentMethodOwnership` | `/p2p/payment-method/ownership/:methodId` | `P2PPaymentMethodOwnershipPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_ownership_page.dart` |
| SC-235 | `sc235P2PPaymentMethodCoolingPeriod` | `/p2p/payment-method/cooling-period` | `P2PPaymentMethodCoolingPeriodPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_cooling_period_page.dart` |
| SC-236 | `sc236P2PPaymentMethodHistory` | `/p2p/payment-method/history` | `P2PPaymentMethodHistoryPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_history_page.dart` |
| SC-237 | `sc237P2PPaymentMethods` | `/p2p/payment-methods` | `P2PPaymentMethodsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_methods_page.dart` |

#### Flow: P2P KYC and verification (8 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-247 | `sc247P2PKycRequirements` | `/p2p/kyc/requirements` | `P2PKycRequirementsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_kyc_requirements_page.dart` |
| SC-248 | `sc248P2PKycStatus` | `/p2p/kyc/status` | `P2PKycStatusPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_kyc_status_page.dart` |
| SC-249 | `sc249P2PIdentityVerification` | `/p2p/kyc/identity` | `P2PIdentityVerificationPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart` |
| SC-250 | `sc250P2PAddressProof` | `/p2p/kyc/address` | `P2PAddressProofPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_address_proof_page.dart` |
| SC-251 | `sc251P2PSelfieVerification` | `/p2p/kyc/selfie` | `P2PSelfieVerificationPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_selfie_verification_page.dart` |
| SC-252 | `sc252P2PVideoVerification` | `/p2p/kyc/video` | `P2PVideoVerificationPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_video_verification_page.dart` |
| SC-402 | `sc402P2PKycVerify` | `/p2p/kyc/verify` | `P2PIdentityVerificationPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart` |
| SC-403 | `sc403P2PKycFaceMatch` | `/p2p/kyc/face-match` | `P2PSelfieVerificationPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_selfie_verification_page.dart` |

#### Flow: P2P account security (7 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-253 | `sc253P2PSecurityCenter` | `/p2p/security/center` | `P2PSecurityCenterPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_security_center_page.dart` |
| SC-254 | `sc254P2P2FASettings` | `/p2p/security/2fa` | `P2P2FASettingsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_2fa_settings_page.dart` |
| SC-255 | `sc255P2PDeviceManagement` | `/p2p/security/devices` | `P2PDeviceManagementPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_device_management_page.dart` |
| SC-256 | `sc256P2PAntiPhishingCode` | `/p2p/security/anti-phishing` | `P2PAntiPhishingCodePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart` |
| SC-257 | `sc257P2PLoginHistory` | `/p2p/security/login-history` | `P2PLoginHistoryPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_login_history_page.dart` |
| SC-258 | `sc258P2PSuspiciousActivity` | `/p2p/security/suspicious-activity` | `P2PSuspiciousActivityPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_suspicious_activity_page.dart` |
| SC-404 | `sc404P2PWhitelistMode` | `/p2p/security/whitelist` | `P2PWhitelistModePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_security_center_page.dart` |

### Feature / Capability: P2P Risk, Compliance and Wallet Operations

- Technical module(s): `p2p`
- Flow count: **3**
- Screen count: **27**

#### Flow: P2P insurance fund (7 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-238 | `sc238P2PInsuranceFund` | `/p2p/insurance` | `P2PInsuranceFundPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_insurance_fund_page.dart` |
| SC-239 | `sc239P2PInsuranceCertificate` | `/p2p/insurance/certificate` | `P2PInsuranceCertificatePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_insurance_certificate_page.dart` |
| SC-240 | `sc240P2PInsuranceScore` | `/p2p/insurance/score` | `P2PInsuranceScorePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart` |
| SC-241 | `sc241P2PInsurancePolicy` | `/p2p/insurance/policy` | `P2PInsurancePolicyPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_insurance_policy_page.dart` |
| SC-242 | `sc242P2PContributionHistory` | `/p2p/insurance/contribution-history` | `P2PContributionHistoryPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_contribution_history_page.dart` |
| SC-243 | `sc243P2PClaimDetail` | `/p2p/insurance/claim/:claimId` | `P2PClaimDetailPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_claim_detail_page.dart` |
| SC-244 | `sc244P2PInsuranceFundAlias` | `/p2p/insurance-fund` | `P2PInsuranceFundPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_insurance_fund_page.dart` |

#### Flow: P2P wallet, dashboard and safety tools (12 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-259 | `sc259P2PE2EInfo` | `/p2p/e2e-info` | `P2PE2EInfoPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart` |
| SC-260 | `sc260P2PFraudPrevention` | `/p2p/fraud-prevention` | `P2PFraudPreventionPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_fraud_prevention_page.dart` |
| SC-261 | `sc261P2PWalletTransfer` | `/p2p/wallet/transfer` | `P2PWalletTransferPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_transfer_page.dart` |
| SC-269 | `sc269P2PSourceOfFunds` | `/p2p/compliance/source-of-funds` | `P2PSourceOfFundsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_source_of_funds_page.dart` |
| SC-270 | `sc270P2PLargeTransaction` | `/p2p/compliance/large-transaction` | `P2PLargeTransactionJustificationPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_large_transaction_justification_page.dart` |
| SC-271 | `sc271P2PRiskAssessment` | `/p2p/compliance/risk-assessment` | `P2PRiskAssessmentPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_risk_assessment_page.dart` |
| SC-272 | `sc272P2PTaxReporting` | `/p2p/tax-reporting` | `P2PTaxReportingPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_tax_reporting_page.dart` |
| SC-273 | `sc273P2POrderBook` | `/p2p/order-book` | `P2POrderBookPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_book_page.dart` |
| SC-275 | `sc275P2PAchievements` | `/p2p/achievements` | `P2PAchievementsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_achievements_page.dart` |
| SC-276 | `sc276P2PBlacklistAdd` | `/p2p/blacklist/add` | `P2PBlacklistAddPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart` |
| SC-277 | `sc277P2PBlacklist` | `/p2p/blacklist` | `P2PBlacklistPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_blacklist_page.dart` |
| SC-282 | `sc282P2PHome` | `/p2p` | `P2PHomePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_home_page.dart` |

#### Flow: P2P compliance, limits and tax (8 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-262 | `sc262P2PFundLockHistory` | `/p2p/wallet/fund-lock-history` | `P2PFundLockHistoryPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_fund_lock_history_page.dart` |
| SC-263 | `sc263P2PWalletHistoryAlias` | `/p2p/wallet/history` | `P2PFundLockHistoryPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_fund_lock_history_page.dart` |
| SC-264 | `sc264P2PWallet` | `/p2p/wallet` | `P2PWalletPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_page.dart` |
| SC-265 | `sc265P2PLimitTracker` | `/p2p/limits/tracker` | `P2PLimitTrackerPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_limit_tracker_page.dart` |
| SC-266 | `sc266P2PTransactionLimits` | `/p2p/limits` | `P2PTransactionLimitsPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_transaction_limits_page.dart` |
| SC-267 | `sc267P2PComplianceOverview` | `/p2p/compliance/overview` | `P2PComplianceOverviewPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart` |
| SC-268 | `sc268P2PAmlScreening` | `/p2p/compliance/aml-screening` | `P2PAmlScreeningPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_aml_screening_page.dart` |
| SC-407 | `sc407P2PTaxReportDetail` | `/p2p/tax-report/detailed/:year` | `P2PTaxReportingPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_tax_reporting_page.dart` |

### Feature / Capability: P2P Trading

- Technical module(s): `p2p`
- Flow count: **1**
- Screen count: **2**

#### Flow: P2P escrow and balance (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-245 | `sc245P2PEscrowBalance` | `/p2p/escrow/balance` | `P2PEscrowBalancePage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_escrow_balance_page.dart` |
| SC-246 | `sc246P2PEscrowDetail` | `/p2p/escrow/:orderId` | `P2PEscrowDetailPage` | `flutter_app/lib/features/p2p/presentation/pages/p2p_escrow_detail_page.dart` |

## Product Area: Wallet and Treasury

### Feature / Capability: Wallet Management and Monitoring

- Technical module(s): `wallet`
- Flow count: **2**
- Screen count: **10**

#### Flow: Wallet overview, history and transaction detail (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-135 | `sc135Wallet` | `/wallet` | `WalletPage` | `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart` |
| SC-136 | `sc136TxHistory` | `/wallet/history` | `TransactionHistoryPage` | `flutter_app/lib/features/wallet/presentation/pages/transaction_history_page.dart` |
| SC-141 | `sc141TransactionDetail` | `/wallet/transaction/:txId` | `TransactionDetailPage` | `flutter_app/lib/features/wallet/presentation/pages/transaction_detail_page.dart` |
| SC-142 | `sc142PortfolioAnalytics` | `/wallet/portfolio-analytics` | `PortfolioAnalyticsPage` | `flutter_app/lib/features/wallet/presentation/pages/portfolio_analytics_page.dart` |

#### Flow: Wallet operations, gas, approvals and health (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-148 | `sc148MultiManager` | `/wallet/multi-manager` | `WalletMultiManagerPage` | `flutter_app/lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart` |
| SC-149 | `sc149GasOptimizer` | `/wallet/gas-optimizer` | `WalletGasOptimizerPage` | `flutter_app/lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart` |
| SC-150 | `sc150TokenApproval` | `/wallet/token-approval` | `WalletTokenApprovalPage` | `flutter_app/lib/features/wallet/presentation/pages/wallet_token_approval_page.dart` |
| SC-151 | `sc151HealthScore` | `/wallet/health-score` | `WalletHealthScorePage` | `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page.dart` |
| SC-154 | `sc154DustConverter` | `/wallet/dust-converter` | `DustConverterPage` | `flutter_app/lib/features/wallet/presentation/pages/dust_converter_page.dart` |
| SC-155 | `sc155NetworkStatus` | `/wallet/network-status` | `NetworkStatusPage` | `flutter_app/lib/features/wallet/presentation/pages/network_status_page.dart` |

### Feature / Capability: Wallet Money Movement

- Technical module(s): `wallet`
- Flow count: **4**
- Screen count: **11**

#### Flow: Deposit and pending deposit tracking (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-137 | `sc137Deposit` | `/wallet/deposit` | `DepositPage` | `flutter_app/lib/features/wallet/presentation/pages/deposit_page.dart` |
| SC-138 | `sc138DepositUsdt` | `/wallet/deposit/:asset` | `DepositPage` | `flutter_app/lib/features/wallet/presentation/pages/deposit_page.dart` |
| SC-152 | `sc152PendingDeposits` | `/wallet/pending-deposits` | `PendingDepositsPage` | `flutter_app/lib/features/wallet/presentation/pages/pending_deposits_page.dart` |

#### Flow: Withdraw and limit controls (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-139 | `sc139Withdraw` | `/wallet/withdraw` | `WithdrawPage` | `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart` |
| SC-140 | `sc140WithdrawUsdt` | `/wallet/withdraw/:asset` | `WithdrawPage` | `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart` |
| SC-153 | `sc153WithdrawLimits` | `/wallet/limits` | `WithdrawLimitsPage` | `flutter_app/lib/features/wallet/presentation/pages/withdraw_limits_page.dart` |

#### Flow: Address book management (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-143 | `sc143AddressAdd` | `/wallet/address-book/add` | `AddressAddPage` | `flutter_app/lib/features/wallet/presentation/pages/address_add_page.dart` |
| SC-144 | `sc144AddressBook` | `/wallet/address-book` | `AddressBookPage` | `flutter_app/lib/features/wallet/presentation/pages/address_book_page.dart` |

#### Flow: Asset, buy and transfer flows (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-145 | `sc145BuyCrypto` | `/wallet/buy-crypto` | `BuyCryptoPage` | `flutter_app/lib/features/wallet/presentation/pages/buy_crypto_page.dart` |
| SC-146 | `sc146Transfer` | `/wallet/transfer` | `TransferPage` | `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart` |
| SC-147 | `sc147AssetDetail` | `/wallet/asset/:assetId` | `AssetDetailPage` | `flutter_app/lib/features/wallet/presentation/pages/asset_detail_page.dart` |

## Product Area: Earn and Savings

### Feature / Capability: Staking / Earn

- Technical module(s): `earn`
- Flow count: **7**
- Screen count: **46**

#### Flow: Earn and staking entry (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-327 | `sc327StakingEarn` | `/earn` | `StakingEarnPage` | `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart` |
| SC-328 | `sc328StakingEarnStaking` | `/earn/staking` | `StakingEarnPage` | `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart` |

#### Flow: Staking terms, risk and policy (5 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-353 | `sc353StakingTerms` | `/earn/staking/terms` | `StakingTermsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_terms_page.dart` |
| SC-354 | `sc354StakingRiskDisclosure` | `/earn/staking/risk-disclosure` | `StakingRiskDisclosurePage` | `flutter_app/lib/features/earn/presentation/pages/staking_risk_disclosure_page.dart` |
| SC-355 | `sc355StakingWithdrawalPolicy` | `/earn/staking/withdrawal-policy` | `StakingWithdrawalPolicyPage` | `flutter_app/lib/features/earn/presentation/pages/staking_withdrawal_policy_page.dart` |
| SC-356 | `sc356StakingTaxGuide` | `/earn/staking/tax-guide` | `StakingTaxGuidePage` | `flutter_app/lib/features/earn/presentation/pages/staking_tax_guide_page.dart` |
| SC-357 | `sc357StakingRiskAssessment` | `/earn/staking/risk-assessment` | `StakingRiskAssessmentPage` | `flutter_app/lib/features/earn/presentation/pages/staking_risk_assessment_page.dart` |

#### Flow: Staking dashboard and history (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-358 | `sc358StakingDashboard` | `/earn/dashboard` | `StakingDashboardPage` | `flutter_app/lib/features/earn/presentation/pages/staking_dashboard_page.dart` |
| SC-359 | `sc359StakingAnalytics` | `/earn/analytics` | `StakingAnalyticsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_analytics_page.dart` |
| SC-360 | `sc360StakingHistory` | `/earn/history` | `StakingHistoryPage` | `flutter_app/lib/features/earn/presentation/pages/staking_history_page.dart` |
| SC-361 | `sc361StakingEarningsCalendar` | `/earn/calendar` | `StakingEarningsCalendarPage` | `flutter_app/lib/features/earn/presentation/pages/staking_earnings_calendar_page.dart` |

#### Flow: Staking operations and products (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-362 | `sc362StakingValidatorSelection` | `/earn/validator-selection` | `StakingValidatorSelectionPage` | `flutter_app/lib/features/earn/presentation/pages/staking_validator_selection_page.dart` |
| SC-363 | `sc363StakingAutoCompound` | `/earn/auto-compound` | `StakingAutoCompoundPage` | `flutter_app/lib/features/earn/presentation/pages/staking_auto_compound_page.dart` |
| SC-364 | `sc364StakingLiquidStaking` | `/earn/liquid-staking` | `StakingLiquidStakingPage` | `flutter_app/lib/features/earn/presentation/pages/staking_liquid_staking_page.dart` |
| SC-366 | `sc366StakingAdvancedOrders` | `/earn/advanced-orders` | `StakingAdvancedOrdersPage` | `flutter_app/lib/features/earn/presentation/pages/staking_advanced_orders_page.dart` |
| SC-367 | `sc367StakingMultiChain` | `/earn/multi-chain` | `StakingMultiChainPage` | `flutter_app/lib/features/earn/presentation/pages/staking_multi_chain_page.dart` |
| SC-368 | `sc368StakingInstitutional` | `/earn/institutional` | `StakingInstitutionalPage` | `flutter_app/lib/features/earn/presentation/pages/staking_institutional_page.dart` |

#### Flow: Staking compliance, custody and risk controls (15 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-365 | `sc365StakingInsurance` | `/earn/insurance` | `StakingInsurancePage` | `flutter_app/lib/features/earn/presentation/pages/staking_insurance_page.dart` |
| SC-373 | `sc373StakingRegulatoryFramework` | `/earn/regulatory-framework` | `StakingRegulatoryFrameworkPage` | `flutter_app/lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart` |
| SC-374 | `sc374StakingAuditReports` | `/earn/audit-reports` | `StakingAuditReportsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_audit_reports_page.dart` |
| SC-375 | `sc375StakingCustody` | `/earn/custody` | `StakingCustodyPage` | `flutter_app/lib/features/earn/presentation/pages/staking_custody_page.dart` |
| SC-376 | `sc376StakingSuitabilityAssessment` | `/earn/suitability-assessment` | `StakingSuitabilityAssessmentPage` | `flutter_app/lib/features/earn/presentation/pages/staking_suitability_assessment_page.dart` |
| SC-377 | `sc377StakingInsuranceFundTransparency` | `/earn/insurance-fund-transparency` | `StakingInsuranceFundTransparencyPage` | `flutter_app/lib/features/earn/presentation/pages/staking_insurance_fund_transparency_page.dart` |
| SC-378 | `sc378StakingTransactionReporting` | `/earn/transaction-reporting` | `StakingTransactionReportingPage` | `flutter_app/lib/features/earn/presentation/pages/staking_transaction_reporting_page.dart` |
| SC-379 | `sc379StakingApiDocumentation` | `/earn/api-documentation` | `StakingApiDocumentationPage` | `flutter_app/lib/features/earn/presentation/pages/staking_api_documentation_page.dart` |
| SC-380 | `sc380StakingProofOfReserves` | `/earn/proof-of-reserves` | `StakingProofOfReservesPage` | `flutter_app/lib/features/earn/presentation/pages/staking_proof_of_reserves_page.dart` |
| SC-381 | `sc381StakingRiskDashboard` | `/earn/risk-dashboard` | `StakingRiskDashboardPage` | `flutter_app/lib/features/earn/presentation/pages/staking_risk_dashboard_page.dart` |
| SC-382 | `sc382StakingSlashingHistory` | `/earn/slashing-history` | `StakingSlashingHistoryPage` | `flutter_app/lib/features/earn/presentation/pages/staking_slashing_history_page.dart` |
| SC-383 | `sc383StakingValidatorHealthMonitor` | `/earn/validator-health-monitor` | `StakingValidatorHealthMonitorPage` | `flutter_app/lib/features/earn/presentation/pages/staking_validator_health_monitor_page.dart` |
| SC-384 | `sc384StakingRiskScoreCalculator` | `/earn/risk-score-calculator` | `StakingRiskScoreCalculatorPage` | `flutter_app/lib/features/earn/presentation/pages/staking_risk_score_calculator_page.dart` |
| SC-385 | `sc385StakingEmergencyActions` | `/earn/emergency-actions` | `StakingEmergencyActionsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_emergency_actions_page.dart` |
| SC-386 | `sc386StakingContingencyPlan` | `/earn/contingency-plan` | `StakingContingencyPlanPage` | `flutter_app/lib/features/earn/presentation/pages/staking_contingency_plan_page.dart` |

#### Flow: Staking education and recommendations (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-369 | `sc369StakingGuide` | `/earn/guide` | `StakingGuidePage` | `flutter_app/lib/features/earn/presentation/pages/staking_guide_page.dart` |
| SC-370 | `sc370StakingFAQ` | `/earn/faq` | `StakingFAQPage` | `flutter_app/lib/features/earn/presentation/pages/staking_faq_page.dart` |
| SC-371 | `sc371StakingNotifications` | `/earn/notifications` | `StakingNotificationsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_notifications_page.dart` |
| SC-372 | `sc372StakingRecommendations` | `/earn/recommendations` | `StakingRecommendationsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_recommendations_page.dart` |

#### Flow: Staking community, governance and integrations (10 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-387 | `sc387StakingSocialFeed` | `/earn/social-feed` | `StakingSocialFeedPage` | `flutter_app/lib/features/earn/presentation/pages/staking_social_feed_page.dart` |
| SC-388 | `sc388StakingCommunityGovernance` | `/earn/community-governance` | `StakingCommunityGovernancePage` | `flutter_app/lib/features/earn/presentation/pages/staking_community_governance_page.dart` |
| SC-389 | `sc389StakingProposals` | `/earn/proposals` | `StakingProposalsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_proposals_page.dart` |
| SC-390 | `sc390StakingVotingDetail` | `/earn/voting/:proposalId` | `StakingVotingPage` | `flutter_app/lib/features/earn/presentation/pages/staking_voting_page.dart` |
| SC-391 | `sc391StakingVoting` | `/earn/voting` | `StakingVotingPage` | `flutter_app/lib/features/earn/presentation/pages/staking_voting_page.dart` |
| SC-392 | `sc392StakingForum` | `/earn/forum` | `StakingForumPage` | `flutter_app/lib/features/earn/presentation/pages/staking_forum_page.dart` |
| SC-393 | `sc393StakingWebhooks` | `/earn/webhooks` | `StakingWebhooksPage` | `flutter_app/lib/features/earn/presentation/pages/staking_webhooks_page.dart` |
| SC-394 | `sc394StakingDataExport` | `/earn/data-export` | `StakingDataExportPage` | `flutter_app/lib/features/earn/presentation/pages/staking_data_export_page.dart` |
| SC-395 | `sc395StakingThirdPartyIntegrations` | `/earn/third-party-integrations` | `StakingThirdPartyIntegrationsPage` | `flutter_app/lib/features/earn/presentation/pages/staking_third_party_integrations_page.dart` |
| SC-396 | `sc396StakingDeveloperConsole` | `/earn/developer-console` | `StakingDeveloperConsolePage` | `flutter_app/lib/features/earn/presentation/pages/staking_developer_console_page.dart` |

### Feature / Capability: Savings

- Technical module(s): `earn`
- Flow count: **3**
- Screen count: **24**

#### Flow: Savings product and portfolio lifecycle (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-329 | `sc329Savings` | `/earn/savings` | `SavingsPage` | `flutter_app/lib/features/earn/presentation/pages/savings_page.dart` |
| SC-330 | `sc330SavingsProductDetail` | `/earn/savings/product/sample` | `SavingsProductDetailPage` | `flutter_app/lib/features/earn/presentation/pages/savings_product_detail_page.dart` |
| SC-331 | `sc331SavingsRedeem` | `/earn/savings/redeem/pos001` | `SavingsRedeemPage` | `flutter_app/lib/features/earn/presentation/pages/savings_redeem_page.dart` |
| SC-332 | `sc332SavingsReceipt` | `/earn/savings/receipt` | `SavingsReceiptPage` | `flutter_app/lib/features/earn/presentation/pages/savings_receipt_page.dart` |
| SC-333 | `sc333SavingsPortfolio` | `/earn/savings/portfolio` | `SavingsPortfolioPage` | `flutter_app/lib/features/earn/presentation/pages/savings_portfolio_page.dart` |
| SC-334 | `sc334SavingsHistory` | `/earn/savings/history` | `SavingsHistoryPage` | `flutter_app/lib/features/earn/presentation/pages/savings_history_page.dart` |

#### Flow: Savings education, risk and comparison (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-335 | `sc335SavingsGuide` | `/earn/savings/guide` | `SavingsGuidePage` | `flutter_app/lib/features/earn/presentation/pages/savings_guide_page.dart` |
| SC-336 | `sc336SavingsFAQ` | `/earn/savings/faq` | `SavingsFAQPage` | `flutter_app/lib/features/earn/presentation/pages/savings_faq_page.dart` |
| SC-337 | `sc337SavingsNotifications` | `/earn/savings/notifications` | `SavingsNotificationsPage` | `flutter_app/lib/features/earn/presentation/pages/savings_notifications_page.dart` |
| SC-338 | `sc338SavingsRecommendations` | `/earn/savings/recommendations` | `SavingsRecommendationsPage` | `flutter_app/lib/features/earn/presentation/pages/savings_recommendations_page.dart` |
| SC-339 | `sc339SavingsRiskAssessment` | `/earn/savings/risk-assessment` | `SavingsRiskAssessmentPage` | `flutter_app/lib/features/earn/presentation/pages/savings_risk_assessment_page.dart` |
| SC-340 | `sc340SavingsComparison` | `/earn/savings/comparison` | `SavingsComparisonPage` | `flutter_app/lib/features/earn/presentation/pages/savings_comparison_page.dart` |

#### Flow: Savings automation, analytics and planning (12 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-341 | `sc341AutoCompoundSettings` | `/earn/savings/auto-compound` | `AutoCompoundSettingsPage` | `flutter_app/lib/features/earn/presentation/pages/auto_compound_settings_page.dart` |
| SC-342 | `sc342SavingsGoal` | `/earn/savings/goals` | `SavingsGoalPage` | `flutter_app/lib/features/earn/presentation/pages/savings_goal_page.dart` |
| SC-343 | `sc343SavingsAnalytics` | `/earn/savings/analytics` | `SavingsAnalyticsPage` | `flutter_app/lib/features/earn/presentation/pages/savings_analytics_page.dart` |
| SC-344 | `sc344SavingsAutoRebalance` | `/earn/savings/rebalance` | `SavingsAutoRebalancePage` | `flutter_app/lib/features/earn/presentation/pages/savings_auto_rebalance_page.dart` |
| SC-345 | `sc345SavingsNotificationPreferences` | `/earn/savings/notification-preferences` | `SavingsNotificationPreferencesPage` | `flutter_app/lib/features/earn/presentation/pages/savings_notification_preferences_page.dart` |
| SC-346 | `sc346SavingsDca` | `/earn/savings/dca` | `SavingsDCAPage` | `flutter_app/lib/features/earn/presentation/pages/savings_dca_page.dart` |
| SC-347 | `sc347SavingsSmartSuggestions` | `/earn/savings/smart-suggestions` | `SavingsSmartSuggestionsPage` | `flutter_app/lib/features/earn/presentation/pages/savings_smart_suggestions_page.dart` |
| SC-348 | `sc348SavingsExport` | `/earn/savings/export` | `SavingsExportPage` | `flutter_app/lib/features/earn/presentation/pages/savings_export_page.dart` |
| SC-349 | `sc349SavingsBacktest` | `/earn/savings/backtest` | `SavingsBacktestPage` | `flutter_app/lib/features/earn/presentation/pages/savings_backtest_page.dart` |
| SC-350 | `sc350SavingsAutoPilot` | `/earn/savings/autopilot` | `SavingsAutoPilotPage` | `flutter_app/lib/features/earn/presentation/pages/savings_autopilot_page.dart` |
| SC-351 | `sc351SavingsLadder` | `/earn/savings/ladder` | `SavingsLadderPage` | `flutter_app/lib/features/earn/presentation/pages/savings_ladder_page.dart` |
| SC-352 | `sc352SavingsWhatIf` | `/earn/savings/whatif` | `SavingsWhatIfPage` | `flutter_app/lib/features/earn/presentation/pages/savings_what_if_page.dart` |

## Product Area: Investment Automation

### Feature / Capability: DCA / Auto-Invest

- Technical module(s): `dca`
- Flow count: **4**
- Screen count: **14**

#### Flow: DCA overview and demo (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-169 | `sc169Dca` | `/dca` | `DCAPage` | `flutter_app/lib/features/dca/presentation/pages/dca_page.dart` |
| SC-400 | `sc400DcaOverviewDemo` | `/dev/dca-overview` | `DCAOverviewDemo` | `flutter_app/lib/features/dca/presentation/pages/dca_overview_demo.dart` |

#### Flow: DCA rebalance lifecycle (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-170 | `sc170DcaRebalanceConfig` | `/dca/rebalance/config` | `DCARebalanceConfig` | `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page.dart` |
| SC-171 | `sc171DcaRebalanceDashboard` | `/dca/rebalance/config001` | `DCARebalanceDashboard` | `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_dashboard_page.dart` |
| SC-408 | `sc408DcaRebalanceEdit` | `/dca/rebalance/:configId/edit` | `DCARebalanceConfig` | `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page.dart` |
| SC-409 | `sc409DcaRebalanceHistory` | `/dca/rebalance/:configId/history` | `DCARebalanceDashboard` | `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_dashboard_page.dart` |

#### Flow: DCA schedule lifecycle (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-172 | `sc172DcaScheduleConfig` | `/dca/schedule/config` | `DCAScheduleConfig` | `flutter_app/lib/features/dca/presentation/pages/dca_schedule_config_page.dart` |
| SC-173 | `sc173DcaScheduleAnalytics` | `/dca/schedule/config001` | `DCAScheduleAnalytics` | `flutter_app/lib/features/dca/presentation/pages/dca_schedule_analytics_page.dart` |

#### Flow: DCA optimization and strategy tools (6 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-174 | `sc174DcaPortfolioOptimizer` | `/dca/portfolio-optimizer` | `DCAPortfolioOptimizer` | `flutter_app/lib/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart` |
| SC-175 | `sc175DcaDynamicAmount` | `/dca/dynamic-amount` | `DCADynamicAmount` | `flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page.dart` |
| SC-176 | `sc176DcaBacktester` | `/dca/backtester` | `DCABacktesterPage` | `flutter_app/lib/features/dca/presentation/pages/dca_backtester_page.dart` |
| SC-177 | `sc177DcaMultiAsset` | `/dca/multi-asset` | `DCAMultiAssetPage` | `flutter_app/lib/features/dca/presentation/pages/dca_multi_asset_page.dart` |
| SC-178 | `sc178DcaPerformanceCompare` | `/dca/performance-compare` | `DCAPerformanceComparePage` | `flutter_app/lib/features/dca/presentation/pages/dca_performance_compare_page.dart` |
| SC-179 | `sc179DcaSmartRules` | `/dca/smart-rules` | `DCASmartRulesPage` | `flutter_app/lib/features/dca/presentation/pages/dca_smart_rules_page.dart` |

## Product Area: Launchpad and Token Access

### Feature / Capability: Launchpad Portfolio and Staking

- Technical module(s): `launchpad`
- Flow count: **1**
- Screen count: **4**

#### Flow: Launchpad overview, portfolio and staking (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-295 | `sc295Launchpad` | `/launchpad` | `LaunchpadPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_page.dart` |
| SC-296 | `sc296LaunchpadPortfolio` | `/launchpad/portfolio` | `LaunchpadPortfolioPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_portfolio_page.dart` |
| SC-297 | `sc297LaunchpadPerformance` | `/launchpad/performance` | `LaunchpadPerformancePage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_performance_page.dart` |
| SC-298 | `sc298LaunchpadStaking` | `/launchpad/staking` | `LaunchpadStakingPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_staking_page.dart` |

### Feature / Capability: Launchpad Participation and Settlement

- Technical module(s): `launchpad`
- Flow count: **2**
- Screen count: **8**

#### Flow: Launchpad IDO bridge, contract and receipt flow (5 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-299 | `sc299LaunchpadIdoBridge` | `/launchpad/idobridge/sample` | `LaunchpadIdoBridgePage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_ido_bridge_page.dart` |
| SC-300 | `sc300LaunchpadContract` | `/launchpad/contract/sample` | `LaunchpadContractPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_contract_page.dart` |
| SC-301 | `sc301LaunchpadReceipt` | `/launchpad/receipt/sub001` | `LaunchpadReceiptPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_receipt_page.dart` |
| SC-304 | `sc304LaunchpadBatchClaim` | `/launchpad/batch-claim` | `LaunchpadBatchClaimPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart` |
| SC-305 | `sc305LaunchpadBridgeCompare` | `/launchpad/bridge-compare` | `LaunchpadBridgeComparePage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_bridge_compare_page.dart` |

#### Flow: Launchpad claim and receipt flow (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-302 | `sc302LaunchpadClaimReceipt` | `/launchpad/claim-receipt/pos001` | `LaunchpadClaimReceiptPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_claim_receipt_page.dart` |
| SC-303 | `sc303LaunchpadBridgeOrder` | `/launchpad/bridge-order/tx001` | `LaunchpadBridgeOrderPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_bridge_order_page.dart` |
| SC-306 | `sc306LaunchpadNotifSound` | `/launchpad/notif-sound` | `LaunchpadNotifSoundPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_notif_sound_page.dart` |

### Feature / Capability: Launchpad Operations and Risk Tools

- Technical module(s): `launchpad`
- Flow count: **2**
- Screen count: **12**

#### Flow: Launchpad operations, notifications and address book (5 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-307 | `sc307LaunchpadEventLog` | `/launchpad/event-log` | `LaunchpadEventLogPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_event_log_page.dart` |
| SC-308 | `sc308LaunchpadAbiDiff` | `/launchpad/abi-diff/contract001` | `LaunchpadAbiDiffPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_abi_diff_page.dart` |
| SC-309 | `sc309LaunchpadAddressBook` | `/launchpad/address-book` | `LaunchpadAddressBookPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_address_book_page.dart` |
| SC-310 | `sc310LaunchpadWebhooks` | `/launchpad/webhooks` | `LaunchpadWebhooksPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_webhooks_page.dart` |
| SC-311 | `sc311LaunchpadGasTracker` | `/launchpad/gas-tracker` | `LaunchpadGasTrackerPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page.dart` |

#### Flow: Launchpad execution, automation and risk tools (7 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-312 | `sc312LaunchpadRebalance` | `/launchpad/rebalance` | `LaunchpadRebalancePage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart` |
| SC-313 | `sc313LaunchpadMultisig` | `/launchpad/multisig` | `LaunchpadMultisigPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_multisig_page.dart` |
| SC-314 | `sc314LaunchpadSwapAggregator` | `/launchpad/swap-aggregator` | `LaunchpadSwapAggregatorPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_swap_aggregator_page.dart` |
| SC-315 | `sc315LaunchpadLimitOrders` | `/launchpad/limit-orders` | `LaunchpadLimitOrdersPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_limit_orders_page.dart` |
| SC-316 | `sc316LaunchpadDcaBuilder` | `/launchpad/dca-builder` | `LaunchpadDcaBuilderPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart` |
| SC-317 | `sc317LaunchpadRiskAnalytics` | `/launchpad/risk-analytics` | `LaunchpadRiskAnalyticsPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_risk_analytics_page.dart` |
| SC-318 | `sc318LaunchpadDetail` | `/launchpad/sample` | `LaunchpadDetailPage` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_detail_page.dart` |

## Product Area: Open Arena

### Feature / Capability: Open Arena Discovery and Management

- Technical module(s): `arena`
- Flow count: **2**
- Screen count: **5**

#### Flow: Arena discovery, guide and production handoff (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-184 | `sc184ArenaHome` | `/arena` | `ArenaHomePage` | `flutter_app/lib/features/arena/presentation/pages/arena_home_page.dart` |
| SC-197 | `sc197ArenaFlowMap` | `/arena/flow-map` | `ArenaFlowMapPage` | `flutter_app/lib/features/arena/presentation/pages/arena_flow_map_page.dart` |
| SC-206 | `sc206ArenaProductionReady` | `/arena/production` | `ArenaProductionReadyPage` | `flutter_app/lib/features/arena/presentation/pages/arena_production_ready_page.dart` |
| SC-209 | `sc209ArenaGuide` | `/arena/guide` | `ArenaGuidePage` | `flutter_app/lib/features/arena/presentation/pages/arena_guide_page.dart` |

#### Flow: My Arena management (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-205 | `sc205MyArena` | `/arena/my` | `MyArenaPage` | `flutter_app/lib/features/arena/presentation/pages/my_arena_page.dart` |

### Feature / Capability: Open Arena Gameplay and Creation

- Technical module(s): `arena`
- Flow count: **3**
- Screen count: **11**

#### Flow: Arena creation studio (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-185 | `sc185ArenaStudio` | `/arena/studio` | `ArenaStudioPage` | `flutter_app/lib/features/arena/presentation/pages/arena_studio_page.dart` |
| SC-186 | `sc186ArenaSmartRules` | `/arena/studio/smart-rules` | `ArenaSmartRuleBuilderPage` | `flutter_app/lib/features/arena/presentation/pages/arena_smart_rule_builder_page.dart` |
| SC-187 | `sc187ArenaPresetLibrary` | `/arena/studio/presets` | `ArenaUniversalPresetLibraryPage` | `flutter_app/lib/features/arena/presentation/pages/arena_universal_preset_library_page.dart` |
| SC-188 | `sc188ArenaGovernanceGate` | `/arena/studio/governance` | `ArenaGovernanceGatePage` | `flutter_app/lib/features/arena/presentation/pages/arena_governance_gate_page.dart` |

#### Flow: Arena mode, challenge and resolution flow (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-189 | `sc189ArenaModeDetail` | `/arena/mode/:modeId` | `ArenaModeDetailPage` | `flutter_app/lib/features/arena/presentation/pages/arena_mode_detail_page.dart` |
| SC-190 | `sc190ArenaChallengeDetail` | `/arena/challenge/:challengeId` | `ArenaChallengeDetailPage` | `flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page.dart` |
| SC-191 | `sc191ArenaJoin` | `/arena/join/:challengeId` | `ArenaJoinPage` | `flutter_app/lib/features/arena/presentation/pages/arena_join_page.dart` |
| SC-192 | `sc192ArenaResolutionCenter` | `/arena/resolution` | `ArenaResolutionCenterPage` | `flutter_app/lib/features/arena/presentation/pages/arena_resolution_center_page.dart` |

#### Flow: Arena creator, leaderboard and verified challenges (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-193 | `sc193ArenaCreator` | `/arena/creator/:creatorId` | `ArenaCreatorPage` | `flutter_app/lib/features/arena/presentation/pages/arena_creator_page.dart` |
| SC-194 | `sc194ArenaLeaderboard` | `/arena/leaderboard` | `ArenaLeaderboardPage` | `flutter_app/lib/features/arena/presentation/pages/arena_leaderboard_page.dart` |
| SC-195 | `sc195VerifiedChallenges` | `/arena/verified` | `VerifiedChallengesPage` | `flutter_app/lib/features/arena/presentation/pages/verified_challenges_page.dart` |

### Feature / Capability: Arena Safety, Trust and Ledger

- Technical module(s): `arena`
- Flow count: **2**
- Screen count: **7**

#### Flow: Arena safety, moderation and reporting (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-198 | `sc198ArenaSafetyCenter` | `/arena/safety` | `ArenaSafetyCenterPage` | `flutter_app/lib/features/arena/presentation/pages/arena_safety_center_page.dart` |
| SC-202 | `sc202ArenaReportCase` | `/arena/report/:caseId` | `ArenaReportCasePage` | `flutter_app/lib/features/arena/presentation/pages/arena_report_case_page.dart` |
| SC-203 | `sc203ArenaBlockedUsers` | `/arena/blocked` | `ArenaBlockedUsersPage` | `flutter_app/lib/features/arena/presentation/pages/arena_blocked_users_page.dart` |
| SC-204 | `sc204MyArenaReports` | `/arena/my-reports` | `MyArenaReportsPage` | `flutter_app/lib/features/arena/presentation/pages/my_arena_reports_page.dart` |

#### Flow: Arena trust and points ledger (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-199 | `sc199ArenaTrustBreakdown` | `/arena/trust/:userId` | `ArenaTrustBreakdownPage` | `flutter_app/lib/features/arena/presentation/pages/arena_trust_breakdown_page.dart` |
| SC-200 | `sc200ArenaPointsEntryDetail` | `/arena/ledger/entry/:entryId` | `ArenaPointsEntryDetailPage` | `flutter_app/lib/features/arena/presentation/pages/arena_points_entry_detail_page.dart` |
| SC-201 | `sc201ArenaPointsLedger` | `/arena/ledger` | `ArenaPointsLedgerPage` | `flutter_app/lib/features/arena/presentation/pages/arena_points_ledger_page.dart` |

### Feature / Capability: Arena Prediction Bridge

- Technical module(s): `arena`
- Flow count: **1**
- Screen count: **2**

#### Flow: Arena and Prediction bridge (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-207 | `sc207ArenaPredictionBridgeFoundation` | `/arena/bridge` | `ArenaPredictionBridgeFoundationPage` | `flutter_app/lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page.dart` |
| SC-208 | `sc208ConnectedEcosystemProduction` | `/arena/ecosystem` | `ConnectedEcosystemProductionPage` | `flutter_app/lib/features/arena/presentation/pages/connected_ecosystem_production_page.dart` |

## Product Area: Growth and Rewards

### Feature / Capability: Rewards and Referral

- Technical module(s): `referral`, `rewards`
- Flow count: **6**
- Screen count: **6**

#### Flow: Referral history (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-286 | `sc286ReferralHistory` | `/referral/history` | `ReferralHistoryPage` | `flutter_app/lib/features/referral/presentation/pages/referral_history_page.dart` |

#### Flow: Referral rewards (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-287 | `sc287ReferralRewards` | `/referral/rewards` | `ReferralRewardsPage` | `flutter_app/lib/features/referral/presentation/pages/referral_rewards_page.dart` |

#### Flow: Referral rules (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-288 | `sc288ReferralRules` | `/referral/rules` | `ReferralRulesPage` | `flutter_app/lib/features/referral/presentation/pages/referral_rules_page.dart` |

#### Flow: Referral friend detail (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-289 | `sc289ReferralFriendDetail` | `/referral/friend/:friendId` | `ReferralFriendDetailPage` | `flutter_app/lib/features/referral/presentation/pages/referral_friend_detail_page.dart` |

#### Flow: Referral program home (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-290 | `sc290ReferralHome` | `/referral` | `ReferralHomePage` | `flutter_app/lib/features/referral/presentation/pages/referral_home_page.dart` |

#### Flow: Rewards hub (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-319 | `sc319RewardsHub` | `/rewards` | `RewardsHubPage` | `flutter_app/lib/features/rewards/presentation/pages/rewards_hub_page.dart` |

## Product Area: Profile and Account

### Feature / Capability: Profile and Account Management

- Technical module(s): `arena`, `predictions`, `profile`
- Flow count: **4**
- Screen count: **16**

#### Flow: Profile, settings and activity (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-156 | `sc156Profile` | `/profile` | `ProfilePage` | `flutter_app/lib/features/profile/presentation/pages/profile_page.dart` |
| SC-157 | `sc157EditProfile` | `/profile/edit` | `EditProfilePage` | `flutter_app/lib/features/profile/presentation/pages/edit_profile_page.dart` |
| SC-158 | `sc158Security` | `/profile/security` | `SecurityPage` | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| SC-164 | `sc164Vip` | `/profile/vip` | `VIPPage` | `flutter_app/lib/features/profile/presentation/pages/vip_page.dart` |

#### Flow: Identity, security and devices (5 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-159 | `sc159Kyc` | `/profile/kyc` | `KYCPage` | `flutter_app/lib/features/profile/presentation/pages/kyc_page.dart` |
| SC-160 | `sc160Settings` | `/profile/settings` | `SettingsPage` | `flutter_app/lib/features/profile/presentation/pages/settings_page.dart` |
| SC-162 | `sc162ApiKeyCreate` | `/profile/api/create` | `ApiKeyCreatePage` | `flutter_app/lib/features/profile/presentation/pages/api_key_create_page.dart` |
| SC-405 | `sc405SettingsSecurityBiometric` | `/settings/security/biometric` | `SecurityPage` | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| SC-406 | `sc406SettingsSecurityChangePassword` | `/settings/security/change-password` | `SecurityPage` | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |

#### Flow: API, subaccounts and VIP (4 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-161 | `sc161ActivityLog` | `/profile/activity` | `ActivityLogPage` | `flutter_app/lib/features/profile/presentation/pages/activity_log_page.dart` |
| SC-163 | `sc163ApiManagement` | `/profile/api` | `ApiManagementPage` | `flutter_app/lib/features/profile/presentation/pages/api_management_page.dart` |
| SC-165 | `sc165DeviceManagement` | `/profile/devices` | `DeviceManagementPage` | `flutter_app/lib/features/profile/presentation/pages/device_management_page.dart` |
| SC-166 | `sc166SubAccount` | `/profile/sub-accounts` | `SubAccountPage` | `flutter_app/lib/features/profile/presentation/pages/sub_account_page.dart` |

#### Flow: Profile module summaries (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-167 | `sc167ProfilePredictions` | `/profile/predictions` | `PredictionsPortfolioPage` | `flutter_app/lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` |
| SC-168 | `sc168MyArena` | `/profile/arena` | `MyArenaPage` | `flutter_app/lib/features/arena/presentation/pages/my_arena_page.dart` |
| SC-413 | `sc413SettingsSecurity` | `/settings/security` | `SecurityPage` | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |

## Product Area: Support and Service

### Feature / Capability: Support and Help

- Technical module(s): `support`
- Flow count: **3**
- Screen count: **3**

#### Flow: Support ticket center (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-292 | `sc292HelpCenter` | `/support/help` | `HelpCenterPage` | `flutter_app/lib/features/support/presentation/pages/help_center_page.dart` |

#### Flow: Announcements (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-293 | `sc293Announcements` | `/support/announcements` | `AnnouncementsPage` | `flutter_app/lib/features/support/presentation/pages/announcements_page.dart` |

#### Flow: Help center (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-294 | `sc294Support` | `/support` | `SupportPage` | `flutter_app/lib/features/support/presentation/pages/support_page.dart` |

## Product Area: Enterprise Operations

### Feature / Capability: Admin and Analytics

- Technical module(s): `admin`
- Flow count: **2**
- Screen count: **5**

#### Flow: Admin operations (2 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-180 | `sc180AdminHome` | `/admin` | `AdminHome` | `flutter_app/lib/features/admin/presentation/pages/admin_home.dart` |
| SC-410 | `sc410AdminSettings` | `/admin/settings` | `AdminSettingsPage` | `flutter_app/lib/features/admin/presentation/pages/admin_settings_page.dart` |

#### Flow: Admin analytics dashboards (3 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-181 | `sc181AnalyticsDashboard` | `/admin/analytics` | `AnalyticsDashboard` | `flutter_app/lib/features/admin/presentation/pages/analytics_dashboard.dart` |
| SC-182 | `sc182AbTestDashboard` | `/admin/abtests` | `ABTestDashboard` | `flutter_app/lib/features/admin/presentation/pages/ab_test_dashboard.dart` |
| SC-183 | `sc183FunnelDashboard` | `/admin/funnels` | `FunnelDashboard` | `flutter_app/lib/features/admin/presentation/pages/funnel_dashboard.dart` |

### Feature / Capability: Enterprise Cross-Module Intelligence

- Technical module(s): `cross_module`, `enterprise_states`
- Flow count: **5**
- Screen count: **5**

#### Flow: Enterprise state patterns (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-320 | `sc320EnterpriseStates` | `/enterprise-states` | `EnterpriseStatesPage` | `flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` |

#### Flow: Unified portfolio intelligence (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-321 | `sc321UnifiedPortfolio` | `/unified-portfolio` | `UnifiedPortfolioDashboard` | `flutter_app/lib/features/cross_module/presentation/pages/unified_portfolio_dashboard.dart` |

#### Flow: Cross-module analytics (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-322 | `sc322CrossModuleAnalytics` | `/cross-module-analytics` | `CrossModuleAnalytics` | `flutter_app/lib/features/cross_module/presentation/pages/cross_module_analytics.dart` |

#### Flow: Smart alerts (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-323 | `sc323SmartAlertCenter` | `/smart-alerts` | `SmartAlertCenter` | `flutter_app/lib/features/cross_module/presentation/pages/smart_alert_center.dart` |

#### Flow: Tax reporting (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-324 | `sc324TaxReportCenter` | `/tax-reports` | `TaxReportCenter` | `flutter_app/lib/features/cross_module/presentation/pages/tax_report_center.dart` |

## Product Area: Developer and QA Tooling

### Feature / Capability: Developer and QA Tools

- Technical module(s): `dev`, `trade`
- Flow count: **5**
- Screen count: **5**

#### Flow: Route QA (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-325 | `sc325RouteChecker` | `/dev/route-checker` | `RouteChecker` | `flutter_app/lib/features/dev/presentation/pages/route_checker_page.dart` |

#### Flow: Performance QA (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-326 | `sc326PerformanceMonitor` | `/dev/performance-monitor` | `PerformanceMonitor` | `flutter_app/lib/features/dev/presentation/pages/performance_monitor.dart` |

#### Flow: Development showcase (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-398 | `sc398MissingScreensShowcase` | `/dev/showcase` | `MissingScreensShowcasePage` | `flutter_app/lib/features/dev/presentation/pages/missing_screens_showcase_page.dart` |

#### Flow: Design system QA (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-399 | `sc399DesignSystem` | `/dev/design-system` | `DesignSystemPage` | `flutter_app/lib/features/dev/presentation/pages/design_system_page.dart` |

#### Flow: Copy trading card demo (1 screens)

| SC | Screen / Route Name | Route Path | Widget / Page | Source File |
| --- | --- | --- | --- | --- |
| SC-401 | `sc401CopyTradingCardDemo` | `/demo/copy-card` | `CopyTradingCardDemo` | `flutter_app/lib/features/trade/presentation/pages/copy_trading_card_demo.dart` |

