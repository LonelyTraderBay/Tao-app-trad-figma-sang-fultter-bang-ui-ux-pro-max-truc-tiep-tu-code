import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';

/// Data source contract for the dev route-checker tool.
abstract interface class RouteCheckerRepository {
  RouteCheckerSnapshot getRouteChecker();
}

/// Data source contract for the dev performance monitor tool.
abstract interface class PerformanceMonitorRepository {
  PerformanceMonitorSnapshot getPerformanceMonitor();
}

/// Data source contract for the dev "missing screens" showcase tool.
abstract interface class MissingScreensShowcaseRepository {
  MissingScreensShowcaseSnapshot getShowcase();
}

/// Data source contract for the dev design-system showcase tool.
abstract interface class DesignSystemRepository {
  DesignSystemSnapshot getDesignSystem();
}
