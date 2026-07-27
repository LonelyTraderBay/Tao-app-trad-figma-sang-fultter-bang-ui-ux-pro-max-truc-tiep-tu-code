// Split from app_environment_test.dart 2026-07-27 (400-line test file size
// gate, Future-Feature-Onboarding-Checklist). Covers the Prediction
// Markets/Open Arena/Earn-domain repository fail-closed wiring (predictions,
// arena, earn savings + staking) when mock data is disabled in production.
// See app_environment_test.dart (config parsing) and sibling
// app_environment_fail_closed_*_test.dart files for the other domains.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';

void main() {
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
}
