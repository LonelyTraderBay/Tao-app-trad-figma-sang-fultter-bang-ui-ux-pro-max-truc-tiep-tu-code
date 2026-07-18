// Fixture-value smoke test for MockTradeBotsRepository's
// TradingBotsRepository slice (bot hub, terms/risk/suitability, risk
// dashboard, emergency stop, security settings, history, performance, and
// action/export methods) — including the highRiskContractId
// High-Risk-State-Standard requires for the trade_bots flow (see
// test/fixtures/high_risk_flow_binding.dart). Literals pinned here are read
// straight from
// lib/features/trade_bots/data/fixtures/trade_bot_lifecycle_risk_repository_methods.dart
// and its matching fixtures file.
//
// See mock_trade_bots_repository_analytics_test.dart for the
// TradeBotAnalyticsRepository slice (backtesting, strategy compare,
// optimization, portfolio/drawdown/equity analytics, guide/faq/tax/API
// docs).
//
// test/features/trade_bots/mock_trade_bots_repository_test.dart already
// exercises every method with `isA<...>()` smoke checks; this file
// complements that (TEST-HR4) without duplicating its per-method coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';

void main() {
  const repo = MockTradeBotsRepository(loadDelay: Duration.zero);

  group('MockTradeBotsRepository lifecycle & risk smoke test', () {
    test(
      'getTradingBots pins highRiskContractId and active bot count',
      () async {
        final bots = await repo.getTradingBots();
        expect(bots.highRiskContractId, HighRiskFlowContractIds.tradeBots);
        expect(bots.activeBots, hasLength(3));
        expect(bots.strategies, isNotEmpty);
      },
    );

    test(
      'getBotTermsOfService / getBotRiskDisclosure pin fixture copy',
      () async {
        final terms = await repo.getBotTermsOfService();
        expect(terms.title, 'Trading Bots Terms of Service');
        expect(terms.sections, isNotEmpty);

        final risk = await repo.getBotRiskDisclosure();
        expect(risk.highRiskTitle, 'HIGH RISK WARNING');
        expect(risk.categories, isNotEmpty);
      },
    );

    test('getBotSuitabilityAssessment returns populated questions', () async {
      final assessment = await repo.getBotSuitabilityAssessment();
      expect(assessment.questions, isNotEmpty);
      expect(assessment.endpoint, isNotEmpty);
    });

    test(
      'getBotRiskDashboard pins the risk score and running bot count',
      () async {
        final dashboard = await repo.getBotRiskDashboard();
        expect(dashboard.riskScore, 68);
        expect(dashboard.runningBots, 3);
        expect(dashboard.emergencyPath, '/trade/bots/emergency-stop');
      },
    );

    test(
      'getBotEmergencyStop / getBotSecuritySettings pin fixture data',
      () async {
        final emergency = await repo.getBotEmergencyStop();
        expect(emergency.bots, hasLength(3));
        expect(emergency.reasons, isNotEmpty);

        final security = await repo.getBotSecuritySettings();
        expect(security.twoFaEnabled, isTrue);
        expect(security.apiKeys, isNotEmpty);
      },
    );

    test(
      'getBotHistory / getBotPerformanceAnalytics pin fixture counts',
      () async {
        final history = await repo.getBotHistory();
        expect(history.trades, hasLength(7));

        final performance = await repo.getBotPerformanceAnalytics();
        expect(performance.metrics.totalTrades, 96);
        expect(performance.metrics.totalPnl, 199.30);
      },
    );

    test(
      'submitBotAction / createTradingBot pin the returned status',
      () async {
        final action = await repo.submitBotAction(
          const TradeBotActionRequest(botId: 'bot1', action: 'pause'),
        );
        expect(action.status, 'accepted');

        final created = await repo.createTradingBot(
          const TradeBotCreateRequest(
            strategyId: 'dca',
            params: {'pair': 'BTC/USDT'},
          ),
        );
        expect(created.botId, 'BOT-DEMO-059');
        expect(created.status, 'created');
      },
    );

    test(
      'submitBotEmergencyStop pins the stopped bot count and redirect',
      () async {
        final result = await repo.submitBotEmergencyStop(
          const TradeBotEmergencyStopDraft(
            reasonId: 'crash',
            closePositions: true,
            confirmed: true,
          ),
        );
        expect(result.status, 'accepted');
        expect(result.stoppedBotCount, 3);
        expect(result.redirectPath, '/trade/bots');
      },
    );

    test(
      'patchBotSecuritySettings echoes the requested twoFaEnabled',
      () async {
        final result = await repo.patchBotSecuritySettings(
          const TradeBotSecuritySettingsDraft(twoFaEnabled: false),
        );
        expect(result.status, 'saved');
        expect(result.twoFaEnabled, isFalse);
      },
    );

    test('createBotHistoryExport pins the generated download url', () async {
      final export = await repo.createBotHistoryExport(
        const TradeBotHistoryExportRequest(format: 'csv'),
      );
      expect(export.status, 'ready');
      expect(export.downloadUrl, '/exports/BOT-HISTORY-123.csv');
    });
  });
}
