import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/launchpad_portfolio_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/launchpad_receipt_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpReceipt(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadReceiptSub001,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-301 mock repository exposes launchpad receipt BE draft', () {
    final snapshot = const MockLaunchpadRepository().getReceipt('sub001');

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-receipt-sub001');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Biên lai');
    expect(snapshot.backRoute, AppRoutePaths.launchpadPortfolio);
    expect(snapshot.launchpadRoute, AppRoutePaths.launchpad);
    expect(snapshot.portfolioRoute, AppRoutePaths.launchpadPortfolio);
    expect(snapshot.subscriptionId, 'sub001');
    expect(snapshot.subscription, isNull);
    expect(snapshot.contractNotes, contains('selected subscription'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      ]),
    );
  });

  test('SC-301 mock repository hydrates known subscription receipts', () {
    final snapshot = const MockLaunchpadRepository().getReceipt('sub1');

    expect(snapshot.subscription, isNotNull);
    expect(snapshot.subscription!.projectName, 'NexaAI Protocol');
    expect(
      snapshot.subscription!.status,
      LaunchpadSubscriptionStatus.partiallyAllocated,
    );
  });

  testWidgets('SC-301 renders Flutter direct-route error state', (
    tester,
  ) async {
    await pumpReceipt(tester);

    expect(find.byType(LaunchpadReceiptPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Biên lai'), findsOneWidget);
    expect(find.byKey(LaunchpadReceiptPage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadReceiptPage.errorKey), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(find.text('Không tải được dữ liệu'), findsOneWidget);
    expect(
      find.text('Vui lòng kiểm tra kết nối mạng và thử lại.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-301 header back returns to launchpad portfolio', (
    tester,
  ) async {
    await pumpReceipt(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPortfolioPage), findsOneWidget);
    expect(find.text('Launchpad Portfolio'), findsWidgets);
  });
}
