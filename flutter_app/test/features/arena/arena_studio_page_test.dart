import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/arena_smart_rule_builder_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/arena_studio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpArenaStudio(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudio,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-185 mock repository exposes Arena Studio BE draft', () {
    final snapshot = const MockArenaRepository().getArenaStudio();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-studio');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.platformFeePct, 10);
    expect(snapshot.steps.length, 6);
    expect(
      snapshot.templates.map((template) => template.id),
      contains('prediction'),
    );
    expect(
      snapshot.templates.map((template) => template.id),
      contains('proof_challenge'),
    );
    expect(snapshot.secondaryActions, ['Lưu', 'Xuất', 'Nhập']);
    expect(
      snapshot.trustSignals.map((signal) => signal.value),
      contains('no wallet value'),
    );
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

  testWidgets('SC-185 renders Arena Studio template baseline', (tester) async {
    await pumpArenaStudio(tester);

    expect(find.byType(ArenaStudioPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Arena Studio'), findsOneWidget);
    expect(find.text('Tạo challenge mới'), findsOneWidget);
    expect(find.text('Phí vận hành platform'), findsOneWidget);
    expect(find.text('Chọn template'), findsOneWidget);
    expect(find.text('Prediction'), findsOneWidget);
    expect(find.text('Closest Guess'), findsOneWidget);
    expect(find.text('Team Battle'), findsOneWidget);
    expect(find.text('Points-only'), findsWidgets);
    expect(find.text('Bước 1 / 6'), findsOneWidget);
  });

  testWidgets('SC-185 requires a template before continuing', (tester) async {
    await pumpArenaStudio(tester);

    await tester.tap(find.byKey(ArenaStudioPage.continueKey));
    await tester.pumpAndSettle();
    expect(find.text('Chọn template'), findsOneWidget);

    await tester.tap(find.byKey(ArenaStudioPage.templateKey('prediction')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ArenaStudioPage.continueKey));
    await tester.pumpAndSettle();

    expect(find.text('Cấu trúc trận đấu'), findsWidgets);
    expect(find.text('Bước 2 / 6'), findsOneWidget);
  });

  testWidgets('SC-185 secondary draft actions expose local state', (
    tester,
  ) async {
    await pumpArenaStudio(tester);

    await tester.tap(find.byKey(ArenaStudioPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã lưu bản nháp'), findsOneWidget);

    await tester.tap(find.byKey(ArenaStudioPage.exportKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã chuẩn bị file xuất'), findsOneWidget);

    await tester.tap(find.byKey(ArenaStudioPage.importKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã sẵn sàng nhập JSON'), findsOneWidget);
  });

  testWidgets('SC-185 Studio child routes open ported screens safely', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudioSmartRules,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ArenaSmartRuleBuilderPage), findsOneWidget);
    expect(find.text('Smart Rule Builder'), findsOneWidget);
  });
}
