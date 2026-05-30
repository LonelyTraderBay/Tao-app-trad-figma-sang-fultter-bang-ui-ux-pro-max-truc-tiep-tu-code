part of 'trade_entities.dart';

final class TradeStressScenario {
  const TradeStressScenario({
    required this.name,
    required this.impact,
    required this.probability,
    required this.colorHex,
  });

  final String name;
  final double impact;
  final int probability;
  final int colorHex;
}

final class TradeProviderLeaderboardSnapshot {
  const TradeProviderLeaderboardSnapshot({
    required this.trade,
    required this.providers,
    required this.sortOptions,
    required this.riskFilters,
    required this.defaultSortId,
    required this.defaultRiskFilterId,
    required this.defaultVerifiedOnly,
    required this.warningTitle,
    required this.warningText,
    required this.verifiedOnlyLabel,
    required this.disclaimer,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyTrader> providers;
  final List<TradeProviderLeaderboardSort> sortOptions;
  final List<TradeProviderLeaderboardRiskFilter> riskFilters;
  final String defaultSortId;
  final String defaultRiskFilterId;
  final bool defaultVerifiedOnly;
  final String warningTitle;
  final String warningText;
  final String verifiedOnlyLabel;
  final String disclaimer;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderLeaderboardSort {
  const TradeProviderLeaderboardSort({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeProviderLeaderboardRiskFilter {
  const TradeProviderLeaderboardRiskFilter({
    required this.id,
    required this.label,
    this.riskLevel,
  });

  final String id;
  final String label;
  final TradeCopyRiskLevel? riskLevel;
}

final class TradeSafetyEducationSnapshot {
  const TradeSafetyEducationSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.scams,
    required this.redFlags,
    required this.verificationTiers,
    required this.reportReasons,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeSafetyTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final List<TradeSafetyScamType> scams;
  final List<TradeSafetyRedFlag> redFlags;
  final List<TradeSafetyVerificationTier> verificationTiers;
  final List<String> reportReasons;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeSafetyTab {
  const TradeSafetyTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeSafetyScamType {
  const TradeSafetyScamType({
    required this.id,
    required this.title,
    required this.description,
    required this.examples,
    required this.howToAvoid,
  });

  final String id;
  final String title;
  final String description;
  final List<String> examples;
  final List<String> howToAvoid;
}

final class TradeSafetyRedFlag {
  const TradeSafetyRedFlag({
    required this.id,
    required this.category,
    required this.flag,
    required this.severity,
    required this.explanation,
  });

  final String id;
  final String category;
  final String flag;
  final String severity;
  final String explanation;
}

final class TradeSafetyVerificationTier {
  const TradeSafetyVerificationTier({
    required this.tier,
    required this.colorHex,
    required this.requirements,
  });

  final String tier;
  final int colorHex;
  final List<String> requirements;
}

final class TradeProviderGovernanceSnapshot {
  const TradeProviderGovernanceSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.stats,
    required this.warning,
    required this.modifications,
    required this.messages,
    required this.feeContributors,
    required this.complianceItems,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderGovernanceTab> tabs;
  final String defaultTabId;
  final TradeProviderGovernanceStats stats;
  final String warning;
  final List<TradeStrategyModification> modifications;
  final List<TradeFollowerMessage> messages;
  final List<TradeFeeContributor> feeContributors;
  final List<TradeComplianceItem> complianceItems;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderGovernanceTab {
  const TradeProviderGovernanceTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeProviderGovernanceStats {
  const TradeProviderGovernanceStats({
    required this.followers,
    required this.aum,
    required this.monthlyFeesEarned,
    required this.allTimeFeesEarned,
    required this.complianceScore,
  });

  final int followers;
  final double aum;
  final double monthlyFeesEarned;
  final double allTimeFeesEarned;
  final int complianceScore;
}

final class TradeStrategyModification {
  const TradeStrategyModification({
    required this.id,
    required this.date,
    required this.type,
    required this.oldValue,
    required this.newValue,
    required this.notificationSent,
    required this.followerImpact,
  });

  final String id;
  final String date;
  final String type;
  final String oldValue;
  final String newValue;
  final bool notificationSent;
  final int followerImpact;
}

final class TradeFollowerMessage {
  const TradeFollowerMessage({
    required this.id,
    required this.date,
    required this.subject,
    required this.body,
    required this.recipients,
    required this.openRate,
  });

  final String id;
  final String date;
  final String subject;
  final String body;
  final int recipients;
  final int openRate;
}

final class TradeFeeContributor {
  const TradeFeeContributor({
    required this.name,
    required this.profit,
    required this.fee,
  });

  final String name;
  final double profit;
  final double fee;
}

final class TradeComplianceItem {
  const TradeComplianceItem({
    required this.item,
    required this.status,
    required this.lastCheck,
  });

  final String item;
  final bool status;
  final String lastCheck;
}

final class TradeDisputeResolutionSnapshot {
  const TradeDisputeResolutionSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.noticeTitle,
    required this.noticeBody,
    required this.complaintTypes,
    required this.providers,
    required this.activeCases,
    required this.resolvedCases,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeDisputeTab> tabs;
  final String defaultTabId;
  final String noticeTitle;
  final String noticeBody;
  final List<TradeComplaintTypeOption> complaintTypes;
  final List<TradeDisputeProviderOption> providers;
  final List<TradeDisputeCase> activeCases;
  final List<TradeDisputeCase> resolvedCases;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeDisputeTab {
  const TradeDisputeTab({
    required this.id,
    required this.label,
    this.badgeCount,
  });

  final String id;
  final String label;
  final int? badgeCount;
}

final class TradeComplaintTypeOption {
  const TradeComplaintTypeOption({
    required this.value,
    required this.label,
    required this.description,
  });

  final String value;
  final String label;
  final String description;
}

final class TradeDisputeProviderOption {
  const TradeDisputeProviderOption({required this.id, required this.name});

  final String id;
  final String name;
}

final class TradeDisputeCase {
  const TradeDisputeCase({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.complaintType,
    required this.subject,
    required this.description,
    required this.status,
    required this.submittedDate,
    required this.updatedDate,
    required this.estimatedResolution,
    this.outcome,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String complaintType;
  final String subject;
  final String description;
  final String status;
  final String submittedDate;
  final String updatedDate;
  final String estimatedResolution;
  final String? outcome;
}

final class TradeDisputeComplaintDraft {
  const TradeDisputeComplaintDraft({
    required this.complaintType,
    required this.providerId,
    required this.subject,
    required this.description,
    this.evidenceNames = const [],
  });

  final String complaintType;
  final String providerId;
  final String subject;
  final String description;
  final List<String> evidenceNames;
}

final class TradeDisputeSubmissionResult {
  const TradeDisputeSubmissionResult({
    required this.caseId,
    required this.status,
    required this.message,
  });

  final String caseId;
  final String status;
  final String message;
}

final class TradeCopySafetyCenterSnapshot {
  const TradeCopySafetyCenterSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.verificationIntro,
    required this.verificationTiers,
    required this.trustMetrics,
    required this.prohibitedBehaviors,
    required this.followerResponsibilities,
    required this.reportingSteps,
    required this.safetyTools,
    required this.enforcementActions,
    required this.warningText,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopySafetyCenterTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final String verificationIntro;
  final List<TradeCopyVerificationTier> verificationTiers;
  final List<TradeCopyTrustMetric> trustMetrics;
  final List<String> prohibitedBehaviors;
  final List<String> followerResponsibilities;
  final List<TradeCopyReportingStep> reportingSteps;
  final List<TradeCopySafetyTool> safetyTools;
  final List<TradeCopyEnforcementAction> enforcementActions;
  final String warningText;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopySafetyCenterTab {
  const TradeCopySafetyCenterTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeCopyVerificationTier {
  const TradeCopyVerificationTier({
    required this.tier,
    required this.requirements,
    required this.benefits,
    required this.colorHex,
  });

  final String tier;
  final List<String> requirements;
  final List<String> benefits;
  final int colorHex;
}

final class TradeCopyTrustMetric {
  const TradeCopyTrustMetric({
    required this.name,
    required this.description,
    required this.goodRange,
    required this.badRange,
    required this.whyMatters,
  });

  final String name;
  final String description;
  final String goodRange;
  final String badRange;
  final String whyMatters;
}

final class TradeCopyReportingStep {
  const TradeCopyReportingStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeCopySafetyTool {
  const TradeCopySafetyTool({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    this.routePath,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String? routePath;
}

final class TradeCopyEnforcementAction {
  const TradeCopyEnforcementAction({
    required this.id,
    required this.date,
    required this.providerName,
    required this.action,
    required this.reason,
  });

  final String id;
  final String date;
  final String providerName;
  final String action;
  final String reason;
}

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
