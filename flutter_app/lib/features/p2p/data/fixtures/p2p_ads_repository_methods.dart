part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryAdsMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PAdAnalyticsSnapshot> getAdAnalytics(String adId) async {
    await _simulateNetwork();
    final resolvedAdId = adId.isEmpty ? 'sample' : adId;
    return P2PAdAnalyticsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-ad-analytics-$resolvedAdId',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.realtimeRefresh,
      ],
      adId: resolvedAdId,
      sourceAdId: 'myad001',
      tradeType: P2PTradeType.sell,
      asset: 'USDT',
      currency: 'VND',
      priceVnd: 25360,
      ranking: 3,
      totalActiveAds: 428,
      impressions: 12847,
      clicks: 1926,
      ordersCreated: 289,
      ordersCompleted: 274,
      ordersDisputed: 3,
      ordersCancelled: 12,
      totalVolume: 2180000000,
      totalRevenue: 6540000,
      avgOrderValue: 7956204,
      avgResponseTimeSeconds: 45,
      avgCompletionMinutes: 8.3,
      conversionRate: 15.0,
      completionRate: 94.8,
      rating: 4.8,
      reviewsCount: 186,
      dailyPerformance: _p2pAdDailyPerformance,
      hourlyHeatmap: _p2pAdHourlyHeatmap,
      paymentBreakdown: _p2pAdPaymentBreakdown,
      competitorComparison: _p2pAdCompetitorComparison,
      optimizationTips: _p2pAdOptimizationTips,
      emptyTitle: 'Chưa có dữ liệu quảng cáo',
      emptySubtitle:
          'Hệ thống cần thêm giao dịch để tạo phân tích đáng tin cậy.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PAdDetailSnapshot> getAdDetail(String adId) async {
    await _simulateNetwork();
    final resolvedAdId = adId.isEmpty ? 'sample' : adId;
    return P2PAdDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-ad-$resolvedAdId',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      adId: resolvedAdId,
      sourceAdId: 'ad001',
      // _p2pAds is the shared ad catalog owned by Home/Discovery (see
      // p2p_home_repository_fixtures.dart) — this looks up a single record.
      ad: _p2pAds.first,
      marketPriceVnd: 25300,
      priceDiffPct: .20,
      trustScore: 100,
      trustLabel: 'Rất đáng tin',
      viewerCount: 7,
      totalVolume30dUsd: 850000,
      availableAmount: 10000,
      paymentWindowMinutes: 15,
      minKycLevel: 1,
      minCompletedTrades: 0,
      remarks:
          'Chuyển khoản nhanh trong 10 phút. Chỉ giao dịch với tài khoản đã KYC.',
      tradingHours: '08:00 - 23:00',
      targetOrderId: 'p2p001',
      emptyTitle: 'Không tìm thấy quảng cáo',
      emptySubtitle: 'Quảng cáo không còn khả dụng hoặc đã bị tạm dừng.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PMyAdsSnapshot> getMyAds() async {
    await _simulateNetwork();
    return const P2PMyAdsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-my-ads',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      ads: _p2pMyAds,
      emptyTitle: 'Chưa có quảng cáo nào',
      emptyActionLabel: 'Đăng quảng cáo đầu tiên',
      quickLinks: [
        P2PQuickLinkDraft(
          id: 'settings',
          title: 'Cài đặt P2P',
          subtitle: 'Tùy chọn giao dịch, thông báo',
          route: '/p2p/settings',
          iconKey: 'settings',
        ),
        P2PQuickLinkDraft(
          id: 'blacklist',
          title: 'Danh sách chặn',
          subtitle: 'Quản lý người dùng đã chặn',
          route: '/p2p/blacklist',
          iconKey: 'block',
        ),
        P2PQuickLinkDraft(
          id: 'guide',
          title: 'Hướng dẫn',
          subtitle: 'Mẹo đăng quảng cáo hiệu quả',
          route: '/p2p/guide',
          iconKey: 'guide',
        ),
      ],
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PCreateAdSnapshot> getCreateAd() async {
    await _simulateNetwork();
    return const P2PCreateAdSnapshot(
      endpoint: '/api/mobile/p2p/p2p-create',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      assets: ['USDT', 'BTC', 'ETH'],
      currencies: ['VND', 'USD'],
      paymentOptions: [
        'Vietcombank',
        'Techcombank',
        'VietinBank',
        'BIDV',
        'MB Bank',
        'ACB',
        'Momo',
        'ZaloPay',
        'VNPay',
      ],
      paymentWindows: [15, 30, 60],
      tradingHours: ['24/7', '08:00 - 22:00', '08:00 - 17:00'],
      marketPrices: {'USDT': 25300, 'BTC': 1715000000, 'ETH': 89200000},
      defaultAsset: 'USDT',
      defaultCurrency: 'VND',
      defaultPaymentWindow: 15,
      defaultTradingHours: '24/7',
      warningNote:
          'Quảng cáo sẽ được xem xét. Vi phạm chính sách sẽ bị đình chỉ tài khoản.',
      escrowNote: 'Tài sản sẽ được khóa trong Escrow khi có người đặt đơn.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
