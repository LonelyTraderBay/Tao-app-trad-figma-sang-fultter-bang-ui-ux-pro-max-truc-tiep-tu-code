import 'package:flutter_riverpod/flutter_riverpod.dart';

final p2pRepositoryProvider = Provider<P2PRepository>(
  (_) => const MockP2PRepository(),
);

abstract interface class P2PRepository {
  P2PHomeSnapshot getHome({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    String fiat = 'VND',
  });

  P2PExpressSnapshot getExpress();

  P2PExpressConfirmSnapshot getExpressConfirm({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    double fiatAmount = 0,
    double cryptoAmount = 0,
    String? adId,
    String? paymentMethod,
  });

  P2POrderTimelineSnapshot getOrderTimeline(String orderId);

  P2POrderRateSnapshot getOrderRate(String orderId);

  P2POrderCancelSnapshot getOrderCancel(String orderId);

  P2POrderProofSnapshot getOrderProof(String orderId);

  P2POrderSnapshot getOrder(String orderId);

  P2PChatSnapshot getChat(String orderId);

  P2PDisputeDetailSnapshot getDisputeDetail(String disputeId);

  P2PDisputeEvidenceSnapshot getDisputeEvidence(String disputeId);

  P2PDisputeResolutionSnapshot getDisputeResolution(String disputeId);

  P2PDisputeOpenSnapshot getDisputeOpen(String orderId);

  P2PDisputesSnapshot getDisputes();

  P2PAdAnalyticsSnapshot getAdAnalytics(String adId);

  P2PAdDetailSnapshot getAdDetail(String adId);

  P2PMyAdsSnapshot getMyAds();

  P2PCreateAdSnapshot getCreateAd();

  P2PMerchantApplySnapshot getMerchantApply();

  P2PMerchantProfileSnapshot getMerchantProfile(String merchantId);

  P2PReportMerchantSnapshot getReportMerchant(String merchantId);

  P2PTradingLevelSnapshot getTradingLevel();

  P2PReviewsSnapshot getReviews();

  P2PPaymentMethodAddSnapshot getPaymentMethodAdd();

  P2PPaymentMethodVerificationSnapshot getPaymentMethodVerification(
    String methodId,
  );

  P2PPaymentMethodOwnershipSnapshot getPaymentMethodOwnership(String methodId);

  P2PPaymentMethodCoolingPeriodSnapshot getPaymentMethodCoolingPeriod();

  P2PPaymentMethodHistorySnapshot getPaymentMethodHistory();

  P2PPaymentMethodsSnapshot getPaymentMethods();

  P2PInsuranceFundSnapshot getInsuranceFund();

  P2PInsuranceCertificateSnapshot getInsuranceCertificate();

  P2PInsuranceScoreSnapshot getInsuranceScore();

  P2PInsurancePolicySnapshot getInsurancePolicy();

  P2PContributionHistorySnapshot getContributionHistory();

  P2PClaimDetailSnapshot getClaimDetail(String claimId);

  P2PEscrowBalanceSnapshot getEscrowBalance({String asset = 'USDT'});

  P2PEscrowDetailSnapshot getEscrowDetail(String orderId);

  P2PKycRequirementsSnapshot getKycRequirements();

  P2PKycStatusSnapshot getKycStatus();

  P2PIdentityVerificationSnapshot getIdentityVerification();

  P2PAddressProofSnapshot getAddressProof();

  P2PSelfieVerificationSnapshot getSelfieVerification();

  P2PVideoVerificationSnapshot getVideoVerification();

  P2PSecurityCenterSnapshot getSecurityCenter();

  P2PTwoFactorSettingsSnapshot getTwoFactorSettings();

  P2PDeviceManagementSnapshot getDeviceManagement();

  P2PAntiPhishingCodeSnapshot getAntiPhishingCode();

  P2PLoginHistorySnapshot getLoginHistory();

  P2PSuspiciousActivitySnapshot getSuspiciousActivity();

  P2PE2EInfoSnapshot getE2EInfo();

  P2PFraudPreventionSnapshot getFraudPrevention();

  P2PWalletTransferSnapshot getWalletTransfer({
    String asset = 'USDT',
    String type = 'deposit',
  });

  P2PFundLockHistorySnapshot getFundLockHistory({
    bool walletHistoryAlias = false,
  });

  P2PWalletSnapshot getWallet();

  P2PLimitTrackerSnapshot getLimitTracker();

  P2PTransactionLimitsSnapshot getTransactionLimits();

  P2PComplianceOverviewSnapshot getComplianceOverview();

  P2PAmlScreeningSnapshot getAmlScreening();

  P2PSourceOfFundsSnapshot getSourceOfFunds();

  P2PLargeTransactionJustificationSnapshot getLargeTransactionJustification({
    double amount = 100000000,
  });

  P2PRiskAssessmentSnapshot getRiskAssessment();

  P2PTaxReportingSnapshot getTaxReporting({
    int selectedYear = 2025,
    String selectedJurisdiction = 'US',
  });

  P2POrderBookSnapshot getOrderBook({String selectedAsset = 'USDT'});

  P2PDashboardSnapshot getDashboard({String timeFilter = '30d'});

  P2PAchievementsSnapshot getAchievements();

  P2PBlacklistAddSnapshot getBlacklistAdd();

  P2PBlacklistSnapshot getBlacklist();

  P2PNotificationSettingsSnapshot getNotificationSettings();

  P2PSettingsSnapshot getSettings();

  P2PGuideSnapshot getGuide();

  P2PMyOrdersSnapshot getMyOrders();
}

final class MockP2PRepository implements P2PRepository {
  const MockP2PRepository();

  @override
  P2PHomeSnapshot getHome({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    String fiat = 'VND',
  }) {
    final ads =
        _p2pAds
            .where(
              (ad) =>
                  ad.type ==
                      (tradeType == P2PTradeType.buy
                          ? P2PTradeType.sell
                          : P2PTradeType.buy) &&
                  ad.asset == asset &&
                  ad.active,
            )
            .toList()
          ..sort(
            (a, b) => tradeType == P2PTradeType.buy
                ? a.price.compareTo(b.price)
                : b.price.compareTo(a.price),
          );

    return P2PHomeSnapshot(
      endpoint: '/api/mobile/p2p/p2p',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'P2P',
      subtitle: 'Lv.3 · P2P Trading',
      defaultTradeType: P2PTradeType.buy,
      selectedTradeType: tradeType,
      selectedAsset: asset,
      selectedFiat: fiat,
      assets: _p2pHomeAssets,
      fiatCurrencies: _p2pHomeFiats,
      searchHint: 'Tìm merchant...',
      quickActions: _p2pHomeQuickActions,
      platformStats: _p2pHomePlatformStats,
      ads: ads,
      expressRoute: '/p2p/express',
      createRoute: '/p2p/create',
      myOrdersRoute: '/p2p/my-orders',
      tradingLevelRoute: '/p2p/trading-level',
      emptyTitle: 'Không tìm thấy offer',
      emptySubtitle: 'Thử thay đổi bộ lọc hoặc tài sản.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PExpressSnapshot getExpress() {
    return const P2PExpressSnapshot(
      endpoint: '/api/mobile/p2p/p2p-express',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      assets: _p2pAssets,
      quickAmountsVnd: [
        1000000,
        2000000,
        5000000,
        10000000,
        20000000,
        50000000,
      ],
      paymentMethods: _p2pPaymentMethods,
      ads: _p2pAds,
      escrowTitle: 'Bảo vệ bởi Escrow VitTrade',
      escrowBuyNote:
          'USDT sẽ được khóa trong Escrow cho đến khi bạn thanh toán và merchant xác nhận.',
      escrowSellNote:
          'USDT của bạn sẽ được khóa trong Escrow và chỉ giải phóng khi nhận được thanh toán.',
      steps: [
        P2PExpressStepDraft(
          title: 'Nhập số tiền VND muốn giao dịch',
          iconKey: 'amount',
        ),
        P2PExpressStepDraft(
          title: 'Hệ thống tự match offer giá tốt nhất',
          iconKey: 'match',
        ),
        P2PExpressStepDraft(
          title: 'Xác nhận - Tạo đơn - Thanh toán',
          iconKey: 'confirm',
        ),
      ],
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PExpressConfirmSnapshot getExpressConfirm({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    double fiatAmount = 0,
    double cryptoAmount = 0,
    String? adId,
    String? paymentMethod,
  }) {
    final ad = _p2pAds.firstWhere(
      (item) => item.id == adId,
      orElse: () => _p2pAds.first,
    );
    final resolvedPayment = paymentMethod == null || paymentMethod.isEmpty
        ? ad.paymentMethods.first
        : paymentMethod;

    return P2PExpressConfirmSnapshot(
      endpoint: '/api/mobile/p2p/p2p-express-confirm',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      tradeType: tradeType,
      asset: asset,
      fiatAmount: fiatAmount,
      cryptoAmount: cryptoAmount,
      paymentMethod: resolvedPayment,
      ad: ad,
      order: const P2POrderDraft(
        id: 'p2p001',
        orderNumber: 'VT-P2P-20240223-001',
        status: 'pending_payment',
        escrowMinutes: 15,
        escrowAmount: 200,
        fee: 0,
      ),
      escrowNote:
          'sẽ được khóa trong Escrow. Bạn có 15 phút để hoàn tất thanh toán sau khi tạo đơn.',
      warningNote:
          'Chỉ bấm xác nhận khi bạn đã sẵn sàng thanh toán. Hủy đơn nhiều lần sẽ ảnh hưởng đến uy tín.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2POrderTimelineSnapshot getOrderTimeline(String orderId) {
    return P2POrderTimelineSnapshot(
      endpoint: '/api/mobile/p2p/p2p-order-timeline-$orderId',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      order: P2POrderDraft(
        id: orderId,
        orderNumber: 'VT-P2P-20260305-001',
        status: 'awaiting_seller_confirmation',
        escrowMinutes: 15,
        escrowAmount: 200,
        fee: 0,
      ),
      events: _p2pOrderTimelineEvents,
      emptyTitle: 'No timeline events',
      emptySubtitle: 'Order activity will appear here when escrow changes.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2POrderRateSnapshot getOrderRate(String orderId) {
    return P2POrderRateSnapshot(
      endpoint: '/api/mobile/p2p/p2p-order-rate-$orderId',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      order: P2POrderRateDraft(
        id: orderId,
        merchant: 'CryptoKing_VN',
        typeLabel: 'Mua',
        amount: 200,
        asset: 'USDT',
        totalVnd: 5070000,
      ),
      quickTags: _p2pOrderRateTags,
      successTitle: 'Cam on ban!',
      successMessage: 'Danh gia cua ban giup cong dong giao dich an toan hon.',
      emptyTitle: 'No order to rate',
      emptySubtitle: 'Completed P2P orders can be rated here.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2POrderCancelSnapshot getOrderCancel(String orderId) {
    return P2POrderCancelSnapshot(
      endpoint: '/api/mobile/p2p/p2p-order-cancel-$orderId',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      order: P2POrderCancelDraft(
        id: orderId,
        orderNumber: 'VT-P2P-20240223-001',
        typeLabel: 'Mua',
        amount: 200,
        asset: 'USDT',
        totalVnd: 5070000,
        currency: 'VND',
        merchant: 'CryptoKing_VN',
        escrowAmount: 200,
      ),
      reasons: _p2pOrderCancelReasons,
      warningTitle: 'Lưu ý quan trọng',
      warningMessage:
          'Hủy đơn sẽ giải phóng 200.0000 USDT từ Escrow trả về merchant. Tỷ lệ hủy cao có thể bị giới hạn giao dịch.',
      emptyTitle: 'Không tìm thấy đơn hàng',
      emptySubtitle: 'Không thể hủy đơn khi thiếu thông tin escrow.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2POrderProofSnapshot getOrderProof(String orderId) {
    return P2POrderProofSnapshot(
      endpoint: '/api/mobile/p2p/p2p-order-proof-$orderId',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      order: P2POrderProofDraft(
        id: orderId,
        orderNumber: 'VT-P2P-20240223-001',
        totalVnd: 5070000,
        currency: 'VND',
      ),
      uploadTitle: 'Tải ảnh bằng chứng',
      uploadSubtitle:
          'Chụp ảnh giao dịch ngân hàng hiển thị rõ số tiền, thời gian và người nhận.',
      tipsTitle: 'HƯỚNG DẪN CHỤP ẢNH',
      tips: _p2pOrderProofTips,
      warningMessage:
          'Tải bằng chứng giả mạo là vi phạm nghiêm trọng và có thể dẫn đến khóa tài khoản vĩnh viễn.',
      emptyTitle: 'Chưa có bằng chứng',
      emptySubtitle: 'Tải ảnh thanh toán để merchant kiểm tra nhanh hơn.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2POrderSnapshot getOrder(String orderId) {
    return P2POrderSnapshot(
      endpoint: '/api/mobile/p2p/p2p-order-$orderId',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      order: P2POrderDetailDraft(
        id: orderId,
        orderNumber: 'VT-P2P-20240223-001',
        statusLabel: 'Chờ thanh toán',
        countdownLabel: '14:59',
        typeLabel: 'Mua',
        amount: 200,
        asset: 'USDT',
        priceVnd: 25350,
        totalVnd: 5070000,
        currency: 'VND',
        paymentMethod: 'Vietcombank',
        merchant: 'CryptoKing_VN',
        merchantId: 'mc001',
        escrowAmount: 200,
        feeLabel: 'Miễn phí',
        bankName: 'Vietcombank',
        accountNumber: '1234567890',
        accountName: 'NGUYEN VAN B',
        transferContent: 'VITTA P2P001',
        createdTime: '11:00',
      ),
      safetyTitle: 'Lưu ý an toàn giao dịch P2P',
      safetyBullets: const [
        'Không giao dịch ngoài nền tảng',
        'Chỉ nhấn "Đã thanh toán" khi đã chuyển khoản thật',
        'Không chia sẻ mã OTP hoặc mật khẩu cho bất kỳ ai',
        'Báo cáo ngay nếu bị yêu cầu làm điều bất thường',
      ],
      paymentFields: _p2pOrderPaymentFields,
      timeline: _p2pOrderTimelineSteps,
      quickActions: _p2pOrderQuickActions,
      transferWarningTitle: 'Lưu ý quan trọng',
      transferWarning:
          'Nội dung chuyển khoản phải ghi chính xác VITTA P2P001. Không ghi nội dung khác.',
      paymentWarning:
          'Chuyển khoản xong mới nhấn "Đã thanh toán". Nhấn trước khi chuyển có thể bị mất tiền.',
      emptyTitle: 'Không tìm thấy đơn hàng',
      emptySubtitle: 'Không thể hiển thị chi tiết khi thiếu thông tin escrow.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PChatSnapshot getChat(String orderId) {
    return P2PChatSnapshot(
      endpoint: '/api/mobile/p2p/p2p-chat-$orderId',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.realtimeRefresh,
      ],
      orderId: orderId,
      orderNumber: 'VT-P2P-20240221-001',
      merchant: 'CryptoKing_VN',
      merchantInitial: 'C',
      activeLabel: 'Đang hoạt động',
      warning: 'Không chia sẻ thông tin cá nhân hay mật khẩu trong chat.',
      e2eTitle: 'Mã hóa đầu cuối (E2E)',
      e2eSubtitle: 'Tin nhắn được bảo vệ. Nhấn để tìm hiểu thêm.',
      encryptionPill: 'Tin nhắn được mã hóa đầu cuối',
      messages: _p2pChatMessages,
      quickReplies: _p2pChatQuickReplies,
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDisputeDetailSnapshot getDisputeDetail(String disputeId) {
    return P2PDisputeDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-detail-$disputeId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      dispute: const P2PDisputeDraft(
        id: 'disp001',
        orderId: 'p2p006',
        orderNumber: 'VT-P2P-20240219-006',
        status: P2PDisputeStatus.underReview,
        statusLabel: 'Đang xem xét',
        reason: 'Đã thanh toán nhưng người bán không xác nhận',
        description:
            'Tôi đã chuyển khoản 20,280,000 VND qua Vietcombank lúc 08:15 nhưng người bán NewTrader01 không xác nhận sau 30 phút.',
        currentLevel: 2,
      ),
      levels: _p2pDisputeLevels,
      evidence: _p2pDisputeEvidence,
      timeline: _p2pDisputeTimeline,
      supportMessages: _p2pDisputeSupportMessages,
      emptyTitle: 'Không tìm thấy tranh chấp',
      emptySubtitle: 'Case này có thể đã được đóng hoặc thiếu quyền truy cập.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDisputeEvidenceSnapshot getDisputeEvidence(String disputeId) {
    return P2PDisputeEvidenceSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-evidence-$disputeId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      disputeId: disputeId,
      title: 'Dispute #$disputeId',
      subtitle: 'Upload tài liệu chứng minh',
      documents: _p2pDisputeEvidenceDocuments,
      emptyTitle: 'Chưa có loại bằng chứng',
      emptySubtitle: 'Hệ thống sẽ hiển thị checklist tài liệu cần bổ sung.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDisputeResolutionSnapshot getDisputeResolution(String disputeId) {
    return P2PDisputeResolutionSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-resolution-$disputeId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      disputeId: disputeId,
      resultTitle: 'Quyết định: Bên mua thắng',
      disputeLabel: 'Dispute #$disputeId',
      refundAmountLabel: '24.000.000',
      reason:
          'Seller không release sau khi buyer đã thanh toán. Evidence cho thấy buyer đã chuyển đúng số tiền.',
      mediator: 'Support Team #A5',
      resolvedAt: '2026-03-05 16:00',
      appealDeadline: '2026-03-07 16:00',
      emptyTitle: 'Chưa có kết quả giải quyết',
      emptySubtitle: 'Mediator sẽ cập nhật quyết định khi review hoàn tất.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDisputeOpenSnapshot getDisputeOpen(String orderId) {
    return P2PDisputeOpenSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-$orderId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      orderId: orderId,
      title: 'Mở tranh chấp',
      subtitle: 'Order #. Vui lòng cung cấp bằng chứng đầy đủ.',
      reasons: _p2pDisputeReasons,
      descriptionLabel: 'Mô tả chi tiết',
      descriptionPlaceholder:
          'Mô tả vấn đề, bao gồm: thời gian, số tiền, bằng chứng...',
      uploadTitle: 'Upload bằng chứng',
      uploadSubtitle: 'Screenshots, chat logs, payment receipts',
      targetDisputeId: 'sample',
      emptyTitle: 'Không thể mở tranh chấp',
      emptySubtitle: 'Đơn hàng này có thể chưa đủ điều kiện khiếu nại.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDisputesSnapshot getDisputes() {
    return const P2PDisputesSnapshot(
      endpoint: '/api/mobile/p2p/p2p-disputes',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      disputes: _p2pDisputeList,
      noticeTitle: 'Quy trình xử lý tranh chấp',
      notice:
          'Mọi tranh chấp được xử lý qua hệ thống 4 cấp: AI tự động -> Nhân viên hỗ trợ -> Trọng tài -> Ban giám đốc. Trung bình giải quyết trong 2-24 giờ.',
      guideTitle: 'Cách mở tranh chấp',
      guideSteps: _p2pDisputeGuideSteps,
      emptyTitle: 'Chưa có tranh chấp nào',
      emptySubtitle: 'Tất cả giao dịch P2P của bạn đều suôn sẻ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

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

  @override
  P2PInsuranceCertificateSnapshot getInsuranceCertificate() {
    return const P2PInsuranceCertificateSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-certificate',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      certId: 'CERT-PRO-2026-78400',
      holderName: 'Nguyễn Văn Minh',
      holderId: 'UID-8847291',
      tierName: 'Pro',
      coveragePct: 85,
      maxCoveragePerClaim: 100000000,
      maxCoveragePer30Days: 100000000,
      contributionRate: '0.1%',
      issueDate: '01/01/2026',
      validUntil: '31/12/2026',
      totalContributed: 238200,
      totalTransactions: 128,
      claimWindowDays: 7,
      reviewSla: '48 giờ',
      payoutSla: '72 giờ',
      auditor: 'Deloitte Vietnam',
      lastAuditDate: '28/02/2026',
      coveredCases: _p2pInsuranceCertificateCoveredCases,
      exclusions: _p2pInsuranceCertificateExclusions,
      disclosure:
          'Chứng nhận này xác nhận quyền lợi bảo hiểm P2P của bạn theo điều khoản hiện hành. Mức bảo hiểm có thể thay đổi khi tier merchant thay đổi.',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có chứng nhận bảo hiểm',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PInsuranceScoreSnapshot getInsuranceScore() {
    return const P2PInsuranceScoreSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-score',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      overallScore: 78,
      maxScore: 100,
      grade: 'A',
      gradeLabel: 'Tốt',
      gradeDescription: 'Bảo vệ mạnh - đang ở tier Pro',
      currentTier: 'Pro',
      factors: _p2pInsuranceScoreFactors,
      quickActions: _p2pInsuranceScoreQuickActions,
      tierRequirements: _p2pInsuranceScoreTiers,
      disclosure:
          'Điểm bảo vệ được tính dựa trên nhiều yếu tố và cập nhật hằng ngày. Điểm không ảnh hưởng đến khả năng giao dịch, chỉ xác định mức bảo hiểm khi xảy ra sự cố.',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có điểm bảo vệ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PInsurancePolicySnapshot getInsurancePolicy() {
    return const P2PInsurancePolicySnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-policy',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Điều khoản & Chính sách',
      subtitle: 'Quỹ Bảo Hiểm P2P',
      version: '2.1',
      lastUpdated: '01/03/2026',
      notice:
          'Vui lòng đọc kỹ các điều khoản trước khi sử dụng dịch vụ bảo hiểm P2P. Bằng việc gửi yêu cầu bồi thường, bạn xác nhận đã đọc và đồng ý với toàn bộ điều khoản này.',
      sections: _p2pInsurancePolicySections,
      privacyNotice:
          'Tài liệu này tuân thủ quy định bảo vệ dữ liệu cá nhân và được lưu trữ an toàn. Mọi thắc mắc vui lòng liên hệ support@platform.com.',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có điều khoản bảo hiểm',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PContributionHistorySnapshot getContributionHistory() {
    return const P2PContributionHistorySnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-contribution-history',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      contributions: _p2pContributionHistoryItems,
      contributionRateLabel: '0.1%',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có lịch sử đóng góp',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PClaimDetailSnapshot getClaimDetail(String claimId) {
    final claim =
        _p2pClaimDetails[claimId] ??
        _p2pClaimDetails[claimId == 'sample' ? 'ic001' : 'ic001']!;
    return P2PClaimDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-claim-sample',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      claim: claim,
      benchmarks: _p2pClaimBenchmarks,
      reasonShares: _p2pClaimReasonShares,
      parentRoute: '/p2p/insurance',
      orderRoute: '/p2p/order/${claim.orderId.replaceFirst('P2P-', '')}',
      supportRoute: '/support/help',
      emptyTitle: 'Không tìm thấy claim bảo hiểm',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PEscrowBalanceSnapshot getEscrowBalance({String asset = 'USDT'}) {
    final selectedAsset = _p2pEscrowOrders.containsKey(asset) ? asset : 'USDT';
    return P2PEscrowBalanceSnapshot(
      endpoint: '/api/mobile/p2p/p2p-escrow-balance',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      selectedAsset: selectedAsset,
      assets: _p2pEscrowAssets,
      ordersByAsset: _p2pEscrowOrders,
      title: 'Escrow Balance',
      subtitle: 'Escrow · P2P',
      infoTitle: 'Escrow là gì?',
      infoBody:
          'Khi bạn bán crypto, số tiền sẽ bị khóa trong escrow cho đến khi buyer thanh toán và bạn release. Điều này đảm bảo an toàn cho cả hai bên.',
      helpTitle: 'Khi nào tiền được giải phóng?',
      helpBullets: _p2pEscrowHelpBullets,
      parentRoute: '/p2p',
      emptyTitle: 'Không có tiền trong escrow',
      emptySubtitle: '$selectedAsset của bạn chưa bị khóa trong đơn hàng nào',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PEscrowDetailSnapshot getEscrowDetail(String orderId) {
    final order = getOrder(orderId).order;
    return P2PEscrowDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-escrow-$orderId',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      orderId: orderId,
      order: order,
      statusLabel: 'Đang khóa — Bảo vệ giao dịch',
      statusToneKey: 'warn',
      escrowAddress: _p2pEscrowAddress,
      explorerRoute: 'https://bscscan.com/address/$_p2pEscrowAddress',
      signers: _p2pEscrowSigners,
      timeline: _p2pEscrowTimeline,
      securityTitle: 'Bảo vệ bởi VitTrade Escrow',
      securityBody:
          'Coin được khóa trong smart contract đa chữ ký (2/3 multisig). Không bên nào có thể đơn phương rút coin. Nếu phát sinh tranh chấp, VitTrade sẽ đóng vai trò tài (arbiter).',
      parentRoute: '/p2p/order/$orderId',
      emptyTitle: 'Không tìm thấy escrow',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PKycRequirementsSnapshot getKycRequirements() {
    return const P2PKycRequirementsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-requirements',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      currentTier: 1,
      pendingTier: null,
      tiers: _p2pKycTiers,
      heroTitle: 'P2P KYC Verification',
      heroBody:
          'P2P yêu cầu xác minh riêng để đảm bảo an toàn giao dịch. Chọn tier phù hợp với nhu cầu của bạn.',
      noticeTitle: 'Lưu ý quan trọng',
      noticeBody:
          'KYC P2P độc lập với KYC nền tảng chính. Bạn cần hoàn thành xác minh riêng để sử dụng P2P Trading.',
      supportTitle: 'Cần hỗ trợ?',
      supportBody:
          'Nếu bạn gặp khó khăn trong quá trình xác minh, vui lòng liên hệ bộ phận hỗ trợ.',
      verifyRouteBase: '/p2p/kyc/verify',
      supportRoute: '/support',
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có tier KYC P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PKycStatusSnapshot getKycStatus() {
    return const P2PKycStatusSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-status',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      tier: 2,
      tierName: 'Intermediate',
      overallStatus: P2PKycVerificationStatus.pending,
      submittedAt: '2026-03-04 14:30',
      steps: _p2pKycStatusSteps,
      infoBody:
          'Chúng tôi đang xem xét hồ sơ của bạn. Bạn sẽ nhận được thông báo qua email khi hoàn tất.',
      supportTitle: 'Cần hỗ trợ?',
      supportBody:
          'Nếu bạn có thắc mắc về quá trình xác minh, vui lòng liên hệ Support.',
      parentRoute: '/p2p/kyc/requirements',
      supportRoute: '/support',
      emptyTitle: 'Chưa có hồ sơ KYC P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PIdentityVerificationSnapshot getIdentityVerification() {
    return const P2PIdentityVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-identity',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Xác minh danh tính',
      heroBody:
          'Upload CMND/CCCD/Passport để xác minh. Quá trình xử lý tự động qua OCR.',
      documentTypes: _p2pIdentityDocumentTypes,
      guidelines: _p2pIdentityGuidelines,
      securityNotes: _p2pIdentitySecurityNotes,
      parentRoute: '/p2p/kyc/status',
      nextRoute: '/p2p/kyc/face-match',
      emptyTitle: 'Chưa chọn loại giấy tờ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PAddressProofSnapshot getAddressProof() {
    return const P2PAddressProofSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-address',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Xác minh địa chỉ',
      heroBody:
          'Upload tài liệu chứng minh địa chỉ cư trú của bạn. Yêu cầu cho Tier 2+.',
      documentTypes: _p2pAddressDocumentTypes,
      requirements: _p2pAddressRequirements,
      securityNotes: _p2pAddressSecurityNotes,
      extractedName: 'NGUYỄN VĂN A',
      extractedAddress: '123 Đường Láng, Đống Đa, Hà Nội',
      extractedDate: '15/02/2026',
      parentRoute: '/p2p/kyc/status',
      submitRoute: '/p2p/kyc/status',
      emptyTitle: 'Chưa chọn tài liệu địa chỉ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PSelfieVerificationSnapshot getSelfieVerification() {
    return const P2PSelfieVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-selfie',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Selfie với ID',
      heroBody:
          'Chụp ảnh selfie cầm ID card để xác minh danh tính. Bao gồm liveness detection.',
      sampleTitle: 'Ảnh mẫu selfie với ID',
      sampleBody: 'Giữ ID cạnh khuôn mặt',
      guidelines: _p2pSelfieGuidelines,
      tips: _p2pSelfieTips,
      livenessActions: _p2pSelfieLivenessActions,
      matchScore: '96.5%',
      livenessScore: '98.2%',
      parentRoute: '/p2p/kyc/status',
      statusRoute: '/p2p/kyc/status',
      supportRoute: '/support',
      emptyTitle: 'Chưa có selfie verification',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PVideoVerificationSnapshot getVideoVerification() {
    return const P2PVideoVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-video',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Video KYC Call',
      heroBody:
          'Gọi video với agent để xác minh danh tính. Yêu cầu cho Tier 3.',
      preparationItems: _p2pVideoPreparationItems,
      timeSlots: _p2pVideoTimeSlots,
      parentRoute: '/p2p/kyc/status',
      statusRoute: '/p2p/kyc/status',
      emptyTitle: 'Chưa chọn khung giờ video KYC',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PSecurityCenterSnapshot getSecurityCenter() {
    return const P2PSecurityCenterSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-center',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      score: 90,
      maxScore: 100,
      scoreLabel: 'Xuất sắc',
      scoreSubtitle: 'Điểm bảo mật P2P của bạn',
      scoreBody: 'Tài khoản P2P của bạn được bảo vệ rất tốt. Tiếp tục duy trì!',
      features: _p2pSecurityFeatures,
      quickActions: _p2pSecurityQuickActions,
      recentEvents: _p2pSecurityRecentEvents,
      parentRoute: '/p2p',
      settingsRoute: '/p2p/settings',
      loginHistoryRoute: '/p2p/security/login-history',
      emptyTitle: 'Chưa có cảnh báo bảo mật P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PTwoFactorSettingsSnapshot getTwoFactorSettings() {
    return const P2PTwoFactorSettingsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-2fa',
      actionDraft:
          'POST /auth/verify-factor; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      methods: _p2pTwoFactorMethods,
      thresholds: _p2pTwoFactorThresholds,
      recommendation:
          'Nên bật ít nhất 2 phương thức 2FA và đặt threshold thấp để đảm bảo an toàn cho tài khoản P2P.',
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Chưa có cấu hình 2FA P2P',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDeviceManagementSnapshot getDeviceManagement() {
    return const P2PDeviceManagementSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-devices',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      devices: _p2pTrustedDevices,
      infoTitle: 'Thiết bị tin cậy',
      infoBody:
          'Đánh dấu thiết bị tin cậy để giảm số lần xác thực 2FA. Chỉ đánh dấu thiết bị cá nhân của bạn.',
      securityTips: _p2pDeviceSecurityTips,
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Chưa có thiết bị P2P đã đăng nhập',
      contractNotes:
          'P2P requires escrow, fraud, KYC, payment-state clarity. Reference/admin surface; gate behind internal role or dev flag.',
    );
  }

  @override
  P2PAntiPhishingCodeSnapshot getAntiPhishingCode() {
    return const P2PAntiPhishingCodeSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-anti-phishing',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      hasCode: true,
      currentCode: 'SECURE2026',
      statusTitle: 'Anti-Phishing Code đã bật',
      statusBody: 'Mọi email P2P chính thức sẽ chứa code này',
      explainerTitle: 'Anti-Phishing Code là gì?',
      explainerBody:
          'Đây là mã bảo mật cá nhân xuất hiện trong mọi email chính thức từ VitTrade. Nếu email không có code này, đó là email giả mạo.',
      benefits: _p2pAntiPhishingBenefits,
      examples: _p2pAntiPhishingExamples,
      warningTitle: 'Cảnh báo quan trọng',
      warnings: _p2pAntiPhishingWarnings,
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Chưa có Anti-Phishing Code P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PLoginHistorySnapshot getLoginHistory() {
    return const P2PLoginHistorySnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-login-history',
      actionDraft:
          'POST /auth/login; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      events: _p2pLoginHistoryEvents,
      warningBody: 'Nếu không phải bạn, vui lòng đổi mật khẩu và bật 2FA ngay.',
      infoTitle: 'Lưu ý bảo mật',
      securityTips: _p2pLoginHistorySecurityTips,
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Không có lịch sử đăng nhập',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PSuspiciousActivitySnapshot getSuspiciousActivity() {
    return const P2PSuspiciousActivitySnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-suspicious-activity',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      alerts: _p2pSuspiciousAlerts,
      summarySubtitle: 'Xem lại hoạt động đáng ngờ',
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Không có hoạt động đáng ngờ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

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
    return const P2PGuideSnapshot(
      endpoint: '/api/mobile/p2p/p2p-guide',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
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
      supportRoute: '/support/help',
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

enum P2PTradeType { buy, sell }

enum P2PScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
}

enum P2POrderTimelineStatus { completed, pending, failed }

enum P2PMyAdStatus { active, paused, expired }

enum P2PEscrowOrderType { buy, sell }

enum P2PEscrowOrderStatus { pendingPayment, paid, pendingRelease, dispute }

enum P2PKycTierStatus { locked, available, current, pending }

enum P2PKycVerificationStatus { approved, pending, rejected, incomplete }

enum P2PKycStepStatus { completed, pending, rejected, waiting, processing }

enum P2PSecurityStatus { enabled, warning, disabled }

enum P2PSecurityEventSeverity { info, warning, critical }

final class P2PHomeSnapshot {
  const P2PHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.defaultTradeType,
    required this.selectedTradeType,
    required this.selectedAsset,
    required this.selectedFiat,
    required this.assets,
    required this.fiatCurrencies,
    required this.searchHint,
    required this.quickActions,
    required this.platformStats,
    required this.ads,
    required this.expressRoute,
    required this.createRoute,
    required this.myOrdersRoute,
    required this.tradingLevelRoute,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2PTradeType defaultTradeType;
  final P2PTradeType selectedTradeType;
  final String selectedAsset;
  final String selectedFiat;
  final List<String> assets;
  final List<String> fiatCurrencies;
  final String searchHint;
  final List<P2PHomeQuickActionDraft> quickActions;
  final P2PHomePlatformStatsDraft platformStats;
  final List<P2PAdDraft> ads;
  final String expressRoute;
  final String createRoute;
  final String myOrdersRoute;
  final String tradingLevelRoute;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PHomeQuickActionDraft {
  const P2PHomeQuickActionDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    required this.route,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
  final String route;
  final String toneKey;
}

final class P2PHomePlatformStatsDraft {
  const P2PHomePlatformStatsDraft({
    required this.volume24h,
    required this.volume24hChange,
    required this.totalTrades24h,
    required this.activeMerchants,
    required this.onlineTraders,
    required this.avgCompletionRate,
    required this.avgCompletionTime,
    required this.escrowProtected,
  });

  final int volume24h;
  final double volume24hChange;
  final int totalTrades24h;
  final int activeMerchants;
  final int onlineTraders;
  final double avgCompletionRate;
  final String avgCompletionTime;
  final int escrowProtected;
}

final class P2PExpressConfirmSnapshot {
  const P2PExpressConfirmSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.tradeType,
    required this.asset,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.paymentMethod,
    required this.ad,
    required this.order,
    required this.escrowNote,
    required this.warningNote,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PTradeType tradeType;
  final String asset;
  final double fiatAmount;
  final double cryptoAmount;
  final String paymentMethod;
  final P2PAdDraft ad;
  final P2POrderDraft order;
  final String escrowNote;
  final String warningNote;
  final String contractNotes;

  bool get isBuy => tradeType == P2PTradeType.buy;
}

final class P2PExpressSnapshot {
  const P2PExpressSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.quickAmountsVnd,
    required this.paymentMethods,
    required this.ads,
    required this.escrowTitle,
    required this.escrowBuyNote,
    required this.escrowSellNote,
    required this.steps,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PAssetDraft> assets;
  final List<int> quickAmountsVnd;
  final List<P2PPaymentMethodDraft> paymentMethods;
  final List<P2PAdDraft> ads;
  final String escrowTitle;
  final String escrowBuyNote;
  final String escrowSellNote;
  final List<P2PExpressStepDraft> steps;
  final String contractNotes;

  P2PAssetDraft assetBySymbol(String symbol) {
    return assets.firstWhere(
      (asset) => asset.symbol == symbol,
      orElse: () => assets.first,
    );
  }

  List<P2PAdDraft> topAds({
    required P2PTradeType tradeType,
    required String asset,
    required int fiatAmount,
  }) {
    final adType = tradeType == P2PTradeType.buy
        ? P2PTradeType.sell
        : P2PTradeType.buy;
    final candidates =
        ads
            .where((ad) => ad.type == adType && ad.asset == asset && ad.active)
            .where(
              (ad) =>
                  fiatAmount <= 0 ||
                  (fiatAmount >= ad.minLimit && fiatAmount <= ad.maxLimit),
            )
            .toList()
          ..sort(
            (a, b) => tradeType == P2PTradeType.buy
                ? a.price.compareTo(b.price)
                : b.price.compareTo(a.price),
          );
    return candidates.take(3).toList();
  }

  P2PAdDraft? bestAd({
    required P2PTradeType tradeType,
    required String asset,
    required int fiatAmount,
    String? paymentMethod,
  }) {
    if (fiatAmount <= 0) return null;
    final candidates =
        topAds(
          tradeType: tradeType,
          asset: asset,
          fiatAmount: fiatAmount,
        ).where(
          (ad) =>
              paymentMethod == null ||
              paymentMethod.isEmpty ||
              ad.paymentMethods.contains(paymentMethod),
        );
    return candidates.isEmpty ? null : candidates.first;
  }
}

final class P2POrderTimelineSnapshot {
  const P2POrderTimelineSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.events,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderDraft order;
  final List<P2POrderTimelineEventDraft> events;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderRateSnapshot {
  const P2POrderRateSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.quickTags,
    required this.successTitle,
    required this.successMessage,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderRateDraft order;
  final List<P2POrderRateTagDraft> quickTags;
  final String successTitle;
  final String successMessage;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderCancelSnapshot {
  const P2POrderCancelSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.reasons,
    required this.warningTitle,
    required this.warningMessage,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderCancelDraft order;
  final List<String> reasons;
  final String warningTitle;
  final String warningMessage;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderProofSnapshot {
  const P2POrderProofSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.uploadTitle,
    required this.uploadSubtitle,
    required this.tipsTitle,
    required this.tips,
    required this.warningMessage,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderProofDraft order;
  final String uploadTitle;
  final String uploadSubtitle;
  final String tipsTitle;
  final List<String> tips;
  final String warningMessage;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderSnapshot {
  const P2POrderSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.safetyTitle,
    required this.safetyBullets,
    required this.paymentFields,
    required this.timeline,
    required this.quickActions,
    required this.transferWarningTitle,
    required this.transferWarning,
    required this.paymentWarning,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderDetailDraft order;
  final String safetyTitle;
  final List<String> safetyBullets;
  final List<P2POrderPaymentFieldDraft> paymentFields;
  final List<P2POrderTimelineStepDraft> timeline;
  final List<P2POrderQuickActionDraft> quickActions;
  final String transferWarningTitle;
  final String transferWarning;
  final String paymentWarning;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PChatSnapshot {
  const P2PChatSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.orderNumber,
    required this.merchant,
    required this.merchantInitial,
    required this.activeLabel,
    required this.warning,
    required this.e2eTitle,
    required this.e2eSubtitle,
    required this.encryptionPill,
    required this.messages,
    required this.quickReplies,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final String orderNumber;
  final String merchant;
  final String merchantInitial;
  final String activeLabel;
  final String warning;
  final String e2eTitle;
  final String e2eSubtitle;
  final String encryptionPill;
  final List<P2PChatMessageDraft> messages;
  final List<String> quickReplies;
  final String contractNotes;
}

enum P2PChatSender { system, me, other }

final class P2PChatMessageDraft {
  const P2PChatMessageDraft({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    this.isRead = true,
  });

  final String id;
  final P2PChatSender sender;
  final String text;
  final String time;
  final bool isRead;
}

final class P2PDisputeDetailSnapshot {
  const P2PDisputeDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.dispute,
    required this.levels,
    required this.evidence,
    required this.timeline,
    required this.supportMessages,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PDisputeDraft dispute;
  final List<P2PDisputeLevelDraft> levels;
  final List<P2PDisputeEvidenceDraft> evidence;
  final List<P2PDisputeTimelineDraft> timeline;
  final List<P2PDisputeSupportMessageDraft> supportMessages;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  P2PDisputeLevelDraft levelByNumber(int level) {
    return levels.firstWhere(
      (item) => item.level == level,
      orElse: () => levels.first,
    );
  }
}

enum P2PDisputeStatus { submitted, underReview, resolved, rejected }

enum P2PDisputeMessageSender { user, support }

final class P2PDisputeDraft {
  const P2PDisputeDraft({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.reason,
    required this.description,
    required this.currentLevel,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final P2PDisputeStatus status;
  final String statusLabel;
  final String reason;
  final String description;
  final int currentLevel;
}

final class P2PDisputeLevelDraft {
  const P2PDisputeLevelDraft({
    required this.level,
    required this.shortLabel,
    required this.label,
    required this.description,
    required this.avgTime,
    required this.iconKey,
  });

  final int level;
  final String shortLabel;
  final String label;
  final String description;
  final String avgTime;
  final String iconKey;
}

final class P2PDisputeEvidenceDraft {
  const P2PDisputeEvidenceDraft({required this.id, required this.fileName});

  final String id;
  final String fileName;
}

final class P2PDisputeTimelineDraft {
  const P2PDisputeTimelineDraft({
    required this.id,
    required this.event,
    required this.time,
    this.detail,
    this.active = false,
  });

  final String id;
  final String event;
  final String time;
  final String? detail;
  final bool active;
}

final class P2PDisputeSupportMessageDraft {
  const P2PDisputeSupportMessageDraft({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });

  final String id;
  final P2PDisputeMessageSender sender;
  final String text;
  final String time;
}

final class P2PDisputeEvidenceSnapshot {
  const P2PDisputeEvidenceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputeId,
    required this.title,
    required this.subtitle,
    required this.documents,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String disputeId;
  final String title;
  final String subtitle;
  final List<P2PDisputeEvidenceDocumentDraft> documents;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PDisputeEvidenceDocumentDraft {
  const P2PDisputeEvidenceDocumentDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.uploaded,
  });

  final String id;
  final String label;
  final String iconKey;
  final bool uploaded;
}

final class P2PDisputeResolutionSnapshot {
  const P2PDisputeResolutionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputeId,
    required this.resultTitle,
    required this.disputeLabel,
    required this.refundAmountLabel,
    required this.reason,
    required this.mediator,
    required this.resolvedAt,
    required this.appealDeadline,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String disputeId;
  final String resultTitle;
  final String disputeLabel;
  final String refundAmountLabel;
  final String reason;
  final String mediator;
  final String resolvedAt;
  final String appealDeadline;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PDisputeOpenSnapshot {
  const P2PDisputeOpenSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.title,
    required this.subtitle,
    required this.reasons,
    required this.descriptionLabel,
    required this.descriptionPlaceholder,
    required this.uploadTitle,
    required this.uploadSubtitle,
    required this.targetDisputeId,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final String title;
  final String subtitle;
  final List<String> reasons;
  final String descriptionLabel;
  final String descriptionPlaceholder;
  final String uploadTitle;
  final String uploadSubtitle;
  final String targetDisputeId;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PDisputesSnapshot {
  const P2PDisputesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputes,
    required this.noticeTitle,
    required this.notice,
    required this.guideTitle,
    required this.guideSteps,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PDisputeListItemDraft> disputes;
  final String noticeTitle;
  final String notice;
  final String guideTitle;
  final List<String> guideSteps;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  int get totalCount => disputes.length;

  int get activeCount =>
      disputes.where((item) => item.status != P2PDisputeStatus.resolved).length;

  int get resolvedCount =>
      disputes.where((item) => item.status == P2PDisputeStatus.resolved).length;
}

final class P2PDisputeListItemDraft {
  const P2PDisputeListItemDraft({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.reason,
    required this.createdAt,
    required this.evidenceCount,
    required this.timelineCount,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final P2PDisputeStatus status;
  final String statusLabel;
  final String reason;
  final String createdAt;
  final int evidenceCount;
  final int timelineCount;

  String get shortOrderNumber {
    if (orderNumber.length <= 6) return orderNumber;
    return orderNumber.substring(orderNumber.length - 6);
  }
}

final class P2PAdAnalyticsSnapshot {
  const P2PAdAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.adId,
    required this.sourceAdId,
    required this.tradeType,
    required this.asset,
    required this.currency,
    required this.priceVnd,
    required this.ranking,
    required this.totalActiveAds,
    required this.impressions,
    required this.clicks,
    required this.ordersCreated,
    required this.ordersCompleted,
    required this.ordersDisputed,
    required this.ordersCancelled,
    required this.totalVolume,
    required this.totalRevenue,
    required this.avgOrderValue,
    required this.avgResponseTimeSeconds,
    required this.avgCompletionMinutes,
    required this.conversionRate,
    required this.completionRate,
    required this.rating,
    required this.reviewsCount,
    required this.dailyPerformance,
    required this.hourlyHeatmap,
    required this.paymentBreakdown,
    required this.competitorComparison,
    required this.optimizationTips,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String adId;
  final String sourceAdId;
  final P2PTradeType tradeType;
  final String asset;
  final String currency;
  final int priceVnd;
  final int ranking;
  final int totalActiveAds;
  final int impressions;
  final int clicks;
  final int ordersCreated;
  final int ordersCompleted;
  final int ordersDisputed;
  final int ordersCancelled;
  final int totalVolume;
  final int totalRevenue;
  final int avgOrderValue;
  final int avgResponseTimeSeconds;
  final double avgCompletionMinutes;
  final double conversionRate;
  final double completionRate;
  final double rating;
  final int reviewsCount;
  final List<P2PAdDailyPerformanceDraft> dailyPerformance;
  final List<P2PAdHourlyHeatmapDraft> hourlyHeatmap;
  final List<P2PAdPaymentBreakdownDraft> paymentBreakdown;
  final List<P2PAdCompetitorComparisonDraft> competitorComparison;
  final List<P2PAdOptimizationTipDraft> optimizationTips;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PAdDailyPerformanceDraft {
  const P2PAdDailyPerformanceDraft({
    required this.date,
    required this.impressions,
    required this.orders,
    required this.volume,
  });

  final String date;
  final int impressions;
  final int orders;
  final int volume;
}

final class P2PAdHourlyHeatmapDraft {
  const P2PAdHourlyHeatmapDraft({required this.hour, required this.orders});

  final int hour;
  final int orders;
}

final class P2PAdPaymentBreakdownDraft {
  const P2PAdPaymentBreakdownDraft({
    required this.method,
    required this.count,
    required this.volume,
  });

  final String method;
  final int count;
  final int volume;
}

final class P2PAdCompetitorComparisonDraft {
  const P2PAdCompetitorComparisonDraft({
    required this.metric,
    required this.yours,
    required this.average,
    required this.top,
  });

  final String metric;
  final double yours;
  final double average;
  final double top;
}

final class P2PAdOptimizationTipDraft {
  const P2PAdOptimizationTipDraft({
    required this.tone,
    required this.iconKey,
    required this.text,
  });

  final String tone;
  final String iconKey;
  final String text;
}

final class P2PAdDetailSnapshot {
  const P2PAdDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.adId,
    required this.sourceAdId,
    required this.ad,
    required this.marketPriceVnd,
    required this.priceDiffPct,
    required this.trustScore,
    required this.trustLabel,
    required this.viewerCount,
    required this.totalVolume30dUsd,
    required this.availableAmount,
    required this.paymentWindowMinutes,
    required this.minKycLevel,
    required this.minCompletedTrades,
    required this.remarks,
    required this.tradingHours,
    required this.targetOrderId,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String adId;
  final String sourceAdId;
  final P2PAdDraft ad;
  final int marketPriceVnd;
  final double priceDiffPct;
  final int trustScore;
  final String trustLabel;
  final int viewerCount;
  final int totalVolume30dUsd;
  final double availableAmount;
  final int paymentWindowMinutes;
  final int minKycLevel;
  final int minCompletedTrades;
  final String remarks;
  final String tradingHours;
  final String targetOrderId;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PMerchantProfileSnapshot {
  const P2PMerchantProfileSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.merchantId,
    required this.merchant,
    required this.ads,
    required this.reviews,
    required this.reportRoute,
    required this.blacklistAddRoute,
    required this.emptyAdsTitle,
    required this.emptyReviewsTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String merchantId;
  final P2PMerchantProfileDraft merchant;
  final List<P2PMerchantProfileAdDraft> ads;
  final List<P2PMerchantProfileReviewDraft> reviews;
  final String reportRoute;
  final String blacklistAddRoute;
  final String emptyAdsTitle;
  final String emptyReviewsTitle;
  final String contractNotes;

  int get positiveReviewCount =>
      (merchant.totalTrades * merchant.positiveRate / 100).round();
}

final class P2PMerchantProfileDraft {
  const P2PMerchantProfileDraft({
    required this.id,
    required this.name,
    required this.level,
    required this.kycVerified,
    required this.joinDate,
    required this.totalTrades,
    required this.totalTrades30d,
    required this.completionRate,
    required this.avgReleaseTime,
    required this.avgPayTime,
    required this.totalVolume30dUsd,
    required this.isOnline,
    required this.lastActive,
    required this.positiveRate,
    required this.negativeCount,
    required this.activeAds,
    this.isBlocked = false,
    this.isFollowed = false,
  });

  final String id;
  final String name;
  final int level;
  final bool kycVerified;
  final String joinDate;
  final int totalTrades;
  final int totalTrades30d;
  final double completionRate;
  final String avgReleaseTime;
  final String avgPayTime;
  final int totalVolume30dUsd;
  final bool isOnline;
  final String lastActive;
  final double positiveRate;
  final int negativeCount;
  final int activeAds;
  final bool isBlocked;
  final bool isFollowed;
}

final class P2PMerchantProfileAdDraft {
  const P2PMerchantProfileAdDraft({
    required this.id,
    required this.merchantId,
    required this.type,
    required this.asset,
    required this.available,
    required this.price,
    required this.minLimit,
    required this.maxLimit,
    required this.paymentMethods,
  });

  final String id;
  final String merchantId;
  final P2PTradeType type;
  final String asset;
  final double available;
  final int price;
  final int minLimit;
  final int maxLimit;
  final List<String> paymentMethods;
}

final class P2PMerchantProfileReviewDraft {
  const P2PMerchantProfileReviewDraft({
    required this.id,
    required this.fromUser,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.positive,
  });

  final String id;
  final String fromUser;
  final String toUserId;
  final int rating;
  final String comment;
  final String createdAt;
  final bool positive;
}

final class P2PReportMerchantSnapshot {
  const P2PReportMerchantSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.merchantId,
    required this.merchant,
    required this.reasons,
    required this.blacklistAddRoute,
    required this.merchantProfileRoute,
    required this.detailPrompt,
    required this.reviewNotice,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String merchantId;
  final P2PMerchantProfileDraft merchant;
  final List<P2PReportReasonDraft> reasons;
  final String blacklistAddRoute;
  final String merchantProfileRoute;
  final String detailPrompt;
  final String reviewNotice;
  final String emptyTitle;
  final String contractNotes;
}

enum P2PReportReasonTone { danger, purple, warning, info, neutral }

final class P2PReportReasonDraft {
  const P2PReportReasonDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final P2PReportReasonTone tone;
}

final class P2PTradingLevelSnapshot {
  const P2PTradingLevelSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.userLevel,
    required this.currentLevel,
    required this.levels,
    required this.upgradeRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PUserTradingLevelDraft userLevel;
  final P2PTradingLevelDraft currentLevel;
  final List<P2PTradingLevelDraft> levels;
  final String upgradeRoute;
  final String emptyTitle;
  final String contractNotes;

  int get dailyUsagePercent =>
      (userLevel.dailyUsed / userLevel.dailyLimit * 100).round();
}

final class P2PReviewsSnapshot {
  const P2PReviewsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.receivedReviews,
    required this.givenReviews,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PReviewDraft> receivedReviews;
  final List<P2PReviewDraft> givenReviews;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PReviewDraft {
  const P2PReviewDraft({
    required this.id,
    required this.orderId,
    required this.fromUser,
    required this.fromUserId,
    required this.toUser,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.positive,
    this.reply,
  });

  final String id;
  final String orderId;
  final String fromUser;
  final String fromUserId;
  final String toUser;
  final String toUserId;
  final int rating;
  final String comment;
  final String createdAt;
  final bool positive;
  final String? reply;
}

final class P2PPaymentMethodAddSnapshot {
  const P2PPaymentMethodAddSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.bankOptions,
    required this.ewalletOptions,
    required this.defaultBankAccountHint,
    required this.defaultEwalletAccountHint,
    required this.ownerNameHint,
    required this.saveRoute,
    required this.securityNote,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<String> bankOptions;
  final List<String> ewalletOptions;
  final String defaultBankAccountHint;
  final String defaultEwalletAccountHint;
  final String ownerNameHint;
  final String saveRoute;
  final String securityNote;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentMethodVerificationSnapshot {
  const P2PPaymentMethodVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methodId,
    required this.methods,
    required this.microDepositSteps,
    required this.warningNote,
    required this.saveRoute,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String methodId;
  final List<P2PPaymentVerificationMethodDraft> methods;
  final List<String> microDepositSteps;
  final String warningNote;
  final String saveRoute;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentVerificationMethodDraft {
  const P2PPaymentVerificationMethodDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.duration,
    required this.iconKey,
    this.recommended = false,
  });

  final String id;
  final String label;
  final String description;
  final String duration;
  final String iconKey;
  final bool recommended;
}

final class P2PPaymentMethodOwnershipSnapshot {
  const P2PPaymentMethodOwnershipSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methodId,
    required this.documents,
    required this.saveRoute,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String methodId;
  final List<P2POwnershipDocumentDraft> documents;
  final String saveRoute;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2POwnershipDocumentDraft {
  const P2POwnershipDocumentDraft({
    required this.id,
    required this.label,
    this.optional = false,
  });

  final String id;
  final String label;
  final bool optional;
}

final class P2PPaymentMethodCoolingPeriodSnapshot {
  const P2PPaymentMethodCoolingPeriodSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.addedAt,
    required this.availableAt,
    required this.hoursRemaining,
    required this.reason,
    required this.reasons,
    required this.waitTitle,
    required this.waitMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String addedAt;
  final String availableAt;
  final int hoursRemaining;
  final String reason;
  final List<String> reasons;
  final String waitTitle;
  final String waitMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentMethodHistorySnapshot {
  const P2PPaymentMethodHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalTransactions,
    required this.totalVolume,
    required this.successRate,
    required this.transactions,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int totalTransactions;
  final int totalVolume;
  final double successRate;
  final List<P2PPaymentHistoryTransactionDraft> transactions;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentHistoryTransactionDraft {
  const P2PPaymentHistoryTransactionDraft({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.status,
    required this.timestamp,
  });

  final String id;
  final String orderId;
  final P2PTradeType type;
  final int amount;
  final String status;
  final String timestamp;
}

final class P2PPaymentMethodsSnapshot {
  const P2PPaymentMethodsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methods,
    required this.addBankRoute,
    required this.addEwalletRoute,
    required this.securityNote,
    required this.deleteConfirmTitle,
    required this.deleteConfirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PPaymentListMethodDraft> methods;
  final String addBankRoute;
  final String addEwalletRoute;
  final String securityNote;
  final String deleteConfirmTitle;
  final String deleteConfirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

enum P2PPaymentListMethodType { bank, ewallet }

final class P2PPaymentListMethodDraft {
  const P2PPaymentListMethodDraft({
    required this.id,
    required this.type,
    required this.name,
    required this.accountNumber,
    required this.accountName,
    required this.isVerified,
    this.isDefault = false,
  });

  final String id;
  final P2PPaymentListMethodType type;
  final String name;
  final String accountNumber;
  final String accountName;
  final bool isVerified;
  final bool isDefault;

  P2PPaymentListMethodDraft copyWith({bool? isDefault}) {
    return P2PPaymentListMethodDraft(
      id: id,
      type: type,
      name: name,
      accountNumber: accountNumber,
      accountName: accountName,
      isVerified: isVerified,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

final class P2PInsuranceFundSnapshot {
  const P2PInsuranceFundSnapshot({
    required this.endpoint,
    required this.legacyEndpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalFund,
    required this.activeClaims,
    required this.totalContributed,
    required this.totalPaid,
    required this.userCoveragePct,
    required this.tierName,
    required this.contributionRate,
    required this.outstandingClaimsAmount,
    required this.solvencyRatio,
    required this.healthStatus,
    required this.lastAuditDate,
    required this.auditorName,
    required this.nextAuditDate,
    required this.maxClaimPerPeriod,
    required this.approvalRate,
    required this.avgResolutionHours,
    required this.eligibilityItems,
    required this.coverageTiers,
    required this.notificationPrefs,
    required this.claims,
    required this.chartPoints,
    required this.certificateRoute,
    required this.contributionHistoryRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String legacyEndpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int totalFund;
  final int activeClaims;
  final int totalContributed;
  final int totalPaid;
  final int userCoveragePct;
  final String tierName;
  final String contributionRate;
  final int outstandingClaimsAmount;
  final double solvencyRatio;
  final String healthStatus;
  final String lastAuditDate;
  final String auditorName;
  final String nextAuditDate;
  final int maxClaimPerPeriod;
  final double approvalRate;
  final int avgResolutionHours;
  final List<P2PInsuranceEligibilityItemDraft> eligibilityItems;
  final List<P2PInsuranceCoverageTierDraft> coverageTiers;
  final List<P2PInsuranceNotificationPrefDraft> notificationPrefs;
  final List<P2PInsuranceClaimDraft> claims;
  final List<P2PInsuranceChartPointDraft> chartPoints;
  final String certificateRoute;
  final String contributionHistoryRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PInsuranceEligibilityItemDraft {
  const P2PInsuranceEligibilityItemDraft({
    required this.label,
    this.value,
    this.highlight = false,
  });

  final String label;
  final String? value;
  final bool highlight;
}

final class P2PInsuranceCoverageTierDraft {
  const P2PInsuranceCoverageTierDraft({
    required this.name,
    required this.coveragePct,
    this.bonus,
    this.highlight = false,
  });

  final String name;
  final String coveragePct;
  final String? bonus;
  final bool highlight;
}

final class P2PInsuranceNotificationPrefDraft {
  const P2PInsuranceNotificationPrefDraft({
    required this.key,
    required this.label,
    required this.description,
    required this.enabled,
  });

  final String key;
  final String label;
  final String description;
  final bool enabled;
}

enum P2PInsuranceClaimStatus { pending, reviewing, approved, rejected, paid }

final class P2PInsuranceClaimDraft {
  const P2PInsuranceClaimDraft({
    required this.id,
    required this.claimCode,
    required this.orderId,
    required this.reason,
    required this.amount,
    required this.status,
    required this.submittedAt,
    this.paidAmount,
  });

  final String id;
  final String claimCode;
  final String orderId;
  final String reason;
  final int amount;
  final int? paidAmount;
  final P2PInsuranceClaimStatus status;
  final String submittedAt;
}

final class P2PInsuranceChartPointDraft {
  const P2PInsuranceChartPointDraft({
    required this.day,
    required this.balance,
    required this.inflow,
    required this.outflow,
  });

  final String day;
  final int balance;
  final int inflow;
  final int outflow;
}

final class P2PInsuranceCertificateSnapshot {
  const P2PInsuranceCertificateSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.certId,
    required this.holderName,
    required this.holderId,
    required this.tierName,
    required this.coveragePct,
    required this.maxCoveragePerClaim,
    required this.maxCoveragePer30Days,
    required this.contributionRate,
    required this.issueDate,
    required this.validUntil,
    required this.totalContributed,
    required this.totalTransactions,
    required this.claimWindowDays,
    required this.reviewSla,
    required this.payoutSla,
    required this.auditor,
    required this.lastAuditDate,
    required this.coveredCases,
    required this.exclusions,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String certId;
  final String holderName;
  final String holderId;
  final String tierName;
  final int coveragePct;
  final int maxCoveragePerClaim;
  final int maxCoveragePer30Days;
  final String contributionRate;
  final String issueDate;
  final String validUntil;
  final int totalContributed;
  final int totalTransactions;
  final int claimWindowDays;
  final String reviewSla;
  final String payoutSla;
  final String auditor;
  final String lastAuditDate;
  final List<String> coveredCases;
  final List<String> exclusions;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  String get shareText =>
      'Chứng nhận bảo hiểm: $certId - Tier $tierName ($coveragePct%)';

  String get exportText =>
      '''
CHỨNG NHẬN BẢO HIỂM GIAO DỊCH P2P
P2P Trading Insurance Certificate

Mã chứng nhận: $certId
Ngày cấp: $issueDate
Hiệu lực đến: $validUntil

Người được bảo hiểm: $holderName
Mã người dùng: $holderId
Tier: $tierName

Tỷ lệ bảo hiểm: $coveragePct% giá trị giao dịch
Hạn mức/claim: $maxCoveragePerClaim VND
Hạn mức/30 ngày: $maxCoveragePer30Days VND
Cửa sổ claim: $claimWindowDays ngày sau sự cố
Phí đóng góp: $contributionRate mỗi giao dịch

Xem xét claim: Trong $reviewSla
Chi trả: Trong $payoutSla sau khi duyệt
Kiểm toán: $auditor
Kiểm toán gần nhất: $lastAuditDate

Tổng đóng góp: $totalContributed VND
Tổng giao dịch: $totalTransactions

Phạm vi bảo vệ:
${coveredCases.map((item) => '- $item').join('\n')}

Không bao gồm:
${exclusions.map((item) => '- $item').join('\n')}
''';
}

final class P2PInsuranceScoreSnapshot {
  const P2PInsuranceScoreSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.overallScore,
    required this.maxScore,
    required this.grade,
    required this.gradeLabel,
    required this.gradeDescription,
    required this.currentTier,
    required this.factors,
    required this.quickActions,
    required this.tierRequirements,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int overallScore;
  final int maxScore;
  final String grade;
  final String gradeLabel;
  final String gradeDescription;
  final String currentTier;
  final List<P2PInsuranceScoreFactorDraft> factors;
  final List<P2PInsuranceScoreQuickActionDraft> quickActions;
  final List<P2PInsuranceScoreTierDraft> tierRequirements;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get potentialGain =>
      factors.fold(0, (sum, factor) => sum + (factor.maxScore - factor.score));
}

final class P2PInsuranceScoreFactorDraft {
  const P2PInsuranceScoreFactorDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.score,
    required this.maxScore,
    required this.statusLabel,
    required this.toneKey,
    required this.iconKey,
    this.recommendation,
  });

  final String id;
  final String label;
  final String description;
  final int score;
  final int maxScore;
  final String statusLabel;
  final String toneKey;
  final String iconKey;
  final String? recommendation;
}

final class P2PInsuranceScoreQuickActionDraft {
  const P2PInsuranceScoreQuickActionDraft({
    required this.label,
    required this.gain,
    required this.toneKey,
    this.route,
  });

  final String label;
  final String gain;
  final String toneKey;
  final String? route;
}

final class P2PInsuranceScoreTierDraft {
  const P2PInsuranceScoreTierDraft({
    required this.name,
    required this.requiredScore,
    required this.coveragePct,
    required this.requirements,
    required this.isCurrent,
    required this.isUnlocked,
  });

  final String name;
  final int requiredScore;
  final String coveragePct;
  final List<String> requirements;
  final bool isCurrent;
  final bool isUnlocked;
}

final class P2PInsurancePolicySnapshot {
  const P2PInsurancePolicySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.version,
    required this.lastUpdated,
    required this.notice,
    required this.sections,
    required this.privacyNotice,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String version;
  final String lastUpdated;
  final String notice;
  final List<P2PInsurancePolicySectionDraft> sections;
  final String privacyNotice;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PInsurancePolicySectionDraft {
  const P2PInsurancePolicySectionDraft({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final List<String> content;
}

final class P2PContributionHistorySnapshot {
  const P2PContributionHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.contributions,
    required this.contributionRateLabel,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PContributionDraft> contributions;
  final String contributionRateLabel;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get totalContributed => contributions.fold(
    0,
    (sum, contribution) => sum + contribution.contributionAmount,
  );

  int get totalTrades => contributions.length;

  int get averagePerTrade =>
      totalTrades == 0 ? 0 : (totalContributed / totalTrades).round();

  List<P2PContributionMonthDraft> get monthlyGroups {
    final grouped = <String, List<P2PContributionDraft>>{};
    for (final contribution in contributions) {
      grouped
          .putIfAbsent(contribution.monthKey, () => <P2PContributionDraft>[])
          .add(contribution);
    }

    final groups = grouped.entries.map((entry) {
      final total = entry.value.fold(
        0,
        (sum, contribution) => sum + contribution.contributionAmount,
      );
      return P2PContributionMonthDraft(
        month: entry.key,
        monthLabel: _monthLabel(entry.key),
        totalAmount: total,
        count: entry.value.length,
        contributions: entry.value,
      );
    }).toList()..sort((a, b) => b.month.compareTo(a.month));

    return groups;
  }
}

final class P2PContributionDraft {
  const P2PContributionDraft({
    required this.id,
    required this.date,
    required this.orderId,
    required this.orderAmount,
    required this.contributionAmount,
    required this.feeRate,
    required this.coin,
  });

  final String id;
  final String date;
  final String orderId;
  final int orderAmount;
  final int contributionAmount;
  final double feeRate;
  final String coin;

  String get monthKey => date.substring(0, 7);

  String get displayDate {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}

final class P2PContributionMonthDraft {
  const P2PContributionMonthDraft({
    required this.month,
    required this.monthLabel,
    required this.totalAmount,
    required this.count,
    required this.contributions,
  });

  final String month;
  final String monthLabel;
  final int totalAmount;
  final int count;
  final List<P2PContributionDraft> contributions;
}

final class P2PEscrowBalanceSnapshot {
  const P2PEscrowBalanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.selectedAsset,
    required this.assets,
    required this.ordersByAsset,
    required this.title,
    required this.subtitle,
    required this.infoTitle,
    required this.infoBody,
    required this.helpTitle,
    required this.helpBullets,
    required this.parentRoute,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String selectedAsset;
  final List<P2PEscrowAssetBalanceDraft> assets;
  final Map<String, List<P2PEscrowOrderDraft>> ordersByAsset;
  final String title;
  final String subtitle;
  final String infoTitle;
  final String infoBody;
  final String helpTitle;
  final List<String> helpBullets;
  final String parentRoute;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  List<P2PEscrowOrderDraft> ordersFor(String asset) =>
      ordersByAsset[asset] ?? const <P2PEscrowOrderDraft>[];

  P2PEscrowAssetBalanceDraft assetBalance(String asset) {
    return assets.firstWhere(
      (item) => item.asset == asset,
      orElse: () => assets.first,
    );
  }
}

final class P2PEscrowAssetBalanceDraft {
  const P2PEscrowAssetBalanceDraft({
    required this.asset,
    required this.totalAmount,
    required this.orderCount,
  });

  final String asset;
  final double totalAmount;
  final int orderCount;
}

final class P2PEscrowOrderDraft {
  const P2PEscrowOrderDraft({
    required this.id,
    required this.orderId,
    required this.type,
    required this.asset,
    required this.amount,
    required this.fiatAmount,
    required this.fiatCurrency,
    required this.counterparty,
    required this.status,
    required this.lockedAt,
    required this.estimatedRelease,
    this.warning,
  });

  final String id;
  final String orderId;
  final P2PEscrowOrderType type;
  final String asset;
  final double amount;
  final int fiatAmount;
  final String fiatCurrency;
  final String counterparty;
  final P2PEscrowOrderStatus status;
  final String lockedAt;
  final String estimatedRelease;
  final String? warning;

  String get canonicalOrderId => orderId.replaceFirst('#P2P-', '');

  String get typeLabel => switch (type) {
    P2PEscrowOrderType.buy => 'MUA',
    P2PEscrowOrderType.sell => 'BÁN',
  };

  String get statusLabel => switch (status) {
    P2PEscrowOrderStatus.pendingPayment => 'Chờ thanh toán',
    P2PEscrowOrderStatus.paid => 'Đã thanh toán',
    P2PEscrowOrderStatus.pendingRelease => 'Chờ release',
    P2PEscrowOrderStatus.dispute => 'Tranh chấp',
  };
}

final class P2PEscrowDetailSnapshot {
  const P2PEscrowDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.order,
    required this.statusLabel,
    required this.statusToneKey,
    required this.escrowAddress,
    required this.explorerRoute,
    required this.signers,
    required this.timeline,
    required this.securityTitle,
    required this.securityBody,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final P2POrderDetailDraft order;
  final String statusLabel;
  final String statusToneKey;
  final String escrowAddress;
  final String explorerRoute;
  final List<P2PEscrowSignerDraft> signers;
  final List<P2PEscrowTimelineEventDraft> timeline;
  final String securityTitle;
  final String securityBody;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get signedCount => signers.where((signer) => signer.hasSigned).length;

  int get signerCount => signers.length;

  String get maskedAddress => _maskAddress(escrowAddress);
}

final class P2PEscrowSignerDraft {
  const P2PEscrowSignerDraft({
    required this.id,
    required this.role,
    required this.label,
    required this.address,
    required this.hasSigned,
    this.signedAt,
  });

  final String id;
  final String role;
  final String label;
  final String address;
  final bool hasSigned;
  final String? signedAt;

  String get maskedAddress => _maskAddress(address);
}

final class P2PEscrowTimelineEventDraft {
  const P2PEscrowTimelineEventDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.status,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final P2POrderStepStatus status;
  final String iconKey;
}

final class P2PKycRequirementsSnapshot {
  const P2PKycRequirementsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.currentTier,
    required this.pendingTier,
    required this.tiers,
    required this.heroTitle,
    required this.heroBody,
    required this.noticeTitle,
    required this.noticeBody,
    required this.supportTitle,
    required this.supportBody,
    required this.verifyRouteBase,
    required this.supportRoute,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int currentTier;
  final int? pendingTier;
  final List<P2PKycTierDraft> tiers;
  final String heroTitle;
  final String heroBody;
  final String noticeTitle;
  final String noticeBody;
  final String supportTitle;
  final String supportBody;
  final String verifyRouteBase;
  final String supportRoute;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  String verifyRouteFor(int tierId) => '$verifyRouteBase?tier=$tierId';
}

final class P2PKycTierDraft {
  const P2PKycTierDraft({
    required this.id,
    required this.name,
    required this.badge,
    required this.toneKey,
    required this.iconKey,
    required this.requirements,
    required this.limits,
    required this.benefits,
    required this.verificationTime,
    required this.status,
  });

  final int id;
  final String name;
  final String badge;
  final String toneKey;
  final String iconKey;
  final List<P2PKycRequirementDraft> requirements;
  final P2PKycLimitsDraft limits;
  final List<String> benefits;
  final String verificationTime;
  final P2PKycTierStatus status;
}

final class P2PKycRequirementDraft {
  const P2PKycRequirementDraft({required this.label, required this.iconKey});

  final String label;
  final String iconKey;
}

final class P2PKycLimitsDraft {
  const P2PKycLimitsDraft({
    required this.dailyBuy,
    required this.dailySell,
    required this.monthlyVolume,
  });

  final int dailyBuy;
  final int dailySell;
  final int monthlyVolume;
}

final class P2PKycStatusSnapshot {
  const P2PKycStatusSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.tier,
    required this.tierName,
    required this.overallStatus,
    required this.submittedAt,
    required this.steps,
    required this.infoBody,
    required this.supportTitle,
    required this.supportBody,
    required this.parentRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int tier;
  final String tierName;
  final P2PKycVerificationStatus overallStatus;
  final String submittedAt;
  final List<P2PKycStatusStepDraft> steps;
  final String infoBody;
  final String supportTitle;
  final String supportBody;
  final String parentRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;

  int get completedSteps =>
      steps.where((step) => step.status == P2PKycStepStatus.completed).length;

  int get totalSteps => steps.length;

  double get progress => totalSteps == 0 ? 0 : completedSteps / totalSteps;

  String get progressLabel => '$completedSteps/$totalSteps bước';

  String get statusLabel => switch (overallStatus) {
    P2PKycVerificationStatus.approved => 'Đã duyệt',
    P2PKycVerificationStatus.pending => 'Đang xử lý',
    P2PKycVerificationStatus.rejected => 'Từ chối',
    P2PKycVerificationStatus.incomplete => 'Chưa hoàn tất',
  };
}

final class P2PKycStatusStepDraft {
  const P2PKycStatusStepDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.status,
    this.completedAt,
    this.rejectedReason,
    this.rejectedDetails,
    this.estimatedTime,
    this.actionLabel,
    this.actionRoute,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final P2PKycStepStatus status;
  final String? completedAt;
  final String? rejectedReason;
  final String? rejectedDetails;
  final String? estimatedTime;
  final String? actionLabel;
  final String? actionRoute;

  bool get hasAction => actionLabel != null && actionRoute != null;

  String get statusLabel => switch (status) {
    P2PKycStepStatus.completed => 'Hoàn thành',
    P2PKycStepStatus.processing => 'Đang xử lý',
    P2PKycStepStatus.pending => 'Chờ xử lý',
    P2PKycStepStatus.waiting => 'Chưa bắt đầu',
    P2PKycStepStatus.rejected => 'Từ chối',
  };
}

final class P2PIdentityVerificationSnapshot {
  const P2PIdentityVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.documentTypes,
    required this.guidelines,
    required this.securityNotes,
    required this.parentRoute,
    required this.nextRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<P2PIdentityDocumentTypeDraft> documentTypes;
  final List<String> guidelines;
  final List<String> securityNotes;
  final String parentRoute;
  final String nextRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PIdentityDocumentTypeDraft {
  const P2PIdentityDocumentTypeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
}

final class P2PAddressProofSnapshot {
  const P2PAddressProofSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.documentTypes,
    required this.requirements,
    required this.securityNotes,
    required this.extractedName,
    required this.extractedAddress,
    required this.extractedDate,
    required this.parentRoute,
    required this.submitRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<P2PAddressDocumentTypeDraft> documentTypes;
  final List<String> requirements;
  final List<String> securityNotes;
  final String extractedName;
  final String extractedAddress;
  final String extractedDate;
  final String parentRoute;
  final String submitRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAddressDocumentTypeDraft {
  const P2PAddressDocumentTypeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.examples,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final List<String> examples;
}

final class P2PSelfieVerificationSnapshot {
  const P2PSelfieVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.sampleTitle,
    required this.sampleBody,
    required this.guidelines,
    required this.tips,
    required this.livenessActions,
    required this.matchScore,
    required this.livenessScore,
    required this.parentRoute,
    required this.statusRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final String sampleTitle;
  final String sampleBody;
  final List<String> guidelines;
  final List<String> tips;
  final List<P2PSelfieLivenessActionDraft> livenessActions;
  final String matchScore;
  final String livenessScore;
  final String parentRoute;
  final String statusRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PSelfieLivenessActionDraft {
  const P2PSelfieLivenessActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String iconKey;
}

final class P2PVideoVerificationSnapshot {
  const P2PVideoVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.preparationItems,
    required this.timeSlots,
    required this.parentRoute,
    required this.statusRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<String> preparationItems;
  final List<P2PVideoTimeSlotDraft> timeSlots;
  final String parentRoute;
  final String statusRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PVideoTimeSlotDraft {
  const P2PVideoTimeSlotDraft({
    required this.id,
    required this.date,
    required this.time,
    required this.available,
  });

  final String id;
  final String date;
  final String time;
  final bool available;
}

final class P2PSecurityCenterSnapshot {
  const P2PSecurityCenterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.score,
    required this.maxScore,
    required this.scoreLabel,
    required this.scoreSubtitle,
    required this.scoreBody,
    required this.features,
    required this.quickActions,
    required this.recentEvents,
    required this.parentRoute,
    required this.settingsRoute,
    required this.loginHistoryRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int score;
  final int maxScore;
  final String scoreLabel;
  final String scoreSubtitle;
  final String scoreBody;
  final List<P2PSecurityFeatureDraft> features;
  final List<P2PSecurityQuickActionDraft> quickActions;
  final List<P2PSecurityEventDraft> recentEvents;
  final String parentRoute;
  final String settingsRoute;
  final String loginHistoryRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PSecurityFeatureDraft {
  const P2PSecurityFeatureDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.status,
    required this.scoreDelta,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final P2PSecurityStatus status;
  final int scoreDelta;
  final String route;
}

final class P2PSecurityQuickActionDraft {
  const P2PSecurityQuickActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.colorKey,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final String colorKey;
  final String route;
}

final class P2PSecurityEventDraft {
  const P2PSecurityEventDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.iconKey,
    required this.severity,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final String iconKey;
  final P2PSecurityEventSeverity severity;
}

final class P2PTwoFactorSettingsSnapshot {
  const P2PTwoFactorSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methods,
    required this.thresholds,
    required this.recommendation,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PTwoFactorMethodDraft> methods;
  final List<P2PTransactionThresholdDraft> thresholds;
  final String recommendation;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PTwoFactorMethodDraft {
  const P2PTwoFactorMethodDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.colorKey,
    required this.enabled,
    required this.isPrimary,
    required this.setupRequired,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final String colorKey;
  final bool enabled;
  final bool isPrimary;
  final bool setupRequired;

  P2PTwoFactorMethodDraft copyWith({
    bool? enabled,
    bool? isPrimary,
    bool? setupRequired,
  }) {
    return P2PTwoFactorMethodDraft(
      id: id,
      label: label,
      description: description,
      iconKey: iconKey,
      colorKey: colorKey,
      enabled: enabled ?? this.enabled,
      isPrimary: isPrimary ?? this.isPrimary,
      setupRequired: setupRequired ?? this.setupRequired,
    );
  }
}

final class P2PTransactionThresholdDraft {
  const P2PTransactionThresholdDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.valueLabel,
    required this.enabled,
    required this.editable,
  });

  final String id;
  final String label;
  final String description;
  final String valueLabel;
  final bool enabled;
  final bool editable;

  P2PTransactionThresholdDraft copyWith({bool? enabled}) {
    return P2PTransactionThresholdDraft(
      id: id,
      label: label,
      description: description,
      valueLabel: valueLabel,
      enabled: enabled ?? this.enabled,
      editable: editable,
    );
  }
}

final class P2PDeviceManagementSnapshot {
  const P2PDeviceManagementSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.devices,
    required this.infoTitle,
    required this.infoBody,
    required this.securityTips,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PTrustedDeviceDraft> devices;
  final String infoTitle;
  final String infoBody;
  final List<String> securityTips;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  List<P2PTrustedDeviceDraft> get trustedDevices =>
      devices.where((device) => device.isTrusted).toList(growable: false);

  List<P2PTrustedDeviceDraft> get untrustedDevices =>
      devices.where((device) => !device.isTrusted).toList(growable: false);
}

final class P2PTrustedDeviceDraft {
  const P2PTrustedDeviceDraft({
    required this.id,
    required this.name,
    required this.type,
    required this.os,
    required this.browser,
    required this.location,
    required this.ip,
    required this.lastActive,
    required this.firstSeen,
    required this.isCurrent,
    required this.isTrusted,
    required this.fingerprint,
  });

  final String id;
  final String name;
  final String type;
  final String os;
  final String browser;
  final String location;
  final String ip;
  final String lastActive;
  final String firstSeen;
  final bool isCurrent;
  final bool isTrusted;
  final String fingerprint;

  P2PTrustedDeviceDraft copyWith({bool? isTrusted}) {
    return P2PTrustedDeviceDraft(
      id: id,
      name: name,
      type: type,
      os: os,
      browser: browser,
      location: location,
      ip: ip,
      lastActive: lastActive,
      firstSeen: firstSeen,
      isCurrent: isCurrent,
      isTrusted: isTrusted ?? this.isTrusted,
      fingerprint: fingerprint,
    );
  }
}

final class P2PAntiPhishingCodeSnapshot {
  const P2PAntiPhishingCodeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.hasCode,
    required this.currentCode,
    required this.statusTitle,
    required this.statusBody,
    required this.explainerTitle,
    required this.explainerBody,
    required this.benefits,
    required this.examples,
    required this.warningTitle,
    required this.warnings,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final bool hasCode;
  final String currentCode;
  final String statusTitle;
  final String statusBody;
  final String explainerTitle;
  final String explainerBody;
  final List<String> benefits;
  final List<P2PAntiPhishingExampleDraft> examples;
  final String warningTitle;
  final List<String> warnings;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAntiPhishingExampleDraft {
  const P2PAntiPhishingExampleDraft({
    required this.id,
    required this.subject,
    required this.preview,
    required this.isLegit,
  });

  final String id;
  final String subject;
  final String preview;
  final bool isLegit;
}

final class P2PLoginHistorySnapshot {
  const P2PLoginHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.events,
    required this.warningBody,
    required this.infoTitle,
    required this.securityTips,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PLoginEventDraft> events;
  final String warningBody;
  final String infoTitle;
  final List<String> securityTips;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get successCount =>
      events.where((event) => event.status == 'success').length;

  int get riskEventCount => events.where((event) => event.isRiskEvent).length;
}

final class P2PLoginEventDraft {
  const P2PLoginEventDraft({
    required this.id,
    required this.timestamp,
    required this.deviceType,
    required this.deviceName,
    required this.os,
    required this.browser,
    required this.city,
    required this.country,
    required this.ip,
    required this.status,
    required this.statusLabel,
    required this.method,
    required this.methodLabel,
    required this.isCurrent,
  });

  final String id;
  final String timestamp;
  final String deviceType;
  final String deviceName;
  final String os;
  final String browser;
  final String city;
  final String country;
  final String ip;
  final String status;
  final String statusLabel;
  final String method;
  final String methodLabel;
  final bool isCurrent;

  bool get isRiskEvent => status == 'suspicious' || status == 'failed';
}

final class P2PSuspiciousActivitySnapshot {
  const P2PSuspiciousActivitySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.alerts,
    required this.summarySubtitle,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PSuspiciousAlertDraft> alerts;
  final String summarySubtitle;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get unreviewedCount => alerts.where((alert) => !alert.reviewed).length;
}

final class P2PSuspiciousAlertDraft {
  const P2PSuspiciousAlertDraft({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.severity,
    required this.reviewed,
  });

  final String id;
  final String type;
  final String message;
  final String timestamp;
  final String severity;
  final bool reviewed;

  P2PSuspiciousAlertDraft copyWith({bool? reviewed}) {
    return P2PSuspiciousAlertDraft(
      id: id,
      type: type,
      message: message,
      timestamp: timestamp,
      severity: severity,
      reviewed: reviewed ?? this.reviewed,
    );
  }
}

final class P2PE2EInfoSnapshot {
  const P2PE2EInfoSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.localLabel,
    required this.partnerLabel,
    required this.diagramCaption,
    required this.infoItems,
    required this.fingerprint,
    required this.fingerprintHint,
    required this.steps,
    required this.serverNote,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroSubtitle;
  final String localLabel;
  final String partnerLabel;
  final String diagramCaption;
  final List<P2PE2EInfoItemDraft> infoItems;
  final String fingerprint;
  final String fingerprintHint;
  final List<P2PE2EStepDraft> steps;
  final String serverNote;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PE2EInfoItemDraft {
  const P2PE2EInfoItemDraft({
    required this.id,
    required this.iconKey,
    required this.title,
    required this.description,
    required this.toneKey,
  });

  final String id;
  final String iconKey;
  final String title;
  final String description;
  final String toneKey;
}

final class P2PE2EStepDraft {
  const P2PE2EStepDraft({
    required this.id,
    required this.step,
    required this.title,
    required this.description,
  });

  final String id;
  final String step;
  final String title;
  final String description;
}

final class P2PFraudPreventionSnapshot {
  const P2PFraudPreventionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.patterns,
    required this.checklist,
    required this.emergencyActions,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PScamPatternDraft> patterns;
  final List<P2PSafetyChecklistItemDraft> checklist;
  final List<P2PFraudEmergencyActionDraft> emergencyActions;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get checkedSafetyCount => checklist.where((item) => item.checked).length;

  int get safetyScore => (checkedSafetyCount / checklist.length * 100).round();
}

final class P2PScamPatternDraft {
  const P2PScamPatternDraft({
    required this.id,
    required this.title,
    required this.severity,
    required this.description,
    required this.howItWorks,
    required this.redFlags,
    required this.prevention,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String severity;
  final String description;
  final List<String> howItWorks;
  final List<String> redFlags;
  final List<String> prevention;
  final String iconKey;
}

final class P2PSafetyChecklistItemDraft {
  const P2PSafetyChecklistItemDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.checked,
    required this.category,
  });

  final String id;
  final String label;
  final String description;
  final bool checked;
  final String category;

  P2PSafetyChecklistItemDraft copyWith({bool? checked}) {
    return P2PSafetyChecklistItemDraft(
      id: id,
      label: label,
      description: description,
      checked: checked ?? this.checked,
      category: category,
    );
  }
}

final class P2PFraudEmergencyActionDraft {
  const P2PFraudEmergencyActionDraft({
    required this.id,
    required this.label,
    required this.route,
    required this.toneKey,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final String toneKey;
  final String iconKey;
}

final class P2PWalletTransferSnapshot {
  const P2PWalletTransferSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.defaultAsset,
    required this.defaultType,
    required this.assets,
    required this.balances,
    required this.feeLabel,
    required this.processingLabel,
    required this.escrowNote,
    required this.confirmationNote,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String defaultAsset;
  final String defaultType;
  final List<P2PWalletTransferAssetDraft> assets;
  final List<P2PWalletTransferBalanceDraft> balances;
  final String feeLabel;
  final String processingLabel;
  final String escrowNote;
  final String confirmationNote;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2PWalletTransferBalanceDraft sourceBalance(String type, String asset) {
    return balanceFor(type == 'withdraw' ? 'p2p' : 'main', asset);
  }

  P2PWalletTransferBalanceDraft destinationBalance(String type, String asset) {
    return balanceFor(type == 'withdraw' ? 'main' : 'p2p', asset);
  }

  P2PWalletTransferBalanceDraft balanceFor(String walletKey, String asset) {
    return balances.firstWhere(
      (item) => item.walletKey == walletKey && item.asset == asset,
      orElse: () => balances.first,
    );
  }
}

final class P2PWalletTransferAssetDraft {
  const P2PWalletTransferAssetDraft({required this.symbol, required this.name});

  final String symbol;
  final String name;
}

final class P2PWalletTransferBalanceDraft {
  const P2PWalletTransferBalanceDraft({
    required this.walletKey,
    required this.walletLabel,
    required this.asset,
    required this.available,
    required this.balanceLabel,
  });

  final String walletKey;
  final String walletLabel;
  final String asset;
  final double available;
  final String balanceLabel;
}

final class P2PFundLockHistorySnapshot {
  const P2PFundLockHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.records,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final List<P2PFundLockRecordDraft> records;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get lockCount => records.where((item) => item.type == 'lock').length;
}

final class P2PFundLockRecordDraft {
  const P2PFundLockRecordDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });

  final String id;
  final String type;
  final String asset;
  final double amount;
  final String reason;
  final String timestamp;
}

final class P2PWalletSnapshot {
  const P2PWalletSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.totalUsdValue,
    required this.privacyMask,
    required this.balances,
    required this.transactions,
    required this.infoNote,
    required this.parentRoute,
    required this.transferRoute,
    required this.historyRoute,
    required this.escrowBalanceRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final double totalUsdValue;
  final String privacyMask;
  final List<P2PWalletBalanceDraft> balances;
  final List<P2PWalletTransactionDraft> transactions;
  final String infoNote;
  final String parentRoute;
  final String transferRoute;
  final String historyRoute;
  final String escrowBalanceRoute;
  final String emptyTitle;
  final String contractNotes;

  P2PWalletBalanceDraft balanceFor(String asset) {
    return balances.firstWhere(
      (item) => item.asset == asset,
      orElse: () => balances.first,
    );
  }
}

final class P2PWalletBalanceDraft {
  const P2PWalletBalanceDraft({
    required this.asset,
    required this.available,
    required this.inEscrow,
    required this.locked,
    required this.total,
    required this.usdValue,
  });

  final String asset;
  final double available;
  final double inEscrow;
  final double locked;
  final double total;
  final double usdValue;
}

final class P2PWalletTransactionDraft {
  const P2PWalletTransactionDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.amount,
    required this.status,
    required this.time,
    this.orderId,
  });

  final String id;
  final String type;
  final String asset;
  final double amount;
  final String status;
  final String time;
  final String? orderId;
}

final class P2PLimitTrackerSnapshot {
  const P2PLimitTrackerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.usages,
    required this.breakdown,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<P2PLimitUsageDraft> usages;
  final List<P2PLimitBreakdownDraft> breakdown;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2PLimitUsageDraft usageFor(String period) {
    return usages.firstWhere(
      (item) => item.period == period,
      orElse: () => usages.first,
    );
  }
}

final class P2PLimitUsageDraft {
  const P2PLimitUsageDraft({
    required this.period,
    required this.label,
    required this.used,
    required this.limit,
    required this.percentage,
  });

  final String period;
  final String label;
  final double used;
  final double limit;
  final int percentage;
}

final class P2PLimitBreakdownDraft {
  const P2PLimitBreakdownDraft({
    required this.date,
    required this.buy,
    required this.sell,
  });

  final String date;
  final double buy;
  final double sell;

  double get total => buy + sell;
}

final class P2PTransactionLimitsSnapshot {
  const P2PTransactionLimitsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.currentTier,
    required this.nextTier,
    required this.usageItems,
    required this.detailItems,
    required this.infoBullets,
    required this.parentRoute,
    required this.trackerRoute,
    required this.kycRequirementsRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2PTransactionLimitTierDraft currentTier;
  final P2PTransactionLimitTierDraft nextTier;
  final List<P2PTransactionLimitUsageDraft> usageItems;
  final List<P2PTransactionLimitDetailDraft> detailItems;
  final List<String> infoBullets;
  final String parentRoute;
  final String trackerRoute;
  final String kycRequirementsRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PComplianceOverviewSnapshot {
  const P2PComplianceOverviewSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.items,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final List<P2PComplianceItemDraft> items;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PComplianceItemDraft {
  const P2PComplianceItemDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.status,
    required this.iconKey,
    required this.route,
  });

  final String id;
  final String label;
  final String value;
  final String status;
  final String iconKey;
  final String route;
}

final class P2PAmlScreeningSnapshot {
  const P2PAmlScreeningSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.statusDescription,
    required this.lastCheckLabel,
    required this.lastCheckAt,
    required this.nextCheckLabel,
    required this.nextCheckAt,
    required this.checks,
    required this.infoTitle,
    required this.infoBody,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String statusDescription;
  final String lastCheckLabel;
  final String lastCheckAt;
  final String nextCheckLabel;
  final String nextCheckAt;
  final List<P2PAmlCheckDraft> checks;
  final String infoTitle;
  final String infoBody;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAmlCheckDraft {
  const P2PAmlCheckDraft({
    required this.id,
    required this.name,
    required this.status,
    required this.detail,
  });

  final String id;
  final String name;
  final String status;
  final String detail;
}

final class P2PSourceOfFundsSnapshot {
  const P2PSourceOfFundsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.sourceTitle,
    required this.inputLabel,
    required this.inputPlaceholder,
    required this.ctaLabel,
    required this.sources,
    required this.parentRoute,
    required this.successRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final String sourceTitle;
  final String inputLabel;
  final String inputPlaceholder;
  final String ctaLabel;
  final List<P2PFundSourceDraft> sources;
  final String parentRoute;
  final String successRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PFundSourceDraft {
  const P2PFundSourceDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String iconKey;
}

final class P2PLargeTransactionJustificationSnapshot {
  const P2PLargeTransactionJustificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.purposeTitle,
    required this.customPurposeLabel,
    required this.customPurposePlaceholder,
    required this.detailsLabel,
    required this.detailsPlaceholder,
    required this.ctaLabel,
    required this.purposes,
    required this.parentRoute,
    required this.successRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final double amount;
  final String heroTitle;
  final String heroSubtitle;
  final String purposeTitle;
  final String customPurposeLabel;
  final String customPurposePlaceholder;
  final String detailsLabel;
  final String detailsPlaceholder;
  final String ctaLabel;
  final List<String> purposes;
  final String parentRoute;
  final String successRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PRiskAssessmentSnapshot {
  const P2PRiskAssessmentSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.overallRisk,
    required this.score,
    required this.scoreLabel,
    required this.scoreSubtitle,
    required this.infoText,
    required this.factorTitle,
    required this.factors,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String overallRisk;
  final int score;
  final String scoreLabel;
  final String scoreSubtitle;
  final String infoText;
  final String factorTitle;
  final List<P2PRiskFactorDraft> factors;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PRiskFactorDraft {
  const P2PRiskFactorDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.risk,
    required this.score,
  });

  final String id;
  final String label;
  final String value;
  final String risk;
  final int score;
}

final class P2PTaxReportingSnapshot {
  const P2PTaxReportingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.selectedYear,
    required this.selectedJurisdiction,
    required this.years,
    required this.jurisdictions,
    required this.summary,
    required this.documents,
    required this.disclaimer,
    required this.parentRoute,
    required this.detailRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final int selectedYear;
  final P2PTaxJurisdictionDraft selectedJurisdiction;
  final List<int> years;
  final List<P2PTaxJurisdictionDraft> jurisdictions;
  final P2PTaxSummaryDraft summary;
  final List<P2PTaxDocumentDraft> documents;
  final String disclaimer;
  final String parentRoute;
  final String detailRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PTaxJurisdictionDraft {
  const P2PTaxJurisdictionDraft({
    required this.code,
    required this.name,
    required this.form,
  });

  final String code;
  final String name;
  final String form;
}

final class P2PTaxSummaryDraft {
  const P2PTaxSummaryDraft({
    required this.totalTransactions,
    required this.totalVolumeLabel,
    required this.capitalGainsLabel,
    required this.capitalLossesLabel,
    required this.netGainsLabel,
    required this.generatedAt,
  });

  final int totalTransactions;
  final String totalVolumeLabel;
  final String capitalGainsLabel;
  final String capitalLossesLabel;
  final String netGainsLabel;
  final String generatedAt;
}

final class P2PTaxDocumentDraft {
  const P2PTaxDocumentDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.format,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String format;
  final String toneKey;
}

final class P2POrderBookSnapshot {
  const P2POrderBookSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.selectedAsset,
    required this.markets,
    required this.bids,
    required this.asks,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2POrderBookMarketDraft selectedAsset;
  final List<P2POrderBookMarketDraft> markets;
  final List<P2POrderBookEntryDraft> bids;
  final List<P2POrderBookEntryDraft> asks;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2POrderBookEntryDraft get bestBid => bids.first;
  P2POrderBookEntryDraft get bestAsk => asks.first;

  double get spreadPercent {
    final spread = bestAsk.priceVnd - bestBid.priceVnd;
    return spread / bestBid.priceVnd * 100;
  }

  double get maxTotal {
    final bidMax = bids
        .map((item) => item.total)
        .reduce((a, b) => a > b ? a : b);
    final askMax = asks
        .map((item) => item.total)
        .reduce((a, b) => a > b ? a : b);
    return bidMax > askMax ? bidMax : askMax;
  }
}

final class P2POrderBookMarketDraft {
  const P2POrderBookMarketDraft({
    required this.asset,
    required this.lastPriceVnd,
    required this.changePct,
    required this.high24hVnd,
    required this.low24hVnd,
    required this.volume24hLabel,
    required this.trades24h,
  });

  final String asset;
  final double lastPriceVnd;
  final double changePct;
  final double high24hVnd;
  final double low24hVnd;
  final String volume24hLabel;
  final int trades24h;
}

final class P2POrderBookEntryDraft {
  const P2POrderBookEntryDraft({
    required this.priceVnd,
    required this.volume,
    required this.total,
    required this.orders,
  });

  final double priceVnd;
  final double volume;
  final double total;
  final int orders;
}

final class P2PDashboardSnapshot {
  const P2PDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.filters,
    required this.selectedFilter,
    required this.stats,
    required this.weeklyVolume,
    required this.monthlyOrders,
    required this.assetDistribution,
    required this.currentLevel,
    required this.nextLevel,
    required this.platformComparisons,
    required this.topMerchants,
    required this.recentActivity,
    required this.quickActions,
    required this.parentRoute,
    required this.myOrdersRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<P2PDashboardFilterDraft> filters;
  final P2PDashboardFilterDraft selectedFilter;
  final P2PDashboardStatsDraft stats;
  final List<P2PDashboardSeriesPointDraft> weeklyVolume;
  final List<P2PDashboardMonthlyOrdersDraft> monthlyOrders;
  final List<P2PDashboardAssetDraft> assetDistribution;
  final P2PDashboardLevelDraft currentLevel;
  final P2PDashboardLevelDraft nextLevel;
  final List<P2PDashboardComparisonDraft> platformComparisons;
  final List<P2PDashboardMerchantDraft> topMerchants;
  final List<P2PDashboardActivityDraft> recentActivity;
  final List<P2PDashboardQuickActionDraft> quickActions;
  final String parentRoute;
  final String myOrdersRoute;
  final String emptyTitle;
  final String contractNotes;

  double get selectedVolume {
    return switch (selectedFilter.id) {
      '7d' => stats.totalVolume7d,
      'all' => stats.totalVolumeAll,
      _ => stats.totalVolume30d,
    };
  }
}

final class P2PDashboardFilterDraft {
  const P2PDashboardFilterDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class P2PDashboardStatsDraft {
  const P2PDashboardStatsDraft({
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.disputedOrders,
    required this.completionRate,
    required this.avgCompletionTime,
    required this.totalVolume7d,
    required this.totalVolume30d,
    required this.totalVolumeAll,
    required this.buyVolume30d,
    required this.sellVolume30d,
    required this.spreadRevenue30d,
    required this.avgOrderSize,
    required this.uniqueCounterparties,
    required this.repeatCustomerRate,
    required this.avgRatingReceived,
    required this.positiveReviewRate,
    required this.responseTimeAvg,
    required this.platformAvgCompletionRate,
    required this.platformAvgResponseTime,
  });

  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int disputedOrders;
  final double completionRate;
  final String avgCompletionTime;
  final double totalVolume7d;
  final double totalVolume30d;
  final double totalVolumeAll;
  final double buyVolume30d;
  final double sellVolume30d;
  final double spreadRevenue30d;
  final double avgOrderSize;
  final int uniqueCounterparties;
  final double repeatCustomerRate;
  final double avgRatingReceived;
  final double positiveReviewRate;
  final String responseTimeAvg;
  final double platformAvgCompletionRate;
  final String platformAvgResponseTime;
}

final class P2PDashboardSeriesPointDraft {
  const P2PDashboardSeriesPointDraft({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}

final class P2PDashboardMonthlyOrdersDraft {
  const P2PDashboardMonthlyOrdersDraft({
    required this.month,
    required this.buy,
    required this.sell,
  });

  final String month;
  final int buy;
  final int sell;
}

final class P2PDashboardAssetDraft {
  const P2PDashboardAssetDraft({
    required this.asset,
    required this.percentage,
    required this.volume,
  });

  final String asset;
  final double percentage;
  final double volume;
}

final class P2PDashboardLevelDraft {
  const P2PDashboardLevelDraft({
    required this.id,
    required this.name,
    required this.dailyUsed,
    required this.dailyLimit,
    required this.progress,
    required this.requirements,
  });

  final int id;
  final String name;
  final double dailyUsed;
  final double dailyLimit;
  final double progress;
  final List<String> requirements;
}

final class P2PDashboardComparisonDraft {
  const P2PDashboardComparisonDraft({
    required this.label,
    required this.yours,
    required this.platform,
    required this.suffix,
    this.lowerBetter = false,
  });

  final String label;
  final double yours;
  final double platform;
  final String suffix;
  final bool lowerBetter;
}

final class P2PDashboardMerchantDraft {
  const P2PDashboardMerchantDraft({
    required this.id,
    required this.name,
    required this.trades,
    required this.volume,
    required this.rating,
  });

  final String id;
  final String name;
  final int trades;
  final double volume;
  final double rating;
}

final class P2PDashboardActivityDraft {
  const P2PDashboardActivityDraft({
    required this.date,
    required this.type,
    required this.asset,
    required this.amount,
    required this.total,
    required this.merchant,
    required this.status,
  });

  final String date;
  final String type;
  final String asset;
  final double amount;
  final double total;
  final String merchant;
  final String status;
}

final class P2PDashboardQuickActionDraft {
  const P2PDashboardQuickActionDraft({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
}

final class P2PAchievementsSnapshot {
  const P2PAchievementsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.currentLevel,
    required this.achievements,
    required this.categories,
    required this.parentRoute,
    required this.tradingLevelRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final int currentLevel;
  final List<P2PAchievementDraft> achievements;
  final List<P2PAchievementCategoryDraft> categories;
  final String parentRoute;
  final String tradingLevelRoute;
  final String emptyTitle;
  final String contractNotes;

  int get unlockedCount {
    return achievements.where((item) => item.unlocked).length;
  }

  int get totalReputationPoints {
    return achievements
        .where((item) => item.unlocked && item.reputationPointsReward != null)
        .fold<int>(0, (sum, item) => sum + item.reputationPointsReward!);
  }

  int get unlockedBadgeCount {
    return achievements
        .where((item) => item.unlocked && item.rewardType == 'badge')
        .length;
  }

  double get overallProgress {
    if (achievements.isEmpty) return 0;
    return unlockedCount / achievements.length;
  }

  List<P2PAchievementDraft> achievementsFor(String categoryId) {
    return achievements.where((item) => item.categoryId == categoryId).toList();
  }
}

final class P2PAchievementCategoryDraft {
  const P2PAchievementCategoryDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class P2PAchievementDraft {
  const P2PAchievementDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.toneKey,
    required this.progress,
    required this.currentValueLabel,
    required this.progressLabel,
    required this.unlocked,
    required this.reward,
    required this.rewardType,
    required this.categoryId,
    this.unlockedAt,
    this.reputationPointsReward,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String toneKey;
  final double progress;
  final String currentValueLabel;
  final String progressLabel;
  final bool unlocked;
  final String? unlockedAt;
  final String reward;
  final String rewardType;
  final int? reputationPointsReward;
  final String categoryId;
}

final class P2PBlacklistAddSnapshot {
  const P2PBlacklistAddSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.usernameLabel,
    required this.usernameHint,
    required this.noteLabel,
    required this.noteHint,
    required this.warning,
    required this.submitLabel,
    required this.reasons,
    required this.parentRoute,
    required this.blacklistRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final String usernameLabel;
  final String usernameHint;
  final String noteLabel;
  final String noteHint;
  final String warning;
  final String submitLabel;
  final List<P2PBlacklistReasonDraft> reasons;
  final String parentRoute;
  final String blacklistRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PBlacklistReasonDraft {
  const P2PBlacklistReasonDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final String label;
  final String iconKey;
  final String toneKey;
}

final class P2PBlacklistSnapshot {
  const P2PBlacklistSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.searchHint,
    required this.infoTitle,
    required this.infoText,
    required this.addRoute,
    required this.parentRoute,
    required this.reasons,
    required this.entries,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String searchHint;
  final String infoTitle;
  final String infoText;
  final String addRoute;
  final String parentRoute;
  final List<P2PBlacklistReasonDraft> reasons;
  final List<P2PBlacklistEntryDraft> entries;
  final String emptyTitle;
  final String contractNotes;

  int get recent30dCount {
    return entries.where((item) => item.recent30d).length;
  }

  Map<String, int> get reasonCounts {
    final counts = <String, int>{};
    for (final entry in entries) {
      counts[entry.reasonId] = (counts[entry.reasonId] ?? 0) + 1;
    }
    return counts;
  }
}

final class P2PBlacklistEntryDraft {
  const P2PBlacklistEntryDraft({
    required this.id,
    required this.userId,
    required this.username,
    required this.reasonId,
    required this.reasonText,
    required this.blockedAt,
    required this.tradesBefore,
    required this.completionRate,
    required this.isVerified,
    required this.recent30d,
    this.orderId,
    this.badge,
  });

  final String id;
  final String userId;
  final String username;
  final String reasonId;
  final String reasonText;
  final String blockedAt;
  final String? orderId;
  final int tradesBefore;
  final double completionRate;
  final bool isVerified;
  final bool recent30d;
  final String? badge;
}

final class P2PNotificationSettingsSnapshot {
  const P2PNotificationSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.settings,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final List<P2PNotificationSettingDraft> settings;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PNotificationSettingDraft {
  const P2PNotificationSettingDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.channels,
  });

  final String id;
  final String label;
  final String description;
  final Map<String, bool> channels;
}

final class P2PSettingsSnapshot {
  const P2PSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.assetOptions,
    required this.currencyOptions,
    required this.paymentWindows,
    required this.defaultAsset,
    required this.defaultCurrency,
    required this.defaultPaymentWindow,
    required this.notificationToggles,
    required this.privacyToggles,
    required this.securityToggles,
    required this.autoReply,
    required this.notificationsRoute,
    required this.trustedDevicesRoute,
    required this.blacklistRoute,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<String> assetOptions;
  final List<String> currencyOptions;
  final List<String> paymentWindows;
  final String defaultAsset;
  final String defaultCurrency;
  final String defaultPaymentWindow;
  final List<P2PSettingsToggleDraft> notificationToggles;
  final List<P2PSettingsToggleDraft> privacyToggles;
  final List<P2PSettingsToggleDraft> securityToggles;
  final P2PSettingsAutoReplyDraft autoReply;
  final String notificationsRoute;
  final String trustedDevicesRoute;
  final String blacklistRoute;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PSettingsToggleDraft {
  const P2PSettingsToggleDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.toneKey,
    required this.enabled,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final String toneKey;
  final bool enabled;
}

final class P2PSettingsAutoReplyDraft {
  const P2PSettingsAutoReplyDraft({
    required this.enabled,
    required this.buyTemplate,
  });

  final bool enabled;
  final String buyTemplate;
}

final class P2PGuideSnapshot {
  const P2PGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.tabs,
    required this.defaultTab,
    required this.faqItems,
    required this.buySteps,
    required this.sellSteps,
    required this.safetyTips,
    required this.videos,
    required this.parentRoute,
    required this.supportRoute,
    required this.marketRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<P2PGuideTabDraft> tabs;
  final String defaultTab;
  final List<P2PGuideFaqDraft> faqItems;
  final List<P2PGuideStepDraft> buySteps;
  final List<P2PGuideStepDraft> sellSteps;
  final List<P2PGuideTipDraft> safetyTips;
  final List<P2PGuideVideoDraft> videos;
  final String parentRoute;
  final String supportRoute;
  final String marketRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PGuideTabDraft {
  const P2PGuideTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class P2PGuideFaqDraft {
  const P2PGuideFaqDraft({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;
}

final class P2PGuideStepDraft {
  const P2PGuideStepDraft({
    required this.id,
    required this.step,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final int step;
  final String title;
  final String description;
  final String iconKey;
  final String toneKey;
}

final class P2PGuideTipDraft {
  const P2PGuideTipDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String toneKey;
}

final class P2PGuideVideoDraft {
  const P2PGuideVideoDraft({
    required this.id,
    required this.title,
    required this.duration,
    required this.views,
    required this.thumb,
    required this.level,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String duration;
  final String views;
  final String thumb;
  final String level;
  final String toneKey;
}

final class P2PMyOrdersSnapshot {
  const P2PMyOrdersSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.searchHint,
    required this.defaultTab,
    required this.tabs,
    required this.orders,
    required this.parentRoute,
    required this.dashboardRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String searchHint;
  final String defaultTab;
  final List<P2PMyOrdersTabDraft> tabs;
  final List<P2PMyOrderDraft> orders;
  final String parentRoute;
  final String dashboardRoute;
  final String emptyTitle;
  final String contractNotes;

  int get completedCount =>
      orders.where((order) => order.status == 'released').length;

  int get disputedCount =>
      orders.where((order) => order.status == 'disputed').length;

  double get completedVolume => orders
      .where((order) => order.status == 'released')
      .fold<double>(0, (sum, order) => sum + order.total);
}

final class P2PMyOrdersTabDraft {
  const P2PMyOrdersTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class P2PMyOrderDraft {
  const P2PMyOrderDraft({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.asset,
    required this.amount,
    required this.price,
    required this.total,
    required this.currency,
    required this.status,
    required this.merchant,
    required this.merchantId,
    required this.createdAt,
  });

  final String id;
  final String orderNumber;
  final String type;
  final String asset;
  final double amount;
  final int price;
  final int total;
  final String currency;
  final String status;
  final String merchant;
  final String merchantId;
  final String createdAt;
}

final class P2PTransactionLimitTierDraft {
  const P2PTransactionLimitTierDraft({
    required this.tier,
    required this.name,
    required this.statusLabel,
    required this.dailyBuy,
    required this.dailySell,
    required this.weeklyTotal,
    required this.monthlyTotal,
    required this.perTransaction,
    required this.requirements,
  });

  final int tier;
  final String name;
  final String statusLabel;
  final double dailyBuy;
  final double dailySell;
  final double weeklyTotal;
  final double monthlyTotal;
  final double perTransaction;
  final List<String> requirements;
}

final class P2PTransactionLimitUsageDraft {
  const P2PTransactionLimitUsageDraft({
    required this.id,
    required this.label,
    required this.current,
    required this.max,
    required this.toneKey,
  });

  final String id;
  final String label;
  final double current;
  final double max;
  final String toneKey;

  double get percentage => current / max * 100;
  double get remaining => max - current;
}

final class P2PTransactionLimitDetailDraft {
  const P2PTransactionLimitDetailDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.toneKey,
    required this.iconKey,
  });

  final String id;
  final String label;
  final double value;
  final String toneKey;
  final String iconKey;
}

final class P2PClaimDetailSnapshot {
  const P2PClaimDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.claim,
    required this.benchmarks,
    required this.reasonShares,
    required this.parentRoute,
    required this.orderRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PClaimDetailDraft claim;
  final List<P2PClaimBenchmarkDraft> benchmarks;
  final List<P2PClaimReasonShareDraft> reasonShares;
  final String parentRoute;
  final String orderRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PClaimDetailDraft {
  const P2PClaimDetailDraft({
    required this.id,
    required this.claimCode,
    required this.orderId,
    required this.orderNumber,
    required this.reason,
    required this.description,
    required this.amount,
    required this.currency,
    required this.status,
    required this.submittedAt,
    required this.estimatedReview,
    required this.coveragePct,
    required this.maxCoverage,
    required this.timeline,
    required this.evidence,
    required this.reviewerNotes,
    required this.notificationsEnabled,
    this.paidAmount,
  });

  final String id;
  final String claimCode;
  final String orderId;
  final String orderNumber;
  final String reason;
  final String description;
  final int amount;
  final int? paidAmount;
  final String currency;
  final P2PInsuranceClaimStatus status;
  final String submittedAt;
  final String estimatedReview;
  final int coveragePct;
  final int maxCoverage;
  final List<P2PClaimTimelineEventDraft> timeline;
  final List<P2PClaimEvidenceDraft> evidence;
  final List<P2PClaimReviewerNoteDraft> reviewerNotes;
  final bool notificationsEnabled;

  String get statusLabel => switch (status) {
    P2PInsuranceClaimStatus.pending => 'Chờ xử lý',
    P2PInsuranceClaimStatus.reviewing => 'Đang xem xét',
    P2PInsuranceClaimStatus.approved => 'Đã duyệt',
    P2PInsuranceClaimStatus.rejected => 'Từ chối',
    P2PInsuranceClaimStatus.paid => 'Đã chi trả',
  };
}

final class P2PClaimTimelineEventDraft {
  const P2PClaimTimelineEventDraft({
    required this.id,
    required this.statusKey,
    required this.title,
    required this.description,
    required this.timestamp,
    this.actor,
  });

  final String id;
  final String statusKey;
  final String title;
  final String description;
  final String timestamp;
  final String? actor;
}

final class P2PClaimEvidenceDraft {
  const P2PClaimEvidenceDraft({
    required this.id,
    required this.type,
    required this.name,
    required this.size,
    required this.uploadedAt,
  });

  final String id;
  final String type;
  final String name;
  final String size;
  final String uploadedAt;
}

final class P2PClaimReviewerNoteDraft {
  const P2PClaimReviewerNoteDraft({
    required this.id,
    required this.author,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final String id;
  final String author;
  final String role;
  final String content;
  final String timestamp;
}

final class P2PClaimBenchmarkDraft {
  const P2PClaimBenchmarkDraft({
    required this.id,
    required this.title,
    required this.value,
    required this.caption,
    required this.comparison,
    required this.progress,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String value;
  final String caption;
  final String comparison;
  final double progress;
  final String toneKey;
}

final class P2PClaimReasonShareDraft {
  const P2PClaimReasonShareDraft({
    required this.label,
    required this.percent,
    this.highlight = false,
  });

  final String label;
  final int percent;
  final bool highlight;
}

final class P2PUserTradingLevelDraft {
  const P2PUserTradingLevelDraft({
    required this.currentLevel,
    required this.completedOrders,
    required this.accumulatedVolume,
    required this.dailyUsed,
    required this.dailyLimit,
    required this.fee,
    required this.nextLevelProgress,
  });

  final int currentLevel;
  final int completedOrders;
  final int accumulatedVolume;
  final int dailyUsed;
  final int dailyLimit;
  final double fee;
  final double nextLevelProgress;
}

final class P2PTradingLevelDraft {
  const P2PTradingLevelDraft({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.fee,
    required this.dailyLimit,
    required this.perOrderLimit,
    required this.requirements,
  });

  final int id;
  final String name;
  final String nameVi;
  final double fee;
  final int dailyLimit;
  final int perOrderLimit;
  final List<String> requirements;
}

final class P2PMyAdsSnapshot {
  const P2PMyAdsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.ads,
    required this.emptyTitle,
    required this.emptyActionLabel,
    required this.quickLinks,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PMyAdDraft> ads;
  final String emptyTitle;
  final String emptyActionLabel;
  final List<P2PQuickLinkDraft> quickLinks;
  final String contractNotes;

  int get activeCount =>
      ads.where((ad) => ad.status == P2PMyAdStatus.active).length;

  int get pausedCount =>
      ads.where((ad) => ad.status == P2PMyAdStatus.paused).length;

  int get totalVolume30dUsd =>
      ads.fold<int>(0, (sum, ad) => sum + ad.totalVolume30dUsd);
}

final class P2PMyAdDraft {
  const P2PMyAdDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.price,
    required this.currency,
    required this.priceType,
    required this.minLimit,
    required this.maxLimit,
    required this.available,
    required this.paymentMethods,
    required this.avgResponseTime,
    required this.status,
    required this.totalVolume30dUsd,
    this.priceMargin,
    this.tradingHours,
  });

  final String id;
  final P2PTradeType type;
  final String asset;
  final int price;
  final String currency;
  final String priceType;
  final int minLimit;
  final int maxLimit;
  final double available;
  final List<String> paymentMethods;
  final String avgResponseTime;
  final P2PMyAdStatus status;
  final int totalVolume30dUsd;
  final double? priceMargin;
  final String? tradingHours;

  P2PMyAdDraft copyWith({P2PMyAdStatus? status}) {
    return P2PMyAdDraft(
      id: id,
      type: type,
      asset: asset,
      price: price,
      currency: currency,
      priceType: priceType,
      minLimit: minLimit,
      maxLimit: maxLimit,
      available: available,
      paymentMethods: paymentMethods,
      avgResponseTime: avgResponseTime,
      status: status ?? this.status,
      totalVolume30dUsd: totalVolume30dUsd,
      priceMargin: priceMargin,
      tradingHours: tradingHours,
    );
  }
}

final class P2PQuickLinkDraft {
  const P2PQuickLinkDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String iconKey;
}

final class P2PCreateAdSnapshot {
  const P2PCreateAdSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.currencies,
    required this.paymentOptions,
    required this.paymentWindows,
    required this.tradingHours,
    required this.marketPrices,
    required this.defaultAsset,
    required this.defaultCurrency,
    required this.defaultPaymentWindow,
    required this.defaultTradingHours,
    required this.warningNote,
    required this.escrowNote,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<String> assets;
  final List<String> currencies;
  final List<String> paymentOptions;
  final List<int> paymentWindows;
  final List<String> tradingHours;
  final Map<String, int> marketPrices;
  final String defaultAsset;
  final String defaultCurrency;
  final int defaultPaymentWindow;
  final String defaultTradingHours;
  final String warningNote;
  final String escrowNote;
  final String contractNotes;
}

final class P2PMerchantApplySnapshot {
  const P2PMerchantApplySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.stats,
    required this.benefits,
    required this.requirements,
    required this.businessTypes,
    required this.documents,
    required this.reviewSteps,
    required this.securityNote,
    required this.reviewNotice,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PMerchantStatsDraft stats;
  final List<P2PMerchantBenefitDraft> benefits;
  final List<P2PMerchantRequirementDraft> requirements;
  final List<String> businessTypes;
  final List<P2PMerchantDocumentDraft> documents;
  final List<String> reviewSteps;
  final String securityNote;
  final String reviewNotice;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  bool get allRequirementsMet => requirements.every((item) => item.met);
}

final class P2PMerchantStatsDraft {
  const P2PMerchantStatsDraft({
    required this.totalTrades,
    required this.completionRate,
    required this.avgResponseTime,
    required this.accountAgeDays,
    required this.volume30dVnd,
    required this.disputes,
    required this.kycLevel,
  });

  final int totalTrades;
  final double completionRate;
  final String avgResponseTime;
  final int accountAgeDays;
  final int volume30dVnd;
  final int disputes;
  final int kycLevel;
}

final class P2PMerchantBenefitDraft {
  const P2PMerchantBenefitDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
  final String toneKey;
}

final class P2PMerchantRequirementDraft {
  const P2PMerchantRequirementDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.met,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String value;
  final bool met;
  final String iconKey;
}

final class P2PMerchantDocumentDraft {
  const P2PMerchantDocumentDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.required,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool required;
  final String iconKey;
}

final class P2POrderDetailDraft {
  const P2POrderDetailDraft({
    required this.id,
    required this.orderNumber,
    required this.statusLabel,
    required this.countdownLabel,
    required this.typeLabel,
    required this.amount,
    required this.asset,
    required this.priceVnd,
    required this.totalVnd,
    required this.currency,
    required this.paymentMethod,
    required this.merchant,
    required this.merchantId,
    required this.escrowAmount,
    required this.feeLabel,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.transferContent,
    required this.createdTime,
  });

  final String id;
  final String orderNumber;
  final String statusLabel;
  final String countdownLabel;
  final String typeLabel;
  final double amount;
  final String asset;
  final int priceVnd;
  final int totalVnd;
  final String currency;
  final String paymentMethod;
  final String merchant;
  final String merchantId;
  final double escrowAmount;
  final String feeLabel;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String transferContent;
  final String createdTime;
}

final class P2POrderPaymentFieldDraft {
  const P2POrderPaymentFieldDraft({
    required this.id,
    required this.label,
    required this.value,
    this.monospace = false,
    this.emphasis = false,
  });

  final String id;
  final String label;
  final String value;
  final bool monospace;
  final bool emphasis;
}

enum P2POrderStepStatus { completed, active, pending }

final class P2POrderTimelineStepDraft {
  const P2POrderTimelineStepDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.status,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final P2POrderStepStatus status;
  final String iconKey;
}

final class P2POrderQuickActionDraft {
  const P2POrderQuickActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final String route;
}

final class P2POrderProofDraft {
  const P2POrderProofDraft({
    required this.id,
    required this.orderNumber,
    required this.totalVnd,
    required this.currency,
  });

  final String id;
  final String orderNumber;
  final int totalVnd;
  final String currency;
}

final class P2POrderCancelDraft {
  const P2POrderCancelDraft({
    required this.id,
    required this.orderNumber,
    required this.typeLabel,
    required this.amount,
    required this.asset,
    required this.totalVnd,
    required this.currency,
    required this.merchant,
    required this.escrowAmount,
  });

  final String id;
  final String orderNumber;
  final String typeLabel;
  final double amount;
  final String asset;
  final int totalVnd;
  final String currency;
  final String merchant;
  final double escrowAmount;
}

final class P2POrderRateDraft {
  const P2POrderRateDraft({
    required this.id,
    required this.merchant,
    required this.typeLabel,
    required this.amount,
    required this.asset,
    required this.totalVnd,
  });

  final String id;
  final String merchant;
  final String typeLabel;
  final double amount;
  final String asset;
  final int totalVnd;
}

final class P2POrderRateTagDraft {
  const P2POrderRateTagDraft({required this.label, required this.iconKey});

  final String label;
  final String iconKey;
}

final class P2POrderTimelineEventDraft {
  const P2POrderTimelineEventDraft({
    required this.id,
    required this.typeKey,
    required this.title,
    required this.time,
    required this.status,
    required this.actor,
  });

  final String id;
  final String typeKey;
  final String title;
  final String time;
  final P2POrderTimelineStatus status;
  final String actor;

  String get statusLabel => status.name;
}

final class P2PAssetDraft {
  const P2PAssetDraft({
    required this.symbol,
    required this.name,
    required this.marketPriceVnd,
  });

  final String symbol;
  final String name;
  final int marketPriceVnd;
}

final class P2PPaymentMethodDraft {
  const P2PPaymentMethodDraft({
    required this.id,
    required this.bankName,
    required this.isVerified,
  });

  final String id;
  final String bankName;
  final bool isVerified;
}

final class P2PExpressStepDraft {
  const P2PExpressStepDraft({required this.title, required this.iconKey});

  final String title;
  final String iconKey;
}

final class P2PAdDraft {
  const P2PAdDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.merchant,
    required this.merchantId,
    required this.merchantVerified,
    required this.completedOrders,
    required this.completionRate,
    required this.price,
    required this.minLimit,
    required this.maxLimit,
    required this.paymentMethods,
    required this.avgResponseTime,
    required this.isOnline,
    required this.kycMinimum,
    this.active = true,
    this.available = 0,
    this.currency = 'VND',
    this.priceType = 'fixed',
    this.priceMargin,
    this.isNewMerchant = false,
    this.merchantBadge,
    this.merchantRating,
  });

  final String id;
  final P2PTradeType type;
  final String asset;
  final String merchant;
  final String merchantId;
  final bool merchantVerified;
  final int completedOrders;
  final double completionRate;
  final int price;
  final int minLimit;
  final int maxLimit;
  final List<String> paymentMethods;
  final String avgResponseTime;
  final bool isOnline;
  final int kycMinimum;
  final bool active;
  final double available;
  final String currency;
  final String priceType;
  final double? priceMargin;
  final bool isNewMerchant;
  final String? merchantBadge;
  final double? merchantRating;
}

final class P2POrderDraft {
  const P2POrderDraft({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.escrowMinutes,
    required this.escrowAmount,
    required this.fee,
  });

  final String id;
  final String orderNumber;
  final String status;
  final int escrowMinutes;
  final double escrowAmount;
  final int fee;
}

const List<P2POrderTimelineEventDraft> _p2pOrderTimelineEvents = [
  P2POrderTimelineEventDraft(
    id: '1',
    typeKey: 'created',
    title: 'Order Created',
    time: '2026-03-05 14:20:00',
    status: P2POrderTimelineStatus.completed,
    actor: 'You',
  ),
  P2POrderTimelineEventDraft(
    id: '2',
    typeKey: 'matched',
    title: 'Matched with Seller',
    time: '2026-03-05 14:20:15',
    status: P2POrderTimelineStatus.completed,
    actor: 'System',
  ),
  P2POrderTimelineEventDraft(
    id: '3',
    typeKey: 'locked',
    title: 'Funds Locked in Escrow',
    time: '2026-03-05 14:20:30',
    status: P2POrderTimelineStatus.completed,
    actor: 'Seller',
  ),
  P2POrderTimelineEventDraft(
    id: '4',
    typeKey: 'payment',
    title: 'Payment Instructions Sent',
    time: '2026-03-05 14:21:00',
    status: P2POrderTimelineStatus.completed,
    actor: 'Seller',
  ),
  P2POrderTimelineEventDraft(
    id: '5',
    typeKey: 'paid',
    title: 'Marked as Paid',
    time: '2026-03-05 14:35:22',
    status: P2POrderTimelineStatus.completed,
    actor: 'You',
  ),
  P2POrderTimelineEventDraft(
    id: '6',
    typeKey: 'confirming',
    title: 'Awaiting Seller Confirmation',
    time: '2026-03-05 14:35:30',
    status: P2POrderTimelineStatus.pending,
    actor: 'Seller',
  ),
];

const List<P2POrderRateTagDraft> _p2pOrderRateTags = [
  P2POrderRateTagDraft(label: 'Giao dich nhanh', iconKey: 'speed'),
  P2POrderRateTagDraft(label: 'Than thien', iconKey: 'positive'),
  P2POrderRateTagDraft(label: 'Dang tin cay', iconKey: 'trust'),
  P2POrderRateTagDraft(label: 'Gia tot', iconKey: 'price'),
  P2POrderRateTagDraft(label: 'Phan hoi cham', iconKey: 'slow'),
  P2POrderRateTagDraft(label: 'Can cai thien', iconKey: 'improve'),
];

const List<String> _p2pOrderCancelReasons = [
  'Không muốn giao dịch nữa',
  'Đã tìm được giá tốt hơn',
  'Người bán không phản hồi',
  'Thông tin thanh toán không đúng',
  'Lý do khác',
];

const List<String> _p2pOrderProofTips = [
  'Chụp toàn bộ màn hình giao dịch ngân hàng',
  'Hiển thị rõ số tiền, ngày giờ và người nhận',
  'Nội dung chuyển khoản phải đúng mã đơn',
  'Không chỉnh sửa hoặc cắt ghép ảnh',
];

const List<P2POrderPaymentFieldDraft> _p2pOrderPaymentFields = [
  P2POrderPaymentFieldDraft(
    id: 'bank',
    label: 'Ngân hàng',
    value: 'Vietcombank',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'account',
    label: 'Số tài khoản',
    value: '1234567890',
    monospace: true,
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'name',
    label: 'Tên chủ TK',
    value: 'NGUYEN VAN B',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'amount',
    label: 'Số tiền',
    value: '5.070.000 VND',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'content',
    label: 'Nội dung CK',
    value: 'VITTA P2P001',
    monospace: true,
    emphasis: true,
  ),
];

const List<P2POrderTimelineStepDraft> _p2pOrderTimelineSteps = [
  P2POrderTimelineStepDraft(
    id: 'created',
    label: 'Đơn hàng đã tạo',
    description: 'Mua 200.0000 USDT - Escrow đã khóa',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'created',
  ),
  P2POrderTimelineStepDraft(
    id: 'payment',
    label: 'Chờ thanh toán',
    description: 'Chuyển 5.070.000 VND qua Vietcombank',
    time: 'Đang chờ',
    status: P2POrderStepStatus.active,
    iconKey: 'payment',
  ),
  P2POrderTimelineStepDraft(
    id: 'confirm',
    label: 'Xác nhận thanh toán',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'confirm',
  ),
  P2POrderTimelineStepDraft(
    id: 'release',
    label: 'Giải phóng crypto',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'release',
  ),
];

const List<P2POrderQuickActionDraft> _p2pOrderQuickActions = [
  P2POrderQuickActionDraft(
    id: 'merchant',
    label: 'Merchant',
    iconKey: 'merchant',
    route: '/p2p/merchant/mc001',
  ),
  P2POrderQuickActionDraft(
    id: 'block',
    label: 'Chặn',
    iconKey: 'block',
    route: '/p2p/blacklist',
  ),
  P2POrderQuickActionDraft(
    id: 'guide',
    label: 'Hướng dẫn',
    iconKey: 'guide',
    route: '/p2p/guide',
  ),
  P2POrderQuickActionDraft(
    id: 'support',
    label: 'Hỗ trợ',
    iconKey: 'support',
    route: '/support/help',
  ),
];

const List<P2PChatMessageDraft> _p2pChatMessages = [
  P2PChatMessageDraft(
    id: 'system-created',
    sender: P2PChatSender.system,
    text:
        'Đơn hàng #VT-P2P-20240221-001 đã được tạo. Vui lòng thanh toán trong 15 phút.',
    time: '11:00',
  ),
  P2PChatMessageDraft(
    id: 'merchant-hello',
    sender: P2PChatSender.other,
    text: 'Xin chào! Vui lòng chuyển khoản theo thông tin tôi cung cấp nhé',
    time: '11:01',
  ),
  P2PChatMessageDraft(
    id: 'buyer-account',
    sender: P2PChatSender.me,
    text: 'Vâng, tôi sẽ chuyển ngay. Số tài khoản là 1234567890 đúng không?',
    time: '11:02',
  ),
  P2PChatMessageDraft(
    id: 'merchant-confirm',
    sender: P2PChatSender.other,
    text: 'Đúng rồi. Chủ tài khoản NGUYEN VAN B - Vietcombank.',
    time: '11:02',
  ),
  P2PChatMessageDraft(
    id: 'buyer-paid',
    sender: P2PChatSender.me,
    text: 'Đã chuyển khoản xong, vui lòng xác nhận nhé!',
    time: '11:07',
  ),
];

const List<String> _p2pChatQuickReplies = [
  'Tôi đã chuyển khoản xong',
  'Bạn đã nhận tiền chưa?',
  'Cảm ơn bạn!',
  'Tôi cần hỗ trợ',
];

const List<P2PDisputeLevelDraft> _p2pDisputeLevels = [
  P2PDisputeLevelDraft(
    level: 1,
    shortLabel: 'Xử lý tự động',
    label: 'Bot AI',
    description: 'Hệ thống AI phân tích bằng chứng & đưa ra khuyến nghị',
    avgTime: '~5 phút',
    iconKey: 'bot',
  ),
  P2PDisputeLevelDraft(
    level: 2,
    shortLabel: 'Nhân viên hỗ trợ',
    label: 'Support Agent',
    description: 'Nhân viên xem xét chi tiết, liên hệ cả hai bên',
    avgTime: '~2 giờ',
    iconKey: 'support',
  ),
  P2PDisputeLevelDraft(
    level: 3,
    shortLabel: 'Trọng tài',
    label: 'Arbitration',
    description: 'Trọng tài viên độc lập đánh giá & ra quyết định',
    avgTime: '~24 giờ',
    iconKey: 'scale',
  ),
  P2PDisputeLevelDraft(
    level: 4,
    shortLabel: 'Đội ngũ pháp lý',
    label: 'Legal Team',
    description: 'Xử lý bởi đội ngũ pháp lý trong trường hợp nghiêm trọng',
    avgTime: '~48 giờ',
    iconKey: 'briefcase',
  ),
];

const List<P2PDisputeEvidenceDraft> _p2pDisputeEvidence = [
  P2PDisputeEvidenceDraft(
    id: 'proof-transfer-001',
    fileName: 'proof_transfer_001.jpg',
  ),
  P2PDisputeEvidenceDraft(
    id: 'screenshot-chat-001',
    fileName: 'screenshot_chat_001.jpg',
  ),
];

const List<P2PDisputeEvidenceDocumentDraft> _p2pDisputeEvidenceDocuments = [
  P2PDisputeEvidenceDocumentDraft(
    id: 'payment',
    label: 'Payment Receipt',
    iconKey: 'file',
    uploaded: true,
  ),
  P2PDisputeEvidenceDocumentDraft(
    id: 'chat',
    label: 'Chat Screenshot',
    iconKey: 'image',
    uploaded: true,
  ),
  P2PDisputeEvidenceDocumentDraft(
    id: 'transaction',
    label: 'Transaction Proof',
    iconKey: 'file',
    uploaded: false,
  ),
];

const List<String> _p2pDisputeReasons = [
  'Seller không release sau khi nhận tiền',
  'Buyer không thanh toán',
  'Thông tin thanh toán sai',
  'Số tiền không khớp',
  'Khác (ghi rõ)',
];

const List<P2PDisputeListItemDraft> _p2pDisputeList = [
  P2PDisputeListItemDraft(
    id: 'disp001',
    orderId: 'p2p006',
    orderNumber: 'VT-P2P-20240219-006',
    status: P2PDisputeStatus.underReview,
    statusLabel: 'Đang xem xét',
    reason: 'Đã thanh toán nhưng người bán không xác nhận',
    createdAt: '2024-02-19 08:50',
    evidenceCount: 2,
    timelineCount: 5,
  ),
];

const List<String> _p2pDisputeGuideSteps = [
  'Vào đơn hàng đang có vấn đề',
  'Bấm "Mở tranh chấp" trong trang chi tiết đơn',
  'Mô tả vấn đề và đính kèm bằng chứng',
  'Chờ hệ thống xử lý (trung bình 2-24 giờ)',
];

const List<P2PAdDailyPerformanceDraft> _p2pAdDailyPerformance = [
  P2PAdDailyPerformanceDraft(
    date: '20/02',
    impressions: 412,
    orders: 8,
    volume: 68000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '21/02',
    impressions: 389,
    orders: 12,
    volume: 95000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '22/02',
    impressions: 478,
    orders: 15,
    volume: 112000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '23/02',
    impressions: 356,
    orders: 6,
    volume: 48000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '24/02',
    impressions: 501,
    orders: 18,
    volume: 142000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '25/02',
    impressions: 445,
    orders: 14,
    volume: 108000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '26/02',
    impressions: 520,
    orders: 20,
    volume: 158000000,
  ),
];

const List<P2PAdHourlyHeatmapDraft> _p2pAdHourlyHeatmap = [
  P2PAdHourlyHeatmapDraft(hour: 0, orders: 2),
  P2PAdHourlyHeatmapDraft(hour: 1, orders: 1),
  P2PAdHourlyHeatmapDraft(hour: 2, orders: 0),
  P2PAdHourlyHeatmapDraft(hour: 3, orders: 0),
  P2PAdHourlyHeatmapDraft(hour: 4, orders: 1),
  P2PAdHourlyHeatmapDraft(hour: 5, orders: 2),
  P2PAdHourlyHeatmapDraft(hour: 6, orders: 4),
  P2PAdHourlyHeatmapDraft(hour: 7, orders: 8),
  P2PAdHourlyHeatmapDraft(hour: 8, orders: 15),
  P2PAdHourlyHeatmapDraft(hour: 9, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 10, orders: 28),
  P2PAdHourlyHeatmapDraft(hour: 11, orders: 24),
  P2PAdHourlyHeatmapDraft(hour: 12, orders: 18),
  P2PAdHourlyHeatmapDraft(hour: 13, orders: 20),
  P2PAdHourlyHeatmapDraft(hour: 14, orders: 26),
  P2PAdHourlyHeatmapDraft(hour: 15, orders: 24),
  P2PAdHourlyHeatmapDraft(hour: 16, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 17, orders: 18),
  P2PAdHourlyHeatmapDraft(hour: 18, orders: 15),
  P2PAdHourlyHeatmapDraft(hour: 19, orders: 20),
  P2PAdHourlyHeatmapDraft(hour: 20, orders: 25),
  P2PAdHourlyHeatmapDraft(hour: 21, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 22, orders: 12),
  P2PAdHourlyHeatmapDraft(hour: 23, orders: 5),
];

const List<P2PAdPaymentBreakdownDraft> _p2pAdPaymentBreakdown = [
  P2PAdPaymentBreakdownDraft(
    method: 'Vietcombank',
    count: 156,
    volume: 1240000000,
  ),
  P2PAdPaymentBreakdownDraft(method: 'Momo', count: 118, volume: 940000000),
];

const List<P2PAdCompetitorComparisonDraft> _p2pAdCompetitorComparison = [
  P2PAdCompetitorComparisonDraft(
    metric: 'Giá',
    yours: 25360,
    average: 25320,
    top: 25280,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Tỷ lệ HT (%)',
    yours: 94.8,
    average: 89.2,
    top: 98.5,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Phản hồi (s)',
    yours: 45,
    average: 120,
    top: 25,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Rating',
    yours: 4.8,
    average: 4.2,
    top: 4.9,
  ),
];

const List<P2PAdOptimizationTipDraft> _p2pAdOptimizationTips = [
  P2PAdOptimizationTipDraft(
    tone: 'buy',
    iconKey: 'check',
    text: 'Tỷ lệ hoàn thành tốt! Duy trì phản hồi nhanh để giữ vị trí top 3.',
  ),
  P2PAdOptimizationTipDraft(
    tone: 'accent',
    iconKey: 'clock',
    text: 'Giờ cao điểm 9h-11h & 20h-21h. Đảm bảo online trong khung giờ này.',
  ),
  P2PAdOptimizationTipDraft(
    tone: 'warn',
    iconKey: 'trend',
    text: 'CVR tốt! Xem xét tăng available amount để đón thêm đơn.',
  ),
];

const List<P2PDisputeTimelineDraft> _p2pDisputeTimeline = [
  P2PDisputeTimelineDraft(
    id: 'created',
    event: 'Đơn hàng được tạo',
    time: '2024-02-19 08:10',
  ),
  P2PDisputeTimelineDraft(
    id: 'paid',
    event: 'Đã thanh toán',
    detail: 'Chuyển khoản Vietcombank',
    time: '2024-02-19 08:15',
  ),
  P2PDisputeTimelineDraft(
    id: 'expired',
    event: 'Hết thời gian xác nhận',
    time: '2024-02-19 08:45',
  ),
  P2PDisputeTimelineDraft(
    id: 'submitted',
    event: 'Khiếu nại được gửi',
    detail: 'Bằng chứng: 2 ảnh',
    time: '2024-02-19 08:50',
  ),
  P2PDisputeTimelineDraft(
    id: 'review',
    event: 'Đang xem xét',
    detail: 'Bộ phận hỗ trợ đã tiếp nhận',
    time: '2024-02-19 09:00',
    active: true,
  ),
];

const List<P2PDisputeSupportMessageDraft> _p2pDisputeSupportMessages = [
  P2PDisputeSupportMessageDraft(
    id: 'user-open',
    sender: P2PDisputeMessageSender.user,
    text:
        'Tôi đã chuyển khoản xong nhưng seller không xác nhận. Đính kèm ảnh chụp giao dịch ngân hàng.',
    time: '08:50',
  ),
  P2PDisputeSupportMessageDraft(
    id: 'support-received',
    sender: P2PDisputeMessageSender.support,
    text:
        'Chào bạn, chúng tôi đã nhận được khiếu nại. Đang liên hệ người bán để xác minh. Vui lòng chờ trong 24h.',
    time: '09:05',
  ),
  P2PDisputeSupportMessageDraft(
    id: 'support-update',
    sender: P2PDisputeMessageSender.support,
    text:
        'Cập nhật: Người bán đã xác nhận nhận được tiền. Crypto sẽ được giải phóng trong 5 phút.',
    time: '10:30',
  ),
];

const List<P2PMerchantProfileDraft> _p2pMerchants = [
  P2PMerchantProfileDraft(
    id: 'mc001',
    name: 'CryptoKing_VN',
    level: 3,
    kycVerified: true,
    joinDate: '15/6/2022',
    totalTrades: 1243,
    totalTrades30d: 89,
    completionRate: 98.5,
    avgReleaseTime: '2 phút',
    avgPayTime: '5 phút',
    totalVolume30dUsd: 850000,
    isOnline: true,
    lastActive: '1 phút trước',
    positiveRate: 97.8,
    negativeCount: 3,
    activeAds: 4,
  ),
  P2PMerchantProfileDraft(
    id: 'mc004',
    name: 'VIPTrader_HN',
    level: 3,
    kycVerified: true,
    joinDate: '5/11/2021',
    totalTrades: 3421,
    totalTrades30d: 210,
    completionRate: 99.1,
    avgReleaseTime: '1 phút',
    avgPayTime: '3 phút',
    totalVolume30dUsd: 2100000,
    isOnline: true,
    lastActive: 'Vừa xong',
    positiveRate: 99.3,
    negativeCount: 1,
    activeAds: 5,
  ),
];

const List<P2PMerchantProfileAdDraft> _p2pMerchantProfileAds = [
  P2PMerchantProfileAdDraft(
    id: 'ad001',
    merchantId: 'mc001',
    type: P2PTradeType.sell,
    asset: 'USDT',
    available: 10000,
    price: 25350,
    minLimit: 500000,
    maxLimit: 50000000,
    paymentMethods: ['Vietcombank', 'Momo', 'ZaloPay'],
  ),
  P2PMerchantProfileAdDraft(
    id: 'ad002',
    merchantId: 'mc001',
    type: P2PTradeType.sell,
    asset: 'ETH',
    available: 15,
    price: 89500000,
    minLimit: 2000000,
    maxLimit: 100000000,
    paymentMethods: ['Vietcombank', 'Momo'],
  ),
  P2PMerchantProfileAdDraft(
    id: 'ad003',
    merchantId: 'mc001',
    type: P2PTradeType.sell,
    asset: 'SOL',
    available: 80,
    price: 4870000,
    minLimit: 2000000,
    maxLimit: 100000000,
    paymentMethods: ['Vietcombank', 'BIDV'],
  ),
];

const List<P2PMerchantProfileReviewDraft> _p2pMerchantProfileReviews = [
  P2PMerchantProfileReviewDraft(
    id: 'rv001',
    fromUser: 'Tôi',
    toUserId: 'mc001',
    rating: 5,
    comment: 'Giao dịch nhanh, xác nhận trong 2 phút. Merchant rất uy tín!',
    createdAt: '2024-02-22 15:00',
    positive: true,
  ),
  P2PMerchantProfileReviewDraft(
    id: 'rv003',
    fromUser: 'TraderNewbie',
    toUserId: 'mc001',
    rating: 4,
    comment: 'Giao dịch ổn, hơi chậm xác nhận lúc đêm khuya.',
    createdAt: '2024-02-20 23:45',
    positive: true,
  ),
  P2PMerchantProfileReviewDraft(
    id: 'rv004',
    fromUser: 'CoinLover99',
    toUserId: 'mc001',
    rating: 5,
    comment: 'Lần thứ 10 giao dịch. Luôn nhanh và tin cậy.',
    createdAt: '2024-02-19 10:20',
    positive: true,
  ),
  P2PMerchantProfileReviewDraft(
    id: 'rv009',
    fromUser: 'SafeBuyer',
    toUserId: 'mc001',
    rating: 5,
    comment: 'Thanh toán rõ ràng, escrow giải phóng đúng cam kết.',
    createdAt: '2024-02-18 08:30',
    positive: true,
  ),
];

const List<P2PReviewDraft> _p2pReviews = [
  P2PReviewDraft(
    id: 'rv001',
    orderId: 'p2p003',
    fromUser: 'Tôi',
    fromUserId: 'user001',
    toUser: 'CryptoKing_VN',
    toUserId: 'mc001',
    rating: 5,
    comment: 'Giao dịch nhanh, xác nhận trong 2 phút. Merchant rất uy tín!',
    createdAt: '2024-02-22 15:00',
    positive: true,
    reply: 'Cảm ơn bạn! Rất vui được hợp tác',
  ),
  P2PReviewDraft(
    id: 'rv002',
    orderId: 'p2p004',
    fromUser: 'Tôi',
    fromUserId: 'user001',
    toUser: 'VIPTrader_HN',
    toUserId: 'mc004',
    rating: 5,
    comment: 'Top merchant. Xác nhận siêu nhanh ~1 phút. Highly recommended!',
    createdAt: '2024-02-21 17:00',
    positive: true,
  ),
  P2PReviewDraft(
    id: 'rv003',
    orderId: 'p2p005',
    fromUser: 'TraderNewbie',
    fromUserId: 'user010',
    toUser: 'CryptoKing_VN',
    toUserId: 'mc001',
    rating: 4,
    comment: 'Giao dịch ổn, hơi chậm xác nhận lúc đêm khuya.',
    createdAt: '2024-02-20 23:45',
    positive: true,
  ),
  P2PReviewDraft(
    id: 'rv004',
    orderId: 'p2p010',
    fromUser: 'CoinLover99',
    fromUserId: 'user015',
    toUser: 'CryptoKing_VN',
    toUserId: 'mc001',
    rating: 5,
    comment: 'Lần thứ 10 giao dịch. Luôn nhanh và tin cậy.',
    createdAt: '2024-02-19 10:20',
    positive: true,
  ),
  P2PReviewDraft(
    id: 'rv005',
    orderId: 'p2p012',
    fromUser: 'SafeTrader',
    fromUserId: 'user020',
    toUser: 'CoinHunter_HCM',
    toUserId: 'mc003',
    rating: 2,
    comment: 'Phản hồi quá chậm, phải đợi 30 phút mới xác nhận.',
    createdAt: '2024-02-18 14:00',
    positive: false,
  ),
  P2PReviewDraft(
    id: 'rv006',
    orderId: 'p2p002',
    fromUser: 'VIPTrader_HN',
    fromUserId: 'mc004',
    toUser: 'Tôi',
    toUserId: 'user001',
    rating: 5,
    comment: 'Người mua thanh toán rất nhanh, hợp tác vui vẻ!',
    createdAt: '2024-02-23 10:00',
    positive: true,
  ),
  P2PReviewDraft(
    id: 'rv007',
    orderId: 'p2p003',
    fromUser: 'TradeMaster99',
    fromUserId: 'mc002',
    toUser: 'Tôi',
    toUserId: 'user001',
    rating: 4,
    comment: 'Giao dịch ổn, thanh toán đúng hạn.',
    createdAt: '2024-02-22 15:30',
    positive: true,
    reply: 'Cảm ơn bạn!',
  ),
  P2PReviewDraft(
    id: 'rv008',
    orderId: 'p2p007',
    fromUser: 'BTCWhale_VN',
    fromUserId: 'mc006',
    toUser: 'Tôi',
    toUserId: 'user001',
    rating: 5,
    comment: 'Người mua uy tín, chuyển khoản nhanh. Sẵn sàng giao dịch tiếp.',
    createdAt: '2024-02-18 13:00',
    positive: true,
  ),
];

const List<P2PReportReasonDraft> _p2pReportReasons = [
  P2PReportReasonDraft(
    id: 'scam',
    label: 'Lừa đảo / Gian lận',
    description: 'Cố gắng lừa đảo hoặc chiếm đoạt tài sản',
    iconKey: 'alert',
    tone: P2PReportReasonTone.danger,
  ),
  P2PReportReasonDraft(
    id: 'fake_payment',
    label: 'Thanh toán giả',
    description: 'Gửi biên lai giả hoặc thanh toán không hợp lệ',
    iconKey: 'ban',
    tone: P2PReportReasonTone.danger,
  ),
  P2PReportReasonDraft(
    id: 'harassment',
    label: 'Quấy rối / Đe dọa',
    description: 'Ngôn ngữ xúc phạm, đe dọa trong giao tiếp',
    iconKey: 'message',
    tone: P2PReportReasonTone.purple,
  ),
  P2PReportReasonDraft(
    id: 'price_manipulation',
    label: 'Thao túng giá',
    description: 'Cố tình đặt giá bất hợp lý để thao túng',
    iconKey: 'currency',
    tone: P2PReportReasonTone.warning,
  ),
  P2PReportReasonDraft(
    id: 'identity',
    label: 'Giả mạo danh tính',
    description: 'Sử dụng tài khoản người khác hoặc thông tin giả',
    iconKey: 'eye',
    tone: P2PReportReasonTone.info,
  ),
  P2PReportReasonDraft(
    id: 'other',
    label: 'Lý do khác',
    description: 'Hành vi vi phạm quy định khác',
    iconKey: 'flag',
    tone: P2PReportReasonTone.neutral,
  ),
];

const P2PUserTradingLevelDraft _p2pUserTradingLevel = P2PUserTradingLevelDraft(
  currentLevel: 3,
  completedOrders: 64,
  accumulatedVolume: 1250000000,
  dailyUsed: 45000000,
  dailyLimit: 500000000,
  fee: 0.15,
  nextLevelProgress: 0.42,
);

const List<P2PTradingLevelDraft> _p2pTradingLevels = [
  P2PTradingLevelDraft(
    id: 1,
    name: 'Basic',
    nameVi: 'Cơ bản',
    fee: 0.30,
    dailyLimit: 10000000,
    perOrderLimit: 5000000,
    requirements: ['Email xác minh'],
  ),
  P2PTradingLevelDraft(
    id: 2,
    name: 'Standard',
    nameVi: 'Tiêu chuẩn',
    fee: 0.20,
    dailyLimit: 100000000,
    perOrderLimit: 50000000,
    requirements: ['KYC Lv.1 (CMND/CCCD)', 'Xác minh SĐT'],
  ),
  P2PTradingLevelDraft(
    id: 3,
    name: 'Advanced',
    nameVi: 'Nâng cao',
    fee: 0.15,
    dailyLimit: 500000000,
    perOrderLimit: 200000000,
    requirements: [
      'KYC Lv.2 (Selfie + Video)',
      '2FA đã bật',
      '50+ giao dịch hoàn tất',
    ],
  ),
  P2PTradingLevelDraft(
    id: 4,
    name: 'VIP',
    nameVi: 'VIP',
    fee: 0.10,
    dailyLimit: 0,
    perOrderLimit: 0,
    requirements: [
      'KYC Lv.2',
      '2FA đã bật',
      'Volume > 5 tỷ VND',
      '200+ giao dịch hoàn tất',
    ],
  ),
];

const List<String> _p2pHomeAssets = ['USDT', 'BTC', 'ETH', 'BNB', 'SOL'];

const List<String> _p2pHomeFiats = ['VND', 'USD'];

const P2PHomePlatformStatsDraft _p2pHomePlatformStats =
    P2PHomePlatformStatsDraft(
      volume24h: 12850000000,
      volume24hChange: 8.7,
      totalTrades24h: 3247,
      activeMerchants: 428,
      onlineTraders: 1892,
      avgCompletionRate: 94.5,
      avgCompletionTime: '6 phút',
      escrowProtected: 45200000000,
    );

const List<P2PHomeQuickActionDraft> _p2pHomeQuickActions = [
  P2PHomeQuickActionDraft(
    id: 'express',
    title: 'Express Trade',
    subtitle: 'Auto match · 1 chạm',
    iconKey: 'bolt',
    route: '/p2p/express',
    toneKey: 'buy',
  ),
  P2PHomeQuickActionDraft(
    id: 'create',
    title: 'Đăng offer',
    subtitle: 'Tạo quảng cáo P2P',
    iconKey: 'add',
    route: '/p2p/create',
    toneKey: 'primary',
  ),
];

const List<P2PAdDraft> _p2pAds = [
  P2PAdDraft(
    id: 'ad001',
    type: P2PTradeType.sell,
    asset: 'USDT',
    merchant: 'CryptoKing_VN',
    merchantId: 'mc001',
    merchantVerified: true,
    completedOrders: 1243,
    completionRate: 98.5,
    price: 25350,
    minLimit: 500000,
    maxLimit: 50000000,
    paymentMethods: ['Vietcombank', 'Momo', 'ZaloPay'],
    avgResponseTime: '2 phút',
    isOnline: true,
    kycMinimum: 1,
    available: 10000,
    merchantBadge: 'elite',
    merchantRating: 4.8,
  ),
  P2PAdDraft(
    id: 'ad002',
    type: P2PTradeType.sell,
    asset: 'USDT',
    merchant: 'TradeMaster99',
    merchantId: 'mc002',
    merchantVerified: true,
    completedOrders: 567,
    completionRate: 96.2,
    price: 25380,
    minLimit: 1000000,
    maxLimit: 100000000,
    paymentMethods: ['Techcombank', 'VietinBank'],
    avgResponseTime: '5 phút',
    isOnline: true,
    kycMinimum: 1,
    available: 5000,
    priceType: 'floating',
    priceMargin: .12,
    merchantBadge: 'pro',
    merchantRating: 4.2,
  ),
  P2PAdDraft(
    id: 'ad003',
    type: P2PTradeType.sell,
    asset: 'USDT',
    merchant: 'CoinHunter_HCM',
    merchantId: 'mc003',
    merchantVerified: false,
    completedOrders: 234,
    completionRate: 94.1,
    price: 25400,
    minLimit: 200000,
    maxLimit: 20000000,
    paymentMethods: ['Momo', 'ZaloPay'],
    avgResponseTime: '8 phút',
    isOnline: false,
    kycMinimum: 0,
    available: 2500,
    isNewMerchant: true,
    merchantRating: 3.8,
  ),
  P2PAdDraft(
    id: 'ad004',
    type: P2PTradeType.buy,
    asset: 'USDT',
    merchant: 'VIPTrader_HN',
    merchantId: 'mc004',
    merchantVerified: true,
    completedOrders: 3421,
    completionRate: 99.1,
    price: 25280,
    minLimit: 2000000,
    maxLimit: 200000000,
    paymentMethods: ['Vietcombank', 'BIDV', 'Momo'],
    avgResponseTime: '1 phút',
    isOnline: true,
    kycMinimum: 2,
    available: 50000,
    merchantBadge: 'elite',
    merchantRating: 4.9,
  ),
];

const List<P2PMyAdDraft> _p2pMyAds = [
  P2PMyAdDraft(
    id: 'myad001',
    type: P2PTradeType.sell,
    asset: 'USDT',
    price: 25360,
    currency: 'VND',
    priceType: 'fixed',
    minLimit: 500000,
    maxLimit: 30000000,
    available: 3000,
    paymentMethods: ['Vietcombank', 'Momo'],
    avgResponseTime: '5 phút',
    status: P2PMyAdStatus.active,
    totalVolume30dUsd: 28000,
    tradingHours: '08:00 - 22:00',
  ),
  P2PMyAdDraft(
    id: 'myad002',
    type: P2PTradeType.buy,
    asset: 'USDT',
    price: 25250,
    currency: 'VND',
    priceType: 'floating',
    priceMargin: -0.4,
    minLimit: 1000000,
    maxLimit: 50000000,
    available: 5000,
    paymentMethods: ['Vietcombank', 'Techcombank', 'Momo'],
    avgResponseTime: '5 phút',
    status: P2PMyAdStatus.active,
    totalVolume30dUsd: 28000,
  ),
  P2PMyAdDraft(
    id: 'myad003',
    type: P2PTradeType.sell,
    asset: 'BTC',
    price: 1718000000,
    currency: 'VND',
    priceType: 'fixed',
    minLimit: 5000000,
    maxLimit: 100000000,
    available: .1,
    paymentMethods: ['Vietcombank'],
    avgResponseTime: '5 phút',
    status: P2PMyAdStatus.paused,
    totalVolume30dUsd: 28000,
  ),
];

const List<P2PAssetDraft> _p2pAssets = [
  P2PAssetDraft(symbol: 'USDT', name: 'Tether', marketPriceVnd: 25300),
  P2PAssetDraft(symbol: 'BTC', name: 'Bitcoin', marketPriceVnd: 1715000000),
  P2PAssetDraft(symbol: 'ETH', name: 'Ethereum', marketPriceVnd: 89000000),
  P2PAssetDraft(symbol: 'BNB', name: 'BNB', marketPriceVnd: 15200000),
  P2PAssetDraft(symbol: 'SOL', name: 'Solana', marketPriceVnd: 4800000),
];

const List<P2PPaymentMethodDraft> _p2pPaymentMethods = [
  P2PPaymentMethodDraft(
    id: 'vietcombank',
    bankName: 'Vietcombank',
    isVerified: true,
  ),
  P2PPaymentMethodDraft(
    id: 'techcombank',
    bankName: 'Techcombank',
    isVerified: true,
  ),
  P2PPaymentMethodDraft(id: 'momo', bankName: 'Momo', isVerified: true),
];

const List<P2PPaymentListMethodDraft> _p2pPaymentMethodList = [
  P2PPaymentListMethodDraft(
    id: 'vietcombank-primary',
    type: P2PPaymentListMethodType.bank,
    name: 'Vietcombank',
    accountNumber: '0071000123456',
    accountName: 'NGUYEN VAN A',
    isVerified: true,
    isDefault: true,
  ),
  P2PPaymentListMethodDraft(
    id: 'techcombank-backup',
    type: P2PPaymentListMethodType.bank,
    name: 'Techcombank',
    accountNumber: '19033456789012',
    accountName: 'NGUYEN VAN A',
    isVerified: true,
  ),
  P2PPaymentListMethodDraft(
    id: 'momo-wallet',
    type: P2PPaymentListMethodType.ewallet,
    name: 'Momo',
    accountNumber: '0901234567',
    accountName: 'NGUYEN VAN A',
    isVerified: true,
  ),
  P2PPaymentListMethodDraft(
    id: 'zalopay-wallet',
    type: P2PPaymentListMethodType.ewallet,
    name: 'ZaloPay',
    accountNumber: '0901234567',
    accountName: 'NGUYEN VAN A',
    isVerified: false,
  ),
];

const List<String> _p2pPaymentBankOptions = [
  'Vietcombank',
  'Techcombank',
  'VietinBank',
  'BIDV',
  'MB Bank',
  'ACB',
  'Sacombank',
  'TPBank',
];

const List<String> _p2pPaymentEwalletOptions = [
  'Momo',
  'ZaloPay',
  'VNPay',
  'ShopeePay',
];

const List<P2PPaymentVerificationMethodDraft> _p2pPaymentVerificationMethods = [
  P2PPaymentVerificationMethodDraft(
    id: 'micro_deposit',
    label: 'Micro-deposit',
    description: 'Chúng tôi gửi 1-2 VND, bạn xác nhận số tiền',
    duration: '1-2 ngày làm việc',
    iconKey: 'card',
    recommended: true,
  ),
  P2PPaymentVerificationMethodDraft(
    id: 'photo',
    label: 'Upload ảnh',
    description: 'Chụp ảnh thẻ ATM/CCCD cùng tên',
    duration: '10 phút',
    iconKey: 'camera',
  ),
  P2PPaymentVerificationMethodDraft(
    id: 'statement',
    label: 'Bank statement',
    description: 'Tải lên sao kê có tên tài khoản',
    duration: '30 phút',
    iconKey: 'upload',
  ),
];

const List<P2POwnershipDocumentDraft> _p2pOwnershipDocuments = [
  P2POwnershipDocumentDraft(id: 'bank_card', label: 'Ảnh thẻ ATM'),
  P2POwnershipDocumentDraft(id: 'selfie_card', label: 'Selfie với thẻ'),
  P2POwnershipDocumentDraft(
    id: 'statement',
    label: 'Bank statement (optional)',
    optional: true,
  ),
];

const List<P2PPaymentHistoryTransactionDraft> _p2pPaymentHistoryTransactions = [
  P2PPaymentHistoryTransactionDraft(
    id: '1',
    orderId: '#45892',
    type: P2PTradeType.buy,
    amount: 36000000,
    status: 'completed',
    timestamp: '2026-03-05 14:20',
  ),
  P2PPaymentHistoryTransactionDraft(
    id: '2',
    orderId: '#45880',
    type: P2PTradeType.buy,
    amount: 24000000,
    status: 'completed',
    timestamp: '2026-03-05 13:45',
  ),
  P2PPaymentHistoryTransactionDraft(
    id: '3',
    orderId: '#45870',
    type: P2PTradeType.sell,
    amount: 16800000,
    status: 'completed',
    timestamp: '2026-03-04 10:30',
  ),
  P2PPaymentHistoryTransactionDraft(
    id: '4',
    orderId: '#45860',
    type: P2PTradeType.buy,
    amount: 25000000,
    status: 'cancelled',
    timestamp: '2026-03-03 16:20',
  ),
];

const List<P2PInsuranceEligibilityItemDraft> _p2pInsuranceEligibilityItems = [
  P2PInsuranceEligibilityItemDraft(label: 'Niêm sự cố thuộc diện nhận claim'),
  P2PInsuranceEligibilityItemDraft(
    label: 'KYC đã xác minh',
    value: 'Level 2 — Pro',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: '2FA đã bật',
    value: 'Google Authenticator',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: 'Tier đủ điều kiện',
    value: 'Pro — bảo hiểm 85%',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: 'Hạn mức còn lại',
    value: '75.000.000 đ / 30 ngày',
    highlight: true,
  ),
  P2PInsuranceEligibilityItemDraft(
    label: 'Giao dịch P2P gần đây',
    value: '3 đơn trong 7 ngày qua',
    highlight: true,
  ),
];

const List<P2PInsuranceCoverageTierDraft> _p2pInsuranceCoverageTiers = [
  P2PInsuranceCoverageTierDraft(name: 'Thường', coveragePct: 'Không có'),
  P2PInsuranceCoverageTierDraft(name: 'Xác minh', coveragePct: '70%'),
  P2PInsuranceCoverageTierDraft(
    name: 'Pro',
    coveragePct: '85%',
    highlight: true,
  ),
  P2PInsuranceCoverageTierDraft(
    name: 'Elite',
    coveragePct: '100%',
    bonus: '+10%',
  ),
];

const List<P2PInsuranceNotificationPrefDraft> _p2pInsuranceNotificationPrefs = [
  P2PInsuranceNotificationPrefDraft(
    key: 'status_change',
    label: 'Thay đổi trạng thái',
    description: 'Khi claim chuyển sang trạng thái mới',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'reviewer_note',
    label: 'Ghi chú reviewer',
    description: 'Khi có ghi chú mới từ nhân viên',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'evidence_request',
    label: 'Yêu cầu bằng chứng',
    description: 'Khi cần bổ sung tài liệu',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'payment_complete',
    label: 'Chi trả hoàn tất',
    description: 'Khi tiền đã chuyển vào ví',
    enabled: true,
  ),
  P2PInsuranceNotificationPrefDraft(
    key: 'fund_report',
    label: 'Báo cáo quỹ hàng tuần',
    description: 'Cập nhật tình hình quỹ bảo hiểm',
    enabled: false,
  ),
];

const List<P2PInsuranceClaimDraft> _p2pInsuranceClaims = [
  P2PInsuranceClaimDraft(
    id: 'ic001',
    claimCode: 'CLM-001',
    orderId: 'P2P-78400',
    reason: 'Gian lận',
    amount: 15000000,
    paidAmount: 12750000,
    status: P2PInsuranceClaimStatus.paid,
    submittedAt: '2026-02-18',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic002',
    claimCode: 'CLM-002',
    orderId: 'P2P-78412',
    reason: 'Chargeback',
    amount: 8000000,
    status: P2PInsuranceClaimStatus.reviewing,
    submittedAt: '2026-02-23',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic003',
    claimCode: 'CLM-003',
    orderId: 'P2P-78415',
    reason: 'Lỗi dispute',
    amount: 50000000,
    status: P2PInsuranceClaimStatus.approved,
    submittedAt: '2026-02-22',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic004',
    claimCode: 'CLM-004',
    orderId: 'P2P-78390',
    reason: 'Khác',
    amount: 3000000,
    status: P2PInsuranceClaimStatus.rejected,
    submittedAt: '2026-02-20',
  ),
  P2PInsuranceClaimDraft(
    id: 'ic005',
    claimCode: 'CLM-005',
    orderId: 'P2P-78425',
    reason: 'Gian lận',
    amount: 25000000,
    status: P2PInsuranceClaimStatus.pending,
    submittedAt: '2026-02-25',
  ),
];

const List<P2PInsuranceChartPointDraft> _p2pInsuranceChartPoints = [
  P2PInsuranceChartPointDraft(
    day: '01/02',
    balance: 380,
    inflow: 12,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '05/02',
    balance: 394,
    inflow: 11,
    outflow: 4,
  ),
  P2PInsuranceChartPointDraft(
    day: '09/02',
    balance: 408,
    inflow: 13,
    outflow: 6,
  ),
  P2PInsuranceChartPointDraft(
    day: '13/02',
    balance: 430,
    inflow: 15,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '17/02',
    balance: 455,
    inflow: 20,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '21/02',
    balance: 478,
    inflow: 19,
    outflow: 6,
  ),
  P2PInsuranceChartPointDraft(
    day: '25/02',
    balance: 505,
    inflow: 20,
    outflow: 5,
  ),
  P2PInsuranceChartPointDraft(
    day: '01/03',
    balance: 523,
    inflow: 14,
    outflow: 6,
  ),
];

const List<String> _p2pInsuranceCertificateCoveredCases = [
  'Gian lận - merchant không giải phóng coin',
  'Chargeback - buyer hoàn tiền qua ngân hàng',
  'Lỗi hệ thống - dispute phân xử sai',
  'Trường hợp khác - xem xét riêng',
];

const List<String> _p2pInsuranceCertificateExclusions = [
  'Biến động giá tài sản',
  'Lỗi nhập sai địa chỉ ví',
  'Giao dịch ngoài nền tảng',
  'Gian lận từ phía người claim',
];

const List<P2PInsuranceScoreFactorDraft> _p2pInsuranceScoreFactors = [
  P2PInsuranceScoreFactorDraft(
    id: 'kyc',
    label: 'Xác minh danh tính',
    description: 'KYC Level 2 đã hoàn tất',
    score: 20,
    maxScore: 20,
    statusLabel: 'Xuất sắc',
    toneKey: 'buy',
    iconKey: 'user_check',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'trading',
    label: 'Lịch sử giao dịch',
    description: '128 giao dịch thành công, 99.2% completion',
    score: 22,
    maxScore: 25,
    statusLabel: 'Tốt',
    toneKey: 'primary',
    iconKey: 'bar_chart',
    recommendation: 'Hoàn thành thêm 20 giao dịch để đạt điểm tối đa',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'claim_history',
    label: 'Lịch sử claims',
    description: '5 claims, 60% được duyệt, 0 gian lận',
    score: 16,
    maxScore: 20,
    statusLabel: 'Tốt',
    toneKey: 'accent',
    iconKey: 'shield',
    recommendation:
        'Tỷ lệ duyệt 60% - cải thiện chất lượng bằng chứng khi gửi claim',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'account_age',
    label: 'Tuổi tài khoản',
    description: '14 tháng hoạt động liên tục',
    score: 12,
    maxScore: 15,
    statusLabel: 'Tốt',
    toneKey: 'warn',
    iconKey: 'award',
    recommendation: 'Đạt 18 tháng để nhận điểm tối đa',
  ),
  P2PInsuranceScoreFactorDraft(
    id: 'security',
    label: 'Bảo mật tài khoản',
    description: '2FA bật, chưa có anti-phishing code',
    score: 8,
    maxScore: 20,
    statusLabel: 'Trung bình',
    toneKey: 'sell',
    iconKey: 'lock',
    recommendation:
        'Thiết lập Anti-Phishing Code và Biometrics để tăng 12 điểm',
  ),
];

const List<P2PInsuranceScoreQuickActionDraft> _p2pInsuranceScoreQuickActions = [
  P2PInsuranceScoreQuickActionDraft(
    label: 'Thiết lập Anti-Phishing Code',
    gain: '+8 điểm',
    toneKey: 'sell',
    route: '/profile/settings',
  ),
  P2PInsuranceScoreQuickActionDraft(
    label: 'Bật Biometrics / Passkey',
    gain: '+4 điểm',
    toneKey: 'warn',
    route: '/profile/settings',
  ),
  P2PInsuranceScoreQuickActionDraft(
    label: 'Hoàn thành thêm 20 giao dịch',
    gain: '+3 điểm',
    toneKey: 'primary',
    route: '/p2p',
  ),
  P2PInsuranceScoreQuickActionDraft(
    label: 'Duy trì 4 tháng nữa',
    gain: '+3 điểm',
    toneKey: 'accent',
  ),
];

const List<P2PInsuranceScoreTierDraft> _p2pInsuranceScoreTiers = [
  P2PInsuranceScoreTierDraft(
    name: 'Thường',
    requiredScore: 0,
    coveragePct: '0%',
    requirements: ['Tạo tài khoản'],
    isCurrent: false,
    isUnlocked: true,
  ),
  P2PInsuranceScoreTierDraft(
    name: 'Xác minh',
    requiredScore: 30,
    coveragePct: '70%',
    requirements: ['KYC Level 1+', 'Điểm bảo vệ ≥ 30', '2FA bật'],
    isCurrent: false,
    isUnlocked: true,
  ),
  P2PInsuranceScoreTierDraft(
    name: 'Pro',
    requiredScore: 60,
    coveragePct: '85%',
    requirements: [
      'KYC Level 2',
      'Điểm bảo vệ ≥ 60',
      '50+ giao dịch',
      'Completion ≥ 95%',
    ],
    isCurrent: true,
    isUnlocked: true,
  ),
  P2PInsuranceScoreTierDraft(
    name: 'Elite',
    requiredScore: 90,
    coveragePct: '100% +10%',
    requirements: [
      'KYC Level 2',
      'Điểm bảo vệ ≥ 90',
      '200+ giao dịch',
      'Completion ≥ 98%',
      '0 vi phạm 6 tháng',
      'Anti-Phishing Code bật',
    ],
    isCurrent: false,
    isUnlocked: false,
  ),
];

const List<P2PInsurancePolicySectionDraft> _p2pInsurancePolicySections = [
  P2PInsurancePolicySectionDraft(
    id: 'scope',
    title: '1. Phạm vi bảo hiểm',
    content: [
      'Quỹ Bảo Hiểm P2P bảo vệ merchants và buyers trên nền tảng giao dịch P2P khỏi các rủi ro gian lận, chargeback, và lỗi hệ thống trong quá trình giao dịch.',
      'Bảo hiểm áp dụng cho tất cả giao dịch P2P đã hoàn tất trên nền tảng, với điều kiện người dùng đã đóng góp vào quỹ thông qua phí giao dịch.',
      'Bảo hiểm KHÔNG bao gồm: thiệt hại do biến động giá thị trường, lỗi của người dùng trong việc nhập sai địa chỉ ví, hoặc các giao dịch ngoài nền tảng.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'eligibility',
    title: '2. Điều kiện đủ tiêu chuẩn',
    content: [
      'Người dùng phải hoàn tất xác minh danh tính (KYC) ít nhất ở mức "Xác minh" để được bảo hiểm.',
      'Giao dịch phải được thực hiện hoàn toàn trên nền tảng, bao gồm thanh toán và giải phóng coin.',
      'Yêu cầu bồi thường phải được gửi trong vòng 7 ngày kể từ ngày giao dịch xảy ra sự cố.',
      'Mỗi người dùng có hạn mức bồi thường tối đa 100.000.000 VND trong 30 ngày.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'tiers',
    title: '3. Các mức bảo hiểm',
    content: [
      'Thường: Không được bảo hiểm - cần hoàn tất KYC để kích hoạt.',
      'Xác minh: Bảo hiểm 70% giá trị giao dịch - áp dụng cho người dùng đã KYC.',
      'Pro: Bảo hiểm 85% giá trị giao dịch - áp dụng cho merchants Pro đã được phê duyệt.',
      'Elite: Bảo hiểm 100% giá trị giao dịch + 10% bonus - áp dụng cho merchants Elite có uy tín cao.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'contribution',
    title: '4. Đóng góp quỹ',
    content: [
      '0.1% giá trị mỗi giao dịch P2P sẽ được tự động trích vào Quỹ Bảo Hiểm.',
      'Phí đóng góp được hiển thị rõ trong phần phí giao dịch trước khi xác nhận.',
      'Đóng góp không được hoàn lại và không thể rút ra khỏi quỹ.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'claims',
    title: '5. Quy trình yêu cầu bồi thường',
    content: [
      'Bước 1: Gửi yêu cầu bồi thường kèm mã đơn hàng, lý do, số tiền, và mô tả chi tiết.',
      'Bước 2: Đội ngũ hỗ trợ sẽ xem xét yêu cầu trong vòng 48 giờ làm việc.',
      'Bước 3: Nếu được phê duyệt, chi trả sẽ được thực hiện trong vòng 72 giờ vào ví nội bộ.',
      'Bước 4: Nếu bị từ chối, người dùng có thể kháng nghị trong vòng 14 ngày.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'evidence',
    title: '6. Bằng chứng yêu cầu',
    content: [
      'Người dùng cần cung cấp bằng chứng đầy đủ: ảnh chụp màn hình giao dịch, lịch sử chat, sao kê ngân hàng.',
      'Bằng chứng phải là nguyên gốc, không chỉnh sửa. Phát hiện giả mạo sẽ dẫn đến từ chối vĩnh viễn.',
      'Tất cả bằng chứng được mã hóa và chỉ nhân viên có thẩm quyền mới được truy cập.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'exclusions',
    title: '7. Các trường hợp loại trừ',
    content: [
      'Giao dịch ngoài nền tảng hoặc sử dụng kênh thanh toán không được hỗ trợ.',
      'Thiệt hại do biến động giá thị trường sau khi giao dịch hoàn tất.',
      'Yêu cầu gửi sau thời hạn 7 ngày kể từ ngày sự cố.',
      'Người dùng có lịch sử gian lận hoặc vi phạm điều khoản sử dụng.',
      'Yêu cầu vượt quá hạn mức bồi thường trong kỳ 30 ngày.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'privacy',
    title: '8. Bảo mật dữ liệu',
    content: [
      'Thông tin cá nhân và bằng chứng được lưu trữ theo tiêu chuẩn bảo mật AES-256.',
      'Dữ liệu chỉ được sử dụng cho mục đích xem xét yêu cầu bồi thường.',
      'Sau khi yêu cầu được giải quyết, bằng chứng sẽ được lưu trữ trong 90 ngày rồi tự động xóa.',
      'Người dùng có quyền yêu cầu xóa dữ liệu sớm hơn theo chính sách GDPR.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'governance',
    title: '9. Quản trị quỹ',
    content: [
      'Quỹ Bảo Hiểm được kiểm toán định kỳ bởi đơn vị kiểm toán độc lập.',
      'Báo cáo Proof of Reserves được công bố hàng tháng.',
      'Tỷ lệ thanh khoản (Solvency Ratio) được giám sát liên tục và công khai.',
      'Nền tảng có quyền tạm ngưng nhận claims mới nếu tỷ lệ thanh khoản dưới 100%.',
    ],
  ),
  P2PInsurancePolicySectionDraft(
    id: 'amendments',
    title: '10. Sửa đổi điều khoản',
    content: [
      'Nền tảng có quyền sửa đổi điều khoản bảo hiểm với thông báo trước 30 ngày.',
      'Người dùng sẽ được thông báo qua email và push notification về các thay đổi.',
      'Tiếp tục sử dụng dịch vụ sau ngày có hiệu lực đồng nghĩa với việc chấp nhận điều khoản mới.',
    ],
  ),
];

const List<P2PContributionDraft> _p2pContributionHistoryItems = [
  P2PContributionDraft(
    id: 'c001',
    date: '2026-03-03',
    orderId: 'P2P-78470',
    orderAmount: 7200000,
    contributionAmount: 7200,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c002',
    date: '2026-03-02',
    orderId: 'P2P-78460',
    orderAmount: 18500000,
    contributionAmount: 18500,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c003',
    date: '2026-03-01',
    orderId: 'P2P-78450',
    orderAmount: 42000000,
    contributionAmount: 42000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c004',
    date: '2026-02-25',
    orderId: 'P2P-78425',
    orderAmount: 25000000,
    contributionAmount: 25000,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c005',
    date: '2026-02-23',
    orderId: 'P2P-78412',
    orderAmount: 8000000,
    contributionAmount: 8000,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c006',
    date: '2026-02-22',
    orderId: 'P2P-78415',
    orderAmount: 50000000,
    contributionAmount: 50000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c007',
    date: '2026-02-20',
    orderId: 'P2P-78390',
    orderAmount: 3000000,
    contributionAmount: 3000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c008',
    date: '2026-02-18',
    orderId: 'P2P-78400',
    orderAmount: 15000000,
    contributionAmount: 15000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c009',
    date: '2026-02-15',
    orderId: 'P2P-78380',
    orderAmount: 12500000,
    contributionAmount: 12500,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c010',
    date: '2026-02-10',
    orderId: 'P2P-78350',
    orderAmount: 22000000,
    contributionAmount: 22000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c011',
    date: '2026-02-05',
    orderId: 'P2P-78320',
    orderAmount: 35000000,
    contributionAmount: 35000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c012',
    date: '2026-01-28',
    orderId: 'P2P-78280',
    orderAmount: 18000000,
    contributionAmount: 18000,
    feeRate: .1,
    coin: 'USDT',
  ),
  P2PContributionDraft(
    id: 'c013',
    date: '2026-01-25',
    orderId: 'P2P-78250',
    orderAmount: 9500000,
    contributionAmount: 9500,
    feeRate: .1,
    coin: 'BTC',
  ),
  P2PContributionDraft(
    id: 'c014',
    date: '2026-01-20',
    orderId: 'P2P-78220',
    orderAmount: 28000000,
    contributionAmount: 28000,
    feeRate: .1,
    coin: 'ETH',
  ),
  P2PContributionDraft(
    id: 'c015',
    date: '2026-01-15',
    orderId: 'P2P-78180',
    orderAmount: 16000000,
    contributionAmount: 16000,
    feeRate: .1,
    coin: 'USDT',
  ),
];

const List<P2PEscrowAssetBalanceDraft> _p2pEscrowAssets = [
  P2PEscrowAssetBalanceDraft(asset: 'USDT', totalAmount: 3200, orderCount: 3),
  P2PEscrowAssetBalanceDraft(asset: 'BTC', totalAmount: .01, orderCount: 1),
  P2PEscrowAssetBalanceDraft(
    asset: 'VND',
    totalAmount: 12000000,
    orderCount: 1,
  ),
];

const Map<String, List<P2PEscrowOrderDraft>> _p2pEscrowOrders = {
  'USDT': [
    P2PEscrowOrderDraft(
      id: '1',
      orderId: '#P2P-45892',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 1500,
      fiatAmount: 36000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***89',
      status: P2PEscrowOrderStatus.paid,
      lockedAt: '2026-03-05 14:20',
      estimatedRelease: '2026-03-05 15:20',
    ),
    P2PEscrowOrderDraft(
      id: '2',
      orderId: '#P2P-45880',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 1000,
      fiatAmount: 24000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***12',
      status: P2PEscrowOrderStatus.pendingPayment,
      lockedAt: '2026-03-05 13:45',
      estimatedRelease: '2026-03-05 14:45',
    ),
    P2PEscrowOrderDraft(
      id: '3',
      orderId: '#P2P-45870',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 700,
      fiatAmount: 16800000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***45',
      status: P2PEscrowOrderStatus.dispute,
      lockedAt: '2026-03-05 10:30',
      estimatedRelease: 'Đang giải quyết',
      warning:
          'Đơn hàng đang tranh chấp. Số tiền sẽ được giữ cho đến khi giải quyết xong.',
    ),
  ],
  'BTC': [
    P2PEscrowOrderDraft(
      id: '4',
      orderId: '#P2P-45860',
      type: P2PEscrowOrderType.sell,
      asset: 'BTC',
      amount: .01,
      fiatAmount: 25000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***78',
      status: P2PEscrowOrderStatus.paid,
      lockedAt: '2026-03-04 16:20',
      estimatedRelease: '2026-03-05 16:20',
    ),
  ],
  'VND': [
    P2PEscrowOrderDraft(
      id: '5',
      orderId: '#P2P-45850',
      type: P2PEscrowOrderType.buy,
      asset: 'USDT',
      amount: 500,
      fiatAmount: 12000000,
      fiatCurrency: 'VND',
      counterparty: 'seller_***34',
      status: P2PEscrowOrderStatus.pendingRelease,
      lockedAt: '2026-03-05 12:10',
      estimatedRelease: '2026-03-05 13:10',
    ),
  ],
};

const List<String> _p2pEscrowHelpBullets = [
  'Bán crypto: sau khi bạn release cho buyer',
  'Mua crypto: sau khi seller release cho bạn',
  'Tranh chấp: sau khi Support giải quyết xong',
  'Hủy đơn: tiền trả về ngay lập tức',
];

const String _p2pEscrowAddress = '0x579bdf13579bdf13579bdf13579bdf13579bdf13';

const List<P2PEscrowSignerDraft> _p2pEscrowSigners = [
  P2PEscrowSignerDraft(
    id: 'buyer',
    role: 'buyer',
    label: 'Người mua',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: false,
  ),
  P2PEscrowSignerDraft(
    id: 'seller',
    role: 'seller',
    label: 'Người bán (CryptoKing_VN)',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: false,
  ),
  P2PEscrowSignerDraft(
    id: 'platform',
    role: 'platform',
    label: 'VitTrade Platform',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: true,
    signedAt: '11:00',
  ),
];

const List<P2PEscrowTimelineEventDraft> _p2pEscrowTimeline = [
  P2PEscrowTimelineEventDraft(
    id: 'created',
    label: 'Escrow được tạo',
    description: 'Smart contract khởi tạo · 200.0000 USDT',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'key',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'locked',
    label: 'Coin đã khóa',
    description: '200.0000 USDT chuyển vào escrow address',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'lock',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'waiting_payment',
    label: 'Chờ thanh toán fiat',
    description: 'Người mua cần chuyển khoản & xác nhận',
    time: 'Đang chờ',
    status: P2POrderStepStatus.active,
    iconKey: 'clock',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'confirm_pending',
    label: 'Xác nhận nhận tiền',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'shield',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'release_pending',
    label: 'Giải phóng coin',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'unlock',
  ),
];

const List<P2PKycTierDraft> _p2pKycTiers = [
  P2PKycTierDraft(
    id: 1,
    name: 'Basic',
    badge: 'Cơ bản',
    toneKey: 'success',
    iconKey: 'shield',
    requirements: [
      P2PKycRequirementDraft(label: 'CMND/CCCD/Passport', iconKey: 'file'),
      P2PKycRequirementDraft(label: 'OCR + Face Match', iconKey: 'camera'),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 50000000,
      dailySell: 50000000,
      monthlyVolume: 500000000,
    ),
    benefits: [
      'Giao dịch P2P cơ bản',
      'Tạo tối đa 3 quảng cáo',
      'Rút tối đa 20M VND/ngày',
    ],
    verificationTime: '10 phút',
    status: P2PKycTierStatus.current,
  ),
  P2PKycTierDraft(
    id: 2,
    name: 'Intermediate',
    badge: 'Trung cấp',
    toneKey: 'p2p',
    iconKey: 'badge',
    requirements: [
      P2PKycRequirementDraft(label: 'KYC Basic', iconKey: 'check'),
      P2PKycRequirementDraft(label: 'Proof of Address', iconKey: 'file'),
      P2PKycRequirementDraft(label: 'Selfie với ID', iconKey: 'camera'),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 200000000,
      dailySell: 200000000,
      monthlyVolume: 2000000000,
    ),
    benefits: [
      'Tất cả quyền Basic',
      'Tạo không giới hạn quảng cáo',
      'Rút tối đa 100M VND/ngày',
      'Ưu tiên hỗ trợ',
    ],
    verificationTime: '24 giờ',
    status: P2PKycTierStatus.available,
  ),
  P2PKycTierDraft(
    id: 3,
    name: 'Advanced',
    badge: 'Nâng cao',
    toneKey: 'warning',
    iconKey: 'star',
    requirements: [
      P2PKycRequirementDraft(label: 'KYC Intermediate', iconKey: 'check'),
      P2PKycRequirementDraft(
        label: 'Video Call Verification',
        iconKey: 'video',
      ),
      P2PKycRequirementDraft(label: 'Source of Funds', iconKey: 'file'),
      P2PKycRequirementDraft(
        label: 'Enhanced Due Diligence',
        iconKey: 'shield',
      ),
    ],
    limits: P2PKycLimitsDraft(
      dailyBuy: 1000000000,
      dailySell: 1000000000,
      monthlyVolume: 10000000000,
    ),
    benefits: [
      'Tất cả quyền Intermediate',
      'Merchant Badge',
      'API Trading Access',
      'Dedicated Support 24/7',
      'Phí ưu đãi đặc biệt',
    ],
    verificationTime: '3-5 ngày làm việc',
    status: P2PKycTierStatus.available,
  ),
];

const List<P2PKycStatusStepDraft> _p2pKycStatusSteps = [
  P2PKycStatusStepDraft(
    id: 'identity',
    label: 'Identity Verification',
    description: 'CMND/CCCD/Passport + OCR',
    iconKey: 'file',
    status: P2PKycStepStatus.completed,
    completedAt: '2026-03-04 14:35',
  ),
  P2PKycStatusStepDraft(
    id: 'face_match',
    label: 'Face Match',
    description: 'So khớp khuôn mặt với ID',
    iconKey: 'face',
    status: P2PKycStepStatus.completed,
    completedAt: '2026-03-04 14:36',
  ),
  P2PKycStatusStepDraft(
    id: 'address_proof',
    label: 'Address Proof',
    description: 'Hóa đơn tiện ích / Bank statement',
    iconKey: 'upload',
    status: P2PKycStepStatus.processing,
    estimatedTime: '2-4 giờ',
  ),
  P2PKycStatusStepDraft(
    id: 'selfie_verification',
    label: 'Selfie Verification',
    description: 'Selfie với ID card',
    iconKey: 'camera',
    status: P2PKycStepStatus.waiting,
    estimatedTime: '10 phút',
    actionLabel: 'Bắt đầu',
    actionRoute: '/p2p/kyc/selfie',
  ),
  P2PKycStatusStepDraft(
    id: 'compliance_review',
    label: 'Compliance Review',
    description: 'Xem xét cuối cùng',
    iconKey: 'shield',
    status: P2PKycStepStatus.waiting,
    estimatedTime: '1-2 ngày làm việc',
  ),
];

const List<P2PIdentityDocumentTypeDraft> _p2pIdentityDocumentTypes = [
  P2PIdentityDocumentTypeDraft(
    id: 'cccd',
    label: 'Căn cước công dân',
    description: 'CCCD gắn chip (12 số)',
    iconKey: 'id_card',
  ),
  P2PIdentityDocumentTypeDraft(
    id: 'cmnd',
    label: 'Chứng minh nhân dân',
    description: 'CMND cũ (9 số)',
    iconKey: 'badge',
  ),
  P2PIdentityDocumentTypeDraft(
    id: 'passport',
    label: 'Hộ chiếu',
    description: 'Passport quốc tế',
    iconKey: 'passport',
  ),
];

const List<String> _p2pIdentityGuidelines = [
  'Đảm bảo ảnh rõ nét, không bị mờ hoặc nhòe',
  'Chụp toàn bộ giấy tờ, không bị cắt góc',
  'Không chụp qua màn hình hoặc ảnh photocopy',
  'Ánh sáng đủ, không bị lóa hoặc bóng tối',
  'Thông tin cá nhân phải đọc được rõ ràng',
];

const List<String> _p2pIdentitySecurityNotes = [
  'Tài liệu được mã hóa end-to-end',
  'Chỉ team Compliance được xem',
  'Tự động xóa sau 90 ngày nếu không approve',
  'Tuân thủ GDPR & Privacy Policy',
];

const List<P2PAddressDocumentTypeDraft> _p2pAddressDocumentTypes = [
  P2PAddressDocumentTypeDraft(
    id: 'utility',
    label: 'Hóa đơn tiện ích',
    description: 'Điện, nước, gas, internet',
    iconKey: 'receipt',
    examples: [
      'Hóa đơn điện EVN',
      'Hóa đơn nước',
      'Hóa đơn internet FPT/Viettel',
    ],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'bank_statement',
    label: 'Sao kê ngân hàng',
    description: 'Bank statement 3 tháng gần nhất',
    iconKey: 'bank_card',
    examples: ['Sao kê Vietcombank', 'Sao kê BIDV', 'Sao kê Techcombank'],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'gov_letter',
    label: 'Giấy tờ chính phủ',
    description: 'Giấy xác nhận tạm trú, hộ khẩu',
    iconKey: 'government',
    examples: ['Giấy xác nhận tạm trú', 'Sổ hộ khẩu'],
  ),
  P2PAddressDocumentTypeDraft(
    id: 'lease',
    label: 'Hợp đồng thuê nhà',
    description: 'Lease agreement có công chứng',
    iconKey: 'home',
    examples: ['Hợp đồng thuê nhà công chứng'],
  ),
];

const List<String> _p2pAddressRequirements = [
  'Tài liệu phải trong vòng 3 tháng',
  'Địa chỉ phải khớp với thông tin đã khai báo',
  'Tên phải khớp với CMND/CCCD',
  'Tài liệu phải rõ nét, đầy đủ thông tin',
  'Chấp nhận cả bản scan và ảnh chụp',
];

const List<String> _p2pAddressSecurityNotes = [
  'Tài liệu được mã hóa AES-256',
  'Chỉ Compliance team được xem',
  'Tự động xóa sau 90 ngày nếu không approve',
  'Tuân thủ GDPR & PDPA',
];

const List<String> _p2pSelfieGuidelines = [
  'Giữ ID card cạnh khuôn mặt',
  'Đảm bảo khuôn mặt và ID rõ nét',
  'Ánh sáng đủ, không chói ngược',
  'Không đeo kính đen, khẩu trang',
  'Nhìn thẳng vào camera',
];

const List<String> _p2pSelfieTips = [
  'Sử dụng môi trường đủ sáng',
  'Giữ điện thoại ổn định',
  'Làm theo hướng dẫn từng bước',
  'Khuôn mặt nên ở chính giữa khung hình',
];

const List<P2PSelfieLivenessActionDraft> _p2pSelfieLivenessActions = [
  P2PSelfieLivenessActionDraft(
    id: 'smile',
    label: 'Mỉm cười',
    iconKey: 'smile',
  ),
  P2PSelfieLivenessActionDraft(
    id: 'blink',
    label: 'Chớp mắt 2 lần',
    iconKey: 'blink',
  ),
  P2PSelfieLivenessActionDraft(
    id: 'turn_left',
    label: 'Quay mặt sang trái',
    iconKey: 'turn_left',
  ),
  P2PSelfieLivenessActionDraft(
    id: 'turn_right',
    label: 'Quay mặt sang phải',
    iconKey: 'turn_right',
  ),
];

const List<String> _p2pVideoPreparationItems = [
  'CMND/CCCD gốc',
  'Môi trường đủ sáng',
  'Camera và mic hoạt động',
  'Thời gian 10-15 phút',
];

const List<P2PVideoTimeSlotDraft> _p2pVideoTimeSlots = [
  P2PVideoTimeSlotDraft(
    id: 'slot_0900',
    date: '2026-03-06',
    time: '09:00 - 09:30',
    available: true,
  ),
  P2PVideoTimeSlotDraft(
    id: 'slot_1000',
    date: '2026-03-06',
    time: '10:00 - 10:30',
    available: true,
  ),
  P2PVideoTimeSlotDraft(
    id: 'slot_1400',
    date: '2026-03-06',
    time: '14:00 - 14:30',
    available: false,
  ),
  P2PVideoTimeSlotDraft(
    id: 'slot_1500',
    date: '2026-03-07',
    time: '15:00 - 15:30',
    available: true,
  ),
];

const List<P2PSecurityFeatureDraft> _p2pSecurityFeatures = [
  P2PSecurityFeatureDraft(
    id: '2fa',
    label: '2FA cho P2P',
    iconKey: 'phone',
    status: P2PSecurityStatus.enabled,
    scoreDelta: 30,
    route: '/p2p/security/2fa',
  ),
  P2PSecurityFeatureDraft(
    id: 'anti_phishing',
    label: 'Anti-Phishing Code',
    iconKey: 'anti_phishing',
    status: P2PSecurityStatus.enabled,
    scoreDelta: 20,
    route: '/p2p/security/anti-phishing',
  ),
  P2PSecurityFeatureDraft(
    id: 'trusted_devices',
    label: 'Trusted Devices',
    iconKey: 'devices',
    status: P2PSecurityStatus.warning,
    scoreDelta: 15,
    route: '/p2p/security/devices',
  ),
  P2PSecurityFeatureDraft(
    id: 'whitelist',
    label: 'Whitelist Mode',
    iconKey: 'whitelist',
    status: P2PSecurityStatus.disabled,
    scoreDelta: 0,
    route: '/p2p/security/whitelist',
  ),
  P2PSecurityFeatureDraft(
    id: 'biometric',
    label: 'Biometric Lock',
    iconKey: 'biometric',
    status: P2PSecurityStatus.enabled,
    scoreDelta: 25,
    route: '/settings/security/biometric',
  ),
];

const List<P2PSecurityQuickActionDraft> _p2pSecurityQuickActions = [
  P2PSecurityQuickActionDraft(
    id: 'change_password',
    label: 'Đổi mật khẩu',
    iconKey: 'password',
    colorKey: 'p2p',
    route: '/settings/security/change-password',
  ),
  P2PSecurityQuickActionDraft(
    id: 'login_history',
    label: 'Lịch sử đăng nhập',
    iconKey: 'history',
    colorKey: 'success',
    route: '/p2p/security/login-history',
  ),
  P2PSecurityQuickActionDraft(
    id: 'devices',
    label: 'Quản lý thiết bị',
    iconKey: 'devices',
    colorKey: 'warning',
    route: '/p2p/security/devices',
  ),
  P2PSecurityQuickActionDraft(
    id: 'activity',
    label: 'Hoạt động đáng ngờ',
    iconKey: 'alert',
    colorKey: 'danger',
    route: '/p2p/security/suspicious-activity',
  ),
];

const List<P2PSecurityEventDraft> _p2pSecurityRecentEvents = [
  P2PSecurityEventDraft(
    id: 'login_success',
    label: 'Đăng nhập thành công',
    description: 'iPhone 15 Pro · Hà Nội, VN',
    time: '2 phút trước',
    iconKey: 'success',
    severity: P2PSecurityEventSeverity.info,
  ),
  P2PSecurityEventDraft(
    id: 'new_device',
    label: 'Thiết bị mới',
    description: 'MacBook Pro · TP.HCM, VN',
    time: '3 giờ trước',
    iconKey: 'device',
    severity: P2PSecurityEventSeverity.warning,
  ),
  P2PSecurityEventDraft(
    id: 'failed_login',
    label: 'Đăng nhập thất bại',
    description: '3 lần nhập sai mật khẩu',
    time: '1 ngày trước',
    iconKey: 'failed',
    severity: P2PSecurityEventSeverity.critical,
  ),
];

const List<P2PTwoFactorMethodDraft> _p2pTwoFactorMethods = [
  P2PTwoFactorMethodDraft(
    id: '2fa_sms',
    label: 'SMS OTP',
    description: '+84 *** *** **89',
    iconKey: 'sms',
    colorKey: 'success',
    enabled: true,
    isPrimary: true,
    setupRequired: false,
  ),
  P2PTwoFactorMethodDraft(
    id: '2fa_authenticator',
    label: 'Authenticator App',
    description: 'Google Authenticator, Authy',
    iconKey: 'authenticator',
    colorKey: 'p2p',
    enabled: false,
    isPrimary: false,
    setupRequired: true,
  ),
  P2PTwoFactorMethodDraft(
    id: '2fa_email',
    label: 'Email OTP',
    description: 'ngu***@gmail.com',
    iconKey: 'email',
    colorKey: 'warning',
    enabled: true,
    isPrimary: false,
    setupRequired: false,
  ),
];

const List<P2PTransactionThresholdDraft> _p2pTwoFactorThresholds = [
  P2PTransactionThresholdDraft(
    id: 'release',
    label: 'Release Escrow',
    description: 'Yêu cầu 2FA khi release >= threshold',
    valueLabel: '≥ 10,000,000 VND',
    enabled: true,
    editable: true,
  ),
  P2PTransactionThresholdDraft(
    id: 'create_order',
    label: 'Create Order',
    description: 'Yêu cầu 2FA khi tạo order >= threshold',
    valueLabel: '≥ 50,000,000 VND',
    enabled: false,
    editable: true,
  ),
  P2PTransactionThresholdDraft(
    id: 'cancel_order',
    label: 'Cancel Order',
    description: 'Luôn yêu cầu 2FA khi hủy đơn',
    valueLabel: '',
    enabled: true,
    editable: false,
  ),
];

const List<P2PTrustedDeviceDraft> _p2pTrustedDevices = [
  P2PTrustedDeviceDraft(
    id: 'device_iphone_15',
    name: 'iPhone 15 Pro',
    type: 'mobile',
    os: 'iOS 17.3',
    browser: 'Safari',
    location: 'Hà Nội, VN',
    ip: '123.21.45.67',
    lastActive: '2 phút trước',
    firstSeen: '2026-01-15',
    isCurrent: true,
    isTrusted: true,
    fingerprint: 'fp_abc123xyz789',
  ),
  P2PTrustedDeviceDraft(
    id: 'device_macbook',
    name: 'MacBook Pro',
    type: 'desktop',
    os: 'macOS 14.3',
    browser: 'Chrome 121',
    location: 'TP.HCM, VN',
    ip: '113.161.78.90',
    lastActive: '3 giờ trước',
    firstSeen: '2026-02-10',
    isCurrent: false,
    isTrusted: true,
    fingerprint: 'fp_def456uvw321',
  ),
  P2PTrustedDeviceDraft(
    id: 'device_samsung_s24',
    name: 'Samsung Galaxy S24',
    type: 'mobile',
    os: 'Android 14',
    browser: 'Chrome Mobile',
    location: 'Đà Nẵng, VN',
    ip: '14.231.56.12',
    lastActive: '1 ngày trước',
    firstSeen: '2026-03-01',
    isCurrent: false,
    isTrusted: false,
    fingerprint: 'fp_ghi789rst456',
  ),
  P2PTrustedDeviceDraft(
    id: 'device_ipad_pro',
    name: 'iPad Pro',
    type: 'tablet',
    os: 'iPadOS 17.2',
    browser: 'Safari',
    location: 'Hà Nội, VN',
    ip: '123.21.45.70',
    lastActive: '2 ngày trước',
    firstSeen: '2025-12-20',
    isCurrent: false,
    isTrusted: true,
    fingerprint: 'fp_jkl012mno789',
  ),
];

const List<String> _p2pDeviceSecurityTips = [
  'Kiểm tra thường xuyên danh sách thiết bị',
  'Xóa ngay thiết bị không nhận ra',
  'Không đánh dấu tin cậy thiết bị công cộng',
  'Đổi mật khẩu nếu phát hiện thiết bị lạ',
];

const List<String> _p2pAntiPhishingBenefits = [
  'Bảo vệ khỏi email phishing',
  'Xác thực email chính thức',
  'Ngăn chặn lừa đảo',
];

const List<P2PAntiPhishingExampleDraft> _p2pAntiPhishingExamples = [
  P2PAntiPhishingExampleDraft(
    id: 'legitimate',
    subject: '[VitTrade] P2P Order Confirmed',
    preview:
        'Anti-Phishing Code: SECURE2026\n\nYour P2P order #45892 has been confirmed...',
    isLegit: true,
  ),
  P2PAntiPhishingExampleDraft(
    id: 'phishing',
    subject: '[VitTrade] Urgent: Verify Your Account',
    preview:
        'Your account will be suspended. Click here immediately...\n(No anti-phishing code)',
    isLegit: false,
  ),
];

const List<String> _p2pAntiPhishingWarnings = [
  'Không chia sẻ code này với bất kỳ ai',
  'VitTrade không bao giờ hỏi code qua email/điện thoại',
  'Nếu email không có code, đó là phishing',
  'Báo ngay cho Support nếu nhận được email lạ',
];

const List<P2PLoginEventDraft> _p2pLoginHistoryEvents = [
  P2PLoginEventDraft(
    id: 'login_iphone_current',
    timestamp: '2026-03-05 14:30:22',
    deviceType: 'mobile',
    deviceName: 'iPhone 15 Pro',
    os: 'iOS 17.3',
    browser: 'Safari',
    city: 'Hà Nội',
    country: 'VN',
    ip: '123.21.45.67',
    status: 'success',
    statusLabel: 'Thành công',
    method: 'biometric',
    methodLabel: 'Biometric',
    isCurrent: true,
  ),
  P2PLoginEventDraft(
    id: 'login_macbook',
    timestamp: '2026-03-05 10:15:33',
    deviceType: 'desktop',
    deviceName: 'MacBook Pro',
    os: 'macOS 14.3',
    browser: 'Chrome 121',
    city: 'TP.HCM',
    country: 'VN',
    ip: '113.161.78.90',
    status: 'success',
    statusLabel: 'Thành công',
    method: '2fa',
    methodLabel: '2FA',
    isCurrent: false,
  ),
  P2PLoginEventDraft(
    id: 'login_samsung_s24',
    timestamp: '2026-03-04 22:45:10',
    deviceType: 'mobile',
    deviceName: 'Samsung Galaxy S24',
    os: 'Android 14',
    browser: 'Chrome Mobile',
    city: 'Đà Nẵng',
    country: 'VN',
    ip: '14.231.56.12',
    status: 'success',
    statusLabel: 'Thành công',
    method: 'password',
    methodLabel: 'Password',
    isCurrent: false,
  ),
  P2PLoginEventDraft(
    id: 'login_windows_suspicious',
    timestamp: '2026-03-04 15:20:05',
    deviceType: 'desktop',
    deviceName: 'Windows PC',
    os: 'Windows 11',
    browser: 'Edge',
    city: 'Singapore',
    country: 'SG',
    ip: '103.45.78.21',
    status: 'suspicious',
    statusLabel: 'Đáng ngờ',
    method: 'password',
    methodLabel: 'Password',
    isCurrent: false,
  ),
  P2PLoginEventDraft(
    id: 'login_unknown_failed',
    timestamp: '2026-03-04 08:10:44',
    deviceType: 'mobile',
    deviceName: 'Unknown Device',
    os: 'Android 12',
    browser: 'Chrome',
    city: 'Bangkok',
    country: 'TH',
    ip: '101.99.12.88',
    status: 'failed',
    statusLabel: 'Thất bại',
    method: 'password',
    methodLabel: 'Password',
    isCurrent: false,
  ),
];

const List<String> _p2pLoginHistorySecurityTips = [
  'Lịch sử được lưu trong 90 ngày',
  'Kiểm tra thường xuyên để phát hiện truy cập trái phép',
  'Báo ngay cho Support nếu thấy hoạt động đáng ngờ',
];

const List<P2PSuspiciousAlertDraft> _p2pSuspiciousAlerts = [
  P2PSuspiciousAlertDraft(
    id: 'suspicious_login_singapore',
    type: 'login',
    message: 'Đăng nhập từ vị trí lạ: Singapore',
    timestamp: '2026-03-05 14:20',
    severity: 'high',
    reviewed: false,
  ),
  P2PSuspiciousAlertDraft(
    id: 'suspicious_transaction_100m',
    type: 'transaction',
    message: 'Giao dịch bất thường: 100M VND',
    timestamp: '2026-03-04 18:30',
    severity: 'medium',
    reviewed: false,
  ),
  P2PSuspiciousAlertDraft(
    id: 'suspicious_device_android',
    type: 'device',
    message: 'Thiết bị mới: Unknown Android',
    timestamp: '2026-03-03 09:15',
    severity: 'low',
    reviewed: true,
  ),
];

const List<P2PE2EInfoItemDraft> _p2pE2EInfoItems = [
  P2PE2EInfoItemDraft(
    id: 'aes_rsa',
    iconKey: 'lock',
    title: 'AES-256 + RSA-2048',
    description:
        'Tin nhắn được mã hóa bằng khóa duy nhất cho mỗi cuộc trò chuyện. Ngay cả VitTrade cũng không thể đọc nội dung.',
    toneKey: 'p2p',
  ),
  P2PE2EInfoItemDraft(
    id: 'session_keys',
    iconKey: 'key',
    title: 'Khóa phiên tạm thời',
    description:
        'Mỗi phiên chat tạo khóa mới. Khóa cũ tự động hủy sau khi đơn hàng hoàn thành, đảm bảo Forward Secrecy.',
    toneKey: 'accent',
  ),
  P2PE2EInfoItemDraft(
    id: 'identity',
    iconKey: 'verified',
    title: 'Xác minh danh tính',
    description:
        'Đối tác đã được xác minh KYC. Tin nhắn chỉ giao tiếp với người dùng đã xác thực.',
    toneKey: 'success',
  ),
  P2PE2EInfoItemDraft(
    id: 'security_warning',
    iconKey: 'warning',
    title: 'Cảnh báo bảo mật',
    description:
        'Không chia sẻ mật khẩu, OTP, seed phrase hay thông tin nhạy cảm qua chat. VitTrade sẽ không bao giờ yêu cầu.',
    toneKey: 'warning',
  ),
];

const List<P2PE2EStepDraft> _p2pE2ESteps = [
  P2PE2EStepDraft(
    id: 'create_keys',
    step: '1',
    title: 'Tạo khóa',
    description: 'Khi bắt đầu chat, cặp khóa RSA-2048 được tạo trên thiết bị',
  ),
  P2PE2EStepDraft(
    id: 'exchange_keys',
    step: '2',
    title: 'Trao đổi khóa',
    description: 'Khóa công khai được trao đổi an toàn qua kênh xác thực',
  ),
  P2PE2EStepDraft(
    id: 'encrypt_messages',
    step: '3',
    title: 'Mã hóa tin nhắn',
    description: 'Mỗi tin nhắn được mã hóa AES-256 với khóa phiên duy nhất',
  ),
  P2PE2EStepDraft(
    id: 'safe_decrypt',
    step: '4',
    title: 'Giải mã an toàn',
    description: 'Chỉ khóa riêng trên thiết bị đối tác mới có thể giải mã',
  ),
];

const List<P2PScamPatternDraft> _p2pFraudPatterns = [
  P2PScamPatternDraft(
    id: 'fake_payment',
    title: 'Bằng chứng thanh toán giả',
    severity: 'critical',
    description:
        'Đối tác gửi screenshot chuyển khoản giả để lừa bạn giải phóng coin',
    howItWorks: [
      'Tạo đơn mua coin trên P2P',
      'Gửi ảnh chuyển khoản chỉnh sửa hoặc giả mạo',
      'Yêu cầu bạn giải phóng coin ngay',
      'Coin bị mất, tiền không bao giờ đến',
    ],
    redFlags: [
      'Thúc giục giải phóng coin nhanh bất thường',
      'Screenshot thanh toán mờ hoặc bị crop',
      'Số tiền trên screenshot không khớp',
      'Tên người chuyển không khớp với tài khoản P2P',
    ],
    prevention: [
      'Luôn kiểm tra tài khoản ngân hàng trước khi giải phóng',
      'Chờ tiền có trong tài khoản, không chỉ nhìn SMS hoặc screenshot',
      'So sánh tên, số tiền và mã giao dịch chính xác',
      'Bấm Đã nhận chỉ khi tiền thực sự đã vào tài khoản',
    ],
    iconKey: 'payment',
  ),
  P2PScamPatternDraft(
    id: 'off_platform',
    title: 'Giao dịch ngoài nền tảng',
    severity: 'critical',
    description: 'Đối tác dụ giao dịch ngoài hệ thống để tránh escrow bảo vệ',
    howItWorks: [
      'Liên hệ qua Zalo hoặc Telegram ngoài chat P2P',
      'Đưa ra mức giá tốt hơn để dụ giao dịch trực tiếp',
      'Khi chuyển tiền hoặc coin, đối phương biến mất',
      'Không có escrow nên không thể dispute hoặc claim bảo hiểm',
    ],
    redFlags: [
      'Yêu cầu liên hệ qua kênh ngoài',
      'Đề nghị giá tốt hơn thị trường',
      'Yêu cầu chuyển coin hoặc tiền trực tiếp',
      'Hứa hẹn nhanh hơn, không cần quy trình',
    ],
    prevention: [
      'Không giao dịch ngoài nền tảng',
      'Mọi thanh toán phải qua flow P2P có escrow',
      'Report ngay nếu bị yêu cầu giao dịch ngoài',
      'Chỉ chat trong hệ thống vì tin nhắn ngoài không được bảo vệ',
    ],
    iconKey: 'globe',
  ),
  P2PScamPatternDraft(
    id: 'chargeback',
    title: 'Chargeback sau giao dịch',
    severity: 'high',
    description:
        'Buyer chuyển tiền rồi làm chargeback qua ngân hàng sau khi nhận coin',
    howItWorks: [
      'Buyer chuyển khoản thật sự qua ngân hàng',
      'Seller xác nhận nhận tiền và giải phóng coin',
      'Buyer liên hệ ngân hàng yêu cầu hoàn tiền',
      'Seller mất cả coin lẫn tiền',
    ],
    redFlags: [
      'Buyer mới, ít giao dịch nhưng order lớn',
      'Thúc giục giải phóng coin rất nhanh',
      'Completion rate thấp bất thường',
      'Không chịu dùng phương thức thanh toán thông thường',
    ],
    prevention: [
      'Chỉ giao dịch với buyer có rating và lịch sử tốt',
      'Cẩn thận với đơn giá trị lớn từ tài khoản mới',
      'Lưu trữ mọi bằng chứng giao dịch',
      'Nếu bị chargeback, gửi claim bảo hiểm ngay trong 7 ngày',
    ],
    iconKey: 'bank',
  ),
  P2PScamPatternDraft(
    id: 'impersonation',
    title: 'Mạo danh nhân viên sàn',
    severity: 'high',
    description:
        'Kẻ lừa đảo giả danh admin hoặc nhân viên sàn để lừa lấy thông tin',
    howItWorks: [
      'Liên hệ qua Telegram hoặc Zalo giả danh nhân viên hỗ trợ',
      'Thông báo tài khoản bị khóa hoặc cần xác minh',
      'Yêu cầu cung cấp mật khẩu, mã OTP hoặc seed phrase',
      'Chiếm quyền tài khoản hoặc rút hết coin',
    ],
    redFlags: [
      'Nhân viên liên hệ qua kênh ngoài',
      'Yêu cầu mật khẩu hoặc mã OTP',
      'Tạo cảm giác khẩn cấp phải làm ngay',
      'Link lạ yêu cầu đăng nhập',
    ],
    prevention: [
      'Nhân viên sàn không bao giờ yêu cầu mật khẩu hoặc OTP',
      'Chỉ liên hệ hỗ trợ qua kênh chính thức trong app',
      'Thiết lập Anti-Phishing Code để nhận diện email thật',
      'Không bấm link lạ, kiểm tra domain chính xác',
    ],
    iconKey: 'user',
  ),
  P2PScamPatternDraft(
    id: 'triangle_scam',
    title: 'Gian lận tam giác',
    severity: 'medium',
    description:
        'Kẻ lừa đảo dùng tiền từ nạn nhân khác để thanh toán đơn P2P của bạn',
    howItWorks: [
      'Kẻ lừa đảo tạo đơn mua coin từ seller',
      'Dụ nạn nhân chuyển tiền vào tài khoản seller',
      'Seller tưởng buyer đã thanh toán và giải phóng coin',
      'Nạn nhân report ngân hàng khiến seller bị khóa tài khoản',
    ],
    redFlags: [
      'Tên người chuyển không khớp với tên tài khoản P2P',
      'Lý do chuyển khoản ghi lạ hoặc không liên quan',
      'Yêu cầu xác nhận bằng mã ngoài hệ thống',
    ],
    prevention: [
      'Kiểm tra tên người chuyển phải khớp với tên P2P',
      'Nếu tên không khớp, không giải phóng và mở dispute',
      'Lưu trữ sao kê ngân hàng mọi giao dịch P2P',
    ],
    iconKey: 'triangle',
  ),
];

const List<P2PSafetyChecklistItemDraft> _p2pFraudChecklist = [
  P2PSafetyChecklistItemDraft(
    id: 'ck1',
    label: '2FA đã bật',
    description: 'Bảo vệ tài khoản bằng 2FA',
    checked: true,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck2',
    label: 'Anti-Phishing Code đã thiết lập',
    description: 'Nhận diện email thật từ sàn',
    checked: false,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck3',
    label: 'Kiểm tra rating đối tác',
    description: 'Chỉ giao dịch với merchant uy tín',
    checked: true,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck4',
    label: 'Xác nhận payment method hợp lệ',
    description: 'Phương thức thanh toán được hỗ trợ',
    checked: true,
    category: 'before',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck5',
    label: 'Kiểm tra tên người chuyển',
    description: 'Tên phải khớp với tên P2P',
    checked: false,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck6',
    label: 'Chỉ bấm "Đã nhận" khi tiền thật vào TK',
    description: 'Không tin screenshot',
    checked: true,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck7',
    label: 'Không giao dịch ngoài nền tảng',
    description: 'Mọi thao tác trong app',
    checked: true,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck8',
    label: 'Lưu bằng chứng giao dịch',
    description: 'Screenshot chat, sao kê ngân hàng',
    checked: false,
    category: 'during',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck9',
    label: 'Review đối tác sau giao dịch',
    description: 'Giúp cộng đồng nhận diện scam',
    checked: true,
    category: 'after',
  ),
  P2PSafetyChecklistItemDraft(
    id: 'ck10',
    label: 'Biết cách gửi claim bảo hiểm',
    description: 'Nắm rõ quy trình trong 7 ngày',
    checked: false,
    category: 'after',
  ),
];

const List<P2PFraudEmergencyActionDraft> _p2pFraudEmergencyActions = [
  P2PFraudEmergencyActionDraft(
    id: 'insurance_claim',
    label: 'Gửi yêu cầu bồi thường bảo hiểm',
    route: '/p2p/insurance-fund',
    toneKey: 'danger',
    iconKey: 'shield',
  ),
  P2PFraudEmergencyActionDraft(
    id: 'support',
    label: 'Liên hệ hỗ trợ khẩn cấp',
    route: '/support',
    toneKey: 'warning',
    iconKey: 'phone',
  ),
  P2PFraudEmergencyActionDraft(
    id: 'report_merchant',
    label: 'Report merchant gian lận',
    route: '/p2p/report/mc001',
    toneKey: 'muted',
    iconKey: 'flag',
  ),
];

const List<P2PWalletTransferAssetDraft> _p2pWalletTransferAssets = [
  P2PWalletTransferAssetDraft(symbol: 'USDT', name: 'Tether'),
  P2PWalletTransferAssetDraft(symbol: 'BTC', name: 'Bitcoin'),
  P2PWalletTransferAssetDraft(symbol: 'VND', name: 'Vietnamese Dong'),
];

const List<P2PWalletTransferBalanceDraft> _p2pWalletTransferBalances = [
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'USDT',
    available: 45200,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'USDT',
    available: 12450.50,
    balanceLabel: 'Số dư',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'BTC',
    available: .1234,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'BTC',
    available: .0524,
    balanceLabel: 'Số dư',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'VND',
    available: 120000000,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'VND',
    available: 45600000,
    balanceLabel: 'Số dư',
  ),
];

const List<P2PFundLockRecordDraft> _p2pFundLockRecords = [
  P2PFundLockRecordDraft(
    id: 'fund_lock_45892',
    type: 'lock',
    asset: 'USDT',
    amount: 1500,
    reason: 'Order #45892 created',
    timestamp: '2026-03-05 14:20',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_unlock_45880',
    type: 'unlock',
    asset: 'USDT',
    amount: 1000,
    reason: 'Order #45880 completed',
    timestamp: '2026-03-05 13:45',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_lock_45870',
    type: 'lock',
    asset: 'BTC',
    amount: .01,
    reason: 'Order #45870 created',
    timestamp: '2026-03-05 10:30',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_unlock_45850',
    type: 'unlock',
    asset: 'VND',
    amount: 12000000,
    reason: 'Order #45850 released',
    timestamp: '2026-03-04 16:20',
  ),
];

const List<P2PWalletBalanceDraft> _p2pWalletBalances = [
  P2PWalletBalanceDraft(
    asset: 'USDT',
    available: 12450.50,
    inEscrow: 3200,
    locked: 500,
    total: 16150.50,
    usdValue: 16150.50,
  ),
  P2PWalletBalanceDraft(
    asset: 'BTC',
    available: .0524,
    inEscrow: .01,
    locked: 0,
    total: .0624,
    usdValue: 4243.20,
  ),
  P2PWalletBalanceDraft(
    asset: 'VND',
    available: 45600000,
    inEscrow: 12000000,
    locked: 0,
    total: 57600000,
    usdValue: 2400,
  ),
];

const List<P2PWalletTransactionDraft> _p2pWalletTransactions = [
  P2PWalletTransactionDraft(
    id: 'tx_escrow_release_45892',
    type: 'escrow_release',
    asset: 'USDT',
    amount: 1500,
    status: 'completed',
    time: '10 phút trước',
    orderId: '#P2P-45892',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_transfer_in_5000',
    type: 'transfer_in',
    asset: 'USDT',
    amount: 5000,
    status: 'completed',
    time: '2 giờ trước',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_escrow_lock_45880',
    type: 'escrow_lock',
    asset: 'BTC',
    amount: .01,
    status: 'pending',
    time: '3 giờ trước',
    orderId: '#P2P-45880',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_transfer_out_vnd',
    type: 'transfer_out',
    asset: 'VND',
    amount: 10000000,
    status: 'completed',
    time: '1 ngày trước',
  ),
];

const List<P2PLimitUsageDraft> _p2pLimitTrackerUsages = [
  P2PLimitUsageDraft(
    period: 'daily',
    label: 'Hôm nay',
    used: 35000000,
    limit: 50000000,
    percentage: 70,
  ),
  P2PLimitUsageDraft(
    period: 'weekly',
    label: 'Tuần',
    used: 180000000,
    limit: 300000000,
    percentage: 60,
  ),
  P2PLimitUsageDraft(
    period: 'monthly',
    label: 'Tháng',
    used: 650000000,
    limit: 1000000000,
    percentage: 65,
  ),
];

const List<P2PLimitBreakdownDraft> _p2pLimitTrackerBreakdown = [
  P2PLimitBreakdownDraft(date: '05/03', buy: 20000000, sell: 15000000),
  P2PLimitBreakdownDraft(date: '04/03', buy: 30000000, sell: 10000000),
  P2PLimitBreakdownDraft(date: '03/03', buy: 25000000, sell: 20000000),
  P2PLimitBreakdownDraft(date: '02/03', buy: 15000000, sell: 25000000),
];

const P2PTransactionLimitTierDraft _p2pTransactionLimitTier1 =
    P2PTransactionLimitTierDraft(
      tier: 1,
      name: 'Basic',
      statusLabel: 'Đang dùng',
      dailyBuy: 50000000,
      dailySell: 50000000,
      weeklyTotal: 300000000,
      monthlyTotal: 1000000000,
      perTransaction: 20000000,
      requirements: ['KYC Basic (CMND/CCCD)'],
    );

const P2PTransactionLimitTierDraft _p2pTransactionLimitTier2 =
    P2PTransactionLimitTierDraft(
      tier: 2,
      name: 'Intermediate',
      statusLabel: 'Có thể nâng cấp',
      dailyBuy: 200000000,
      dailySell: 200000000,
      weeklyTotal: 1200000000,
      monthlyTotal: 4000000000,
      perTransaction: 100000000,
      requirements: [
        'KYC Intermediate',
        'Proof of Address',
        'Selfie Verification',
      ],
    );

const List<P2PTransactionLimitUsageDraft> _p2pTransactionLimitUsages = [
  P2PTransactionLimitUsageDraft(
    id: 'daily_buy',
    label: 'Mua hôm nay',
    current: 35000000,
    max: 50000000,
    toneKey: 'buy',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'daily_sell',
    label: 'Bán hôm nay',
    current: 15000000,
    max: 50000000,
    toneKey: 'sell',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'weekly',
    label: 'Tuần này',
    current: 180000000,
    max: 300000000,
    toneKey: 'accent',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'monthly',
    label: 'Tháng này',
    current: 650000000,
    max: 1000000000,
    toneKey: 'warning',
  ),
];

const List<P2PTransactionLimitDetailDraft> _p2pTransactionLimitDetails = [
  P2PTransactionLimitDetailDraft(
    id: 'daily_buy',
    label: 'Mua tối đa/ngày',
    value: 50000000,
    toneKey: 'buy',
    iconKey: 'trend',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'daily_sell',
    label: 'Bán tối đa/ngày',
    value: 50000000,
    toneKey: 'sell',
    iconKey: 'trend',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'weekly',
    label: 'Tổng/tuần',
    value: 300000000,
    toneKey: 'accent',
    iconKey: 'calendar',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'monthly',
    label: 'Tổng/tháng',
    value: 1000000000,
    toneKey: 'warning',
    iconKey: 'calendar',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'per_transaction',
    label: 'Tối đa/giao dịch',
    value: 20000000,
    toneKey: 'danger',
    iconKey: 'amount',
  ),
];

const List<String> _p2pTransactionLimitInfoBullets = [
  'Giới hạn reset vào 00:00 UTC+7 mỗi ngày/tuần/tháng',
  'Giới hạn áp dụng cho cả Buy và Sell orders',
  'Số tiền đang trong escrow không tính vào giới hạn',
  'Giới hạn có thể thay đổi theo chính sách compliance',
];

const List<P2PComplianceItemDraft> _p2pComplianceOverviewItems = [
  P2PComplianceItemDraft(
    id: 'kyc',
    label: 'KYC Status',
    value: 'Tier 1 Basic',
    status: 'active',
    iconKey: 'shield',
    route: '/p2p/kyc/status',
  ),
  P2PComplianceItemDraft(
    id: 'aml',
    label: 'AML Screening',
    value: 'Low Risk',
    status: 'active',
    iconKey: 'file',
    route: '/p2p/compliance/aml-screening',
  ),
  P2PComplianceItemDraft(
    id: 'limits',
    label: 'Transaction Limits',
    value: '50M/ngày',
    status: 'active',
    iconKey: 'trend',
    route: '/p2p/limits',
  ),
  P2PComplianceItemDraft(
    id: 'sof',
    label: 'Source of Funds',
    value: 'Đã khai báo',
    status: 'active',
    iconKey: 'money',
    route: '/p2p/compliance/source-of-funds',
  ),
];

const List<P2PAmlCheckDraft> _p2pAmlScreeningChecks = [
  P2PAmlCheckDraft(
    id: 'sanctions',
    name: 'Sanctions List',
    status: 'pass',
    detail: 'No match found',
  ),
  P2PAmlCheckDraft(
    id: 'pep',
    name: 'PEP Check',
    status: 'pass',
    detail: 'Not a PEP',
  ),
  P2PAmlCheckDraft(
    id: 'adverse_media',
    name: 'Adverse Media',
    status: 'pass',
    detail: 'No negative news',
  ),
  P2PAmlCheckDraft(
    id: 'transaction_pattern',
    name: 'Transaction Pattern',
    status: 'review',
    detail: 'Under periodic review',
  ),
];

const List<P2PFundSourceDraft> _p2pFundSources = [
  P2PFundSourceDraft(
    id: 'salary',
    label: 'Lương/Thu nhập',
    iconKey: 'briefcase',
  ),
  P2PFundSourceDraft(id: 'business', label: 'Kinh doanh', iconKey: 'trend'),
  P2PFundSourceDraft(id: 'investment', label: 'Đầu tư', iconKey: 'money'),
  P2PFundSourceDraft(id: 'property', label: 'Bất động sản', iconKey: 'home'),
  P2PFundSourceDraft(id: 'gift', label: 'Quà tặng/Thừa kế', iconKey: 'gift'),
];

const List<String> _p2pLargeTransactionPurposes = [
  'Mua crypto để đầu tư dài hạn',
  'Trading ngắn hạn',
  'Thanh toán quốc tế',
  'Chuyển đổi tài sản',
  'Khác (ghi rõ)',
];

const List<P2PRiskFactorDraft> _p2pRiskFactors = [
  P2PRiskFactorDraft(
    id: 'kyc',
    label: 'KYC Level',
    value: 'Tier 1',
    risk: 'low',
    score: 5,
  ),
  P2PRiskFactorDraft(
    id: 'history',
    label: 'Transaction History',
    value: '156 đơn, 97.2% HT',
    risk: 'low',
    score: 3,
  ),
  P2PRiskFactorDraft(
    id: 'aml',
    label: 'AML Screening',
    value: 'Passed all checks',
    risk: 'low',
    score: 2,
  ),
  P2PRiskFactorDraft(
    id: 'disputes',
    label: 'Disputes',
    value: '1 vụ/156 đơn',
    risk: 'low',
    score: 3,
  ),
  P2PRiskFactorDraft(
    id: 'velocity',
    label: 'Transaction Velocity',
    value: 'Normal',
    risk: 'low',
    score: 2,
  ),
];

const List<int> _p2pTaxYears = [2026, 2025, 2024, 2023];

const List<P2PTaxJurisdictionDraft> _p2pTaxJurisdictions = [
  P2PTaxJurisdictionDraft(code: 'US', name: 'United States', form: 'Form 1099'),
  P2PTaxJurisdictionDraft(
    code: 'EU',
    name: 'European Union',
    form: 'Tax Certificate',
  ),
  P2PTaxJurisdictionDraft(code: 'UK', name: 'United Kingdom', form: 'P60/P45'),
  P2PTaxJurisdictionDraft(code: 'VN', name: 'Vietnam', form: 'Tax Declaration'),
];

const P2PTaxSummaryDraft _p2pTaxSummary2025 = P2PTaxSummaryDraft(
  totalTransactions: 156,
  totalVolumeLabel: '1.250M',
  capitalGainsLabel: '+45M',
  capitalLossesLabel: '-12M',
  netGainsLabel: '33M VND',
  generatedAt: '2026-01-15',
);

const List<P2PTaxDocumentDraft> _p2pTaxDocuments2025 = [
  P2PTaxDocumentDraft(
    id: 'form',
    title: 'Form 1099',
    subtitle: 'Generated 2026-01-15',
    format: 'PDF',
    toneKey: 'success',
  ),
  P2PTaxDocumentDraft(
    id: 'csv',
    title: 'Transaction History (CSV)',
    subtitle: 'All transactions for 2025',
    format: 'CSV',
    toneKey: 'primary',
  ),
  P2PTaxDocumentDraft(
    id: 'txf',
    title: 'TurboTax Export (TXF)',
    subtitle: 'Import to TurboTax/TaxAct',
    format: 'TXF',
    toneKey: 'warning',
  ),
];

const List<P2POrderBookMarketDraft> _p2pOrderBookMarkets = [
  P2POrderBookMarketDraft(
    asset: 'USDT',
    lastPriceVnd: 25300,
    changePct: .80,
    high24hVnd: 25450,
    low24hVnd: 25180,
    volume24hLabel: '2.45B',
    trades24h: 1243,
  ),
  P2POrderBookMarketDraft(
    asset: 'BTC',
    lastPriceVnd: 1715000000,
    changePct: -2.30,
    high24hVnd: 1755000000,
    low24hVnd: 1698000000,
    volume24hLabel: '85B',
    trades24h: 892,
  ),
  P2POrderBookMarketDraft(
    asset: 'ETH',
    lastPriceVnd: 89000000,
    changePct: 3.50,
    high24hVnd: 91200000,
    low24hVnd: 86500000,
    volume24hLabel: '12.5B',
    trades24h: 654,
  ),
  P2POrderBookMarketDraft(
    asset: 'BNB',
    lastPriceVnd: 15200000,
    changePct: 1.20,
    high24hVnd: 15450000,
    low24hVnd: 15050000,
    volume24hLabel: '4.2B',
    trades24h: 421,
  ),
  P2POrderBookMarketDraft(
    asset: 'SOL',
    lastPriceVnd: 4800000,
    changePct: -1.50,
    high24hVnd: 4920000,
    low24hVnd: 4750000,
    volume24hLabel: '1.85B',
    trades24h: 387,
  ),
];

const List<P2POrderBookEntryDraft> _p2pOrderBookBids = [
  P2POrderBookEntryDraft(
    priceVnd: 25224.1,
    volume: 149.9880,
    total: 149.9880,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25200,
    volume: 161.2992,
    total: 311.2872,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25180,
    volume: 153.1690,
    total: 464.4562,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25160,
    volume: 122.1745,
    total: 586.6307,
    orders: 5,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25130,
    volume: 530.8145,
    total: 1117.4452,
    orders: 7,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25110,
    volume: 308.5426,
    total: 1425.9878,
    orders: 6,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25090,
    volume: 113.8138,
    total: 1539.8016,
    orders: 2,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25060,
    volume: 496.5048,
    total: 2036.3064,
    orders: 8,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25040,
    volume: 221.2488,
    total: 2257.5552,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25020,
    volume: 189.4260,
    total: 2446.9812,
    orders: 5,
  ),
];

const List<P2POrderBookEntryDraft> _p2pOrderBookAsks = [
  P2POrderBookEntryDraft(
    priceVnd: 25375.9,
    volume: 228.1104,
    total: 228.1104,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25400,
    volume: 238.2529,
    total: 466.3633,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25420,
    volume: 537.6315,
    total: 1003.9948,
    orders: 7,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25440,
    volume: 239.3836,
    total: 1243.3784,
    orders: 5,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25470,
    volume: 204.2349,
    total: 1447.6133,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25490,
    volume: 139.0445,
    total: 1586.6578,
    orders: 2,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25510,
    volume: 193.9158,
    total: 1780.5736,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25540,
    volume: 374.8984,
    total: 2155.4720,
    orders: 6,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25560,
    volume: 351.3147,
    total: 2506.7867,
    orders: 7,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25580,
    volume: 516.0706,
    total: 3022.8573,
    orders: 9,
  ),
];

const List<P2PDashboardFilterDraft> _p2pDashboardFilters = [
  P2PDashboardFilterDraft(id: '7d', label: '7 ngày'),
  P2PDashboardFilterDraft(id: '30d', label: '30 ngày'),
  P2PDashboardFilterDraft(id: 'all', label: 'Tất cả'),
];

const P2PDashboardStatsDraft _p2pDashboardStats = P2PDashboardStatsDraft(
  totalOrders: 78,
  completedOrders: 64,
  cancelledOrders: 8,
  disputedOrders: 2,
  completionRate: 82.1,
  avgCompletionTime: '8 phút',
  totalVolume7d: 89500000,
  totalVolume30d: 385000000,
  totalVolumeAll: 1250000000,
  buyVolume30d: 245000000,
  sellVolume30d: 140000000,
  spreadRevenue30d: 1850000,
  avgOrderSize: 16200000,
  uniqueCounterparties: 23,
  repeatCustomerRate: 34.8,
  avgRatingReceived: 4.8,
  positiveReviewRate: 95.3,
  responseTimeAvg: '4 phút',
  platformAvgCompletionRate: 94.5,
  platformAvgResponseTime: '6 phút',
);

const List<P2PDashboardSeriesPointDraft> _p2pDashboardWeeklyVolume = [
  P2PDashboardSeriesPointDraft(label: 'T1', value: 45000000),
  P2PDashboardSeriesPointDraft(label: 'T2', value: 72000000),
  P2PDashboardSeriesPointDraft(label: 'T3', value: 98000000),
  P2PDashboardSeriesPointDraft(label: 'T4', value: 120000000),
  P2PDashboardSeriesPointDraft(label: 'T5', value: 85000000),
  P2PDashboardSeriesPointDraft(label: 'T6', value: 135000000),
  P2PDashboardSeriesPointDraft(label: 'T7', value: 68000000),
  P2PDashboardSeriesPointDraft(label: 'T8', value: 89500000),
];

const List<P2PDashboardMonthlyOrdersDraft> _p2pDashboardMonthlyOrders = [
  P2PDashboardMonthlyOrdersDraft(month: 'T9', buy: 4, sell: 2),
  P2PDashboardMonthlyOrdersDraft(month: 'T10', buy: 6, sell: 5),
  P2PDashboardMonthlyOrdersDraft(month: 'T11', buy: 8, sell: 4),
  P2PDashboardMonthlyOrdersDraft(month: 'T12', buy: 10, sell: 7),
  P2PDashboardMonthlyOrdersDraft(month: 'T1', buy: 12, sell: 6),
  P2PDashboardMonthlyOrdersDraft(month: 'T2', buy: 9, sell: 5),
];

const List<P2PDashboardAssetDraft> _p2pDashboardAssetDistribution = [
  P2PDashboardAssetDraft(asset: 'USDT', percentage: 72, volume: 277200000),
  P2PDashboardAssetDraft(asset: 'BTC', percentage: 18, volume: 69300000),
  P2PDashboardAssetDraft(asset: 'ETH', percentage: 6, volume: 23100000),
  P2PDashboardAssetDraft(asset: 'BNB', percentage: 3, volume: 11550000),
  P2PDashboardAssetDraft(asset: 'SOL', percentage: 1, volume: 3850000),
];

const P2PDashboardLevelDraft _p2pDashboardCurrentLevel = P2PDashboardLevelDraft(
  id: 3,
  name: 'Advanced',
  dailyUsed: 45500000,
  dailyLimit: 500000000,
  progress: .42,
  requirements: [],
);

const P2PDashboardLevelDraft _p2pDashboardNextLevel = P2PDashboardLevelDraft(
  id: 4,
  name: 'VIP',
  dailyUsed: 45500000,
  dailyLimit: 500000000,
  progress: .42,
  requirements: [
    'KYC Lv.2',
    '2FA đã bật',
    'Volume > 5 tỷ VND',
    '200+ giao dịch hoàn tất',
  ],
);

const List<P2PDashboardComparisonDraft> _p2pDashboardPlatformComparisons = [
  P2PDashboardComparisonDraft(
    label: 'Tỷ lệ hoàn thành',
    yours: 82.1,
    platform: 94.5,
    suffix: '%',
  ),
  P2PDashboardComparisonDraft(
    label: 'Phản hồi trung bình',
    yours: 4,
    platform: 6,
    suffix: ' phút',
    lowerBetter: true,
  ),
  P2PDashboardComparisonDraft(
    label: 'Đánh giá nhận được',
    yours: 4.8,
    platform: 4.3,
    suffix: '/5.0',
  ),
  P2PDashboardComparisonDraft(
    label: 'Tỷ lệ review tích cực',
    yours: 95.3,
    platform: 91,
    suffix: '%',
  ),
];

const List<P2PDashboardMerchantDraft> _p2pDashboardTopMerchants = [
  P2PDashboardMerchantDraft(
    id: 'mc001',
    name: 'CryptoKing_VN',
    trades: 15,
    volume: 127000000,
    rating: 4.8,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc004',
    name: 'VIPTrader_HN',
    trades: 12,
    volume: 98000000,
    rating: 4.9,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc002',
    name: 'TradeMaster99',
    trades: 8,
    volume: 62000000,
    rating: 4.2,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc006',
    name: 'BTCWhale_VN',
    trades: 5,
    volume: 85750000,
    rating: 4.9,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc005',
    name: 'FastTrade_SG',
    trades: 4,
    volume: 32000000,
    rating: 4.6,
  ),
];

const List<P2PDashboardActivityDraft> _p2pDashboardRecentActivity = [
  P2PDashboardActivityDraft(
    date: '23/02 11:00',
    type: 'buy',
    asset: 'USDT',
    amount: 200,
    total: 5070000,
    merchant: 'CryptoKing_VN',
    status: 'pending_payment',
  ),
  P2PDashboardActivityDraft(
    date: '23/02 09:15',
    type: 'sell',
    asset: 'USDT',
    amount: 500,
    total: 12640000,
    merchant: 'VIPTrader_HN',
    status: 'paid',
  ),
  P2PDashboardActivityDraft(
    date: '22/02 14:30',
    type: 'buy',
    asset: 'USDT',
    amount: 1000,
    total: 25300000,
    merchant: 'TradeMaster99',
    status: 'released',
  ),
  P2PDashboardActivityDraft(
    date: '21/02 16:45',
    type: 'buy',
    asset: 'USDT',
    amount: 150,
    total: 3810000,
    merchant: 'CoinHunter_HCM',
    status: 'released',
  ),
  P2PDashboardActivityDraft(
    date: '18/02 12:00',
    type: 'buy',
    asset: 'BTC',
    amount: .05,
    total: 85750000,
    merchant: 'BTCWhale_VN',
    status: 'released',
  ),
];

const List<P2PDashboardQuickActionDraft> _p2pDashboardQuickActions = [
  P2PDashboardQuickActionDraft(
    id: 'orders',
    label: 'Đơn hàng',
    route: '/p2p/my-orders',
    iconKey: 'orders',
  ),
  P2PDashboardQuickActionDraft(
    id: 'reviews',
    label: 'Đánh giá',
    route: '/p2p/reviews',
    iconKey: 'reviews',
  ),
  P2PDashboardQuickActionDraft(
    id: 'ads',
    label: 'Quảng cáo',
    route: '/p2p/my-ads',
    iconKey: 'ads',
  ),
  P2PDashboardQuickActionDraft(
    id: 'express',
    label: 'Express',
    route: '/p2p/express',
    iconKey: 'express',
  ),
];

const List<P2PAchievementCategoryDraft> _p2pAchievementCategories = [
  P2PAchievementCategoryDraft(id: 'trades', label: 'Giao dịch'),
  P2PAchievementCategoryDraft(id: 'volume', label: 'Khối lượng'),
  P2PAchievementCategoryDraft(id: 'trust', label: 'Uy tín'),
  P2PAchievementCategoryDraft(id: 'special', label: 'Đặc biệt'),
];

const List<P2PAchievementDraft> _p2pAchievements = [
  P2PAchievementDraft(
    id: 'ach001',
    title: 'Giao dịch đầu tiên',
    description: 'Hoàn thành giao dịch P2P đầu tiên',
    iconKey: 'bolt',
    toneKey: 'primary',
    progress: 1,
    currentValueLabel: '1/1 giao dịch',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-01-15',
    reward: '+5 điểm uy tín',
    rewardType: 'reputation',
    reputationPointsReward: 5,
    categoryId: 'trades',
  ),
  P2PAchievementDraft(
    id: 'ach002',
    title: 'Trader bền bỉ',
    description: 'Hoàn thành 50 giao dịch thành công',
    iconKey: 'target',
    toneKey: 'success',
    progress: 1,
    currentValueLabel: '50/50 giao dịch',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-02-10',
    reward: '+15 điểm uy tín',
    rewardType: 'reputation',
    reputationPointsReward: 15,
    categoryId: 'trades',
  ),
  P2PAchievementDraft(
    id: 'ach003',
    title: 'Bách chiến bách thắng',
    description: 'Hoàn thành 100 giao dịch thành công',
    iconKey: 'medal',
    toneKey: 'warning',
    progress: .78,
    currentValueLabel: '78/100 giao dịch',
    progressLabel: '78%',
    unlocked: false,
    reward: '+30 điểm uy tín',
    rewardType: 'reputation',
    categoryId: 'trades',
  ),
  P2PAchievementDraft(
    id: 'ach004',
    title: 'Volume 100M',
    description: 'Tổng khối lượng giao dịch đạt 100M VND',
    iconKey: 'trend',
    toneKey: 'accent',
    progress: 1,
    currentValueLabel: '100/100 triệu VND',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-02-15',
    reward: 'Giảm phí 0.05%',
    rewardType: 'fee',
    categoryId: 'volume',
  ),
  P2PAchievementDraft(
    id: 'ach005',
    title: 'Volume 500M',
    description: 'Tổng khối lượng giao dịch đạt 500M VND',
    iconKey: 'trend',
    toneKey: 'accent',
    progress: .42,
    currentValueLabel: '210/500 triệu VND',
    progressLabel: '42%',
    unlocked: false,
    reward: 'Giảm phí 0.10%',
    rewardType: 'fee',
    categoryId: 'volume',
  ),
  P2PAchievementDraft(
    id: 'ach006',
    title: 'Tỷ lệ hoàn tất 98%+',
    description: 'Duy trì tỷ lệ hoàn tất trên 98% với ≥20 giao dịch',
    iconKey: 'shield',
    toneKey: 'success',
    progress: 1,
    currentValueLabel: '98.5/98 %',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-02-20',
    reward: 'Huy hiệu "Tin cậy"',
    rewardType: 'badge',
    categoryId: 'trust',
  ),
  P2PAchievementDraft(
    id: 'ach007',
    title: 'Không tranh chấp',
    description: '50 giao dịch liên tiếp không có tranh chấp',
    iconKey: 'star',
    toneKey: 'warning',
    progress: .86,
    currentValueLabel: '43/50 giao dịch',
    progressLabel: '86%',
    unlocked: false,
    reward: 'Huy hiệu "An toàn"',
    rewardType: 'badge',
    categoryId: 'trust',
  ),
  P2PAchievementDraft(
    id: 'ach008',
    title: 'Cộng đồng',
    description: 'Được 20 đánh giá 5 sao từ đối tác giao dịch',
    iconKey: 'users',
    toneKey: 'highlight',
    progress: .65,
    currentValueLabel: '13/20 đánh giá',
    progressLabel: '65%',
    unlocked: false,
    reward: '+20 điểm uy tín',
    rewardType: 'reputation',
    categoryId: 'special',
  ),
  P2PAchievementDraft(
    id: 'ach009',
    title: 'Tốc độ thanh toán',
    description: 'Trung bình thanh toán dưới 3 phút (≥10 giao dịch)',
    iconKey: 'bolt',
    toneKey: 'orange',
    progress: 1,
    currentValueLabel: '2.5/3 phút',
    progressLabel: '100%',
    unlocked: true,
    unlockedAt: '2024-03-01',
    reward: 'Huy hiệu "Nhanh nhẹn"',
    rewardType: 'badge',
    categoryId: 'special',
  ),
];

const List<P2PBlacklistReasonDraft> _p2pBlacklistAddReasons = [
  P2PBlacklistReasonDraft(
    id: 'scam',
    label: 'Lừa đảo',
    iconKey: 'alert',
    toneKey: 'danger',
  ),
  P2PBlacklistReasonDraft(
    id: 'unresponsive',
    label: 'Không phản hồi',
    iconKey: 'clock',
    toneKey: 'warning',
  ),
  P2PBlacklistReasonDraft(
    id: 'fake_payment',
    label: 'Thanh toán giả',
    iconKey: 'ban',
    toneKey: 'danger',
  ),
  P2PBlacklistReasonDraft(
    id: 'harassment',
    label: 'Quấy rối',
    iconKey: 'message',
    toneKey: 'accent',
  ),
  P2PBlacklistReasonDraft(
    id: 'other',
    label: 'Lý do khác',
    iconKey: 'info',
    toneKey: 'neutral',
  ),
];

const List<P2PBlacklistEntryDraft> _p2pBlacklistEntries = [
  P2PBlacklistEntryDraft(
    id: 'bl001',
    userId: 'u_bad001',
    username: 'FakeTrader88',
    reasonId: 'fake_payment',
    reasonText: 'Gửi biên lai chuyển khoản giả, tiền không vào tài khoản.',
    blockedAt: '2024-02-18 14:30:00',
    orderId: 'p2p-fake001',
    tradesBefore: 3,
    completionRate: 45,
    isVerified: false,
    recent30d: false,
  ),
  P2PBlacklistEntryDraft(
    id: 'bl002',
    userId: 'u_bad002',
    username: 'SlowPay_VN',
    reasonId: 'unresponsive',
    reasonText:
        'Không phản hồi tin nhắn sau khi tạo đơn, để đơn hết hạn 3 lần liên tiếp.',
    blockedAt: '2024-02-15 09:12:00',
    orderId: 'p2p-slow001',
    tradesBefore: 7,
    completionRate: 28.6,
    isVerified: true,
    recent30d: false,
  ),
  P2PBlacklistEntryDraft(
    id: 'bl003',
    userId: 'u_bad003',
    username: 'Scammer_X',
    reasonId: 'scam',
    reasonText: 'Cố gắng lừa đảo bằng cách yêu cầu giao dịch ngoài nền tảng.',
    blockedAt: '2024-02-10 21:45:00',
    tradesBefore: 1,
    completionRate: 0,
    isVerified: false,
    recent30d: false,
  ),
  P2PBlacklistEntryDraft(
    id: 'bl004',
    userId: 'u_bad004',
    username: 'RudeTrader99',
    reasonId: 'harassment',
    reasonText: 'Ngôn ngữ xúc phạm và đe dọa trong chat.',
    blockedAt: '2024-01-28 16:20:00',
    orderId: 'p2p-rude001',
    tradesBefore: 12,
    completionRate: 75,
    isVerified: true,
    recent30d: false,
    badge: 'pro',
  ),
  P2PBlacklistEntryDraft(
    id: 'bl005',
    userId: 'u_bad005',
    username: 'GhostBuyer',
    reasonId: 'other',
    reasonText:
        'Tạo đơn liên tục rồi hủy, gây phiền hà và khóa crypto trong escrow.',
    blockedAt: '2024-01-20 10:05:00',
    tradesBefore: 15,
    completionRate: 33.3,
    isVerified: false,
    recent30d: false,
  ),
];

const List<P2PNotificationSettingDraft> _p2pNotificationSettings = [
  P2PNotificationSettingDraft(
    id: 'order_updates',
    label: 'Order Updates',
    description: 'Cập nhật trạng thái đơn hàng',
    channels: {'push': true, 'email': true, 'sms': false},
  ),
  P2PNotificationSettingDraft(
    id: 'payment_received',
    label: 'Payment Received',
    description: 'Thông báo khi nhận thanh toán',
    channels: {'push': true, 'email': true, 'sms': true},
  ),
  P2PNotificationSettingDraft(
    id: 'release_reminder',
    label: 'Release Reminder',
    description: 'Nhắc release escrow',
    channels: {'push': true, 'email': false, 'sms': false},
  ),
  P2PNotificationSettingDraft(
    id: 'security_alerts',
    label: 'Security Alerts',
    description: 'Cảnh báo bảo mật',
    channels: {'push': true, 'email': true, 'sms': true},
  ),
  P2PNotificationSettingDraft(
    id: 'kyc_updates',
    label: 'KYC Updates',
    description: 'Cập nhật xác minh KYC',
    channels: {'push': true, 'email': true, 'sms': false},
  ),
];

const List<P2PSettingsToggleDraft> _p2pSettingsNotificationToggles = [
  P2PSettingsToggleDraft(
    id: 'orders',
    label: 'Đơn hàng',
    description: 'Thông báo khi có đơn mới, xác nhận, tranh chấp',
    iconKey: 'bell',
    toneKey: 'primary',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'chat',
    label: 'Tin nhắn',
    description: 'Thông báo tin nhắn mới trong chat',
    iconKey: 'message',
    toneKey: 'success',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'price',
    label: 'Cảnh báo giá',
    description: 'Khi giá thị trường biến động lớn',
    iconKey: 'alert',
    toneKey: 'danger',
    enabled: false,
  ),
  P2PSettingsToggleDraft(
    id: 'promo',
    label: 'Khuyến mãi',
    description: 'Ưu đãi phí, sự kiện P2P',
    iconKey: 'globe',
    toneKey: 'accent',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'sound',
    label: 'Âm thanh',
    description: 'Phát âm thanh khi có thông báo',
    iconKey: 'volume',
    toneKey: 'warning',
    enabled: true,
  ),
];

const List<P2PSettingsToggleDraft> _p2pSettingsPrivacyToggles = [
  P2PSettingsToggleDraft(
    id: 'online',
    label: 'Trạng thái online',
    description: 'Hiển thị trạng thái trực tuyến cho đối tác',
    iconKey: 'eye',
    toneKey: 'success',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'completion',
    label: 'Tỷ lệ hoàn thành',
    description: 'Hiển thị % hoàn thành trên profile',
    iconKey: 'shield',
    toneKey: 'primary',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'volume',
    label: 'Khối lượng giao dịch',
    description: 'Hiển thị tổng volume giao dịch',
    iconKey: 'wallet',
    toneKey: 'warning',
    enabled: false,
  ),
  P2PSettingsToggleDraft(
    id: 'last_seen',
    label: 'Lần hoạt động cuối',
    description: 'Hiển thị "hoạt động X phút trước"',
    iconKey: 'clock',
    toneKey: 'accent',
    enabled: true,
  ),
];

const List<P2PSettingsToggleDraft> _p2pSettingsSecurityToggles = [
  P2PSettingsToggleDraft(
    id: '2fa',
    label: 'Xác thực 2FA',
    description: 'Yêu cầu 2FA cho mọi giao dịch P2P',
    iconKey: 'lock',
    toneKey: 'danger',
    enabled: true,
  ),
  P2PSettingsToggleDraft(
    id: 'pin',
    label: 'Mã PIN giao dịch',
    description: 'Nhập PIN khi xác nhận đã nhận tiền',
    iconKey: 'fingerprint',
    toneKey: 'accent',
    enabled: false,
  ),
  P2PSettingsToggleDraft(
    id: 'ip',
    label: 'IP Whitelist',
    description: 'Chỉ cho phép giao dịch từ IP đã đăng ký',
    iconKey: 'globe',
    toneKey: 'primary',
    enabled: false,
  ),
];

const P2PSettingsAutoReplyDraft _p2pSettingsAutoReply =
    P2PSettingsAutoReplyDraft(
      enabled: true,
      buyTemplate: 'Cảm ơn bạn! Vui lòng chuyển khoản theo thông tin bên dưới.',
    );

const List<P2PGuideTabDraft> _p2pGuideTabs = [
  P2PGuideTabDraft(id: 'guide', label: 'Hướng dẫn'),
  P2PGuideTabDraft(id: 'safety', label: 'An toàn'),
  P2PGuideTabDraft(id: 'faq', label: 'FAQ'),
  P2PGuideTabDraft(id: 'video', label: 'Video'),
];

const List<P2PGuideFaqDraft> _p2pGuideFaqItems = [
  P2PGuideFaqDraft(
    id: 'what_is_p2p',
    question: 'P2P Trading là gì?',
    answer:
        'P2P (Peer-to-Peer) là hình thức mua bán crypto trực tiếp giữa người dùng với nhau, thông qua nền tảng trung gian. VitTrade cung cấp hệ thống Escrow để bảo vệ cả hai bên.',
  ),
  P2PGuideFaqDraft(
    id: 'fees',
    question: 'Phí giao dịch P2P là bao nhiêu?',
    answer:
        'Người tạo quảng cáo (Maker) miễn phí. Người đặt đơn (Taker) chịu phí 0.1%. Merchant được ưu đãi giảm 50% phí.',
  ),
  P2PGuideFaqDraft(
    id: 'escrow',
    question: 'Escrow hoạt động như thế nào?',
    answer:
        'Khi có đơn, crypto của người bán bị khóa trong hợp đồng thông minh. Chỉ khi người bán xác nhận đã nhận tiền, crypto mới được giải phóng cho người mua.',
  ),
  P2PGuideFaqDraft(
    id: 'dispute',
    question: 'Nếu có tranh chấp thì sao?',
    answer:
        'Bạn có thể mở tranh chấp trong vòng 72 giờ. Đội ngũ VitTrade sẽ xem xét bằng chứng từ cả hai bên và đưa ra phán quyết trong 24-48 giờ.',
  ),
  P2PGuideFaqDraft(
    id: 'payment_time',
    question: 'Thời gian thanh toán tối đa?',
    answer:
        'Tùy quảng cáo: 15, 30 hoặc 60 phút. Nếu quá thời hạn, đơn hàng tự động hủy và crypto trả về ví người bán.',
  ),
  P2PGuideFaqDraft(
    id: 'merchant',
    question: 'Tôi có thể trở thành Merchant?',
    answer:
        'Có. Cần: tài khoản trên 30 ngày, ít nhất 100 đơn hoàn thành, tỷ lệ hoàn thành từ 95%, KYC cấp 2 trở lên. Đăng ký tại mục Đăng ký Merchant.',
  ),
  P2PGuideFaqDraft(
    id: 'safe',
    question: 'VitTrade có an toàn không?',
    answer:
        'VitTrade sử dụng mã hóa E2E cho tin nhắn, hệ thống Escrow smart contract, KYC đa cấp và đội ngũ giám sát 24/7.',
  ),
];

const List<P2PGuideStepDraft> _p2pGuideBuySteps = [
  P2PGuideStepDraft(
    id: 'buy_search',
    step: 1,
    title: 'Tìm quảng cáo',
    description:
        'Chọn quảng cáo BÁN phù hợp với giá, phương thức thanh toán và giới hạn mong muốn.',
    iconKey: 'search',
    toneKey: 'primary',
  ),
  P2PGuideStepDraft(
    id: 'buy_pay',
    step: 2,
    title: 'Đặt đơn & Thanh toán',
    description:
        'Nhập số lượng, xác nhận đơn. Chuyển tiền đúng thông tin và thời hạn quy định.',
    iconKey: 'payment',
    toneKey: 'accent',
  ),
  P2PGuideStepDraft(
    id: 'buy_chat',
    step: 3,
    title: 'Chat & Xác nhận',
    description:
        'Liên hệ người bán qua chat mã hóa E2E. Gửi bằng chứng chuyển khoản.',
    iconKey: 'chat',
    toneKey: 'success',
  ),
  P2PGuideStepDraft(
    id: 'buy_receive',
    step: 4,
    title: 'Nhận crypto',
    description:
        'Sau khi người bán xác nhận, crypto tự động chuyển vào ví của bạn.',
    iconKey: 'wallet',
    toneKey: 'warning',
  ),
];

const List<P2PGuideStepDraft> _p2pGuideSellSteps = [
  P2PGuideStepDraft(
    id: 'sell_create',
    step: 1,
    title: 'Đăng quảng cáo',
    description:
        'Tạo quảng cáo BÁN với giá, số lượng, phương thức thanh toán và điều kiện.',
    iconKey: 'file',
    toneKey: 'danger',
  ),
  P2PGuideStepDraft(
    id: 'sell_escrow',
    step: 2,
    title: 'Escrow tự động',
    description:
        'Khi có đơn, crypto tự động bị khóa trong Escrow để bảo vệ người mua.',
    iconKey: 'lock',
    toneKey: 'accent',
  ),
  P2PGuideStepDraft(
    id: 'sell_check',
    step: 3,
    title: 'Kiểm tra thanh toán',
    description: 'Kiểm tra tài khoản ngân hàng. Xác nhận khi đã nhận đủ tiền.',
    iconKey: 'eye',
    toneKey: 'primary',
  ),
  P2PGuideStepDraft(
    id: 'sell_release',
    step: 4,
    title: 'Giải phóng crypto',
    description:
        'Nhấn xác nhận, crypto tự động chuyển cho người mua. Hoàn tất.',
    iconKey: 'check',
    toneKey: 'success',
  ),
];

const List<P2PGuideTipDraft> _p2pGuideSafetyTips = [
  P2PGuideTipDraft(
    id: 'platform_only',
    title: 'Chỉ giao dịch trên nền tảng',
    description: 'Không chuyển tiền hoặc crypto ra ngoài hệ thống VitTrade.',
    iconKey: 'shield',
    toneKey: 'primary',
  ),
  P2PGuideTipDraft(
    id: 'secrets',
    title: 'Không chia sẻ thông tin nhạy cảm',
    description: 'Mật khẩu, OTP, seed phrase không bao giờ chia sẻ trong chat.',
    iconKey: 'lock',
    toneKey: 'danger',
  ),
  P2PGuideTipDraft(
    id: 'fraud',
    title: 'Cảnh giác lừa đảo',
    description:
        'Kiểm tra kỹ số tiền, tên người nhận. Không tin đã chuyển nếu chưa thấy tiền.',
    iconKey: 'alert',
    toneKey: 'warning',
  ),
  P2PGuideTipDraft(
    id: 'partner',
    title: 'Kiểm tra đối tác',
    description:
        'Ưu tiên merchant có huy hiệu, tỷ lệ hoàn thành cao và nhiều đơn hoàn thành.',
    iconKey: 'users',
    toneKey: 'success',
  ),
];

const List<P2PGuideVideoDraft> _p2pGuideVideos = [
  P2PGuideVideoDraft(
    id: 'start',
    title: 'Bắt đầu giao dịch P2P',
    duration: '5:32',
    views: '12.5K',
    thumb: 'P2P',
    level: 'Cơ bản',
    toneKey: 'success',
  ),
  P2PGuideVideoDraft(
    id: 'ads',
    title: 'Cách tạo quảng cáo hiệu quả',
    duration: '8:15',
    views: '8.3K',
    thumb: 'ADS',
    level: 'Trung bình',
    toneKey: 'warning',
  ),
  P2PGuideVideoDraft(
    id: 'security',
    title: 'Bảo mật tài khoản P2P',
    duration: '6:48',
    views: '15.2K',
    thumb: 'SEC',
    level: 'Cơ bản',
    toneKey: 'primary',
  ),
  P2PGuideVideoDraft(
    id: 'dispute',
    title: 'Xử lý tranh chấp',
    duration: '7:20',
    views: '6.1K',
    thumb: 'DSP',
    level: 'Nâng cao',
    toneKey: 'danger',
  ),
];

const List<P2PMyOrdersTabDraft> _p2pMyOrdersTabs = [
  P2PMyOrdersTabDraft(id: 'processing', label: 'Đang xử lý'),
  P2PMyOrdersTabDraft(id: 'completed', label: 'Hoàn tất'),
  P2PMyOrdersTabDraft(id: 'disputed', label: 'Tranh chấp'),
];

const List<P2PMyOrderDraft> _p2pMyOrders = [
  P2PMyOrderDraft(
    id: 'p2p001',
    orderNumber: 'VT-P2P-20240223-001',
    type: 'buy',
    asset: 'USDT',
    amount: 200,
    price: 25350,
    total: 5070000,
    currency: 'VND',
    status: 'pending_payment',
    merchant: 'CryptoKing_VN',
    merchantId: 'mc001',
    createdAt: '2024-02-23 11:00:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p002',
    orderNumber: 'VT-P2P-20240223-002',
    type: 'sell',
    asset: 'USDT',
    amount: 500,
    price: 25280,
    total: 12640000,
    currency: 'VND',
    status: 'paid',
    merchant: 'VIPTrader_HN',
    merchantId: 'mc004',
    createdAt: '2024-02-23 09:15:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p003',
    orderNumber: 'VT-P2P-20240222-003',
    type: 'buy',
    asset: 'USDT',
    amount: 1000,
    price: 25300,
    total: 25300000,
    currency: 'VND',
    status: 'released',
    merchant: 'TradeMaster99',
    merchantId: 'mc002',
    createdAt: '2024-02-22 14:30:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p004',
    orderNumber: 'VT-P2P-20240221-004',
    type: 'buy',
    asset: 'USDT',
    amount: 150,
    price: 25400,
    total: 3810000,
    currency: 'VND',
    status: 'released',
    merchant: 'CoinHunter_HCM',
    merchantId: 'mc003',
    createdAt: '2024-02-21 16:45:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p005',
    orderNumber: 'VT-P2P-20240220-005',
    type: 'sell',
    asset: 'USDT',
    amount: 300,
    price: 25260,
    total: 7578000,
    currency: 'VND',
    status: 'cancelled',
    merchant: 'FastTrade_SG',
    merchantId: 'mc005',
    createdAt: '2024-02-20 10:20:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p006',
    orderNumber: 'VT-P2P-20240219-006',
    type: 'buy',
    asset: 'USDT',
    amount: 800,
    price: 25350,
    total: 20280000,
    currency: 'VND',
    status: 'disputed',
    merchant: 'NewTrader01',
    merchantId: 'mc007',
    createdAt: '2024-02-19 08:10:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p007',
    orderNumber: 'VT-P2P-20240218-007',
    type: 'buy',
    asset: 'BTC',
    amount: .05,
    price: 1715000000,
    total: 85750000,
    currency: 'VND',
    status: 'released',
    merchant: 'BTCWhale_VN',
    merchantId: 'mc006',
    createdAt: '2024-02-18 12:00:00',
  ),
];

String _formatVndDots(double value) {
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  return buffer.toString();
}

const Map<String, P2PClaimDetailDraft> _p2pClaimDetails = {
  'sample': _p2pClaimDetailPaid,
  'ic001': _p2pClaimDetailPaid,
};

const P2PClaimDetailDraft _p2pClaimDetailPaid = P2PClaimDetailDraft(
  id: 'ic001',
  claimCode: 'CLM-001',
  orderId: 'P2P-78400',
  orderNumber: 'VT-P2P-20260218-001',
  reason: 'Gian lận',
  description:
      'Merchant không giải phóng coin sau khi đã xác nhận thanh toán thành công. Đã liên hệ merchant qua chat nhiều lần nhưng không phản hồi sau 6 giờ.',
  amount: 15000000,
  paidAmount: 12750000,
  currency: 'VND',
  status: P2PInsuranceClaimStatus.paid,
  submittedAt: '2026-02-18 14:30',
  estimatedReview: '2026-02-20 14:30',
  coveragePct: 85,
  maxCoverage: 100000000,
  notificationsEnabled: true,
  timeline: [
    P2PClaimTimelineEventDraft(
      id: 't1',
      statusKey: 'submitted',
      title: 'Yêu cầu đã gửi',
      description: 'Hệ thống tiếp nhận yêu cầu bồi thường',
      timestamp: '2026-02-18 14:30',
      actor: 'Hệ thống',
    ),
    P2PClaimTimelineEventDraft(
      id: 't2',
      statusKey: 'evidence_added',
      title: 'Bằng chứng bổ sung',
      description: 'Ảnh chụp màn hình chuyển khoản đã tải lên',
      timestamp: '2026-02-18 14:45',
      actor: 'Bạn',
    ),
    P2PClaimTimelineEventDraft(
      id: 't3',
      statusKey: 'reviewing',
      title: 'Bắt đầu điều tra',
      description: 'Nhân viên hỗ trợ bắt đầu xem xét bằng chứng',
      timestamp: '2026-02-19 09:15',
      actor: 'Nguyễn Văn A',
    ),
    P2PClaimTimelineEventDraft(
      id: 't4',
      statusKey: 'note_added',
      title: 'Ghi chú điều tra',
      description: 'Đã xác minh lịch sử chat và bằng chứng thanh toán',
      timestamp: '2026-02-19 11:30',
      actor: 'Nguyễn Văn A',
    ),
    P2PClaimTimelineEventDraft(
      id: 't5',
      statusKey: 'approved',
      title: 'Đã chấp thuận',
      description: 'Yêu cầu bồi thường đủ điều kiện, phê duyệt chi trả 85%',
      timestamp: '2026-02-19 16:00',
      actor: 'Trưởng nhóm',
    ),
    P2PClaimTimelineEventDraft(
      id: 't6',
      statusKey: 'paid',
      title: 'Đã chi trả',
      description: 'Chuyển 12.750.000 VND vào ví nội bộ',
      timestamp: '2026-02-20 10:00',
      actor: 'Hệ thống',
    ),
  ],
  evidence: [
    P2PClaimEvidenceDraft(
      id: 'e1',
      type: 'screenshot',
      name: 'chuyen_khoan_mb.png',
      size: '1.2 MB',
      uploadedAt: '2026-02-18 14:32',
    ),
    P2PClaimEvidenceDraft(
      id: 'e2',
      type: 'screenshot',
      name: 'chat_merchant.png',
      size: '850 KB',
      uploadedAt: '2026-02-18 14:35',
    ),
    P2PClaimEvidenceDraft(
      id: 'e3',
      type: 'screenshot',
      name: 'order_detail.png',
      size: '620 KB',
      uploadedAt: '2026-02-18 14:45',
    ),
    P2PClaimEvidenceDraft(
      id: 'e4',
      type: 'document',
      name: 'sao_ke_ngan_hang.pdf',
      size: '2.1 MB',
      uploadedAt: '2026-02-19 08:00',
    ),
  ],
  reviewerNotes: [
    P2PClaimReviewerNoteDraft(
      id: 'rn1',
      author: 'Nguyễn Văn A',
      role: 'Chuyên viên hỗ trợ',
      content:
          'Đã xác minh bằng chứng chuyển khoản qua MB Bank, khớp với số tiền giao dịch. Merchant không phản hồi sau 12 giờ theo quy định.',
      timestamp: '2026-02-19 11:30',
    ),
    P2PClaimReviewerNoteDraft(
      id: 'rn2',
      author: 'Trần Thị B',
      role: 'Trưởng nhóm Claims',
      content:
          'Phê duyệt chi trả 85% theo tier Pro. Merchant sẽ bị cảnh cáo và giảm hạng.',
      timestamp: '2026-02-19 16:00',
    ),
    P2PClaimReviewerNoteDraft(
      id: 'rn3',
      author: 'Hệ thống',
      role: 'Tự động',
      content:
          'Đã chuyển 12.750.000 VND vào ví nội bộ. Mã giao dịch: TXN-INS-20260220-001.',
      timestamp: '2026-02-20 10:00',
    ),
  ],
);

const List<P2PClaimBenchmarkDraft> _p2pClaimBenchmarks = [
  P2PClaimBenchmarkDraft(
    id: 'amount',
    title: 'Số tiền yêu cầu',
    value: '15.000.000 đ',
    caption: 'Tiền trung vị',
    comparison: 'Gần trung bình',
    progress: .32,
    toneKey: 'primary',
  ),
  P2PClaimBenchmarkDraft(
    id: 'resolution',
    title: 'Thời gian xử lý',
    value: '334h',
    caption: 'Chậm hơn 75% claims',
    comparison: 'Cao hơn TB',
    progress: 1,
    toneKey: 'warn',
  ),
  P2PClaimBenchmarkDraft(
    id: 'coverage',
    title: 'Tỷ lệ bảo hiểm',
    value: '85%',
    caption: 'Cao hơn 7% so với TB nền tảng',
    comparison: 'TB nền tảng: 78%',
    progress: .85,
    toneKey: 'buy',
  ),
];

const List<P2PClaimReasonShareDraft> _p2pClaimReasonShares = [
  P2PClaimReasonShareDraft(label: 'Gian lận', percent: 42, highlight: true),
  P2PClaimReasonShareDraft(label: 'Chargeback', percent: 28),
  P2PClaimReasonShareDraft(label: 'Lỗi dispute', percent: 18),
  P2PClaimReasonShareDraft(label: 'Khác', percent: 12),
];

String _monthLabel(String monthKey) {
  final parts = monthKey.split('-');
  if (parts.length != 2) return monthKey;
  return 'Tháng ${int.parse(parts[1])}/${parts[0]}';
}

String _maskAddress(String address) {
  if (address.length < 14) return address;
  return '${address.substring(0, 8)}...${address.substring(address.length - 6)}';
}

const List<P2PMerchantBenefitDraft> _p2pMerchantBenefits = [
  P2PMerchantBenefitDraft(
    id: 'badge',
    title: 'Huy hiệu Merchant',
    subtitle: 'Tăng uy tín & thứ hạng hiển thị',
    iconKey: 'star',
    toneKey: 'warn',
  ),
  P2PMerchantBenefitDraft(
    id: 'fees',
    title: 'Phí ưu đãi',
    subtitle: 'Giảm 50% phí giao dịch P2P',
    iconKey: 'zap',
    toneKey: 'buy',
  ),
  P2PMerchantBenefitDraft(
    id: 'priority',
    title: 'Ưu tiên hiển thị',
    subtitle: 'Quảng cáo xuất hiện đầu danh sách',
    iconKey: 'users',
    toneKey: 'primary',
  ),
  P2PMerchantBenefitDraft(
    id: 'support',
    title: 'Hỗ trợ VIP',
    subtitle: 'Kênh hỗ trợ Merchant riêng 24/7',
    iconKey: 'shield',
    toneKey: 'accent',
  ),
];

const List<P2PMerchantRequirementDraft> _p2pMerchantRequirements = [
  P2PMerchantRequirementDraft(
    id: 'account_age',
    label: 'Tài khoản >= 30 ngày',
    value: '247 ngày',
    met: true,
    iconKey: 'clock',
  ),
  P2PMerchantRequirementDraft(
    id: 'orders',
    label: '>= 100 đơn hoàn thành',
    value: '156 đơn',
    met: true,
    iconKey: 'trend',
  ),
  P2PMerchantRequirementDraft(
    id: 'completion',
    label: 'Tỷ lệ HT >= 95%',
    value: '97.2%',
    met: true,
    iconKey: 'shield',
  ),
  P2PMerchantRequirementDraft(
    id: 'kyc',
    label: 'KYC cấp 2+',
    value: 'Cấp 2',
    met: true,
    iconKey: 'verified',
  ),
  P2PMerchantRequirementDraft(
    id: 'disputes',
    label: '<= 2 tranh chấp',
    value: '1 vụ',
    met: true,
    iconKey: 'warning',
  ),
];

const List<P2PMerchantDocumentDraft> _p2pMerchantDocuments = [
  P2PMerchantDocumentDraft(
    id: 'identity',
    title: 'CMND / CCCD / Hộ chiếu',
    subtitle: 'Ảnh 2 mặt rõ nét',
    required: true,
    iconKey: 'file',
  ),
  P2PMerchantDocumentDraft(
    id: 'business',
    title: 'Giấy phép kinh doanh',
    subtitle: 'Bản scan hoặc ảnh chụp',
    required: false,
    iconKey: 'award',
  ),
  P2PMerchantDocumentDraft(
    id: 'selfie',
    title: 'Ảnh selfie xác minh',
    subtitle: 'Cầm CMND + giấy ghi ngày',
    required: true,
    iconKey: 'camera',
  ),
];
