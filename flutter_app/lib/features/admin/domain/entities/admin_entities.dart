/// UI state an Admin screen snapshot supports rendering.
enum AdminScreenState { loading, empty, error, offline }

/// Accent color choice for an admin metric tile/dashboard link.
enum AdminMetricAccent { accent, primary, success }

/// Leading icon choice for an admin dashboard tile/link.
enum AdminDashboardIcon { analytics, experiment, funnel }

/// Time window filter for the admin analytics screen.
enum AdminAnalyticsRange { sevenDays, thirtyDays, ninetyDays }

/// Lifecycle status of an [AdminAbTestSummary].
enum AdminAbTestStatus { active, completed }

/// Data for the admin home screen: top-level [adminMetrics], quick/live
/// stat tiles, and dashboard shortcut links.
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

/// Top-level admin platform metrics (events, tests, funnels, active
/// users, health) shared across admin screens.
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

/// One labeled metric tile (value, delta, timeframe) on an admin screen.
class AdminMetricTile {
  const AdminMetricTile({
    required this.label,
    required this.value,
    required this.accent,
    required this.icon,
    this.deltaLabel = '0.0%',
    this.timeframeLabel = 'Current window',
  });

  final String label;
  final String value;
  final AdminMetricAccent accent;
  final AdminDashboardIcon icon;
  final String deltaLabel;
  final String timeframeLabel;
}

/// One navigation shortcut card (title/description/route/stat) on the
/// admin home screen.
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

/// Placeholder marker type for a raw analytics event reference shared
/// across admin snapshots.
class AdminAnalyticsEvent {
  const AdminAnalyticsEvent();
}

/// Placeholder marker type for a funnel reference shared across admin
/// snapshots.
class AdminFunnelDraft {
  const AdminFunnelDraft();
}

/// Placeholder marker type for an A/B test experiment reference shared
/// across admin snapshots.
class AdminExperimentDraft {
  const AdminExperimentDraft();
}

/// Data for the admin analytics screen: range-filtered daily stats, top/
/// recent events, and shared [adminMetrics].
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

/// One selectable [AdminAnalyticsRange] entry with its display label.
class AdminAnalyticsRangeOption {
  const AdminAnalyticsRangeOption({required this.range, required this.label});

  final AdminAnalyticsRange range;
  final String label;
}

/// One dated events/users data point in the admin analytics chart.
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

/// One aggregated event's count/share on the admin analytics "top events"
/// list.
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

/// One raw recent analytics event (name, properties, timestamp) on the
/// admin analytics screen.
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

/// Data for the admin A/B tests screen: active/completed counts and all
/// [tests].
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

/// One A/B test's statistical summary (sample size, confidence, lift,
/// p-value) and its [variants].
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

/// One variant's exposure/conversion stats within an [AdminAbTestSummary].
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

/// Data for the admin funnels screen: session/completion totals for the
/// [selectedFunnelId] plus all [funnels].
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

/// One named conversion funnel and its ordered [steps].
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

/// One step in an [AdminConversionFunnel], with reached/completed/dropout
/// stats.
class AdminFunnelStep {
  const AdminFunnelStep({required this.label});

  final String label;
  int get reached => 0;
  int get completed => 0;
  String get completionRateLabel => '0.0%';
  String get dropoutRateLabel => '0.0%';
  String get avgTimeLabel => '0s';
}
