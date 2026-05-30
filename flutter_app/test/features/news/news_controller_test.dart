import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/news/data/repositories/mock_news_repository.dart';
import 'package:vit_trade_flutter/features/news/presentation/controllers/news_controller.dart';

void main() {
  group('NewsController', () {
    test('exposes filtered news snapshots through repository contract', () {
      final controller = NewsController(const MockNewsRepository());

      final all = controller.getNews();
      final security = controller.getNews(type: NewsArticleType.security);
      final empty = controller.getNews(type: NewsArticleType.general);

      expect(all.articles, hasLength(5));
      expect(security.articles.single.type, NewsArticleType.security);
      expect(empty.screenState, NewsScreenState.empty);
      expect(all.supportedStates, contains(NewsScreenState.offline));
    });
  });
}
