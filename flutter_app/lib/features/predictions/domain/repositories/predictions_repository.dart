import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';

/// Data source contract for the Prediction Markets feature: read snapshots
/// for every prediction screen and submit orders.
abstract interface class PredictionsRepository {
  Future<PredictionHomeSnapshot> getHome({
    PredictionFilterTab filter = PredictionFilterTab.trending,
    String? category,
    String searchQuery = '',
  });

  Future<PredictionSearchSnapshot> getSearch({
    PredictionSearchSort sort = PredictionSearchSort.trending,
    PredictionStatusFilter status = PredictionStatusFilter.active,
    String? category,
    String searchQuery = '',
  });

  Future<PredictionBreakingSnapshot> getBreaking({String? category});

  Future<PredictionEventDetailSnapshot> getEventDetail(String eventId);

  Future<PredictionPortfolioSnapshot> getPortfolio();

  Future<PredictionRewardsSnapshot> getRewards();

  Future<PredictionLeaderboardSnapshot> getLeaderboard({
    PredictionLeaderboardTimeFilter timeFilter =
        PredictionLeaderboardTimeFilter.weekly,
    PredictionLeaderboardMetric metric = PredictionLeaderboardMetric.pnl,
  });

  Future<PredictionGlobalActivitySnapshot> getGlobalActivity({
    double minAmount = 0,
  });

  Future<PredictionOrderReceiptSnapshot> getOrderReceipt(String receiptId);

  /// Đường ghi tài chính là async theo ADR-001 — trả về `receiptId` để view
  /// điều hướng trang biên lai (biên lai tự load qua [getOrderReceipt]).
  Future<String> submitOrder({
    required String eventId,
    required String outcome,
    required bool isBuy,
    required bool isMarket,
    required double amount,
  });

  Future<PredictionRiskCalculatorSnapshot> getRiskCalculator();

  Future<PredictionMarketMakerSnapshot> getMarketMaker();

  Future<PredictionPortfolioAnalyzerSnapshot> getPortfolioAnalyzer();

  Future<PredictionEventCalendarSnapshot> getEventCalendar({String? category});

  Future<PredictionSocialSnapshot> getSocial();

  Future<PredictionAdvancedChartSnapshot> getAdvancedChart(String eventId);

  Future<PredictionTournamentsSnapshot> getTournaments();

  Future<PredictionDataIntegrationSnapshot> getDataIntegration();
}
