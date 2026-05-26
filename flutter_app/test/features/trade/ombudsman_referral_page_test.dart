import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/ombudsman_referral_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpOmbudsman(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyOmbudsmanReferral,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-114 mock repository exposes ombudsman BE draft', () {
    final snapshot = const MockTradeRepository().getOmbudsmanReferral();

    expect(snapshot.infoTitle, 'Free & Independent');
    expect(snapshot.eligibility.map((item) => item.title), [
      'After 8 Weeks',
      'Not Satisfied',
      'Within 6 Months',
    ]);
    expect(snapshot.contacts.map((contact) => contact.label), [
      'Phone',
      'Website',
      'Address',
    ]);
    expect(snapshot.processSteps, hasLength(4));
    expect(snapshot.externalUrl, 'https://www.financial-ombudsman.org.uk');
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-ombudsman-referral',
    );
    expect(snapshot.actionDraft, contains('POST /copy-trading/follow'));
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

  testWidgets('SC-114 renders ombudsman referral page in Trade shell', (
    tester,
  ) async {
    await pumpOmbudsman(tester);

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Financial Ombudsman'), findsOneWidget);
    expect(find.text('Independent Dispute Resolution'), findsOneWidget);
    expect(find.text('Free & Independent'), findsOneWidget);
    expect(find.text('When Can You Refer?'), findsOneWidget);
    expect(find.text('0800 023 4567'), findsOneWidget);
    expect(find.text('How It Works'), findsOneWidget);
    expect(find.text('Submit Your Complaint'), findsOneWidget);
  });

  testWidgets('SC-114 exposes external FOS website CTA', (tester) async {
    await pumpOmbudsman(tester);

    await tester.drag(
      find.byKey(OmbudsmanReferralPage.contentKey),
      const Offset(0, -520),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(OmbudsmanReferralPage.ctaKey), findsOneWidget);
    expect(find.text('Visit FOS Website'), findsOneWidget);
  });
}
