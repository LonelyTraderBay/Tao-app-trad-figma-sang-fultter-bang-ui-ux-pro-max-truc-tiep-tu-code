import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

/// A11Y-3 follow-up (docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv):
/// the app-wide 1.3x text-scaling clamp (VitTradeApp's
/// MediaQuery.withClampedTextScaling) already caught one RenderFlex overflow
/// on Home (a VitCard(height: fixed, contentAlign: center) tile whose
/// title+subtitle no longer fit — see SharedSpacingTokens.homeRecentProductHeight).
/// Manually auditing every VitCard(height:) call site in the app for the same
/// bug is impractical (hundreds of call sites) and error-prone (requires
/// reasoning about exact font metrics per site) — this sweeps every priority
/// route at 1.3x scale instead and asserts none of them throws a layout
/// overflow, which empirically catches this whole bug class (VitCard-driven
/// or otherwise) rather than relying on manual math per widget.
void main() {
  testWidgets(
    'priority routes render without layout overflow at 1.3x text scaling',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final failures = <String>[];
      for (final route in _priorityRoutes) {
        await _scanRoute(tester, route, failures);
      }

      if (failures.isNotEmpty) {
        fail('Text-scaling (1.3x) overflow failures:\n${failures.join('\n')}');
      }
    },
  );
}

Future<void> _scanRoute(
  WidgetTester tester,
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
  } catch (error) {
    failures.add('- ${route.name}: threw $error');
  } finally {
    FlutterError.onError = previousOnError;
  }

  Object? exception = tester.takeException();
  while (exception != null) {
    failures.add('- ${route.name}: exception $exception');
    exception = tester.takeException();
  }

  if (errors.isNotEmpty) {
    failures.addAll(
      errors.map(
        (details) => '- ${route.name}: ${details.exceptionAsString()}',
      ),
    );
  }

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

final _priorityRoutes = [
  const _PriorityRoute('Home', AppRoutePaths.home),
  const _PriorityRoute('Markets', AppRoutePaths.markets),
  _PriorityRoute('Pair Detail', AppRoutePaths.pairDetail('btcusdt')),
  const _PriorityRoute('Trade', AppRoutePaths.trade),
  const _PriorityRoute('Orders History', AppRoutePaths.tradeOrdersHistory),
  const _PriorityRoute('Order Receipt', AppRoutePaths.tradeOrderReceipt),
  const _PriorityRoute('Wallet', AppRoutePaths.wallet),
  _PriorityRoute('Asset Detail', AppRoutePaths.walletAsset('btc')),
  _PriorityRoute(
    'Transaction Detail',
    AppRoutePaths.walletTransaction('tx001'),
  ),
  const _PriorityRoute('Deposit', AppRoutePaths.walletDeposit),
  const _PriorityRoute('Pending Deposits', AppRoutePaths.walletPendingDeposits),
  const _PriorityRoute(
    'Portfolio Analytics',
    AppRoutePaths.walletPortfolioAnalytics,
  ),
  const _PriorityRoute('Wallet Health', AppRoutePaths.walletHealthScore),
  const _PriorityRoute('Dust Converter', AppRoutePaths.walletDustConverter),
  const _PriorityRoute('Withdraw', AppRoutePaths.walletWithdraw),
  const _PriorityRoute('Transfer', AppRoutePaths.walletTransfer),
  const _PriorityRoute('Address Book', AppRoutePaths.walletAddressBook),
  const _PriorityRoute('Address Add', AppRoutePaths.walletAddressBookAdd),
  const _PriorityRoute('Profile', AppRoutePaths.profile),
  const _PriorityRoute('Prediction Home', AppRoutePaths.marketsPredictions),
  _PriorityRoute(
    'Prediction Event',
    AppRoutePaths.marketsPredictionEvent('pred-1'),
  ),
  const _PriorityRoute(
    'Prediction Risk',
    AppRoutePaths.marketsPredictionsRiskCalculator,
  ),
  _PriorityRoute(
    'Prediction Receipt',
    AppRoutePaths.marketsPredictionReceipt('po-1'),
  ),
  const _PriorityRoute(
    'Prediction Portfolio',
    AppRoutePaths.marketsPredictionsPortfolio,
  ),
  const _PriorityRoute('Arena Home', AppRoutePaths.arena),
  _PriorityRoute('Arena Challenge', AppRoutePaths.arenaChallenge('ch003')),
  _PriorityRoute('Arena Join', AppRoutePaths.arenaJoin('ch003')),
  const _PriorityRoute('Token Approval', AppRoutePaths.walletTokenApproval),
  const _PriorityRoute('P2P Dashboard', AppRoutePaths.p2pDashboard),
  const _PriorityRoute('P2P Payment Methods', AppRoutePaths.p2pPaymentMethods),
  const _PriorityRoute('P2P Payment Add', AppRoutePaths.p2pPaymentMethodAdd),
  _PriorityRoute('P2P Order', AppRoutePaths.p2pOrder('p2p001')),
  _PriorityRoute('P2P Dispute', AppRoutePaths.p2pDispute('p2p001')),
  const _PriorityRoute('Admin Home', AppRoutePaths.admin),
  const _PriorityRoute('Analytics Dashboard', AppRoutePaths.adminAnalytics),
  const _PriorityRoute('Funnel Dashboard', AppRoutePaths.adminFunnels),
  const _PriorityRoute('A/B Test Dashboard', AppRoutePaths.adminAbtests),
];

class _PriorityRoute {
  const _PriorityRoute(this.name, this.location);

  final String name;
  final String location;
}
