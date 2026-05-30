part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryMethodsPart02 on _MockP2PRepositoryBase {
  @override
  P2PAdAnalyticsSnapshot getAdAnalytics(String adId) {
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
  P2PAdDetailSnapshot getAdDetail(String adId) {
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
  P2PMyAdsSnapshot getMyAds() {
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
  P2PCreateAdSnapshot getCreateAd() {
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

  @override
  P2PMerchantApplySnapshot getMerchantApply() {
    return const P2PMerchantApplySnapshot(
      endpoint: '/api/mobile/p2p/p2p-merchant-apply',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      stats: P2PMerchantStatsDraft(
        totalTrades: 156,
        completionRate: 97.2,
        avgResponseTime: '2m 15s',
        accountAgeDays: 247,
        volume30dVnd: 125400000,
        disputes: 1,
        kycLevel: 2,
      ),
      benefits: _p2pMerchantBenefits,
      requirements: _p2pMerchantRequirements,
      businessTypes: ['Cá nhân', 'Hộ kinh doanh', 'Công ty', 'OTC Desk'],
      documents: _p2pMerchantDocuments,
      reviewSteps: [
        'Nhận đơn đăng ký',
        'Xác minh tài liệu',
        'Đánh giá lịch sử',
        'Phê duyệt',
      ],
      securityNote:
          'Tài liệu được mã hóa AES-256 và chỉ dùng cho mục đích xác minh. Tự động xóa sau 90 ngày.',
      reviewNotice:
          'Quá trình xét duyệt thường mất 1-3 ngày làm việc. Trong thời gian chờ, bạn vẫn có thể giao dịch bình thường.',
      emptyTitle: 'Chưa đủ điều kiện Merchant',
      emptySubtitle:
          'Hoàn thành thêm giao dịch P2P, KYC và lịch sử uy tín để mở đơn đăng ký.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PMerchantProfileSnapshot getMerchantProfile(String merchantId) {
    final resolvedMerchantId = merchantId.isEmpty ? 'mc001' : merchantId;
    final merchant = _p2pMerchants.firstWhere(
      (item) => item.id == resolvedMerchantId,
      orElse: () => _p2pMerchants.first,
    );

    return P2PMerchantProfileSnapshot(
      endpoint: '/api/mobile/p2p/p2p-merchant-$resolvedMerchantId',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      merchantId: resolvedMerchantId,
      merchant: merchant,
      ads: _p2pMerchantProfileAds
          .where((ad) => ad.merchantId == merchant.id)
          .toList(growable: false),
      reviews: _p2pMerchantProfileReviews
          .where((review) => review.toUserId == merchant.id)
          .take(4)
          .toList(growable: false),
      reportRoute: '/p2p/report/$resolvedMerchantId',
      blacklistAddRoute: '/p2p/blacklist/add',
      emptyAdsTitle: 'Chưa có quảng cáo nào',
      emptyReviewsTitle: 'Chưa có đánh giá nào',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PReportMerchantSnapshot getReportMerchant(String merchantId) {
    final resolvedMerchantId = merchantId.isEmpty ? 'mc001' : merchantId;
    final merchant = _p2pMerchants.firstWhere(
      (item) => item.id == resolvedMerchantId,
      orElse: () => _p2pMerchants.first,
    );

    return P2PReportMerchantSnapshot(
      endpoint: '/api/mobile/p2p/p2p-report-$resolvedMerchantId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /exports',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      merchantId: resolvedMerchantId,
      merchant: merchant,
      reasons: _p2pReportReasons,
      blacklistAddRoute: '/p2p/blacklist/add',
      merchantProfileRoute: '/p2p/merchant/$resolvedMerchantId',
      detailPrompt: 'Mô tả chi tiết sự việc...',
      reviewNotice:
          'Báo cáo sẽ được đội ngũ VitTrade xem xét nghiêm túc. Báo cáo sai sự thật có thể ảnh hưởng đến tài khoản của bạn.',
      emptyTitle: 'Chưa chọn lý do báo cáo',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PTradingLevelSnapshot getTradingLevel() {
    final userLevel = _p2pUserTradingLevel;
    final currentLevel = _p2pTradingLevels.firstWhere(
      (level) => level.id == userLevel.currentLevel,
      orElse: () => _p2pTradingLevels.first,
    );

    return P2PTradingLevelSnapshot(
      endpoint: '/api/mobile/p2p/p2p-trading-level',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      userLevel: userLevel,
      currentLevel: currentLevel,
      levels: _p2pTradingLevels,
      upgradeRoute: '/p2p/trading-level',
      emptyTitle: 'Chưa có dữ liệu cấp bậc',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PReviewsSnapshot getReviews() {
    final received = _p2pReviews
        .where((review) => review.toUserId == 'user001')
        .toList(growable: false);
    final given = _p2pReviews
        .where((review) => review.fromUserId == 'user001')
        .toList(growable: false);

    return P2PReviewsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-reviews',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      receivedReviews: received,
      givenReviews: given,
      emptyTitle: 'Chưa có đánh giá nào',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PPaymentMethodAddSnapshot getPaymentMethodAdd() {
    return const P2PPaymentMethodAddSnapshot(
      endpoint: '/api/mobile/p2p/p2p-payment-method-add',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      bankOptions: _p2pPaymentBankOptions,
      ewalletOptions: _p2pPaymentEwalletOptions,
      defaultBankAccountHint: '0071000123456',
      defaultEwalletAccountHint: '0901234567',
      ownerNameHint: 'NGUYEN VAN A',
      saveRoute: '/p2p/payment-methods',
      securityNote:
          'Thông tin thanh toán được mã hóa và chỉ hiển thị cho đối tác khi đơn P2P được tạo.',
      confirmTitle: 'Xác nhận thêm phương thức?',
      confirmMessage:
          'Kiểm tra đúng ngân hàng, số tài khoản và tên chủ tài khoản trước khi lưu. Thay đổi phương thức thanh toán cần audit trail.',
      emptyTitle: 'Chưa có phương thức thanh toán',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PPaymentMethodVerificationSnapshot getPaymentMethodVerification(
    String methodId,
  ) {
    return P2PPaymentMethodVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-payment-method-verification-$methodId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      methodId: methodId,
      methods: _p2pPaymentVerificationMethods,
      microDepositSteps: const [
        'Chúng tôi gửi 1-2 VND vào tài khoản',
        'Kiểm tra bank statement (1-2 ngày)',
        'Nhập chính xác số tiền nhận được',
        'Xác minh hoàn tất',
      ],
      warningNote:
          'Phương thức thanh toán chưa xác minh sẽ có giới hạn giao dịch thấp hơn và có thể bị từ chối bởi một số merchant.',
      saveRoute: '/p2p/payment-methods',
      confirmTitle: 'Gửi yêu cầu xác minh?',
      confirmMessage:
          'Yêu cầu xác minh phương thức thanh toán sẽ được ghi vào audit trail và có thể cần đối soát với merchant/KYC.',
      emptyTitle: 'Chưa có phương thức xác minh',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PPaymentMethodOwnershipSnapshot getPaymentMethodOwnership(String methodId) {
    return P2PPaymentMethodOwnershipSnapshot(
      endpoint: '/api/mobile/p2p/p2p-payment-method-ownership-$methodId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      methodId: methodId,
      documents: _p2pOwnershipDocuments,
      saveRoute: '/p2p/payment-methods',
      confirmTitle: 'Gửi xác minh sở hữu?',
      confirmMessage:
          'Tài liệu sẽ được lưu vào audit trail và đối chiếu với hồ sơ KYC trước khi mở giới hạn P2P.',
      emptyTitle: 'Chưa có tài liệu xác minh',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PPaymentMethodCoolingPeriodSnapshot getPaymentMethodCoolingPeriod() {
    return const P2PPaymentMethodCoolingPeriodSnapshot(
      endpoint: '/api/mobile/p2p/p2p-payment-method-cooling-period',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      addedAt: '2026-03-05 10:00',
      availableAt: '2026-03-12 10:00',
      hoursRemaining: 168,
      reason: 'New payment method',
      reasons: [
        'Bảo vệ khỏi fraud và scam',
        'Thời gian xác minh ownership',
        'Tuân thủ quy định AML/CTF',
        'Giảm thiểu dispute',
      ],
      waitTitle: 'Trong thời gian chờ',
      waitMessage:
          'Bạn vẫn có thể dùng các phương thức khác đã verify. Phương thức này sẽ tự động khả dụng sau 7 ngày.',
      emptyTitle: 'Không có phương thức đang chờ',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PPaymentMethodHistorySnapshot getPaymentMethodHistory() {
    return const P2PPaymentMethodHistorySnapshot(
      endpoint: '/api/mobile/p2p/p2p-payment-method-history',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      totalTransactions: 45,
      totalVolume: 1250000000,
      successRate: 96.5,
      transactions: _p2pPaymentHistoryTransactions,
      emptyTitle: 'Chưa có lịch sử thanh toán',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PPaymentMethodsSnapshot getPaymentMethods() {
    return const P2PPaymentMethodsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-payment-methods',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      methods: _p2pPaymentMethodList,
      addBankRoute: '/p2p/payment-method/add?type=bank',
      addEwalletRoute: '/p2p/payment-method/add?type=ewallet',
      securityNote:
          'Thông tin thanh toán chỉ hiển thị cho đối tác khi đơn hàng P2P được tạo. VitTrade không lưu trữ mật khẩu ngân hàng.',
      deleteConfirmTitle: 'Xóa phương thức thanh toán?',
      deleteConfirmMessage:
          'Hành động này không thể hoàn tác. Quảng cáo P2P sử dụng phương thức này sẽ cần cập nhật lại.',
      emptyTitle: 'Chưa có phương thức thanh toán',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PInsuranceFundSnapshot getInsuranceFund() {
    return const P2PInsuranceFundSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance',
      legacyEndpoint: '/api/mobile/p2p/p2p-insurance-fund',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      totalFund: 523000000,
      activeClaims: 3,
      totalContributed: 780000000,
      totalPaid: 257000000,
      userCoveragePct: 85,
      tierName: 'Pro',
      contributionRate: '0.1%',
      outstandingClaimsAmount: 83000000,
      solvencyRatio: 6.3,
      healthStatus: 'Khỏe mạnh',
      lastAuditDate: '28/02/2026',
      auditorName: 'Deloitte Vietnam',
      nextAuditDate: '31/03/2026',
      maxClaimPerPeriod: 100000000,
      approvalRate: 78.5,
      avgResolutionHours: 36,
      eligibilityItems: _p2pInsuranceEligibilityItems,
      coverageTiers: _p2pInsuranceCoverageTiers,
      notificationPrefs: _p2pInsuranceNotificationPrefs,
      claims: _p2pInsuranceClaims,
      chartPoints: _p2pInsuranceChartPoints,
      certificateRoute: '/p2p/insurance/certificate',
      contributionHistoryRoute: '/p2p/insurance/contribution-history',
      emptyTitle: 'Chưa có yêu cầu bồi thường',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
