part of 'earn_entities.dart';

final class StakingAutoCompoundPointDraft {
  const StakingAutoCompoundPointDraft({
    required this.month,
    required this.withCompound,
    required this.withoutCompound,
  });

  final int month;
  final double withCompound;
  final double withoutCompound;
}

final class StakingLiquidStakingSnapshot {
  const StakingLiquidStakingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.tokens,
    required this.swapFromOptions,
    required this.swapToOptions,
    required this.slippageTolerance,
    required this.estimatedGasFee,
    required this.holdingsValue,
    required this.riskNote,
    required this.swapNote,
    required this.benefits,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingLiquidTokenDraft> tokens;
  final List<String> swapFromOptions;
  final List<String> swapToOptions;
  final double slippageTolerance;
  final double estimatedGasFee;
  final double holdingsValue;
  final String riskNote;
  final String swapNote;
  final List<StakingLiquidBenefitDraft> benefits;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingLiquidTokenDraft {
  const StakingLiquidTokenDraft({
    required this.id,
    required this.name,
    required this.symbol,
    required this.underlyingAsset,
    required this.exchangeRate,
    required this.apy,
    required this.totalSupply,
    required this.tvl,
    required this.protocol,
    required this.risks,
    required this.benefits,
  });

  final String id;
  final String name;
  final String symbol;
  final String underlyingAsset;
  final double exchangeRate;
  final double apy;
  final double totalSupply;
  final double tvl;
  final String protocol;
  final List<String> risks;
  final List<String> benefits;
}

final class StakingLiquidBenefitDraft {
  const StakingLiquidBenefitDraft({
    required this.icon,
    required this.label,
    required this.description,
  });

  final String icon;
  final String label;
  final String description;
}

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

final class StakingTaxExportOptionDraft {
  const StakingTaxExportOptionDraft({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

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

final class StakingApiErrorCodeDraft {
  const StakingApiErrorCodeDraft({required this.code, required this.message});

  final int code;
  final String message;
}
