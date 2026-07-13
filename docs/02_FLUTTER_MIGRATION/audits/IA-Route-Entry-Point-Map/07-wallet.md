# WALLET — Route map (21 routes)

Route group: `wallet_routes`

| # | Path | Page class | EP cha | Phân loại | Menu UI đề xuất |
|--:|------|------------|--------|-----------|-----------------|
| 1 | `'${AppRoutePaths.walletDeposit}/:asset'` | `DepositPage` | EP-08 | ẨN | — Wallet flow (chọn asset) |
| 2 | `'${AppRoutePaths.walletWithdraw}/:asset'` | `WithdrawPage` | EP-09 | ẨN | — Wallet flow (chọn asset) |
| 3 | `'/wallet/asset/:assetId'` | `AssetDetailPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 4 | `'/wallet/transaction/:txId'` | `TransactionDetailPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 5 | `AppRoutePaths.wallet` | `WalletPage` | EP-04 | GIỮ | Bottom Nav → Wallet |
| 6 | `AppRoutePaths.walletAddressBook` | `AddressBookPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 7 | `AppRoutePaths.walletAddressBookAdd` | `AddressAddPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 8 | `AppRoutePaths.walletBuyCrypto` | `BuyCryptoPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 9 | `AppRoutePaths.walletDeposit` | `DepositPage` | EP-08 | GIỮ | Home Hero + Wallet → Nạp |
| 10 | `AppRoutePaths.walletDustConverter` | `DustConverterPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 11 | `AppRoutePaths.walletGasOptimizer` | `WalletGasOptimizerPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 12 | `AppRoutePaths.walletHealthScore` | `WalletHealthScorePage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 13 | `AppRoutePaths.walletHistory` | `TransactionHistoryPage` | EP-04 | HUB | Wallet hub → Dịch vụ ví |
| 14 | `AppRoutePaths.walletLimits` | `WithdrawLimitsPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 15 | `AppRoutePaths.walletMultiManager` | `WalletMultiManagerPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 16 | `AppRoutePaths.walletNetworkStatus` | `NetworkStatusPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 17 | `AppRoutePaths.walletPendingDeposits` | `PendingDepositsPage` | EP-08 | ẨN | — Flow / deep link (không menu) |
| 18 | `AppRoutePaths.walletPortfolioAnalytics` | `PortfolioAnalyticsPage` | EP-04 | HUB | Wallet hub → Dịch vụ ví |
| 19 | `AppRoutePaths.walletTokenApproval` | `WalletTokenApprovalPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 20 | `AppRoutePaths.walletTransfer` | `TransferPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 21 | `AppRoutePaths.walletWithdraw` | `WithdrawPage` | EP-09 | GIỮ | Home Next action + Wallet → Rút |

### Thống kê module

| Phân loại | Số |
|-----------|---:|
| ẨN | 16 |
| GIỮ | 3 |
| HUB | 2 |
