part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryHomeMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PHomeSnapshot> getHome({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    String fiat = 'VND',
  }) async {
    await _simulateNetwork();
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
  Future<P2PExpressSnapshot> getExpress() async {
    await _simulateNetwork();
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
  Future<P2PExpressConfirmSnapshot> getExpressConfirm({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    double fiatAmount = 0,
    double cryptoAmount = 0,
    String? adId,
    String? paymentMethod,
  }) async {
    await _simulateNetwork();
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
}
