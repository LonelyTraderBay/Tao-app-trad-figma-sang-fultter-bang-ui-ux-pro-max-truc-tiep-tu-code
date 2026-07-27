// Split from app_environment_test.dart 2026-07-27 (400-line test file size
// gate, Future-Feature-Onboarding-Checklist). Covers the trading-domain
// repository fail-closed wiring (trade, trade_bots, trade_copy,
// trade_terminal) when mock data is disabled in production. See
// app_environment_test.dart (config parsing) and sibling
// app_environment_fail_closed_*_test.dart files for the other domains.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';

void main() {
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

  test(
    'trade_bots repository fails closed without wiring mock or fake remote',
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

      final repository = container.read(tradingBotsRepositoryProvider);

      expect(repository, isA<FailClosedTradeBotsRepository>());
      expect(
        () => repository.getTradingBots(),
        throwsA(isA<TradeBackendContractMissingException>()),
      );
    },
  );

  test(
    'trade_copy repository fails closed without wiring mock or fake remote',
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

      final repository = container.read(tradeCopyTradingRepositoryProvider);

      expect(repository, isA<FailClosedTradeCopyTradingRepository>());
      expect(
        () => repository.getCopyTrading(),
        throwsA(isA<TradeBackendContractMissingException>()),
      );
    },
  );

  test(
    'trade_terminal repository fails closed without wiring mock or fake remote',
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

      final repository = container.read(spotTradeRepositoryProvider);

      expect(repository, isA<FailClosedTradeTerminalRepository>());
      expect(
        () => repository.getTrade(),
        throwsA(isA<TradeBackendContractMissingException>()),
      );
    },
  );
}
