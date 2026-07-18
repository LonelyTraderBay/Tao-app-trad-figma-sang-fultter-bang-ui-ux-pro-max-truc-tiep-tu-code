part of 'mock_dev_tools_repository.dart';

final class MockDesignSystemRepository extends _MockDevToolsRepositoryBase
    implements DesignSystemRepository {
  const MockDesignSystemRepository({super.simulateError, super.loadDelay});

  @override
  Future<DesignSystemSnapshot> getDesignSystem() async {
    await _simulateNetwork();
    return const DesignSystemSnapshot(
      endpoint: '/api/mobile/dev/dev-design-system',
      actionDraft: 'read-only or local navigation action',
      title: 'Design System',
      subtitle: 'Dev · Design System',
      backRoute: '/home',
      heroEyebrow: 'Enterprise Design System',
      heroTitle: 'VitTrade UI Kit',
      heroDescription:
          'Shared components, design tokens, và enterprise standards cho iPhone 16 Pro Max (440×956pt).',
      tokens: [
        DesignTokenDraft(label: '--input-height', value: '52px'),
        DesignTokenDraft(label: '--input-radius', value: '14px'),
        DesignTokenDraft(label: '--cta-height', value: '52px'),
        DesignTokenDraft(label: '--cta-radius', value: '14px'),
        DesignTokenDraft(label: '--card-radius', value: '16px (rounded-2xl)'),
        DesignTokenDraft(
          label: '--card-radius-lg',
          value: '20px (rounded-3xl)',
        ),
        DesignTokenDraft(label: '--device-content-pad', value: '20px (px-5)'),
        DesignTokenDraft(label: '--section-gap', value: '20px'),
        DesignTokenDraft(label: '--row-py', value: '14px'),
      ],
      swatches: [
        DesignSwatchDraft(id: 'primary', label: 'Primary', value: '#E58A00'),
        DesignSwatchDraft(id: 'success', label: 'Success', value: '#10B981'),
        DesignSwatchDraft(id: 'danger', label: 'Danger', value: '#EF4444'),
        DesignSwatchDraft(id: 'warning', label: 'Warning', value: '#F5A524'),
        DesignSwatchDraft(id: 'accent', label: 'Accent', value: '#8B5CF6'),
        DesignSwatchDraft(id: 'bg', label: 'BG', value: '#07090D'),
        DesignSwatchDraft(id: 'card', label: 'Card', value: '#10141B'),
        DesignSwatchDraft(id: 'input', label: 'Input', value: '#171C24'),
        DesignSwatchDraft(id: 'border', label: 'Border', value: '#2D3440'),
        DesignSwatchDraft(id: 'text', label: 'Text', value: '#F5F7FA'),
        DesignSwatchDraft(id: 'label', label: 'Label', value: '#A7AFBF'),
        DesignSwatchDraft(id: 'muted', label: 'Muted', value: '#667085'),
        DesignSwatchDraft(id: 'buy', label: 'Buy', value: '#10B981'),
        DesignSwatchDraft(id: 'sell', label: 'Sell', value: '#EF4444'),
        DesignSwatchDraft(id: 'link', label: 'Link', value: '#E58A00'),
      ],
      ctaDemos: [
        DesignCtaDemoDraft(id: 'primary', label: 'Mua BTC', variant: 'primary'),
        DesignCtaDemoDraft(
          id: 'success',
          label: 'Xác nhận giao dịch',
          variant: 'success',
        ),
        DesignCtaDemoDraft(id: 'danger', label: 'Bán BTC', variant: 'danger'),
        DesignCtaDemoDraft(
          id: 'ghost',
          label: 'Đăng nhập Demo',
          variant: 'ghost',
        ),
        DesignCtaDemoDraft(
          id: 'loading',
          label: 'Đang xử lý...',
          variant: 'primary',
          loading: true,
        ),
        DesignCtaDemoDraft(
          id: 'disabled',
          label: 'Chưa đủ điều kiện',
          variant: 'primary',
          disabled: true,
        ),
      ],
      inputDemos: [
        DesignInputDemoDraft(
          id: 'basic',
          caption: 'Basic with label',
          label: 'Email / Số điện thoại',
          placeholder: 'you@example.com',
        ),
        DesignInputDemoDraft(
          id: 'password',
          caption: 'With prefix + suffix icons',
          label: 'Mật khẩu',
          placeholder: '••••••••',
          prefix: true,
          suffix: true,
          obscure: true,
        ),
        DesignInputDemoDraft(
          id: 'search',
          caption: 'Search with prefix icon',
          label: '',
          placeholder: 'Tìm kiếm coin, token...',
          prefix: true,
        ),
        DesignInputDemoDraft(
          id: 'error',
          caption: 'Error state',
          label: 'Số lượng',
          placeholder: '0.00',
          value: 'abc',
          error: 'Số lượng không hợp lệ',
        ),
      ],
      sectionDemos: [
        DesignSectionDemoDraft(title: 'Thông tin đơn hàng'),
        DesignSectionDemoDraft(title: 'Giao dịch gần đây'),
        DesignSectionDemoDraft(
          title: 'Phương thức thanh toán',
          subtitle: 'Chọn tối đa 5 phương thức',
        ),
        DesignSectionDemoDraft(title: 'Tài sản của tôi', badge: '+12.5%'),
      ],
      playgroundControls: [
        'variant',
        'children (text)',
        'disabled',
        'loading',
        'fullWidth',
        'prefix',
        'suffix',
      ],
      footerTitle:
          'VitTrade Design System v2.4 — iPhone 16 Pro Max (440×956pt)',
      footerSubtitle: 'Golden Ratio φ = 1.618 • Enterprise Fintech Standards',
      contractNotes:
          'Reference/admin surface; gate behind internal role or dev flag. Token values mirror the Flutter Home foundation and normalize legacy web blue surfaces to AppColors.',
      supportedStates: {
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      },
    );
  }
}

final class MockPerformanceMonitorRepository extends _MockDevToolsRepositoryBase
    implements PerformanceMonitorRepository {
  const MockPerformanceMonitorRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<PerformanceMonitorSnapshot> getPerformanceMonitor() async {
    await _simulateNetwork();
    return const PerformanceMonitorSnapshot(
      endpoint: '/api/mobile/dev/dev-performance-monitor',
      actionDraft: 'read-only or local navigation action',
      title: 'Performance Monitor',
      subtitle: 'Based on Core Web Vitals',
      backRoute: '/home',
      summaryMetrics: [
        PerformanceSummaryMetric(
          label: 'FCP',
          value: '6244ms',
          tone: PerformanceScoreTone.poor,
        ),
        PerformanceSummaryMetric(
          label: 'LCP',
          value: '0ms',
          tone: PerformanceScoreTone.good,
        ),
        PerformanceSummaryMetric(
          label: 'Load Time',
          value: '0.00s',
          tone: PerformanceScoreTone.good,
        ),
      ],
      vitals: [
        PerformanceVitalMetric(
          label: 'First Paint (FP)',
          value: '6196ms',
          progress: 1,
          tone: PerformanceScoreTone.poor,
        ),
        PerformanceVitalMetric(
          label: 'First Contentful Paint (FCP)',
          value: '6244ms',
          progress: 1,
          tone: PerformanceScoreTone.poor,
        ),
        PerformanceVitalMetric(
          label: 'Largest Contentful Paint (LCP)',
          value: '0ms',
          progress: 0.02,
          tone: PerformanceScoreTone.good,
        ),
        PerformanceVitalMetric(
          label: 'DOM Content Loaded',
          value: '6189ms',
          progress: 1,
          tone: PerformanceScoreTone.poor,
        ),
        PerformanceVitalMetric(
          label: 'Page Load',
          value: '0ms',
          progress: 1,
          tone: PerformanceScoreTone.good,
        ),
      ],
      memory: PerformanceMemoryUsage(
        usedLabel: '87.5 MB',
        limitLabel: 'of 3586 MB limit',
        percentLabel: '2.4%',
        progress: 0.024,
      ),
      lazyChunks: [
        'chunk-2TUXMMP5.js?v=05a0af4a',
        'chunk-73THXJN7.js?v=05a0af4a',
        'chunk-IXXKGCW7.js?v=05a0af4a',
      ],
      resources: [
        PerformanceResourceTiming(
          name: 'ArenaPointsLedgerPage.tsx',
          type: 'script',
          size: '45.2 KB',
          duration: '5.25s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaTrustBreakdownPage.tsx',
          type: 'script',
          size: '21.8 KB',
          duration: '5.23s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaSafetyCenterPage.tsx',
          type: 'script',
          size: '84.2 KB',
          duration: '5.23s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaFlowMapPage.tsx',
          type: 'script',
          size: '179.1 KB',
          duration: '5.23s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaPointsPage.tsx',
          type: 'script',
          size: '5.2 KB',
          duration: '5.18s',
        ),
        PerformanceResourceTiming(
          name: 'VerifiedChallengesPage.tsx',
          type: 'script',
          size: '16.6 KB',
          duration: '5.18s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaLeaderboardPage.tsx',
          type: 'script',
          size: '97.6 KB',
          duration: '5.18s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaCreatorPage.tsx',
          type: 'script',
          size: '105.5 KB',
          duration: '5.18s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaResolutionCenterPage.tsx',
          type: 'script',
          size: '106.0 KB',
          duration: '5.18s',
        ),
        PerformanceResourceTiming(
          name: 'ArenaJoinPage.tsx',
          type: 'script',
          size: '71.0 KB',
          duration: '5.18s',
        ),
      ],
      tips: [
        PerformanceOptimizationTip(
          title: 'Lazy Loading Active',
          body:
              'Staking routes are code-split. About 251KB saved on initial load.',
          tone: PerformanceScoreTone.good,
        ),
        PerformanceOptimizationTip(
          title: 'Bundle Splitting',
          body: 'Charts load only when needed. Recharts is about 50KB gzipped.',
          tone: PerformanceScoreTone.warning,
        ),
        PerformanceOptimizationTip(
          title: 'First Visit Caching',
          body:
              'After first load, chunks are cached. Subsequent visits are near-instant.',
          tone: PerformanceScoreTone.warning,
        ),
      ],
      targets: [
        'FCP < 1.8s (Good)',
        'LCP < 2.5s (Good)',
        'Total Load < 3s (Good)',
        'Memory < 50MB (Mobile-friendly)',
      ],
      contractNotes:
          'Reference/admin surface. Keep behind internal role or dev flag. Metrics are mock reference data until native runtime instrumentation is added.',
      supportedStates: {
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      },
    );
  }
}
