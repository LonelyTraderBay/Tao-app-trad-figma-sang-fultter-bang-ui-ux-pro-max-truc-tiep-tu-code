// GD4 Cụm F7 (REALTIME): unit test cho `watchCandles` của
// [MockTradeTerminalRepository]. Giá trị kỳ vọng TÍNH TAY từ công thức
// deterministic (bảng delta % cố định áp lên `close` của nến CUỐI CÙNG
// trong `_advancedChartCandles`, xem
// `trade_realtime_repository_methods.dart`):
//
//   newClose(tick) = lastCandle.close * (1 + deltaPct[tick % 4] / 100 * magnitude)
//
// Nến cuối gốc (time '09:00', khung 09:00-24h sau): open 64370, high
// 64475.28, low 64185.74, close 64268.03. deltaPct = [0.08, -0.05, 0.10,
// -0.07]; magnitude('1h') = 1.0.
//   tick0: 64268.03 * 1.0008  -> 64319.44
//   tick1: 64268.03 * 0.9995  -> 64235.90
//   tick2: 64268.03 * 1.0010  -> 64332.30
//   tick3: 64268.03 * 0.9993  -> 64223.04
// magnitude('4h') = 1.4 -> tick0 delta hiệu dụng 0.112%:
//   64268.03 * 1.00112 -> 64340.01
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';

void main() {
  group('MockTradeTerminalRepository.watchCandles', () {
    test(
      'emits deterministic last-candle close ticks (hand-computed)',
      () async {
        final repo = const MockTradeTerminalRepository(
          loadDelay: Duration.zero,
          tickInterval: Duration(milliseconds: 1),
        );

        await expectLater(
          repo.watchCandles('btcusdt'),
          emitsInOrder([
            predicate<TradeAdvancedChartSnapshot>(
              (s) => _closeTo(s.candles.last.close, 64319.44, 0.01),
              'tick0: last close ~64319.44',
            ),
            predicate<TradeAdvancedChartSnapshot>(
              (s) => _closeTo(s.candles.last.close, 64235.90, 0.01),
              'tick1: last close ~64235.90',
            ),
            predicate<TradeAdvancedChartSnapshot>(
              (s) => _closeTo(s.candles.last.close, 64332.30, 0.01),
              'tick2: last close ~64332.30',
            ),
            predicate<TradeAdvancedChartSnapshot>(
              (s) => _closeTo(s.candles.last.close, 64223.04, 0.01),
              'tick3: last close ~64223.04',
            ),
          ]),
        );
      },
    );

    test('only the last candle changes; earlier candles + open/time/volume '
        'are untouched', () async {
      final repo = const MockTradeTerminalRepository(
        loadDelay: Duration.zero,
        tickInterval: Duration(milliseconds: 1),
      );

      final base = await repo.getAdvancedChart(pairId: 'btcusdt');
      final tick0 = await repo.watchCandles('btcusdt').first;

      expect(tick0.candles.length, base.candles.length);
      expect(
        tick0.candles.sublist(0, tick0.candles.length - 1),
        base.candles.sublist(0, base.candles.length - 1),
      );
      final lastBase = base.candles.last;
      final lastLive = tick0.candles.last;
      expect(lastLive.time, lastBase.time);
      expect(lastLive.open, lastBase.open);
      expect(lastLive.volume, lastBase.volume);
      expect(lastLive.close, isNot(lastBase.close));
    });

    test('timeframe scales the oscillation magnitude', () async {
      final repo = const MockTradeTerminalRepository(
        loadDelay: Duration.zero,
        tickInterval: Duration(milliseconds: 1),
      );

      final snapshot = await repo
          .watchCandles('btcusdt', timeframe: '4h')
          .first;
      expect(_closeTo(snapshot.candles.last.close, 64340.01, 0.01), isTrue);
    });

    test('simulateError fails the stream (fail-closed)', () async {
      final repo = const MockTradeTerminalRepository(
        loadDelay: Duration.zero,
        tickInterval: Duration(milliseconds: 1),
        simulateError: true,
      );

      await expectLater(repo.watchCandles('btcusdt'), emitsError(isStateError));
    });
  });
}

bool _closeTo(double actual, double expected, double tolerance) {
  return (actual - expected).abs() <= tolerance;
}
