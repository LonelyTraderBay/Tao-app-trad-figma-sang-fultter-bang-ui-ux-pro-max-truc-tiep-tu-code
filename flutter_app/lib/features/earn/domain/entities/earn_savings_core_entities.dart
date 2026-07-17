part of 'earn_entities.dart';

enum SavingsProductType { flexible, locked }

enum SavingsHistoryTransactionType {
  subscribe,
  redeem,
  interest,
  compound,
  earlyRedeem,
}

enum SavingsHistoryTransactionStatus { completed, pending, failed }

enum SavingsGoalStatus { active, completed, paused }

final class SavingsSnapshot {
  const SavingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.portfolioRoute,
    required this.guideRoute,
    required this.exportRoute,
    required this.productDetailRoute,
    required this.totalDepositedUsd,
    required this.gainLabel,
    required this.insights,
    required this.products,
    required this.positions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String portfolioRoute;
  final String guideRoute;
  final String exportRoute;
  final String productDetailRoute;
  final String totalDepositedUsd;
  final String gainLabel;
  final List<SavingsInsightDraft> insights;
  final List<SavingsProductDraft> products;
  final List<SavingsPositionDraft> positions;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsInsightDraft {
  const SavingsInsightDraft({
    required this.title,
    required this.subtitle,
    required this.tone,
    this.route,
  });

  final String title;
  final String subtitle;
  final EarnRiskLevel tone;
  final String? route;
}

final class SavingsProductDraft {
  const SavingsProductDraft({
    required this.id,
    required this.asset,
    required this.name,
    required this.type,
    required this.apy,
    required this.totalSubscribed,
    required this.remainingQuota,
    required this.participants,
    required this.progress,
    required this.riskLevel,
    this.lockDays,
    this.maxApy,
    this.isHot = false,
    this.isNew = false,
  });

  final String id;
  final String asset;
  final String name;
  final SavingsProductType type;
  final String apy;
  final int? lockDays;
  final String? maxApy;
  final String totalSubscribed;
  final String remainingQuota;
  final String participants;
  final double progress;
  final EarnRiskLevel riskLevel;
  final bool isHot;
  final bool isNew;
}

final class SavingsPositionDraft {
  const SavingsPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.earned,
    required this.apy,
    required this.startDate,
    required this.type,
    required this.riskLevel,
    this.endDate,
  });

  final String id;
  final String product;
  final String asset;
  final String amount;
  final String earned;
  final String apy;
  final String startDate;
  final String? endDate;
  final SavingsProductType type;
  final EarnRiskLevel riskLevel;
}

final class SavingsProductDetailSnapshot {
  const SavingsProductDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.productId,
    required this.product,
    required this.notFoundMessage,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String productId;
  final SavingsProductDraft? product;
  final String notFoundMessage;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsRedeemSnapshot {
  const SavingsRedeemSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.receiptRoute,
    required this.positionId,
    required this.position,
    required this.notFoundMessage,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String receiptRoute;
  final String positionId;
  final SavingsPositionDraft? position;
  final String notFoundMessage;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsReceiptSnapshot {
  const SavingsReceiptSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.earnRoute,
    required this.receipt,
    required this.emptyMessage,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String earnRoute;
  final SavingsReceiptDraft? receipt;
  final String emptyMessage;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsReceiptDraft {
  const SavingsReceiptDraft({
    required this.referenceId,
    required this.type,
    required this.product,
    required this.asset,
    required this.amount,
    required this.timestamp,
  });

  final String referenceId;
  final String type;
  final String product;
  final String asset;
  final String amount;
  final String timestamp;
}

final class SavingsPortfolioSnapshot {
  const SavingsPortfolioSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.savingsRoute,
    required this.historyRoute,
    required this.totalDepositedUsd,
    required this.gainLabel,
    required this.weightedApy,
    required this.flexibleTotalUsd,
    required this.lockedTotalUsd,
    required this.activePositions,
    required this.maturingPositions,
    required this.positions,
    required this.incomeProjections,
    required this.maturityEvents,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String savingsRoute;
  final String historyRoute;
  final String totalDepositedUsd;
  final String gainLabel;
  final String weightedApy;
  final String flexibleTotalUsd;
  final String lockedTotalUsd;
  final int activePositions;
  final int maturingPositions;
  final List<SavingsPortfolioPositionDraft> positions;
  final List<SavingsIncomeProjectionDraft> incomeProjections;
  final List<SavingsMaturityEventDraft> maturityEvents;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsPortfolioPositionDraft {
  const SavingsPortfolioPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.type,
    required this.amount,
    required this.usdValue,
    required this.allocationLabel,
    required this.earned,
    required this.apy,
    required this.startDate,
    required this.status,
    required this.progress,
    required this.tone,
    this.endDate,
    this.daysLeft,
  });

  final String id;
  final String product;
  final String asset;
  final SavingsProductType type;
  final String amount;
  final String usdValue;
  final String allocationLabel;
  final String earned;
  final String apy;
  final String startDate;
  final String? endDate;
  final String status;
  final double progress;
  final EarnRiskLevel tone;
  final int? daysLeft;
}

final class SavingsIncomeProjectionDraft {
  const SavingsIncomeProjectionDraft({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final String icon;
}

final class SavingsMaturityEventDraft {
  const SavingsMaturityEventDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.apy,
    required this.progress,
    required this.date,
    required this.daysLeft,
    required this.elapsedLabel,
    required this.tone,
  });

  final String id;
  final String product;
  final String asset;
  final String amount;
  final String usdValue;
  final String apy;
  final double progress;
  final String date;
  final int daysLeft;
  final String elapsedLabel;
  final EarnRiskLevel tone;
}

final class SavingsHistorySnapshot {
  const SavingsHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.receiptRoute,
    required this.totalSubscribed,
    required this.totalInterest,
    required this.totalRedeemed,
    required this.searchPlaceholder,
    required this.transactions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String receiptRoute;
  final String totalSubscribed;
  final String totalInterest;
  final String totalRedeemed;
  final String searchPlaceholder;
  final List<SavingsHistoryTransactionDraft> transactions;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsHistoryTransactionDraft {
  const SavingsHistoryTransactionDraft({
    required this.id,
    required this.type,
    required this.status,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.product,
    required this.date,
    required this.time,
    required this.referenceId,
    this.note,
  });

  final String id;
  final SavingsHistoryTransactionType type;
  final SavingsHistoryTransactionStatus status;
  final String asset;
  final String amount;
  final String usdValue;
  final String product;
  final String date;
  final String time;
  final String referenceId;
  final String? note;
}

final class SavingsGoalsSnapshot {
  const SavingsGoalsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.goals,
    required this.templates,
    required this.tips,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<SavingsGoalDraft> goals;
  final List<SavingsGoalTemplateDraft> templates;
  final List<SavingsGoalTipDraft> tips;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsGoalDraft {
  const SavingsGoalDraft({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.currency,
    required this.iconKey,
    required this.startDate,
    required this.targetDate,
    required this.autoContribute,
    required this.monthlyContribution,
    required this.linkedProduct,
    required this.linkedProductApy,
    required this.status,
    required this.milestones,
    required this.contributions,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String currency;
  final String iconKey;
  final String startDate;
  final String targetDate;
  final bool autoContribute;
  final double monthlyContribution;
  final String linkedProduct;
  final double linkedProductApy;
  final SavingsGoalStatus status;
  final List<SavingsGoalMilestoneDraft> milestones;
  final List<SavingsGoalContributionDraft> contributions;
}

final class SavingsGoalMilestoneDraft {
  const SavingsGoalMilestoneDraft({
    required this.id,
    required this.percentage,
    required this.label,
    required this.reward,
    required this.rewardType,
    required this.rewardValue,
    required this.unlocked,
    this.claimedAt,
  });

  final String id;
  final int percentage;
  final String label;
  final String reward;
  final String rewardType;
  final String rewardValue;
  final bool unlocked;
  final String? claimedAt;
}

final class SavingsGoalContributionDraft {
  const SavingsGoalContributionDraft({
    required this.date,
    required this.amount,
    required this.source,
  });

  final String date;
  final double amount;
  final String source;
}

final class SavingsGoalTemplateDraft {
  const SavingsGoalTemplateDraft({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.suggestedTarget,
    required this.suggestedMonths,
    required this.description,
  });

  final String id;
  final String name;
  final String iconKey;
  final double suggestedTarget;
  final int suggestedMonths;
  final String description;
}

final class SavingsGoalTipDraft {
  const SavingsGoalTipDraft({
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String title;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
}
