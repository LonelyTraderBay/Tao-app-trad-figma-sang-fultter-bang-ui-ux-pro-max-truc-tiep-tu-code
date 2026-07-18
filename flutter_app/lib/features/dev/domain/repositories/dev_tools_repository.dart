import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';

/// Data source contract for the dev route-checker tool.
abstract interface class RouteCheckerRepository {
  Future<RouteCheckerSnapshot> getRouteChecker();
}

/// Data source contract for the dev performance monitor tool.
abstract interface class PerformanceMonitorRepository {
  Future<PerformanceMonitorSnapshot> getPerformanceMonitor();
}

/// Data source contract for the dev "missing screens" showcase tool.
abstract interface class MissingScreensShowcaseRepository {
  Future<MissingScreensShowcaseSnapshot> getShowcase();
}

/// Data source contract for the dev design-system showcase tool.
abstract interface class DesignSystemRepository {
  Future<DesignSystemSnapshot> getDesignSystem();
}
