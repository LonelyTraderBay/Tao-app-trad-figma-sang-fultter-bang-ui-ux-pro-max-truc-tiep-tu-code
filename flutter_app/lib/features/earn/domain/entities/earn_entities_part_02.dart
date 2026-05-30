part of 'earn_entities.dart';

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

final class SavingsGuideSnapshot {
  const SavingsGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.savingsRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.tutorials,
    required this.quickTips,
    required this.terms,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String savingsRoute;
  final List<SavingsGuideTabDraft> tabs;
  final String defaultTab;
  final String heroTitle;
  final String heroSubtitle;
  final List<SavingsGuideTutorialDraft> tutorials;
  final List<SavingsGuideQuickTipDraft> quickTips;
  final List<SavingsGuideTermDraft> terms;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsGuideTabDraft {
  const SavingsGuideTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class SavingsGuideTutorialDraft {
  const SavingsGuideTutorialDraft({
    required this.id,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.description,
    required this.steps,
  });

  final String id;
  final String title;
  final String duration;
  final SavingsGuideDifficulty difficulty;
  final String description;
  final List<SavingsGuideStepDraft> steps;
}

final class SavingsGuideStepDraft {
  const SavingsGuideStepDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tips,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final List<String> tips;
}

final class SavingsGuideQuickTipDraft {
  const SavingsGuideQuickTipDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
}

final class SavingsGuideTermDraft {
  const SavingsGuideTermDraft({required this.term, required this.definition});

  final String term;
  final String definition;
}

final class SavingsFAQSnapshot {
  const SavingsFAQSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.supportRoute,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.searchPlaceholder,
    required this.categories,
    required this.items,
    required this.supportTitle,
    required this.supportSubtitle,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String supportRoute;
  final String heroTitle;
  final String heroSubtitle;
  final String searchPlaceholder;
  final List<SavingsFAQCategoryDraft> categories;
  final List<SavingsFAQItemDraft> items;
  final String supportTitle;
  final String supportSubtitle;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsFAQCategoryDraft {
  const SavingsFAQCategoryDraft({
    required this.id,
    required this.label,
    required this.category,
  });

  final String id;
  final String label;
  final SavingsFAQCategory? category;
}

final class SavingsFAQItemDraft {
  const SavingsFAQItemDraft({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  final String id;
  final SavingsFAQCategory category;
  final String question;
  final String answer;
}

final class SavingsNotificationsSnapshot {
  const SavingsNotificationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.settingsActionDraft,
    required this.clearActionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.history,
    required this.settings,
    required this.settingsTitle,
    required this.settingsSubtitle,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String settingsActionDraft;
  final String clearActionDraft;
  final String title;
  final String backRoute;
  final List<SavingsNotificationTabDraft> tabs;
  final String defaultTab;
  final List<SavingsNotificationDraft> history;
  final List<SavingsNotificationSettingDraft> settings;
  final String settingsTitle;
  final String settingsSubtitle;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsNotificationTabDraft {
  const SavingsNotificationTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class SavingsNotificationDraft {
  const SavingsNotificationDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.read,
  });

  final String id;
  final SavingsNotificationType type;
  final String title;
  final String message;
  final String time;
  final bool read;

  SavingsNotificationDraft copyWith({bool? read}) {
    return SavingsNotificationDraft(
      id: id,
      type: type,
      title: title,
      message: message,
      time: time,
      read: read ?? this.read,
    );
  }
}

final class SavingsNotificationSettingDraft {
  const SavingsNotificationSettingDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.enabled,
    required this.priority,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final bool enabled;
  final SavingsNotificationPriority priority;

  SavingsNotificationSettingDraft copyWith({bool? enabled}) {
    return SavingsNotificationSettingDraft(
      id: id,
      title: title,
      description: description,
      iconKey: iconKey,
      enabled: enabled ?? this.enabled,
      priority: priority,
    );
  }
}

final class SavingsRecommendationsSnapshot {
  const SavingsRecommendationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.riskAssessmentRoute,
    required this.savingsRoute,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.profile,
    required this.strategies,
    required this.insights,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String riskAssessmentRoute;
  final String savingsRoute;
  final String heroTitle;
  final String heroSubtitle;
  final SavingsUserProfileDraft profile;
  final List<SavingsStrategyDraft> strategies;
  final List<SavingsRecommendationInsightDraft> insights;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsUserProfileDraft {
  const SavingsUserProfileDraft({
    required this.riskTolerance,
    required this.investmentHorizon,
    required this.liquidityNeed,
    required this.totalAvailable,
    required this.preferredAssets,
    required this.hasCompletedAssessment,
    required this.assessmentDate,
  });

  final SavingsProfileRiskTolerance riskTolerance;
  final SavingsInvestmentHorizon investmentHorizon;
  final SavingsLiquidityNeed liquidityNeed;
  final double totalAvailable;
  final List<String> preferredAssets;
  final bool hasCompletedAssessment;
  final String assessmentDate;
}

final class SavingsStrategyDraft {
  const SavingsStrategyDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.matchScore,
    required this.expectedApy,
    required this.riskLevel,
    required this.liquidityRatio,
    required this.allocation,
    required this.pros,
    required this.cons,
    required this.bestFor,
    this.recommended = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int matchScore;
  final double expectedApy;
  final SavingsStrategyRiskLevel riskLevel;
  final int liquidityRatio;
  final List<SavingsStrategyAllocationDraft> allocation;
  final List<String> pros;
  final List<String> cons;
  final List<String> bestFor;
  final bool recommended;
}

final class SavingsStrategyAllocationDraft {
  const SavingsStrategyAllocationDraft({
    required this.product,
    required this.asset,
    required this.type,
    required this.percentage,
    required this.apy,
    this.lockDays,
  });

  final String product;
  final String asset;
  final SavingsStrategyAllocationType type;
  final int percentage;
  final double apy;
  final int? lockDays;
}

final class SavingsRecommendationInsightDraft {
  const SavingsRecommendationInsightDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
}

final class SavingsRiskAssessmentSnapshot {
  const SavingsRiskAssessmentSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.resultTitle,
    required this.backRoute,
    required this.savingsRoute,
    required this.recommendationsRoute,
    required this.questions,
    required this.results,
    required this.infoText,
    required this.footerDisclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String resultTitle;
  final String backRoute;
  final String savingsRoute;
  final String recommendationsRoute;
  final List<SavingsRiskQuestionDraft> questions;
  final List<SavingsRiskProfileResultDraft> results;
  final String infoText;
  final String footerDisclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsRiskQuestionDraft {
  const SavingsRiskQuestionDraft({
    required this.id,
    required this.question,
    required this.options,
    this.helpText,
  });

  final String id;
  final String question;
  final String? helpText;
  final List<SavingsRiskOptionDraft> options;
}

final class SavingsRiskOptionDraft {
  const SavingsRiskOptionDraft({
    required this.label,
    required this.value,
    this.description,
  });

  final String label;
  final int value;
  final String? description;
}

final class SavingsRiskProfileResultDraft {
  const SavingsRiskProfileResultDraft({
    required this.level,
    required this.minScore,
    required this.maxScore,
    required this.label,
    required this.description,
    required this.strategyMatch,
    required this.recommendations,
    required this.products,
    required this.warnings,
  });

  final SavingsRiskProfileLevel level;
  final int minScore;
  final int maxScore;
  final String label;
  final String description;
  final String strategyMatch;
  final List<String> recommendations;
  final List<SavingsRiskProductDraft> products;
  final List<String> warnings;
}

final class SavingsRiskProductDraft {
  const SavingsRiskProductDraft({
    required this.name,
    required this.apy,
    required this.risk,
    required this.type,
    required this.asset,
  });

  final String name;
  final String apy;
  final String risk;
  final SavingsStrategyAllocationType type;
  final String asset;
}
