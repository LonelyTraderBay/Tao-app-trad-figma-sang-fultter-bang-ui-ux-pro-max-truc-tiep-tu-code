import 'package:vit_trade_flutter/features/earn/domain/entities/earn_errors.dart';

T failClosedEarnRepository<T>() {
  throw const EarnBackendContractMissingException();
}
