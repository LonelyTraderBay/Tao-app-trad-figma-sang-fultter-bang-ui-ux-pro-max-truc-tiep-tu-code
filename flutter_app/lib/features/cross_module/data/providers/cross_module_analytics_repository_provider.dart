import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/cross_module_analytics_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/fail_closed_cross_module_analytics_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_cross_module_analytics_repository.dart';

final crossModuleAnalyticsRepositoryProvider =
    Provider<CrossModuleAnalyticsRepository>((ref) {
      return guardedRepository(
        ref,
        featureName: 'CrossModuleAnalytics',
        mock: () => const MockCrossModuleAnalyticsRepository(),
        failClosed: () => const FailClosedCrossModuleAnalyticsRepository(),
      );
    });
