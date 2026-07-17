import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

enum DcaPortfolioAssetAccent { btc, eth, usdt, sol, bnb }

enum DcaPortfolioSuggestionType { increase, decrease, add, remove }

class DcaPortfolioOptimizerSnapshot {
  const DcaPortfolioOptimizerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.score,
    required this.driftPercent,
    required this.driftThresholdPercent,
    required this.optimalSharpe,
    required this.optimalReturnPercent,
    required this.optimalRiskPercent,
    required this.currentAllocations,
    required this.frontier,
    required this.suggestions,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int score;
  final double driftPercent;
  final double driftThresholdPercent;
  final double optimalSharpe;
  final double optimalReturnPercent;
  final double optimalRiskPercent;
  final List<DcaPortfolioAllocation> currentAllocations;
  final List<DcaFrontierPoint> frontier;
  final List<DcaPortfolioSuggestion> suggestions;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaPortfolioAllocation {
  const DcaPortfolioAllocation({
    required this.symbol,
    required this.name,
    required this.currentPercent,
    required this.optimalPercent,
    required this.accent,
  });

  final String symbol;
  final String name;
  final double currentPercent;
  final double optimalPercent;
  final DcaPortfolioAssetAccent accent;

  double get diffPercent => optimalPercent - currentPercent;
}

class DcaFrontierPoint {
  const DcaFrontierPoint({
    required this.label,
    required this.riskPercent,
    required this.returnPercent,
    required this.sharpe,
  });

  final String label;
  final double riskPercent;
  final double returnPercent;
  final double sharpe;
}

class DcaPortfolioSuggestion {
  const DcaPortfolioSuggestion({
    required this.type,
    required this.symbol,
    required this.currentPercent,
    required this.suggestedPercent,
    required this.reason,
  });

  final DcaPortfolioSuggestionType type;
  final String symbol;
  final double currentPercent;
  final double suggestedPercent;
  final String reason;
}
