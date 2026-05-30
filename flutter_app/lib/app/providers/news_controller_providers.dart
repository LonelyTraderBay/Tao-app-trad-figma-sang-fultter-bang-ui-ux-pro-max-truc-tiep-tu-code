import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/news/data/providers/news_repository_provider.dart';
import 'package:vit_trade_flutter/features/news/presentation/controllers/news_controller.dart';

export 'package:vit_trade_flutter/features/news/presentation/controllers/news_controller.dart';

final newsControllerProvider = Provider<NewsController>((ref) {
  return NewsController(ref.watch(newsRepositoryProvider));
});
