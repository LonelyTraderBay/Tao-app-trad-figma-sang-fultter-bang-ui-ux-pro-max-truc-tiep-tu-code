part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryMethodsPart04 on _MockP2PRepositoryBase {
  @override
  P2PE2EInfoSnapshot getE2EInfo() {
    return const P2PE2EInfoSnapshot(
      endpoint: '/api/mobile/p2p/p2p-e2e-info',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      heroTitle: 'End-to-End Encryption',
      heroSubtitle: 'Bảo mật cấp quân sự',
      localLabel: 'Bạn',
      partnerLabel: 'M',
      diagramCaption: 'Chỉ bạn và đối tác mới đọc được tin nhắn',
      infoItems: _p2pE2EInfoItems,
      fingerprint: '7F3A 92D1 B5E8 4C6F\nA1D3 8B2C E9F4 5A7D',
      fingerprintHint: 'So khớp mã này với đối tác để xác minh kết nối an toàn',
      steps: _p2pE2ESteps,
      serverNote:
          'VitTrade sử dụng kiến trúc Zero-Knowledge. Máy chủ chỉ lưu trữ tin nhắn đã mã hóa và không có khả năng giải mã nội dung.',
      parentRoute: '/p2p/chat/p2p001',
      emptyTitle: 'Chưa có thông tin mã hóa P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PFraudPreventionSnapshot getFraudPrevention() {
    return const P2PFraudPreventionSnapshot(
      endpoint: '/api/mobile/p2p/p2p-fraud-prevention',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      patterns: _p2pFraudPatterns,
      checklist: _p2pFraudChecklist,
      emergencyActions: _p2pFraudEmergencyActions,
      disclosure:
          'Thông tin phòng chống gian lận mang tính chất giáo dục. Nếu bạn đã bị lừa đảo, hãy gửi claim bảo hiểm trong vòng 7 ngày và liên hệ hỗ trợ ngay.',
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có nội dung phòng chống gian lận',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PWalletTransferSnapshot getWalletTransfer({
    String asset = 'USDT',
    String type = 'deposit',
  }) {
    return const P2PWalletTransferSnapshot(
      endpoint: '/api/mobile/p2p/p2p-wallet-transfer',
      actionDraft:
          'POST /wallet/transfer-preview + POST /wallet/transfer-confirm; POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      defaultAsset: 'USDT',
      defaultType: 'deposit',
      assets: _p2pWalletTransferAssets,
      balances: _p2pWalletTransferBalances,
      feeLabel: 'Miễn phí',
      processingLabel: 'Tức thì',
      escrowNote:
          'P2P Wallet và Main Wallet hoạt động độc lập để đảm bảo an toàn. Số dư trong escrow không thể chuyển.',
      confirmationNote:
          'Giao dịch nội bộ giữa P2P Wallet và Main Wallet được xử lý tức thì và hoàn toàn miễn phí.',
      parentRoute: '/p2p/wallet',
      emptyTitle: 'Chưa có dữ liệu chuyển ví P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PFundLockHistorySnapshot getFundLockHistory({
    bool walletHistoryAlias = false,
  }) {
    return P2PFundLockHistorySnapshot(
      endpoint: walletHistoryAlias
          ? '/api/mobile/p2p/p2p-wallet-history'
          : '/api/mobile/p2p/p2p-wallet-fund-lock-history',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Fund Lock History',
      subtitle: 'Escrow · P2P',
      heroTitle: 'Lịch sử khóa tiền',
      records: _p2pFundLockRecords,
      parentRoute: '/p2p/wallet',
      emptyTitle: walletHistoryAlias
          ? 'Chưa có lịch sử ví P2P'
          : 'Chưa có lịch sử khóa tiền',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PWalletSnapshot getWallet() {
    return const P2PWalletSnapshot(
      endpoint: '/api/mobile/p2p/p2p-wallet',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'P2P Wallet',
      subtitle: 'Ví · P2P',
      totalUsdValue: 22793.70,
      privacyMask: '••••••',
      balances: _p2pWalletBalances,
      transactions: _p2pWalletTransactions,
      infoNote:
          'P2P Wallet tách biệt khỏi Main Wallet để đảm bảo an toàn. Chuyển tiền nội bộ miễn phí & tức thì.',
      parentRoute: '/p2p',
      transferRoute: '/p2p/wallet/transfer',
      historyRoute: '/p2p/wallet/history',
      escrowBalanceRoute: '/p2p/escrow/balance',
      emptyTitle: 'Chưa có dữ liệu ví P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PLimitTrackerSnapshot getLimitTracker() {
    return const P2PLimitTrackerSnapshot(
      endpoint: '/api/mobile/p2p/p2p-limits-tracker',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Limit Tracker',
      subtitle: 'Hạn mức · P2P',
      usages: _p2pLimitTrackerUsages,
      breakdown: _p2pLimitTrackerBreakdown,
      parentRoute: '/p2p/limits',
      emptyTitle: 'Chưa có dữ liệu hạn mức P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PTransactionLimitsSnapshot getTransactionLimits() {
    return const P2PTransactionLimitsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-limits',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Transaction Limits',
      subtitle: 'Hạn mức · P2P',
      currentTier: _p2pTransactionLimitTier1,
      nextTier: _p2pTransactionLimitTier2,
      usageItems: _p2pTransactionLimitUsages,
      detailItems: _p2pTransactionLimitDetails,
      infoBullets: _p2pTransactionLimitInfoBullets,
      parentRoute: '/p2p',
      trackerRoute: '/p2p/limits/tracker',
      kycRequirementsRoute: '/p2p/kyc/requirements',
      emptyTitle: 'Chưa có dữ liệu hạn mức giao dịch P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PComplianceOverviewSnapshot getComplianceOverview() {
    return const P2PComplianceOverviewSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-overview',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Compliance Overview',
      subtitle: 'Tuân thủ · P2P',
      heroTitle: 'Compliance Active',
      heroSubtitle: 'Tài khoản tuân thủ đầy đủ quy định',
      items: _p2pComplianceOverviewItems,
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có dữ liệu tuân thủ P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PAmlScreeningSnapshot getAmlScreening() {
    return const P2PAmlScreeningSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-aml-screening',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'AML Screening',
      subtitle: 'Tuân thủ · P2P',
      statusLabel: 'AML Status: Clear',
      statusDescription: 'Tài khoản đã qua kiểm tra AML',
      lastCheckLabel: 'Kiểm tra gần nhất',
      lastCheckAt: '2026-03-05 10:00',
      nextCheckLabel: 'Kiểm tra tiếp theo',
      nextCheckAt: '2026-03-12 10:00',
      checks: _p2pAmlScreeningChecks,
      infoTitle: 'Về AML Screening',
      infoBody:
          'Chúng tôi thực hiện kiểm tra AML định kỳ để tuân thủ quy định chống rửa tiền. Nếu có vấn đề, team Compliance sẽ liên hệ.',
      parentRoute: '/p2p/compliance/overview',
      emptyTitle: 'Chưa có dữ liệu kiểm tra AML',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PSourceOfFundsSnapshot getSourceOfFunds() {
    return const P2PSourceOfFundsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-source-of-funds',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Source of Funds',
      subtitle: 'Tuân thủ · P2P',
      heroTitle: 'Khai báo nguồn vốn',
      heroSubtitle:
          'Yêu cầu cho giao dịch lớn hoặc Tier 3. Thông tin được bảo mật.',
      sourceTitle: 'Nguồn tiền chính',
      inputLabel: 'Chi tiết bổ sung',
      inputPlaceholder: 'VD: Lương từ công ty ABC, vị trí Senior Engineer',
      ctaLabel: 'Gửi khai báo',
      sources: _p2pFundSources,
      parentRoute: '/p2p/compliance/overview',
      successRoute: '/p2p/kyc/status',
      emptyTitle: 'Chưa có khai báo nguồn vốn',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PLargeTransactionJustificationSnapshot getLargeTransactionJustification({
    double amount = 100000000,
  }) {
    return P2PLargeTransactionJustificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-large-transaction',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Large Transaction',
      subtitle: 'Giao dịch · P2P',
      amount: amount,
      heroTitle: 'Giao dịch lớn: ${_formatVndDots(amount)}',
      heroSubtitle: 'Cần giải trình mục đích theo quy định AML/CTF',
      purposeTitle: 'Mục đích giao dịch',
      customPurposeLabel: 'Mục đích cụ thể',
      customPurposePlaceholder: 'Nhập mục đích sử dụng',
      detailsLabel: 'Giải trình chi tiết',
      detailsPlaceholder:
          'VD: Mua BTC để nắm giữ dài hạn, dự kiến hold 1-2 năm...',
      ctaLabel: 'Gửi giải trình',
      purposes: _p2pLargeTransactionPurposes,
      parentRoute: '/p2p/compliance/overview',
      successRoute: '/p2p/my-orders',
      emptyTitle: 'Chưa có giải trình giao dịch lớn',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PRiskAssessmentSnapshot getRiskAssessment() {
    return const P2PRiskAssessmentSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-risk-assessment',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Risk Assessment',
      subtitle: 'Rủi ro · P2P',
      overallRisk: 'low',
      score: 15,
      scoreLabel: 'Low Risk',
      scoreSubtitle: 'Risk Score: 15/100',
      infoText:
          'Risk score được tính dựa trên KYC level, transaction history, AML screening, và behavioral patterns.',
      factorTitle: 'Risk Factors',
      factors: _p2pRiskFactors,
      parentRoute: '/p2p/compliance/overview',
      emptyTitle: 'Chưa có dữ liệu đánh giá rủi ro',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PTaxReportingSnapshot getTaxReporting({
    int selectedYear = 2025,
    String selectedJurisdiction = 'US',
  }) {
    final jurisdiction = _p2pTaxJurisdictions.firstWhere(
      (item) => item.code == selectedJurisdiction,
      orElse: () => _p2pTaxJurisdictions.first,
    );

    return P2PTaxReportingSnapshot(
      endpoint: '/api/mobile/p2p/p2p-tax-reporting',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /exports',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Tax Reporting',
      subtitle: 'Thuế · P2P',
      selectedYear: selectedYear,
      selectedJurisdiction: jurisdiction,
      years: _p2pTaxYears,
      jurisdictions: _p2pTaxJurisdictions,
      summary: _p2pTaxSummary2025,
      documents: _p2pTaxDocuments2025,
      disclaimer:
          'This report is for informational purposes only and should not be considered tax advice. Please consult a qualified tax professional for your specific situation. Cryptocurrency tax laws vary by jurisdiction.',
      parentRoute: '/p2p',
      detailRoute: '/p2p/tax-report/detailed/$selectedYear',
      emptyTitle: 'Chưa có dữ liệu báo cáo thuế P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2POrderBookSnapshot getOrderBook({String selectedAsset = 'USDT'}) {
    final selected = _p2pOrderBookMarkets.firstWhere(
      (item) => item.asset == selectedAsset,
      orElse: () => _p2pOrderBookMarkets.first,
    );

    return P2POrderBookSnapshot(
      endpoint: '/api/mobile/p2p/p2p-order-book',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
        P2PScreenState.realtimeRefresh,
      ],
      title: 'Sổ lệnh P2P',
      subtitle: 'Giao dịch · P2P',
      selectedAsset: selected,
      markets: _p2pOrderBookMarkets,
      bids: _p2pOrderBookBids,
      asks: _p2pOrderBookAsks,
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có dữ liệu sổ lệnh',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDashboardSnapshot getDashboard({String timeFilter = '30d'}) {
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
  P2PAchievementsSnapshot getAchievements() {
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
  P2PBlacklistAddSnapshot getBlacklistAdd() {
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
  P2PBlacklistSnapshot getBlacklist() {
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
}
