import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/p2p/domain/repositories/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p/data/repositories/mock_p2p_repository.dart';

final p2pRepositoryProvider = Provider<P2PRepository>(
  (_) => const MockP2PRepository(),
);
