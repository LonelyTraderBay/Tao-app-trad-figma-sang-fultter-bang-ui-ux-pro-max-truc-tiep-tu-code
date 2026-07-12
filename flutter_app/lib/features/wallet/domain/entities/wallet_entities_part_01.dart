part of 'wallet_entities.dart';

enum WalletScreenState {
  loading,
  empty,
  error,
  offline,
  realtimeRefresh,
  submitting,
  success,
}

final class WalletSnapshot {
  const WalletSnapshot({
    required this.totalUsd,
    required this.totalBtc,
    required this.availableUsd,
    required this.inOrderUsd,
    required this.frozenUsd,
    required this.actions,
    required this.dca,
    required this.tools,
    required this.assets,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double totalUsd;
  final double totalBtc;
  final double availableUsd;
  final double inOrderUsd;
  final double frozenUsd;
  final List<WalletAction> actions;
  final WalletDcaSnapshot dca;
  final List<WalletTool> tools;
  final List<WalletAsset> assets;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletAction {
  const WalletAction({
    required this.id,
    required this.label,
    required this.route,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final int colorHex;
  final String iconKey;
}

final class WalletDcaSnapshot {
  const WalletDcaSnapshot({
    required this.title,
    required this.subtitle,
    required this.returnLabel,
    required this.activePlans,
    required this.invested,
    required this.nextTrade,
  });

  final String title;
  final String subtitle;
  final String returnLabel;
  final int activePlans;
  final double invested;
  final String nextTrade;
}

final class WalletTool {
  const WalletTool({
    required this.id,
    required this.label,
    required this.route,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final int colorHex;
  final String iconKey;
}

final class WalletAsset {
  const WalletAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.balance,
    required this.usdValue,
    required this.change24h,
    required this.colorHex,
  });

  final String id;
  final String symbol;
  final String name;
  final double balance;
  final double usdValue;
  final double change24h;
  final int colorHex;
}

final class WalletTransactionHistorySnapshot {
  const WalletTransactionHistorySnapshot({
    required this.transactions,
    required this.filters,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletTransaction> transactions;
  final List<WalletTransactionFilter> filters;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletTransactionDetailSnapshot {
  const WalletTransactionDetailSnapshot({
    required this.transaction,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final WalletTransaction? transaction;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletPortfolioAnalyticsSnapshot {
  const WalletPortfolioAnalyticsSnapshot({
    required this.totalUsd,
    required this.totalReturnUsd,
    required this.totalReturnPct,
    required this.bestProfitUsd,
    required this.bestProfitAsset,
    required this.worstLossUsd,
    required this.worstLossAsset,
    required this.assets,
    required this.periods,
    required this.activePeriod,
    required this.history,
    required this.metrics,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double totalUsd;
  final double totalReturnUsd;
  final double totalReturnPct;
  final double bestProfitUsd;
  final String bestProfitAsset;
  final double worstLossUsd;
  final String worstLossAsset;
  final List<WalletAsset> assets;
  final List<String> periods;
  final String activePeriod;
  final List<WalletPortfolioPoint> history;
  final List<WalletPortfolioMetric> metrics;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletPortfolioPoint {
  const WalletPortfolioPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class WalletPortfolioMetric {
  const WalletPortfolioMetric({
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String label;
  final String value;
  final int colorHex;
}

final class WalletAddressAddSnapshot {
  const WalletAddressAddSnapshot({
    required this.networks,
    required this.assets,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.auditTrailNote,
    this.highRiskContractId,
  });

  final List<WalletAddressNetwork> networks;
  final List<String> assets;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
  final String auditTrailNote;
  final String? highRiskContractId;
}

final class WalletAddressNetwork {
  const WalletAddressNetwork({
    required this.id,
    required this.label,
    required this.colorHex,
    required this.addressHint,
  });

  final String id;
  final String label;
  final int colorHex;
  final String addressHint;
}

final class WalletAddressBookSnapshot {
  const WalletAddressBookSnapshot({
    required this.addresses,
    required this.networkFilters,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletSavedAddress> addresses;
  final List<String> networkFilters;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletSavedAddress {
  const WalletSavedAddress({
    required this.id,
    required this.label,
    required this.address,
    required this.network,
    required this.asset,
    required this.isFavorite,
    required this.createdAt,
    required this.isWhitelisted,
    this.lastUsed,
  });

  final String id;
  final String label;
  final String address;
  final String network;
  final String asset;
  final bool isFavorite;
  final String createdAt;
  final bool isWhitelisted;
  final String? lastUsed;

  WalletSavedAddress copyWith({bool? isFavorite, bool? isWhitelisted}) {
    return WalletSavedAddress(
      id: id,
      label: label,
      address: address,
      network: network,
      asset: asset,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      isWhitelisted: isWhitelisted ?? this.isWhitelisted,
      lastUsed: lastUsed,
    );
  }
}

final class WalletBuyCryptoSnapshot {
  const WalletBuyCryptoSnapshot({
    required this.cryptoOptions,
    required this.paymentMethods,
    required this.presetAmounts,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletBuyCryptoOption> cryptoOptions;
  final List<WalletPaymentMethod> paymentMethods;
  final List<int> presetAmounts;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletBuyCryptoOption {
  const WalletBuyCryptoOption({
    required this.symbol,
    required this.name,
    required this.colorHex,
    required this.minBuyVnd,
    required this.priceVnd,
  });

  final String symbol;
  final String name;
  final int colorHex;
  final int minBuyVnd;
  final int priceVnd;
}

enum WalletPaymentMethodType { bank, ewallet, qr }

final class WalletPaymentMethod {
  const WalletPaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.logo,
    required this.logoColorHex,
    required this.processingTime,
    required this.feeVnd,
    required this.dailyLimitLabel,
    this.isPopular = false,
  });

  final String id;
  final String name;
  final WalletPaymentMethodType type;
  final String logo;
  final int logoColorHex;
  final String processingTime;
  final int feeVnd;
  final String dailyLimitLabel;
  final bool isPopular;
}

final class WalletTransferSnapshot {
  const WalletTransferSnapshot({
    required this.wallets,
    required this.assets,
    required this.recentTransfers,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletTransferWallet> wallets;
  final List<WalletTransferAsset> assets;
  final List<WalletRecentTransfer> recentTransfers;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletTransferWallet {
  const WalletTransferWallet({
    required this.id,
    required this.name,
    required this.balanceUsd,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String name;
  final double balanceUsd;
  final int colorHex;
  final String iconKey;
}

final class WalletTransferAsset {
  const WalletTransferAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.available,
    required this.usdRate,
    required this.colorHex,
  });

  final String id;
  final String symbol;
  final String name;
  final double available;
  final double usdRate;
  final int colorHex;
}

final class WalletRecentTransfer {
  const WalletRecentTransfer({
    required this.fromWallet,
    required this.toWallet,
    required this.asset,
    required this.amount,
    required this.time,
  });

  final String fromWallet;
  final String toWallet;
  final String asset;
  final double amount;
  final String time;
}

final class WalletAssetDetailSnapshot {
  const WalletAssetDetailSnapshot({
    required this.assetId,
    required this.name,
    required this.symbol,
    required this.colorHex,
    required this.balance,
    required this.usdValue,
    required this.change24h,
    required this.available,
    required this.inOrder,
    required this.frozen,
    required this.currentPrice,
    required this.actions,
    required this.chart,
    required this.transactions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String assetId;
  final String name;
  final String symbol;
  final int colorHex;
  final double balance;
  final double usdValue;
  final double change24h;
  final double available;
  final double inOrder;
  final double frozen;
  final double currentPrice;
  final List<WalletAssetDetailAction> actions;
  final List<WalletAssetChartPoint> chart;
  final List<WalletAssetDetailTransaction> transactions;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletAssetDetailAction {
  const WalletAssetDetailAction({
    required this.id,
    required this.label,
    required this.route,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final int colorHex;
  final String iconKey;
}

final class WalletAssetChartPoint {
  const WalletAssetChartPoint({required this.index, required this.price});

  final int index;
  final double price;
}
