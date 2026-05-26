import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/investor_compensation_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpInvestorCompensation(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyInvestorCompensation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-104 mock repository exposes investor compensation BE draft', () {
    final snapshot = const MockTradeRepository().getInvestorCompensation();

    expect(snapshot.coverageLimit, '£85,000');
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-investor-compensation',
    );
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
    expect(snapshot.overviewItems.map((item) => item.title), [
      'Independent Protection',
      'Free to Claimants',
      'Fast Payment',
    ]);
    expect(snapshot.coverageItems.map((item) => item.label), [
      'Investments',
      'Deposits',
    ]);
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-104 renders investor compensation in Trade shell', (
    tester,
  ) async {
    await pumpInvestorCompensation(tester);

    expect(find.byType(InvestorCompensationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Investor Compensation'), findsOneWidget);
    expect(find.text('FSCS Protection'), findsOneWidget);
    expect(find.text('Protected up to £85,000'), findsOneWidget);
    expect(find.text('Automatic Protection'), findsOneWidget);
    expect(find.text('What Is FSCS?'), findsOneWidget);
    expect(find.text('Coverage Limits'), findsOneWidget);
    expect(find.byKey(InvestorCompensationPage.faqKey), findsOneWidget);
  });

  testWidgets('SC-104 switches eligibility and claim tabs', (tester) async {
    await pumpInvestorCompensation(tester);

    await tester.tap(
      find.byKey(InvestorCompensationPage.tabKey('eligibility')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Who Is Eligible?'), findsOneWidget);
    expect(find.text('Individuals (retail clients)'), findsOneWidget);
    expect(find.text('Large companies'), findsOneWidget);

    await tester.tap(find.byKey(InvestorCompensationPage.tabKey('claim')));
    await tester.pumpAndSettle();

    expect(find.text('How to Make a Claim'), findsOneWidget);
    expect(find.text('Firm Declared in Default'), findsOneWidget);
    expect(find.text('Visit FSCS Website'), findsOneWidget);
  });
}
