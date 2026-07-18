import 'package:vit_trade_flutter/features/admin/domain/entities/admin_entities.dart';
import 'package:vit_trade_flutter/features/admin/domain/repositories/admin_repository.dart';

final class MockAdminRepository implements AdminRepository {
  const MockAdminRepository({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) throw StateError('admin_mock_fetch_failed');
  }

  @override
  Future<AdminHomeSnapshot> getHome() async {
    await _simulateNetwork();
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

  @override
  Future<AdminAnalyticsSnapshot> getAnalytics() async {
    await _simulateNetwork();
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

  @override
  Future<AdminAbTestsSnapshot> getAbTests() async {
    await _simulateNetwork();
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

  @override
  Future<AdminFunnelsSnapshot> getFunnels() async {
    await _simulateNetwork();
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
