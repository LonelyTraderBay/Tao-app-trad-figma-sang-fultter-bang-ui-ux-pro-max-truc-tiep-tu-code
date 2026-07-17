import 'package:vit_trade_flutter/features/cross_module/domain/entities/cross_module_analytics_errors.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/cross_module_analytics_repository.dart';

final class FailClosedCrossModuleAnalyticsRepository
    implements CrossModuleAnalyticsRepository {
  const FailClosedCrossModuleAnalyticsRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const CrossModuleAnalyticsBackendContractMissingException();
  }
}
