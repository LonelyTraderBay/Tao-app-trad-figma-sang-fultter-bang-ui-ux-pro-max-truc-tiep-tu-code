import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/domain/repositories/dev_tools_repository.dart';

export 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
export 'package:vit_trade_flutter/features/dev/domain/repositories/dev_tools_repository.dart';

final class RouteCheckerController {
  const RouteCheckerController(this._repository);

  final RouteCheckerRepository _repository;

  RouteCheckerSnapshot snapshot() => _repository.getRouteChecker();
}

final class PerformanceMonitorController {
  const PerformanceMonitorController(this._repository);

  final PerformanceMonitorRepository _repository;

  PerformanceMonitorSnapshot snapshot() => _repository.getPerformanceMonitor();
}

final class MissingScreensShowcaseController {
  const MissingScreensShowcaseController(this._repository);

  final MissingScreensShowcaseRepository _repository;

  MissingScreensShowcaseSnapshot snapshot() => _repository.getShowcase();
}

final class DesignSystemController {
  const DesignSystemController(this._repository);

  final DesignSystemRepository _repository;

  DesignSystemSnapshot snapshot() => _repository.getDesignSystem();
}
