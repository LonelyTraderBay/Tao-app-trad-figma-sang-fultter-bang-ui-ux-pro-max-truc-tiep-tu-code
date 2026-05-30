part of 'earn_entities.dart';

final class StakingProofOfReservesSnapshot {
  const StakingProofOfReservesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.overall,
    required this.assets,
    required this.auditReports,
    required this.history,
    required this.verifySteps,
    required this.verifyInfo,
    required this.privacyNote,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final StakingReserveOverallDraft overall;
  final List<StakingAssetReserveDraft> assets;
  final List<StakingReserveAuditReportDraft> auditReports;
  final List<StakingReserveHistoryPointDraft> history;
  final List<StakingReserveVerifyStepDraft> verifySteps;
  final String verifyInfo;
  final String privacyNote;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingReserveOverallDraft {
  const StakingReserveOverallDraft({
    required this.totalAssetsUsd,
    required this.totalLiabilitiesUsd,
    required this.reserveRatio,
    required this.lastAudit,
    required this.lastUpdated,
  });

  final double totalAssetsUsd;
  final double totalLiabilitiesUsd;
  final double reserveRatio;
  final String lastAudit;
  final String lastUpdated;
}

final class StakingAssetReserveDraft {
  const StakingAssetReserveDraft({
    required this.asset,
    required this.onChainBalance,
    required this.userLiabilities,
    required this.reserveRatio,
    required this.lastUpdated,
    required this.walletAddress,
    required this.explorer,
  });

  final String asset;
  final double onChainBalance;
  final double userLiabilities;
  final double reserveRatio;
  final String lastUpdated;
  final String walletAddress;
  final String explorer;
}

final class StakingReserveAuditReportDraft {
  const StakingReserveAuditReportDraft({
    required this.id,
    required this.auditor,
    required this.dateLabel,
    required this.status,
    required this.reportUrl,
    required this.findings,
  });

  final String id;
  final String auditor;
  final String dateLabel;
  final String status;
  final String reportUrl;
  final String findings;
}

final class StakingReserveHistoryPointDraft {
  const StakingReserveHistoryPointDraft({
    required this.month,
    required this.ratio,
  });

  final String month;
  final double ratio;
}

final class StakingReserveVerifyStepDraft {
  const StakingReserveVerifyStepDraft({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class StakingMerkleProofDraft {
  const StakingMerkleProofDraft({
    required this.userId,
    required this.balance,
    required this.leaf,
    required this.root,
    required this.siblings,
    required this.verified,
  });

  final String userId;
  final double balance;
  final String leaf;
  final String root;
  final List<String> siblings;
  final bool verified;
}

final class StakingRiskDashboardSnapshot {
  const StakingRiskDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.overallScore,
    required this.totalStakedUsd,
    required this.atRiskUsd,
    required this.protectedPercent,
    required this.riskMetrics,
    required this.exposures,
    required this.events,
    required this.actions,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final int overallScore;
  final double totalStakedUsd;
  final double atRiskUsd;
  final int protectedPercent;
  final List<StakingRiskMetricDraft> riskMetrics;
  final List<StakingRiskExposureDraft> exposures;
  final List<StakingRiskEventDraft> events;
  final List<StakingRiskActionDraft> actions;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingRiskMetricDraft {
  const StakingRiskMetricDraft({
    required this.category,
    required this.score,
    required this.status,
    required this.description,
    this.actionRoute,
  });

  final String category;
  final int score;
  final String status;
  final String description;
  final String? actionRoute;
}

final class StakingRiskExposureDraft {
  const StakingRiskExposureDraft({
    required this.asset,
    required this.valueUsd,
    required this.percentage,
    required this.risk,
  });

  final String asset;
  final double valueUsd;
  final int percentage;
  final String risk;
}

final class StakingRiskEventDraft {
  const StakingRiskEventDraft({
    required this.id,
    required this.dateLabel,
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
  });

  final String id;
  final String dateLabel;
  final String type;
  final String title;
  final String description;
  final String severity;
}

final class StakingRiskActionDraft {
  const StakingRiskActionDraft({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final String route;
  final String tone;
}

final class StakingSlashingHistorySnapshot {
  const StakingSlashingHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.stats,
    required this.events,
    required this.trend,
    required this.networkBreakdown,
    required this.reasonBreakdown,
    required this.preventionMeasures,
    required this.exportLabel,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final StakingSlashingStatsDraft stats;
  final List<StakingSlashingEventDraft> events;
  final List<StakingSlashingTrendPointDraft> trend;
  final List<StakingSlashingNetworkDraft> networkBreakdown;
  final List<StakingSlashingReasonDraft> reasonBreakdown;
  final List<StakingSlashingPreventionDraft> preventionMeasures;
  final String exportLabel;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingSlashingStatsDraft {
  const StakingSlashingStatsDraft({
    required this.totalEvents,
    required this.totalSlashedEth,
    required this.totalCoveredEth,
    required this.coverageRate,
    required this.avgRecoveryTime,
    required this.lastEvent,
  });

  final int totalEvents;
  final double totalSlashedEth;
  final double totalCoveredEth;
  final double coverageRate;
  final String avgRecoveryTime;
  final String lastEvent;
}

final class StakingSlashingEventDraft {
  const StakingSlashingEventDraft({
    required this.id,
    required this.dateLabel,
    required this.validator,
    required this.network,
    required this.reason,
    required this.slashedAmount,
    required this.affectedUsers,
    required this.insuranceCoverage,
    required this.status,
  });

  final String id;
  final String dateLabel;
  final String validator;
  final String network;
  final String reason;
  final double slashedAmount;
  final int affectedUsers;
  final int insuranceCoverage;
  final String status;
}

final class StakingSlashingTrendPointDraft {
  const StakingSlashingTrendPointDraft({
    required this.month,
    required this.events,
    required this.amountEth,
  });

  final String month;
  final int events;
  final double amountEth;
}

final class StakingSlashingNetworkDraft {
  const StakingSlashingNetworkDraft({
    required this.network,
    required this.events,
    required this.amount,
    required this.unit,
    required this.coverage,
  });

  final String network;
  final int events;
  final double amount;
  final String unit;
  final int coverage;
}

final class StakingSlashingReasonDraft {
  const StakingSlashingReasonDraft({
    required this.reason,
    required this.events,
    required this.severity,
  });

  final String reason;
  final int events;
  final String severity;
}

final class StakingSlashingPreventionDraft {
  const StakingSlashingPreventionDraft({
    required this.measure,
    required this.status,
    required this.description,
  });

  final String measure;
  final String status;
  final String description;
}

final class StakingValidatorHealthMonitorSnapshot {
  const StakingValidatorHealthMonitorSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.validators,
    required this.uptimeHistory,
    required this.actionTitle,
    required this.actionBody,
    required this.actionLabel,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<StakingValidatorHealthDraft> validators;
  final List<StakingUptimeHistoryPointDraft> uptimeHistory;
  final String actionTitle;
  final String actionBody;
  final String actionLabel;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;

  int get healthyCount =>
      validators.where((validator) => validator.status == 'healthy').length;

  int get warningCount =>
      validators.where((validator) => validator.status == 'warning').length;

  double get averageUptime =>
      validators.fold<double>(0, (sum, validator) => sum + validator.uptime) /
      validators.length;
}

final class StakingValidatorHealthDraft {
  const StakingValidatorHealthDraft({
    required this.id,
    required this.name,
    required this.address,
    required this.uptime,
    required this.apr,
    required this.totalStakedEth,
    required this.commission,
    required this.status,
    required this.lastBlock,
    required this.missedBlocks,
  });

  final String id;
  final String name;
  final String address;
  final double uptime;
  final double apr;
  final double totalStakedEth;
  final int commission;
  final String status;
  final String lastBlock;
  final int missedBlocks;
}

final class StakingUptimeHistoryPointDraft {
  const StakingUptimeHistoryPointDraft({
    required this.dateLabel,
    required this.validatorOne,
    required this.validatorTwo,
    required this.validatorThree,
  });

  final String dateLabel;
  final double validatorOne;
  final double validatorTwo;
  final double validatorThree;
}

final class StakingRiskScoreCalculatorSnapshot {
  const StakingRiskScoreCalculatorSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.defaultAmountUsd,
    required this.defaultAsset,
    required this.defaultDuration,
    required this.defaultValidators,
    required this.assetOptions,
    required this.durationOptions,
    required this.recommendations,
    required this.proceedLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final double defaultAmountUsd;
  final String defaultAsset;
  final String defaultDuration;
  final int defaultValidators;
  final List<StakingRiskScoreOptionDraft> assetOptions;
  final List<StakingRiskScoreOptionDraft> durationOptions;
  final List<StakingRiskScoreRecommendationDraft> recommendations;
  final String proceedLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingRiskScoreOptionDraft {
  const StakingRiskScoreOptionDraft({required this.value, required this.label});

  final String value;
  final String label;
}

final class StakingRiskScoreRecommendationDraft {
  const StakingRiskScoreRecommendationDraft({
    required this.trigger,
    required this.title,
    required this.body,
    required this.tone,
  });

  final String trigger;
  final String title;
  final String body;
  final String tone;
}

final class StakingEmergencyActionsSnapshot {
  const StakingEmergencyActionsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.warningTitle,
    required this.warningBody,
    required this.actions,
    required this.useCases,
    required this.statusCards,
    required this.pauseSheet,
    required this.withdrawSheet,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String warningTitle;
  final String warningBody;
  final List<StakingEmergencyActionDraft> actions;
  final List<StakingEmergencyUseCaseDraft> useCases;
  final List<StakingEmergencyStatusDraft> statusCards;
  final StakingEmergencySheetDraft pauseSheet;
  final StakingEmergencySheetDraft withdrawSheet;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingEmergencyActionDraft {
  const StakingEmergencyActionDraft({
    required this.id,
    required this.title,
    required this.body,
    required this.impact,
    required this.tone,
  });

  final String id;
  final String title;
  final String body;
  final String impact;
  final String tone;
}

final class StakingEmergencyUseCaseDraft {
  const StakingEmergencyUseCaseDraft({
    required this.title,
    required this.severity,
    required this.description,
  });

  final String title;
  final String severity;
  final String description;
}
