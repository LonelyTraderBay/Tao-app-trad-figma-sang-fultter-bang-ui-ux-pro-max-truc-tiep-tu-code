import 'package:vit_trade_flutter/features/discovery/domain/entities/discovery_errors.dart';
import 'package:vit_trade_flutter/features/discovery/domain/repositories/discovery_repository.dart';

final class FailClosedDiscoveryRepository implements DiscoveryRepository {
  const FailClosedDiscoveryRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const DiscoveryBackendContractMissingException();
  }
}
