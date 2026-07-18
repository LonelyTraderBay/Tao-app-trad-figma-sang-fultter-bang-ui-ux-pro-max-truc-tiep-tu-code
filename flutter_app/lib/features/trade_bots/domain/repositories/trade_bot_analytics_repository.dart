import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

/// Data contract for bot backtesting, strategy comparison/optimization,
/// portfolio analytics, and tax-reporting/API-documentation screens.
///
/// GD4-F6: mọi method — kể cả method GHI (run/create) — giờ đều là
/// `Future<T>` (xem doc comment của [TradingBotsRepository] và
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md bẫy 19).
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
  Future<TradeBotBacktestResult> runBotBacktest(
    TradeBotBacktestRequest request,
  );
  Future<TradeBotOptimizationResult> runBotOptimization(
    TradeBotOptimizationRequest request,
  );
  Future<TradeBotTaxReportExportResult> createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  );
}
