import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/notifications/data/notifications_repository.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/trade_core/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

void main() {
  test('production config disables mock data by default', () {
    final config = AppConfig.fromDartDefines(
      environmentName: 'production',
      apiBaseUrl: 'https://api.vittrade.example',
    );

    expect(config.environment, AppEnvironment.production);
    expect(config.apiBaseUrl, Uri.parse('https://api.vittrade.example'));
    expect(config.enableMockData, isFalse);
  });

  test('production ignores explicit mock data enable flag', () {
    final productionWithMocks = AppConfig.fromDartDefines(
      environmentName: 'production',
      apiBaseUrl: 'https://api.vittrade.example',
      enableMockData: 'true',
    );
    final developmentWithMocks = AppConfig.fromDartDefines(
      environmentName: 'development',
      apiBaseUrl: 'https://dev-api.vittrade.example',
      enableMockData: 'true',
    );
    final stagingWithoutMocks = AppConfig.fromDartDefines(
      environmentName: 'staging',
      apiBaseUrl: 'https://staging-api.vittrade.example',
      enableMockData: 'false',
    );

    expect(productionWithMocks.enableMockData, isFalse);
    expect(developmentWithMocks.enableMockData, isTrue);
    expect(stagingWithoutMocks.enableMockData, isFalse);
  });

  test(
    'auth repository fails closed without wiring mock or fake remote',
    () async {
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

      final repository = container.read(authRepositoryProvider);

      expect(repository, isA<FailClosedAuthRepository>());
      await expectLater(
        repository.login(identifier: 'user@vittrade.vn', password: 'secret'),
        throwsA(isA<AuthBackendContractMissingException>()),
      );
    },
  );

  test('wallet repository fails closed with safe empty snapshots', () {
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
    final snapshot = repository.getWallet();

    expect(repository, isA<FailClosedWalletRepository>());
    expect(snapshot.totalUsd, 0);
    expect(snapshot.assets, isEmpty);
    expect(snapshot.supportedStates, contains(WalletScreenState.error));
    expect(snapshot.actionDraft, contains('Wallet service is unavailable'));
  });

  test('trade repository fails closed without wiring mock or fake remote', () {
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

    final repository = container.read(tradeRepositoryProvider);

    expect(repository, isA<FailClosedTradeRepository>());
    expect(
      () => repository.getTrade(),
      throwsA(isA<TradeBackendContractMissingException>()),
    );
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
    'predictions repository fails closed without wiring mock or fake remote',
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

      final repository = container.read(predictionsRepositoryProvider);

      expect(repository, isA<FailClosedPredictionsRepository>());
      expect(
        () => repository.getHome(),
        throwsA(isA<PredictionsBackendContractMissingException>()),
      );
    },
  );

  test('arena repository fails closed without wiring mock or fake remote', () {
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

    final repository = container.read(arenaRepositoryProvider);

    expect(repository, isA<FailClosedArenaRepository>());
    expect(
      () => repository.getArenaHome(),
      throwsA(isA<ArenaBackendContractMissingException>()),
    );
  });

  test('earn repositories fail closed without wiring mock or fake remote', () {
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

    final earnContractMissing = throwsA(
      predicate<Object>((error) {
        final message = error.toString();
        return message.contains('EarnBackendContractMissingException') &&
            message.contains('mock data is disabled');
      }),
    );

    expect(
      () => container.read(savingsRepositoryProvider),
      earnContractMissing,
    );
    expect(
      () => container.read(stakingEarnRepositoryProvider),
      earnContractMissing,
    );
  });

  test(
    'profile repository fails closed without wiring mock or fake remote',
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

      final repository = container.read(profileRepositoryProvider);

      expect(repository, isA<FailClosedProfileRepository>());
      expect(
        () => repository.getProfile(),
        throwsA(isA<ProfileBackendContractMissingException>()),
      );
    },
  );

  test(
    'notifications repository fails closed without wiring mock or fake remote',
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

      final repository = container.read(notificationsRepositoryProvider);

      expect(repository, isA<FailClosedNotificationsRepository>());
      expect(
        () => repository.getNotifications(),
        throwsA(isA<NotificationsBackendContractMissingException>()),
      );
    },
  );
}
