part of 'mock_dev_tools_repository.dart';

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
