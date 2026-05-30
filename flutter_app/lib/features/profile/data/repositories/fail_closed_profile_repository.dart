import 'package:vit_trade_flutter/features/profile/domain/entities/profile_errors.dart';
import 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';

final class FailClosedProfileRepository implements ProfileRepository {
  const FailClosedProfileRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const ProfileBackendContractMissingException();
  }
}
