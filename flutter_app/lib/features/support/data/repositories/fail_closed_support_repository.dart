import 'package:vit_trade_flutter/features/support/domain/entities/support_errors.dart';
import 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';

final class FailClosedSupportRepository implements SupportRepository {
  const FailClosedSupportRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const SupportBackendContractMissingException();
  }
}
