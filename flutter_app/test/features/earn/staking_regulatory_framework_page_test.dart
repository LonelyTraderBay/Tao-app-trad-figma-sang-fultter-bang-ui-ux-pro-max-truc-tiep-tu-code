import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn/presentation/pages/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn/presentation/pages/staking_regulatory_framework_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpFramework(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnRegulatoryFramework,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-373 mock repository exposes regulatory framework BE draft', () {
    final snapshot = const MockStakingRegulatoryFrameworkRepository()
        .getFramework();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-regulatory-framework');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Regulatory Framework');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.defaultTabId, 'licenses');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'licenses',
      'protection',
      'complaints',
    ]);
    expect(snapshot.licenses, hasLength(5));
    expect(snapshot.protectionSchemes, hasLength(3));
    expect(snapshot.complaintSteps, hasLength(3));
    expect(snapshot.authorityContacts, hasLength(3));
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-373 renders licenses baseline', (tester) async {
    await pumpFramework(tester);

    expect(find.byType(StakingRegulatoryFrameworkPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Regulatory Framework'), findsOneWidget);
    expect(find.byKey(StakingRegulatoryFrameworkPage.heroKey), findsOneWidget);
    expect(find.text('Regulated & Compliant'), findsOneWidget);
    expect(find.text('Licenses'), findsOneWidget);
    expect(find.text('Protection'), findsOneWidget);
    expect(find.text('Complaints'), findsOneWidget);
    expect(
      find.byKey(StakingRegulatoryFrameworkPage.licensesKey),
      findsOneWidget,
    );
    expect(find.text('Global Regulatory Licenses'), findsOneWidget);
    expect(find.text('United States'), findsOneWidget);
    expect(find.text('United Kingdom'), findsOneWidget);
    expect(find.text('Singapore'), findsOneWidget);
  });

  testWidgets('SC-373 license detail sheet opens and closes', (tester) async {
    await pumpFramework(tester);

    await tester.tap(
      find.byKey(
        StakingRegulatoryFrameworkPage.licenseKey('MSB-31000198765432'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Regulator'), findsOneWidget);
    expect(find.text('License Number'), findsOneWidget);
    expect(find.text('Authorized Scope'), findsOneWidget);
    expect(
      find.byKey(StakingRegulatoryFrameworkPage.detailCtaKey),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();

    expect(find.text('Regulator'), findsNothing);
  });

  testWidgets('SC-373 tabs show protection and complaints content', (
    tester,
  ) async {
    await pumpFramework(tester);

    await tester.tap(find.text('Protection'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(StakingRegulatoryFrameworkPage.protectionKey),
      findsOneWidget,
    );
    expect(find.text('Investor Protection Schemes'), findsOneWidget);
    expect(
      find.text('Financial Services Compensation Scheme (FSCS)'),
      findsOneWidget,
    );

    await tester.tap(find.text('Complaints'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(StakingRegulatoryFrameworkPage.complaintsKey),
      findsOneWidget,
    );
    expect(find.text('Complaint Handling Process'), findsOneWidget);
    expect(find.text('How to File a Complaint'), findsOneWidget);
    expect(find.text('UK Financial Conduct Authority'), findsOneWidget);
  });

  testWidgets('SC-373 back returns to staking hub', (tester) async {
    await pumpFramework(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
