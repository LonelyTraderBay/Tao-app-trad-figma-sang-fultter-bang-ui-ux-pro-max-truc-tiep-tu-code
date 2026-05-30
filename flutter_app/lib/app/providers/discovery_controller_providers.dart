import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/discovery/data/providers/discovery_repository_provider.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/controllers/discovery_controller.dart';

export 'package:vit_trade_flutter/features/discovery/presentation/controllers/discovery_controller.dart';

final discoveryControllerProvider = Provider<DiscoveryController>((ref) {
  return DiscoveryController(ref.watch(discoveryRepositoryProvider));
});
