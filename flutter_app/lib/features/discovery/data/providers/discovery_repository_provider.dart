import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:vit_trade_flutter/features/discovery/data/repositories/fail_closed_discovery_repository.dart';
import 'package:vit_trade_flutter/features/discovery/data/repositories/mock_discovery_repository.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'Discovery',
    mock: () => const MockDiscoveryRepository(),
    failClosed: () => const FailClosedDiscoveryRepository(),
  );
});
