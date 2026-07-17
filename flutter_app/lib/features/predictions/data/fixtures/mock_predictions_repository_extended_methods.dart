part of '../repositories/mock_predictions_repository.dart';

mixin _MockPredictionsRepositoryMethodsPart02
    on _MockPredictionsRepositoryBase {
  @override
  PredictionEventCalendarSnapshot getEventCalendar({String? category}) {
    final events = category == null
        ? _predictionCalendarEvents
        : _predictionCalendarEvents
              .where((event) => event.category == category)
              .toList();
    return PredictionEventCalendarSnapshot(
      events: events,
      categories: _predictionCalendarCategories,
      selectedCategory: category,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionSocialSnapshot getSocial() {
    return PredictionSocialSnapshot(
      eventTitle: 'BTC > \$100K by Dec 2026?',
      comments: _predictionSocialComments,
      sentiment: _predictionSocialSentiment,
      contributors: _predictionSocialContributors,
      shareUrl: 'https://app.example.com/predictions/event/pred-1',
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionAdvancedChartSnapshot getAdvancedChart(String eventId) {
    return PredictionAdvancedChartSnapshot(
      eventId: eventId,
      priceHistory: _predictionAdvancedPriceHistory,
      orderFlow: _predictionAdvancedOrderFlow,
      indicators: _predictionAdvancedIndicators,
      patterns: _predictionAdvancedPatterns,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionTournamentsSnapshot getTournaments() {
    return PredictionTournamentsSnapshot(
      tournaments: _predictionTournaments,
      leaderboard: _predictionTournamentLeaderboard,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionDataIntegrationSnapshot getDataIntegration() {
    return PredictionDataIntegrationSnapshot(
      sources: _predictionDataSources,
      apiKeys: _predictionApiKeys,
      webhooks: _predictionWebhooks,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }
}
