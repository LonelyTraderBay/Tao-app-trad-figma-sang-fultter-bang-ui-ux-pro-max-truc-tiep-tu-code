import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/trade_page.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/orders_history_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/trade_settings_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/position_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/trade_history_export_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/convert/convert_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/futures/futures_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/futures/leverage_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/margin/margin_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/margin/margin_trading_hub_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';

List<RouteBase> tradeRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.trade,
      name: AppRouteNames.sc048Trade,
      builder: (_, state) => TradePage(
        initialSide: _tradeSideFromQuery(state.uri.queryParameters['side']),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeConvert,
      name: AppRouteNames.sc056Convert,
      builder: (_, _) => ConvertPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
      name: AppRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias,
      redirect: (_, _) => AppRoutePaths.tradeCopyRegulatoryDisclosures,
    ),
    GoRoute(
      path: AppRoutePaths.tradeMargin,
      name: AppRouteNames.sc085MarginTrading,
      builder: (_, _) => MarginTradingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginBtcusdt,
      name: AppRouteNames.sc086MarginTradingPair,
      builder: (_, _) => MarginTradingPage(
        pairId: 'btcusdt',
        pairRouteVariant: true,
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginHub,
      name: AppRouteNames.sc090MarginTradingHub,
      builder: (_, _) => MarginTradingHubPage(shellRenderMode: shellRenderMode),
    ),
    ...tradeMarginOutgoingPlaceholders,
    ...tradeBotsOutgoingPlaceholders,
    GoRoute(
      path: AppRoutePaths.tradeOrderReceipt,
      name: AppRouteNames.sc051OrderReceipt,
      builder: (_, _) => OrderReceiptPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeOrdersHistory,
      name: AppRouteNames.sc050OrdersHistory,
      builder: (_, _) => OrdersHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradePositions,
      name: AppRouteNames.sc053PositionDashboard,
      builder: (_, _) =>
          PositionDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeSettings,
      name: AppRouteNames.sc052TradeSettings,
      builder: (_, _) => TradeSettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeExport,
      name: AppRouteNames.sc054TradeHistoryExport,
      builder: (_, _) =>
          TradeHistoryExportPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/trade/:pairId/futures/leverage',
      name: AppRouteNames.sc058Leverage,
      builder: (_, state) => LeveragePage(
        pairId: state.pathParameters['pairId'] ?? 'btcusdt',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/trade/:pairId/futures',
      name: AppRouteNames.sc057Futures,
      builder: (_, state) => FuturesPage(
        pairId: state.pathParameters['pairId'] ?? 'btcusdt',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/trade/:pairId',
      name: AppRouteNames.sc049TradePair,
      builder: (_, state) => TradePage(
        pairId: state.pathParameters['pairId'] ?? 'btcusdt',
        chartVariant: TradeChartVariant.pairRoute,
        initialSide: _tradeSideFromQuery(state.uri.queryParameters['side']),
        shellRenderMode: shellRenderMode,
      ),
    ),
  ];
}

TradeOrderSide _tradeSideFromQuery(String? value) {
  return value == 'sell' ? TradeOrderSide.sell : TradeOrderSide.buy;
}
