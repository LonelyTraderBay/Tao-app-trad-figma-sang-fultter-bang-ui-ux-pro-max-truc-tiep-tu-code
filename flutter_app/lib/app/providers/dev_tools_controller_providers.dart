import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/dev/data/providers/dev_tools_repository_provider.dart';
import 'package:vit_trade_flutter/features/dev/presentation/controllers/dev_tools_controller.dart';

export 'package:vit_trade_flutter/features/dev/presentation/controllers/dev_tools_controller.dart';

final routeCheckerControllerProvider = Provider<RouteCheckerController>((ref) {
  return RouteCheckerController(ref.watch(routeCheckerRepositoryProvider));
});

final performanceMonitorControllerProvider =
    Provider<PerformanceMonitorController>((ref) {
      return PerformanceMonitorController(
        ref.watch(performanceMonitorRepositoryProvider),
      );
    });

final missingScreensShowcaseControllerProvider =
    Provider<MissingScreensShowcaseController>((ref) {
      return MissingScreensShowcaseController(
        ref.watch(missingScreensShowcaseRepositoryProvider),
      );
    });

final designSystemControllerProvider = Provider<DesignSystemController>((ref) {
  return DesignSystemController(ref.watch(designSystemRepositoryProvider));
});
