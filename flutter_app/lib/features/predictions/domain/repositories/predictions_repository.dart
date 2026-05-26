import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';

abstract interface class PredictionsRepository {
  PredictionHomeSnapshot getHome({
    PredictionFilterTab filter = PredictionFilterTab.trending,
    String? category,
    String searchQuery = '',
  });

  PredictionSearchSnapshot getSearch({
    PredictionSearchSort sort = PredictionSearchSort.trending,
    PredictionStatusFilter status = PredictionStatusFilter.active,
    String? category,
    String searchQuery = '',
  });

  PredictionBreakingSnapshot getBreaking({String? category});

  PredictionEventDetailSnapshot getEventDetail(String eventId);

  PredictionPortfolioSnapshot getPortfolio();

  PredictionRewardsSnapshot getRewards();

  PredictionLeaderboardSnapshot getLeaderboard({
    PredictionLeaderboardTimeFilter timeFilter =
        PredictionLeaderboardTimeFilter.weekly,
    PredictionLeaderboardMetric metric = PredictionLeaderboardMetric.pnl,
  });

  PredictionGlobalActivitySnapshot getGlobalActivity({double minAmount = 0});

  PredictionOrderReceiptSnapshot getOrderReceipt(String receiptId);

  PredictionRiskCalculatorSnapshot getRiskCalculator();

  PredictionMarketMakerSnapshot getMarketMaker();

  PredictionPortfolioAnalyzerSnapshot getPortfolioAnalyzer();

  PredictionEventCalendarSnapshot getEventCalendar({String? category});

  PredictionSocialSnapshot getSocial();

  PredictionAdvancedChartSnapshot getAdvancedChart(String eventId);

  PredictionTournamentsSnapshot getTournaments();

  PredictionDataIntegrationSnapshot getDataIntegration();
}
