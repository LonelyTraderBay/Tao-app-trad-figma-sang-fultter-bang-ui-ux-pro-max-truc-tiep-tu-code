part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryPaymentsMethods on _MockP2PRepositoryBase {
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
}
