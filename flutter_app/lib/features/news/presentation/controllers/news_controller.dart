import 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';
import 'package:vit_trade_flutter/features/news/domain/repositories/news_repository.dart';

export 'package:vit_trade_flutter/features/news/domain/entities/news_entities.dart';
export 'package:vit_trade_flutter/features/news/domain/repositories/news_repository.dart';

final class NewsController implements NewsRepository {
  const NewsController(this._repository);

  final NewsRepository _repository;

  @override
  NewsScreenSnapshot getNews({NewsArticleType? type}) {
    return _repository.getNews(type: type);
  }
}
