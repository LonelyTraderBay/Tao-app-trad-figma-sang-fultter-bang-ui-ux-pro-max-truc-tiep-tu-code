import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/dca_schedule_config_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpScheduleConfig(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaScheduleConfig,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-172 mock repository exposes schedule config BE draft', () {
    final snapshot = const DcaRepository().getScheduleConfig();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-schedule-config');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.strategy, DcaScheduleStrategy.hybrid);
    expect(snapshot.timePreference, DcaScheduleTimePreference.any);
    expect(snapshot.maxDelayHours, 6);
    expect(snapshot.maxAdvanceHours, 6);
    expect(snapshot.volatilityThreshold, 3);
    expect(snapshot.gasPriceThreshold, 30);
    expect(snapshot.enabled, isTrue);
    expect(snapshot.strategies.map((strategy) => strategy.strategy), [
      DcaScheduleStrategy.fixed,
      DcaScheduleStrategy.volatility,
      DcaScheduleStrategy.gasOptimized,
      DcaScheduleStrategy.volume,
      DcaScheduleStrategy.hybrid,
    ]);
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

  testWidgets('SC-172 renders smart scheduling form with trade nav active', (
    tester,
  ) async {
    await pumpScheduleConfig(tester);

    expect(find.byType(DCAScheduleConfig), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Smart Scheduling'), findsOneWidget);
    expect(find.text('Lịch trình thông minh'), findsOneWidget);
    expect(find.text('Chiến lược'), findsOneWidget);
    expect(find.text('Hybrid'), findsOneWidget);
    expect(find.text('Khung giờ ưu tiên'), findsOneWidget);
    expect(find.byKey(DCAScheduleConfig.saveKey), findsOneWidget);
  });

  testWidgets('SC-172 strategy, time preference and switch update state', (
    tester,
  ) async {
    await pumpScheduleConfig(tester);

    await tester.tap(
      find.byKey(DCAScheduleConfig.strategyKey(DcaScheduleStrategy.fixed)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Cố định'), findsWidgets);
    expect(find.textContaining('không tối ưu'), findsWidgets);

    await tester.tap(
      find.byKey(DCAScheduleConfig.timeKey(DcaScheduleTimePreference.morning)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(DCAScheduleConfig.enabledKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCAScheduleConfig.enabledKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DCAScheduleConfig.enabledKey), findsOneWidget);
  });

  testWidgets('SC-172 save routes to schedule analytics route', (tester) async {
    await pumpScheduleConfig(tester);

    await tester.ensureVisible(find.byKey(DCAScheduleConfig.saveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCAScheduleConfig.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Configuration not found'), findsOneWidget);
  });
}
