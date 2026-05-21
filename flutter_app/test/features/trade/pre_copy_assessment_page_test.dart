import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pre_copy_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpPreCopyAssessment(
    WidgetTester tester, {
    String providerId = 'provider001',
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyProviderAssessment(
              providerId,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-071 mock repository exposes pre-copy assessment BE draft', () {
    final repo = const MockTradeRepository();
    final notFound = repo.getPreCopyAssessment(providerId: 'provider001');
    final found = repo.getPreCopyAssessment(providerId: 'ct001');

    expect(notFound.isNotFound, isTrue);
    expect(found.provider?.name, 'AlphaHunter_VN');
    expect(found.questions, hasLength(2));
    expect(found.educationDocs, hasLength(3));
    expect(
      notFound.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-071 renders blank state for missing provider001 baseline', (
    tester,
  ) async {
    await pumpPreCopyAssessment(tester);

    expect(find.byType(PreCopyAssessmentPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đánh giá rủi ro'), findsNothing);
    expect(find.text('Provider Not Found'), findsNothing);
  });

  testWidgets('SC-071 valid provider starts the assessment flow', (
    tester,
  ) async {
    await pumpPreCopyAssessment(tester, providerId: 'ct001');

    expect(find.text('Đánh giá rủi ro'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);

    await tester.tap(find.byKey(PreCopyAssessmentPage.startKey));
    await tester.pumpAndSettle();

    expect(find.text('Câu hỏi đánh giá'), findsOneWidget);
    expect(find.text('Kinh nghiệm giao dịch của bạn?'), findsOneWidget);
  });
}
