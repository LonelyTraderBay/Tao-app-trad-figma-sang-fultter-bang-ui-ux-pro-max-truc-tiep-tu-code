import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/arena_smart_rule_builder_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

void main() {
  Future<void> pumpSmartRules(WidgetTester tester) async {
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
  }

  test('SC-186 mock repository exposes Smart Rule BE draft', () {
    final snapshot = const MockArenaRepository().getArenaSmartRules();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-studio-smart-rules');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.steps.length, 6);
    expect(snapshot.domains.map((domain) => domain.id), contains('crypto'));
    expect(
      snapshot.challengeTypes.map((type) => type.id),
      containsAll(['yes_no', 'proof_challenge']),
    );
    expect(snapshot.defaultEndDate, '2026-03-15');
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

  testWidgets('SC-186 renders Smart Rule Builder baseline', (tester) async {
    await pumpSmartRules(tester);

    expect(find.byType(ArenaSmartRuleBuilderPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Arena Studio'), findsOneWidget);
    expect(find.text('Smart Rule Builder'), findsOneWidget);
    expect(find.text('Luật chơi — Smart Builder'), findsOneWidget);
    expect(find.text('Rule Clarity Score'), findsOneWidget);
    expect(find.text('Thấp'), findsWidgets);
    expect(find.text('Public vs Private — Room cần rule gì?'), findsOneWidget);
    expect(find.text('Tên challenge'), findsOneWidget);
    expect(find.text('Loại challenge'), findsWidgets);
    expect(find.text('Yes / No'), findsOneWidget);
  });

  testWidgets('SC-186 structured rule controls enable continue', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    final blockedCta = tester.widget<VitCtaButton>(
      find.byKey(ArenaSmartRuleBuilderPage.continueKey),
    );
    expect(blockedCta.onPressed, isNull);

    await tester.enterText(
      find.byKey(ArenaSmartRuleBuilderPage.titleKey),
      'BTC Weekly Predict — Tuần 10',
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.domainKey));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ArenaSmartRuleBuilderPage.challengeTypeKey('yes_no')),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.subjectKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.subjectKey));
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.actionKey));
    await tester.pumpAndSettle();

    expect(find.text('Crypto / Markets'), findsWidgets);
    expect(find.text('Người chơi'), findsWidgets);
    expect(find.text('đoán gần đúng nhất'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.continueKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.continueKey));
    await tester.pumpAndSettle();
    expect(find.text('Rule đã hoàn chỉnh'), findsOneWidget);
  });

  testWidgets('SC-186 guidance and draft actions expose local state', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.guidanceKey));
    await tester.pumpAndSettle();
    expect(find.text('Public room cần rule rõ ràng hơn'), findsOneWidget);

    await tester.ensureVisible(find.byKey(ArenaSmartRuleBuilderPage.saveKey));
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã lưu nháp'), findsOneWidget);
  });
}
