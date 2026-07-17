import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/fail_closed_market_repository.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'Markets',
    mock: () => const MockMarketRepository(),
    failClosed: () => const FailClosedMarketRepository(),
  );
});
