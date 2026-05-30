import 'package:vit_trade_flutter/features/arena/domain/entities/arena_errors.dart';
import 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';

final class FailClosedArenaRepository implements ArenaRepository {
  const FailClosedArenaRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const ArenaBackendContractMissingException();
  }
}
