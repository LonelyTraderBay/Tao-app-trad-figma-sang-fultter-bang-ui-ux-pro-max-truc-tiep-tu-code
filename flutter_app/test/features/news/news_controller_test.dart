import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/news/data/repositories/mock_news_repository.dart';
import 'package:vit_trade_flutter/features/news/presentation/controllers/news_controller.dart';

void main() {
  group('NewsController', () {
    test('filters an already-fetched snapshot client-side', () async {
      final snapshot = await const MockNewsRepository(
        loadDelay: Duration.zero,
      ).getNews();
      final controller = NewsController(snapshot: snapshot);

      final all = controller.filterBy(null);
      final security = controller.filterBy(NewsArticleType.security);
      final empty = controller.filterBy(NewsArticleType.general);

      expect(all.articles, hasLength(5));
      expect(security.articles.single.type, NewsArticleType.security);
      expect(empty.screenState, NewsScreenState.empty);
      expect(all.supportedStates, contains(NewsScreenState.offline));
    });

    test(
      'preserves a non-ready screen state even when filtering empties it',
      () {
        const snapshot = NewsScreenSnapshot(
          articles: [],
          pinnedArticles: [],
          normalArticles: [],
          newsReferenceData: NewsReferenceData(
            endpoint: '/api/mobile/news/news',
            filters: NewsArticleType.values,
            lastUpdatedLabel: 'read-only',
          ),
          screenState: NewsScreenState.offline,
          supportedStates: [
            NewsScreenState.loading,
            NewsScreenState.empty,
            NewsScreenState.error,
            NewsScreenState.offline,
          ],
        );
        final controller = const NewsController(snapshot: snapshot);

        final filtered = controller.filterBy(NewsArticleType.security);

        expect(filtered.screenState, NewsScreenState.offline);
      },
    );
  });
}
