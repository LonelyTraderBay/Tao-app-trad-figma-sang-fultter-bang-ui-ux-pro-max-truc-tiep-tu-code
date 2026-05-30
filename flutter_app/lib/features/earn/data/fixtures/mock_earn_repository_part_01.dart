part of '../repositories/mock_earn_repository.dart';

final class MockStakingEarnRepository implements StakingEarnRepository {
  const MockStakingEarnRepository();

  @override
  StakingEarnSnapshot getStakingEarn({
    StakingEarnRoute route = StakingEarnRoute.earn,
  }) {
    return StakingEarnSnapshot(
      endpoint: switch (route) {
        StakingEarnRoute.earn => '/api/mobile/earn/earn',
        StakingEarnRoute.staking => '/api/mobile/earn/earn-staking',
      },
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Staking & Earn',
      subtitle: 'Earn - Tai chinh',
      backRoute: '/home',
      savingsRoute: '/earn/savings',
      totalEarnedUsd: '+\$38.33',
      activePositions: 2,
      maxApyLabel: 'APY toi da 24.5%',
      fundProtectionLabel: 'Bao hiem quy',
      products: [
        EarnProductDraft(
          id: 'btc-fixed-90',
          asset: 'BTC',
          name: 'Bitcoin Fixed',
          type: EarnProductType.fixed,
          apy: '5.8%',
          minAmount: '0.001 BTC',
          lockLabel: '90 ngay',
          totalStaked: '12,450 BTC',
          participants: '8,432 nguoi',
          progress: 0.72,
          riskLevel: EarnRiskLevel.low,
          isHot: true,
        ),
        EarnProductDraft(
          id: 'eth-flexible',
          asset: 'ETH',
          name: 'Ethereum Flexible',
          type: EarnProductType.flexible,
          apy: '4.2%',
          minAmount: '0.01 ETH',
          lockLabel: 'Linh hoat',
          totalStaked: '48,234 ETH',
          participants: '23,140 nguoi',
          progress: 0.85,
          riskLevel: EarnRiskLevel.low,
        ),
        EarnProductDraft(
          id: 'sol-fixed-30',
          asset: 'SOL',
          name: 'Solana Fixed 30D',
          type: EarnProductType.fixed,
          apy: '8.5%',
          boostApy: 'Max 12.3%',
          minAmount: '1 SOL',
          lockLabel: '30 ngay',
          totalStaked: '234,120 SOL',
          participants: '14,230 nguoi',
          progress: 0.45,
          riskLevel: EarnRiskLevel.medium,
          isNew: true,
        ),
        EarnProductDraft(
          id: 'usdt-flexible',
          asset: 'USDT',
          name: 'USDT Savings',
          type: EarnProductType.flexible,
          apy: '6.5%',
          minAmount: '10 USDT',
          lockLabel: 'Linh hoat',
          totalStaked: '\$45.2M',
          participants: '67,890 nguoi',
          progress: 0.91,
          riskLevel: EarnRiskLevel.low,
          isHot: true,
        ),
        EarnProductDraft(
          id: 'bnb-fixed-60',
          asset: 'BNB',
          name: 'BNB Fixed 60D',
          type: EarnProductType.fixed,
          apy: '9.2%',
          minAmount: '0.1 BNB',
          lockLabel: '60 ngay',
          totalStaked: '12,450 BNB',
          participants: '5,210 nguoi',
          progress: 0.58,
          riskLevel: EarnRiskLevel.medium,
        ),
        EarnProductDraft(
          id: 'defi-pool-1',
          asset: 'ETH/USDT',
          name: 'ETH-USDT LP Pool',
          type: EarnProductType.defi,
          apy: '18.7%',
          boostApy: 'Max 24.5%',
          minAmount: '100 USDT',
          lockLabel: 'Linh hoat',
          totalStaked: '\$8.2M',
          participants: '3,420 nguoi',
          progress: 0.63,
          riskLevel: EarnRiskLevel.high,
        ),
      ],
      positions: [
        EarnPositionDraft(
          id: 'p1',
          product: 'Bitcoin Fixed',
          asset: 'BTC',
          amount: '0.05 BTC',
          earned: '+0.00029 BTC',
          apy: '5.8%',
          startDate: '01/01/2026',
          endDate: '01/04/2026',
          type: EarnProductType.fixed,
        ),
        EarnPositionDraft(
          id: 'p2',
          product: 'USDT Savings',
          asset: 'USDT',
          amount: '2500 USDT',
          earned: '+18.74 USDT',
          apy: '6.5%',
          startDate: '15/01/2026',
          endDate: null,
          type: EarnProductType.flexible,
        ),
      ],
      estimatedIncome: [
        EarnIncomeEstimateDraft(label: 'Hang ngay', value: '+\$1.42'),
        EarnIncomeEstimateDraft(label: 'Hang thang', value: '+\$42.60'),
        EarnIncomeEstimateDraft(label: 'Hang nam', value: '+\$511.20'),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsRepository implements SavingsRepository {
  const MockSavingsRepository();

  @override
  SavingsSnapshot getSavings() {
    return const SavingsSnapshot(
      endpoint: '/api/mobile/earn/earn-savings',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Tiết kiệm',
      subtitle: 'Earn - Tài chính',
      backRoute: '/earn',
      portfolioRoute: '/earn/savings/portfolio',
      guideRoute: '/earn/savings/guide',
      exportRoute: '/earn/savings/export',
      productDetailRoute: '/earn/savings/product/sample',
      totalDepositedUsd: '\$8,100.86',
      gainLabel: '+\$74.36 (4.8%)',
      insights: [
        SavingsInsightDraft(
          title: 'APY có thể cao hơn 1.2%',
          subtitle: '3 gợi ý tối ưu danh mục cho bạn',
          tone: EarnRiskLevel.high,
          route: '/earn/savings/smart-suggestions',
        ),
        SavingsInsightDraft(
          title: 'Xuất báo cáo tiết kiệm',
          subtitle: 'Tạo CSV, PDF hoặc Excel cho giao dịch và thuế',
          tone: EarnRiskLevel.low,
          route: '/earn/savings/export',
        ),
        SavingsInsightDraft(
          title: 'Mô phỏng đầu tư',
          subtitle: 'Backtest phân bổ tiết kiệm trước khi áp dụng',
          tone: EarnRiskLevel.medium,
          route: '/earn/savings/backtest',
        ),
        SavingsInsightDraft(
          title: 'AutoPilot Savings',
          subtitle: 'Tự động DCA, rebalance, tối ưu APY và kiểm soát rủi ro',
          tone: EarnRiskLevel.medium,
          route: '/earn/savings/autopilot',
        ),
        SavingsInsightDraft(
          title: 'Ladder đáo hạn',
          subtitle: 'Chia vốn thành nhiều bậc để giữ thanh khoản định kỳ',
          tone: EarnRiskLevel.medium,
          route: '/earn/savings/ladder',
        ),
        SavingsInsightDraft(
          title: 'What-If Analysis',
          subtitle: 'Mô phỏng APY và stress test danh mục tiết kiệm',
          tone: EarnRiskLevel.high,
          route: '/earn/savings/whatif',
        ),
        SavingsInsightDraft(
          title: 'BTC sắp đáo hạn 7 ngày nữa',
          subtitle: 'Xem chi tiết và lên kế hoạch tái đầu tư',
          tone: EarnRiskLevel.medium,
        ),
        SavingsInsightDraft(
          title: 'Tiết kiệm tự động mỗi tuần',
          subtitle: 'Thiết lập DCA để tích lũy đều đặn',
          tone: EarnRiskLevel.low,
          route: '/earn/savings/dca',
        ),
      ],
      products: [
        SavingsProductDraft(
          id: 'sav001',
          asset: 'USDT',
          name: 'USDT Linh hoạt',
          type: SavingsProductType.flexible,
          apy: '4.5%',
          totalSubscribed: '\$125M',
          remainingQuota: 'Không giới hạn',
          participants: '45,230 người',
          progress: 0.62,
          riskLevel: EarnRiskLevel.low,
          isHot: true,
        ),
        SavingsProductDraft(
          id: 'sav002',
          asset: 'USDT',
          name: 'USDT Cố định 30D',
          type: SavingsProductType.locked,
          apy: '7.2%',
          lockDays: 30,
          maxApy: 'Tối đa 8.5%',
          totalSubscribed: '\$45M',
          remainingQuota: '\$5M',
          participants: '12,480 người',
          progress: 0.90,
          riskLevel: EarnRiskLevel.low,
          isNew: true,
        ),
        SavingsProductDraft(
          id: 'sav003',
          asset: 'USDT',
          name: 'USDT Cố định 90D',
          type: SavingsProductType.locked,
          apy: '9.8%',
          lockDays: 90,
          totalSubscribed: '\$28M',
          remainingQuota: '\$2M',
          participants: '6,720 người',
          progress: 0.93,
          riskLevel: EarnRiskLevel.medium,
        ),
        SavingsProductDraft(
          id: 'sav004',
          asset: 'BTC',
          name: 'BTC Linh hoạt',
          type: SavingsProductType.flexible,
          apy: '1.8%',
          totalSubscribed: '1,240 BTC',
          remainingQuota: 'Không giới hạn',
          participants: '18,340 người',
          progress: 0.48,
          riskLevel: EarnRiskLevel.low,
        ),
        SavingsProductDraft(
          id: 'sav005',
          asset: 'BTC',
          name: 'BTC Cố định 60D',
          type: SavingsProductType.locked,
          apy: '3.5%',
          lockDays: 60,
          maxApy: 'Tối đa 4.2%',
          totalSubscribed: '450 BTC',
          remainingQuota: '50 BTC',
          participants: '9,120 người',
          progress: 0.82,
          riskLevel: EarnRiskLevel.low,
          isHot: true,
        ),
        SavingsProductDraft(
          id: 'sav006',
          asset: 'ETH',
          name: 'ETH Linh hoạt',
          type: SavingsProductType.flexible,
          apy: '2.1%',
          totalSubscribed: '18,500 ETH',
          remainingQuota: 'Không giới hạn',
          participants: '15,670 người',
          progress: 0.55,
          riskLevel: EarnRiskLevel.low,
        ),
        SavingsProductDraft(
          id: 'sav007',
          asset: 'SOL',
          name: 'SOL Cố định 30D',
          type: SavingsProductType.locked,
          apy: '6.5%',
          lockDays: 30,
          totalSubscribed: '120K SOL',
          remainingQuota: '10K SOL',
          participants: '4,890 người',
          progress: 0.35,
          riskLevel: EarnRiskLevel.low,
          isNew: true,
        ),
      ],
      positions: [
        SavingsPositionDraft(
          id: 'ms1',
          product: 'USDT Linh hoạt',
          asset: 'USDT',
          amount: '3500 USDT',
          earned: '+14.58 USDT',
          apy: '4.5%',
          startDate: '01/02/2026',
          type: SavingsProductType.flexible,
          riskLevel: EarnRiskLevel.low,
        ),
        SavingsPositionDraft(
          id: 'ms2',
          product: 'BTC Cố định 60D',
          asset: 'BTC',
          amount: '0.02 BTC',
          earned: '+0.000019 BTC',
          apy: '3.5%',
          startDate: '15/01/2026',
          endDate: '16/03/2026',
          type: SavingsProductType.locked,
          riskLevel: EarnRiskLevel.low,
        ),
        SavingsPositionDraft(
          id: 'ms3',
          product: 'SOL Cố định 30D',
          asset: 'SOL',
          amount: '25 SOL',
          earned: '+0.45 SOL',
          apy: '6.5%',
          startDate: '20/02/2026',
          endDate: '22/03/2026',
          type: SavingsProductType.locked,
          riskLevel: EarnRiskLevel.medium,
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsProductDetailRepository
    implements SavingsProductDetailRepository {
  const MockSavingsProductDetailRepository();

  @override
  SavingsProductDetailSnapshot getProductDetail({required String productId}) {
    final savings = const MockSavingsRepository().getSavings();
    SavingsProductDraft? product;
    for (final item in savings.products) {
      if (item.id == productId) {
        product = item;
        break;
      }
    }

    return SavingsProductDetailSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-product-$productId',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: product?.name ?? 'Sản phẩm',
      backRoute: '/earn/savings',
      productId: productId,
      product: product,
      notFoundMessage: 'Không tìm thấy sản phẩm',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData.',
      supportedStates: const {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsRedeemRepository implements SavingsRedeemRepository {
  const MockSavingsRedeemRepository();

  @override
  SavingsRedeemSnapshot getRedeem({required String positionId}) {
    final savings = const MockSavingsRepository().getSavings();
    SavingsPositionDraft? position;
    for (final item in savings.positions) {
      if (item.id == positionId) {
        position = item;
        break;
      }
    }

    return SavingsRedeemSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-redeem-$positionId',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Rút Tiết kiệm',
      backRoute: '/earn/savings',
      receiptRoute: '/earn/savings/receipt',
      positionId: positionId,
      position: position,
      notFoundMessage: 'Không tìm thấy vị thế',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData.',
      supportedStates: const {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      },
    );
  }
}

final class MockSavingsReceiptRepository implements SavingsReceiptRepository {
  const MockSavingsReceiptRepository();

  @override
  SavingsReceiptSnapshot getReceipt() {
    return const SavingsReceiptSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-receipt',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Biên nhận',
      backRoute: '/earn/savings',
      earnRoute: '/earn',
      receipt: null,
      emptyMessage: 'Không có dữ liệu biên nhận',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
