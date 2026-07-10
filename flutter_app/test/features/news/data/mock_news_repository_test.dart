import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/news/data/repositories/mock_news_repository.dart';
import 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';

/// Behavior test for [MockNewsRepository]. Since the `{type}` filter param
/// was removed from `getNews()` (filtering moved client-side into
/// [NewsController], covered separately in news_controller_test.dart), this
/// repository is now thin: it returns a static article list, partitions it
/// into pinned/normal, derives `screenState`, and exposes a
/// `simulateError`/`loadDelay` toggle for exercising the error path. These
/// tests cover exactly that surface.
void main() {
  const repository = MockNewsRepository(loadDelay: Duration.zero);

  group('MockNewsRepository.getNews', () {
    test(
      'resolves to a NewsScreenSnapshot with the full fixture list',
      () async {
        final snapshot = await repository.getNews();

        expect(snapshot, isA<NewsScreenSnapshot>());
        expect(snapshot.articles, hasLength(5));
        expect(snapshot.articles.map((article) => article.id).toList(), [
          'news001',
          'news002',
          'news003',
          'news004',
          'news005',
        ]);
        expect(snapshot.newsReferenceData.endpoint, '/api/mobile/news/news');
        expect(snapshot.newsReferenceData.filters, NewsArticleType.values);
        expect(snapshot.newsReferenceData.lastUpdatedLabel, 'read-only');
        expect(snapshot.supportedStates, [
          NewsScreenState.loading,
          NewsScreenState.empty,
          NewsScreenState.error,
          NewsScreenState.offline,
        ]);
      },
    );

    test(
      'partitions the fixture into pinnedArticles/normalArticles by isPinned',
      () async {
        final snapshot = await repository.getNews();

        // Fixture: news001 and news002 are isPinned: true; news003, news004,
        // news005 are isPinned: false.
        expect(snapshot.pinnedArticles, hasLength(2));
        expect(snapshot.pinnedArticles.map((article) => article.id).toList(), [
          'news001',
          'news002',
        ]);
        expect(
          snapshot.pinnedArticles.every((article) => article.isPinned),
          isTrue,
        );

        expect(snapshot.normalArticles, hasLength(3));
        expect(snapshot.normalArticles.map((article) => article.id).toList(), [
          'news003',
          'news004',
          'news005',
        ]);
        expect(
          snapshot.normalArticles.every((article) => !article.isPinned),
          isTrue,
        );

        // The partition is exhaustive and non-overlapping.
        expect(
          snapshot.pinnedArticles.length + snapshot.normalArticles.length,
          snapshot.articles.length,
        );
      },
    );

    test(
      'screenState is ready given the current non-empty fixture',
      () async {
        final snapshot = await repository.getNews();

        expect(snapshot.screenState, NewsScreenState.ready);
      },
      // The `.empty` branch (screenState when the article list is empty) is
      // not exercised here: `_articles` is a private top-level `const List`
      // baked into mock_news_repository.dart, and MockNewsRepository has no
      // constructor parameter to swap it out for an empty fixture.
    );
  });

  group('MockNewsRepository.getNews simulateError', () {
    test('throws a StateError instead of resolving', () {
      const failingRepository = MockNewsRepository(
        simulateError: true,
        loadDelay: Duration.zero,
      );

      expect(failingRepository.getNews(), throwsA(isA<StateError>()));
    });
  });
}
