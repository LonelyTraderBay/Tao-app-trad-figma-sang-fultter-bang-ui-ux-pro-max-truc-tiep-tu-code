import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/client_categorization_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/regulatory_disclosures_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/security_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpClientCategorization(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyClientCategorization,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-099 mock repository exposes client categorization BE draft', () {
    final snapshot = const MockTradeRepository().getClientCategorization();

    expect(snapshot.defaultTab, 'overview');
    expect(snapshot.currentCategoryId, 'retail');
    expect(snapshot.categories.map((category) => category.label), [
      'Retail Client',
      'Professional Client',
      'Eligible Counterparty',
    ]);
    expect(snapshot.categories.first.protections.length, 8);
    expect(snapshot.categories.first.requirements.length, 3);
    expect(snapshot.history.map((entry) => entry.action), [
      'categorized',
      'opt-up-requested',
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

  testWidgets('SC-099 renders client categorization inside Trade shell', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    expect(find.byType(ClientCategorizationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Client Categorization'), findsOneWidget);
    expect(find.text('MiFID II Classification'), findsOneWidget);
    expect(find.text('Maximum Protection Active'), findsOneWidget);
    expect(find.text('MiFID II Categorization'), findsOneWidget);
    expect(find.text('Client Categories'), findsOneWidget);
    expect(
      find.byKey(ClientCategorizationPage.categoryKey('retail')),
      findsOneWidget,
    );
    expect(find.text('Professional Client'), findsOneWidget);
  });

  testWidgets('SC-099 switches protections, requirements, and history tabs', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    await tester.tap(ClientCategorizationPage.tabKey('protections').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Protection Comparison'), findsOneWidget);
    expect(find.text('Full appropriateness test required'), findsOneWidget);

    await tester.tap(
      ClientCategorizationPage.tabKey('requirements').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Qualification Requirements'), findsOneWidget);
    expect(find.text('Portfolio over EUR 500,000'), findsOneWidget);

    await tester.tap(ClientCategorizationPage.tabKey('history').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Category History'), findsOneWidget);
    expect(find.text('Initial Categorization'), findsOneWidget);
    expect(find.text('Opt-Up Requested'), findsOneWidget);
  });

  testWidgets('SC-099 opt-up edge uses scoped request route', (tester) async {
    await pumpClientCategorization(tester);

    await tester.ensureVisible(find.byKey(ClientCategorizationPage.optUpKey));
    await tester.tap(find.byKey(ClientCategorizationPage.optUpKey));
    await tester.pumpAndSettle();

    expect(find.byType(ClientOptUpRequestPage), findsOneWidget);
    expect(find.text('Client Opt-Up Request'), findsOneWidget);
  });

  testWidgets('SC-099 quick links resolve to disclosure and settings routes', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    await tester.ensureVisible(
      find.byKey(ClientCategorizationPage.disclosuresKey),
    );
    await tester.tap(find.byKey(ClientCategorizationPage.disclosuresKey));
    await tester.pumpAndSettle();

    expect(find.byType(RegulatoryDisclosuresPage), findsOneWidget);
    expect(find.text('Regulatory Disclosures'), findsOneWidget);

    await pumpClientCategorization(tester);
    await tester.ensureVisible(
      find.byKey(ClientCategorizationPage.settingsKey),
    );
    await tester.tap(find.byKey(ClientCategorizationPage.settingsKey));
    await tester.pumpAndSettle();

    expect(find.byType(SecurityPage), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
