part of 'trade_entities.dart';

final class TradeRegulatoryDisclosuresSnapshot {
  const TradeRegulatoryDisclosuresSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.mifidTitle,
    required this.mifidArticles,
    required this.commitmentText,
    required this.protection,
    required this.restrictions,
    required this.liability,
    required this.contacts,
    required this.whistleblower,
    required this.terms,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeRegulatoryTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final String mifidTitle;
  final List<TradeRegulatoryDisclosureBlock> mifidArticles;
  final String commitmentText;
  final TradeRegulatoryProtection protection;
  final TradeRegulatoryRestrictions restrictions;
  final TradeRegulatoryLiability liability;
  final List<TradeRegulatoryContact> contacts;
  final TradeRegulatoryDisclosureBlock whistleblower;
  final List<TradeRegulatoryDocumentLink> terms;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeRegulatoryTab {
  const TradeRegulatoryTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeRegulatoryDisclosureBlock {
  const TradeRegulatoryDisclosureBlock({
    required this.title,
    required this.body,
    this.items = const [],
  });

  final String title;
  final String body;
  final List<String> items;
}

final class TradeRegulatoryProtection {
  const TradeRegulatoryProtection({
    required this.coverage,
    required this.covered,
    required this.notCovered,
    required this.claimSteps,
    required this.contactLabel,
  });

  final TradeRegulatoryDisclosureBlock coverage;
  final TradeRegulatoryDisclosureBlock covered;
  final TradeRegulatoryDisclosureBlock notCovered;
  final TradeRegulatoryDisclosureBlock claimSteps;
  final String contactLabel;
}

final class TradeRegulatoryRestrictions {
  const TradeRegulatoryRestrictions({
    required this.unavailableCountries,
    required this.leverageRules,
    required this.taxReporting,
  });

  final List<String> unavailableCountries;
  final List<TradeRegulatoryDisclosureBlock> leverageRules;
  final TradeRegulatoryDisclosureBlock taxReporting;
}

final class TradeRegulatoryLiability {
  const TradeRegulatoryLiability({
    required this.platformRole,
    required this.userResponsibility,
    required this.indemnification,
    required this.limitation,
  });

  final TradeRegulatoryDisclosureBlock platformRole;
  final TradeRegulatoryDisclosureBlock userResponsibility;
  final TradeRegulatoryDisclosureBlock indemnification;
  final TradeRegulatoryDisclosureBlock limitation;
}

final class TradeRegulatoryContact {
  const TradeRegulatoryContact({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String icon;
}

final class TradeRegulatoryDocumentLink {
  const TradeRegulatoryDocumentLink({required this.title, required this.icon});

  final String title;
  final String icon;
}

final class TradeTransactionReportingSnapshot {
  const TradeTransactionReportingSnapshot({
    required this.reports,
    required this.stats,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeTransactionReport> reports;
  final TradeTransactionReportingStats stats;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;

  List<TradeTransactionReport> reportsForTab(String tab) {
    return switch (tab) {
      'queue' =>
        reports
            .where(
              (report) => [
                'pending',
                'submitting',
                'submitted',
              ].contains(report.status),
            )
            .toList(),
      'history' =>
        reports.where((report) => report.status == 'confirmed').toList(),
      'failed' => reports.where((report) => report.status == 'failed').toList(),
      _ => reports,
    };
  }
}

final class TradeTransactionReport {
  const TradeTransactionReport({
    required this.id,
    required this.transactionId,
    required this.reportType,
    required this.tradingVenue,
    required this.instrument,
    required this.side,
    required this.quantity,
    required this.price,
    required this.value,
    required this.executionTime,
    this.reportedTime,
    this.confirmedTime,
    required this.status,
    required this.armProvider,
    this.messageId,
    this.errorMessage,
    required this.retryCount,
    required this.slaStatus,
  });

  final String id;
  final String transactionId;
  final String reportType;
  final String tradingVenue;
  final String instrument;
  final String side;
  final double quantity;
  final double price;
  final double value;
  final String executionTime;
  final String? reportedTime;
  final String? confirmedTime;
  final String status;
  final String armProvider;
  final String? messageId;
  final String? errorMessage;
  final int retryCount;
  final String slaStatus;
}

final class TradeTransactionReportingStats {
  const TradeTransactionReportingStats({
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.pending,
    required this.onTime,
    required this.avgLatencySeconds,
    required this.totalValue,
    required this.mifidReports,
    required this.emirReports,
    required this.providerCounts,
  });

  final int total;
  final int confirmed;
  final int failed;
  final int pending;
  final int onTime;
  final int avgLatencySeconds;
  final double totalValue;
  final int mifidReports;
  final int emirReports;
  final Map<String, int> providerCounts;
}

final class TradeRegulatoryReportsDashboardSnapshot {
  const TradeRegulatoryReportsDashboardSnapshot({
    required this.dailyStats,
    required this.providers,
    required this.distribution,
    required this.totals,
    required this.timeRanges,
    required this.defaultRange,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeRegulatoryDailyStat> dailyStats;
  final List<TradeRegulatoryArmProvider> providers;
  final List<TradeRegulatoryDistributionItem> distribution;
  final TradeRegulatoryDashboardTotals totals;
  final List<String> timeRanges;
  final String defaultRange;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeRegulatoryDailyStat {
  const TradeRegulatoryDailyStat({
    required this.date,
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.avgLatency,
  });

  final String date;
  final int total;
  final int confirmed;
  final int failed;
  final int avgLatency;
}

final class TradeRegulatoryArmProvider {
  const TradeRegulatoryArmProvider({
    required this.name,
    required this.reports,
    required this.successRate,
    required this.avgLatency,
    required this.status,
  });

  final String name;
  final int reports;
  final double successRate;
  final int avgLatency;
  final String status;
}

final class TradeRegulatoryDistributionItem {
  const TradeRegulatoryDistributionItem({
    required this.name,
    required this.value,
    required this.colorHex,
  });

  final String name;
  final int value;
  final int colorHex;
}

final class TradeRegulatoryDashboardTotals {
  const TradeRegulatoryDashboardTotals({
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.avgLatency,
    required this.successRate,
    required this.distributionTotal,
  });

  final int total;
  final int confirmed;
  final int failed;
  final double avgLatency;
  final double successRate;
  final int distributionTotal;
}

final class TradeClientCategorizationSnapshot {
  const TradeClientCategorizationSnapshot({
    required this.categories,
    required this.history,
    required this.currentCategoryId,
    required this.defaultTab,
    required this.supportedStates,
  });

  final List<TradeClientCategoryInfo> categories;
  final List<TradeClientCategoryHistory> history;
  final String currentCategoryId;
  final String defaultTab;
  final List<TradeScreenState> supportedStates;
}

final class TradeClientCategoryInfo {
  const TradeClientCategoryInfo({
    required this.id,
    required this.label,
    required this.description,
    required this.protections,
    required this.requirements,
  });

  final String id;
  final String label;
  final String description;
  final List<String> protections;
  final List<String> requirements;
}

final class TradeClientCategoryHistory {
  const TradeClientCategoryHistory({
    required this.date,
    required this.action,
    required this.toCategoryId,
    required this.reason,
    this.fromCategoryId,
  });

  final String date;
  final String action;
  final String? fromCategoryId;
  final String toCategoryId;
  final String reason;
}

final class TradeProductGovernanceSnapshot {
  const TradeProductGovernanceSnapshot({
    required this.products,
    required this.defaultTab,
    required this.nextReviewLabel,
    required this.supportedStates,
  });

  final List<TradeCopyProduct> products;
  final String defaultTab;
  final String nextReviewLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeCopyProduct {
  const TradeCopyProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.targetMarket,
    required this.negativeTarget,
    required this.riskLevel,
    required this.lastReview,
    required this.nextReview,
    required this.distributionChannels,
  });

  final String id;
  final String name;
  final String type;
  final String status;
  final List<String> targetMarket;
  final List<String> negativeTarget;
  final String riskLevel;
  final String lastReview;
  final String nextReview;
  final List<String> distributionChannels;
}

final class TradeTargetMarketDefinitionSnapshot {
  const TradeTargetMarketDefinitionSnapshot({
    required this.product,
    required this.dimensions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeCopyProduct product;
  final List<TradeTargetMarketDimension> dimensions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeTargetMarketDimension {
  const TradeTargetMarketDimension({
    required this.id,
    required this.category,
    required this.suitableFor,
    required this.notSuitableFor,
  });

  final String id;
  final String category;
  final List<String> suitableFor;
  final List<String> notSuitableFor;
}

final class TradeAuditTrailSnapshot {
  const TradeAuditTrailSnapshot({
    required this.noticeTitle,
    required this.noticeDescription,
    required this.stats,
    required this.searchPlaceholder,
    required this.tabs,
    required this.entries,
    required this.exportFormats,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String noticeTitle;
  final String noticeDescription;
  final List<TradeAuditStat> stats;
  final String searchPlaceholder;
  final List<TradeAuditTab> tabs;
  final List<TradeAuditEntry> entries;
  final List<String> exportFormats;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeAuditStat {
  const TradeAuditStat({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;
}

final class TradeAuditTab {
  const TradeAuditTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeAuditEntry {
  const TradeAuditEntry({
    required this.id,
    required this.timestampLabel,
    required this.category,
    required this.categoryLabel,
    required this.action,
    required this.details,
    this.user,
    this.ipAddress,
  });

  final String id;
  final String timestampLabel;
  final TradeAuditCategory category;
  final String categoryLabel;
  final String action;
  final String details;
  final String? user;
  final String? ipAddress;
}

enum TradeAuditCategory { trade, compliance, clientAction, system }

final class TradeRegulatoryInspectionSnapshot {
  const TradeRegulatoryInspectionSnapshot({
    required this.complianceScore,
    required this.scoreLabel,
    required this.readyTitle,
    required this.readyDescription,
    required this.stats,
    required this.frameworks,
    required this.documents,
    required this.portalTitle,
    required this.portalDescription,
    required this.portalCta,
    required this.reportCta,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int complianceScore;
  final String scoreLabel;
  final String readyTitle;
  final String readyDescription;
  final List<TradeRegulatoryInspectionStat> stats;
  final List<TradeRegulatoryFramework> frameworks;
  final List<TradeRegulatoryDocument> documents;
  final String portalTitle;
  final String portalDescription;
  final String portalCta;
  final String reportCta;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRegulatoryInspectionStat {
  const TradeRegulatoryInspectionStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final TradeRegulatoryInspectionStatIcon icon;
}

enum TradeRegulatoryInspectionStatIcon {
  documents,
  clients,
  auditLogs,
  retention,
}

final class TradeRegulatoryFramework {
  const TradeRegulatoryFramework({
    required this.name,
    required this.compliance,
    required this.requirements,
  });

  final String name;
  final int compliance;
  final List<String> requirements;
}

final class TradeRegulatoryDocument {
  const TradeRegulatoryDocument({
    required this.name,
    required this.countLabel,
    required this.status,
  });

  final String name;
  final String countLabel;
  final String status;
}
