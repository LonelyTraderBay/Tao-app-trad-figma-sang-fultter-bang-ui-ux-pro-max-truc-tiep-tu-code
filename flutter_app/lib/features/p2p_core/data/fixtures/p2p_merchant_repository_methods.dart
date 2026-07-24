part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryMerchantMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PMerchantApplySnapshot> getMerchantApply() async {
    await _simulateNetwork();
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
  Future<P2PMerchantProfileSnapshot> getMerchantProfile(
    String merchantId,
  ) async {
    await _simulateNetwork();
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
  Future<P2PReportMerchantSnapshot> getReportMerchant(String merchantId) async {
    await _simulateNetwork();
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
  Future<P2PTradingLevelSnapshot> getTradingLevel() async {
    await _simulateNetwork();
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
  Future<P2PReviewsSnapshot> getReviews() async {
    await _simulateNetwork();
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
}
