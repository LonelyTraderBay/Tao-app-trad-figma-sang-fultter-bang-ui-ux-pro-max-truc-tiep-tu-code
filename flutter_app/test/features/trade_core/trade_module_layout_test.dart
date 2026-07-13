import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_product_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

/// Test-local stand-in for a module-owned nav source (see the doc comment
/// on `tradeShellWithProductTabs` — `trade_core` never supplies one itself).
TradeProductNavigation _fakeProductNavigation({
  required BuildContext context,
  TradePair? pair,
  required String activeId,
  Key Function(String id)? quickNavKey,
}) {
  return TradeProductNavigation(
    tabs: [
      VitTradeProductTab(id: 'spot', label: 'Spot', onTap: () {}),
      VitTradeProductTab(id: 'futures', label: 'Futures', onTap: () {}),
    ],
    overflow: const [],
  );
}

void main() {
  testWidgets('tradeScrollBottomInset matches Home formula at 360px native', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late double inset;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            inset = tradeScrollBottomInset(
              context,
              shellRenderMode: ShellRenderMode.native,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(inset, AppSpacing.buttonStandard + AppSpacing.x5);
  });

  testWidgets('tradeTerminalScrollBottomInset includes chrome at visual QA', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late double nativeInset;
    late double visualInset;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            nativeInset = tradeTerminalScrollBottomInset(
              context,
              shellRenderMode: ShellRenderMode.native,
            );
            visualInset = tradeTerminalScrollBottomInset(
              context,
              shellRenderMode: ShellRenderMode.visualQa,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(visualInset, greaterThan(nativeInset));
    expect(nativeInset, greaterThan(TradeSpacingTokens.tradeBottomInsetNative));
  });

  testWidgets('VitTradeDetailScaffold uses flush page variant', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: VitTradeDetailScaffold(
          title: 'Compliance detail',
          showBack: false,
          showProductTabs: false,
          children: const [Text('Body')],
        ),
      ),
    );

    final layout = tester.widget<VitPageLayout>(find.byType(VitPageLayout));
    expect(layout.variant, VitPageVariant.flush);
    expect(find.text('Compliance detail'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });

  testWidgets('VitTradeComplianceSection renders rows, dividers, and pill', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VitTradeComplianceSection(
            title: 'Regulatory status',
            statusPill: const VitStatusPill(
              label: 'Compliant',
              status: VitStatusPillStatus.success,
            ),
            items: const [
              VitTradeComplianceItem(label: 'Framework', value: 'MiFID II'),
              VitTradeComplianceItem(label: 'Last review', value: '2026-01-15'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Regulatory status'), findsOneWidget);
    expect(find.text('Compliant'), findsOneWidget);
    expect(find.text('Framework'), findsOneWidget);
    expect(find.text('MiFID II'), findsOneWidget);
    expect(find.text('Last review'), findsOneWidget);
    expect(find.byType(VitInfoRow), findsNWidgets(2));
    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets(
    'VitTradeHubScaffold renders product tabs as first scroll child',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VitTradeHubScaffold(
            title: 'Orders',
            showBack: false,
            showProductTabs: true,
            navigationBuilder: _fakeProductNavigation,
            children: const [Text('Order body')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VitTradeProductTabs), findsOneWidget);
      expect(find.text('Spot'), findsOneWidget);
      expect(find.text('Order body'), findsOneWidget);

      final pageContent = tester.widget<VitPageContent>(
        find.descendant(
          of: find.byType(VitTradeHubScaffold),
          matching: find.byType(VitPageContent),
        ),
      );
      expect(pageContent.children.first, isA<VitTradeProductTabs>());
    },
  );
}
