import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/discovery/data/discovery_repository.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/topic_hub_page.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSearch(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.search),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-283 mock repository exposes discovery search BE draft', () {
    final snapshot = const MockDiscoveryRepository().getUnifiedSearch();

    expect(snapshot.endpoint, '/api/mobile/discovery/search');
    expect(snapshot.actionDraft, 'GET with query filters');
    expect(snapshot.title, 'Tìm kiếm');
    expect(snapshot.searchHint, 'Tìm sự kiện, mode, room, creator, coin...');
    expect(snapshot.trendingQueries.map((query) => query.label), [
      'Bitcoin',
      'ETH price',
      'Fed rate',
      'Arena challenge',
      'Altcoin battle',
      'Macro news',
    ]);
    expect(snapshot.modules.map((module) => module.route), [
      AppRoutePaths.marketsPredictions,
      AppRoutePaths.arena,
      AppRoutePaths.topics,
    ]);
    expect(
      snapshot.supportedStates,
      containsAll([
        DiscoveryScreenState.loading,
        DiscoveryScreenState.empty,
        DiscoveryScreenState.error,
        DiscoveryScreenState.offline,
      ]),
    );

    final bitcoin = const MockDiscoveryRepository().getUnifiedSearch(
      query: 'bitcoin',
    );
    expect(bitcoin.results.predictions.map((event) => event.id), ['pred-1']);
    expect(bitcoin.results.tradingPairs.map((pair) => pair.id), ['btcusdt']);
    expect(bitcoin.contractNotes, contains('Arena Points only'));
  });

  testWidgets('SC-283 renders baseline no-query discovery state', (
    tester,
  ) async {
    await pumpSearch(tester);

    expect(find.byType(UnifiedSearchPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tìm kiếm'), findsOneWidget);
    expect(find.byKey(UnifiedSearchPage.searchKey), findsOneWidget);
    expect(find.byKey(UnifiedSearchPage.offlineKey), findsOneWidget);
    expect(find.text('Trending'), findsOneWidget);
    expect(find.byKey(UnifiedSearchPage.trendingKey), findsOneWidget);
    expect(
      find.byKey(UnifiedSearchPage.trendingQueryKey('Bitcoin')),
      findsOneWidget,
    );
    expect(
      find.byKey(UnifiedSearchPage.moduleKey('predictions')),
      findsOneWidget,
    );
    expect(find.byKey(UnifiedSearchPage.moduleKey('arena')), findsOneWidget);
    expect(find.byKey(UnifiedSearchPage.moduleKey('topics')), findsOneWidget);
    expect(find.text('Prediction Markets'), findsOneWidget);
    expect(find.text('Open Arena'), findsOneWidget);
    expect(find.text('Topic Hub'), findsOneWidget);
  });

  testWidgets('SC-283 filters segmented results from query input', (
    tester,
  ) async {
    await pumpSearch(tester);

    await tester.enterText(find.byType(TextField).first, 'bitcoin');
    await tester.pumpAndSettle();

    expect(find.text('Prediction Events'), findsOneWidget);
    expect(find.text('Arena Rooms'), findsOneWidget);
    expect(find.text('Trading Pairs'), findsOneWidget);
    expect(find.text('Bitcoin ETF approval trước Q2?'), findsOneWidget);
    expect(
      find.byKey(UnifiedSearchPage.resultKey('pair', 'btcusdt')),
      findsOneWidget,
    );
    expect(find.byKey(UnifiedSearchPage.disclosureKey), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'arena');
    await tester.pumpAndSettle();

    expect(find.text('Arena Modes'), findsOneWidget);
    expect(find.text('Arena Rooms'), findsOneWidget);
    expect(find.text('Creators'), findsOneWidget);
    expect(find.text('Altcoin Battle'), findsOneWidget);
    expect(find.text('Minh Arena'), findsOneWidget);
  });

  testWidgets('SC-283 module and result navigation edges are wired', (
    tester,
  ) async {
    await pumpSearch(tester);

    await tester.tap(find.byKey(UnifiedSearchPage.moduleKey('predictions')));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);

    await pumpSearch(tester);
    await tester.tap(find.byKey(UnifiedSearchPage.moduleKey('topics')));
    await tester.pumpAndSettle();
    expect(find.byType(TopicHubPage), findsOneWidget);

    await pumpSearch(tester);
    await tester.enterText(find.byType(TextField).first, 'bitcoin');
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(UnifiedSearchPage.resultKey('pair', 'btcusdt')),
    );
    await tester.tap(
      find.byKey(UnifiedSearchPage.resultKey('pair', 'btcusdt')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });
}
