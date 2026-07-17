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
  const repo = MockTradeBotsRepository();

  group('MockTradeBotsRepository smoke test', () {
    group('getters', () {
      test('getTradingBots', () {
        final bots = repo.getTradingBots();
        expect(bots, isA<TradeBotsSnapshot>());
        expect(bots.activeBots, hasLength(3));
      });

      test(
        'getBotTermsOfService / getBotRiskDisclosure / getBotSuitabilityAssessment',
        () {
          expect(repo.getBotTermsOfService(), isA<TradeBotTermsSnapshot>());
          expect(
            repo.getBotRiskDisclosure(),
            isA<TradeBotRiskDisclosureSnapshot>(),
          );
          expect(
            repo.getBotSuitabilityAssessment(),
            isA<TradeBotSuitabilityAssessmentSnapshot>(),
          );
        },
      );

      test(
        'getBotRiskDashboard / getBotEmergencyStop / getBotSecuritySettings',
        () {
          expect(
            repo.getBotRiskDashboard(),
            isA<TradeBotRiskDashboardSnapshot>(),
          );
          expect(
            repo.getBotEmergencyStop(),
            isA<TradeBotEmergencyStopSnapshot>(),
          );
          expect(
            repo.getBotSecuritySettings(),
            isA<TradeBotSecuritySettingsSnapshot>(),
          );
        },
      );

      test(
        'getBotHistory / getBotPerformanceAnalytics / getBotBacktesting',
        () {
          final history = repo.getBotHistory();
          expect(history, isA<TradeBotHistorySnapshot>());
          expect(history.trades, hasLength(7));
          expect(
            repo.getBotPerformanceAnalytics(),
            isA<TradeBotPerformanceAnalyticsSnapshot>(),
          );
          expect(repo.getBotBacktesting(), isA<TradeBotBacktestingSnapshot>());
        },
      );

      test(
        'getBotStrategyCompare / getBotOptimization / getBotPortfolioDashboard',
        () {
          expect(
            repo.getBotStrategyCompare(),
            isA<TradeBotStrategyCompareSnapshot>(),
          );
          expect(
            repo.getBotOptimization(),
            isA<TradeBotOptimizationSnapshot>(),
          );
          expect(
            repo.getBotPortfolioDashboard(),
            isA<TradeBotPortfolioDashboardSnapshot>(),
          );
        },
      );

      test(
        'getBotDrawdownAnalyzer / getBotEquityCurve / getBotGuide / getBotFaq',
        () {
          expect(
            repo.getBotDrawdownAnalyzer(),
            isA<TradeBotDrawdownAnalyzerSnapshot>(),
          );
          expect(repo.getBotEquityCurve(), isA<TradeBotEquityCurveSnapshot>());
          expect(repo.getBotGuide(), isA<TradeBotGuideSnapshot>());
          expect(repo.getBotFaq(), isA<TradeBotFaqSnapshot>());
        },
      );

      test('getBotTaxReporting / getBotApiDocumentation', () {
        expect(repo.getBotTaxReporting(), isA<TradeBotTaxReportingSnapshot>());
        expect(
          repo.getBotApiDocumentation(),
          isA<TradeBotApiDocumentationSnapshot>(),
        );
      });
    });

    group('write / action methods', () {
      test('createBotTaxReportExport', () {
        final result = repo.createBotTaxReportExport(
          const TradeBotTaxReportExportRequest(
            year: '2025',
            reportTypeIds: ['irs-8949', 'turbotax'],
            costBasisMethod: 'FIFO',
          ),
        );
        expect(result, isA<TradeBotTaxReportExportResult>());
      });

      test('submitBotAction / createTradingBot', () {
        final action = repo.submitBotAction(
          const TradeBotActionRequest(botId: 'bot1', action: 'pause'),
        );
        expect(action, isA<TradeBotActionResult>());
        final created = repo.createTradingBot(
          const TradeBotCreateRequest(
            strategyId: 'dca',
            params: {'pair': 'BTC/USDT'},
          ),
        );
        expect(created, isA<TradeBotCreateResult>());
      });

      test('submitBotEmergencyStop', () {
        final result = repo.submitBotEmergencyStop(
          const TradeBotEmergencyStopDraft(
            reasonId: 'crash',
            closePositions: true,
            confirmed: true,
          ),
        );
        expect(result, isA<TradeBotEmergencyStopResult>());
      });

      test('patchBotSecuritySettings', () {
        final result = repo.patchBotSecuritySettings(
          const TradeBotSecuritySettingsDraft(twoFaEnabled: false),
        );
        expect(result, isA<TradeBotSecuritySettingsResult>());
        expect(result.status, 'saved');
      });

      test('createBotHistoryExport', () {
        final export = repo.createBotHistoryExport(
          const TradeBotHistoryExportRequest(format: 'csv'),
        );
        expect(export, isA<TradeBotHistoryExportResult>());
      });

      test('runBotBacktest', () {
        final result = repo.runBotBacktest(
          const TradeBotBacktestRequest(
            strategyId: 'grid',
            pair: 'BTC/USDT',
            dateRangeId: '6m',
            initialCapital: 1000,
          ),
        );
        expect(result, isA<TradeBotBacktestResult>());
      });

      test('runBotOptimization', () {
        final result = repo.runBotOptimization(
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
