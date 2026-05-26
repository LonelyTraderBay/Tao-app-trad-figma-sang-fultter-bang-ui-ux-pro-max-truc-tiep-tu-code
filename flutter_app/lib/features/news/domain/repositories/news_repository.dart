import 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';

abstract interface class NewsRepository {
  NewsScreenSnapshot getNews({NewsArticleType? type});
}
