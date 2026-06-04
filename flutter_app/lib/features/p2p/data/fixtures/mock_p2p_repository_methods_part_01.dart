part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryMethodsPart01 on _MockP2PRepositoryBase {
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
      highRiskContractId: HighRiskFlowContractIds.p2pEscrowOrder,
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
      highRiskContractId: HighRiskFlowContractIds.p2pEscrowOrder,
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
      highRiskContractId: HighRiskFlowContractIds.p2pEscrowOrder,
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
      highRiskContractId: HighRiskFlowContractIds.p2pEscrowOrder,
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
}
