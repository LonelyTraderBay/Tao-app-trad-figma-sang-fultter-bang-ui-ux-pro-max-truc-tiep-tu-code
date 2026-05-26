import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/arena_blocked_users_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/arena_creator_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpBlockedUsers(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaBlocked,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-203 mock repository exposes blocked users BE draft', () {
    final snapshot = const MockArenaRepository().getArenaBlockedUsers();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-blocked');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.bannerTitle, 'Về tính năng chặn');
    expect(snapshot.users.map((user) => user.id), ['blk001', 'blk002']);
    expect(snapshot.users.first.name, 'SpamBot_X');
    expect(snapshot.users.last.source, ArenaBlockedUserSource.reportOutcome);
    expect(snapshot.emptyTitle, 'Chưa chặn ai');
    expect(snapshot.disclaimer, contains('không phải ví giao dịch'));
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

  testWidgets('SC-203 renders blocked users baseline', (tester) async {
    await pumpBlockedUsers(tester);

    expect(find.byType(ArenaBlockedUsersPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Người đã chặn'), findsOneWidget);
    expect(find.text('An toàn · Open Arena'), findsOneWidget);
    expect(find.text('Về tính năng chặn'), findsOneWidget);
    expect(find.text('SpamBot_X'), findsOneWidget);
    expect(find.text('ToxicTrader'), findsOneWidget);
    expect(find.text('2 người đã bị chặn'), findsOneWidget);
  });

  testWidgets('SC-203 unblock flow removes users and reaches empty state', (
    tester,
  ) async {
    await pumpBlockedUsers(tester);

    await tester.tap(find.byKey(ArenaBlockedUsersPage.unblockKey('blk001')));
    await tester.pumpAndSettle();
    expect(find.text('Bỏ chặn SpamBot_X?'), findsOneWidget);

    await tester.tap(
      find.byKey(ArenaBlockedUsersPage.confirmUnblockKey('blk001')),
    );
    await tester.pumpAndSettle();
    expect(find.text('SpamBot_X'), findsNothing);
    expect(find.text('1 người đã bị chặn'), findsOneWidget);

    await tester.tap(find.byKey(ArenaBlockedUsersPage.unblockKey('blk002')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ArenaBlockedUsersPage.confirmUnblockKey('blk002')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(ArenaBlockedUsersPage.emptyKey), findsOneWidget);
    expect(find.text('Chưa chặn ai'), findsOneWidget);
  });

  testWidgets('SC-203 view profile uses Arena creator route', (tester) async {
    await pumpBlockedUsers(tester);

    await tester.tap(
      find.byKey(ArenaBlockedUsersPage.viewProfileKey('blk001')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ArenaCreatorPage), findsOneWidget);
    expect(find.text('Creator Profile'), findsOneWidget);
  });
}
