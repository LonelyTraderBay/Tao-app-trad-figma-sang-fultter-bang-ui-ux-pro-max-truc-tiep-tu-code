import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/support/data/providers/support_repository_provider.dart';
import 'package:vit_trade_flutter/features/support/presentation/controllers/support_controller.dart';

export 'package:vit_trade_flutter/features/support/presentation/controllers/support_controller.dart';

final supportControllerProvider = Provider<SupportController>((ref) {
  return SupportController(ref.watch(supportRepositoryProvider));
});

// GD4-F5 (mục 3+4 GD4-Async-Playbook): provider trung gian cho mọi snapshot
// support — trang `.watch()` một trong các provider dưới đây thay vì gọi
// `supportControllerProvider.getX()` trực tiếp trong build() (repo giờ trả
// Future<T>).
final supportHubSnapshotProvider = FutureProvider<SupportHubSnapshot>(
  (ref) => ref.watch(supportControllerProvider).getSupportHub(),
);

final helpCenterSnapshotProvider = FutureProvider<HelpCenterSnapshot>(
  (ref) => ref.watch(supportControllerProvider).getHelpCenter(),
);

final announcementsSnapshotProvider = FutureProvider<AnnouncementsSnapshot>(
  (ref) => ref.watch(supportControllerProvider).getAnnouncements(),
);
