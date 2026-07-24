import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_entities.dart';

/// Marketplace slice of [P2PRepository] (hub, ads, express, guide, settings).
abstract interface class P2PMarketplaceRepository {
  Future<P2PHomeSnapshot> getHome({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    String fiat = 'VND',
  });

  Future<P2PExpressSnapshot> getExpress();

  Future<P2PExpressConfirmSnapshot> getExpressConfirm({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    double fiatAmount = 0,
    double cryptoAmount = 0,
    String? adId,
    String? paymentMethod,
  });

  Future<P2PAdAnalyticsSnapshot> getAdAnalytics(String adId);

  Future<P2PAdDetailSnapshot> getAdDetail(String adId);

  Future<P2PMyAdsSnapshot> getMyAds();

  Future<P2PCreateAdSnapshot> getCreateAd();

  Future<P2PTradingLevelSnapshot> getTradingLevel();

  Future<P2POrderBookSnapshot> getOrderBook({String selectedAsset = 'USDT'});

  Future<P2PDashboardSnapshot> getDashboard({String timeFilter = '30d'});

  Future<P2PNotificationSettingsSnapshot> getNotificationSettings();

  Future<P2PSettingsSnapshot> getSettings();

  Future<P2PGuideSnapshot> getGuide();
}
