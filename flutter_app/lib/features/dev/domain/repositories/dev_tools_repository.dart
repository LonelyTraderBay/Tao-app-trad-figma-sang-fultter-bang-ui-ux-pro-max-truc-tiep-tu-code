import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';

abstract interface class RouteCheckerRepository {
  RouteCheckerSnapshot getRouteChecker();
}

abstract interface class PerformanceMonitorRepository {
  PerformanceMonitorSnapshot getPerformanceMonitor();
}

abstract interface class MissingScreensShowcaseRepository {
  MissingScreensShowcaseSnapshot getShowcase();
}

abstract interface class DesignSystemRepository {
  DesignSystemSnapshot getDesignSystem();
}
