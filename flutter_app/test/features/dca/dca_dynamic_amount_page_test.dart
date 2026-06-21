import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/pages/dca_dynamic_amount_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/pages/dca_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDynamicAmount(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaDynamicAmount,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-175 mock repository exposes dynamic amount BE draft', () {
    final snapshot = const DcaRepository().getDynamicAmount();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-dynamic-amount');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.activeStrategy, DcaDynamicStrategy.volatility);
    expect(snapshot.adjustment.adjustedAmountVnd, 500000);
    expect(snapshot.volatilityHistory.length, 10);
    expect(snapshot.amountHistory.length, 6);
    expect(snapshot.configItems.length, 6);
    expect(snapshot.dcaPlans, isEmpty);
    expect(snapshot.schedules, isEmpty);
    expect(snapshot.rules, isEmpty);
    expect(snapshot.portfolioTargets, isEmpty);
    expect(snapshot.backtests, isEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-175 renders dynamic amount default volatility view', (
    tester,
  ) async {
    await pumpDynamicAmount(tester);

    expect(find.byType(DCADynamicAmount), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Dynamic Amount'), findsOneWidget);
    expect(find.text('500K'), findsWidgets);
    expect(find.text('Volatility'), findsWidgets);
    expect(find.text('Biến động & Hệ số'), findsOneWidget);
    expect(find.text('Lịch sử điều chỉnh'), findsOneWidget);
    expect(find.text('Cấu hình Volatility'), findsOneWidget);
    expect(find.byKey(DCADynamicAmount.applyKey), findsOneWidget);
  });

  testWidgets('SC-175 switches strategy and apply returns to DCA dashboard', (
    tester,
  ) async {
    await pumpDynamicAmount(tester);

    await tester.ensureVisible(
      find.byKey(DCADynamicAmount.strategyKey(DcaDynamicStrategy.performance)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(DCADynamicAmount.strategyKey(DcaDynamicStrategy.performance)),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Cấu hình Hiệu suất'), findsOneWidget);
    expect(find.text('600K'), findsWidgets);

    await tester.ensureVisible(find.byKey(DCADynamicAmount.applyKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCADynamicAmount.applyKey));
    await tester.pumpAndSettle();

    expect(find.byType(DCAPage), findsOneWidget);
  });

  testWidgets('SC-175 first viewport reaches dynamic strategy controls', (
    tester,
  ) async {
    await pumpDynamicAmount(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-175 DCADynamicAmount',
      semanticLabel: 'SC-175 DCADynamicAmount',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCADynamicAmount.settingsKey),
      routeName: 'SC-175 DCADynamicAmount',
      actionLabel: 'dynamic amount settings action',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCADynamicAmount.strategyKey(DcaDynamicStrategy.volatility)),
      routeName: 'SC-175 DCADynamicAmount',
      actionLabel: 'active volatility strategy chip',
    );
  });
}
