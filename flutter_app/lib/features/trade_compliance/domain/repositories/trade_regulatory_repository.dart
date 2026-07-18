import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

/// Data contract for the Trade Compliance feature: cost/disclosure
/// documents, regulatory disclosures & governance, execution quality
/// analytics, and disputes/complaints handling.
abstract interface class TradeRegulatoryRepository {
  // Costs & disclosure documents
  TradeClientMoneyProtectionSnapshot getClientMoneyProtection();
  TradeCassReconciliationSnapshot getCassReconciliation();
  TradeInvestorCompensationSnapshot getInvestorCompensation();
  TradeExAnteCostsSnapshot getExAnteCosts();
  TradeRiyCalculatorSnapshot getRiyCalculator();
  TradeExPostCostsReportSnapshot getExPostCostsReport();
  TradeKidGeneratorSnapshot getKidGenerator();
  TradePerformanceScenariosSnapshot getPerformanceScenarios();
  TradeRiskIndicatorSnapshot getRiskIndicatorExplainer();
  TradeExPostCostsReportExportResult createExPostCostsReportExport({
    int year = 2025,
  });

  // Regulatory disclosures & governance
  TradeRegulatoryDisclosuresSnapshot getRegulatoryDisclosures();
  TradeTransactionReportingSnapshot getTransactionReporting();
  TradeRegulatoryReportsDashboardSnapshot getRegulatoryReportsDashboard();
  TradeClientCategorizationSnapshot getClientCategorization();
  TradeProductGovernanceSnapshot getProductGovernance();
  TradeTargetMarketDefinitionSnapshot getTargetMarketDefinition({
    String productId = 'prod-1',
  });
  TradeAuditTrailSnapshot getAuditTrail();
  TradeRegulatoryInspectionSnapshot getRegulatoryInspectionReady();

  // Execution quality analytics
  TradeMarketDataAnalyticsSnapshot getMarketDataAnalytics();
  TradeMarketDataAnalyticsSnapshot getLiveMarketDataAnalytics();
  TradeArmIntegrationStatusSnapshot getArmIntegrationStatus();
  TradeBestExecutionReportsSnapshot getBestExecutionReports();
  TradeExecutionVenueAnalysisSnapshot getExecutionVenueAnalysis();
  TradeSlippageMonitoringSnapshot getSlippageMonitoring();

  // Disputes & complaints
  TradeComplaintsHandlingSnapshot getComplaintsHandling();
  TradeComplaintSubmissionSnapshot getComplaintSubmission();
  TradeComplaintTrackingSnapshot getComplaintTracking({String? complaintId});
  TradeOmbudsmanReferralSnapshot getOmbudsmanReferral();
}
