// Origin: a7cadd94 (2026-07-18) - feat(gd4-f7): realtime — 3 Stream surface loi (ticker/depth/candles) + no-polling guardrail + ADR-009
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

/// GD4 Cụm F7 (REALTIME) tick-rebuild benchmark — khuôn
/// `trade_order_form_rebuild_harness_test.dart` (ProviderObserver đếm
/// didAddProvider/didUpdateProvider), áp cho `marketPairLivePriceProvider`
/// thay vì đếm rebuild toàn danh sách.
///
/// Thiết lập: 10 "hàng" (khớp 10 pair trong `_marketPairs` fixture) mỗi
/// hàng `container.listen(marketPairLivePriceProvider(id), ..., fireImmediately: true)`
/// — mô phỏng 10 `_MarketPairRow` đang hiển thị cùng lúc, mỗi hàng chỉ
/// `.select()` giá của CHÍNH pair đó (xem `_MarketPairRow` +
/// `marketPairLivePriceProvider` trong `market_list_pairs.dart` /
/// `market_controller_providers.dart`).
///
/// Công thức `watchTicker` (mock_market_realtime_methods.dart): mỗi tick
/// chỉ MỘT pair kích hoạt (`tick % pairCount`), nên TỪ TICK THỨ 2 trở đi,
/// mỗi tick chỉ tạo đúng 1 didUpdateProvider trên toàn bộ family (không
/// phải 10 — kịch bản nếu `.select()` bị gỡ và mỗi hàng rebuild theo TOÀN
/// BỘ list mỗi tick). Tick ĐẦU TIÊN là ngoại lệ: mọi pair đi từ "chưa có
/// dữ liệu sống" (`null`) sang có giá lần đầu, nên cả 10 hàng cùng đổi một
/// lần duy nhất đó — xem giải thích đầy đủ tại chỗ tính `expectedChurn`.
base class _CountingObserver extends ProviderObserver {
  int addCount = 0;
  int updateCount = 0;

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (identical(context.provider.from, marketPairLivePriceProvider)) {
      addCount += 1;
    }
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (identical(context.provider.from, marketPairLivePriceProvider)) {
      updateCount += 1;
    }
  }
}

const _pairIds = [
  'btcusdt',
  'ethusdt',
  'bnbusdt',
  'solusdt',
  'xrpusdt',
  'adausdt',
  'dotusdt',
  'maticusdt',
  'avaxusdt',
  'linkusdt',
];

void main() {
  test('marketPairLivePriceProvider only updates the 1 pair activated per tick '
      '(select-based row isolation), not all 10 rows', () async {
    final observer = _CountingObserver();
    final controller = StreamController<List<MarketPair>>();
    addTearDown(controller.close);

    final container = ProviderContainer(
      observers: [observer],
      overrides: [
        marketTickerStreamProvider.overrideWith((ref) => controller.stream),
      ],
    );
    addTearDown(container.dispose);

    // Mô phỏng 10 hàng đang mount cùng lúc, mỗi hàng chỉ watch giá của
    // chính pairId của nó.
    final subscriptions = [
      for (final id in _pairIds)
        container.listen(
          marketPairLivePriceProvider(id),
          (previous, next) {},
          fireImmediately: true,
        ),
    ];
    addTearDown(() {
      for (final sub in subscriptions) {
        sub.close();
      }
    });

    // Baseline: 10 lần khởi tạo family member (fireImmediately) không
    // phải churn do tick — loại khỏi phép đo giống khuôn
    // trade_order_form_rebuild_harness_test.dart.
    expect(observer.addCount, 10);
    final baselineUpdates = observer.updateCount;

    // Phát 15 tick giả lập (1.5 vòng qua 10 pair) — công thức mock
    // `watchTicker` áp DELTA MỚI mỗi lần một pair được kích hoạt lại nên
    // mỗi tick luôn tạo ra một giá trị THỰC SỰ khác (xem
    // mock_market_repository_realtime_test.dart để verify công thức).
    const tickCount = 15;
    for (var tick = 0; tick < tickCount; tick += 1) {
      controller.add(_tickerPairsAtTick(tick));
      // Cho phép StreamController's microtask event tự flush trước khi
      // đếm — ProviderContainer không có `tester.pump()` để đẩy zone.
      await Future<void>.delayed(Duration.zero);
    }

    final churn = observer.updateCount - baselineUpdates;

    // Đo thực tế: tick0 luôn đổi CẢ 10 pair (mọi giá trị `.select()` đi từ
    // `null` — chưa có tick nào — sang giá trị thật lần đầu tiên, kể cả 9
    // pair "chưa kích hoạt" vẫn chuyển từ null -> giá gốc); mỗi tick SAU
    // đó (1..tickCount-1) chỉ đúng 1 pair đổi giá thật (công thức mock đảm
    // bảo giá trị mới luôn khác giá cũ — xem
    // mock_market_repository_realtime_test.dart). Tổng = 10 + (tickCount -
    // 1) = 24 cho tickCount=15. Ghim ngưỡng +2 đệm nhỏ (giống khuôn
    // PERF-HN2) để chịu sai khác nhỏ nhưng vẫn bắt hồi quy thật: nếu
    // `.select()` bị gỡ, MỌI tick sẽ đụng cả 10 hàng -> churn tiệm cận
    // tickCount * 10 = 150, vượt xa ngưỡng trên.
    final expectedChurn = 10 + (tickCount - 1);
    expect(
      churn,
      inInclusiveRange(expectedChurn, expectedChurn + 2),
      reason:
          'marketPairLivePriceProvider cập nhật quá nhiều/quá ít lần cho '
          '$tickCount tick — nghi ngờ hồi quy select-based row isolation '
          '(tick đầu đổi cả 10 hàng khi bắt đầu có dữ liệu sống, mỗi tick '
          'sau đó chỉ được đổi đúng 1 hàng).',
    );
  });
}

/// Bản sao THUẦN của công thức trong `mock_market_realtime_methods.dart`
/// (không import file `part of` được — dựng lại công thức tối thiểu ở đây
/// chỉ để lái `StreamController` trong benchmark, KHÔNG phải nguồn sự thật
/// thứ hai: `mock_market_repository_realtime_test.dart` đã pin công thức
/// thật bằng giá trị tính tay).
const List<double> _tickerDeltaPct = [
  0.12,
  -0.18,
  0.24,
  -0.09,
  0.15,
  -0.21,
  0.06,
  -0.14,
];

const List<double> _basePrices = [
  67543.21,
  3521.45,
  412.87,
  178.32,
  0.6234,
  0.4521,
  7.832,
  0.8976,
  38.54,
  14.23,
];

int _lastActivation(int pairIndex, int tick, int pairCount) {
  if (tick < pairIndex) return -1;
  return pairIndex + pairCount * ((tick - pairIndex) ~/ pairCount);
}

List<MarketPair> _tickerPairsAtTick(int tick) {
  return [
    for (var index = 0; index < _pairIds.length; index += 1)
      _fakePair(index, tick),
  ];
}

MarketPair _fakePair(int index, int tick) {
  final basePrice = _basePrices[index];
  final activation = _lastActivation(index, tick, _pairIds.length);
  final price = activation < 0
      ? basePrice
      : basePrice *
            (1 + _tickerDeltaPct[activation % _tickerDeltaPct.length] / 100);
  return MarketPair(
    id: _pairIds[index],
    symbol: _pairIds[index],
    baseAsset: _pairIds[index],
    quoteAsset: 'USDT',
    price: price,
    prevPrice: basePrice,
    change24h: 0,
    high24h: basePrice,
    low24h: basePrice,
    volume24h: 0,
    marketCap: 0,
    sparklineData: const [],
    isFavorite: false,
    category: 'Layer 1',
  );
}
