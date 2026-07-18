import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_bots/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/controllers/trade_bots_controller_models.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';

export 'package:vit_trade_flutter/features/trade_bots/data/providers/trade_repository_provider.dart';

// Trading-bots domain controller providers (trade_bots extraction, Batch 1
// of Phase 3 of the trade module split; controllers wired in Batch 4).
// Re-exports [tradingBotsRepositoryProvider] and
// [tradeBotAnalyticsRepositoryProvider] above so other `app/providers/*`
// files depend on this app-layer facade instead of reaching into
// `features/trade_bots/data/` directly. Batch 4 moved every bot-specific
// controller provider out of `trade_controller_providers.dart` into this
// file, rewiring each from the old cross-domain union
// `tradeRepositoryProvider` to the narrow `tradingBotsRepositoryProvider`,
// mirroring the trade_copy Batch 4 pattern.
//
// GD4-F3: every READ (get*) method on [TradingBotsRepository]/
// [TradeBotAnalyticsRepository] is now `Future<T>` (ADR-001 read idiom —
// see docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md).
// Write/mutation methods (submit*/patch*/create*/run*) stay synchronous
// (ADR-001's "đường ghi phụ vẫn đồng bộ — migrate dần khi chạm tới"), so
// every "raw read" provider below is a plain FutureProvider forwarding the
// repository call, while the write call-sites inside the controllers below
// are unchanged.

final tradingBotsSnapshotProvider = FutureProvider<TradeBotsSnapshot>(
  (ref) => ref.watch(tradingBotsRepositoryProvider).getTradingBots(),
);

final tradeBotTermsOfServiceProvider = FutureProvider<TradeBotTermsSnapshot>(
  (ref) => ref.watch(tradingBotsRepositoryProvider).getBotTermsOfService(),
);

final tradeBotRiskDisclosureProvider =
    FutureProvider<TradeBotRiskDisclosureSnapshot>(
      (ref) => ref.watch(tradingBotsRepositoryProvider).getBotRiskDisclosure(),
    );

final tradeBotSuitabilityAssessmentSnapshotProvider =
    FutureProvider<TradeBotSuitabilityAssessmentSnapshot>(
      (ref) => ref
          .watch(tradingBotsRepositoryProvider)
          .getBotSuitabilityAssessment(),
    );

final tradeBotRiskDashboardProvider =
    FutureProvider<TradeBotRiskDashboardSnapshot>(
      (ref) => ref.watch(tradingBotsRepositoryProvider).getBotRiskDashboard(),
    );

final tradeBotEmergencyStopSnapshotProvider =
    FutureProvider<TradeBotEmergencyStopSnapshot>(
      (ref) => ref.watch(tradingBotsRepositoryProvider).getBotEmergencyStop(),
    );

final tradeBotSecuritySettingsSnapshotProvider =
    FutureProvider<TradeBotSecuritySettingsSnapshot>(
      (ref) =>
          ref.watch(tradingBotsRepositoryProvider).getBotSecuritySettings(),
    );

final tradeBotHistoryProvider = FutureProvider<TradeBotHistorySnapshot>(
  (ref) => ref.watch(tradingBotsRepositoryProvider).getBotHistory(),
);

final tradeBotPerformanceAnalyticsProvider =
    FutureProvider<TradeBotPerformanceAnalyticsSnapshot>(
      (ref) =>
          ref.watch(tradingBotsRepositoryProvider).getBotPerformanceAnalytics(),
    );

final tradeBotBacktestingProvider = FutureProvider<TradeBotBacktestingSnapshot>(
  (ref) => ref.watch(tradeBotAnalyticsRepositoryProvider).getBotBacktesting(),
);

final tradeBotStrategyCompareProvider =
    FutureProvider<TradeBotStrategyCompareSnapshot>(
      (ref) => ref
          .watch(tradeBotAnalyticsRepositoryProvider)
          .getBotStrategyCompare(),
    );

final tradeBotOptimizationProvider =
    FutureProvider<TradeBotOptimizationSnapshot>(
      (ref) =>
          ref.watch(tradeBotAnalyticsRepositoryProvider).getBotOptimization(),
    );

final tradeBotPortfolioDashboardProvider =
    FutureProvider<TradeBotPortfolioDashboardSnapshot>(
      (ref) => ref
          .watch(tradeBotAnalyticsRepositoryProvider)
          .getBotPortfolioDashboard(),
    );

final tradeBotDrawdownAnalyzerProvider =
    FutureProvider<TradeBotDrawdownAnalyzerSnapshot>(
      (ref) => ref
          .watch(tradeBotAnalyticsRepositoryProvider)
          .getBotDrawdownAnalyzer(),
    );

final tradeBotEquityCurveProvider = FutureProvider<TradeBotEquityCurveSnapshot>(
  (ref) => ref.watch(tradeBotAnalyticsRepositoryProvider).getBotEquityCurve(),
);

final tradeBotGuideProvider = FutureProvider<TradeBotGuideSnapshot>(
  (ref) => ref.watch(tradeBotAnalyticsRepositoryProvider).getBotGuide(),
);

final tradeBotFaqProvider = FutureProvider<TradeBotFaqSnapshot>(
  (ref) => ref.watch(tradeBotAnalyticsRepositoryProvider).getBotFaq(),
);

final tradeBotTaxReportingProvider =
    FutureProvider<TradeBotTaxReportingSnapshot>(
      (ref) =>
          ref.watch(tradeBotAnalyticsRepositoryProvider).getBotTaxReporting(),
    );

final tradeBotApiDocumentationProvider =
    FutureProvider<TradeBotApiDocumentationSnapshot>(
      (ref) => ref
          .watch(tradeBotAnalyticsRepositoryProvider)
          .getBotApiDocumentation(),
    );

// STATE-S25 khuôn (xem home_controller_providers.dart / GD4-Async-Playbook.md
// mục 4 "Controller wrapper thuần đọc"): 3 controller pure-logic dưới đây
// (không mutation nội bộ — action method của chúng gọi thẳng repo write
// method, vẫn đồng bộ) chỉ cần bọc AsyncValue quanh phần SEED từ snapshot
// đọc; consumer widget tự `.when()` loading/error/data.

final tradeBotEmergencyStopControllerProvider =
    Provider<AsyncValue<TradeBotEmergencyStopController>>((ref) {
      final repository = ref.watch(tradingBotsRepositoryProvider);
      return ref
          .watch(tradeBotEmergencyStopSnapshotProvider)
          .whenData(
            (snapshot) => TradeBotEmergencyStopController(
              repository: repository,
              state: TradeBotEmergencyStopViewState(snapshot: snapshot),
            ),
          );
    });

final tradeBotSecuritySettingsControllerProvider =
    Provider<AsyncValue<TradeBotSecuritySettingsController>>((ref) {
      final repository = ref.watch(tradingBotsRepositoryProvider);
      return ref
          .watch(tradeBotSecuritySettingsSnapshotProvider)
          .whenData(
            (snapshot) => TradeBotSecuritySettingsController(
              repository: repository,
              state: TradeBotSecuritySettingsViewState(snapshot: snapshot),
            ),
          );
    });

final tradeBotSuitabilityControllerProvider =
    Provider<AsyncValue<TradeBotSuitabilityController>>((ref) {
      return ref
          .watch(tradeBotSuitabilityAssessmentSnapshotProvider)
          .whenData(
            (snapshot) => TradeBotSuitabilityController(
              state: TradeBotSuitabilityViewState(snapshot: snapshot),
            ),
          );
    });

final tradeBotsControllerProvider =
    NotifierProvider<TradeBotsController, TradeBotsViewState>(
      TradeBotsController.new,
    );

/// Owns [TradeBotsViewState] reactively so pages read a single source of
/// truth instead of forking the bot list into local `setState`. The mock
/// repository is stateless (`submitBotAction`/`createTradingBot` return a
/// fixed demo result, see `trading_bots_page_test.dart`'s "SC-059 bot
/// actions stay local"), so the optimistic list edits below are applied
/// here rather than by re-fetching — they replace the page-local `_bots`
/// override that used to silently desync from this provider on rebuild.
///
/// GD4-F3 "controller GHI" khuôn (xem GD4-Async-Playbook.md mục 6, Biến
/// thể A): Notifier vẫn SYNC (không đổi sang AsyncNotifier). `build()` lấy
/// snapshot qua `ref.watch(tradingBotsSnapshotProvider).value` (nullable
/// trong Riverpod 3.x) với fallback rỗng tường minh. Mutation method
/// (`submitAction`/`createBot`) giữ nguyên không đổi — `submitBotAction`/
/// `createTradingBot` trên [TradingBotsRepository] vẫn đồng bộ (xem doc
/// comment của repository đó), nên không có gì phải `await`. Trang
/// (`trading_bots_page.dart`) gate qua `tradingBotsSnapshotProvider.when()`
/// trước khi đọc Notifier này, nên `.value` không bao giờ null trong luồng
/// UI thật.
final class TradeBotsController extends Notifier<TradeBotsViewState> {
  @override
  TradeBotsViewState build() {
    final snapshot =
        ref.watch(tradingBotsSnapshotProvider).value ?? _emptyTradeBotsSnapshot;
    return TradeBotsViewState(snapshot: snapshot);
  }

  /// Áp mutation local optimistic NGAY (đồng bộ, không phụ thuộc kết quả
  /// repo — xem GD4-Async-Playbook.md bẫy 19) rồi mới gọi repo, để UI phản
  /// hồi tức thời trong lúc await network.
  Future<TradeBotActionResult> submitAction({
    required String botId,
    required String action,
  }) {
    _applyBotAction(botId: botId, action: action);
    return ref
        .read(tradingBotsRepositoryProvider)
        .submitBotAction(TradeBotActionRequest(botId: botId, action: action));
  }

  Future<TradeBotCreateResult> createBot(TradeBotCreateRequest request) {
    return ref.read(tradingBotsRepositoryProvider).createTradingBot(request);
  }

  String? botActionValidationMessage({
    required String botId,
    required String action,
  }) => state.botActionValidationMessage(botId: botId, action: action);

  String? createValidationMessage(TradeBotCreateRequest request) =>
      state.createValidationMessage(request);

  void _applyBotAction({required String botId, required String action}) {
    switch (action) {
      case 'delete':
        state = state.copyWith(
          snapshot: state.snapshot.copyWith(
            activeBots: state.snapshot.activeBots
                .where((bot) => bot.id != botId)
                .toList(growable: false),
          ),
        );
      case 'toggle':
        state = state.copyWith(
          snapshot: state.snapshot.copyWith(
            activeBots: [
              for (final bot in state.snapshot.activeBots)
                bot.id == botId
                    ? bot.copyWith(
                        status: bot.status == TradeBotStatus.running
                            ? TradeBotStatus.paused
                            : TradeBotStatus.running,
                      )
                    : bot,
            ],
          ),
        );
    }
  }
}

const _emptyTradeScreenSnapshot = TradeScreenSnapshot(
  pair: TradePair(
    id: '',
    symbol: '',
    baseAsset: '',
    quoteAsset: '',
    price: 0,
    changePct: 0,
    logoColorHex: 0,
  ),
  pairs: [],
  orderBook: TradeOrderBook(bids: [], asks: []),
  trades: [],
  orders: [],
  positions: [],
  copyProviders: [],
  botStrategies: [],
  balances: TradeBalances(usdtAvailable: 0, baseAvailable: 0),
  supportedStates: [TradeScreenState.loading],
  lastUpdatedLabel: '',
);

const _emptyTradeBotsSnapshot = TradeBotsSnapshot(
  trade: _emptyTradeScreenSnapshot,
  strategies: [],
  activeBots: [],
  lastUpdatedLabel: '',
  supportedStates: [TradeScreenState.loading],
);
