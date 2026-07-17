/// Category of a news article, driving its label/emoji and filter grouping.
enum NewsArticleType {
  maintenance,
  newFeature,
  promotion,
  security,
  listing,
  general,
}

/// Display helpers (label, emoji) for [NewsArticleType].
extension NewsArticleTypeConfig on NewsArticleType {
  String get label => switch (this) {
    NewsArticleType.maintenance => 'Bảo trì',
    NewsArticleType.newFeature => 'Tính năng mới',
    NewsArticleType.promotion => 'Khuyến mãi',
    NewsArticleType.security => 'Bảo mật',
    NewsArticleType.listing => 'Niêm yết',
    NewsArticleType.general => 'Tổng hợp',
  };

  String get emoji => switch (this) {
    NewsArticleType.maintenance => '⚙️',
    NewsArticleType.newFeature => '✨',
    NewsArticleType.promotion => '🎉',
    NewsArticleType.security => '🔐',
    NewsArticleType.listing => '📊',
    NewsArticleType.general => '📰',
  };
}

/// UI states the news screen can render.
enum NewsScreenState { loading, empty, error, offline, ready }

/// Reference data (available filters, endpoint, freshness label) for the
/// news screen.
final class NewsReferenceData {
  const NewsReferenceData({
    required this.endpoint,
    required this.filters,
    required this.lastUpdatedLabel,
  });

  final String endpoint;
  final List<NewsArticleType> filters;
  final String lastUpdatedLabel;
}

/// Data contract for the news screen: articles split into pinned/normal
/// plus reference data and current state.
final class NewsScreenSnapshot {
  const NewsScreenSnapshot({
    required this.articles,
    required this.pinnedArticles,
    required this.normalArticles,
    required this.newsReferenceData,
    required this.screenState,
    required this.supportedStates,
  });

  final List<NewsArticle> articles;
  final List<NewsArticle> pinnedArticles;
  final List<NewsArticle> normalArticles;
  final NewsReferenceData newsReferenceData;
  final NewsScreenState screenState;
  final List<NewsScreenState> supportedStates;
}

/// A single news article shown in the news feed.
final class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedAtLabel,
    required this.isPinned,
    required this.tags,
  });

  final String id;
  final NewsArticleType type;
  final String title;
  final String summary;
  final String content;
  final String publishedAtLabel;
  final bool isPinned;
  final List<String> tags;
}
