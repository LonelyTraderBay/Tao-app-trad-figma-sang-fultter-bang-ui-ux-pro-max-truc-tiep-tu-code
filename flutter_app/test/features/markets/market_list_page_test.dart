import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/hub/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/market_movers_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/market_sectors_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpMarkets(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.markets),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-008 mock repository exposes the BE draft read model', () {
    final snapshot = const MockMarketRepository().getMarketList();

    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, contains('Tất cả'));
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-008 renders inside the shell with Markets active', (
    tester,
  ) async {
    await pumpMarkets(tester);

    expect(find.byType(MarketListPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Thị trường'), findsWidgets);
    expect(find.text('Tìm kiếm BTC, ETH...'), findsOneWidget);
    expect(find.text('Tăng mạnh'), findsOneWidget);
    expect(find.text('Giảm mạnh'), findsOneWidget);
    expect(find.text('Cặp giao dịch'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);
    expect(find.textContaining('Vol \$'), findsWidgets);
  });

  testWidgets('SC-008 supports search empty state and reset', (tester) async {
    await pumpMarkets(tester);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('Không tìm thấy "zzz"'), findsOneWidget);
    expect(find.text('Tăng mạnh'), findsNothing);

    await tester.tap(find.text('Xóa bộ lọc'));
    await tester.pump();

    expect(find.text('BTC'), findsWidgets);
    expect(find.text('Tăng mạnh'), findsOneWidget);
  });

  testWidgets('SC-008 supports category and sort controls', (tester) async {
    await pumpMarkets(tester);

    await tester.tap(find.text('Layer 2'));
    await tester.pump();

    expect(find.text('MATIC'), findsWidgets);
    expect(find.text('Tăng mạnh'), findsNothing);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pump();

    expect(find.text('Giá thấp -> cao'), findsOneWidget);

    await tester.tap(find.text('Giá thấp -> cao'));
    await tester.pump();

    expect(find.text('Giá thấp -> cao'), findsNothing);
  });

  testWidgets('SC-008 toggles local watchlist state', (tester) async {
    await pumpMarkets(tester);

    expect(find.bySemanticsLabel('Thêm vào yêu thích BNB'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Thêm vào yêu thích BNB'));
    await tester.pump();

    expect(find.bySemanticsLabel('Bỏ yêu thích BNB'), findsOneWidget);
  });

  testWidgets('SC-008 wires visible market navigation edges', (tester) async {
    await pumpMarkets(tester);

    await tester.tap(find.byTooltip('Tổng quan thị trường'));
    await tester.pumpAndSettle();
    expect(find.text('Tổng quan thị trường'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.bar_chart_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(MarketMoversPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.layers_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(MarketSectorsPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bộ lọc'));
    await tester.pumpAndSettle();
    expect(find.text('Bộ lọc thị trường'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sc008_pair_btcusdt')));
    await tester.pumpAndSettle();
    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-008 full content reaches the safe bridge section', (
    tester,
  ) async {
    await pumpMarkets(tester);

    await tester.ensureVisible(find.text('Khám phá thêm'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Khám phá thêm'), findsOneWidget);
    expect(find.text('Prediction Markets'), findsOneWidget);
    expect(find.text('Open Arena'), findsOneWidget);
  });
}
