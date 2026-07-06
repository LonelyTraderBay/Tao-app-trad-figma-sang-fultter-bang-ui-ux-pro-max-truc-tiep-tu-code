part of 'p2p_entities.dart';

final class P2PHomeSnapshot {
  const P2PHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.defaultTradeType,
    required this.selectedTradeType,
    required this.selectedAsset,
    required this.selectedFiat,
    required this.assets,
    required this.fiatCurrencies,
    required this.searchHint,
    required this.quickActions,
    required this.platformStats,
    required this.ads,
    required this.expressRoute,
    required this.createRoute,
    required this.myOrdersRoute,
    required this.tradingLevelRoute,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
    this.highRiskContractId,
    this.currentState = P2PScreenState.realtimeRefresh,
    this.lastUpdatedLabel = '',
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2PTradeType defaultTradeType;
  final P2PTradeType selectedTradeType;
  final String selectedAsset;
  final String selectedFiat;
  final List<String> assets;
  final List<String> fiatCurrencies;
  final String searchHint;
  final List<P2PHomeQuickActionDraft> quickActions;
  final P2PHomePlatformStatsDraft platformStats;
  final List<P2PAdDraft> ads;
  final String expressRoute;
  final String createRoute;
  final String myOrdersRoute;
  final String tradingLevelRoute;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
  final String? highRiskContractId;
  final P2PScreenState currentState;
  final String lastUpdatedLabel;

  P2PHomeSnapshot copyWith({
    P2PScreenState? currentState,
    String? lastUpdatedLabel,
    List<P2PAdDraft>? ads,
  }) {
    return P2PHomeSnapshot(
      endpoint: endpoint,
      actionDraft: actionDraft,
      supportedStates: supportedStates,
      title: title,
      subtitle: subtitle,
      defaultTradeType: defaultTradeType,
      selectedTradeType: selectedTradeType,
      selectedAsset: selectedAsset,
      selectedFiat: selectedFiat,
      assets: assets,
      fiatCurrencies: fiatCurrencies,
      searchHint: searchHint,
      quickActions: quickActions,
      platformStats: platformStats,
      ads: ads ?? this.ads,
      expressRoute: expressRoute,
      createRoute: createRoute,
      myOrdersRoute: myOrdersRoute,
      tradingLevelRoute: tradingLevelRoute,
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      contractNotes: contractNotes,
      highRiskContractId: highRiskContractId,
      currentState: currentState ?? this.currentState,
      lastUpdatedLabel: lastUpdatedLabel ?? this.lastUpdatedLabel,
    );
  }
}

final class P2PHomeQuickActionDraft {
  const P2PHomeQuickActionDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    required this.route,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
  final String route;
  final String toneKey;
}

final class P2PHomePlatformStatsDraft {
  const P2PHomePlatformStatsDraft({
    required this.volume24h,
    required this.volume24hChange,
    required this.totalTrades24h,
    required this.activeMerchants,
    required this.onlineTraders,
    required this.avgCompletionRate,
    required this.avgCompletionTime,
    required this.escrowProtected,
  });

  final int volume24h;
  final double volume24hChange;
  final int totalTrades24h;
  final int activeMerchants;
  final int onlineTraders;
  final double avgCompletionRate;
  final String avgCompletionTime;
  final int escrowProtected;
}

final class P2PExpressConfirmSnapshot {
  const P2PExpressConfirmSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.tradeType,
    required this.asset,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.paymentMethod,
    required this.ad,
    required this.order,
    required this.escrowNote,
    required this.warningNote,
    required this.contractNotes,
    this.highRiskContractId,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PTradeType tradeType;
  final String asset;
  final double fiatAmount;
  final double cryptoAmount;
  final String paymentMethod;
  final P2PAdDraft ad;
  final P2POrderDraft order;
  final String escrowNote;
  final String warningNote;
  final String contractNotes;
  final String? highRiskContractId;

  bool get isBuy => tradeType == P2PTradeType.buy;
}

final class P2PExpressSnapshot {
  const P2PExpressSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.quickAmountsVnd,
    required this.paymentMethods,
    required this.ads,
    required this.escrowTitle,
    required this.escrowBuyNote,
    required this.escrowSellNote,
    required this.steps,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PAssetDraft> assets;
  final List<int> quickAmountsVnd;
  final List<P2PPaymentMethodDraft> paymentMethods;
  final List<P2PAdDraft> ads;
  final String escrowTitle;
  final String escrowBuyNote;
  final String escrowSellNote;
  final List<P2PExpressStepDraft> steps;
  final String contractNotes;

  P2PAssetDraft assetBySymbol(String symbol) {
    return assets.firstWhere(
      (asset) => asset.symbol == symbol,
      orElse: () => assets.first,
    );
  }

  List<P2PAdDraft> topAds({
    required P2PTradeType tradeType,
    required String asset,
    required int fiatAmount,
  }) {
    final adType = tradeType == P2PTradeType.buy
        ? P2PTradeType.sell
        : P2PTradeType.buy;
    final candidates =
        ads
            .where((ad) => ad.type == adType && ad.asset == asset && ad.active)
            .where(
              (ad) =>
                  fiatAmount <= 0 ||
                  (fiatAmount >= ad.minLimit && fiatAmount <= ad.maxLimit),
            )
            .toList()
          ..sort(
            (a, b) => tradeType == P2PTradeType.buy
                ? a.price.compareTo(b.price)
                : b.price.compareTo(a.price),
          );
    return candidates.take(3).toList();
  }

  P2PAdDraft? bestAd({
    required P2PTradeType tradeType,
    required String asset,
    required int fiatAmount,
    String? paymentMethod,
  }) {
    if (fiatAmount <= 0) return null;
    final candidates =
        topAds(
          tradeType: tradeType,
          asset: asset,
          fiatAmount: fiatAmount,
        ).where(
          (ad) =>
              paymentMethod == null ||
              paymentMethod.isEmpty ||
              ad.paymentMethods.contains(paymentMethod),
        );
    return candidates.isEmpty ? null : candidates.first;
  }
}

final class P2PAssetDraft {
  const P2PAssetDraft({
    required this.symbol,
    required this.name,
    required this.marketPriceVnd,
  });

  final String symbol;
  final String name;
  final int marketPriceVnd;
}

final class P2PPaymentMethodDraft {
  const P2PPaymentMethodDraft({
    required this.id,
    required this.bankName,
    required this.isVerified,
  });

  final String id;
  final String bankName;
  final bool isVerified;
}

final class P2PExpressStepDraft {
  const P2PExpressStepDraft({required this.title, required this.iconKey});

  final String title;
  final String iconKey;
}
