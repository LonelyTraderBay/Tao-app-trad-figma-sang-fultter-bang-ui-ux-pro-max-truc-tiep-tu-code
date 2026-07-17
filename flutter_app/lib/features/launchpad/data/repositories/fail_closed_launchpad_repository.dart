import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_errors.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';

final class FailClosedLaunchpadRepository implements LaunchpadRepository {
  const FailClosedLaunchpadRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const LaunchpadBackendContractMissingException();
  }
}
