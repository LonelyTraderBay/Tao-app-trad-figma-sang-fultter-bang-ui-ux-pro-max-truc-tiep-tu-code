import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';

export 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';

final marketControllerProvider = Provider<MarketController>((ref) {
  return MarketController(ref.watch(marketRepositoryProvider));
});
