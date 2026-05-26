import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/data/repositories/mock_launchpad_repository.dart';

final launchpadRepositoryProvider = Provider<LaunchpadRepository>((ref) {
  return const MockLaunchpadRepository();
});
