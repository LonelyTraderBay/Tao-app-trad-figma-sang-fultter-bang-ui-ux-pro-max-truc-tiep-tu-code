// GD4 Cụm F7 (REALTIME): unit test cho 2 method Stream của
// [MockMarketRepository] — `watchTicker`/`watchDepth`. Giá trị kỳ vọng ở
// 4 tick đầu TÍNH TAY từ công thức deterministic (bảng delta % cố định áp
// lên giá fixture gốc trong `mock_market_shared_fixtures.dart`), khớp
// dartdoc trong `mock_market_realtime_methods.dart`:
//
//   price(tick) = basePrice * (1 + deltaPct[tick % length] / 100)
//
// watchTicker(): mỗi tick chỉ MỘT pair (theo `tick % pairCount`, pairCount
// = 10) kích hoạt; deltaPct = [0.12, -0.18, 0.24, -0.09, ...][tick % 8].
//   tick0 (BTC, base 67543.21, delta 0.12%)  -> 67543.21 * 1.0012
//   tick1 (ETH, base 3521.45,  delta -0.18%) -> 3521.45  * 0.9982
//   tick2 (BNB, base 412.87,   delta 0.24%)  -> 412.87   * 1.0024
//   tick3 (SOL, base 178.32,   delta -0.09%) -> 178.32   * 0.9991
// Pair chưa kích hoạt giữ nguyên giá fixture gốc; pair đã kích hoạt GIỮ
// NGUYÊN giá của lần kích hoạt gần nhất ở các tick sau (không trôi dạt).
//
// watchDepth('btcusdt'): mid-price dao động quanh giá fixture gốc (không
// dồn tích), deltaPct = [0.05, -0.08, 0.03, -0.04][tick % 4]:
//   tick0: 67543.21 * 1.0005
//   tick1: 67543.21 * 0.9992
//   tick2: 67543.21 * 1.0003
//   tick3: 67543.21 * 0.9996
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';

void main() {
  group('MockMarketRepository.watchTicker', () {
    test(
      'emits deterministic price ticks (hand-computed, 4 first ticks)',
      () async {
        final repo = const MockMarketRepository(
          loadDelay: Duration.zero,
          tickInterval: Duration(milliseconds: 1),
        );

        await expectLater(
          repo.watchTicker(),
          emitsInOrder([
            predicate<List<MarketPair>>((pairs) {
              final btc = pairs.firstWhere((p) => p.id == 'btcusdt');
              final eth = pairs.firstWhere((p) => p.id == 'ethusdt');
              return _closeTo(btc.price, 67624.26, 0.01) &&
                  _closeTo(eth.price, 3521.45, 0.001); // ETH chưa kích hoạt
            }, 'tick0: BTC ~67624.26, ETH vẫn giá gốc'),
            predicate<List<MarketPair>>((pairs) {
              final btc = pairs.firstWhere((p) => p.id == 'btcusdt');
              final eth = pairs.firstWhere((p) => p.id == 'ethusdt');
              return _closeTo(btc.price, 67624.26, 0.01) && // BTC không đổi
                  _closeTo(eth.price, 3515.11, 0.01);
            }, 'tick1: BTC không đổi, ETH ~3515.11'),
            predicate<List<MarketPair>>((pairs) {
              final bnb = pairs.firstWhere((p) => p.id == 'bnbusdt');
              return _closeTo(bnb.price, 413.86, 0.01);
            }, 'tick2: BNB ~413.86'),
            predicate<List<MarketPair>>((pairs) {
              final sol = pairs.firstWhere((p) => p.id == 'solusdt');
              return _closeTo(sol.price, 178.16, 0.01);
            }, 'tick3: SOL ~178.16'),
          ]),
        );
      },
    );

    test('only the newly-activated pair changes price between ticks', () async {
      final repo = const MockMarketRepository(
        loadDelay: Duration.zero,
        tickInterval: Duration(milliseconds: 1),
      );

      final ticks = await repo.watchTicker().take(3).toList();
      final tick0Prices = {for (final p in ticks[0]) p.id: p.price};
      final tick1Prices = {for (final p in ticks[1]) p.id: p.price};

      // Ở tick1 chỉ 'ethusdt' (pair vừa kích hoạt) đổi giá so với tick0 —
      // mọi pair khác (kể cả 'btcusdt' đã kích hoạt ở tick0) giữ nguyên.
      final changed = tick0Prices.keys.where(
        (id) => tick0Prices[id] != tick1Prices[id],
      );
      expect(changed, ['ethusdt']);
    });
  });

  group('MockMarketRepository.watchDepth', () {
    test('emits deterministic mid-price ticks (hand-computed)', () async {
      final repo = const MockMarketRepository(
        loadDelay: Duration.zero,
        tickInterval: Duration(milliseconds: 1),
      );

      await expectLater(
        repo.watchDepth('btcusdt'),
        emitsInOrder([
          predicate<MarketDepthSnapshot>(
            (s) =>
                s.pair.id == 'btcusdt' &&
                _closeTo(s.depth.midPrice, 67576.98, 0.01),
            'tick0: mid ~67576.98',
          ),
          predicate<MarketDepthSnapshot>(
            (s) => _closeTo(s.depth.midPrice, 67489.18, 0.01),
            'tick1: mid ~67489.18',
          ),
          predicate<MarketDepthSnapshot>(
            (s) => _closeTo(s.depth.midPrice, 67563.47, 0.01),
            'tick2: mid ~67563.47',
          ),
          predicate<MarketDepthSnapshot>(
            (s) => _closeTo(s.depth.midPrice, 67516.19, 0.01),
            'tick3: mid ~67516.19',
          ),
        ]),
      );
    });

    test('honours the requested levels count', () async {
      final repo = const MockMarketRepository(
        loadDelay: Duration.zero,
        tickInterval: Duration(milliseconds: 1),
      );

      final snapshot = await repo.watchDepth('ethusdt', levels: 15).first;
      expect(snapshot.pair.id, 'ethusdt');
      expect(snapshot.depth.bids, hasLength(15));
      expect(snapshot.depth.asks, hasLength(15));
    });
  });
}

bool _closeTo(double actual, double expected, double tolerance) {
  return (actual - expected).abs() <= tolerance;
}
