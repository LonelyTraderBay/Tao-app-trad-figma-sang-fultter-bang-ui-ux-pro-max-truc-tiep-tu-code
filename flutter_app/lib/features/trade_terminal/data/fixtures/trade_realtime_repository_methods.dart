part of '../repositories/mock_trade_terminal_repository.dart';

/// GD4 Cụm F7 (REALTIME): `watchCandles` của [SpotTradeRepository] — tick
/// phát qua `Stream.periodic` với công thức DETERMINISTIC dựa trên chỉ số
/// tick (KHÔNG `Random`/`DateTime.now`), cập nhật nến CUỐI CÙNG của
/// [getAdvancedChart] mỗi tick để mô phỏng nến đang hình thành.
mixin _MockTradeTerminalRepositoryRealtimeMethods
    on _MockTradeTerminalRepositoryBase {
  @override
  Stream<TradeAdvancedChartSnapshot> watchCandles(
    String pairId, {
    String timeframe = '1h',
  }) {
    // CỐ Ý KHÔNG dùng `async*`/`await for` lồng `Stream.periodic` bên
    // trong: khi subscriber huỷ đăng ký (autoDispose khi rời trang biểu
    // đồ), cancel không lan truyền đồng bộ xuống tới stream định kỳ lồng
    // bên trong qua generator `async*` trong môi trường FakeAsync của
    // widget test — để lại `Timer.periodic` "mồ côi" (test framework báo
    // lỗi `!timersPending`: "A Timer is still pending even after the
    // widget tree was disposed", dù không có gì watch stream nữa). Ghép
    // bằng `Future.asStream().asyncExpand()` thay vì generator để
    // `StreamSubscription.cancel()` huỷ đúng cascade (Future đơn ->
    // stream định kỳ) đồng bộ như `watchTicker`/`watchDepth`.
    //
    // `_simulateNetwork()` chỉ chạy MỘT lần (qua `getAdvancedChart` — bẫy
    // playbook §9.18: "mock gọi chuỗi mock khác thì bỏ _simulateNetwork()
    // ở lớp ngoài"); nếu `simulateError` bật, Future này reject và
    // `asyncExpand` tự chuyển thành lỗi trên stream (fail-closed, không
    // cần catch thủ công).
    return getAdvancedChart(pairId: pairId).asStream().asyncExpand((base) {
      return Stream<int>.periodic(
        tickInterval,
        (tick) => tick,
      ).map((tick) => _candleSnapshotAtTick(base, tick, timeframe));
    });
  }
}

/// Bảng delta % cố định cho nến realtime — áp cho `close` của nến CUỐI
/// CÙNG trong `candles` mỗi tick (mô phỏng nến đang hình thành), tính LẠI
/// từ giá đóng cửa GỐC mỗi lần (không dồn tích qua tick — dao động quanh
/// mốc, không trôi dạt vĩnh viễn — cùng công thức "oscillate around base"
/// với `watchTicker`/`watchDepth` của markets).
const List<double> _candleDeltaPct = [0.08, -0.05, 0.10, -0.07];

/// Biên độ dao động theo khung thời gian đang chọn trên UI — timeframe dài
/// hơn dao động mạnh hơn một chút. KHÔNG đổi TẬP nến trả về (khớp
/// `getAdvancedChart` vốn cũng không nhận timeframe — xem dartdoc
/// `SpotTradeRepository.watchCandles`).
double _candleTimeframeMagnitude(String timeframe) {
  switch (timeframe) {
    case '1m':
      return 0.4;
    case '5m':
      return 0.6;
    case '15m':
      return 0.8;
    case '4h':
      return 1.4;
    case '1D':
      return 2.0;
    case '1W':
      return 2.6;
    case '1h':
    default:
      return 1.0;
  }
}

TradeAdvancedChartSnapshot _candleSnapshotAtTick(
  TradeAdvancedChartSnapshot base,
  int tick,
  String timeframe,
) {
  if (base.candles.isEmpty) return base;
  final magnitude = _candleTimeframeMagnitude(timeframe);
  final deltaPct = _candleDeltaPct[tick % _candleDeltaPct.length] * magnitude;
  final lastIndex = base.candles.length - 1;
  final lastCandle = base.candles[lastIndex];
  final newClose = lastCandle.close * (1 + deltaPct / 100);
  final updatedCandle = TradeCandle(
    time: lastCandle.time,
    open: lastCandle.open,
    high: newClose > lastCandle.high ? newClose : lastCandle.high,
    low: newClose < lastCandle.low ? newClose : lastCandle.low,
    close: newClose,
    volume: lastCandle.volume,
  );
  final updatedCandles = List<TradeCandle>.of(base.candles);
  updatedCandles[lastIndex] = updatedCandle;

  return TradeAdvancedChartSnapshot(
    trade: base.trade,
    pair: base.pair,
    candles: updatedCandles,
    indicators: base.indicators,
    timeframes: base.timeframes,
    chartTypes: base.chartTypes,
    ohlcv: base.ohlcv,
    supportedStates: base.supportedStates,
    lastUpdatedLabel: 'realtime',
  );
}
