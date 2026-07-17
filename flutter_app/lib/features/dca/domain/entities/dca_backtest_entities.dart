import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

enum DcaBacktestFrequency { weekly, biweekly, monthly, daily }

enum DcaBacktestStrategy { fixed, valueAverage, buyDips }

class DcaBacktesterSnapshot {
  const DcaBacktesterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.startDate,
    required this.endDate,
    required this.investmentAmountUsd,
    required this.activeFrequency,
    required this.activeStrategy,
    required this.frequencies,
    required this.strategies,
    required this.result,
    required this.historicalData,
    required this.drawdowns,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final List<String> assets;
  final String startDate;
  final String endDate;
  final int investmentAmountUsd;
  final DcaBacktestFrequency activeFrequency;
  final DcaBacktestStrategy activeStrategy;
  final List<DcaBacktestFrequencyOption> frequencies;
  final List<DcaBacktestStrategyOption> strategies;
  final DcaBacktestResult result;
  final List<DcaBacktestPoint> historicalData;
  final List<DcaDrawdownPoint> drawdowns;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaBacktestFrequencyOption {
  const DcaBacktestFrequencyOption({
    required this.frequency,
    required this.label,
  });

  final DcaBacktestFrequency frequency;
  final String label;
}

class DcaBacktestStrategyOption {
  const DcaBacktestStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
  });

  final DcaBacktestStrategy strategy;
  final String title;
  final String subtitle;
}

class DcaBacktestResult {
  const DcaBacktestResult({
    required this.totalInvestedUsd,
    required this.finalValueUsd,
    required this.totalReturnUsd,
    required this.returnPercent,
    required this.avgBuyPriceUsd,
    required this.totalShares,
    required this.maxDrawdownPercent,
    required this.sharpeRatio,
    required this.volatilityPercent,
    required this.winRatePercent,
    required this.numberOfBuys,
  });

  final int totalInvestedUsd;
  final int finalValueUsd;
  final int totalReturnUsd;
  final double returnPercent;
  final int avgBuyPriceUsd;
  final double totalShares;
  final double maxDrawdownPercent;
  final double sharpeRatio;
  final double volatilityPercent;
  final double winRatePercent;
  final int numberOfBuys;
}

class DcaBacktestPoint {
  const DcaBacktestPoint({
    required this.date,
    required this.priceUsd,
    required this.dcaValueUsd,
    required this.lumpValueUsd,
  });

  final String date;
  final int priceUsd;
  final int dcaValueUsd;
  final int lumpValueUsd;
}

class DcaDrawdownPoint {
  const DcaDrawdownPoint({required this.date, required this.drawdownPercent});

  final String date;
  final double drawdownPercent;
}
