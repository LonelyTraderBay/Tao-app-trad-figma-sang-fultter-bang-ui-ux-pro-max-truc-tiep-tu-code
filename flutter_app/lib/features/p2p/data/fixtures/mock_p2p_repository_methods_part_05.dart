part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryMethodsPart05 on _MockP2PRepositoryBase {
  @override
  P2PNotificationSettingsSnapshot getNotificationSettings() {
    return const P2PNotificationSettingsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-settings-notifications',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      title: 'P2P Notifications',
      subtitle: 'Thông báo · P2P',
      heroTitle: 'Notification Settings',
      heroSubtitle: 'Tùy chỉnh thông báo cho P2P Trading',
      settings: _p2pNotificationSettings,
      parentRoute: '/p2p/settings',
      emptyTitle: 'Chưa có tuỳ chọn thông báo P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PSettingsSnapshot getSettings() {
    return const P2PSettingsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-settings',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      title: 'Cài đặt P2P',
      subtitle: 'Cài đặt · P2P',
      assetOptions: ['USDT', 'BTC', 'ETH', 'BNB'],
      currencyOptions: ['VND', 'USD', 'EUR'],
      paymentWindows: ['15', '30', '60'],
      defaultAsset: 'USDT',
      defaultCurrency: 'VND',
      defaultPaymentWindow: '15',
      notificationToggles: _p2pSettingsNotificationToggles,
      privacyToggles: _p2pSettingsPrivacyToggles,
      securityToggles: _p2pSettingsSecurityToggles,
      autoReply: _p2pSettingsAutoReply,
      notificationsRoute: '/p2p/settings/notifications',
      trustedDevicesRoute: '/profile/devices',
      blacklistRoute: '/p2p/blacklist',
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có cài đặt P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PGuideSnapshot getGuide() {
    return P2PGuideSnapshot(
      endpoint: '/api/mobile/p2p/p2p-guide',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Hướng dẫn P2P',
      subtitle: 'Hướng dẫn · P2P',
      tabs: _p2pGuideTabs,
      defaultTab: 'faq',
      faqItems: _p2pGuideFaqItems,
      buySteps: _p2pGuideBuySteps,
      sellSteps: _p2pGuideSellSteps,
      safetyTips: _p2pGuideSafetyTips,
      videos: _p2pGuideVideos,
      parentRoute: '/p2p',
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.p2pOrder,
        referenceId: 'p2p-emergency-guide',
        sourceRoute: '/p2p/guide',
        issueLabel: 'P2P emergency trade support',
      ),
      marketRoute: '/p2p',
      emptyTitle: 'Chưa có hướng dẫn P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PMyOrdersSnapshot getMyOrders() {
    return const P2PMyOrdersSnapshot(
      endpoint: '/api/mobile/p2p/p2p-my-orders',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      title: 'Đơn P2P của tôi',
      subtitle: 'Đơn hàng · P2P',
      searchHint: 'Tìm theo mã đơn hoặc merchant...',
      defaultTab: 'processing',
      tabs: _p2pMyOrdersTabs,
      orders: _p2pMyOrders,
      parentRoute: '/p2p',
      dashboardRoute: '/p2p/dashboard',
      emptyTitle: 'Chưa có đơn hàng nào',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
