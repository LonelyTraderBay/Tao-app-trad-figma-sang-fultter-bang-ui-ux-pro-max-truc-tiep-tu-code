import 'package:vit_trade_flutter/features/home/domain/entities/home_errors.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';

final class FailClosedHomeRepository implements HomeRepository {
  const FailClosedHomeRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const HomeBackendContractMissingException();
  }
}
