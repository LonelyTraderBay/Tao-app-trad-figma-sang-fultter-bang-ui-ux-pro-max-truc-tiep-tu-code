import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  for (final viewport in _responsiveViewports) {
    testWidgets(
      'UI-05 priority routes render without layout errors at ${viewport.label}',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(
          viewport.width.toDouble(),
          viewport.height.toDouble(),
        );
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        final failures = <String>[];
        for (final route in _filteredPriorityRoutes) {
          await _scanRoute(tester, viewport, route, failures);
        }

        if (failures.isNotEmpty) {
          fail(
            'Responsive visual QA failures for ${viewport.label}:\n'
            '${failures.join('\n')}',
          );
        }
      },
    );
  }
}

Future<void> _scanRoute(
  WidgetTester tester,
  _ResponsiveViewport viewport,
  _PriorityRoute route,
  List<String> failures,
) async {
  final errors = <FlutterErrorDetails>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;

  try {
    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(initialLocation: route.location),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 50),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 3),
    );

    final semantics = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics && widget.properties.label == route.semanticLabel,
      description: route.semanticLabel,
    );
    if (semantics.evaluate().isEmpty) {
      failures.add(
        '- ${route.name} ${viewport.label}: missing ${route.semanticLabel}',
      );
    }

    final bottomNav = find.byType(VitBottomNav);
    if (bottomNav.evaluate().length != 1) {
      failures.add(
        '- ${route.name} ${viewport.label}: expected one bottom nav, found '
        '${bottomNav.evaluate().length}',
      );
    } else {
      final navRect = tester.getRect(bottomNav);
      if (navRect.left < -0.5 ||
          navRect.right > viewport.width + 0.5 ||
          navRect.bottom > viewport.height + 0.5) {
        failures.add(
          '- ${route.name} ${viewport.label}: bottom nav clipped '
          '(${navRect.left.toStringAsFixed(1)}, '
          '${navRect.top.toStringAsFixed(1)}, '
          '${navRect.right.toStringAsFixed(1)}, '
          '${navRect.bottom.toStringAsFixed(1)})',
        );
      }
    }
  } catch (error) {
    failures.add('- ${route.name} ${viewport.label}: threw $error');
  } finally {
    FlutterError.onError = previousOnError;
  }

  Object? exception = tester.takeException();
  while (exception != null) {
    failures.add('- ${route.name} ${viewport.label}: exception $exception');
    exception = tester.takeException();
  }

  if (errors.isNotEmpty) {
    failures.addAll(
      errors.map(
        (details) =>
            '- ${route.name} ${viewport.label}: '
            '${_describeFlutterError(details)}',
      ),
    );
  }

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

const _responsiveViewports = [
  _ResponsiveViewport('360x800 minimum phone', 360, 800),
  _ResponsiveViewport('440x956 QA phone', 440, 956),
  _ResponsiveViewport('480x1040 large phone', 480, 1040),
];

final _priorityRoutes = [
  _PriorityRoute('Home', AppRoutePaths.home, 'SC-007 HomePage'),
  _PriorityRoute('Markets', AppRoutePaths.markets, 'SC-008 MarketListPage'),
  _PriorityRoute(
    'Pair Detail',
    AppRoutePaths.pairDetail('btcusdt'),
    'SC-044 PairDetailPage',
  ),
  _PriorityRoute('Trade', AppRoutePaths.trade, 'SC-048 TradePage'),
  _PriorityRoute(
    'Orders History',
    AppRoutePaths.tradeOrdersHistory,
    'SC-050 OrdersHistoryPage',
  ),
  _PriorityRoute(
    'Order Receipt',
    AppRoutePaths.tradeOrderReceipt,
    'SC-051 OrderReceiptPage',
  ),
  _PriorityRoute('Wallet', AppRoutePaths.wallet, 'SC-135 WalletPage'),
  _PriorityRoute(
    'Asset Detail',
    AppRoutePaths.walletAsset('btc'),
    'SC-147 AssetDetailPage',
  ),
  _PriorityRoute(
    'Transaction Detail',
    AppRoutePaths.walletTransaction('tx001'),
    'SC-141 TransactionDetailPage',
  ),
  _PriorityRoute('Deposit', AppRoutePaths.walletDeposit, 'SC-137 DepositPage'),
  _PriorityRoute(
    'Pending Deposits',
    AppRoutePaths.walletPendingDeposits,
    'SC-152 PendingDepositsPage',
  ),
  _PriorityRoute(
    'Portfolio Analytics',
    AppRoutePaths.walletPortfolioAnalytics,
    'SC-142 PortfolioAnalyticsPage',
  ),
  _PriorityRoute(
    'Wallet Health',
    AppRoutePaths.walletHealthScore,
    'SC-151 WalletHealthScorePage',
  ),
  _PriorityRoute(
    'Dust Converter',
    AppRoutePaths.walletDustConverter,
    'SC-154 DustConverterPage',
  ),
  _PriorityRoute(
    'Withdraw',
    AppRoutePaths.walletWithdraw,
    'SC-139 WithdrawPage',
  ),
  _PriorityRoute(
    'Transfer',
    AppRoutePaths.walletTransfer,
    'SC-146 TransferPage',
  ),
  _PriorityRoute(
    'Address Book',
    AppRoutePaths.walletAddressBook,
    'SC-144 AddressBookPage',
  ),
  _PriorityRoute(
    'Address Add',
    AppRoutePaths.walletAddressBookAdd,
    'SC-143 AddressAddPage',
  ),
  _PriorityRoute('Profile', AppRoutePaths.profile, 'SC-156 ProfilePage'),
  _PriorityRoute(
    'Prediction Home',
    AppRoutePaths.marketsPredictions,
    'SC-027 PredictionsHomePage',
  ),
  _PriorityRoute(
    'Prediction Event',
    AppRoutePaths.marketsPredictionEvent('pred-1'),
    'SC-030 PredictionEventDetailPage',
  ),
  _PriorityRoute(
    'Prediction Risk',
    AppRoutePaths.marketsPredictionsRiskCalculator,
    'SC-036 PredictionRiskCalculatorPage',
  ),
  _PriorityRoute(
    'Prediction Receipt',
    AppRoutePaths.marketsPredictionReceipt('po-1'),
    'SC-035 PredictionOrderReceiptPage',
  ),
  _PriorityRoute(
    'Prediction Portfolio',
    AppRoutePaths.marketsPredictionsPortfolio,
    'SC-031 PredictionsPortfolioPage',
  ),
  _PriorityRoute('Arena Home', AppRoutePaths.arena, 'SC-184 ArenaHomePage'),
  _PriorityRoute(
    'Arena Challenge',
    AppRoutePaths.arenaChallenge('ch003'),
    'SC-190 ArenaChallengeDetailPage',
  ),
  _PriorityRoute(
    'Arena Join',
    AppRoutePaths.arenaJoin('ch003'),
    'SC-191 ArenaJoinPage',
  ),
  _PriorityRoute(
    'Token Approval',
    AppRoutePaths.walletTokenApproval,
    'SC-150 WalletTokenApprovalPage',
  ),
  _PriorityRoute(
    'P2P Dashboard',
    AppRoutePaths.p2pDashboard,
    'SC-274 P2PDashboardPage',
  ),
  _PriorityRoute(
    'P2P Payment Methods',
    AppRoutePaths.p2pPaymentMethods,
    'SC-237 P2PPaymentMethodsPage',
  ),
  _PriorityRoute(
    'P2P Payment Add',
    AppRoutePaths.p2pPaymentMethodAdd,
    'SC-232 P2PPaymentMethodAddPage',
  ),
  _PriorityRoute(
    'P2P Order',
    AppRoutePaths.p2pOrder('p2p001'),
    'SC-216 P2POrderPage',
  ),
  _PriorityRoute(
    'P2P Dispute',
    AppRoutePaths.p2pDispute('p2p001'),
    'SC-221 P2PDisputePage',
  ),
  _PriorityRoute('Admin Home', AppRoutePaths.admin, 'SC-180 AdminHome'),
  _PriorityRoute(
    'Analytics Dashboard',
    AppRoutePaths.adminAnalytics,
    'SC-181 AnalyticsDashboard',
  ),
  _PriorityRoute(
    'Funnel Dashboard',
    AppRoutePaths.adminFunnels,
    'SC-183 FunnelDashboard',
  ),
  _PriorityRoute(
    'A/B Test Dashboard',
    AppRoutePaths.adminAbtests,
    'SC-182 ABTestDashboard',
  ),
];

final _filteredPriorityRoutes = _routeFilter.isEmpty
    ? _priorityRoutes
    : _priorityRoutes
          .where(
            (route) =>
                route.name.toLowerCase().contains(_routeFilter) ||
                route.location.toLowerCase().contains(_routeFilter),
          )
          .toList(growable: false);

String _describeFlutterError(FlutterErrorDetails details) {
  if (_includeDiagnostics) {
    return details.toString();
  }
  return details.exceptionAsString();
}

final _routeFilter = const String.fromEnvironment(
  'RESPONSIVE_QA_ROUTE',
).toLowerCase();
const _includeDiagnostics = bool.fromEnvironment('RESPONSIVE_QA_DIAGNOSTICS');

class _ResponsiveViewport {
  const _ResponsiveViewport(this.label, this.width, this.height);

  final String label;
  final int width;
  final int height;
}

class _PriorityRoute {
  const _PriorityRoute(this.name, this.location, this.semanticLabel);

  final String name;
  final String location;
  final String semanticLabel;
}
