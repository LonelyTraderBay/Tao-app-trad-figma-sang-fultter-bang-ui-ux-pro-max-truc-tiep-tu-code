part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryOrdersMethods on _MockP2PRepositoryBase {
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
      successTitle: 'Cảm ơn bạn!',
      successMessage: 'Đánh giá của bạn giúp cộng đồng giao dịch an toàn hơn.',
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
