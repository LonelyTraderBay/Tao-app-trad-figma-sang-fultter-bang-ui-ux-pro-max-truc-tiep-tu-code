import 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';

export 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';

/// Pure client-side view over an already-fetched [NewsScreenSnapshot].
///
/// The repository now returns the full, unfiltered article set in one shot
/// (see [NewsRepository]); filtering by [NewsArticleType] happens here so
/// switching filter chips never re-triggers a fetch or a loading flash.
final class NewsController {
  const NewsController({required this.snapshot});

  final NewsScreenSnapshot snapshot;

  NewsScreenSnapshot filterBy(NewsArticleType? type) {
    final filtered = type == null
        ? snapshot.articles
        : snapshot.articles.where((article) => article.type == type).toList();
    final resolvedState =
        filtered.isEmpty && snapshot.screenState == NewsScreenState.ready
        ? NewsScreenState.empty
        : snapshot.screenState;
    return NewsScreenSnapshot(
      articles: filtered,
      pinnedArticles: filtered.where((article) => article.isPinned).toList(),
      normalArticles: filtered.where((article) => !article.isPinned).toList(),
      newsReferenceData: snapshot.newsReferenceData,
      screenState: resolvedState,
      supportedStates: snapshot.supportedStates,
    );
  }
}
