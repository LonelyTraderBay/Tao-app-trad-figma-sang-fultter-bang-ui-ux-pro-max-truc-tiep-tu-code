import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/repositories/mock_p2p_repository.dart';

import 'package:vit_trade_flutter/features/p2p_core/data/repositories/fail_closed_p2p_repository.dart';

final p2pRepositoryProvider = Provider<P2PRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'P2P',
    mock: () => const MockP2PRepository(),
    failClosed: () => const FailClosedP2PRepository(),
  ),
);

final p2pMarketplaceRepositoryProvider = Provider<P2PMarketplaceRepository>(
  (ref) => ref.watch(p2pRepositoryProvider),
);

final p2pOrdersRepositoryProvider = Provider<P2POrdersRepository>(
  (ref) => ref.watch(p2pRepositoryProvider),
);

final p2pAccountRepositoryProvider = Provider<P2PAccountRepository>(
  (ref) => ref.watch(p2pRepositoryProvider),
);

final p2pTrustRepositoryProvider = Provider<P2PTrustRepository>(
  (ref) => ref.watch(p2pRepositoryProvider),
);
