import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/pages/dca_overview_demo.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpDcaOverviewDemo(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.devDcaOverview,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-400 mock repository exposes DCA overview demo BE draft', () {
    final snapshot = const DcaRepository().getOverviewDemo();

    expect(snapshot.endpoint, '/api/mobile/dev/dev-dca-overview');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.title, 'DCA Overview Card Demo');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.scenarios, hasLength(5));
    expect(snapshot.mobilePreview.id, 'mobile-preview');
    expect(snapshot.contractNotes, contains('internal role or dev flag'));
    expect(snapshot.contractNotes, contains('mock-local'));
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

  testWidgets('SC-400 renders profitable and loss overview scenarios', (
    tester,
  ) async {
    await pumpDcaOverviewDemo(tester);

    expect(find.byType(DCAOverviewDemo), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('DCA Overview Card Demo'), findsOneWidget);
    expect(find.text('Demo · DCA'), findsOneWidget);
    expect(find.text('Show Loading'), findsOneWidget);
    expect(
      find.text('Scenario 1: Lãi (Profitable) + Sparkline + Actions'),
      findsOneWidget,
    );
    expect(find.text('₫42.350.000'), findsWidgets);
    expect(find.text('35.50M'), findsWidgets);

    await tester.ensureVisible(find.byKey(DCAOverviewDemo.scenarioKey('loss')));
    await tester.pump();

    expect(find.text('Scenario 2: Lỗ (Loss) + Sparkline'), findsOneWidget);
    expect(find.text('₫28.900.000'), findsOneWidget);
  });

  testWidgets('SC-400 toggles loading skeleton state', (tester) async {
    await pumpDcaOverviewDemo(tester);

    await tester.tap(find.byKey(DCAOverviewDemo.loadingToggleKey));
    await tester.pump();

    expect(find.text('Hide Loading'), findsOneWidget);
    expect(find.byKey(DCAOverviewDemo.loadingSectionKey), findsOneWidget);
    expect(find.byType(VitSkeleton), findsWidgets);
  });

  testWidgets('SC-400 renders mobile preview and action edge', (tester) async {
    await pumpDcaOverviewDemo(tester);

    await tester.ensureVisible(find.byKey(DCAOverviewDemo.mobilePreviewKey));
    await tester.pump();

    expect(find.text('Mobile Preview (360px width)'), findsOneWidget);
    expect(
      find.byKey(DCAOverviewDemo.cardKey('mobile-preview')),
      findsOneWidget,
    );
    expect(
      find.byKey(DCAOverviewDemo.actionKey('mobile-preview', 'create')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(DCAOverviewDemo.actionKey('mobile-preview', 'create')),
    );
    await tester.pump();
  });

  testWidgets('SC-400 header back returns home', (tester) async {
    await pumpDcaOverviewDemo(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomePage), findsOneWidget);
  });
}
