import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-007 HomePage renders the required proof sections', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('VitTrade'), findsOneWidget);
    expect(find.text('Tổng tài sản (USDT)'), findsOneWidget);
    expect(find.text('Dịch vụ'), findsOneWidget);
    expect(find.text('Prediction Markets'), findsOneWidget);
    expect(find.text('Open Arena'), findsOneWidget);
    expect(find.text('Thị trường'), findsWidgets);
    expect(find.text('BTC/USDT'), findsWidgets);
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Giao dịch'), findsOneWidget);
  });

  testWidgets('SC-007 supports balance toggle and market tabs', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(find.text('••••••'), findsOneWidget);

    final gainersTab = find.textContaining('Tăng');
    await tester.ensureVisible(gainersTab);
    await tester.pumpAndSettle();
    await tester.tap(gainersTab);
    await tester.pump();

    expect(find.text('SOL/USDT'), findsWidgets);
  });

  testWidgets(
    'SC-007 hides the Home header on scroll down and shows it on scroll up',
    (tester) async {
      await pumpHome(tester);

      double headerHeight() {
        return tester.getSize(find.byKey(HomePage.headerKey)).height;
      }

      expect(headerHeight(), greaterThan(0));
      expect(find.text('VitTrade'), findsOneWidget);

      await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -320));
      await tester.pumpAndSettle(const Duration(milliseconds: 220));

      expect(headerHeight(), closeTo(0, 0.1));

      await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, 120));
      await tester.pumpAndSettle(const Duration(milliseconds: 220));

      expect(headerHeight(), greaterThan(0));
      expect(find.text('VitTrade'), findsOneWidget);
    },
  );

  testWidgets(
    'SC-007 exposes Home outgoing navigation without porting targets',
    (tester) async {
      await pumpHome(tester);

      await tester.tap(find.byTooltip('Tìm kiếm toàn cục'));
      await tester.pumpAndSettle();

      expect(find.byType(UnifiedSearchPage), findsOneWidget);
      expect(find.text('Tìm kiếm'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('P2P'));
      await tester.tap(find.text('P2P'));
      await tester.pumpAndSettle();

      expect(find.text('P2P'), findsOneWidget);
    },
  );

  testWidgets('SC-007 full content scroll reaches lower market sections', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.ensureVisible(find.text('Top giảm giá'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Top giảm giá'), findsOneWidget);
    expect(find.byKey(HomePage.contentKey), findsOneWidget);
  });

  testWidgets('SC-007 bottom content clears the bottom nav overlay', (
    tester,
  ) async {
    await pumpHome(tester);

    for (var i = 0; i < 8; i++) {
      await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -600));
      await tester.pump();
    }
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    final lastLoser = find.text('XRP/USDT').last;
    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;

    expect(lastLoser, findsOneWidget);
    expect(tester.getBottomLeft(lastLoser).dy, lessThan(navTop - 8));
  });
}
