import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/dev/data/providers/dev_tools_repository_provider.dart';
import 'package:vit_trade_flutter/features/dev/presentation/controllers/dev_tools_controller.dart';

export 'package:vit_trade_flutter/features/dev/presentation/controllers/dev_tools_controller.dart';

// GD4-F6 (bẫy 29 "controller forwarder mỏng"): các controller dưới đây chỉ
// bọc 1 repository, không giữ ViewState riêng — giữ nguyên
// `Provider<XController>` SYNC, thêm FutureProvider snapshot gọi XUYÊN QUA
// controller. Trang tự `.when()` provider snapshot.

final routeCheckerControllerProvider = Provider<RouteCheckerController>((ref) {
  return RouteCheckerController(ref.watch(routeCheckerRepositoryProvider));
});

final routeCheckerSnapshotProvider = FutureProvider<RouteCheckerSnapshot>(
  (ref) => ref.watch(routeCheckerControllerProvider).snapshot(),
);

final performanceMonitorControllerProvider =
    Provider<PerformanceMonitorController>((ref) {
      return PerformanceMonitorController(
        ref.watch(performanceMonitorRepositoryProvider),
      );
    });

final performanceMonitorSnapshotProvider =
    FutureProvider<PerformanceMonitorSnapshot>(
      (ref) => ref.watch(performanceMonitorControllerProvider).snapshot(),
    );

final missingScreensShowcaseControllerProvider =
    Provider<MissingScreensShowcaseController>((ref) {
      return MissingScreensShowcaseController(
        ref.watch(missingScreensShowcaseRepositoryProvider),
      );
    });

final missingScreensShowcaseSnapshotProvider =
    FutureProvider<MissingScreensShowcaseSnapshot>(
      (ref) => ref.watch(missingScreensShowcaseControllerProvider).snapshot(),
    );

final designSystemControllerProvider = Provider<DesignSystemController>((ref) {
  return DesignSystemController(ref.watch(designSystemRepositoryProvider));
});

final designSystemSnapshotProvider = FutureProvider<DesignSystemSnapshot>(
  (ref) => ref.watch(designSystemControllerProvider).snapshot(),
);
