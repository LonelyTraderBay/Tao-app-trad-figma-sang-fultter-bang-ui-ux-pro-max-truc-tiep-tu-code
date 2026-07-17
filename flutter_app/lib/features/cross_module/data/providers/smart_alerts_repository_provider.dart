import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/smart_alerts_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/fail_closed_smart_alerts_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_smart_alerts_repository.dart';

final smartAlertsRepositoryProvider = Provider<SmartAlertsRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'SmartAlerts',
    mock: () => const MockSmartAlertsRepository(),
    failClosed: () => const FailClosedSmartAlertsRepository(),
  );
});
