import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/arena_creator_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/arena_safety_center_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/arena_trust_breakdown_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpTrust(WidgetTester tester, String entityId) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaTrust(entityId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-199 mock repository exposes Arena Trust BE draft', () {
    final missing = const MockArenaRepository().getArenaTrustBreakdown(
      'user001',
    );
    final creator = const MockArenaRepository().getArenaTrustBreakdown('cr001');

    expect(missing.endpoint, '/api/mobile/arena/arena-trust-user001');
    expect(
      missing.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(missing.creator, isNull);
    expect(missing.emptyTitle, 'Không tìm thấy');
    expect(missing.emptySubtitle, 'Creator không tồn tại');
    expect(creator.creator?.id, 'cr001');
    expect(
      creator.metrics.map((metric) => metric.label),
      contains('Fair Play'),
    );
    expect(creator.disclaimer, contains('không phải PnL'));
    expect(
      missing.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-199 renders missing creator baseline', (tester) async {
    await pumpTrust(tester, 'user001');

    expect(find.byType(ArenaTrustBreakdownPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trust Score'), findsOneWidget);
    expect(find.text('Độ tin cậy · Open Arena'), findsOneWidget);
    expect(find.text('Không tìm thấy'), findsOneWidget);
    expect(find.text('Creator không tồn tại'), findsOneWidget);
  });

  testWidgets('SC-199 creator trust links navigate safely', (tester) async {
    await pumpTrust(tester, 'cr001');

    expect(find.text('CryptoMaster_VN Trust Score'), findsOneWidget);
    expect(find.text('Fair Play'), findsWidgets);
    expect(find.text('95%'), findsOneWidget);

    await tester.tap(find.byKey(ArenaTrustBreakdownPage.creatorLinkKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaCreatorPage), findsOneWidget);

    await pumpTrust(tester, 'cr001');
    await tester.ensureVisible(
      find.byKey(ArenaTrustBreakdownPage.safetyLinkKey),
    );
    await tester.tap(find.byKey(ArenaTrustBreakdownPage.safetyLinkKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaSafetyCenterPage), findsOneWidget);
  });
}
