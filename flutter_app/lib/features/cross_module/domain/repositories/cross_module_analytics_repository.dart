import 'package:vit_trade_flutter/features/cross_module/domain/entities/cross_module_analytics_entities.dart';

/// Data source contract for the cross-module analytics screen.
abstract interface class CrossModuleAnalyticsRepository {
  CrossModuleAnalyticsSnapshot getAnalytics();
}
