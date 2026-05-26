part of '../app_router.dart';

List<RouteBase> _walletRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.wallet,
      name: AppRouteNames.sc135Wallet,
      builder: (_, _) => WalletPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletHistory,
      name: AppRouteNames.sc136TxHistory,
      builder: (_, _) =>
          TransactionHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletDeposit,
      name: AppRouteNames.sc137Deposit,
      builder: (_, _) => DepositPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '${AppRoutePaths.walletDeposit}/:asset',
      name: AppRouteNames.sc138DepositUsdt,
      builder: (_, state) => DepositPage(
        asset: state.pathParameters['asset'] ?? 'USDT',
        assetScoped: true,
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.walletWithdraw,
      name: AppRouteNames.sc139Withdraw,
      builder: (_, _) => WithdrawPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '${AppRoutePaths.walletWithdraw}/:asset',
      name: AppRouteNames.sc140WithdrawUsdt,
      builder: (_, state) => WithdrawPage(
        asset: state.pathParameters['asset'] ?? 'USDT',
        assetScoped: true,
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/wallet/transaction/:txId',
      name: AppRouteNames.sc141TransactionDetail,
      builder: (_, state) => TransactionDetailPage(
        transactionId: state.pathParameters['txId'] ?? 'tx001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.walletPortfolioAnalytics,
      name: AppRouteNames.sc142PortfolioAnalytics,
      builder: (_, _) =>
          PortfolioAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletAddressBookAdd,
      name: AppRouteNames.sc143AddressAdd,
      builder: (_, _) => AddressAddPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletAddressBook,
      name: AppRouteNames.sc144AddressBook,
      builder: (_, _) => AddressBookPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletBuyCrypto,
      name: AppRouteNames.sc145BuyCrypto,
      builder: (_, _) => BuyCryptoPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletTransfer,
      name: AppRouteNames.sc146Transfer,
      builder: (_, _) => TransferPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/wallet/asset/:assetId',
      name: AppRouteNames.sc147AssetDetail,
      builder: (_, state) => AssetDetailPage(
        assetId: state.pathParameters['assetId'] ?? 'btc',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.walletMultiManager,
      name: AppRouteNames.sc148MultiManager,
      builder: (_, _) =>
          WalletMultiManagerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletGasOptimizer,
      name: AppRouteNames.sc149GasOptimizer,
      builder: (_, _) =>
          WalletGasOptimizerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletTokenApproval,
      name: AppRouteNames.sc150TokenApproval,
      builder: (_, _) =>
          WalletTokenApprovalPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletHealthScore,
      name: AppRouteNames.sc151HealthScore,
      builder: (_, _) =>
          WalletHealthScorePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletPendingDeposits,
      name: AppRouteNames.sc152PendingDeposits,
      builder: (_, _) => PendingDepositsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletLimits,
      name: AppRouteNames.sc153WithdrawLimits,
      builder: (_, _) => WithdrawLimitsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletDustConverter,
      name: AppRouteNames.sc154DustConverter,
      builder: (_, _) => DustConverterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletNetworkStatus,
      name: AppRouteNames.sc155NetworkStatus,
      builder: (_, _) => NetworkStatusPage(shellRenderMode: shellRenderMode),
    ),
    ..._walletOutgoingPlaceholders,
  ];
}
