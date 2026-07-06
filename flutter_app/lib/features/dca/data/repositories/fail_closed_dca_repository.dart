import 'package:vit_trade_flutter/features/dca/domain/entities/dca_errors.dart';
import 'package:vit_trade_flutter/features/dca/domain/repositories/dca_repository.dart';

final class FailClosedDcaRepository implements DcaRepository {
  const FailClosedDcaRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const DcaBackendContractMissingException();
  }
}
