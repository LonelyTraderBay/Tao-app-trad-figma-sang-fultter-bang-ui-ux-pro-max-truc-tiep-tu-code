part of 'trade_entities.dart';

final class TradeActiveCopy {
  const TradeActiveCopy({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.providerVerified,
    required this.capital,
    required this.currentValue,
    required this.pnl,
    required this.pnlPct,
    required this.status,
    required this.startDate,
    required this.copyMode,
    required this.trades,
    required this.winRate,
    required this.hasCustomStopLoss,
    required this.recentTrades,
    required this.performanceHistory,
    this.copyRatio,
    this.stopLossLevel,
    this.coolingOffUntil,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final bool providerVerified;
  final double capital;
  final double currentValue;
  final double pnl;
  final double pnlPct;
  final TradeActiveCopyStatus status;
  final String startDate;
  final TradeActiveCopyMode copyMode;
  final double? copyRatio;
  final int trades;
  final double winRate;
  final bool hasCustomStopLoss;
  final double? stopLossLevel;
  final String? coolingOffUntil;
  final List<TradeCopyRecentTrade> recentTrades;
  final List<TradeCopyPerformancePoint> performanceHistory;
}

final class TradeCopyRecentTrade {
  const TradeCopyRecentTrade({
    required this.id,
    required this.pair,
    required this.side,
    required this.size,
    required this.price,
    required this.pnl,
    required this.timestamp,
  });

  final String id;
  final String pair;
  final TradeOrderSide side;
  final double size;
  final double price;
  final double pnl;
  final String timestamp;
}

final class TradeCopyPerformancePoint {
  const TradeCopyPerformancePoint({
    required this.timestamp,
    required this.value,
  });

  final String timestamp;
  final double value;
}

final class TradeCopySettingsSnapshot {
  const TradeCopySettingsSnapshot({
    required this.trade,
    required this.settings,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeCopySettings settings;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopySettings {
  const TradeCopySettings({
    required this.defaultCopyMode,
    required this.defaultCopyRatio,
    required this.defaultStopLoss,
    required this.defaultTakeProfit,
    required this.maxPortfolioAllocation,
    required this.maxCopiesActive,
    required this.enableCircuitBreaker,
    required this.circuitBreakerThreshold,
    required this.notifyNewTrades,
    required this.notifyPnlChanges,
    required this.notifyRiskAlerts,
    required this.notifyProviderUpdates,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.showPortfolioPublic,
  });

  final TradeCopySettingsMode defaultCopyMode;
  final double defaultCopyRatio;
  final double defaultStopLoss;
  final double defaultTakeProfit;
  final double maxPortfolioAllocation;
  final int maxCopiesActive;
  final bool enableCircuitBreaker;
  final double circuitBreakerThreshold;
  final bool notifyNewTrades;
  final bool notifyPnlChanges;
  final bool notifyRiskAlerts;
  final bool notifyProviderUpdates;
  final bool emailNotifications;
  final bool pushNotifications;
  final String emergencyContact;
  final String emergencyPhone;
  final bool showPortfolioPublic;

  TradeCopySettings copyWith({
    TradeCopySettingsMode? defaultCopyMode,
    double? defaultCopyRatio,
    double? defaultStopLoss,
    double? defaultTakeProfit,
    double? maxPortfolioAllocation,
    int? maxCopiesActive,
    bool? enableCircuitBreaker,
    double? circuitBreakerThreshold,
    bool? notifyNewTrades,
    bool? notifyPnlChanges,
    bool? notifyRiskAlerts,
    bool? notifyProviderUpdates,
    bool? emailNotifications,
    bool? pushNotifications,
    String? emergencyContact,
    String? emergencyPhone,
    bool? showPortfolioPublic,
  }) {
    return TradeCopySettings(
      defaultCopyMode: defaultCopyMode ?? this.defaultCopyMode,
      defaultCopyRatio: defaultCopyRatio ?? this.defaultCopyRatio,
      defaultStopLoss: defaultStopLoss ?? this.defaultStopLoss,
      defaultTakeProfit: defaultTakeProfit ?? this.defaultTakeProfit,
      maxPortfolioAllocation:
          maxPortfolioAllocation ?? this.maxPortfolioAllocation,
      maxCopiesActive: maxCopiesActive ?? this.maxCopiesActive,
      enableCircuitBreaker: enableCircuitBreaker ?? this.enableCircuitBreaker,
      circuitBreakerThreshold:
          circuitBreakerThreshold ?? this.circuitBreakerThreshold,
      notifyNewTrades: notifyNewTrades ?? this.notifyNewTrades,
      notifyPnlChanges: notifyPnlChanges ?? this.notifyPnlChanges,
      notifyRiskAlerts: notifyRiskAlerts ?? this.notifyRiskAlerts,
      notifyProviderUpdates:
          notifyProviderUpdates ?? this.notifyProviderUpdates,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      showPortfolioPublic: showPortfolioPublic ?? this.showPortfolioPublic,
    );
  }
}

final class TradeCopySettingsSaveResult {
  const TradeCopySettingsSaveResult({
    required this.status,
    required this.settings,
  });

  final String status;
  final TradeCopySettings settings;
}

enum TradeCopyNotificationType { trade, risk, update, system }

enum TradeCopyNotificationSeverity { info, warning, critical }

final class TradeCopyNotificationsSnapshot {
  const TradeCopyNotificationsSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTab,
    required this.notifications,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyNotificationTab> tabs;
  final String defaultTab;
  final List<TradeCopyNotification> notifications;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyNotificationTab {
  const TradeCopyNotificationTab({
    required this.id,
    required this.label,
    this.badge,
  });

  final String id;
  final String label;
  final int? badge;
}

final class TradeCopyNotification {
  const TradeCopyNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.severity,
    this.providerId,
    this.providerName,
    this.copyId,
    this.actionPath,
    this.pnl,
    this.pair,
    this.side,
  });

  final String id;
  final TradeCopyNotificationType type;
  final String title;
  final String message;
  final String timestamp;
  final bool read;
  final TradeCopyNotificationSeverity severity;
  final String? providerId;
  final String? providerName;
  final String? copyId;
  final String? actionPath;
  final double? pnl;
  final String? pair;
  final TradeOrderSide? side;

  TradeCopyNotification copyWith({bool? read}) {
    return TradeCopyNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      read: read ?? this.read,
      severity: severity,
      providerId: providerId,
      providerName: providerName,
      copyId: copyId,
      actionPath: actionPath,
      pnl: pnl,
      pair: pair,
      side: side,
    );
  }
}

enum TradeProviderApplicationStep {
  intro,
  requirements,
  disclosure,
  fees,
  review,
}

final class TradeProviderApplicationSnapshot {
  const TradeProviderApplicationSnapshot({
    required this.trade,
    required this.steps,
    required this.defaultStep,
    required this.benefits,
    required this.requirements,
    required this.responsibilities,
    required this.defaultDraft,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderApplicationStep> steps;
  final TradeProviderApplicationStep defaultStep;
  final List<TradeProviderBenefit> benefits;
  final List<TradeProviderRequirement> requirements;
  final List<String> responsibilities;
  final TradeProviderApplicationDraft defaultDraft;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeProviderBenefit {
  const TradeProviderBenefit({
    required this.iconName,
    required this.title,
    required this.description,
  });

  final String iconName;
  final String title;
  final String description;
}

final class TradeProviderRequirement {
  const TradeProviderRequirement({required this.label, required this.met});

  final String label;
  final bool met;
}

final class TradeProviderApplicationDraft {
  const TradeProviderApplicationDraft({
    required this.hasKyc,
    required this.tradingMonths,
    required this.minCapital,
    required this.performanceFee,
    required this.agreedToDisclosure,
    required this.agreedToFiduciary,
    required this.agreedToTerms,
    required this.strategyDescription,
  });

  final bool hasKyc;
  final int tradingMonths;
  final int minCapital;
  final int performanceFee;
  final bool agreedToDisclosure;
  final bool agreedToFiduciary;
  final bool agreedToTerms;
  final String strategyDescription;

  TradeProviderApplicationDraft copyWith({
    bool? hasKyc,
    int? tradingMonths,
    int? minCapital,
    int? performanceFee,
    bool? agreedToDisclosure,
    bool? agreedToFiduciary,
    bool? agreedToTerms,
    String? strategyDescription,
  }) {
    return TradeProviderApplicationDraft(
      hasKyc: hasKyc ?? this.hasKyc,
      tradingMonths: tradingMonths ?? this.tradingMonths,
      minCapital: minCapital ?? this.minCapital,
      performanceFee: performanceFee ?? this.performanceFee,
      agreedToDisclosure: agreedToDisclosure ?? this.agreedToDisclosure,
      agreedToFiduciary: agreedToFiduciary ?? this.agreedToFiduciary,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      strategyDescription: strategyDescription ?? this.strategyDescription,
    );
  }
}

final class TradeProviderApplicationResult {
  const TradeProviderApplicationResult({
    required this.applicationId,
    required this.status,
    required this.reviewWindow,
  });

  final String applicationId;
  final String status;
  final String reviewWindow;
}

final class TradeCopyProviderDetailSnapshot {
  const TradeCopyProviderDetailSnapshot({
    required this.providerId,
    required this.provider,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.notFoundMessage = 'Provider không tồn tại',
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String notFoundMessage;

  bool get isNotFound => provider == null;
}

final class TradePreCopyAssessmentSnapshot {
  const TradePreCopyAssessmentSnapshot({
    required this.providerId,
    required this.provider,
    required this.questions,
    required this.educationDocs,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradePreCopyQuestion> questions;
  final List<TradePreCopyEducationDoc> educationDocs;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradePreCopyQuestion {
  const TradePreCopyQuestion({
    required this.id,
    required this.question,
    required this.description,
    required this.options,
  });

  final String id;
  final String question;
  final String description;
  final List<TradePreCopyOption> options;
}

final class TradePreCopyOption {
  const TradePreCopyOption({
    required this.value,
    required this.label,
    required this.score,
  });

  final String value;
  final String label;
  final int score;
}

final class TradePreCopyEducationDoc {
  const TradePreCopyEducationDoc({
    required this.id,
    required this.title,
    required this.duration,
  });

  final String id;
  final String title;
  final String duration;
}

enum TradeCopyConfigurationMode { mirror, fixed, smart }

enum TradePositionSizingMethod { percentage, fixedAmount, riskBased }

enum TradeCopyConfigurationValidationLevel { error, warning, info }

final class TradeCopyConfigurationSnapshot {
  const TradeCopyConfigurationSnapshot({
    required this.providerId,
    required this.provider,
    required this.defaultDraft,
    required this.totalPortfolio,
    required this.currentCopyAllocation,
    required this.availableCapital,
    required this.feePreview,
    required this.validations,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final TradeCopyConfigurationDraft defaultDraft;
  final double totalPortfolio;
  final double currentCopyAllocation;
  final double availableCapital;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyConfigurationValidation> validations;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradeCopyConfigurationDraft {
  const TradeCopyConfigurationDraft({
    required this.providerId,
    required this.copyCapital,
    required this.copyMode,
    required this.positionSizing,
    required this.copyRatio,
    required this.useCustomStopLoss,
    required this.customStopLoss,
    required this.useCustomTakeProfit,
    required this.customTakeProfit,
    required this.useTrailingStop,
    required this.trailingStopPercent,
  });

  final String providerId;
  final double copyCapital;
  final TradeCopyConfigurationMode copyMode;
  final TradePositionSizingMethod positionSizing;
  final double copyRatio;
  final bool useCustomStopLoss;
  final double customStopLoss;
  final bool useCustomTakeProfit;
  final double customTakeProfit;
  final bool useTrailingStop;
  final double trailingStopPercent;

  TradeCopyConfigurationDraft copyWith({
    double? copyCapital,
    TradeCopyConfigurationMode? copyMode,
    TradePositionSizingMethod? positionSizing,
    double? copyRatio,
    bool? useCustomStopLoss,
    double? customStopLoss,
    bool? useCustomTakeProfit,
    double? customTakeProfit,
    bool? useTrailingStop,
    double? trailingStopPercent,
  }) {
    return TradeCopyConfigurationDraft(
      providerId: providerId,
      copyCapital: copyCapital ?? this.copyCapital,
      copyMode: copyMode ?? this.copyMode,
      positionSizing: positionSizing ?? this.positionSizing,
      copyRatio: copyRatio ?? this.copyRatio,
      useCustomStopLoss: useCustomStopLoss ?? this.useCustomStopLoss,
      customStopLoss: customStopLoss ?? this.customStopLoss,
      useCustomTakeProfit: useCustomTakeProfit ?? this.useCustomTakeProfit,
      customTakeProfit: customTakeProfit ?? this.customTakeProfit,
      useTrailingStop: useTrailingStop ?? this.useTrailingStop,
      trailingStopPercent: trailingStopPercent ?? this.trailingStopPercent,
    );
  }
}

final class TradeCopyConfigurationFeePreview {
  const TradeCopyConfigurationFeePreview({
    required this.platformFee,
    required this.estimatedTradingFees,
    required this.performanceFeeNote,
  });

  final double platformFee;
  final double estimatedTradingFees;
  final String performanceFeeNote;

  double get totalFixedFees => platformFee + estimatedTradingFees;
}
