import 'package:flutter_riverpod/flutter_riverpod.dart';

final routeCheckerRepositoryProvider = Provider<RouteCheckerRepository>((ref) {
  return const MockRouteCheckerRepository();
});

final performanceMonitorRepositoryProvider =
    Provider<PerformanceMonitorRepository>((ref) {
      return const MockPerformanceMonitorRepository();
    });

final missingScreensShowcaseRepositoryProvider =
    Provider<MissingScreensShowcaseRepository>((ref) {
      return const MockMissingScreensShowcaseRepository();
    });

final designSystemRepositoryProvider = Provider<DesignSystemRepository>((ref) {
  return const MockDesignSystemRepository();
});

abstract interface class RouteCheckerRepository {
  RouteCheckerSnapshot getRouteChecker();
}

abstract interface class PerformanceMonitorRepository {
  PerformanceMonitorSnapshot getPerformanceMonitor();
}

abstract interface class MissingScreensShowcaseRepository {
  MissingScreensShowcaseSnapshot getShowcase();
}

abstract interface class DesignSystemRepository {
  DesignSystemSnapshot getDesignSystem();
}

enum DevScreenState { loading, empty, error, offline }

enum PerformanceScoreTone { good, warning, poor }

final class RouteCheckerSnapshot {
  const RouteCheckerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.routes,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<DevRouteDraft> routes;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;

  int get totalRoutes => routes.length;

  List<int> get phases {
    final set = routes.map((route) => route.phase).toSet().toList()..sort();
    return set;
  }

  int phaseTotal(int phase) =>
      routes.where((route) => route.phase == phase).length;
}

final class DevRouteDraft {
  const DevRouteDraft({
    required this.path,
    required this.name,
    required this.phase,
    this.featured = false,
  });

  final String path;
  final String name;
  final int phase;
  final bool featured;
}

final class PerformanceMonitorSnapshot {
  const PerformanceMonitorSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.summaryMetrics,
    required this.vitals,
    required this.memory,
    required this.lazyChunks,
    required this.resources,
    required this.tips,
    required this.targets,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<PerformanceSummaryMetric> summaryMetrics;
  final List<PerformanceVitalMetric> vitals;
  final PerformanceMemoryUsage memory;
  final List<String> lazyChunks;
  final List<PerformanceResourceTiming> resources;
  final List<PerformanceOptimizationTip> tips;
  final List<String> targets;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;
}

final class PerformanceSummaryMetric {
  const PerformanceSummaryMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final PerformanceScoreTone tone;
}

final class PerformanceVitalMetric {
  const PerformanceVitalMetric({
    required this.label,
    required this.value,
    required this.progress,
    required this.tone,
  });

  final String label;
  final String value;
  final double progress;
  final PerformanceScoreTone tone;
}

final class PerformanceMemoryUsage {
  const PerformanceMemoryUsage({
    required this.usedLabel,
    required this.limitLabel,
    required this.percentLabel,
    required this.progress,
  });

  final String usedLabel;
  final String limitLabel;
  final String percentLabel;
  final double progress;
}

final class PerformanceResourceTiming {
  const PerformanceResourceTiming({
    required this.name,
    required this.type,
    required this.size,
    required this.duration,
  });

  final String name;
  final String type;
  final String size;
  final String duration;
}

final class PerformanceOptimizationTip {
  const PerformanceOptimizationTip({
    required this.title,
    required this.body,
    required this.tone,
  });

  final String title;
  final String body;
  final PerformanceScoreTone tone;
}

final class MissingScreensShowcaseSnapshot {
  const MissingScreensShowcaseSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.newScreensIntro,
    required this.newScreens,
    required this.v2Intro,
    required this.v2Pages,
    required this.flowConnections,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<DevShowcaseTabDraft> tabs;
  final String newScreensIntro;
  final List<DevShowcaseScreenDraft> newScreens;
  final String v2Intro;
  final List<DevShowcaseV2PageDraft> v2Pages;
  final List<DevShowcaseFlowDraft> flowConnections;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;
}

final class DevShowcaseTabDraft {
  const DevShowcaseTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class DevShowcaseScreenDraft {
  const DevShowcaseScreenDraft({
    required this.id,
    required this.title,
    required this.route,
    required this.description,
    required this.states,
  });

  final String id;
  final String title;
  final String route;
  final String description;
  final List<String> states;
}

final class DevShowcaseV2PageDraft {
  const DevShowcaseV2PageDraft({
    required this.id,
    required this.title,
    required this.route,
    required this.changes,
  });

  final String id;
  final String title;
  final String route;
  final List<String> changes;
}

final class DevShowcaseFlowDraft {
  const DevShowcaseFlowDraft({
    required this.id,
    required this.from,
    required this.fromRoute,
    required this.to,
    required this.toRoute,
    required this.trigger,
  });

  final String id;
  final String from;
  final String fromRoute;
  final String to;
  final String toRoute;
  final String trigger;
}

final class DesignSystemSnapshot {
  const DesignSystemSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.heroEyebrow,
    required this.heroTitle,
    required this.heroDescription,
    required this.tokens,
    required this.swatches,
    required this.ctaDemos,
    required this.inputDemos,
    required this.sectionDemos,
    required this.playgroundControls,
    required this.footerTitle,
    required this.footerSubtitle,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String heroEyebrow;
  final String heroTitle;
  final String heroDescription;
  final List<DesignTokenDraft> tokens;
  final List<DesignSwatchDraft> swatches;
  final List<DesignCtaDemoDraft> ctaDemos;
  final List<DesignInputDemoDraft> inputDemos;
  final List<DesignSectionDemoDraft> sectionDemos;
  final List<String> playgroundControls;
  final String footerTitle;
  final String footerSubtitle;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;
}

final class DesignTokenDraft {
  const DesignTokenDraft({required this.label, required this.value});

  final String label;
  final String value;
}

final class DesignSwatchDraft {
  const DesignSwatchDraft({
    required this.id,
    required this.label,
    required this.value,
  });

  final String id;
  final String label;
  final String value;
}

final class DesignCtaDemoDraft {
  const DesignCtaDemoDraft({
    required this.id,
    required this.label,
    required this.variant,
    this.loading = false,
    this.disabled = false,
  });

  final String id;
  final String label;
  final String variant;
  final bool loading;
  final bool disabled;
}

final class DesignInputDemoDraft {
  const DesignInputDemoDraft({
    required this.id,
    required this.caption,
    required this.label,
    required this.placeholder,
    this.value = '',
    this.error,
    this.prefix = false,
    this.suffix = false,
    this.obscure = false,
  });

  final String id;
  final String caption;
  final String label;
  final String placeholder;
  final String value;
  final String? error;
  final bool prefix;
  final bool suffix;
  final bool obscure;
}

final class DesignSectionDemoDraft {
  const DesignSectionDemoDraft({
    required this.title,
    this.subtitle,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final String? badge;
}

final class MockRouteCheckerRepository implements RouteCheckerRepository {
  const MockRouteCheckerRepository();

  @override
  RouteCheckerSnapshot getRouteChecker() {
    return const RouteCheckerSnapshot(
      endpoint: '/api/mobile/dev/dev-route-checker',
      actionDraft: 'read-only or local navigation action',
      title: 'Staking Route Checker',
      subtitle: 'Test all 43 routes systematically. Click to mark each route.',
      backRoute: '/home',
      routes: [
        DevRouteDraft(
          path: '/earn/staking/terms',
          name: 'Terms of Service',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/risk-disclosure',
          name: 'Risk Disclosure',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/withdrawal-policy',
          name: 'Withdrawal Policy',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/tax-guide',
          name: 'Tax Guide',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/risk-assessment',
          name: 'Risk Assessment',
          phase: 1,
        ),
        DevRouteDraft(path: '/earn/dashboard', name: 'Dashboard', phase: 2),
        DevRouteDraft(path: '/earn/analytics', name: 'Analytics', phase: 2),
        DevRouteDraft(path: '/earn/history', name: 'History', phase: 2),
        DevRouteDraft(
          path: '/earn/calendar',
          name: 'Earnings Calendar',
          phase: 2,
        ),
        DevRouteDraft(
          path: '/earn/validator-selection',
          name: 'Validator Selection',
          phase: 3,
        ),
        DevRouteDraft(
          path: '/earn/auto-compound',
          name: 'Auto-Compound',
          phase: 3,
        ),
        DevRouteDraft(
          path: '/earn/liquid-staking',
          name: 'Liquid Staking',
          phase: 3,
        ),
        DevRouteDraft(path: '/earn/insurance', name: 'Insurance', phase: 3),
        DevRouteDraft(
          path: '/earn/advanced-orders',
          name: 'Advanced Orders',
          phase: 3,
          featured: true,
        ),
        DevRouteDraft(
          path: '/earn/multi-chain',
          name: 'Multi-Chain',
          phase: 3,
          featured: true,
        ),
        DevRouteDraft(
          path: '/earn/institutional',
          name: 'Institutional',
          phase: 3,
          featured: true,
        ),
        DevRouteDraft(path: '/earn/guide', name: 'Guide', phase: 4),
        DevRouteDraft(path: '/earn/faq', name: 'FAQ', phase: 4),
        DevRouteDraft(
          path: '/earn/notifications',
          name: 'Notifications',
          phase: 4,
        ),
        DevRouteDraft(
          path: '/earn/recommendations',
          name: 'Recommendations',
          phase: 4,
        ),
        DevRouteDraft(
          path: '/earn/regulatory-framework',
          name: 'Regulatory Framework',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/audit-reports',
          name: 'Audit Reports',
          phase: 5,
        ),
        DevRouteDraft(path: '/earn/custody', name: 'Custody', phase: 5),
        DevRouteDraft(
          path: '/earn/suitability-assessment',
          name: 'Suitability Assessment',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/insurance-fund-transparency',
          name: 'Insurance Fund',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/transaction-reporting',
          name: 'Transaction Reporting',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/api-documentation',
          name: 'API Documentation',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/proof-of-reserves',
          name: 'Proof of Reserves',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/risk-dashboard',
          name: 'Risk Dashboard',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/slashing-history',
          name: 'Slashing History',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/validator-health-monitor',
          name: 'Validator Health',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/risk-score-calculator',
          name: 'Risk Calculator',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/emergency-actions',
          name: 'Emergency Actions',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/contingency-plan',
          name: 'Contingency Plan',
          phase: 6,
        ),
        DevRouteDraft(path: '/earn/social-feed', name: 'Social Feed', phase: 7),
        DevRouteDraft(
          path: '/earn/community-governance',
          name: 'Governance',
          phase: 7,
        ),
        DevRouteDraft(path: '/earn/proposals', name: 'Proposals', phase: 7),
        DevRouteDraft(path: '/earn/voting/p1', name: 'Voting', phase: 7),
        DevRouteDraft(path: '/earn/forum', name: 'Forum', phase: 7),
        DevRouteDraft(path: '/earn/webhooks', name: 'Webhooks', phase: 8),
        DevRouteDraft(path: '/earn/data-export', name: 'Data Export', phase: 8),
        DevRouteDraft(
          path: '/earn/third-party-integrations',
          name: 'Integrations',
          phase: 8,
        ),
        DevRouteDraft(
          path: '/earn/developer-console',
          name: 'Developer Console',
          phase: 8,
        ),
      ],
      contractNotes:
          'Reference/admin surface. Keep behind internal role or dev flag. Route rows are local QA checks until the target staking screens are ported.',
      supportedStates: {
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      },
    );
  }
}

final class MockMissingScreensShowcaseRepository
    implements MissingScreensShowcaseRepository {
  const MockMissingScreensShowcaseRepository();

  @override
  MissingScreensShowcaseSnapshot getShowcase() {
    return const MissingScreensShowcaseSnapshot(
      endpoint: '/api/mobile/dev/dev-showcase',
      actionDraft: 'read-only or local navigation action',
      title: '03 – Missing Screens & Flow Fix',
      subtitle: 'No redesign • Chỉ tạo mới + v2 entry points',
      backRoute: '/home',
      tabs: [
        DevShowcaseTabDraft(id: 'new', label: 'New Screens (3)'),
        DevShowcaseTabDraft(id: 'v2', label: 'v2 + Prototype Links'),
      ],
      newScreensIntro:
          '3 màn hình mới tạo hoàn chỉnh, match 100% UI style hiện có. Tap để mở live preview.',
      newScreens: [
        DevShowcaseScreenDraft(
          id: 'reset_password',
          title: 'Auth – Reset Password',
          route: '/auth/reset-password',
          description:
              'Form đặt lại mật khẩu với password rules, loading state, error handling, và success toast.',
          states: [
            'Idle',
            'Loading (CTA disabled)',
            'Error (mật khẩu yếu)',
            'Success (toast + CTA Đăng nhập)',
          ],
        ),
        DevShowcaseScreenDraft(
          id: 'p2p_orders',
          title: 'P2P – My Orders',
          route: '/p2p/my-orders',
          description:
              'Danh sách đơn P2P với tabs (Đang xử lý / Hoàn tất / Tranh chấp) và enterprise state variants.',
          states: [
            'Loading (skeleton)',
            'Ready (data)',
            'Empty (CTA Khám phá P2P)',
            'Error (retry)',
            'Offline (stale data)',
          ],
        ),
        DevShowcaseScreenDraft(
          id: 'wallet_tx',
          title: 'Wallet – Transaction Detail',
          route: '/wallet/tx/tx001',
          description:
              'Chi tiết giao dịch với summary card, timeline steps, detail rows (copyable), và action buttons.',
          states: [
            'Ready',
            'Not Found (error)',
            'Explorer link',
            'Contact support',
          ],
        ),
      ],
      v2Intro:
          'v2 features consolidated into main routes. All flow connections now use primary paths.',
      v2Pages: [
        DevShowcaseV2PageDraft(
          id: 'otp',
          title: 'OTPPage (consolidated)',
          route: '/auth/otp',
          changes: [
            'Purpose badge hiển thị loại xác minh',
            'Nút "Quên mật khẩu? Đặt lại" → /auth/reset-password',
          ],
        ),
        DevShowcaseV2PageDraft(
          id: 'p2p',
          title: 'P2PHomePage (consolidated)',
          route: '/p2p',
          changes: [
            'Card "Đơn P2P của tôi" nổi bật với badge count',
            'Navigate → /p2p/my-orders',
          ],
        ),
        DevShowcaseV2PageDraft(
          id: 'security',
          title: 'SecurityPage (consolidated)',
          route: '/profile/security',
          changes: [
            '"Nhật ký hoạt động" với badge count → /profile/activity',
            '"Lịch sử lệnh" entry → /trade/orders',
          ],
        ),
        DevShowcaseV2PageDraft(
          id: 'wallet',
          title: 'TransactionHistoryPage (consolidated)',
          route: '/wallet/history',
          changes: [
            'Enterprise states: Loading/Error/Offline',
            'Tap row → /wallet/tx/:txId (detail page)',
          ],
        ),
      ],
      flowConnections: [
        DevShowcaseFlowDraft(
          id: 'otp_reset',
          from: 'OTPPage',
          fromRoute: '/auth/otp',
          to: 'ResetPasswordPage',
          toRoute: '/auth/reset-password',
          trigger: 'OTP verified (purpose=verify)',
        ),
        DevShowcaseFlowDraft(
          id: 'reset_login',
          from: 'ResetPasswordPage',
          fromRoute: '/auth/reset-password',
          to: 'LoginPage',
          toRoute: '/auth/login',
          trigger: 'Success → "Đăng nhập"',
        ),
        DevShowcaseFlowDraft(
          id: 'p2p_orders',
          from: 'P2PHomePage',
          fromRoute: '/p2p',
          to: 'P2PMyOrdersPage',
          toRoute: '/p2p/my-orders',
          trigger: 'Tap "Đơn P2P của tôi"',
        ),
        DevShowcaseFlowDraft(
          id: 'order_detail',
          from: 'P2PMyOrdersPage',
          fromRoute: '/p2p/my-orders',
          to: 'P2POrderPage',
          toRoute: '/p2p/order/:id',
          trigger: 'Tap order card',
        ),
        DevShowcaseFlowDraft(
          id: 'wallet_tx',
          from: 'TransactionHistory',
          fromRoute: '/wallet/history',
          to: 'TransactionDetail',
          toRoute: '/wallet/tx/:id',
          trigger: 'Tap transaction row',
        ),
        DevShowcaseFlowDraft(
          id: 'security_activity',
          from: 'SecurityPage',
          fromRoute: '/profile/security',
          to: 'ActivityLogPage',
          toRoute: '/profile/activity',
          trigger: 'Tap "Nhật ký hoạt động"',
        ),
        DevShowcaseFlowDraft(
          id: 'security_orders',
          from: 'SecurityPage',
          fromRoute: '/profile/security',
          to: 'OrdersHistoryPage',
          toRoute: '/trade/orders',
          trigger: 'Tap "Lịch sử lệnh"',
        ),
      ],
      contractNotes:
          'Reference/admin surface; gate behind internal role or dev flag. Dynamic route samples are local preview links and can use canonical placeholder-safe ids.',
      supportedStates: {
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      },
    );
  }
}

final class MockDesignSystemRepository implements DesignSystemRepository {
  const MockDesignSystemRepository();

  @override
  DesignSystemSnapshot getDesignSystem() {
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
          'Reference/admin surface; gate behind internal role or dev flag. Token values mirror the Flutter Home foundation and normalize legacy React blue surfaces to AppColors.',
      supportedStates: {
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      },
    );
  }
}

final class MockPerformanceMonitorRepository
    implements PerformanceMonitorRepository {
  const MockPerformanceMonitorRepository();

  @override
  PerformanceMonitorSnapshot getPerformanceMonitor() {
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
