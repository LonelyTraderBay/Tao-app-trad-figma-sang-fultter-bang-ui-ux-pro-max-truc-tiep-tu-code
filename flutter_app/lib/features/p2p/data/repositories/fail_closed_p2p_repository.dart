import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_errors.dart';
import 'package:vit_trade_flutter/features/p2p/domain/repositories/p2p_repository.dart';

final class FailClosedP2PRepository implements P2PRepository {
  const FailClosedP2PRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const P2PBackendContractMissingException();
  }
}
