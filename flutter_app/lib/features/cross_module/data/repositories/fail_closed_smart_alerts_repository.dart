import 'package:vit_trade_flutter/features/cross_module/domain/entities/smart_alerts_errors.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/smart_alerts_repository.dart';

final class FailClosedSmartAlertsRepository implements SmartAlertsRepository {
  const FailClosedSmartAlertsRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const SmartAlertsBackendContractMissingException();
  }
}
