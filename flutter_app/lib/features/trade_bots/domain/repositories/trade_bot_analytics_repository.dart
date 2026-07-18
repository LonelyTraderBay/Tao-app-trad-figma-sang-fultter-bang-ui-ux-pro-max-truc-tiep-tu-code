import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

/// Data contract for bot backtesting, strategy comparison/optimization,
/// portfolio analytics, and tax-reporting/API-documentation screens.
///
/// GD4-F3: every READ method is `Future<T>` (ADR-001's read idiom — see
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md). Mock
/// implementations simulate network latency via `loadDelay`; production
/// implementations will be real network calls with the same signature.
/// Write/mutation methods (run/create) stay synchronous — see
/// [TradingBotsRepository]'s doc comment for why.
abstract interface class TradeBotAnalyticsRepository {
  Future<TradeBotBacktestingSnapshot> getBotBacktesting();
  Future<TradeBotStrategyCompareSnapshot> getBotStrategyCompare();
  Future<TradeBotOptimizationSnapshot> getBotOptimization();
  Future<TradeBotPortfolioDashboardSnapshot> getBotPortfolioDashboard();
  Future<TradeBotDrawdownAnalyzerSnapshot> getBotDrawdownAnalyzer();
  Future<TradeBotEquityCurveSnapshot> getBotEquityCurve();
  Future<TradeBotGuideSnapshot> getBotGuide();
  Future<TradeBotFaqSnapshot> getBotFaq();
  Future<TradeBotTaxReportingSnapshot> getBotTaxReporting();
  Future<TradeBotApiDocumentationSnapshot> getBotApiDocumentation();
  TradeBotBacktestResult runBotBacktest(TradeBotBacktestRequest request);
  TradeBotOptimizationResult runBotOptimization(
    TradeBotOptimizationRequest request,
  );
  TradeBotTaxReportExportResult createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  );
}
