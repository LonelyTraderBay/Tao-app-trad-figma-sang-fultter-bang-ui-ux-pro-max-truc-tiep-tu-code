import 'package:vit_trade_flutter/features/cross_module/domain/entities/smart_alerts_entities.dart';

abstract interface class SmartAlertsRepository {
  SmartAlertsSnapshot getCenter();
}
