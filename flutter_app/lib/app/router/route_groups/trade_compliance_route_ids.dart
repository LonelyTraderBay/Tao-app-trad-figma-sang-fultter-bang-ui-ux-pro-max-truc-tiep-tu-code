final class TradeComplianceRoutePaths {
  const TradeComplianceRoutePaths._();

  static const String tradeCopyRegulatoryDisclosures =
      '/trade/copy-regulatory-disclosures';
  static const String tradeCopyTransactionReporting =
      '/trade/copy-trading/transaction-reporting';
  static const String tradeCopyRegulatoryReportsDashboard =
      '/trade/copy-trading/regulatory-reports-dashboard';
  static const String tradeCopyArmIntegrationStatus =
      '/trade/copy-trading/arm-integration-status';
  static const String tradeCopyBestExecutionReports =
      '/trade/copy-trading/best-execution-reports';
  static const String tradeCopyExecutionVenueAnalysis =
      '/trade/copy-trading/execution-venue-analysis';
  static const String tradeCopySlippageMonitoring =
      '/trade/copy-trading/slippage-monitoring';
  static const String tradeCopyClientCategorization =
      '/trade/copy-trading/client-categorization';
  static const String tradeCopyClientOptUpRequest =
      '/trade/copy-trading/client-opt-up-request';
  static const String tradeCopyProductGovernance =
      '/trade/copy-trading/product-governance';
  static const String tradeCopyTargetMarketDefinition =
      '/trade/copy-trading/target-market-definition';
  static String tradeCopyTargetMarketDefinitionForProduct(String productId) =>
      '$tradeCopyTargetMarketDefinition/$productId';
  static const String tradeCopyClientMoneyProtection =
      '/trade/copy-trading/client-money-protection';
  static const String tradeCopyCassReconciliation =
      '/trade/copy-trading/cass-reconciliation';
  static const String tradeCopyInvestorCompensation =
      '/trade/copy-trading/investor-compensation';
  static const String tradeCopyExAnteCosts =
      '/trade/copy-trading/ex-ante-costs';
  static const String tradeCopyRiyCalculator =
      '/trade/copy-trading/riy-calculator';
  static const String tradeCopyExPostCostsReport =
      '/trade/copy-trading/ex-post-costs-report';
  static const String tradeCopyKidGenerator =
      '/trade/copy-trading/kid-generator';
  static const String tradeCopyPerformanceScenarios =
      '/trade/copy-trading/performance-scenarios';
  static const String tradeCopyRiskIndicatorExplainer =
      '/trade/copy-trading/risk-indicator-explainer';
  static const String tradeCopyComplaintsHandling =
      '/trade/copy-trading/complaints-handling';
  static const String tradeCopyComplaintSubmission =
      '/trade/copy-trading/complaint-submission';
  static const String tradeCopyComplaintTrackingBase =
      '/trade/copy-trading/complaint-tracking';
  static String tradeCopyComplaintTracking(String complaintId) =>
      '/trade/copy-trading/complaint-tracking/$complaintId';
  static const String tradeCopyOmbudsmanReferral =
      '/trade/copy-trading/ombudsman-referral';
  static const String tradeCopyAuditTrail = '/trade/copy-trading/audit-trail';
  static const String tradeCopyRegulatoryInspectionReady =
      '/trade/copy-trading/regulatory-inspection-ready';
  static const String tradeMarginMarketDataAnalytics =
      '/trade/margin/market-data-analytics';
  static const String tradeMarginLiveMarketDataAnalytics =
      '/trade/margin/live-market-data-analytics';
}

final class TradeComplianceRouteNames {
  const TradeComplianceRouteNames._();

  static const String sc084RegulatoryDisclosures = 'sc084RegulatoryDisclosures';
  static const String sc089MarketDataAnalytics = 'sc089MarketDataAnalytics';
  static const String sc091LiveMarketDataAnalytics =
      'sc091LiveMarketDataAnalytics';
  static const String sc093TransactionReporting = 'sc093TransactionReporting';
  static const String sc094RegulatoryReportsDashboard =
      'sc094RegulatoryReportsDashboard';
  static const String sc095ArmIntegrationStatus = 'sc095ArmIntegrationStatus';
  static const String sc096BestExecutionReports = 'sc096BestExecutionReports';
  static const String sc097ExecutionVenueAnalysis =
      'sc097ExecutionVenueAnalysis';
  static const String sc098SlippageMonitoring = 'sc098SlippageMonitoring';
  static const String sc099ClientCategorization = 'sc099ClientCategorization';
  static const String sc100ProductGovernance = 'sc100ProductGovernance';
  static const String sc101TargetMarketDefinition =
      'sc101TargetMarketDefinition';
  static const String sc102ClientMoneyProtection = 'sc102ClientMoneyProtection';
  static const String sc103CassReconciliation = 'sc103CassReconciliation';
  static const String sc104InvestorCompensation = 'sc104InvestorCompensation';
  static const String sc105ExAnteCosts = 'sc105ExAnteCosts';
  static const String sc106RiyCalculator = 'sc106RiyCalculator';
  static const String sc107ExPostCostsReport = 'sc107ExPostCostsReport';
  static const String sc108KidGenerator = 'sc108KidGenerator';
  static const String sc109PerformanceScenarios = 'sc109PerformanceScenarios';
  static const String sc110RiskIndicatorExplainer =
      'sc110RiskIndicatorExplainer';
  static const String sc111ComplaintsHandling = 'sc111ComplaintsHandling';
  static const String sc112ComplaintSubmission = 'sc112ComplaintSubmission';
  static const String sc113ComplaintTracking = 'sc113ComplaintTracking';
  static const String sc114OmbudsmanReferral = 'sc114OmbudsmanReferral';
  static const String sc115AuditTrail = 'sc115AuditTrail';
  static const String sc116RegulatoryInspectionReady =
      'sc116RegulatoryInspectionReady';
  static const String sc411ClientOptUpRequest = 'sc411ClientOptUpRequest';
  static const String sc415TargetMarketDefinitionDetail =
      'sc415TargetMarketDefinitionDetail';
  static const String sc416ComplaintTrackingDetail =
      'sc416ComplaintTrackingDetail';
}
