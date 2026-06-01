# VitTrade Screen Navigation Connection Audit

Generated: 2026-06-01

Scope: audit cac man hinh Flutter hien tai bang router chinh thuc, bottom navigation, va cac handler dieu huong `context.go/push/replace/pop` hoac `Navigator.*` trong `flutter_app/lib`.

## Executive Summary

- Router truth table hien dang current: 417 route declarations, trong do 414 `real_page`, 3 `redirect_alias`.
- Da quet 913 navigation handlers trong source UI/widgets. 431 handler co target route tinh/dinh danh duoc; 137 handler la back/close modal. Cac target dong nhu `snapshot.backRoute`, `item.route`, `module.route`, `tx.route` duoc giu nguyen trong CSV de truy ve data source.
- Bang chi tiet tung nut/handler: `docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Navigation-Edges.csv`.
- Bang route day du cua du an: `docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md`.

## Global Shell Va Bottom Navigation

- Initial route mac dinh: `/home`; root `/` redirect ve `/home`.
- App dung `ShellRoute` boc cac route module va render `VitAppShell`; bottom nav goi `context.go(destination.routePath)`.
- 5 tab co dinh:

| Tab | Route | Ghi chu active |
| --- | --- | --- |
| Trang chu | `/home` | Mac dinh neu khong match route khac |
| Thi truong | `/markets` | Active cho `/markets...` |
| Giao dich | `/trade` | Active cho `/trade`, `/pair`, `/dca`, `/earn`, `/admin`, `/rewards`, `/p2p`, `/arena`, `/support`, `/launchpad`, `/search`, `/notifications`, cross-module va dev routes |
| Vi | `/wallet` | Active cho `/wallet...` |
| Toi | `/profile` | Active cho `/profile...` |

Nhan xet: app hien gom rat nhieu module duoi active tab `Giao dich`. Neu sau nay san pham lon hon, nen can nhac module launcher/menu hoac tab phu de tranh cam giac tat ca deu nam trong mot tab.

## Route Groups

| Route group | Real pages | Prefix/hub | Vi du route dau tien |
| --- | ---: | --- | --- |
| `admin` | 4 | `/admin` | `/admin, /admin/analytics, /admin/abtests, /admin/funnels` |
| `arena` | 25 | `/arena` | `/arena, /arena/guide, /arena/studio, /arena/studio/smart-rules, /arena/studio/presets` |
| `auth` | 7 | `/auth` | `/auth/login, /auth/register, /auth/otp, /auth/2fa-setup, /auth/forgot-password` |
| `dca` | 11 | `/dca` | `/dca, /dca/portfolio-optimizer, /dca/dynamic-amount, /dca/backtester, /dca/multi-asset` |
| `earn` | 70 | `/earn` | `/earn, /earn/staking, /earn/staking/terms, /earn/staking/risk-disclosure, /earn/staking/withdrawal-policy` |
| `home` | 2 | `/home` | `/home, /news` |
| `launchpad` | 24 | `/launchpad` | `/launchpad, /launchpad/portfolio, /launchpad/performance, /launchpad/staking, /launchpad/idobridge/sample` |
| `markets` | 22 | `/markets + /pair` | `/markets, /markets/overview, /markets/movers, /markets/sectors, /markets/watchlist` |
| `p2p` | 79 | `/p2p` | `/p2p/express, /p2p/express/confirm, /p2p/order/timeline/:orderId, /p2p/order/rate/:orderId, /p2p/order/cancel/:orderId` |
| `placeholder` | 5 | `` | `/dca/rebalance/:configId/edit, /dca/rebalance/:configId/history, /admin/settings, /trade/copy-trading/client-opt-up-request, /settings/security` |
| `predictions` | 18 | `/markets/predictions` | `/markets/predictions, /markets/predictions/search, /markets/predictions/breaking, /markets/predictions/event/:eventId, /markets/predictions/portfolio` |
| `profile` | 13 | `/profile` | `/profile, /profile/edit, /profile/kyc, /profile/security, /profile/settings` |
| `support` | 3 | `/support` | `/support, /support/help, /support/announcements` |
| `trade` | 89 | `/trade` | `/trade/advanced-chart/:pairId, /trade, /trade/convert, /trade/bots, /trade/bots/terms-of-service` |
| `utility` | 21 | `/search, /notifications, /rewards, /dev, cross-module` | `/rewards, /enterprise-states, /unified-portfolio, /cross-module-analytics, /smart-alerts` |
| `wallet` | 21 | `/wallet` | `/wallet, /wallet/history, /wallet/deposit, /wallet/deposit/:asset, /wallet/withdraw` |

## Luong Man Hinh Chinh Theo Module

### Auth

- `/auth/login`: login thanh cong hoac demo login -> `/home`; quen mat khau -> `/auth/forgot-password`; tao tai khoan -> `/auth/register`.
- `/auth/register`: back/dang nhap -> `/auth/login`; submit dang ky -> `/auth/otp` kem query/extra tu flow dang ky.
- `/auth/otp`: verify thanh cong -> `/home` hoac `/auth/2fa-setup`; reset password flow -> `/auth/reset-password`; back -> `/auth/login`.
- `/auth/2fa-setup`: back -> pop neu co stack, fallback `/auth/otp`; hoan tat -> `/home`.
- `/auth/forgot-password`: back -> pop/fallback `/auth/login`; flow xong quay ve login/OTP tuy state controller.
- `/auth/reset-password`: back/fallback -> `/auth/login`; lien ket resend/forgot -> `/auth/forgot-password`; xong -> `/auth/login`.

### Home

- Header search icon -> `/search`; notification icon -> `/notifications`.
- Portfolio card: `Nap` -> `/wallet/deposit/USDT`; `Rut` -> `/wallet/withdraw/USDT`; `Vi` -> `/wallet`; eye icon chi toggle so du, khong doi route.
- Quick services: Kham pha -> `/topics`; Mua nhanh -> `/trade/btcusdt`; Convert -> `/trade/convert`; P2P -> `/p2p`; Launchpad -> `/launchpad`; Staking -> `/earn/staking`; Mua dinh ky -> `/dca`; Bot -> `/trade/bots`; Copy Trade -> `/trade/copy-trading`; Tiet kiem -> `/earn/savings`; Phan thuong -> `/rewards`; Margin -> `/trade/margin`; Gioi thieu -> `/referral`.
- Discovery cards: Prediction Markets -> `/markets/predictions`; Open Arena -> `/arena`.
- Market/trending/ranked rows -> `/pair/<pairId>`; cac nut `Xem tat ca` -> `/markets`.

### Markets Va Prediction Markets

- Hub `/markets` lien ket cac man hinh overview, movers, sectors, watchlist, heatmap, alerts, screener, compare, calendar, derivatives, depth, sentiment, tracker, news, charts, unlocks, signals, correlations.
- Token/pair rows -> `/pair/<pairId>`; pair detail co buy/sell CTA -> `/trade/<pairId>?side=buy|sell`; chart toolbar co the quay ve trade pair hoac markets.
- Prediction Markets nam duoi `/markets/predictions...`: home/search/breaking/event detail/portfolio/rewards/leaderboard/activity/receipt/risk calculator/market maker/analyzer/calendar/social/advanced chart/tournaments/data integration.
- Prediction va Arena co bridge qua topic/search/discovery, nhung route tach namespace: Predictions la `/markets/predictions...`, Arena la `/arena...`.

### Trade

- `/trade` va `/trade/<pairId>` la man hinh giao dich chinh; submit order -> `/trade/order-receipt`; pair row -> `/trade/<pairId>`.
- Quick tools trong trade: Convert -> `/trade/convert`; DCA -> `/dca`; Futures -> `/trade/<pairId>/futures`; Positions -> `/trade/positions`; Settings -> `/trade/settings`.
- Futures -> leverage `/trade/<pairId>/futures/leverage`, chart `/trade/advanced-chart/<pairId>`, back spot -> `/trade/<pairId>`.
- Order receipt: back -> `/trade`; continue -> `/trade/btcusdt`; orders history link -> `/trade/orders-history`.
- Copy trading subflow: `/trade/copy-trading` -> provider detail `/trade/copy-provider/<id>` -> assessment -> configuration -> confirmation -> active copies/performance/audit log. Regulatory/support pages quay ve `/trade/copy-trading` hoac parent compliance route.
- Margin subflow: `/trade/margin` va `/trade/margin/...`; hub cards dung `item.targetPath`, cac page back ve `/trade/margin` hoac `/trade`.

### Wallet

- `/wallet` la hub vi; asset/action rows dieu huong qua route trong data: deposit, withdraw, transfer, history, analytics, address book, buy crypto, multi-manager, gas optimizer, token approval, health score, pending deposits, limits, dust converter, network status, asset detail.
- Deposit/withdraw asset-specific routes: `/wallet/deposit/<asset>`, `/wallet/withdraw/<asset>`; cac picker/preview sheet dung `Navigator.pop` de dong modal.
- Address book -> add address `/wallet/address-book/add`; add flow preview/confirm dong modal va quay ve address book.
- Transaction history row -> `/wallet/transaction/<transactionId>`; transaction detail co support/copy/local actions.

### Profile

- `/profile`: edit -> `/profile/edit`; predictions -> `/profile/predictions`; arena -> `/profile/arena`; activity -> `/profile/activity`; logout -> `/auth/login`.
- Security menu item route tu data (`item.route`) -> profile security/device/api/kyc/settings/vip/sub-accounts/activity; subpages back/pop fallback ve `/profile`.
- API management: create -> `/profile/api/create`; create result/back -> `/profile/api`; delete/reveal/copy la local dialog/state.
- VIP CTA -> `/trade/btcusdt`.

### P2P

- P2P namespace la `/p2p...`; co cac group: express/confirm, order lifecycle, chat, dispute, ads/merchant, payment methods, insurance, escrow, KYC, security, wallet, limits/compliance/tax, dashboard/settings/guide.
- Order flow: `/p2p/express` -> `/p2p/express/confirm` -> order detail `/p2p/order/<id>` -> timeline/rate/cancel/proof/chat/dispute. Dispute route tach detail/evidence/resolution.
- High-risk/security flows co preview/confirm hoac route rieng: payment-method add/verification/ownership/cooling-period/history, escrow detail, KYC identity/address/selfie/video, security 2FA/devices/anti-phishing/login-history/suspicious activity.
- Nhieu nut trong P2P dung `snapshot.*Route`; CSV giu expression de truy ve repository mock/data source. Tat ca van nam duoi active tab `Giao dich`.

### Earn / Savings / Staking

- Staking root `/earn` va `/earn/staking`; cac route con gom terms, risk disclosure, withdrawal policy, tax guide, dashboard, analytics, history, calendar, validator selection, auto-compound, liquid staking, insurance, advanced orders, multichain, institutional, guide, FAQ, notifications, recommendations, regulatory, audit, custody, suitability, proof/reserves, risk dashboard, social/governance, proposals/voting/forum, webhooks/data export/integrations/developer console.
- Savings root `/earn/savings`; portfolio/history/guide/FAQ/notifications/recommendations/risk/comparison/auto-compound/goals/analytics/rebalance/preferences/DCA/smart suggestions/export/backtest/autopilot/ladder/what-if/product/redeem/receipt.
- Back route trong Earn phan lon la `snapshot.backRoute`; CTA noi bo nhu community governance -> proposals/forum, risk disclosure -> assessment, third-party integrations -> API docs.

### Arena

- Arena namespace `/arena...`: home, guide, studio, smart rules, presets, governance, mode detail, challenge detail, join, resolution, creator, leaderboard, verified, flow map, safety, blocked users, reports, my arena, production, bridge, ecosystem, trust breakdown, ledger/entry, report case.
- `/arena/points` la redirect alias sang `/rewards?tab=arena`; do do diem Arena hien di qua RewardsHub tab arena.
- Challenge flow: challenge detail -> join `/arena/join/<challengeId>` -> detail/resolution/ledger/report tuy action. Ledger row -> `/arena/ledger/entry/<entryId>`; report row -> `/arena/report/<caseId>`.
- Arena van giu boundary points-only; route tach voi Predictions, bridge chi nam o route `/arena/bridge` va discovery/topic surfaces.

### DCA, Launchpad, Referral, Support, Cross-module

- DCA: `/dca` -> optimizer/dynamic/backtester/multi-asset/performance/smart-rules/rebalance config/dashboard/schedule config/analytics; rebalance config submit -> dashboard; back fallback -> `/trade` hoac `/dca`.
- Launchpad: `/launchpad` -> portfolio/performance/staking/IDO bridge/contract/receipt/claim/batch/bridge/gas/rebalance/multisig/swap/limit/DCA/risk/detail; portfolio/receipt success quay ve portfolio hoac launchpad.
- Referral: `/referral` -> history/rewards/rules/friend detail; friend rows -> `/referral/friend/<id>`; back route tu snapshot ve parent.
- Support: `/support` -> help/announcements; help quick actions co chat/ticket routes trong snapshot, neu route chua duoc khai bao thi can route guard/placeholder khi mo that.
- Cross-module: unified portfolio, cross-module analytics, smart alerts, tax reports dieu huong bang `snapshot.backRoute` va `module.route` sang cac module con.

## Edge Table Rut Gon

Bang duoi chi la mau dai dien theo module. File CSV moi la danh sach day du tung handler.

### `app`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/app/router/route_groups/root_routes.dart` | 29 | - | `context.go` | `destination.routePath` | - |

### `auth`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/auth/presentation/pages/forgot_password_page.dart` | 89 | - | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/forgot_password_page.dart` | 300 | - | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/login_page.dart` | 89 | - | `context.go` | `/home` | HomePage (/home) |
| `lib/features/auth/presentation/pages/login_page.dart` | 281 | - | `context.go` | `/auth/forgot-password` | _AuthRouteShell (/auth/forgot-password) |
| `lib/features/auth/presentation/pages/login_page.dart` | 324 | Đăng nhập Demo | `context.go` | `/auth/register` | _AuthRouteShell (/auth/register) |
| `lib/features/auth/presentation/pages/otp_page.dart` | 170 | - | `context.go` | `/auth/2fa-setup` | _AuthRouteShell (/auth/2fa-setup) |
| `lib/features/auth/presentation/pages/otp_page.dart` | 172 | - | `context.go` | `/home` | HomePage (/home) |
| `lib/features/auth/presentation/pages/otp_page.dart` | 175 | - | `context.go` | `/auth/reset-password` | _AuthRouteShell (/auth/reset-password) |
| `lib/features/auth/presentation/pages/otp_page.dart` | 178 | - | `context.go` | `/auth/reset-password` | _AuthRouteShell (/auth/reset-password) |
| `lib/features/auth/presentation/pages/otp_page.dart` | 229 | Xác minh OTP / Xác thực · Bảo mật / SC-003 OTPPage | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/register_page.dart` | 140 | - | `context.go` | `/auth/otp` | _AuthRouteShell (/auth/otp) |
| `lib/features/auth/presentation/pages/register_page.dart` | 174 | Tạo tài khoản / Xác thực · Đăng ký / SC-002 RegisterPage | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/register_page.dart` | 323 | Tiếp tục | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/reset_password_page.dart` | 108 | - | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/reset_password_page.dart` | 265 | - | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/reset_password_page.dart` | 285 | Xác minh lại | `context.go` | `/auth/forgot-password` | _AuthRouteShell (/auth/forgot-password) |
| `lib/features/auth/presentation/pages/reset_password_page.dart` | 291 | Xác minh lại | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/reset_password_page.dart` | 311 | Đăng nhập | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/auth/presentation/pages/two_fa_setup_page.dart` | 73 | - | `context.go` | `/auth/otp` | _AuthRouteShell (/auth/otp) |
| `lib/features/auth/presentation/pages/two_fa_setup_page.dart` | 173 | - | `context.go` | `/home` | HomePage (/home) |

### `home`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/home/presentation/pages/home_page_part_01.dart` | 17 | - | `context.go` | `path` | - |

### `markets`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/markets/presentation/pages/advanced_charts_page_part_01.dart` | 37 | Phân tích kỹ thuật / SC-023 AdvancedChartsPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/comparison_tool_page.dart` | 107 | So sánh / SC-016 ComparisonToolPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/derivatives_overview_page.dart` | 66 | Phái sinh / SC-018 DerivativesOverviewPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_calendar_page.dart` | 89 | Lịch sự kiện / SC-017 MarketCalendarPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_correlations_page.dart` | 79 | Tương quan thị trường / SC-026 MarketCorrelationsPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_depth_page.dart` | 69 | ${snapshot.pair.baseAsset} Depth / SC-019 MarketDepthPage | `context.go` | `widget.backPath` | - |
| `lib/features/markets/presentation/pages/market_heatmap_page.dart` | 74 | Market Heatmap / Bản đồ · Markets / SC-013 MarketHeatmapPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_heatmap_page.dart` | 130 | - | `context.go` | `/pair/${selectedCoin.id}usdt` | PairDetailPage (/pair/:pairId) |
| `lib/features/markets/presentation/pages/market_list_page.dart` | 76 | - | `context.go` | `path` | - |
| `lib/features/markets/presentation/pages/market_movers_page.dart` | 146 | Biến động thị trường / SC-010 MarketMoversPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_movers_page.dart` | 223 | Xóa bộ lọc | `context.go` | `/pair/${mover.id}usdt` | PairDetailPage (/pair/:pairId) |
| `lib/features/markets/presentation/pages/market_news_page.dart` | 71 | Tin thị trường / SC-022 MarketNewsPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_news_page.dart` | 129 | - | `context.go` | `/pair/${token.toLowerCase()}usdt` | PairDetailPage (/pair/:pairId) |
| `lib/features/markets/presentation/pages/market_overview_page.dart` | 68 | Tổng quan thị trường / SC-009 MarketOverviewPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_overview_page_part_02.dart` | 126 | - | `context.go` | `route` | - |
| `lib/features/markets/presentation/pages/market_overview_page_part_02.dart` | 211 | - | `context.go` | `/markets/movers` | MarketMoversPage (/markets/movers) |
| `lib/features/markets/presentation/pages/market_overview_page_part_02.dart` | 352 | Hiệu suất ngành | `context.go` | `/markets/sectors?id=${sector.id}` | MarketSectorsPage (/markets/sectors) |
| `lib/features/markets/presentation/pages/market_overview_page_part_02.dart` | 356 | Hiệu suất ngành | `context.go` | `/markets/sectors` | MarketSectorsPage (/markets/sectors) |
| `lib/features/markets/presentation/pages/market_overview_page_part_03.dart` | 185 | - | `context.go` | `route` | - |
| `lib/features/markets/presentation/pages/market_screener_page.dart` | 172 | Bộ lọc thị trường / SC-015 MarketScreenerPage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_screener_page.dart` | 221 | - | `context.go` | `/pair/${pair.id}` | PairDetailPage (/pair/:pairId) |
| `lib/features/markets/presentation/pages/market_sectors_page.dart` | 84 | - | `context.go` | `/markets/sectors` | MarketSectorsPage (/markets/sectors) |
| `lib/features/markets/presentation/pages/market_sectors_page.dart` | 87 | - | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/markets/presentation/pages/market_sectors_page.dart` | 127 | - | `context.go` | `/markets/sectors?id=${sector.id}` | MarketSectorsPage (/markets/sectors) |
| `lib/features/markets/presentation/pages/market_sectors_page.dart` | 149 | - | `context.go` | `/pair/${coin.id}usdt` | PairDetailPage (/pair/:pairId) |

_Con 24 edge khac trong CSV._

### `predictions`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/predictions/presentation/pages/prediction_advanced_chart_page_part_01.dart` | 63 | Advanced Chart / SC-041 PredictionAdvancedChartPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_data_integration_page.dart` | 96 | Data Integration / SC-043 PredictionDataIntegrationPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart` | 75 | Event Calendar / SC-039 PredictionEventCalendarPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` | 131 | Event Detail / Chi tiết · Prediction / SC-030 PredictionEventDetailPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` | 218 | - | `context.go` | `/arena/studio` | ArenaStudioPage (/arena/studio) |
| `lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` | 222 | - | `context.go` | `/markets/predictions/rewards` | PredictionsRewardsPage (/markets/predictions/rewards) |
| `lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` | 223 | - | `context.go` | `/markets/predictions/activity` | PredictionsGlobalActivityPage (/markets/predictions/activity) |
| `lib/features/predictions/presentation/pages/prediction_market_maker_page.dart` | 111 | Market Maker / SC-037 PredictionMarketMakerPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_order_receipt_page.dart` | 66 | Chi tiết lệnh / Biên lai · Prediction / SC-035 PredictionOrderReceiptPage | `context.go` | `/markets/predictions/portfolio` | PredictionsPortfolioPage (/markets/predictions/portfolio) |
| `lib/features/predictions/presentation/pages/prediction_portfolio_analyzer_page.dart` | 71 | Portfolio Analyzer / SC-038 PredictionPortfolioAnalyzerPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_risk_calculator_page.dart` | 137 | Risk Calculator / SC-036 PredictionRiskCalculatorPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_social_page.dart` | 93 | Social & Discussion / SC-040 PredictionSocialPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/prediction_tournaments_page.dart` | 72 | Tournaments / SC-042 PredictionTournamentsPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/predictions_breaking_page.dart` | 80 | Breaking Movers / Biến động · Prediction / SC-029 PredictionsBreakingPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/predictions_breaking_page.dart` | 116 | - | `context.go` | `/markets/predictions/event/<snapshot.movers[index].id>` | PredictionEventDetailPage (/markets/predictions/event/:eventId) |
| `lib/features/predictions/presentation/pages/predictions_global_activity_page.dart` | 70 | Global Activity / Hoạt động · Prediction / SC-034 PredictionsGlobalActivityPage | `context.go` | `/markets/predictions/event/pred-1` | PredictionEventDetailPage (/markets/predictions/event/:eventId) |
| `lib/features/predictions/presentation/pages/predictions_home_page.dart` | 81 | Prediction Markets / Thị trường dự đoán / SC-027 PredictionsHomePage | `context.go` | `/markets` | MarketListPage (/markets) |
| `lib/features/predictions/presentation/pages/predictions_home_page.dart` | 94 | Prediction Markets / Thị trường dự đoán | `context.go` | `/markets/predictions/search` | PredictionsSearchPage (/markets/predictions/search) |
| `lib/features/predictions/presentation/pages/predictions_home_page.dart` | 148 | My Predictions / ${snapshot.openPositionCount} open positions | `context.go` | `/profile/predictions` | PredictionsPortfolioPage (/profile/predictions) |
| `lib/features/predictions/presentation/pages/predictions_home_page.dart` | 152 | My Predictions / ${snapshot.openPositionCount} open positions | `context.go` | `/markets/predictions/breaking` | PredictionsBreakingPage (/markets/predictions/breaking) |
| `lib/features/predictions/presentation/pages/predictions_home_page.dart` | 157 | My Predictions / ${snapshot.openPositionCount} open positions | `context.go` | `/arena` | ArenaHomePage (/arena) |
| `lib/features/predictions/presentation/pages/predictions_home_page.dart` | 167 | - | `context.go` | `/markets/predictions/event/<event.id>` | PredictionEventDetailPage (/markets/predictions/event/:eventId) |
| `lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart` | 77 | Leaderboard / Bảng xếp hạng · Prediction / SC-033 PredictionsLeaderboardPage | `context.go` | `/markets/predictions` | PredictionsHomePage (/markets/predictions) |
| `lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` | 80 | Prediction Portfolio / Danh m\u1ee5c \u00b7 Prediction | `context.go` | `widget.backPath` | - |
| `lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` | 137 | Closed positions will appear here | `context.go` | `/arena` | ArenaHomePage (/arena) |

_Con 16 edge khac trong CSV._

### `trade`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/trade/presentation/pages/active_copies_page.dart` | 83 | Copy đang chạy / SC-066 ActiveCopiesPage | `context.go` | `/trade/copy-trading` | CopyTradingPage (/trade/copy-trading) |
| `lib/features/trade/presentation/pages/active_copies_page.dart` | 85 | Copy đang chạy / SC-066 ActiveCopiesPage | `context.go` | `/trade/copy-trading` | CopyTradingPage (/trade/copy-trading) |
| `lib/features/trade/presentation/pages/active_copies_page.dart` | 110 | - | `context.go` | `/trade/copy-trading` | CopyTradingPage (/trade/copy-trading) |
| `lib/features/trade/presentation/pages/active_copies_page.dart` | 123 | - | `context.go` | `/trade/copy-provider/<copy.providerId>` | CopyProviderDetailPage (/trade/copy-provider/:providerId) |
| `lib/features/trade/presentation/pages/active_copies_page.dart` | 129 | - | `context.go` | `/trade/copy-provider/<copy.providerId>/configuration` | CopyConfigurationPage (/trade/copy-provider/:providerId/configuration) |
| `lib/features/trade/presentation/pages/advanced_analytics_page_part_01.dart` | 30 | Advanced Analytics / AI & Professional Tools / SC-092 AdvancedAnalyticsPage | `context.go` | `/trade/margin` | MarginTradingPage (/trade/margin) |
| `lib/features/trade/presentation/pages/advanced_tools_demo_page.dart` | 78 | Advanced Trading Tools / SC-062 AdvancedToolsDemoPage | `context.go` | `/trade` | TradePage (/trade) |
| `lib/features/trade/presentation/pages/advanced_trading_demo_page.dart` | 71 | Advanced Trading / Position & Order Controls / SC-088 AdvancedTradingDemoPage | `context.go` | `/trade/margin` | MarginTradingPage (/trade/margin) |
| `lib/features/trade/presentation/pages/arm_integration_status_page.dart` | 83 | ARM Integration / Connection Health · Monitoring / SC-095 ARMIntegrationStatusPage | `context.go` | `/trade/copy-trading/regulatory-reports-dashboard` | RegulatoryReportsDashboardPage (/trade/copy-trading/regulatory-reports-dashboard) |
| `lib/features/trade/presentation/pages/arm_integration_status_page.dart` | 115 | - | `context.go` | `/trade/copy-trading/transaction-reporting` | TransactionReportingPage (/trade/copy-trading/transaction-reporting) |
| `lib/features/trade/presentation/pages/arm_integration_status_page.dart` | 118 | - | `context.go` | `/trade/copy-trading/regulatory-reports-dashboard` | RegulatoryReportsDashboardPage (/trade/copy-trading/regulatory-reports-dashboard) |
| `lib/features/trade/presentation/pages/audit_trail_page.dart` | 71 | Audit Trail / MiFID II Record-Keeping / SC-115 AuditTrailPage | `context.go` | `/trade/copy-trading` | CopyTradingPage (/trade/copy-trading) |
| `lib/features/trade/presentation/pages/best_execution_reports_page.dart` | 75 | Best Execution Reports / RTS 27 / RTS 28 Compliance / SC-096 BestExecutionReportsPage | `context.go` | `/trade/copy-trading` | CopyTradingPage (/trade/copy-trading) |
| `lib/features/trade/presentation/pages/best_execution_reports_page.dart` | 99 | - | `context.go` | `/trade/copy-trading/execution-venue-analysis` | ExecutionVenueAnalysisPage (/trade/copy-trading/execution-venue-analysis) |
| `lib/features/trade/presentation/pages/bot_api_documentation_page.dart` | 85 | API Documentation / SC-134 BotAPIDocumentationPage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_backtesting_page.dart` | 87 | Backtest Strategy / SC-125 BotBacktestingPage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_drawdown_analyzer_page.dart` | 59 | Drawdown Analyzer / SC-129 BotDrawdownAnalyzerPage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_emergency_stop_page.dart` | 78 | Emergency Stop / SC-121 BotEmergencyStopPage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_emergency_stop_page.dart` | 143 | - | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_emergency_stop_page.dart` | 166 | - | `context.go` | `result.redirectPath` | - |
| `lib/features/trade/presentation/pages/bot_equity_curve_page.dart` | 67 | Equity Curve / SC-130 BotEquityCurvePage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_faq_page.dart` | 91 | Trading Bots FAQ / SC-132 BotFAQPage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_guide_page.dart` | 69 | Trading Bots Guide / SC-131 BotGuidePage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_history_page.dart` | 77 | Trade History / SC-123 BotHistoryPage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |
| `lib/features/trade/presentation/pages/bot_optimization_page.dart` | 65 | Parameter Optimization / SC-127 BotOptimizationPage | `context.go` | `/trade/bots` | TradingBotsPage (/trade/bots) |

_Con 125 edge khac trong CSV._

### `wallet`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/wallet/presentation/pages/address_add_page.dart` | 80 | SC-143 AddressAddPage | `context.go` | `/wallet/address-book` | AddressBookPage (/wallet/address-book) |
| `lib/features/wallet/presentation/pages/address_add_page.dart` | 100 | Thêm địa chỉ mới / Sổ địa chỉ · Wallet / SC-143 AddressAddPage | `context.go` | `/wallet/address-book` | AddressBookPage (/wallet/address-book) |
| `lib/features/wallet/presentation/pages/address_book_page.dart` | 91 | Sổ địa chỉ / Quản lý · Wallet / SC-144 AddressBookPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/address_book_page.dart` | 93 | Sổ địa chỉ / Quản lý · Wallet / SC-144 AddressBookPage | `context.go` | `/wallet/address-book/add` | AddressAddPage (/wallet/address-book/add) |
| `lib/features/wallet/presentation/pages/address_book_page.dart` | 159 | Tất cả địa chỉ | `context.go` | `/wallet/address-book/add` | AddressAddPage (/wallet/address-book/add) |
| `lib/features/wallet/presentation/pages/asset_detail_page.dart` | 69 | Chi tiết · Wallet / SC-147 AssetDetailPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/asset_detail_page.dart` | 82 | Chi tiết · Wallet | `context.go` | `route` | - |
| `lib/features/wallet/presentation/pages/asset_detail_page.dart` | 93 | - | `context.go` | `route` | - |
| `lib/features/wallet/presentation/pages/buy_crypto_page.dart` | 69 | - | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/buy_crypto_page.dart` | 93 | Giao dịch · Wallet / SC-145 BuyCryptoPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/deposit_page.dart` | 84 | Nạp ${snapshot.asset} / Nạp tiền · Wallet | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/dust_converter_page.dart` | 82 | Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF / SC-154 DustConverterPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/network_status_page.dart` | 59 | Tr\u1EA1ng th\u00E1i m\u1EA1ng / SC-155 NetworkStatusPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/pending_deposits_page.dart` | 71 | N\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD / SC-152 PendingDepositsPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/portfolio_analytics_page.dart` | 75 | Phân tích Danh mục / Phân tích · Wallet / SC-142 PortfolioAnalyticsPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/transaction_detail_page.dart` | 64 | Chi tiết giao dịch / Lịch sử · Wallet / SC-141 TransactionDetailPage | `context.go` | `/wallet/history` | TransactionHistoryPage (/wallet/history) |
| `lib/features/wallet/presentation/pages/transaction_detail_page.dart` | 72 | Chi tiết giao dịch / Lịch sử · Wallet / SC-141 TransactionDetailPage | `context.go` | `/wallet/history` | TransactionHistoryPage (/wallet/history) |
| `lib/features/wallet/presentation/pages/transaction_detail_page.dart` | 77 | Chi tiết giao dịch / Lịch sử · Wallet | `context.go` | `/support` | SupportPage (/support) |
| `lib/features/wallet/presentation/pages/transaction_history_page.dart` | 67 | Lịch sử giao dịch / Lịch sử · Wallet / SC-136 TxHistoryPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/transaction_history_page.dart` | 94 | - | `context.go` | `/wallet/transaction/<tx.id>` | TransactionDetailPage (/wallet/transaction/:txId) |
| `lib/features/wallet/presentation/pages/transfer_page.dart` | 82 | Chuyển nội bộ / Chuyển tiền · Wallet / SC-146 TransferPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart` | 73 | Gas Optimizer / SC-149 WalletGasOptimizerPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/wallet_health_score_page_part_01.dart` | 26 | Wallet Health / SC-151 WalletHealthScorePage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart` | 66 | Multi-Wallet Manager / SC-148 WalletMultiManagerPage | `context.go` | `/wallet` | WalletPage (/wallet) |
| `lib/features/wallet/presentation/pages/wallet_page.dart` | 144 | - | `context.go` | `route` | - |

_Con 4 edge khac trong CSV._

### `profile`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/profile/presentation/pages/activity_log_page.dart` | 139 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/api_key_create_page.dart` | 228 | API Key / Secret Key / \u0110\u00E3 l\u01B0u, quay l\u1EA1i / T\u1EA1o th\u00E0nh c\u00F4ng! | `context.go` | `/profile/api` | ApiManagementPage (/profile/api) |
| `lib/features/profile/presentation/pages/api_key_create_page.dart` | 263 | - | `context.go` | `/profile/api` | ApiManagementPage (/profile/api) |
| `lib/features/profile/presentation/pages/api_management_page.dart` | 118 | - | `context.go` | `/profile/api/create` | ApiKeyCreatePage (/profile/api/create) |
| `lib/features/profile/presentation/pages/api_management_page.dart` | 183 | Xo\u00E1 | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/device_management_page.dart` | 194 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/edit_profile_page.dart` | 168 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/kyc_page.dart` | 122 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/profile_page.dart` | 83 | - | `context.go` | `/profile/edit` | EditProfilePage (/profile/edit) |
| `lib/features/profile/presentation/pages/profile_page.dart` | 101 | D\u1EF1 \u0111o\u00E1n & Th\u00E1ch \u0111\u1EA5u | `context.go` | `/profile/predictions` | PredictionsPortfolioPage (/profile/predictions) |
| `lib/features/profile/presentation/pages/profile_page.dart` | 106 | D\u1EF1 \u0111o\u00E1n & Th\u00E1ch \u0111\u1EA5u | `context.go` | `/profile/arena` | MyArenaPage (/profile/arena) |
| `lib/features/profile/presentation/pages/profile_page.dart` | 118 | - | `context.go` | `/profile/activity` | ActivityLogPage (/profile/activity) |
| `lib/features/profile/presentation/pages/profile_page.dart` | 120 | - | `context.go` | `/auth/login` | _AuthRouteShell (/auth/login) |
| `lib/features/profile/presentation/pages/security_page.dart` | 122 | - | `context.go` | `item.route!` | - |
| `lib/features/profile/presentation/pages/security_page.dart` | 139 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/settings_page.dart` | 160 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/sub_account_page.dart` | 140 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/pages/vip_page.dart` | 122 | - | `context.go` | `/trade/btcusdt` | TradePage (/trade/:pairId) |
| `lib/features/profile/presentation/pages/vip_page.dart` | 130 | - | `context.go` | `/profile` | ProfilePage (/profile) |
| `lib/features/profile/presentation/widgets/profile_home_menu_actions.dart` | 43 | - | `context.go` | `item.route` | - |

### `p2p`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/p2p/presentation/pages/p2p_2fa_settings_page.dart` | 81 | 2FA cho P2P / Bảo mật · P2P / SC-254 P2P2FASettingsPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_achievements_page.dart` | 55 | SC-275 P2PAchievementsPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_ad_analytics_page.dart` | 58 | Phân tích quảng cáo / Phân tích · P2P / SC-223 P2PAdAnalyticsPage | `context.go` | `/p2p` | P2PHomePage (/p2p) |
| `lib/features/p2p/presentation/pages/p2p_ad_detail_page.dart` | 74 | Chi tiết quảng cáo / Quảng cáo · P2P / SC-224 P2PAdDetailPage | `context.go` | `/p2p` | P2PHomePage (/p2p) |
| `lib/features/p2p/presentation/pages/p2p_ad_detail_page.dart` | 129 | Mua ${ad.asset} | `context.go` | `/p2p/order/<snapshot.targetOrderId>` | P2POrderPage (/p2p/order/:orderId) |
| `lib/features/p2p/presentation/pages/p2p_address_proof_page.dart` | 73 | Proof of Address / KYC · P2P / SC-250 P2PAddressProofPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_address_proof_page.dart` | 144 | Gửi tài liệu | `context.go` | `snapshot.submitRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_aml_screening_page.dart` | 50 | SC-268 P2PAMLScreeningPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart` | 95 | Anti-Phishing Code / Bảo mật · P2P / SC-256 P2PAntiPhishingCodePage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart` | 54 | - | `context.go` | `snapshot.blacklistRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart` | 80 | SC-276 P2PBlacklistAddPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_blacklist_page.dart` | 78 | SC-277 P2PBlacklistPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_blacklist_page.dart` | 82 | SC-277 P2PBlacklistPage | `context.go` | `snapshot.addRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_chat_page.dart` | 81 | SC-217 P2PChatPage | `context.go` | `/p2p/e2e-info` | P2PE2EInfoPage (/p2p/e2e-info) |
| `lib/features/p2p/presentation/pages/p2p_chat_page.dart` | 105 | - | `context.go` | `/p2p/e2e-info` | P2PE2EInfoPage (/p2p/e2e-info) |
| `lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart` | 38 | Bảo hiểm · P2P / SC-243 P2PClaimDetailPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart` | 101 | Xem đơn hàng gốc / Liên hệ hỗ trợ | `context.go` | `snapshot.orderRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart` | 48 | SC-267 P2PComplianceOverviewPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart` | 192 | - | `context.go` | `item.route` | - |
| `lib/features/p2p/presentation/pages/p2p_contribution_history_page.dart` | 58 | Lịch sử đóng góp / Bảo hiểm · P2P / SC-242 P2PContributionHistoryPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_create_ad_page.dart` | 116 | Đăng quảng cáo P2P / Tạo mới · P2P / SC-226 P2PCreateAdPage | `context.go` | `/p2p/my-ads` | P2PMyAdsPage (/p2p/my-ads) |
| `lib/features/p2p/presentation/pages/p2p_create_ad_page.dart` | 472 | - | `context.go` | `/p2p/my-ads` | P2PMyAdsPage (/p2p/my-ads) |
| `lib/features/p2p/presentation/pages/p2p_dashboard_page.dart` | 80 | SC-274 P2PDashboardPage | `context.go` | `snapshot.parentRoute` | - |
| `lib/features/p2p/presentation/pages/p2p_dashboard_page_part_02.dart` | 129 | Top Merchants | `context.go` | `/p2p/merchant/${snapshot.topMerchants[index].id}` | P2PMerchantProfilePage (/p2p/merchant/:merchantId) |
| `lib/features/p2p/presentation/pages/p2p_dashboard_page_part_02.dart` | 165 | Hoạt động gần đây / Xem tất cả | `context.go` | `snapshot.myOrdersRoute` | - |

_Con 150 edge khac trong CSV._

### `earn`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/earn/presentation/pages/auto_compound_settings_page_part_01.dart` | 38 | SC-341 AutoCompoundSettingsPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_analytics_page.dart` | 69 | SC-343 SavingsAnalyticsPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_auto_rebalance_page.dart` | 89 | SC-344 SavingsAutoRebalancePage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_autopilot_page.dart` | 91 | SC-350 SavingsAutoPilotPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_autopilot_page.dart` | 122 | - | `context.go` | `route` | - |
| `lib/features/earn/presentation/pages/savings_backtest_page.dart` | 103 | SC-349 SavingsBacktestPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_backtest_page.dart` | 146 | - | `context.go` | `snapshot.recommendationsRoute` | - |
| `lib/features/earn/presentation/pages/savings_comparison_page.dart` | 74 | SC-340 SavingsComparisonPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_dca_page.dart` | 71 | SC-346 SavingsDCAPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_export_page.dart` | 93 | SC-348 SavingsExportPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_faq_page.dart` | 71 | SC-336 SavingsFAQPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_goal_page_part_01.dart` | 33 | SC-342 SavingsGoalPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_guide_page.dart` | 65 | SC-335 SavingsGuidePage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_history_page.dart` | 65 | SC-334 SavingsHistoryPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_ladder_page.dart` | 92 | SC-351 SavingsLadderPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_notification_preferences_page.dart` | 89 | SC-345 SavingsNotificationPreferencesPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_notifications_page.dart` | 79 | SC-337 SavingsNotificationsPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_page.dart` | 79 | SC-329 SavingsPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_portfolio_page_part_01.dart` | 30 | SC-333 SavingsPortfolioPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_portfolio_page_part_01.dart` | 268 | Cố định / Gửi thêm / Rút | `context.go` | `snapshot.savingsRoute` | - |
| `lib/features/earn/presentation/pages/savings_portfolio_page_part_01.dart` | 276 | Gửi thêm / Rút / Lịch sử | `context.go` | `snapshot.savingsRoute` | - |
| `lib/features/earn/presentation/pages/savings_portfolio_page_part_01.dart` | 285 | Rút / Lịch sử | `context.go` | `snapshot.historyRoute` | - |
| `lib/features/earn/presentation/pages/savings_product_detail_page.dart` | 44 | SC-330 SavingsProductDetailPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_product_detail_page.dart` | 92 | Quay lại | `context.go` | `snapshot.backRoute` | - |
| `lib/features/earn/presentation/pages/savings_receipt_page.dart` | 37 | SC-332 SavingsReceiptPage | `context.go` | `snapshot.backRoute` | - |

_Con 87 edge khac trong CSV._

### `arena`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/arena/presentation/pages/arena_blocked_users_page.dart` | 105 | - | `context.go` | `/arena/creator/<user.id>` | ArenaCreatorPage (/arena/creator/:creatorId) |
| `lib/features/arena/presentation/pages/arena_blocked_users_page.dart` | 147 | - | `context.go` | `/arena/safety` | ArenaSafetyCenterPage (/arena/safety) |
| `lib/features/arena/presentation/pages/arena_challenge_detail_page.dart` | 173 | - | `context.go` | `route` | - |
| `lib/features/arena/presentation/pages/arena_challenge_detail_page.dart` | 181 | Gửi bằng chứng | `context.go` | `/arena` | ArenaHomePage (/arena) |
| `lib/features/arena/presentation/pages/arena_creator_page.dart` | 146 | - | `context.go` | `route` | - |
| `lib/features/arena/presentation/pages/arena_creator_page.dart` | 154 | - | `context.go` | `/arena` | ArenaHomePage (/arena) |
| `lib/features/arena/presentation/pages/arena_flow_map_page.dart` | 155 | - | `context.go` | `route` | - |
| `lib/features/arena/presentation/pages/arena_flow_map_page.dart` | 164 | - | `context.go` | `/arena` | ArenaHomePage (/arena) |
| `lib/features/arena/presentation/pages/arena_governance_gate_page.dart` | 411 | - | `context.go` | `/arena/studio` | ArenaStudioPage (/arena/studio) |
| `lib/features/arena/presentation/pages/arena_guide_page_part_01.dart` | 94 | Áp dụng ngay - Tạo Challenge | `context.go` | `/arena/studio` | ArenaStudioPage (/arena/studio) |
| `lib/features/arena/presentation/pages/arena_guide_page_part_01.dart` | 104 | Áp dụng ngay - Tạo Challenge | `context.go` | `/arena/safety` | ArenaSafetyCenterPage (/arena/safety) |
| `lib/features/arena/presentation/pages/arena_guide_page_part_01.dart` | 114 | - | `context.go` | `/support` | SupportPage (/support) |
| `lib/features/arena/presentation/pages/arena_guide_page_part_01.dart` | 141 | - | `context.go` | `_mode == _GuideMode.create ? AppRoutePaths.arenaStudio : AppRoutePaths.arena` | - |
| `lib/features/arena/presentation/pages/arena_guide_page_part_01.dart` | 154 | - | `context.go` | `/arena` | ArenaHomePage (/arena) |
| `lib/features/arena/presentation/pages/arena_home_page_part_01.dart` | 120 | - | `context.go` | `route` | - |
| `lib/features/arena/presentation/pages/arena_home_page_part_01.dart` | 128 | - | `context.go` | `/home` | HomePage (/home) |
| `lib/features/arena/presentation/pages/arena_join_page.dart` | 148 | - | `context.go` | `/arena/challenge/<widget.challengeId>` | ArenaChallengeDetailPage (/arena/challenge/:challengeId) |
| `lib/features/arena/presentation/pages/arena_join_page.dart` | 158 | - | `context.go` | `route` | - |
| `lib/features/arena/presentation/pages/arena_join_page.dart` | 166 | - | `context.go` | `/arena/challenge/<widget.challengeId>` | ArenaChallengeDetailPage (/arena/challenge/:challengeId) |
| `lib/features/arena/presentation/pages/arena_leaderboard_page.dart` | 130 | - | `context.go` | `route` | - |
| `lib/features/arena/presentation/pages/arena_leaderboard_page.dart` | 138 | - | `context.go` | `/arena` | ArenaHomePage (/arena) |
| `lib/features/arena/presentation/pages/arena_mode_detail_page.dart` | 147 | - | `context.go` | `route` | - |
| `lib/features/arena/presentation/pages/arena_mode_detail_page.dart` | 155 | - | `context.go` | `/arena` | ArenaHomePage (/arena) |
| `lib/features/arena/presentation/pages/arena_points_entry_detail_page.dart` | 143 | - | `context.go` | `/arena/ledger` | ArenaPointsLedgerPage (/arena/ledger) |
| `lib/features/arena/presentation/pages/arena_points_ledger_page.dart` | 117 | - | `context.go` | `/arena/safety` | ArenaSafetyCenterPage (/arena/safety) |

_Con 34 edge khac trong CSV._

### `dca`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/dca/presentation/pages/dca_backtester_page.dart` | 118 | Backtest report ready | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_dynamic_amount_page.dart` | 121 | - | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_dynamic_amount_page.dart` | 137 | Dynamic amount settings ready | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_multi_asset_page_part_01.dart` | 172 | Add asset flow ready | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_overview_demo.dart` | 66 | SC-400 DCAOverviewDemo | `context.go` | `snapshot.backRoute` | - |
| `lib/features/dca/presentation/pages/dca_page_part_01.dart` | 103 | Tạo kế hoạch mới | `context.go` | `route` | - |
| `lib/features/dca/presentation/pages/dca_page_part_01.dart` | 126 | - | `context.go` | `/trade` | TradePage (/trade) |
| `lib/features/dca/presentation/pages/dca_performance_compare_page.dart` | 166 | - | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart` | 130 | - | `context.go` | `/dca/rebalance/config` | DCARebalanceConfig (/dca/rebalance/config) |
| `lib/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart` | 146 | Portfolio report ready to share | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_rebalance_config_page.dart` | 274 | - | `context.go` | `/dca/rebalance/config001` | DCARebalanceDashboard (/dca/rebalance/config001) |
| `lib/features/dca/presentation/pages/dca_rebalance_config_page.dart` | 282 | - | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_schedule_config_page.dart` | 208 | - | `context.go` | `/dca/schedule/config001` | DCAScheduleAnalytics (/dca/schedule/config001) |
| `lib/features/dca/presentation/pages/dca_schedule_config_page.dart` | 216 | - | `context.go` | `/dca` | DCAPage (/dca) |
| `lib/features/dca/presentation/pages/dca_smart_rules_page.dart` | 150 | Create rule flow ready | `context.go` | `/dca` | DCAPage (/dca) |

### `launchpad`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/launchpad/presentation/pages/launchpad_abi_diff_page.dart` | 87 | SC-308 LaunchpadABIDiffPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_address_book_page.dart` | 105 | SC-309 LaunchpadAddressBookPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart` | 91 | SC-304 LaunchpadBatchClaimPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart` | 123 | - | `context.go` | `snapshot.claimReceiptRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart` | 140 | - | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_bridge_compare_page.dart` | 85 | SC-305 LaunchpadBridgeComparePage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_bridge_compare_page.dart` | 155 | - | `context.go` | `snapshot.bridgeOrderRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_bridge_order_page.dart` | 73 | SC-303 LaunchpadBridgeOrderPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_claim_receipt_page.dart` | 87 | SC-302 LaunchpadClaimReceiptPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_contract_page.dart` | 52 | SC-300 LaunchpadContractPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_contract_page.dart` | 171 | ABI Diff | `context.go` | `snapshot.abiDiffRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart` | 105 | SC-316 LaunchpadDcaBuilderPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_detail_page.dart` | 53 | SC-318 LaunchpadDetailPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_detail_page.dart` | 171 | Mở Launchpad staking | `context.go` | `snapshot.stakingRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_event_log_page.dart` | 105 | SC-307 LaunchpadEventLogPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page.dart` | 106 | SC-311 LaunchpadGasTrackerPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_ido_bridge_page.dart` | 52 | SC-299 LaunchpadIdoBridgePage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_limit_orders_page.dart` | 120 | SC-315 LaunchpadLimitOrdersPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_01.dart` | 47 | SC-313 LaunchpadMultisigPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_notif_sound_page.dart` | 93 | SC-306 LaunchpadNotifSoundPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_page.dart` | 79 | SC-295 LaunchpadPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_performance_page.dart` | 69 | SC-297 LaunchpadPerformancePage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_portfolio_page.dart` | 71 | SC-296 LaunchpadPortfolioPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart` | 109 | SC-312 LaunchpadRebalancePage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/launchpad/presentation/pages/launchpad_receipt_page.dart` | 60 | SC-301 LaunchpadReceiptPage | `context.go` | `snapshot.backRoute` | - |

_Con 18 edge khac trong CSV._

### `support`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/support/presentation/pages/announcements_page.dart` | 75 | SC-293 AnnouncementsPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/support/presentation/pages/help_center_page.dart` | 81 | SC-292 HelpCenterPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/support/presentation/pages/support_page.dart` | 83 | SC-294 SupportPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/support/presentation/widgets/help_center_hero_actions.dart` | 80 | Chat hỗ trợ / Gửi ticket | `context.go` | `chatRoute` | - |
| `lib/features/support/presentation/widgets/help_center_hero_actions.dart` | 90 | Chat hỗ trợ / Gửi ticket | `context.go` | `ticketRoute` | - |
| `lib/features/support/presentation/widgets/support_quick_contacts_tabs.dart` | 33 | Trợ giúp / Hệ thống | `context.go` | `snapshot.helpRoute` | - |
| `lib/features/support/presentation/widgets/support_quick_contacts_tabs.dart` | 44 | Trợ giúp / Hệ thống | `context.go` | `snapshot.announcementsRoute` | - |

### `discovery`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/discovery/presentation/pages/topic_hub_page.dart` | 92 | Tìm kiếm / SC-284 TopicHubPage | `context.go` | `/home` | HomePage (/home) |
| `lib/features/discovery/presentation/pages/topic_hub_page.dart` | 98 | Tìm kiếm / SC-284 TopicHubPage | `context.go` | `snapshot.searchRoute` | - |
| `lib/features/discovery/presentation/pages/unified_search_page.dart` | 77 | SC-283 UnifiedSearchPage | `context.go` | `/home` | HomePage (/home) |
| `lib/features/discovery/presentation/widgets/topic_hub_cards.dart` | 12 | Prediction Market | `context.go` | `event.route` | - |
| `lib/features/discovery/presentation/widgets/topic_hub_cards.dart` | 88 | Arena Points only | `context.go` | `room.route` | - |
| `lib/features/discovery/presentation/widgets/topic_hub_cards.dart` | 153 | - | `context.go` | `mode.route` | - |
| `lib/features/discovery/presentation/widgets/topic_hub_cards.dart` | 213 | Xem mode | `context.go` | `creator.route` | - |
| `lib/features/discovery/presentation/widgets/topic_hub_cards.dart` | 299 | Tạo room | `context.go` | `snapshot.createArenaRoute` | - |
| `lib/features/discovery/presentation/widgets/topic_hub_sections.dart` | 17 | Xem tất cả / Prediction Events | `context.go` | `snapshot.predictionsRoute` | - |
| `lib/features/discovery/presentation/widgets/topic_hub_sections.dart` | 40 | Xem tất cả / Live Arena Rooms | `context.go` | `snapshot.arenaRoute` | - |
| `lib/features/discovery/presentation/widgets/unified_search_entity_cards.dart` | 12 | Arena Points only | `context.go` | `room.route` | - |
| `lib/features/discovery/presentation/widgets/unified_search_entity_cards.dart` | 86 | - | `context.go` | `creator.route` | - |
| `lib/features/discovery/presentation/widgets/unified_search_entity_cards.dart` | 146 | Spot Trading | `context.go` | `pair.route` | - |
| `lib/features/discovery/presentation/widgets/unified_search_prediction_arena_cards.dart` | 12 | Prediction Market | `context.go` | `event.route` | - |
| `lib/features/discovery/presentation/widgets/unified_search_prediction_arena_cards.dart` | 68 | Open Arena | `context.go` | `mode.route` | - |
| `lib/features/discovery/presentation/widgets/unified_search_shell.dart` | 145 | - | `context.go` | `module.route` | - |

### `referral`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/referral/presentation/pages/referral_friend_detail_page.dart` | 41 | SC-289 ReferralFriendDetailPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/referral/presentation/pages/referral_friend_detail_page.dart` | 110 | Quay lại danh sách | `context.go` | `snapshot.listRoute` | - |
| `lib/features/referral/presentation/pages/referral_history_page.dart` | 83 | SC-286 ReferralHistoryPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/referral/presentation/pages/referral_history_page.dart` | 142 | Không tìm thấy | `context.go` | `friend.route` | - |
| `lib/features/referral/presentation/pages/referral_home_page.dart` | 73 | SC-290 ReferralHomePage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/referral/presentation/pages/referral_home_page.dart` | 94 | - | `context.go` | `/referral/history` | ReferralHistoryPage (/referral/history) |
| `lib/features/referral/presentation/pages/referral_home_page.dart` | 134 | Mời bạn bè ngay | `context.go` | `route` | - |
| `lib/features/referral/presentation/pages/referral_rewards_page_part_01.dart` | 30 | SC-287 ReferralRewardsPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/referral/presentation/pages/referral_rules_page.dart` | 66 | SC-288 ReferralRulesPage | `context.go` | `snapshot.backRoute` | - |

### `cross_module`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/cross_module/presentation/pages/cross_module_analytics.dart` | 63 | SC-322 CrossModuleAnalytics | `context.go` | `snapshot.backRoute` | - |
| `lib/features/cross_module/presentation/pages/smart_alert_center.dart` | 63 | SC-323 SmartAlertCenter | `context.go` | `snapshot.backRoute` | - |
| `lib/features/cross_module/presentation/pages/tax_report_center_part_01.dart` | 33 | SC-324 TaxReportCenter | `context.go` | `snapshot.backRoute` | - |
| `lib/features/cross_module/presentation/pages/unified_portfolio_dashboard.dart` | 60 | SC-321 UnifiedPortfolioDashboard | `context.go` | `snapshot.backRoute` | - |
| `lib/features/cross_module/presentation/pages/unified_portfolio_dashboard.dart` | 82 | - | `context.go` | `route` | - |

### `notifications`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/notifications/presentation/pages/notifications_page.dart` | 74 | SC-291 NotificationsPage | `context.go` | `snapshot.backRoute` | - |
| `lib/features/notifications/presentation/pages/notifications_page.dart` | 169 | - | `context.go` | `path` | - |

### `news`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/news/presentation/pages/news_page.dart` | 78 | Tin tức & Thông báo / Tin tức · Cập nhật / SC-047 NewsPage | `context.go` | `/home` | HomePage (/home) |

### `admin`

| Source | Line | Trigger/label gan nhat | Kind | Target | Target screen |
| --- | ---: | --- | --- | --- | --- |
| `lib/features/admin/presentation/pages/ab_test_dashboard.dart` | 58 | A/B Test Dashboard / Test Results & Analysis / SC-182 ABTestDashboard | `context.go` | `/admin` | AdminHome (/admin) |
| `lib/features/admin/presentation/pages/admin_home.dart` | 62 | Admin Dashboard / DCA Analytics & Monitoring / SC-180 AdminHome | `context.go` | `/admin/settings` | AdminSettingsPage (/admin/settings) |
| `lib/features/admin/presentation/pages/admin_settings_page.dart` | 45 | Admin Settings / Operations controls / SC-180 AdminSettingsPage | `context.go` | `/admin` | AdminHome (/admin) |
| `lib/features/admin/presentation/pages/admin_settings_page.dart` | 72 | Dashboard routing | `context.go` | `dashboard.route` | - |
| `lib/features/admin/presentation/pages/analytics_dashboard.dart` | 63 | Analytics Dashboard / DCA Event Analytics / SC-181 AnalyticsDashboard | `context.go` | `/admin` | AdminHome (/admin) |
| `lib/features/admin/presentation/pages/funnel_dashboard.dart` | 72 | Funnel Analytics / Conversion Funnel Tracking / SC-183 FunnelDashboard | `context.go` | `/admin` | AdminHome (/admin) |
| `lib/features/admin/presentation/widgets/admin_home_dashboards_footer.dart` | 38 | - | `context.go` | `dashboard.route` | - |

## Audit Findings / Viec Can Theo Doi

1. Route registry sach va artifact route coverage dang current, nhung so luong man hinh rat lon: 414 real pages. Nen bat buoc duy tri audit CSV/route truth table trong CI khi them route moi.
2. Co nhieu edge target dong (`snapshot.backRoute`, `item.route`, `module.route`, `tx.route`, `tool.route`). Day la pattern tot cho mock/domain-driven UI, nhung khi review can kiem tra data source de dam bao route da khai bao.
3. Bottom nav active map dang gom nhieu module vao tab `Giao dich`; ve UX enterprise, khi P2P/Earn/Arena/Launchpad lon hon nen can secondary module navigation hoac app launcher de nguoi dung khong bi mat ngu canh.
4. Mot so handler la local state/modal (`Navigator.pop`, toggle, picker, copy, sheet close) khong phai route. CSV da gan note `back_or_close_modal` de khong nham voi man hinh moi.
5. `/arena/points` khong render page rieng ma redirect sang `/rewards?tab=arena`; neu team thiet ke mong co man hinh diem rieng thi can quyet dinh lai canonical route.

## Cach Su Dung Khi Phat Trien Sau Nay

- Khi them nut moi: them route vao `AppRoutePaths`, route group, test route contract, va cap nhat snapshot/data route neu nut dung data-driven route.
- Khi them man hinh moi: dam bao co duong vao tu hub/menu, back route ro rang, va co trong `Flutter-Route-Coverage-Truth-Table.md`.
- Khi review UI flow: loc CSV theo `source_file` hoac `normalized_target` de xem nut nao dan tu dau sang dau.
