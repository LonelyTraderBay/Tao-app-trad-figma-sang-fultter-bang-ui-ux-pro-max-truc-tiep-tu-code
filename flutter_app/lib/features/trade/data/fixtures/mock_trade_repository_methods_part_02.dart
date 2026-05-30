part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryMethodsPart02 on _MockTradeRepositoryBase {
  @override
  TradeCopyCardDemoSnapshot getCopyCardDemo() {
    return const TradeCopyCardDemoSnapshot(
      endpoint: '/api/mobile/demo/demo-copy-card',
      actionDraft: 'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
      ],
      title: 'Copy Trading Card Analysis',
      backRoute: '/home',
      metrics: TradeCopyCardMetrics(
        traders: 5,
        copiers: 11000,
        aumUsd: 19250000,
        aumTrendPercent: 12.3,
        lastUpdated: '2 mins ago',
      ),
      improvements: [
        'AUM gets featured treatment (centered, 28px bold)',
        'Trend appears below value with direction and context',
        'Removed color semantics confusion with neutral metrics',
        'Added timestamp transparency',
        'Typography hierarchy follows information priority',
        'Number formatting optimized (11K not 11.0K)',
      ],
      variants: [
        TradeCopyCardVariantDraft(
          id: 'hero',
          title: 'Variant A: Hero Metric Pattern',
          badge: 'RECOMMENDED',
          notesTitle: 'Why better:',
          notes: [
            'AUM (primary metric) gets largest visual weight',
            'Trend indicator adds context and transparency',
            'Icons replace color coding for accessibility',
            'Clear 3-tier hierarchy: hero, secondary, metadata',
            'Timestamp provides transparency',
          ],
        ),
        TradeCopyCardVariantDraft(
          id: 'tabular',
          title: 'Variant B: Financial Dashboard Pattern',
          badge: null,
          notesTitle: 'Why better:',
          notes: [
            'Scannable tabular layout',
            'Right-aligned numbers support comparison',
            'Neutral professional metrics',
            'Explicit timestamp and info access',
            'Follows clarity over density principle',
          ],
        ),
        TradeCopyCardVariantDraft(
          id: 'compact',
          title: 'Variant C: Compact (Original Structure Refined)',
          badge: null,
          notesTitle: 'Changes from original:',
          notes: [
            'Removed colored values from non-profit metrics',
            'AUM gets subtle highlight to show priority',
            'Number format: 11K instead of 11.0K',
            'Tabular numbers for alignment',
            'Equal spacing follows the 8pt grid',
          ],
        ),
      ],
      issues: [
        TradeCopyCardIssue(
          category: 'Visual Hierarchy',
          description: 'AUM prominence and metric priority',
          original: TradeCopyCardCompliance.fail,
          variantA: TradeCopyCardCompliance.pass,
          variantB: TradeCopyCardCompliance.warn,
          variantC: TradeCopyCardCompliance.warn,
        ),
        TradeCopyCardIssue(
          category: 'Color Semantics',
          description: 'No misleading green/orange for metrics',
          original: TradeCopyCardCompliance.fail,
          variantA: TradeCopyCardCompliance.pass,
          variantB: TradeCopyCardCompliance.pass,
          variantC: TradeCopyCardCompliance.pass,
        ),
        TradeCopyCardIssue(
          category: 'Trust Transparency',
          description: 'Timestamp and trend indicators',
          original: TradeCopyCardCompliance.fail,
          variantA: TradeCopyCardCompliance.pass,
          variantB: TradeCopyCardCompliance.pass,
          variantC: TradeCopyCardCompliance.fail,
        ),
        TradeCopyCardIssue(
          category: 'Number Format',
          description: '11K not 11.0K, tabular-nums',
          original: TradeCopyCardCompliance.warn,
          variantA: TradeCopyCardCompliance.pass,
          variantB: TradeCopyCardCompliance.pass,
          variantC: TradeCopyCardCompliance.pass,
        ),
        TradeCopyCardIssue(
          category: 'Beginner-First',
          description: 'Icons, context, explanatory features',
          original: TradeCopyCardCompliance.fail,
          variantA: TradeCopyCardCompliance.pass,
          variantB: TradeCopyCardCompliance.pass,
          variantC: TradeCopyCardCompliance.warn,
        ),
        TradeCopyCardIssue(
          category: 'Accessibility',
          description: 'Not color-dependent, contrast OK',
          original: TradeCopyCardCompliance.fail,
          variantA: TradeCopyCardCompliance.pass,
          variantB: TradeCopyCardCompliance.pass,
          variantC: TradeCopyCardCompliance.warn,
        ),
        TradeCopyCardIssue(
          category: 'Scanability',
          description: 'Quick focal point identification',
          original: TradeCopyCardCompliance.fail,
          variantA: TradeCopyCardCompliance.pass,
          variantB: TradeCopyCardCompliance.pass,
          variantC: TradeCopyCardCompliance.warn,
        ),
      ],
      originalIssues: [
        TradeCopyCardTextBlock(
          title: '1. Visual Hierarchy',
          body:
              'AUM is the most critical metric but had equal weight with others.',
        ),
        TradeCopyCardTextBlock(
          title: '2. Color Semantics',
          body:
              'Green and orange metric colors could imply profit or warning states.',
        ),
        TradeCopyCardTextBlock(
          title: '3. Number Formatting',
          body:
              '11.0K has unnecessary precision and dynamic values need tabular figures.',
        ),
        TradeCopyCardTextBlock(
          title: '4. Trust & Transparency',
          body:
              'Timestamp, trend direction and metric definitions were missing.',
        ),
        TradeCopyCardTextBlock(
          title: '5. Typography Hierarchy',
          body: 'All values used similar scale, so priority was unclear.',
        ),
      ],
      recommendation:
          'Use Variant A (Hero Metric Pattern) for production deployment.',
      recommendationReasons: [
        'Aligns with fintech best practices',
        'Follows trust-first and no dark patterns guidance',
        'Clear hierarchy guides user attention correctly',
        'Transparency features build trust',
        'Accessible icon and text pairing',
        'Responsive to future tooltips and modals',
      ],
      guidelines: [
        TradeCopyCardTextBlock(
          title: 'Trust-first',
          body: 'Added timestamp, trend and info access.',
        ),
        TradeCopyCardTextBlock(
          title: 'Clarity over density',
          body: 'Hierarchy prioritizes scanability.',
        ),
        TradeCopyCardTextBlock(
          title: 'Readability',
          body: 'Icon is not color-only and contrast is normalized.',
        ),
        TradeCopyCardTextBlock(
          title: 'Number clarity',
          body: 'Tabular numbers and compact formatting.',
        ),
      ],
      contractNotes:
          'Reference/admin surface gated behind internal role or dev flag. Follow/configure/stop actions are mock-local and map to the copy trading action contract.',
    );
  }

  @override
  TradeCopyEducationSnapshot getCopyEducation() {
    return TradeCopyEducationSnapshot(
      trade: getTrade(),
      tabs: _copyEducationTabs,
      defaultTab: 'how-it-works',
      introTitle: 'Học trước khi đầu tư',
      introDescription:
          'Trang này giúp bạn hiểu rõ cơ chế, rủi ro và chi phí của Copy Trading. Không có gì thay thế được hiểu biết đầy đủ.',
      steps: _copyEducationSteps,
      copyModes: _copyModeGuides,
      concepts: _copyConceptGuides,
      lastUpdatedLabel: '2 mins ago',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeActiveCopiesSnapshot getActiveCopies() {
    return TradeActiveCopiesSnapshot(
      trade: getTrade(),
      portfolio: const TradeActiveCopyPortfolio(
        totalCapital: 10000,
        totalValue: 10500,
        totalPnl: 500,
        totalPnlPct: 5,
        activeCopies: 2,
        totalCopies: 3,
      ),
      tabs: const [
        TradeActiveCopiesTab(id: 'all', label: 'Tất cả', badge: 3),
        TradeActiveCopiesTab(id: 'active', label: 'Đang chạy', badge: 2),
        TradeActiveCopiesTab(id: 'paused', label: 'Tạm dừng'),
        TradeActiveCopiesTab(id: 'history', label: 'Lịch sử'),
      ],
      defaultTab: 'all',
      copies: _activeCopies,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopySettingsSnapshot getCopySettings() {
    return TradeCopySettingsSnapshot(
      trade: getTrade(),
      settings: _defaultCopySettings,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyNotificationsSnapshot getCopyNotifications() {
    final unreadCount = _copyNotifications
        .where((notification) => !notification.read)
        .length;
    final tradeCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.trade &&
              !notification.read,
        )
        .length;
    final riskCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.risk &&
              !notification.read,
        )
        .length;
    final updateCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.update &&
              !notification.read,
        )
        .length;
    final systemCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.system &&
              !notification.read,
        )
        .length;

    return TradeCopyNotificationsSnapshot(
      trade: getTrade(),
      defaultTab: 'all',
      tabs: [
        TradeCopyNotificationTab(
          id: 'all',
          label: 'Tất cả',
          badge: unreadCount == 0 ? null : unreadCount,
        ),
        TradeCopyNotificationTab(
          id: 'unread',
          label: 'Chưa đọc',
          badge: unreadCount == 0 ? null : unreadCount,
        ),
        TradeCopyNotificationTab(
          id: 'trade',
          label: 'Trades',
          badge: tradeCount == 0 ? null : tradeCount,
        ),
        TradeCopyNotificationTab(
          id: 'risk',
          label: 'Rủi ro',
          badge: riskCount == 0 ? null : riskCount,
        ),
        TradeCopyNotificationTab(
          id: 'update',
          label: 'Cập nhật',
          badge: updateCount == 0 ? null : updateCount,
        ),
        TradeCopyNotificationTab(
          id: 'system',
          label: 'Hệ thống',
          badge: systemCount == 0 ? null : systemCount,
        ),
      ],
      notifications: _copyNotifications,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeProviderApplicationSnapshot getProviderApplication() {
    return TradeProviderApplicationSnapshot(
      trade: getTrade(),
      steps: const [
        TradeProviderApplicationStep.intro,
        TradeProviderApplicationStep.requirements,
        TradeProviderApplicationStep.disclosure,
        TradeProviderApplicationStep.fees,
        TradeProviderApplicationStep.review,
      ],
      defaultStep: TradeProviderApplicationStep.intro,
      benefits: _providerApplicationBenefits,
      requirements: _providerApplicationRequirements,
      responsibilities: _providerApplicationResponsibilities,
      defaultDraft: _defaultProviderApplicationDraft,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyProviderDetailSnapshot getCopyProviderDetail({
    String providerId = 'provider001',
  }) {
    TradeCopyTrader? provider;
    for (final trader in _copyTraders) {
      if (trader.id == providerId) {
        provider = trader;
        break;
      }
    }

    return TradeCopyProviderDetailSnapshot(
      providerId: providerId,
      provider: provider,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePreCopyAssessmentSnapshot getPreCopyAssessment({
    String providerId = 'provider001',
  }) {
    final detail = getCopyProviderDetail(providerId: providerId);
    return TradePreCopyAssessmentSnapshot(
      providerId: providerId,
      provider: detail.provider,
      questions: _preCopyQuestions,
      educationDocs: _preCopyEducationDocs,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyConfigurationSnapshot getCopyConfiguration({
    String providerId = 'provider001',
  }) {
    final detail = getCopyProviderDetail(providerId: providerId);
    final defaultDraft = TradeCopyConfigurationDraft(
      providerId: providerId,
      copyCapital: 5000,
      copyMode: TradeCopyConfigurationMode.fixed,
      positionSizing: TradePositionSizingMethod.percentage,
      copyRatio: 50,
      useCustomStopLoss: false,
      customStopLoss: 10,
      useCustomTakeProfit: false,
      customTakeProfit: 20,
      useTrailingStop: false,
      trailingStopPercent: 5,
    );

    return TradeCopyConfigurationSnapshot(
      providerId: providerId,
      provider: detail.provider,
      defaultDraft: defaultDraft,
      totalPortfolio: 25000,
      currentCopyAllocation: 8000,
      availableCapital: 17000,
      feePreview: _copyConfigurationFeePreview(defaultDraft),
      validations: _copyConfigurationValidations(defaultDraft, detail.provider),
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyConfirmationSnapshot getCopyConfirmation({
    String providerId = 'provider001',
  }) {
    final configuration = getCopyConfiguration(providerId: providerId);
    return TradeCopyConfirmationSnapshot(
      providerId: providerId,
      provider: configuration.provider,
      configuration: configuration.defaultDraft,
      feePreview: configuration.feePreview,
      scenarios: _copyScenarioProjections(
        configuration.defaultDraft,
        configuration.feePreview,
      ),
      maxLossAmount: configuration.defaultDraft.useCustomStopLoss
          ? configuration.defaultDraft.copyCapital *
                configuration.defaultDraft.customStopLoss /
                100
          : configuration.defaultDraft.copyCapital,
      consentItems: _copyConfirmationConsents,
      coolingOffHours: 24,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyPerformanceSnapshot getCopyPerformance({String copyId = 'copy001'}) {
    return TradeCopyPerformanceSnapshot(
      copyId: copyId,
      initialCapital: 5000,
      yourReturnPct: 13,
      providerReturnPct: 15.6,
      yourCurrentValue: 5650,
      providerTheoreticalValue: 5780,
      performanceGapPct: 2.6,
      avgSlippagePct: .68,
      providerAvgSlippagePct: .48,
      totalCosts: 290,
      equityCurve: _copyPerformanceEquityCurve,
      slippageBuckets: _copyPerformanceSlippageBuckets,
      costAttribution: _copyPerformanceCostAttribution,
      tradeComparisons: _copyPerformanceTrades,
      metrics: _copyPerformanceMetrics,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }
}
