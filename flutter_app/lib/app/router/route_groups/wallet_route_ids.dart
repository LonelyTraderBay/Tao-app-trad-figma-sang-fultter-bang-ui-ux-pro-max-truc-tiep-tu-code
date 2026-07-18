final class WalletRoutePaths {
  const WalletRoutePaths._();

  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet/history';
  static const String walletDeposit = '/wallet/deposit';
  static String walletDepositAsset(String asset) => '/wallet/deposit/$asset';
  static const String walletWithdraw = '/wallet/withdraw';
  static String walletWithdrawAsset(String asset) => '/wallet/withdraw/$asset';
  static String walletTransaction(String transactionId) =>
      '/wallet/transaction/$transactionId';
  static const String walletPortfolioAnalytics = '/wallet/portfolio-analytics';
  static const String walletAddressBook = '/wallet/address-book';
  static const String walletAddressBookAdd = '/wallet/address-book/add';
  static const String walletBuyCrypto = '/wallet/buy-crypto';
  static const String walletTransfer = '/wallet/transfer';
  static String walletAsset(String assetId) => '/wallet/asset/$assetId';
  static const String walletMultiManager = '/wallet/multi-manager';
  static const String walletGasOptimizer = '/wallet/gas-optimizer';
  static const String walletTokenApproval = '/wallet/token-approval';
  static const String walletHealthScore = '/wallet/health-score';
  static const String walletPendingDeposits = '/wallet/pending-deposits';
  static const String walletLimits = '/wallet/limits';
  static const String walletDustConverter = '/wallet/dust-converter';
  static const String walletNetworkStatus = '/wallet/network-status';
}

final class WalletRouteNames {
  const WalletRouteNames._();

  static const String sc135Wallet = 'sc135Wallet';
  static const String sc136TxHistory = 'sc136TxHistory';
  static const String sc137Deposit = 'sc137Deposit';
  static const String sc138DepositUsdt = 'sc138DepositUsdt';
  static const String sc139Withdraw = 'sc139Withdraw';
  static const String sc140WithdrawUsdt = 'sc140WithdrawUsdt';
  static const String sc141TransactionDetail = 'sc141TransactionDetail';
  static const String sc142PortfolioAnalytics = 'sc142PortfolioAnalytics';
  static const String sc143AddressAdd = 'sc143AddressAdd';
  static const String sc144AddressBook = 'sc144AddressBook';
  static const String sc145BuyCrypto = 'sc145BuyCrypto';
  static const String sc146Transfer = 'sc146Transfer';
  static const String sc147AssetDetail = 'sc147AssetDetail';
  static const String sc148MultiManager = 'sc148MultiManager';
  static const String sc149GasOptimizer = 'sc149GasOptimizer';
  static const String sc150TokenApproval = 'sc150TokenApproval';
  static const String sc151HealthScore = 'sc151HealthScore';
  static const String sc152PendingDeposits = 'sc152PendingDeposits';
  static const String sc153WithdrawLimits = 'sc153WithdrawLimits';
  static const String sc154DustConverter = 'sc154DustConverter';
  static const String sc155NetworkStatus = 'sc155NetworkStatus';
}
