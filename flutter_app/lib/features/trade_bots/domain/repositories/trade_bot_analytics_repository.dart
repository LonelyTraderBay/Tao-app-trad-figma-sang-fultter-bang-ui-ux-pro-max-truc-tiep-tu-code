import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

/// Data contract for bot backtesting, strategy comparison/optimization,
/// portfolio analytics, and tax-reporting/API-documentation screens.
abstract interface class TradeBotAnalyticsRepository {
  TradeBotBacktestingSnapshot getBotBacktesting();
  TradeBotStrategyCompareSnapshot getBotStrategyCompare();
  TradeBotOptimizationSnapshot getBotOptimization();
  TradeBotPortfolioDashboardSnapshot getBotPortfolioDashboard();
  TradeBotDrawdownAnalyzerSnapshot getBotDrawdownAnalyzer();
  TradeBotEquityCurveSnapshot getBotEquityCurve();
  TradeBotGuideSnapshot getBotGuide();
  TradeBotFaqSnapshot getBotFaq();
  TradeBotTaxReportingSnapshot getBotTaxReporting();
  TradeBotApiDocumentationSnapshot getBotApiDocumentation();
  TradeBotBacktestResult runBotBacktest(TradeBotBacktestRequest request);
  TradeBotOptimizationResult runBotOptimization(
    TradeBotOptimizationRequest request,
  );
  TradeBotTaxReportExportResult createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  );
}
