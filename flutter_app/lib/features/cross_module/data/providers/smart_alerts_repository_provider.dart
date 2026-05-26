import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/smart_alerts_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_smart_alerts_repository.dart';

final smartAlertsRepositoryProvider = Provider<SmartAlertsRepository>((ref) {
  return const MockSmartAlertsRepository();
});
