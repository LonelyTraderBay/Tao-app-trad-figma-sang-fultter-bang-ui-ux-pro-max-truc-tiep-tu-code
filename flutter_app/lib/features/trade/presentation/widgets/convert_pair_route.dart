import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

String? resolveConvertSpotPairId({
  required String fromSymbol,
  required String toSymbol,
  required List<TradePair> knownPairs,
}) {
  for (final pair in knownPairs) {
    final matches =
        (pair.quoteAsset == fromSymbol && pair.baseAsset == toSymbol) ||
        (pair.quoteAsset == toSymbol && pair.baseAsset == fromSymbol);
    if (matches) return pair.id;
  }
  return null;
}
