import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

void main() {
  group('MarketController', () {
    test('exposes core market read models through repository contract', () {
      final controller = const MarketController(MockMarketRepository());

      final list = controller.getMarketList();
      final overview = controller.getMarketOverview();
      final alerts = controller.getPriceAlerts();

      expect(list.marketPairs, isNotEmpty);
      expect(list.supportedStates, contains(MarketScreenState.offline));
      expect(overview.globalStats.totalCoins, greaterThan(0));
      expect(alerts.priceAlerts, isNotEmpty);
    });

    test('forwards filter parameters to advanced market read models', () {
      final controller = const MarketController(MockMarketRepository());

      final depth = controller.getMarketDepth(pairId: 'ethusdt', levels: 5);
      final news = controller.getMarketNews(category: 'defi');
      final correlations = controller.getMarketCorrelations(
        timeframe: MarketCorrelationTimeframe.d30,
      );

      expect(depth.pair.id, 'ethusdt');
      expect(news.news, isNotEmpty);
      expect(correlations.timeframe, MarketCorrelationTimeframe.d30);
    });
  });
}
