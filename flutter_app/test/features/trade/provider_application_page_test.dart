import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/provider_application_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpProviderApplication(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyProviderApply,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-069 mock repository exposes provider application BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getProviderApplication();
    final result = repo.submitProviderApplication(snapshot.defaultDraft);

    expect(snapshot.steps, hasLength(5));
    expect(snapshot.defaultStep, TradeProviderApplicationStep.intro);
    expect(snapshot.benefits, hasLength(3));
    expect(snapshot.requirements.first.label, 'KYC Level 2');
    expect(snapshot.defaultDraft.minCapital, 10000);
    expect(result.status, 'submitted');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-069 renders ProviderApplicationPage inside the Trade shell', (
    tester,
  ) async {
    await pumpProviderApplication(tester);

    expect(find.byType(ProviderApplicationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('Đăng ký Provider'), findsOneWidget);
    expect(find.text('Trở thành Copy Trading Provider'), findsOneWidget);
    expect(find.text('Performance Fee'), findsOneWidget);
    expect(find.text('Trách nhiệm quan trọng'), findsOneWidget);
    expect(find.byKey(ProviderApplicationPage.nextKey), findsOneWidget);
  });

  testWidgets('SC-069 wizard gates requirements before disclosure', (
    tester,
  ) async {
    await pumpProviderApplication(tester);

    await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
    await tester.pumpAndSettle();

    expect(find.text('Kiểm tra điều kiện'), findsOneWidget);

    await tester.tap(find.byKey(ProviderApplicationPage.kycKey));
    await tester.enterText(
      find.byKey(ProviderApplicationPage.monthsFieldKey),
      '6',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
    await tester.pumpAndSettle();

    expect(find.text('Nghĩa vụ công khai'), findsOneWidget);
  });

  testWidgets('SC-069 back returns to SC-063 CopyTradingPage', (tester) async {
    await pumpProviderApplication(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(ProviderApplicationPage), findsNothing);
  });
}
