import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AdminScreenState { loading, empty, error, offline }

enum AdminMetricAccent { accent, primary, success }

enum AdminDashboardIcon { analytics, experiment, funnel }

enum AdminAnalyticsRange { sevenDays, thirtyDays, ninetyDays }

enum AdminAbTestStatus { active, completed }

class AdminRepository {
  const AdminRepository();

  AdminHomeSnapshot getHome() {
    return const AdminHomeSnapshot(
      endpoint: '/api/mobile/admin/admin',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        AdminScreenState.loading,
        AdminScreenState.empty,
        AdminScreenState.error,
        AdminScreenState.offline,
      ],
      adminMetrics: AdminMetrics(
        totalEvents: 0,
        totalTests: 5,
        totalFunnels: 5,
        eventsPerMinute: '0',
        activeUsers: 0,
        healthLabel: 'Tốt',
        liveEventWindowLabel: '0 sự kiện (5 phút)',
        lastUpdatedTime: '23:33:46',
        footerUpdatedLabel: '23:33:46 18/5/2026',
      ),
      quickStats: [
        AdminMetricTile(
          label: 'Events',
          value: '0',
          accent: AdminMetricAccent.accent,
          icon: AdminDashboardIcon.analytics,
        ),
        AdminMetricTile(
          label: 'Tests',
          value: '5',
          accent: AdminMetricAccent.primary,
          icon: AdminDashboardIcon.experiment,
        ),
        AdminMetricTile(
          label: 'Funnels',
          value: '5',
          accent: AdminMetricAccent.success,
          icon: AdminDashboardIcon.funnel,
        ),
      ],
      liveStats: [
        AdminMetricTile(
          label: 'Events/phút',
          value: '0',
          accent: AdminMetricAccent.accent,
          icon: AdminDashboardIcon.analytics,
        ),
        AdminMetricTile(
          label: 'Users',
          value: '0',
          accent: AdminMetricAccent.primary,
          icon: AdminDashboardIcon.experiment,
        ),
        AdminMetricTile(
          label: 'Health',
          value: 'Tốt',
          accent: AdminMetricAccent.success,
          icon: AdminDashboardIcon.funnel,
        ),
      ],
      dashboards: [
        AdminDashboardLink(
          id: 'analytics',
          title: 'Analytics Dashboard',
          description: 'Event volume, top events, trends',
          route: '/admin/analytics',
          stat: '0 events',
          accent: AdminMetricAccent.accent,
          icon: AdminDashboardIcon.analytics,
        ),
        AdminDashboardLink(
          id: 'abtests',
          title: 'A/B Test Dashboard',
          description: 'Test results, statistical significance',
          route: '/admin/abtests',
          stat: '5 active',
          accent: AdminMetricAccent.primary,
          icon: AdminDashboardIcon.experiment,
        ),
        AdminDashboardLink(
          id: 'funnels',
          title: 'Funnel Dashboard',
          description: 'Conversion funnels, dropout analysis',
          route: '/admin/funnels',
          stat: '0 completed',
          accent: AdminMetricAccent.success,
          icon: AdminDashboardIcon.funnel,
        ),
      ],
      analyticsEvents: [],
      funnels: [],
      experiments: [],
    );
  }

  AdminAnalyticsSnapshot getAnalytics() {
    return const AdminAnalyticsSnapshot(
      endpoint: '/api/mobile/admin/admin-analytics',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        AdminScreenState.loading,
        AdminScreenState.empty,
        AdminScreenState.error,
        AdminScreenState.offline,
      ],
      realtimeRefresh: true,
      activeRange: AdminAnalyticsRange.sevenDays,
      ranges: [
        AdminAnalyticsRangeOption(
          range: AdminAnalyticsRange.sevenDays,
          label: '7 ngày',
        ),
        AdminAnalyticsRangeOption(
          range: AdminAnalyticsRange.thirtyDays,
          label: '30 ngày',
        ),
        AdminAnalyticsRangeOption(
          range: AdminAnalyticsRange.ninetyDays,
          label: '90 ngày',
        ),
      ],
      totalEvents: 0,
      uniqueUsers: 0,
      eventsPerDayLabel: '~0 sự kiện/ngày',
      dailyStats: [
        AdminDailyStat(label: '12 thg 5', events: 0, users: 0),
        AdminDailyStat(label: '14 thg 5', events: 0, users: 0),
        AdminDailyStat(label: '16 thg 5', events: 0, users: 0),
        AdminDailyStat(label: '18 thg 5', events: 0, users: 0),
      ],
      topEvents: [],
      recentEvents: [],
      queueSummary: 'Tổng 0 sự kiện trong queue • Cập nhật lần cuối: 23:33:48',
      analyticsEvents: [],
      funnels: [],
      experiments: [],
      adminMetrics: AdminMetrics(
        totalEvents: 0,
        totalTests: 5,
        totalFunnels: 5,
        eventsPerMinute: '0',
        activeUsers: 0,
        healthLabel: 'Tốt',
        liveEventWindowLabel: '0 sự kiện (5 phút)',
        lastUpdatedTime: '23:33:48',
        footerUpdatedLabel: '23:33:48 18/5/2026',
      ),
    );
  }

  AdminAbTestsSnapshot getAbTests() {
    return const AdminAbTestsSnapshot(
      endpoint: '/api/mobile/admin/admin-abtests',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        AdminScreenState.loading,
        AdminScreenState.empty,
        AdminScreenState.error,
        AdminScreenState.offline,
      ],
      activeTests: 5,
      completedTests: 0,
      tests: [
        AdminAbTestSummary(
          id: 'dca_wallet_shortcut_v1',
          name: 'Wallet Shortcut Design',
          status: AdminAbTestStatus.active,
          sampleSize: 0,
          confidenceLabel: '0.0%',
          liftLabel: 'NaN%',
          zScoreLabel: '0.000',
          pValueLabel: '1.0000',
          minSampleSize: 1000,
          variants: [
            AdminAbTestVariant(
              id: 'full',
              label: 'Variant FULL',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: true,
              isWinner: false,
            ),
            AdminAbTestVariant(
              id: 'compact',
              label: 'Variant COMPACT',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: false,
              isWinner: false,
            ),
          ],
        ),
        AdminAbTestSummary(
          id: 'dca_onboarding_v1',
          name: 'Onboarding Flow',
          status: AdminAbTestStatus.active,
          sampleSize: 0,
          confidenceLabel: '0.0%',
          liftLabel: 'NaN%',
          zScoreLabel: '0.000',
          pValueLabel: '1.0000',
          minSampleSize: 500,
          variants: [
            AdminAbTestVariant(
              id: 'v1',
              label: 'Variant V1',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: true,
              isWinner: false,
            ),
            AdminAbTestVariant(
              id: 'v2',
              label: 'Variant V2',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: false,
              isWinner: false,
            ),
            AdminAbTestVariant(
              id: 'v3',
              label: 'Variant V3',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: false,
              isWinner: false,
            ),
          ],
        ),
        AdminAbTestSummary(
          id: 'dca_frequency_v1',
          name: 'Frequency Presets',
          status: AdminAbTestStatus.active,
          sampleSize: 0,
          confidenceLabel: '0.0%',
          liftLabel: 'NaN%',
          zScoreLabel: '0.000',
          pValueLabel: '1.0000',
          minSampleSize: 800,
          variants: [
            AdminAbTestVariant(
              id: 'simple',
              label: 'Variant SIMPLE',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: true,
              isWinner: false,
            ),
            AdminAbTestVariant(
              id: 'advanced',
              label: 'Variant ADVANCED',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: false,
              isWinner: false,
            ),
          ],
        ),
        AdminAbTestSummary(
          id: 'dca_form_layout_v1',
          name: 'Create Form Layout',
          status: AdminAbTestStatus.active,
          sampleSize: 0,
          confidenceLabel: '0.0%',
          liftLabel: 'NaN%',
          zScoreLabel: '0.000',
          pValueLabel: '1.0000',
          minSampleSize: 600,
          variants: [
            AdminAbTestVariant(
              id: 'single_page',
              label: 'Variant SINGLE_PAGE',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: true,
              isWinner: false,
            ),
            AdminAbTestVariant(
              id: 'multi_step',
              label: 'Variant MULTI_STEP',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: false,
              isWinner: false,
            ),
          ],
        ),
        AdminAbTestSummary(
          id: 'dca_pair_detail_placement_v1',
          name: 'Pair Detail DCA Banner Placement',
          status: AdminAbTestStatus.active,
          sampleSize: 0,
          confidenceLabel: '0.0%',
          liftLabel: 'NaN%',
          zScoreLabel: '0.000',
          pValueLabel: '1.0000',
          minSampleSize: 1000,
          variants: [
            AdminAbTestVariant(
              id: 'after_risk',
              label: 'Variant AFTER_RISK',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: true,
              isWinner: false,
            ),
            AdminAbTestVariant(
              id: 'before_risk',
              label: 'Variant BEFORE_RISK',
              exposures: 0,
              conversions: 0,
              conversionRateLabel: '0.0%',
              isControl: false,
              isWinner: false,
            ),
          ],
        ),
      ],
      analyticsEvents: [],
      funnels: [],
      experiments: [],
      adminMetrics: AdminMetrics(
        totalEvents: 0,
        totalTests: 5,
        totalFunnels: 5,
        eventsPerMinute: '0',
        activeUsers: 0,
        healthLabel: 'Tốt',
        liveEventWindowLabel: '0 sự kiện (5 phút)',
        lastUpdatedTime: '23:33:48',
        footerUpdatedLabel: '23:33:48 18/5/2026',
      ),
    );
  }

  AdminFunnelsSnapshot getFunnels() {
    return const AdminFunnelsSnapshot(
      endpoint: '/api/mobile/admin/admin-funnels',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        AdminScreenState.loading,
        AdminScreenState.empty,
        AdminScreenState.error,
        AdminScreenState.offline,
      ],
      selectedFunnelId: 'wallet_to_creation',
      totalSessions: 0,
      completedSessions: 0,
      completionRateLabel: '0.0%',
      avgCompletionTimeLabel: '0s',
      funnels: [
        AdminConversionFunnel(
          id: 'wallet_to_creation',
          name: 'Wallet Discovery → Plan Creation',
          stepCountLabel: '6 bước',
          steps: [
            AdminFunnelStep(label: 'Wallet Page View'),
            AdminFunnelStep(label: 'Shortcut Impression'),
            AdminFunnelStep(label: 'Shortcut Click'),
            AdminFunnelStep(label: 'DCA Page View'),
            AdminFunnelStep(label: 'Create Button Click'),
            AdminFunnelStep(label: 'Plan Created'),
          ],
        ),
        AdminConversionFunnel(
          id: 'asset_to_creation',
          name: 'Asset Detail → Plan Creation',
          stepCountLabel: '6 bước',
          steps: [
            AdminFunnelStep(label: 'Asset Detail View'),
            AdminFunnelStep(label: 'DCA Button Impression'),
            AdminFunnelStep(label: 'DCA Button Click'),
            AdminFunnelStep(label: 'Create Sheet Opened'),
            AdminFunnelStep(label: 'Preselected Coin Used'),
            AdminFunnelStep(label: 'Plan Created'),
          ],
        ),
        AdminConversionFunnel(
          id: 'first_time_user',
          name: 'First-Time User Journey',
          stepCountLabel: '5 bước',
          steps: [
            AdminFunnelStep(label: 'DCA Page View'),
            AdminFunnelStep(label: 'Empty State Impression'),
            AdminFunnelStep(label: 'Empty State CTA Click'),
            AdminFunnelStep(label: 'Create Sheet Opened'),
            AdminFunnelStep(label: 'First Plan Created'),
          ],
        ),
        AdminConversionFunnel(
          id: 'plan_activation',
          name: 'Plan Activation',
          stepCountLabel: '3 bước',
          steps: [
            AdminFunnelStep(label: 'Plan Created'),
            AdminFunnelStep(label: 'Plan Details Viewed'),
            AdminFunnelStep(label: 'First Execution'),
          ],
        ),
        AdminConversionFunnel(
          id: 'pair_detail_to_creation',
          name: 'Pair Detail → Plan Creation',
          stepCountLabel: '7 bước',
          steps: [
            AdminFunnelStep(label: 'Pair Detail View'),
            AdminFunnelStep(label: 'DCA Banner Impression'),
            AdminFunnelStep(label: 'DCA Banner Click'),
            AdminFunnelStep(label: 'DCA Page View'),
            AdminFunnelStep(label: 'Preselected Coin Kept'),
            AdminFunnelStep(label: 'Create Sheet Opened'),
            AdminFunnelStep(label: 'Plan Created'),
          ],
        ),
      ],
      analyticsEvents: [],
      experiments: [],
      adminMetrics: AdminMetrics(
        totalEvents: 0,
        totalTests: 5,
        totalFunnels: 5,
        eventsPerMinute: '0',
        activeUsers: 0,
        healthLabel: 'Tốt',
        liveEventWindowLabel: '0 sự kiện (5 phút)',
        lastUpdatedTime: '23:33:48',
        footerUpdatedLabel: '23:33:48 18/5/2026',
      ),
    );
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return const AdminRepository();
});

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
