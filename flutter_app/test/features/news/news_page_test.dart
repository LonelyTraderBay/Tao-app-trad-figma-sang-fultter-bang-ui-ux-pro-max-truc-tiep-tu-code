import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/features/news/data/news_repository.dart';
import 'package:vit_trade_flutter/features/news/presentation/pages/news_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpNews(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.news),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-047 mock repository exposes the BE draft read model', () {
    final snapshot = const MockNewsRepository().getNews();

    expect(snapshot.newsReferenceData.endpoint, '/api/mobile/news/news');
    expect(snapshot.newsReferenceData.lastUpdatedLabel, 'read-only');
    expect(snapshot.articles, hasLength(5));
    expect(snapshot.pinnedArticles.map((article) => article.id), [
      'news001',
      'news002',
    ]);
    expect(snapshot.normalArticles, hasLength(3));
    expect(snapshot.newsReferenceData.filters, NewsArticleType.values);
    expect(snapshot.screenState, NewsScreenState.ready);
    expect(
      snapshot.supportedStates,
      containsAll([
        NewsScreenState.loading,
        NewsScreenState.empty,
        NewsScreenState.error,
        NewsScreenState.offline,
      ]),
    );

    final maintenance = const MockNewsRepository().getNews(
      type: NewsArticleType.maintenance,
    );
    expect(maintenance.articles.single.title, 'Bảo trì hệ thống định kỳ');

    final empty = const MockNewsRepository().getNews(
      type: NewsArticleType.general,
    );
    expect(empty.screenState, NewsScreenState.empty);
  });

  testWidgets('SC-047 renders the announcements feed inside the shell', (
    tester,
  ) async {
    await pumpNews(tester);

    expect(find.byType(NewsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tin tức & Thông báo'), findsOneWidget);
    expect(find.text('Tin tức · Cập nhật'), findsOneWidget);
    expect(find.text('GHIM (2)'), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsOneWidget);
    expect(find.text('Ra mắt tính năng P2P Trading'), findsOneWidget);
  });

  testWidgets('SC-047 first viewport reaches pinned news card', (tester) async {
    await pumpNews(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-047 NewsPage',
      semanticLabel: 'SC-047 NewsPage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(NewsPage.articleCardKey('news001')),
      targetLabel: 'the first pinned news card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-047 filters by article type', (tester) async {
    await pumpNews(tester);

    await tester.tap(
      find.byKey(NewsPage.filterKey(NewsArticleType.maintenance)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bảo trì hệ thống định kỳ'), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsNothing);

    await tester.tap(find.byKey(NewsPage.filterAllKey));
    await tester.pumpAndSettle();
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsOneWidget);
  });

  testWidgets('SC-047 opens and closes article detail sheet', (tester) async {
    await pumpNews(tester);

    await tester.tap(find.byKey(NewsPage.articleCardKey('news001')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Chào mừng sự kiện đặc biệt'), findsOneWidget);
    expect(find.text('Đóng'), findsOneWidget);

    await tester.tap(find.byKey(NewsPage.closeSheetKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chào mừng sự kiện đặc biệt'), findsNothing);
  });

  testWidgets('SC-047 back button returns to Home', (tester) async {
    await pumpNews(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });
}
