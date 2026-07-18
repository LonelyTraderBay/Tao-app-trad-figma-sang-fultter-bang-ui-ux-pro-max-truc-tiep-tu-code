import 'package:vit_trade_flutter/features/cross_module/domain/entities/smart_alerts_entities.dart';

/// Data source contract for the smart alerts (cross-module) center.
abstract interface class SmartAlertsRepository {
  SmartAlertsSnapshot getCenter();
}
