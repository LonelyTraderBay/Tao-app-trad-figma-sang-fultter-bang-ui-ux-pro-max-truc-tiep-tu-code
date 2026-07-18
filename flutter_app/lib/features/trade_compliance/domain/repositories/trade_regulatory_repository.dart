import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

/// Data contract for the Trade Compliance feature: cost/disclosure
/// documents, regulatory disclosures & governance, execution quality
/// analytics, and disputes/complaints handling.
///
/// GD4 Cụm F3: every read method returns `Future<T>` (ADR-001 read idiom) —
/// see `docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md`.
abstract interface class TradeRegulatoryRepository {
  // Costs & disclosure documents
  Future<TradeClientMoneyProtectionSnapshot> getClientMoneyProtection();
  Future<TradeCassReconciliationSnapshot> getCassReconciliation();
  Future<TradeInvestorCompensationSnapshot> getInvestorCompensation();
  Future<TradeExAnteCostsSnapshot> getExAnteCosts();
  Future<TradeRiyCalculatorSnapshot> getRiyCalculator();
  Future<TradeExPostCostsReportSnapshot> getExPostCostsReport();
  Future<TradeKidGeneratorSnapshot> getKidGenerator();
  Future<TradePerformanceScenariosSnapshot> getPerformanceScenarios();
  Future<TradeRiskIndicatorSnapshot> getRiskIndicatorExplainer();
  Future<TradeExPostCostsReportExportResult> createExPostCostsReportExport({
    int year = 2025,
  });

  // Regulatory disclosures & governance
  Future<TradeRegulatoryDisclosuresSnapshot> getRegulatoryDisclosures();
  Future<TradeTransactionReportingSnapshot> getTransactionReporting();
  Future<TradeRegulatoryReportsDashboardSnapshot>
  getRegulatoryReportsDashboard();
  Future<TradeClientCategorizationSnapshot> getClientCategorization();
  Future<TradeProductGovernanceSnapshot> getProductGovernance();
  Future<TradeTargetMarketDefinitionSnapshot> getTargetMarketDefinition({
    String productId = 'prod-1',
  });
  Future<TradeAuditTrailSnapshot> getAuditTrail();
  Future<TradeRegulatoryInspectionSnapshot> getRegulatoryInspectionReady();

  // Execution quality analytics
  Future<TradeMarketDataAnalyticsSnapshot> getMarketDataAnalytics();
  Future<TradeMarketDataAnalyticsSnapshot> getLiveMarketDataAnalytics();
  Future<TradeArmIntegrationStatusSnapshot> getArmIntegrationStatus();
  Future<TradeBestExecutionReportsSnapshot> getBestExecutionReports();
  Future<TradeExecutionVenueAnalysisSnapshot> getExecutionVenueAnalysis();
  Future<TradeSlippageMonitoringSnapshot> getSlippageMonitoring();

  // Disputes & complaints
  Future<TradeComplaintsHandlingSnapshot> getComplaintsHandling();
  Future<TradeComplaintSubmissionSnapshot> getComplaintSubmission();
  Future<TradeComplaintTrackingSnapshot> getComplaintTracking({
    String? complaintId,
  });
  Future<TradeOmbudsmanReferralSnapshot> getOmbudsmanReferral();
}
