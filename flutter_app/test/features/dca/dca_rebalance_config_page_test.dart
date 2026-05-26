import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/pages/dca_rebalance_config_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpRebalanceConfig(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaRebalanceConfig,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-170 mock repository exposes rebalance config BE draft', () {
    final snapshot = const DcaRepository().getRebalanceConfig();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-rebalance-config');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.targets.map((target) => target.symbol), [
      'BTC',
      'ETH',
      'USDT',
    ]);
    expect(snapshot.strategy, DcaRebalanceStrategy.threshold);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
        DcaScreenState.submitting,
        DcaScreenState.success,
      ]),
    );
  });

  testWidgets('SC-170 renders Auto-Rebalance form with trade nav active', (
    tester,
  ) async {
    await pumpRebalanceConfig(tester);

    expect(find.byType(DCARebalanceConfig), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Auto-Rebalance'), findsOneWidget);
    expect(find.text('Tự động cân bằng danh mục'), findsOneWidget);
    expect(find.text('Phân bổ mục tiêu'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);
    expect(find.text('Chiến lược'), findsOneWidget);
    expect(find.byKey(DCARebalanceConfig.previewKey), findsOneWidget);
    expect(find.byKey(DCARebalanceConfig.saveKey), findsOneWidget);
  });

  testWidgets('SC-170 strategy and advanced controls update local state', (
    tester,
  ) async {
    await pumpRebalanceConfig(tester);

    await tester.ensureVisible(
      find.byKey(DCARebalanceConfig.strategyKey(DcaRebalanceStrategy.periodic)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(DCARebalanceConfig.strategyKey(DcaRebalanceStrategy.periodic)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tần suất'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(DCARebalanceConfig.advancedToggleKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCARebalanceConfig.advancedToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('Giao dịch tối thiểu'), findsOneWidget);
    expect(find.text('Tự động thực thi'), findsOneWidget);
  });

  testWidgets('SC-170 preview confirms to dashboard placeholder edge', (
    tester,
  ) async {
    await pumpRebalanceConfig(tester);

    await tester.tap(find.byKey(DCARebalanceConfig.previewKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DCARebalanceConfig.previewSheetKey), findsOneWidget);
    expect(find.text('Preview Simulation'), findsOneWidget);

    await tester.tap(find.byKey(DCARebalanceConfig.confirmSaveKey));
    await tester.pumpAndSettle();
    expect(find.text('Configuration not found'), findsOneWidget);
  });
}
