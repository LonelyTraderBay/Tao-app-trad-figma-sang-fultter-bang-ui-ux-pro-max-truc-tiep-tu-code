import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/providers/trade_repository_provider.dart';

export 'package:vit_trade_flutter/features/trade_compliance/data/providers/trade_repository_provider.dart';

/// Regulatory/compliance domain controller providers (trade_compliance
/// extraction, Batch 1 of Phase 1 of the trade module split). Pages must not
/// import `features/trade_compliance/data/providers/` directly (architecture
/// rule — presentation depends on `app/providers/*`, not feature data
/// facades); this file re-exports [tradeRegulatoryRepositoryProvider] above
/// and hosts derived controller providers for the domain.
///
/// GD4 Cụm F3: `TradeRegulatoryRepository` methods are now `Future<T>`
/// (ADR-001 read idiom). Every "raw read" provider below is a plain
/// `FutureProvider` forwarding the repository call — none of these existed
/// as intermediate snapshot providers before this cụm (every page called
/// `ref.watch(tradeRegulatoryRepositoryProvider).getX()` directly inside
/// `build()`), so this is "bước A + bước B gộp" per
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md mục 3 —
/// semantics kept non-autoDispose to match the prior sync `Provider<T>`
/// direct-call pattern. `createExPostCostsReportExport` stays a direct
/// write-style repo call (no snapshot provider) since it is only ever
/// triggered from a header export button, not read in `build()`.
final tradeRiskIndicatorExplainerProvider =
    FutureProvider<TradeRiskIndicatorSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getRiskIndicatorExplainer(),
    );

final tradeClientMoneyProtectionProvider =
    FutureProvider<TradeClientMoneyProtectionSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getClientMoneyProtection(),
    );

final tradeCassReconciliationProvider =
    FutureProvider<TradeCassReconciliationSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getCassReconciliation(),
    );

final tradeInvestorCompensationProvider =
    FutureProvider<TradeInvestorCompensationSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getInvestorCompensation(),
    );

final tradeExAnteCostsProvider = FutureProvider<TradeExAnteCostsSnapshot>(
  (ref) => ref.watch(tradeRegulatoryRepositoryProvider).getExAnteCosts(),
);

final tradeRiyCalculatorProvider = FutureProvider<TradeRiyCalculatorSnapshot>(
  (ref) => ref.watch(tradeRegulatoryRepositoryProvider).getRiyCalculator(),
);

final tradeExPostCostsReportProvider =
    FutureProvider<TradeExPostCostsReportSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getExPostCostsReport(),
    );

final tradeKidGeneratorProvider = FutureProvider<TradeKidGeneratorSnapshot>(
  (ref) => ref.watch(tradeRegulatoryRepositoryProvider).getKidGenerator(),
);

final tradePerformanceScenariosProvider =
    FutureProvider<TradePerformanceScenariosSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getPerformanceScenarios(),
    );

final tradeRegulatoryDisclosuresProvider =
    FutureProvider<TradeRegulatoryDisclosuresSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getRegulatoryDisclosures(),
    );

final tradeTransactionReportingProvider =
    FutureProvider<TradeTransactionReportingSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getTransactionReporting(),
    );

final tradeRegulatoryReportsDashboardProvider =
    FutureProvider<TradeRegulatoryReportsDashboardSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getRegulatoryReportsDashboard(),
    );

final tradeClientCategorizationProvider =
    FutureProvider<TradeClientCategorizationSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getClientCategorization(),
    );

final tradeProductGovernanceProvider =
    FutureProvider<TradeProductGovernanceSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getProductGovernance(),
    );

final tradeTargetMarketDefinitionProvider =
    FutureProvider.family<TradeTargetMarketDefinitionSnapshot, String>(
      (ref, productId) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getTargetMarketDefinition(productId: productId),
    );

final tradeAuditTrailProvider = FutureProvider<TradeAuditTrailSnapshot>(
  (ref) => ref.watch(tradeRegulatoryRepositoryProvider).getAuditTrail(),
);

final tradeRegulatoryInspectionReadyProvider =
    FutureProvider<TradeRegulatoryInspectionSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getRegulatoryInspectionReady(),
    );

final tradeMarketDataAnalyticsProvider =
    FutureProvider<TradeMarketDataAnalyticsSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getMarketDataAnalytics(),
    );

final tradeLiveMarketDataAnalyticsProvider =
    FutureProvider<TradeMarketDataAnalyticsSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getLiveMarketDataAnalytics(),
    );

final tradeArmIntegrationStatusProvider =
    FutureProvider<TradeArmIntegrationStatusSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getArmIntegrationStatus(),
    );

final tradeBestExecutionReportsProvider =
    FutureProvider<TradeBestExecutionReportsSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getBestExecutionReports(),
    );

final tradeExecutionVenueAnalysisProvider =
    FutureProvider<TradeExecutionVenueAnalysisSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getExecutionVenueAnalysis(),
    );

final tradeSlippageMonitoringProvider =
    FutureProvider<TradeSlippageMonitoringSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getSlippageMonitoring(),
    );

final tradeComplaintsHandlingProvider =
    FutureProvider<TradeComplaintsHandlingSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getComplaintsHandling(),
    );

final tradeComplaintSubmissionProvider =
    FutureProvider<TradeComplaintSubmissionSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getComplaintSubmission(),
    );

final tradeComplaintTrackingProvider =
    FutureProvider.family<TradeComplaintTrackingSnapshot, String?>(
      (ref, complaintId) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getComplaintTracking(complaintId: complaintId),
    );

final tradeOmbudsmanReferralProvider =
    FutureProvider<TradeOmbudsmanReferralSnapshot>(
      (ref) =>
          ref.watch(tradeRegulatoryRepositoryProvider).getOmbudsmanReferral(),
    );
