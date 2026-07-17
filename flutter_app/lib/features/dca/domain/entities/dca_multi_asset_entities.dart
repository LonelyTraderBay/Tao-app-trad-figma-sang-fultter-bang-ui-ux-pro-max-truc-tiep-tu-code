import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

enum DcaMultiAssetFrequency { weekly, monthly }

class DcaMultiAssetSnapshot {
  const DcaMultiAssetSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalBudgetUsd,
    required this.activeFrequency,
    required this.rebalanceEnabled,
    required this.rebalanceThresholdPercent,
    required this.allocations,
    required this.performance,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int totalBudgetUsd;
  final DcaMultiAssetFrequency activeFrequency;
  final bool rebalanceEnabled;
  final double rebalanceThresholdPercent;
  final List<DcaMultiAssetAllocation> allocations;
  final List<DcaMultiAssetPerformancePoint> performance;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  int get totalInvestedUsd {
    return allocations.fold(0, (sum, asset) => sum + asset.totalInvestedUsd);
  }

  int get currentValueUsd {
    return allocations.fold(0, (sum, asset) => sum + asset.currentValueUsd);
  }

  int get totalReturnUsd => currentValueUsd - totalInvestedUsd;

  double get totalReturnPercent {
    if (totalInvestedUsd == 0) return 0;
    return totalReturnUsd / totalInvestedUsd * 100;
  }

  bool get needsRebalance {
    return allocations.any(
      (asset) =>
          (asset.currentPercent - asset.targetPercent).abs() >
          rebalanceThresholdPercent,
    );
  }
}

class DcaMultiAssetAllocation {
  const DcaMultiAssetAllocation({
    required this.id,
    required this.symbol,
    required this.assetName,
    required this.targetPercent,
    required this.currentPercent,
    required this.amountPerPeriodUsd,
    required this.totalInvestedUsd,
    required this.currentValueUsd,
    required this.shares,
    required this.averagePriceUsd,
  });

  final String id;
  final String symbol;
  final String assetName;
  final double targetPercent;
  final double currentPercent;
  final int amountPerPeriodUsd;
  final int totalInvestedUsd;
  final int currentValueUsd;
  final double shares;
  final int averagePriceUsd;

  int get returnUsd => currentValueUsd - totalInvestedUsd;

  double get returnPercent {
    if (totalInvestedUsd == 0) return 0;
    return returnUsd / totalInvestedUsd * 100;
  }
}

class DcaMultiAssetPerformancePoint {
  const DcaMultiAssetPerformancePoint({
    required this.month,
    required this.btcUsd,
    required this.ethUsd,
    required this.bnbUsd,
    required this.solUsd,
  });

  final String month;
  final int btcUsd;
  final int ethUsd;
  final int bnbUsd;
  final int solUsd;

  int get totalUsd => btcUsd + ethUsd + bnbUsd + solUsd;
}
