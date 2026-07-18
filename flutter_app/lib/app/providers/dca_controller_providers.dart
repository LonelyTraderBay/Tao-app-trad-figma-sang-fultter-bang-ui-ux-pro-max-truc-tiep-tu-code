import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/dca/data/providers/dca_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/dca/presentation/controllers/dca_controller.dart';

export 'package:vit_trade_flutter/features/dca/presentation/controllers/dca_controller.dart';

final dcaDashboardProvider = FutureProvider<DcaDashboardSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getDashboard();
});

final dcaRebalanceConfigProvider = FutureProvider<DcaRebalanceConfigSnapshot>((
  ref,
) {
  return ref.watch(data.dcaRepositoryProvider).getRebalanceConfig();
});

final dcaRebalanceDashboardProvider =
    FutureProvider.family<DcaRebalanceDashboardSnapshot, String>((
      ref,
      configId,
    ) {
      return ref
          .watch(data.dcaRepositoryProvider)
          .getRebalanceDashboard(configId);
    });

final dcaScheduleConfigProvider = FutureProvider<DcaScheduleConfigSnapshot>((
  ref,
) {
  return ref.watch(data.dcaRepositoryProvider).getScheduleConfig();
});

final dcaScheduleAnalyticsProvider =
    FutureProvider.family<DcaScheduleAnalyticsSnapshot, String>((
      ref,
      configId,
    ) {
      return ref
          .watch(data.dcaRepositoryProvider)
          .getScheduleAnalytics(configId);
    });

final dcaPortfolioOptimizerProvider =
    FutureProvider<DcaPortfolioOptimizerSnapshot>((ref) {
      return ref.watch(data.dcaRepositoryProvider).getPortfolioOptimizer();
    });

final dcaDynamicAmountProvider = FutureProvider<DcaDynamicAmountSnapshot>((
  ref,
) {
  return ref.watch(data.dcaRepositoryProvider).getDynamicAmount();
});

final dcaBacktesterProvider = FutureProvider<DcaBacktesterSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getBacktester();
});

final dcaMultiAssetProvider = FutureProvider<DcaMultiAssetSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getMultiAsset();
});

final dcaPerformanceCompareProvider =
    FutureProvider<DcaPerformanceCompareSnapshot>((ref) {
      return ref.watch(data.dcaRepositoryProvider).getPerformanceCompare();
    });

final dcaSmartRulesProvider = FutureProvider<DcaSmartRulesSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getSmartRules();
});

final dcaOverviewDemoProvider = FutureProvider<DcaOverviewDemoSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getOverviewDemo();
});

/// STATE-S23: view-state bất biến của Cấu hình Auto-Rebalance — targets +
/// strategy + frequency + threshold + min-trade sống ở Notifier (một nguồn
/// sự thật), trang chỉ watch + gọi method.
final class DcaRebalanceConfigViewState {
  const DcaRebalanceConfigViewState({
    required this.snapshot,
    required this.targets,
    required this.strategy,
    required this.frequency,
    required this.driftThreshold,
    required this.minTradeAmountUsd,
  });

  factory DcaRebalanceConfigViewState.fromSnapshot(
    DcaRebalanceConfigSnapshot snapshot,
  ) {
    return DcaRebalanceConfigViewState(
      snapshot: snapshot,
      targets: List.unmodifiable(snapshot.targets),
      strategy: snapshot.strategy,
      frequency: snapshot.frequency,
      driftThreshold: snapshot.driftThreshold,
      minTradeAmountUsd: snapshot.minTradeAmountUsd.toDouble(),
    );
  }

  final DcaRebalanceConfigSnapshot snapshot;
  final List<DcaRebalanceTarget> targets;
  final DcaRebalanceStrategy strategy;
  final DcaRebalanceFrequency frequency;
  final double driftThreshold;
  final double minTradeAmountUsd;

  DcaRebalanceConfigViewState copyWith({
    List<DcaRebalanceTarget>? targets,
    DcaRebalanceStrategy? strategy,
    DcaRebalanceFrequency? frequency,
    double? driftThreshold,
    double? minTradeAmountUsd,
  }) {
    return DcaRebalanceConfigViewState(
      snapshot: snapshot,
      targets: targets == null ? this.targets : List.unmodifiable(targets),
      strategy: strategy ?? this.strategy,
      frequency: frequency ?? this.frequency,
      driftThreshold: driftThreshold ?? this.driftThreshold,
      minTradeAmountUsd: minTradeAmountUsd ?? this.minTradeAmountUsd,
    );
  }
}

/// GD4 (khuôn STATE-S25 biến thể A): `dcaRebalanceConfigProvider` giờ là
/// `FutureProvider` — build() seed từ `.value` (nullable ở Riverpod 3.x)
/// với fallback rỗng tường minh. Trang gate qua `dcaRebalanceConfigProvider
/// .when()` trước khi đọc Notifier này (xem GD4-Async-Playbook.md mục 6),
/// nên `.value` không bao giờ null trong luồng UI thật.
const _emptyDcaRebalanceConfigSnapshot = DcaRebalanceConfigSnapshot(
  endpoint: '',
  actionDraft: '',
  supportedStates: [],
  totalPortfolioUsd: 0,
  driftThreshold: 0,
  minTradeAmountUsd: 0,
  strategy: DcaRebalanceStrategy.threshold,
  frequency: DcaRebalanceFrequency.monthly,
  targets: [],
  strategyOptions: [],
  frequencyOptions: [],
);

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — cấu hình
/// rebalance giữ nguyên khi điều hướng đi/về trong phiên (trước khi lưu).
final class DcaRebalanceConfigStateController
    extends Notifier<DcaRebalanceConfigViewState> {
  @override
  DcaRebalanceConfigViewState build() {
    final snapshot =
        ref.watch(dcaRebalanceConfigProvider).value ??
        _emptyDcaRebalanceConfigSnapshot;
    return DcaRebalanceConfigViewState.fromSnapshot(snapshot);
  }

  void addTarget() {
    final targets = state.targets;
    if (targets.length >= 4) return;
    final nextId = 'target-extra-${targets.length + 1}';
    final accent = targets.length.isEven
        ? DcaRebalanceAccent.warning
        : DcaRebalanceAccent.accent;
    state = state.copyWith(
      targets: [
        ...targets,
        DcaRebalanceTarget(
          id: nextId,
          symbol: targets.length.isEven ? 'BNB' : 'SOL',
          assetName: targets.length.isEven ? 'BNB' : 'Solana',
          currentPercent: 0,
          targetPercent: 0,
          tolerance: 5,
          currentValueUsd: 0,
          unitPriceUsd: targets.length.isEven ? 320 : 105,
          accent: accent,
        ),
      ],
    );
  }

  void removeTarget(String id) {
    if (state.targets.length <= 2) return;
    state = state.copyWith(
      targets: state.targets
          .where((target) => target.id != id)
          .toList(growable: false),
    );
  }

  void updateTargetPercent(String id, double value) {
    state = state.copyWith(
      targets: [
        for (final target in state.targets)
          target.id == id
              ? target.copyWith(targetPercent: value.roundToDouble())
              : target,
      ],
    );
  }

  void updateTargetTolerance(String id, double value) {
    state = state.copyWith(
      targets: [
        for (final target in state.targets)
          target.id == id
              ? target.copyWith(tolerance: value.clamp(1, 20).toDouble())
              : target,
      ],
    );
  }

  void setStrategy(DcaRebalanceStrategy strategy) {
    state = state.copyWith(strategy: strategy);
  }

  void setFrequency(DcaRebalanceFrequency frequency) {
    state = state.copyWith(frequency: frequency);
  }

  void setDriftThreshold(double value) {
    state = state.copyWith(driftThreshold: value);
  }

  void setMinTradeAmount(double value) {
    state = state.copyWith(minTradeAmountUsd: value);
  }
}

final dcaRebalanceConfigStateControllerProvider =
    NotifierProvider<
      DcaRebalanceConfigStateController,
      DcaRebalanceConfigViewState
    >(DcaRebalanceConfigStateController.new);
