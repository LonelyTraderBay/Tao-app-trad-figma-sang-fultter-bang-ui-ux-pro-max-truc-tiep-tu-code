// Spot / Futures / Margin / Convert product controller providers.
// Advanced terminal demos stay in trade_terminal_controller_providers.dart.
//
// Composition root for the `trade` feature's own domain/data/controllers
// layers (features/trade/domain, features/trade/data,
// features/trade/presentation/controllers) — no longer wired through
// `trade_core`'s 6-way TradeRepository union.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/features/trade/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

final tradeReadModelControllerProvider = Provider<TradeRepository>((ref) {
  return ref.watch(tradeRepositoryProvider);
});

typedef TradeMarginControllerRequest = ({String pairId, bool pairRouteVariant});

// GD4 Cụm F3 (phần bổ sung): 19 method còn lại của SpotTradeRepository/
// TradeFuturesMarginRepository giờ là `Future<T>` (ADR-001) — khác trade_bots
// Cụm F3, batch này cũng bao gồm preview/patch/action/create (xem doc comment
// SpotTradeRepository). Mỗi repo call trực tiếp trong build() cũ (page hoặc
// controller) trở thành FutureProvider trung gian (playbook mục 3/4); trang
// bọc `.when()` (mục 5); Notifier có mutation seed qua `.value` + fallback
// rỗng tường minh (mục 6 Biến thể A).

final tradeScreenProvider = FutureProvider.family<TradeScreenSnapshot, String>(
  (ref, pairId) => ref.watch(tradeRepositoryProvider).getTrade(pairId: pairId),
);

final tradeFuturesProvider =
    FutureProvider.family<TradeFuturesSnapshot, String>(
      (ref, pairId) =>
          ref.watch(tradeRepositoryProvider).getFutures(pairId: pairId),
    );

final tradeOrdersHistorySnapshotProvider =
    FutureProvider<TradeOrdersHistorySnapshot>(
      (ref) => ref.watch(tradeRepositoryProvider).getOrdersHistory(),
    );

/// STATE-S25 khuôn (mục 4) — [TradeOrdersHistoryController] không có
/// mutation nội bộ (`cancelOrder` gọi thẳng repo write method, không tự sửa
/// `state`), nên bọc `AsyncValue` quanh phần seed thay vì Notifier +
/// fallback rỗng. Trang tự `.when()` loading/error/data.
final tradeOrdersHistoryControllerProvider =
    Provider<AsyncValue<TradeOrdersHistoryController>>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return ref
          .watch(tradeOrdersHistorySnapshotProvider)
          .whenData(
            (snapshot) => TradeOrdersHistoryController(
              repository: repository,
              state: TradeOrdersHistoryViewState(snapshot: snapshot),
            ),
          );
    });

/// `previewOrder` giờ `Future<T>` — mỗi draft (family key) watch preview qua
/// provider trung gian riêng thay vì gọi thẳng repo trong `build()` của
/// [TradeOrderController] (không thể `await` trong `Notifier.build()`).
/// autoDispose vì mỗi draft là tạm thời (khuôn PERF-HN1).
final tradeOrderPreviewProvider = FutureProvider.autoDispose
    .family<TradeOrderPreview, TradeOrderDraft>(
      (ref, draft) => ref.watch(tradeRepositoryProvider).previewOrder(draft),
    );

/// Notifier theo ADR-001 — family key giữ nguyên record request (PERF-HN1
/// đã cho record này value equality qua TradeOrderDraft ==), autoDispose để
/// member theo từng draft không tích lũy.
final tradeOrderControllerProvider = NotifierProvider.autoDispose
    .family<
      TradeOrderController,
      TradeOrderViewState,
      TradeOrderControllerRequest
    >(TradeOrderController.new);

final tradeFuturesLeverageSnapshotProvider =
    FutureProvider.family<TradeFuturesLeverageSnapshot, String>(
      (ref, pairId) =>
          ref.watch(tradeRepositoryProvider).getFuturesLeverage(pairId: pairId),
    );

/// `previewFuturesLeverage` giờ `Future<T>` — xem [tradeOrderPreviewProvider].
/// Family key = `TradeFuturesLeverageRequest` (giờ có value equality, xem
/// entity) để nhiều lần watch cùng leverage không tạo fetch mới.
final tradeFuturesLeveragePreviewProvider = FutureProvider.autoDispose
    .family<TradeFuturesLeveragePreview, TradeFuturesLeverageRequest>(
      (ref, request) =>
          ref.watch(tradeRepositoryProvider).previewFuturesLeverage(request),
    );

/// STATE-S22: Notifier theo ADR-001, family key thu về `String pairId` —
/// nấc đòn bẩy là state trong Notifier, không còn nằm trong key (trước đây
/// mỗi nấc slider tạo một element cache riêng — leak allowlist S24).
final tradeLeverageControllerProvider = NotifierProvider.autoDispose
    .family<TradeLeverageController, TradeLeverageViewState, String>(
      TradeLeverageController.new,
    );

final tradeMarginSnapshotProvider = FutureProvider.autoDispose
    .family<TradeMarginTradingSnapshot, TradeMarginControllerRequest>(
      (ref, request) => ref
          .watch(tradeRepositoryProvider)
          .getMarginTrading(
            pairId: request.pairId,
            pairRouteVariant: request.pairRouteVariant,
          ),
    );

/// STATE-S25 khuôn (mục 4) — [TradeMarginController] không có mutation nội
/// bộ (chỉ có method đọc thuần: `positionsForMode`/`totalPnlForMode`/
/// `maxAmountFor`/`leverageValidationMessage`), nên bọc `AsyncValue` quanh
/// phần seed thay vì Notifier + fallback rỗng. Trang tự `.when()`.
final tradeMarginControllerProvider = Provider.autoDispose
    .family<AsyncValue<TradeMarginController>, TradeMarginControllerRequest>((
      ref,
      request,
    ) {
      return ref
          .watch(tradeMarginSnapshotProvider(request))
          .whenData(
            (snapshot) => TradeMarginController(
              state: TradeMarginViewState(snapshot: snapshot),
            ),
          );
    });

/// `previewFuturesOrder` giờ `Future<T>` — xem [tradeOrderPreviewProvider].
final tradeFuturesOrderPreviewProvider = FutureProvider.autoDispose
    .family<TradeFuturesPreview, TradeFuturesOrderDraft>(
      (ref, draft) =>
          ref.watch(tradeRepositoryProvider).previewFuturesOrder(draft),
    );

/// STATE-S22: Notifier theo ADR-001 (mirror tradeOrderControllerProvider).
final tradeFuturesOrderControllerProvider = NotifierProvider.autoDispose
    .family<
      TradeFuturesOrderController,
      TradeFuturesOrderViewState,
      TradeFuturesOrderControllerRequest
    >(TradeFuturesOrderController.new);

/// GD4 Cụm F3 "controller GHI" khuôn (mục 6, Biến thể A): Notifier vẫn SYNC
/// (không đổi sang AsyncNotifier) — `enterPreview`/`cancelPreview`/`submit`
/// là mutation cục bộ trên `state.status`. `build()` lấy snapshot/preview
/// qua `ref.watch(...).value` (nullable trong Riverpod 3.x) với fallback
/// rỗng tường minh. Trang (`trade_page_state.dart`) gate qua
/// `tradeScreenProvider(pairId).when()` trước khi dựng request này, nên
/// `.value` của snapshot không bao giờ null trong luồng UI thật; `preview`
/// vẫn có thể null ở frame đầu tiên của MỖI draft mới (mỗi keystroke đổi
/// amount tạo family member preview mới — xem GD4-Async-Playbook.md mục 9,
/// bẫy mới "preview đọc theo draft").
final class TradeOrderController extends Notifier<TradeOrderViewState> {
  TradeOrderController(this.request);

  final TradeOrderControllerRequest request;

  TradeRepository get _repository => ref.read(tradeRepositoryProvider);

  @override
  TradeOrderViewState build() {
    final snapshot =
        ref.watch(tradeScreenProvider(request.pairId)).value ??
        _emptyTradeScreenSnapshot;
    final preview =
        ref.watch(tradeOrderPreviewProvider(request.draft)).value ??
        _emptyTradeOrderPreview;
    final seeded = TradeOrderViewState(
      snapshot: snapshot,
      draft: request.draft,
      preview: preview,
    );
    if (request.draft.amount <= 0) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.draft);
    }
    if (_validationMessageFor(seeded) != null) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.validationError);
    }
    return seeded;
  }

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() => _validationMessageFor(state);

  static String? _validationMessageFor(TradeOrderViewState state) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this order.';
    }
    if (state.status.isBusy) {
      return 'Confirmation is already in progress.';
    }
    if (state.draft.pairId.trim().isEmpty) {
      return 'Select a trading pair before preview.';
    }
    if (state.draft.amount <= 0) {
      return 'Enter a valid order amount before preview.';
    }
    if (state.draft.price <= 0) {
      return 'Enter a valid order price before preview.';
    }
    if (state.draft.side == TradeOrderSide.buy &&
        state.preview.total > state.snapshot.balances.usdtAvailable) {
      return 'Order total exceeds available quote balance.';
    }
    if (state.draft.side == TradeOrderSide.sell &&
        state.draft.amount > state.snapshot.balances.baseAvailable) {
      return 'Order amount exceeds available base balance.';
    }
    return null;
  }

  /// Người dùng mở sheet 'Xem lại lệnh' — `ready → preview`.
  void enterPreview() {
    if (!canSubmit || state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.preview);
  }

  /// Đóng sheet mà không xác nhận — quay về `ready`.
  void cancelPreview() {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.ready);
  }

  /// Người dùng bấm xác nhận trong sheet. Nhánh `offline` phân loại qua
  /// [OfflineFailure]; mọi lỗi khác về `error` — không bao giờ ném ra UI.
  Future<void> submit() async {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.confirming);
    state = state.copyWith(status: TradeHighRiskFlowStatus.submitting);
    try {
      final receipt = await _repository.submitOrder(state.draft);
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.submitted,
        receipt: receipt,
      );
      state = state.copyWith(status: TradeHighRiskFlowStatus.success);
    } on OfflineFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.offline,
        errorMessage: failure.message,
      );
    } on Object {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.error,
        errorMessage: 'Gửi lệnh thất bại. Vui lòng thử lại.',
      );
    }
  }
}

final class TradeLeverageController extends Notifier<TradeLeverageViewState> {
  TradeLeverageController(this.pairId);

  final String pairId;

  TradeRepository get _repository => ref.read(tradeRepositoryProvider);

  static int sanitize(int leverage) => leverage.clamp(1, 100).toInt();

  int sanitizeLeverage(int leverage) => sanitize(leverage);

  @override
  TradeLeverageViewState build() {
    final snapshot =
        ref.watch(tradeFuturesLeverageSnapshotProvider(pairId)).value ??
        _emptyTradeFuturesLeverageSnapshot;
    final request = TradeFuturesLeverageRequest(
      pairId: pairId,
      leverage: sanitize(snapshot.currentLeverage),
      exampleMargin: snapshot.exampleMargin,
    );
    final preview =
        ref.watch(tradeFuturesLeveragePreviewProvider(request)).value ??
        _emptyTradeFuturesLeveragePreview;
    return TradeLeverageViewState(
      snapshot: snapshot,
      request: request,
      preview: preview,
    );
  }

  /// Người dùng kéo slider/chọn preset — cập nhật request ngay lập tức
  /// (đồng bộ, giữ preview cũ hiển thị trong lúc chờ) rồi tự `await` preview
  /// mới. `Notifier.build()` không tự chạy lại khi `state =` được gán tay,
  /// nên không thể chỉ dựa vào watch trong `build()` cho lần cập nhật này —
  /// khác lần seed đầu (xem GD4-Async-Playbook.md mục 9, bẫy mới "mutation
  /// cục bộ cần recompute qua preview giờ async").
  Future<void> setLeverage(int leverage) async {
    if (state.status.isBusy) return;
    final request = TradeFuturesLeverageRequest(
      pairId: pairId,
      leverage: sanitize(leverage),
      exampleMargin: state.snapshot.exampleMargin,
    );
    state = state.copyWith(
      request: request,
      status: TradeHighRiskFlowStatus.ready,
    );
    final preview = await _repository.previewFuturesLeverage(request);
    if (!ref.mounted) return;
    // Bỏ qua kết quả trả về muộn nếu người dùng đã kéo sang nấc khác trước
    // khi preview này resolve (tránh preview cũ ghi đè preview mới hơn).
    if (state.request == request) {
      state = state.copyWith(preview: preview);
    }
  }

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before changing leverage.';
    }
    if (state.status.isBusy) {
      return 'Leverage confirmation is already in progress.';
    }
    if (state.request.pairId.trim().isEmpty) {
      return 'Select a futures pair before preview.';
    }
    if (state.request.leverage < 1 || state.request.leverage > 100) {
      return 'Leverage must stay between 1x and 100x.';
    }
    if (state.request.exampleMargin <= 0) {
      return 'Enter a valid margin example before preview.';
    }
    return null;
  }

  /// Máy trạng thái chung ADR-001 — xem [TradeOrderController.submit].
  Future<void> submit() async {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.confirming);
    state = state.copyWith(status: TradeHighRiskFlowStatus.submitting);
    try {
      final receipt = await _repository.submitFuturesLeverage(state.request);
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.submitted,
        receipt: receipt,
      );
      state = state.copyWith(status: TradeHighRiskFlowStatus.success);
    } on OfflineFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.offline,
        errorMessage: failure.message,
      );
    } on Object {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.error,
        errorMessage: 'Điều chỉnh đòn bẩy thất bại. Vui lòng thử lại.',
      );
    }
  }
}

final class TradeFuturesOrderController
    extends Notifier<TradeFuturesOrderViewState> {
  TradeFuturesOrderController(this.request);

  final TradeFuturesOrderControllerRequest request;

  TradeRepository get _repository => ref.read(tradeRepositoryProvider);

  @override
  TradeFuturesOrderViewState build() {
    final snapshot =
        ref.watch(tradeFuturesProvider(request.pairId)).value ??
        _emptyTradeFuturesSnapshot;
    final preview =
        ref.watch(tradeFuturesOrderPreviewProvider(request.draft)).value ??
        _emptyTradeFuturesPreview;
    final seeded = TradeFuturesOrderViewState(
      snapshot: snapshot,
      draft: request.draft,
      preview: preview,
    );
    if (request.draft.margin <= 0) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.draft);
    }
    if (_validationMessageFor(seeded) != null) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.validationError);
    }
    return seeded;
  }

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() => _validationMessageFor(state);

  /// Người dùng mở sheet 'Xem lại hợp đồng' — `ready → preview`.
  void enterPreview() {
    if (!canSubmit || state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.preview);
  }

  /// Đóng sheet mà không xác nhận — quay về `ready`.
  void cancelPreview() {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.ready);
  }

  /// Máy trạng thái chung ADR-001 — xem [TradeOrderController.submit].
  Future<void> submit() async {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.confirming);
    state = state.copyWith(status: TradeHighRiskFlowStatus.submitting);
    try {
      final receipt = await _repository.submitFuturesOrder(state.draft);
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.submitted,
        receipt: receipt,
      );
      state = state.copyWith(status: TradeHighRiskFlowStatus.success);
    } on OfflineFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.offline,
        errorMessage: failure.message,
      );
    } on Object {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.error,
        errorMessage: 'Gửi lệnh futures thất bại. Vui lòng thử lại.',
      );
    }
  }

  static String? _validationMessageFor(TradeFuturesOrderViewState state) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this futures order.';
    }
    if (state.status.isBusy) {
      return 'Futures confirmation is already in progress.';
    }
    if (state.draft.pairId.trim().isEmpty) {
      return 'Select a futures pair before preview.';
    }
    if (state.draft.margin <= 0) {
      return 'Enter a valid margin amount before preview.';
    }
    if (state.draft.leverage < 1 || state.draft.leverage > 100) {
      return 'Leverage must stay between 1x and 100x.';
    }
    final availableMargin =
        state.snapshot.accountBalance - state.snapshot.usedMargin;
    if (state.draft.margin > availableMargin) {
      return 'Margin exceeds available futures balance.';
    }
    if (state.draft.type == TradeFuturesOrderType.limit &&
        (state.draft.limitPrice == null || state.draft.limitPrice! <= 0)) {
      return 'Enter a valid limit price before preview.';
    }
    if (!state.preview.canOpen) {
      return 'Resolve futures risk checks before confirmation.';
    }
    return null;
  }
}

/// STATE-S23: view-state bất biến của Xuất lịch sử giao dịch — format/
/// period/includes/isExporting/result sống ở Notifier (một nguồn sự thật),
/// trang chỉ watch + gọi method.
final class TradeHistoryExportViewState {
  const TradeHistoryExportViewState({
    required this.snapshot,
    required this.format,
    required this.period,
    required this.includes,
    required this.isExporting,
    required this.result,
  });

  factory TradeHistoryExportViewState.fromSnapshot(
    TradeExportSnapshot snapshot,
  ) {
    return TradeHistoryExportViewState(
      snapshot: snapshot,
      format: snapshot.formats.first.id,
      period: '30d',
      includes: List.unmodifiable(snapshot.includes),
      isExporting: false,
      result: null,
    );
  }

  final TradeExportSnapshot snapshot;
  final String format;
  final String period;
  final List<TradeExportInclude> includes;
  final bool isExporting;
  final TradeExportResult? result;

  /// `result` cố ý KHÔNG giữ giá trị cũ khi không truyền — mỗi transition
  /// mới (đổi format/period, toggle include, xuất mới) xóa kết quả xuất cũ
  /// (khuôn `errorMessage` của TradeOrderViewState.copyWith).
  TradeHistoryExportViewState copyWith({
    String? format,
    String? period,
    List<TradeExportInclude>? includes,
    bool? isExporting,
    TradeExportResult? result,
  }) {
    return TradeHistoryExportViewState(
      snapshot: snapshot,
      format: format ?? this.format,
      period: period ?? this.period,
      includes: includes == null ? this.includes : List.unmodifiable(includes),
      isExporting: isExporting ?? this.isExporting,
      result: result,
    );
  }
}

final tradeExportSnapshotProvider = FutureProvider<TradeExportSnapshot>(
  (ref) => ref.watch(tradeRepositoryProvider).getTradeExport(),
);

// GD4 Cụm F3: 6 FutureProvider dưới đây forward các repo call trước kia gọi
// trực tiếp trong `build()`/`initState()` của trang (mục 3, bước A+B gộp) —
// không có controller/Notifier trung gian, trang tự `.when()`.

final tradeOrderReceiptProvider = FutureProvider<TradeOrderReceiptSnapshot>(
  (ref) => ref.watch(tradeRepositoryProvider).getOrderReceipt(),
);

final tradeSettingsSnapshotProvider = FutureProvider<TradeSettingsSnapshot>(
  (ref) => ref.watch(tradeRepositoryProvider).getTradeSettings(),
);

final tradePositionsProvider = FutureProvider<TradePositionsSnapshot>(
  (ref) => ref.watch(tradeRepositoryProvider).getTradePositions(),
);

final tradeMarginTradingHubProvider =
    FutureProvider<TradeMarginTradingHubSnapshot>(
      (ref) => ref.watch(tradeRepositoryProvider).getMarginTradingHub(),
    );

final tradeConvertSnapshotProvider = FutureProvider<TradeConvertSnapshot>(
  (ref) => ref.watch(tradeRepositoryProvider).getConvert(),
);

/// `previewConvert` giờ `Future<T>` — trang `convert_page.dart` coi
/// [tradeConvertSnapshotProvider] là async CHÍNH (chặn toàn trang) và quote
/// này là async PHỤ, đọc qua `.value` + fallback (mục 5 "2 async song song
/// trên 1 trang" — tránh 2 lớp skeleton chồng nhau).
final tradeConvertQuoteProvider = FutureProvider.autoDispose
    .family<TradeConvertQuote, TradeConvertRequest>(
      (ref, request) =>
          ref.watch(tradeRepositoryProvider).previewConvert(request),
    );

/// STATE-S23 (khuôn MarketWatchlistStateController) + GD4 Cụm F3 "controller
/// GHI" khuôn (mục 6, Biến thể A): build() seed từ repo (giờ `Future<T>`) qua
/// `.value` + fallback rỗng; method mutate `state = copyWith(...)` giữ
/// nguyên. KHÔNG autoDispose — giữ nguyên khi điều hướng đi/về trong phiên
/// xuất lịch sử. Trang (`trade_history_export_page.dart`) gate qua
/// `tradeExportSnapshotProvider.when()` trước khi đọc Notifier này, nên
/// `.value` không bao giờ null trong luồng UI thật.
final class TradeHistoryExportStateController
    extends Notifier<TradeHistoryExportViewState> {
  TradeRepository get _repository => ref.read(tradeReadModelControllerProvider);

  @override
  TradeHistoryExportViewState build() {
    final snapshot =
        ref.watch(tradeExportSnapshotProvider).value ??
        _emptyTradeExportSnapshot;
    return TradeHistoryExportViewState.fromSnapshot(snapshot);
  }

  void setFormat(String format) {
    state = state.copyWith(format: format);
  }

  void setPeriod(String period) {
    state = state.copyWith(period: period);
  }

  void toggleInclude(String id) {
    state = state.copyWith(
      includes: [
        for (final item in state.includes)
          item.id == id ? item.copyWith(checked: !item.checked) : item,
      ],
    );
  }

  /// Đóng kết quả xuất hiện tại — quay về form chọn định dạng/khoảng thời
  /// gian ('Tạo mới').
  void resetResult() {
    state = state.copyWith();
  }

  Future<void> submitExport() async {
    if (state.isExporting) return;
    state = state.copyWith(isExporting: true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final request = TradeExportRequest(
      format: state.format,
      period: state.period,
      includeIds: [
        for (final item in state.includes)
          if (item.checked) item.id,
      ],
    );
    final result = await _repository.createTradeExport(request);
    if (!ref.mounted) return;
    state = state.copyWith(isExporting: false, result: result);
  }
}

final tradeHistoryExportStateControllerProvider =
    NotifierProvider<
      TradeHistoryExportStateController,
      TradeHistoryExportViewState
    >(TradeHistoryExportStateController.new);

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

const _emptyTradeOrderPreview = TradeOrderPreview(
  total: 0,
  fee: 0,
  feeRate: 0,
  estimatedReceive: 0,
);

const _emptyTradeFuturesSnapshot = TradeFuturesSnapshot(
  trade: _emptyTradeScreenSnapshot,
  pair: TradePair(
    id: '',
    symbol: '',
    baseAsset: '',
    quoteAsset: '',
    price: 0,
    changePct: 0,
    logoColorHex: 0,
  ),
  positions: [],
  leverages: [],
  markPrice: 0,
  indexPrice: 0,
  fundingRate: 0,
  accountBalance: 0,
  usedMargin: 0,
  supportedStates: [TradeScreenState.loading],
  lastUpdatedLabel: '',
);

const _emptyTradeFuturesPreview = TradeFuturesPreview(
  positionSize: 0,
  contractQty: 0,
  liquidationPrice: 0,
  openFee: 0,
  canOpen: false,
);

const _emptyTradeFuturesLeverageSnapshot = TradeFuturesLeverageSnapshot(
  futures: _emptyTradeFuturesSnapshot,
  currentLeverage: 1,
  presets: [],
  sliderStops: [],
  exampleMargin: 0,
  supportedStates: [TradeScreenState.loading],
  lastUpdatedLabel: '',
);

const _emptyTradeFuturesLeveragePreview = TradeFuturesLeveragePreview(
  leverage: 1,
  riskLabel: '',
  riskLevel: 0,
  riskColorHex: 0,
  positionSize: 0,
  liquidationDistancePct: 0,
  openFee: 0,
  profitAtOnePct: 0,
  lossAtOnePct: 0,
  warningText: '',
  showRiskTips: false,
);

const _emptyTradeExportSnapshot = TradeExportSnapshot(
  trade: _emptyTradeScreenSnapshot,
  stats: TradeExportStats(
    totalTrades: 0,
    totalVolume: 0,
    totalFees: 0,
    netPnl: 0,
  ),
  // `TradeHistoryExportViewState.fromSnapshot` reads `formats.first` — giữ 1
  // phần tử placeholder để fallback rỗng không ném lỗi khi test đọc Notifier
  // trực tiếp trước khi provider async resolve (xem mục 6).
  formats: [TradeExportFormat(id: '', label: '', description: '')],
  periods: [],
  includes: [],
  lastUpdatedLabel: '',
  supportedStates: [TradeScreenState.loading],
);
