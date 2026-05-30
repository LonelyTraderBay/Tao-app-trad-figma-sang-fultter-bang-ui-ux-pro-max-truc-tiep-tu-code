enum NewsArticleType {
  maintenance,
  newFeature,
  promotion,
  security,
  listing,
  general,
}

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

enum NewsScreenState { loading, empty, error, offline, ready }

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
