// Split 2026-07-27 (400-line test file size gate,
// Future-Feature-Onboarding-Checklist): this file now covers AppConfig
// construction/parsing only (fromDartDefines, parseRuntimeFlag,
// parseBuildNumber, forceUpdateRequired). Fail-closed repository wiring
// moved to per-domain siblings:
// app_environment_fail_closed_trading_test.dart,
// app_environment_fail_closed_wallet_test.dart,
// app_environment_fail_closed_markets_test.dart,
// app_environment_fail_closed_account_test.dart.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';

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

  group('AppConfig.parseRuntimeFlag', () {
    test('empty value defaults to false (blocking flag, fail-safe)', () {
      expect(AppConfig.parseRuntimeFlag(''), isFalse);
      expect(AppConfig.parseRuntimeFlag('   '), isFalse);
    });

    test('recognizes truthy variants case-insensitively', () {
      for (final value in ['1', 'true', 'TRUE', 'yes', 'Yes', 'on', 'ON']) {
        expect(AppConfig.parseRuntimeFlag(value), isTrue, reason: value);
      }
    });

    test('any other value is false', () {
      expect(AppConfig.parseRuntimeFlag('0'), isFalse);
      expect(AppConfig.parseRuntimeFlag('false'), isFalse);
      expect(AppConfig.parseRuntimeFlag('off'), isFalse);
      expect(AppConfig.parseRuntimeFlag('maybe'), isFalse);
    });
  });

  group('AppConfig.parseBuildNumber', () {
    test('parses a valid positive integer', () {
      expect(AppConfig.parseBuildNumber('42'), 42);
    });

    test('invalid or empty input falls back to 0', () {
      expect(AppConfig.parseBuildNumber(''), 0);
      expect(AppConfig.parseBuildNumber('not-a-number'), 0);
    });

    test('negative input clamps to 0', () {
      expect(AppConfig.parseBuildNumber('-5'), 0);
    });
  });

  group('AppConfig.forceUpdateRequired', () {
    test('minSupportedBuild == 0 means the constraint is off', () {
      final config = AppConfig(
        environment: AppEnvironment.production,
        apiBaseUrl: Uri.parse('https://api.vittrade.example'),
        buildNumber: 1,
      );

      expect(config.forceUpdateRequired, isFalse);
    });

    test('current build at or above the minimum is not required', () {
      final atMinimum = AppConfig(
        environment: AppEnvironment.production,
        apiBaseUrl: Uri.parse('https://api.vittrade.example'),
        minSupportedBuild: 10,
        buildNumber: 10,
      );
      final aboveMinimum = AppConfig(
        environment: AppEnvironment.production,
        apiBaseUrl: Uri.parse('https://api.vittrade.example'),
        minSupportedBuild: 10,
        buildNumber: 11,
      );

      expect(atMinimum.forceUpdateRequired, isFalse);
      expect(aboveMinimum.forceUpdateRequired, isFalse);
    });

    test('current build below the minimum requires an update', () {
      final config = AppConfig(
        environment: AppEnvironment.production,
        apiBaseUrl: Uri.parse('https://api.vittrade.example'),
        minSupportedBuild: 10,
        buildNumber: 9,
      );

      expect(config.forceUpdateRequired, isTrue);
    });
  });
}
