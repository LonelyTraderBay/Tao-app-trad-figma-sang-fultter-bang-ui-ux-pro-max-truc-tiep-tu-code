// Split from app_environment_test.dart 2026-07-27 (400-line test file size
// gate, Future-Feature-Onboarding-Checklist). Covers the wallet/P2P-domain
// repository fail-closed wiring (wallet, p2p, launchpad) when mock data is
// disabled in production. See app_environment_test.dart (config parsing) and
// sibling app_environment_fail_closed_*_test.dart files for the other
// domains.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

void main() {
  test('wallet repository fails closed with safe empty snapshots', () async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            environment: AppEnvironment.production,
            apiBaseUrl: Uri.parse('https://api.vittrade.example'),
            enableMockData: false,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(walletRepositoryProvider);
    final snapshot = await repository.getWallet();

    expect(repository, isA<FailClosedWalletRepository>());
    expect(snapshot.totalUsd, 0);
    expect(snapshot.assets, isEmpty);
    expect(snapshot.supportedStates, contains(WalletScreenState.error));
    expect(snapshot.actionDraft, contains('Wallet service is unavailable'));
  });

  test('p2p repository fails closed without wiring mock or fake remote', () {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            environment: AppEnvironment.production,
            apiBaseUrl: Uri.parse('https://api.vittrade.example'),
            enableMockData: false,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(p2pRepositoryProvider);

    expect(repository, isA<FailClosedP2PRepository>());
    expect(
      () => repository.getHome(),
      throwsA(isA<P2PBackendContractMissingException>()),
    );
  });

  test(
    'launchpad repository fails closed without wiring mock or fake remote',
    () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.production,
              apiBaseUrl: Uri.parse('https://api.vittrade.example'),
              enableMockData: false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(launchpadRepositoryProvider);

      expect(repository, isA<FailClosedLaunchpadRepository>());
      expect(
        () => repository.getHome(),
        throwsA(isA<LaunchpadBackendContractMissingException>()),
      );
    },
  );
}
