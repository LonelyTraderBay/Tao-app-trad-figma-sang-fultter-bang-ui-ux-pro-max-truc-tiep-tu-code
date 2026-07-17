import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/presentation/controllers/home_controller.dart';

export 'package:vit_trade_flutter/features/home/presentation/controllers/home_controller.dart';

final homeSnapshotProvider = FutureProvider<HomeSnapshot>((ref) {
  return ref.watch(homeRepositoryProvider).fetchHome();
});

/// STATE-S25: trả AsyncValue thay vì `requireValue` (từng ném StateError khi
/// đọc lúc snapshot còn loading/error) — consumer tự xử lý loading/error
/// tường minh qua when/whenData.
final homeControllerProvider = Provider<AsyncValue<HomeController>>((ref) {
  return ref
      .watch(homeSnapshotProvider)
      .whenData(
        (snapshot) => HomeController(state: HomeViewState(snapshot: snapshot)),
      );
});
