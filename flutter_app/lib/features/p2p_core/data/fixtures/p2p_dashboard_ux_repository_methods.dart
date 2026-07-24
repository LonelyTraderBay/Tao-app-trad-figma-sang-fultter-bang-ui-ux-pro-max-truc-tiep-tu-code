part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryDashboardUxMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PDashboardSnapshot> getDashboard({String timeFilter = '30d'}) async {
    await _simulateNetwork();
    final selectedFilter = _p2pDashboardFilters.firstWhere(
      (item) => item.id == timeFilter,
      orElse: () => _p2pDashboardFilters[1],
    );

    return P2PDashboardSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dashboard',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.realtimeRefresh,
      ],
      title: 'P2P Dashboard',
      subtitle: 'Tổng quan · P2P',
      filters: _p2pDashboardFilters,
      selectedFilter: selectedFilter,
      stats: _p2pDashboardStats,
      weeklyVolume: _p2pDashboardWeeklyVolume,
      monthlyOrders: _p2pDashboardMonthlyOrders,
      assetDistribution: _p2pDashboardAssetDistribution,
      currentLevel: _p2pDashboardCurrentLevel,
      nextLevel: _p2pDashboardNextLevel,
      platformComparisons: _p2pDashboardPlatformComparisons,
      topMerchants: _p2pDashboardTopMerchants,
      recentActivity: _p2pDashboardRecentActivity,
      quickActions: _p2pDashboardQuickActions,
      parentRoute: '/p2p',
      myOrdersRoute: '/p2p/my-orders',
      emptyTitle: 'Chưa có dữ liệu dashboard P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PAchievementsSnapshot> getAchievements() async {
    await _simulateNetwork();
    return const P2PAchievementsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-achievements',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Thành tích P2P',
      subtitle: 'Thành tích · P2P',
      currentLevel: 3,
      achievements: _p2pAchievements,
      categories: _p2pAchievementCategories,
      parentRoute: '/p2p',
      tradingLevelRoute: '/p2p/trading-level',
      emptyTitle: 'Chưa có thành tích P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PBlacklistAddSnapshot> getBlacklistAdd() async {
    await _simulateNetwork();
    return const P2PBlacklistAddSnapshot(
      endpoint: '/api/mobile/p2p/p2p-blacklist-add',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      title: 'Thêm vào blacklist',
      subtitle: 'An toàn · P2P',
      heroTitle: 'Chặn người dùng',
      heroSubtitle: 'Người dùng bị chặn sẽ không thể giao dịch P2P với bạn',
      usernameLabel: 'Tên người dùng *',
      usernameHint: 'Nhập username...',
      noteLabel: 'Ghi chú (tùy chọn)',
      noteHint: 'Mô tả chi tiết lý do chặn...',
      warning:
          'Người bị chặn sẽ không thể giao dịch với bạn, gửi tin nhắn, hoặc xem quảng cáo của bạn. Bạn có thể bỏ chặn bất kỳ lúc nào.',
      submitLabel: 'Chặn người dùng',
      reasons: _p2pBlacklistAddReasons,
      parentRoute: '/p2p/blacklist',
      blacklistRoute: '/p2p/blacklist',
      emptyTitle: 'Chưa chọn người dùng để chặn',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PBlacklistSnapshot> getBlacklist() async {
    await _simulateNetwork();
    return const P2PBlacklistSnapshot(
      endpoint: '/api/mobile/p2p/p2p-blacklist',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      title: 'Danh sách chặn',
      subtitle: 'An toàn · P2P',
      searchHint: 'Tìm người dùng đã chặn...',
      infoTitle: 'Về danh sách chặn',
      infoText:
          'Người dùng bị chặn sẽ không thể tạo đơn với bạn, gửi tin nhắn, hoặc xem quảng cáo của bạn.',
      addRoute: '/p2p/blacklist/add',
      parentRoute: '/p2p',
      reasons: _p2pBlacklistAddReasons,
      entries: _p2pBlacklistEntries,
      emptyTitle: 'Danh sách trống',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PNotificationSettingsSnapshot> getNotificationSettings() async {
    await _simulateNetwork();
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
      title: 'Thông báo P2P',
      subtitle: 'Thông báo · P2P',
      heroTitle: 'Cài đặt thông báo',
      heroSubtitle: 'Tùy chỉnh thông báo cho P2P Trading',
      settings: _p2pNotificationSettings,
      parentRoute: '/p2p/settings',
      emptyTitle: 'Chưa có tuỳ chọn thông báo P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PSettingsSnapshot> getSettings() async {
    await _simulateNetwork();
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
  Future<P2PGuideSnapshot> getGuide() async {
    await _simulateNetwork();
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
}
