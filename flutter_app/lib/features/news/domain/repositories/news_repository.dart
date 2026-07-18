import 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';

/// Repository contract for fetching the news feed's [NewsScreenSnapshot].
abstract interface class NewsRepository {
  Future<NewsScreenSnapshot> getNews();
}
