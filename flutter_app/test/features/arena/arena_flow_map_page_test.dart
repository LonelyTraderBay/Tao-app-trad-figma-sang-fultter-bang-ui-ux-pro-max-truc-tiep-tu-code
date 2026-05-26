import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/arena_flow_map_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/arena_points_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpFlowMap(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaFlowMap,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-197 mock repository exposes Arena Flow Map BE draft', () {
    final snapshot = const MockArenaRepository().getArenaFlowMap();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-flow-map');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.stats.map((stat) => stat.label), contains('Routes'));
    expect(
      snapshot.routes.map((route) => route.path),
      contains('/arena/points'),
    );
    expect(snapshot.groups.map((group) => group.id), contains('participant'));
    expect(snapshot.components.first.file, 'ArenaChips.tsx');
    expect(snapshot.handoffNotes.first.title, 'Open Arena = Points-only');
    expect(
      snapshot.qaItems.map((item) => item.category),
      contains('Moderation'),
    );
    expect(snapshot.disclaimer, contains('không phải ví giao dịch hoặc PnL'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-197 renders Open Arena Flow Map baseline', (tester) async {
    await pumpFlowMap(tester);

    expect(find.byType(ArenaFlowMapPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Open Arena Flow Map'), findsOneWidget);
    expect(find.text('06F — Prototype & QA'), findsOneWidget);
    expect(find.text('Open Arena Module'), findsOneWidget);
    expect(find.text('SECTION 1 — Flow Map'), findsOneWidget);
    expect(find.text('Route Registry'), findsOneWidget);
    expect(find.text('/arena'), findsOneWidget);
    expect(find.text('Core Entry Points'), findsOneWidget);
    expect(find.text('Discovery Flow'), findsOneWidget);
  });

  testWidgets('SC-197 expands handoff and QA sections', (tester) async {
    await pumpFlowMap(tester);

    await tester.ensureVisible(
      find.byKey(ArenaFlowMapPage.sectionKey('handoff')),
    );
    await tester.tap(find.byKey(ArenaFlowMapPage.sectionKey('handoff')));
    await tester.pumpAndSettle();
    expect(find.text('Open Arena = Points-only'), findsOneWidget);

    await tester.ensureVisible(find.byKey(ArenaFlowMapPage.sectionKey('qa')));
    await tester.tap(find.byKey(ArenaFlowMapPage.sectionKey('qa')));
    await tester.pumpAndSettle();
    expect(find.text('Tiến độ QA'), findsOneWidget);

    await tester.tap(find.byKey(ArenaFlowMapPage.qaKey('qa01')));
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsOneWidget);
  });

  testWidgets('SC-197 flow nodes navigate through safe canonical routes', (
    tester,
  ) async {
    await pumpFlowMap(tester);

    await tester.ensureVisible(
      find.byKey(ArenaFlowMapPage.nodeKey('ArenaPointsPage')),
    );
    await tester.tap(find.byKey(ArenaFlowMapPage.nodeKey('ArenaPointsPage')));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaPointsPage), findsOneWidget);
  });
}
