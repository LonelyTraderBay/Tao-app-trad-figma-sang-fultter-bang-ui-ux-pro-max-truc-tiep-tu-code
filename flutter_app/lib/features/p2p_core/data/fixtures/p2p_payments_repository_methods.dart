part of '../repositories/mock_p2p_repository.dart';

/// Payment-method-scoped high-risk contract id shared by the add,
/// ownership-verification, and cooling-period screens (one continuous
/// payment-method-onboarding audit trail — analogous to how
/// `HighRiskFlowContractIds.walletMoneyMovement` spans one withdrawal's
/// preview/confirm/receipt). Deliberately not registered in
/// `HighRiskFlowContractIds`: `p2pEscrowOrder` is specifically
/// order/escrow/dispute lifecycle, not payment-method management, and
/// registering a new shared entry would require inventing a full 9-stage
/// flow this surface doesn't have.
const _p2pPaymentMethodContractId = 'p2p_payment_method_onboarding';

mixin _MockP2PRepositoryPaymentsMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PPaymentMethodAddSnapshot> getPaymentMethodAdd() async {
    await _simulateNetwork();
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
          'Kiểm tra đúng ngân hàng, số tài khoản đã che và tên chủ tài khoản trước khi lưu.',
      emptyTitle: 'Chưa có phương thức thanh toán',
      contractNotes:
          'Hành động rủi ro cao: cần xem trước, xác nhận và nhật ký kiểm toán. P2P yêu cầu escrow, chống gian lận, KYC và trạng thái thanh toán rõ ràng.',
      highRiskContractId: _p2pPaymentMethodContractId,
    );
  }

  @override
  Future<P2PPaymentMethodVerificationSnapshot> getPaymentMethodVerification(
    String methodId,
  ) async {
    await _simulateNetwork();
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
  Future<P2PPaymentMethodOwnershipSnapshot> getPaymentMethodOwnership(
    String methodId,
  ) async {
    await _simulateNetwork();
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
          'Tài liệu sẽ được lưu vào nhật ký kiểm toán và đối chiếu với hồ sơ KYC trước khi mở giới hạn P2P.',
      emptyTitle: 'Chưa có tài liệu xác minh',
      contractNotes:
          'Hành động rủi ro cao: cần xem trước, xác nhận và nhật ký kiểm toán. P2P yêu cầu escrow, chống gian lận, KYC và trạng thái thanh toán rõ ràng.',
      highRiskContractId: _p2pPaymentMethodContractId,
    );
  }

  @override
  Future<P2PPaymentMethodCoolingPeriodSnapshot>
  getPaymentMethodCoolingPeriod() async {
    await _simulateNetwork();
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
      reason: 'Phương thức thanh toán mới',
      reasons: [
        'Bảo vệ khỏi gian lận và lừa đảo',
        'Thời gian xác minh quyền sở hữu',
        'Tuân thủ quy định AML/CTF',
        'Giảm thiểu tranh chấp',
      ],
      waitTitle: 'Trong thời gian chờ',
      waitMessage:
          'Bạn vẫn có thể dùng các phương thức khác đã xác minh. Phương thức này sẽ tự động khả dụng sau 7 ngày.',
      emptyTitle: 'Không có phương thức đang chờ',
      contractNotes:
          'Hành động rủi ro cao: cần xem trước, xác nhận và nhật ký kiểm toán. P2P yêu cầu escrow, chống gian lận, KYC và trạng thái thanh toán rõ ràng.',
      highRiskContractId: _p2pPaymentMethodContractId,
    );
  }

  @override
  Future<P2PPaymentMethodHistorySnapshot> getPaymentMethodHistory() async {
    await _simulateNetwork();
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
  Future<P2PPaymentMethodsSnapshot> getPaymentMethods() async {
    await _simulateNetwork();
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
