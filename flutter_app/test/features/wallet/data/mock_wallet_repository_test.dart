import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

/// Smoke test for [MockWalletRepository]: exercises every method on
/// [WalletRepository] and asserts each call succeeds without throwing and
/// returns a plausible, non-empty result.
void main() {
  const repository = MockWalletRepository();

  group('MockWalletRepository smoke test', () {
    test('getWallet returns a populated snapshot', () {
      final snapshot = repository.getWallet();

      expect(snapshot, isA<WalletSnapshot>());
      expect(snapshot.actions, isNotEmpty);
      expect(snapshot.tools, isNotEmpty);
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getTransactionHistory returns a populated snapshot', () {
      final snapshot = repository.getTransactionHistory();

      expect(snapshot, isA<WalletTransactionHistorySnapshot>());
      expect(snapshot.transactions, isNotEmpty);
      expect(snapshot.filters, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getTransactionDetail returns the matching transaction for a known id',
      () {
        final snapshot = repository.getTransactionDetail('tx001');

        expect(snapshot, isA<WalletTransactionDetailSnapshot>());
        expect(snapshot.transaction, isNotNull);
        expect(snapshot.transaction?.id, 'tx001');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getTransactionDetail does not throw for an unknown id and falls '
        'back to a null transaction', () {
      late final WalletTransactionDetailSnapshot snapshot;

      expect(
        () => snapshot = repository.getTransactionDetail('does-not-exist'),
        returnsNormally,
      );
      expect(snapshot, isA<WalletTransactionDetailSnapshot>());
      expect(snapshot.transaction, isNull);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getPortfolioAnalytics returns a populated snapshot', () {
      final snapshot = repository.getPortfolioAnalytics();

      expect(snapshot, isA<WalletPortfolioAnalyticsSnapshot>());
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.periods, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.metrics, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getAddressAdd returns a populated snapshot', () {
      final snapshot = repository.getAddressAdd();

      expect(snapshot, isA<WalletAddressAddSnapshot>());
      expect(snapshot.networks, isNotEmpty);
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getAddressBook returns a populated snapshot', () {
      final snapshot = repository.getAddressBook();

      expect(snapshot, isA<WalletAddressBookSnapshot>());
      expect(snapshot.addresses, isNotEmpty);
      expect(snapshot.networkFilters, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getBuyCrypto returns a populated snapshot', () {
      final snapshot = repository.getBuyCrypto();

      expect(snapshot, isA<WalletBuyCryptoSnapshot>());
      expect(snapshot.cryptoOptions, isNotEmpty);
      expect(snapshot.paymentMethods, isNotEmpty);
      expect(snapshot.presetAmounts, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getTransfer returns a populated snapshot', () {
      final snapshot = repository.getTransfer();

      expect(snapshot, isA<WalletTransferSnapshot>());
      expect(snapshot.wallets, isNotEmpty);
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.recentTransfers, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getAssetDetail returns a populated snapshot for a known asset', () {
      final snapshot = repository.getAssetDetail('btc');

      expect(snapshot, isA<WalletAssetDetailSnapshot>());
      expect(snapshot.assetId, 'btc');
      expect(snapshot.symbol, 'BTC');
      expect(snapshot.actions, isNotEmpty);
      expect(snapshot.chart, isNotEmpty);
      expect(snapshot.transactions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getAssetDetail does not throw for an unrecognized asset id and '
        'falls back to the default fixture', () {
      late final WalletAssetDetailSnapshot snapshot;

      expect(
        () => snapshot = repository.getAssetDetail('does-not-exist'),
        returnsNormally,
      );
      expect(snapshot, isA<WalletAssetDetailSnapshot>());
      expect(snapshot.symbol, isNotEmpty);
    });

    test('getMultiManager returns a populated snapshot', () {
      final snapshot = repository.getMultiManager();

      expect(snapshot, isA<WalletMultiManagerSnapshot>());
      expect(snapshot.wallets, isNotEmpty);
      expect(snapshot.groups, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getGasOptimizer returns a populated snapshot', () {
      final snapshot = repository.getGasOptimizer();

      expect(snapshot, isA<WalletGasOptimizerSnapshot>());
      expect(snapshot.levels, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.networkActivity, isNotEmpty);
      expect(snapshot.comparisons, isNotEmpty);
      expect(snapshot.tips, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getTokenApprovals returns a populated snapshot', () {
      final snapshot = repository.getTokenApprovals();

      expect(snapshot, isA<WalletTokenApprovalSnapshot>());
      expect(snapshot.approvals, isNotEmpty);
      expect(snapshot.revokedApprovals, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getHealthScore returns a populated snapshot', () {
      final snapshot = repository.getHealthScore();

      expect(snapshot, isA<WalletHealthScoreSnapshot>());
      expect(snapshot.metrics, isNotEmpty);
      expect(snapshot.diversification, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.recommendations, isNotEmpty);
      expect(snapshot.securityChecklist, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getPendingDeposits returns a populated snapshot', () {
      final snapshot = repository.getPendingDeposits();

      expect(snapshot, isA<WalletPendingDepositsSnapshot>());
      expect(snapshot.deposits, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getWithdrawLimits returns a populated snapshot', () {
      final snapshot = repository.getWithdrawLimits();

      expect(snapshot, isA<WalletWithdrawLimitsSnapshot>());
      expect(snapshot.tiers, isNotEmpty);
      expect(snapshot.faqs, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDustConverter returns a populated snapshot', () {
      final snapshot = repository.getDustConverter();

      expect(snapshot, isA<WalletDustConverterSnapshot>());
      expect(snapshot.targets, isNotEmpty);
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getNetworkStatus returns a populated snapshot', () {
      final snapshot = repository.getNetworkStatus();

      expect(snapshot, isA<WalletNetworkStatusSnapshot>());
      expect(snapshot.networks, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDeposit returns a populated snapshot for a known asset', () {
      final snapshot = repository.getDeposit('USDT');

      expect(snapshot, isA<WalletDepositSnapshot>());
      expect(snapshot.asset, 'USDT');
      expect(snapshot.networks, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDeposit with assetScoped true uses an asset-scoped endpoint', () {
      final snapshot = repository.getDeposit('USDT', assetScoped: true);

      expect(snapshot.endpoint, contains('usdt'));
    });

    test('getDeposit does not throw for an unrecognized asset and falls back '
        'to default networks', () {
      late final WalletDepositSnapshot snapshot;

      expect(
        () => snapshot = repository.getDeposit('does-not-exist'),
        returnsNormally,
      );
      expect(snapshot.networks, isNotEmpty);
    });

    test('getWithdraw returns a populated snapshot for a known asset', () {
      final snapshot = repository.getWithdraw('USDT');

      expect(snapshot, isA<WalletWithdrawSnapshot>());
      expect(snapshot.asset, 'USDT');
      expect(snapshot.networks, isNotEmpty);
      expect(snapshot.recentAddresses, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getWithdraw with assetScoped true uses an asset-scoped endpoint', () {
      final snapshot = repository.getWithdraw('USDT', assetScoped: true);

      expect(snapshot.endpoint, contains('usdt'));
    });

    test('getWithdraw does not throw for an unrecognized asset and falls '
        'back to default networks and available amount', () {
      late final WalletWithdrawSnapshot snapshot;

      expect(
        () => snapshot = repository.getWithdraw('does-not-exist'),
        returnsNormally,
      );
      expect(snapshot.networks, isNotEmpty);
      expect(snapshot.available, greaterThan(0));
    });
  });
}
