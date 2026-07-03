import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/presentation/controllers/home_controller.dart';

export 'package:vit_trade_flutter/features/home/presentation/controllers/home_controller.dart';

final homeSnapshotProvider = FutureProvider<HomeSnapshot>((ref) {
  return ref.watch(homeRepositoryProvider).fetchHome();
});

final homeControllerProvider = Provider<HomeController>((ref) {
  final snapshot = ref.watch(homeSnapshotProvider).requireValue;
  return HomeController(state: HomeViewState(snapshot: snapshot));
});
