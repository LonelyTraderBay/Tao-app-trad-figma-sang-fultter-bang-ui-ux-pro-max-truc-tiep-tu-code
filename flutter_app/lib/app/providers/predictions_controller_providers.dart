import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/core/utils/accent_tone.dart';
import 'package:vit_trade_flutter/features/predictions/data/providers/predictions_repository_provider.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

// GD4-F5 (mục 3+4 GD4-Async-Playbook): provider trung gian cho mọi snapshot
// predictions — trang/controller `.watch()` một trong các provider dưới đây
// thay vì gọi `predictionsRepositoryProvider.getX()` trực tiếp trong
// `build()` (repo giờ trả `Future<T>`). Đọc thuần → FutureProvider forward
// thẳng, KHÔNG thêm async/await thừa (mục 4).

/// Family key cho `getHome(filter:, category:, searchQuery:)`.
typedef PredictionHomeQuery = ({
  PredictionFilterTab filter,
  String? category,
  String searchQuery,
});

/// Query mặc định (không lọc) — dùng cho tổng số sự kiện toàn cục ở hub
/// (`hubTotals`), độc lập với bộ lọc/tìm kiếm hiện tại của người dùng.
const predictionsHomeDefaultQuery = (
  filter: PredictionFilterTab.trending,
  category: null,
  searchQuery: '',
);

final predictionsHomeSnapshotProvider =
    FutureProvider.family<PredictionHomeSnapshot, PredictionHomeQuery>((
      ref,
      query,
    ) {
      return ref
          .watch(predictionsRepositoryProvider)
          .getHome(
            filter: query.filter,
            category: query.category,
            searchQuery: query.searchQuery,
          );
    });

/// Family key cho `getSearch(sort:, status:, category:, searchQuery:)`.
typedef PredictionSearchQuery = ({
  PredictionSearchSort sort,
  PredictionStatusFilter status,
  String? category,
  String searchQuery,
});

final predictionsSearchSnapshotProvider =
    FutureProvider.family<PredictionSearchSnapshot, PredictionSearchQuery>((
      ref,
      query,
    ) {
      return ref
          .watch(predictionsRepositoryProvider)
          .getSearch(
            sort: query.sort,
            status: query.status,
            category: query.category,
            searchQuery: query.searchQuery,
          );
    });

final predictionsBreakingSnapshotProvider =
    FutureProvider.family<PredictionBreakingSnapshot, String?>(
      (ref, category) => ref
          .watch(predictionsRepositoryProvider)
          .getBreaking(category: category),
    );

final predictionsEventDetailSnapshotProvider =
    FutureProvider.family<PredictionEventDetailSnapshot, String>(
      (ref, eventId) =>
          ref.watch(predictionsRepositoryProvider).getEventDetail(eventId),
    );

final predictionsPortfolioSnapshotProvider =
    FutureProvider<PredictionPortfolioSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getPortfolio(),
    );

final predictionsRewardsSnapshotProvider =
    FutureProvider<PredictionRewardsSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getRewards(),
    );

/// Family key cho `getLeaderboard(timeFilter:, metric:)`.
typedef PredictionLeaderboardQuery = ({
  PredictionLeaderboardTimeFilter timeFilter,
  PredictionLeaderboardMetric metric,
});

final predictionsLeaderboardSnapshotProvider =
    FutureProvider.family<
      PredictionLeaderboardSnapshot,
      PredictionLeaderboardQuery
    >((ref, query) {
      return ref
          .watch(predictionsRepositoryProvider)
          .getLeaderboard(timeFilter: query.timeFilter, metric: query.metric);
    });

final predictionsGlobalActivitySnapshotProvider =
    FutureProvider.family<PredictionGlobalActivitySnapshot, double>(
      (ref, minAmount) => ref
          .watch(predictionsRepositoryProvider)
          .getGlobalActivity(minAmount: minAmount),
    );

final predictionsOrderReceiptSnapshotProvider =
    FutureProvider.family<PredictionOrderReceiptSnapshot, String>(
      (ref, receiptId) =>
          ref.watch(predictionsRepositoryProvider).getOrderReceipt(receiptId),
    );

final predictionsRiskCalculatorSnapshotProvider =
    FutureProvider<PredictionRiskCalculatorSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getRiskCalculator(),
    );

final predictionsMarketMakerSnapshotProvider =
    FutureProvider<PredictionMarketMakerSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getMarketMaker(),
    );

final predictionsPortfolioAnalyzerSnapshotProvider =
    FutureProvider<PredictionPortfolioAnalyzerSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getPortfolioAnalyzer(),
    );

final predictionsEventCalendarSnapshotProvider =
    FutureProvider.family<PredictionEventCalendarSnapshot, String?>(
      (ref, category) => ref
          .watch(predictionsRepositoryProvider)
          .getEventCalendar(category: category),
    );

final predictionsSocialSnapshotProvider =
    FutureProvider<PredictionSocialSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getSocial(),
    );

final predictionsAdvancedChartSnapshotProvider =
    FutureProvider.family<PredictionAdvancedChartSnapshot, String>(
      (ref, eventId) =>
          ref.watch(predictionsRepositoryProvider).getAdvancedChart(eventId),
    );

final predictionsTournamentsSnapshotProvider =
    FutureProvider<PredictionTournamentsSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getTournaments(),
    );

final predictionsDataIntegrationSnapshotProvider =
    FutureProvider<PredictionDataIntegrationSnapshot>(
      (ref) => ref.watch(predictionsRepositoryProvider).getDataIntegration(),
    );

/// ERR-36: Notifier theo ADR-001 — máy trạng thái submit dự đoán, family key
/// = eventId.
final predictionEventDetailControllerProvider = NotifierProvider.autoDispose
    .family<
      PredictionEventDetailController,
      PredictionEventDetailViewState,
      String
    >(PredictionEventDetailController.new);

// STATE-S25: 3 controller wrapper thuần đọc (không mutation nội bộ) dựng lại
// mỗi lần watch từ 1 snapshot — trả `AsyncValue<Controller>` thay vì
// `requireValue` để consumer tự xử lý loading/error tường minh qua
// when/whenData (khuôn `homeControllerProvider`).
final predictionsPortfolioControllerProvider =
    Provider<AsyncValue<PredictionsPortfolioController>>((ref) {
      return ref
          .watch(predictionsPortfolioSnapshotProvider)
          .whenData(
            (snapshot) => PredictionsPortfolioController(
              state: PredictionsPortfolioViewState(snapshot: snapshot),
            ),
          );
    });

final predictionRiskCalculatorControllerProvider =
    Provider<AsyncValue<PredictionRiskCalculatorController>>((ref) {
      return ref
          .watch(predictionsRiskCalculatorSnapshotProvider)
          .whenData(
            (snapshot) => PredictionRiskCalculatorController(
              state: PredictionRiskCalculatorViewState(snapshot: snapshot),
            ),
          );
    });

final predictionOrderReceiptControllerProvider =
    Provider.family<AsyncValue<PredictionOrderReceiptController>, String>((
      ref,
      receiptId,
    ) {
      return ref
          .watch(predictionsOrderReceiptSnapshotProvider(receiptId))
          .whenData(
            (snapshot) => PredictionOrderReceiptController(
              state: PredictionOrderReceiptViewState(snapshot: snapshot),
            ),
          );
    });

final class PredictionEventDetailController
    extends Notifier<PredictionEventDetailViewState> {
  PredictionEventDetailController(this.eventId);

  final String eventId;

  PredictionsRepository get _repository =>
      ref.read(predictionsRepositoryProvider);

  // GD4-F5 (mục 6, biến thể A): fallback rỗng — chỉ chạm tới khi Notifier
  // build() chạy trước khi provider async tương ứng resolve lần đầu (test
  // đọc Notifier trực tiếp); luồng UI thật luôn gate qua
  // `predictionsEventDetailSnapshotProvider.when()` trước (mục 5) nên
  // `.value` không bao giờ null khi `data:` chạy.
  @override
  PredictionEventDetailViewState build() {
    final snapshot =
        ref.watch(predictionsEventDetailSnapshotProvider(eventId)).value ??
        _emptyEventDetailSnapshot;
    return PredictionEventDetailViewState(snapshot: snapshot);
  }

  /// Người dùng bấm CTA Buy/Sell sau preview. Trả về `receiptId` khi thành
  /// công (view điều hướng trang biên lai), `null` khi lỗi/validation —
  /// trạng thái + errorMessage đã ghi vào state, không bao giờ ném ra UI.
  Future<String?> submitOrder({
    required String outcome,
    required bool isBuy,
    required bool isMarket,
    required String amountText,
  }) async {
    if (state.status.isBusy) return null;
    final validation = orderValidationMessage(
      outcome: outcome,
      amountText: amountText,
    );
    if (validation != null) {
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.validationError,
        errorMessage: validation,
      );
      return null;
    }
    final amount = double.tryParse(amountText.trim().replaceAll(',', '')) ?? 0;
    state = state.copyWith(status: PredictionHighRiskFlowStatus.confirming);
    state = state.copyWith(status: PredictionHighRiskFlowStatus.submitting);
    try {
      final receiptId = await _repository.submitOrder(
        eventId: eventId,
        outcome: outcome,
        isBuy: isBuy,
        isMarket: isMarket,
        amount: amount,
      );
      if (!ref.mounted) return null;
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.submitted,
        lastReceiptId: receiptId,
      );
      return receiptId;
    } on OfflineFailure catch (failure) {
      if (!ref.mounted) return null;
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.offline,
        errorMessage: failure.message,
      );
      return null;
    } on Object {
      if (!ref.mounted) return null;
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.error,
        errorMessage: 'Gửi lệnh dự đoán thất bại. Vui lòng thử lại.',
      );
      return null;
    }
  }

  String? orderValidationMessage({
    required String outcome,
    required String amountText,
  }) {
    if (state.status == PredictionHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this prediction order.';
    }
    if (state.status.isBusy) {
      return 'Prediction order confirmation is already in progress.';
    }
    if (state.snapshot.event.status != PredictionEventStatus.active) {
      return 'Resolved events are receipt-only and cannot accept new orders.';
    }
    final hasOutcome = state.snapshot.event.outcomes.any(
      (item) => item.label == outcome,
    );
    if (!hasOutcome) {
      return 'Select an available outcome before preview.';
    }
    final amount = double.tryParse(amountText.trim().replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return 'Enter a valid order amount before preview.';
    }
    return null;
  }

  bool canSubmitOrder({required String outcome, required String amountText}) {
    return orderValidationMessage(outcome: outcome, amountText: amountText) ==
        null;
  }

  PredictionOrderPreview previewOrder({
    required String outcome,
    required bool isBuy,
    required bool isMarket,
    required String amountText,
  }) {
    final selected = state.snapshot.event.outcomes.firstWhere(
      (item) => item.label == outcome,
      orElse: () => state.snapshot.event.outcomes.first,
    );
    final amount = double.tryParse(amountText.trim().replaceAll(',', '')) ?? 0;
    final price = selected.chance / 100;
    final fee = amount * .005;
    final shares = price <= 0 ? 0.0 : amount / price;
    final canSubmit = canSubmitOrder(
      outcome: selected.label,
      amountText: amountText,
    );
    return PredictionOrderPreview(
      outcome: selected.label,
      sideLabel: isBuy ? 'Buy' : 'Sell',
      orderTypeLabel: isMarket ? 'Market' : 'Limit',
      probabilityPct: selected.chance,
      price: price,
      amount: amount,
      fee: fee,
      shares: shares,
      maxLoss: amount + fee,
      canSubmit: canSubmit,
    );
  }
}

final _emptyPredictionEvent = PredictionEventDraft(
  id: '',
  title: '',
  category: '',
  tags: const [],
  outcomes: const [
    PredictionOutcomeDraft(label: 'Yes', chance: 50, tone: AccentTone.buy),
  ],
  volume24h: 0,
  totalVolume: 0,
  endDate: DateTime.utc(2000),
  liquidity: 0,
  participants: 0,
  status: PredictionEventStatus.active,
  change24h: 0,
  createdAt: DateTime.utc(2000),
);

final _emptyEventDetailSnapshot = PredictionEventDetailSnapshot(
  event: _emptyPredictionEvent,
  position: null,
  relatedEvents: const [],
  probabilityHistory: const [],
  volumeHistory: const [],
  orderBook: const PredictionOrderBookDraft(bids: [], asks: []),
  rules: const [],
  topHolders: const [],
  activity: const [],
  arenaRooms: const [],
  orders: const [],
  receipts: const [],
  rewards: const [],
  lastUpdatedLabel: '',
  supportedStates: const {},
);
