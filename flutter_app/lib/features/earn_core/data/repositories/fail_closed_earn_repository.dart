import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_errors.dart';

T failClosedEarnRepository<T>() {
  throw const EarnBackendContractMissingException();
}
