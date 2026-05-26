enum AdminScreenState { loading, empty, error, offline }

enum AdminMetricAccent { accent, primary, success }

enum AdminDashboardIcon { analytics, experiment, funnel }

enum AdminAnalyticsRange { sevenDays, thirtyDays, ninetyDays }

enum AdminAbTestStatus { active, completed }

class AdminHomeSnapshot {
  const AdminHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.adminMetrics,
    required this.quickStats,
    required this.liveStats,
    required this.dashboards,
    required this.analyticsEvents,
    required this.funnels,
    required this.experiments,
  });

  final String endpoint;
  final String actionDraft;
  final List<AdminScreenState> supportedStates;
  final AdminMetrics adminMetrics;
  final List<AdminMetricTile> quickStats;
  final List<AdminMetricTile> liveStats;
  final List<AdminDashboardLink> dashboards;
  final List<AdminAnalyticsEvent> analyticsEvents;
  final List<AdminFunnelDraft> funnels;
  final List<AdminExperimentDraft> experiments;
}

class AdminMetrics {
  const AdminMetrics({
    required this.totalEvents,
    required this.totalTests,
    required this.totalFunnels,
    required this.eventsPerMinute,
    required this.activeUsers,
    required this.healthLabel,
    required this.liveEventWindowLabel,
    required this.lastUpdatedTime,
    required this.footerUpdatedLabel,
  });

  final int totalEvents;
  final int totalTests;
  final int totalFunnels;
  final String eventsPerMinute;
  final int activeUsers;
  final String healthLabel;
  final String liveEventWindowLabel;
  final String lastUpdatedTime;
  final String footerUpdatedLabel;
}

class AdminMetricTile {
  const AdminMetricTile({
    required this.label,
    required this.value,
    required this.accent,
    required this.icon,
  });

  final String label;
  final String value;
  final AdminMetricAccent accent;
  final AdminDashboardIcon icon;
}

class AdminDashboardLink {
  const AdminDashboardLink({
    required this.id,
    required this.title,
    required this.description,
    required this.route,
    required this.stat,
    required this.accent,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String route;
  final String stat;
  final AdminMetricAccent accent;
  final AdminDashboardIcon icon;
}

class AdminAnalyticsEvent {
  const AdminAnalyticsEvent();
}

class AdminFunnelDraft {
  const AdminFunnelDraft();
}

class AdminExperimentDraft {
  const AdminExperimentDraft();
}

class AdminAnalyticsSnapshot {
  const AdminAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.realtimeRefresh,
    required this.activeRange,
    required this.ranges,
    required this.totalEvents,
    required this.uniqueUsers,
    required this.eventsPerDayLabel,
    required this.dailyStats,
    required this.topEvents,
    required this.recentEvents,
    required this.queueSummary,
    required this.analyticsEvents,
    required this.funnels,
    required this.experiments,
    required this.adminMetrics,
  });

  final String endpoint;
  final String actionDraft;
  final List<AdminScreenState> supportedStates;
  final bool realtimeRefresh;
  final AdminAnalyticsRange activeRange;
  final List<AdminAnalyticsRangeOption> ranges;
  final int totalEvents;
  final int uniqueUsers;
  final String eventsPerDayLabel;
  final List<AdminDailyStat> dailyStats;
  final List<AdminEventSummary> topEvents;
  final List<AdminRecentEvent> recentEvents;
  final String queueSummary;
  final List<AdminAnalyticsEvent> analyticsEvents;
  final List<AdminFunnelDraft> funnels;
  final List<AdminExperimentDraft> experiments;
  final AdminMetrics adminMetrics;
}

class AdminAnalyticsRangeOption {
  const AdminAnalyticsRangeOption({required this.range, required this.label});

  final AdminAnalyticsRange range;
  final String label;
}

class AdminDailyStat {
  const AdminDailyStat({
    required this.label,
    required this.events,
    required this.users,
  });

  final String label;
  final int events;
  final int users;
}

class AdminEventSummary {
  const AdminEventSummary({
    required this.eventName,
    required this.count,
    required this.percentage,
  });

  final String eventName;
  final int count;
  final double percentage;
}

class AdminRecentEvent {
  const AdminRecentEvent({
    required this.eventName,
    required this.properties,
    required this.time,
    required this.date,
  });

  final String eventName;
  final String properties;
  final String time;
  final String date;
}

class AdminAbTestsSnapshot {
  const AdminAbTestsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.activeTests,
    required this.completedTests,
    required this.tests,
    required this.analyticsEvents,
    required this.funnels,
    required this.experiments,
    required this.adminMetrics,
  });

  final String endpoint;
  final String actionDraft;
  final List<AdminScreenState> supportedStates;
  final int activeTests;
  final int completedTests;
  final List<AdminAbTestSummary> tests;
  final List<AdminAnalyticsEvent> analyticsEvents;
  final List<AdminFunnelDraft> funnels;
  final List<AdminExperimentDraft> experiments;
  final AdminMetrics adminMetrics;
}

class AdminAbTestSummary {
  const AdminAbTestSummary({
    required this.id,
    required this.name,
    required this.status,
    required this.sampleSize,
    required this.confidenceLabel,
    required this.liftLabel,
    required this.zScoreLabel,
    required this.pValueLabel,
    required this.minSampleSize,
    required this.variants,
  });

  final String id;
  final String name;
  final AdminAbTestStatus status;
  final int sampleSize;
  final String confidenceLabel;
  final String liftLabel;
  final String zScoreLabel;
  final String pValueLabel;
  final int minSampleSize;
  final List<AdminAbTestVariant> variants;
}

class AdminAbTestVariant {
  const AdminAbTestVariant({
    required this.id,
    required this.label,
    required this.exposures,
    required this.conversions,
    required this.conversionRateLabel,
    required this.isControl,
    required this.isWinner,
  });

  final String id;
  final String label;
  final int exposures;
  final int conversions;
  final String conversionRateLabel;
  final bool isControl;
  final bool isWinner;
}

class AdminFunnelsSnapshot {
  const AdminFunnelsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.selectedFunnelId,
    required this.totalSessions,
    required this.completedSessions,
    required this.completionRateLabel,
    required this.avgCompletionTimeLabel,
    required this.funnels,
    required this.analyticsEvents,
    required this.experiments,
    required this.adminMetrics,
  });

  final String endpoint;
  final String actionDraft;
  final List<AdminScreenState> supportedStates;
  final String selectedFunnelId;
  final int totalSessions;
  final int completedSessions;
  final String completionRateLabel;
  final String avgCompletionTimeLabel;
  final List<AdminConversionFunnel> funnels;
  final List<AdminAnalyticsEvent> analyticsEvents;
  final List<AdminExperimentDraft> experiments;
  final AdminMetrics adminMetrics;
}

class AdminConversionFunnel {
  const AdminConversionFunnel({
    required this.id,
    required this.name,
    required this.stepCountLabel,
    required this.steps,
  });

  final String id;
  final String name;
  final String stepCountLabel;
  final List<AdminFunnelStep> steps;
}

class AdminFunnelStep {
  const AdminFunnelStep({required this.label});

  final String label;
  int get reached => 0;
  int get completed => 0;
  String get completionRateLabel => '0.0%';
  String get dropoutRateLabel => '0.0%';
  String get avgTimeLabel => '0s';
}
