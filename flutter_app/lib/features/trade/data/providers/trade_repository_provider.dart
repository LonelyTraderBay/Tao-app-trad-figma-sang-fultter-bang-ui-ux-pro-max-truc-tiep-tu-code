import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/data/repositories/mock_trade_repository.dart';

import '../repositories/fail_closed_trade_repository.dart';

final tradeRepositoryProvider = Provider<TradeRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Trade',
    mock: () => const MockTradeRepository(),
    failClosed: () => const FailClosedTradeRepository(),
  ),
);
