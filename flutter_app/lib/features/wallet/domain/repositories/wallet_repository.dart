import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';

/// Data source contract for the Wallet feature: read snapshots for every
/// wallet screen (balances, transfers, gas, approvals, health, etc.).
///
/// GD4-F2: every method is `Future<T>` (ADR-001's read idiom — see
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md). Mock
/// implementations simulate network latency via `loadDelay`; production
/// implementations will be real network calls with the same signature.
abstract interface class WalletRepository {
  Future<WalletSnapshot> getWallet();
  Future<WalletTransactionHistorySnapshot> getTransactionHistory();
  Future<WalletTransactionDetailSnapshot> getTransactionDetail(
    String transactionId,
  );
  Future<WalletPortfolioAnalyticsSnapshot> getPortfolioAnalytics();
  Future<WalletAddressAddSnapshot> getAddressAdd();
  Future<WalletAddressBookSnapshot> getAddressBook();
  Future<WalletBuyCryptoSnapshot> getBuyCrypto();
  Future<WalletTransferSnapshot> getTransfer();
  Future<WalletAssetDetailSnapshot> getAssetDetail(String assetId);
  Future<WalletMultiManagerSnapshot> getMultiManager();
  Future<WalletGasOptimizerSnapshot> getGasOptimizer();
  Future<WalletTokenApprovalSnapshot> getTokenApprovals();
  Future<WalletHealthScoreSnapshot> getHealthScore();
  Future<WalletPendingDepositsSnapshot> getPendingDeposits();
  Future<WalletWithdrawLimitsSnapshot> getWithdrawLimits();
  Future<WalletDustConverterSnapshot> getDustConverter();
  Future<WalletNetworkStatusSnapshot> getNetworkStatus();
  Future<WalletDepositSnapshot> getDeposit(
    String asset, {
    bool assetScoped = false,
  });
  Future<WalletWithdrawSnapshot> getWithdraw(
    String asset, {
    bool assetScoped = false,
  });
}
