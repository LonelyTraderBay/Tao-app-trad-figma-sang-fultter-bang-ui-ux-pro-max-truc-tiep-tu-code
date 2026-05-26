import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/arena_points_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpArenaPoints(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaPoints,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-196 mock repository exposes Arena Points BE draft', () {
    final snapshot = const MockArenaRepository().getArenaPoints();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-points');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.summary.currentBalance, 2220);
    expect(snapshot.summary.lockedBalance, 450);
    expect(snapshot.summary.pendingCount, 3);
    expect(
      snapshot.categories.map((category) => category.id),
      contains('arena'),
    );
    expect(snapshot.tasks.map((task) => task.id), contains('task-thang3'));
    expect(snapshot.leaderboard.first.name, 'CryptoWhale');
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

  testWidgets('SC-196 redirects /arena/points into the Rewards Hub baseline', (
    tester,
  ) async {
    await pumpArenaPoints(tester);

    expect(find.byType(ArenaPointsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trung tâm Phần thưởng'), findsOneWidget);
    expect(find.text('Phần thưởng · Rewards'), findsOneWidget);
    expect(find.text('USDT đã nhận'), findsOneWidget);
    expect(find.text('Arena Points'), findsOneWidget);
    expect(find.text('3 phần thưởng chờ nhận'), findsOneWidget);
    expect(find.text('Check-in hằng ngày'), findsOneWidget);
    expect(find.text('Nhiệm vụ'), findsOneWidget);
  });

  testWidgets('SC-196 filters reward tasks and supports claim-all state', (
    tester,
  ) async {
    await pumpArenaPoints(tester);

    await tester.tap(find.byKey(ArenaPointsPage.claimAllKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã nhận hết phần thưởng chờ'), findsOneWidget);

    await tester.drag(
      find.byKey(ArenaPointsPage.contentKey),
      const Offset(0, -280),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ArenaPointsPage.filterKey('Flash')));
    await tester.pumpAndSettle();
    expect(find.text('Flash: Mua BTC hôm nay'), findsOneWidget);
    expect(find.text('Flash 3 lệnh P2P liên tiếp'), findsOneWidget);
    expect(find.text('Volume tuần \$10K'), findsNothing);
  });

  testWidgets('SC-196 referral navigation uses the migrated referral home', (
    tester,
  ) async {
    await pumpArenaPoints(tester);

    await tester.ensureVisible(find.byKey(ArenaPointsPage.referralKey));
    await tester.tap(find.byKey(ArenaPointsPage.referralKey));
    await tester.pumpAndSettle();
    expect(find.text('Giới thiệu bạn bè'), findsOneWidget);
  });
}
