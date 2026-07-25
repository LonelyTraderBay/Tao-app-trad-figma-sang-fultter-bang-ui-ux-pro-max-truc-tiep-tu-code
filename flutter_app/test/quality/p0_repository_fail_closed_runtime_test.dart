// Runtime ratchet for P0 Auth + Wallet: enableMockData=false must resolve
// FailClosed* repositories (not Mock*), and method calls must surface
// backend-contract-missing errors — complements the static source.contains
// checks in repository_guard_coverage_guardrail_test.dart.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            environment: AppEnvironment.staging,
            apiBaseUrl: Uri.parse('https://api.staging.vittrade.example'),
            enableMockData: false,
          ),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  test(
    'authRepositoryProvider fails closed at runtime (not MockAuthRepository)',
    () async {
      final repository = container.read(authRepositoryProvider);

      expect(repository, isA<FailClosedAuthRepository>());
      expect(repository, isNot(isA<MockAuthRepository>()));
      expect(repository.runtimeType.toString(), isNot(contains('Mock')));

      await expectLater(
        repository.login(identifier: 'user@vittrade.vn', password: 'secret'),
        throwsA(isA<AuthBackendContractMissingException>()),
      );
    },
  );

  test(
    'walletRepositoryProvider fails closed at runtime (not MockWalletRepository)',
    () async {
      final repository = container.read(walletRepositoryProvider);

      expect(repository, isA<FailClosedWalletRepository>());
      expect(repository, isNot(isA<MockWalletRepository>()));
      expect(repository.runtimeType.toString(), isNot(contains('Mock')));

      // getWallet returns a controlled empty/error snapshot (not mock balances).
      final snapshot = await repository.getWallet();
      expect(snapshot.assets, isEmpty);
      expect(snapshot.totalUsd, 0);
      expect(snapshot.supportedStates, contains(WalletScreenState.error));

      // Other reads throw synchronously via noSuchMethod.
      expect(
        () => repository.getAddressBook(),
        throwsA(isA<WalletBackendContractMissingException>()),
      );
    },
  );
}
