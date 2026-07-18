// Smoke test for MockTradeBotsRepository: exercises TradingBotsRepository
// and TradeBotAnalyticsRepository's getters/actions against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Phase 6 (2026-07-15): redistributed here from the deleted
// `trade_core`/`MockTradeRepository` union's mock_trade_repository_bots_test.dart
// (getters, unchanged) plus this domain's slice of
// mock_trade_repository_core_test.dart (getTradingBots) and
// mock_trade_repository_actions_test.dart (bot action/export methods).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';

void main() {
  const repo = MockTradeBotsRepository(loadDelay: Duration.zero);

  group('MockTradeBotsRepository smoke test', () {
    group('getters', () {
      test('getTradingBots', () async {
        final bots = await repo.getTradingBots();
        expect(bots, isA<TradeBotsSnapshot>());
        expect(bots.activeBots, hasLength(3));
      });

      test(
        'getBotTermsOfService / getBotRiskDisclosure / getBotSuitabilityAssessment',
        () async {
          expect(
            await repo.getBotTermsOfService(),
            isA<TradeBotTermsSnapshot>(),
          );
          expect(
            await repo.getBotRiskDisclosure(),
            isA<TradeBotRiskDisclosureSnapshot>(),
          );
          expect(
            await repo.getBotSuitabilityAssessment(),
            isA<TradeBotSuitabilityAssessmentSnapshot>(),
          );
        },
      );

      test(
        'getBotRiskDashboard / getBotEmergencyStop / getBotSecuritySettings',
        () async {
          expect(
            await repo.getBotRiskDashboard(),
            isA<TradeBotRiskDashboardSnapshot>(),
          );
          expect(
            await repo.getBotEmergencyStop(),
            isA<TradeBotEmergencyStopSnapshot>(),
          );
          expect(
            await repo.getBotSecuritySettings(),
            isA<TradeBotSecuritySettingsSnapshot>(),
          );
        },
      );

      test(
        'getBotHistory / getBotPerformanceAnalytics / getBotBacktesting',
        () async {
          final history = await repo.getBotHistory();
          expect(history, isA<TradeBotHistorySnapshot>());
          expect(history.trades, hasLength(7));
          expect(
            await repo.getBotPerformanceAnalytics(),
            isA<TradeBotPerformanceAnalyticsSnapshot>(),
          );
          expect(
            await repo.getBotBacktesting(),
            isA<TradeBotBacktestingSnapshot>(),
          );
        },
      );

      test(
        'getBotStrategyCompare / getBotOptimization / getBotPortfolioDashboard',
        () async {
          expect(
            await repo.getBotStrategyCompare(),
            isA<TradeBotStrategyCompareSnapshot>(),
          );
          expect(
            await repo.getBotOptimization(),
            isA<TradeBotOptimizationSnapshot>(),
          );
          expect(
            await repo.getBotPortfolioDashboard(),
            isA<TradeBotPortfolioDashboardSnapshot>(),
          );
        },
      );

      test(
        'getBotDrawdownAnalyzer / getBotEquityCurve / getBotGuide / getBotFaq',
        () async {
          expect(
            await repo.getBotDrawdownAnalyzer(),
            isA<TradeBotDrawdownAnalyzerSnapshot>(),
          );
          expect(
            await repo.getBotEquityCurve(),
            isA<TradeBotEquityCurveSnapshot>(),
          );
          expect(await repo.getBotGuide(), isA<TradeBotGuideSnapshot>());
          expect(await repo.getBotFaq(), isA<TradeBotFaqSnapshot>());
        },
      );

      test('getBotTaxReporting / getBotApiDocumentation', () async {
        expect(
          await repo.getBotTaxReporting(),
          isA<TradeBotTaxReportingSnapshot>(),
        );
        expect(
          await repo.getBotApiDocumentation(),
          isA<TradeBotApiDocumentationSnapshot>(),
        );
      });
    });

    group('write / action methods', () {
      test('createBotTaxReportExport', () async {
        final result = await repo.createBotTaxReportExport(
          const TradeBotTaxReportExportRequest(
            year: '2025',
            reportTypeIds: ['irs-8949', 'turbotax'],
            costBasisMethod: 'FIFO',
          ),
        );
        expect(result, isA<TradeBotTaxReportExportResult>());
      });

      test('submitBotAction / createTradingBot', () async {
        final action = await repo.submitBotAction(
          const TradeBotActionRequest(botId: 'bot1', action: 'pause'),
        );
        expect(action, isA<TradeBotActionResult>());
        final created = await repo.createTradingBot(
          const TradeBotCreateRequest(
            strategyId: 'dca',
            params: {'pair': 'BTC/USDT'},
          ),
        );
        expect(created, isA<TradeBotCreateResult>());
      });

      test('submitBotEmergencyStop', () async {
        final result = await repo.submitBotEmergencyStop(
          const TradeBotEmergencyStopDraft(
            reasonId: 'crash',
            closePositions: true,
            confirmed: true,
          ),
        );
        expect(result, isA<TradeBotEmergencyStopResult>());
      });

      test('patchBotSecuritySettings', () async {
        final result = await repo.patchBotSecuritySettings(
          const TradeBotSecuritySettingsDraft(twoFaEnabled: false),
        );
        expect(result, isA<TradeBotSecuritySettingsResult>());
        expect(result.status, 'saved');
      });

      test('createBotHistoryExport', () async {
        final export = await repo.createBotHistoryExport(
          const TradeBotHistoryExportRequest(format: 'csv'),
        );
        expect(export, isA<TradeBotHistoryExportResult>());
      });

      test('runBotBacktest', () async {
        final result = await repo.runBotBacktest(
          const TradeBotBacktestRequest(
            strategyId: 'grid',
            pair: 'BTC/USDT',
            dateRangeId: '6m',
            initialCapital: 1000,
          ),
        );
        expect(result, isA<TradeBotBacktestResult>());
      });

      test('runBotOptimization', () async {
        final result = await repo.runBotOptimization(
          const TradeBotOptimizationRequest(
            targetId: 'sharpe',
            gridCount: 25,
            gridRangePct: 35,
          ),
        );
        expect(result, isA<TradeBotOptimizationResult>());
      });
    });
  });
}
