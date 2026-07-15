import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_core/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/governance/client_categorization_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/regulatory_disclosures_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/security_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

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

  Future<void> pumpClientOptUp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyClientOptUpRequest,
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

  testWidgets('SC-099 first viewport reaches classification review panel', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ClientCategorizationPage',
      semanticLabel: 'SC-099 ClientCategorizationPage',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Client classification review'),
      minVisibleHeight: 24,
      targetLabel: 'client classification review panel',
      reason:
          'Client categorization must expose the compliance review panel above '
          'bottom navigation before category inventory and tab content.',
    );
  });

  testWidgets('SC-099 opt-up first viewport reaches criteria review', (
    tester,
  ) async {
    await pumpClientOptUp(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ClientOptUpRequestPage',
      semanticLabel: 'SC-099 ClientOptUpRequestPage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ClientOptUpRequestPage.criteriaKey),
      minVisibleHeight: 24,
      targetLabel: 'professional criteria confirmation',
      reason:
          'Opt-up request must show the first required acknowledgement above '
          'bottom navigation before the submit action.',
    );
  });

  testWidgets('SC-099 switches protections, requirements, and history tabs', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    // The segmented tab row sits low enough in the compact layout that it
    // initially renders behind the fixed bottom navigation bar's hit-test
    // band; scroll it clear before interacting.
    await tester.scrollUntilVisible(
      ClientCategorizationPage.tabKey('protections').asFinder(),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ClientCategorizationPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();

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

    await tester.scrollUntilVisible(
      find.byKey(ClientCategorizationPage.disclosuresKey),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ClientCategorizationPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.drag(
      find.byKey(ClientCategorizationPage.contentKey),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ClientCategorizationPage.disclosuresKey));
    await tester.pumpAndSettle();

    expect(find.byType(RegulatoryDisclosuresPage), findsOneWidget);
    expect(find.text('Regulatory Disclosures'), findsOneWidget);

    await pumpClientCategorization(tester);
    await tester.scrollUntilVisible(
      find.byKey(ClientCategorizationPage.settingsKey),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ClientCategorizationPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.drag(
      find.byKey(ClientCategorizationPage.contentKey),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ClientCategorizationPage.settingsKey));
    await tester.pumpAndSettle();

    expect(find.byType(SecurityPage), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
