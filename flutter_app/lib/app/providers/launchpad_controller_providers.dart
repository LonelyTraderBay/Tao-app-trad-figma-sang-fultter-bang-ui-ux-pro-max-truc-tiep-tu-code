import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/launchpad/data/providers/launchpad_repository_provider.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/controllers/launchpad_controller.dart';

export 'package:vit_trade_flutter/features/launchpad/presentation/controllers/launchpad_controller.dart';

final launchpadControllerProvider = Provider<LaunchpadController>((ref) {
  return LaunchpadController(ref.watch(launchpadRepositoryProvider));
});
