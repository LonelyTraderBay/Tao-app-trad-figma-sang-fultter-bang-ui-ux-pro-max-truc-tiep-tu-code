import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

enum DcaPerformanceWinner { dca, lumpSum }

class DcaPerformanceCompareSnapshot {
  const DcaPerformanceCompareSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.investedUsd,
    required this.comparison,
    required this.metrics,
    required this.scenarios,
    required this.radar,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int investedUsd;
  final List<DcaPerformancePoint> comparison;
  final List<DcaComparisonMetric> metrics;
  final List<DcaVolatilityScenario> scenarios;
  final List<DcaRadarMetric> radar;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  DcaPerformancePoint get finalPoint => comparison.last;

  int get dcaFinalValueUsd => finalPoint.dcaValueUsd;

  int get lumpSumFinalValueUsd => finalPoint.lumpSumValueUsd;

  double get dcaReturnPercent {
    if (investedUsd == 0) return 0;
    return (dcaFinalValueUsd - investedUsd) / investedUsd * 100;
  }

  double get lumpSumReturnPercent {
    if (investedUsd == 0) return 0;
    return (lumpSumFinalValueUsd - investedUsd) / investedUsd * 100;
  }

  double get advantagePercent => dcaReturnPercent - lumpSumReturnPercent;

  DcaPerformanceWinner get winner {
    return advantagePercent >= 0
        ? DcaPerformanceWinner.dca
        : DcaPerformanceWinner.lumpSum;
  }
}

class DcaPerformancePoint {
  const DcaPerformancePoint({
    required this.month,
    required this.dcaValueUsd,
    required this.lumpSumValueUsd,
    required this.priceUsd,
  });

  final String month;
  final int dcaValueUsd;
  final int lumpSumValueUsd;
  final int priceUsd;
}

class DcaComparisonMetric {
  const DcaComparisonMetric({
    required this.label,
    required this.dcaValue,
    required this.lumpSumValue,
    required this.winner,
  });

  final String label;
  final String dcaValue;
  final String lumpSumValue;
  final DcaPerformanceWinner winner;
}

class DcaVolatilityScenario {
  const DcaVolatilityScenario({
    required this.name,
    required this.scenario,
    required this.description,
    required this.dcaAdvantage,
    required this.lumpSumAdvantage,
  });

  final String name;
  final String scenario;
  final String description;
  final int dcaAdvantage;
  final int lumpSumAdvantage;
}

class DcaRadarMetric {
  const DcaRadarMetric({
    required this.metric,
    required this.dcaScore,
    required this.lumpSumScore,
  });

  final String metric;
  final int dcaScore;
  final int lumpSumScore;
}
