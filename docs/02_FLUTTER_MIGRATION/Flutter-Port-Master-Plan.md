# Flutter Port Master Plan

Generated: 2026-05-19
Source of truth: `output/flutter-ui-reference/manifest.json`
Coverage baseline: 401 screens, 802 screenshots, viewport 440x956, dark theme.

## AI Execution Contract

- The migration must use a screen-by-screen workflow.
- Implement exactly one `SC-xxx` screen per task unless explicitly instructed otherwise.
- Do not implement a whole module in one pass.
- A screen is not done until Flutter UI, navigation, BE contract, and visual QA are checked.
- Use the `Screen Checklist` row as the unit of work and the `Source File Index` row as the React source lookup for that unit.

## Overview

- Port one screen per task. Do not rebuild a whole module in one large change.
- Every screen must match its viewport and full-page screenshots before BE wiring is considered complete.
- Use React source only as behavior and layout reference; Flutter implementation must use Flutter-native widgets and shared design tokens.
- `SC-007 HomePage` is the Flutter native color/size/chrome standard for all later screens. Use `Flutter-Native-Design-Standard.md` before porting or reviewing any `SC-xxx`.
- React screenshot parity does not permit legacy blue native brand drift. In native runtime, normalize backgrounds, surfaces, CTAs, cards, bottom nav, spacing, radii, and typography back to the Home standard unless a screen-specific exception is documented.
- Prediction Markets are wallet/value surfaces. Arena is points-only. These BE domains must stay separate.
- Each checklist row has independent Flutter, BE, and QA status so the team can port screen by screen without losing coverage.

## Module Coverage

| Module | Screens | First order | Last order |
| --- | --- | --- | --- |
| trade | 87 | 48 | 134 |
| p2p | 73 | 210 | 282 |
| earn | 70 | 327 | 396 |
| arena | 26 | 184 | 209 |
| launchpad | 24 | 295 | 318 |
| markets | 22 | 8 | 46 |
| wallet | 21 | 135 | 155 |
| predictions | 17 | 27 | 43 |
| profile | 13 | 156 | 168 |
| dca | 11 | 169 | 179 |
| auth | 6 | 1 | 6 |
| dev | 5 | 325 | 400 |
| referral | 5 | 286 | 290 |
| admin | 4 | 180 | 183 |
| cross-module | 4 | 321 | 324 |
| discovery | 3 | 283 | 285 |
| support | 3 | 292 | 294 |
| demo | 1 | 401 | 401 |
| enterprise-states | 1 | 320 | 320 |
| home | 1 | 7 | 7 |
| news | 1 | 47 | 47 |
| notifications | 1 | 291 | 291 |
| onboarding | 1 | 397 | 397 |
| rewards | 1 | 319 | 319 |

## Implementation Phases

Phases define order only; each phase is still executed one screen at a time.

| Phase | Modules | Goal | Done when |
| --- | --- | --- | --- |
| P0 | auth, onboarding, home, shared shell | Establish routing, app shell, theme, status bar, bottom nav, auth placeholders. | Home/auth screenshots match and route skeleton exists. |
| P1 | markets, trade, wallet, profile | Port core trading and wallet journeys with mock repositories. | Core user can browse markets, trade mock, inspect wallet/profile. |
| P2 | p2p, predictions, arena, earn, launchpad, dca | Port large domain modules one screen at a time with separated domain services. | Each domain has independent repos/contracts and no cross-domain leakage. |
| P3 | admin, dev, demo, support, referral, rewards, cross-module | Port internal/reference and support surfaces after main flows. | All remaining manifest screens have visual parity and documented BE status. |

## Porting Workflow For Every Screen

1. Open the row in Screen Checklist and locate viewport/fullpage screenshots.
2. Read the React source from Source File Index; inspect only dependencies needed for that screen.
3. Check `Flutter-Native-Design-Standard.md`, then build the Flutter screen as an isolated route with mock data first.
4. Add navigation edges from Navigation Graph; unresolved edges marked `NEEDS_MANUAL_CONFIRM` must be resolved before QA complete.
5. Add repository/interface from Backend Contract Draft; keep endpoint names draft until BE confirms.
6. Compare Flutter screenshot against both reference images for visual-QA structure; fix spacing, typography, colors, and states.
7. Re-check native runtime against Home standard: no repeated local legacy palette, no per-module nav accent, shared token sizing, Home orange brand, neutral surfaces.
8. Tick Flutter, BE, and QA status in this file only after the screen passes its acceptance checks.

## Screen Checklist

### auth (6)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-001 | 1 | LoginPage | /auth/login | output/flutter-ui-reference/screenshots/auth/001_auth_login-page__auth-login__viewport.png | output/flutter-ui-reference/screenshots/auth/001_auth_login-page__auth-login__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-002 | 2 | RegisterPage | /auth/register | output/flutter-ui-reference/screenshots/auth/002_auth_register-page__auth-register__viewport.png | output/flutter-ui-reference/screenshots/auth/002_auth_register-page__auth-register__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-003 | 3 | OTPPage | /auth/otp | output/flutter-ui-reference/screenshots/auth/003_auth_otp-page__auth-otp__viewport.png | output/flutter-ui-reference/screenshots/auth/003_auth_otp-page__auth-otp__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-004 | 4 | TwoFASetupPage | /auth/2fa-setup | output/flutter-ui-reference/screenshots/auth/004_auth_two-fa-setup-page__auth-2fa-setup__viewport.png | output/flutter-ui-reference/screenshots/auth/004_auth_two-fa-setup-page__auth-2fa-setup__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-005 | 5 | ForgotPasswordPage | /auth/forgot-password | output/flutter-ui-reference/screenshots/auth/005_auth_forgot-password-page__auth-forgot-password__viewport.png | output/flutter-ui-reference/screenshots/auth/005_auth_forgot-password-page__auth-forgot-password__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-006 | 6 | ResetPasswordPage | /auth/reset-password | output/flutter-ui-reference/screenshots/auth/006_auth_reset-password-page__auth-reset-password__viewport.png | output/flutter-ui-reference/screenshots/auth/006_auth_reset-password-page__auth-reset-password__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |

### home (1)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-007 | 7 | HomePage | /home | output/flutter-ui-reference/screenshots/home/007_home_home-page__home__viewport.png | output/flutter-ui-reference/screenshots/home/007_home_home-page__home__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |

### markets (22)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-008 | 8 | MarketListPage | /markets | output/flutter-ui-reference/screenshots/markets/008_markets_market-list-page__markets__viewport.png | output/flutter-ui-reference/screenshots/markets/008_markets_market-list-page__markets__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-009 | 9 | MarketOverviewPage | /markets/overview | output/flutter-ui-reference/screenshots/markets/009_markets_market-overview-page__markets-overview__viewport.png | output/flutter-ui-reference/screenshots/markets/009_markets_market-overview-page__markets-overview__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-010 | 10 | MarketMoversPage | /markets/movers | output/flutter-ui-reference/screenshots/markets/010_markets_market-movers-page__markets-movers__viewport.png | output/flutter-ui-reference/screenshots/markets/010_markets_market-movers-page__markets-movers__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-011 | 11 | MarketSectorsPage | /markets/sectors | output/flutter-ui-reference/screenshots/markets/011_markets_market-sectors-page__markets-sectors__viewport.png | output/flutter-ui-reference/screenshots/markets/011_markets_market-sectors-page__markets-sectors__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-012 | 12 | WatchlistPage | /markets/watchlist | output/flutter-ui-reference/screenshots/markets/012_markets_watchlist-page__markets-watchlist__viewport.png | output/flutter-ui-reference/screenshots/markets/012_markets_watchlist-page__markets-watchlist__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-013 | 13 | MarketHeatmapPage | /markets/heatmap | output/flutter-ui-reference/screenshots/markets/013_markets_market-heatmap-page__markets-heatmap__viewport.png | output/flutter-ui-reference/screenshots/markets/013_markets_market-heatmap-page__markets-heatmap__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-014 | 14 | PriceAlertsPage | /markets/alerts | output/flutter-ui-reference/screenshots/markets/014_markets_price-alerts-page__markets-alerts__viewport.png | output/flutter-ui-reference/screenshots/markets/014_markets_price-alerts-page__markets-alerts__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-015 | 15 | MarketScreenerPage | /markets/screener | output/flutter-ui-reference/screenshots/markets/015_markets_market-screener-page__markets-screener__viewport.png | output/flutter-ui-reference/screenshots/markets/015_markets_market-screener-page__markets-screener__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-016 | 16 | ComparisonToolPage | /markets/compare | output/flutter-ui-reference/screenshots/markets/016_markets_comparison-tool-page__markets-compare__viewport.png | output/flutter-ui-reference/screenshots/markets/016_markets_comparison-tool-page__markets-compare__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-017 | 17 | MarketCalendarPage | /markets/calendar | output/flutter-ui-reference/screenshots/markets/017_markets_market-calendar-page__markets-calendar__viewport.png | output/flutter-ui-reference/screenshots/markets/017_markets_market-calendar-page__markets-calendar__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-018 | 18 | DerivativesOverviewPage | /markets/derivatives | output/flutter-ui-reference/screenshots/markets/018_markets_derivatives-overview-page__markets-derivatives__viewport.png | output/flutter-ui-reference/screenshots/markets/018_markets_derivatives-overview-page__markets-derivatives__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-019 | 19 | MarketDepthPage | /markets/depth | output/flutter-ui-reference/screenshots/markets/019_markets_market-depth-page__markets-depth__viewport.png | output/flutter-ui-reference/screenshots/markets/019_markets_market-depth-page__markets-depth__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-020 | 20 | SocialSentimentPage | /markets/social-sentiment | output/flutter-ui-reference/screenshots/markets/020_markets_social-sentiment-page__markets-social-sentiment__viewport.png | output/flutter-ui-reference/screenshots/markets/020_markets_social-sentiment-page__markets-social-sentiment__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-021 | 21 | PortfolioTrackerPage | /markets/portfolio-tracker | output/flutter-ui-reference/screenshots/markets/021_markets_portfolio-tracker-page__markets-portfolio-tracker__viewport.png | output/flutter-ui-reference/screenshots/markets/021_markets_portfolio-tracker-page__markets-portfolio-tracker__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-022 | 22 | MarketNewsPage | /markets/news | output/flutter-ui-reference/screenshots/markets/022_markets_market-news-page__markets-news__viewport.png | output/flutter-ui-reference/screenshots/markets/022_markets_market-news-page__markets-news__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-023 | 23 | AdvancedChartsPage | /markets/advanced-charts | output/flutter-ui-reference/screenshots/markets/023_markets_advanced-charts-page__markets-advanced-charts__viewport.png | output/flutter-ui-reference/screenshots/markets/023_markets_advanced-charts-page__markets-advanced-charts__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-024 | 24 | TokenUnlocksPage | /markets/unlocks | output/flutter-ui-reference/screenshots/markets/024_markets_token-unlocks-page__markets-unlocks__viewport.png | output/flutter-ui-reference/screenshots/markets/024_markets_token-unlocks-page__markets-unlocks__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-025 | 25 | SocialSignalsPage | /markets/signals | output/flutter-ui-reference/screenshots/markets/025_markets_social-signals-page__markets-signals__viewport.png | output/flutter-ui-reference/screenshots/markets/025_markets_social-signals-page__markets-signals__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-026 | 26 | MarketCorrelationsPage | /markets/correlations | output/flutter-ui-reference/screenshots/markets/026_markets_market-correlations-page__markets-correlations__viewport.png | output/flutter-ui-reference/screenshots/markets/026_markets_market-correlations-page__markets-correlations__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-044 | 44 | PairDetailPage | /pair/btcusdt | output/flutter-ui-reference/screenshots/markets/044_markets_pair-detail-page__pair-btcusdt__viewport.png | output/flutter-ui-reference/screenshots/markets/044_markets_pair-detail-page__pair-btcusdt__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-045 | 45 | TokenInfoPage | /pair/btcusdt/info | output/flutter-ui-reference/screenshots/markets/045_markets_token-info-page__pair-btcusdt-info__viewport.png | output/flutter-ui-reference/screenshots/markets/045_markets_token-info-page__pair-btcusdt-info__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-046 | 46 | MarketDepthPage | /pair/btcusdt/depth | output/flutter-ui-reference/screenshots/markets/046_markets_market-depth-page__pair-btcusdt-depth__viewport.png | output/flutter-ui-reference/screenshots/markets/046_markets_market-depth-page__pair-btcusdt-depth__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |

### predictions (17)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-027 | 27 | PredictionsHomePage | /markets/predictions | output/flutter-ui-reference/screenshots/predictions/027_predictions_predictions-home-page__markets-predictions__viewport.png | output/flutter-ui-reference/screenshots/predictions/027_predictions_predictions-home-page__markets-predictions__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-028 | 28 | PredictionsSearchPage | /markets/predictions/search | output/flutter-ui-reference/screenshots/predictions/028_predictions_predictions-search-page__markets-predictions-search__viewport.png | output/flutter-ui-reference/screenshots/predictions/028_predictions_predictions-search-page__markets-predictions-search__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-029 | 29 | PredictionsBreakingPage | /markets/predictions/breaking | output/flutter-ui-reference/screenshots/predictions/029_predictions_predictions-breaking-page__markets-predictions-breaking__viewport.png | output/flutter-ui-reference/screenshots/predictions/029_predictions_predictions-breaking-page__markets-predictions-breaking__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-030 | 30 | PredictionEventDetailPage | /markets/predictions/event/pred-1 | output/flutter-ui-reference/screenshots/predictions/030_predictions_prediction-event-detail-page__markets-predictions-event-pred-1__viewport.png | output/flutter-ui-reference/screenshots/predictions/030_predictions_prediction-event-detail-page__markets-predictions-event-pred-1__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-031 | 31 | PredictionsPortfolioPage | /markets/predictions/portfolio | output/flutter-ui-reference/screenshots/predictions/031_predictions_predictions-portfolio-page__markets-predictions-portfolio__viewport.png | output/flutter-ui-reference/screenshots/predictions/031_predictions_predictions-portfolio-page__markets-predictions-portfolio__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-032 | 32 | PredictionsRewardsPage | /markets/predictions/rewards | output/flutter-ui-reference/screenshots/predictions/032_predictions_predictions-rewards-page__markets-predictions-rewards__viewport.png | output/flutter-ui-reference/screenshots/predictions/032_predictions_predictions-rewards-page__markets-predictions-rewards__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-033 | 33 | PredictionsLeaderboardPage | /markets/predictions/leaderboard | output/flutter-ui-reference/screenshots/predictions/033_predictions_predictions-leaderboard-page__markets-predictions-leaderboard__viewport.png | output/flutter-ui-reference/screenshots/predictions/033_predictions_predictions-leaderboard-page__markets-predictions-leaderboard__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-034 | 34 | PredictionsGlobalActivityPage | /markets/predictions/activity | output/flutter-ui-reference/screenshots/predictions/034_predictions_predictions-global-activity-page__markets-predictions-activity__viewport.png | output/flutter-ui-reference/screenshots/predictions/034_predictions_predictions-global-activity-page__markets-predictions-activity__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-035 | 35 | PredictionOrderReceiptPage | /markets/predictions/receipt/p2p001 | output/flutter-ui-reference/screenshots/predictions/035_predictions_prediction-order-receipt-page__markets-predictions-receipt-p2p001__viewport.png | output/flutter-ui-reference/screenshots/predictions/035_predictions_prediction-order-receipt-page__markets-predictions-receipt-p2p001__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-036 | 36 | PredictionRiskCalculatorPage | /markets/predictions/risk-calculator | output/flutter-ui-reference/screenshots/predictions/036_predictions_prediction-risk-calculator-page__markets-predictions-risk-calculator__viewport.png | output/flutter-ui-reference/screenshots/predictions/036_predictions_prediction-risk-calculator-page__markets-predictions-risk-calculator__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-037 | 37 | PredictionMarketMakerPage | /markets/predictions/market-maker | output/flutter-ui-reference/screenshots/predictions/037_predictions_prediction-market-maker-page__markets-predictions-market-maker__viewport.png | output/flutter-ui-reference/screenshots/predictions/037_predictions_prediction-market-maker-page__markets-predictions-market-maker__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-038 | 38 | PredictionPortfolioAnalyzerPage | /markets/predictions/portfolio-analyzer | output/flutter-ui-reference/screenshots/predictions/038_predictions_prediction-portfolio-analyzer-page__markets-predictions-portfolio-analyzer__viewport.png | output/flutter-ui-reference/screenshots/predictions/038_predictions_prediction-portfolio-analyzer-page__markets-predictions-portfolio-analyzer__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-039 | 39 | PredictionEventCalendarPage | /markets/predictions/event-calendar | output/flutter-ui-reference/screenshots/predictions/039_predictions_prediction-event-calendar-page__markets-predictions-event-calendar__viewport.png | output/flutter-ui-reference/screenshots/predictions/039_predictions_prediction-event-calendar-page__markets-predictions-event-calendar__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-040 | 40 | PredictionSocialPage | /markets/predictions/social | output/flutter-ui-reference/screenshots/predictions/040_predictions_prediction-social-page__markets-predictions-social__viewport.png | output/flutter-ui-reference/screenshots/predictions/040_predictions_prediction-social-page__markets-predictions-social__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-041 | 41 | PredictionAdvancedChartPage | /markets/predictions/advanced-chart/btcusdt | output/flutter-ui-reference/screenshots/predictions/041_predictions_prediction-advanced-chart-page__markets-predictions-advanced-chart-btcusdt__viewport.png | output/flutter-ui-reference/screenshots/predictions/041_predictions_prediction-advanced-chart-page__markets-predictions-advanced-chart-btcusdt__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-042 | 42 | PredictionTournamentsPage | /markets/predictions/tournaments | output/flutter-ui-reference/screenshots/predictions/042_predictions_prediction-tournaments-page__markets-predictions-tournaments__viewport.png | output/flutter-ui-reference/screenshots/predictions/042_predictions_prediction-tournaments-page__markets-predictions-tournaments__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-043 | 43 | PredictionDataIntegrationPage | /markets/predictions/data-integration | output/flutter-ui-reference/screenshots/predictions/043_predictions_prediction-data-integration-page__markets-predictions-data-integration__viewport.png | output/flutter-ui-reference/screenshots/predictions/043_predictions_prediction-data-integration-page__markets-predictions-data-integration__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |

### news (1)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-047 | 47 | NewsPage | /news | output/flutter-ui-reference/screenshots/news/047_news_news-page__news__viewport.png | output/flutter-ui-reference/screenshots/news/047_news_news-page__news__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |

### trade (87)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-048 | 48 | TradePage | /trade | output/flutter-ui-reference/screenshots/trade/048_trade_trade-page__trade__viewport.png | output/flutter-ui-reference/screenshots/trade/048_trade_trade-page__trade__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-049 | 49 | TradePage | /trade/btcusdt | output/flutter-ui-reference/screenshots/trade/049_trade_trade-page__trade-btcusdt__viewport.png | output/flutter-ui-reference/screenshots/trade/049_trade_trade-page__trade-btcusdt__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-050 | 50 | OrdersHistoryPage | /trade/orders-history | output/flutter-ui-reference/screenshots/trade/050_trade_orders-history-page__trade-orders-history__viewport.png | output/flutter-ui-reference/screenshots/trade/050_trade_orders-history-page__trade-orders-history__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-051 | 51 | OrderReceiptPage | /trade/order-receipt | output/flutter-ui-reference/screenshots/trade/051_trade_order-receipt-page__trade-order-receipt__viewport.png | output/flutter-ui-reference/screenshots/trade/051_trade_order-receipt-page__trade-order-receipt__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-052 | 52 | TradeSettingsPage | /trade/settings | output/flutter-ui-reference/screenshots/trade/052_trade_trade-settings-page__trade-settings__viewport.png | output/flutter-ui-reference/screenshots/trade/052_trade_trade-settings-page__trade-settings__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-053 | 53 | PositionDashboardPage | /trade/positions | output/flutter-ui-reference/screenshots/trade/053_trade_position-dashboard-page__trade-positions__viewport.png | output/flutter-ui-reference/screenshots/trade/053_trade_position-dashboard-page__trade-positions__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-054 | 54 | TradeHistoryExportPage | /trade/export | output/flutter-ui-reference/screenshots/trade/054_trade_trade-history-export-page__trade-export__viewport.png | output/flutter-ui-reference/screenshots/trade/054_trade_trade-history-export-page__trade-export__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-055 | 55 | AdvancedChartPage | /trade/advanced-chart/btcusdt | output/flutter-ui-reference/screenshots/trade/055_trade_advanced-chart-page__trade-advanced-chart-btcusdt__viewport.png | output/flutter-ui-reference/screenshots/trade/055_trade_advanced-chart-page__trade-advanced-chart-btcusdt__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-056 | 56 | ConvertPage | /trade/convert | output/flutter-ui-reference/screenshots/trade/056_trade_convert-page__trade-convert__viewport.png | output/flutter-ui-reference/screenshots/trade/056_trade_convert-page__trade-convert__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-057 | 57 | FuturesPage | /trade/btcusdt/futures | output/flutter-ui-reference/screenshots/trade/057_trade_futures-page__trade-btcusdt-futures__viewport.png | output/flutter-ui-reference/screenshots/trade/057_trade_futures-page__trade-btcusdt-futures__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-058 | 58 | LeveragePage | /trade/btcusdt/futures/leverage | output/flutter-ui-reference/screenshots/trade/058_trade_leverage-page__trade-btcusdt-futures-leverage__viewport.png | output/flutter-ui-reference/screenshots/trade/058_trade_leverage-page__trade-btcusdt-futures-leverage__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-059 | 59 | TradingBotsPage | /trade/bots | output/flutter-ui-reference/screenshots/trade/059_trade_trading-bots-page__trade-bots__viewport.png | output/flutter-ui-reference/screenshots/trade/059_trade_trading-bots-page__trade-bots__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-060 | 60 | RiskManagementDemoPage | /trade/risk-management | output/flutter-ui-reference/screenshots/trade/060_trade_risk-management-demo-page__trade-risk-management__viewport.png | output/flutter-ui-reference/screenshots/trade/060_trade_risk-management-demo-page__trade-risk-management__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-061 | 61 | ExecutionQualityDemoPage | /trade/execution-quality | output/flutter-ui-reference/screenshots/trade/061_trade_execution-quality-demo-page__trade-execution-quality__viewport.png | output/flutter-ui-reference/screenshots/trade/061_trade_execution-quality-demo-page__trade-execution-quality__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-062 | 62 | AdvancedToolsDemoPage | /trade/advanced-tools | output/flutter-ui-reference/screenshots/trade/062_trade_advanced-tools-demo-page__trade-advanced-tools__viewport.png | output/flutter-ui-reference/screenshots/trade/062_trade_advanced-tools-demo-page__trade-advanced-tools__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-063 | 63 | CopyTradingPage | /trade/copy-trading | output/flutter-ui-reference/screenshots/trade/063_trade_copy-trading-page__trade-copy-trading__viewport.png | output/flutter-ui-reference/screenshots/trade/063_trade_copy-trading-page__trade-copy-trading__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-064 | 64 | CopyTradingPageV2 | /trade/copy-trading/v2 | output/flutter-ui-reference/screenshots/trade/064_trade_copy-trading-page-v2__trade-copy-trading-v2__viewport.png | output/flutter-ui-reference/screenshots/trade/064_trade_copy-trading-page-v2__trade-copy-trading-v2__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-065 | 65 | CopyEducationPage | /trade/copy-trading/education | output/flutter-ui-reference/screenshots/trade/065_trade_copy-education-page__trade-copy-trading-education__viewport.png | output/flutter-ui-reference/screenshots/trade/065_trade_copy-education-page__trade-copy-trading-education__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-066 | 66 | ActiveCopiesPage | /trade/copy-trading/active | output/flutter-ui-reference/screenshots/trade/066_trade_active-copies-page__trade-copy-trading-active__viewport.png | output/flutter-ui-reference/screenshots/trade/066_trade_active-copies-page__trade-copy-trading-active__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-067 | 67 | CopySettingsPage | /trade/copy-trading/settings | output/flutter-ui-reference/screenshots/trade/067_trade_copy-settings-page__trade-copy-trading-settings__viewport.png | output/flutter-ui-reference/screenshots/trade/067_trade_copy-settings-page__trade-copy-trading-settings__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-068 | 68 | CopyNotificationsPage | /trade/copy-trading/notifications | output/flutter-ui-reference/screenshots/trade/068_trade_copy-notifications-page__trade-copy-trading-notifications__viewport.png | output/flutter-ui-reference/screenshots/trade/068_trade_copy-notifications-page__trade-copy-trading-notifications__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-069 | 69 | ProviderApplicationPage | /trade/copy-provider-apply | output/flutter-ui-reference/screenshots/trade/069_trade_provider-application-page__trade-copy-provider-apply__viewport.png | output/flutter-ui-reference/screenshots/trade/069_trade_provider-application-page__trade-copy-provider-apply__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-070 | 70 | CopyProviderDetailPage | /trade/copy-provider/provider001 | output/flutter-ui-reference/screenshots/trade/070_trade_copy-provider-detail-page__trade-copy-provider-provider001__viewport.png | output/flutter-ui-reference/screenshots/trade/070_trade_copy-provider-detail-page__trade-copy-provider-provider001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-071 | 71 | PreCopyAssessmentPage | /trade/copy-provider/provider001/assessment | output/flutter-ui-reference/screenshots/trade/071_trade_pre-copy-assessment-page__trade-copy-provider-provider001-assessment__viewport.png | output/flutter-ui-reference/screenshots/trade/071_trade_pre-copy-assessment-page__trade-copy-provider-provider001-assessment__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-072 | 72 | CopyConfigurationPage | /trade/copy-provider/provider001/configuration | output/flutter-ui-reference/screenshots/trade/072_trade_copy-configuration-page__trade-copy-provider-provider001-configuration__viewport.png | output/flutter-ui-reference/screenshots/trade/072_trade_copy-configuration-page__trade-copy-provider-provider001-configuration__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-073 | 73 | CopyConfirmationPage | /trade/copy-provider/provider001/confirmation | output/flutter-ui-reference/screenshots/trade/073_trade_copy-confirmation-page__trade-copy-provider-provider001-confirmation__viewport.png | output/flutter-ui-reference/screenshots/trade/073_trade_copy-confirmation-page__trade-copy-provider-provider001-confirmation__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-074 | 74 | CopyPerformancePage | /trade/copy-performance/copy001 | output/flutter-ui-reference/screenshots/trade/074_trade_copy-performance-page__trade-copy-performance-copy001__viewport.png | output/flutter-ui-reference/screenshots/trade/074_trade_copy-performance-page__trade-copy-performance-copy001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-075 | 75 | PerformanceAttributionPage | /trade/copy-performance/copy001/attribution | output/flutter-ui-reference/screenshots/trade/075_trade_performance-attribution-page__trade-copy-performance-copy001-attribution__viewport.png | output/flutter-ui-reference/screenshots/trade/075_trade_performance-attribution-page__trade-copy-performance-copy001-attribution__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-076 | 76 | ProviderComparisonPage | /trade/copy-trading/comparison | output/flutter-ui-reference/screenshots/trade/076_trade_provider-comparison-page__trade-copy-trading-comparison__viewport.png | output/flutter-ui-reference/screenshots/trade/076_trade_provider-comparison-page__trade-copy-trading-comparison__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-077 | 77 | CopyAuditLogPage | /trade/copy-audit-log/copy001 | output/flutter-ui-reference/screenshots/trade/077_trade_copy-audit-log-page__trade-copy-audit-log-copy001__viewport.png | output/flutter-ui-reference/screenshots/trade/077_trade_copy-audit-log-page__trade-copy-audit-log-copy001__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-078 | 78 | PortfolioRiskAnalysisPage | /trade/copy-trading/risk-analysis | output/flutter-ui-reference/screenshots/trade/078_trade_portfolio-risk-analysis-page__trade-copy-trading-risk-analysis__viewport.png | output/flutter-ui-reference/screenshots/trade/078_trade_portfolio-risk-analysis-page__trade-copy-trading-risk-analysis__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-079 | 79 | ProviderLeaderboardPage | /trade/copy-trading/leaderboard | output/flutter-ui-reference/screenshots/trade/079_trade_provider-leaderboard-page__trade-copy-trading-leaderboard__viewport.png | output/flutter-ui-reference/screenshots/trade/079_trade_provider-leaderboard-page__trade-copy-trading-leaderboard__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-080 | 80 | SafetyEducationPage | /trade/copy-trading/safety | output/flutter-ui-reference/screenshots/trade/080_trade_safety-education-page__trade-copy-trading-safety__viewport.png | output/flutter-ui-reference/screenshots/trade/080_trade_safety-education-page__trade-copy-trading-safety__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-081 | 81 | ProviderGovernancePage | /trade/copy-provider-governance | output/flutter-ui-reference/screenshots/trade/081_trade_provider-governance-page__trade-copy-provider-governance__viewport.png | output/flutter-ui-reference/screenshots/trade/081_trade_provider-governance-page__trade-copy-provider-governance__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-082 | 82 | DisputeResolutionPage | /trade/copy-dispute-resolution | output/flutter-ui-reference/screenshots/trade/082_trade_dispute-resolution-page__trade-copy-dispute-resolution__viewport.png | output/flutter-ui-reference/screenshots/trade/082_trade_dispute-resolution-page__trade-copy-dispute-resolution__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-083 | 83 | CopySafetyCenterPage | /trade/copy-safety-center | output/flutter-ui-reference/screenshots/trade/083_trade_copy-safety-center-page__trade-copy-safety-center__viewport.png | output/flutter-ui-reference/screenshots/trade/083_trade_copy-safety-center-page__trade-copy-safety-center__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-084 | 84 | RegulatoryDisclosuresPage | /trade/copy-regulatory-disclosures | output/flutter-ui-reference/screenshots/trade/084_trade_regulatory-disclosures-page__trade-copy-regulatory-disclosures__viewport.png | output/flutter-ui-reference/screenshots/trade/084_trade_regulatory-disclosures-page__trade-copy-regulatory-disclosures__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-085 | 85 | MarginTradingPage | /trade/margin | output/flutter-ui-reference/screenshots/trade/085_trade_margin-trading-page__trade-margin__viewport.png | output/flutter-ui-reference/screenshots/trade/085_trade_margin-trading-page__trade-margin__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-086 | 86 | MarginTradingPage | /trade/margin/btcusdt | output/flutter-ui-reference/screenshots/trade/086_trade_margin-trading-page__trade-margin-btcusdt__viewport.png | output/flutter-ui-reference/screenshots/trade/086_trade_margin-trading-page__trade-margin-btcusdt__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-087 | 87 | TraderProfilePage | /trade/trader/trader001 | output/flutter-ui-reference/screenshots/trade/087_trade_trader-profile-page__trade-trader-trader001__viewport.png | output/flutter-ui-reference/screenshots/trade/087_trade_trader-profile-page__trade-trader-trader001__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-088 | 88 | AdvancedTradingDemoPage | /trade/margin/advanced-demo | output/flutter-ui-reference/screenshots/trade/088_trade_advanced-trading-demo-page__trade-margin-advanced-demo__viewport.png | output/flutter-ui-reference/screenshots/trade/088_trade_advanced-trading-demo-page__trade-margin-advanced-demo__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-089 | 89 | MarketDataAnalyticsPage | /trade/margin/market-data-analytics | output/flutter-ui-reference/screenshots/trade/089_trade_market-data-analytics-page__trade-margin-market-data-analytics__viewport.png | output/flutter-ui-reference/screenshots/trade/089_trade_market-data-analytics-page__trade-margin-market-data-analytics__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-090 | 90 | MarginTradingHubPage | /trade/margin/hub | output/flutter-ui-reference/screenshots/trade/090_trade_margin-trading-hub-page__trade-margin-hub__viewport.png | output/flutter-ui-reference/screenshots/trade/090_trade_margin-trading-hub-page__trade-margin-hub__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-091 | 91 | LiveMarketDataAnalyticsPage | /trade/margin/live-market-data-analytics | output/flutter-ui-reference/screenshots/trade/091_trade_live-market-data-analytics-page__trade-margin-live-market-data-analytics__viewport.png | output/flutter-ui-reference/screenshots/trade/091_trade_live-market-data-analytics-page__trade-margin-live-market-data-analytics__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-092 | 92 | AdvancedAnalyticsPage | /trade/margin/advanced-analytics | output/flutter-ui-reference/screenshots/trade/092_trade_advanced-analytics-page__trade-margin-advanced-analytics__viewport.png | output/flutter-ui-reference/screenshots/trade/092_trade_advanced-analytics-page__trade-margin-advanced-analytics__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-093 | 93 | TransactionReportingPage | /trade/copy-trading/transaction-reporting | output/flutter-ui-reference/screenshots/trade/093_trade_transaction-reporting-page__trade-copy-trading-transaction-reporting__viewport.png | output/flutter-ui-reference/screenshots/trade/093_trade_transaction-reporting-page__trade-copy-trading-transaction-reporting__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-094 | 94 | RegulatoryReportsDashboardPage | /trade/copy-trading/regulatory-reports-dashboard | output/flutter-ui-reference/screenshots/trade/094_trade_regulatory-reports-dashboard-page__trade-copy-trading-regulatory-reports-dashboard__viewport.png | output/flutter-ui-reference/screenshots/trade/094_trade_regulatory-reports-dashboard-page__trade-copy-trading-regulatory-reports-dashboard__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-095 | 95 | ARMIntegrationStatusPage | /trade/copy-trading/arm-integration-status | output/flutter-ui-reference/screenshots/trade/095_trade_arm-integration-status-page__trade-copy-trading-arm-integration-status__viewport.png | output/flutter-ui-reference/screenshots/trade/095_trade_arm-integration-status-page__trade-copy-trading-arm-integration-status__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-096 | 96 | BestExecutionReportsPage | /trade/copy-trading/best-execution-reports | output/flutter-ui-reference/screenshots/trade/096_trade_best-execution-reports-page__trade-copy-trading-best-execution-reports__viewport.png | output/flutter-ui-reference/screenshots/trade/096_trade_best-execution-reports-page__trade-copy-trading-best-execution-reports__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-097 | 97 | ExecutionVenueAnalysisPage | /trade/copy-trading/execution-venue-analysis | output/flutter-ui-reference/screenshots/trade/097_trade_execution-venue-analysis-page__trade-copy-trading-execution-venue-analysis__viewport.png | output/flutter-ui-reference/screenshots/trade/097_trade_execution-venue-analysis-page__trade-copy-trading-execution-venue-analysis__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-098 | 98 | SlippageMonitoringPage | /trade/copy-trading/slippage-monitoring | output/flutter-ui-reference/screenshots/trade/098_trade_slippage-monitoring-page__trade-copy-trading-slippage-monitoring__viewport.png | output/flutter-ui-reference/screenshots/trade/098_trade_slippage-monitoring-page__trade-copy-trading-slippage-monitoring__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-099 | 99 | ClientCategorizationPage | /trade/copy-trading/client-categorization | output/flutter-ui-reference/screenshots/trade/099_trade_client-categorization-page__trade-copy-trading-client-categorization__viewport.png | output/flutter-ui-reference/screenshots/trade/099_trade_client-categorization-page__trade-copy-trading-client-categorization__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-100 | 100 | ProductGovernancePage | /trade/copy-trading/product-governance | output/flutter-ui-reference/screenshots/trade/100_trade_product-governance-page__trade-copy-trading-product-governance__viewport.png | output/flutter-ui-reference/screenshots/trade/100_trade_product-governance-page__trade-copy-trading-product-governance__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-101 | 101 | TargetMarketDefinitionPage | /trade/copy-trading/target-market-definition | output/flutter-ui-reference/screenshots/trade/101_trade_target-market-definition-page__trade-copy-trading-target-market-definition__viewport.png | output/flutter-ui-reference/screenshots/trade/101_trade_target-market-definition-page__trade-copy-trading-target-market-definition__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-102 | 102 | ClientMoneyProtectionPage | /trade/copy-trading/client-money-protection | output/flutter-ui-reference/screenshots/trade/102_trade_client-money-protection-page__trade-copy-trading-client-money-protection__viewport.png | output/flutter-ui-reference/screenshots/trade/102_trade_client-money-protection-page__trade-copy-trading-client-money-protection__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-103 | 103 | CASSReconciliationPage | /trade/copy-trading/cass-reconciliation | output/flutter-ui-reference/screenshots/trade/103_trade_cass-reconciliation-page__trade-copy-trading-cass-reconciliation__viewport.png | output/flutter-ui-reference/screenshots/trade/103_trade_cass-reconciliation-page__trade-copy-trading-cass-reconciliation__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-104 | 104 | InvestorCompensationPage | /trade/copy-trading/investor-compensation | output/flutter-ui-reference/screenshots/trade/104_trade_investor-compensation-page__trade-copy-trading-investor-compensation__viewport.png | output/flutter-ui-reference/screenshots/trade/104_trade_investor-compensation-page__trade-copy-trading-investor-compensation__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-105 | 105 | ExAnteCostsPage | /trade/copy-trading/ex-ante-costs | output/flutter-ui-reference/screenshots/trade/105_trade_ex-ante-costs-page__trade-copy-trading-ex-ante-costs__viewport.png | output/flutter-ui-reference/screenshots/trade/105_trade_ex-ante-costs-page__trade-copy-trading-ex-ante-costs__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-106 | 106 | RIYCalculatorPage | /trade/copy-trading/riy-calculator | output/flutter-ui-reference/screenshots/trade/106_trade_riy-calculator-page__trade-copy-trading-riy-calculator__viewport.png | output/flutter-ui-reference/screenshots/trade/106_trade_riy-calculator-page__trade-copy-trading-riy-calculator__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-107 | 107 | ExPostCostsReportPage | /trade/copy-trading/ex-post-costs-report | output/flutter-ui-reference/screenshots/trade/107_trade_ex-post-costs-report-page__trade-copy-trading-ex-post-costs-report__viewport.png | output/flutter-ui-reference/screenshots/trade/107_trade_ex-post-costs-report-page__trade-copy-trading-ex-post-costs-report__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-108 | 108 | KIDGeneratorPage | /trade/copy-trading/kid-generator | output/flutter-ui-reference/screenshots/trade/108_trade_kid-generator-page__trade-copy-trading-kid-generator__viewport.png | output/flutter-ui-reference/screenshots/trade/108_trade_kid-generator-page__trade-copy-trading-kid-generator__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-109 | 109 | PerformanceScenariosPage | /trade/copy-trading/performance-scenarios | output/flutter-ui-reference/screenshots/trade/109_trade_performance-scenarios-page__trade-copy-trading-performance-scenarios__viewport.png | output/flutter-ui-reference/screenshots/trade/109_trade_performance-scenarios-page__trade-copy-trading-performance-scenarios__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-110 | 110 | RiskIndicatorExplainerPage | /trade/copy-trading/risk-indicator-explainer | output/flutter-ui-reference/screenshots/trade/110_trade_risk-indicator-explainer-page__trade-copy-trading-risk-indicator-explainer__viewport.png | output/flutter-ui-reference/screenshots/trade/110_trade_risk-indicator-explainer-page__trade-copy-trading-risk-indicator-explainer__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-111 | 111 | ComplaintsHandlingPage | /trade/copy-trading/complaints-handling | output/flutter-ui-reference/screenshots/trade/111_trade_complaints-handling-page__trade-copy-trading-complaints-handling__viewport.png | output/flutter-ui-reference/screenshots/trade/111_trade_complaints-handling-page__trade-copy-trading-complaints-handling__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-112 | 112 | ComplaintSubmissionPage | /trade/copy-trading/complaint-submission | output/flutter-ui-reference/screenshots/trade/112_trade_complaint-submission-page__trade-copy-trading-complaint-submission__viewport.png | output/flutter-ui-reference/screenshots/trade/112_trade_complaint-submission-page__trade-copy-trading-complaint-submission__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-113 | 113 | ComplaintTrackingPage | /trade/copy-trading/complaint-tracking | output/flutter-ui-reference/screenshots/trade/113_trade_complaint-tracking-page__trade-copy-trading-complaint-tracking__viewport.png | output/flutter-ui-reference/screenshots/trade/113_trade_complaint-tracking-page__trade-copy-trading-complaint-tracking__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-114 | 114 | OmbudsmanReferralPage | /trade/copy-trading/ombudsman-referral | output/flutter-ui-reference/screenshots/trade/114_trade_ombudsman-referral-page__trade-copy-trading-ombudsman-referral__viewport.png | output/flutter-ui-reference/screenshots/trade/114_trade_ombudsman-referral-page__trade-copy-trading-ombudsman-referral__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-115 | 115 | AuditTrailPage | /trade/copy-trading/audit-trail | output/flutter-ui-reference/screenshots/trade/115_trade_audit-trail-page__trade-copy-trading-audit-trail__viewport.png | output/flutter-ui-reference/screenshots/trade/115_trade_audit-trail-page__trade-copy-trading-audit-trail__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-116 | 116 | RegulatoryInspectionReadyPage | /trade/copy-trading/regulatory-inspection-ready | output/flutter-ui-reference/screenshots/trade/116_trade_regulatory-inspection-ready-page__trade-copy-trading-regulatory-inspection-ready__viewport.png | output/flutter-ui-reference/screenshots/trade/116_trade_regulatory-inspection-ready-page__trade-copy-trading-regulatory-inspection-ready__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-117 | 117 | BotTermsOfServicePage | /trade/bots/terms-of-service | output/flutter-ui-reference/screenshots/trade/117_trade_bot-terms-of-service-page__trade-bots-terms-of-service__viewport.png | output/flutter-ui-reference/screenshots/trade/117_trade_bot-terms-of-service-page__trade-bots-terms-of-service__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-118 | 118 | BotRiskDisclosurePage | /trade/bots/risk-disclosure | output/flutter-ui-reference/screenshots/trade/118_trade_bot-risk-disclosure-page__trade-bots-risk-disclosure__viewport.png | output/flutter-ui-reference/screenshots/trade/118_trade_bot-risk-disclosure-page__trade-bots-risk-disclosure__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-119 | 119 | BotSuitabilityAssessmentPage | /trade/bots/suitability-assessment | output/flutter-ui-reference/screenshots/trade/119_trade_bot-suitability-assessment-page__trade-bots-suitability-assessment__viewport.png | output/flutter-ui-reference/screenshots/trade/119_trade_bot-suitability-assessment-page__trade-bots-suitability-assessment__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-120 | 120 | BotRiskDashboardPage | /trade/bots/risk-dashboard | output/flutter-ui-reference/screenshots/trade/120_trade_bot-risk-dashboard-page__trade-bots-risk-dashboard__viewport.png | output/flutter-ui-reference/screenshots/trade/120_trade_bot-risk-dashboard-page__trade-bots-risk-dashboard__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-121 | 121 | BotEmergencyStopPage | /trade/bots/emergency-stop | output/flutter-ui-reference/screenshots/trade/121_trade_bot-emergency-stop-page__trade-bots-emergency-stop__viewport.png | output/flutter-ui-reference/screenshots/trade/121_trade_bot-emergency-stop-page__trade-bots-emergency-stop__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-122 | 122 | BotSecuritySettingsPage | /trade/bots/security-settings | output/flutter-ui-reference/screenshots/trade/122_trade_bot-security-settings-page__trade-bots-security-settings__viewport.png | output/flutter-ui-reference/screenshots/trade/122_trade_bot-security-settings-page__trade-bots-security-settings__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-123 | 123 | BotHistoryPage | /trade/bots/history | output/flutter-ui-reference/screenshots/trade/123_trade_bot-history-page__trade-bots-history__viewport.png | output/flutter-ui-reference/screenshots/trade/123_trade_bot-history-page__trade-bots-history__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-124 | 124 | BotPerformanceAnalyticsPage | /trade/bots/performance-analytics | output/flutter-ui-reference/screenshots/trade/124_trade_bot-performance-analytics-page__trade-bots-performance-analytics__viewport.png | output/flutter-ui-reference/screenshots/trade/124_trade_bot-performance-analytics-page__trade-bots-performance-analytics__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-125 | 125 | BotBacktestingPage | /trade/bots/backtesting | output/flutter-ui-reference/screenshots/trade/125_trade_bot-backtesting-page__trade-bots-backtesting__viewport.png | output/flutter-ui-reference/screenshots/trade/125_trade_bot-backtesting-page__trade-bots-backtesting__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-126 | 126 | BotStrategyComparePage | /trade/bots/strategy-compare | output/flutter-ui-reference/screenshots/trade/126_trade_bot-strategy-compare-page__trade-bots-strategy-compare__viewport.png | output/flutter-ui-reference/screenshots/trade/126_trade_bot-strategy-compare-page__trade-bots-strategy-compare__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-127 | 127 | BotOptimizationPage | /trade/bots/optimization | output/flutter-ui-reference/screenshots/trade/127_trade_bot-optimization-page__trade-bots-optimization__viewport.png | output/flutter-ui-reference/screenshots/trade/127_trade_bot-optimization-page__trade-bots-optimization__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-128 | 128 | BotPortfolioDashboardPage | /trade/bots/portfolio-dashboard | output/flutter-ui-reference/screenshots/trade/128_trade_bot-portfolio-dashboard-page__trade-bots-portfolio-dashboard__viewport.png | output/flutter-ui-reference/screenshots/trade/128_trade_bot-portfolio-dashboard-page__trade-bots-portfolio-dashboard__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-129 | 129 | BotDrawdownAnalyzerPage | /trade/bots/drawdown-analyzer | output/flutter-ui-reference/screenshots/trade/129_trade_bot-drawdown-analyzer-page__trade-bots-drawdown-analyzer__viewport.png | output/flutter-ui-reference/screenshots/trade/129_trade_bot-drawdown-analyzer-page__trade-bots-drawdown-analyzer__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-130 | 130 | BotEquityCurvePage | /trade/bots/equity-curve | output/flutter-ui-reference/screenshots/trade/130_trade_bot-equity-curve-page__trade-bots-equity-curve__viewport.png | output/flutter-ui-reference/screenshots/trade/130_trade_bot-equity-curve-page__trade-bots-equity-curve__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-131 | 131 | BotGuidePage | /trade/bots/guide | output/flutter-ui-reference/screenshots/trade/131_trade_bot-guide-page__trade-bots-guide__viewport.png | output/flutter-ui-reference/screenshots/trade/131_trade_bot-guide-page__trade-bots-guide__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-132 | 132 | BotFAQPage | /trade/bots/faq | output/flutter-ui-reference/screenshots/trade/132_trade_bot-faq-page__trade-bots-faq__viewport.png | output/flutter-ui-reference/screenshots/trade/132_trade_bot-faq-page__trade-bots-faq__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-133 | 133 | BotTaxReportingPage | /trade/bots/tax-reporting | output/flutter-ui-reference/screenshots/trade/133_trade_bot-tax-reporting-page__trade-bots-tax-reporting__viewport.png | output/flutter-ui-reference/screenshots/trade/133_trade_bot-tax-reporting-page__trade-bots-tax-reporting__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-134 | 134 | BotAPIDocumentationPage | /trade/bots/api-documentation | output/flutter-ui-reference/screenshots/trade/134_trade_bot-api-documentation-page__trade-bots-api-documentation__viewport.png | output/flutter-ui-reference/screenshots/trade/134_trade_bot-api-documentation-page__trade-bots-api-documentation__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |

### wallet (21)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-135 | 135 | WalletPage | /wallet | output/flutter-ui-reference/screenshots/wallet/135_wallet_wallet-page__wallet__viewport.png | output/flutter-ui-reference/screenshots/wallet/135_wallet_wallet-page__wallet__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-136 | 136 | TxHistoryPage | /wallet/history | output/flutter-ui-reference/screenshots/wallet/136_wallet_tx-history-page__wallet-history__viewport.png | output/flutter-ui-reference/screenshots/wallet/136_wallet_tx-history-page__wallet-history__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-137 | 137 | DepositPage | /wallet/deposit | output/flutter-ui-reference/screenshots/wallet/137_wallet_deposit-page__wallet-deposit__viewport.png | output/flutter-ui-reference/screenshots/wallet/137_wallet_deposit-page__wallet-deposit__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-138 | 138 | DepositPage | /wallet/deposit/USDT | output/flutter-ui-reference/screenshots/wallet/138_wallet_deposit-page__wallet-deposit-usdt__viewport.png | output/flutter-ui-reference/screenshots/wallet/138_wallet_deposit-page__wallet-deposit-usdt__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-139 | 139 | WithdrawPage | /wallet/withdraw | output/flutter-ui-reference/screenshots/wallet/139_wallet_withdraw-page__wallet-withdraw__viewport.png | output/flutter-ui-reference/screenshots/wallet/139_wallet_withdraw-page__wallet-withdraw__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-140 | 140 | WithdrawPage | /wallet/withdraw/USDT | output/flutter-ui-reference/screenshots/wallet/140_wallet_withdraw-page__wallet-withdraw-usdt__viewport.png | output/flutter-ui-reference/screenshots/wallet/140_wallet_withdraw-page__wallet-withdraw-usdt__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-141 | 141 | TransactionDetailPage | /wallet/transaction/tx001 | output/flutter-ui-reference/screenshots/wallet/141_wallet_transaction-detail-page__wallet-transaction-tx001__viewport.png | output/flutter-ui-reference/screenshots/wallet/141_wallet_transaction-detail-page__wallet-transaction-tx001__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-142 | 142 | PortfolioAnalyticsPage | /wallet/portfolio-analytics | output/flutter-ui-reference/screenshots/wallet/142_wallet_portfolio-analytics-page__wallet-portfolio-analytics__viewport.png | output/flutter-ui-reference/screenshots/wallet/142_wallet_portfolio-analytics-page__wallet-portfolio-analytics__fullpage.png | [x] Flutter UI ported | [x] contract draft | [x] QA compared |
| SC-143 | 143 | AddressAddPage | /wallet/address-book/add | output/flutter-ui-reference/screenshots/wallet/143_wallet_address-add-page__wallet-address-book-add__viewport.png | output/flutter-ui-reference/screenshots/wallet/143_wallet_address-add-page__wallet-address-book-add__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-144 | 144 | AddressBookPage | /wallet/address-book | output/flutter-ui-reference/screenshots/wallet/144_wallet_address-book-page__wallet-address-book__viewport.png | output/flutter-ui-reference/screenshots/wallet/144_wallet_address-book-page__wallet-address-book__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-145 | 145 | BuyCryptoPage | /wallet/buy-crypto | output/flutter-ui-reference/screenshots/wallet/145_wallet_buy-crypto-page__wallet-buy-crypto__viewport.png | output/flutter-ui-reference/screenshots/wallet/145_wallet_buy-crypto-page__wallet-buy-crypto__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-146 | 146 | TransferPage | /wallet/transfer | output/flutter-ui-reference/screenshots/wallet/146_wallet_transfer-page__wallet-transfer__viewport.png | output/flutter-ui-reference/screenshots/wallet/146_wallet_transfer-page__wallet-transfer__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-147 | 147 | AssetDetailPage | /wallet/asset/btc | output/flutter-ui-reference/screenshots/wallet/147_wallet_asset-detail-page__wallet-asset-btc__viewport.png | output/flutter-ui-reference/screenshots/wallet/147_wallet_asset-detail-page__wallet-asset-btc__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-148 | 148 | WalletMultiManagerPage | /wallet/multi-manager | output/flutter-ui-reference/screenshots/wallet/148_wallet_wallet-multi-manager-page__wallet-multi-manager__viewport.png | output/flutter-ui-reference/screenshots/wallet/148_wallet_wallet-multi-manager-page__wallet-multi-manager__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-149 | 149 | WalletGasOptimizerPage | /wallet/gas-optimizer | output/flutter-ui-reference/screenshots/wallet/149_wallet_wallet-gas-optimizer-page__wallet-gas-optimizer__viewport.png | output/flutter-ui-reference/screenshots/wallet/149_wallet_wallet-gas-optimizer-page__wallet-gas-optimizer__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-150 | 150 | WalletTokenApprovalPage | /wallet/token-approval | output/flutter-ui-reference/screenshots/wallet/150_wallet_wallet-token-approval-page__wallet-token-approval__viewport.png | output/flutter-ui-reference/screenshots/wallet/150_wallet_wallet-token-approval-page__wallet-token-approval__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-151 | 151 | WalletHealthScorePage | /wallet/health-score | output/flutter-ui-reference/screenshots/wallet/151_wallet_wallet-health-score-page__wallet-health-score__viewport.png | output/flutter-ui-reference/screenshots/wallet/151_wallet_wallet-health-score-page__wallet-health-score__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-152 | 152 | PendingDepositsPage | /wallet/pending-deposits | output/flutter-ui-reference/screenshots/wallet/152_wallet_pending-deposits-page__wallet-pending-deposits__viewport.png | output/flutter-ui-reference/screenshots/wallet/152_wallet_pending-deposits-page__wallet-pending-deposits__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-153 | 153 | WithdrawLimitsPage | /wallet/limits | output/flutter-ui-reference/screenshots/wallet/153_wallet_withdraw-limits-page__wallet-limits__viewport.png | output/flutter-ui-reference/screenshots/wallet/153_wallet_withdraw-limits-page__wallet-limits__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-154 | 154 | DustConverterPage | /wallet/dust-converter | output/flutter-ui-reference/screenshots/wallet/154_wallet_dust-converter-page__wallet-dust-converter__viewport.png | output/flutter-ui-reference/screenshots/wallet/154_wallet_dust-converter-page__wallet-dust-converter__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-155 | 155 | NetworkStatusPage | /wallet/network-status | output/flutter-ui-reference/screenshots/wallet/155_wallet_network-status-page__wallet-network-status__viewport.png | output/flutter-ui-reference/screenshots/wallet/155_wallet_network-status-page__wallet-network-status__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |

### profile (13)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-156 | 156 | ProfilePage | /profile | output/flutter-ui-reference/screenshots/profile/156_profile_profile-page__profile__viewport.png | output/flutter-ui-reference/screenshots/profile/156_profile_profile-page__profile__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-157 | 157 | EditProfilePage | /profile/edit | output/flutter-ui-reference/screenshots/profile/157_profile_edit-profile-page__profile-edit__viewport.png | output/flutter-ui-reference/screenshots/profile/157_profile_edit-profile-page__profile-edit__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-158 | 158 | SecurityPage | /profile/security | output/flutter-ui-reference/screenshots/profile/158_profile_security-page__profile-security__viewport.png | output/flutter-ui-reference/screenshots/profile/158_profile_security-page__profile-security__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-159 | 159 | KYCPage | /profile/kyc | output/flutter-ui-reference/screenshots/profile/159_profile_kyc-page__profile-kyc__viewport.png | output/flutter-ui-reference/screenshots/profile/159_profile_kyc-page__profile-kyc__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-160 | 160 | SettingsPage | /profile/settings | output/flutter-ui-reference/screenshots/profile/160_profile_settings-page__profile-settings__viewport.png | output/flutter-ui-reference/screenshots/profile/160_profile_settings-page__profile-settings__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-161 | 161 | ActivityLogPage | /profile/activity | output/flutter-ui-reference/screenshots/profile/161_profile_activity-log-page__profile-activity__viewport.png | output/flutter-ui-reference/screenshots/profile/161_profile_activity-log-page__profile-activity__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-162 | 162 | ApiKeyCreatePage | /profile/api/create | output/flutter-ui-reference/screenshots/profile/162_profile_api-key-create-page__profile-api-create__viewport.png | output/flutter-ui-reference/screenshots/profile/162_profile_api-key-create-page__profile-api-create__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-163 | 163 | ApiManagementPage | /profile/api | output/flutter-ui-reference/screenshots/profile/163_profile_api-management-page__profile-api__viewport.png | output/flutter-ui-reference/screenshots/profile/163_profile_api-management-page__profile-api__fullpage.png | [x] Flutter UI done | [x] contract draft | [x] QA checked |
| SC-164 | 164 | VIPPage | /profile/vip | output/flutter-ui-reference/screenshots/profile/164_profile_vip-page__profile-vip__viewport.png | output/flutter-ui-reference/screenshots/profile/164_profile_vip-page__profile-vip__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-165 | 165 | DeviceManagementPage | /profile/devices | output/flutter-ui-reference/screenshots/profile/165_profile_device-management-page__profile-devices__viewport.png | output/flutter-ui-reference/screenshots/profile/165_profile_device-management-page__profile-devices__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-166 | 166 | SubAccountPage | /profile/sub-accounts | output/flutter-ui-reference/screenshots/profile/166_profile_sub-account-page__profile-sub-accounts__viewport.png | output/flutter-ui-reference/screenshots/profile/166_profile_sub-account-page__profile-sub-accounts__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-167 | 167 | PredictionsPortfolioPage | /profile/predictions | output/flutter-ui-reference/screenshots/profile/167_profile_predictions-portfolio-page__profile-predictions__viewport.png | output/flutter-ui-reference/screenshots/profile/167_profile_predictions-portfolio-page__profile-predictions__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-168 | 168 | MyArenaPage | /profile/arena | output/flutter-ui-reference/screenshots/profile/168_profile_my-arena-page__profile-arena__viewport.png | output/flutter-ui-reference/screenshots/profile/168_profile_my-arena-page__profile-arena__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |

### dca (11)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-169 | 169 | DCAPage | /dca | output/flutter-ui-reference/screenshots/dca/169_dca_dca-page__dca__viewport.png | output/flutter-ui-reference/screenshots/dca/169_dca_dca-page__dca__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-170 | 170 | DCARebalanceConfig | /dca/rebalance/config | output/flutter-ui-reference/screenshots/dca/170_dca_dca-rebalance-config__dca-rebalance-config__viewport.png | output/flutter-ui-reference/screenshots/dca/170_dca_dca-rebalance-config__dca-rebalance-config__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-171 | 171 | DCARebalanceDashboard | /dca/rebalance/config001 | output/flutter-ui-reference/screenshots/dca/171_dca_dca-rebalance-dashboard__dca-rebalance-config001__viewport.png | output/flutter-ui-reference/screenshots/dca/171_dca_dca-rebalance-dashboard__dca-rebalance-config001__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-172 | 172 | DCAScheduleConfig | /dca/schedule/config | output/flutter-ui-reference/screenshots/dca/172_dca_dca-schedule-config__dca-schedule-config__viewport.png | output/flutter-ui-reference/screenshots/dca/172_dca_dca-schedule-config__dca-schedule-config__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-173 | 173 | DCAScheduleAnalytics | /dca/schedule/config001 | output/flutter-ui-reference/screenshots/dca/173_dca_dca-schedule-analytics__dca-schedule-config001__viewport.png | output/flutter-ui-reference/screenshots/dca/173_dca_dca-schedule-analytics__dca-schedule-config001__fullpage.png | [x] Flutter UI complete | [x] contract draft | [x] QA checked |
| SC-174 | 174 | DCAPortfolioOptimizer | /dca/portfolio-optimizer | output/flutter-ui-reference/screenshots/dca/174_dca_dca-portfolio-optimizer__dca-portfolio-optimizer__viewport.png | output/flutter-ui-reference/screenshots/dca/174_dca_dca-portfolio-optimizer__dca-portfolio-optimizer__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-175 | 175 | DCADynamicAmount | /dca/dynamic-amount | output/flutter-ui-reference/screenshots/dca/175_dca_dca-dynamic-amount__dca-dynamic-amount__viewport.png | output/flutter-ui-reference/screenshots/dca/175_dca_dca-dynamic-amount__dca-dynamic-amount__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-176 | 176 | DCABacktesterPage | /dca/backtester | output/flutter-ui-reference/screenshots/dca/176_dca_dca-backtester-page__dca-backtester__viewport.png | output/flutter-ui-reference/screenshots/dca/176_dca_dca-backtester-page__dca-backtester__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-177 | 177 | DCAMultiAssetPage | /dca/multi-asset | output/flutter-ui-reference/screenshots/dca/177_dca_dca-multi-asset-page__dca-multi-asset__viewport.png | output/flutter-ui-reference/screenshots/dca/177_dca_dca-multi-asset-page__dca-multi-asset__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-178 | 178 | DCAPerformanceComparePage | /dca/performance-compare | output/flutter-ui-reference/screenshots/dca/178_dca_dca-performance-compare-page__dca-performance-compare__viewport.png | output/flutter-ui-reference/screenshots/dca/178_dca_dca-performance-compare-page__dca-performance-compare__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-179 | 179 | DCASmartRulesPage | /dca/smart-rules | output/flutter-ui-reference/screenshots/dca/179_dca_dca-smart-rules-page__dca-smart-rules__viewport.png | output/flutter-ui-reference/screenshots/dca/179_dca_dca-smart-rules-page__dca-smart-rules__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |

### admin (4)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-180 | 180 | AdminHome | /admin | output/flutter-ui-reference/screenshots/admin/180_admin_admin-home__admin__viewport.png | output/flutter-ui-reference/screenshots/admin/180_admin_admin-home__admin__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-181 | 181 | AnalyticsDashboard | /admin/analytics | output/flutter-ui-reference/screenshots/admin/181_admin_analytics-dashboard__admin-analytics__viewport.png | output/flutter-ui-reference/screenshots/admin/181_admin_analytics-dashboard__admin-analytics__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-182 | 182 | ABTestDashboard | /admin/abtests | output/flutter-ui-reference/screenshots/admin/182_admin_ab-test-dashboard__admin-abtests__viewport.png | output/flutter-ui-reference/screenshots/admin/182_admin_ab-test-dashboard__admin-abtests__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-183 | 183 | FunnelDashboard | /admin/funnels | output/flutter-ui-reference/screenshots/admin/183_admin_funnel-dashboard__admin-funnels__viewport.png | output/flutter-ui-reference/screenshots/admin/183_admin_funnel-dashboard__admin-funnels__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |

### arena (26)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-184 | 184 | ArenaHomePage | /arena | output/flutter-ui-reference/screenshots/arena/184_arena_arena-home-page__arena__viewport.png | output/flutter-ui-reference/screenshots/arena/184_arena_arena-home-page__arena__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-185 | 185 | ArenaStudioPage | /arena/studio | output/flutter-ui-reference/screenshots/arena/185_arena_arena-studio-page__arena-studio__viewport.png | output/flutter-ui-reference/screenshots/arena/185_arena_arena-studio-page__arena-studio__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-186 | 186 | ArenaSmartRuleBuilderPage | /arena/studio/smart-rules | output/flutter-ui-reference/screenshots/arena/186_arena_arena-smart-rule-builder-page__arena-studio-smart-rules__viewport.png | output/flutter-ui-reference/screenshots/arena/186_arena_arena-smart-rule-builder-page__arena-studio-smart-rules__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-187 | 187 | ArenaUniversalPresetLibraryPage | /arena/studio/presets | output/flutter-ui-reference/screenshots/arena/187_arena_arena-universal-preset-library-page__arena-studio-presets__viewport.png | output/flutter-ui-reference/screenshots/arena/187_arena_arena-universal-preset-library-page__arena-studio-presets__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-188 | 188 | ArenaGovernanceGatePage | /arena/studio/governance | output/flutter-ui-reference/screenshots/arena/188_arena_arena-governance-gate-page__arena-studio-governance__viewport.png | output/flutter-ui-reference/screenshots/arena/188_arena_arena-governance-gate-page__arena-studio-governance__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-189 | 189 | ArenaModeDetailPage | /arena/mode/mode001 | output/flutter-ui-reference/screenshots/arena/189_arena_arena-mode-detail-page__arena-mode-mode001__viewport.png | output/flutter-ui-reference/screenshots/arena/189_arena_arena-mode-detail-page__arena-mode-mode001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-190 | 190 | ArenaChallengeDetailPage | /arena/challenge/ch003 | output/flutter-ui-reference/screenshots/arena/190_arena_arena-challenge-detail-page__arena-challenge-ch003__viewport.png | output/flutter-ui-reference/screenshots/arena/190_arena_arena-challenge-detail-page__arena-challenge-ch003__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-191 | 191 | ArenaJoinPage | /arena/join/ch003 | output/flutter-ui-reference/screenshots/arena/191_arena_arena-join-page__arena-join-ch003__viewport.png | output/flutter-ui-reference/screenshots/arena/191_arena_arena-join-page__arena-join-ch003__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-192 | 192 | ArenaResolutionCenterPage | /arena/resolution | output/flutter-ui-reference/screenshots/arena/192_arena_arena-resolution-center-page__arena-resolution__viewport.png | output/flutter-ui-reference/screenshots/arena/192_arena_arena-resolution-center-page__arena-resolution__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-193 | 193 | ArenaCreatorPage | /arena/creator/cr001 | output/flutter-ui-reference/screenshots/arena/193_arena_arena-creator-page__arena-creator-cr001__viewport.png | output/flutter-ui-reference/screenshots/arena/193_arena_arena-creator-page__arena-creator-cr001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-194 | 194 | ArenaLeaderboardPage | /arena/leaderboard | output/flutter-ui-reference/screenshots/arena/194_arena_arena-leaderboard-page__arena-leaderboard__viewport.png | output/flutter-ui-reference/screenshots/arena/194_arena_arena-leaderboard-page__arena-leaderboard__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-195 | 195 | VerifiedChallengesPage | /arena/verified | output/flutter-ui-reference/screenshots/arena/195_arena_verified-challenges-page__arena-verified__viewport.png | output/flutter-ui-reference/screenshots/arena/195_arena_verified-challenges-page__arena-verified__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-196 | 196 | ArenaPointsPage | /arena/points | output/flutter-ui-reference/screenshots/arena/196_arena_arena-points-page__arena-points__viewport.png | output/flutter-ui-reference/screenshots/arena/196_arena_arena-points-page__arena-points__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-197 | 197 | ArenaFlowMapPage | /arena/flow-map | output/flutter-ui-reference/screenshots/arena/197_arena_arena-flow-map-page__arena-flow-map__viewport.png | output/flutter-ui-reference/screenshots/arena/197_arena_arena-flow-map-page__arena-flow-map__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-198 | 198 | ArenaSafetyCenterPage | /arena/safety | output/flutter-ui-reference/screenshots/arena/198_arena_arena-safety-center-page__arena-safety__viewport.png | output/flutter-ui-reference/screenshots/arena/198_arena_arena-safety-center-page__arena-safety__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-199 | 199 | ArenaTrustBreakdownPage | /arena/trust/user001 | output/flutter-ui-reference/screenshots/arena/199_arena_arena-trust-breakdown-page__arena-trust-user001__viewport.png | output/flutter-ui-reference/screenshots/arena/199_arena_arena-trust-breakdown-page__arena-trust-user001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-200 | 200 | ArenaPointsEntryDetailPage | /arena/ledger/entry/entry001 | output/flutter-ui-reference/screenshots/arena/200_arena_arena-points-entry-detail-page__arena-ledger-entry-entry001__viewport.png | output/flutter-ui-reference/screenshots/arena/200_arena_arena-points-entry-detail-page__arena-ledger-entry-entry001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-201 | 201 | ArenaPointsLedgerPage | /arena/ledger | output/flutter-ui-reference/screenshots/arena/201_arena_arena-points-ledger-page__arena-ledger__viewport.png | output/flutter-ui-reference/screenshots/arena/201_arena_arena-points-ledger-page__arena-ledger__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-202 | 202 | ArenaReportCasePage | /arena/report/case001 | output/flutter-ui-reference/screenshots/arena/202_arena_arena-report-case-page__arena-report-case001__viewport.png | output/flutter-ui-reference/screenshots/arena/202_arena_arena-report-case-page__arena-report-case001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-203 | 203 | ArenaBlockedUsersPage | /arena/blocked | output/flutter-ui-reference/screenshots/arena/203_arena_arena-blocked-users-page__arena-blocked__viewport.png | output/flutter-ui-reference/screenshots/arena/203_arena_arena-blocked-users-page__arena-blocked__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-204 | 204 | MyArenaReportsPage | /arena/my-reports | output/flutter-ui-reference/screenshots/arena/204_arena_my-arena-reports-page__arena-my-reports__viewport.png | output/flutter-ui-reference/screenshots/arena/204_arena_my-arena-reports-page__arena-my-reports__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-205 | 205 | MyArenaPage | /arena/my | output/flutter-ui-reference/screenshots/arena/205_arena_my-arena-page__arena-my__viewport.png | output/flutter-ui-reference/screenshots/arena/205_arena_my-arena-page__arena-my__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-206 | 206 | ArenaProductionReadyPage | /arena/production | output/flutter-ui-reference/screenshots/arena/206_arena_arena-production-ready-page__arena-production__viewport.png | output/flutter-ui-reference/screenshots/arena/206_arena_arena-production-ready-page__arena-production__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-207 | 207 | ArenaPredictionBridgeFoundationPage | /arena/bridge | output/flutter-ui-reference/screenshots/arena/207_arena_arena-prediction-bridge-foundation-page__arena-bridge__viewport.png | output/flutter-ui-reference/screenshots/arena/207_arena_arena-prediction-bridge-foundation-page__arena-bridge__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-208 | 208 | ConnectedEcosystemProductionPage | /arena/ecosystem | output/flutter-ui-reference/screenshots/arena/208_arena_connected-ecosystem-production-page__arena-ecosystem__viewport.png | output/flutter-ui-reference/screenshots/arena/208_arena_connected-ecosystem-production-page__arena-ecosystem__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-209 | 209 | ArenaGuidePage | /arena/guide | output/flutter-ui-reference/screenshots/arena/209_arena_arena-guide-page__arena-guide__viewport.png | output/flutter-ui-reference/screenshots/arena/209_arena_arena-guide-page__arena-guide__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |

### p2p (73)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-210 | 210 | P2PExpressConfirmPage | /p2p/express/confirm | output/flutter-ui-reference/screenshots/p2p/210_p2p_p2-p-express-confirm-page__p2p-express-confirm__viewport.png | output/flutter-ui-reference/screenshots/p2p/210_p2p_p2-p-express-confirm-page__p2p-express-confirm__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-211 | 211 | P2PExpressPage | /p2p/express | output/flutter-ui-reference/screenshots/p2p/211_p2p_p2-p-express-page__p2p-express__viewport.png | output/flutter-ui-reference/screenshots/p2p/211_p2p_p2-p-express-page__p2p-express__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-212 | 212 | P2POrderTimelinePage | /p2p/order/timeline/p2p001 | output/flutter-ui-reference/screenshots/p2p/212_p2p_p2-p-order-timeline-page__p2p-order-timeline-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/212_p2p_p2-p-order-timeline-page__p2p-order-timeline-p2p001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-213 | 213 | P2POrderRatePage | /p2p/order/rate/p2p001 | output/flutter-ui-reference/screenshots/p2p/213_p2p_p2-p-order-rate-page__p2p-order-rate-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/213_p2p_p2-p-order-rate-page__p2p-order-rate-p2p001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-214 | 214 | P2POrderCancelPage | /p2p/order/cancel/p2p001 | output/flutter-ui-reference/screenshots/p2p/214_p2p_p2-p-order-cancel-page__p2p-order-cancel-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/214_p2p_p2-p-order-cancel-page__p2p-order-cancel-p2p001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-215 | 215 | P2POrderProofPage | /p2p/order/proof/p2p001 | output/flutter-ui-reference/screenshots/p2p/215_p2p_p2-p-order-proof-page__p2p-order-proof-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/215_p2p_p2-p-order-proof-page__p2p-order-proof-p2p001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-216 | 216 | P2POrderPage | /p2p/order/p2p001 | output/flutter-ui-reference/screenshots/p2p/216_p2p_p2-p-order-page__p2p-order-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/216_p2p_p2-p-order-page__p2p-order-p2p001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-217 | 217 | P2PChatPage | /p2p/chat/p2p001 | output/flutter-ui-reference/screenshots/p2p/217_p2p_p2-p-chat-page__p2p-chat-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/217_p2p_p2-p-chat-page__p2p-chat-p2p001__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-218 | 218 | P2PDisputeDetailPage | /p2p/dispute/detail/sample | output/flutter-ui-reference/screenshots/p2p/218_p2p_p2-p-dispute-detail-page__p2p-dispute-detail-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/218_p2p_p2-p-dispute-detail-page__p2p-dispute-detail-sample__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-219 | 219 | P2PDisputeEvidencePage | /p2p/dispute/evidence/sample | output/flutter-ui-reference/screenshots/p2p/219_p2p_p2-p-dispute-evidence-page__p2p-dispute-evidence-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/219_p2p_p2-p-dispute-evidence-page__p2p-dispute-evidence-sample__fullpage.png | [x] Flutter UI | [x] contract draft | [x] QA checked |
| SC-220 | 220 | P2PDisputeResolutionPage | /p2p/dispute/resolution/sample | output/flutter-ui-reference/screenshots/p2p/220_p2p_p2-p-dispute-resolution-page__p2p-dispute-resolution-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/220_p2p_p2-p-dispute-resolution-page__p2p-dispute-resolution-sample__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-221 | 221 | P2PDisputePage | /p2p/dispute/p2p001 | output/flutter-ui-reference/screenshots/p2p/221_p2p_p2-p-dispute-page__p2p-dispute-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/221_p2p_p2-p-dispute-page__p2p-dispute-p2p001__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-222 | 222 | P2PDisputesPage | /p2p/disputes | output/flutter-ui-reference/screenshots/p2p/222_p2p_p2-p-disputes-page__p2p-disputes__viewport.png | output/flutter-ui-reference/screenshots/p2p/222_p2p_p2-p-disputes-page__p2p-disputes__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-223 | 223 | P2PAdAnalyticsPage | /p2p/ad-analytics/sample | output/flutter-ui-reference/screenshots/p2p/223_p2p_p2-p-ad-analytics-page__p2p-ad-analytics-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/223_p2p_p2-p-ad-analytics-page__p2p-ad-analytics-sample__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-224 | 224 | P2PAdDetailPage | /p2p/ad/sample | output/flutter-ui-reference/screenshots/p2p/224_p2p_p2-p-ad-detail-page__p2p-ad-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/224_p2p_p2-p-ad-detail-page__p2p-ad-sample__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-225 | 225 | P2PMyAdsPage | /p2p/my-ads | output/flutter-ui-reference/screenshots/p2p/225_p2p_p2-p-my-ads-page__p2p-my-ads__viewport.png | output/flutter-ui-reference/screenshots/p2p/225_p2p_p2-p-my-ads-page__p2p-my-ads__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-226 | 226 | P2PCreateAdPage | /p2p/create | output/flutter-ui-reference/screenshots/p2p/226_p2p_p2-p-create-ad-page__p2p-create__viewport.png | output/flutter-ui-reference/screenshots/p2p/226_p2p_p2-p-create-ad-page__p2p-create__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-227 | 227 | P2PMerchantApplyPage | /p2p/merchant-apply | output/flutter-ui-reference/screenshots/p2p/227_p2p_p2-p-merchant-apply-page__p2p-merchant-apply__viewport.png | output/flutter-ui-reference/screenshots/p2p/227_p2p_p2-p-merchant-apply-page__p2p-merchant-apply__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-228 | 228 | P2PMerchantProfilePage | /p2p/merchant/mc001 | output/flutter-ui-reference/screenshots/p2p/228_p2p_p2-p-merchant-profile-page__p2p-merchant-mc001__viewport.png | output/flutter-ui-reference/screenshots/p2p/228_p2p_p2-p-merchant-profile-page__p2p-merchant-mc001__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-229 | 229 | P2PReportMerchantPage | /p2p/report/mc001 | output/flutter-ui-reference/screenshots/p2p/229_p2p_p2-p-report-merchant-page__p2p-report-mc001__viewport.png | output/flutter-ui-reference/screenshots/p2p/229_p2p_p2-p-report-merchant-page__p2p-report-mc001__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-230 | 230 | P2PTradingLevelPage | /p2p/trading-level | output/flutter-ui-reference/screenshots/p2p/230_p2p_p2-p-trading-level-page__p2p-trading-level__viewport.png | output/flutter-ui-reference/screenshots/p2p/230_p2p_p2-p-trading-level-page__p2p-trading-level__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-231 | 231 | P2PReviewsPage | /p2p/reviews | output/flutter-ui-reference/screenshots/p2p/231_p2p_p2-p-reviews-page__p2p-reviews__viewport.png | output/flutter-ui-reference/screenshots/p2p/231_p2p_p2-p-reviews-page__p2p-reviews__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-232 | 232 | P2PPaymentMethodAddPage | /p2p/payment-method/add | output/flutter-ui-reference/screenshots/p2p/232_p2p_p2-p-payment-method-add-page__p2p-payment-method-add__viewport.png | output/flutter-ui-reference/screenshots/p2p/232_p2p_p2-p-payment-method-add-page__p2p-payment-method-add__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-233 | 233 | P2PPaymentMethodVerificationPage | /p2p/payment-method/verification/sample | output/flutter-ui-reference/screenshots/p2p/233_p2p_p2-p-payment-method-verification-page__p2p-payment-method-verification-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/233_p2p_p2-p-payment-method-verification-page__p2p-payment-method-verification-sample__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-234 | 234 | P2PPaymentMethodOwnershipPage | /p2p/payment-method/ownership/sample | output/flutter-ui-reference/screenshots/p2p/234_p2p_p2-p-payment-method-ownership-page__p2p-payment-method-ownership-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/234_p2p_p2-p-payment-method-ownership-page__p2p-payment-method-ownership-sample__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-235 | 235 | P2PPaymentMethodCoolingPeriodPage | /p2p/payment-method/cooling-period | output/flutter-ui-reference/screenshots/p2p/235_p2p_p2-p-payment-method-cooling-period-page__p2p-payment-method-cooling-period__viewport.png | output/flutter-ui-reference/screenshots/p2p/235_p2p_p2-p-payment-method-cooling-period-page__p2p-payment-method-cooling-period__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-236 | 236 | P2PPaymentMethodHistoryPage | /p2p/payment-method/history | output/flutter-ui-reference/screenshots/p2p/236_p2p_p2-p-payment-method-history-page__p2p-payment-method-history__viewport.png | output/flutter-ui-reference/screenshots/p2p/236_p2p_p2-p-payment-method-history-page__p2p-payment-method-history__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-237 | 237 | P2PPaymentMethodsPage | /p2p/payment-methods | output/flutter-ui-reference/screenshots/p2p/237_p2p_p2-p-payment-methods-page__p2p-payment-methods__viewport.png | output/flutter-ui-reference/screenshots/p2p/237_p2p_p2-p-payment-methods-page__p2p-payment-methods__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-238 | 238 | P2PInsuranceFundPage | /p2p/insurance | output/flutter-ui-reference/screenshots/p2p/238_p2p_p2-p-insurance-fund-page__p2p-insurance__viewport.png | output/flutter-ui-reference/screenshots/p2p/238_p2p_p2-p-insurance-fund-page__p2p-insurance__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-239 | 239 | P2PInsuranceCertificatePage | /p2p/insurance/certificate | output/flutter-ui-reference/screenshots/p2p/239_p2p_p2-p-insurance-certificate-page__p2p-insurance-certificate__viewport.png | output/flutter-ui-reference/screenshots/p2p/239_p2p_p2-p-insurance-certificate-page__p2p-insurance-certificate__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-240 | 240 | P2PInsuranceScorePage | /p2p/insurance/score | output/flutter-ui-reference/screenshots/p2p/240_p2p_p2-p-insurance-score-page__p2p-insurance-score__viewport.png | output/flutter-ui-reference/screenshots/p2p/240_p2p_p2-p-insurance-score-page__p2p-insurance-score__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-241 | 241 | P2PInsurancePolicyPage | /p2p/insurance/policy | output/flutter-ui-reference/screenshots/p2p/241_p2p_p2-p-insurance-policy-page__p2p-insurance-policy__viewport.png | output/flutter-ui-reference/screenshots/p2p/241_p2p_p2-p-insurance-policy-page__p2p-insurance-policy__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-242 | 242 | P2PContributionHistoryPage | /p2p/insurance/contribution-history | output/flutter-ui-reference/screenshots/p2p/242_p2p_p2-p-contribution-history-page__p2p-insurance-contribution-history__viewport.png | output/flutter-ui-reference/screenshots/p2p/242_p2p_p2-p-contribution-history-page__p2p-insurance-contribution-history__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-243 | 243 | P2PClaimDetailPage | /p2p/insurance/claim/sample | output/flutter-ui-reference/screenshots/p2p/243_p2p_p2-p-claim-detail-page__p2p-insurance-claim-sample__viewport.png | output/flutter-ui-reference/screenshots/p2p/243_p2p_p2-p-claim-detail-page__p2p-insurance-claim-sample__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-244 | 244 | P2PInsuranceFundPage | /p2p/insurance-fund | output/flutter-ui-reference/screenshots/p2p/244_p2p_p2-p-insurance-fund-page__p2p-insurance-fund__viewport.png | output/flutter-ui-reference/screenshots/p2p/244_p2p_p2-p-insurance-fund-page__p2p-insurance-fund__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-245 | 245 | P2PEscrowBalancePage | /p2p/escrow/balance | output/flutter-ui-reference/screenshots/p2p/245_p2p_p2-p-escrow-balance-page__p2p-escrow-balance__viewport.png | output/flutter-ui-reference/screenshots/p2p/245_p2p_p2-p-escrow-balance-page__p2p-escrow-balance__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-246 | 246 | P2PEscrowDetailPage | /p2p/escrow/p2p001 | output/flutter-ui-reference/screenshots/p2p/246_p2p_p2-p-escrow-detail-page__p2p-escrow-p2p001__viewport.png | output/flutter-ui-reference/screenshots/p2p/246_p2p_p2-p-escrow-detail-page__p2p-escrow-p2p001__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-247 | 247 | P2PKYCRequirementsPage | /p2p/kyc/requirements | output/flutter-ui-reference/screenshots/p2p/247_p2p_p2-pkyc-requirements-page__p2p-kyc-requirements__viewport.png | output/flutter-ui-reference/screenshots/p2p/247_p2p_p2-pkyc-requirements-page__p2p-kyc-requirements__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-248 | 248 | P2PKYCStatusPage | /p2p/kyc/status | output/flutter-ui-reference/screenshots/p2p/248_p2p_p2-pkyc-status-page__p2p-kyc-status__viewport.png | output/flutter-ui-reference/screenshots/p2p/248_p2p_p2-pkyc-status-page__p2p-kyc-status__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-249 | 249 | P2PIdentityVerificationPage | /p2p/kyc/identity | output/flutter-ui-reference/screenshots/p2p/249_p2p_p2-p-identity-verification-page__p2p-kyc-identity__viewport.png | output/flutter-ui-reference/screenshots/p2p/249_p2p_p2-p-identity-verification-page__p2p-kyc-identity__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-250 | 250 | P2PAddressProofPage | /p2p/kyc/address | output/flutter-ui-reference/screenshots/p2p/250_p2p_p2-p-address-proof-page__p2p-kyc-address__viewport.png | output/flutter-ui-reference/screenshots/p2p/250_p2p_p2-p-address-proof-page__p2p-kyc-address__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-251 | 251 | P2PSelfieVerificationPage | /p2p/kyc/selfie | output/flutter-ui-reference/screenshots/p2p/251_p2p_p2-p-selfie-verification-page__p2p-kyc-selfie__viewport.png | output/flutter-ui-reference/screenshots/p2p/251_p2p_p2-p-selfie-verification-page__p2p-kyc-selfie__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-252 | 252 | P2PVideoVerificationPage | /p2p/kyc/video | output/flutter-ui-reference/screenshots/p2p/252_p2p_p2-p-video-verification-page__p2p-kyc-video__viewport.png | output/flutter-ui-reference/screenshots/p2p/252_p2p_p2-p-video-verification-page__p2p-kyc-video__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-253 | 253 | P2PSecurityCenterPage | /p2p/security/center | output/flutter-ui-reference/screenshots/p2p/253_p2p_p2-p-security-center-page__p2p-security-center__viewport.png | output/flutter-ui-reference/screenshots/p2p/253_p2p_p2-p-security-center-page__p2p-security-center__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-254 | 254 | P2P2FASettingsPage | /p2p/security/2fa | output/flutter-ui-reference/screenshots/p2p/254_p2p_p2-p2-fa-settings-page__p2p-security-2fa__viewport.png | output/flutter-ui-reference/screenshots/p2p/254_p2p_p2-p2-fa-settings-page__p2p-security-2fa__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-255 | 255 | P2PDeviceManagementPage | /p2p/security/devices | output/flutter-ui-reference/screenshots/p2p/255_p2p_p2-p-device-management-page__p2p-security-devices__viewport.png | output/flutter-ui-reference/screenshots/p2p/255_p2p_p2-p-device-management-page__p2p-security-devices__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-256 | 256 | P2PAntiPhishingCodePage | /p2p/security/anti-phishing | output/flutter-ui-reference/screenshots/p2p/256_p2p_p2-p-anti-phishing-code-page__p2p-security-anti-phishing__viewport.png | output/flutter-ui-reference/screenshots/p2p/256_p2p_p2-p-anti-phishing-code-page__p2p-security-anti-phishing__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-257 | 257 | P2PLoginHistoryPage | /p2p/security/login-history | output/flutter-ui-reference/screenshots/p2p/257_p2p_p2-p-login-history-page__p2p-security-login-history__viewport.png | output/flutter-ui-reference/screenshots/p2p/257_p2p_p2-p-login-history-page__p2p-security-login-history__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-258 | 258 | P2PSuspiciousActivityPage | /p2p/security/suspicious-activity | output/flutter-ui-reference/screenshots/p2p/258_p2p_p2-p-suspicious-activity-page__p2p-security-suspicious-activity__viewport.png | output/flutter-ui-reference/screenshots/p2p/258_p2p_p2-p-suspicious-activity-page__p2p-security-suspicious-activity__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-259 | 259 | P2PE2EInfoPage | /p2p/e2e-info | output/flutter-ui-reference/screenshots/p2p/259_p2p_p2-pe2-e-info-page__p2p-e2e-info__viewport.png | output/flutter-ui-reference/screenshots/p2p/259_p2p_p2-pe2-e-info-page__p2p-e2e-info__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-260 | 260 | P2PFraudPreventionPage | /p2p/fraud-prevention | output/flutter-ui-reference/screenshots/p2p/260_p2p_p2-p-fraud-prevention-page__p2p-fraud-prevention__viewport.png | output/flutter-ui-reference/screenshots/p2p/260_p2p_p2-p-fraud-prevention-page__p2p-fraud-prevention__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-261 | 261 | P2PWalletTransferPage | /p2p/wallet/transfer | output/flutter-ui-reference/screenshots/p2p/261_p2p_p2-p-wallet-transfer-page__p2p-wallet-transfer__viewport.png | output/flutter-ui-reference/screenshots/p2p/261_p2p_p2-p-wallet-transfer-page__p2p-wallet-transfer__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-262 | 262 | P2PFundLockHistoryPage | /p2p/wallet/fund-lock-history | output/flutter-ui-reference/screenshots/p2p/262_p2p_p2-p-fund-lock-history-page__p2p-wallet-fund-lock-history__viewport.png | output/flutter-ui-reference/screenshots/p2p/262_p2p_p2-p-fund-lock-history-page__p2p-wallet-fund-lock-history__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-263 | 263 | P2PFundLockHistoryPage | /p2p/wallet/history | output/flutter-ui-reference/screenshots/p2p/263_p2p_p2-p-fund-lock-history-page__p2p-wallet-history__viewport.png | output/flutter-ui-reference/screenshots/p2p/263_p2p_p2-p-fund-lock-history-page__p2p-wallet-history__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-264 | 264 | P2PWalletPage | /p2p/wallet | output/flutter-ui-reference/screenshots/p2p/264_p2p_p2-p-wallet-page__p2p-wallet__viewport.png | output/flutter-ui-reference/screenshots/p2p/264_p2p_p2-p-wallet-page__p2p-wallet__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-265 | 265 | P2PLimitTrackerPage | /p2p/limits/tracker | output/flutter-ui-reference/screenshots/p2p/265_p2p_p2-p-limit-tracker-page__p2p-limits-tracker__viewport.png | output/flutter-ui-reference/screenshots/p2p/265_p2p_p2-p-limit-tracker-page__p2p-limits-tracker__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-266 | 266 | P2PTransactionLimitsPage | /p2p/limits | output/flutter-ui-reference/screenshots/p2p/266_p2p_p2-p-transaction-limits-page__p2p-limits__viewport.png | output/flutter-ui-reference/screenshots/p2p/266_p2p_p2-p-transaction-limits-page__p2p-limits__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-267 | 267 | P2PComplianceOverviewPage | /p2p/compliance/overview | output/flutter-ui-reference/screenshots/p2p/267_p2p_p2-p-compliance-overview-page__p2p-compliance-overview__viewport.png | output/flutter-ui-reference/screenshots/p2p/267_p2p_p2-p-compliance-overview-page__p2p-compliance-overview__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-268 | 268 | P2PAMLScreeningPage | /p2p/compliance/aml-screening | output/flutter-ui-reference/screenshots/p2p/268_p2p_p2-paml-screening-page__p2p-compliance-aml-screening__viewport.png | output/flutter-ui-reference/screenshots/p2p/268_p2p_p2-paml-screening-page__p2p-compliance-aml-screening__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-269 | 269 | P2PSourceOfFundsPage | /p2p/compliance/source-of-funds | output/flutter-ui-reference/screenshots/p2p/269_p2p_p2-p-source-of-funds-page__p2p-compliance-source-of-funds__viewport.png | output/flutter-ui-reference/screenshots/p2p/269_p2p_p2-p-source-of-funds-page__p2p-compliance-source-of-funds__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-270 | 270 | P2PLargeTransactionJustificationPage | /p2p/compliance/large-transaction | output/flutter-ui-reference/screenshots/p2p/270_p2p_p2-p-large-transaction-justification-page__p2p-compliance-large-transaction__viewport.png | output/flutter-ui-reference/screenshots/p2p/270_p2p_p2-p-large-transaction-justification-page__p2p-compliance-large-transaction__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-271 | 271 | P2PRiskAssessmentPage | /p2p/compliance/risk-assessment | output/flutter-ui-reference/screenshots/p2p/271_p2p_p2-p-risk-assessment-page__p2p-compliance-risk-assessment__viewport.png | output/flutter-ui-reference/screenshots/p2p/271_p2p_p2-p-risk-assessment-page__p2p-compliance-risk-assessment__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-272 | 272 | P2PTaxReportingPage | /p2p/tax-reporting | output/flutter-ui-reference/screenshots/p2p/272_p2p_p2-p-tax-reporting-page__p2p-tax-reporting__viewport.png | output/flutter-ui-reference/screenshots/p2p/272_p2p_p2-p-tax-reporting-page__p2p-tax-reporting__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-273 | 273 | P2POrderBookPage | /p2p/order-book | output/flutter-ui-reference/screenshots/p2p/273_p2p_p2-p-order-book-page__p2p-order-book__viewport.png | output/flutter-ui-reference/screenshots/p2p/273_p2p_p2-p-order-book-page__p2p-order-book__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-274 | 274 | P2PDashboardPage | /p2p/dashboard | output/flutter-ui-reference/screenshots/p2p/274_p2p_p2-p-dashboard-page__p2p-dashboard__viewport.png | output/flutter-ui-reference/screenshots/p2p/274_p2p_p2-p-dashboard-page__p2p-dashboard__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-275 | 275 | P2PAchievementsPage | /p2p/achievements | output/flutter-ui-reference/screenshots/p2p/275_p2p_p2-p-achievements-page__p2p-achievements__viewport.png | output/flutter-ui-reference/screenshots/p2p/275_p2p_p2-p-achievements-page__p2p-achievements__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-276 | 276 | P2PBlacklistAddPage | /p2p/blacklist/add | output/flutter-ui-reference/screenshots/p2p/276_p2p_p2-p-blacklist-add-page__p2p-blacklist-add__viewport.png | output/flutter-ui-reference/screenshots/p2p/276_p2p_p2-p-blacklist-add-page__p2p-blacklist-add__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-277 | 277 | P2PBlacklistPage | /p2p/blacklist | output/flutter-ui-reference/screenshots/p2p/277_p2p_p2-p-blacklist-page__p2p-blacklist__viewport.png | output/flutter-ui-reference/screenshots/p2p/277_p2p_p2-p-blacklist-page__p2p-blacklist__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-278 | 278 | P2PNotificationsSettingsPage | /p2p/settings/notifications | output/flutter-ui-reference/screenshots/p2p/278_p2p_p2-p-notifications-settings-page__p2p-settings-notifications__viewport.png | output/flutter-ui-reference/screenshots/p2p/278_p2p_p2-p-notifications-settings-page__p2p-settings-notifications__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-279 | 279 | P2PSettingsPage | /p2p/settings | output/flutter-ui-reference/screenshots/p2p/279_p2p_p2-p-settings-page__p2p-settings__viewport.png | output/flutter-ui-reference/screenshots/p2p/279_p2p_p2-p-settings-page__p2p-settings__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-280 | 280 | P2PGuidePage | /p2p/guide | output/flutter-ui-reference/screenshots/p2p/280_p2p_p2-p-guide-page__p2p-guide__viewport.png | output/flutter-ui-reference/screenshots/p2p/280_p2p_p2-p-guide-page__p2p-guide__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-281 | 281 | P2PMyOrdersPage | /p2p/my-orders | output/flutter-ui-reference/screenshots/p2p/281_p2p_p2-p-my-orders-page__p2p-my-orders__viewport.png | output/flutter-ui-reference/screenshots/p2p/281_p2p_p2-p-my-orders-page__p2p-my-orders__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-282 | 282 | P2PHomePage | /p2p | output/flutter-ui-reference/screenshots/p2p/282_p2p_p2-p-home-page__p2p__viewport.png | output/flutter-ui-reference/screenshots/p2p/282_p2p_p2-p-home-page__p2p__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |

### discovery (3)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-283 | 283 | UnifiedSearchPage | /search | output/flutter-ui-reference/screenshots/discovery/283_discovery_unified-search-page__search__viewport.png | output/flutter-ui-reference/screenshots/discovery/283_discovery_unified-search-page__search__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-284 | 284 | TopicHubPage | /topics | output/flutter-ui-reference/screenshots/discovery/284_discovery_topic-hub-page__topics__viewport.png | output/flutter-ui-reference/screenshots/discovery/284_discovery_topic-hub-page__topics__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |
| SC-285 | 285 | TopicHubPage | /topic/crypto | output/flutter-ui-reference/screenshots/discovery/285_discovery_topic-hub-page__topic-crypto__viewport.png | output/flutter-ui-reference/screenshots/discovery/285_discovery_topic-hub-page__topic-crypto__fullpage.png | [x] Flutter UI implemented | [x] contract draft | [x] QA checked |

### referral (5)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-286 | 286 | ReferralHistoryPage | /referral/history | output/flutter-ui-reference/screenshots/referral/286_referral_referral-history-page__referral-history__viewport.png | output/flutter-ui-reference/screenshots/referral/286_referral_referral-history-page__referral-history__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-287 | 287 | ReferralRewardsPage | /referral/rewards | output/flutter-ui-reference/screenshots/referral/287_referral_referral-rewards-page__referral-rewards__viewport.png | output/flutter-ui-reference/screenshots/referral/287_referral_referral-rewards-page__referral-rewards__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-288 | 288 | ReferralRulesPage | /referral/rules | output/flutter-ui-reference/screenshots/referral/288_referral_referral-rules-page__referral-rules__viewport.png | output/flutter-ui-reference/screenshots/referral/288_referral_referral-rules-page__referral-rules__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-289 | 289 | ReferralFriendDetailPage | /referral/friend/friend001 | output/flutter-ui-reference/screenshots/referral/289_referral_referral-friend-detail-page__referral-friend-friend001__viewport.png | output/flutter-ui-reference/screenshots/referral/289_referral_referral-friend-detail-page__referral-friend-friend001__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-290 | 290 | ReferralHomePage | /referral | output/flutter-ui-reference/screenshots/referral/290_referral_referral-home-page__referral__viewport.png | output/flutter-ui-reference/screenshots/referral/290_referral_referral-home-page__referral__fullpage.png | [x] migrated | [x] contract draft | [x] checked |

### notifications (1)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-291 | 291 | NotificationsPage | /notifications | output/flutter-ui-reference/screenshots/notifications/291_notifications_notifications-page__notifications__viewport.png | output/flutter-ui-reference/screenshots/notifications/291_notifications_notifications-page__notifications__fullpage.png | [x] migrated | [x] contract draft | [x] checked |

### support (3)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-292 | 292 | HelpCenterPage | /support/help | output/flutter-ui-reference/screenshots/support/292_support_help-center-page__support-help__viewport.png | output/flutter-ui-reference/screenshots/support/292_support_help-center-page__support-help__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-293 | 293 | AnnouncementsPage | /support/announcements | output/flutter-ui-reference/screenshots/support/293_support_announcements-page__support-announcements__viewport.png | output/flutter-ui-reference/screenshots/support/293_support_announcements-page__support-announcements__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-294 | 294 | SupportPage | /support | output/flutter-ui-reference/screenshots/support/294_support_support-page__support__viewport.png | output/flutter-ui-reference/screenshots/support/294_support_support-page__support__fullpage.png | [x] migrated | [x] contract draft | [x] checked |

### launchpad (24)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-295 | 295 | LaunchpadPage | /launchpad | output/flutter-ui-reference/screenshots/launchpad/295_launchpad_launchpad-page__launchpad__viewport.png | output/flutter-ui-reference/screenshots/launchpad/295_launchpad_launchpad-page__launchpad__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-296 | 296 | LaunchpadPortfolioPage | /launchpad/portfolio | output/flutter-ui-reference/screenshots/launchpad/296_launchpad_launchpad-portfolio-page__launchpad-portfolio__viewport.png | output/flutter-ui-reference/screenshots/launchpad/296_launchpad_launchpad-portfolio-page__launchpad-portfolio__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-297 | 297 | LaunchpadPerformancePage | /launchpad/performance | output/flutter-ui-reference/screenshots/launchpad/297_launchpad_launchpad-performance-page__launchpad-performance__viewport.png | output/flutter-ui-reference/screenshots/launchpad/297_launchpad_launchpad-performance-page__launchpad-performance__fullpage.png | [x] migrated | [x] contract draft | [x] checked |
| SC-298 | 298 | LaunchpadStakingPage | /launchpad/staking | output/flutter-ui-reference/screenshots/launchpad/298_launchpad_launchpad-staking-page__launchpad-staking__viewport.png | output/flutter-ui-reference/screenshots/launchpad/298_launchpad_launchpad-staking-page__launchpad-staking__fullpage.png | [x] Flutter implemented | [x] contract draft | [x] QA passed |
| SC-299 | 299 | LaunchpadIDOBridgePage | /launchpad/idobridge/sample | output/flutter-ui-reference/screenshots/launchpad/299_launchpad_launchpad-ido-bridge-page__launchpad-idobridge-sample__viewport.png | output/flutter-ui-reference/screenshots/launchpad/299_launchpad_launchpad-ido-bridge-page__launchpad-idobridge-sample__fullpage.png | [x] Flutter implemented | [x] contract draft | [x] QA passed |
| SC-300 | 300 | LaunchpadContractPage | /launchpad/contract/sample | output/flutter-ui-reference/screenshots/launchpad/300_launchpad_launchpad-contract-page__launchpad-contract-sample__viewport.png | output/flutter-ui-reference/screenshots/launchpad/300_launchpad_launchpad-contract-page__launchpad-contract-sample__fullpage.png | [x] Flutter implemented | [x] contract draft | [x] QA passed |
| SC-301 | 301 | LaunchpadReceiptPage | /launchpad/receipt/sub001 | output/flutter-ui-reference/screenshots/launchpad/301_launchpad_launchpad-receipt-page__launchpad-receipt-sub001__viewport.png | output/flutter-ui-reference/screenshots/launchpad/301_launchpad_launchpad-receipt-page__launchpad-receipt-sub001__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-302 | 302 | LaunchpadClaimReceiptPage | /launchpad/claim-receipt/pos001 | output/flutter-ui-reference/screenshots/launchpad/302_launchpad_launchpad-claim-receipt-page__launchpad-claim-receipt-pos001__viewport.png | output/flutter-ui-reference/screenshots/launchpad/302_launchpad_launchpad-claim-receipt-page__launchpad-claim-receipt-pos001__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-303 | 303 | LaunchpadBridgeOrderPage | /launchpad/bridge-order/tx001 | output/flutter-ui-reference/screenshots/launchpad/303_launchpad_launchpad-bridge-order-page__launchpad-bridge-order-tx001__viewport.png | output/flutter-ui-reference/screenshots/launchpad/303_launchpad_launchpad-bridge-order-page__launchpad-bridge-order-tx001__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-304 | 304 | LaunchpadBatchClaimPage | /launchpad/batch-claim | output/flutter-ui-reference/screenshots/launchpad/304_launchpad_launchpad-batch-claim-page__launchpad-batch-claim__viewport.png | output/flutter-ui-reference/screenshots/launchpad/304_launchpad_launchpad-batch-claim-page__launchpad-batch-claim__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-305 | 305 | LaunchpadBridgeComparePage | /launchpad/bridge-compare | output/flutter-ui-reference/screenshots/launchpad/305_launchpad_launchpad-bridge-compare-page__launchpad-bridge-compare__viewport.png | output/flutter-ui-reference/screenshots/launchpad/305_launchpad_launchpad-bridge-compare-page__launchpad-bridge-compare__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-306 | 306 | LaunchpadNotifSoundPage | /launchpad/notif-sound | output/flutter-ui-reference/screenshots/launchpad/306_launchpad_launchpad-notif-sound-page__launchpad-notif-sound__viewport.png | output/flutter-ui-reference/screenshots/launchpad/306_launchpad_launchpad-notif-sound-page__launchpad-notif-sound__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-307 | 307 | LaunchpadEventLogPage | /launchpad/event-log | output/flutter-ui-reference/screenshots/launchpad/307_launchpad_launchpad-event-log-page__launchpad-event-log__viewport.png | output/flutter-ui-reference/screenshots/launchpad/307_launchpad_launchpad-event-log-page__launchpad-event-log__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-308 | 308 | LaunchpadABIDiffPage | /launchpad/abi-diff/contract001 | output/flutter-ui-reference/screenshots/launchpad/308_launchpad_launchpad-abi-diff-page__launchpad-abi-diff-contract001__viewport.png | output/flutter-ui-reference/screenshots/launchpad/308_launchpad_launchpad-abi-diff-page__launchpad-abi-diff-contract001__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-309 | 309 | LaunchpadAddressBookPage | /launchpad/address-book | output/flutter-ui-reference/screenshots/launchpad/309_launchpad_launchpad-address-book-page__launchpad-address-book__viewport.png | output/flutter-ui-reference/screenshots/launchpad/309_launchpad_launchpad-address-book-page__launchpad-address-book__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-310 | 310 | LaunchpadWebhooksPage | /launchpad/webhooks | output/flutter-ui-reference/screenshots/launchpad/310_launchpad_launchpad-webhooks-page__launchpad-webhooks__viewport.png | output/flutter-ui-reference/screenshots/launchpad/310_launchpad_launchpad-webhooks-page__launchpad-webhooks__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-311 | 311 | LaunchpadGasTrackerPage | /launchpad/gas-tracker | output/flutter-ui-reference/screenshots/launchpad/311_launchpad_launchpad-gas-tracker-page__launchpad-gas-tracker__viewport.png | output/flutter-ui-reference/screenshots/launchpad/311_launchpad_launchpad-gas-tracker-page__launchpad-gas-tracker__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-312 | 312 | LaunchpadRebalancePage | /launchpad/rebalance | output/flutter-ui-reference/screenshots/launchpad/312_launchpad_launchpad-rebalance-page__launchpad-rebalance__viewport.png | output/flutter-ui-reference/screenshots/launchpad/312_launchpad_launchpad-rebalance-page__launchpad-rebalance__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-313 | 313 | LaunchpadMultisigPage | /launchpad/multisig | output/flutter-ui-reference/screenshots/launchpad/313_launchpad_launchpad-multisig-page__launchpad-multisig__viewport.png | output/flutter-ui-reference/screenshots/launchpad/313_launchpad_launchpad-multisig-page__launchpad-multisig__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-314 | 314 | LaunchpadSwapAggregatorPage | /launchpad/swap-aggregator | output/flutter-ui-reference/screenshots/launchpad/314_launchpad_launchpad-swap-aggregator-page__launchpad-swap-aggregator__viewport.png | output/flutter-ui-reference/screenshots/launchpad/314_launchpad_launchpad-swap-aggregator-page__launchpad-swap-aggregator__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-315 | 315 | LaunchpadLimitOrdersPage | /launchpad/limit-orders | output/flutter-ui-reference/screenshots/launchpad/315_launchpad_launchpad-limit-orders-page__launchpad-limit-orders__viewport.png | output/flutter-ui-reference/screenshots/launchpad/315_launchpad_launchpad-limit-orders-page__launchpad-limit-orders__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-316 | 316 | LaunchpadDCABuilderPage | /launchpad/dca-builder | output/flutter-ui-reference/screenshots/launchpad/316_launchpad_launchpad-dca-builder-page__launchpad-dca-builder__viewport.png | output/flutter-ui-reference/screenshots/launchpad/316_launchpad_launchpad-dca-builder-page__launchpad-dca-builder__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-317 | 317 | LaunchpadRiskAnalyticsPage | /launchpad/risk-analytics | output/flutter-ui-reference/screenshots/launchpad/317_launchpad_launchpad-risk-analytics-page__launchpad-risk-analytics__viewport.png | output/flutter-ui-reference/screenshots/launchpad/317_launchpad_launchpad-risk-analytics-page__launchpad-risk-analytics__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-318 | 318 | LaunchpadDetailPage | /launchpad/sample | output/flutter-ui-reference/screenshots/launchpad/318_launchpad_launchpad-detail-page__launchpad-sample__viewport.png | output/flutter-ui-reference/screenshots/launchpad/318_launchpad_launchpad-detail-page__launchpad-sample__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

### rewards (1)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-319 | 319 | RewardsHubPage | /rewards | output/flutter-ui-reference/screenshots/rewards/319_rewards_rewards-hub-page__rewards__viewport.png | output/flutter-ui-reference/screenshots/rewards/319_rewards_rewards-hub-page__rewards__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

### enterprise-states (1)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-320 | 320 | EnterpriseStatesPage | /enterprise-states | output/flutter-ui-reference/screenshots/enterprise-states/320_enterprise-states_enterprise-states-page__enterprise-states__viewport.png | output/flutter-ui-reference/screenshots/enterprise-states/320_enterprise-states_enterprise-states-page__enterprise-states__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

### cross-module (4)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-321 | 321 | UnifiedPortfolioDashboard | /unified-portfolio | output/flutter-ui-reference/screenshots/cross-module/321_cross-module_unified-portfolio-dashboard__unified-portfolio__viewport.png | output/flutter-ui-reference/screenshots/cross-module/321_cross-module_unified-portfolio-dashboard__unified-portfolio__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-322 | 322 | CrossModuleAnalytics | /cross-module-analytics | output/flutter-ui-reference/screenshots/cross-module/322_cross-module_cross-module-analytics__cross-module-analytics__viewport.png | output/flutter-ui-reference/screenshots/cross-module/322_cross-module_cross-module-analytics__cross-module-analytics__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-323 | 323 | SmartAlertCenter | /smart-alerts | output/flutter-ui-reference/screenshots/cross-module/323_cross-module_smart-alert-center__smart-alerts__viewport.png | output/flutter-ui-reference/screenshots/cross-module/323_cross-module_smart-alert-center__smart-alerts__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-324 | 324 | TaxReportCenter | /tax-reports | output/flutter-ui-reference/screenshots/cross-module/324_cross-module_tax-report-center__tax-reports__viewport.png | output/flutter-ui-reference/screenshots/cross-module/324_cross-module_tax-report-center__tax-reports__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

### dev (5)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-325 | 325 | RouteChecker | /dev/route-checker | output/flutter-ui-reference/screenshots/dev/325_dev_route-checker__dev-route-checker__viewport.png | output/flutter-ui-reference/screenshots/dev/325_dev_route-checker__dev-route-checker__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-326 | 326 | PerformanceMonitor | /dev/performance-monitor | output/flutter-ui-reference/screenshots/dev/326_dev_performance-monitor__dev-performance-monitor__viewport.png | output/flutter-ui-reference/screenshots/dev/326_dev_performance-monitor__dev-performance-monitor__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-398 | 398 | MissingScreensShowcasePage | /dev/showcase | output/flutter-ui-reference/screenshots/dev/398_dev_missing-screens-showcase-page__dev-showcase__viewport.png | output/flutter-ui-reference/screenshots/dev/398_dev_missing-screens-showcase-page__dev-showcase__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-399 | 399 | DesignSystemPage | /dev/design-system | output/flutter-ui-reference/screenshots/dev/399_dev_design-system-page__dev-design-system__viewport.png | output/flutter-ui-reference/screenshots/dev/399_dev_design-system-page__dev-design-system__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-400 | 400 | DCAOverviewDemo | /dev/dca-overview | output/flutter-ui-reference/screenshots/dev/400_dev_dca-overview-demo__dev-dca-overview__viewport.png | output/flutter-ui-reference/screenshots/dev/400_dev_dca-overview-demo__dev-dca-overview__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

### earn (70)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-327 | 327 | StakingEarnPage | /earn | output/flutter-ui-reference/screenshots/earn/327_earn_staking-earn-page__earn__viewport.png | output/flutter-ui-reference/screenshots/earn/327_earn_staking-earn-page__earn__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-328 | 328 | StakingEarnPage | /earn/staking | output/flutter-ui-reference/screenshots/earn/328_earn_staking-earn-page__earn-staking__viewport.png | output/flutter-ui-reference/screenshots/earn/328_earn_staking-earn-page__earn-staking__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-329 | 329 | SavingsPage | /earn/savings | output/flutter-ui-reference/screenshots/earn/329_earn_savings-page__earn-savings__viewport.png | output/flutter-ui-reference/screenshots/earn/329_earn_savings-page__earn-savings__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-330 | 330 | SavingsProductDetailPage | /earn/savings/product/sample | output/flutter-ui-reference/screenshots/earn/330_earn_savings-product-detail-page__earn-savings-product-sample__viewport.png | output/flutter-ui-reference/screenshots/earn/330_earn_savings-product-detail-page__earn-savings-product-sample__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-331 | 331 | SavingsRedeemPage | /earn/savings/redeem/pos001 | output/flutter-ui-reference/screenshots/earn/331_earn_savings-redeem-page__earn-savings-redeem-pos001__viewport.png | output/flutter-ui-reference/screenshots/earn/331_earn_savings-redeem-page__earn-savings-redeem-pos001__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-332 | 332 | SavingsReceiptPage | /earn/savings/receipt | output/flutter-ui-reference/screenshots/earn/332_earn_savings-receipt-page__earn-savings-receipt__viewport.png | output/flutter-ui-reference/screenshots/earn/332_earn_savings-receipt-page__earn-savings-receipt__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-333 | 333 | SavingsPortfolioPage | /earn/savings/portfolio | output/flutter-ui-reference/screenshots/earn/333_earn_savings-portfolio-page__earn-savings-portfolio__viewport.png | output/flutter-ui-reference/screenshots/earn/333_earn_savings-portfolio-page__earn-savings-portfolio__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-334 | 334 | SavingsHistoryPage | /earn/savings/history | output/flutter-ui-reference/screenshots/earn/334_earn_savings-history-page__earn-savings-history__viewport.png | output/flutter-ui-reference/screenshots/earn/334_earn_savings-history-page__earn-savings-history__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-335 | 335 | SavingsGuidePage | /earn/savings/guide | output/flutter-ui-reference/screenshots/earn/335_earn_savings-guide-page__earn-savings-guide__viewport.png | output/flutter-ui-reference/screenshots/earn/335_earn_savings-guide-page__earn-savings-guide__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-336 | 336 | SavingsFAQPage | /earn/savings/faq | output/flutter-ui-reference/screenshots/earn/336_earn_savings-faq-page__earn-savings-faq__viewport.png | output/flutter-ui-reference/screenshots/earn/336_earn_savings-faq-page__earn-savings-faq__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-337 | 337 | SavingsNotificationsPage | /earn/savings/notifications | output/flutter-ui-reference/screenshots/earn/337_earn_savings-notifications-page__earn-savings-notifications__viewport.png | output/flutter-ui-reference/screenshots/earn/337_earn_savings-notifications-page__earn-savings-notifications__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-338 | 338 | SavingsRecommendationsPage | /earn/savings/recommendations | output/flutter-ui-reference/screenshots/earn/338_earn_savings-recommendations-page__earn-savings-recommendations__viewport.png | output/flutter-ui-reference/screenshots/earn/338_earn_savings-recommendations-page__earn-savings-recommendations__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-339 | 339 | SavingsRiskAssessmentPage | /earn/savings/risk-assessment | output/flutter-ui-reference/screenshots/earn/339_earn_savings-risk-assessment-page__earn-savings-risk-assessment__viewport.png | output/flutter-ui-reference/screenshots/earn/339_earn_savings-risk-assessment-page__earn-savings-risk-assessment__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-340 | 340 | SavingsComparisonPage | /earn/savings/comparison | output/flutter-ui-reference/screenshots/earn/340_earn_savings-comparison-page__earn-savings-comparison__viewport.png | output/flutter-ui-reference/screenshots/earn/340_earn_savings-comparison-page__earn-savings-comparison__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-341 | 341 | AutoCompoundSettingsPage | /earn/savings/auto-compound | output/flutter-ui-reference/screenshots/earn/341_earn_auto-compound-settings-page__earn-savings-auto-compound__viewport.png | output/flutter-ui-reference/screenshots/earn/341_earn_auto-compound-settings-page__earn-savings-auto-compound__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-342 | 342 | SavingsGoalPage | /earn/savings/goals | output/flutter-ui-reference/screenshots/earn/342_earn_savings-goal-page__earn-savings-goals__viewport.png | output/flutter-ui-reference/screenshots/earn/342_earn_savings-goal-page__earn-savings-goals__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-343 | 343 | SavingsAnalyticsPage | /earn/savings/analytics | output/flutter-ui-reference/screenshots/earn/343_earn_savings-analytics-page__earn-savings-analytics__viewport.png | output/flutter-ui-reference/screenshots/earn/343_earn_savings-analytics-page__earn-savings-analytics__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-344 | 344 | SavingsAutoRebalancePage | /earn/savings/rebalance | output/flutter-ui-reference/screenshots/earn/344_earn_savings-auto-rebalance-page__earn-savings-rebalance__viewport.png | output/flutter-ui-reference/screenshots/earn/344_earn_savings-auto-rebalance-page__earn-savings-rebalance__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-345 | 345 | SavingsNotificationPreferencesPage | /earn/savings/notification-preferences | output/flutter-ui-reference/screenshots/earn/345_earn_savings-notification-preferences-page__earn-savings-notification-preferences__viewport.png | output/flutter-ui-reference/screenshots/earn/345_earn_savings-notification-preferences-page__earn-savings-notification-preferences__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-346 | 346 | SavingsDCAPage | /earn/savings/dca | output/flutter-ui-reference/screenshots/earn/346_earn_savings-dca-page__earn-savings-dca__viewport.png | output/flutter-ui-reference/screenshots/earn/346_earn_savings-dca-page__earn-savings-dca__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-347 | 347 | SavingsSmartSuggestionsPage | /earn/savings/smart-suggestions | output/flutter-ui-reference/screenshots/earn/347_earn_savings-smart-suggestions-page__earn-savings-smart-suggestions__viewport.png | output/flutter-ui-reference/screenshots/earn/347_earn_savings-smart-suggestions-page__earn-savings-smart-suggestions__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-348 | 348 | SavingsExportPage | /earn/savings/export | output/flutter-ui-reference/screenshots/earn/348_earn_savings-export-page__earn-savings-export__viewport.png | output/flutter-ui-reference/screenshots/earn/348_earn_savings-export-page__earn-savings-export__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-349 | 349 | SavingsBacktestPage | /earn/savings/backtest | output/flutter-ui-reference/screenshots/earn/349_earn_savings-backtest-page__earn-savings-backtest__viewport.png | output/flutter-ui-reference/screenshots/earn/349_earn_savings-backtest-page__earn-savings-backtest__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-350 | 350 | SavingsAutoPilotPage | /earn/savings/autopilot | output/flutter-ui-reference/screenshots/earn/350_earn_savings-auto-pilot-page__earn-savings-autopilot__viewport.png | output/flutter-ui-reference/screenshots/earn/350_earn_savings-auto-pilot-page__earn-savings-autopilot__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-351 | 351 | SavingsLadderPage | /earn/savings/ladder | output/flutter-ui-reference/screenshots/earn/351_earn_savings-ladder-page__earn-savings-ladder__viewport.png | output/flutter-ui-reference/screenshots/earn/351_earn_savings-ladder-page__earn-savings-ladder__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-352 | 352 | SavingsWhatIfPage | /earn/savings/whatif | output/flutter-ui-reference/screenshots/earn/352_earn_savings-what-if-page__earn-savings-whatif__viewport.png | output/flutter-ui-reference/screenshots/earn/352_earn_savings-what-if-page__earn-savings-whatif__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-353 | 353 | StakingTermsPage | /earn/staking/terms | output/flutter-ui-reference/screenshots/earn/353_earn_staking-terms-page__earn-staking-terms__viewport.png | output/flutter-ui-reference/screenshots/earn/353_earn_staking-terms-page__earn-staking-terms__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-354 | 354 | StakingRiskDisclosurePage | /earn/staking/risk-disclosure | output/flutter-ui-reference/screenshots/earn/354_earn_staking-risk-disclosure-page__earn-staking-risk-disclosure__viewport.png | output/flutter-ui-reference/screenshots/earn/354_earn_staking-risk-disclosure-page__earn-staking-risk-disclosure__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-355 | 355 | StakingWithdrawalPolicyPage | /earn/staking/withdrawal-policy | output/flutter-ui-reference/screenshots/earn/355_earn_staking-withdrawal-policy-page__earn-staking-withdrawal-policy__viewport.png | output/flutter-ui-reference/screenshots/earn/355_earn_staking-withdrawal-policy-page__earn-staking-withdrawal-policy__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-356 | 356 | StakingTaxGuidePage | /earn/staking/tax-guide | output/flutter-ui-reference/screenshots/earn/356_earn_staking-tax-guide-page__earn-staking-tax-guide__viewport.png | output/flutter-ui-reference/screenshots/earn/356_earn_staking-tax-guide-page__earn-staking-tax-guide__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-357 | 357 | StakingRiskAssessmentPage | /earn/staking/risk-assessment | output/flutter-ui-reference/screenshots/earn/357_earn_staking-risk-assessment-page__earn-staking-risk-assessment__viewport.png | output/flutter-ui-reference/screenshots/earn/357_earn_staking-risk-assessment-page__earn-staking-risk-assessment__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-358 | 358 | StakingDashboardPage | /earn/dashboard | output/flutter-ui-reference/screenshots/earn/358_earn_staking-dashboard-page__earn-dashboard__viewport.png | output/flutter-ui-reference/screenshots/earn/358_earn_staking-dashboard-page__earn-dashboard__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-359 | 359 | StakingAnalyticsPage | /earn/analytics | output/flutter-ui-reference/screenshots/earn/359_earn_staking-analytics-page__earn-analytics__viewport.png | output/flutter-ui-reference/screenshots/earn/359_earn_staking-analytics-page__earn-analytics__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-360 | 360 | StakingHistoryPage | /earn/history | output/flutter-ui-reference/screenshots/earn/360_earn_staking-history-page__earn-history__viewport.png | output/flutter-ui-reference/screenshots/earn/360_earn_staking-history-page__earn-history__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-361 | 361 | StakingEarningsCalendarPage | /earn/calendar | output/flutter-ui-reference/screenshots/earn/361_earn_staking-earnings-calendar-page__earn-calendar__viewport.png | output/flutter-ui-reference/screenshots/earn/361_earn_staking-earnings-calendar-page__earn-calendar__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-362 | 362 | StakingValidatorSelectionPage | /earn/validator-selection | output/flutter-ui-reference/screenshots/earn/362_earn_staking-validator-selection-page__earn-validator-selection__viewport.png | output/flutter-ui-reference/screenshots/earn/362_earn_staking-validator-selection-page__earn-validator-selection__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-363 | 363 | StakingAutoCompoundPage | /earn/auto-compound | output/flutter-ui-reference/screenshots/earn/363_earn_staking-auto-compound-page__earn-auto-compound__viewport.png | output/flutter-ui-reference/screenshots/earn/363_earn_staking-auto-compound-page__earn-auto-compound__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-364 | 364 | StakingLiquidStakingPage | /earn/liquid-staking | output/flutter-ui-reference/screenshots/earn/364_earn_staking-liquid-staking-page__earn-liquid-staking__viewport.png | output/flutter-ui-reference/screenshots/earn/364_earn_staking-liquid-staking-page__earn-liquid-staking__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-365 | 365 | StakingInsurancePage | /earn/insurance | output/flutter-ui-reference/screenshots/earn/365_earn_staking-insurance-page__earn-insurance__viewport.png | output/flutter-ui-reference/screenshots/earn/365_earn_staking-insurance-page__earn-insurance__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-366 | 366 | StakingAdvancedOrdersPage | /earn/advanced-orders | output/flutter-ui-reference/screenshots/earn/366_earn_staking-advanced-orders-page__earn-advanced-orders__viewport.png | output/flutter-ui-reference/screenshots/earn/366_earn_staking-advanced-orders-page__earn-advanced-orders__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-367 | 367 | StakingMultiChainPage | /earn/multi-chain | output/flutter-ui-reference/screenshots/earn/367_earn_staking-multi-chain-page__earn-multi-chain__viewport.png | output/flutter-ui-reference/screenshots/earn/367_earn_staking-multi-chain-page__earn-multi-chain__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-368 | 368 | StakingInstitutionalPage | /earn/institutional | output/flutter-ui-reference/screenshots/earn/368_earn_staking-institutional-page__earn-institutional__viewport.png | output/flutter-ui-reference/screenshots/earn/368_earn_staking-institutional-page__earn-institutional__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-369 | 369 | StakingGuidePage | /earn/guide | output/flutter-ui-reference/screenshots/earn/369_earn_staking-guide-page__earn-guide__viewport.png | output/flutter-ui-reference/screenshots/earn/369_earn_staking-guide-page__earn-guide__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-370 | 370 | StakingFAQPage | /earn/faq | output/flutter-ui-reference/screenshots/earn/370_earn_staking-faq-page__earn-faq__viewport.png | output/flutter-ui-reference/screenshots/earn/370_earn_staking-faq-page__earn-faq__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-371 | 371 | StakingNotificationsPage | /earn/notifications | output/flutter-ui-reference/screenshots/earn/371_earn_staking-notifications-page__earn-notifications__viewport.png | output/flutter-ui-reference/screenshots/earn/371_earn_staking-notifications-page__earn-notifications__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-372 | 372 | StakingRecommendationsPage | /earn/recommendations | output/flutter-ui-reference/screenshots/earn/372_earn_staking-recommendations-page__earn-recommendations__viewport.png | output/flutter-ui-reference/screenshots/earn/372_earn_staking-recommendations-page__earn-recommendations__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-373 | 373 | StakingRegulatoryFrameworkPage | /earn/regulatory-framework | output/flutter-ui-reference/screenshots/earn/373_earn_staking-regulatory-framework-page__earn-regulatory-framework__viewport.png | output/flutter-ui-reference/screenshots/earn/373_earn_staking-regulatory-framework-page__earn-regulatory-framework__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-374 | 374 | StakingAuditReportsPage | /earn/audit-reports | output/flutter-ui-reference/screenshots/earn/374_earn_staking-audit-reports-page__earn-audit-reports__viewport.png | output/flutter-ui-reference/screenshots/earn/374_earn_staking-audit-reports-page__earn-audit-reports__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-375 | 375 | StakingCustodyPage | /earn/custody | output/flutter-ui-reference/screenshots/earn/375_earn_staking-custody-page__earn-custody__viewport.png | output/flutter-ui-reference/screenshots/earn/375_earn_staking-custody-page__earn-custody__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-376 | 376 | StakingSuitabilityAssessmentPage | /earn/suitability-assessment | output/flutter-ui-reference/screenshots/earn/376_earn_staking-suitability-assessment-page__earn-suitability-assessment__viewport.png | output/flutter-ui-reference/screenshots/earn/376_earn_staking-suitability-assessment-page__earn-suitability-assessment__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-377 | 377 | StakingInsuranceFundTransparencyPage | /earn/insurance-fund-transparency | output/flutter-ui-reference/screenshots/earn/377_earn_staking-insurance-fund-transparency-page__earn-insurance-fund-transparency__viewport.png | output/flutter-ui-reference/screenshots/earn/377_earn_staking-insurance-fund-transparency-page__earn-insurance-fund-transparency__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-378 | 378 | StakingTransactionReportingPage | /earn/transaction-reporting | output/flutter-ui-reference/screenshots/earn/378_earn_staking-transaction-reporting-page__earn-transaction-reporting__viewport.png | output/flutter-ui-reference/screenshots/earn/378_earn_staking-transaction-reporting-page__earn-transaction-reporting__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-379 | 379 | StakingAPIDocumentationPage | /earn/api-documentation | output/flutter-ui-reference/screenshots/earn/379_earn_staking-api-documentation-page__earn-api-documentation__viewport.png | output/flutter-ui-reference/screenshots/earn/379_earn_staking-api-documentation-page__earn-api-documentation__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-380 | 380 | StakingProofOfReservesPage | /earn/proof-of-reserves | output/flutter-ui-reference/screenshots/earn/380_earn_staking-proof-of-reserves-page__earn-proof-of-reserves__viewport.png | output/flutter-ui-reference/screenshots/earn/380_earn_staking-proof-of-reserves-page__earn-proof-of-reserves__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-381 | 381 | StakingRiskDashboardPage | /earn/risk-dashboard | output/flutter-ui-reference/screenshots/earn/381_earn_staking-risk-dashboard-page__earn-risk-dashboard__viewport.png | output/flutter-ui-reference/screenshots/earn/381_earn_staking-risk-dashboard-page__earn-risk-dashboard__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-382 | 382 | StakingSlashingHistoryPage | /earn/slashing-history | output/flutter-ui-reference/screenshots/earn/382_earn_staking-slashing-history-page__earn-slashing-history__viewport.png | output/flutter-ui-reference/screenshots/earn/382_earn_staking-slashing-history-page__earn-slashing-history__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-383 | 383 | StakingValidatorHealthMonitorPage | /earn/validator-health-monitor | output/flutter-ui-reference/screenshots/earn/383_earn_staking-validator-health-monitor-page__earn-validator-health-monitor__viewport.png | output/flutter-ui-reference/screenshots/earn/383_earn_staking-validator-health-monitor-page__earn-validator-health-monitor__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-384 | 384 | StakingRiskScoreCalculatorPage | /earn/risk-score-calculator | output/flutter-ui-reference/screenshots/earn/384_earn_staking-risk-score-calculator-page__earn-risk-score-calculator__viewport.png | output/flutter-ui-reference/screenshots/earn/384_earn_staking-risk-score-calculator-page__earn-risk-score-calculator__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-385 | 385 | StakingEmergencyActionsPage | /earn/emergency-actions | output/flutter-ui-reference/screenshots/earn/385_earn_staking-emergency-actions-page__earn-emergency-actions__viewport.png | output/flutter-ui-reference/screenshots/earn/385_earn_staking-emergency-actions-page__earn-emergency-actions__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-386 | 386 | StakingContingencyPlanPage | /earn/contingency-plan | output/flutter-ui-reference/screenshots/earn/386_earn_staking-contingency-plan-page__earn-contingency-plan__viewport.png | output/flutter-ui-reference/screenshots/earn/386_earn_staking-contingency-plan-page__earn-contingency-plan__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-387 | 387 | StakingSocialFeedPage | /earn/social-feed | output/flutter-ui-reference/screenshots/earn/387_earn_staking-social-feed-page__earn-social-feed__viewport.png | output/flutter-ui-reference/screenshots/earn/387_earn_staking-social-feed-page__earn-social-feed__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-388 | 388 | StakingCommunityGovernancePage | /earn/community-governance | output/flutter-ui-reference/screenshots/earn/388_earn_staking-community-governance-page__earn-community-governance__viewport.png | output/flutter-ui-reference/screenshots/earn/388_earn_staking-community-governance-page__earn-community-governance__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-389 | 389 | StakingProposalsPage | /earn/proposals | output/flutter-ui-reference/screenshots/earn/389_earn_staking-proposals-page__earn-proposals__viewport.png | output/flutter-ui-reference/screenshots/earn/389_earn_staking-proposals-page__earn-proposals__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-390 | 390 | StakingVotingPage | /earn/voting/prop001 | output/flutter-ui-reference/screenshots/earn/390_earn_staking-voting-page__earn-voting-prop001__viewport.png | output/flutter-ui-reference/screenshots/earn/390_earn_staking-voting-page__earn-voting-prop001__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-391 | 391 | StakingVotingPage | /earn/voting | output/flutter-ui-reference/screenshots/earn/391_earn_staking-voting-page__earn-voting__viewport.png | output/flutter-ui-reference/screenshots/earn/391_earn_staking-voting-page__earn-voting__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-392 | 392 | StakingForumPage | /earn/forum | output/flutter-ui-reference/screenshots/earn/392_earn_staking-forum-page__earn-forum__viewport.png | output/flutter-ui-reference/screenshots/earn/392_earn_staking-forum-page__earn-forum__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-393 | 393 | StakingWebhooksPage | /earn/webhooks | output/flutter-ui-reference/screenshots/earn/393_earn_staking-webhooks-page__earn-webhooks__viewport.png | output/flutter-ui-reference/screenshots/earn/393_earn_staking-webhooks-page__earn-webhooks__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-394 | 394 | StakingDataExportPage | /earn/data-export | output/flutter-ui-reference/screenshots/earn/394_earn_staking-data-export-page__earn-data-export__viewport.png | output/flutter-ui-reference/screenshots/earn/394_earn_staking-data-export-page__earn-data-export__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-395 | 395 | StakingThirdPartyIntegrationsPage | /earn/third-party-integrations | output/flutter-ui-reference/screenshots/earn/395_earn_staking-third-party-integrations-page__earn-third-party-integrations__viewport.png | output/flutter-ui-reference/screenshots/earn/395_earn_staking-third-party-integrations-page__earn-third-party-integrations__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |
| SC-396 | 396 | StakingDeveloperConsolePage | /earn/developer-console | output/flutter-ui-reference/screenshots/earn/396_earn_staking-developer-console-page__earn-developer-console__viewport.png | output/flutter-ui-reference/screenshots/earn/396_earn_staking-developer-console-page__earn-developer-console__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

### onboarding (1)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-397 | 397 | OnboardingFlow | /onboarding | output/flutter-ui-reference/screenshots/onboarding/397_onboarding_onboarding-flow__onboarding__viewport.png | output/flutter-ui-reference/screenshots/onboarding/397_onboarding_onboarding-flow__onboarding__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

### demo (1)

| ID | Order | Screen | Route | Viewport | Fullpage | Flutter status | BE status | QA status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SC-401 | 401 | CopyTradingCardDemo | /demo/copy-card | output/flutter-ui-reference/screenshots/demo/401_demo_copy-trading-card-demo__demo-copy-card__viewport.png | output/flutter-ui-reference/screenshots/demo/401_demo_copy-trading-card-demo__demo-copy-card__fullpage.png | [ ] not started | [ ] contract draft | [ ] not checked |

## Source File Index

Use this index during each screen task before implementing Flutter widgets. `NEEDS_MANUAL_CONFIRM` means the route uses an override or dynamic import that must be checked manually from the route source.

| ID | Screen | Route | React source file |
| --- | --- | --- | --- |
| SC-001 | LoginPage | /auth/login | src/app/pages/auth/LoginPage.tsx |
| SC-002 | RegisterPage | /auth/register | src/app/pages/auth/RegisterPage.tsx |
| SC-003 | OTPPage | /auth/otp | src/app/pages/auth/OTPPage.tsx |
| SC-004 | TwoFASetupPage | /auth/2fa-setup | src/app/pages/auth/TwoFASetupPage.tsx |
| SC-005 | ForgotPasswordPage | /auth/forgot-password | src/app/pages/auth/ForgotPasswordPage.tsx |
| SC-006 | ResetPasswordPage | /auth/reset-password | src/app/pages/auth/ResetPasswordPage.tsx |
| SC-007 | HomePage | /home | src/app/pages/market/HomePage.tsx |
| SC-008 | MarketListPage | /markets | src/app/pages/market/MarketListPage.tsx |
| SC-009 | MarketOverviewPage | /markets/overview | src/app/pages/markets/MarketOverviewPage.tsx |
| SC-010 | MarketMoversPage | /markets/movers | src/app/pages/markets/MarketMoversPage.tsx |
| SC-011 | MarketSectorsPage | /markets/sectors | src/app/pages/markets/MarketSectorsPage.tsx |
| SC-012 | WatchlistPage | /markets/watchlist | src/app/pages/markets/WatchlistPage.tsx |
| SC-013 | MarketHeatmapPage | /markets/heatmap | src/app/pages/market/MarketHeatmapPage.tsx |
| SC-014 | PriceAlertsPage | /markets/alerts | src/app/pages/markets/PriceAlertsPage.tsx |
| SC-015 | MarketScreenerPage | /markets/screener | src/app/pages/markets/MarketScreenerPage.tsx |
| SC-016 | ComparisonToolPage | /markets/compare | src/app/pages/markets/ComparisonToolPage.tsx |
| SC-017 | MarketCalendarPage | /markets/calendar | src/app/pages/markets/MarketCalendarPage.tsx |
| SC-018 | DerivativesOverviewPage | /markets/derivatives | src/app/pages/markets/DerivativesOverviewPage.tsx |
| SC-019 | MarketDepthPage | /markets/depth | src/app/pages/markets/MarketDepthPage.tsx |
| SC-020 | SocialSentimentPage | /markets/social-sentiment | src/app/pages/markets/SocialSentimentPage.tsx |
| SC-021 | PortfolioTrackerPage | /markets/portfolio-tracker | src/app/pages/markets/PortfolioTrackerPage.tsx |
| SC-022 | MarketNewsPage | /markets/news | src/app/pages/markets/MarketNewsPage.tsx |
| SC-023 | AdvancedChartsPage | /markets/advanced-charts | src/app/pages/markets/AdvancedChartsPage.tsx |
| SC-024 | TokenUnlocksPage | /markets/unlocks | src/app/pages/markets/TokenUnlocksPage.tsx |
| SC-025 | SocialSignalsPage | /markets/signals | src/app/pages/markets/SocialSignalsPage.tsx |
| SC-026 | MarketCorrelationsPage | /markets/correlations | src/app/pages/markets/MarketCorrelationsPage.tsx |
| SC-027 | PredictionsHomePage | /markets/predictions | src/app/pages/predictions/PredictionsHomePage.tsx |
| SC-028 | PredictionsSearchPage | /markets/predictions/search | src/app/pages/predictions/PredictionsSearchPage.tsx |
| SC-029 | PredictionsBreakingPage | /markets/predictions/breaking | src/app/pages/predictions/PredictionsBreakingPage.tsx |
| SC-030 | PredictionEventDetailPage | /markets/predictions/event/pred-1 | src/app/pages/predictions/PredictionEventDetailPage.tsx |
| SC-031 | PredictionsPortfolioPage | /markets/predictions/portfolio | src/app/pages/predictions/PredictionsPortfolioPage.tsx |
| SC-032 | PredictionsRewardsPage | /markets/predictions/rewards | src/app/pages/predictions/PredictionsRewardsPage.tsx |
| SC-033 | PredictionsLeaderboardPage | /markets/predictions/leaderboard | src/app/pages/predictions/PredictionsLeaderboardPage.tsx |
| SC-034 | PredictionsGlobalActivityPage | /markets/predictions/activity | src/app/pages/predictions/PredictionsGlobalActivityPage.tsx |
| SC-035 | PredictionOrderReceiptPage | /markets/predictions/receipt/p2p001 | src/app/pages/predictions/PredictionOrderReceiptPage.tsx |
| SC-036 | PredictionRiskCalculatorPage | /markets/predictions/risk-calculator | src/app/pages/predictions/PredictionRiskCalculatorPage.tsx |
| SC-037 | PredictionMarketMakerPage | /markets/predictions/market-maker | src/app/pages/predictions/PredictionMarketMakerPage.tsx |
| SC-038 | PredictionPortfolioAnalyzerPage | /markets/predictions/portfolio-analyzer | src/app/pages/predictions/PredictionPortfolioAnalyzerPage.tsx |
| SC-039 | PredictionEventCalendarPage | /markets/predictions/event-calendar | src/app/pages/predictions/PredictionEventCalendarPage.tsx |
| SC-040 | PredictionSocialPage | /markets/predictions/social | src/app/pages/predictions/PredictionSocialPage.tsx |
| SC-041 | PredictionAdvancedChartPage | /markets/predictions/advanced-chart/btcusdt | src/app/pages/predictions/PredictionAdvancedChartPage.tsx |
| SC-042 | PredictionTournamentsPage | /markets/predictions/tournaments | src/app/pages/predictions/PredictionTournamentsPage.tsx |
| SC-043 | PredictionDataIntegrationPage | /markets/predictions/data-integration | src/app/pages/predictions/PredictionDataIntegrationPage.tsx |
| SC-044 | PairDetailPage | /pair/btcusdt | src/app/pages/market/PairDetailPage.tsx |
| SC-045 | TokenInfoPage | /pair/btcusdt/info | src/app/pages/markets/TokenInfoPage.tsx |
| SC-046 | MarketDepthPage | /pair/btcusdt/depth | src/app/pages/markets/MarketDepthPage.tsx |
| SC-047 | NewsPage | /news | src/app/pages/news/NewsPage.tsx |
| SC-048 | TradePage | /trade | src/app/pages/trade/TradePage.tsx |
| SC-049 | TradePage | /trade/btcusdt | src/app/pages/trade/TradePage.tsx |
| SC-050 | OrdersHistoryPage | /trade/orders-history | src/app/pages/trade/OrdersHistoryPage.tsx |
| SC-051 | OrderReceiptPage | /trade/order-receipt | src/app/pages/trade/OrderReceiptPage.tsx |
| SC-052 | TradeSettingsPage | /trade/settings | src/app/pages/trade/TradeSettingsPage.tsx |
| SC-053 | PositionDashboardPage | /trade/positions | src/app/pages/trade/PositionDashboardPage.tsx |
| SC-054 | TradeHistoryExportPage | /trade/export | src/app/pages/trade/TradeHistoryExportPage.tsx |
| SC-055 | AdvancedChartPage | /trade/advanced-chart/btcusdt | src/app/pages/trade/AdvancedChartPage.tsx |
| SC-056 | ConvertPage | /trade/convert | src/app/pages/trade/ConvertPage.tsx |
| SC-057 | FuturesPage | /trade/btcusdt/futures | src/app/pages/trade/FuturesPage.tsx |
| SC-058 | LeveragePage | /trade/btcusdt/futures/leverage | src/app/pages/trade/LeveragePage.tsx |
| SC-059 | TradingBotsPage | /trade/bots | src/app/pages/trade/TradingBotsPage.tsx |
| SC-060 | RiskManagementDemoPage | /trade/risk-management | src/app/pages/trade/RiskManagementDemoPage.tsx |
| SC-061 | ExecutionQualityDemoPage | /trade/execution-quality | src/app/pages/trade/ExecutionQualityDemoPage.tsx |
| SC-062 | AdvancedToolsDemoPage | /trade/advanced-tools | src/app/pages/trade/AdvancedToolsDemoPage.tsx |
| SC-063 | CopyTradingPage | /trade/copy-trading | src/app/pages/trade/CopyTradingPage.tsx |
| SC-064 | CopyTradingPageV2 | /trade/copy-trading/v2 | src/app/pages/trade/CopyTradingPageV2.tsx |
| SC-065 | CopyEducationPage | /trade/copy-trading/education | src/app/pages/trade/CopyEducationPage.tsx |
| SC-066 | ActiveCopiesPage | /trade/copy-trading/active | src/app/pages/trade/ActiveCopiesPage.tsx |
| SC-067 | CopySettingsPage | /trade/copy-trading/settings | src/app/pages/trade/CopySettingsPage.tsx |
| SC-068 | CopyNotificationsPage | /trade/copy-trading/notifications | src/app/pages/trade/CopyNotificationsPage.tsx |
| SC-069 | ProviderApplicationPage | /trade/copy-provider-apply | src/app/pages/trade/ProviderApplicationPage.tsx |
| SC-070 | CopyProviderDetailPage | /trade/copy-provider/provider001 | src/app/pages/trade/CopyProviderDetailPage.tsx |
| SC-071 | PreCopyAssessmentPage | /trade/copy-provider/provider001/assessment | src/app/pages/trade/PreCopyAssessmentPage.tsx |
| SC-072 | CopyConfigurationPage | /trade/copy-provider/provider001/configuration | src/app/pages/trade/CopyConfigurationPage.tsx |
| SC-073 | CopyConfirmationPage | /trade/copy-provider/provider001/confirmation | src/app/pages/trade/CopyConfirmationPage.tsx |
| SC-074 | CopyPerformancePage | /trade/copy-performance/copy001 | src/app/pages/trade/CopyPerformancePage.tsx |
| SC-075 | PerformanceAttributionPage | /trade/copy-performance/copy001/attribution | src/app/pages/trade/PerformanceAttributionPage.tsx |
| SC-076 | ProviderComparisonPage | /trade/copy-trading/comparison | src/app/pages/trade/ProviderComparisonPage.tsx |
| SC-077 | CopyAuditLogPage | /trade/copy-audit-log/copy001 | src/app/pages/trade/CopyAuditLogPage.tsx |
| SC-078 | PortfolioRiskAnalysisPage | /trade/copy-trading/risk-analysis | src/app/pages/trade/PortfolioRiskAnalysisPage.tsx |
| SC-079 | ProviderLeaderboardPage | /trade/copy-trading/leaderboard | src/app/pages/trade/ProviderLeaderboardPage.tsx |
| SC-080 | SafetyEducationPage | /trade/copy-trading/safety | src/app/pages/trade/SafetyEducationPage.tsx |
| SC-081 | ProviderGovernancePage | /trade/copy-provider-governance | src/app/pages/trade/ProviderGovernancePage.tsx |
| SC-082 | DisputeResolutionPage | /trade/copy-dispute-resolution | src/app/pages/trade/DisputeResolutionPage.tsx |
| SC-083 | CopySafetyCenterPage | /trade/copy-safety-center | src/app/pages/trade/CopySafetyCenterPage.tsx |
| SC-084 | RegulatoryDisclosuresPage | /trade/copy-regulatory-disclosures | src/app/pages/trade/RegulatoryDisclosuresPage.tsx |
| SC-085 | MarginTradingPage | /trade/margin | src/app/pages/trade/MarginTradingPage.tsx |
| SC-086 | MarginTradingPage | /trade/margin/btcusdt | src/app/pages/trade/MarginTradingPage.tsx |
| SC-087 | TraderProfilePage | /trade/trader/trader001 | src/app/pages/trade/TraderProfilePage.tsx |
| SC-088 | AdvancedTradingDemoPage | /trade/margin/advanced-demo | src/app/pages/trade/AdvancedTradingDemoPage.tsx |
| SC-089 | MarketDataAnalyticsPage | /trade/margin/market-data-analytics | src/app/pages/trade/MarketDataAnalyticsPage.tsx |
| SC-090 | MarginTradingHubPage | /trade/margin/hub | src/app/pages/trade/MarginTradingHubPage.tsx |
| SC-091 | LiveMarketDataAnalyticsPage | /trade/margin/live-market-data-analytics | src/app/pages/trade/LiveMarketDataAnalyticsPage.tsx |
| SC-092 | AdvancedAnalyticsPage | /trade/margin/advanced-analytics | src/app/pages/trade/AdvancedAnalyticsPage.tsx |
| SC-093 | TransactionReportingPage | /trade/copy-trading/transaction-reporting | src/app/pages/trade/TransactionReportingPage.tsx |
| SC-094 | RegulatoryReportsDashboardPage | /trade/copy-trading/regulatory-reports-dashboard | src/app/pages/trade/RegulatoryReportsDashboardPage.tsx |
| SC-095 | ARMIntegrationStatusPage | /trade/copy-trading/arm-integration-status | src/app/pages/trade/ARMIntegrationStatusPage.tsx |
| SC-096 | BestExecutionReportsPage | /trade/copy-trading/best-execution-reports | src/app/pages/trade/BestExecutionReportsPage.tsx |
| SC-097 | ExecutionVenueAnalysisPage | /trade/copy-trading/execution-venue-analysis | src/app/pages/trade/ExecutionVenueAnalysisPage.tsx |
| SC-098 | SlippageMonitoringPage | /trade/copy-trading/slippage-monitoring | src/app/pages/trade/SlippageMonitoringPage.tsx |
| SC-099 | ClientCategorizationPage | /trade/copy-trading/client-categorization | src/app/pages/trade/ClientCategorizationPage.tsx |
| SC-100 | ProductGovernancePage | /trade/copy-trading/product-governance | src/app/pages/trade/ProductGovernancePage.tsx |
| SC-101 | TargetMarketDefinitionPage | /trade/copy-trading/target-market-definition | src/app/pages/trade/TargetMarketDefinitionPage.tsx |
| SC-102 | ClientMoneyProtectionPage | /trade/copy-trading/client-money-protection | src/app/pages/trade/ClientMoneyProtectionPage.tsx |
| SC-103 | CASSReconciliationPage | /trade/copy-trading/cass-reconciliation | src/app/pages/trade/CASSReconciliationPage.tsx |
| SC-104 | InvestorCompensationPage | /trade/copy-trading/investor-compensation | src/app/pages/trade/InvestorCompensationPage.tsx |
| SC-105 | ExAnteCostsPage | /trade/copy-trading/ex-ante-costs | src/app/pages/trade/ExAnteCostsPage.tsx |
| SC-106 | RIYCalculatorPage | /trade/copy-trading/riy-calculator | src/app/pages/trade/RIYCalculatorPage.tsx |
| SC-107 | ExPostCostsReportPage | /trade/copy-trading/ex-post-costs-report | src/app/pages/trade/ExPostCostsReportPage.tsx |
| SC-108 | KIDGeneratorPage | /trade/copy-trading/kid-generator | src/app/pages/trade/KIDGeneratorPage.tsx |
| SC-109 | PerformanceScenariosPage | /trade/copy-trading/performance-scenarios | src/app/pages/trade/PerformanceScenariosPage.tsx |
| SC-110 | RiskIndicatorExplainerPage | /trade/copy-trading/risk-indicator-explainer | src/app/pages/trade/RiskIndicatorExplainerPage.tsx |
| SC-111 | ComplaintsHandlingPage | /trade/copy-trading/complaints-handling | src/app/pages/trade/ComplaintsHandlingPage.tsx |
| SC-112 | ComplaintSubmissionPage | /trade/copy-trading/complaint-submission | src/app/pages/trade/ComplaintSubmissionPage.tsx |
| SC-113 | ComplaintTrackingPage | /trade/copy-trading/complaint-tracking | src/app/pages/trade/ComplaintTrackingPage.tsx |
| SC-114 | OmbudsmanReferralPage | /trade/copy-trading/ombudsman-referral | src/app/pages/trade/OmbudsmanReferralPage.tsx |
| SC-115 | AuditTrailPage | /trade/copy-trading/audit-trail | src/app/pages/trade/AuditTrailPage.tsx |
| SC-116 | RegulatoryInspectionReadyPage | /trade/copy-trading/regulatory-inspection-ready | src/app/pages/trade/RegulatoryInspectionReadyPage.tsx |
| SC-117 | BotTermsOfServicePage | /trade/bots/terms-of-service | src/app/pages/trade/bots/BotTermsOfServicePage.tsx |
| SC-118 | BotRiskDisclosurePage | /trade/bots/risk-disclosure | src/app/pages/trade/bots/BotRiskDisclosurePage.tsx |
| SC-119 | BotSuitabilityAssessmentPage | /trade/bots/suitability-assessment | src/app/pages/trade/bots/BotSuitabilityAssessmentPage.tsx |
| SC-120 | BotRiskDashboardPage | /trade/bots/risk-dashboard | src/app/pages/trade/bots/BotRiskDashboardPage.tsx |
| SC-121 | BotEmergencyStopPage | /trade/bots/emergency-stop | src/app/pages/trade/bots/BotEmergencyStopPage.tsx |
| SC-122 | BotSecuritySettingsPage | /trade/bots/security-settings | src/app/pages/trade/bots/BotSecuritySettingsPage.tsx |
| SC-123 | BotHistoryPage | /trade/bots/history | src/app/pages/trade/bots/BotHistoryPage.tsx |
| SC-124 | BotPerformanceAnalyticsPage | /trade/bots/performance-analytics | src/app/pages/trade/bots/BotPerformanceAnalyticsPage.tsx |
| SC-125 | BotBacktestingPage | /trade/bots/backtesting | src/app/pages/trade/bots/BotBacktestingPage.tsx |
| SC-126 | BotStrategyComparePage | /trade/bots/strategy-compare | src/app/pages/trade/bots/BotStrategyComparePage.tsx |
| SC-127 | BotOptimizationPage | /trade/bots/optimization | src/app/pages/trade/bots/BotOptimizationPage.tsx |
| SC-128 | BotPortfolioDashboardPage | /trade/bots/portfolio-dashboard | src/app/pages/trade/bots/BotPortfolioDashboardPage.tsx |
| SC-129 | BotDrawdownAnalyzerPage | /trade/bots/drawdown-analyzer | src/app/pages/trade/bots/BotDrawdownAnalyzerPage.tsx |
| SC-130 | BotEquityCurvePage | /trade/bots/equity-curve | src/app/pages/trade/bots/BotEquityCurvePage.tsx |
| SC-131 | BotGuidePage | /trade/bots/guide | src/app/pages/trade/bots/BotGuidePage.tsx |
| SC-132 | BotFAQPage | /trade/bots/faq | src/app/pages/trade/bots/BotFAQPage.tsx |
| SC-133 | BotTaxReportingPage | /trade/bots/tax-reporting | src/app/pages/trade/bots/BotTaxReportingPage.tsx |
| SC-134 | BotAPIDocumentationPage | /trade/bots/api-documentation | src/app/pages/trade/bots/BotAPIDocumentationPage.tsx |
| SC-135 | WalletPage | /wallet | src/app/pages/wallet/WalletPage.tsx |
| SC-136 | TxHistoryPage | /wallet/history | src/app/pages/wallet/TransactionHistoryPage.tsx |
| SC-137 | DepositPage | /wallet/deposit | src/app/pages/wallet/DepositPage.tsx |
| SC-138 | DepositPage | /wallet/deposit/USDT | src/app/pages/wallet/DepositPage.tsx |
| SC-139 | WithdrawPage | /wallet/withdraw | src/app/pages/wallet/WithdrawPage.tsx |
| SC-140 | WithdrawPage | /wallet/withdraw/USDT | src/app/pages/wallet/WithdrawPage.tsx |
| SC-141 | TransactionDetailPage | /wallet/transaction/tx001 | src/app/pages/wallet/TransactionDetailPage.tsx |
| SC-142 | PortfolioAnalyticsPage | /wallet/portfolio-analytics | src/app/pages/wallet/PortfolioAnalyticsPage.tsx |
| SC-143 | AddressAddPage | /wallet/address-book/add | src/app/pages/wallet/AddressAddPage.tsx |
| SC-144 | AddressBookPage | /wallet/address-book | src/app/pages/wallet/AddressBookPage.tsx |
| SC-145 | BuyCryptoPage | /wallet/buy-crypto | src/app/pages/wallet/BuyCryptoPage.tsx |
| SC-146 | TransferPage | /wallet/transfer | src/app/pages/wallet/TransferPage.tsx |
| SC-147 | AssetDetailPage | /wallet/asset/btc | src/app/pages/wallet/AssetDetailPage.tsx |
| SC-148 | WalletMultiManagerPage | /wallet/multi-manager | src/app/pages/wallet/WalletMultiManagerPage.tsx |
| SC-149 | WalletGasOptimizerPage | /wallet/gas-optimizer | src/app/pages/wallet/WalletGasOptimizerPage.tsx |
| SC-150 | WalletTokenApprovalPage | /wallet/token-approval | src/app/pages/wallet/WalletTokenApprovalPage.tsx |
| SC-151 | WalletHealthScorePage | /wallet/health-score | src/app/pages/wallet/WalletHealthScorePage.tsx |
| SC-152 | PendingDepositsPage | /wallet/pending-deposits | src/app/pages/wallet/PendingDepositsPage.tsx |
| SC-153 | WithdrawLimitsPage | /wallet/limits | src/app/pages/wallet/WithdrawLimitsPage.tsx |
| SC-154 | DustConverterPage | /wallet/dust-converter | src/app/pages/wallet/DustConverterPage.tsx |
| SC-155 | NetworkStatusPage | /wallet/network-status | src/app/pages/wallet/NetworkStatusPage.tsx |
| SC-156 | ProfilePage | /profile | src/app/pages/profile/ProfilePage.tsx |
| SC-157 | EditProfilePage | /profile/edit | src/app/pages/profile/EditProfilePage.tsx |
| SC-158 | SecurityPage | /profile/security | src/app/pages/profile/SecurityPage.tsx |
| SC-159 | KYCPage | /profile/kyc | src/app/pages/profile/KYCPage.tsx |
| SC-160 | SettingsPage | /profile/settings | src/app/pages/profile/SettingsPage.tsx |
| SC-161 | ActivityLogPage | /profile/activity | src/app/pages/profile/ActivityLogPage.tsx |
| SC-162 | ApiKeyCreatePage | /profile/api/create | src/app/pages/profile/ApiKeyCreatePage.tsx |
| SC-163 | ApiManagementPage | /profile/api | src/app/pages/profile/ApiManagementPage.tsx |
| SC-164 | VIPPage | /profile/vip | src/app/pages/profile/VIPPage.tsx |
| SC-165 | DeviceManagementPage | /profile/devices | src/app/pages/profile/DeviceManagementPage.tsx |
| SC-166 | SubAccountPage | /profile/sub-accounts | src/app/pages/profile/SubAccountPage.tsx |
| SC-167 | PredictionsPortfolioPage | /profile/predictions | src/app/pages/predictions/PredictionsPortfolioPage.tsx |
| SC-168 | MyArenaPage | /profile/arena | src/app/pages/arena/MyArenaPage.tsx |
| SC-169 | DCAPage | /dca | src/app/pages/dca/DCAPage.tsx |
| SC-170 | DCARebalanceConfig | /dca/rebalance/config | src/app/pages/dca/DCARebalanceConfig.tsx |
| SC-171 | DCARebalanceDashboard | /dca/rebalance/config001 | src/app/pages/dca/DCARebalanceDashboard.tsx |
| SC-172 | DCAScheduleConfig | /dca/schedule/config | src/app/pages/dca/DCAScheduleConfig.tsx |
| SC-173 | DCAScheduleAnalytics | /dca/schedule/config001 | src/app/pages/dca/DCAScheduleAnalytics.tsx |
| SC-174 | DCAPortfolioOptimizer | /dca/portfolio-optimizer | src/app/pages/dca/DCAPortfolioOptimizer.tsx |
| SC-175 | DCADynamicAmount | /dca/dynamic-amount | src/app/pages/dca/DCADynamicAmount.tsx |
| SC-176 | DCABacktesterPage | /dca/backtester | src/app/pages/dca/DCABacktesterPage.tsx |
| SC-177 | DCAMultiAssetPage | /dca/multi-asset | src/app/pages/dca/DCAMultiAssetPage.tsx |
| SC-178 | DCAPerformanceComparePage | /dca/performance-compare | src/app/pages/dca/DCAPerformanceComparePage.tsx |
| SC-179 | DCASmartRulesPage | /dca/smart-rules | src/app/pages/dca/DCASmartRulesPage.tsx |
| SC-180 | AdminHome | /admin | src/app/pages/admin/AdminHome.tsx |
| SC-181 | AnalyticsDashboard | /admin/analytics | src/app/pages/admin/AnalyticsDashboard.tsx |
| SC-182 | ABTestDashboard | /admin/abtests | src/app/pages/admin/ABTestDashboard.tsx |
| SC-183 | FunnelDashboard | /admin/funnels | src/app/pages/admin/FunnelDashboard.tsx |
| SC-184 | ArenaHomePage | /arena | src/app/pages/arena/ArenaHomePage.tsx |
| SC-185 | ArenaStudioPage | /arena/studio | src/app/pages/arena/ArenaStudioPage.tsx |
| SC-186 | ArenaSmartRuleBuilderPage | /arena/studio/smart-rules | src/app/pages/arena/ArenaSmartRuleBuilderPage.tsx |
| SC-187 | ArenaUniversalPresetLibraryPage | /arena/studio/presets | src/app/pages/arena/ArenaUniversalPresetLibraryPage.tsx |
| SC-188 | ArenaGovernanceGatePage | /arena/studio/governance | src/app/pages/arena/ArenaGovernanceGatePage.tsx |
| SC-189 | ArenaModeDetailPage | /arena/mode/mode001 | src/app/pages/arena/ArenaModeDetailPage.tsx |
| SC-190 | ArenaChallengeDetailPage | /arena/challenge/ch003 | src/app/pages/arena/ArenaChallengeDetailPage.tsx |
| SC-191 | ArenaJoinPage | /arena/join/ch003 | src/app/pages/arena/ArenaJoinPage.tsx |
| SC-192 | ArenaResolutionCenterPage | /arena/resolution | src/app/pages/arena/ArenaResolutionCenterPage.tsx |
| SC-193 | ArenaCreatorPage | /arena/creator/cr001 | src/app/pages/arena/ArenaCreatorPage.tsx |
| SC-194 | ArenaLeaderboardPage | /arena/leaderboard | src/app/pages/arena/ArenaLeaderboardPage.tsx |
| SC-195 | VerifiedChallengesPage | /arena/verified | src/app/pages/arena/VerifiedChallengesPage.tsx |
| SC-196 | ArenaPointsPage | /arena/points | src/app/pages/arena/ArenaPointsPage.tsx |
| SC-197 | ArenaFlowMapPage | /arena/flow-map | src/app/pages/arena/ArenaFlowMapPage.tsx |
| SC-198 | ArenaSafetyCenterPage | /arena/safety | src/app/pages/arena/ArenaSafetyCenterPage.tsx |
| SC-199 | ArenaTrustBreakdownPage | /arena/trust/user001 | src/app/pages/arena/ArenaTrustBreakdownPage.tsx |
| SC-200 | ArenaPointsEntryDetailPage | /arena/ledger/entry/entry001 | src/app/pages/arena/ArenaPointsEntryDetailPage.tsx |
| SC-201 | ArenaPointsLedgerPage | /arena/ledger | src/app/pages/arena/ArenaPointsLedgerPage.tsx |
| SC-202 | ArenaReportCasePage | /arena/report/case001 | src/app/pages/arena/ArenaReportCasePage.tsx |
| SC-203 | ArenaBlockedUsersPage | /arena/blocked | src/app/pages/arena/ArenaBlockedUsersPage.tsx |
| SC-204 | MyArenaReportsPage | /arena/my-reports | src/app/pages/arena/MyArenaReportsPage.tsx |
| SC-205 | MyArenaPage | /arena/my | src/app/pages/arena/MyArenaPage.tsx |
| SC-206 | ArenaProductionReadyPage | /arena/production | src/app/pages/arena/ArenaProductionReadyPage.tsx |
| SC-207 | ArenaPredictionBridgeFoundationPage | /arena/bridge | src/app/pages/arena/ArenaPredictionBridgeFoundationPage.tsx |
| SC-208 | ConnectedEcosystemProductionPage | /arena/ecosystem | src/app/pages/arena/ConnectedEcosystemProductionPage.tsx |
| SC-209 | ArenaGuidePage | /arena/guide | src/app/pages/arena/ArenaGuidePage.tsx |
| SC-210 | P2PExpressConfirmPage | /p2p/express/confirm | src/app/pages/p2p/P2PExpressConfirmPage.tsx |
| SC-211 | P2PExpressPage | /p2p/express | src/app/pages/p2p/P2PExpressPage.tsx |
| SC-212 | P2POrderTimelinePage | /p2p/order/timeline/p2p001 | src/app/pages/p2p/P2POrderTimelinePage.tsx |
| SC-213 | P2POrderRatePage | /p2p/order/rate/p2p001 | src/app/pages/p2p/P2POrderRatePage.tsx |
| SC-214 | P2POrderCancelPage | /p2p/order/cancel/p2p001 | src/app/pages/p2p/P2POrderCancelPage.tsx |
| SC-215 | P2POrderProofPage | /p2p/order/proof/p2p001 | src/app/pages/p2p/P2POrderProofPage.tsx |
| SC-216 | P2POrderPage | /p2p/order/p2p001 | src/app/pages/p2p/P2POrderPage.tsx |
| SC-217 | P2PChatPage | /p2p/chat/p2p001 | src/app/pages/p2p/P2PChatPage.tsx |
| SC-218 | P2PDisputeDetailPage | /p2p/dispute/detail/sample | src/app/pages/p2p/P2PDisputeDetailPage.tsx |
| SC-219 | P2PDisputeEvidencePage | /p2p/dispute/evidence/sample | src/app/pages/p2p/P2PDisputeEvidencePage.tsx |
| SC-220 | P2PDisputeResolutionPage | /p2p/dispute/resolution/sample | src/app/pages/p2p/P2PDisputeResolutionPage.tsx |
| SC-221 | P2PDisputePage | /p2p/dispute/p2p001 | src/app/pages/p2p/P2PDisputePage.tsx |
| SC-222 | P2PDisputesPage | /p2p/disputes | src/app/pages/p2p/P2PDisputesPage.tsx |
| SC-223 | P2PAdAnalyticsPage | /p2p/ad-analytics/sample | src/app/pages/p2p/P2PAdAnalyticsPage.tsx |
| SC-224 | P2PAdDetailPage | /p2p/ad/sample | src/app/pages/p2p/P2PAdDetailPage.tsx |
| SC-225 | P2PMyAdsPage | /p2p/my-ads | src/app/pages/p2p/P2PMyAdsPage.tsx |
| SC-226 | P2PCreateAdPage | /p2p/create | src/app/pages/p2p/P2PCreateAdPage.tsx |
| SC-227 | P2PMerchantApplyPage | /p2p/merchant-apply | src/app/pages/p2p/P2PMerchantApplyPage.tsx |
| SC-228 | P2PMerchantProfilePage | /p2p/merchant/mc001 | src/app/pages/p2p/P2PMerchantProfilePage.tsx |
| SC-229 | P2PReportMerchantPage | /p2p/report/mc001 | src/app/pages/p2p/P2PReportMerchantPage.tsx |
| SC-230 | P2PTradingLevelPage | /p2p/trading-level | src/app/pages/p2p/P2PTradingLevelPage.tsx |
| SC-231 | P2PReviewsPage | /p2p/reviews | src/app/pages/p2p/P2PReviewsPage.tsx |
| SC-232 | P2PPaymentMethodAddPage | /p2p/payment-method/add | src/app/pages/p2p/P2PPaymentMethodAddPage.tsx |
| SC-233 | P2PPaymentMethodVerificationPage | /p2p/payment-method/verification/sample | src/app/pages/p2p/P2PPaymentMethodVerificationPage.tsx |
| SC-234 | P2PPaymentMethodOwnershipPage | /p2p/payment-method/ownership/sample | src/app/pages/p2p/P2PPaymentMethodOwnershipPage.tsx |
| SC-235 | P2PPaymentMethodCoolingPeriodPage | /p2p/payment-method/cooling-period | src/app/pages/p2p/P2PPaymentMethodCoolingPeriodPage.tsx |
| SC-236 | P2PPaymentMethodHistoryPage | /p2p/payment-method/history | src/app/pages/p2p/P2PPaymentMethodHistoryPage.tsx |
| SC-237 | P2PPaymentMethodsPage | /p2p/payment-methods | src/app/pages/p2p/P2PPaymentMethodsPage.tsx |
| SC-238 | P2PInsuranceFundPage | /p2p/insurance | src/app/pages/p2p/P2PInsuranceFundPage.tsx |
| SC-239 | P2PInsuranceCertificatePage | /p2p/insurance/certificate | src/app/pages/p2p/P2PInsuranceCertificatePage.tsx |
| SC-240 | P2PInsuranceScorePage | /p2p/insurance/score | src/app/pages/p2p/P2PInsuranceScorePage.tsx |
| SC-241 | P2PInsurancePolicyPage | /p2p/insurance/policy | src/app/pages/p2p/P2PInsurancePolicyPage.tsx |
| SC-242 | P2PContributionHistoryPage | /p2p/insurance/contribution-history | src/app/pages/p2p/P2PContributionHistoryPage.tsx |
| SC-243 | P2PClaimDetailPage | /p2p/insurance/claim/sample | src/app/pages/p2p/P2PClaimDetailPage.tsx |
| SC-244 | P2PInsuranceFundPage | /p2p/insurance-fund | src/app/pages/p2p/P2PInsuranceFundPage.tsx |
| SC-245 | P2PEscrowBalancePage | /p2p/escrow/balance | src/app/pages/p2p/P2PEscrowBalancePage.tsx |
| SC-246 | P2PEscrowDetailPage | /p2p/escrow/p2p001 | src/app/pages/p2p/P2PEscrowDetailPage.tsx |
| SC-247 | P2PKYCRequirementsPage | /p2p/kyc/requirements | src/app/pages/p2p/P2PKYCRequirementsPage.tsx |
| SC-248 | P2PKYCStatusPage | /p2p/kyc/status | src/app/pages/p2p/P2PKYCStatusPage.tsx |
| SC-249 | P2PIdentityVerificationPage | /p2p/kyc/identity | src/app/pages/p2p/P2PIdentityVerificationPage.tsx |
| SC-250 | P2PAddressProofPage | /p2p/kyc/address | src/app/pages/p2p/P2PAddressProofPage.tsx |
| SC-251 | P2PSelfieVerificationPage | /p2p/kyc/selfie | src/app/pages/p2p/P2PSelfieVerificationPage.tsx |
| SC-252 | P2PVideoVerificationPage | /p2p/kyc/video | src/app/pages/p2p/P2PVideoVerificationPage.tsx |
| SC-253 | P2PSecurityCenterPage | /p2p/security/center | src/app/pages/p2p/P2PSecurityCenterPage.tsx |
| SC-254 | P2P2FASettingsPage | /p2p/security/2fa | src/app/pages/p2p/P2P2FASettingsPage.tsx |
| SC-255 | P2PDeviceManagementPage | /p2p/security/devices | src/app/pages/p2p/P2PDeviceManagementPage.tsx |
| SC-256 | P2PAntiPhishingCodePage | /p2p/security/anti-phishing | src/app/pages/p2p/P2PAntiPhishingCodePage.tsx |
| SC-257 | P2PLoginHistoryPage | /p2p/security/login-history | src/app/pages/p2p/P2PLoginHistoryPage.tsx |
| SC-258 | P2PSuspiciousActivityPage | /p2p/security/suspicious-activity | src/app/pages/p2p/P2PSuspiciousActivityPage.tsx |
| SC-259 | P2PE2EInfoPage | /p2p/e2e-info | src/app/pages/p2p/P2PE2EInfoPage.tsx |
| SC-260 | P2PFraudPreventionPage | /p2p/fraud-prevention | src/app/pages/p2p/P2PFraudPreventionPage.tsx |
| SC-261 | P2PWalletTransferPage | /p2p/wallet/transfer | src/app/pages/p2p/P2PWalletTransferPage.tsx |
| SC-262 | P2PFundLockHistoryPage | /p2p/wallet/fund-lock-history | src/app/pages/p2p/P2PFundLockHistoryPage.tsx |
| SC-263 | P2PFundLockHistoryPage | /p2p/wallet/history | src/app/pages/p2p/P2PFundLockHistoryPage.tsx |
| SC-264 | P2PWalletPage | /p2p/wallet | src/app/pages/p2p/P2PWalletPage.tsx |
| SC-265 | P2PLimitTrackerPage | /p2p/limits/tracker | src/app/pages/p2p/P2PLimitTrackerPage.tsx |
| SC-266 | P2PTransactionLimitsPage | /p2p/limits | src/app/pages/p2p/P2PTransactionLimitsPage.tsx |
| SC-267 | P2PComplianceOverviewPage | /p2p/compliance/overview | src/app/pages/p2p/P2PComplianceOverviewPage.tsx |
| SC-268 | P2PAMLScreeningPage | /p2p/compliance/aml-screening | src/app/pages/p2p/P2PAMLScreeningPage.tsx |
| SC-269 | P2PSourceOfFundsPage | /p2p/compliance/source-of-funds | src/app/pages/p2p/P2PSourceOfFundsPage.tsx |
| SC-270 | P2PLargeTransactionJustificationPage | /p2p/compliance/large-transaction | src/app/pages/p2p/P2PLargeTransactionJustificationPage.tsx |
| SC-271 | P2PRiskAssessmentPage | /p2p/compliance/risk-assessment | src/app/pages/p2p/P2PRiskAssessmentPage.tsx |
| SC-272 | P2PTaxReportingPage | /p2p/tax-reporting | src/app/pages/p2p/P2PTaxReportingPage.tsx |
| SC-273 | P2POrderBookPage | /p2p/order-book | src/app/pages/p2p/P2POrderBookPage.tsx |
| SC-274 | P2PDashboardPage | /p2p/dashboard | src/app/pages/p2p/P2PDashboardPage.tsx |
| SC-275 | P2PAchievementsPage | /p2p/achievements | src/app/pages/p2p/P2PAchievementsPage.tsx |
| SC-276 | P2PBlacklistAddPage | /p2p/blacklist/add | src/app/pages/p2p/P2PBlacklistAddPage.tsx |
| SC-277 | P2PBlacklistPage | /p2p/blacklist | src/app/pages/p2p/P2PBlacklistPage.tsx |
| SC-278 | P2PNotificationsSettingsPage | /p2p/settings/notifications | src/app/pages/p2p/P2PNotificationsSettingsPage.tsx |
| SC-279 | P2PSettingsPage | /p2p/settings | src/app/pages/p2p/P2PSettingsPage.tsx |
| SC-280 | P2PGuidePage | /p2p/guide | src/app/pages/p2p/P2PGuidePage.tsx |
| SC-281 | P2PMyOrdersPage | /p2p/my-orders | src/app/pages/p2p/P2PMyOrdersPage.tsx |
| SC-282 | P2PHomePage | /p2p | src/app/pages/p2p/P2PHomePage.tsx |
| SC-283 | UnifiedSearchPage | /search | src/app/pages/discovery/UnifiedSearchPage.tsx |
| SC-284 | TopicHubPage | /topics | src/app/pages/discovery/TopicHubPage.tsx |
| SC-285 | TopicHubPage | /topic/crypto | src/app/pages/discovery/TopicHubPage.tsx |
| SC-286 | ReferralHistoryPage | /referral/history | src/app/pages/referral/ReferralHistoryPage.tsx |
| SC-287 | ReferralRewardsPage | /referral/rewards | src/app/pages/referral/ReferralRewardsPage.tsx |
| SC-288 | ReferralRulesPage | /referral/rules | src/app/pages/referral/ReferralRulesPage.tsx |
| SC-289 | ReferralFriendDetailPage | /referral/friend/friend001 | src/app/pages/referral/ReferralFriendDetailPage.tsx |
| SC-290 | ReferralHomePage | /referral | src/app/pages/referral/ReferralHomePage.tsx |
| SC-291 | NotificationsPage | /notifications | src/app/pages/notifications/NotificationsPage.tsx |
| SC-292 | HelpCenterPage | /support/help | src/app/pages/support/HelpCenterPage.tsx |
| SC-293 | AnnouncementsPage | /support/announcements | src/app/pages/support/AnnouncementsPage.tsx |
| SC-294 | SupportPage | /support | src/app/pages/support/SupportPage.tsx |
| SC-295 | LaunchpadPage | /launchpad | src/app/pages/launchpad/LaunchpadPage.tsx |
| SC-296 | LaunchpadPortfolioPage | /launchpad/portfolio | src/app/pages/launchpad/LaunchpadPortfolioPage.tsx |
| SC-297 | LaunchpadPerformancePage | /launchpad/performance | src/app/pages/launchpad/LaunchpadPerformancePage.tsx |
| SC-298 | LaunchpadStakingPage | /launchpad/staking | src/app/pages/launchpad/LaunchpadStakingPage.tsx |
| SC-299 | LaunchpadIDOBridgePage | /launchpad/idobridge/sample | src/app/pages/launchpad/LaunchpadIDOBridgePage.tsx |
| SC-300 | LaunchpadContractPage | /launchpad/contract/sample | src/app/pages/launchpad/LaunchpadContractPage.tsx |
| SC-301 | LaunchpadReceiptPage | /launchpad/receipt/sub001 | src/app/pages/launchpad/LaunchpadReceiptPage.tsx |
| SC-302 | LaunchpadClaimReceiptPage | /launchpad/claim-receipt/pos001 | src/app/pages/launchpad/LaunchpadClaimReceiptPage.tsx |
| SC-303 | LaunchpadBridgeOrderPage | /launchpad/bridge-order/tx001 | src/app/pages/launchpad/LaunchpadBridgeOrderPage.tsx |
| SC-304 | LaunchpadBatchClaimPage | /launchpad/batch-claim | src/app/pages/launchpad/LaunchpadBatchClaimPage.tsx |
| SC-305 | LaunchpadBridgeComparePage | /launchpad/bridge-compare | src/app/pages/launchpad/LaunchpadBridgeComparePage.tsx |
| SC-306 | LaunchpadNotifSoundPage | /launchpad/notif-sound | src/app/pages/launchpad/LaunchpadNotifSoundPage.tsx |
| SC-307 | LaunchpadEventLogPage | /launchpad/event-log | src/app/pages/launchpad/LaunchpadEventLogPage.tsx |
| SC-308 | LaunchpadABIDiffPage | /launchpad/abi-diff/contract001 | src/app/pages/launchpad/LaunchpadABIDiffPage.tsx |
| SC-309 | LaunchpadAddressBookPage | /launchpad/address-book | src/app/pages/launchpad/LaunchpadAddressBookPage.tsx |
| SC-310 | LaunchpadWebhooksPage | /launchpad/webhooks | src/app/pages/launchpad/LaunchpadWebhooksPage.tsx |
| SC-311 | LaunchpadGasTrackerPage | /launchpad/gas-tracker | src/app/pages/launchpad/LaunchpadGasTrackerPage.tsx |
| SC-312 | LaunchpadRebalancePage | /launchpad/rebalance | src/app/pages/launchpad/LaunchpadRebalancePage.tsx |
| SC-313 | LaunchpadMultisigPage | /launchpad/multisig | src/app/pages/launchpad/LaunchpadMultisigPage.tsx |
| SC-314 | LaunchpadSwapAggregatorPage | /launchpad/swap-aggregator | src/app/pages/launchpad/LaunchpadSwapAggregatorPage.tsx |
| SC-315 | LaunchpadLimitOrdersPage | /launchpad/limit-orders | src/app/pages/launchpad/LaunchpadLimitOrdersPage.tsx |
| SC-316 | LaunchpadDCABuilderPage | /launchpad/dca-builder | src/app/pages/launchpad/LaunchpadDCABuilderPage.tsx |
| SC-317 | LaunchpadRiskAnalyticsPage | /launchpad/risk-analytics | src/app/pages/launchpad/LaunchpadRiskAnalyticsPage.tsx |
| SC-318 | LaunchpadDetailPage | /launchpad/sample | src/app/pages/launchpad/LaunchpadDetailPage.tsx |
| SC-319 | RewardsHubPage | /rewards | src/app/pages/rewards/RewardsHubPage.tsx |
| SC-320 | EnterpriseStatesPage | /enterprise-states | src/app/pages/dev/EnterpriseStatesPage.tsx |
| SC-321 | UnifiedPortfolioDashboard | /unified-portfolio | src/app/pages/cross-module/UnifiedPortfolioDashboard.tsx |
| SC-322 | CrossModuleAnalytics | /cross-module-analytics | src/app/pages/cross-module/CrossModuleAnalytics.tsx |
| SC-323 | SmartAlertCenter | /smart-alerts | src/app/pages/cross-module/SmartAlertCenter.tsx |
| SC-324 | TaxReportCenter | /tax-reports | src/app/pages/cross-module/TaxReportCenter.tsx |
| SC-325 | RouteChecker | /dev/route-checker | NEEDS_MANUAL_CONFIRM |
| SC-326 | PerformanceMonitor | /dev/performance-monitor | NEEDS_MANUAL_CONFIRM |
| SC-327 | StakingEarnPage | /earn | src/app/pages/earn/StakingEarnPage.tsx |
| SC-328 | StakingEarnPage | /earn/staking | src/app/pages/earn/StakingEarnPage.tsx |
| SC-329 | SavingsPage | /earn/savings | src/app/pages/earn/SavingsPage.tsx |
| SC-330 | SavingsProductDetailPage | /earn/savings/product/sample | src/app/pages/earn/SavingsProductDetailPage.tsx |
| SC-331 | SavingsRedeemPage | /earn/savings/redeem/pos001 | src/app/pages/earn/SavingsRedeemPage.tsx |
| SC-332 | SavingsReceiptPage | /earn/savings/receipt | src/app/pages/earn/SavingsReceiptPage.tsx |
| SC-333 | SavingsPortfolioPage | /earn/savings/portfolio | src/app/pages/earn/SavingsPortfolioPage.tsx |
| SC-334 | SavingsHistoryPage | /earn/savings/history | src/app/pages/earn/SavingsHistoryPage.tsx |
| SC-335 | SavingsGuidePage | /earn/savings/guide | src/app/pages/earn/SavingsGuidePage.tsx |
| SC-336 | SavingsFAQPage | /earn/savings/faq | src/app/pages/earn/SavingsFAQPage.tsx |
| SC-337 | SavingsNotificationsPage | /earn/savings/notifications | src/app/pages/earn/SavingsNotificationsPage.tsx |
| SC-338 | SavingsRecommendationsPage | /earn/savings/recommendations | src/app/pages/earn/SavingsRecommendationsPage.tsx |
| SC-339 | SavingsRiskAssessmentPage | /earn/savings/risk-assessment | src/app/pages/earn/SavingsRiskAssessmentPage.tsx |
| SC-340 | SavingsComparisonPage | /earn/savings/comparison | src/app/pages/earn/SavingsComparisonPage.tsx |
| SC-341 | AutoCompoundSettingsPage | /earn/savings/auto-compound | src/app/pages/earn/AutoCompoundSettingsPage.tsx |
| SC-342 | SavingsGoalPage | /earn/savings/goals | src/app/pages/earn/SavingsGoalPage.tsx |
| SC-343 | SavingsAnalyticsPage | /earn/savings/analytics | src/app/pages/earn/SavingsAnalyticsPage.tsx |
| SC-344 | SavingsAutoRebalancePage | /earn/savings/rebalance | src/app/pages/earn/SavingsAutoRebalancePage.tsx |
| SC-345 | SavingsNotificationPreferencesPage | /earn/savings/notification-preferences | src/app/pages/earn/SavingsNotificationPreferencesPage.tsx |
| SC-346 | SavingsDCAPage | /earn/savings/dca | src/app/pages/earn/SavingsDCAPage.tsx |
| SC-347 | SavingsSmartSuggestionsPage | /earn/savings/smart-suggestions | src/app/pages/earn/SavingsSmartSuggestionsPage.tsx |
| SC-348 | SavingsExportPage | /earn/savings/export | src/app/pages/earn/SavingsExportPage.tsx |
| SC-349 | SavingsBacktestPage | /earn/savings/backtest | src/app/pages/earn/SavingsBacktestPage.tsx |
| SC-350 | SavingsAutoPilotPage | /earn/savings/autopilot | src/app/pages/earn/SavingsAutoPilotPage.tsx |
| SC-351 | SavingsLadderPage | /earn/savings/ladder | src/app/pages/earn/SavingsLadderPage.tsx |
| SC-352 | SavingsWhatIfPage | /earn/savings/whatif | src/app/pages/earn/SavingsWhatIfPage.tsx |
| SC-353 | StakingTermsPage | /earn/staking/terms | src/app/pages/earn/StakingTermsPage.tsx |
| SC-354 | StakingRiskDisclosurePage | /earn/staking/risk-disclosure | src/app/pages/earn/StakingRiskDisclosurePage.tsx |
| SC-355 | StakingWithdrawalPolicyPage | /earn/staking/withdrawal-policy | src/app/pages/earn/StakingWithdrawalPolicyPage.tsx |
| SC-356 | StakingTaxGuidePage | /earn/staking/tax-guide | src/app/pages/earn/StakingTaxGuidePage.tsx |
| SC-357 | StakingRiskAssessmentPage | /earn/staking/risk-assessment | src/app/pages/earn/StakingRiskAssessmentPage.tsx |
| SC-358 | StakingDashboardPage | /earn/dashboard | src/app/pages/earn/StakingDashboardPage.tsx |
| SC-359 | StakingAnalyticsPage | /earn/analytics | src/app/pages/earn/StakingAnalyticsPage.tsx |
| SC-360 | StakingHistoryPage | /earn/history | src/app/pages/earn/StakingHistoryPage.tsx |
| SC-361 | StakingEarningsCalendarPage | /earn/calendar | src/app/pages/earn/StakingEarningsCalendarPage.tsx |
| SC-362 | StakingValidatorSelectionPage | /earn/validator-selection | src/app/pages/earn/StakingValidatorSelectionPage.tsx |
| SC-363 | StakingAutoCompoundPage | /earn/auto-compound | src/app/pages/earn/StakingAutoCompoundPage.tsx |
| SC-364 | StakingLiquidStakingPage | /earn/liquid-staking | src/app/pages/earn/StakingLiquidStakingPage.tsx |
| SC-365 | StakingInsurancePage | /earn/insurance | src/app/pages/earn/StakingInsurancePage.tsx |
| SC-366 | StakingAdvancedOrdersPage | /earn/advanced-orders | src/app/pages/earn/StakingAdvancedOrdersPage.tsx |
| SC-367 | StakingMultiChainPage | /earn/multi-chain | src/app/pages/earn/StakingMultiChainPage.tsx |
| SC-368 | StakingInstitutionalPage | /earn/institutional | src/app/pages/earn/StakingInstitutionalPage.tsx |
| SC-369 | StakingGuidePage | /earn/guide | src/app/pages/earn/StakingGuidePage.tsx |
| SC-370 | StakingFAQPage | /earn/faq | src/app/pages/earn/StakingFAQPage.tsx |
| SC-371 | StakingNotificationsPage | /earn/notifications | src/app/pages/earn/StakingNotificationsPage.tsx |
| SC-372 | StakingRecommendationsPage | /earn/recommendations | src/app/pages/earn/StakingRecommendationsPage.tsx |
| SC-373 | StakingRegulatoryFrameworkPage | /earn/regulatory-framework | src/app/pages/earn/StakingRegulatoryFrameworkPage.tsx |
| SC-374 | StakingAuditReportsPage | /earn/audit-reports | src/app/pages/earn/StakingAuditReportsPage.tsx |
| SC-375 | StakingCustodyPage | /earn/custody | src/app/pages/earn/StakingCustodyPage.tsx |
| SC-376 | StakingSuitabilityAssessmentPage | /earn/suitability-assessment | src/app/pages/earn/StakingSuitabilityAssessmentPage.tsx |
| SC-377 | StakingInsuranceFundTransparencyPage | /earn/insurance-fund-transparency | src/app/pages/earn/StakingInsuranceFundTransparencyPage.tsx |
| SC-378 | StakingTransactionReportingPage | /earn/transaction-reporting | src/app/pages/earn/StakingTransactionReportingPage.tsx |
| SC-379 | StakingAPIDocumentationPage | /earn/api-documentation | src/app/pages/earn/StakingAPIDocumentationPage.tsx |
| SC-380 | StakingProofOfReservesPage | /earn/proof-of-reserves | src/app/pages/earn/StakingProofOfReservesPage.tsx |
| SC-381 | StakingRiskDashboardPage | /earn/risk-dashboard | src/app/pages/earn/StakingRiskDashboardPage.tsx |
| SC-382 | StakingSlashingHistoryPage | /earn/slashing-history | src/app/pages/earn/StakingSlashingHistoryPage.tsx |
| SC-383 | StakingValidatorHealthMonitorPage | /earn/validator-health-monitor | src/app/pages/earn/StakingValidatorHealthMonitorPage.tsx |
| SC-384 | StakingRiskScoreCalculatorPage | /earn/risk-score-calculator | src/app/pages/earn/StakingRiskScoreCalculatorPage.tsx |
| SC-385 | StakingEmergencyActionsPage | /earn/emergency-actions | src/app/pages/earn/StakingEmergencyActionsPage.tsx |
| SC-386 | StakingContingencyPlanPage | /earn/contingency-plan | src/app/pages/earn/StakingContingencyPlanPage.tsx |
| SC-387 | StakingSocialFeedPage | /earn/social-feed | src/app/pages/earn/StakingSocialFeedPage.tsx |
| SC-388 | StakingCommunityGovernancePage | /earn/community-governance | src/app/pages/earn/StakingCommunityGovernancePage.tsx |
| SC-389 | StakingProposalsPage | /earn/proposals | src/app/pages/earn/StakingProposalsPage.tsx |
| SC-390 | StakingVotingPage | /earn/voting/prop001 | src/app/pages/earn/StakingVotingPage.tsx |
| SC-391 | StakingVotingPage | /earn/voting | src/app/pages/earn/StakingVotingPage.tsx |
| SC-392 | StakingForumPage | /earn/forum | src/app/pages/earn/StakingForumPage.tsx |
| SC-393 | StakingWebhooksPage | /earn/webhooks | src/app/pages/earn/StakingWebhooksPage.tsx |
| SC-394 | StakingDataExportPage | /earn/data-export | src/app/pages/earn/StakingDataExportPage.tsx |
| SC-395 | StakingThirdPartyIntegrationsPage | /earn/third-party-integrations | src/app/pages/earn/StakingThirdPartyIntegrationsPage.tsx |
| SC-396 | StakingDeveloperConsolePage | /earn/developer-console | src/app/pages/earn/StakingDeveloperConsolePage.tsx |
| SC-397 | OnboardingFlow | /onboarding | src/app/pages/onboarding/OnboardingFlow.tsx |
| SC-398 | MissingScreensShowcasePage | /dev/showcase | src/app/pages/v2/MissingScreensShowcasePage.tsx |
| SC-399 | DesignSystemPage | /dev/design-system | src/app/pages/v2/DesignSystemPage.tsx |
| SC-400 | DCAOverviewDemo | /dev/dca-overview | src/app/pages/dca/DCAOverviewDemo.tsx |
| SC-401 | CopyTradingCardDemo | /demo/copy-card | src/app/pages/demo/CopyTradingCardDemo.tsx |

## Navigation Graph

Confidence legend: `resolved` means the target matched a manifest route or browser back; `NEEDS_MANUAL_CONFIRM` means the source expression was dynamic or points to an unmanifested route.

### admin navigation (5)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /admin | /admin/abtests | route-hierarchy | resolved | route tree/url hierarchy |  |
| /admin | /admin/analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /admin | /admin/funnels | route-hierarchy | resolved | route tree/url hierarchy |  |
| /admin | /admin/settings | navigate | resolved | src/app/pages/admin/AdminHome.tsx:98 | User-confirmed safe placeholder route; no separate SC row/source/screenshot, backPath `/admin`. |
| /admin | /admin/{analytics,abtests,funnels} | navigate | resolved | src/app/pages/admin/AdminHome.tsx:168 | `dashboard.path` resolves to the three dashboard routes; Flutter wires real routes for SC-181, SC-182, and SC-183. |

### arena navigation (115)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /arena | /arena/blocked | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/bridge | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/challenge/{challengeId} | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:317 | dynamic id mapped with `AppRoutePaths.arenaChallenge(room.id)`; placeholder route until SC-190. |
| /arena | /arena/challenge/{challengeId} | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:661 | dynamic id mapped with `AppRoutePaths.arenaChallenge(room.id)`; placeholder route until SC-190. |
| /arena | /arena/challenge/ch003 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/creator/{creatorId} | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:385 | dynamic id mapped with `AppRoutePaths.arenaCreator(cr.id)`; placeholder route until SC-193. |
| /arena | /arena/creator/{creatorId} | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:685 | dynamic id mapped with `AppRoutePaths.arenaCreator(cr.id)`; placeholder route until SC-193. |
| /arena | /arena/creator/cr001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/ecosystem | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/flow-map | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/guide | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/join/ch003 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/leaderboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/leaderboard | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:216 | template-normalized |
| /arena | /arena/ledger | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/mode/mode001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/mode/mode001 | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:234 | template-normalized |
| /arena | /arena/mode/mode001 | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:634 | template-normalized |
| /arena | /arena/my | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/my-reports | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/points | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/production | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/report/case001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/resolution | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/safety | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/studio | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/studio | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:104 | template-normalized |
| /arena | /arena/studio | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:166 | template-normalized |
| /arena | /arena/trust/user001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /arena/verified | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena | /markets/predictions | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:433 | template-normalized |
| /arena | /arena/{guide,leaderboard}/profile-arena/rewards | navigate | resolved | src/app/pages/arena/ArenaHomePage.tsx:597 | quick-chip `item.path` mapped to typed routes where available; rewards query remains scoped placeholder. |
| /arena/studio | /arena | navigate | resolved | src/app/pages/arena/ArenaStudioPage.tsx:3323 | template-normalized |
| /arena/studio | /arena/studio/governance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena/studio | /arena/studio/presets | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena/studio | /arena/studio/smart-rules | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena/mode/mode001 | /arena/challenge/${room.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaModeDetailPage.tsx:288 | dynamic-expression; raw=`${prefix}/arena/challenge/${room.id}` |
| /arena/mode/mode001 | /arena/creator/${mode.creator.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaModeDetailPage.tsx:120 | dynamic-expression; raw=`${prefix}/arena/creator/${mode.creator.id}` |
| /arena/mode/mode001 | /arena/mode/${rm.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaModeDetailPage.tsx:324 | dynamic-expression; raw=`${prefix}/arena/mode/${rm.id}` |
| /arena/mode/mode001 | /arena/studio | navigate | resolved | src/app/pages/arena/ArenaModeDetailPage.tsx:259 | template-normalized |
| /arena/mode/mode001 | /arena/studio | navigate | resolved | src/app/pages/arena/ArenaModeDetailPage.tsx:263 | template-normalized |
| /arena/mode/mode001 | /arena/trust/${mode.creator.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaModeDetailPage.tsx:143 | dynamic-expression; raw=`${prefix}/arena/trust/${mode.creator.id}` |
| /arena/challenge/ch003 | /arena/creator/${data.creator.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaChallengeDetailPage.tsx:704 | dynamic-expression; raw=`${prefix}/arena/creator/${data.creator.id}` |
| /arena/challenge/ch003 | /arena/join/${data.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaChallengeDetailPage.tsx:1262 | dynamic-expression; raw=`${prefix}/arena/join/${data.id}` |
| /arena/challenge/ch003 | /arena/ledger | navigate | resolved | src/app/pages/arena/ArenaChallengeDetailPage.tsx:1182 | template-normalized |
| /arena/challenge/ch003 | /arena/mode/${data.modeId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaChallengeDetailPage.tsx:482 | dynamic-expression; raw=`${prefix}/arena/mode/${data.modeId}` |
| /arena/challenge/ch003 | /arena/resolution | navigate | resolved | src/app/pages/arena/ArenaChallengeDetailPage.tsx:1181 | template-normalized |
| /arena/challenge/ch003 | /arena/resolution | navigate | resolved | src/app/pages/arena/ArenaChallengeDetailPage.tsx:1249 | template-normalized |
| /arena/challenge/ch003 | /arena/safety | navigate | resolved | src/app/pages/arena/ArenaChallengeDetailPage.tsx:728 | template-normalized |
| /arena/challenge/ch003 | /arena/safety | navigate | resolved | src/app/pages/arena/ArenaChallengeDetailPage.tsx:1023 | template-normalized |
| /arena/challenge/ch003 | /arena/safety | navigate | resolved | src/app/pages/arena/ArenaChallengeDetailPage.tsx:1024 | template-normalized |
| /arena/challenge/ch003 | /arena/studio | navigate | resolved | src/app/pages/arena/ArenaChallengeDetailPage.tsx:749 | template-normalized |
| /arena/challenge/ch003 | /markets/predictions/event/${linkedEvent.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaChallengeDetailPage.tsx:517 | dynamic-expression; raw=`${prefix}/markets/predictions/event/${linkedEvent.id}` |
| /arena/join/ch003 | /arena/challenge/ch003 | navigate | resolved | src/app/pages/arena/ArenaJoinPage.tsx:122 | template-normalized |
| /arena/join/ch003 | /arena/safety | navigate | resolved | src/app/pages/arena/ArenaJoinPage.tsx:266 | template-normalized |
| /arena/join/ch003 | BACK | navigate | resolved | src/app/pages/arena/ArenaJoinPage.tsx:128 | history |
| /arena/resolution | /arena/challenge/ch003 | navigate | resolved | src/app/pages/arena/ArenaResolutionCenterPage.tsx:388 | template-normalized |
| /arena/resolution | /arena/challenge/ch003 | navigate | resolved | src/app/pages/arena/ArenaResolutionCenterPage.tsx:405 | template-normalized |
| /arena/resolution | /arena/creator/${resolution.refereeId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaResolutionCenterPage.tsx:201 | dynamic-expression; raw=`${prefix}/arena/creator/${resolution.refereeId}` |
| /arena/resolution | /arena/ledger | navigate | resolved | src/app/pages/arena/ArenaResolutionCenterPage.tsx:360 | template-normalized |
| /arena/resolution | /arena/ledger | navigate | resolved | src/app/pages/arena/ArenaResolutionCenterPage.tsx:406 | template-normalized |
| /arena/creator/cr001 | /arena/challenge/${room.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaCreatorPage.tsx:302 | dynamic-expression; raw=`${prefix}/arena/challenge/${room.id}` |
| /arena/creator/cr001 | /arena/mode/${creatorModes[0].id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaCreatorPage.tsx:266 | dynamic-expression; raw=`${prefix}/arena/mode/${creatorModes[0].id}` |
| /arena/creator/cr001 | /arena/mode/mode001 | navigate | resolved | src/app/pages/arena/ArenaCreatorPage.tsx:238 | template-normalized |
| /arena/creator/cr001 | /arena/safety | navigate | resolved | src/app/pages/arena/ArenaCreatorPage.tsx:436 | template-normalized |
| /arena/creator/cr001 | /arena/studio | navigate | resolved | src/app/pages/arena/ArenaCreatorPage.tsx:276 | template-normalized |
| /arena/creator/cr001 | /arena/trust/cr001 | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaCreatorPage.tsx:170 | template-normalized; raw=`${prefix}/arena/trust/${creator.id}` |
| /arena/leaderboard | /arena/creator/${entry.creator.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaLeaderboardPage.tsx:382 | dynamic-expression; raw=`${prefix}/arena/creator/${entry.creator.id}` |
| /arena/points | /rewards | navigate | resolved | src/app/pages/arena/ArenaPointsPage.tsx:21 | template-normalized |
| /arena/flow-map | ${route} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaFlowMapPage.tsx:751 | expression-not-absolute; raw=`${prefix}${route}` |
| /arena/safety | /profile/arena/blocked | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaSafetyCenterPage.tsx:337 | template-normalized; raw=`${prefix}/profile/arena/blocked` |
| /arena/safety | /profile/arena/reports/rpt001 | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaSafetyCenterPage.tsx:349 | template-normalized; raw=`${prefix}/profile/arena/reports/rpt001` |
| /arena/safety | BACK | navigate | resolved | src/app/pages/arena/ArenaSafetyCenterPage.tsx:99 | history |
| /arena/trust/user001 | /arena/creator/cr001 | navigate | resolved | src/app/pages/arena/ArenaTrustBreakdownPage.tsx:68 | template-normalized |
| /arena/trust/user001 | /arena/safety | navigate | resolved | src/app/pages/arena/ArenaTrustBreakdownPage.tsx:97 | template-normalized |
| /arena/trust/user001 | BACK | navigate | resolved | src/app/pages/arena/ArenaTrustBreakdownPage.tsx:101 | history |
| /arena/ledger/entry/entry001 | /arena/challenge/${entry.linkedChallengeId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaPointsEntryDetailPage.tsx:121 | dynamic-expression; raw=`${prefix}/arena/challenge/${entry.linkedChallengeId}` |
| /arena/ledger/entry/entry001 | /arena/challenge/${entry.linkedChallengeId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaPointsEntryDetailPage.tsx:202 | dynamic-expression; raw=`${prefix}/arena/challenge/${entry.linkedChallengeId}` |
| /arena/ledger/entry/entry001 | /arena/mode/${entry.linkedModeId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaPointsEntryDetailPage.tsx:133 | dynamic-expression; raw=`${prefix}/arena/mode/${entry.linkedModeId}` |
| /arena/ledger | /arena/ledger/entry/${entry.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaPointsLedgerPage.tsx:162 | dynamic-expression; raw=`${prefix}/arena/ledger/entry/${entry.id}` |
| /arena/ledger | /arena/ledger/entry/entry001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /arena/report/case001 | /arena/challenge/${reportCase.relatedChallenge} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaReportCasePage.tsx:84 | dynamic-expression; raw=`${prefix}/arena/challenge/${reportCase.relatedChallenge}` |
| /arena/report/case001 | /arena/my-reports | navigate | resolved | src/app/pages/arena/ArenaReportCasePage.tsx:203 | template-normalized |
| /arena/report/case001 | /arena/report/${r.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaReportCasePage.tsx:220 | dynamic-expression; raw=`${prefix}/arena/report/${r.id}` |
| /arena/report/case001 | BACK | navigate | resolved | src/app/pages/arena/ArenaReportCasePage.tsx:63 | history |
| /arena/blocked | /arena/creator/${user.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaBlockedUsersPage.tsx:90 | dynamic-expression; raw=`${prefix}/arena/creator/${user.id}` |
| /arena/my-reports | /profile/arena/reports/${reportCase.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaReportsPage.tsx:169 | dynamic-expression; raw=`${prefix}/profile/arena/reports/${reportCase.id}` |
| /arena/my | /arena | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:356 | template-normalized |
| /arena/my | /arena | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:374 | template-normalized |
| /arena/my | /arena/challenge/${ch.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaPage.tsx:344 | dynamic-expression; raw=`${prefix}/arena/challenge/${ch.id}` |
| /arena/my | /arena/challenge/${ch.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaPage.tsx:362 | dynamic-expression; raw=`${prefix}/arena/challenge/${ch.id}` |
| /arena/my | /arena/challenge/${ch.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaPage.tsx:465 | dynamic-expression; raw=`${prefix}/arena/challenge/${ch.id}` |
| /arena/my | /arena/challenge/sample | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaPage.tsx:533 | template-normalized; raw=`${prefix}/arena/challenge/${id}` |
| /arena/my | /arena/mode/mode001 | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:380 | template-normalized |
| /arena/my | /arena/points | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:143 | template-normalized |
| /arena/my | /arena/safety | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:571 | template-normalized |
| /arena/my | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:283 | template-normalized |
| /arena/my | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:338 | template-normalized |
| /arena/my | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:417 | template-normalized |
| /arena/my | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:423 | template-normalized |
| /arena/my | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:505 | template-normalized |
| /arena/my | /profile/arena/blocked | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaPage.tsx:557 | template-normalized; raw=`${prefix}/profile/arena/blocked` |
| /arena/my | /profile/arena/reports | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaPage.tsx:543 | template-normalized; raw=`${prefix}/profile/arena/reports` |
| /arena/my | /rewards | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:209 | template-normalized |
| /arena/my | item.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/MyArenaPage.tsx:297 | expression-not-absolute; raw=item.path |
| /arena/production | ${route} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaProductionReadyPage.tsx:524 | expression-not-absolute; raw=`${prefix}${route}` |
| /arena/production | ${screen.route.replace(':challengeId', 'ch003').replace(':id', 'ch003')} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaProductionReadyPage.tsx:406 | expression-not-absolute; raw=`${prefix}${screen.route.replace(':challengeId', 'ch003').replace(':id', 'ch003')}` |
| /arena/bridge | /profile/arena | navigate | resolved | src/app/pages/arena/ArenaPredictionBridgeFoundationPage.tsx:464 | template-normalized |
| /arena/bridge | /profile/predictions | navigate | resolved | src/app/pages/arena/ArenaPredictionBridgeFoundationPage.tsx:463 | template-normalized |
| /arena/ecosystem | ${route} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ConnectedEcosystemProductionPage.tsx:649 | expression-not-absolute; raw=`${prefix}${route}` |
| /arena/ecosystem | ${screen.route.replace(':id', 'evt001').replace(':challengeId', 'ch001')} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ConnectedEcosystemProductionPage.tsx:504 | expression-not-absolute; raw=`${prefix}${screen.route.replace(':id', 'evt001').replace(':challengeId', 'ch001')}` |
| /arena/guide | /arena/safety | navigate | resolved | src/app/pages/arena/ArenaGuidePage.tsx:457 | template-normalized |
| /arena/guide | /arena/studio | navigate | resolved | src/app/pages/arena/ArenaGuidePage.tsx:388 | template-normalized |
| /arena/guide | /support | navigate | resolved | src/app/pages/arena/ArenaGuidePage.tsx:552 | template-normalized |
| /arena/guide | guideMode === 'create' ? `/arena/studio` : `/arena` | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/arena/ArenaGuidePage.tsx:193 | expression-not-absolute; raw=guideMode === 'create' ? `${prefix}/arena/studio` : `${prefix}/arena` |

### auth navigation (13)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /auth/login | /auth/forgot-password | navigate | resolved | src/app/pages/auth/LoginPage.tsx:96 | template-normalized |
| /auth/login | /auth/register | navigate | resolved | src/app/pages/auth/LoginPage.tsx:126 | template-normalized |
| /auth/login | /home | navigate | resolved | src/app/pages/auth/LoginPage.tsx:30 | template-normalized |
| /auth/login | /home | navigate | resolved | src/app/pages/auth/LoginPage.tsx:37 | template-normalized |
| /auth/register | /auth/login | navigate | resolved | src/app/pages/auth/RegisterPage.tsx:168 | template-normalized |
| /auth/register | /auth/otp | navigate | resolved | src/app/pages/auth/RegisterPage.tsx:77 | template-normalized |
| /auth/otp | /auth/2fa-setup | navigate | resolved | src/app/pages/auth/OTPPage.tsx:57 | template-normalized |
| /auth/otp | /auth/reset-password | navigate | resolved | src/app/pages/auth/OTPPage.tsx:59 | template-normalized |
| /auth/otp | /home | navigate | resolved | src/app/pages/auth/OTPPage.tsx:58 | template-normalized |
| /auth/2fa-setup | /home | navigate | resolved | src/app/pages/auth/TwoFASetupPage.tsx:47 | template-normalized |
| /auth/forgot-password | /auth/login | navigate | resolved | src/app/pages/auth/ForgotPasswordPage.tsx:106 | template-normalized |
| /auth/reset-password | /auth/login | navigate | resolved | src/app/pages/auth/ResetPasswordPage.tsx:59 | template-normalized |
| /auth/reset-password | /auth/login | navigate | resolved | src/app/pages/auth/ResetPasswordPage.tsx:160 | template-normalized |

### cross-module navigation (6)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /unified-portfolio | /arena | navigate | resolved | src/app/pages/cross-module/UnifiedPortfolioDashboard.tsx:269 | literal |
| /unified-portfolio | /dca | navigate | resolved | src/app/pages/cross-module/UnifiedPortfolioDashboard.tsx:270 | literal |
| /unified-portfolio | /markets/predictions | navigate | resolved | src/app/pages/cross-module/UnifiedPortfolioDashboard.tsx:268 | literal |
| /unified-portfolio | /p2p | navigate | resolved | src/app/pages/cross-module/UnifiedPortfolioDashboard.tsx:267 | literal |
| /unified-portfolio | /trade | navigate | resolved | src/app/pages/cross-module/UnifiedPortfolioDashboard.tsx:266 | literal |
| /unified-portfolio | /wallet | navigate | resolved | src/app/pages/cross-module/UnifiedPortfolioDashboard.tsx:265 | literal |

### dca navigation (22)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /dca | /dca/backtester | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/dynamic-amount | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/dynamic-amount | navigate | resolved | src/app/pages/dca/DCAPage.tsx:372 | template-normalized |
| /dca | /dca/multi-asset | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/performance-compare | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/portfolio-optimizer | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/portfolio-optimizer | navigate | resolved | src/app/pages/dca/DCAPage.tsx:345 | template-normalized |
| /dca | /dca/rebalance/config | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/rebalance/config | navigate | resolved | src/app/pages/dca/DCAPage.tsx:399 | template-normalized |
| /dca | /dca/rebalance/config001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/schedule/config | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/schedule/config | navigate | resolved | src/app/pages/dca/DCAPage.tsx:426 | template-normalized |
| /dca | /dca/schedule/config001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | /dca/smart-rules | route-hierarchy | resolved | route tree/url hierarchy |  |
| /dca | BACK | navigate | resolved | src/app/pages/dca/DCAPage.tsx:279 | history |
| /dca | comment-only replace reference | navigate | resolved | src/app/pages/dca/DCAPage.tsx:107 | Source review: `replace` appears in deep-link documentation/commentary, not as an executable navigation edge. Flutter keeps only BACK and resolved DCA tool routes. |
| /dca/rebalance/config | /dca/rebalance/config001 | navigate | resolved | src/app/pages/dca/DCARebalanceConfig.tsx:594 | template-normalized |
| /dca/rebalance/config001 | /dca/rebalance/config001/edit | navigate | resolved | src/app/pages/dca/DCARebalanceDashboard.tsx:123 | template-normalized; raw=`${routePrefix}/dca/rebalance/${configId}/edit`; Flutter safe placeholder wired |
| /dca/rebalance/config001 | /dca/rebalance/config001/history | navigate | resolved | src/app/pages/dca/DCARebalanceDashboard.tsx:432 | template-normalized; raw=`${routePrefix}/dca/rebalance/${configId}/history`; Flutter safe placeholder wired |
| /dca/schedule/config | /dca/schedule/config001 | navigate | resolved | src/app/pages/dca/DCAScheduleConfig.tsx:133 | template-normalized |
| /dca/portfolio-optimizer | /dca/rebalance/config | navigate | resolved | src/app/pages/dca/DCAPortfolioOptimizer.tsx:1467 | template-normalized |
| /dca/dynamic-amount | /dca | navigate | resolved | src/app/pages/dca/DCADynamicAmount.tsx:1229 | template-normalized |

### dev navigation (4)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /dev/showcase | BACK | navigate | resolved | src/app/pages/v2/MissingScreensShowcasePage.tsx:226 | history |
| /dev/showcase | flow.fromRoute | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/v2/MissingScreensShowcasePage.tsx:200 | expression-not-absolute; raw=flow.fromRoute |
| /dev/showcase | page.route | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/v2/MissingScreensShowcasePage.tsx:166 | expression-not-absolute; raw=page.route |
| /dev/showcase | screen.route | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/v2/MissingScreensShowcasePage.tsx:77 | expression-not-absolute; raw=screen.route |

### discovery navigation (24)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /search | /arena | navigate | resolved | src/app/pages/discovery/UnifiedSearchPage.tsx:458 | template-normalized |
| /search | /arena/challenge/${room.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/discovery/UnifiedSearchPage.tsx:209 | dynamic-expression; raw=`${prefix}/arena/challenge/${room.id}` |
| /search | /arena/creator/cr001 | navigate | resolved | src/app/pages/discovery/UnifiedSearchPage.tsx:244 | template-normalized |
| /search | /arena/mode/mode001 | navigate | resolved | src/app/pages/discovery/UnifiedSearchPage.tsx:175 | template-normalized |
| /search | /market/btcusdt | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/discovery/UnifiedSearchPage.tsx:280 | template-normalized; raw=`${prefix}/market/${pair.id}` |
| /search | /markets/predictions | navigate | resolved | src/app/pages/discovery/UnifiedSearchPage.tsx:444 | template-normalized |
| /search | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/discovery/UnifiedSearchPage.tsx:144 | template-normalized |
| /search | /topics | navigate | resolved | src/app/pages/discovery/UnifiedSearchPage.tsx:472 | template-normalized |
| /topics | /arena | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:390 | template-normalized |
| /topics | /arena/challenge/${room.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/discovery/TopicHubPage.tsx:193 | dynamic-expression; raw=`${prefix}/arena/challenge/${room.id}` |
| /topics | /arena/creator/cr001 | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:262 | template-normalized |
| /topics | /arena/mode/mode001 | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:233 | template-normalized |
| /topics | /arena/studio | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:464 | template-normalized |
| /topics | /markets/predictions | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:358 | template-normalized |
| /topics | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:152 | template-normalized |
| /topics | /search | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:298 | template-normalized |
| /topic/crypto | /arena | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:390 | template-normalized |
| /topic/crypto | /arena/challenge/${room.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/discovery/TopicHubPage.tsx:193 | dynamic-expression; raw=`${prefix}/arena/challenge/${room.id}` |
| /topic/crypto | /arena/creator/cr001 | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:262 | template-normalized |
| /topic/crypto | /arena/mode/mode001 | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:233 | template-normalized |
| /topic/crypto | /arena/studio | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:464 | template-normalized |
| /topic/crypto | /markets/predictions | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:358 | template-normalized |
| /topic/crypto | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:152 | template-normalized |
| /topic/crypto | /search | navigate | resolved | src/app/pages/discovery/TopicHubPage.tsx:298 | template-normalized |

### earn navigation (149)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /earn | /earn/advanced-orders | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/api-documentation | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/audit-reports | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/auto-compound | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/calendar | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/community-governance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/contingency-plan | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/custody | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/dashboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/data-export | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/developer-console | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/emergency-actions | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/faq | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/forum | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/guide | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/institutional | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/insurance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/insurance-fund-transparency | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/liquid-staking | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/multi-chain | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/notifications | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/proof-of-reserves | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/proposals | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/recommendations | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/regulatory-framework | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/risk-dashboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/risk-score-calculator | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/savings | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/savings | navigate | resolved | src/app/pages/earn/StakingEarnPage.tsx:187 | template-normalized |
| /earn | /earn/slashing-history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/social-feed | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/staking | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/suitability-assessment | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/third-party-integrations | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/transaction-reporting | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/validator-health-monitor | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/validator-selection | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/voting | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn | /earn/webhooks | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/staking | /earn/savings | navigate | resolved | src/app/pages/earn/StakingEarnPage.tsx:187 | template-normalized |
| /earn/staking | /earn/staking/risk-assessment | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/staking | /earn/staking/risk-disclosure | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/staking | /earn/staking/tax-guide | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/staking | /earn/staking/terms | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/staking | /earn/staking/withdrawal-policy | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/analytics | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:798 | template-normalized |
| /earn/savings | /earn/savings/auto-compound | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/auto-compound | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:788 | template-normalized |
| /earn/savings | /earn/savings/autopilot | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/autopilot | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:814 | template-normalized |
| /earn/savings | /earn/savings/backtest | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/backtest | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:802 | template-normalized |
| /earn/savings | /earn/savings/comparison | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/comparison | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:786 | template-normalized |
| /earn/savings | /earn/savings/dca | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/dca | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:733 | template-normalized |
| /earn/savings | /earn/savings/dca | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:790 | template-normalized |
| /earn/savings | /earn/savings/export | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/export | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:778 | template-normalized |
| /earn/savings | /earn/savings/faq | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/faq | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:826 | template-normalized |
| /earn/savings | /earn/savings/goals | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/goals | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:812 | template-normalized |
| /earn/savings | /earn/savings/guide | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/guide | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:824 | template-normalized |
| /earn/savings | /earn/savings/history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/history | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:776 | template-normalized |
| /earn/savings | /earn/savings/ladder | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/ladder | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:804 | template-normalized |
| /earn/savings | /earn/savings/notification-preferences | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/notification-preferences | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:818 | template-normalized |
| /earn/savings | /earn/savings/notifications | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/notifications | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:828 | template-normalized |
| /earn/savings | /earn/savings/portfolio | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/portfolio | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:641 | template-normalized |
| /earn/savings | /earn/savings/portfolio | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:715 | template-normalized |
| /earn/savings | /earn/savings/portfolio | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:774 | template-normalized |
| /earn/savings | /earn/savings/product/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/product/sample | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:960 | template-normalized |
| /earn/savings | /earn/savings/rebalance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/rebalance | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:792 | template-normalized |
| /earn/savings | /earn/savings/receipt | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/recommendations | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/recommendations | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:697 | template-normalized |
| /earn/savings | /earn/savings/recommendations | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:784 | template-normalized |
| /earn/savings | /earn/savings/redeem/${pos.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsPage.tsx:1088 | dynamic-expression; raw=`${prefix}/earn/savings/redeem/${pos.id}` |
| /earn/savings | /earn/savings/redeem/${pos.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsPage.tsx:1100 | dynamic-expression; raw=`${prefix}/earn/savings/redeem/${pos.id}` |
| /earn/savings | /earn/savings/redeem/pos001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/risk-assessment | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/risk-assessment | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:816 | template-normalized |
| /earn/savings | /earn/savings/smart-suggestions | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/smart-suggestions | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:800 | template-normalized |
| /earn/savings | /earn/savings/whatif | route-hierarchy | resolved | route tree/url hierarchy |  |
| /earn/savings | /earn/savings/whatif | navigate | resolved | src/app/pages/earn/SavingsPage.tsx:806 | template-normalized |
| /earn/savings/product/sample | /earn/savings/receipt | navigate | resolved | src/app/pages/earn/SavingsProductDetailPage.tsx:121 | template-normalized |
| /earn/savings/product/sample | BACK | navigate | resolved | src/app/pages/earn/SavingsProductDetailPage.tsx:91 | history |
| /earn/savings/redeem/pos001 | /earn/savings/receipt | navigate | resolved | src/app/pages/earn/SavingsRedeemPage.tsx:99 | template-normalized |
| /earn/savings/redeem/pos001 | BACK | navigate | resolved | src/app/pages/earn/SavingsRedeemPage.tsx:63 | history |
| /earn/savings/receipt | /earn | navigate | resolved | src/app/pages/earn/SavingsReceiptPage.tsx:264 | template-normalized |
| /earn/savings/receipt | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsReceiptPage.tsx:76 | template-normalized |
| /earn/savings/receipt | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsReceiptPage.tsx:255 | template-normalized |
| /earn/savings/portfolio | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsPortfolioPage.tsx:327 | template-normalized |
| /earn/savings/portfolio | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsPortfolioPage.tsx:343 | template-normalized |
| /earn/savings/portfolio | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsPortfolioPage.tsx:1316 | template-normalized |
| /earn/savings/portfolio | /earn/savings/history | navigate | resolved | src/app/pages/earn/SavingsPortfolioPage.tsx:360 | template-normalized |
| /earn/savings/portfolio | /earn/savings/product/${evt.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsPortfolioPage.tsx:892 | dynamic-expression; raw=`${prefix}/earn/savings/product/${evt.id}` |
| /earn/savings/portfolio | /earn/savings/product/${pos.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsPortfolioPage.tsx:1251 | dynamic-expression; raw=`${prefix}/earn/savings/product/${pos.id}` |
| /earn/savings/portfolio | /earn/savings/redeem/${evt.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsPortfolioPage.tsx:704 | dynamic-expression; raw=`${prefix}/earn/savings/redeem/${evt.id}` |
| /earn/savings/portfolio | /earn/savings/redeem/${evt.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsPortfolioPage.tsx:911 | dynamic-expression; raw=`${prefix}/earn/savings/redeem/${evt.id}` |
| /earn/savings/portfolio | /earn/savings/redeem/${pos.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsPortfolioPage.tsx:1266 | dynamic-expression; raw=`${prefix}/earn/savings/redeem/${pos.id}` |
| /earn/savings/history | /earn/savings/receipt | navigate | resolved | src/app/pages/earn/SavingsHistoryPage.tsx:587 | template-normalized |
| /earn/savings/guide | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsGuidePage.tsx:463 | template-normalized |
| /earn/savings/faq | /support | navigate | resolved | src/app/pages/earn/SavingsFAQPage.tsx:383 | template-normalized |
| /earn/savings/recommendations | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsRecommendationsPage.tsx:355 | template-normalized |
| /earn/savings/recommendations | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsRecommendationsPage.tsx:688 | template-normalized |
| /earn/savings/recommendations | /earn/savings/risk-assessment | navigate | resolved | src/app/pages/earn/SavingsRecommendationsPage.tsx:496 | template-normalized |
| /earn/savings/recommendations | /earn/savings/risk-assessment | navigate | resolved | src/app/pages/earn/SavingsRecommendationsPage.tsx:681 | template-normalized |
| /earn/savings/risk-assessment | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsRiskAssessmentPage.tsx:352 | template-normalized |
| /earn/savings/risk-assessment | /earn/savings | navigate | resolved | src/app/pages/earn/SavingsRiskAssessmentPage.tsx:407 | template-normalized |
| /earn/savings/risk-assessment | /earn/savings/recommendations | navigate | resolved | src/app/pages/earn/SavingsRiskAssessmentPage.tsx:322 | template-normalized |
| /earn/savings/analytics | /earn/savings/product/${selectedProduct.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsAnalyticsPage.tsx:1120 | dynamic-expression; raw=`${prefix}/earn/savings/product/${selectedProduct.id}` |
| /earn/savings/smart-suggestions | ${sg.actionRoute} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsSmartSuggestionsPage.tsx:283 | expression-not-absolute; raw=`${prefix}${sg.actionRoute}` |
| /earn/savings/backtest | /earn/savings/recommendations | navigate | resolved | src/app/pages/earn/SavingsBacktestPage.tsx:704 | template-normalized |
| /earn/savings/autopilot | ${mod.route} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/SavingsAutoPilotPage.tsx:543 | expression-not-absolute; raw=`${prefix}${mod.route}` |
| /earn/staking/risk-disclosure | /earn/risk-assessment | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/earn/StakingRiskDisclosurePage.tsx:466 | template-normalized; raw=`${prefix}/earn/risk-assessment` |
| /earn/staking/tax-guide | /earn/history | navigate | resolved | src/app/pages/earn/StakingTaxGuidePage.tsx:214 | template-normalized |
| /earn/staking/tax-guide | /tax-reports | navigate | resolved | src/app/pages/earn/StakingTaxGuidePage.tsx:228 | template-normalized |
| /earn/staking/risk-assessment | /earn/staking | navigate | resolved | src/app/pages/earn/StakingRiskAssessmentPage.tsx:282 | template-normalized |
| /earn/dashboard | /earn/analytics | navigate | resolved | src/app/pages/earn/StakingDashboardPage.tsx:393 | template-normalized |
| /earn/dashboard | /earn/calendar | navigate | resolved | src/app/pages/earn/StakingDashboardPage.tsx:423 | template-normalized |
| /earn/dashboard | /earn/calendar | navigate | resolved | src/app/pages/earn/StakingDashboardPage.tsx:453 | template-normalized |
| /earn/dashboard | /earn/history | navigate | resolved | src/app/pages/earn/StakingDashboardPage.tsx:406 | template-normalized |
| /earn/dashboard | /earn/staking | navigate | resolved | src/app/pages/earn/StakingDashboardPage.tsx:386 | template-normalized |
| /earn/multi-chain | /earn/dashboard | navigate | resolved | src/app/pages/earn/StakingMultiChainPage.tsx:157 | literal |
| /earn/risk-dashboard | /earn/audit-reports | navigate | resolved | src/app/pages/earn/StakingRiskDashboardPage.tsx:190 | literal |
| /earn/risk-dashboard | /earn/contingency-plan | navigate | resolved | src/app/pages/earn/StakingRiskDashboardPage.tsx:360 | literal |
| /earn/risk-dashboard | /earn/emergency-actions | navigate | resolved | src/app/pages/earn/StakingRiskDashboardPage.tsx:346 | literal |
| /earn/risk-dashboard | /earn/insurance | navigate | resolved | src/app/pages/earn/StakingRiskDashboardPage.tsx:367 | literal |
| /earn/risk-dashboard | /earn/risk-score-calculator | navigate | resolved | src/app/pages/earn/StakingRiskDashboardPage.tsx:353 | literal |
| /earn/risk-dashboard | /earn/slashing-history | navigate | resolved | src/app/pages/earn/StakingRiskDashboardPage.tsx:189 | literal |
| /earn/risk-dashboard | /earn/validator-health-monitor | navigate | resolved | src/app/pages/earn/StakingRiskDashboardPage.tsx:188 | literal |
| /earn/community-governance | /earn/forum | navigate | resolved | src/app/pages/earn/StakingCommunityGovernancePage.tsx:191 | literal |
| /earn/community-governance | /earn/proposals | navigate | resolved | src/app/pages/earn/StakingCommunityGovernancePage.tsx:87 | literal |
| /earn/community-governance | /earn/proposals | navigate | resolved | src/app/pages/earn/StakingCommunityGovernancePage.tsx:185 | literal |
| /earn/proposals | /earn/voting/prop001 | navigate | resolved | src/app/pages/earn/StakingProposalsPage.tsx:31 | template-normalized |
| /earn/voting | /earn/voting/prop001 | route-hierarchy | resolved | route tree/url hierarchy |  |

### enterprise-states navigation (4)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /enterprise-states | /auth/login | navigate | resolved | src/app/pages/dev/EnterpriseStatesPage.tsx:522 | template-normalized |
| /enterprise-states | /markets | navigate | resolved | src/app/pages/dev/EnterpriseStatesPage.tsx:86 | template-normalized |
| /enterprise-states | /profile/kyc | navigate | resolved | src/app/pages/dev/EnterpriseStatesPage.tsx:131 | template-normalized |
| /enterprise-states | ${activeOverlay === 'kyc' ? '/profile/kyc' : '/profile/security'} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/dev/EnterpriseStatesPage.tsx:514 | expression-not-absolute; raw=`${prefix}${activeOverlay === 'kyc' ? '/profile/kyc' : '/profile/security'}` |

### home navigation (64)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /home | /admin | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /arena | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /auth/2fa-setup | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /auth/forgot-password | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /auth/login | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /auth/otp | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /auth/register | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /auth/reset-password | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /cross-module-analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /dca | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /dca | navigate | resolved | src/app/pages/market/HomePage.tsx:261 | template-normalized |
| /home | /demo/copy-card | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /dev/dca-overview | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /dev/design-system | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /dev/performance-monitor | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /dev/route-checker | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /dev/showcase | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /earn | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /earn/savings | navigate | resolved | src/app/pages/market/HomePage.tsx:264 | template-normalized |
| /home | /earn/staking | navigate | resolved | src/app/pages/market/HomePage.tsx:260 | template-normalized |
| /home | /enterprise-states | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /launchpad | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /launchpad | navigate | resolved | src/app/pages/market/HomePage.tsx:259 | template-normalized |
| /home | /markets | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /markets | navigate | resolved | src/app/pages/market/HomePage.tsx:438 | template-normalized |
| /home | /markets | navigate | resolved | src/app/pages/market/HomePage.tsx:532 | template-normalized |
| /home | /markets | navigate | resolved | src/app/pages/market/HomePage.tsx:585 | template-normalized |
| /home | /markets | navigate | resolved | src/app/pages/market/HomePage.tsx:637 | template-normalized |
| /home | /news | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /notifications | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /notifications | navigate | resolved | src/app/pages/market/HomePage.tsx:403 | template-normalized |
| /home | /onboarding | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /p2p | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /p2p | navigate | resolved | src/app/pages/market/HomePage.tsx:258 | template-normalized |
| /home | /pair/btcusdt | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /pair/btcusdt | navigate | resolved | src/app/pages/market/HomePage.tsx:470 | template-normalized |
| /home | /pair/btcusdt | navigate | resolved | src/app/pages/market/HomePage.tsx:540 | template-normalized |
| /home | /pair/btcusdt | navigate | resolved | src/app/pages/market/HomePage.tsx:591 | template-normalized |
| /home | /pair/btcusdt | navigate | resolved | src/app/pages/market/HomePage.tsx:643 | template-normalized |
| /home | /profile | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /referral | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /referral | navigate | resolved | src/app/pages/market/HomePage.tsx:267 | template-normalized |
| /home | /rewards | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /rewards | navigate | resolved | src/app/pages/market/HomePage.tsx:265 | template-normalized |
| /home | /search | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /search | navigate | resolved | src/app/pages/market/HomePage.tsx:395 | template-normalized |
| /home | /smart-alerts | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /support | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /tax-reports | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /topic/crypto | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /topics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /topics | navigate | resolved | src/app/pages/market/HomePage.tsx:255 | template-normalized |
| /home | /trade | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /trade/bots | navigate | resolved | src/app/pages/market/HomePage.tsx:262 | template-normalized |
| /home | /trade/btcusdt | navigate | resolved | src/app/pages/market/HomePage.tsx:256 | template-normalized |
| /home | /trade/convert | navigate | resolved | src/app/pages/market/HomePage.tsx:257 | template-normalized |
| /home | /trade/copy-trading | navigate | resolved | src/app/pages/market/HomePage.tsx:263 | template-normalized |
| /home | /trade/margin | navigate | resolved | src/app/pages/market/HomePage.tsx:266 | template-normalized |
| /home | /unified-portfolio | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /wallet | route-hierarchy | resolved | route tree/url hierarchy |  |
| /home | /wallet | navigate | resolved | src/app/pages/market/HomePage.tsx:228 | template-normalized |
| /home | /wallet/deposit/USDT | navigate | resolved | src/app/pages/market/HomePage.tsx:195 | template-normalized |
| /home | /wallet/withdraw/USDT | navigate | resolved | src/app/pages/market/HomePage.tsx:211 | template-normalized |
| /home | route | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/market/HomePage.tsx:686 | expression-not-absolute; raw=route |

### launchpad navigation (54)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /launchpad | /launchpad/${project.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadPage.tsx:280 | dynamic-expression; raw=`${prefix}/launchpad/${project.id}` |
| /launchpad | /launchpad/abi-diff/contract001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/address-book | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/batch-claim | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/bridge-compare | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/bridge-order/tx001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/claim-receipt/pos001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/contract/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/dca-builder | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/event-log | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/gas-tracker | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/idobridge/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/limit-orders | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/multisig | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/notif-sound | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/performance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/performance | navigate | resolved | src/app/pages/launchpad/LaunchpadPage.tsx:154 | template-normalized |
| /launchpad | /launchpad/portfolio | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/portfolio | navigate | resolved | src/app/pages/launchpad/LaunchpadPage.tsx:161 | template-normalized |
| /launchpad | /launchpad/rebalance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/receipt/new | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadPage.tsx:86 | template-normalized; raw=`${prefix}/launchpad/receipt/new` |
| /launchpad | /launchpad/receipt/sub001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/risk-analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/staking | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/staking | navigate | resolved | src/app/pages/launchpad/LaunchpadPage.tsx:287 | template-normalized |
| /launchpad | /launchpad/swap-aggregator | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | /launchpad/webhooks | route-hierarchy | resolved | route tree/url hierarchy |  |
| /launchpad | tool.route | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadPage.tsx:315 | expression-not-absolute; raw=tool.route |
| /launchpad | tool.route | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadPage.tsx:341 | expression-not-absolute; raw=tool.route |
| /launchpad/portfolio | /launchpad | navigate | resolved | src/app/pages/launchpad/LaunchpadPortfolioPage.tsx:135 | template-normalized |
| /launchpad/portfolio | /launchpad/receipt/sub001 | navigate | resolved | src/app/pages/launchpad/LaunchpadPortfolioPage.tsx:181 | template-normalized |
| /launchpad/staking | /launchpad/${pool.projectId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadStakingPage.tsx:184 | dynamic-expression; raw=`${prefix}/launchpad/${pool.projectId}` |
| /launchpad/staking | /launchpad/batch-claim | navigate | resolved | src/app/pages/launchpad/LaunchpadStakingPage.tsx:211 | template-normalized |
| /launchpad/staking | /launchpad/claim-receipt/pos001 | navigate | resolved | src/app/pages/launchpad/LaunchpadStakingPage.tsx:462 | template-normalized |
| /launchpad/idobridge/sample | /launchpad/${project.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadIDOBridgePage.tsx:511 | dynamic-expression; raw=`${prefix}/launchpad/${project.id}` |
| /launchpad/idobridge/sample | /launchpad/bridge-compare | navigate | resolved | src/app/pages/launchpad/LaunchpadIDOBridgePage.tsx:281 | template-normalized |
| /launchpad/idobridge/sample | /launchpad/bridge-order/${record.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadIDOBridgePage.tsx:504 | dynamic-expression; raw=`${prefix}/launchpad/bridge-order/${record.id}` |
| /launchpad/idobridge/sample | /launchpad/bridge-order/tx001 | navigate | resolved | src/app/pages/launchpad/LaunchpadIDOBridgePage.tsx:793 | template-normalized |
| /launchpad/contract/sample | /launchpad/abi-diff/${encodeURIComponent(contractAddress)} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadContractPage.tsx:909 | dynamic-expression; raw=`${prefix}/launchpad/abi-diff/${encodeURIComponent(contractAddress)}` |
| /launchpad/receipt/sub001 | /launchpad | navigate | resolved | src/app/pages/launchpad/LaunchpadReceiptPage.tsx:166 | template-normalized |
| /launchpad/receipt/sub001 | /launchpad/portfolio | navigate | resolved | src/app/pages/launchpad/LaunchpadReceiptPage.tsx:162 | template-normalized |
| /launchpad/bridge-order/tx001 | /launchpad/${bridgeTx.projectId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadBridgeOrderPage.tsx:653 | dynamic-expression; raw=`${prefix}/launchpad/${bridgeTx.projectId}` |
| /launchpad/bridge-order/tx001 | BACK | navigate | resolved | src/app/pages/launchpad/LaunchpadBridgeOrderPage.tsx:638 | history |
| /launchpad/bridge-order/tx001 | BACK | navigate | resolved | src/app/pages/launchpad/LaunchpadBridgeOrderPage.tsx:658 | history |
| /launchpad/batch-claim | /launchpad/claim-receipt/${pos.positionId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadBatchClaimPage.tsx:196 | dynamic-expression; raw=`${prefix}/launchpad/claim-receipt/${pos.positionId}` |
| /launchpad/batch-claim | /launchpad/staking | navigate | resolved | src/app/pages/launchpad/LaunchpadBatchClaimPage.tsx:103 | template-normalized |
| /launchpad/batch-claim | /launchpad/staking | navigate | resolved | src/app/pages/launchpad/LaunchpadBatchClaimPage.tsx:499 | template-normalized |
| /launchpad/batch-claim | BACK | navigate | resolved | src/app/pages/launchpad/LaunchpadBatchClaimPage.tsx:504 | history |
| /launchpad/bridge-compare | /launchpad/bridge-order/batch_${Date.now()} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadBridgeComparePage.tsx:104 | dynamic-expression; raw=`${prefix}/launchpad/bridge-order/batch_${Date.now()}` |
| /launchpad/sample | /launchpad/contract/${project.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadDetailPage.tsx:204 | dynamic-expression; raw=`${prefix}/launchpad/contract/${project.id}` |
| /launchpad/sample | /launchpad/idobridge/${project.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadDetailPage.tsx:197 | dynamic-expression; raw=`${prefix}/launchpad/idobridge/${project.id}` |
| /launchpad/sample | /launchpad/receipt/new | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/launchpad/LaunchpadDetailPage.tsx:95 | template-normalized; raw=`${prefix}/launchpad/receipt/new` |
| /launchpad/sample | /launchpad/staking | navigate | resolved | src/app/pages/launchpad/LaunchpadDetailPage.tsx:189 | template-normalized |

### markets navigation (53)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /markets | /markets/${tool.route} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/market/MarketListPage.tsx:226 | dynamic-expression; raw=`${routePrefix}/markets/${tool.route}` |
| /markets | /markets/advanced-charts | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/alerts | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/calendar | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/compare | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/correlations | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/depth | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/derivatives | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/heatmap | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/movers | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/movers | navigate | resolved | src/app/pages/market/MarketListPage.tsx:103 | template-normalized |
| /markets | /markets/news | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/overview | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/overview | navigate | resolved | src/app/pages/market/MarketListPage.tsx:95 | template-normalized |
| /markets | /markets/portfolio-tracker | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/predictions | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/screener | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/sectors | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/sectors | navigate | resolved | src/app/pages/market/MarketListPage.tsx:111 | template-normalized |
| /markets | /markets/signals | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/social-sentiment | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/unlocks | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets | /markets/watchlist | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/overview | /markets/${item.path} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/markets/MarketOverviewPage.tsx:377 | dynamic-expression; raw=`${prefix}/markets/${item.path}` |
| /markets/overview | /markets/${item.path} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/markets/MarketOverviewPage.tsx:502 | dynamic-expression; raw=`${prefix}/markets/${item.path}` |
| /markets/overview | /markets/movers | navigate | resolved | src/app/pages/markets/MarketOverviewPage.tsx:397 | template-normalized |
| /markets/overview | /markets/movers | navigate | resolved | src/app/pages/markets/MarketOverviewPage.tsx:415 | template-normalized |
| /markets/overview | /markets/sectors | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/markets/MarketOverviewPage.tsx:438 | dynamic-expression; raw=`${prefix}/markets/sectors?id=${sector.id}` |
| /markets/overview | /markets/sectors | navigate | resolved | src/app/pages/markets/MarketOverviewPage.tsx:443 | template-normalized |
| /markets/movers | /pair/btcusdt | navigate | resolved | src/app/pages/markets/MarketMoversPage.tsx:297 | template-normalized |
| /markets/sectors | /pair/${coin.id}usdt | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/markets/MarketSectorsPage.tsx:225 | dynamic-expression; raw=`${prefix}/pair/${coin.id}usdt` |
| /markets/sectors | /pair/${data.id}usdt | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/markets/MarketSectorsPage.tsx:282 | dynamic-expression; raw=`${prefix}/pair/${data.id}usdt` |
| /markets/watchlist | /markets | navigate | resolved | src/app/pages/markets/WatchlistPage.tsx:66 | template-normalized |
| /markets/watchlist | /markets | navigate | resolved | src/app/pages/markets/WatchlistPage.tsx:90 | template-normalized |
| /markets/watchlist | /pair/btcusdt | navigate | resolved | src/app/pages/markets/WatchlistPage.tsx:108 | template-normalized |
| /markets/watchlist | /pair/btcusdt | navigate | resolved | src/app/pages/markets/WatchlistPage.tsx:118 | template-normalized |
| /markets/watchlist | /trade/btcusdt | navigate | resolved | src/app/pages/markets/WatchlistPage.tsx:177 | template-normalized |
| /markets/heatmap | /pair/${selected.id}usdt | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/market/MarketHeatmapPage.tsx:184 | dynamic-expression; raw=`${prefix}/pair/${selected.id}usdt` |
| /markets/screener | /pair/btcusdt | navigate | resolved | src/app/pages/markets/MarketScreenerPage.tsx:351 | template-normalized |
| /markets/portfolio-tracker | /pair/${holding.id}usdt | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/markets/PortfolioTrackerPage.tsx:153 | dynamic-expression; raw=`${prefix}/pair/${holding.id}usdt` |
| /markets/portfolio-tracker | /pair/${holding.id}usdt | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/markets/PortfolioTrackerPage.tsx:239 | dynamic-expression; raw=`${prefix}/pair/${holding.id}usdt` |
| /markets/news | /pair/btcusdt | navigate | resolved | src/app/pages/markets/MarketNewsPage.tsx:174 | template-normalized |
| /pair/btcusdt | /dca | navigate | resolved | src/app/pages/market/PairDetailPage.tsx:94 | template-normalized |
| /pair/btcusdt | /markets | navigate | resolved | src/app/pages/market/PairDetailPage.tsx:134 | template-normalized |
| /pair/btcusdt | /pair/btcusdt/depth | route-hierarchy | resolved | route tree/url hierarchy |  |
| /pair/btcusdt | /pair/btcusdt/depth | navigate | resolved | src/app/pages/market/PairDetailPage.tsx:331 | template-normalized |
| /pair/btcusdt | /pair/btcusdt/info | route-hierarchy | resolved | route tree/url hierarchy |  |
| /pair/btcusdt | /pair/btcusdt/info | navigate | resolved | src/app/pages/market/PairDetailPage.tsx:307 | template-normalized |
| /pair/btcusdt | /trade/advanced-chart/btcusdt | navigate | resolved | src/app/pages/market/PairDetailPage.tsx:238 | template-normalized |
| /pair/btcusdt | /trade/btcusdt | navigate | resolved | src/app/pages/market/PairDetailPage.tsx:356 | template-normalized |
| /pair/btcusdt | /trade/btcusdt | navigate | resolved | src/app/pages/market/PairDetailPage.tsx:362 | template-normalized |
| /pair/btcusdt/info | /pair/btcusdt | navigate | resolved | src/app/pages/markets/TokenInfoPage.tsx:199 | template-normalized |
| /pair/btcusdt/info | /pair/btcusdt | navigate | resolved | src/app/pages/markets/TokenInfoPage.tsx:390 | template-normalized |

### notifications navigation (1)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /notifications | notif.actionUrl | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/notifications/NotificationsPage.tsx:48 | expression-not-absolute; raw=notif.actionUrl |

### onboarding navigation (2)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /onboarding | /home | navigate | resolved | src/app/pages/onboarding/OnboardingFlow.tsx:118 | literal |
| /onboarding | route | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/onboarding/OnboardingFlow.tsx:132 | expression-not-absolute; raw=route |

### p2p navigation (209)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /p2p/express/confirm | /p2p/order/p2p001 | navigate | resolved | src/app/pages/p2p/P2PExpressConfirmPage.tsx:44 | template-normalized |
| /p2p/express/confirm | BACK | navigate | resolved | src/app/pages/p2p/P2PExpressConfirmPage.tsx:140 | history |
| /p2p/express | /p2p | navigate | resolved | src/app/pages/p2p/P2PExpressPage.tsx:146 | template-normalized |
| /p2p/express | /p2p | navigate | resolved | src/app/pages/p2p/P2PExpressPage.tsx:515 | template-normalized |
| /p2p/express | /p2p/express/confirm | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/express | /p2p/express/confirm | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PExpressPage.tsx:590 | dynamic-expression; raw=`${prefix}/p2p/express/confirm?${params.toString()}` |
| /p2p/express | /p2p/merchant/${bestAd.merchantId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PExpressPage.tsx:460 | dynamic-expression; raw=`${prefix}/p2p/merchant/${bestAd.merchantId}` |
| /p2p/order/rate/p2p001 | /p2p | navigate | resolved | src/app/pages/p2p/P2POrderRatePage.tsx:64 | template-normalized |
| /p2p/order/rate/p2p001 | BACK | navigate | resolved | src/app/pages/p2p/P2POrderRatePage.tsx:155 | history |
| /p2p/order/cancel/p2p001 | /p2p/order/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderCancelPage.tsx:40 | template-normalized |
| /p2p/order/cancel/p2p001 | BACK | navigate | resolved | src/app/pages/p2p/P2POrderCancelPage.tsx:119 | history |
| /p2p/order/proof/p2p001 | BACK | navigate | resolved | src/app/pages/p2p/P2POrderProofPage.tsx:42 | history |
| /p2p/order/p2p001 | /p2p | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:907 | template-normalized |
| /p2p/order/p2p001 | /p2p | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:912 | template-normalized |
| /p2p/order/p2p001 | /p2p/blacklist | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:968 | template-normalized |
| /p2p/order/p2p001 | /p2p/chat/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:892 | template-normalized |
| /p2p/order/p2p001 | /p2p/dispute/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:926 | template-normalized |
| /p2p/order/p2p001 | /p2p/dispute/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:936 | template-normalized |
| /p2p/order/p2p001 | /p2p/escrow/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:587 | template-normalized |
| /p2p/order/p2p001 | /p2p/guide | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:976 | template-normalized |
| /p2p/order/p2p001 | /p2p/merchant/${order.merchantId \|\| 'mc001'} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2POrderPage.tsx:960 | dynamic-expression; raw=`${prefix}/p2p/merchant/${order.merchantId \|\| 'mc001'}` |
| /p2p/order/p2p001 | /p2p/order/cancel/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:920 | template-normalized |
| /p2p/order/p2p001 | /p2p/order/proof/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:823 | template-normalized |
| /p2p/order/p2p001 | /p2p/order/rate/p2p001 | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:354 | template-normalized |
| /p2p/order/p2p001 | /support/help | navigate | resolved | src/app/pages/p2p/P2POrderPage.tsx:984 | template-normalized |
| /p2p/chat/p2p001 | /p2p/e2e-info | navigate | resolved | src/app/pages/p2p/P2PChatPage.tsx:121 | template-normalized |
| /p2p/chat/p2p001 | /p2p/e2e-info | navigate | resolved | src/app/pages/p2p/P2PChatPage.tsx:181 | template-normalized |
| /p2p/chat/p2p001 | /p2p/e2e-info | navigate | resolved | src/app/pages/p2p/P2PChatPage.tsx:217 | template-normalized |
| /p2p/chat/p2p001 | /p2p/order/p2p001 | navigate | resolved | src/app/pages/p2p/P2PChatPage.tsx:154 | template-normalized |
| /p2p/dispute/detail/sample | /p2p/dispute/evidence/${dispute.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PDisputeDetailPage.tsx:420 | dynamic-expression; raw=`${prefix}/p2p/dispute/evidence/${dispute.id}` |
| /p2p/dispute/detail/sample | /p2p/dispute/resolution/${dispute.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PDisputeDetailPage.tsx:447 | dynamic-expression; raw=`${prefix}/p2p/dispute/resolution/${dispute.id}` |
| /p2p/dispute/detail/sample | /p2p/disputes | navigate | resolved | src/app/pages/p2p/P2PDisputeDetailPage.tsx:474 | template-normalized |
| /p2p/dispute/evidence/sample | /p2p/dispute/detail/sample | navigate | resolved | src/app/pages/p2p/P2PDisputeEvidencePage.tsx:78 | template-normalized |
| /p2p/dispute/resolution/sample | /p2p/disputes | navigate | resolved | src/app/pages/p2p/P2PDisputeResolutionPage.tsx:110 | template-normalized |
| /p2p/dispute/p2p001 | /p2p/dispute/detail/sample | navigate | resolved | src/app/pages/p2p/P2PDisputePage.tsx:50 | template-normalized |
| /p2p/disputes | /p2p/dispute/detail/${dispute.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PDisputesPage.tsx:115 | dynamic-expression; raw=`${prefix}/p2p/dispute/detail/${dispute.id}` |
| /p2p/ad/sample | /p2p/merchant/${ad.merchantId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PAdDetailPage.tsx:174 | dynamic-expression; raw=`${prefix}/p2p/merchant/${ad.merchantId}` |
| /p2p/ad/sample | /p2p/order/p2p001 | navigate | resolved | src/app/pages/p2p/P2PAdDetailPage.tsx:143 | template-normalized |
| /p2p/my-ads | /p2p/ad-analytics/sample | navigate | resolved | src/app/pages/p2p/P2PMyAdsPage.tsx:187 | template-normalized |
| /p2p/my-ads | /p2p/create | navigate | resolved | src/app/pages/p2p/P2PMyAdsPage.tsx:59 | template-normalized |
| /p2p/my-ads | /p2p/create | navigate | resolved | src/app/pages/p2p/P2PMyAdsPage.tsx:108 | template-normalized |
| /p2p/my-ads | /p2p/create | navigate | resolved | src/app/pages/p2p/P2PMyAdsPage.tsx:198 | template-normalized |
| /p2p/my-ads | link.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PMyAdsPage.tsx:226 | expression-not-absolute; raw=link.path |
| /p2p/create | /p2p/my-ads | navigate | resolved | src/app/pages/p2p/P2PCreateAdPage.tsx:89 | template-normalized |
| /p2p/merchant-apply | /p2p | navigate | resolved | src/app/pages/p2p/P2PMerchantApplyPage.tsx:182 | template-normalized |
| /p2p/merchant/mc001 | /p2p/ad/sample | navigate | resolved | src/app/pages/p2p/P2PMerchantProfilePage.tsx:189 | template-normalized |
| /p2p/merchant/mc001 | /p2p/blacklist/add | navigate | resolved | src/app/pages/p2p/P2PMerchantProfilePage.tsx:249 | template-normalized |
| /p2p/merchant/mc001 | /p2p/report/mc001 | navigate | resolved | src/app/pages/p2p/P2PMerchantProfilePage.tsx:93 | template-normalized |
| /p2p/report/mc001 | /p2p/blacklist/add | navigate | resolved | src/app/pages/p2p/P2PReportMerchantPage.tsx:74 | template-normalized |
| /p2p/report/mc001 | /p2p/merchant/mc001 | navigate | resolved | src/app/pages/p2p/P2PReportMerchantPage.tsx:87 | template-normalized |
| /p2p/report/mc001 | BACK | navigate | resolved | src/app/pages/p2p/P2PReportMerchantPage.tsx:50 | history |
| /p2p/payment-method/add | /p2p/payment-methods | navigate | resolved | src/app/pages/p2p/P2PPaymentMethodAddPage.tsx:41 | template-normalized |
| /p2p/payment-method/verification/sample | /p2p/payment-methods | navigate | resolved | src/app/pages/p2p/P2PPaymentMethodVerificationPage.tsx:70 | template-normalized |
| /p2p/payment-method/ownership/sample | /p2p/payment-methods | navigate | resolved | src/app/pages/p2p/P2PPaymentMethodOwnershipPage.tsx:54 | template-normalized |
| /p2p/payment-methods | /p2p/payment-method/add | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PPaymentMethodsPage.tsx:62 | dynamic-expression; raw=`${prefix}/p2p/payment-method/add?type=${pm.type}` |
| /p2p/payment-methods | /p2p/payment-method/add | navigate | resolved | src/app/pages/p2p/P2PPaymentMethodsPage.tsx:96 | template-normalized |
| /p2p/payment-methods | /p2p/payment-method/add | navigate | resolved | src/app/pages/p2p/P2PPaymentMethodsPage.tsx:101 | template-normalized |
| /p2p/insurance | /p2p/disputes | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:634 | template-normalized |
| /p2p/insurance | /p2p/fraud-prevention | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:557 | template-normalized |
| /p2p/insurance | /p2p/insurance/certificate | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/insurance | /p2p/insurance/certificate | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:586 | template-normalized |
| /p2p/insurance | /p2p/insurance/claim/${claimId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PInsuranceFundPage.tsx:285 | dynamic-expression; raw=`${prefix}/p2p/insurance/claim/${claimId}` |
| /p2p/insurance | /p2p/insurance/claim/${existingClaim.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PInsuranceFundPage.tsx:1759 | dynamic-expression; raw=`${prefix}/p2p/insurance/claim/${existingClaim.id}` |
| /p2p/insurance | /p2p/insurance/claim/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/insurance | /p2p/insurance/contribution-history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/insurance | /p2p/insurance/contribution-history | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:494 | template-normalized |
| /p2p/insurance | /p2p/insurance/policy | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/insurance | /p2p/insurance/policy | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:1682 | template-normalized |
| /p2p/insurance | /p2p/insurance/policy | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:1689 | template-normalized |
| /p2p/insurance | /p2p/insurance/score | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/insurance | /p2p/insurance/score | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:525 | template-normalized |
| /p2p/insurance/score | /p2p | navigate | resolved | src/app/pages/p2p/P2PInsuranceScorePage.tsx:322 | template-normalized |
| /p2p/insurance/score | /profile/settings | navigate | resolved | src/app/pages/p2p/P2PInsuranceScorePage.tsx:310 | template-normalized |
| /p2p/insurance/score | /profile/settings | navigate | resolved | src/app/pages/p2p/P2PInsuranceScorePage.tsx:316 | template-normalized |
| /p2p/insurance/claim/sample | /p2p/order/${claim.orderId.replace('P2P-', '')} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PClaimDetailPage.tsx:817 | dynamic-expression; raw=`${prefix}/p2p/order/${claim.orderId.replace('P2P-', '')}` |
| /p2p/insurance/claim/sample | BACK | navigate | resolved | src/app/pages/p2p/P2PClaimDetailPage.tsx:372 | history |
| /p2p/insurance-fund | /p2p/disputes | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:634 | template-normalized |
| /p2p/insurance-fund | /p2p/fraud-prevention | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:557 | template-normalized |
| /p2p/insurance-fund | /p2p/insurance/certificate | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:586 | template-normalized |
| /p2p/insurance-fund | /p2p/insurance/claim/${claimId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PInsuranceFundPage.tsx:285 | dynamic-expression; raw=`${prefix}/p2p/insurance/claim/${claimId}` |
| /p2p/insurance-fund | /p2p/insurance/claim/${existingClaim.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PInsuranceFundPage.tsx:1759 | dynamic-expression; raw=`${prefix}/p2p/insurance/claim/${existingClaim.id}` |
| /p2p/insurance-fund | /p2p/insurance/contribution-history | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:494 | template-normalized |
| /p2p/insurance-fund | /p2p/insurance/policy | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:1682 | template-normalized |
| /p2p/insurance-fund | /p2p/insurance/policy | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:1689 | template-normalized |
| /p2p/insurance-fund | /p2p/insurance/score | navigate | resolved | src/app/pages/p2p/P2PInsuranceFundPage.tsx:525 | template-normalized |
| /p2p/escrow/balance | /p2p/orders/${order.orderId.replace('#P2P-', '')} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PEscrowBalancePage.tsx:154 | dynamic-expression; raw=`${prefix}/p2p/orders/${order.orderId.replace('#P2P-', '')}` |
| /p2p/escrow/p2p001 | /p2p/order/p2p001 | navigate | resolved | src/app/pages/p2p/P2PEscrowDetailPage.tsx:591 | template-normalized |
| /p2p/kyc/requirements | /p2p/kyc/verify?tier=${tierId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PKYCRequirementsPage.tsx:335 | dynamic-expression; raw=`${prefix}/p2p/kyc/verify?tier=${tierId}` |
| /p2p/kyc/requirements | /support | navigate | resolved | src/app/pages/p2p/P2PKYCRequirementsPage.tsx:412 | template-normalized |
| /p2p/kyc/status | /support | navigate | resolved | src/app/pages/p2p/P2PKYCStatusPage.tsx:437 | template-normalized |
| /p2p/kyc/status | ${step.action!.path} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PKYCStatusPage.tsx:235 | expression-not-absolute; raw=`${prefix}${step.action!.path}` |
| /p2p/kyc/identity | /p2p/kyc/face-match | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PIdentityVerificationPage.tsx:193 | template-normalized; raw=`${prefix}/p2p/kyc/face-match` |
| /p2p/kyc/address | /p2p/kyc/status | navigate | resolved | src/app/pages/p2p/P2PAddressProofPage.tsx:174 | template-normalized |
| /p2p/kyc/selfie | /p2p/kyc/status | navigate | resolved | src/app/pages/p2p/P2PSelfieVerificationPage.tsx:166 | template-normalized |
| /p2p/kyc/selfie | /support | navigate | resolved | src/app/pages/p2p/P2PSelfieVerificationPage.tsx:527 | template-normalized |
| /p2p/kyc/video | /p2p/kyc/status | navigate | resolved | src/app/pages/p2p/P2PVideoVerificationPage.tsx:43 | template-normalized |
| /p2p/security/center | /p2p/security/login-history | navigate | resolved | src/app/pages/p2p/P2PSecurityCenterPage.tsx:474 | template-normalized |
| /p2p/security/center | ${action.path} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PSecurityCenterPage.tsx:407 | expression-not-absolute; raw=`${prefix}${action.path}` |
| /p2p/security/center | ${metric.path} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PSecurityCenterPage.tsx:323 | expression-not-absolute; raw=`${prefix}${metric.path}` |
| /p2p/fraud-prevention | /p2p/insurance-fund | navigate | resolved | src/app/pages/p2p/P2PFraudPreventionPage.tsx:480 | template-normalized |
| /p2p/fraud-prevention | /support | navigate | resolved | src/app/pages/p2p/P2PFraudPreventionPage.tsx:494 | template-normalized |
| /p2p/wallet/transfer | /p2p/wallet | navigate | resolved | src/app/pages/p2p/P2PWalletTransferPage.tsx:104 | template-normalized |
| /p2p/wallet | /p2p/escrow/balance | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PWalletPage.tsx:260 | dynamic-expression; raw=`${prefix}/p2p/escrow/balance?asset=${balance.asset}` |
| /p2p/wallet | /p2p/wallet/fund-lock-history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/wallet | /p2p/wallet/history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/wallet | /p2p/wallet/history | navigate | resolved | src/app/pages/p2p/P2PWalletPage.tsx:348 | template-normalized |
| /p2p/wallet | /p2p/wallet/history | navigate | resolved | src/app/pages/p2p/P2PWalletPage.tsx:468 | template-normalized |
| /p2p/wallet | /p2p/wallet/transfer | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/wallet | /p2p/wallet/transfer | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PWalletPage.tsx:233 | dynamic-expression; raw=`${prefix}/p2p/wallet/transfer?asset=${balance.asset}&type=deposit` |
| /p2p/wallet | /p2p/wallet/transfer | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PWalletPage.tsx:245 | dynamic-expression; raw=`${prefix}/p2p/wallet/transfer?asset=${balance.asset}&type=withdraw` |
| /p2p/wallet | /p2p/wallet/transfer | navigate | resolved | src/app/pages/p2p/P2PWalletPage.tsx:405 | template-normalized |
| /p2p/wallet | /p2p/wallet/transfer | navigate | resolved | src/app/pages/p2p/P2PWalletPage.tsx:416 | template-normalized |
| /p2p/limits | /p2p/kyc/requirements | navigate | resolved | src/app/pages/p2p/P2PTransactionLimitsPage.tsx:395 | template-normalized |
| /p2p/limits | /p2p/limit-tracker | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PTransactionLimitsPage.tsx:262 | template-normalized; raw=`${prefix}/p2p/limit-tracker` |
| /p2p/limits | /p2p/limits/tracker | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/compliance/overview | ${item.path} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PComplianceOverviewPage.tsx:57 | expression-not-absolute; raw=`${prefix}${item.path}` |
| /p2p/compliance/source-of-funds | /p2p/kyc/status | navigate | resolved | src/app/pages/p2p/P2PSourceOfFundsPage.tsx:49 | template-normalized |
| /p2p/compliance/large-transaction | /p2p/orders | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PLargeTransactionJustificationPage.tsx:57 | template-normalized; raw=`${prefix}/p2p/orders` |
| /p2p/tax-reporting | /p2p/tax-report/detailed/${selectedYear} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PTaxReportingPage.tsx:308 | dynamic-expression; raw=`${prefix}/p2p/tax-report/detailed/${selectedYear}` |
| /p2p/dashboard | /p2p/merchant/${m.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PDashboardPage.tsx:580 | dynamic-expression; raw=`${prefix}/p2p/merchant/${m.id}` |
| /p2p/dashboard | /p2p/my-orders | navigate | resolved | src/app/pages/p2p/P2PDashboardPage.tsx:615 | template-normalized |
| /p2p/dashboard | item.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PDashboardPage.tsx:674 | expression-not-absolute; raw=item.path |
| /p2p/achievements | /p2p/trading-level | navigate | resolved | src/app/pages/p2p/P2PAchievementsPage.tsx:288 | template-normalized |
| /p2p/blacklist/add | /p2p/blacklist | navigate | resolved | src/app/pages/p2p/P2PBlacklistAddPage.tsx:47 | template-normalized |
| /p2p/blacklist | /p2p/blacklist/add | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/blacklist | /p2p/blacklist/add | navigate | resolved | src/app/pages/p2p/P2PBlacklistPage.tsx:82 | template-normalized |
| /p2p/blacklist | /p2p/blacklist/add | navigate | resolved | src/app/pages/p2p/P2PBlacklistPage.tsx:162 | template-normalized |
| /p2p/settings | /p2p/blacklist | navigate | resolved | src/app/pages/p2p/P2PSettingsPage.tsx:236 | template-normalized |
| /p2p/settings | /p2p/settings/notifications | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p/settings | /profile/devices | navigate | resolved | src/app/pages/p2p/P2PSettingsPage.tsx:235 | template-normalized |
| /p2p/guide | /p2p | navigate | resolved | src/app/pages/p2p/P2PGuidePage.tsx:173 | template-normalized |
| /p2p/guide | /support/help | navigate | resolved | src/app/pages/p2p/P2PGuidePage.tsx:238 | template-normalized |
| /p2p/my-orders | /p2p | navigate | resolved | src/app/pages/p2p/P2PMyOrdersPage.tsx:149 | template-normalized |
| /p2p/my-orders | /p2p/dashboard | navigate | resolved | src/app/pages/p2p/P2PMyOrdersPage.tsx:83 | template-normalized |
| /p2p/my-orders | /p2p/dispute/detail/p2p001 | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PMyOrdersPage.tsx:163 | template-normalized; raw=`${routePrefix}/p2p/dispute/detail/${order.id}` |
| /p2p/my-orders | /p2p/order/p2p001 | navigate | resolved | src/app/pages/p2p/P2PMyOrdersPage.tsx:164 | template-normalized |
| /p2p | /p2p/achievements | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/ad-analytics/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/ad/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/ad/sample | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:239 | template-normalized |
| /p2p | /p2p/ad/sample | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:600 | template-normalized |
| /p2p | /p2p/ad/sample | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:608 | template-normalized |
| /p2p | /p2p/blacklist | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/chat/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/compliance/aml-screening | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/compliance/large-transaction | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/compliance/overview | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/compliance/risk-assessment | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/compliance/source-of-funds | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/create | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/create | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:960 | template-normalized |
| /p2p | /p2p/dashboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/dispute/detail/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/dispute/evidence/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/dispute/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/dispute/resolution/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/disputes | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/e2e-info | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/escrow/balance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/escrow/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/express | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/express | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:938 | template-normalized |
| /p2p | /p2p/fraud-prevention | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/guide | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/guide | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:881 | template-normalized |
| /p2p | /p2p/insurance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/insurance-fund | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/kyc/address | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/kyc/identity | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/kyc/requirements | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/kyc/selfie | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/kyc/status | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/kyc/video | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/limits | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/merchant-apply | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/merchant/${contextMenuAd.merchantId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PHomePage.tsx:645 | dynamic-expression; raw=`${prefix}/p2p/merchant/${contextMenuAd.merchantId}` |
| /p2p | /p2p/merchant/mc001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/my-ads | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/my-orders | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/my-orders | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:734 | template-normalized |
| /p2p | /p2p/order-book | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/order/cancel/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/order/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/order/proof/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/order/rate/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/order/timeline/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/payment-method/add | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/payment-method/cooling-period | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/payment-method/history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/payment-method/ownership/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/payment-method/verification/sample | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/payment-methods | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/report/${ad.merchantId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PHomePage.tsx:391 | dynamic-expression; raw=`${prefix}/p2p/report/${ad.merchantId}` |
| /p2p | /p2p/report/mc001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/reviews | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/security/2fa | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/security/anti-phishing | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/security/center | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/security/devices | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/security/login-history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/security/suspicious-activity | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/settings | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/tax-reporting | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/trading-level | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | /p2p/trading-level | navigate | resolved | src/app/pages/p2p/P2PHomePage.tsx:760 | template-normalized |
| /p2p | /p2p/wallet | route-hierarchy | resolved | route tree/url hierarchy |  |
| /p2p | item.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PHomePage.tsx:802 | expression-not-absolute; raw=item.path |
| /p2p | item.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PHomePage.tsx:832 | expression-not-absolute; raw=item.path |
| /p2p | item.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/p2p/P2PHomePage.tsx:862 | expression-not-absolute; raw=item.path |

### predictions navigation (41)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /markets/predictions | /arena | navigate | resolved | src/app/pages/predictions/PredictionsHomePage.tsx:522 | template-normalized |
| /markets/predictions | /markets/predictions/activity | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/advanced-chart/btcusdt | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/breaking | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/breaking | navigate | resolved | src/app/pages/predictions/PredictionsHomePage.tsx:487 | template-normalized |
| /markets/predictions | /markets/predictions/data-integration | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/event-calendar | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/event/pred-1 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/predictions/PredictionsHomePage.tsx:573 | template-normalized |
| /markets/predictions | /markets/predictions/leaderboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/market-maker | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/portfolio | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/portfolio-analyzer | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/receipt/p2p001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/rewards | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/risk-calculator | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/search | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/search | navigate | resolved | src/app/pages/predictions/PredictionsHomePage.tsx:320 | template-normalized |
| /markets/predictions | /markets/predictions/social | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /markets/predictions/tournaments | route-hierarchy | resolved | route tree/url hierarchy |  |
| /markets/predictions | /profile/predictions | navigate | resolved | src/app/pages/predictions/PredictionsHomePage.tsx:460 | template-normalized |
| /markets/predictions/search | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/predictions/PredictionsSearchPage.tsx:82 | template-normalized |
| /markets/predictions/breaking | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/predictions/PredictionsBreakingPage.tsx:56 | template-normalized |
| /markets/predictions/event/pred-1 | /arena/studio | navigate | resolved | src/app/pages/predictions/PredictionEventDetailPage.tsx:1620 | template-normalized |
| /markets/predictions/event/pred-1 | /markets/predictions | navigate | resolved | src/app/pages/predictions/PredictionEventDetailPage.tsx:1083 | template-normalized |
| /markets/predictions/event/pred-1 | /markets/predictions/activity | navigate | resolved | src/app/pages/predictions/PredictionEventDetailPage.tsx:1546 | template-normalized |
| /markets/predictions/event/pred-1 | /markets/predictions/event/${ev.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionEventDetailPage.tsx:1100 | dynamic-expression; raw=`${prefix}/markets/predictions/event/${ev.id}` |
| /markets/predictions/event/pred-1 | /markets/predictions/rewards | navigate | resolved | src/app/pages/predictions/PredictionEventDetailPage.tsx:1535 | template-normalized |
| /markets/predictions/portfolio | /arena | navigate | resolved | src/app/pages/predictions/PredictionsPortfolioPage.tsx:553 | template-normalized |
| /markets/predictions/portfolio | /markets/predictions/event/${position.eventId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionsPortfolioPage.tsx:169 | dynamic-expression; raw=`${prefix}/markets/predictions/event/${position.eventId}` |
| /markets/predictions/portfolio | /markets/predictions/receipt/${order.id.replace('oo-', 'po-')} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionsPortfolioPage.tsx:256 | dynamic-expression; raw=`${prefix}/markets/predictions/receipt/${order.id.replace('oo-', 'po-')}` |
| /markets/predictions/portfolio | /markets/predictions/receipt/${receipt.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionsPortfolioPage.tsx:320 | dynamic-expression; raw=`${prefix}/markets/predictions/receipt/${receipt.id}` |
| /markets/predictions/rewards | /arena | navigate | resolved | src/app/pages/predictions/PredictionsRewardsPage.tsx:302 | template-normalized |
| /markets/predictions/rewards | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/predictions/PredictionsRewardsPage.tsx:226 | template-normalized |
| /markets/predictions/leaderboard | /markets/predictions/event/${matchedEvent.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionsLeaderboardPage.tsx:288 | dynamic-expression; raw=`${prefix}/markets/predictions/event/${matchedEvent.id}` |
| /markets/predictions/activity | /markets/predictions/event/pred-1 | navigate | resolved | src/app/pages/predictions/PredictionsGlobalActivityPage.tsx:167 | template-normalized |
| /markets/predictions/receipt/p2p001 | /markets/predictions/event/${order.eventId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionOrderReceiptPage.tsx:310 | dynamic-expression; raw=`${prefix}/markets/predictions/event/${order.eventId}` |
| /markets/predictions/receipt/p2p001 | /profile/predictions | navigate | resolved | src/app/pages/predictions/PredictionOrderReceiptPage.tsx:314 | template-normalized |
| /markets/predictions/event-calendar | /predictions/event/pred-1 | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionEventCalendarPage.tsx:253 | template-normalized; raw=`${prefix}/predictions/event/${event.id}` |
| /markets/predictions/event-calendar | /predictions/event/pred-1 | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionEventCalendarPage.tsx:332 | template-normalized; raw=`${prefix}/predictions/event/${event.id}` |
| /markets/predictions/tournaments | /predictions/tournament/${tournament.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/predictions/PredictionTournamentsPage.tsx:160 | dynamic-expression; raw=`${prefix}/predictions/tournament/${tournament.id}` |

### profile navigation (62)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /profile | /auth/login | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:184 | template-normalized |
| /profile | /dca | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:223 | template-normalized |
| /profile | /earn/staking | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:224 | template-normalized |
| /profile | /markets/predictions/leaderboard | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:222 | template-normalized |
| /profile | /news | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:227 | template-normalized |
| /profile | /notifications | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:197 | template-normalized |
| /profile | /onboarding | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:211 | literal |
| /profile | /profile/activity | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/activity | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:413 | template-normalized |
| /profile | /profile/api | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/api | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:198 | template-normalized |
| /profile | /profile/arena | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/devices | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/devices | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:199 | template-normalized |
| /profile | /profile/edit | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/edit | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:306 | template-normalized |
| /profile | /profile/kyc | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/kyc | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:194 | template-normalized |
| /profile | /profile/predictions | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/security | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/security | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:195 | template-normalized |
| /profile | /profile/settings | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/settings | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:210 | template-normalized |
| /profile | /profile/sub-accounts | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/sub-accounts | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:200 | template-normalized |
| /profile | /profile/vip | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile | /profile/vip | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:196 | template-normalized |
| /profile | /referral | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:221 | template-normalized |
| /profile | /support | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:226 | template-normalized |
| /profile | /topics | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:220 | template-normalized |
| /profile | /trade/bots | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:225 | template-normalized |
| /profile | /trade/orders-history | navigate | resolved | src/app/pages/profile/ProfilePage.tsx:201 | template-normalized |
| /profile/edit | BACK | navigate | resolved | src/app/pages/profile/EditProfilePage.tsx:22 | history |
| /profile/security | /auth/2fa-setup | navigate | resolved | src/app/pages/profile/SecurityPage.tsx:76 | template-normalized |
| /profile/security | /auth/forgot-password | navigate | resolved | src/app/pages/profile/SecurityPage.tsx:77 | template-normalized |
| /profile/security | /profile/activity | navigate | resolved | src/app/pages/profile/SecurityPage.tsx:80 | template-normalized |
| /profile/api/create | /profile/api | navigate | resolved | src/app/pages/profile/ApiKeyCreatePage.tsx:225 | template-normalized |
| /profile/api | /profile/api/create | route-hierarchy | resolved | route tree/url hierarchy |  |
| /profile/api | /profile/api/create | navigate | resolved | src/app/pages/profile/ApiManagementPage.tsx:99 | template-normalized |
| /profile/vip | /trade/btcusdt | navigate | resolved | src/app/pages/profile/VIPPage.tsx:392 | user-confirmed normalization of routePrefix + '/trade/btcusdt' to Flutter helper AppRoutePaths.tradePair('btcusdt') |
| /profile/predictions | /arena | navigate | resolved | src/app/pages/predictions/PredictionsPortfolioPage.tsx:553 | template-normalized |
| /profile/predictions | /markets/predictions/event/{eventId} | navigate | resolved | src/app/pages/predictions/PredictionsPortfolioPage.tsx:169 | Flutter helper AppRoutePaths.marketsPredictionEvent(position.eventId) |
| /profile/predictions | /markets/predictions/receipt/{receiptId} | navigate | resolved | src/app/pages/predictions/PredictionsPortfolioPage.tsx:256 | Flutter helper AppRoutePaths.marketsPredictionReceipt(order.receiptId) |
| /profile/predictions | /markets/predictions/receipt/{receiptId} | navigate | resolved | src/app/pages/predictions/PredictionsPortfolioPage.tsx:320 | Flutter helper AppRoutePaths.marketsPredictionReceipt(receipt.id) |
| /profile/arena | /arena | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:356 | template-normalized |
| /profile/arena | /arena | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:374 | template-normalized |
| /profile/arena | /arena/challenge/{challengeId} | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:344 | dynamic id mapped with `AppRoutePaths.arenaChallenge(ch.id)`; placeholder route until SC-190. |
| /profile/arena | /arena/challenge/{challengeId} | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:362 | dynamic id mapped with `AppRoutePaths.arenaChallenge(ch.id)`; placeholder route until SC-190. |
| /profile/arena | /arena/challenge/{challengeId} | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:465 | dynamic id mapped with `AppRoutePaths.arenaChallenge(ch.id)`; placeholder route until SC-190. |
| /profile/arena | /arena/challenge/sample | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:533 | mapped with `AppRoutePaths.arenaChallenge('sample')`; placeholder route until SC-190. |
| /profile/arena | /arena/mode/mode001 | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:380 | template-normalized |
| /profile/arena | /arena/points | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:143 | template-normalized |
| /profile/arena | /arena/safety | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:571 | template-normalized |
| /profile/arena | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:283 | template-normalized |
| /profile/arena | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:338 | template-normalized |
| /profile/arena | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:417 | template-normalized |
| /profile/arena | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:423 | template-normalized |
| /profile/arena | /arena/studio | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:505 | template-normalized |
| /profile/arena | /arena/blocked | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:557 | canonicalized from `/profile/arena/blocked` to `AppRoutePaths.arenaBlocked`; placeholder route until SC-203. |
| /profile/arena | /arena/my-reports | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:543 | canonicalized from `/profile/arena/reports` to `AppRoutePaths.arenaMyReports`; placeholder route until SC-204. |
| /profile/arena | /rewards | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:209 | template-normalized |
| /profile/arena | /arena/leaderboard | navigate | resolved | src/app/pages/arena/MyArenaPage.tsx:297 | raw `item.path` replaced by typed quick-link route `AppRoutePaths.arenaLeaderboard`; placeholder route until SC-194. |

### referral navigation (14)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /referral/history | prefix + '/referral' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralHistoryPage.tsx:97 | expression-not-absolute; raw=prefix + '/referral' |
| /referral/history | prefix + '/referral/friend/' + friend.id | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralHistoryPage.tsx:182 | expression-not-absolute; raw=prefix + '/referral/friend/' + friend.id |
| /referral/rewards | prefix + '/referral' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralRewardsPage.tsx:167 | expression-not-absolute; raw=prefix + '/referral' |
| /referral/rules | prefix + '/referral' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralRulesPage.tsx:51 | expression-not-absolute; raw=prefix + '/referral' |
| /referral/friend/friend001 | prefix + '/referral/history' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralFriendDetailPage.tsx:74 | expression-not-absolute; raw=prefix + '/referral/history' |
| /referral/friend/friend001 | prefix + '/referral/history' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralFriendDetailPage.tsx:80 | expression-not-absolute; raw=prefix + '/referral/history' |
| /referral/friend/friend001 | prefix + '/referral/history' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralFriendDetailPage.tsx:95 | expression-not-absolute; raw=prefix + '/referral/history' |
| /referral/friend/friend001 | prefix + '/referral/rewards' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralFriendDetailPage.tsx:305 | expression-not-absolute; raw=prefix + '/referral/rewards' |
| /referral | /referral/friend/friend001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /referral | /referral/history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /referral | /referral/rewards | route-hierarchy | resolved | route tree/url hierarchy |  |
| /referral | /referral/rules | route-hierarchy | resolved | route tree/url hierarchy |  |
| /referral | item.route | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralHomePage.tsx:983 | expression-not-absolute; raw=item.route |
| /referral | prefix + '/referral/history' | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/referral/ReferralHomePage.tsx:707 | expression-not-absolute; raw=prefix + '/referral/history' |

### rewards navigation (2)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /rewards | /arena/leaderboard | navigate | resolved | src/app/pages/rewards/RewardsHubPage.tsx:1092 | template-normalized |
| /rewards | /referral | navigate | resolved | src/app/pages/rewards/RewardsHubPage.tsx:631 | template-normalized |

### support navigation (5)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /support/help | action.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/support/HelpCenterPage.tsx:66 | expression-not-absolute; raw=action.path |
| /support | /support/announcements | route-hierarchy | resolved | route tree/url hierarchy |  |
| /support | /support/announcements | navigate | resolved | src/app/pages/support/SupportPage.tsx:146 | template-normalized |
| /support | /support/help | route-hierarchy | resolved | route tree/url hierarchy |  |
| /support | /support/help | navigate | resolved | src/app/pages/support/SupportPage.tsx:137 | template-normalized |

### trade navigation (175)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /trade | /dca | navigate | resolved | src/app/pages/trade/TradePage.tsx:502 | template-normalized |
| /trade | /trade/advanced-chart/btcusdt | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/advanced-tools | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/bots | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/btcusdt | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/btcusdt | navigate | resolved | src/app/pages/trade/TradePage.tsx:245 | template-normalized |
| /trade | /trade/btcusdt/futures | navigate | resolved | src/app/pages/trade/TradePage.tsx:509 | template-normalized |
| /trade | /trade/convert | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/convert | navigate | resolved | src/app/pages/trade/TradePage.tsx:494 | template-normalized |
| /trade | /trade/copy-audit-log/copy001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-dispute-resolution | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-performance/copy001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-provider-apply | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-provider-governance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-provider/provider001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-regulatory-disclosures | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-safety-center | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/copy-trading | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/execution-quality | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/export | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/export | navigate | resolved | src/app/pages/trade/TradePage.tsx:1052 | template-normalized |
| /trade | /trade/export | navigate | resolved | src/app/pages/trade/TradePage.tsx:1133 | template-normalized |
| /trade | /trade/margin | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/order-receipt | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/order-receipt | navigate | resolved | src/app/pages/trade/TradePage.tsx:236 | template-normalized |
| /trade | /trade/order-receipt | navigate | resolved | src/app/pages/trade/TradePage.tsx:701 | template-normalized |
| /trade | /trade/order-receipt | navigate | resolved | src/app/pages/trade/TradePage.tsx:1067 | template-normalized |
| /trade | /trade/orders-history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/positions | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/positions | navigate | resolved | src/app/pages/trade/TradePage.tsx:515 | template-normalized |
| /trade | /trade/risk-management | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/settings | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade | /trade/settings | navigate | resolved | src/app/pages/trade/TradePage.tsx:521 | template-normalized |
| /trade | /trade/trader/trader001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/btcusdt | /dca | navigate | resolved | src/app/pages/trade/TradePage.tsx:502 | template-normalized |
| /trade/btcusdt | /trade/btcusdt | navigate | resolved | src/app/pages/trade/TradePage.tsx:245 | template-normalized |
| /trade/btcusdt | /trade/btcusdt/futures | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/btcusdt | /trade/btcusdt/futures | navigate | resolved | src/app/pages/trade/TradePage.tsx:509 | template-normalized |
| /trade/btcusdt | /trade/convert | navigate | resolved | src/app/pages/trade/TradePage.tsx:494 | template-normalized |
| /trade/btcusdt | /trade/export | navigate | resolved | src/app/pages/trade/TradePage.tsx:1052 | template-normalized |
| /trade/btcusdt | /trade/export | navigate | resolved | src/app/pages/trade/TradePage.tsx:1133 | template-normalized |
| /trade/btcusdt | /trade/order-receipt | navigate | resolved | src/app/pages/trade/TradePage.tsx:236 | template-normalized |
| /trade/btcusdt | /trade/order-receipt | navigate | resolved | src/app/pages/trade/TradePage.tsx:701 | template-normalized |
| /trade/btcusdt | /trade/order-receipt | navigate | resolved | src/app/pages/trade/TradePage.tsx:1067 | template-normalized |
| /trade/btcusdt | /trade/positions | navigate | resolved | src/app/pages/trade/TradePage.tsx:515 | template-normalized |
| /trade/btcusdt | /trade/settings | navigate | resolved | src/app/pages/trade/TradePage.tsx:521 | template-normalized |
| /trade/order-receipt | /trade/${order.symbol.replace('/', '-').toLowerCase()} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/OrderReceiptPage.tsx:210 | dynamic-expression; raw=`${prefix}/trade/${order.symbol.replace('/', '-').toLowerCase()}` |
| /trade/order-receipt | /trade/orders-history | navigate | resolved | src/app/pages/trade/OrderReceiptPage.tsx:186 | template-normalized |
| /trade/advanced-chart/btcusdt | /markets | navigate | resolved | src/app/pages/trade/AdvancedChartPage.tsx:435 | template-normalized |
| /trade/advanced-chart/btcusdt | /markets/alerts | navigate | resolved | src/app/pages/trade/AdvancedChartPage.tsx:559 | template-normalized |
| /trade/advanced-chart/btcusdt | /trade/btcusdt | navigate | resolved | src/app/pages/trade/AdvancedChartPage.tsx:547 | template-normalized |
| /trade/advanced-chart/btcusdt | /trade/btcusdt | navigate | resolved | src/app/pages/trade/AdvancedChartPage.tsx:553 | template-normalized |
| /trade/convert | toAsset | link | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ConvertPage.tsx:915 | expression-not-absolute; raw=toAsset |
| /trade/convert | toAsset | link | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ConvertPage.tsx:1012 | expression-not-absolute; raw=toAsset |
| /trade/convert | toAsset | link | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ConvertPage.tsx:1175 | expression-not-absolute; raw=toAsset |
| /trade/convert | toAsset | link | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ConvertPage.tsx:1185 | expression-not-absolute; raw=toAsset |
| /trade/convert | toAsset | link | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ConvertPage.tsx:1194 | expression-not-absolute; raw=toAsset |
| /trade/convert | toAsset | link | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ConvertPage.tsx:1395 | expression-not-absolute; raw=toAsset |
| /trade/convert | toAsset | link | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ConvertPage.tsx:1476 | expression-not-absolute; raw=toAsset |
| /trade/btcusdt/futures | /trade/advanced-chart/btcusdt | navigate | resolved | src/app/pages/trade/FuturesPage.tsx:138 | template-normalized |
| /trade/btcusdt/futures | /trade/btcusdt | navigate | resolved | src/app/pages/trade/FuturesPage.tsx:55 | template-normalized |
| /trade/btcusdt/futures | /trade/btcusdt/futures/leverage | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/btcusdt/futures | /trade/btcusdt/futures/leverage | navigate | resolved | src/app/pages/trade/FuturesPage.tsx:99 | template-normalized |
| /trade/btcusdt/futures/leverage | /trade/btcusdt/futures | navigate | resolved | src/app/pages/trade/LeveragePage.tsx:52 | template-normalized |
| /trade/bots | /trade/bots/api-documentation | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/backtesting | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/drawdown-analyzer | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/emergency-stop | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/equity-curve | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/faq | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/guide | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/optimization | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/performance-analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/portfolio-dashboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/risk-dashboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/risk-disclosure | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/security-settings | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/strategy-compare | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/suitability-assessment | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/tax-reporting | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/bots | /trade/bots/terms-of-service | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-provider/${trader.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/CopyTradingPage.tsx:205 | dynamic-expression; raw=`${prefix}/trade/copy-provider/${trader.id}` |
| /trade/copy-trading | /trade/copy-trading/active | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/arm-integration-status | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/audit-trail | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/best-execution-reports | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/cass-reconciliation | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/client-categorization | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/client-money-protection | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/comparison | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/complaint-submission | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/complaint-tracking | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/complaints-handling | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/education | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/ex-ante-costs | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/ex-post-costs-report | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/execution-venue-analysis | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/investor-compensation | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/kid-generator | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/leaderboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/notifications | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/ombudsman-referral | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/performance-scenarios | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/product-governance | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/regulatory-inspection-ready | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/regulatory-reports-dashboard | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/risk-analysis | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/risk-indicator-explainer | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/riy-calculator | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/safety | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/settings | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/slippage-monitoring | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/target-market-definition | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/transaction-reporting | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading | /trade/copy-trading/v2 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading/v2 | /copy-trading/${trader.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/CopyTradingPageV2.tsx:179 | dynamic-expression; raw=`${prefix}/copy-trading/${trader.id}` |
| /trade/copy-trading/education | /trade/copy-trading | navigate | resolved | src/app/pages/trade/CopyEducationPage.tsx:879 | template-normalized |
| /trade/copy-trading/active | /trade/copy-provider/${copy.providerId} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ActiveCopiesPage.tsx:347 | dynamic-expression; raw=`${prefix}/trade/copy-provider/${copy.providerId}` |
| /trade/copy-trading/active | /trade/copy-provider/${copy.providerId}/configuration | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ActiveCopiesPage.tsx:648 | dynamic-expression; raw=`${prefix}/trade/copy-provider/${copy.providerId}/configuration` |
| /trade/copy-trading/active | /trade/copy-trading | navigate | resolved | src/app/pages/trade/ActiveCopiesPage.tsx:234 | template-normalized |
| /trade/copy-trading/active | /trade/copy-trading | navigate | resolved | src/app/pages/trade/ActiveCopiesPage.tsx:258 | template-normalized |
| /trade/copy-trading/notifications | /trade/copy-trading/settings | navigate | resolved | src/app/pages/trade/CopyNotificationsPage.tsx:214 | template-normalized |
| /trade/copy-trading/notifications | ${notification.actionUrl} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/CopyNotificationsPage.tsx:186 | expression-not-absolute; raw=`${prefix}${notification.actionUrl}` |
| /trade/copy-provider-apply | /trade/copy-trading | navigate | resolved | src/app/pages/trade/ProviderApplicationPage.tsx:96 | template-normalized |
| /trade/copy-provider/provider001 | /trade/copy-provider/provider001/assessment | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-provider/provider001 | /trade/copy-provider/provider001/assessment | navigate | resolved | src/app/pages/trade/CopyProviderDetailPage.tsx:809 | template-normalized |
| /trade/copy-provider/provider001 | /trade/copy-provider/provider001/configuration | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-provider/provider001 | /trade/copy-provider/provider001/confirmation | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-provider/provider001/assessment | /trade/copy-provider/provider001/configuration | navigate | resolved | src/app/pages/trade/PreCopyAssessmentPage.tsx:717 | template-normalized |
| /trade/copy-provider/provider001/assessment | /trade/copy-trading | navigate | resolved | src/app/pages/trade/PreCopyAssessmentPage.tsx:715 | template-normalized |
| /trade/copy-provider/provider001/configuration | /trade/copy-provider/provider001/confirmation | navigate | resolved | src/app/pages/trade/CopyConfigurationPage.tsx:575 | template-normalized |
| /trade/copy-provider/provider001/confirmation | /trade/copy-trading/active | navigate | resolved | src/app/pages/trade/CopyConfirmationPage.tsx:620 | template-normalized |
| /trade/copy-performance/copy001 | /trade/copy-performance/copy001/attribution | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading/comparison | /trade/copy-provider/provider001 | navigate | resolved | src/app/pages/trade/ProviderComparisonPage.tsx:330 | template-normalized |
| /trade/copy-trading/comparison | /trade/copy-trading | navigate | resolved | src/app/pages/trade/ProviderComparisonPage.tsx:121 | template-normalized |
| /trade/copy-trading/comparison | /trade/copy-trading | navigate | resolved | src/app/pages/trade/ProviderComparisonPage.tsx:143 | template-normalized |
| /trade/copy-trading/leaderboard | /trade/copy-provider/provider001 | navigate | resolved | src/app/pages/trade/ProviderLeaderboardPage.tsx:202 | template-normalized |
| /trade/copy-safety-center | /trade/copy-trading | navigate | resolved | src/app/pages/trade/CopySafetyCenterPage.tsx:441 | template-normalized |
| /trade/copy-safety-center | /trade/copy-trading/safety | navigate | resolved | src/app/pages/trade/CopySafetyCenterPage.tsx:460 | template-normalized |
| /trade/margin | /trade/margin/advanced-analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/margin | /trade/margin/advanced-demo | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/margin | /trade/margin/btcusdt | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/margin | /trade/margin/hub | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/margin | /trade/margin/live-market-data-analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/margin | /trade/margin/market-data-analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /trade/copy-trading/transaction-reporting | /trade/copy-trading/arm-integration-status | navigate | resolved | src/app/pages/trade/TransactionReportingPage.tsx:561 | template-normalized |
| /trade/copy-trading/transaction-reporting | /trade/copy-trading/regulatory-reports-dashboard | navigate | resolved | src/app/pages/trade/TransactionReportingPage.tsx:389 | template-normalized |
| /trade/copy-trading/transaction-reporting | /trade/copy-trading/regulatory-reports-dashboard | navigate | resolved | src/app/pages/trade/TransactionReportingPage.tsx:550 | template-normalized |
| /trade/copy-trading/regulatory-reports-dashboard | /trade/copy-trading/arm-integration-status | navigate | resolved | src/app/pages/trade/RegulatoryReportsDashboardPage.tsx:504 | template-normalized |
| /trade/copy-trading/regulatory-reports-dashboard | /trade/copy-trading/transaction-reporting | navigate | resolved | src/app/pages/trade/RegulatoryReportsDashboardPage.tsx:493 | template-normalized |
| /trade/copy-trading/arm-integration-status | /trade/copy-trading/regulatory-reports-dashboard | navigate | resolved | src/app/pages/trade/ARMIntegrationStatusPage.tsx:414 | template-normalized |
| /trade/copy-trading/arm-integration-status | /trade/copy-trading/transaction-reporting | navigate | resolved | src/app/pages/trade/ARMIntegrationStatusPage.tsx:403 | template-normalized |
| /trade/copy-trading/best-execution-reports | /trade/copy-trading/execution-venue-analysis | navigate | resolved | src/app/pages/trade/BestExecutionReportsPage.tsx:358 | template-normalized |
| /trade/copy-trading/client-categorization | /settings/security | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ClientCategorizationPage.tsx:457 | template-normalized; raw=`${prefix}/settings/security` |
| /trade/copy-trading/client-categorization | /trade/copy-trading/client-opt-up-request | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ClientCategorizationPage.tsx:170 | template-normalized; raw=`${prefix}/trade/copy-trading/client-opt-up-request` |
| /trade/copy-trading/client-categorization | /trade/copy-trading/regulatory-disclosures | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ClientCategorizationPage.tsx:446 | template-normalized; raw=`${prefix}/trade/copy-trading/regulatory-disclosures` |
| /trade/copy-trading/product-governance | /trade/copy-trading/target-market-definition/sample | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ProductGovernancePage.tsx:191 | template-normalized; raw=`${prefix}/trade/copy-trading/target-market-definition/${product.id}` |
| /trade/copy-trading/client-money-protection | /trade/copy-trading/cass-reconciliation | navigate | resolved | src/app/pages/trade/ClientMoneyProtectionPage.tsx:213 | template-normalized |
| /trade/copy-trading/ex-ante-costs | /trade/copy-trading/ex-post-costs-report | navigate | resolved | src/app/pages/trade/ExAnteCostsPage.tsx:443 | template-normalized |
| /trade/copy-trading/ex-ante-costs | /trade/copy-trading/kid-generator | navigate | resolved | src/app/pages/trade/ExAnteCostsPage.tsx:454 | template-normalized |
| /trade/copy-trading/ex-ante-costs | /trade/copy-trading/riy-calculator | navigate | resolved | src/app/pages/trade/ExAnteCostsPage.tsx:312 | template-normalized |
| /trade/copy-trading/complaints-handling | /trade/copy-trading/complaint-submission | navigate | resolved | src/app/pages/trade/ComplaintsHandlingPage.tsx:147 | template-normalized |
| /trade/copy-trading/complaints-handling | /trade/copy-trading/complaint-tracking/${complaint.id} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ComplaintsHandlingPage.tsx:236 | dynamic-expression; raw=`${prefix}/trade/copy-trading/complaint-tracking/${complaint.id}` |
| /trade/copy-trading/complaints-handling | /trade/copy-trading/ombudsman-referral | navigate | resolved | src/app/pages/trade/ComplaintsHandlingPage.tsx:339 | template-normalized |
| /trade/copy-trading/complaint-submission | /trade/copy-trading/complaint-tracking/COMP-2026-NEW | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/trade/ComplaintSubmissionPage.tsx:46 | template-normalized; raw=`${prefix}/trade/copy-trading/complaint-tracking/COMP-2026-NEW` |
| /trade/copy-trading/complaint-tracking | /trade/copy-trading/ombudsman-referral | navigate | resolved | src/app/pages/trade/ComplaintTrackingPage.tsx:192 | template-normalized |
| /trade/bots/terms-of-service | /trade/bots | navigate | resolved | src/app/pages/trade/bots/BotTermsOfServicePage.tsx:29 | literal |
| /trade/bots/risk-disclosure | /trade/bots/suitability-assessment | navigate | resolved | src/app/pages/trade/bots/BotRiskDisclosurePage.tsx:100 | user-confirmed canonical route; React literal raw='/trade/bots/suitability' |
| /trade/bots/suitability-assessment | /trade/bots | navigate | resolved | src/app/pages/trade/bots/BotSuitabilityAssessmentPage.tsx:183 | literal |
| /trade/bots/risk-dashboard | /trade/bots/emergency-stop | navigate | resolved | src/app/pages/trade/bots/BotRiskDashboardPage.tsx:81 | literal |
| /trade/bots/risk-dashboard | /trade/bots/emergency-stop | navigate | resolved | src/app/pages/trade/bots/BotRiskDashboardPage.tsx:367 | literal |
| /trade/bots/emergency-stop | /trade/bots | navigate | resolved | src/app/pages/trade/bots/BotEmergencyStopPage.tsx:32 | literal |
| /trade/bots/emergency-stop | BACK | navigate | resolved | src/app/pages/trade/bots/BotEmergencyStopPage.tsx:184 | history |
| /trade/bots/backtesting | /trade/bots | navigate | resolved | src/app/pages/trade/bots/BotBacktestingPage.tsx:93 | literal |

### wallet navigation (38)

| From | To | Type | Confidence | Source | Note |
| --- | --- | --- | --- | --- | --- |
| /wallet | /wallet/address-book | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/address-book | navigate | resolved | src/app/pages/wallet/WalletPage.tsx:332 | template-normalized |
| /wallet | /wallet/asset/btc | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/asset/btc | navigate | resolved | src/app/pages/wallet/WalletPage.tsx:380 | template-normalized |
| /wallet | /wallet/buy-crypto | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/deposit | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/dust-converter | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/dust-converter | navigate | resolved | src/app/pages/wallet/WalletPage.tsx:256 | template-normalized |
| /wallet | /wallet/gas-optimizer | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/health-score | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/history | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/limits | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/limits | navigate | resolved | src/app/pages/wallet/WalletPage.tsx:248 | template-normalized |
| /wallet | /wallet/multi-manager | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/network-status | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/network-status | navigate | resolved | src/app/pages/wallet/WalletPage.tsx:264 | template-normalized |
| /wallet | /wallet/pending-deposits | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/pending-deposits | navigate | resolved | src/app/pages/wallet/WalletPage.tsx:240 | template-normalized |
| /wallet | /wallet/portfolio-analytics | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/portfolio-analytics | navigate | resolved | src/app/pages/wallet/WalletPage.tsx:345 | template-normalized |
| /wallet | /wallet/token-approval | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/transaction/tx001 | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/transfer | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | /wallet/withdraw | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet | ${btn.route} | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/wallet/WalletPage.tsx:212 | expression-not-absolute; raw=`${routePrefix}${btn.route}` |
| /wallet/history | /wallet/transaction/tx001 | navigate | resolved | src/app/pages/wallet/TransactionHistoryPage.tsx:172 | template-normalized |
| /wallet/deposit | /wallet/deposit/USDT | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet/withdraw | /wallet/withdraw/USDT | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet/transaction/tx001 | /support | navigate | resolved | src/app/pages/wallet/TransactionDetailPage.tsx:134 | template-normalized |
| /wallet/transaction/tx001 | /wallet/history | navigate | resolved | src/app/pages/wallet/TransactionDetailPage.tsx:54 | template-normalized |
| /wallet/address-book/add | /wallet/address-book | navigate | resolved | src/app/pages/wallet/AddressAddPage.tsx:71 | template-normalized |
| /wallet/address-book | /wallet/address-book/add | route-hierarchy | resolved | route tree/url hierarchy |  |
| /wallet/address-book | /wallet/address-book/add | navigate | resolved | src/app/pages/wallet/AddressBookPage.tsx:161 | template-normalized |
| /wallet/address-book | /wallet/address-book/add | navigate | resolved | src/app/pages/wallet/AddressBookPage.tsx:302 | template-normalized |
| /wallet/buy-crypto | /wallet | navigate | resolved | src/app/pages/wallet/BuyCryptoPage.tsx:166 | template-normalized |
| /wallet/asset/btc | /wallet/transaction/tx001 | navigate | resolved | src/app/pages/wallet/AssetDetailPage.tsx:216 | template-normalized |
| /wallet/asset/btc | btn.path | navigate | NEEDS_MANUAL_CONFIRM | src/app/pages/wallet/AssetDetailPage.tsx:152 | expression-not-absolute; raw=btn.path |
| /wallet/limits | /profile/kyc | navigate | resolved | src/app/pages/wallet/WithdrawLimitsPage.tsx:271 | template-normalized |

## Backend Contract Draft

These are draft mobile contracts to make BE discussion easier. Do not treat endpoint names as final API design until backend signs off.

### auth contracts (6)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-001 | /auth/login | /api/mobile/auth/auth-login -> { authSession, userCredentials, otpChallenge, deviceTrust } | POST /auth/login | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-002 | /auth/register | /api/mobile/auth/auth-register -> { authSession, userCredentials, otpChallenge, deviceTrust } | POST /auth/register | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-003 | /auth/otp | /api/mobile/auth/auth-otp -> { authSession, userCredentials, otpChallenge, deviceTrust } | POST /auth/verify-factor | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-004 | /auth/2fa-setup | /api/mobile/auth/auth-2fa-setup -> { authSession, userCredentials, otpChallenge, deviceTrust } | POST /auth/verify-factor | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. |
| SC-005 | /auth/forgot-password | /api/mobile/auth/auth-forgot-password -> { authSession, userCredentials, otpChallenge, deviceTrust } | POST /auth/password-reset | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. |
| SC-006 | /auth/reset-password | /api/mobile/auth/auth-reset-password -> { authSession, userCredentials, otpChallenge, deviceTrust } | POST /auth/password-reset | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. |

### home contracts (1)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-007 | /home | /api/mobile/home/home -> { userPortfolioSummary, announcements, quickActions, marketMovers, notificationsCount } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### markets contracts (22)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-008 | /markets | /api/mobile/markets/markets -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-009 | /markets/overview | /api/mobile/markets/markets-overview -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-010 | /markets/movers | /api/mobile/markets/markets-movers -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-011 | /markets/sectors | /api/mobile/markets/markets-sectors -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-012 | /markets/watchlist | /api/mobile/markets/markets-watchlist -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-013 | /markets/heatmap | /api/mobile/markets/markets-heatmap -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-014 | /markets/alerts | /api/mobile/markets/markets-alerts -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-015 | /markets/screener | /api/mobile/markets/markets-screener -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | GET with query filters | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-016 | /markets/compare | /api/mobile/markets/markets-compare -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | GET with query filters | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-017 | /markets/calendar | /api/mobile/markets/markets-calendar -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-018 | /markets/derivatives | /api/mobile/markets/markets-derivatives -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-019 | /markets/depth | /api/mobile/markets/markets-depth -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-020 | /markets/social-sentiment | /api/mobile/markets/markets-social-sentiment -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-021 | /markets/portfolio-tracker | /api/mobile/markets/markets-portfolio-tracker -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-022 | /markets/news | /api/mobile/markets/markets-news -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-023 | /markets/advanced-charts | /api/mobile/markets/markets-advanced-charts -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-024 | /markets/unlocks | /api/mobile/markets/markets-unlocks -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-025 | /markets/signals | /api/mobile/markets/markets-signals -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-026 | /markets/correlations | /api/mobile/markets/markets-correlations -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-044 | /pair/btcusdt | /api/mobile/markets/pair-btcusdt -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-045 | /pair/btcusdt/info | /api/mobile/markets/pair-btcusdt-info -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-046 | /pair/btcusdt/depth | /api/mobile/markets/pair-btcusdt-depth -> { marketPairs, watchlist, alerts, screenFilters, chartSeries } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### predictions contracts (17)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-027 | /markets/predictions | /api/mobile/predictions/markets-predictions -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-028 | /markets/predictions/search | /api/mobile/predictions/markets-predictions-search -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable; GET with query filters | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-029 | /markets/predictions/breaking | /api/mobile/predictions/markets-predictions-breaking -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-030 | /markets/predictions/event/pred-1 | /api/mobile/predictions/markets-predictions-event-pred-1 -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-031 | /markets/predictions/portfolio | /api/mobile/predictions/markets-predictions-portfolio -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-032 | /markets/predictions/rewards | /api/mobile/predictions/markets-predictions-rewards -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-033 | /markets/predictions/leaderboard | /api/mobile/predictions/markets-predictions-leaderboard -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-034 | /markets/predictions/activity | /api/mobile/predictions/markets-predictions-activity -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-035 | /markets/predictions/receipt/p2p001 | /api/mobile/predictions/markets-predictions-receipt-p2p001 -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /p2p/* workflow action where applicable; POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-036 | /markets/predictions/risk-calculator | /api/mobile/predictions/markets-predictions-risk-calculator -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-037 | /markets/predictions/market-maker | /api/mobile/predictions/markets-predictions-market-maker -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-038 | /markets/predictions/portfolio-analyzer | /api/mobile/predictions/markets-predictions-portfolio-analyzer -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-039 | /markets/predictions/event-calendar | /api/mobile/predictions/markets-predictions-event-calendar -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-040 | /markets/predictions/social | /api/mobile/predictions/markets-predictions-social -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-041 | /markets/predictions/advanced-chart/btcusdt | /api/mobile/predictions/markets-predictions-advanced-chart-btcusdt -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-042 | /markets/predictions/tournaments | /api/mobile/predictions/markets-predictions-tournaments -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |
| SC-043 | /markets/predictions/data-integration | /api/mobile/predictions/markets-predictions-data-integration -> { predictionEvents, outcomes, positions, orders, receipts, rewards } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Value surface: wallet/P-L domain; never merge with Arena Points. |

### news contracts (1)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-047 | /news | /api/mobile/news/news -> { newsReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### trade contracts (87)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-048 | /trade | /api/mobile/trade/trade -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-049 | /trade/btcusdt | /api/mobile/trade/trade-btcusdt -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-050 | /trade/orders-history | /api/mobile/trade/trade-orders-history -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /orders/:id/action where applicable | loading, empty, error, offline, submitting, success, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-051 | /trade/order-receipt | /api/mobile/trade/trade-order-receipt -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /orders/:id/action where applicable | loading, empty, error, offline, submitting, success, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-052 | /trade/settings | /api/mobile/trade/trade-settings -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; PATCH /user/settings or module settings | loading, empty, error, offline, submitting, success, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-053 | /trade/positions | /api/mobile/trade/trade-positions -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-054 | /trade/export | /api/mobile/trade/trade-export -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /exports | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-055 | /trade/advanced-chart/btcusdt | /api/mobile/trade/trade-advanced-chart-btcusdt -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-056 | /trade/convert | /api/mobile/trade/trade-convert -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-057 | /trade/btcusdt/futures | /api/mobile/trade/trade-btcusdt-futures -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-058 | /trade/btcusdt/futures/leverage | /api/mobile/trade/trade-btcusdt-futures-leverage -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-059 | /trade/bots | /api/mobile/trade/trade-bots -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-060 | /trade/risk-management | /api/mobile/trade/trade-risk-management -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-061 | /trade/execution-quality | /api/mobile/trade/trade-execution-quality -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-062 | /trade/advanced-tools | /api/mobile/trade/trade-advanced-tools -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-063 | /trade/copy-trading | /api/mobile/trade/trade-copy-trading -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-064 | /trade/copy-trading/v2 | /api/mobile/trade/trade-copy-trading-v2 -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-065 | /trade/copy-trading/education | /api/mobile/trade/trade-copy-trading-education -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-066 | /trade/copy-trading/active | /api/mobile/trade/trade-copy-trading-active -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-067 | /trade/copy-trading/settings | /api/mobile/trade/trade-copy-trading-settings -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable; PATCH /user/settings or module settings | loading, empty, error, offline, submitting, success, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-068 | /trade/copy-trading/notifications | /api/mobile/trade/trade-copy-trading-notifications -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable; PATCH /user/settings or module settings | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-069 | /trade/copy-provider-apply | /api/mobile/trade/trade-copy-provider-apply -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, submitting, success, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-070 | /trade/copy-provider/provider001 | /api/mobile/trade/trade-copy-provider-provider001 -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-071 | /trade/copy-provider/provider001/assessment | /api/mobile/trade/trade-copy-provider-provider001-assessment -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-072 | /trade/copy-provider/provider001/configuration | /api/mobile/trade/trade-copy-provider-provider001-configuration -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-073 | /trade/copy-provider/provider001/confirmation | /api/mobile/trade/trade-copy-provider-provider001-confirmation -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, submitting, success, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-074 | /trade/copy-performance/copy001 | /api/mobile/trade/trade-copy-performance-copy001 -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-075 | /trade/copy-performance/copy001/attribution | /api/mobile/trade/trade-copy-performance-copy001-attribution -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-076 | /trade/copy-trading/comparison | /api/mobile/trade/trade-copy-trading-comparison -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-077 | /trade/copy-audit-log/copy001 | /api/mobile/trade/trade-copy-audit-log-copy001 -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-078 | /trade/copy-trading/risk-analysis | /api/mobile/trade/trade-copy-trading-risk-analysis -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-079 | /trade/copy-trading/leaderboard | /api/mobile/trade/trade-copy-trading-leaderboard -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-080 | /trade/copy-trading/safety | /api/mobile/trade/trade-copy-trading-safety -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-081 | /trade/copy-provider-governance | /api/mobile/trade/trade-copy-provider-governance -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-082 | /trade/copy-dispute-resolution | /api/mobile/trade/trade-copy-dispute-resolution -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable; POST /p2p/disputes/:id/evidence\|resolve | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-083 | /trade/copy-safety-center | /api/mobile/trade/trade-copy-safety-center -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-084 | /trade/copy-regulatory-disclosures | /api/mobile/trade/trade-copy-regulatory-disclosures -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-085 | /trade/margin | /api/mobile/trade/trade-margin -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-086 | /trade/margin/btcusdt | /api/mobile/trade/trade-margin-btcusdt -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-087 | /trade/trader/trader001 | /api/mobile/trade/trade-trader-trader001 -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-088 | /trade/margin/advanced-demo | /api/mobile/trade/trade-margin-advanced-demo -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Reference/admin surface; gate behind internal role or dev flag. |
| SC-089 | /trade/margin/market-data-analytics | /api/mobile/trade/trade-margin-market-data-analytics -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-090 | /trade/margin/hub | /api/mobile/trade/trade-margin-hub -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-091 | /trade/margin/live-market-data-analytics | /api/mobile/trade/trade-margin-live-market-data-analytics -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-092 | /trade/margin/advanced-analytics | /api/mobile/trade/trade-margin-advanced-analytics -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-093 | /trade/copy-trading/transaction-reporting | /api/mobile/trade/trade-copy-trading-transaction-reporting -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable; POST /exports | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-094 | /trade/copy-trading/regulatory-reports-dashboard | /api/mobile/trade/trade-copy-trading-regulatory-reports-dashboard -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable; POST /exports | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-095 | /trade/copy-trading/arm-integration-status | /api/mobile/trade/trade-copy-trading-arm-integration-status -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-096 | /trade/copy-trading/best-execution-reports | /api/mobile/trade/trade-copy-trading-best-execution-reports -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable; POST /exports | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-097 | /trade/copy-trading/execution-venue-analysis | /api/mobile/trade/trade-copy-trading-execution-venue-analysis -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-098 | /trade/copy-trading/slippage-monitoring | /api/mobile/trade/trade-copy-trading-slippage-monitoring -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-099 | /trade/copy-trading/client-categorization | /api/mobile/trade/trade-copy-trading-client-categorization -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-100 | /trade/copy-trading/product-governance | /api/mobile/trade/trade-copy-trading-product-governance -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-101 | /trade/copy-trading/target-market-definition | /api/mobile/trade/trade-copy-trading-target-market-definition -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-102 | /trade/copy-trading/client-money-protection | /api/mobile/trade/trade-copy-trading-client-money-protection -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-103 | /trade/copy-trading/cass-reconciliation | /api/mobile/trade/trade-copy-trading-cass-reconciliation -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-104 | /trade/copy-trading/investor-compensation | /api/mobile/trade/trade-copy-trading-investor-compensation -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-105 | /trade/copy-trading/ex-ante-costs | /api/mobile/trade/trade-copy-trading-ex-ante-costs -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-106 | /trade/copy-trading/riy-calculator | /api/mobile/trade/trade-copy-trading-riy-calculator -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-107 | /trade/copy-trading/ex-post-costs-report | /api/mobile/trade/trade-copy-trading-ex-post-costs-report -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable; POST /exports | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-108 | /trade/copy-trading/kid-generator | /api/mobile/trade/trade-copy-trading-kid-generator -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-109 | /trade/copy-trading/performance-scenarios | /api/mobile/trade/trade-copy-trading-performance-scenarios -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-110 | /trade/copy-trading/risk-indicator-explainer | /api/mobile/trade/trade-copy-trading-risk-indicator-explainer -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-111 | /trade/copy-trading/complaints-handling | /api/mobile/trade/trade-copy-trading-complaints-handling -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-112 | /trade/copy-trading/complaint-submission | /api/mobile/trade/trade-copy-trading-complaint-submission -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-113 | /trade/copy-trading/complaint-tracking | /api/mobile/trade/trade-copy-trading-complaint-tracking -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-114 | /trade/copy-trading/ombudsman-referral | /api/mobile/trade/trade-copy-trading-ombudsman-referral -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-115 | /trade/copy-trading/audit-trail | /api/mobile/trade/trade-copy-trading-audit-trail -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-116 | /trade/copy-trading/regulatory-inspection-ready | /api/mobile/trade/trade-copy-trading-regulatory-inspection-ready -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-117 | /trade/bots/terms-of-service | /api/mobile/trade/trade-bots-terms-of-service -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-118 | /trade/bots/risk-disclosure | /api/mobile/trade/trade-bots-risk-disclosure -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-119 | /trade/bots/suitability-assessment | /api/mobile/trade/trade-bots-suitability-assessment -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-120 | /trade/bots/risk-dashboard | /api/mobile/trade/trade-bots-risk-dashboard -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-121 | /trade/bots/emergency-stop | /api/mobile/trade/trade-bots-emergency-stop -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-122 | /trade/bots/security-settings | /api/mobile/trade/trade-bots-security-settings -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable; PATCH /user/settings or module settings | loading, empty, error, offline, submitting, success, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-123 | /trade/bots/history | /api/mobile/trade/trade-bots-history -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-124 | /trade/bots/performance-analytics | /api/mobile/trade/trade-bots-performance-analytics -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-125 | /trade/bots/backtesting | /api/mobile/trade/trade-bots-backtesting -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-126 | /trade/bots/strategy-compare | /api/mobile/trade/trade-bots-strategy-compare -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable; GET with query filters | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-127 | /trade/bots/optimization | /api/mobile/trade/trade-bots-optimization -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-128 | /trade/bots/portfolio-dashboard | /api/mobile/trade/trade-bots-portfolio-dashboard -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-129 | /trade/bots/drawdown-analyzer | /api/mobile/trade/trade-bots-drawdown-analyzer -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-130 | /trade/bots/equity-curve | /api/mobile/trade/trade-bots-equity-curve -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-131 | /trade/bots/guide | /api/mobile/trade/trade-bots-guide -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-132 | /trade/bots/faq | /api/mobile/trade/trade-bots-faq -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-133 | /trade/bots/tax-reporting | /api/mobile/trade/trade-bots-tax-reporting -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable; POST /exports | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-134 | /trade/bots/api-documentation | /api/mobile/trade/trade-bots-api-documentation -> { pairs, orderBook, trades, orders, positions, copyProviders, botStrategies } | POST /trade/order-preview + POST /trade/orders; POST /bots/create\|pause\|stop\|optimize where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |

### wallet contracts (21)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-135 | /wallet | /api/mobile/wallet/wallet -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-136 | /wallet/history | /api/mobile/wallet/wallet-history -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-137 | /wallet/deposit | /api/mobile/wallet/wallet-deposit -> { walletBalances, assets, transactions, addresses, networkFees, limits } | POST /wallet/deposit-intent | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-138 | /wallet/deposit/USDT | /api/mobile/wallet/wallet-deposit-usdt -> { walletBalances, assets, transactions, addresses, networkFees, limits } | POST /wallet/deposit-intent | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-139 | /wallet/withdraw | /api/mobile/wallet/wallet-withdraw -> { walletBalances, assets, transactions, addresses, networkFees, limits } | POST /wallet/withdraw-preview + POST /wallet/withdraw-confirm | loading, empty, error, offline, submitting, success | High-risk action: preview + confirm + audit trail required. |
| SC-140 | /wallet/withdraw/USDT | /api/mobile/wallet/wallet-withdraw-usdt -> { walletBalances, assets, transactions, addresses, networkFees, limits } | POST /wallet/withdraw-preview + POST /wallet/withdraw-confirm | loading, empty, error, offline, submitting, success | High-risk action: preview + confirm + audit trail required. |
| SC-141 | /wallet/transaction/tx001 | /api/mobile/wallet/wallet-transaction-tx001 -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-142 | /wallet/portfolio-analytics | /api/mobile/wallet/wallet-portfolio-analytics -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-143 | /wallet/address-book/add | /api/mobile/wallet/wallet-address-book-add -> { walletBalances, assets, transactions, addresses, networkFees, limits } | POST /wallet/addresses; POST /kyc/submission-step | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. |
| SC-144 | /wallet/address-book | /api/mobile/wallet/wallet-address-book -> { walletBalances, assets, transactions, addresses, networkFees, limits } | POST /kyc/submission-step | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-145 | /wallet/buy-crypto | /api/mobile/wallet/wallet-buy-crypto -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-146 | /wallet/transfer | /api/mobile/wallet/wallet-transfer -> { walletBalances, assets, transactions, addresses, networkFees, limits } | POST /wallet/transfer-preview + POST /wallet/transfer-confirm | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-147 | /wallet/asset/btc | /api/mobile/wallet/wallet-asset-btc -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-148 | /wallet/multi-manager | /api/mobile/wallet/wallet-multi-manager -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-149 | /wallet/gas-optimizer | /api/mobile/wallet/wallet-gas-optimizer -> { walletBalances, assets, transactions, addresses, networkFees, limits } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-150 | /wallet/token-approval | /api/mobile/wallet/wallet-token-approval -> { approvals, revokedApprovals, approvalRiskSummary, walletBalances, assets } | POST /wallet/token-approval/revoke-preview + POST /wallet/token-approval/revoke-confirm | loading, empty, error, offline, submitting, success | High-risk revoke actions require preview + confirm before real API wiring. |
| SC-151 | /wallet/health-score | /api/mobile/wallet/wallet-health-score -> { metrics, diversification, history, recommendations, securityChecklist } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; actions remain local recommendations until real API wiring. |
| SC-152 | /wallet/pending-deposits | /api/mobile/wallet/wallet-pending-deposits -> { deposits, pendingCount, confirmations, estimatedArrival } | POST /wallet/deposit-intent | loading, empty, error, offline, submitting, success | Match screenshot first; deposit tracker uses mock live status until real API wiring. |
| SC-153 | /wallet/limits | /api/mobile/wallet/wallet-limits -> { currentLevel, usedToday, usedMonth, tiers, faqs, dailyRemaining, monthlyRemaining } | read-only + local navigation to /profile/kyc placeholder | loading, empty, error, offline | Match screenshot first; KYC upgrade edge is placeholder until profile KYC screen is ported. |
| SC-154 | /wallet/dust-converter | /api/mobile/wallet/wallet-dust-converter -> { targets, eligibleAssets, dustThresholdUsd, conversionFeePct, preview } | POST /wallet/dust-converter/preview + POST /wallet/dust-converter/confirm | loading, empty, error, offline, submitting, success | Match screenshot first; conversion confirm remains local until real API wiring. |
| SC-155 | /wallet/network-status | /api/mobile/wallet/wallet-network-status -> { networks, operationalCount, issueCount, downCount, refreshIntervalSeconds } | read-only refresh | loading, empty, error, offline, realtimeRefresh | Match screenshot first; network status refresh remains local until live chain status API wiring. |

### profile contracts (13)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-156 | /profile | /api/mobile/profile/profile -> { user, vipProgress, predictionSummary, arenaSummary, menuSections, securitySummary } | read-only + local navigation actions | loading, empty, error, offline | Match screenshot first; unresolved child profile routes use placeholders until their SC rows are ported. |
| SC-157 | /profile/edit | /api/mobile/profile/profile-edit -> { user, editableFields, validationRules } | PATCH /user/settings | loading, empty, error, offline, submitting, success | Match screenshot first; save is local mock and returns to profile until real profile settings API wiring. |
| SC-158 | /profile/security | /api/mobile/profile/profile-security -> { score, enabledFactors, securityItems, devices, antiPhishingCodeStatus } | PATCH /user/settings + local navigation to auth/activity routes | loading, empty, error, offline, submitting, success | Match screenshot first; device reveal and anti-phishing save remain local until real security settings API wiring. |
| SC-159 | /profile/kyc | /api/mobile/profile/profile-kyc -> { currentLevel, status, levels, limits, unlockedFeatures } | POST /kyc/submission-step | loading, empty, error, offline, submitting, success | Match screenshot first; current mock is verified KYC level 2 with local level expansion until real KYC submission wiring. |
| SC-160 | /profile/settings | /api/mobile/profile/profile-settings -> { currencyOptions, selectedCurrency, languages, selectedLanguageId, tradeSecurity, notifications, appInfo } | PATCH /user/settings or module settings | loading, empty, error, offline, submitting, success | Match screenshot first; settings choices and toggles stay local mock state until real user settings persistence is wired. |
| SC-161 | /profile/activity | /api/mobile/profile/profile-activity -> { filters, logs, suspiciousCount } | read-only + local filter actions | loading, empty, error, offline | Match screenshot first; activity list uses mock audit events and local filters until real account activity API is wired. |
| SC-162 | /profile/api/create | /api/mobile/profile/profile-api-create -> { permissions, expiryOptions, securityTips, draftName, selectedPermissions, ipWhitelist, expiry } | POST /user/api-keys + local confirm/result steps | loading, empty, error, offline, submitting, success | Match screenshot first; create flow uses mock confirm/result and returns to /profile/api placeholder until SC-163 API management is ported. |
| SC-163 | /profile/api | /api/mobile/profile/profile-api -> { apiKeys, permissions, ipWhitelist, requestCount, lastUsed, docsLink } | read-only + local toggle, copy, secret reveal, delete, and create navigation actions | loading, empty, error, offline, submitting, success | Match screenshot first; /profile/api/create is wired to SC-162 and destructive delete remains local-confirmed until real API key management endpoints are wired. |
| SC-164 | /profile/vip | /api/mobile/profile/profile-vip -> { currentLevel, monthlyVolume, assetHold, memberSince, tiers, history } | read-only + local trade navigation action | loading, empty, error, offline | Match screenshot first; VIP trade CTA uses user-confirmed /trade/btcusdt edge. |
| SC-165 | /profile/devices | /api/mobile/profile/profile-devices -> { userProfile, securitySettings, kycStatus, devices, apiKeys } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |
| SC-166 | /profile/sub-accounts | /api/mobile/profile/profile-sub-accounts -> { userProfile, securitySettings, kycStatus, devices, apiKeys } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-167 | /profile/predictions | /api/mobile/profile/profile-predictions -> { predictionEvents, outcomes, positions, orders, receipts, rewards, profileSummary } | POST /predictions/orders\|claim\|watchlist where applicable | loading, empty, error, offline, realtime-refresh | Profile entry to value-based Prediction portfolio; never merge wallet/P-L receipts with Arena Points. |
| SC-168 | /profile/arena | /api/mobile/profile/profile-arena -> { arenaRooms, challenges, savedModes, drafts, pointsLedger, reports, trustSignals, profileSummary } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |

### dca contracts (11)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-169 | /dca | /api/mobile/dca/dca -> { overview, sparkline, dcaPlans, schedules, rules, portfolioTargets, backtests, portfolioHistory, toolAvailability } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline, submitting, success | Match screenshot first; DCA dashboard uses mock read model plus local create/pause/history state until plan APIs are wired. |
| SC-170 | /dca/rebalance/config | /api/mobile/dca/dca-rebalance-config -> { targets, holdings, strategyOptions, frequencyOptions, driftThreshold, minTradeAmount, autoExecute, previewTrades, validation } | POST /dca/rebalance/config\|preview | loading, empty, error, offline, submitting, success | Match screenshot first; save flow previews simulated trades and then routes to /dca/rebalance/config001 until dashboard API is ported. |
| SC-171 | /dca/rebalance/config001 | /api/mobile/dca/dca-rebalance-config001 -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-172 | /dca/schedule/config | /api/mobile/dca/dca-schedule-config -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-173 | /dca/schedule/config001 | /api/mobile/dca/dca-schedule-config001 -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-174 | /dca/portfolio-optimizer | /api/mobile/dca/dca-portfolio-optimizer -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-175 | /dca/dynamic-amount | /api/mobile/dca/dca-dynamic-amount -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-176 | /dca/backtester | /api/mobile/dca/dca-backtester -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-177 | /dca/multi-asset | /api/mobile/dca/dca-multi-asset -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-178 | /dca/performance-compare | /api/mobile/dca/dca-performance-compare -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule; GET with query filters | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-179 | /dca/smart-rules | /api/mobile/dca/dca-smart-rules -> { dcaPlans, schedules, rules, portfolioTargets, backtests } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### admin contracts (4)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-180 | /admin | /api/mobile/admin/admin -> { analyticsEvents, funnels, experiments, adminMetrics } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |
| SC-181 | /admin/analytics | /api/mobile/admin/admin-analytics -> { analyticsEvents, funnels, experiments, adminMetrics } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Reference/admin surface; gate behind internal role or dev flag. |
| SC-182 | /admin/abtests | /api/mobile/admin/admin-abtests -> { abTests, variants, analyticsEvents, funnels, experiments, adminMetrics } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; mock A/B test summaries mirror DCA experiment registry until analytics API is wired. |
| SC-183 | /admin/funnels | /api/mobile/admin/admin-funnels -> { funnels, funnelSteps, analyticsEvents, experiments, adminMetrics } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; mock conversion funnel registry mirrors DCA funnel definitions until analytics API is wired. |

### arena contracts (26)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-184 | /arena | /api/mobile/arena/arena -> { templates, featuredModes, arenaRooms, creators, trustSignals, searchIndex } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy; Flutter uses Material icons for templates and safe placeholders for child routes until SC-185+ rows are ported. |
| SC-185 | /arena/studio | /api/mobile/arena/arena-studio -> { templates, wizardSteps, draftChallenge, platformFee, importExportState, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable + local save/export/import draft actions | loading, empty, error, offline, submitting, under_review | Points-only/social surface; never expose wallet/PnL copy; platform fee is fixed at 10% total pool and child studio routes stay safe placeholders until SC-186..188 are ported. |
| SC-186 | /arena/studio/smart-rules | /api/mobile/arena/arena-studio-smart-rules -> { wizardSteps, domains, challengeTypes, ruleBuilderOptions, edgeRules, clarityScore, draftRule } | POST /arena/challenges\|join\|resolve\|report where applicable + local save draft action | loading, empty, error, offline, validation | Points-only/social surface; Smart Rule Builder is wizard step 3 with clarity score, structured winning-condition controls, timing/edge rules, and no wallet/PnL copy. |
| SC-187 | /arena/studio/presets | /api/mobile/arena/arena-studio-presets -> { sections, domainPacks, suggestionLibrary, dropdownGroups, demoFlows, titleSuggestions } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline, selected_suggestion | Points-only/social surface; Universal Preset Library provides reusable rule presets, Material icon mapping, and shared rule-engine metadata with no wallet/PnL copy. |
| SC-188 | /arena/studio/governance | /api/mobile/arena/arena-studio-governance -> { wizardSteps, privacyOptions, domains, challengeTypes, ruleBuilderOptions, edgeRules, clarityScore, ambiguityWarnings, fallbackSuggestions, eligibilitySummary } | POST /arena/challenges\|join\|resolve\|report where applicable + local save draft/guidance/suggestion actions | loading, empty, error, offline, validation, publish_blocked | Points-only/social surface; Governance Gate checks public/private eligibility, rule clarity, ambiguity warnings, edge rules, and never exposes wallet/PnL copy. |
| SC-189 | /arena/mode/mode001 | /api/mobile/arena/arena-mode-mode001 -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-190 | /arena/challenge/ch003 | /api/mobile/arena/arena-challenge-ch003 -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-191 | /arena/join/ch003 | /api/mobile/arena/arena-join-ch003 -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-192 | /arena/resolution | /api/mobile/arena/arena-resolution -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /p2p/disputes/:id/evidence\|resolve; POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-193 | /arena/creator/cr001 | /api/mobile/arena/arena-creator-cr001 -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-194 | /arena/leaderboard | /api/mobile/arena/arena-leaderboard -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-195 | /arena/verified | /api/mobile/arena/arena-verified -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-196 | /arena/points | /api/mobile/arena/arena-points -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-197 | /arena/flow-map | /api/mobile/arena/arena-flow-map -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-198 | /arena/safety | /api/mobile/arena/arena-safety -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-199 | /arena/trust/user001 | /api/mobile/arena/arena-trust-user001 -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-200 | /arena/ledger/entry/entry001 | /api/mobile/arena/arena-ledger-entry-entry001 -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-201 | /arena/ledger | /api/mobile/arena/arena-ledger -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-202 | /arena/report/case001 | /api/mobile/arena/arena-report-case001 -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable; POST /exports | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-203 | /arena/blocked | /api/mobile/arena/arena-blocked -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-204 | /arena/my-reports | /api/mobile/arena/arena-my-reports -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable; POST /exports | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-205 | /arena/my | /api/mobile/arena/arena-my -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-206 | /arena/production | /api/mobile/arena/arena-production -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-207 | /arena/bridge | /api/mobile/arena/arena-bridge -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-208 | /arena/ecosystem | /api/mobile/arena/arena-ecosystem -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |
| SC-209 | /arena/guide | /api/mobile/arena/arena-guide -> { arenaRooms, challenges, pointsLedger, creators, reports, trustSignals } | POST /arena/challenges\|join\|resolve\|report where applicable | loading, empty, error, offline | Points-only/social surface; never expose wallet/PnL copy. |

### p2p contracts (73)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-210 | /p2p/express/confirm | /api/mobile/p2p/p2p-express-confirm -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-211 | /p2p/express | /api/mobile/p2p/p2p-express -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-212 | /p2p/order/timeline/p2p001 | /api/mobile/p2p/p2p-order-timeline-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-213 | /p2p/order/rate/p2p001 | /api/mobile/p2p/p2p-order-rate-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-214 | /p2p/order/cancel/p2p001 | /api/mobile/p2p/p2p-order-cancel-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-215 | /p2p/order/proof/p2p001 | /api/mobile/p2p/p2p-order-proof-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-216 | /p2p/order/p2p001 | /api/mobile/p2p/p2p-order-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-217 | /p2p/chat/p2p001 | /api/mobile/p2p/p2p-chat-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline, realtime-refresh | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-218 | /p2p/dispute/detail/sample | /api/mobile/p2p/p2p-dispute-detail-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence\|resolve | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-219 | /p2p/dispute/evidence/sample | /api/mobile/p2p/p2p-dispute-evidence-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence\|resolve | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-220 | /p2p/dispute/resolution/sample | /api/mobile/p2p/p2p-dispute-resolution-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence\|resolve | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-221 | /p2p/dispute/p2p001 | /api/mobile/p2p/p2p-dispute-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence\|resolve | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-222 | /p2p/disputes | /api/mobile/p2p/p2p-disputes -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence\|resolve | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-223 | /p2p/ad-analytics/sample | /api/mobile/p2p/p2p-ad-analytics-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline, realtime-refresh | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-224 | /p2p/ad/sample | /api/mobile/p2p/p2p-ad-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-225 | /p2p/my-ads | /api/mobile/p2p/p2p-my-ads -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-226 | /p2p/create | /api/mobile/p2p/p2p-create -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-227 | /p2p/merchant-apply | /api/mobile/p2p/p2p-merchant-apply -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-228 | /p2p/merchant/mc001 | /api/mobile/p2p/p2p-merchant-mc001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-229 | /p2p/report/mc001 | /api/mobile/p2p/p2p-report-mc001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /exports | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-230 | /p2p/trading-level | /api/mobile/p2p/p2p-trading-level -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-231 | /p2p/reviews | /api/mobile/p2p/p2p-reviews -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-232 | /p2p/payment-method/add | /api/mobile/p2p/p2p-payment-method-add -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/payment-methods | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-233 | /p2p/payment-method/verification/sample | /api/mobile/p2p/p2p-payment-method-verification-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/payment-methods | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-234 | /p2p/payment-method/ownership/sample | /api/mobile/p2p/p2p-payment-method-ownership-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/payment-methods | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-235 | /p2p/payment-method/cooling-period | /api/mobile/p2p/p2p-payment-method-cooling-period -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/payment-methods | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-236 | /p2p/payment-method/history | /api/mobile/p2p/p2p-payment-method-history -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/payment-methods | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-237 | /p2p/payment-methods | /api/mobile/p2p/p2p-payment-methods -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /p2p/payment-methods | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-238 | /p2p/insurance | /api/mobile/p2p/p2p-insurance -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-239 | /p2p/insurance/certificate | /api/mobile/p2p/p2p-insurance-certificate -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-240 | /p2p/insurance/score | /api/mobile/p2p/p2p-insurance-score -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-241 | /p2p/insurance/policy | /api/mobile/p2p/p2p-insurance-policy -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-242 | /p2p/insurance/contribution-history | /api/mobile/p2p/p2p-insurance-contribution-history -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-243 | /p2p/insurance/claim/sample | /api/mobile/p2p/p2p-insurance-claim-sample -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-244 | /p2p/insurance-fund | /api/mobile/p2p/p2p-insurance-fund -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-245 | /p2p/escrow/balance | /api/mobile/p2p/p2p-escrow-balance -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-246 | /p2p/escrow/p2p001 | /api/mobile/p2p/p2p-escrow-p2p001 -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-247 | /p2p/kyc/requirements | /api/mobile/p2p/p2p-kyc-requirements -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /kyc/submission-step | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-248 | /p2p/kyc/status | /api/mobile/p2p/p2p-kyc-status -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /kyc/submission-step | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-249 | /p2p/kyc/identity | /api/mobile/p2p/p2p-kyc-identity -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /kyc/submission-step | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-250 | /p2p/kyc/address | /api/mobile/p2p/p2p-kyc-address -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /kyc/submission-step | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-251 | /p2p/kyc/selfie | /api/mobile/p2p/p2p-kyc-selfie -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /kyc/submission-step | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-252 | /p2p/kyc/video | /api/mobile/p2p/p2p-kyc-video -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /kyc/submission-step | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-253 | /p2p/security/center | /api/mobile/p2p/p2p-security-center -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-254 | /p2p/security/2fa | /api/mobile/p2p/p2p-security-2fa -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /auth/verify-factor; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline | High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-255 | /p2p/security/devices | /api/mobile/p2p/p2p-security-devices -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. Reference/admin surface; gate behind internal role or dev flag. |
| SC-256 | /p2p/security/anti-phishing | /api/mobile/p2p/p2p-security-anti-phishing -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-257 | /p2p/security/login-history | /api/mobile/p2p/p2p-security-login-history -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /auth/login; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-258 | /p2p/security/suspicious-activity | /api/mobile/p2p/p2p-security-suspicious-activity -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-259 | /p2p/e2e-info | /api/mobile/p2p/p2p-e2e-info -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-260 | /p2p/fraud-prevention | /api/mobile/p2p/p2p-fraud-prevention -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-261 | /p2p/wallet/transfer | /api/mobile/p2p/p2p-wallet-transfer -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /wallet/transfer-preview + POST /wallet/transfer-confirm; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-262 | /p2p/wallet/fund-lock-history | /api/mobile/p2p/p2p-wallet-fund-lock-history -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-263 | /p2p/wallet/history | /api/mobile/p2p/p2p-wallet-history -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-264 | /p2p/wallet | /api/mobile/p2p/p2p-wallet -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-265 | /p2p/limits/tracker | /api/mobile/p2p/p2p-limits-tracker -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-266 | /p2p/limits | /api/mobile/p2p/p2p-limits -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-267 | /p2p/compliance/overview | /api/mobile/p2p/p2p-compliance-overview -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-268 | /p2p/compliance/aml-screening | /api/mobile/p2p/p2p-compliance-aml-screening -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-269 | /p2p/compliance/source-of-funds | /api/mobile/p2p/p2p-compliance-source-of-funds -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-270 | /p2p/compliance/large-transaction | /api/mobile/p2p/p2p-compliance-large-transaction -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-271 | /p2p/compliance/risk-assessment | /api/mobile/p2p/p2p-compliance-risk-assessment -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-272 | /p2p/tax-reporting | /api/mobile/p2p/p2p-tax-reporting -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; POST /exports | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-273 | /p2p/order-book | /api/mobile/p2p/p2p-order-book -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success, realtime-refresh | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-274 | /p2p/dashboard | /api/mobile/p2p/p2p-dashboard -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline, realtime-refresh | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-275 | /p2p/achievements | /api/mobile/p2p/p2p-achievements -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-276 | /p2p/blacklist/add | /api/mobile/p2p/p2p-blacklist-add -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-277 | /p2p/blacklist | /api/mobile/p2p/p2p-blacklist -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-278 | /p2p/settings/notifications | /api/mobile/p2p/p2p-settings-notifications -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-279 | /p2p/settings | /api/mobile/p2p/p2p-settings -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-280 | /p2p/guide | /api/mobile/p2p/p2p-guide -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-281 | /p2p/my-orders | /api/mobile/p2p/p2p-my-orders -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable | loading, empty, error, offline, submitting, success | P2P requires escrow, fraud, KYC, payment-state clarity. |
| SC-282 | /p2p | /api/mobile/p2p/p2p -> { p2pAds, p2pOrders, merchants, disputes, escrow, kyc, paymentMethods } | POST /p2p/* workflow action where applicable | loading, empty, error, offline | P2P requires escrow, fraud, KYC, payment-state clarity. |

### discovery contracts (3)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-283 | /search | /api/mobile/discovery/search -> { discoveryReferenceData, screenState } | GET with query filters | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-284 | /topics | /api/mobile/discovery/topics -> { discoveryReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-285 | /topic/crypto | /api/mobile/discovery/topic-crypto -> { discoveryReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### referral contracts (5)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-286 | /referral/history | /api/mobile/referral/referral-history -> { referralReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-287 | /referral/rewards | /api/mobile/referral/referral-rewards -> { referralReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-288 | /referral/rules | /api/mobile/referral/referral-rules -> { referralReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-289 | /referral/friend/friend001 | /api/mobile/referral/referral-friend-friend001 -> { referralReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-290 | /referral | /api/mobile/referral/referral -> { referralReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### notifications contracts (1)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-291 | /notifications | /api/mobile/notifications/notifications -> { notificationsReferenceData, screenState } | PATCH /user/settings or module settings | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### support contracts (3)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-292 | /support/help | /api/mobile/support/support-help -> { supportArticles, tickets, announcements } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-293 | /support/announcements | /api/mobile/support/support-announcements -> { supportArticles, tickets, announcements } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-294 | /support | /api/mobile/support/support -> { supportArticles, tickets, announcements } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### launchpad contracts (24)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-295 | /launchpad | /api/mobile/launchpad/launchpad -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-296 | /launchpad/portfolio | /api/mobile/launchpad/launchpad-portfolio -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-297 | /launchpad/performance | /api/mobile/launchpad/launchpad-performance -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-298 | /launchpad/staking | /api/mobile/launchpad/launchpad-staking -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-299 | /launchpad/idobridge/sample | /api/mobile/launchpad/launchpad-idobridge-sample -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-300 | /launchpad/contract/sample | /api/mobile/launchpad/launchpad-contract-sample -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-301 | /launchpad/receipt/sub001 | /api/mobile/launchpad/launchpad-receipt-sub001 -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-302 | /launchpad/claim-receipt/pos001 | /api/mobile/launchpad/launchpad-claim-receipt-pos001 -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-303 | /launchpad/bridge-order/tx001 | /api/mobile/launchpad/launchpad-bridge-order-tx001 -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /orders/:id/action where applicable; POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-304 | /launchpad/batch-claim | /api/mobile/launchpad/launchpad-batch-claim -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-305 | /launchpad/bridge-compare | /api/mobile/launchpad/launchpad-bridge-compare -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable; GET with query filters | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-306 | /launchpad/notif-sound | /api/mobile/launchpad/launchpad-notif-sound -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-307 | /launchpad/event-log | /api/mobile/launchpad/launchpad-event-log -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-308 | /launchpad/abi-diff/contract001 | /api/mobile/launchpad/launchpad-abi-diff-contract001 -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-309 | /launchpad/address-book | /api/mobile/launchpad/launchpad-address-book -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /kyc/submission-step; POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-310 | /launchpad/webhooks | /api/mobile/launchpad/launchpad-webhooks -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-311 | /launchpad/gas-tracker | /api/mobile/launchpad/launchpad-gas-tracker -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-312 | /launchpad/rebalance | /api/mobile/launchpad/launchpad-rebalance -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-313 | /launchpad/multisig | /api/mobile/launchpad/launchpad-multisig -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-314 | /launchpad/swap-aggregator | /api/mobile/launchpad/launchpad-swap-aggregator -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-315 | /launchpad/limit-orders | /api/mobile/launchpad/launchpad-limit-orders -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /orders/:id/action where applicable; POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-316 | /launchpad/dca-builder | /api/mobile/launchpad/launchpad-dca-builder -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable; POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-317 | /launchpad/risk-analytics | /api/mobile/launchpad/launchpad-risk-analytics -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-318 | /launchpad/sample | /api/mobile/launchpad/launchpad-sample -> { launchpadProjects, subscriptions, claims, bridgeOrders, contracts } | POST /launchpad/subscribe\|claim\|bridge where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### rewards contracts (1)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-319 | /rewards | /api/mobile/rewards/rewards -> { rewardsReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### enterprise-states contracts (1)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-320 | /enterprise-states | /api/mobile/enterprise-states/enterprise-states -> { enterprise-statesReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### cross-module contracts (4)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-321 | /unified-portfolio | /api/mobile/cross-module/unified-portfolio -> { cross-moduleReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-322 | /cross-module-analytics | /api/mobile/cross-module/cross-module-analytics -> { cross-moduleReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-323 | /smart-alerts | /api/mobile/cross-module/smart-alerts -> { cross-moduleReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-324 | /tax-reports | /api/mobile/cross-module/tax-reports -> { cross-moduleReferenceData, screenState } | POST /exports | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### dev contracts (5)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-325 | /dev/route-checker | /api/mobile/dev/dev-route-checker -> { devReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |
| SC-326 | /dev/performance-monitor | /api/mobile/dev/dev-performance-monitor -> { devReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |
| SC-398 | /dev/showcase | /api/mobile/dev/dev-showcase -> { devReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |
| SC-399 | /dev/design-system | /api/mobile/dev/dev-design-system -> { devReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |
| SC-400 | /dev/dca-overview | /api/mobile/dev/dev-dca-overview -> { devReferenceData, screenState } | POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |

### earn contracts (70)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-327 | /earn | /api/mobile/earn/earn -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-328 | /earn/staking | /api/mobile/earn/earn-staking -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-329 | /earn/savings | /api/mobile/earn/earn-savings -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-330 | /earn/savings/product/sample | /api/mobile/earn/earn-savings-product-sample -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-331 | /earn/savings/redeem/pos001 | /api/mobile/earn/earn-savings-redeem-pos001 -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-332 | /earn/savings/receipt | /api/mobile/earn/earn-savings-receipt -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-333 | /earn/savings/portfolio | /api/mobile/earn/earn-savings-portfolio -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-334 | /earn/savings/history | /api/mobile/earn/earn-savings-history -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-335 | /earn/savings/guide | /api/mobile/earn/earn-savings-guide -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-336 | /earn/savings/faq | /api/mobile/earn/earn-savings-faq -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-337 | /earn/savings/notifications | /api/mobile/earn/earn-savings-notifications -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; PATCH /user/settings or module settings | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-338 | /earn/savings/recommendations | /api/mobile/earn/earn-savings-recommendations -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-339 | /earn/savings/risk-assessment | /api/mobile/earn/earn-savings-risk-assessment -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-340 | /earn/savings/comparison | /api/mobile/earn/earn-savings-comparison -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-341 | /earn/savings/auto-compound | /api/mobile/earn/earn-savings-auto-compound -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-342 | /earn/savings/goals | /api/mobile/earn/earn-savings-goals -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-343 | /earn/savings/analytics | /api/mobile/earn/earn-savings-analytics -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-344 | /earn/savings/rebalance | /api/mobile/earn/earn-savings-rebalance -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-345 | /earn/savings/notification-preferences | /api/mobile/earn/earn-savings-notification-preferences -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-346 | /earn/savings/dca | /api/mobile/earn/earn-savings-dca -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; POST /dca/plans\|rebalance\|schedule | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-347 | /earn/savings/smart-suggestions | /api/mobile/earn/earn-savings-smart-suggestions -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-348 | /earn/savings/export | /api/mobile/earn/earn-savings-export -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; POST /exports | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-349 | /earn/savings/backtest | /api/mobile/earn/earn-savings-backtest -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-350 | /earn/savings/autopilot | /api/mobile/earn/earn-savings-autopilot -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-351 | /earn/savings/ladder | /api/mobile/earn/earn-savings-ladder -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-352 | /earn/savings/whatif | /api/mobile/earn/earn-savings-whatif -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-353 | /earn/staking/terms | /api/mobile/earn/earn-staking-terms -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-354 | /earn/staking/risk-disclosure | /api/mobile/earn/earn-staking-risk-disclosure -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-355 | /earn/staking/withdrawal-policy | /api/mobile/earn/earn-staking-withdrawal-policy -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /wallet/withdraw-preview + POST /wallet/withdraw-confirm; POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline, submitting, success | High-risk action: preview + confirm + audit trail required. |
| SC-356 | /earn/staking/tax-guide | /api/mobile/earn/earn-staking-tax-guide -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; POST /exports | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-357 | /earn/staking/risk-assessment | /api/mobile/earn/earn-staking-risk-assessment -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-358 | /earn/dashboard | /api/mobile/earn/earn-dashboard -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-359 | /earn/analytics | /api/mobile/earn/earn-analytics -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-360 | /earn/history | /api/mobile/earn/earn-history -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-361 | /earn/calendar | /api/mobile/earn/earn-calendar -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-362 | /earn/validator-selection | /api/mobile/earn/earn-validator-selection -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-363 | /earn/auto-compound | /api/mobile/earn/earn-auto-compound -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-364 | /earn/liquid-staking | /api/mobile/earn/earn-liquid-staking -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-365 | /earn/insurance | /api/mobile/earn/earn-insurance -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-366 | /earn/advanced-orders | /api/mobile/earn/earn-advanced-orders -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /orders/:id/action where applicable; POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline, submitting, success | Match screenshot first; wire BE after visual parity. |
| SC-367 | /earn/multi-chain | /api/mobile/earn/earn-multi-chain -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-368 | /earn/institutional | /api/mobile/earn/earn-institutional -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-369 | /earn/guide | /api/mobile/earn/earn-guide -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-370 | /earn/faq | /api/mobile/earn/earn-faq -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-371 | /earn/notifications | /api/mobile/earn/earn-notifications -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; PATCH /user/settings or module settings | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-372 | /earn/recommendations | /api/mobile/earn/earn-recommendations -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-373 | /earn/regulatory-framework | /api/mobile/earn/earn-regulatory-framework -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-374 | /earn/audit-reports | /api/mobile/earn/earn-audit-reports -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; POST /exports | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-375 | /earn/custody | /api/mobile/earn/earn-custody -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-376 | /earn/suitability-assessment | /api/mobile/earn/earn-suitability-assessment -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-377 | /earn/insurance-fund-transparency | /api/mobile/earn/earn-insurance-fund-transparency -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-378 | /earn/transaction-reporting | /api/mobile/earn/earn-transaction-reporting -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; POST /exports | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-379 | /earn/api-documentation | /api/mobile/earn/earn-api-documentation -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-380 | /earn/proof-of-reserves | /api/mobile/earn/earn-proof-of-reserves -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-381 | /earn/risk-dashboard | /api/mobile/earn/earn-risk-dashboard -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline, realtime-refresh | Match screenshot first; wire BE after visual parity. |
| SC-382 | /earn/slashing-history | /api/mobile/earn/earn-slashing-history -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-383 | /earn/validator-health-monitor | /api/mobile/earn/earn-validator-health-monitor -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-384 | /earn/risk-score-calculator | /api/mobile/earn/earn-risk-score-calculator -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-385 | /earn/emergency-actions | /api/mobile/earn/earn-emergency-actions -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-386 | /earn/contingency-plan | /api/mobile/earn/earn-contingency-plan -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-387 | /earn/social-feed | /api/mobile/earn/earn-social-feed -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-388 | /earn/community-governance | /api/mobile/earn/earn-community-governance -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-389 | /earn/proposals | /api/mobile/earn/earn-proposals -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-390 | /earn/voting/prop001 | /api/mobile/earn/earn-voting-prop001 -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-391 | /earn/voting | /api/mobile/earn/earn-voting -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-392 | /earn/forum | /api/mobile/earn/earn-forum -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-393 | /earn/webhooks | /api/mobile/earn/earn-webhooks -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-394 | /earn/data-export | /api/mobile/earn/earn-data-export -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable; POST /exports | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-395 | /earn/third-party-integrations | /api/mobile/earn/earn-third-party-integrations -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |
| SC-396 | /earn/developer-console | /api/mobile/earn/earn-developer-console -> { earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData } | POST /earn/subscribe\|redeem\|claim\|vote where applicable | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |

### onboarding contracts (1)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-397 | /onboarding | /api/mobile/onboarding/onboarding -> { onboardingReferenceData, screenState } | read-only or local navigation action | loading, empty, error, offline | Match screenshot first; wire BE after visual parity. |

### demo contracts (1)

| ID | Route | Read model | Actions / mutations | States | Notes |
| --- | --- | --- | --- | --- | --- |
| SC-401 | /demo/copy-card | /api/mobile/demo/demo-copy-card -> { demoReferenceData, screenState } | POST /copy-trading/follow\|configure\|stop where applicable | loading, empty, error, offline | Reference/admin surface; gate behind internal role or dev flag. |

## Acceptance Gates

- Coverage gate: manifest rows must remain 401; Screen Checklist Flutter status rows must remain 401.
- Screenshot gate: every checklist row must keep both viewport and fullpage reference paths.
- Navigation gate: no `NEEDS_MANUAL_CONFIRM` edge can be ignored; it must be confirmed, removed with reason, or mapped to a Flutter route.
- BE gate: every production screen must have a repository/interface and state model before replacing mock data.
- Visual gate: Flutter screen must be compared against reference screenshot at 440x956 before status moves to QA done.
