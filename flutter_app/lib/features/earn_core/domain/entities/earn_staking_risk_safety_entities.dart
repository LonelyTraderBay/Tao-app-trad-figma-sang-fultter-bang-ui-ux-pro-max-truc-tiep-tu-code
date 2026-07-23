part of 'earn_entities.dart';

/// Data contract for the staking insurance screen.
final class StakingInsuranceSnapshot {
  const StakingInsuranceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.plans,
    required this.positions,
    required this.claims,
    required this.benefits,
    required this.warningTitle,
    required this.warningBullets,
    required this.claimReasons,
    required this.claimEvidenceNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingInsurancePlanDraft> plans;
  final List<StakingInsurancePositionDraft> positions;
  final List<StakingInsuranceClaimDraft> claims;
  final List<StakingInsuranceBenefitDraft> benefits;
  final String warningTitle;
  final List<String> warningBullets;
  final List<String> claimReasons;
  final String claimEvidenceNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A selectable staking insurance plan.
final class StakingInsurancePlanDraft {
  const StakingInsurancePlanDraft({
    required this.id,
    required this.name,
    required this.coverage,
    required this.premium,
    required this.maxClaim,
    required this.cooldownDays,
    required this.features,
  });

  final String id;
  final String name;
  final int coverage;
  final double premium;
  final double maxClaim;
  final int cooldownDays;
  final List<String> features;
}

/// A single staking position with its insurance coverage status.
final class StakingInsurancePositionDraft {
  const StakingInsurancePositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.insured,
    this.insurancePlanId,
  });

  final String id;
  final String product;
  final String asset;
  final double amount;
  final double usdValue;
  final bool insured;
  final String? insurancePlanId;
}

/// A single insurance claim filed against a staking position.
final class StakingInsuranceClaimDraft {
  const StakingInsuranceClaimDraft({
    required this.id,
    required this.date,
    required this.position,
    required this.reason,
    required this.loss,
    required this.coverage,
    required this.payout,
    required this.status,
  });

  final String id;
  final String date;
  final String position;
  final String reason;
  final double loss;
  final int coverage;
  final double payout;
  final String status;
}

/// A single benefit card shown on the staking insurance screen.
final class StakingInsuranceBenefitDraft {
  const StakingInsuranceBenefitDraft({
    required this.icon,
    required this.label,
    required this.description,
  });

  final String icon;
  final String label;
  final String description;
}

/// Data contract for the insurance fund transparency screen.
final class StakingInsuranceFundTransparencySnapshot {
  const StakingInsuranceFundTransparencySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.totalBalance,
    required this.targetRatio,
    required this.currentRatio,
    required this.liabilities,
    required this.surplus,
    required this.lastUpdated,
    required this.assets,
    required this.claims,
    required this.history,
    required this.stakingFeeContribution,
    required this.monthlyContribution,
    required this.ytdContributions,
    required this.totalContributed,
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
  final double totalBalance;
  final int targetRatio;
  final int currentRatio;
  final double liabilities;
  final double surplus;
  final String lastUpdated;
  final List<StakingInsuranceFundAssetDraft> assets;
  final List<StakingInsuranceFundClaimDraft> claims;
  final List<StakingInsuranceFundHistoryDraft> history;
  final int stakingFeeContribution;
  final double monthlyContribution;
  final double ytdContributions;
  final double totalContributed;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single asset slice in the insurance fund's holdings breakdown.
final class StakingInsuranceFundAssetDraft {
  const StakingInsuranceFundAssetDraft({
    required this.asset,
    required this.value,
    required this.percentage,
    required this.colorKey,
  });

  final String asset;
  final double value;
  final int percentage;
  final String colorKey;
}

/// A single claim entry in the insurance fund's claim ledger.
final class StakingInsuranceFundClaimDraft {
  const StakingInsuranceFundClaimDraft({
    required this.id,
    required this.date,
    required this.user,
    required this.reason,
    required this.loss,
    required this.coverage,
    required this.payout,
    required this.status,
    required this.processingDays,
  });

  final String id;
  final String date;
  final String user;
  final String reason;
  final double loss;
  final int coverage;
  final double payout;
  final String status;
  final int processingDays;
}

/// A single month's data point in the insurance fund's balance history.
final class StakingInsuranceFundHistoryDraft {
  const StakingInsuranceFundHistoryDraft({
    required this.month,
    required this.balance,
    required this.ratio,
  });

  final String month;
  final double balance;
  final int ratio;
}

/// Data contract for the staking transaction tax reporting screen.
final class StakingTransactionReportingSnapshot {
  const StakingTransactionReportingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.years,
    required this.defaultYear,
    required this.defaultCostBasis,
    required this.summary,
    required this.transactions,
    required this.costBasisMethods,
    required this.taxForms,
    required this.integrations,
    required this.rawDataFormats,
    required this.resources,
    required this.taxNotice,
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
  final List<String> years;
  final String defaultYear;
  final String defaultCostBasis;
  final StakingTaxSummaryDraft summary;
  final List<StakingTaxTransactionDraft> transactions;
  final List<StakingCostBasisMethodDraft> costBasisMethods;
  final List<StakingTaxExportOptionDraft> taxForms;
  final List<StakingTaxExportOptionDraft> integrations;
  final List<StakingTaxExportOptionDraft> rawDataFormats;
  final List<StakingTaxResourceDraft> resources;
  final String taxNotice;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// Tax summary totals for the selected reporting period.
final class StakingTaxSummaryDraft {
  const StakingTaxSummaryDraft({
    required this.totalStakingIncome,
    required this.totalCapitalGains,
    required this.costBasis,
    required this.proceeds,
    required this.shortTermGains,
    required this.longTermGains,
    required this.rewardsByAsset,
  });

  final double totalStakingIncome;
  final double totalCapitalGains;
  final double costBasis;
  final double proceeds;
  final double shortTermGains;
  final double longTermGains;
  final List<StakingTaxRewardAssetDraft> rewardsByAsset;
}

/// Per-asset staking reward total within a [StakingTaxSummaryDraft].
final class StakingTaxRewardAssetDraft {
  const StakingTaxRewardAssetDraft({
    required this.asset,
    required this.amount,
    required this.usdValue,
  });

  final String asset;
  final double amount;
  final double usdValue;
}

/// A single taxable transaction row in the tax reporting list.
final class StakingTaxTransactionDraft {
  const StakingTaxTransactionDraft({
    required this.date,
    required this.type,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.taxable,
    this.costBasis,
  });

  final String date;
  final String type;
  final String asset;
  final double amount;
  final double usdValue;
  final bool taxable;
  final double? costBasis;
}

/// A selectable cost-basis calculation method option.
final class StakingCostBasisMethodDraft {
  const StakingCostBasisMethodDraft({
    required this.value,
    required this.label,
    required this.description,
  });

  final String value;
  final String label;
  final String description;
}

/// A selectable tax form/integration/raw-data export option.
final class StakingTaxExportOptionDraft {
  const StakingTaxExportOptionDraft({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

/// Data contract for the staking API documentation screen.
final class StakingApiDocumentationSnapshot {
  const StakingApiDocumentationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.stats,
    required this.defaultTab,
    required this.defaultLanguage,
    required this.endpoints,
    required this.codeExamples,
    required this.sandboxBaseUrl,
    required this.authHeaderExample,
    required this.rateLimits,
    required this.errorCodes,
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
  final List<StakingApiStatDraft> stats;
  final String defaultTab;
  final String defaultLanguage;
  final List<StakingApiEndpointDraft> endpoints;
  final List<StakingApiCodeExampleDraft> codeExamples;
  final String sandboxBaseUrl;
  final String authHeaderExample;
  final List<StakingApiRateLimitDraft> rateLimits;
  final List<StakingApiErrorCodeDraft> errorCodes;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single usage stat card on the API documentation screen.
final class StakingApiStatDraft {
  const StakingApiStatDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

/// A single documented API endpoint.
final class StakingApiEndpointDraft {
  const StakingApiEndpointDraft({
    required this.method,
    required this.path,
    required this.name,
    required this.description,
    required this.params,
    required this.responseJson,
  });

  final String method;
  final String path;
  final String name;
  final String description;
  final List<StakingApiParameterDraft> params;
  final String responseJson;
}

/// A single request parameter within a [StakingApiEndpointDraft].
final class StakingApiParameterDraft {
  const StakingApiParameterDraft({
    required this.name,
    required this.type,
    required this.required,
    required this.description,
  });

  final String name;
  final String type;
  final bool required;
  final String description;
}

/// A single language code sample on the API documentation screen.
final class StakingApiCodeExampleDraft {
  const StakingApiCodeExampleDraft({
    required this.language,
    required this.label,
    required this.source,
  });

  final String language;
  final String label;
  final String source;
}

/// A single API rate-limit tier row.
final class StakingApiRateLimitDraft {
  const StakingApiRateLimitDraft({
    required this.tier,
    required this.requests,
    required this.window,
    required this.price,
    required this.recommended,
  });

  final String tier;
  final int requests;
  final String window;
  final String price;
  final bool recommended;
}

/// A single documented API error code.
final class StakingApiErrorCodeDraft {
  const StakingApiErrorCodeDraft({required this.code, required this.message});

  final int code;
  final String message;
}

/// A Merkle proof entry used to verify a user's staked balance.
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

/// Data contract for the proof-of-reserves screen.
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

/// Aggregate reserve totals shown on the proof-of-reserves screen.
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

/// Per-asset on-chain reserve vs liability row.
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

/// A single third-party audit report entry.
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

/// A single month's data point in the reserve ratio history chart.
final class StakingReserveHistoryPointDraft {
  const StakingReserveHistoryPointDraft({
    required this.month,
    required this.ratio,
  });

  final String month;
  final double ratio;
}

/// A single step in the proof-of-reserves self-verification guide.
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

/// Data contract for the staking risk dashboard screen.
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

/// A single scored risk category row on the risk dashboard.
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

/// A single asset's exposure row on the risk dashboard.
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

/// A single risk event entry on the risk dashboard.
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

/// A single suggested risk-mitigation action on the risk dashboard.
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

/// Data contract for the validator slashing history screen.
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

/// Aggregate slashing stats shown on the slashing history screen.
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

/// A single slashing incident entry.
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

/// A single month's data point in the slashing trend chart.
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

/// Per-network slashing incident breakdown row.
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

/// Per-reason slashing incident breakdown row.
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

/// A single slashing-prevention measure row.
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

/// Data contract for the validator health monitor screen.
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

/// A single validator's live health row.
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

/// A single data point in the validator uptime history chart.
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

/// Data contract for the staking risk score calculator screen.
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

/// A selectable option (asset/duration) for the risk score calculator.
final class StakingRiskScoreOptionDraft {
  const StakingRiskScoreOptionDraft({required this.value, required this.label});

  final String value;
  final String label;
}

/// A conditional recommendation shown by the risk score calculator.
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

/// Data contract for the staking emergency actions screen.
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

/// A single emergency action (pause/withdraw) card.
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

/// A single example use case for an emergency action.
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

/// A single status card on the emergency actions screen.
final class StakingEmergencyStatusDraft {
  const StakingEmergencyStatusDraft({
    required this.title,
    required this.value,
    required this.body,
    required this.tone,
  });

  final String title;
  final String value;
  final String body;
  final String tone;
}

/// Confirmation sheet content for a [StakingEmergencyActionDraft].
final class StakingEmergencySheetDraft {
  const StakingEmergencySheetDraft({
    required this.title,
    required this.body,
    required this.bullets,
    required this.confirmLabel,
    required this.tone,
  });

  final String title;
  final String body;
  final List<String> bullets;
  final String confirmLabel;
  final String tone;
}

/// Data contract for the staking contingency plan screen.
final class StakingContingencyPlanSnapshot {
  const StakingContingencyPlanSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.metrics,
    required this.scenarios,
    required this.validationItems,
    required this.validationBody,
    required this.documents,
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
  final List<StakingContingencyMetricDraft> metrics;
  final List<StakingContingencyScenarioDraft> scenarios;
  final List<StakingContingencyValidationDraft> validationItems;
  final String validationBody;
  final List<StakingContingencyDocumentDraft> documents;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single readiness metric card on the contingency plan screen.
final class StakingContingencyMetricDraft {
  const StakingContingencyMetricDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

/// A single contingency scenario (likelihood/impact/response) row.
final class StakingContingencyScenarioDraft {
  const StakingContingencyScenarioDraft({
    required this.scenario,
    required this.likelihood,
    required this.impact,
    required this.response,
    required this.preventative,
  });

  final String scenario;
  final String likelihood;
  final String impact;
  final List<String> response;
  final List<String> preventative;
}

/// A single validation checklist item on the contingency plan screen.
final class StakingContingencyValidationDraft {
  const StakingContingencyValidationDraft({
    required this.title,
    required this.dateLabel,
    required this.tone,
  });

  final String title;
  final String dateLabel;
  final String tone;
}

/// A single downloadable contingency plan document.
final class StakingContingencyDocumentDraft {
  const StakingContingencyDocumentDraft({
    required this.name,
    required this.size,
    required this.updatedLabel,
  });

  final String name;
  final String size;
  final String updatedLabel;
}
