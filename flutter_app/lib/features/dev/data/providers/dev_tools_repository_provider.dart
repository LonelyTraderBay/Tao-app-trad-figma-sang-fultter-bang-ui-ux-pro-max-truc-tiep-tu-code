import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/dev/domain/repositories/dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/data/repositories/mock_dev_tools_repository.dart';

final routeCheckerRepositoryProvider = Provider<RouteCheckerRepository>((ref) {
  return const MockRouteCheckerRepository();
});

final performanceMonitorRepositoryProvider =
    Provider<PerformanceMonitorRepository>((ref) {
      return const MockPerformanceMonitorRepository();
    });

final missingScreensShowcaseRepositoryProvider =
    Provider<MissingScreensShowcaseRepository>((ref) {
      return const MockMissingScreensShowcaseRepository();
    });

final designSystemRepositoryProvider = Provider<DesignSystemRepository>((ref) {
  return const MockDesignSystemRepository();
});
