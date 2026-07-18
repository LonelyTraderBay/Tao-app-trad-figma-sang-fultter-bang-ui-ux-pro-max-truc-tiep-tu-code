import 'package:vit_trade_flutter/core/utils/accent_tone.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

part '../fixtures/mock_market_shared_fixtures.dart';
part '../fixtures/mock_market_overview_methods.dart';
part '../fixtures/mock_market_screening_methods.dart';
part '../fixtures/mock_market_calendar_derivatives_methods.dart';
part '../fixtures/mock_market_social_sentiment_methods.dart';
part '../fixtures/mock_market_portfolio_news_methods.dart';
part '../fixtures/mock_market_token_detail_methods.dart';
part '../fixtures/mock_market_realtime_methods.dart';

abstract class _MockMarketRepositoryBase implements MarketRepository {
  const _MockMarketRepositoryBase({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
    this.tickInterval = const Duration(seconds: 30),
  });

  /// When `true`, every method throws a [StateError] after [loadDelay] —
  /// used to exercise error/retry UI states in tests.
  final bool simulateError;

  /// Simulated network latency before a method resolves. Tests should pass
  /// [Duration.zero] to avoid slowing down the suite.
  final Duration loadDelay;

  /// GD4 Cụm F7 (REALTIME): khoảng cách giữa 2 tick của `watchTicker`/
  /// `watchDepth` (`Stream.periodic`). Test truyền một giá trị nhỏ hơn khi
  /// cần quan sát nhiều tick nhanh (khuôn `tickInterval: Duration(milliseconds: 1)`
  /// trong `mock_market_repository_realtime_test.dart`).
  ///
  /// Mặc định 30s (KHÔNG phải 800ms như ví dụ minh hoạ ban đầu trong task
  /// spec) — đo thực tế: một số widget test hiện có gọi `pumpAndSettle()`
  /// NHIỀU LẦN trong CÙNG một test (ví dụ mở/đóng sheet chỉ báo rồi thao
  /// tác tiếp — `advanced_chart_painter_test.dart`), cộng dồn đủ virtual
  /// time vượt qua mốc 800ms khiến tick thật sự bắn giữa chừng, làm sai
  /// lệch các test "unrelated rebuild -> không repaint" (PERF-HN5). 30s
  /// đảm bảo an toàn cho MỌI test hiện có (không test nào cộng dồn quá vài
  /// giây virtual time) trong khi vẫn để lớp cập-nhật-đè hoạt động thật
  /// trong ứng dụng chạy thật.
  final Duration tickInterval;

  /// Shared network simulation for every mock method: awaits [loadDelay],
  /// then throws when [simulateError] is set. Khuôn MockHomeRepository.
  /// Sống ở base class (không phải mixin) vì 6 mixin method đều cần gọi nó
  /// và Dart mixin không thấy method của mixin anh em cùng "on" constraint.
  ///
  /// Delay 0 thì KHÔNG tạo timer — Future.delayed(Duration.zero) vẫn là
  /// timer và tester.pump() không-duration không đẩy fake clock (xem
  /// GD4-Async-Playbook §9, bẫy 10).
  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) {
      throw StateError('markets_mock_fetch_failed');
    }
  }
}

final class MockMarketRepository extends _MockMarketRepositoryBase
    with
        _MockMarketRepositoryOverviewMethods,
        _MockMarketRepositoryScreeningMethods,
        _MockMarketRepositoryCalendarDerivativesMethods,
        _MockMarketRepositorySocialSentimentMethods,
        _MockMarketRepositoryPortfolioNewsMethods,
        _MockMarketRepositoryTokenDetailMethods,
        _MockMarketRepositoryRealtimeMethods {
  const MockMarketRepository({
    super.simulateError,
    super.loadDelay,
    super.tickInterval,
  });
}
