part of 'earn_entities.dart';

final class StakingWebhooksSnapshot {
  const StakingWebhooksSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.createLabel,
    required this.activeTitle,
    required this.webhooks,
    required this.eventsTitle,
    required this.availableEvents,
    required this.sheetTitle,
    required this.urlLabel,
    required this.urlPlaceholder,
    required this.eventsLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String createLabel;
  final String activeTitle;
  final List<StakingWebhookDraft> webhooks;
  final String eventsTitle;
  final List<String> availableEvents;
  final String sheetTitle;
  final String urlLabel;
  final String urlPlaceholder;
  final String eventsLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingWebhookDraft {
  const StakingWebhookDraft({
    required this.id,
    required this.url,
    required this.events,
    required this.active,
    required this.lastTriggered,
  });

  final String id;
  final String url;
  final List<String> events;
  final bool active;
  final String lastTriggered;
}

final class StakingDataExportSnapshot {
  const StakingDataExportSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.quickTitle,
    required this.quickExports,
    required this.customTitle,
    required this.dateRangeLabel,
    required this.startPlaceholder,
    required this.endPlaceholder,
    required this.formatLabel,
    required this.formatOptions,
    required this.defaultFormat,
    required this.exportLabel,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String quickTitle;
  final List<StakingQuickExportDraft> quickExports;
  final String customTitle;
  final String dateRangeLabel;
  final String startPlaceholder;
  final String endPlaceholder;
  final String formatLabel;
  final List<String> formatOptions;
  final String defaultFormat;
  final String exportLabel;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingQuickExportDraft {
  const StakingQuickExportDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String name;
  final String description;
  final String iconKey;
}

final class StakingThirdPartyIntegrationsSnapshot {
  const StakingThirdPartyIntegrationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.sectionTitle,
    required this.integrations,
    required this.apiTitle,
    required this.apiBody,
    required this.apiActionLabel,
    required this.apiDocsRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String sectionTitle;
  final List<StakingIntegrationDraft> integrations;
  final String apiTitle;
  final String apiBody;
  final String apiActionLabel;
  final String apiDocsRoute;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingIntegrationDraft {
  const StakingIntegrationDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.connected,
    required this.iconKey,
  });

  final String id;
  final String name;
  final String description;
  final bool connected;
  final String iconKey;
}

final class StakingDeveloperConsoleSnapshot {
  const StakingDeveloperConsoleSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.defaultTab,
    required this.tabs,
    required this.stats,
    required this.keysTitle,
    required this.apiKeys,
    required this.createKeyLabel,
    required this.logsTitle,
    required this.recentRequests,
    required this.docsTitle,
    required this.docs,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String defaultTab;
  final List<StakingConsoleTabDraft> tabs;
  final List<StakingConsoleStatDraft> stats;
  final String keysTitle;
  final List<StakingApiKeyDraft> apiKeys;
  final String createKeyLabel;
  final String logsTitle;
  final List<StakingApiRequestDraft> recentRequests;
  final String docsTitle;
  final List<StakingConsoleDocDraft> docs;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingConsoleTabDraft {
  const StakingConsoleTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class StakingConsoleStatDraft {
  const StakingConsoleStatDraft({
    required this.id,
    required this.value,
    required this.label,
    required this.tone,
  });

  final String id;
  final String value;
  final String label;
  final String tone;
}

final class StakingApiKeyDraft {
  const StakingApiKeyDraft({
    required this.id,
    required this.name,
    required this.keyPreview,
    required this.created,
    required this.lastUsed,
    required this.requests,
  });

  final String id;
  final String name;
  final String keyPreview;
  final String created;
  final String lastUsed;
  final int requests;
}

final class StakingApiRequestDraft {
  const StakingApiRequestDraft({
    required this.endpoint,
    required this.status,
    required this.time,
    required this.timestamp,
  });

  final String endpoint;
  final int status;
  final String time;
  final String timestamp;
}

final class StakingConsoleDocDraft {
  const StakingConsoleDocDraft({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

enum StakingAdvancedOrderType { takeProfit, stopLoss, trailingStop }

enum StakingAdvancedOrderStatus { active, triggered, cancelled }

final class StakingAdvancedOrdersSnapshot {
  const StakingAdvancedOrdersSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.activeOrders,
    required this.orderHistory,
    required this.statCards,
    required this.orderTypeOptions,
    required this.assetOptions,
    required this.currentPriceLabel,
    required this.availableLabel,
    required this.orderTypeWarnings,
    required this.howItWorks,
    required this.riskTitle,
    required this.riskBody,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingAdvancedOrderDraft> activeOrders;
  final List<StakingAdvancedOrderDraft> orderHistory;
  final List<StakingAdvancedOrderStatDraft> statCards;
  final List<StakingAdvancedOrderType> orderTypeOptions;
  final List<String> assetOptions;
  final String currentPriceLabel;
  final String availableLabel;
  final Map<StakingAdvancedOrderType, String> orderTypeWarnings;
  final List<StakingAdvancedOrderInfoDraft> howItWorks;
  final String riskTitle;
  final String riskBody;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingAdvancedOrderDraft {
  const StakingAdvancedOrderDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.trigger,
    required this.amount,
    required this.status,
    required this.created,
  });

  final String id;
  final StakingAdvancedOrderType type;
  final String asset;
  final double trigger;
  final double amount;
  final StakingAdvancedOrderStatus status;
  final String created;
}

final class StakingAdvancedOrderStatDraft {
  const StakingAdvancedOrderStatDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

final class StakingAdvancedOrderInfoDraft {
  const StakingAdvancedOrderInfoDraft({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

enum StakingChainId { ethereum, polygon, avalanche, cosmos, solana }

final class StakingMultiChainSnapshot {
  const StakingMultiChainSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.dashboardRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.totalValue,
    required this.totalGainLabel,
    required this.totalRewards24h,
    required this.avgApy,
    required this.activeChains,
    required this.positions,
    required this.quickActions,
    required this.benefits,
    required this.technicalNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String dashboardRoute;
  final String infoTitle;
  final String infoBody;
  final double totalValue;
  final String totalGainLabel;
  final double totalRewards24h;
  final double avgApy;
  final int activeChains;
  final List<StakingChainPositionDraft> positions;
  final List<StakingMultiChainInfoDraft> quickActions;
  final List<StakingMultiChainInfoDraft> benefits;
  final String technicalNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingChainPositionDraft {
  const StakingChainPositionDraft({
    required this.chainId,
    required this.chain,
    required this.asset,
    required this.staked,
    required this.value,
    required this.apy,
  });

  final StakingChainId chainId;
  final String chain;
  final String asset;
  final double staked;
  final double value;
  final double apy;
}

final class StakingMultiChainInfoDraft {
  const StakingMultiChainInfoDraft({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;
}

enum StakingInstitutionalBatchType { stake, unstake, claim }

enum StakingInstitutionalBatchStatus { pending, approved, executed }

enum StakingInstitutionalSignerStatus { approved, pending }

final class StakingInstitutionalSnapshot {
  const StakingInstitutionalSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.stats,
    required this.pendingBatches,
    required this.executedBatches,
    required this.signers,
    required this.features,
    required this.complianceTitle,
    required this.complianceBody,
    required this.operationTypes,
    required this.csvFormatNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingInstitutionalStatDraft> stats;
  final List<StakingInstitutionalBatchDraft> pendingBatches;
  final List<StakingInstitutionalBatchDraft> executedBatches;
  final List<StakingInstitutionalSignerDraft> signers;
  final List<StakingInstitutionalFeatureDraft> features;
  final String complianceTitle;
  final String complianceBody;
  final List<String> operationTypes;
  final String csvFormatNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingInstitutionalStatDraft {
  const StakingInstitutionalStatDraft({
    required this.label,
    required this.value,
    required this.tone,
    required this.icon,
  });

  final String label;
  final String value;
  final String tone;
  final String icon;
}

final class StakingInstitutionalBatchDraft {
  const StakingInstitutionalBatchDraft({
    required this.id,
    required this.type,
    required this.operations,
    required this.totalAmount,
    required this.status,
    required this.created,
    required this.approvals,
    required this.requiredApprovals,
  });

  final String id;
  final StakingInstitutionalBatchType type;
  final int operations;
  final double totalAmount;
  final StakingInstitutionalBatchStatus status;
  final String created;
  final int approvals;
  final int requiredApprovals;
}

final class StakingInstitutionalSignerDraft {
  const StakingInstitutionalSignerDraft({
    required this.name,
    required this.role,
    required this.address,
    required this.status,
  });

  final String name;
  final String role;
  final String address;
  final StakingInstitutionalSignerStatus status;
}

final class StakingInstitutionalFeatureDraft {
  const StakingInstitutionalFeatureDraft({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;
}
