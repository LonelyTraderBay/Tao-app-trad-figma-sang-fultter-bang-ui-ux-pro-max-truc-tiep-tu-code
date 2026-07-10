import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/news/data/providers/news_repository_provider.dart';
import 'package:vit_trade_flutter/features/news/presentation/controllers/news_controller.dart';

export 'package:vit_trade_flutter/features/news/presentation/controllers/news_controller.dart';

final newsSnapshotProvider = FutureProvider<NewsScreenSnapshot>((ref) {
  return ref.watch(newsRepositoryProvider).getNews();
});

final newsControllerProvider = Provider<NewsController>((ref) {
  final snapshot = ref.watch(newsSnapshotProvider).requireValue;
  return NewsController(snapshot: snapshot);
});
