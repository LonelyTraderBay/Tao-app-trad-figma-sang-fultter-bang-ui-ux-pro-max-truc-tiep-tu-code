import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';

/// Data source contract for the Wallet feature: read snapshots for every
/// wallet screen (balances, transfers, gas, approvals, health, etc.).
abstract interface class WalletRepository {
  WalletSnapshot getWallet();
  WalletTransactionHistorySnapshot getTransactionHistory();
  WalletTransactionDetailSnapshot getTransactionDetail(String transactionId);
  WalletPortfolioAnalyticsSnapshot getPortfolioAnalytics();
  WalletAddressAddSnapshot getAddressAdd();
  WalletAddressBookSnapshot getAddressBook();
  WalletBuyCryptoSnapshot getBuyCrypto();
  WalletTransferSnapshot getTransfer();
  WalletAssetDetailSnapshot getAssetDetail(String assetId);
  WalletMultiManagerSnapshot getMultiManager();
  WalletGasOptimizerSnapshot getGasOptimizer();
  WalletTokenApprovalSnapshot getTokenApprovals();
  WalletHealthScoreSnapshot getHealthScore();
  WalletPendingDepositsSnapshot getPendingDeposits();
  WalletWithdrawLimitsSnapshot getWithdrawLimits();
  WalletDustConverterSnapshot getDustConverter();
  WalletNetworkStatusSnapshot getNetworkStatus();
  WalletDepositSnapshot getDeposit(String asset, {bool assetScoped = false});
  WalletWithdrawSnapshot getWithdraw(String asset, {bool assetScoped = false});
}
