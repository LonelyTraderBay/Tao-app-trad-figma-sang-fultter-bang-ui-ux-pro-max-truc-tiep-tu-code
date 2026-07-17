part of 'launchpad_entities.dart';

final class LaunchpadAbiDiffSnapshot {
  const LaunchpadAbiDiffSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.contractId,
    required this.diff,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String contractId;
  final LaunchpadAbiDiffResultDraft diff;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadAbiDiffResultDraft {
  const LaunchpadAbiDiffResultDraft({
    required this.contractAddress,
    required this.chain,
    required this.oldImpl,
    required this.newImpl,
    required this.oldImplLabel,
    required this.newImplLabel,
    required this.upgradeBlock,
    required this.upgradeTimestamp,
    required this.upgradeTxHash,
    required this.totalFunctionsOld,
    required this.totalFunctionsNew,
    required this.totalEventsOld,
    required this.totalEventsNew,
    required this.added,
    required this.removed,
    required this.modified,
    required this.unchanged,
    required this.riskScore,
    required this.entries,
  });

  final String contractAddress;
  final String chain;
  final String oldImpl;
  final String newImpl;
  final String oldImplLabel;
  final String newImplLabel;
  final int upgradeBlock;
  final String upgradeTimestamp;
  final String upgradeTxHash;
  final int totalFunctionsOld;
  final int totalFunctionsNew;
  final int totalEventsOld;
  final int totalEventsNew;
  final int added;
  final int removed;
  final int modified;
  final int unchanged;
  final int riskScore;
  final List<LaunchpadAbiDiffEntryDraft> entries;
}

final class LaunchpadAbiDiffEntryDraft {
  const LaunchpadAbiDiffEntryDraft({
    required this.name,
    required this.type,
    required this.changeType,
    required this.riskLevel,
    this.oldSignature,
    this.newSignature,
    this.oldVisibility,
    this.newVisibility,
    this.oldStateMutability,
    this.newStateMutability,
    this.riskNote,
  });

  final String name;
  final String type;
  final LaunchpadAbiChangeType changeType;
  final LaunchpadAbiRiskLevel riskLevel;
  final String? oldSignature;
  final String? newSignature;
  final String? oldVisibility;
  final String? newVisibility;
  final String? oldStateMutability;
  final String? newStateMutability;
  final String? riskNote;
}

final class LaunchpadAddressBookSnapshot {
  const LaunchpadAddressBookSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.addresses,
    required this.chainFilters,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<LaunchpadWalletAddressDraft> addresses;
  final List<String> chainFilters;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadWalletAddressDraft {
  const LaunchpadWalletAddressDraft({
    required this.id,
    required this.label,
    required this.address,
    required this.chain,
    required this.accent,
    required this.iconKey,
    required this.isDefault,
    required this.isFavorite,
    required this.usageCount,
    required this.tags,
    required this.createdAt,
    required this.verified,
    this.lastUsed,
    this.notes,
  });

  final String id;
  final String label;
  final String address;
  final String chain;
  final AccentTone accent;
  final String iconKey;
  final bool isDefault;
  final bool isFavorite;
  final int usageCount;
  final List<String> tags;
  final String createdAt;
  final bool verified;
  final String? lastUsed;
  final String? notes;

  String get maskedAddress => maskAddress(address);

  LaunchpadWalletAddressDraft copyWith({bool? isDefault, bool? isFavorite}) {
    return LaunchpadWalletAddressDraft(
      id: id,
      label: label,
      address: address,
      chain: chain,
      accent: accent,
      iconKey: iconKey,
      isDefault: isDefault ?? this.isDefault,
      isFavorite: isFavorite ?? this.isFavorite,
      usageCount: usageCount,
      tags: tags,
      createdAt: createdAt,
      verified: verified,
      lastUsed: lastUsed,
      notes: notes,
    );
  }
}

final class LaunchpadWebhooksSnapshot {
  const LaunchpadWebhooksSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.subscriptions,
    required this.deliveries,
    required this.eventTypes,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final List<LaunchpadWebhookSubscriptionDraft> subscriptions;
  final List<LaunchpadWebhookDeliveryDraft> deliveries;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadWebhookStatus { active, paused, error, pending }

enum LaunchpadWebhookDeliveryStatus { delivered, failed, retrying, pending }

enum LaunchpadWebhookRetryPolicy { none, linear, exponential }

final class LaunchpadWebhookEventDraft {
  const LaunchpadWebhookEventDraft({
    required this.type,
    required this.label,
    required this.description,
    required this.accent,
  });

  final String type;
  final String label;
  final String description;
  final AccentTone accent;
}

final class LaunchpadWebhookFilterDraft {
  const LaunchpadWebhookFilterDraft({
    required this.field,
    required this.operator,
    required this.value,
  });

  final String field;
  final String operator;
  final String value;
}

final class LaunchpadWebhookSubscriptionDraft {
  const LaunchpadWebhookSubscriptionDraft({
    required this.id,
    required this.label,
    required this.contractAddress,
    required this.chain,
    required this.accent,
    required this.eventTypes,
    required this.webhookUrl,
    required this.status,
    required this.createdAt,
    required this.triggerCount,
    required this.errorCount,
    required this.filters,
    required this.retryPolicy,
    required this.maxRetries,
    this.secret,
    this.lastTriggered,
    this.lastError,
  });

  final String id;
  final String label;
  final String contractAddress;
  final String chain;
  final AccentTone accent;
  final List<String> eventTypes;
  final String webhookUrl;
  final String? secret;
  final LaunchpadWebhookStatus status;
  final String createdAt;
  final String? lastTriggered;
  final int triggerCount;
  final int errorCount;
  final String? lastError;
  final List<LaunchpadWebhookFilterDraft> filters;
  final LaunchpadWebhookRetryPolicy retryPolicy;
  final int maxRetries;

  String get maskedContract => maskAddress(contractAddress, head: 10);

  LaunchpadWebhookSubscriptionDraft copyWith({LaunchpadWebhookStatus? status}) {
    return LaunchpadWebhookSubscriptionDraft(
      id: id,
      label: label,
      contractAddress: contractAddress,
      chain: chain,
      accent: accent,
      eventTypes: eventTypes,
      webhookUrl: webhookUrl,
      secret: secret,
      status: status ?? this.status,
      createdAt: createdAt,
      lastTriggered: lastTriggered,
      triggerCount: triggerCount,
      errorCount: errorCount,
      lastError: lastError,
      filters: filters,
      retryPolicy: retryPolicy,
      maxRetries: maxRetries,
    );
  }
}

final class LaunchpadWebhookDeliveryDraft {
  const LaunchpadWebhookDeliveryDraft({
    required this.id,
    required this.subscriptionId,
    required this.eventType,
    required this.timestamp,
    required this.status,
    required this.payload,
    required this.retryCount,
    this.statusCode,
    this.responseTime,
    this.txHash,
    this.blockNumber,
  });

  final String id;
  final String subscriptionId;
  final String eventType;
  final String timestamp;
  final LaunchpadWebhookDeliveryStatus status;
  final int? statusCode;
  final int? responseTime;
  final String payload;
  final String? txHash;
  final int? blockNumber;
  final int retryCount;
}

final class LaunchpadGasTrackerSnapshot {
  const LaunchpadGasTrackerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.prices,
    required this.estimates,
    required this.alerts,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final List<LaunchpadGasPriceDraft> prices;
  final List<LaunchpadGasEstimateDraft> estimates;
  final List<LaunchpadGasAlertDraft> alerts;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadGasTrend { up, down, stable }

enum LaunchpadGasAlertDirection { above, below }

final class LaunchpadGasPriceDraft {
  const LaunchpadGasPriceDraft({
    required this.chain,
    required this.accent,
    required this.chainIcon,
    required this.slow,
    required this.standard,
    required this.fast,
    required this.instant,
    required this.unit,
    required this.lastUpdated,
    required this.trend,
    required this.change24h,
    this.baseFee,
    this.priorityFee,
  });

  final String chain;
  final AccentTone accent;
  final String chainIcon;
  final double slow;
  final double standard;
  final double fast;
  final double instant;
  final String unit;
  final double? baseFee;
  final double? priorityFee;
  final String lastUpdated;
  final LaunchpadGasTrend trend;
  final double change24h;
}

final class LaunchpadGasEstimateDraft {
  const LaunchpadGasEstimateDraft({
    required this.operation,
    required this.gasUnits,
    required this.costs,
  });

  final String operation;
  final int gasUnits;
  final List<LaunchpadGasEstimateCostDraft> costs;
}

final class LaunchpadGasEstimateCostDraft {
  const LaunchpadGasEstimateCostDraft({
    required this.chain,
    required this.slow,
    required this.standard,
    required this.fast,
  });

  final String chain;
  final String slow;
  final String standard;
  final String fast;
}

final class LaunchpadGasAlertDraft {
  const LaunchpadGasAlertDraft({
    required this.id,
    required this.chain,
    required this.accent,
    required this.threshold,
    required this.direction,
    required this.unit,
    required this.enabled,
    required this.triggerCount,
    this.lastTriggered,
  });

  final String id;
  final String chain;
  final AccentTone accent;
  final double threshold;
  final LaunchpadGasAlertDirection direction;
  final String unit;
  final bool enabled;
  final String? lastTriggered;
  final int triggerCount;

  LaunchpadGasAlertDraft copyWith({bool? enabled}) {
    return LaunchpadGasAlertDraft(
      id: id,
      chain: chain,
      accent: accent,
      threshold: threshold,
      direction: direction,
      unit: unit,
      enabled: enabled ?? this.enabled,
      lastTriggered: lastTriggered,
      triggerCount: triggerCount,
    );
  }
}

final class LaunchpadRebalanceSnapshot {
  const LaunchpadRebalanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.assets,
    required this.strategies,
    required this.defaultStrategyId,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<LaunchpadRebalanceAssetDraft> assets;
  final List<LaunchpadRebalanceStrategyDraft> strategies;
  final String defaultStrategyId;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadRebalanceRisk { conservative, moderate, aggressive }

enum LaunchpadRebalanceAction { buy, sell, hold }

final class LaunchpadRebalanceAssetDraft {
  const LaunchpadRebalanceAssetDraft({
    required this.id,
    required this.symbol,
    required this.name,
    required this.accent,
    required this.currentAmount,
    required this.currentValue,
    required this.currentPercent,
    required this.targetPercent,
    required this.price,
    required this.change24h,
    required this.chain,
  });

  final String id;
  final String symbol;
  final String name;
  final AccentTone accent;
  final double currentAmount;
  final double currentValue;
  final double currentPercent;
  final double targetPercent;
  final double price;
  final double change24h;
  final String chain;

  LaunchpadRebalanceAssetDraft copyWith({double? targetPercent}) {
    return LaunchpadRebalanceAssetDraft(
      id: id,
      symbol: symbol,
      name: name,
      accent: accent,
      currentAmount: currentAmount,
      currentValue: currentValue,
      currentPercent: currentPercent,
      targetPercent: targetPercent ?? this.targetPercent,
      price: price,
      change24h: change24h,
      chain: chain,
    );
  }
}

final class LaunchpadRebalanceStrategyDraft {
  const LaunchpadRebalanceStrategyDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.accent,
    required this.targets,
  });

  final String id;
  final String name;
  final String description;
  final LaunchpadRebalanceRisk riskLevel;
  final AccentTone accent;
  final List<LaunchpadRebalanceTargetDraft> targets;
}

final class LaunchpadRebalanceTargetDraft {
  const LaunchpadRebalanceTargetDraft({
    required this.symbol,
    required this.percent,
  });

  final String symbol;
  final double percent;
}
