import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/p2p_core/data/providers/p2p_repository_provider.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

export 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

final p2pHomeProvider =
    FutureProvider.family<
      P2PHomeSnapshot,
      ({P2PTradeType tradeType, String asset, String fiat})
    >((ref, request) {
      return ref
          .watch(p2pMarketplaceRepositoryProvider)
          .getHome(
            tradeType: request.tradeType,
            asset: request.asset,
            fiat: request.fiat,
          );
    });

final p2pExpressProvider = FutureProvider<P2PExpressSnapshot>(
  (ref) => ref.watch(p2pMarketplaceRepositoryProvider).getExpress(),
);

final p2pExpressConfirmProvider =
    FutureProvider.family<
      P2PExpressConfirmSnapshot,
      ({
        P2PTradeType tradeType,
        String asset,
        double fiatAmount,
        double cryptoAmount,
        String? adId,
        String? paymentMethod,
      })
    >((ref, request) {
      return ref
          .watch(p2pMarketplaceRepositoryProvider)
          .getExpressConfirm(
            tradeType: request.tradeType,
            asset: request.asset,
            fiatAmount: request.fiatAmount,
            cryptoAmount: request.cryptoAmount,
            adId: request.adId,
            paymentMethod: request.paymentMethod,
          );
    });

final p2pAdAnalyticsProvider =
    FutureProvider.family<P2PAdAnalyticsSnapshot, String>(
      (ref, adId) =>
          ref.watch(p2pMarketplaceRepositoryProvider).getAdAnalytics(adId),
    );

final p2pAdDetailProvider = FutureProvider.family<P2PAdDetailSnapshot, String>(
  (ref, adId) => ref.watch(p2pMarketplaceRepositoryProvider).getAdDetail(adId),
);

final p2pMyAdsProvider = FutureProvider<P2PMyAdsSnapshot>(
  (ref) => ref.watch(p2pMarketplaceRepositoryProvider).getMyAds(),
);

final p2pCreateAdProvider = FutureProvider<P2PCreateAdSnapshot>(
  (ref) => ref.watch(p2pMarketplaceRepositoryProvider).getCreateAd(),
);

final p2pTradingLevelProvider = FutureProvider<P2PTradingLevelSnapshot>(
  (ref) => ref.watch(p2pMarketplaceRepositoryProvider).getTradingLevel(),
);

final p2pOrderBookProvider =
    FutureProvider.family<P2POrderBookSnapshot, String>(
      (ref, selectedAsset) => ref
          .watch(p2pMarketplaceRepositoryProvider)
          .getOrderBook(selectedAsset: selectedAsset),
    );

final p2pDashboardProvider =
    FutureProvider.family<P2PDashboardSnapshot, String>(
      (ref, timeFilter) => ref
          .watch(p2pMarketplaceRepositoryProvider)
          .getDashboard(timeFilter: timeFilter),
    );

final p2pNotificationSettingsProvider =
    FutureProvider<P2PNotificationSettingsSnapshot>(
      (ref) =>
          ref.watch(p2pMarketplaceRepositoryProvider).getNotificationSettings(),
    );

final p2pSettingsProvider = FutureProvider<P2PSettingsSnapshot>(
  (ref) => ref.watch(p2pMarketplaceRepositoryProvider).getSettings(),
);

final p2pGuideProvider = FutureProvider<P2PGuideSnapshot>(
  (ref) => ref.watch(p2pMarketplaceRepositoryProvider).getGuide(),
);
