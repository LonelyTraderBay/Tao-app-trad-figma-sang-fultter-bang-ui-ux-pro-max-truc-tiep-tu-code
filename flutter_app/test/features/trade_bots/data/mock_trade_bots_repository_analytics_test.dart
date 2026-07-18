// Fixture-value smoke test for MockTradeBotsRepository's
// TradeBotAnalyticsRepository slice (backtesting, strategy compare,
// optimization, portfolio/drawdown/equity analytics, guide/faq/tax/API
// docs). None of this slice's snapshots carry a highRiskContractId (that
// lives on `getTradingBots` in the lifecycle slice — see
// mock_trade_bots_repository_lifecycle_test.dart). Literals pinned here are
// read straight from
// lib/features/trade_bots/data/fixtures/trade_bot_backtest_portfolio_repository_methods.dart.
//
// test/features/trade_bots/mock_trade_bots_repository_test.dart already
// exercises every method with `isA<...>()` smoke checks; this file
// complements that (TEST-HR4) without duplicating its per-method coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';

void main() {
  const repo = MockTradeBotsRepository(loadDelay: Duration.zero);

  group('MockTradeBotsRepository analytics & backtest smoke test', () {
    test(
      'getBotBacktesting pins the default strategy, pair and capital',
      () async {
        final backtest = await repo.getBotBacktesting();
        expect(backtest.defaultStrategyId, 'grid');
        expect(backtest.defaultPair, 'BTC/USDT');
        expect(backtest.defaultCapital, 1000);
        expect(backtest.strategies, isNotEmpty);
      },
    );

    test('getBotStrategyCompare pins the default selection', () async {
      final compare = await repo.getBotStrategyCompare();
      expect(compare.defaultSelectedIds, ['grid', 'momentum']);
      expect(compare.strategies, isNotEmpty);
    });

    test('getBotOptimization pins the default optimization target', () async {
      final optimization = await repo.getBotOptimization();
      expect(optimization.defaultTargetId, 'sharpe');
      expect(optimization.targets, isNotEmpty);
    });

    test('getBotPortfolioDashboard returns populated allocations', () async {
      final dashboard = await repo.getBotPortfolioDashboard();
      expect(dashboard.allocations, isNotEmpty);
      expect(dashboard.healthItems, isNotEmpty);
    });

    test(
      'getBotDrawdownAnalyzer / getBotEquityCurve return populated data',
      () async {
        final drawdown = await repo.getBotDrawdownAnalyzer();
        expect(drawdown.events, isNotEmpty);
        expect(drawdown.insights, isNotEmpty);

        final equity = await repo.getBotEquityCurve();
        expect(equity.equityPoints, isNotEmpty);
        expect(equity.performanceStats, isNotEmpty);
      },
    );

    test('getBotGuide / getBotFaq return populated content', () async {
      final guide = await repo.getBotGuide();
      expect(guide.strategies, isNotEmpty);
      expect(guide.bestPractices, isNotEmpty);

      final faq = await repo.getBotFaq();
      expect(faq.categories, isNotEmpty);
      expect(faq.totalFaqs, greaterThan(0));
    });

    test(
      'getBotTaxReporting pins the default year and cost basis method',
      () async {
        final tax = await repo.getBotTaxReporting();
        expect(tax.defaultYear, '2025');
        expect(tax.defaultCostBasisMethod, 'FIFO');
        expect(tax.taxYears, contains('2025'));
      },
    );

    test(
      'getBotApiDocumentation pins the default view and websocket url',
      () async {
        final docs = await repo.getBotApiDocumentation();
        expect(docs.defaultView, 'endpoints');
        expect(
          docs.websocketUrl,
          'wss://ws.tradingplatform.com/bots?apiKey=YOUR_API_KEY',
        );
        expect(docs.endpoints, isNotEmpty);
      },
    );

    test(
      'runBotBacktest pins the queued status, report id and progress',
      () async {
        final result = await repo.runBotBacktest(
          const TradeBotBacktestRequest(
            strategyId: 'grid',
            pair: 'BTC/USDT',
            dateRangeId: '6m',
            initialCapital: 1000,
          ),
        );
        expect(result.status, 'queued');
        expect(result.reportId, 'BOT-BACKTEST-125');
        expect(result.progress, 0);
      },
    );

    test('runBotOptimization pins the queued status, job id and eta', () async {
      final result = await repo.runBotOptimization(
        const TradeBotOptimizationRequest(
          targetId: 'sharpe',
          gridCount: 25,
          gridRangePct: 35,
        ),
      );
      expect(result.status, 'queued');
      expect(result.jobId, 'BOT-OPT-127');
      expect(result.estimatedMinutes, 3);
    });

    test('createBotTaxReportExport pins the generated export id', () async {
      final result = await repo.createBotTaxReportExport(
        const TradeBotTaxReportExportRequest(
          year: '2025',
          reportTypeIds: ['irs-8949', 'turbotax'],
          costBasisMethod: 'FIFO',
        ),
      );
      expect(result.status, 'ready');
      expect(result.reportCount, 2);
      expect(result.exportId, 'BOT-TAX-2025-FIFO');
    });
  });
}
