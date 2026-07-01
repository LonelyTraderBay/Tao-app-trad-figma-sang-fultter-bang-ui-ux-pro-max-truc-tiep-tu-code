import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/convert_pair_route.dart';

void main() {
  const knownPairs = [
    TradePair(
      id: 'btcusdt',
      symbol: 'BTC/USDT',
      baseAsset: 'BTC',
      quoteAsset: 'USDT',
      price: 67543.21,
      changePct: 1.2,
      logoColorHex: 0xFFF7931A,
    ),
    TradePair(
      id: 'ethusdt',
      symbol: 'ETH/USDT',
      baseAsset: 'ETH',
      quoteAsset: 'USDT',
      price: 3521.45,
      changePct: 0.8,
      logoColorHex: 0xFF627EEA,
    ),
    TradePair(
      id: 'solusdt',
      symbol: 'SOL/USDT',
      baseAsset: 'SOL',
      quoteAsset: 'USDT',
      price: 178.32,
      changePct: 2.1,
      logoColorHex: 0xFF14F195,
    ),
  ];

  group('resolveConvertSpotPairId', () {
    test('USDT/BTC resolves to btcusdt', () {
      expect(
        resolveConvertSpotPairId(
          fromSymbol: 'USDT',
          toSymbol: 'BTC',
          knownPairs: knownPairs,
        ),
        'btcusdt',
      );
    });

    test('USDT/ETH resolves to ethusdt', () {
      expect(
        resolveConvertSpotPairId(
          fromSymbol: 'USDT',
          toSymbol: 'ETH',
          knownPairs: knownPairs,
        ),
        'ethusdt',
      );
    });

    test('BTC/ETH returns null when no spot pair exists', () {
      expect(
        resolveConvertSpotPairId(
          fromSymbol: 'BTC',
          toSymbol: 'ETH',
          knownPairs: knownPairs,
        ),
        isNull,
      );
    });
  });
}
