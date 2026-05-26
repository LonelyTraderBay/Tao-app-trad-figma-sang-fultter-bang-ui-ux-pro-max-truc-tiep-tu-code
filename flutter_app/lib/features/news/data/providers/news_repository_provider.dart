import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/news/domain/repositories/news_repository.dart';
import 'package:vit_trade_flutter/features/news/data/repositories/mock_news_repository.dart';

final newsRepositoryProvider = Provider<NewsRepository>(
  (_) => const MockNewsRepository(),
);
