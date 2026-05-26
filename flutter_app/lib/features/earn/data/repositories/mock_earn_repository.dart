import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/domain/repositories/earn_repository.dart';

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

final class MockSavingsPortfolioRepository
    implements SavingsPortfolioRepository {
  const MockSavingsPortfolioRepository();

  @override
  SavingsPortfolioSnapshot getPortfolio() {
    return const SavingsPortfolioSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-portfolio',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Savings Portfolio',
      backRoute: '/earn/savings',
      savingsRoute: '/earn/savings',
      historyRoute: '/earn/savings/history',
      totalDepositedUsd: '\$10,340.86',
      gainLabel: '+\$77.72 (4.6%)',
      weightedApy: '4.6%',
      flexibleTotalUsd: '\$5,740.00',
      lockedTotalUsd: '\$4,600.86',
      activePositions: 3,
      maturingPositions: 1,
      positions: [
        SavingsPortfolioPositionDraft(
          id: 'ms1',
          product: 'USDT Linh hoạt',
          asset: 'USDT',
          type: SavingsProductType.flexible,
          amount: '3,500.00 USDT',
          usdValue: '\$3,500.00',
          allocationLabel: '33.8%',
          earned: '+14.58 USDT',
          apy: '4.5%',
          startDate: '01/02/2026',
          status: 'Đang hoạt động',
          progress: 0.34,
          tone: EarnRiskLevel.low,
        ),
        SavingsPortfolioPositionDraft(
          id: 'ms2',
          product: 'BTC Cố định 60D',
          asset: 'BTC',
          type: SavingsProductType.locked,
          amount: '0.020000 BTC',
          usdValue: '\$1,350.86',
          allocationLabel: '13.1%',
          earned: '+0.000019 BTC',
          apy: '3.5%',
          startDate: '15/01/2026',
          endDate: '16/03/2026',
          status: 'Gần đáo hạn',
          progress: 0.88,
          tone: EarnRiskLevel.medium,
          daysLeft: 7,
        ),
        SavingsPortfolioPositionDraft(
          id: 'ms3',
          product: 'SOL Cố định 30D',
          asset: 'SOL',
          type: SavingsProductType.locked,
          amount: '25.0000 SOL',
          usdValue: '\$3,250.00',
          allocationLabel: '31.4%',
          earned: '+0.45 SOL',
          apy: '6.5%',
          startDate: '20/02/2026',
          endDate: '22/03/2026',
          status: 'Sắp tới',
          progress: 0.57,
          tone: EarnRiskLevel.high,
          daysLeft: 13,
        ),
        SavingsPortfolioPositionDraft(
          id: 'ms4',
          product: 'ETH Linh hoạt',
          asset: 'ETH',
          type: SavingsProductType.flexible,
          amount: '0.8000 ETH',
          usdValue: '\$2,240.00',
          allocationLabel: '21.7%',
          earned: '+0.0012 ETH',
          apy: '2.8%',
          startDate: '05/02/2026',
          status: 'Đang hoạt động',
          progress: 0.22,
          tone: EarnRiskLevel.low,
        ),
      ],
      incomeProjections: [
        SavingsIncomeProjectionDraft(
          label: 'Hằng ngày',
          value: '~\$1.31',
          icon: 'day',
        ),
        SavingsIncomeProjectionDraft(
          label: 'Hằng tháng',
          value: '~\$39.35',
          icon: 'month',
        ),
        SavingsIncomeProjectionDraft(
          label: 'Hằng năm',
          value: '~\$478.75',
          icon: 'year',
        ),
      ],
      maturityEvents: [
        SavingsMaturityEventDraft(
          id: 'ms2',
          product: 'BTC Cố định 60D',
          asset: 'BTC',
          amount: '0.020000 BTC',
          usdValue: '\$1,350.86',
          apy: 'APY 3.5%',
          progress: 0.88,
          date: '16/03/2026',
          daysLeft: 7,
          elapsedLabel: '53/60 ngày',
          tone: EarnRiskLevel.medium,
        ),
        SavingsMaturityEventDraft(
          id: 'ms3',
          product: 'SOL Cố định 30D',
          asset: 'SOL',
          amount: '25.0000 SOL',
          usdValue: '\$3,250.00',
          apy: 'APY 6.5%',
          progress: 0.57,
          date: '22/03/2026',
          daysLeft: 13,
          elapsedLabel: '17/30 ngày',
          tone: EarnRiskLevel.high,
        ),
        SavingsMaturityEventDraft(
          id: 'ms5',
          product: 'ETH Cố định 90D',
          asset: 'ETH',
          amount: '0.500000 ETH',
          usdValue: '\$1,400.00',
          apy: 'APY 4.2%',
          progress: 0.26,
          date: '15/05/2026',
          daysLeft: 67,
          elapsedLabel: '23/90 ngày',
          tone: EarnRiskLevel.low,
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

final class MockSavingsHistoryRepository implements SavingsHistoryRepository {
  const MockSavingsHistoryRepository();

  @override
  SavingsHistorySnapshot getHistory() {
    return const SavingsHistorySnapshot(
      endpoint: '/api/mobile/earn/earn-savings-history',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Lịch sử Tiết kiệm',
      backRoute: '/earn/savings',
      receiptRoute: '/earn/savings/receipt',
      totalSubscribed: '\$10,340.86',
      totalInterest: '\$72.62',
      totalRedeemed: '\$0.00',
      searchPlaceholder: 'Tìm theo tài sản, sản phẩm, mã GD...',
      transactions: [
        SavingsHistoryTransactionDraft(
          id: 'stx12',
          type: SavingsHistoryTransactionType.earlyRedeem,
          status: SavingsHistoryTransactionStatus.pending,
          asset: 'SOL',
          amount: '-10.0000 SOL',
          usdValue: '≈ \$1,300.00',
          product: 'SOL Cố định 30D',
          date: '08/03/2026',
          time: '11:30',
          referenceId: 'RDM-SOLE-0308-ABCD',
          note: 'Rút sớm - phí phạt 1.2%',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx10',
          type: SavingsHistoryTransactionType.interest,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'SOL',
          amount: '+0.450000 SOL',
          usdValue: '≈ \$58.50',
          product: 'SOL Cố định 30D',
          date: '05/03/2026',
          time: '00:00',
          referenceId: 'INT-SOL-0305-AUTO',
          note: 'Lãi cố định phân phối',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx11',
          type: SavingsHistoryTransactionType.interest,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'ETH',
          amount: '+0.001200 ETH',
          usdValue: '≈ \$3.36',
          product: 'ETH Linh hoạt',
          date: '05/03/2026',
          time: '00:00',
          referenceId: 'INT-ETH-0305-AUTO',
          note: 'Lãi tự động phân phối',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx08',
          type: SavingsHistoryTransactionType.compound,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'USDT',
          amount: '+5.1000 USDT',
          usdValue: '≈ \$5.10',
          product: 'USDT Linh hoạt',
          date: '01/03/2026',
          time: '00:01',
          referenceId: 'CMP-USDT-0301-AUTO',
          note: 'Tái đầu tư tự động vào gốc',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx07',
          type: SavingsHistoryTransactionType.interest,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'USDT',
          amount: '+5.1000 USDT',
          usdValue: '≈ \$5.10',
          product: 'USDT Linh hoạt',
          date: '01/03/2026',
          time: '00:00',
          referenceId: 'INT-USDT-0301-AUTO',
          note: 'Lãi tự động phân phối',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx09',
          type: SavingsHistoryTransactionType.interest,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'BTC',
          amount: '+0.00001900 BTC',
          usdValue: '≈ \$1.28',
          product: 'BTC Cố định 60D',
          date: '01/03/2026',
          time: '00:00',
          referenceId: 'INT-BTC-0301-AUTO',
          note: 'Lãi cố định phân phối',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx04',
          type: SavingsHistoryTransactionType.subscribe,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'SOL',
          amount: '25.0000 SOL',
          usdValue: '≈ \$3,250.00',
          product: 'SOL Cố định 30D',
          date: '20/02/2026',
          time: '09:45',
          referenceId: 'SAV-SOLQ-8834-RTYU',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx05',
          type: SavingsHistoryTransactionType.compound,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'USDT',
          amount: '+4.3800 USDT',
          usdValue: '≈ \$4.38',
          product: 'USDT Linh hoạt',
          date: '15/02/2026',
          time: '00:01',
          referenceId: 'CMP-USDT-0215-AUTO',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx03',
          type: SavingsHistoryTransactionType.interest,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'USDT',
          amount: '+4.3800 USDT',
          usdValue: '≈ \$4.38',
          product: 'USDT Linh hoạt',
          date: '15/02/2026',
          time: '00:00',
          referenceId: 'INT-USDT-0215-AUTO',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx06',
          type: SavingsHistoryTransactionType.subscribe,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'ETH',
          amount: '0.800000 ETH',
          usdValue: '≈ \$2,240.00',
          product: 'ETH Linh hoạt',
          date: '05/02/2026',
          time: '16:20',
          referenceId: 'SAV-ETHF-6612-JKLM',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx01',
          type: SavingsHistoryTransactionType.subscribe,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'USDT',
          amount: '3,500.00 USDT',
          usdValue: '≈ \$3,500.00',
          product: 'USDT Linh hoạt',
          date: '01/02/2026',
          time: '10:15',
          referenceId: 'SAV-DJKL-7823-MNPQ',
        ),
        SavingsHistoryTransactionDraft(
          id: 'stx02',
          type: SavingsHistoryTransactionType.subscribe,
          status: SavingsHistoryTransactionStatus.completed,
          asset: 'BTC',
          amount: '0.020000 BTC',
          usdValue: '≈ \$1,350.86',
          product: 'BTC Cố định 60D',
          date: '15/01/2026',
          time: '14:32',
          referenceId: 'SAV-BKLM-4521-WXYZ',
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

final class MockSavingsGuideRepository implements SavingsGuideRepository {
  const MockSavingsGuideRepository();

  @override
  SavingsGuideSnapshot getGuide() {
    return const SavingsGuideSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-guide',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Hướng dẫn Tiết kiệm',
      backRoute: '/earn/savings',
      savingsRoute: '/earn/savings',
      tabs: [
        SavingsGuideTabDraft(id: 'tutorials', label: 'Hướng dẫn'),
        SavingsGuideTabDraft(id: 'glossary', label: 'Thuật ngữ'),
      ],
      defaultTab: 'tutorials',
      heroTitle: 'Tiết kiệm Crypto từ Zero',
      heroSubtitle:
          'Hướng dẫn từng bước để bắt đầu gửi tiết kiệm và kiếm lãi thụ động từ crypto. Không cần kiến thức kỹ thuật phức tạp.',
      tutorials: [
        SavingsGuideTutorialDraft(
          id: 'savings-basic',
          title: 'Tiết kiệm Crypto là gì?',
          duration: '4 phút',
          difficulty: SavingsGuideDifficulty.beginner,
          description:
              'Hiểu cơ bản về gửi tiết kiệm crypto và cách kiếm lãi thụ động.',
          steps: [
            SavingsGuideStepDraft(
              id: 'sb1',
              title: 'Tiết kiệm Crypto hoạt động thế nào?',
              description:
                  'Bạn gửi tài sản vào sản phẩm tiết kiệm và nhận lãi hằng ngày. Tài sản được dùng để cung cấp thanh khoản cho thị trường vay mượn, phần lãi được phân phối lại cho bạn.',
              iconKey: 'piggy',
              tips: [
                'Bạn vẫn sở hữu 100% tài sản đã gửi',
                'Lãi được tính và phân phối tự động hằng ngày',
                'Không cần kiến thức kỹ thuật phức tạp',
              ],
            ),
            SavingsGuideStepDraft(
              id: 'sb2',
              title: 'Linh hoạt vs Cố định',
              description:
                  'Linh hoạt cho phép rút bất kỳ lúc nào nhưng APY thấp hơn. Cố định yêu cầu khóa tài sản theo kỳ hạn 30, 60 hoặc 90 ngày để nhận APY cao hơn.',
              iconKey: 'lock',
              tips: [
                'Linh hoạt phù hợp với nhu cầu thanh khoản',
                'Cố định phù hợp với khoản không cần dùng ngắn hạn',
                'Đọc kỹ điều khoản rút sớm trước khi gửi',
              ],
            ),
            SavingsGuideStepDraft(
              id: 'sb3',
              title: 'Bắt đầu gửi tiết kiệm',
              description:
                  'Chọn sản phẩm phù hợp, nhập số lượng, xem lại điều khoản và xác nhận gửi. Lãi sẽ bắt đầu tính theo lịch của sản phẩm.',
              iconKey: 'check',
              tips: [
                'Kiểm tra số dư khả dụng trước khi gửi',
                'Bắt đầu với số nhỏ để làm quen',
                'Bật auto-compound nếu muốn tối ưu lãi kép',
              ],
            ),
          ],
        ),
        SavingsGuideTutorialDraft(
          id: 'savings-optimize',
          title: 'Tối ưu lãi suất Tiết kiệm',
          duration: '6 phút',
          difficulty: SavingsGuideDifficulty.intermediate,
          description:
              'Chiến lược nâng cao để tối đa hóa thu nhập từ tiết kiệm crypto.',
          steps: [
            SavingsGuideStepDraft(
              id: 'so1',
              title: 'Chiến lược phân bổ Ladder',
              description:
                  'Chia tài sản vào nhiều sản phẩm với kỳ hạn khác nhau để cân bằng APY và thanh khoản.',
              iconKey: 'trend',
              tips: [
                'Giữ một phần ở Linh hoạt để có thanh khoản',
                'Kỳ hạn dài hơn thường có APY cao hơn',
                'Review phân bổ mỗi tháng khi có kỳ đáo hạn',
              ],
            ),
            SavingsGuideStepDraft(
              id: 'so2',
              title: 'Tái đầu tư tự động',
              description:
                  'Auto-compound tự động gộp lãi vào gốc để tạo lãi kép và cải thiện APY thực tế.',
              iconKey: 'zap',
              tips: [
                'Bật auto-compound cho sản phẩm Linh hoạt',
                'Theo dõi lãi thực tế trong Portfolio',
                'Đánh giá lại nếu cần dòng tiền định kỳ',
              ],
            ),
            SavingsGuideStepDraft(
              id: 'so3',
              title: 'Theo dõi APY và thời điểm',
              description:
                  'APY thay đổi theo cung cầu thị trường. Theo dõi xu hướng APY để chọn thời điểm gửi Cố định tối ưu.',
              iconKey: 'calculator',
              tips: [
                'Bật thông báo khi APY thay đổi mạnh',
                'So sánh APY giữa các tài sản',
                'Ưu tiên stablecoin nếu muốn giảm biến động giá',
              ],
            ),
          ],
        ),
        SavingsGuideTutorialDraft(
          id: 'savings-risk',
          title: 'Rủi ro & An toàn Tiết kiệm',
          duration: '5 phút',
          difficulty: SavingsGuideDifficulty.advanced,
          description:
              'Hiểu rủi ro và cách bảo vệ tài sản trong tiết kiệm crypto.',
          steps: [
            SavingsGuideStepDraft(
              id: 'sr1',
              title: 'Các loại rủi ro cần biết',
              description:
                  'Tiết kiệm crypto có rủi ro nền tảng, rủi ro thị trường, rủi ro thanh khoản và rủi ro kỹ thuật. Hãy phân bổ phù hợp với khẩu vị rủi ro.',
              iconKey: 'alert',
              tips: [
                'Stablecoin giúp giảm biến động giá',
                'Sản phẩm Linh hoạt giảm rủi ro thanh khoản',
                'Không gửi toàn bộ tài sản vào một kỳ hạn',
              ],
            ),
            SavingsGuideStepDraft(
              id: 'sr2',
              title: 'Rút sớm sản phẩm Cố định',
              description:
                  'Rút trước đáo hạn có thể làm mất một phần hoặc toàn bộ lãi đã tích lũy. Luôn xem preview phí trước khi xác nhận.',
              iconKey: 'shield',
              tips: [
                'Đọc kỹ chính sách rút sớm',
                'Một số sản phẩm không cho phép rút sớm',
                'Preview phải hiển thị phí và lãi bị mất',
              ],
            ),
            SavingsGuideStepDraft(
              id: 'sr3',
              title: 'Bảo mật tài khoản',
              description:
                  'Bật 2FA, quản lý thiết bị và anti-phishing code trước khi gửi số lượng lớn.',
              iconKey: 'shield',
              tips: [
                'Bật 2FA trước khi gửi tiết kiệm',
                'Kiểm tra thiết bị đăng nhập định kỳ',
                'Không chia sẻ OTP hoặc link xác nhận',
              ],
            ),
          ],
        ),
      ],
      quickTips: [
        SavingsGuideQuickTipDraft(
          id: 'small',
          title: 'Bắt đầu nhỏ',
          description: 'Gửi \$50-200 đầu tiên để làm quen với hệ thống',
          iconKey: 'piggy',
          tone: EarnRiskLevel.low,
        ),
        SavingsGuideQuickTipDraft(
          id: 'apy',
          title: 'Theo dõi APY',
          description: 'APY thay đổi liên tục, kiểm tra hằng tuần',
          iconKey: 'trend',
          tone: EarnRiskLevel.medium,
        ),
        SavingsGuideQuickTipDraft(
          id: 'security',
          title: 'Bật 2FA',
          description: 'Bảo vệ tài khoản trước khi gửi số lượng lớn',
          iconKey: 'shield',
          tone: EarnRiskLevel.high,
        ),
        SavingsGuideQuickTipDraft(
          id: 'compound',
          title: 'Auto-compound',
          description: 'Bật tái đầu tư tự động để tối đa lãi kép',
          iconKey: 'zap',
          tone: EarnRiskLevel.medium,
        ),
        SavingsGuideQuickTipDraft(
          id: 'ladder',
          title: 'Ladder strategy',
          description: 'Chia tài sản vào nhiều kỳ hạn khác nhau',
          iconKey: 'lock',
          tone: EarnRiskLevel.low,
        ),
        SavingsGuideQuickTipDraft(
          id: 'fee',
          title: 'Tính phí rút sớm',
          description: 'Luôn kiểm tra phí trước khi rút Cố định sớm',
          iconKey: 'calculator',
          tone: EarnRiskLevel.medium,
        ),
      ],
      terms: [
        SavingsGuideTermDraft(
          term: 'APY',
          definition:
              'Annual Percentage Yield - lãi suất hằng năm đã tính lãi kép',
        ),
        SavingsGuideTermDraft(
          term: 'Linh hoạt',
          definition: 'Sản phẩm rút tự do bất kỳ lúc nào, APY thấp hơn Cố định',
        ),
        SavingsGuideTermDraft(
          term: 'Cố định',
          definition:
              'Sản phẩm khóa kỳ hạn, APY cao hơn, có thể có phí rút sớm',
        ),
        SavingsGuideTermDraft(
          term: 'Auto-compound',
          definition: 'Tự động gộp lãi vào gốc để tạo lãi kép',
        ),
        SavingsGuideTermDraft(
          term: 'Rút sớm',
          definition:
              'Rút trước đáo hạn Cố định, có thể mất lãi hoặc chịu phí phạt',
        ),
        SavingsGuideTermDraft(
          term: 'Đáo hạn',
          definition: 'Ngày kết thúc kỳ hạn khóa, gốc và lãi trả về ví',
        ),
        SavingsGuideTermDraft(
          term: 'Quỹ Bảo hiểm',
          definition:
              'Quỹ dự phòng bảo vệ một phần tài sản user khi xảy ra sự cố',
        ),
      ],
      disclaimer:
          'Thuật ngữ và giải thích mang tính giáo dục, không phải lời khuyên tài chính. Luôn tự nghiên cứu trước khi đưa ra quyết định đầu tư.',
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

final class MockSavingsFAQRepository implements SavingsFAQRepository {
  const MockSavingsFAQRepository();

  @override
  SavingsFAQSnapshot getFAQ() {
    return const SavingsFAQSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-faq',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'FAQ Tiết kiệm',
      backRoute: '/earn/savings',
      supportRoute: '/support',
      heroTitle: 'Câu hỏi thường gặp',
      heroSubtitle:
          'Tìm câu trả lời cho các thắc mắc phổ biến về Tiết kiệm Crypto. Không tìm thấy? Liên hệ hỗ trợ bất kỳ lúc nào.',
      searchPlaceholder: 'Tìm câu hỏi...',
      categories: [
        SavingsFAQCategoryDraft(id: 'all', label: 'Tất cả', category: null),
        SavingsFAQCategoryDraft(
          id: 'general',
          label: 'Tổng quan',
          category: SavingsFAQCategory.general,
        ),
        SavingsFAQCategoryDraft(
          id: 'products',
          label: 'Sản phẩm',
          category: SavingsFAQCategory.products,
        ),
        SavingsFAQCategoryDraft(
          id: 'operations',
          label: 'Thao tác',
          category: SavingsFAQCategory.operations,
        ),
        SavingsFAQCategoryDraft(
          id: 'fees',
          label: 'Phí & Lãi',
          category: SavingsFAQCategory.fees,
        ),
        SavingsFAQCategoryDraft(
          id: 'risks',
          label: 'Rủi ro',
          category: SavingsFAQCategory.risks,
        ),
      ],
      items: [
        SavingsFAQItemDraft(
          id: 'g1',
          category: SavingsFAQCategory.general,
          question: 'Tiết kiệm Crypto là gì?',
          answer:
              'Tiết kiệm Crypto cho phép bạn gửi tài sản kỹ thuật số như USDT, BTC, ETH hoặc SOL vào sản phẩm tiết kiệm để nhận lãi hằng ngày. Bạn vẫn sở hữu tài sản đã gửi.',
        ),
        SavingsFAQItemDraft(
          id: 'g2',
          category: SavingsFAQCategory.general,
          question: 'Tiết kiệm có khác Staking không?',
          answer:
              'Có. Staking phục vụ bảo mật blockchain và có rủi ro validator. Tiết kiệm là pool thanh khoản đơn giản hơn, thường ít phức tạp hơn nhưng APY cũng thấp hơn một chút.',
        ),
        SavingsFAQItemDraft(
          id: 'g3',
          category: SavingsFAQCategory.general,
          question: 'Tôi có mất quyền sở hữu tài sản khi gửi tiết kiệm không?',
          answer:
              'Không. Bạn vẫn sở hữu tài sản đã gửi và nhận lại gốc cùng lãi theo điều khoản của sản phẩm khi rút hoặc đáo hạn.',
        ),
        SavingsFAQItemDraft(
          id: 'g4',
          category: SavingsFAQCategory.general,
          question: 'Tôi cần tối thiểu bao nhiêu để bắt đầu?',
          answer:
              'Số lượng tối thiểu tùy sản phẩm, thường từ 1 USDT hoặc tương đương. Người mới nên bắt đầu với khoản nhỏ để làm quen.',
        ),
        SavingsFAQItemDraft(
          id: 'p1',
          category: SavingsFAQCategory.products,
          question: 'Linh hoạt và Cố định khác nhau thế nào?',
          answer:
              'Linh hoạt cho phép rút bất kỳ lúc nào và APY thấp hơn. Cố định khóa 30/60/90 ngày, APY cao hơn nhưng rút sớm có thể chịu phí.',
        ),
        SavingsFAQItemDraft(
          id: 'p2',
          category: SavingsFAQCategory.products,
          question: 'Auto-compound là gì?',
          answer:
              'Auto-compound tự động gộp lãi nhận được vào gốc để tạo lãi kép, giúp APY thực tế cải thiện so với nhận lãi riêng.',
        ),
        SavingsFAQItemDraft(
          id: 'p3',
          category: SavingsFAQCategory.products,
          question: 'Tôi có thể gửi nhiều sản phẩm cùng lúc không?',
          answer:
              'Có. Bạn có thể chia tài sản vào nhiều sản phẩm và kỳ hạn khác nhau để cân bằng giữa lãi suất và thanh khoản.',
        ),
        SavingsFAQItemDraft(
          id: 'p4',
          category: SavingsFAQCategory.products,
          question: 'Sản phẩm nào phù hợp với người mới?',
          answer:
              'Người mới nên bắt đầu với sản phẩm Linh hoạt trên stablecoin như USDT hoặc USDC vì dễ rút và ít biến động giá hơn.',
        ),
        SavingsFAQItemDraft(
          id: 'o1',
          category: SavingsFAQCategory.operations,
          question: 'Làm sao để gửi tiết kiệm?',
          answer:
              'Vào Tiết kiệm, chọn sản phẩm, xem APY và điều khoản, nhập số lượng, xem lại chi tiết rồi xác nhận. Lãi bắt đầu tích lũy theo lịch sản phẩm.',
        ),
        SavingsFAQItemDraft(
          id: 'o2',
          category: SavingsFAQCategory.operations,
          question: 'Rút tiết kiệm mất bao lâu?',
          answer:
              'Linh hoạt thường rút tức thì hoặc trong vài phút. Cố định đáo hạn tự trả về ví; rút sớm có thể mất thêm thời gian xử lý.',
        ),
        SavingsFAQItemDraft(
          id: 'o3',
          category: SavingsFAQCategory.operations,
          question: 'Tôi có thể rút một phần không?',
          answer:
              'Linh hoạt cho phép rút một phần. Cố định tùy từng sản phẩm; một số yêu cầu rút toàn bộ hoặc áp dụng phí trên phần rút.',
        ),
        SavingsFAQItemDraft(
          id: 'o4',
          category: SavingsFAQCategory.operations,
          question: 'Lãi được trả khi nào?',
          answer:
              'Linh hoạt thường tính và phân phối hằng ngày. Cố định có thể phân phối hằng ngày hoặc tích lũy đến ngày đáo hạn tùy sản phẩm.',
        ),
        SavingsFAQItemDraft(
          id: 'f1',
          category: SavingsFAQCategory.fees,
          question: 'Có phí gì khi gửi tiết kiệm không?',
          answer:
              'Gửi và rút Linh hoạt thường miễn phí. Rút sớm Cố định có thể mất lãi đã tích lũy hoặc chịu phí phạt theo điều khoản.',
        ),
        SavingsFAQItemDraft(
          id: 'f2',
          category: SavingsFAQCategory.fees,
          question: 'APY có cố định hay thay đổi?',
          answer:
              'APY Linh hoạt thay đổi theo thị trường. APY Cố định được khóa tại thời điểm gửi trong suốt kỳ hạn.',
        ),
        SavingsFAQItemDraft(
          id: 'f3',
          category: SavingsFAQCategory.fees,
          question: 'Phí rút sớm Cố định tính thế nào?',
          answer:
              'Phí rút sớm thường gồm mất một phần hoặc toàn bộ lãi tích lũy và có thể thêm phí trên số gốc rút. Preview phải hiển thị rõ trước xác nhận.',
        ),
        SavingsFAQItemDraft(
          id: 'r1',
          category: SavingsFAQCategory.risks,
          question: 'Tiết kiệm Crypto có rủi ro gì?',
          answer:
              'Có rủi ro nền tảng, thị trường, thanh khoản và kỹ thuật. Stablecoin giảm biến động giá nhưng không loại bỏ toàn bộ rủi ro.',
        ),
        SavingsFAQItemDraft(
          id: 'r2',
          category: SavingsFAQCategory.risks,
          question: 'Quỹ Bảo hiểm hoạt động thế nào?',
          answer:
              'Quỹ Bảo hiểm là quỹ dự phòng hỗ trợ user khi xảy ra sự cố nền tảng. Quỹ không bảo vệ khỏi thua lỗ do biến động giá thị trường.',
        ),
        SavingsFAQItemDraft(
          id: 'r3',
          category: SavingsFAQCategory.risks,
          question: 'Tài sản của tôi có an toàn không?',
          answer:
              'VitTrade áp dụng nhiều lớp bảo mật như 2FA, quản lý thiết bị, cold storage và audit định kỳ. Không hệ thống nào an toàn tuyệt đối.',
        ),
        SavingsFAQItemDraft(
          id: 'r4',
          category: SavingsFAQCategory.risks,
          question: 'Tôi nên gửi bao nhiêu % tổng tài sản?',
          answer:
              'Không nên gửi toàn bộ tài sản. Hãy giữ một phần liquid cho giao dịch hoặc tình huống khẩn cấp và chia sản phẩm theo kỳ hạn.',
        ),
      ],
      supportTitle: 'Vẫn cần hỗ trợ?',
      supportSubtitle: 'Liên hệ đội ngũ hỗ trợ 24/7',
      disclaimer:
          'Thông tin FAQ mang tính giáo dục và giải thích chung. Điều khoản chi tiết của từng sản phẩm có thể khác nhau - luôn đọc kỹ trước khi gửi tiết kiệm.',
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

final class MockSavingsNotificationsRepository
    implements SavingsNotificationsRepository {
  const MockSavingsNotificationsRepository();

  @override
  SavingsNotificationsSnapshot getNotifications() {
    return const SavingsNotificationsSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-notifications',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      settingsActionDraft: 'PATCH /user/settings/earn-savings-notifications',
      clearActionDraft: 'DELETE /user/settings/earn-savings-notifications/log',
      title: 'Thông báo Tiết kiệm',
      backRoute: '/earn/savings',
      tabs: [
        SavingsNotificationTabDraft(id: 'history', label: 'Thông báo'),
        SavingsNotificationTabDraft(id: 'settings', label: 'Cài đặt'),
      ],
      defaultTab: 'history',
      history: [
        SavingsNotificationDraft(
          id: 'nh1',
          type: SavingsNotificationType.maturity,
          title: 'BTC Cố định 60D sắp đáo hạn',
          message:
              'Vị thế của bạn sẽ đáo hạn vào 16/03/2026 (còn 7 ngày). Gốc + lãi sẽ tự động trả về ví.',
          time: '1 giờ trước',
          read: false,
        ),
        SavingsNotificationDraft(
          id: 'nh2',
          type: SavingsNotificationType.apy,
          title: 'APY USDT Linh hoạt tăng lên 4.8%',
          message:
              'APY tăng từ 4.5% lên 4.8% (+0.3%). Lãi hằng ngày của bạn tăng ~\$0.03.',
          time: '3 giờ trước',
          read: false,
        ),
        SavingsNotificationDraft(
          id: 'nh3',
          type: SavingsNotificationType.interest,
          title: 'Nhận lãi hôm nay: +\$1.19',
          message:
              'Đã phân phối lãi từ 4 vị thế. Tổng lãi tháng này: \$35.55. Auto-compound đã gộp vào gốc.',
          time: '6 giờ trước',
          read: false,
        ),
        SavingsNotificationDraft(
          id: 'nh4',
          type: SavingsNotificationType.compound,
          title: 'Auto-compound thành công',
          message:
              'Đã tự động gộp \$1.19 lãi vào gốc USDT Linh hoạt. Gốc mới: \$3,514.58. APY hiệu quả: 4.62%.',
          time: '6 giờ trước',
          read: true,
        ),
        SavingsNotificationDraft(
          id: 'nh5',
          type: SavingsNotificationType.maturity,
          title: 'SOL Cố định 30D sắp đáo hạn',
          message:
              'Vị thế sẽ đáo hạn vào 22/03/2026 (còn 13 ngày). Bạn sẽ nhận 25 SOL + 0.45 SOL lãi.',
          time: '1 ngày trước',
          read: true,
        ),
        SavingsNotificationDraft(
          id: 'nh6',
          type: SavingsNotificationType.product,
          title: 'Sản phẩm mới: AVAX Cố định 30D',
          message:
              'AVAX Cố định 30D đã ra mắt với APY khởi đầu 8.2%. Quota có hạn - 35% đã được đăng ký.',
          time: '2 ngày trước',
          read: true,
        ),
        SavingsNotificationDraft(
          id: 'nh7',
          type: SavingsNotificationType.system,
          title: 'Báo cáo tuần 03/03 - 09/03',
          message:
              'Tổng lãi tuần: \$8.07 | APY TB: 4.18% | Portfolio: \$10,340.86 (+0.08%). Chi tiết trong Danh mục.',
          time: '2 ngày trước',
          read: true,
        ),
        SavingsNotificationDraft(
          id: 'nh8',
          type: SavingsNotificationType.interest,
          title: 'Nhận lãi hôm qua: +\$1.16',
          message:
              'Đã phân phối lãi từ 4 vị thế. USDT: +\$0.43, BTC: +\$0.01, SOL: +\$0.46, ETH: +\$0.26.',
          time: '1 ngày trước',
          read: true,
        ),
      ],
      settings: [
        SavingsNotificationSettingDraft(
          id: 'maturity',
          title: 'Sắp đáo hạn',
          description:
              'Nhận thông báo 3 ngày và 24 giờ trước khi sản phẩm Cố định đáo hạn',
          iconKey: 'calendar',
          enabled: true,
          priority: SavingsNotificationPriority.high,
        ),
        SavingsNotificationSettingDraft(
          id: 'apy-change',
          title: 'Thay đổi APY',
          description:
              'Thông báo khi APY sản phẩm Linh hoạt thay đổi trên 0.5%',
          iconKey: 'trend',
          enabled: true,
          priority: SavingsNotificationPriority.high,
        ),
        SavingsNotificationSettingDraft(
          id: 'early-redeem-risk',
          title: 'Cảnh báo rút sớm',
          description: 'Nhắc nhở phí phạt trước khi xác nhận rút sớm Cố định',
          iconKey: 'shield',
          enabled: true,
          priority: SavingsNotificationPriority.high,
        ),
        SavingsNotificationSettingDraft(
          id: 'interest-paid',
          title: 'Nhận lãi',
          description:
              'Thông báo hằng ngày khi lãi được phân phối vào ví tiết kiệm',
          iconKey: 'piggy',
          enabled: false,
          priority: SavingsNotificationPriority.medium,
        ),
        SavingsNotificationSettingDraft(
          id: 'capacity-warning',
          title: 'Sắp hết quota',
          description:
              'Thông báo khi sản phẩm bạn quan tâm sắp hết capacity (>90%)',
          iconKey: 'alert',
          enabled: true,
          priority: SavingsNotificationPriority.medium,
        ),
        SavingsNotificationSettingDraft(
          id: 'compound-done',
          title: 'Tái đầu tư hoàn tất',
          description: 'Thông báo khi auto-compound tự động gộp lãi vào gốc',
          iconKey: 'zap',
          enabled: true,
          priority: SavingsNotificationPriority.low,
        ),
        SavingsNotificationSettingDraft(
          id: 'new-product',
          title: 'Sản phẩm mới',
          description:
              'Thông báo khi có sản phẩm tiết kiệm mới với APY hấp dẫn',
          iconKey: 'bell',
          enabled: true,
          priority: SavingsNotificationPriority.low,
        ),
        SavingsNotificationSettingDraft(
          id: 'weekly-summary',
          title: 'Báo cáo tuần',
          description:
              'Tổng kết lãi nhận được, APY trung bình, portfolio update hằng tuần',
          iconKey: 'trend',
          enabled: true,
          priority: SavingsNotificationPriority.low,
        ),
      ],
      settingsTitle: 'Quản lý Thông báo',
      settingsSubtitle:
          'Tùy chỉnh thông báo để không bỏ lỡ sự kiện quan trọng.',
      disclaimer:
          'Thông báo quan trọng (đáo hạn, cảnh báo rủi ro) được khuyến nghị luôn bật. Bạn có thể quản lý thông báo push chung trong Cài đặt hệ thống.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData. Settings changes use a module settings PATCH draft.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsRecommendationsRepository
    implements SavingsRecommendationsRepository {
  const MockSavingsRecommendationsRepository();

  @override
  SavingsRecommendationsSnapshot getRecommendations() {
    return const SavingsRecommendationsSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-recommendations',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Gợi ý Tiết kiệm',
      backRoute: '/earn/savings',
      riskAssessmentRoute: '/earn/savings/risk-assessment',
      savingsRoute: '/earn/savings',
      heroTitle: 'Gợi ý Tiết kiệm Cá nhân hóa',
      heroSubtitle:
          'Dựa trên mức chấp nhận rủi ro, thời gian đầu tư, và nhu cầu thanh khoản, chúng tôi đề xuất chiến lược tiết kiệm tối ưu cho bạn.',
      profile: SavingsUserProfileDraft(
        riskTolerance: SavingsProfileRiskTolerance.moderate,
        investmentHorizon: SavingsInvestmentHorizon.medium,
        liquidityNeed: SavingsLiquidityNeed.medium,
        totalAvailable: 15000,
        preferredAssets: ['USDT', 'BTC', 'ETH'],
        hasCompletedAssessment: true,
        assessmentDate: '05/03/2026',
      ),
      strategies: [
        SavingsStrategyDraft(
          id: 'stable-yield',
          title: 'Lãi suất Ổn định',
          subtitle: 'Bảo toàn vốn, thanh khoản cao',
          description:
              'Ưu tiên stablecoin linh hoạt và cố định ngắn hạn. Phù hợp cho người mới hoặc cần dùng tiền bất kỳ lúc nào.',
          matchScore: 72,
          expectedApy: 4.7,
          riskLevel: SavingsStrategyRiskLevel.low,
          liquidityRatio: 75,
          allocation: [
            SavingsStrategyAllocationDraft(
              product: 'USDT Linh hoạt',
              asset: 'USDT',
              type: SavingsStrategyAllocationType.flexible,
              percentage: 60,
              apy: 4.5,
            ),
            SavingsStrategyAllocationDraft(
              product: 'USDT Cố định 30D',
              asset: 'USDT',
              type: SavingsStrategyAllocationType.locked,
              percentage: 25,
              apy: 7.2,
              lockDays: 30,
            ),
            SavingsStrategyAllocationDraft(
              product: 'BTC Linh hoạt',
              asset: 'BTC',
              type: SavingsStrategyAllocationType.flexible,
              percentage: 15,
              apy: 1.8,
            ),
          ],
          pros: [
            '75% thanh khoản tức thì, rút bất kỳ lúc nào',
            'Stablecoin chiếm 85%, giảm biến động giá',
            'APY ổn định, dễ theo dõi cho người mới',
            'Phù hợp số tiền lớn trên \$10,000',
          ],
          cons: [
            'APY thấp nhất trong các chiến lược',
            'Phụ thuộc vào stablecoin và rủi ro đối tác',
            'Không tận dụng nhiều upside khi thị trường tăng',
          ],
          bestFor: [
            'Người mới bắt đầu gửi tiết kiệm',
            'Cần thanh khoản cao',
            'Không quen thuộc với biến động crypto',
          ],
        ),
        SavingsStrategyDraft(
          id: 'balanced-growth',
          title: 'Tăng trưởng Cân bằng',
          subtitle: 'Mix linh hoạt + cố định, APY cao hơn',
          description:
              'Cân bằng giữa thanh khoản và lợi suất. Kết hợp stablecoin, BTC, và altcoin top, phù hợp đa số users.',
          matchScore: 94,
          expectedApy: 6.1,
          riskLevel: SavingsStrategyRiskLevel.medium,
          liquidityRatio: 30,
          recommended: true,
          allocation: [
            SavingsStrategyAllocationDraft(
              product: 'USDT Linh hoạt',
              asset: 'USDT',
              type: SavingsStrategyAllocationType.flexible,
              percentage: 30,
              apy: 4.5,
            ),
            SavingsStrategyAllocationDraft(
              product: 'USDT Cố định 90D',
              asset: 'USDT',
              type: SavingsStrategyAllocationType.locked,
              percentage: 25,
              apy: 9.8,
              lockDays: 90,
            ),
            SavingsStrategyAllocationDraft(
              product: 'BTC Cố định 60D',
              asset: 'BTC',
              type: SavingsStrategyAllocationType.locked,
              percentage: 25,
              apy: 3.5,
              lockDays: 60,
            ),
            SavingsStrategyAllocationDraft(
              product: 'SOL Cố định 30D',
              asset: 'SOL',
              type: SavingsStrategyAllocationType.locked,
              percentage: 20,
              apy: 6.5,
              lockDays: 30,
            ),
          ],
          pros: [
            'APY cao hơn khoảng 30% so với chiến lược an toàn',
            'Đa dạng hóa stablecoin + BTC + SOL',
            'Vẫn giữ 30% thanh khoản tức thì',
            'Kỳ hạn khác nhau tạo dòng tiền khi đáo hạn',
          ],
          cons: [
            'Rủi ro giá BTC và SOL ảnh hưởng tổng giá trị',
            '70% bị khóa, không rút ngay được',
            'Cần theo dõi lịch đáo hạn',
          ],
          bestFor: [
            'Users có kinh nghiệm crypto cơ bản',
            'Tổng tiền \$5,000-\$50,000',
            'Chấp nhận rủi ro vừa phải',
            'Không cần dùng tiền gấp trong 1-3 tháng',
          ],
        ),
        SavingsStrategyDraft(
          id: 'max-yield',
          title: 'Tối đa Lợi suất',
          subtitle: 'Lock dài hạn, APY cao nhất',
          description:
              'Tối ưu APY bằng cách lock dài hạn và altcoin. Phù hợp cho tiền dư dài hạn, không cần thanh khoản.',
          matchScore: 58,
          expectedApy: 6.0,
          riskLevel: SavingsStrategyRiskLevel.high,
          liquidityRatio: 20,
          allocation: [
            SavingsStrategyAllocationDraft(
              product: 'USDT Cố định 90D',
              asset: 'USDT',
              type: SavingsStrategyAllocationType.locked,
              percentage: 30,
              apy: 9.8,
              lockDays: 90,
            ),
            SavingsStrategyAllocationDraft(
              product: 'BTC Cố định 60D',
              asset: 'BTC',
              type: SavingsStrategyAllocationType.locked,
              percentage: 25,
              apy: 3.5,
              lockDays: 60,
            ),
            SavingsStrategyAllocationDraft(
              product: 'SOL Cố định 30D',
              asset: 'SOL',
              type: SavingsStrategyAllocationType.locked,
              percentage: 25,
              apy: 6.5,
              lockDays: 30,
            ),
            SavingsStrategyAllocationDraft(
              product: 'ETH Linh hoạt',
              asset: 'ETH',
              type: SavingsStrategyAllocationType.flexible,
              percentage: 20,
              apy: 2.1,
            ),
          ],
          pros: [
            'APY cao nhất, tối đa hóa lợi suất',
            '80% locked để nhận lãi suất tốt hơn',
            'Đa dạng hóa nhiều loại crypto',
          ],
          cons: [
            'Chỉ 20% thanh khoản tức thì',
            'Rủi ro giá crypto cao hơn',
            'Rút sớm sản phẩm cố định sẽ mất lãi',
          ],
          bestFor: [
            'Experienced crypto users',
            'Không cần dùng tiền trong 3+ tháng',
            'Sẵn sàng chấp nhận biến động giá',
          ],
        ),
      ],
      insights: [
        SavingsRecommendationInsightDraft(
          id: 'fit',
          title: 'Phù hợp nhất với bạn',
          description:
              'Moderate risk + Medium horizon → Tăng trưởng Cân bằng (Match 94%)',
          iconKey: 'target',
          tone: EarnRiskLevel.medium,
        ),
        SavingsRecommendationInsightDraft(
          id: 'income',
          title: 'Ước tính thu nhập',
          description: 'Với \$15,000, bạn có thể kiếm khoảng \$915/năm',
          iconKey: 'calculator',
          tone: EarnRiskLevel.low,
        ),
        SavingsRecommendationInsightDraft(
          id: 'risk',
          title: 'Lưu ý rủi ro',
          description:
              'APY có thể thay đổi. Sản phẩm cố định không rút sớm được mà không mất lãi.',
          iconKey: 'shield',
          tone: EarnRiskLevel.high,
        ),
        SavingsRecommendationInsightDraft(
          id: 'maturity',
          title: 'Đáo hạn đa kỳ',
          description:
              'Chọn nhiều kỳ hạn khác nhau để có dòng tiền liên tục khi đáo hạn.',
          iconKey: 'clock',
          tone: EarnRiskLevel.medium,
        ),
      ],
      disclaimer:
          'Đây chỉ là gợi ý dựa trên hồ sơ của bạn, không phải tư vấn tài chính. APY có thể thay đổi theo điều kiện thị trường. Sản phẩm cố định rút sớm sẽ mất toàn bộ lãi. Bạn nên tự đánh giá và chịu trách nhiệm cho quyết định đầu tư.',
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

final class MockSavingsRiskAssessmentRepository
    implements SavingsRiskAssessmentRepository {
  const MockSavingsRiskAssessmentRepository();

  @override
  SavingsRiskAssessmentSnapshot getRiskAssessment() {
    return const SavingsRiskAssessmentSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-risk-assessment',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Đánh giá Rủi ro',
      resultTitle: 'Kết quả Đánh giá',
      backRoute: '/earn/savings',
      savingsRoute: '/earn/savings',
      recommendationsRoute: '/earn/savings/recommendations',
      questions: [
        SavingsRiskQuestionDraft(
          id: 'experience',
          question: 'Kinh nghiệm đầu tư / tiết kiệm crypto của bạn?',
          options: [
            SavingsRiskOptionDraft(
              label: 'Hoàn toàn mới',
              value: 0,
              description: 'Chưa từng gửi tiết kiệm crypto',
            ),
            SavingsRiskOptionDraft(
              label: 'Cơ bản',
              value: 1,
              description: 'Đã dùng flexible savings 1-2 lần',
            ),
            SavingsRiskOptionDraft(
              label: 'Có kinh nghiệm',
              value: 2,
              description: 'Đã dùng flexible + locked savings',
            ),
            SavingsRiskOptionDraft(
              label: 'Thành thạo',
              value: 3,
              description: 'Hiểu rõ APY, lock period, risks',
            ),
          ],
        ),
        SavingsRiskQuestionDraft(
          id: 'savings-goal',
          question: 'Mục tiêu gửi tiết kiệm chính của bạn?',
          options: [
            SavingsRiskOptionDraft(
              label: 'Bảo toàn vốn',
              value: 0,
              description: 'Giữ tiền an toàn, lãi nhẹ là đủ',
            ),
            SavingsRiskOptionDraft(
              label: 'Thu nhập thụ động',
              value: 1,
              description: 'Kiếm lãi đều đặn hằng tháng',
            ),
            SavingsRiskOptionDraft(
              label: 'Tăng trưởng',
              value: 2,
              description: 'Tối đa hóa lợi suất trong trung hạn',
            ),
            SavingsRiskOptionDraft(
              label: 'Tối đa APY',
              value: 3,
              description: 'Sẵn sàng lock dài để APY cao nhất',
            ),
          ],
        ),
        SavingsRiskQuestionDraft(
          id: 'risk-tolerance',
          question: 'Bạn phản ứng thế nào nếu tài sản giảm 15-20%?',
          helpText:
              'Giá crypto biến động - ảnh hưởng giá trị sản phẩm cố định BTC/ETH/SOL.',
          options: [
            SavingsRiskOptionDraft(
              label: 'Rất lo lắng, muốn rút ngay',
              value: 0,
            ),
            SavingsRiskOptionDraft(label: 'Lo nhưng chờ đáo hạn', value: 1),
            SavingsRiskOptionDraft(
              label: 'Bình tĩnh, chấp nhận biến động',
              value: 2,
            ),
            SavingsRiskOptionDraft(
              label: 'Không quan tâm, giữ dài hạn',
              value: 3,
            ),
          ],
        ),
        SavingsRiskQuestionDraft(
          id: 'liquidity',
          question: 'Bạn có cần dùng khoản tiền này trong thời gian ngắn?',
          helpText: 'Sản phẩm cố định không rút sớm được mà không mất lãi.',
          options: [
            SavingsRiskOptionDraft(
              label: 'Có thể cần bất kỳ lúc nào',
              value: 0,
            ),
            SavingsRiskOptionDraft(
              label: 'Có thể cần trong 1-2 tháng',
              value: 1,
            ),
            SavingsRiskOptionDraft(
              label: 'Không cần trong 3-6 tháng',
              value: 2,
            ),
            SavingsRiskOptionDraft(
              label: 'Tiền dư - không cần trong 6+ tháng',
              value: 3,
            ),
          ],
        ),
        SavingsRiskQuestionDraft(
          id: 'asset-preference',
          question: 'Bạn ưu tiên loại tài sản nào để tiết kiệm?',
          options: [
            SavingsRiskOptionDraft(
              label: 'Chỉ stablecoin (USDT/USDC)',
              value: 0,
              description: 'Không rủi ro biến động giá',
            ),
            SavingsRiskOptionDraft(
              label: 'Stablecoin + BTC/ETH',
              value: 1,
              description: 'Mix an toàn + blue-chip crypto',
            ),
            SavingsRiskOptionDraft(
              label: 'Đa dạng (+ altcoin top)',
              value: 2,
              description: 'Thêm SOL, AVAX, etc.',
            ),
            SavingsRiskOptionDraft(
              label: 'APY cao nhất, bất kỳ asset',
              value: 3,
              description: 'Ưu tiên lợi suất trên hết',
            ),
          ],
        ),
        SavingsRiskQuestionDraft(
          id: 'lock-comfort',
          question: 'Bạn thoải mái với kỳ hạn lock bao lâu?',
          helpText: 'Lock càng dài -> APY càng cao, nhưng không rút sớm được.',
          options: [
            SavingsRiskOptionDraft(
              label: 'Chỉ linh hoạt (flexible)',
              value: 0,
              description: 'Rút bất kỳ lúc nào',
            ),
            SavingsRiskOptionDraft(
              label: 'Cố định ngắn (≤30 ngày)',
              value: 1,
              description: 'Lock tối đa 1 tháng',
            ),
            SavingsRiskOptionDraft(
              label: 'Cố định vừa (31-90 ngày)',
              value: 2,
              description: 'Sẵn sàng lock 1-3 tháng',
            ),
            SavingsRiskOptionDraft(
              label: 'Cố định dài (90+ ngày)',
              value: 3,
              description: 'Lock dài để APY cao nhất',
            ),
          ],
        ),
        SavingsRiskQuestionDraft(
          id: 'amount-ratio',
          question:
              'Khoản tiết kiệm này chiếm bao nhiêu % tổng tài sản crypto?',
          options: [
            SavingsRiskOptionDraft(
              label: 'Phần lớn (>60%)',
              value: 0,
              description: 'Cần cẩn thận - an toàn trước',
            ),
            SavingsRiskOptionDraft(label: 'Kha khá (30-60%)', value: 1),
            SavingsRiskOptionDraft(label: 'Một phần (10-30%)', value: 2),
            SavingsRiskOptionDraft(
              label: 'Rất nhỏ (<10%)',
              value: 3,
              description: 'Tiền dư - sẵn sàng chấp nhận rủi ro',
            ),
          ],
        ),
      ],
      results: [
        SavingsRiskProfileResultDraft(
          level: SavingsRiskProfileLevel.conservative,
          minScore: 0,
          maxScore: 7,
          label: 'Thận trọng (Conservative)',
          description:
              'Bạn ưu tiên an toàn và bảo toàn vốn. Nên chọn sản phẩm linh hoạt hoặc cố định ngắn hạn với stablecoin.',
          strategyMatch: 'Lãi suất Ổn định',
          recommendations: [
            'Ưu tiên sản phẩm Linh hoạt - rút bất kỳ lúc nào',
            'Stablecoin chiếm 60-80% danh mục tiết kiệm',
            'Cố định ngắn hạn 30 ngày cho phần còn lại',
            'Tránh lock dài 90+ ngày nếu chưa sẵn sàng',
          ],
          products: [
            SavingsRiskProductDraft(
              name: 'USDT Linh hoạt',
              apy: '4.5%',
              risk: 'Rất thấp',
              type: SavingsStrategyAllocationType.flexible,
              asset: 'USDT',
            ),
            SavingsRiskProductDraft(
              name: 'USDT Cố định 30D',
              apy: '7.2%',
              risk: 'Thấp',
              type: SavingsStrategyAllocationType.locked,
              asset: 'USDT',
            ),
            SavingsRiskProductDraft(
              name: 'BTC Linh hoạt',
              apy: '1.8%',
              risk: 'Thấp',
              type: SavingsStrategyAllocationType.flexible,
              asset: 'BTC',
            ),
          ],
          warnings: [
            'Stablecoin vẫn có rủi ro counterparty',
            'APY có thể thay đổi theo điều kiện thị trường',
          ],
        ),
        SavingsRiskProfileResultDraft(
          level: SavingsRiskProfileLevel.moderate,
          minScore: 8,
          maxScore: 14,
          label: 'Cân bằng (Moderate)',
          description:
              'Bạn chấp nhận rủi ro vừa phải để đổi lấy lợi suất cao hơn. Nên mix giữa linh hoạt và cố định, stablecoin và blue-chip crypto.',
          strategyMatch: 'Tăng trưởng Cân bằng',
          recommendations: [
            'Mix 30-40% Flexible + 60-70% Fixed nhiều kỳ hạn',
            'Đa dạng hóa: USDT, BTC, ETH hoặc SOL',
            'Chọn kỳ hạn khác nhau để dòng tiền liên tục',
            'Theo dõi ngày đáo hạn và gia hạn kịp thời',
          ],
          products: [
            SavingsRiskProductDraft(
              name: 'USDT Linh hoạt',
              apy: '4.5%',
              risk: 'Thấp',
              type: SavingsStrategyAllocationType.flexible,
              asset: 'USDT',
            ),
            SavingsRiskProductDraft(
              name: 'USDT Cố định 90D',
              apy: '9.8%',
              risk: 'Thấp',
              type: SavingsStrategyAllocationType.locked,
              asset: 'USDT',
            ),
            SavingsRiskProductDraft(
              name: 'BTC Cố định 60D',
              apy: '3.5%',
              risk: 'Trung bình',
              type: SavingsStrategyAllocationType.locked,
              asset: 'BTC',
            ),
            SavingsRiskProductDraft(
              name: 'SOL Cố định 30D',
              apy: '6.5%',
              risk: 'Trung bình',
              type: SavingsStrategyAllocationType.locked,
              asset: 'SOL',
            ),
          ],
          warnings: [
            'Giá BTC/SOL có thể biến động 20-30% trong 30-90 ngày',
            'Rút sớm sản phẩm cố định sẽ mất toàn bộ lãi tích lũy',
            'Cần theo dõi ngày đáo hạn để tái ký kịp thời',
          ],
        ),
        SavingsRiskProfileResultDraft(
          level: SavingsRiskProfileLevel.aggressive,
          minScore: 15,
          maxScore: 21,
          label: 'Năng động (Aggressive)',
          description:
              'Bạn ưu tiên tối đa hóa lợi suất, sẵn sàng chấp nhận rủi ro biến động giá và lock dài hạn.',
          strategyMatch: 'Tối đa Lợi suất',
          recommendations: [
            'Ưu tiên sản phẩm Cố định 60-90 ngày',
            'Đa dạng altcoin: SOL, ETH cùng USDT fixed',
            'Giữ tối thiểu 15-20% flexible cho thanh khoản khẩn cấp',
            'Theo dõi thị trường để quyết định khi đáo hạn',
          ],
          products: [
            SavingsRiskProductDraft(
              name: 'USDT Cố định 90D',
              apy: '9.8%',
              risk: 'Thấp',
              type: SavingsStrategyAllocationType.locked,
              asset: 'USDT',
            ),
            SavingsRiskProductDraft(
              name: 'BTC Cố định 60D',
              apy: '3.5%',
              risk: 'Trung bình',
              type: SavingsStrategyAllocationType.locked,
              asset: 'BTC',
            ),
            SavingsRiskProductDraft(
              name: 'SOL Cố định 30D',
              apy: '6.5%',
              risk: 'Trung bình',
              type: SavingsStrategyAllocationType.locked,
              asset: 'SOL',
            ),
            SavingsRiskProductDraft(
              name: 'ETH Linh hoạt',
              apy: '2.1%',
              risk: 'Thấp',
              type: SavingsStrategyAllocationType.flexible,
              asset: 'ETH',
            ),
          ],
          warnings: [
            'Lock dài hạn = không rút sớm. Đảm bảo bạn không cần tiền',
            'Altcoin có thể giảm 30-50% trong thời gian lock',
            'APY không phải lợi nhuận đảm bảo',
            'Phân tán nhiều sản phẩm để giảm rủi ro tập trung',
          ],
        ),
      ],
      infoText:
          'Trả lời trung thực để nhận gợi ý sản phẩm tiết kiệm phù hợp. Kết quả có thể thay đổi khi làm lại.',
      footerDisclaimer:
          'Hồ sơ rủi ro được lưu trong tài khoản. Bạn có thể đánh giá lại bất kỳ lúc nào. Đây không phải tư vấn tài chính - bạn chịu trách nhiệm cho quyết định đầu tư.',
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

final class MockStakingRiskAssessmentRepository
    implements StakingRiskAssessmentRepository {
  const MockStakingRiskAssessmentRepository();

  @override
  StakingRiskAssessmentSnapshot getRiskAssessment() {
    return const StakingRiskAssessmentSnapshot(
      endpoint: '/api/mobile/earn/earn-staking-risk-assessment',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; source /earn/staking/risk-assessment',
      title: 'Đánh giá Rủi ro',
      resultTitle: 'Kết quả Đánh giá',
      backRoute: '/earn/staking',
      stakingRoute: '/earn/staking',
      questions: [
        StakingRiskQuestionDraft(
          id: 'experience',
          question: 'Kinh nghiệm đầu tư crypto của bạn?',
          options: [
            StakingRiskOptionDraft(label: 'Người mới (< 6 tháng)', value: 0),
            StakingRiskOptionDraft(
              label: 'Trung bình (6 tháng - 2 năm)',
              value: 1,
            ),
            StakingRiskOptionDraft(label: 'Có kinh nghiệm (2-5 năm)', value: 2),
            StakingRiskOptionDraft(label: 'Chuyên nghiệp (> 5 năm)', value: 3),
          ],
        ),
        StakingRiskQuestionDraft(
          id: 'knowledge',
          question: 'Hiểu biết về staking?',
          options: [
            StakingRiskOptionDraft(label: 'Không biết gì', value: 0),
            StakingRiskOptionDraft(
              label: 'Hiểu cơ bản (APY, lock-up)',
              value: 1,
            ),
            StakingRiskOptionDraft(
              label: 'Hiểu rõ (validator, slashing, unbonding)',
              value: 2,
            ),
            StakingRiskOptionDraft(
              label: 'Chuyên gia (PoS, DeFi, liquid staking)',
              value: 3,
            ),
          ],
        ),
        StakingRiskQuestionDraft(
          id: 'risk-tolerance',
          question: 'Khả năng chấp nhận rủi ro?',
          options: [
            StakingRiskOptionDraft(
              label: 'Thấp - Không muốn mất tiền',
              value: 0,
            ),
            StakingRiskOptionDraft(
              label: 'Trung bình - Chấp nhận mất 10-20%',
              value: 1,
            ),
            StakingRiskOptionDraft(
              label: 'Cao - Chấp nhận mất 20-50%',
              value: 2,
            ),
            StakingRiskOptionDraft(
              label: 'Rất cao - Chấp nhận mất >50%',
              value: 3,
            ),
          ],
        ),
        StakingRiskQuestionDraft(
          id: 'reaction',
          question: 'Nếu tài sản giảm 30%, bạn sẽ?',
          options: [
            StakingRiskOptionDraft(
              label: 'Hoảng sợ và muốn rút ngay',
              value: 0,
            ),
            StakingRiskOptionDraft(label: 'Lo lắng nhưng giữ', value: 1),
            StakingRiskOptionDraft(label: 'Bình tĩnh, chờ hồi phục', value: 2),
            StakingRiskOptionDraft(label: 'Mua thêm (buy the dip)', value: 3),
          ],
        ),
        StakingRiskQuestionDraft(
          id: 'horizon',
          question: 'Thời gian đầu tư dự kiến?',
          options: [
            StakingRiskOptionDraft(label: '< 3 tháng (ngắn hạn)', value: 0),
            StakingRiskOptionDraft(label: '3-12 tháng (trung hạn)', value: 1),
            StakingRiskOptionDraft(label: '1-3 năm (dài hạn)', value: 2),
            StakingRiskOptionDraft(label: '> 3 năm (rất dài hạn)', value: 3),
          ],
        ),
        StakingRiskQuestionDraft(
          id: 'liquidity',
          question: 'Bạn có cần tiền khẩn cấp không?',
          options: [
            StakingRiskOptionDraft(
              label: 'Có thể cần bất kỳ lúc nào',
              value: 0,
            ),
            StakingRiskOptionDraft(label: 'Có thể cần trong 6 tháng', value: 1),
            StakingRiskOptionDraft(label: 'Không cần trong 1 năm', value: 2),
            StakingRiskOptionDraft(
              label: 'Hoàn toàn không cần (tiền dư)',
              value: 3,
            ),
          ],
        ),
        StakingRiskQuestionDraft(
          id: 'allocation',
          question: 'Bạn định stake bao nhiêu % tổng tài sản crypto?',
          options: [
            StakingRiskOptionDraft(label: '< 10%', value: 3),
            StakingRiskOptionDraft(label: '10-30%', value: 2),
            StakingRiskOptionDraft(label: '30-50%', value: 1),
            StakingRiskOptionDraft(label: '> 50%', value: 0),
          ],
        ),
      ],
      results: [
        StakingRiskProfileResultDraft(
          level: StakingRiskProfileLevel.conservative,
          minScore: 0,
          maxScore: 7,
          label: 'Bảo thủ (Conservative)',
          description:
              'Bạn ưu tiên an toàn và bảo toàn vốn. Tránh rủi ro cao và ưu tiên thanh khoản.',
          recommendations: [
            'Staking Linh hoạt - APY thấp hơn nhưng có thể rút bất kỳ lúc nào',
            'Staking Cố định 30-60 ngày với kỳ hạn ngắn',
            'Chọn tài sản ổn định: USDT, USDC, BTC, ETH',
            'Phân tán qua nhiều sản phẩm, mỗi sản phẩm < 20% tổng tài sản',
            'Tránh DeFi staking, fixed >90 ngày và altcoin rủi ro cao',
          ],
          products: [
            StakingRiskAssessmentProductDraft(
              name: 'USDT Linh hoạt',
              apy: '4.5%',
              risk: 'Thấp',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'BTC Cố định 30D',
              apy: '5.8%',
              risk: 'Thấp',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'ETH Linh hoạt',
              apy: '4.2%',
              risk: 'Thấp',
            ),
          ],
          warnings: [
            'APY có thể thay đổi theo điều kiện thị trường',
            'Không stake phần tài sản cần dùng trong ngắn hạn',
          ],
        ),
        StakingRiskProfileResultDraft(
          level: StakingRiskProfileLevel.moderate,
          minScore: 8,
          maxScore: 14,
          label: 'Cân bằng (Moderate)',
          description:
              'Bạn chấp nhận một mức rủi ro hợp lý để đổi lấy lợi nhuận cao hơn.',
          recommendations: [
            'Mix Flexible và Fixed Staking theo tỷ trọng 50-50',
            'Staking cố định 60-90 ngày để tăng APY',
            'Mix stablecoin 40%, BTC/ETH 40%, altcoin top 20 20%',
            'Có thể thử DeFi staking với tỷ trọng nhỏ dưới 10%',
            'Theo dõi thị trường và điều chỉnh allocation định kỳ',
          ],
          products: [
            StakingRiskAssessmentProductDraft(
              name: 'USDT Cố định 60D',
              apy: '6.5%',
              risk: 'Thấp',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'ETH Cố định 90D',
              apy: '7.2%',
              risk: 'Trung bình',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'SOL Cố định 60D',
              apy: '9.8%',
              risk: 'Trung bình',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'ETH-USDT LP Pool',
              apy: '18.7%',
              risk: 'Cao (nhỏ)',
            ),
          ],
          warnings: [
            'Giá tài sản có thể biến động trong thời gian lock',
            'Rút sớm sản phẩm cố định có thể mất phần thưởng tích lũy',
          ],
        ),
        StakingRiskProfileResultDraft(
          level: StakingRiskProfileLevel.aggressive,
          minScore: 15,
          maxScore: 21,
          label: 'Năng động (Aggressive)',
          description:
              'Bạn sẵn sàng chấp nhận rủi ro cao để tối đa hóa lợi nhuận.',
          recommendations: [
            'Ưu tiên Fixed Staking 90-365 ngày với APY cao hơn',
            'DeFi staking trong giới hạn kiểm soát rủi ro',
            'Liquid staking để tăng thanh khoản khi cần',
            'Chọn altcoin tiềm năng như SOL, AVAX, MATIC, ADA',
            'Sử dụng Validator Selection để chọn validator phù hợp',
            'Tham gia Dual Rewards nếu hiểu rõ cơ chế thưởng',
          ],
          products: [
            StakingRiskAssessmentProductDraft(
              name: 'SOL Cố định 180D',
              apy: '12.3%',
              risk: 'Trung bình',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'AVAX Cố định 90D',
              apy: '14.5%',
              risk: 'Cao',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'ETH-USDT LP Pool',
              apy: '24.5%',
              risk: 'Rất cao',
            ),
            StakingRiskAssessmentProductDraft(
              name: 'BNB Liquid Staking',
              apy: '9.2%',
              risk: 'Trung bình',
            ),
          ],
          warnings: [
            'APY cao không đồng nghĩa lợi nhuận được bảo đảm',
            'DeFi và LP pool có rủi ro smart contract và impermanent loss',
            'Luôn giữ phần tài sản thanh khoản cho tình huống khẩn cấp',
          ],
        ),
      ],
      infoText:
          'Trả lời trung thực để nhận được gợi ý sản phẩm phù hợp với tình hình tài chính và mục tiêu đầu tư của bạn.',
      footerDisclaimer:
          'Hồ sơ rủi ro được lưu trong tài khoản của bạn. Bạn có thể làm lại bài đánh giá bất kỳ lúc nào để cập nhật gợi ý sản phẩm phù hợp.',
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

final class MockStakingDashboardRepository
    implements StakingDashboardRepository {
  const MockStakingDashboardRepository();

  @override
  StakingDashboardSnapshot getDashboard() {
    return const StakingDashboardSnapshot(
      endpoint: '/api/mobile/earn/earn-dashboard',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; realtime-refresh on /earn/dashboard',
      title: 'Staking Dashboard',
      backRoute: '/earn/staking',
      stakingRoute: '/earn/staking',
      analyticsRoute: '/earn/analytics',
      historyRoute: '/earn/history',
      calendarRoute: '/earn/calendar',
      totalStakedUsd: 17577,
      totalEarnedUsd: 315.82,
      weightedApy: 8.45,
      dailyEarningsUsd: 4.07,
      monthlyEarningsUsd: 122.04,
      yearlyProjectionUsd: 1484.77,
      activePositions: 3,
      maturingSoon: 2,
      performance: [
        StakingPerformancePointDraft(
          date: '01/01',
          valueUsd: 15000,
          earnedUsd: 0,
        ),
        StakingPerformancePointDraft(
          date: '15/01',
          valueUsd: 15120,
          earnedUsd: 120,
        ),
        StakingPerformancePointDraft(
          date: '01/02',
          valueUsd: 15280,
          earnedUsd: 280,
        ),
        StakingPerformancePointDraft(
          date: '15/02',
          valueUsd: 15450,
          earnedUsd: 450,
        ),
        StakingPerformancePointDraft(
          date: '01/03',
          valueUsd: 15640,
          earnedUsd: 640,
        ),
        StakingPerformancePointDraft(
          date: '07/03',
          valueUsd: 15577,
          earnedUsd: 315.82,
        ),
      ],
      allocations: [
        StakingAllocationDraft(asset: 'BTC', valueUsd: 3377, colorIndex: 0),
        StakingAllocationDraft(asset: 'USDT', valueUsd: 2500, colorIndex: 1),
        StakingAllocationDraft(asset: 'ETH', valueUsd: 4200, colorIndex: 2),
        StakingAllocationDraft(asset: 'SOL', valueUsd: 6500, colorIndex: 3),
        StakingAllocationDraft(asset: 'LP', valueUsd: 1000, colorIndex: 4),
      ],
      positions: [
        StakingPositionDraft(
          id: 'p1',
          product: 'BTC Fixed 90D',
          asset: 'BTC',
          type: StakingDashboardPositionType.fixed,
          amount: 0.05,
          usdValue: 3377,
          earned: 0.00029,
          earnedUsd: 19.58,
          apy: 5.8,
          startDate: '01/01/2026',
          endDate: '01/04/2026',
          status: StakingDashboardPositionStatus.active,
          colorIndex: 0,
        ),
        StakingPositionDraft(
          id: 'p2',
          product: 'USDT Flexible',
          asset: 'USDT',
          type: StakingDashboardPositionType.flexible,
          amount: 2500,
          usdValue: 2500,
          earned: 18.74,
          earnedUsd: 18.74,
          apy: 6.5,
          startDate: '15/01/2026',
          endDate: null,
          status: StakingDashboardPositionStatus.active,
          colorIndex: 1,
        ),
        StakingPositionDraft(
          id: 'p3',
          product: 'ETH Fixed 60D',
          asset: 'ETH',
          type: StakingDashboardPositionType.fixed,
          amount: 1.5,
          usdValue: 4200,
          earned: 0.035,
          earnedUsd: 98,
          apy: 7.2,
          startDate: '20/01/2026',
          endDate: '21/03/2026',
          status: StakingDashboardPositionStatus.maturing,
          colorIndex: 2,
          daysUntilMaturity: 65,
        ),
        StakingPositionDraft(
          id: 'p4',
          product: 'SOL Fixed 30D',
          asset: 'SOL',
          type: StakingDashboardPositionType.fixed,
          amount: 50,
          usdValue: 6500,
          earned: 1.2,
          earnedUsd: 156,
          apy: 9.8,
          startDate: '01/02/2026',
          endDate: '03/03/2026',
          status: StakingDashboardPositionStatus.maturing,
          colorIndex: 3,
          daysUntilMaturity: 83,
        ),
        StakingPositionDraft(
          id: 'p5',
          product: 'ETH-USDT LP',
          asset: 'LP',
          type: StakingDashboardPositionType.defi,
          amount: 1000,
          usdValue: 1000,
          earned: 23.5,
          earnedUsd: 23.5,
          apy: 18.7,
          startDate: '10/02/2026',
          endDate: null,
          status: StakingDashboardPositionStatus.active,
          colorIndex: 4,
        ),
      ],
      alertTitle: '2 vị thế sắp đáo hạn',
      alertBody: 'Kiểm tra lịch nhận lãi để không bỏ lỡ rewards',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, and realtime-refresh.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.realtimeRefresh,
      },
    );
  }
}

final class MockStakingAnalyticsRepository
    implements StakingAnalyticsRepository {
  const MockStakingAnalyticsRepository();

  @override
  StakingAnalyticsSnapshot getAnalytics() {
    return const StakingAnalyticsSnapshot(
      endpoint: '/api/mobile/earn/earn-analytics',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; realtime-refresh on /earn/analytics',
      title: 'Phân tích Hiệu suất',
      backRoute: '/earn/dashboard',
      defaultTab: 'earnings',
      tabs: [
        StakingAnalyticsTabDraft(id: 'earnings', label: 'Thu nhập'),
        StakingAnalyticsTabDraft(id: 'apy', label: 'APY Trends'),
        StakingAnalyticsTabDraft(id: 'roi', label: 'ROI So sánh'),
        StakingAnalyticsTabDraft(id: 'products', label: 'Sản phẩm'),
      ],
      summary: StakingAnalyticsSummaryDraft(
        totalEarned: 315.82,
        averageApy: 7.2,
        bestRoi: 2.4,
      ),
      earningsBreakdown: [
        StakingEarningsPointDraft(
          date: '01/01',
          btc: 0,
          usdt: 0,
          eth: 0,
          sol: 0,
          lp: 0,
          total: 0,
        ),
        StakingEarningsPointDraft(
          date: '15/01',
          btc: 5.2,
          usdt: 12.3,
          eth: 0,
          sol: 0,
          lp: 0,
          total: 17.5,
        ),
        StakingEarningsPointDraft(
          date: '01/02',
          btc: 10.8,
          usdt: 24.6,
          eth: 15.2,
          sol: 0,
          lp: 0,
          total: 50.6,
        ),
        StakingEarningsPointDraft(
          date: '15/02',
          btc: 16.2,
          usdt: 36.9,
          eth: 32.4,
          sol: 18.5,
          lp: 5.8,
          total: 109.8,
        ),
        StakingEarningsPointDraft(
          date: '01/03',
          btc: 21.5,
          usdt: 49.2,
          eth: 51.6,
          sol: 42.3,
          lp: 14.2,
          total: 178.8,
        ),
        StakingEarningsPointDraft(
          date: '07/03',
          btc: 19.58,
          usdt: 18.74,
          eth: 98,
          sol: 156,
          lp: 23.5,
          total: 315.82,
        ),
      ],
      apyTrends: [
        StakingApyTrendPointDraft(
          date: '01/01',
          flexible: 4.5,
          fixed: 6.2,
          defi: 22.5,
        ),
        StakingApyTrendPointDraft(
          date: '15/01',
          flexible: 4.3,
          fixed: 6.0,
          defi: 21.8,
        ),
        StakingApyTrendPointDraft(
          date: '01/02',
          flexible: 4.8,
          fixed: 6.5,
          defi: 23.2,
        ),
        StakingApyTrendPointDraft(
          date: '15/02',
          flexible: 5.0,
          fixed: 7.0,
          defi: 24.5,
        ),
        StakingApyTrendPointDraft(
          date: '01/03',
          flexible: 4.7,
          fixed: 6.8,
          defi: 22.9,
        ),
        StakingApyTrendPointDraft(
          date: '07/03',
          flexible: 4.5,
          fixed: 6.5,
          defi: 20.8,
        ),
      ],
      roiComparison: [
        StakingRoiComparisonPointDraft(
          month: 'T1',
          staking: 2.1,
          holding: -3.5,
        ),
        StakingRoiComparisonPointDraft(month: 'T2', staking: 4.8, holding: 1.2),
        StakingRoiComparisonPointDraft(month: 'T3', staking: 7.2, holding: 5.8),
        StakingRoiComparisonPointDraft(month: 'T4', staking: 9.8, holding: 7.2),
        StakingRoiComparisonPointDraft(
          month: 'T5',
          staking: 12.5,
          holding: 9.1,
        ),
        StakingRoiComparisonPointDraft(
          month: 'T6',
          staking: 15.3,
          holding: 11.8,
        ),
      ],
      productPerformance: [
        StakingProductPerformanceDraft(
          product: 'BTC Fixed 90D',
          asset: 'BTC',
          investedUsd: 3377,
          earnedUsd: 19.58,
          roi: 0.58,
          apy: 5.8,
          colorIndex: 0,
        ),
        StakingProductPerformanceDraft(
          product: 'USDT Flexible',
          asset: 'USDT',
          investedUsd: 2500,
          earnedUsd: 18.74,
          roi: 0.75,
          apy: 6.5,
          colorIndex: 1,
        ),
        StakingProductPerformanceDraft(
          product: 'ETH Fixed 60D',
          asset: 'ETH',
          investedUsd: 4200,
          earnedUsd: 98,
          roi: 2.33,
          apy: 7.2,
          colorIndex: 2,
        ),
        StakingProductPerformanceDraft(
          product: 'SOL Fixed 30D',
          asset: 'SOL',
          investedUsd: 6500,
          earnedUsd: 156,
          roi: 2.4,
          apy: 9.8,
          colorIndex: 3,
        ),
        StakingProductPerformanceDraft(
          product: 'ETH-USDT LP',
          asset: 'LP',
          investedUsd: 1000,
          earnedUsd: 23.5,
          roi: 2.35,
          apy: 18.7,
          colorIndex: 4,
        ),
      ],
      footerNote:
          'Dữ liệu được cập nhật theo thời gian thực. APY có thể thay đổi dựa trên điều kiện thị trường. ROI tính theo giá trị USD tại thời điểm hiện tại.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, and realtime-refresh state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.realtimeRefresh,
      },
    );
  }
}

final class MockStakingHistoryRepository implements StakingHistoryRepository {
  const MockStakingHistoryRepository();

  @override
  StakingHistorySnapshot getHistory() {
    return const StakingHistorySnapshot(
      endpoint: '/api/mobile/earn/earn-history',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Lịch sử Staking',
      backRoute: '/earn/dashboard',
      totalStakedUsd: 17577,
      totalEarnedUsd: 92.07,
      totalUnstakedUsd: 6656,
      searchPlaceholder: 'Tìm asset, sản phẩm, ID...',
      transactions: [
        StakingHistoryTransactionDraft(
          id: 'tx1',
          type: StakingHistoryTransactionType.stake,
          asset: 'BTC',
          amountLabel: '0.050000',
          usdValue: 3377,
          product: 'BTC Fixed 90D',
          date: '01/01/2026',
          time: '14:23',
          status: StakingHistoryTransactionStatus.completed,
          txHash: '0x1234...5678',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx2',
          type: StakingHistoryTransactionType.stake,
          asset: 'USDT',
          amountLabel: '2,500.00',
          usdValue: 2500,
          product: 'USDT Flexible',
          date: '15/01/2026',
          time: '09:45',
          status: StakingHistoryTransactionStatus.completed,
          txHash: '0xabcd...ef12',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx3',
          type: StakingHistoryTransactionType.claim,
          asset: 'BTC',
          amountLabel: '+0.00015000',
          usdValue: 10.13,
          product: 'BTC Fixed 90D',
          date: '01/02/2026',
          time: '00:00',
          status: StakingHistoryTransactionStatus.completed,
          note: 'Nhận lãi tự động',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx4',
          type: StakingHistoryTransactionType.stake,
          asset: 'ETH',
          amountLabel: '1.5000',
          usdValue: 4200,
          product: 'ETH Fixed 60D',
          date: '20/01/2026',
          time: '16:12',
          status: StakingHistoryTransactionStatus.completed,
          txHash: '0x9876...5432',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx5',
          type: StakingHistoryTransactionType.claim,
          asset: 'USDT',
          amountLabel: '+8.5000',
          usdValue: 8.5,
          product: 'USDT Flexible',
          date: '15/02/2026',
          time: '00:00',
          status: StakingHistoryTransactionStatus.completed,
          note: 'Nhận lãi tự động',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx6',
          type: StakingHistoryTransactionType.stake,
          asset: 'SOL',
          amountLabel: '50.0000',
          usdValue: 6500,
          product: 'SOL Fixed 30D',
          date: '01/02/2026',
          time: '11:30',
          status: StakingHistoryTransactionStatus.completed,
          txHash: '0xdef0...9abc',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx7',
          type: StakingHistoryTransactionType.compound,
          asset: 'USDT',
          amountLabel: '+10.2400',
          usdValue: 10.24,
          product: 'USDT Flexible',
          date: '01/03/2026',
          time: '00:00',
          status: StakingHistoryTransactionStatus.completed,
          note: 'Tái đầu tư tự động',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx8',
          type: StakingHistoryTransactionType.stake,
          asset: 'LP',
          amountLabel: '1,000.00',
          usdValue: 1000,
          product: 'ETH-USDT LP',
          date: '10/02/2026',
          time: '13:45',
          status: StakingHistoryTransactionStatus.completed,
          txHash: '0x1111...2222',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx9',
          type: StakingHistoryTransactionType.claim,
          asset: 'ETH',
          amountLabel: '+0.018000',
          usdValue: 50.4,
          product: 'ETH Fixed 60D',
          date: '20/02/2026',
          time: '00:00',
          status: StakingHistoryTransactionStatus.completed,
          note: 'Nhận lãi tự động',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx10',
          type: StakingHistoryTransactionType.unstake,
          asset: 'SOL',
          amountLabel: '+51.2000',
          usdValue: 6656,
          product: 'SOL Fixed 30D',
          date: '03/03/2026',
          time: '10:15',
          status: StakingHistoryTransactionStatus.pending,
          note: 'Đang xử lý unbonding',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx11',
          type: StakingHistoryTransactionType.penalty,
          asset: 'BTC',
          amountLabel: '-0.00005000',
          usdValue: 3.38,
          product: 'BTC Fixed 90D',
          date: '05/02/2026',
          time: '14:20',
          status: StakingHistoryTransactionStatus.completed,
          note: 'Phí rút sớm',
        ),
        StakingHistoryTransactionDraft(
          id: 'tx12',
          type: StakingHistoryTransactionType.claim,
          asset: 'LP',
          amountLabel: '+12.8000',
          usdValue: 12.8,
          product: 'ETH-USDT LP',
          date: '25/02/2026',
          time: '00:00',
          status: StakingHistoryTransactionStatus.completed,
          note: 'Nhận lãi hằng tuần',
        ),
      ],
      footerNote:
          'Lịch sử giao dịch được lưu trữ vĩnh viễn. Bạn có thể xuất CSV để lưu trữ hoặc khai báo thuế. Giá trị USD tính theo tỷ giá tại thời điểm giao dịch.',
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

final class MockStakingEarningsCalendarRepository
    implements StakingEarningsCalendarRepository {
  const MockStakingEarningsCalendarRepository();

  @override
  StakingEarningsCalendarSnapshot getCalendar() {
    return const StakingEarningsCalendarSnapshot(
      endpoint: '/api/mobile/earn/earn-calendar',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /calendar/export; PATCH /earn/calendar/notifications',
      title: 'Lịch nhận lãi',
      backRoute: '/earn/dashboard',
      defaultTab: 'calendar',
      tabs: [
        StakingAnalyticsTabDraft(id: 'calendar', label: 'Lịch'),
        StakingAnalyticsTabDraft(id: 'list', label: 'Danh sách'),
      ],
      currentMonthLabel: 'Tháng 3 2026',
      currentYear: 2026,
      currentMonth: 3,
      todayIso: '2026-03-07',
      totalUpcomingUsd: 14359.20,
      events: [
        StakingCalendarEventDraft(
          id: 'e1',
          dateIso: '2026-03-07',
          type: StakingCalendarEventType.dailyReward,
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 0.45,
          usdValue: 0.45,
          description: 'Nhận lãi hằng ngày',
        ),
        StakingCalendarEventDraft(
          id: 'e2',
          dateIso: '2026-03-08',
          type: StakingCalendarEventType.dailyReward,
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 0.45,
          usdValue: 0.45,
          description: 'Nhận lãi hằng ngày',
        ),
        StakingCalendarEventDraft(
          id: 'e3',
          dateIso: '2026-03-09',
          type: StakingCalendarEventType.dailyReward,
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 0.45,
          usdValue: 0.45,
          description: 'Nhận lãi hằng ngày',
        ),
        StakingCalendarEventDraft(
          id: 'e4',
          dateIso: '2026-03-10',
          type: StakingCalendarEventType.autoCompound,
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 3.15,
          usdValue: 3.15,
          description: 'Tái đầu tư tự động hằng tuần',
        ),
        StakingCalendarEventDraft(
          id: 'e5',
          dateIso: '2026-03-15',
          type: StakingCalendarEventType.maturity,
          product: 'SOL Fixed 30D',
          asset: 'SOL',
          amount: 51.2,
          usdValue: 6656,
          description: 'Đáo hạn - nhận vốn và lãi',
        ),
        StakingCalendarEventDraft(
          id: 'e6',
          dateIso: '2026-03-21',
          type: StakingCalendarEventType.maturity,
          product: 'ETH Fixed 60D',
          asset: 'ETH',
          amount: 1.535,
          usdValue: 4298,
          description: 'Đáo hạn - nhận vốn và lãi',
        ),
        StakingCalendarEventDraft(
          id: 'e7',
          dateIso: '2026-03-25',
          type: StakingCalendarEventType.rateChange,
          product: 'USDT Flexible',
          asset: 'USDT',
          oldRate: 6.5,
          newRate: 7.0,
          description: 'Thay đổi APY: 6.5% -> 7.0%',
        ),
        StakingCalendarEventDraft(
          id: 'e8',
          dateIso: '2026-04-01',
          type: StakingCalendarEventType.maturity,
          product: 'BTC Fixed 90D',
          asset: 'BTC',
          amount: 0.05029,
          usdValue: 3396.58,
          description: 'Đáo hạn - nhận vốn và lãi',
        ),
        StakingCalendarEventDraft(
          id: 'e9',
          dateIso: '2026-03-14',
          type: StakingCalendarEventType.dailyReward,
          product: 'ETH-USDT LP',
          asset: 'LP',
          amount: 0.52,
          usdValue: 0.52,
          description: 'Nhận lãi DeFi pool',
        ),
        StakingCalendarEventDraft(
          id: 'e10',
          dateIso: '2026-03-17',
          type: StakingCalendarEventType.autoCompound,
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 3.60,
          usdValue: 3.60,
          description: 'Tái đầu tư tự động hằng tuần',
        ),
      ],
      infoTitle: 'Về Lịch nhận lãi',
      infoBullets: [
        'Lãi được phân phối tự động vào ví staking của bạn',
        'Bật thông báo để nhận alert trước 24 giờ',
        'Xuất lịch để đồng bộ với Google/Apple Calendar',
        'APY có thể thay đổi - kiểm tra thông báo thường xuyên',
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, notification preference, export calendar action, and calendar/list states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingValidatorSelectionRepository
    implements StakingValidatorSelectionRepository {
  const MockStakingValidatorSelectionRepository();

  @override
  StakingValidatorSelectionSnapshot getSelection() {
    return const StakingValidatorSelectionSnapshot(
      endpoint: '/api/mobile/earn/earn-validator-selection',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; PATCH /earn/staking/validator-preference',
      title: 'Chọn Validator',
      backRoute: '/earn/staking',
      infoTitle: 'Tính năng Nâng cao',
      infoBody:
          'Chọn validator riêng để tối ưu APY và kiểm soát rủi ro. Mặc định, chúng tôi tự động phân phối qua nhiều validator uy tín.',
      validators: [
        StakingValidatorDraft(
          id: 'v1',
          name: 'Coinbase Cloud',
          address: '0x1234...5678',
          commission: 8,
          apy: 5.92,
          uptime: 99.98,
          totalStaked: 125000,
          delegators: 45230,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.top,
          description: 'Institutional-grade validator with 24/7 monitoring',
          website: 'coinbase.com/cloud',
          features: ['24/7 Support', 'MEV Protection', 'Auto-compound'],
        ),
        StakingValidatorDraft(
          id: 'v2',
          name: 'Kraken Staking',
          address: '0xabcd...ef12',
          commission: 10,
          apy: 5.80,
          uptime: 99.95,
          totalStaked: 98500,
          delegators: 32150,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.top,
          description: 'Regulated validator with insurance coverage',
          website: 'kraken.com/staking',
          features: ['Insurance', 'Regulated', 'Low Commission'],
        ),
        StakingValidatorDraft(
          id: 'v3',
          name: 'Figment',
          address: '0x9876...5432',
          commission: 5,
          apy: 6.15,
          uptime: 99.99,
          totalStaked: 210000,
          delegators: 68900,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.top,
          description: 'Highest APY with excellent track record',
          website: 'figment.io',
          features: ['Highest APY', 'Open Source', 'Multi-chain'],
        ),
        StakingValidatorDraft(
          id: 'v4',
          name: 'Chorus One',
          address: '0xdef0...9abc',
          commission: 7,
          apy: 6.03,
          uptime: 99.97,
          totalStaked: 150000,
          delegators: 52000,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.recommended,
          description:
              'Community-focused validator with transparent operations',
          features: ['Community Driven', 'Educational', 'Governance Active'],
        ),
        StakingValidatorDraft(
          id: 'v5',
          name: 'P2P Validator',
          address: '0x1111...2222',
          commission: 6,
          apy: 6.08,
          uptime: 99.96,
          totalStaked: 88000,
          delegators: 28500,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.recommended,
          description: 'Non-custodial staking with full control',
          features: ['Non-custodial', 'API Access', 'Custom Reports'],
        ),
        StakingValidatorDraft(
          id: 'v6',
          name: 'Everstake',
          address: '0x3333...4444',
          commission: 9,
          apy: 5.85,
          uptime: 99.94,
          totalStaked: 72000,
          delegators: 21000,
          slashingHistory: 0,
          verified: false,
          tier: StakingValidatorTier.standard,
          description: 'Reliable validator with global infrastructure',
          features: ['Global Nodes', 'Backup Validators', 'Analytics'],
        ),
        StakingValidatorDraft(
          id: 'v7',
          name: 'Staked.us',
          address: '0x5555...6666',
          commission: 12,
          apy: 5.68,
          uptime: 99.92,
          totalStaked: 45000,
          delegators: 15000,
          slashingHistory: 1,
          verified: false,
          tier: StakingValidatorTier.standard,
          description: 'US-based validator with compliance focus',
          features: ['US Regulated', 'Tax Reporting', 'Compliance'],
        ),
      ],
      footerNote:
          'Thông tin validator được cập nhật theo thời gian thực từ blockchain. APY có thể thay đổi dựa trên hiệu suất validator và điều kiện mạng. Chúng tôi khuyến nghị chọn validator có uptime >99.9% và không có lịch sử slashing.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, sort/filter state, validator details, and preference update action.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingAutoCompoundRepository
    implements StakingAutoCompoundRepository {
  const MockStakingAutoCompoundRepository();

  @override
  StakingAutoCompoundSnapshot getAutoCompound() {
    return const StakingAutoCompoundSnapshot(
      endpoint: '/api/mobile/earn/earn-auto-compound',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; PATCH /earn/staking/auto-compound-settings',
      title: 'Auto-Compound',
      backRoute: '/earn/staking',
      infoTitle: 'Tự động Tái đầu tư',
      infoBody:
          'Auto-compound tự động thêm phần thưởng vào số lượng stake để tối đa hóa lợi nhuận kép. APY thực tế sẽ cao hơn APY danh nghĩa.',
      frequencies: [
        StakingAutoCompoundFrequencyDraft(
          id: 'daily',
          label: 'Hàng ngày',
          description: 'APY cao nhất',
        ),
        StakingAutoCompoundFrequencyDraft(
          id: 'weekly',
          label: 'Hàng tuần',
          description: 'Cân bằng',
        ),
        StakingAutoCompoundFrequencyDraft(
          id: 'monthly',
          label: 'Hàng tháng',
          description: 'Tiết kiệm gas',
        ),
      ],
      positions: [
        StakingAutoCompoundPositionDraft(
          id: 'p1',
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 2500,
          autoCompound: true,
        ),
        StakingAutoCompoundPositionDraft(
          id: 'p2',
          product: 'BTC Fixed 90D',
          asset: 'BTC',
          amount: 0.05,
          autoCompound: false,
        ),
        StakingAutoCompoundPositionDraft(
          id: 'p3',
          product: 'ETH Fixed 60D',
          asset: 'ETH',
          amount: 1.5,
          autoCompound: true,
        ),
        StakingAutoCompoundPositionDraft(
          id: 'p4',
          product: 'SOL Fixed 30D',
          asset: 'SOL',
          amount: 50,
          autoCompound: false,
        ),
      ],
      suggestion:
          'Tần suất Daily cho APY tối đa. Weekly cân bằng giữa APY và gas fee. Monthly tiết kiệm gas nhất nhưng APY thấp hơn.',
      footerNote:
          'Auto-compound hoạt động tự động 24/7. Phần thưởng sẽ được tự động thêm vào số lượng stake theo tần suất đã chọn. Bạn có thể tắt bất kỳ lúc nào mà không mất phần thưởng đã tích lũy.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, per-position auto-compound toggles, global frequency, gas optimization, and simulator state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingLiquidStakingRepository
    implements StakingLiquidStakingRepository {
  const MockStakingLiquidStakingRepository();

  @override
  StakingLiquidStakingSnapshot getLiquidStaking() {
    return const StakingLiquidStakingSnapshot(
      endpoint: '/api/mobile/earn/earn-liquid-staking',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/liquid-stake; POST /earn/staking/liquid-swap',
      title: 'Liquid Staking',
      backRoute: '/earn/staking',
      infoTitle: 'Về Liquid Staking',
      infoBody:
          'Stake và nhận liquid token (stToken) có thể giao dịch ngay lập tức. Bạn vẫn nhận phần thưởng staking trong khi giữ thanh khoản 100%.',
      tokens: [
        StakingLiquidTokenDraft(
          id: 'steth',
          name: 'Lido Staked ETH',
          symbol: 'stETH',
          underlyingAsset: 'ETH',
          exchangeRate: 1.002,
          apy: 4.2,
          totalSupply: 9500000,
          tvl: 26600000000,
          protocol: 'Lido',
          risks: ['Smart contract risk', 'Slippage khi swap', 'Depegging risk'],
          benefits: [
            'Thanh khoản tức thì',
            'Có thể dùng làm collateral',
            'Nhận rewards liên tục',
          ],
        ),
        StakingLiquidTokenDraft(
          id: 'reth',
          name: 'Rocket Pool ETH',
          symbol: 'rETH',
          underlyingAsset: 'ETH',
          exchangeRate: 1.058,
          apy: 4.5,
          totalSupply: 580000,
          tvl: 1624000000,
          protocol: 'Rocket Pool',
          risks: [
            'Phí swap cao hơn',
            'Thanh khoản thấp hơn stETH',
            'Phụ thuộc node operators',
          ],
          benefits: ['Decentralized hơn', 'APY cao hơn', 'Hỗ trợ mini-pool'],
        ),
        StakingLiquidTokenDraft(
          id: 'cbeth',
          name: 'Coinbase Wrapped Staked ETH',
          symbol: 'cbETH',
          underlyingAsset: 'ETH',
          exchangeRate: 1.045,
          apy: 3.8,
          totalSupply: 450000,
          tvl: 1260000000,
          protocol: 'Coinbase',
          risks: ['Centralized (Coinbase custody)', 'Thanh khoản trung bình'],
          benefits: [
            'Uy tín cao (Coinbase)',
            'Dễ dàng onboarding',
            'Regulated',
          ],
        ),
      ],
      swapFromOptions: ['stETH', 'rETH', 'cbETH'],
      swapToOptions: ['ETH', 'stETH', 'rETH', 'cbETH'],
      slippageTolerance: 0.3,
      estimatedGasFee: 2.50,
      holdingsValue: 0,
      riskNote:
          'Liquid token có rủi ro smart contract và depegging (mất peg so với asset gốc). Chỉ stake số lượng bạn có thể chấp nhận rủi ro.',
      swapNote:
          'Swap qua DEX aggregator (1inch, Paraswap) để có rate tốt nhất. Slippage có thể cao hơn trong thời điểm thị trường biến động.',
      benefits: [
        StakingLiquidBenefitDraft(
          icon: 'zap',
          label: 'Thanh khoản tức thì',
          description: 'Swap bất kỳ lúc nào',
        ),
        StakingLiquidBenefitDraft(
          icon: 'trend',
          label: 'Nhận rewards liên tục',
          description: 'APY auto-compound',
        ),
        StakingLiquidBenefitDraft(
          icon: 'shield',
          label: 'Làm collateral',
          description: 'Vay/cho vay DeFi',
        ),
        StakingLiquidBenefitDraft(
          icon: 'swap',
          label: 'Swap dễ dàng',
          description: 'Uniswap, Curve',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, liquid token catalog, stake/swap preview, holdings, and slippage state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingInsuranceRepository
    implements StakingInsuranceRepository {
  const MockStakingInsuranceRepository();

  @override
  StakingInsuranceSnapshot getInsurance() {
    return const StakingInsuranceSnapshot(
      endpoint: '/api/mobile/earn/earn-insurance',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/insurance/claim; PATCH /earn/staking/insurance-plan',
      title: 'Slashing Insurance',
      backRoute: '/earn/staking',
      infoTitle: 'Bảo vệ Slashing',
      infoBody:
          'Insurance bồi thường 25-75% thiệt hại nếu validator bị slashing. Phí bảo hiểm chỉ 0.5-1.5% APY.',
      plans: [
        StakingInsurancePlanDraft(
          id: 'basic',
          name: 'Basic Coverage',
          coverage: 25,
          premium: 0.5,
          maxClaim: 5000,
          cooldownDays: 7,
          features: [
            'Bồi thường 25% thiệt hại',
            'Claim trong 7 ngày',
            'Tối đa \$5,000/claim',
          ],
        ),
        StakingInsurancePlanDraft(
          id: 'standard',
          name: 'Standard Coverage',
          coverage: 50,
          premium: 1.0,
          maxClaim: 25000,
          cooldownDays: 3,
          features: [
            'Bồi thường 50% thiệt hại',
            'Claim trong 3 ngày',
            'Tối đa \$25,000/claim',
            'Priority support',
          ],
        ),
        StakingInsurancePlanDraft(
          id: 'premium',
          name: 'Premium Coverage',
          coverage: 75,
          premium: 1.5,
          maxClaim: 100000,
          cooldownDays: 1,
          features: [
            'Bồi thường 75% thiệt hại',
            'Claim trong 24 giờ',
            'Tối đa \$100,000/claim',
            'Priority support',
            'Legal assistance',
          ],
        ),
      ],
      positions: [
        StakingInsurancePositionDraft(
          id: 'p1',
          product: 'BTC Fixed 90D',
          asset: 'BTC',
          amount: 0.05,
          usdValue: 3377,
          insured: true,
          insurancePlanId: 'standard',
        ),
        StakingInsurancePositionDraft(
          id: 'p2',
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 2500,
          usdValue: 2500,
          insured: false,
        ),
        StakingInsurancePositionDraft(
          id: 'p3',
          product: 'ETH Fixed 60D',
          asset: 'ETH',
          amount: 1.5,
          usdValue: 4200,
          insured: true,
          insurancePlanId: 'premium',
        ),
        StakingInsurancePositionDraft(
          id: 'p4',
          product: 'SOL Fixed 30D',
          asset: 'SOL',
          amount: 50,
          usdValue: 6500,
          insured: false,
        ),
      ],
      claims: [
        StakingInsuranceClaimDraft(
          id: 'c1',
          date: '15/02/2026',
          position: 'ETH Fixed 60D',
          reason: 'Validator downtime (48h)',
          loss: 125.50,
          coverage: 50,
          payout: 62.75,
          status: 'approved',
        ),
        StakingInsuranceClaimDraft(
          id: 'c2',
          date: '03/01/2026',
          position: 'BTC Fixed 90D',
          reason: 'Slashing penalty (0.01%)',
          loss: 3.38,
          coverage: 50,
          payout: 1.69,
          status: 'approved',
        ),
      ],
      benefits: [
        StakingInsuranceBenefitDraft(
          icon: 'shield',
          label: 'Bảo vệ vốn',
          description: 'Bồi thường 25-75%',
        ),
        StakingInsuranceBenefitDraft(
          icon: 'clock',
          label: 'Xử lý nhanh',
          description: 'Claim trong 1-7 ngày',
        ),
        StakingInsuranceBenefitDraft(
          icon: 'cost',
          label: 'Phí thấp',
          description: 'Chỉ 0.5-1.5% APY',
        ),
        StakingInsuranceBenefitDraft(
          icon: 'audit',
          label: 'Minh bạch',
          description: 'Smart contract audit',
        ),
      ],
      warningTitle: 'Lưu ý quan trọng',
      warningBullets: [
        'Bảo hiểm KHÔNG cover mất giá asset (market risk)',
        'Chỉ cover slashing penalty, downtime loss, smart contract bug',
        'Phí bảo hiểm được trừ trực tiếp từ APY nhận được',
        'Claim phải có bằng chứng rõ ràng',
      ],
      claimReasons: [
        'Slashing penalty',
        'Validator downtime',
        'Smart contract bug',
        'Khác',
      ],
      claimEvidenceNote:
          'Claim sẽ được xem xét trong vòng 1-7 ngày. Bạn cần cung cấp bằng chứng như transaction hash, screenshot hoặc audit report để hỗ trợ claim.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, coverage plan catalog, insured position mapping, claim history, claim evidence workflow, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
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

final class MockStakingInsuranceFundTransparencyRepository
    implements StakingInsuranceFundTransparencyRepository {
  const MockStakingInsuranceFundTransparencyRepository();

  @override
  StakingInsuranceFundTransparencySnapshot getTransparency() {
    return const StakingInsuranceFundTransparencySnapshot(
      endpoint: '/api/mobile/earn/earn-insurance-fund-transparency',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Insurance Fund',
      backRoute: '/earn/staking',
      infoTitle: 'User Protection Fund',
      infoBody:
          'A dedicated fund covers up to 50-100% of losses from slashing, smart contract exploits, and validator failures. Fully transparent, audited monthly.',
      totalBalance: 50000000,
      targetRatio: 150,
      currentRatio: 165,
      liabilities: 30303030,
      surplus: 19696970,
      lastUpdated: '07/03/2026, 21:30',
      assets: [
        StakingInsuranceFundAssetDraft(
          asset: 'ETH',
          value: 30000000,
          percentage: 60,
          colorKey: 'primary',
        ),
        StakingInsuranceFundAssetDraft(
          asset: 'BTC',
          value: 15000000,
          percentage: 30,
          colorKey: 'warning',
        ),
        StakingInsuranceFundAssetDraft(
          asset: 'USDT',
          value: 5000000,
          percentage: 10,
          colorKey: 'success',
        ),
      ],
      claims: [
        StakingInsuranceFundClaimDraft(
          id: 'c-20260220',
          date: '20/02/2026',
          user: 'User#12345',
          reason: 'Validator slashing (2%)',
          loss: 125.50,
          coverage: 50,
          payout: 62.75,
          status: 'approved',
          processingDays: 3,
        ),
        StakingInsuranceFundClaimDraft(
          id: 'c-20260115',
          date: '15/01/2026',
          user: 'User#67890',
          reason: 'Smart contract exploit (partial)',
          loss: 5000,
          coverage: 80,
          payout: 4000,
          status: 'approved',
          processingDays: 7,
        ),
        StakingInsuranceFundClaimDraft(
          id: 'c-20251210',
          date: '10/12/2025',
          user: 'User#24680',
          reason: 'Validator downtime loss',
          loss: 50,
          coverage: 100,
          payout: 50,
          status: 'approved',
          processingDays: 2,
        ),
        StakingInsuranceFundClaimDraft(
          id: 'c-20251105',
          date: '05/11/2025',
          user: 'User#13579',
          reason: 'Slashing event (1.5%)',
          loss: 200,
          coverage: 50,
          payout: 100,
          status: 'approved',
          processingDays: 4,
        ),
      ],
      history: [
        StakingInsuranceFundHistoryDraft(
          month: 'Apr 2025',
          balance: 45.2,
          ratio: 155,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'May 2025',
          balance: 46,
          ratio: 157,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Jun 2025',
          balance: 46.8,
          ratio: 159,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Jul 2025',
          balance: 47.5,
          ratio: 160,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Aug 2025',
          balance: 48,
          ratio: 161,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Sep 2025',
          balance: 48.5,
          ratio: 162,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Oct 2025',
          balance: 49,
          ratio: 163,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Nov 2025',
          balance: 49.2,
          ratio: 164,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Dec 2025',
          balance: 49.5,
          ratio: 164,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Jan 2026',
          balance: 49.8,
          ratio: 165,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Feb 2026',
          balance: 49.9,
          ratio: 165,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Mar 2026',
          balance: 50,
          ratio: 165,
        ),
      ],
      stakingFeeContribution: 2,
      monthlyContribution: 150000,
      ytdContributions: 450000,
      totalContributed: 5200000,
      footerNote:
          'Insurance fund is audited monthly by third-party firms. All claim data is anonymized. Fund balance and ratio are updated in real-time. Last audit: March 1, 2026.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, insurance fund balance, asset breakdown, claims history, monthly audit report metadata, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingTransactionReportingRepository
    implements StakingTransactionReportingRepository {
  const MockStakingTransactionReportingRepository();

  @override
  StakingTransactionReportingSnapshot getReporting() {
    return const StakingTransactionReportingSnapshot(
      endpoint: '/api/mobile/earn/earn-transaction-reporting',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /exports',
      title: 'Tax Reporting',
      backRoute: '/earn/staking',
      infoTitle: 'Tax Compliance Made Easy',
      infoBody:
          'Generate IRS-compliant tax reports. Export to TurboTax, CoinTracker, or download PDF forms. Always consult a tax professional.',
      years: ['2025', '2024', '2023'],
      defaultYear: '2025',
      defaultCostBasis: 'FIFO',
      summary: StakingTaxSummaryDraft(
        totalStakingIncome: 5234.56,
        totalCapitalGains: 12345.67,
        costBasis: 100000,
        proceeds: 112345.67,
        shortTermGains: 8000,
        longTermGains: 4345.67,
        rewardsByAsset: [
          StakingTaxRewardAssetDraft(asset: 'ETH', amount: 2.5, usdValue: 7000),
          StakingTaxRewardAssetDraft(
            asset: 'BTC',
            amount: 0.05,
            usdValue: 2250,
          ),
          StakingTaxRewardAssetDraft(asset: 'SOL', amount: 50, usdValue: 4750),
        ],
      ),
      transactions: [
        StakingTaxTransactionDraft(
          date: '31/12/2025',
          type: 'stake',
          asset: 'ETH',
          amount: 10,
          usdValue: 28000,
          costBasis: 28000,
          taxable: false,
        ),
        StakingTaxTransactionDraft(
          date: '15/12/2025',
          type: 'reward',
          asset: 'ETH',
          amount: 0.1,
          usdValue: 280,
          taxable: true,
        ),
        StakingTaxTransactionDraft(
          date: '20/11/2025',
          type: 'unstake',
          asset: 'BTC',
          amount: 0.5,
          usdValue: 22500,
          costBasis: 20000,
          taxable: true,
        ),
        StakingTaxTransactionDraft(
          date: '01/11/2025',
          type: 'reward',
          asset: 'SOL',
          amount: 25,
          usdValue: 2375,
          taxable: true,
        ),
        StakingTaxTransactionDraft(
          date: '15/10/2025',
          type: 'stake',
          asset: 'SOL',
          amount: 200,
          usdValue: 18000,
          costBasis: 18000,
          taxable: false,
        ),
        StakingTaxTransactionDraft(
          date: '01/09/2025',
          type: 'reward',
          asset: 'ETH',
          amount: 0.05,
          usdValue: 140,
          taxable: true,
        ),
      ],
      costBasisMethods: [
        StakingCostBasisMethodDraft(
          value: 'FIFO',
          label: 'First In, First Out (FIFO)',
          description:
              'Default IRS method. First purchased assets are first sold.',
        ),
        StakingCostBasisMethodDraft(
          value: 'LIFO',
          label: 'Last In, First Out (LIFO)',
          description:
              'Last purchased assets are first sold. May reduce short-term gains.',
        ),
        StakingCostBasisMethodDraft(
          value: 'Specific ID',
          label: 'Specific Identification',
          description:
              'Manually identify which lots to sell. Requires detailed records.',
        ),
        StakingCostBasisMethodDraft(
          value: 'Average Cost',
          label: 'Average Cost Basis',
          description: 'Average cost of all holdings. Simplified calculation.',
        ),
      ],
      taxForms: [
        StakingTaxExportOptionDraft(
          name: 'Form 1099-MISC',
          description: 'Staking income report',
        ),
        StakingTaxExportOptionDraft(
          name: 'Form 8949',
          description: 'Capital gains & losses',
        ),
        StakingTaxExportOptionDraft(
          name: 'Schedule D',
          description: 'Capital gains summary',
        ),
      ],
      integrations: [
        StakingTaxExportOptionDraft(
          name: 'TurboTax CSV',
          description: 'Import directly to TurboTax',
        ),
        StakingTaxExportOptionDraft(
          name: 'CoinTracker JSON',
          description: 'Export to CoinTracker',
        ),
        StakingTaxExportOptionDraft(
          name: 'Koinly CSV',
          description: 'Export to Koinly',
        ),
      ],
      rawDataFormats: [
        StakingTaxExportOptionDraft(
          name: 'CSV',
          description: 'All transactions',
        ),
        StakingTaxExportOptionDraft(
          name: 'JSON',
          description: 'Developer-friendly format',
        ),
      ],
      resources: [
        StakingTaxResourceDraft(label: 'IRS Crypto Tax Guide', url: 'irs.gov'),
        StakingTaxResourceDraft(
          label: 'Find a Crypto Tax Professional',
          url: 'taxbit.com',
        ),
        StakingTaxResourceDraft(
          label: 'Tax Loss Harvesting Guide',
          url: 'platform.com/tax-guide',
        ),
      ],
      taxNotice:
          'These reports are for informational purposes only. Tax laws vary by jurisdiction. Always consult a qualified tax professional or CPA before filing. We are not tax advisors.',
      footerNote:
          'Tax reports are generated using real-time transaction data. Historical data cannot be modified once a tax year closes. Reports use fair market value at the time of transaction (UTC timezone). Last updated: 25/05/2026.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, tax summary, transaction ledger, cost basis method state, export job state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingApiDocumentationRepository
    implements StakingApiDocumentationRepository {
  const MockStakingApiDocumentationRepository();

  @override
  StakingApiDocumentationSnapshot getDocumentation() {
    return const StakingApiDocumentationSnapshot(
      endpoint: '/api/mobile/earn/earn-api-documentation',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'API Documentation',
      backRoute: '/earn/staking',
      infoTitle: 'Programmatic Staking API',
      infoBody:
          'RESTful API with JSON payloads. Rate limits apply. API key authentication required. Test in sandbox environment before production.',
      stats: [
        StakingApiStatDraft(label: 'Uptime', value: '99.9%', tone: 'warn'),
        StakingApiStatDraft(label: 'Endpoints', value: '5', tone: 'primary'),
        StakingApiStatDraft(label: 'API Version', value: 'v1.0', tone: 'buy'),
      ],
      defaultTab: 'endpoints',
      defaultLanguage: 'javascript',
      endpoints: [
        StakingApiEndpointDraft(
          method: 'POST',
          path: '/staking/stake',
          name: 'Create Stake Position',
          description: 'Stake assets to a specific product',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: true,
              description: 'ETH, BTC, SOL, etc.',
            ),
            StakingApiParameterDraft(
              name: 'amount',
              type: 'number',
              required: true,
              description: 'Amount to stake',
            ),
            StakingApiParameterDraft(
              name: 'product',
              type: 'string',
              required: true,
              description: 'flexible, fixed-30, fixed-60, etc.',
            ),
            StakingApiParameterDraft(
              name: 'validator',
              type: 'string',
              required: false,
              description: 'Optional validator address',
            ),
          ],
          responseJson: r'''{
  "positionId": "pos_abc123",
  "asset": "ETH",
  "amount": 1.5,
  "product": "flexible",
  "apy": 4.2,
  "status": "active",
  "createdAt": "2026-03-07T14:30:00Z"
}''',
        ),
        StakingApiEndpointDraft(
          method: 'GET',
          path: '/staking/positions',
          name: 'Get Staking Positions',
          description: 'Retrieve all staking positions for authenticated user',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: false,
              description: 'Filter by asset',
            ),
            StakingApiParameterDraft(
              name: 'status',
              type: 'string',
              required: false,
              description: 'active, unstaking, completed',
            ),
            StakingApiParameterDraft(
              name: 'limit',
              type: 'number',
              required: false,
              description: 'Max 100',
            ),
            StakingApiParameterDraft(
              name: 'offset',
              type: 'number',
              required: false,
              description: 'Pagination offset',
            ),
          ],
          responseJson: r'''{
  "positions": [
    {
      "positionId": "pos_abc123",
      "asset": "ETH",
      "amount": 1.5,
      "product": "flexible",
      "apy": 4.2,
      "earnedRewards": 0.05,
      "status": "active"
    }
  ],
  "total": 1
}''',
        ),
        StakingApiEndpointDraft(
          method: 'POST',
          path: '/staking/unstake',
          name: 'Unstake Position',
          description: 'Unstake assets from a position',
          params: [
            StakingApiParameterDraft(
              name: 'positionId',
              type: 'string',
              required: true,
              description: 'Position ID to unstake',
            ),
            StakingApiParameterDraft(
              name: 'amount',
              type: 'number',
              required: false,
              description: 'Partial unstake amount (optional)',
            ),
          ],
          responseJson: r'''{
  "unstakeId": "uns_xyz789",
  "positionId": "pos_abc123",
  "amount": 1.5,
  "estimatedCompletion": "2026-03-09T14:30:00Z",
  "status": "unstaking"
}''',
        ),
        StakingApiEndpointDraft(
          method: 'GET',
          path: '/staking/rewards',
          name: 'Get Rewards History',
          description: 'Retrieve rewards history with filters',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: false,
              description: 'Filter by asset',
            ),
            StakingApiParameterDraft(
              name: 'startDate',
              type: 'string',
              required: false,
              description: 'ISO 8601 date',
            ),
            StakingApiParameterDraft(
              name: 'endDate',
              type: 'string',
              required: false,
              description: 'ISO 8601 date',
            ),
            StakingApiParameterDraft(
              name: 'limit',
              type: 'number',
              required: false,
              description: 'Max 100',
            ),
          ],
          responseJson: r'''{
  "rewards": [
    {
      "rewardId": "rew_123",
      "asset": "ETH",
      "amount": 0.001,
      "usdValue": 2.8,
      "timestamp": "2026-03-07T00:00:00Z"
    }
  ],
  "total": 50
}''',
        ),
        StakingApiEndpointDraft(
          method: 'GET',
          path: '/staking/validators',
          name: 'Get Validators List',
          description: 'Get available validators with performance metrics',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: true,
              description: 'ETH, SOL, etc.',
            ),
            StakingApiParameterDraft(
              name: 'sortBy',
              type: 'string',
              required: false,
              description: 'apy, uptime, commission',
            ),
          ],
          responseJson: r'''{
  "validators": [
    {
      "address": "0x1234...5678",
      "name": "Validator A",
      "apy": 4.5,
      "commission": 10,
      "uptime": 99.8,
      "totalStaked": 125000
    }
  ],
  "total": 25
}''',
        ),
      ],
      codeExamples: [
        StakingApiCodeExampleDraft(
          language: 'javascript',
          label: 'JavaScript',
          source: r'''// JavaScript/Node.js
const response = await fetch('https://api.platform.com/v1/staking/stake', {
  method: 'POST',
  headers: {
    'X-API-Key': 'YOUR_API_KEY',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    asset: 'ETH',
    amount: 1.5,
    product: 'flexible'
  })
});
const data = await response.json();
console.log(data);''',
        ),
        StakingApiCodeExampleDraft(
          language: 'python',
          label: 'Python',
          source: r'''# Python
import requests

url = 'https://api.platform.com/v1/staking/stake'
headers = {
    'X-API-Key': 'YOUR_API_KEY',
    'Content-Type': 'application/json'
}
body = {
    'asset': 'ETH',
    'amount': 1.5,
    'product': 'flexible'
}

response = requests.post(url, headers=headers, json=body)
data = response.json()
print(data)''',
        ),
        StakingApiCodeExampleDraft(
          language: 'curl',
          label: 'cURL',
          source: r'''# cURL
curl -X POST https://api.platform.com/v1/staking/stake \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "asset": "ETH",
    "amount": 1.5,
    "product": "flexible"
  }' ''',
        ),
      ],
      sandboxBaseUrl: 'https://sandbox.platform.com/v1',
      authHeaderExample:
          'curl -H "X-API-Key: YOUR_API_KEY" https://api.platform.com/v1/staking/positions',
      rateLimits: [
        StakingApiRateLimitDraft(
          tier: 'Free',
          requests: 100,
          window: '1 hour',
          price: r'$0',
          recommended: false,
        ),
        StakingApiRateLimitDraft(
          tier: 'Pro',
          requests: 1000,
          window: '1 hour',
          price: r'$29/mo',
          recommended: true,
        ),
        StakingApiRateLimitDraft(
          tier: 'Enterprise',
          requests: 10000,
          window: '1 hour',
          price: 'Custom',
          recommended: false,
        ),
      ],
      errorCodes: [
        StakingApiErrorCodeDraft(
          code: 401,
          message: 'Unauthorized - Invalid API key',
        ),
        StakingApiErrorCodeDraft(
          code: 403,
          message: 'Forbidden - Rate limit exceeded',
        ),
        StakingApiErrorCodeDraft(
          code: 400,
          message: 'Bad Request - Invalid parameters',
        ),
        StakingApiErrorCodeDraft(
          code: 404,
          message: 'Not Found - Endpoint does not exist',
        ),
        StakingApiErrorCodeDraft(code: 500, message: 'Internal Server Error'),
      ],
      footerNote:
          'API documentation last updated: March 7, 2026. For enterprise support, contact api-support@platform.com. Join our Discord for community help.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, endpoint catalogue, code examples, auth details, rate limits, error codes, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingProofOfReservesRepository
    implements StakingProofOfReservesRepository {
  const MockStakingProofOfReservesRepository();

  @override
  StakingProofOfReservesSnapshot getProofOfReserves() {
    return const StakingProofOfReservesSnapshot(
      endpoint: '/api/mobile/earn/earn-proof-of-reserves',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Proof of Reserves',
      backRoute: '/earn/staking',
      infoTitle: 'Cryptographic Proof of Reserves',
      infoBody:
          'All reserves are verifiable on-chain. Third-party audited monthly. Users can verify their balance inclusion via Merkle tree proofs.',
      overall: StakingReserveOverallDraft(
        totalAssetsUsd: 350000000,
        totalLiabilitiesUsd: 340000000,
        reserveRatio: 102.9,
        lastAudit: '2026-03-01',
        lastUpdated: '25/05/2026, 18:58:56',
      ),
      assets: [
        StakingAssetReserveDraft(
          asset: 'ETH',
          onChainBalance: 125430.50,
          userLiabilities: 122000,
          reserveRatio: 102.8,
          lastUpdated: '14:30',
          walletAddress: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
          explorer: 'etherscan.io',
        ),
        StakingAssetReserveDraft(
          asset: 'BTC',
          onChainBalance: 2100.25,
          userLiabilities: 2050,
          reserveRatio: 102.5,
          lastUpdated: '14:30',
          walletAddress: 'bc1q...xyz',
          explorer: 'blockchain.com',
        ),
        StakingAssetReserveDraft(
          asset: 'SOL',
          onChainBalance: 850000,
          userLiabilities: 820000,
          reserveRatio: 103.7,
          lastUpdated: '14:30',
          walletAddress: 'DYw8...ABC',
          explorer: 'solscan.io',
        ),
      ],
      auditReports: [
        StakingReserveAuditReportDraft(
          id: 'por-202603',
          auditor: 'Armanino LLP',
          dateLabel: 'March 2026',
          status: 'Verified',
          reportUrl: '/por/armanino-march-2026.pdf',
          findings:
              'All liabilities covered. Reserve ratio: 102.9%. No discrepancies found.',
        ),
        StakingReserveAuditReportDraft(
          id: 'por-202602',
          auditor: 'Armanino LLP',
          dateLabel: 'February 2026',
          status: 'Verified',
          reportUrl: '/por/armanino-feb-2026.pdf',
          findings: 'Reserve ratio: 102.5%. All balances verified on-chain.',
        ),
        StakingReserveAuditReportDraft(
          id: 'por-202601',
          auditor: 'Armanino LLP',
          dateLabel: 'January 2026',
          status: 'Verified',
          reportUrl: '/por/armanino-jan-2026.pdf',
          findings: 'Reserve ratio: 101.8%. Surplus increased by 3.2% MoM.',
        ),
      ],
      history: [
        StakingReserveHistoryPointDraft(month: 'Apr 2025', ratio: 101.2),
        StakingReserveHistoryPointDraft(month: 'May 2025', ratio: 101.5),
        StakingReserveHistoryPointDraft(month: 'Jun 2025', ratio: 101.7),
        StakingReserveHistoryPointDraft(month: 'Jul 2025', ratio: 101.8),
        StakingReserveHistoryPointDraft(month: 'Aug 2025', ratio: 102.0),
        StakingReserveHistoryPointDraft(month: 'Sep 2025', ratio: 102.1),
        StakingReserveHistoryPointDraft(month: 'Oct 2025', ratio: 102.3),
        StakingReserveHistoryPointDraft(month: 'Nov 2025', ratio: 102.4),
        StakingReserveHistoryPointDraft(month: 'Dec 2025', ratio: 102.5),
        StakingReserveHistoryPointDraft(month: 'Jan 2026', ratio: 101.8),
        StakingReserveHistoryPointDraft(month: 'Feb 2026', ratio: 102.5),
        StakingReserveHistoryPointDraft(month: 'Mar 2026', ratio: 102.9),
      ],
      verifyInfo:
          'Enter your User ID and staked balance to verify inclusion in the Merkle tree. This proves your balance is included in our Proof of Reserves.',
      verifySteps: [
        StakingReserveVerifyStepDraft(
          step: 1,
          title: 'Merkle Tree Generation',
          description:
              'All user balances are hashed and organized into a Merkle tree. The root hash represents the entire set of balances.',
        ),
        StakingReserveVerifyStepDraft(
          step: 2,
          title: 'Proof Generation',
          description:
              'When you verify, you receive a cryptographic proof that links your balance to the Merkle root.',
        ),
        StakingReserveVerifyStepDraft(
          step: 3,
          title: 'Independent Verification',
          description:
              'You can verify the proof independently without revealing other users data.',
        ),
        StakingReserveVerifyStepDraft(
          step: 4,
          title: 'Audit Confirmation',
          description:
              'Third-party auditors verify the Merkle root matches on-chain balances, ensuring 100% coverage.',
        ),
      ],
      privacyNote:
          'Merkle tree verification allows you to prove inclusion without revealing your exact balance to others. Only the hash of your balance is used in the tree.',
      footerNote:
          'Proof of Reserves is updated in real-time. On-chain balances are verified every 10 minutes. Third-party audits conducted monthly by Armanino LLP. Merkle root published publicly at por.platform.com.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, overall reserves, per-asset reserves, audit reports, Merkle verification state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingRiskDashboardRepository
    implements StakingRiskDashboardRepository {
  const MockStakingRiskDashboardRepository();

  @override
  StakingRiskDashboardSnapshot getRiskDashboard() {
    return const StakingRiskDashboardSnapshot(
      endpoint: '/api/mobile/earn/earn-risk-dashboard',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Risk Dashboard',
      backRoute: '/earn/staking',
      overallScore: 28,
      totalStakedUsd: 100000,
      atRiskUsd: 5000,
      protectedPercent: 95,
      riskMetrics: [
        StakingRiskMetricDraft(
          category: 'Validator Health',
          score: 15,
          status: 'low',
          description: 'All validators performing normally. Avg uptime: 99.8%',
          actionRoute: '/earn/validator-health-monitor',
        ),
        StakingRiskMetricDraft(
          category: 'Slashing Risk',
          score: 8,
          status: 'low',
          description: 'No slashing events in 90 days. Insurance fund at 165%',
          actionRoute: '/earn/slashing-history',
        ),
        StakingRiskMetricDraft(
          category: 'Smart Contract Risk',
          score: 20,
          status: 'low',
          description: 'Last audit: 30 days ago. No critical vulnerabilities',
          actionRoute: '/earn/audit-reports',
        ),
        StakingRiskMetricDraft(
          category: 'Liquidity Risk',
          score: 35,
          status: 'medium',
          description:
              'Unstaking queue: 2-3 days. Normal range for current network',
        ),
        StakingRiskMetricDraft(
          category: 'Market Risk',
          score: 45,
          status: 'medium',
          description: 'ETH volatility: 25% (30-day). Higher than 12-month avg',
        ),
        StakingRiskMetricDraft(
          category: 'Concentration Risk',
          score: 52,
          status: 'medium',
          description: '45% of stake on ETH. Consider diversification',
        ),
      ],
      exposures: [
        StakingRiskExposureDraft(
          asset: 'ETH',
          valueUsd: 45000,
          percentage: 45,
          risk: 'medium',
        ),
        StakingRiskExposureDraft(
          asset: 'BTC',
          valueUsd: 30000,
          percentage: 30,
          risk: 'low',
        ),
        StakingRiskExposureDraft(
          asset: 'SOL',
          valueUsd: 15000,
          percentage: 15,
          risk: 'medium',
        ),
        StakingRiskExposureDraft(
          asset: 'USDT',
          valueUsd: 10000,
          percentage: 10,
          risk: 'low',
        ),
      ],
      events: [
        StakingRiskEventDraft(
          id: 're1',
          dateLabel: '05/03/2026',
          type: 'warning',
          title: 'High ETH Volatility Detected',
          description: '30-day volatility increased to 25% (avg: 18%)',
          severity: 'medium',
        ),
        StakingRiskEventDraft(
          id: 're2',
          dateLabel: '01/03/2026',
          type: 'info',
          title: 'Validator Uptime Alert',
          description: 'Validator #3 uptime dropped to 98.5% (threshold: 99%)',
          severity: 'low',
        ),
        StakingRiskEventDraft(
          id: 're3',
          dateLabel: '25/02/2026',
          type: 'resolved',
          title: 'Smart Contract Upgrade Completed',
          description:
              'Staking contract upgraded to v2.1 with security improvements',
          severity: 'low',
        ),
      ],
      actions: [
        StakingRiskActionDraft(
          title: 'Emergency Actions',
          subtitle: 'Pause, withdraw, or rebalance',
          route: '/earn/emergency-actions',
          tone: 'sell',
        ),
        StakingRiskActionDraft(
          title: 'Risk Calculator',
          subtitle: 'Simulate scenarios',
          route: '/earn/risk-score-calculator',
          tone: 'primary',
        ),
        StakingRiskActionDraft(
          title: 'Contingency Plan',
          subtitle: 'Disaster recovery',
          route: '/earn/contingency-plan',
          tone: 'buy',
        ),
        StakingRiskActionDraft(
          title: 'Insurance Fund',
          subtitle: '165% coverage',
          route: '/earn/insurance',
          tone: 'accent',
        ),
      ],
      footerNote:
          'Risk scores are updated every 10 minutes. Historical data available for 12 months. Risk metrics are for informational purposes only and do not constitute financial advice.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, overall risk score, risk metrics, exposure data, recent events, action edges, and loading/empty/error/offline/realtime-refresh states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.realtimeRefresh,
      },
    );
  }
}

final class MockStakingSlashingHistoryRepository
    implements StakingSlashingHistoryRepository {
  const MockStakingSlashingHistoryRepository();

  @override
  StakingSlashingHistorySnapshot getSlashingHistory() {
    return const StakingSlashingHistorySnapshot(
      endpoint: '/api/mobile/earn/earn-slashing-history',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Slashing History',
      backRoute: '/earn/risk-dashboard',
      infoTitle: 'Protected by Insurance',
      infoBody:
          'All slashing events are covered by our insurance fund. 89.5% of historical losses have been fully compensated.',
      stats: StakingSlashingStatsDraft(
        totalEvents: 3,
        totalSlashedEth: 5.7,
        totalCoveredEth: 5.1,
        coverageRate: 89.5,
        avgRecoveryTime: '2.5 days',
        lastEvent: '2026-02-20',
      ),
      events: [
        StakingSlashingEventDraft(
          id: 'se-20260220',
          dateLabel: '20/02/2026',
          validator: 'Validator #3',
          network: 'Ethereum',
          reason: 'Validator Downtime',
          slashedAmount: 0.5,
          affectedUsers: 12,
          insuranceCoverage: 100,
          status: 'covered',
        ),
        StakingSlashingEventDraft(
          id: 'se-20251115',
          dateLabel: '15/11/2025',
          validator: 'Validator #7',
          network: 'Ethereum',
          reason: 'Missed Attestations',
          slashedAmount: 0.2,
          affectedUsers: 8,
          insuranceCoverage: 100,
          status: 'covered',
        ),
        StakingSlashingEventDraft(
          id: 'se-20250820',
          dateLabel: '20/08/2025',
          validator: 'Validator #12',
          network: 'Solana',
          reason: 'Double Signing',
          slashedAmount: 5,
          affectedUsers: 25,
          insuranceCoverage: 80,
          status: 'partial',
        ),
      ],
      trend: [
        StakingSlashingTrendPointDraft(
          month: 'Apr 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'May 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Jun 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Jul 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Aug 2025',
          events: 1,
          amountEth: 5,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Sep 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Oct 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Nov 2025',
          events: 1,
          amountEth: 0.2,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Dec 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Jan 2026',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Feb 2026',
          events: 1,
          amountEth: 0.5,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Mar 2026',
          events: 0,
          amountEth: 0,
        ),
      ],
      networkBreakdown: [
        StakingSlashingNetworkDraft(
          network: 'Ethereum',
          events: 2,
          amount: 0.7,
          unit: 'ETH',
          coverage: 100,
        ),
        StakingSlashingNetworkDraft(
          network: 'Solana',
          events: 1,
          amount: 5,
          unit: 'SOL',
          coverage: 80,
        ),
      ],
      reasonBreakdown: [
        StakingSlashingReasonDraft(
          reason: 'Double Signing',
          events: 1,
          severity: 'critical',
        ),
        StakingSlashingReasonDraft(
          reason: 'Validator Downtime',
          events: 1,
          severity: 'high',
        ),
        StakingSlashingReasonDraft(
          reason: 'Missed Attestations',
          events: 1,
          severity: 'medium',
        ),
      ],
      preventionMeasures: [
        StakingSlashingPreventionDraft(
          measure: 'Multi-Validator Distribution',
          status: 'active',
          description:
              'Stakes distributed across 15+ validators to minimize single-point failure',
        ),
        StakingSlashingPreventionDraft(
          measure: 'Real-time Monitoring',
          status: 'active',
          description:
              '24/7 automated monitoring of validator uptime and performance',
        ),
        StakingSlashingPreventionDraft(
          measure: 'Auto-Rebalancing',
          status: 'active',
          description:
              'Automatic stake reallocation from underperforming validators',
        ),
        StakingSlashingPreventionDraft(
          measure: 'Insurance Fund',
          status: 'active',
          description:
              '165% coverage ratio ensures full compensation for slashing events',
        ),
      ],
      exportLabel: 'Export Slashing Report (CSV)',
      footerNote:
          'Slashing data is updated in real-time. Insurance claims are processed within 7 business days. Historical data available for 24 months. For questions, contact support@platform.com.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, slashing events, trend data, network and reason breakdowns, prevention measures, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingValidatorHealthMonitorRepository
    implements StakingValidatorHealthMonitorRepository {
  const MockStakingValidatorHealthMonitorRepository();

  @override
  StakingValidatorHealthMonitorSnapshot getValidatorHealth() {
    return const StakingValidatorHealthMonitorSnapshot(
      endpoint: '/api/mobile/earn/earn-validator-health-monitor',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Validator Health',
      backRoute: '/earn/risk-dashboard',
      validators: [
        StakingValidatorHealthDraft(
          id: 'v1',
          name: 'Validator #1',
          address: '0x1234...5678',
          uptime: 99.95,
          apr: 4.5,
          totalStakedEth: 15000,
          commission: 10,
          status: 'healthy',
          lastBlock: '2 mins ago',
          missedBlocks: 2,
        ),
        StakingValidatorHealthDraft(
          id: 'v2',
          name: 'Validator #2',
          address: '0xabcd...ef12',
          uptime: 99.92,
          apr: 4.3,
          totalStakedEth: 12500,
          commission: 10,
          status: 'healthy',
          lastBlock: '1 min ago',
          missedBlocks: 3,
        ),
        StakingValidatorHealthDraft(
          id: 'v3',
          name: 'Validator #3',
          address: '0x9876...5432',
          uptime: 98.5,
          apr: 3.8,
          totalStakedEth: 10000,
          commission: 10,
          status: 'warning',
          lastBlock: '5 mins ago',
          missedBlocks: 15,
        ),
      ],
      uptimeHistory: [
        StakingUptimeHistoryPointDraft(
          dateLabel: '01 Mar',
          validatorOne: 99.9,
          validatorTwo: 99.8,
          validatorThree: 99.2,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '02 Mar',
          validatorOne: 99.95,
          validatorTwo: 99.9,
          validatorThree: 99,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '03 Mar',
          validatorOne: 99.92,
          validatorTwo: 99.85,
          validatorThree: 98.8,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '04 Mar',
          validatorOne: 99.96,
          validatorTwo: 99.9,
          validatorThree: 98.5,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '05 Mar',
          validatorOne: 99.94,
          validatorTwo: 99.88,
          validatorThree: 98.4,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '06 Mar',
          validatorOne: 99.95,
          validatorTwo: 99.92,
          validatorThree: 98.5,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '07 Mar',
          validatorOne: 99.95,
          validatorTwo: 99.92,
          validatorThree: 98.5,
        ),
      ],
      actionTitle: 'Action Required',
      actionBody:
          '1 validator(s) showing degraded performance. Consider rebalancing your stake to healthier validators.',
      actionLabel: 'Auto-Rebalance Stake',
      footerNote:
          'Validator metrics updated every 5 minutes. Uptime calculated based on last 10,000 blocks. Auto-rebalancing triggers when validator uptime drops below 99%.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, validator status, uptime trend, action warning, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingRiskScoreCalculatorRepository
    implements StakingRiskScoreCalculatorRepository {
  const MockStakingRiskScoreCalculatorRepository();

  @override
  StakingRiskScoreCalculatorSnapshot getCalculator() {
    return const StakingRiskScoreCalculatorSnapshot(
      endpoint: '/api/mobile/earn/earn-risk-score-calculator',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Risk Calculator',
      backRoute: '/earn/risk-dashboard',
      defaultAmountUsd: 10000,
      defaultAsset: 'ETH',
      defaultDuration: 'flexible',
      defaultValidators: 3,
      assetOptions: [
        StakingRiskScoreOptionDraft(value: 'USDT', label: 'USDT (Stablecoin)'),
        StakingRiskScoreOptionDraft(
          value: 'BTC',
          label: 'BTC (Low Volatility)',
        ),
        StakingRiskScoreOptionDraft(
          value: 'ETH',
          label: 'ETH (Medium Volatility)',
        ),
        StakingRiskScoreOptionDraft(
          value: 'SOL',
          label: 'SOL (High Volatility)',
        ),
      ],
      durationOptions: [
        StakingRiskScoreOptionDraft(
          value: 'flexible',
          label: 'Flexible (No lock)',
        ),
        StakingRiskScoreOptionDraft(value: 'fixed-30', label: 'Fixed 30 Days'),
        StakingRiskScoreOptionDraft(value: 'fixed-60', label: 'Fixed 60 Days'),
        StakingRiskScoreOptionDraft(value: 'fixed-90', label: 'Fixed 90 Days'),
        StakingRiskScoreOptionDraft(
          value: 'fixed-180',
          label: 'Fixed 180 Days',
        ),
      ],
      recommendations: [
        StakingRiskScoreRecommendationDraft(
          trigger: 'reduce-risk',
          title: 'Consider Reducing Risk',
          body: 'Diversify across more validators or reduce lock-up duration.',
          tone: 'warning',
        ),
        StakingRiskScoreRecommendationDraft(
          trigger: 'large-position',
          title: 'Large Position',
          body: 'Consider splitting across multiple products.',
          tone: 'info',
        ),
        StakingRiskScoreRecommendationDraft(
          trigger: 'balanced',
          title: 'Well-Balanced Portfolio',
          body: 'Your scenario has low risk. Good diversification!',
          tone: 'success',
        ),
      ],
      proceedLabel: 'Proceed with This Configuration',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, scenario inputs, calculated score, radar factors, recommendations, CTA edge, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingEmergencyActionsRepository
    implements StakingEmergencyActionsRepository {
  const MockStakingEmergencyActionsRepository();

  @override
  StakingEmergencyActionsSnapshot getEmergencyActions() {
    return const StakingEmergencyActionsSnapshot(
      endpoint: '/api/mobile/earn/earn-emergency-actions',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Emergency Actions',
      backRoute: '/earn/risk-dashboard',
      warningTitle: 'Emergency Actions Only',
      warningBody:
          'Use these actions only in critical situations (smart contract exploits, validator failures, extreme market events). Normal unstaking is available anytime via Dashboard.',
      actions: [
        StakingEmergencyActionDraft(
          id: 'pause',
          title: 'Pause All Staking',
          body:
              'Temporarily halt all new staking transactions. Existing stakes continue earning.',
          impact: 'Moderate Impact - Reversible',
          tone: 'warning',
        ),
        StakingEmergencyActionDraft(
          id: 'withdraw',
          title: 'Emergency Withdrawal',
          body:
              'Immediately unstake all positions. May incur penalties for fixed-term stakes.',
          impact: 'High Impact - Penalties Apply',
          tone: 'danger',
        ),
        StakingEmergencyActionDraft(
          id: 'rebalance',
          title: 'Auto-Rebalance Validators',
          body:
              'Automatically move stakes from underperforming validators to healthy ones.',
          impact: 'Low Impact - Recommended',
          tone: 'info',
        ),
      ],
      useCases: [
        StakingEmergencyUseCaseDraft(
          title: 'Smart Contract Exploit',
          severity: 'critical',
          description:
              'Immediate withdrawal if contract vulnerability discovered',
        ),
        StakingEmergencyUseCaseDraft(
          title: 'Validator Mass Failure',
          severity: 'high',
          description: 'Multiple validators going offline simultaneously',
        ),
        StakingEmergencyUseCaseDraft(
          title: 'Extreme Market Event',
          severity: 'high',
          description: 'Black swan event with >50% asset price drop',
        ),
        StakingEmergencyUseCaseDraft(
          title: 'Regulatory Action',
          severity: 'medium',
          description: 'Government ban or restriction on staking',
        ),
      ],
      statusCards: [
        StakingEmergencyStatusDraft(
          title: 'System Status',
          value: 'All Systems Normal',
          body: 'No emergency action needed',
          tone: 'success',
        ),
        StakingEmergencyStatusDraft(
          title: 'Last Emergency',
          value: 'Never',
          body: 'No history',
          tone: 'neutral',
        ),
      ],
      pauseSheet: StakingEmergencySheetDraft(
        title: 'Pause All Staking',
        body:
            'This will pause all new staking transactions. Existing stakes will continue earning rewards. You can resume anytime.',
        bullets: [],
        confirmLabel: 'Confirm Pause',
        tone: 'warning',
      ),
      withdrawSheet: StakingEmergencySheetDraft(
        title: 'Emergency Withdrawal',
        body:
            'Warning: Emergency withdrawal may incur penalties and take 2-7 days depending on network.',
        bullets: [
          'Fixed-term stakes: 5% early withdrawal penalty',
          'Flexible stakes: Standard 2-day unstaking period',
          'Rewards earned to date will be included',
        ],
        confirmLabel: 'Confirm Emergency Withdrawal',
        tone: 'danger',
      ),
      footerNote:
          'Emergency actions are monitored and logged. Abuse may result in account restrictions. For non-emergency unstaking, use the Dashboard. Contact support before taking emergency actions.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, emergency actions, confirmation sheet copy, status cards, audit logging metadata, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingContingencyPlanRepository
    implements StakingContingencyPlanRepository {
  const MockStakingContingencyPlanRepository();

  @override
  StakingContingencyPlanSnapshot getContingencyPlan() {
    return const StakingContingencyPlanSnapshot(
      endpoint: '/api/mobile/earn/earn-contingency-plan',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Contingency Plan',
      backRoute: '/earn/risk-dashboard',
      infoTitle: 'Disaster Recovery & Business Continuity',
      infoBody:
          'Our contingency plan ensures continuity of service and asset protection in all emergency scenarios. Tested quarterly.',
      metrics: [
        StakingContingencyMetricDraft(
          label: 'Recovery Time (RTO)',
          value: '4 hours',
          tone: 'neutral',
        ),
        StakingContingencyMetricDraft(
          label: 'Data Loss Limit (RPO)',
          value: '15 minutes',
          tone: 'neutral',
        ),
        StakingContingencyMetricDraft(
          label: 'Mean Time To Recovery',
          value: '2 hours',
          tone: 'neutral',
        ),
        StakingContingencyMetricDraft(
          label: 'Insurance Coverage',
          value: '165%',
          tone: 'success',
        ),
      ],
      scenarios: [
        StakingContingencyScenarioDraft(
          scenario: 'Smart Contract Exploit',
          likelihood: 'Very Low',
          impact: 'Critical',
          response: [
            'Immediate pause of all deposits',
            'Emergency withdrawal enabled',
            'Insurance fund activation',
            'Full audit within 24 hours',
            'User communication within 1 hour',
          ],
          preventative: [
            'Quarterly security audits',
            'Bug bounty program',
            'Multi-sig wallet controls',
            'Insurance fund 165% coverage',
          ],
        ),
        StakingContingencyScenarioDraft(
          scenario: 'Validator Slashing Event',
          likelihood: 'Low',
          impact: 'Medium',
          response: [
            'Automatic stake rebalancing',
            'Insurance payout within 7 days',
            'Affected users notified immediately',
            'Validator removed from rotation',
          ],
          preventative: [
            '24/7 validator monitoring',
            'Multi-validator distribution',
            'Performance-based allocation',
            'Automatic failover',
          ],
        ),
        StakingContingencyScenarioDraft(
          scenario: 'Network Failure',
          likelihood: 'Very Low',
          impact: 'High',
          response: [
            'Failover to backup infrastructure',
            'Read-only mode activated',
            'Status page updated real-time',
            'Service restoration within 4 hours',
          ],
          preventative: [
            'Multi-region deployment',
            'Redundant infrastructure',
            'Daily backups',
            'Disaster recovery drills',
          ],
        ),
        StakingContingencyScenarioDraft(
          scenario: 'Regulatory Action',
          likelihood: 'Low',
          impact: 'High',
          response: [
            'Legal team engagement',
            'Compliance review',
            'User withdrawal window (30 days)',
            'Geographic restriction if required',
          ],
          preventative: [
            'Proactive compliance monitoring',
            'Multiple jurisdictional licenses',
            'Legal reserve fund',
          ],
        ),
      ],
      validationItems: [
        StakingContingencyValidationDraft(
          title: 'Last DR Test',
          dateLabel: '15 February 2026',
          tone: 'success',
        ),
        StakingContingencyValidationDraft(
          title: 'Next Scheduled Test',
          dateLabel: '15 May 2026',
          tone: 'warning',
        ),
      ],
      validationBody:
          'Our disaster recovery plan is tested quarterly with full simulations. All test results are documented and audited by third parties.',
      documents: [
        StakingContingencyDocumentDraft(
          name: 'Full Contingency Plan (PDF)',
          size: '2.5 MB',
          updatedLabel: '15/01/2026',
        ),
        StakingContingencyDocumentDraft(
          name: 'Incident Response Playbook',
          size: '1.8 MB',
          updatedLabel: '20/01/2026',
        ),
        StakingContingencyDocumentDraft(
          name: 'Business Continuity Plan',
          size: '3.2 MB',
          updatedLabel: '01/02/2026',
        ),
      ],
      footerNote:
          'Our contingency plan is reviewed annually and updated based on new threats, regulatory requirements, and industry best practices. For inquiries, contact compliance@platform.com.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, recovery metrics, contingency scenarios, validation schedule, documents, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingSocialFeedRepository
    implements StakingSocialFeedRepository {
  const MockStakingSocialFeedRepository();

  @override
  StakingSocialFeedSnapshot getFeed() {
    return const StakingSocialFeedSnapshot(
      endpoint: '/api/mobile/earn/earn-social-feed',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Community Feed',
      backRoute: '/earn',
      infoTitle: 'Share Your Staking Journey',
      infoBody:
          'Connect with fellow stakers, share strategies, and celebrate milestones. Learn from the community experience.',
      composerPlaceholder: 'Share your staking wins, tips, or questions...',
      defaultTabId: 'trending',
      tabs: [
        StakingSocialFeedTabDraft(
          id: 'trending',
          label: 'Trending',
          sectionTitle: 'Trending Posts',
        ),
        StakingSocialFeedTabDraft(
          id: 'following',
          label: 'Following',
          sectionTitle: 'From People You Follow',
        ),
        StakingSocialFeedTabDraft(
          id: 'my-posts',
          label: 'My Posts',
          sectionTitle: 'Your Posts',
        ),
      ],
      posts: [
        StakingSocialFeedPostDraft(
          id: 'p1',
          author: 'CryptoWhale',
          avatarLabel: 'CW',
          badge: 'VIP',
          timestamp: '2 hours ago',
          content:
              'Just hit 1000 ETH staked! The auto-compound feature is a game changer. Earned 12% more vs manual claiming.',
          type: 'milestone',
          likes: 234,
          comments: 45,
          asset: 'ETH',
        ),
        StakingSocialFeedPostDraft(
          id: 'p2',
          author: 'YieldMaximizer',
          avatarLabel: 'YM',
          timestamp: '5 hours ago',
          content:
              'Pro tip: Stake during validator rotation windows for better APY. I switched from Validator #3 to #1 and got +0.5% APY boost.',
          type: 'tip',
          likes: 156,
          comments: 28,
          asset: 'ETH',
          apy: '4.5% APY',
        ),
        StakingSocialFeedPostDraft(
          id: 'p3',
          author: 'DeFiBuilder',
          avatarLabel: 'DB',
          badge: 'Expert',
          timestamp: '1 day ago',
          content:
              'Comparison: Flexible vs Fixed 90D staking. Fixed gave me 1.2% higher APY, but liquidity risk during market dips. What is your strategy?',
          type: 'discussion',
          likes: 89,
          comments: 67,
        ),
        StakingSocialFeedPostDraft(
          id: 'p4',
          author: 'SafeStaker',
          avatarLabel: 'SS',
          timestamp: '1 day ago',
          content:
              'Achievement unlocked: 365 days uninterrupted staking! Total rewards: 125 ETH. Insurance fund saved me twice during slashing events.',
          type: 'achievement',
          likes: 312,
          comments: 52,
          asset: 'ETH',
        ),
      ],
      stats: [
        StakingSocialFeedStatDraft(
          value: '12.5K',
          label: 'Members',
          tone: 'neutral',
        ),
        StakingSocialFeedStatDraft(
          value: '3.2K',
          label: 'Posts Today',
          tone: 'neutral',
        ),
        StakingSocialFeedStatDraft(
          value: '89%',
          label: 'Active Rate',
          tone: 'success',
        ),
      ],
      footerNote:
          'Community guidelines apply. Be respectful, share knowledge, and support fellow stakers. Spam, financial advice, and referral links are prohibited.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, feed tabs, posts, reactions, comments, sharing metadata, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingCommunityGovernanceRepository
    implements StakingCommunityGovernanceRepository {
  const MockStakingCommunityGovernanceRepository();

  @override
  StakingCommunityGovernanceSnapshot getGovernance() {
    return const StakingCommunityGovernanceSnapshot(
      endpoint: '/api/mobile/earn/earn-community-governance',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Governance',
      backRoute: '/earn',
      proposalsRoute: '/earn/proposals',
      forumRoute: '/earn/forum',
      infoTitle: 'Community-Driven Decisions',
      infoBody:
          'Stakers vote on fee structures, new asset support, insurance fund policies, and platform improvements. Your stake = your voting power.',
      statsTitle: 'Governance Overview',
      stats: [
        StakingGovernanceStatDraft(
          label: 'Token Holders',
          value: '125,000',
          tone: 'neutral',
        ),
        StakingGovernanceStatDraft(
          label: 'Active Voters',
          value: '45,000',
          tone: 'accent',
        ),
        StakingGovernanceStatDraft(
          label: 'Participation Rate',
          value: '36%',
          tone: 'neutral',
        ),
        StakingGovernanceStatDraft(
          label: 'Proposals Passed',
          value: '89/127',
          tone: 'success',
        ),
      ],
      activeProposal: StakingGovernanceActiveProposalDraft(
        title: 'View All Active Proposals',
        body: 'Vote on platform fees, new features, and policy changes',
        badge: '3 Active',
      ),
      recentDecisions: [
        StakingGovernanceDecisionDraft(
          proposal: 'Reduce ETH staking fees from 2% to 1.5%',
          status: 'Passed',
          votes: '89,234',
          dateLabel: '15/02/2026',
        ),
        StakingGovernanceDecisionDraft(
          proposal: 'Add Polygon validator support',
          status: 'Passed',
          votes: '67,821',
          dateLabel: '20/01/2026',
        ),
        StakingGovernanceDecisionDraft(
          proposal: 'Increase insurance fund contribution to 3%',
          status: 'Passed',
          votes: '54,123',
          dateLabel: '10/12/2025',
        ),
      ],
      governanceSteps: [
        StakingGovernanceStepDraft(
          step: 1,
          title: 'Proposal Creation',
          description:
              'Community members with >=10,000 tokens can create proposals',
        ),
        StakingGovernanceStepDraft(
          step: 2,
          title: 'Discussion Period',
          description: '7-day discussion on forum before voting opens',
        ),
        StakingGovernanceStepDraft(
          step: 3,
          title: 'Voting Period',
          description: '14-day voting window. 1 token = 1 vote',
        ),
        StakingGovernanceStepDraft(
          step: 4,
          title: 'Execution',
          description:
              'Passed proposals (>50% approval, >10% quorum) executed within 7 days',
        ),
      ],
      votingPower: StakingGovernanceVotingPowerDraft(
        title: 'Your Voting Power',
        body: 'Based on your staked tokens. Stake more to increase influence.',
        value: '12,500',
        share: 'votes (1.25% of total)',
      ),
      footerNote:
          'Governance is on-chain and transparent. All votes are recorded on Ethereum. Proposal outcomes are binding and executed via smart contracts.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, governance stats, proposal routing, voting power, decision history, forum link, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingProposalsRepository
    implements StakingProposalsRepository {
  const MockStakingProposalsRepository();

  @override
  StakingProposalsSnapshot getProposals() {
    return const StakingProposalsSnapshot(
      endpoint: '/api/mobile/earn/earn-proposals',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Proposals',
      backRoute: '/earn/community-governance',
      createLabel: 'Create New Proposal (Requires 10K tokens)',
      proposals: [
        StakingProposalDraft(
          id: 'prop001',
          title: 'Lower ETH staking fees to 1%',
          status: 'active',
          yesVotes: 42000,
          noVotes: 18000,
          quorum: 65,
          endsIn: '5 days',
          category: 'Fees',
          votingRoute: '/earn/voting/prop001',
        ),
        StakingProposalDraft(
          id: 'prop002',
          title: 'Add support for Avalanche staking',
          status: 'active',
          yesVotes: 38000,
          noVotes: 22000,
          quorum: 58,
          endsIn: '12 days',
          category: 'Product',
          votingRoute: '/earn/voting/prop002',
        ),
        StakingProposalDraft(
          id: 'prop003',
          title: 'Increase insurance fund to 200% coverage',
          status: 'active',
          yesVotes: 28000,
          noVotes: 15000,
          quorum: 42,
          endsIn: '3 days',
          category: 'Risk',
          votingRoute: '/earn/voting/prop003',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, active proposal cards, vote ratios, quorum, proposal detail route, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingVotingRepository implements StakingVotingRepository {
  const MockStakingVotingRepository();

  @override
  StakingVotingSnapshot getVoting({String? proposalId}) {
    final endpoint = proposalId == null
        ? '/api/mobile/earn/earn-voting'
        : '/api/mobile/earn/earn-voting-$proposalId';
    return StakingVotingSnapshot(
      endpoint: endpoint,
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Proposal #127',
      backRoute: '/earn/proposals',
      category: 'Fees',
      proposalTitle: 'Lower ETH Staking Fees from 1.5% to 1%',
      proposalBody:
          'This proposal aims to reduce platform fees for ETH staking from 1.5% to 1% to remain competitive with other platforms. Revenue impact: -\$500K/year, offset by higher volume.',
      proposedByLabel: 'Proposed By',
      proposedBy: 'CommunityDAO',
      resultsTitle: 'Current Results',
      results: const [
        StakingVotingResultDraft(
          id: 'yes',
          label: 'Yes',
          percent: 70,
          votes: 42000,
          tone: 'success',
        ),
        StakingVotingResultDraft(
          id: 'no',
          label: 'No',
          percent: 30,
          votes: 18000,
          tone: 'danger',
        ),
      ],
      voteTitle: 'Cast Your Vote',
      options: const [
        StakingVotingOptionDraft(id: 'yes', label: 'Yes', tone: 'success'),
        StakingVotingOptionDraft(id: 'no', label: 'No', tone: 'danger'),
      ],
      votingPowerPrefix: 'Your voting power:',
      votingPower: '12,500 votes',
      votingPowerSuffix:
          '(based on staked tokens). Votes are final and cannot be changed.',
      submitLabel: 'Submit Vote',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, proposal detail, vote results, selected vote draft, voting power, and loading/empty/error/offline states.',
      supportedStates: const {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingForumRepository implements StakingForumRepository {
  const MockStakingForumRepository();

  @override
  StakingForumSnapshot getForum() {
    return const StakingForumSnapshot(
      endpoint: '/api/mobile/earn/earn-forum',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Forum',
      backRoute: '/earn/community-governance',
      heroTitle: 'Community Forum',
      heroBody:
          'Discuss strategies, proposals, and get support from fellow stakers.',
      categoriesTitle: 'Categories',
      categories: [
        StakingForumCategoryDraft(
          name: 'General Discussion',
          threads: 1234,
          posts: 8901,
        ),
        StakingForumCategoryDraft(
          name: 'Proposals & Voting',
          threads: 89,
          posts: 567,
        ),
        StakingForumCategoryDraft(
          name: 'Technical Support',
          threads: 456,
          posts: 2340,
        ),
        StakingForumCategoryDraft(
          name: 'Strategy & Tips',
          threads: 678,
          posts: 4521,
        ),
      ],
      threadsTitle: 'Trending Threads',
      threads: [
        StakingForumThreadDraft(
          title: 'Best validators for ETH staking in 2026?',
          replies: 234,
          views: 5678,
          pinned: true,
          author: 'CryptoGuru',
        ),
        StakingForumThreadDraft(
          title: 'Proposal #127 discussion: Lower fees',
          replies: 156,
          views: 3421,
          pinned: false,
          author: 'StakeMax',
        ),
        StakingForumThreadDraft(
          title: 'How to maximize rewards with auto-compound',
          replies: 89,
          views: 2103,
          pinned: false,
          author: 'YieldHunter',
        ),
      ],
      createLabel: 'Create New Thread',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, forum categories, trending threads, create-thread draft, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingWebhooksRepository implements StakingWebhooksRepository {
  const MockStakingWebhooksRepository();

  @override
  StakingWebhooksSnapshot getWebhooks() {
    return const StakingWebhooksSnapshot(
      endpoint: '/api/mobile/earn/earn-webhooks',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/webhooks; DELETE /earn/webhooks/:id',
      title: 'Webhooks',
      backRoute: '/earn',
      heroTitle: 'Real-time Event Notifications',
      heroBody:
          'Receive instant HTTP callbacks when staking events occur. Perfect for automation and integrations.',
      createLabel: 'Create Webhook',
      activeTitle: 'Active Webhooks',
      webhooks: [
        StakingWebhookDraft(
          id: 'w1',
          url: 'https://api.myapp.com/staking/rewards',
          events: ['reward_received'],
          active: true,
          lastTriggered: '2 mins ago',
        ),
        StakingWebhookDraft(
          id: 'w2',
          url: 'https://hooks.slack.com/services/...',
          events: ['stake_completed', 'unstake_completed'],
          active: true,
          lastTriggered: '1 hour ago',
        ),
        StakingWebhookDraft(
          id: 'w3',
          url: 'https://discord.com/api/webhooks/...',
          events: ['slashing_detected'],
          active: false,
          lastTriggered: 'Never',
        ),
      ],
      eventsTitle: 'Available Events',
      availableEvents: [
        'stake_completed',
        'unstake_completed',
        'reward_received',
        'validator_changed',
        'slashing_detected',
        'apy_changed',
      ],
      sheetTitle: 'Create Webhook',
      urlLabel: 'Webhook URL',
      urlPlaceholder: 'https://...',
      eventsLabel: 'Events',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, webhook URL draft, event subscriptions, create/delete action state, and loading/empty/error/offline states.',
      supportedStates: {
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

final class MockStakingDataExportRepository
    implements StakingDataExportRepository {
  const MockStakingDataExportRepository();

  @override
  StakingDataExportSnapshot getDataExport() {
    return const StakingDataExportSnapshot(
      endpoint: '/api/mobile/earn/earn-data-export',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /exports',
      title: 'Data Export',
      backRoute: '/earn',
      heroTitle: 'Export Your Data',
      heroBody:
          'Download complete records for accounting, tax reporting, or personal analysis. All exports are encrypted.',
      quickTitle: 'Quick Exports',
      quickExports: [
        StakingQuickExportDraft(
          id: 'transactions',
          name: 'All Transactions',
          description: 'Complete transaction history (CSV)',
          iconKey: 'file',
        ),
        StakingQuickExportDraft(
          id: 'rewards',
          name: 'Rewards Report',
          description: 'Daily rewards breakdown (CSV)',
          iconKey: 'calendar',
        ),
        StakingQuickExportDraft(
          id: 'tax',
          name: 'Tax Report',
          description: 'Annual tax summary (PDF)',
          iconKey: 'file',
        ),
        StakingQuickExportDraft(
          id: 'portfolio',
          name: 'Portfolio Snapshot',
          description: 'Current positions (JSON)',
          iconKey: 'file',
        ),
      ],
      customTitle: 'Custom Export',
      dateRangeLabel: 'Date Range',
      startPlaceholder: 'mm/dd/yyyy',
      endPlaceholder: 'mm/dd/yyyy',
      formatLabel: 'Format',
      formatOptions: ['CSV', 'JSON', 'PDF'],
      defaultFormat: 'CSV',
      exportLabel: 'Export Custom Range',
      footerNote:
          'Exports are generated on-demand and available for download for 7 days. Large exports may take up to 5 minutes to process.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, quick export type, custom date range, format selection, export job state, and POST /exports action state.',
      supportedStates: {
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

final class MockStakingThirdPartyIntegrationsRepository
    implements StakingThirdPartyIntegrationsRepository {
  const MockStakingThirdPartyIntegrationsRepository();

  @override
  StakingThirdPartyIntegrationsSnapshot getIntegrations() {
    return const StakingThirdPartyIntegrationsSnapshot(
      endpoint: '/api/mobile/earn/earn-third-party-integrations',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/integrations/:id/connect',
      title: 'Integrations',
      backRoute: '/earn',
      heroTitle: 'Connect Your Tools',
      heroBody:
          'Sync your staking data with tax software, portfolio trackers, and automation tools.',
      sectionTitle: 'Available Integrations',
      integrations: [
        StakingIntegrationDraft(
          id: 'turbotax',
          name: 'TurboTax',
          description: 'Automatic tax import',
          connected: true,
          iconKey: 'briefcase',
        ),
        StakingIntegrationDraft(
          id: 'cointracker',
          name: 'CoinTracker',
          description: 'Portfolio tracking',
          connected: true,
          iconKey: 'chart',
        ),
        StakingIntegrationDraft(
          id: 'ledger',
          name: 'Ledger Live',
          description: 'Hardware wallet sync',
          connected: false,
          iconKey: 'lock',
        ),
        StakingIntegrationDraft(
          id: 'metamask',
          name: 'MetaMask',
          description: 'Wallet integration',
          connected: true,
          iconKey: 'wallet',
        ),
        StakingIntegrationDraft(
          id: 'zapier',
          name: 'Zapier',
          description: 'Automation workflows',
          connected: false,
          iconKey: 'bolt',
        ),
        StakingIntegrationDraft(
          id: 'discord',
          name: 'Discord Bot',
          description: 'Notifications',
          connected: false,
          iconKey: 'bot',
        ),
      ],
      apiTitle: 'API Access',
      apiBody:
          'Build custom integrations using our API. Full documentation available.',
      apiActionLabel: 'View API Docs',
      apiDocsRoute: '/earn/api-documentation',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, integration connection state, API docs route, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
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

final class MockStakingDeveloperConsoleRepository
    implements StakingDeveloperConsoleRepository {
  const MockStakingDeveloperConsoleRepository();

  @override
  StakingDeveloperConsoleSnapshot getConsole() {
    return const StakingDeveloperConsoleSnapshot(
      endpoint: '/api/mobile/earn/earn-developer-console',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/developer-console/api-keys',
      title: 'Developer Console',
      backRoute: '/earn',
      heroTitle: 'API Management',
      heroBody: 'Manage API keys, monitor usage, and access documentation.',
      defaultTab: 'keys',
      tabs: [
        StakingConsoleTabDraft(id: 'keys', label: 'API Keys'),
        StakingConsoleTabDraft(id: 'logs', label: 'Logs'),
        StakingConsoleTabDraft(id: 'docs', label: 'Docs'),
      ],
      stats: [
        StakingConsoleStatDraft(
          id: 'requests',
          value: '13.4K',
          label: 'Requests/day',
          tone: 'neutral',
        ),
        StakingConsoleStatDraft(
          id: 'uptime',
          value: '99.9%',
          label: 'Uptime',
          tone: 'success',
        ),
        StakingConsoleStatDraft(
          id: 'latency',
          value: '12ms',
          label: 'Avg latency',
          tone: 'neutral',
        ),
      ],
      keysTitle: 'API Keys',
      apiKeys: [
        StakingApiKeyDraft(
          id: 'key1',
          name: 'Production API',
          keyPreview: 'sk_live_4f8b...2a3c',
          created: '2026-01-15',
          lastUsed: '2 mins ago',
          requests: 12543,
        ),
        StakingApiKeyDraft(
          id: 'key2',
          name: 'Test Environment',
          keyPreview: 'sk_test_9d1e...7b4f',
          created: '2025-12-01',
          lastUsed: '1 day ago',
          requests: 892,
        ),
      ],
      createKeyLabel: 'Create New API Key',
      logsTitle: 'Recent API Requests',
      recentRequests: [
        StakingApiRequestDraft(
          endpoint: 'POST /staking/stake',
          status: 200,
          time: '45ms',
          timestamp: '14:32:15',
        ),
        StakingApiRequestDraft(
          endpoint: 'GET /staking/positions',
          status: 200,
          time: '23ms',
          timestamp: '14:30:02',
        ),
        StakingApiRequestDraft(
          endpoint: 'GET /staking/rewards',
          status: 200,
          time: '18ms',
          timestamp: '14:28:47',
        ),
      ],
      docsTitle: 'Quick Links',
      docs: [
        StakingConsoleDocDraft(
          title: 'API Reference',
          description: 'Complete endpoint documentation',
        ),
        StakingConsoleDocDraft(
          title: 'Authentication',
          description: 'API key setup and security',
        ),
        StakingConsoleDocDraft(
          title: 'Rate Limits',
          description: 'Request quotas and throttling',
        ),
        StakingConsoleDocDraft(
          title: 'Webhooks Guide',
          description: 'Real-time event notifications',
        ),
      ],
      contractNotes:
          'Reference/admin surface; gate behind internal role or dev flag. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, API key previews, request log samples, docs links, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
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

final class MockStakingAdvancedOrdersRepository
    implements StakingAdvancedOrdersRepository {
  const MockStakingAdvancedOrdersRepository();

  @override
  StakingAdvancedOrdersSnapshot getAdvancedOrders() {
    return const StakingAdvancedOrdersSnapshot(
      endpoint: '/api/mobile/earn/earn-advanced-orders',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/advanced-orders; DELETE /earn/staking/advanced-orders/:id',
      title: 'Advanced Orders',
      backRoute: '/earn/staking',
      infoTitle: 'Automate Your Liquid Staking Strategy',
      infoBody:
          'Set take-profit and stop-loss orders for liquid staking tokens (stETH, rETH). Automatically exit positions at target prices.',
      activeOrders: [
        StakingAdvancedOrderDraft(
          id: 'o1',
          type: StakingAdvancedOrderType.takeProfit,
          asset: 'stETH',
          trigger: 1.15,
          amount: 50,
          status: StakingAdvancedOrderStatus.active,
          created: '2026-03-01',
        ),
        StakingAdvancedOrderDraft(
          id: 'o2',
          type: StakingAdvancedOrderType.stopLoss,
          asset: 'rETH',
          trigger: 0.95,
          amount: 25,
          status: StakingAdvancedOrderStatus.active,
          created: '2026-02-28',
        ),
        StakingAdvancedOrderDraft(
          id: 'o3',
          type: StakingAdvancedOrderType.trailingStop,
          asset: 'stMATIC',
          trigger: 0.90,
          amount: 100,
          status: StakingAdvancedOrderStatus.active,
          created: '2026-02-25',
        ),
      ],
      orderHistory: [
        StakingAdvancedOrderDraft(
          id: 'h1',
          type: StakingAdvancedOrderType.takeProfit,
          asset: 'stETH',
          trigger: 1.12,
          amount: 30,
          status: StakingAdvancedOrderStatus.triggered,
          created: '2026-02-20',
        ),
        StakingAdvancedOrderDraft(
          id: 'h2',
          type: StakingAdvancedOrderType.stopLoss,
          asset: 'rETH',
          trigger: 0.98,
          amount: 15,
          status: StakingAdvancedOrderStatus.cancelled,
          created: '2026-02-15',
        ),
      ],
      statCards: [
        StakingAdvancedOrderStatDraft(
          label: 'Active Orders',
          value: '3',
          tone: 'success',
        ),
        StakingAdvancedOrderStatDraft(
          label: 'Triggered',
          value: '8',
          tone: 'neutral',
        ),
        StakingAdvancedOrderStatDraft(
          label: 'Saved P&L',
          value: '+\$12.4K',
          tone: 'neutral',
        ),
      ],
      orderTypeOptions: [
        StakingAdvancedOrderType.takeProfit,
        StakingAdvancedOrderType.stopLoss,
        StakingAdvancedOrderType.trailingStop,
      ],
      assetOptions: [
        'stETH (Lido)',
        'rETH (Rocket Pool)',
        'stMATIC (Lido Polygon)',
        'cbETH (Coinbase)',
      ],
      currentPriceLabel: 'Current: 1.05 ETH',
      availableLabel: 'Available: 150 stETH',
      orderTypeWarnings: {
        StakingAdvancedOrderType.takeProfit:
            'Order will execute automatically when price reaches trigger. Subject to market slippage.',
        StakingAdvancedOrderType.stopLoss:
            'Stop-loss protects against downside but may lock in losses during flash crashes.',
        StakingAdvancedOrderType.trailingStop:
            'Trailing stop follows price up but sells if it drops by set percentage.',
      },
      howItWorks: [
        StakingAdvancedOrderInfoDraft(
          title: 'Take Profit',
          description:
              'Automatically sell when price reaches target. Lock in gains without monitoring 24/7.',
        ),
        StakingAdvancedOrderInfoDraft(
          title: 'Stop Loss',
          description:
              'Exit position if price drops below threshold. Limit downside risk during market volatility.',
        ),
        StakingAdvancedOrderInfoDraft(
          title: 'Trailing Stop',
          description:
              'Dynamic stop that follows price up. Captures upside while protecting profits.',
        ),
      ],
      riskTitle: 'Risk Disclosure',
      riskBody:
          'Advanced orders execute at market prices and may experience slippage. Stop-loss orders do not guarantee execution price during extreme volatility. Only use with liquid staking tokens you understand.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, active orders, order history, create-order draft, cancel-order action, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
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

final class MockStakingMultiChainRepository
    implements StakingMultiChainRepository {
  const MockStakingMultiChainRepository();

  @override
  StakingMultiChainSnapshot getMultiChain() {
    return const StakingMultiChainSnapshot(
      endpoint: '/api/mobile/earn/earn-multi-chain',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/multi-chain/rebalance; POST /earn/staking/multi-chain/connect',
      title: 'Multi-Chain Portfolio',
      backRoute: '/earn/staking',
      dashboardRoute: '/earn/dashboard',
      infoTitle: 'Cross-Chain Staking Hub',
      infoBody:
          'Manage staking positions across Ethereum, Polygon, Avalanche, Cosmos, and Solana from one dashboard. Unified rewards tracking.',
      totalValue: 482150,
      totalGainLabel: '+12.4%',
      totalRewards24h: 156.8,
      avgApy: 7.84,
      activeChains: 5,
      positions: [
        StakingChainPositionDraft(
          chainId: StakingChainId.ethereum,
          chain: 'Ethereum',
          asset: 'ETH',
          staked: 125.5,
          value: 287650,
          apy: 4.2,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.polygon,
          chain: 'Polygon',
          asset: 'MATIC',
          staked: 50000,
          value: 45000,
          apy: 8.5,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.avalanche,
          chain: 'Avalanche',
          asset: 'AVAX',
          staked: 1200,
          value: 48000,
          apy: 6.8,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.cosmos,
          chain: 'Cosmos',
          asset: 'ATOM',
          staked: 3500,
          value: 38500,
          apy: 12.5,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.solana,
          chain: 'Solana',
          asset: 'SOL',
          staked: 450,
          value: 63000,
          apy: 7.2,
        ),
      ],
      quickActions: [
        StakingMultiChainInfoDraft(
          title: 'Rebalance',
          description: 'Optimize allocation across chains',
          icon: 'trend',
        ),
        StakingMultiChainInfoDraft(
          title: 'Add Chain',
          description: 'Expand to new networks',
          icon: 'globe',
        ),
      ],
      benefits: [
        StakingMultiChainInfoDraft(
          title: 'Diversification',
          description: 'Reduce risk by spreading across multiple blockchains',
          icon: 'shield',
        ),
        StakingMultiChainInfoDraft(
          title: 'APY Optimization',
          description: 'Access higher yields on different networks',
          icon: 'trend',
        ),
        StakingMultiChainInfoDraft(
          title: 'Network Resilience',
          description: 'Not dependent on single chain performance',
          icon: 'globe',
        ),
        StakingMultiChainInfoDraft(
          title: 'Gas Efficiency',
          description: 'Choose low-cost chains for smaller positions',
          icon: 'cost',
        ),
      ],
      technicalNote:
          'Cross-chain positions require separate wallet connections for each network. Bridge fees apply when moving assets between chains. Always verify contract addresses.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, chain allocation, per-chain positions, rebalance action draft, chain connection state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingInstitutionalRepository
    implements StakingInstitutionalRepository {
  const MockStakingInstitutionalRepository();

  @override
  StakingInstitutionalSnapshot getInstitutional() {
    return const StakingInstitutionalSnapshot(
      endpoint: '/api/mobile/earn/earn-institutional',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/institutional/batches; POST /earn/staking/institutional/batches/:id/approve; POST /earn/staking/institutional/batches/:id/execute',
      title: 'Institutional Dashboard',
      backRoute: '/earn/staking',
      infoTitle: 'Enterprise Staking Platform',
      infoBody:
          'Batch operations, multi-signature approvals, and institutional-grade custody for large-scale staking.',
      stats: [
        StakingInstitutionalStatDraft(
          label: 'Total Staked',
          value: '\$25.6M',
          tone: 'primary',
          icon: 'building',
        ),
        StakingInstitutionalStatDraft(
          label: 'Multi-Sig',
          value: '3/5',
          tone: 'neutral',
          icon: 'users',
        ),
        StakingInstitutionalStatDraft(
          label: 'Certified',
          value: 'SOC 2',
          tone: 'success',
          icon: 'shield',
        ),
      ],
      pendingBatches: [
        StakingInstitutionalBatchDraft(
          id: 'b1',
          type: StakingInstitutionalBatchType.stake,
          operations: 12,
          totalAmount: 500,
          status: StakingInstitutionalBatchStatus.pending,
          created: '2026-03-07 14:30',
          approvals: 1,
          requiredApprovals: 3,
        ),
        StakingInstitutionalBatchDraft(
          id: 'b2',
          type: StakingInstitutionalBatchType.claim,
          operations: 8,
          totalAmount: 24.5,
          status: StakingInstitutionalBatchStatus.approved,
          created: '2026-03-07 13:15',
          approvals: 3,
          requiredApprovals: 3,
        ),
      ],
      executedBatches: [
        StakingInstitutionalBatchDraft(
          id: 'e1',
          type: StakingInstitutionalBatchType.stake,
          operations: 15,
          totalAmount: 750,
          status: StakingInstitutionalBatchStatus.executed,
          created: '2026-03-06 16:20',
          approvals: 3,
          requiredApprovals: 3,
        ),
        StakingInstitutionalBatchDraft(
          id: 'e2',
          type: StakingInstitutionalBatchType.unstake,
          operations: 5,
          totalAmount: 150,
          status: StakingInstitutionalBatchStatus.executed,
          created: '2026-03-05 11:45',
          approvals: 3,
          requiredApprovals: 3,
        ),
      ],
      signers: [
        StakingInstitutionalSignerDraft(
          name: 'Alice Chen',
          role: 'CFO',
          address: '0x1234...5678',
          status: StakingInstitutionalSignerStatus.approved,
        ),
        StakingInstitutionalSignerDraft(
          name: 'Bob Martinez',
          role: 'CTO',
          address: '0xabcd...ef01',
          status: StakingInstitutionalSignerStatus.approved,
        ),
        StakingInstitutionalSignerDraft(
          name: 'Carol Wu',
          role: 'COO',
          address: '0x9876...5432',
          status: StakingInstitutionalSignerStatus.pending,
        ),
      ],
      features: [
        StakingInstitutionalFeatureDraft(
          title: 'Cold Storage',
          description: '95% of funds in cold wallets',
          icon: 'shield',
        ),
        StakingInstitutionalFeatureDraft(
          title: 'Audit Trail',
          description: 'Complete transaction logs',
          icon: 'file',
        ),
        StakingInstitutionalFeatureDraft(
          title: 'RBAC',
          description: 'Role-based access control',
          icon: 'users',
        ),
        StakingInstitutionalFeatureDraft(
          title: 'Custody',
          description: 'Fireblocks integration',
          icon: 'building',
        ),
      ],
      complianceTitle: 'Institutional Compliance',
      complianceBody:
          'SOC 2 Type II certified. MiFID II compliant. Multi-signature custody with Fireblocks. 24/7 institutional support. Dedicated account manager for AUM > \$10M.',
      operationTypes: [
        'Batch Stake',
        'Batch Unstake',
        'Batch Claim Rewards',
        'Batch Validator Change',
      ],
      csvFormatNote: 'Format: address, amount, validator',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, batch operations, signer approvals, RBAC roles, custody provider status, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
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

final class MockStakingGuideRepository implements StakingGuideRepository {
  const MockStakingGuideRepository();

  @override
  StakingGuideSnapshot getGuide() {
    return const StakingGuideSnapshot(
      endpoint: '/api/mobile/earn/earn-guide',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Hướng dẫn Staking',
      backRoute: '/earn/staking',
      stakingRoute: '/earn/staking',
      heroTitle: 'Học Staking từ Zero',
      heroBody:
          'Hướng dẫn từng bước để bạn bắt đầu kiếm passive income từ crypto. Từ cơ bản đến nâng cao.',
      tutorials: [
        StakingGuideTutorialDraft(
          id: 'basic',
          title: 'Staking Cơ bản',
          duration: '5 phút',
          difficulty: StakingGuideDifficulty.beginner,
          steps: [
            StakingGuideStepDraft(
              id: 's1',
              title: 'Staking là gì?',
              description:
                  'Staking là cách khóa crypto để hỗ trợ mạng blockchain và nhận phần thưởng. Giống gửi tiết kiệm, nhưng APY có thể cao hơn và vẫn có rủi ro thị trường.',
              iconKey: 'book',
              tips: [
                'APY thường cao hơn lãi suất ngân hàng nhưng không cố định.',
                'Phần thưởng có thể được phân phối tự động hằng ngày.',
                'Bạn vẫn sở hữu crypto đã stake, trừ khi chọn sản phẩm có điều khoản khóa riêng.',
              ],
            ),
            StakingGuideStepDraft(
              id: 's2',
              title: 'Chọn loại Staking',
              description:
                  'Có 3 nhóm chính: Flexible rút linh hoạt, Fixed khóa theo kỳ hạn và DeFi staking có thanh khoản hoặc smart contract risk cao hơn.',
              iconKey: 'trend',
              tips: [
                'Flexible phù hợp khi cần thanh khoản khẩn cấp.',
                'Fixed thường có APY cao hơn nhưng cần đọc thời gian unbonding.',
                'DeFi chỉ nên dùng khi hiểu rõ protocol và rủi ro hợp đồng.',
              ],
            ),
            StakingGuideStepDraft(
              id: 's3',
              title: 'Tính toán lợi nhuận',
              description:
                  'Lãi năm ước tính = số tiền stake x APY. Ví dụ stake 10,000 USD với APY 7.5% có thể tạo khoảng 750 USD/năm trước phí.',
              iconKey: 'calculator',
              tips: [
                'Auto-compound giúp tăng lợi nhuận kép.',
                'APY thực tế có thể đổi theo validator và thị trường.',
                'Luôn trừ phí validator, gas và phí nền tảng nếu có.',
              ],
            ),
          ],
        ),
        StakingGuideTutorialDraft(
          id: 'advanced',
          title: 'Staking Nâng cao',
          duration: '10 phút',
          difficulty: StakingGuideDifficulty.intermediate,
          steps: [
            StakingGuideStepDraft(
              id: 'a1',
              title: 'Chọn Validator',
              description:
                  'Validator vận hành node blockchain. Ưu tiên uptime cao, phí hợp lý, không có lịch sử slashing nghiêm trọng và minh bạch vận hành.',
              iconKey: 'shield',
              tips: [
                'Ưu tiên validator recommended hoặc top tier.',
                'Kiểm tra uptime, commission và slashing history.',
                'Chia qua nhiều validator để giảm rủi ro tập trung.',
              ],
            ),
            StakingGuideStepDraft(
              id: 'a2',
              title: 'Auto-compound Strategy',
              description:
                  'Auto-compound tái đầu tư phần thưởng để tạo lãi kép. Daily compound có thể tối ưu APY nhưng cần cân bằng với phí gas.',
              iconKey: 'trend',
              tips: [
                'Đặt threshold tối thiểu để tránh compound số nhỏ.',
                'Dùng gas optimization khi mạng phí cao.',
                'Review hiệu quả compound theo tuần hoặc tháng.',
              ],
            ),
            StakingGuideStepDraft(
              id: 'a3',
              title: 'Liquid Staking',
              description:
                  'Liquid staking trả về token đại diện như stETH hoặc rETH để bạn vẫn có thanh khoản. Token này có thể swap hoặc dùng trong DeFi nhưng có rủi ro depeg.',
              iconKey: 'book',
              tips: [
                'Chọn protocol có thanh khoản tốt.',
                'Theo dõi chênh lệch giá giữa stToken và tài sản gốc.',
                'Cẩn thận slippage khi thị trường biến động mạnh.',
              ],
            ),
          ],
        ),
        StakingGuideTutorialDraft(
          id: 'risk',
          title: 'Quản lý Rủi ro',
          duration: '8 phút',
          difficulty: StakingGuideDifficulty.advanced,
          steps: [
            StakingGuideStepDraft(
              id: 'r1',
              title: 'Hiểu các loại rủi ro',
              description:
                  'Staking có rủi ro slashing, smart contract, market risk và liquidity risk. Không nên xem APY là lợi nhuận đảm bảo.',
              iconKey: 'warning',
              tips: [
                'Slashing có thể làm mất một phần tài sản đã stake.',
                'Smart contract bug có thể ảnh hưởng DeFi staking.',
                'Giá crypto giảm không được bù bởi staking reward.',
              ],
            ),
            StakingGuideStepDraft(
              id: 'r2',
              title: 'Sử dụng Insurance',
              description:
                  'Insurance có thể bồi thường một phần thiệt hại nếu có slashing hoặc lỗi validator, nhưng thường không cover market risk.',
              iconKey: 'shield',
              tips: [
                'Standard plan thường phù hợp với vị thế vừa.',
                'Premium plan đáng cân nhắc cho số lượng lớn.',
                'Đọc kỹ điều kiện claim trước khi mua.',
              ],
            ),
            StakingGuideStepDraft(
              id: 'r3',
              title: 'Diversification Strategy',
              description:
                  'Không stake toàn bộ vào một sản phẩm hoặc validator. Chia giữa Flexible, Fixed, DeFi và giữ phần thanh khoản dự phòng.',
              iconKey: 'chart',
              tips: [
                'Không stake quá 50% tổng tài sản nếu chưa có kế hoạch rút.',
                'Giữ một phần Flexible cho thanh khoản khẩn cấp.',
                'Review portfolio hằng tháng.',
              ],
            ),
          ],
        ),
      ],
      quickTips: [
        StakingGuideQuickTipDraft(
          title: 'Bắt đầu nhỏ',
          description: 'Stake 100-500 USD đầu tiên để học cách hoạt động',
          iconKey: 'book',
          tone: 'warning',
        ),
        StakingGuideQuickTipDraft(
          title: 'Theo dõi APY',
          description: 'APY thay đổi liên tục, kiểm tra hằng tuần',
          iconKey: 'chart',
          tone: 'primary',
        ),
        StakingGuideQuickTipDraft(
          title: 'Bật 2FA',
          description: 'Bảo vệ tài khoản trước khi stake số lượng lớn',
          iconKey: 'lock',
          tone: 'danger',
        ),
        StakingGuideQuickTipDraft(
          title: 'Bật thông báo',
          description: 'Nhận alert khi có maturity hoặc thay đổi APY',
          iconKey: 'bell',
          tone: 'primary',
        ),
        StakingGuideQuickTipDraft(
          title: 'Tính phí',
          description: 'Đừng quên trừ phí validator và gas fee',
          iconKey: 'calculator',
          tone: 'warning',
        ),
        StakingGuideQuickTipDraft(
          title: 'Lên lịch',
          description: 'Dùng Calendar để không bỏ lỡ ngày đáo hạn',
          iconKey: 'calendar',
          tone: 'danger',
        ),
      ],
      mistakes: [
        StakingGuideMistakeDraft(
          title: 'Stake tất cả vào Fixed dài hạn',
          correction: 'Nên giữ 30-50% ở Flexible để thanh khoản khẩn cấp.',
          tone: 'danger',
        ),
        StakingGuideMistakeDraft(
          title: 'Không đọc điều khoản rút',
          correction:
              'Fixed có unbonding period 7-14 ngày, không rút ngay được.',
          tone: 'warning',
        ),
        StakingGuideMistakeDraft(
          title: 'Bỏ qua rủi ro slashing',
          correction: 'Chọn validator uy tín hoặc mua insurance cho số lớn.',
          tone: 'danger',
        ),
        StakingGuideMistakeDraft(
          title: 'Quên compound phần thưởng',
          correction: 'Bật Auto-compound để tối đa hóa lợi nhuận kép.',
          tone: 'warning',
        ),
      ],
      ctaTitle: 'Sẵn sàng bắt đầu?',
      ctaBody:
          'Stake từ 100 USD để thử nghiệm. Bắt đầu với Flexible APY 6.5% - rút bất kỳ lúc nào.',
      ctaLabel: 'Stake ngay',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, tutorial progress, quick tips, common mistakes, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingFAQRepository implements StakingFAQRepository {
  const MockStakingFAQRepository();

  @override
  StakingFAQSnapshot getFAQ() {
    return const StakingFAQSnapshot(
      endpoint: '/api/mobile/earn/earn-faq',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'FAQ',
      backRoute: '/earn/staking',
      searchPlaceholder: 'Tìm câu hỏi...',
      items: [
        StakingFAQItemDraft(
          id: 'g1',
          category: StakingFAQCategory.general,
          question: 'Staking là gì và hoạt động như thế nào?',
          answer:
              'Staking là quá trình khóa crypto để hỗ trợ mạng blockchain xác thực giao dịch, bảo mật mạng và nhận phần thưởng. Bạn vẫn sở hữu crypto đã stake nhưng có thể bị giới hạn giao dịch trong thời gian stake.',
        ),
        StakingFAQItemDraft(
          id: 'g2',
          category: StakingFAQCategory.general,
          question: 'Tôi có mất quyền sở hữu crypto khi stake không?',
          answer:
              'Không. Bạn vẫn sở hữu tài sản đã stake. Với Flexible có thể rút bất kỳ lúc nào, còn Fixed cần chờ hết kỳ hạn hoặc tuân theo điều khoản rút sớm.',
        ),
        StakingFAQItemDraft(
          id: 'g3',
          category: StakingFAQCategory.general,
          question: 'Phần thưởng được tính như thế nào?',
          answer:
              'Phần thưởng ước tính theo công thức số lượng stake x APY / 365 ngày. APY thực tế có thể thay đổi theo mạng, validator và điều kiện thị trường.',
        ),
        StakingFAQItemDraft(
          id: 'g4',
          category: StakingFAQCategory.general,
          question: 'Khác biệt giữa Flexible và Fixed?',
          answer:
              'Flexible rút linh hoạt và thường có APY thấp hơn. Fixed khóa theo kỳ hạn, APY cao hơn nhưng không rút sớm được hoặc có thể mất phí/phần thưởng.',
        ),
        StakingFAQItemDraft(
          id: 'g5',
          category: StakingFAQCategory.general,
          question: 'Tôi cần bao nhiêu để bắt đầu stake?',
          answer:
              'Không có mức tối thiểu chung cho mọi sản phẩm, nhưng nên bắt đầu từ 100-500 USD ở Flexible để làm quen và đảm bảo phần thưởng vượt phí giao dịch.',
        ),
        StakingFAQItemDraft(
          id: 't1',
          category: StakingFAQCategory.technical,
          question: 'Unbonding period là gì?',
          answer:
              'Unbonding period là thời gian chờ từ lúc yêu cầu rút đến khi tài sản về ví. Một số blockchain không trả reward trong giai đoạn này.',
        ),
        StakingFAQItemDraft(
          id: 't2',
          category: StakingFAQCategory.technical,
          question: 'Validator là gì? Tôi có cần chọn validator không?',
          answer:
              'Validator vận hành node blockchain. Mặc định hệ thống phân bổ qua validator uy tín, nhưng người dùng nâng cao có thể tự chọn để tối ưu APY hoặc giảm rủi ro.',
        ),
        StakingFAQItemDraft(
          id: 't3',
          category: StakingFAQCategory.technical,
          question: 'Auto-compound hoạt động như thế nào?',
          answer:
              'Auto-compound tự động thêm reward vào số lượng stake để tạo lãi kép. Cần cân bằng lợi ích APY với phí gas và ngưỡng compound tối thiểu.',
        ),
        StakingFAQItemDraft(
          id: 't4',
          category: StakingFAQCategory.technical,
          question: 'Liquid staking khác gì staking thường?',
          answer:
              'Liquid staking trả token đại diện như stETH hoặc rETH để vẫn có thanh khoản. Token này có thể depeg hoặc chịu slippage khi swap.',
        ),
        StakingFAQItemDraft(
          id: 'f1',
          category: StakingFAQCategory.fees,
          question: 'Có phí gì khi stake không?',
          answer:
              'Thường không có phí stake ban đầu. Phí phổ biến là commission validator lấy từ reward, không lấy từ vốn gốc.',
        ),
        StakingFAQItemDraft(
          id: 'f2',
          category: StakingFAQCategory.fees,
          question: 'Có phí rút không?',
          answer:
              'Flexible thường không có phí rút. Fixed rút đúng hạn thường không phí; rút sớm có thể mất một phần reward hoặc phí theo điều khoản.',
        ),
        StakingFAQItemDraft(
          id: 'f3',
          category: StakingFAQCategory.fees,
          question: 'Gas fee có ảnh hưởng không?',
          answer:
              'Gas fee ảnh hưởng khi stake, unstake hoặc compound on-chain. Rewards hằng ngày thường không bị trừ gas riêng từng lần.',
        ),
        StakingFAQItemDraft(
          id: 'r1',
          category: StakingFAQCategory.risks,
          question: 'Slashing là gì? Tôi có thể mất tiền không?',
          answer:
              'Slashing là hình phạt khi validator vi phạm quy tắc mạng. Bạn có thể mất một phần tài sản stake, vì vậy nên chọn validator uy tín và cân nhắc insurance.',
        ),
        StakingFAQItemDraft(
          id: 'r2',
          category: StakingFAQCategory.risks,
          question: 'Insurance bồi thường những gì?',
          answer:
              'Insurance có thể bồi thường thiệt hại từ slashing, downtime hoặc lỗi hợp đồng tùy plan. Insurance thường không cover market risk.',
        ),
        StakingFAQItemDraft(
          id: 'r3',
          category: StakingFAQCategory.risks,
          question: 'Nếu giá crypto giảm, tôi có mất tiền không?',
          answer:
              'Số lượng crypto stake không đổi theo reward logic, nhưng giá trị quy đổi USD giảm theo thị trường. Đây là market risk, không phải lỗi staking.',
        ),
        StakingFAQItemDraft(
          id: 'r4',
          category: StakingFAQCategory.risks,
          question: 'Làm sao để giảm rủi ro?',
          answer:
              'Chọn validator uy tín, đa dạng hóa vị thế, giữ phần Flexible cho thanh khoản và không stake quá mức chịu rủi ro cá nhân.',
        ),
        StakingFAQItemDraft(
          id: 'a1',
          category: StakingFAQCategory.advanced,
          question: 'MEV là gì?',
          answer:
              'MEV là giá trị validator có thể thu thêm từ việc sắp xếp giao dịch trong block. Một số validator chia MEV với stakers để tăng APY.',
        ),
        StakingFAQItemDraft(
          id: 'a2',
          category: StakingFAQCategory.advanced,
          question: 'Tôi có thể chuyển stake sang validator khác không?',
          answer:
              'Có, nhưng thường cần unstake, chờ unbonding rồi stake lại. Trong thời gian chờ bạn có thể không nhận reward.',
        ),
        StakingFAQItemDraft(
          id: 'a3',
          category: StakingFAQCategory.advanced,
          question: 'Có thể dùng staking token trong DeFi không?',
          answer:
              'Có nếu dùng liquid staking token, nhưng cần theo dõi liquidation risk, smart contract risk và rủi ro depeg.',
        ),
        StakingFAQItemDraft(
          id: 'a4',
          category: StakingFAQCategory.advanced,
          question: 'APY thay đổi có ảnh hưởng vị thế hiện tại không?',
          answer:
              'Flexible thường cập nhật APY ngay. Fixed thường giữ APY theo lúc stake cho đến hết kỳ hạn, tùy điều khoản sản phẩm.',
        ),
      ],
      supportTitle: 'Không tìm thấy câu trả lời?',
      supportBody:
          'Liên hệ đội ngũ support 24/7. Thời gian phản hồi trung bình: <2 giờ.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, FAQ categories, search/filter state, support contact actions, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingNotificationsRepository
    implements StakingNotificationsRepository {
  const MockStakingNotificationsRepository();

  @override
  StakingNotificationsSnapshot getNotifications() {
    return const StakingNotificationsSnapshot(
      endpoint: '/api/mobile/earn/earn-notifications',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      settingsActionDraft: 'PATCH /user/settings/earn-notifications',
      title: 'Thông báo',
      backRoute: '/earn/staking',
      infoTitle: 'Quản lý Thông báo',
      infoBody:
          'Tùy chỉnh thông báo để không bỏ lỡ sự kiện quan trọng. Chúng tôi chỉ gửi thông báo thật sự cần thiết.',
      settings: [
        StakingNotificationSettingDraft(
          id: 'maturity',
          title: 'Vị thế sắp đáo hạn',
          description: 'Nhận thông báo 24h trước khi Fixed staking đáo hạn',
          iconKey: 'calendar',
          enabled: true,
          priority: StakingNotificationPriority.high,
        ),
        StakingNotificationSettingDraft(
          id: 'apy-change',
          title: 'Thay đổi APY',
          description: 'Thông báo khi APY thay đổi >1% (tăng hoặc giảm)',
          iconKey: 'trend',
          enabled: true,
          priority: StakingNotificationPriority.high,
        ),
        StakingNotificationSettingDraft(
          id: 'reward-ready',
          title: 'Phần thưởng sẵn sàng',
          description: 'Thông báo hằng ngày khi nhận rewards (chỉ nếu >\$10)',
          iconKey: 'reward',
          enabled: false,
          priority: StakingNotificationPriority.medium,
        ),
        StakingNotificationSettingDraft(
          id: 'compound-done',
          title: 'Auto-compound hoàn tất',
          description: 'Thông báo khi auto-compound được thực hiện',
          iconKey: 'zap',
          enabled: true,
          priority: StakingNotificationPriority.low,
        ),
        StakingNotificationSettingDraft(
          id: 'validator-risk',
          title: 'Cảnh báo Validator',
          description: 'Uptime validator <99% hoặc có slashing event',
          iconKey: 'alert',
          enabled: true,
          priority: StakingNotificationPriority.high,
        ),
        StakingNotificationSettingDraft(
          id: 'unlock-soon',
          title: 'Unbonding sắp xong',
          description:
              'Thông báo khi unbonding period sắp kết thúc (còn 1 ngày)',
          iconKey: 'clock',
          enabled: true,
          priority: StakingNotificationPriority.medium,
        ),
        StakingNotificationSettingDraft(
          id: 'weekly-summary',
          title: 'Báo cáo hằng tuần',
          description: 'Tổng kết earnings, performance, APY trung bình',
          iconKey: 'trend',
          enabled: true,
          priority: StakingNotificationPriority.low,
        ),
        StakingNotificationSettingDraft(
          id: 'new-products',
          title: 'Sản phẩm mới',
          description: 'Thông báo khi có sản phẩm staking mới hoặc APY hấp dẫn',
          iconKey: 'zap',
          enabled: false,
          priority: StakingNotificationPriority.low,
        ),
      ],
      channels: [
        StakingNotificationChannelDraft(
          id: 'push',
          label: 'Push Notification (App)',
          enabled: true,
        ),
        StakingNotificationChannelDraft(
          id: 'email',
          label: 'Email',
          enabled: true,
        ),
        StakingNotificationChannelDraft(
          id: 'sms',
          label: 'SMS (chỉ High priority)',
          enabled: false,
        ),
      ],
      history: [
        StakingNotificationHistoryDraft(
          id: 'n1',
          type: StakingNotificationType.maturity,
          title: 'SOL Fixed 30D sắp đáo hạn',
          message:
              'Vị thế của bạn sẽ đáo hạn vào 03/03/2026. Nhớ kiểm tra và quyết định stake lại hoặc rút về.',
          time: '2 giờ trước',
          read: false,
        ),
        StakingNotificationHistoryDraft(
          id: 'n2',
          type: StakingNotificationType.apyChange,
          title: 'APY USDT Flexible tăng',
          message:
              'APY đã tăng từ 6.0% lên 7.0% (+16.7%). Đây là thời điểm tốt để stake thêm.',
          time: '5 giờ trước',
          read: false,
        ),
        StakingNotificationHistoryDraft(
          id: 'n3',
          type: StakingNotificationType.reward,
          title: 'Nhận phần thưởng hôm nay',
          message:
              'Bạn đã nhận \$12.45 từ 3 vị thế staking. Tổng earnings tháng này: \$156.80.',
          time: '1 ngày trước',
          read: true,
        ),
        StakingNotificationHistoryDraft(
          id: 'n4',
          type: StakingNotificationType.system,
          title: 'Auto-compound thành công',
          message:
              'Đã tự động compound 18.5 USDT vào vị thế Flexible. APY hiệu quả: 7.2%.',
          time: '1 ngày trước',
          read: true,
        ),
        StakingNotificationHistoryDraft(
          id: 'n5',
          type: StakingNotificationType.risk,
          title: 'Cảnh báo: Validator uptime thấp',
          message:
              'Validator "Staked.us" có uptime 98.5%. Cân nhắc chuyển sang validator khác.',
          time: '3 ngày trước',
          read: true,
        ),
      ],
      footerNote:
          'Thông báo giúp bạn không bỏ lỡ các sự kiện quan trọng. Chúng tôi cam kết không spam và chỉ gửi thông báo có giá trị thật sự.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, notification settings, channels, history, DND preference, PATCH module settings, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingRecommendationsRepository
    implements StakingRecommendationsRepository {
  const MockStakingRecommendationsRepository();

  @override
  StakingRecommendationsSnapshot getRecommendations() {
    return const StakingRecommendationsSnapshot(
      endpoint: '/api/mobile/earn/earn-recommendations',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Gợi ý Staking',
      backRoute: '/earn/staking',
      riskAssessmentRoute: '/earn/staking/risk-assessment',
      stakingRoute: '/earn/staking',
      heroTitle: 'Gợi ý Staking Cá nhân hóa',
      heroSubtitle:
          'Dựa trên risk tolerance, investment horizon, và portfolio size của bạn, chúng tôi đề xuất chiến lược tối ưu.',
      profile: StakingRecommendationProfileDraft(
        riskTolerance: StakingRecommendationProfileRisk.moderate,
        investmentHorizon: StakingRecommendationHorizon.medium,
        liquidityNeed: StakingRecommendationLiquidity.medium,
        totalPortfolio: 10000,
      ),
      strategies: [
        StakingStrategyDraft(
          id: 'conservative',
          title: 'Chiến lược An toàn',
          description:
              'Ưu tiên bảo toàn vốn với APY ổn định. Phù hợp beginners và người không thích rủi ro.',
          expectedApy: 5.8,
          riskLevel: StakingRecommendationRiskLevel.low,
          allocation: [
            StakingRecommendationAllocationDraft(
              product: 'USDT Flexible',
              asset: 'USDT',
              percentage: 50,
              apy: 6.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'BTC Fixed 60D',
              asset: 'BTC',
              percentage: 30,
              apy: 5.8,
            ),
            StakingRecommendationAllocationDraft(
              product: 'ETH Fixed 30D',
              asset: 'ETH',
              percentage: 20,
              apy: 4.5,
            ),
          ],
          pros: [
            'Rủi ro thấp nhất (stablecoin + top crypto)',
            '50% thanh khoản tức thì (Flexible)',
            'APY ổn định, không biến động',
          ],
          cons: [
            'APY thấp hơn chiến lược khác',
            'Phụ thuộc stablecoin (USDT risk)',
          ],
          bestFor: [
            'Beginners mới bắt đầu staking',
            'Số lượng lớn (>\$50,000)',
            'Người không thích rủi ro',
          ],
        ),
        StakingStrategyDraft(
          id: 'balanced',
          title: 'Chiến lược Cân bằng',
          description:
              'Cân bằng giữa APY và rủi ro. Phù hợp nhất cho đa số users.',
          expectedApy: 7.2,
          riskLevel: StakingRecommendationRiskLevel.medium,
          recommended: true,
          allocation: [
            StakingRecommendationAllocationDraft(
              product: 'USDT Flexible',
              asset: 'USDT',
              percentage: 30,
              apy: 6.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'ETH Fixed 60D',
              asset: 'ETH',
              percentage: 35,
              apy: 7.2,
            ),
            StakingRecommendationAllocationDraft(
              product: 'SOL Fixed 30D',
              asset: 'SOL',
              percentage: 25,
              apy: 9.8,
            ),
            StakingRecommendationAllocationDraft(
              product: 'stETH Liquid',
              asset: 'stETH',
              percentage: 10,
              apy: 4.2,
            ),
          ],
          pros: [
            'APY cao hơn 25% so với Conservative',
            'Vẫn có 30% thanh khoản tức thì',
            'Đa dạng hóa tốt (stablecoin + top alts)',
          ],
          cons: [
            'Rủi ro giá altcoin (ETH, SOL)',
            'Liquid staking có depegging risk',
          ],
          bestFor: [
            'Users có kinh nghiệm crypto',
            'Số lượng \$5,000-50,000',
            'Người chấp nhận rủi ro vừa phải',
          ],
        ),
        StakingStrategyDraft(
          id: 'aggressive',
          title: 'Chiến lược Tăng trưởng',
          description:
              'Tối đa hóa APY với rủi ro cao hơn. Phù hợp cho risk-seekers và số lượng nhỏ.',
          expectedApy: 11.3,
          riskLevel: StakingRecommendationRiskLevel.high,
          allocation: [
            StakingRecommendationAllocationDraft(
              product: 'SOL Fixed 90D',
              asset: 'SOL',
              percentage: 35,
              apy: 10.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'ETH-USDT LP (DeFi)',
              asset: 'ETH-USDT',
              percentage: 30,
              apy: 18.7,
            ),
            StakingRecommendationAllocationDraft(
              product: 'rETH Liquid',
              asset: 'rETH',
              percentage: 20,
              apy: 4.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'USDT Flexible',
              asset: 'USDT',
              percentage: 15,
              apy: 6.5,
            ),
          ],
          pros: [
            'APY cao nhất (+95% so với Conservative)',
            'Tận dụng DeFi liquidity mining',
            'Vẫn giữ 15% stablecoin an toàn',
          ],
          cons: [
            'Rủi ro smart contract (DeFi)',
            'Chỉ 15% thanh khoản tức thì',
            'Rủi ro giá altcoin cao',
          ],
          bestFor: [
            'Experienced traders',
            'Số lượng nhỏ (<\$5,000)',
            'Người sẵn sàng chấp nhận rủi ro',
          ],
        ),
      ],
      tips: [
        StakingPersonalizedTipDraft(
          id: 'profile',
          title: 'Dựa trên Profile của bạn',
          description:
              'Moderate risk + Medium horizon → Balanced Strategy phù hợp nhất',
          iconKey: 'target',
          tone: EarnRiskLevel.medium,
        ),
        StakingPersonalizedTipDraft(
          id: 'compound',
          title: 'Tối ưu hóa nhanh',
          description:
              'Bật Auto-compound cho tất cả vị thế để tăng APY thêm 5-10%',
          iconKey: 'zap',
          tone: EarnRiskLevel.low,
        ),
        StakingPersonalizedTipDraft(
          id: 'insurance',
          title: 'Giảm rủi ro',
          description:
              'Với \$10,000 portfolio, nên mua Standard Insurance Plan (\$100/năm)',
          iconKey: 'shield',
          tone: EarnRiskLevel.high,
        ),
      ],
      disclaimer:
          'Disclaimer: Đây chỉ là gợi ý dựa trên profile. Không phải tư vấn tài chính. Bạn nên tự nghiên cứu (DYOR) và chịu trách nhiệm cho quyết định đầu tư. APY có thể thay đổi theo thị trường.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, user profile, allocation strategies, personalized tips, and strategy handoff.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingRegulatoryFrameworkRepository
    implements StakingRegulatoryFrameworkRepository {
  const MockStakingRegulatoryFrameworkRepository();

  @override
  StakingRegulatoryFrameworkSnapshot getFramework() {
    return const StakingRegulatoryFrameworkSnapshot(
      endpoint: '/api/mobile/earn/earn-regulatory-framework',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Regulatory Framework',
      backRoute: '/earn/staking',
      tabs: [
        StakingRegulatoryTabDraft(id: 'licenses', label: 'Licenses'),
        StakingRegulatoryTabDraft(id: 'protection', label: 'Protection'),
        StakingRegulatoryTabDraft(id: 'complaints', label: 'Complaints'),
      ],
      defaultTabId: 'licenses',
      heroTitle: 'Regulated & Compliant',
      heroBody:
          'We operate under licenses from leading global regulators. Your funds are protected by investor protection schemes where eligible.',
      licenses: [
        StakingLicenseDraft(
          jurisdiction: 'United States',
          regulator: 'FinCEN (Financial Crimes Enforcement Network)',
          licenseNumber: 'MSB-31000198765432',
          status: StakingLicenseStatus.active,
          issuedDate: '2023-01-15',
          scope: ['Money Services Business', 'Virtual Currency Exchange'],
          website: 'fincen.gov',
        ),
        StakingLicenseDraft(
          jurisdiction: 'United Kingdom',
          regulator: 'Financial Conduct Authority (FCA)',
          licenseNumber: 'FRN: 928619',
          status: StakingLicenseStatus.active,
          issuedDate: '2022-09-20',
          scope: ['Cryptoasset Exchange', 'Custodian Wallet Provider'],
          website: 'fca.org.uk',
        ),
        StakingLicenseDraft(
          jurisdiction: 'European Union',
          regulator: 'Central Bank of Ireland',
          licenseNumber: 'C193305',
          status: StakingLicenseStatus.active,
          issuedDate: '2023-03-10',
          scope: ['MiFID II Investment Firm', 'Payment Institution'],
          website: 'centralbank.ie',
        ),
        StakingLicenseDraft(
          jurisdiction: 'Singapore',
          regulator: 'Monetary Authority of Singapore (MAS)',
          licenseNumber: 'DPT-000123-2023',
          status: StakingLicenseStatus.active,
          issuedDate: '2023-06-01',
          scope: ['Digital Payment Token Service Provider'],
          website: 'mas.gov.sg',
        ),
        StakingLicenseDraft(
          jurisdiction: 'Hong Kong',
          regulator: 'Securities and Futures Commission (SFC)',
          licenseNumber: 'Type 1 & 7: BQR123',
          status: StakingLicenseStatus.pending,
          issuedDate: '2024-01-10',
          scope: ['Virtual Asset Trading Platform'],
          website: 'sfc.hk',
        ),
      ],
      protectionSchemes: [
        StakingProtectionSchemeDraft(
          jurisdiction: 'United Kingdom',
          scheme: 'Financial Services Compensation Scheme (FSCS)',
          coverage: 'GBP 85,000 per person',
          description: 'Protects eligible customers if authorized firm fails',
          eligibility: 'UK retail customers holding fiat currency',
        ),
        StakingProtectionSchemeDraft(
          jurisdiction: 'European Union',
          scheme: 'Deposit Guarantee Scheme (DGS)',
          coverage: 'EUR 100,000 per person',
          description: 'EU-wide protection for eligible deposits',
          eligibility: 'EU residents with eligible deposits',
        ),
        StakingProtectionSchemeDraft(
          jurisdiction: 'United States',
          scheme: 'FDIC Insurance (via partner banks)',
          coverage: '\$250,000 per depositor',
          description: 'Protection for USD deposits held at partner banks',
          eligibility: 'US customers with fiat balances at partner banks',
        ),
      ],
      complaintSteps: [
        StakingComplaintStepDraft(
          step: 1,
          title: 'Contact Customer Support',
          description:
              'Submit your complaint via Live Chat, Email, or Support Ticket. Response within 24 hours.',
          action: 'support@platform.com',
        ),
        StakingComplaintStepDraft(
          step: 2,
          title: 'Escalate to Compliance Team',
          description:
              'If not resolved within 7 days, escalate to our Compliance Officer.',
          action: 'compliance@platform.com',
        ),
        StakingComplaintStepDraft(
          step: 3,
          title: 'External Dispute Resolution',
          description:
              'If unresolved after 8 weeks, you may refer to the Financial Ombudsman Service or relevant authority.',
          action: 'financial-ombudsman.org.uk',
        ),
      ],
      authorityContacts: [
        StakingAuthorityContactDraft(
          name: 'UK Financial Conduct Authority',
          email: 'consumer.queries@fca.org.uk',
          phone: '+44 800 111 6768',
        ),
        StakingAuthorityContactDraft(
          name: 'US FinCEN',
          email: 'frc@fincen.gov',
          phone: '+1 800-949-2732',
        ),
        StakingAuthorityContactDraft(
          name: 'EU Financial Ombudsman',
          email: 'enquiries@financialombudsman.ie',
          phone: '+353 1 567 7000',
        ),
      ],
      licenseNote:
          'All licenses are verified and up-to-date. Tap any license to view full details and verify directly with the regulator.',
      protectionWarning:
          'Important: Cryptocurrency holdings are not covered by traditional deposit insurance. Only fiat balances held at partner banks are eligible for FDIC/FSCS/DGS protection. Staking rewards are subject to smart contract and validator risks.',
      footerNote:
          'This information is accurate as of March 2026. Regulatory status may change. For the most current information, contact Compliance Team or verify directly with the respective regulators.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, jurisdiction licenses, protection schemes, complaint process, authority contacts, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingAuditReportsRepository
    implements StakingAuditReportsRepository {
  const MockStakingAuditReportsRepository();

  @override
  StakingAuditReportsSnapshot getAuditReports() {
    return const StakingAuditReportsSnapshot(
      endpoint: '/api/mobile/earn/earn-audit-reports',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /exports',
      title: 'Audit Reports',
      backRoute: '/earn/staking',
      tabs: [
        StakingAuditTabDraft(id: 'all', label: 'All'),
        StakingAuditTabDraft(id: 'smart-contract', label: 'Smart Contract'),
        StakingAuditTabDraft(id: 'financial', label: 'Financial'),
        StakingAuditTabDraft(id: 'security', label: 'Security'),
      ],
      defaultTabId: 'all',
      heroTitle: 'Transparency & Trust',
      heroBody:
          'All staking smart contracts are audited quarterly by leading security firms. Financial and security audits are conducted annually.',
      stats: [
        StakingAuditStatDraft(
          label: 'Published Audits',
          value: '4',
          tone: EarnRiskLevel.low,
        ),
        StakingAuditStatDraft(
          label: 'Critical Issues',
          value: '0',
          caption: 'All-time',
          tone: EarnRiskLevel.low,
        ),
        StakingAuditStatDraft(
          label: 'Bug Bounty',
          value: '\$2M',
          caption: 'Max payout',
          tone: EarnRiskLevel.medium,
        ),
      ],
      reports: [
        StakingAuditReportDraft(
          id: 'sc-2026-q1',
          type: StakingAuditReportType.smartContract,
          title: 'Q1 2026 Smart Contract Security Audit',
          auditor: 'Trail of Bits',
          dateLabel: '28/02/2026',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 2,
            low: 5,
            informational: 8,
          ),
          summary:
              'Comprehensive security audit of staking smart contracts. All critical and high-severity issues resolved. Medium-severity findings relate to gas optimization opportunities.',
          scope: [
            'Staking Pool Contract',
            'Reward Distribution',
            'Validator Registry',
            'Emergency Pause Mechanism',
          ],
          pdfUrl: '/audits/trail-of-bits-q1-2026.pdf',
        ),
        StakingAuditReportDraft(
          id: 'sc-2025-q4',
          type: StakingAuditReportType.smartContract,
          title: 'Q4 2025 Smart Contract Audit',
          auditor: 'Sigma Prime',
          dateLabel: '20/11/2025',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 1,
            medium: 3,
            low: 7,
            informational: 12,
          ),
          summary:
              'All high-severity issues patched before deployment. Focus areas: reentrancy protection, integer overflow checks, access control.',
          scope: [
            'Liquid Staking Module',
            'Auto-Compound Logic',
            'Insurance Fund Contract',
          ],
          pdfUrl: '/audits/sigma-prime-q4-2025.pdf',
        ),
        StakingAuditReportDraft(
          id: 'fin-2025',
          type: StakingAuditReportType.financial,
          title: '2025 Annual Financial Audit',
          auditor: 'Deloitte',
          dateLabel: '31/01/2026',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 0,
            low: 0,
            informational: 0,
          ),
          summary:
              'Unqualified opinion. Financial statements present fairly the financial position. Internal controls are adequate and effective.',
          scope: [
            'Balance Sheet',
            'Income Statement',
            'Cash Flow',
            'Internal Controls',
            'Client Fund Segregation',
          ],
          pdfUrl: '/audits/deloitte-financial-2025.pdf',
        ),
        StakingAuditReportDraft(
          id: 'sec-2025',
          type: StakingAuditReportType.security,
          title: 'SOC 2 Type II Audit 2025',
          auditor: 'PwC',
          dateLabel: '15/12/2025',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 1,
            low: 3,
            informational: 5,
          ),
          summary:
              'Successfully passed SOC 2 Type II audit. Controls operating effectively for Security, Availability, and Confidentiality.',
          scope: [
            'Access Controls',
            'Encryption',
            'Incident Response',
            'Business Continuity',
            'Change Management',
          ],
          pdfUrl: '/audits/pwc-soc2-2025.pdf',
        ),
        StakingAuditReportDraft(
          id: 'sc-2026-q2',
          type: StakingAuditReportType.smartContract,
          title: 'Q2 2026 Smart Contract Audit',
          auditor: 'ConsenSys Diligence',
          dateLabel: '15/05/2026',
          status: StakingAuditReportStatus.inProgress,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 0,
            low: 0,
            informational: 0,
          ),
          summary:
              'Audit currently in progress. Expected completion: May 20, 2026.',
          scope: [
            'Cross-Chain Staking',
            'Governance Module',
            'Slashing Protection',
          ],
        ),
      ],
      bugBounty: StakingBugBountyDraft(
        title: 'Immunefi Bug Bounty',
        subtitle: 'Up to \$2M for critical vulnerabilities',
        body:
            'We partner with Immunefi to reward security researchers who discover vulnerabilities in our smart contracts and infrastructure.',
        programUrl: 'https://immunefi.com',
        payouts: [
          StakingBugBountyPayoutDraft(
            severity: 'Critical',
            amount: '\$2,000,000',
            tone: EarnRiskLevel.high,
          ),
          StakingBugBountyPayoutDraft(
            severity: 'High',
            amount: '\$100,000',
            tone: EarnRiskLevel.medium,
          ),
          StakingBugBountyPayoutDraft(
            severity: 'Medium',
            amount: '\$10,000',
            tone: EarnRiskLevel.medium,
          ),
          StakingBugBountyPayoutDraft(
            severity: 'Low',
            amount: '\$1,000',
            tone: EarnRiskLevel.low,
          ),
        ],
      ),
      footerNote:
          'All audit reports are published within 14 days of completion. Smart contract audits are conducted quarterly. Financial and security audits are conducted annually. Reports are available for download and verification.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, audit reports, findings, scope chips, bug bounty data, POST /exports action state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingCustodyRepository implements StakingCustodyRepository {
  const MockStakingCustodyRepository();

  @override
  StakingCustodySnapshot getCustody() {
    return const StakingCustodySnapshot(
      endpoint: '/api/mobile/earn/earn-custody',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Custody & Segregation',
      backRoute: '/earn/staking',
      heroTitle: 'Institutional-Grade Custody',
      heroBody:
          'Your staked assets are held by Fireblocks, a regulated institutional custodian, segregated from platform operational funds.',
      custodian: StakingCustodianDraft(
        name: 'Fireblocks',
        type: 'Institutional Digital Asset Custodian',
        founded: '2018',
        headquarters: 'New York, USA',
        licenses: ['NY Trust Charter', 'SOC 2 Type II', 'ISO 27001'],
        insurance: "\$255M Crime Insurance (Lloyd's of London)",
        clients: '1,800+ institutions',
        aum: '\$4 Trillion+ in digital assets transferred',
      ),
      segregationBody:
          'Client staking funds are completely segregated from platform operational funds. In the event of insolvency, your assets are protected and returned in full.',
      segregation: [
        StakingCustodyAllocationDraft(
          name: 'Client Staking Funds',
          value: 85,
          tone: EarnRiskLevel.low,
        ),
        StakingCustodyAllocationDraft(
          name: 'Platform Operational',
          value: 10,
          tone: EarnRiskLevel.high,
        ),
        StakingCustodyAllocationDraft(
          name: 'Insurance Reserve',
          value: 5,
          tone: EarnRiskLevel.medium,
        ),
      ],
      segregationLegend: [
        StakingCustodyLegendDraft(
          iconKey: 'building',
          label: 'Client Funds',
          description: 'Held in segregated accounts at custodian',
          tone: EarnRiskLevel.low,
        ),
        StakingCustodyLegendDraft(
          iconKey: 'lock',
          label: 'Platform Operational',
          description: 'Company operating capital (separate)',
          tone: EarnRiskLevel.high,
        ),
        StakingCustodyLegendDraft(
          iconKey: 'shield',
          label: 'Insurance Reserve',
          description: 'Emergency fund for slashing events',
          tone: EarnRiskLevel.medium,
        ),
      ],
      hotColdBody:
          '95% of staked assets are held in cold storage (offline, air-gapped). Only 5% in hot wallets for operational liquidity (withdrawals, auto-compound).',
      hotCold: [
        StakingCustodyAllocationDraft(
          name: 'Cold Wallet',
          value: 95,
          tone: EarnRiskLevel.low,
        ),
        StakingCustodyAllocationDraft(
          name: 'Hot Wallet',
          value: 5,
          tone: EarnRiskLevel.medium,
        ),
      ],
      reconciliationBody:
          'Every day, we reconcile on-chain balances with custodian records. 100% match rate since launch.',
      reconciliationLogs: [
        StakingReconciliationLogDraft(
          dateLabel: '07/03/2026',
          onChainUsd: 125430500,
          custodyUsd: 125430500,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '06/03/2026',
          onChainUsd: 124850250,
          custodyUsd: 124850250,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '05/03/2026',
          onChainUsd: 123900750,
          custodyUsd: 123900750,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '04/03/2026',
          onChainUsd: 122500000,
          custodyUsd: 122500000,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '03/03/2026',
          onChainUsd: 121200500,
          custodyUsd: 121200500,
          discrepancyUsd: 0,
        ),
      ],
      transparencyBody:
          'All staking transactions are visible on-chain. You can verify your stake anytime using blockchain explorers.',
      transparencyAddresses: [
        StakingTransparencyAddressDraft(
          label: 'Ethereum Mainnet',
          address: '0x1234...5678',
          explorer: 'etherscan.io',
        ),
        StakingTransparencyAddressDraft(
          label: 'Polygon',
          address: '0xabcd...ef12',
          explorer: 'polygonscan.com',
        ),
        StakingTransparencyAddressDraft(
          label: 'BNB Chain',
          address: '0x9876...5432',
          explorer: 'bscscan.com',
        ),
      ],
      footerNote:
          'Custody arrangements are reviewed quarterly. Custodian is independently audited annually. Insurance coverage is updated to reflect total AUM. All disclosures are accurate as of March 2026.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, custody provider, segregation allocations, hot/cold wallet distribution, reconciliation audit trail, transparency addresses, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingSuitabilityAssessmentRepository
    implements StakingSuitabilityAssessmentRepository {
  const MockStakingSuitabilityAssessmentRepository();

  @override
  StakingSuitabilityAssessmentSnapshot getAssessment() {
    return const StakingSuitabilityAssessmentSnapshot(
      endpoint: '/api/mobile/earn/earn-suitability-assessment',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Suitability Assessment',
      resultTitle: 'Assessment Result',
      backRoute: '/earn/staking',
      stakingRoute: '/earn/staking',
      infoTitle: 'Why This Assessment?',
      infoBody:
          'Regulatory compliance requires us to assess your suitability for high-risk staking products. This helps protect you from unsuitable investments. Your answers are confidential.',
      questions: [
        StakingSuitabilityQuestionDraft(
          id: 'experience',
          question: 'How long have you invested in cryptocurrency?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(label: 'No experience', weight: 0),
            StakingSuitabilityOptionDraft(
              label: 'Less than 1 year',
              weight: 10,
            ),
            StakingSuitabilityOptionDraft(label: '1-3 years', weight: 20),
            StakingSuitabilityOptionDraft(label: '3-5 years', weight: 30),
            StakingSuitabilityOptionDraft(label: '5+ years', weight: 40),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'net-worth',
          question:
              'What is your total net worth (excluding primary residence)?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(
              label: 'Less than \$10,000',
              weight: 0,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$10,000-\$50,000',
              weight: 10,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$50,000-\$100,000',
              weight: 20,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$100,000-\$500,000',
              weight: 30,
            ),
            StakingSuitabilityOptionDraft(label: 'Over \$500,000', weight: 40),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'income',
          question: 'What is your annual income?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(
              label: 'Less than \$30,000',
              weight: 0,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$30,000-\$60,000',
              weight: 10,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$60,000-\$100,000',
              weight: 15,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$100,000-\$200,000',
              weight: 20,
            ),
            StakingSuitabilityOptionDraft(label: 'Over \$200,000', weight: 25),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'objectives',
          question: 'What is your primary investment objective?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(
              label: 'Capital Preservation',
              weight: 5,
            ),
            StakingSuitabilityOptionDraft(label: 'Stable Income', weight: 15),
            StakingSuitabilityOptionDraft(label: 'Growth', weight: 25),
            StakingSuitabilityOptionDraft(
              label: 'Aggressive Growth',
              weight: 35,
            ),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'horizon',
          question: 'What is your investment time horizon for staked assets?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(label: 'Less than 1 year', weight: 0),
            StakingSuitabilityOptionDraft(label: '1-3 years', weight: 10),
            StakingSuitabilityOptionDraft(label: '3-5 years', weight: 20),
            StakingSuitabilityOptionDraft(label: '5+ years', weight: 30),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'risk',
          question:
              'How would you rate your risk tolerance? (1 = Very Conservative, 10 = Very Aggressive)',
          type: StakingSuitabilityQuestionType.slider,
          min: 1,
          max: 10,
          weight: 3,
        ),
        StakingSuitabilityQuestionDraft(
          id: 'knowledge',
          question: 'Test your staking knowledge (5 questions)',
          type: StakingSuitabilityQuestionType.quiz,
          weight: 5,
          quizQuestions: [
            StakingSuitabilityQuizDraft(
              question: 'What is slashing in Proof of Stake?',
              options: [
                'A reward mechanism',
                'A penalty for validator misbehavior',
                'A way to unstake faster',
                'A fee structure',
              ],
              correctIndex: 1,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What does APY stand for?',
              options: [
                'Annual Payment Yield',
                'Annual Percentage Yield',
                'Average Profit Yearly',
                'Asset Price Yield',
              ],
              correctIndex: 1,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What is a lock-up period?',
              options: [
                'Time to earn rewards',
                'Time funds are locked and cannot be withdrawn',
                'Time to verify transactions',
                'Validator uptime',
              ],
              correctIndex: 1,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What is liquid staking?',
              options: [
                'Staking only stablecoins',
                'Staking with instant withdrawal',
                'Staking while maintaining liquidity via derivative tokens',
                'Staking in liquidity pools',
              ],
              correctIndex: 2,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What is the main risk of staking?',
              options: [
                'High fees',
                'Slashing and smart contract risk',
                'Slow transactions',
                'No rewards',
              ],
              correctIndex: 1,
            ),
          ],
        ),
      ],
      profiles: [
        StakingSuitabilityProfileDraft(
          level: StakingSuitabilityProfileLevel.conservative,
          minScore: 0,
          maxScore: 39,
          label: 'Conservative',
          description:
              'You prefer low-risk, stable returns. Suitable products: Flexible staking, stablecoins, short lock-up periods.',
          products: ['USDT Flexible', 'USDC Flexible', 'BTC Fixed 30D'],
          warning:
              'High-risk products are restricted until your suitability profile changes.',
        ),
        StakingSuitabilityProfileDraft(
          level: StakingSuitabilityProfileLevel.moderate,
          minScore: 40,
          maxScore: 69,
          label: 'Moderate',
          description:
              'You accept moderate risk for higher returns. Suitable products: ETH staking, 60-90 day fixed terms, auto-compound.',
          products: [
            'ETH Fixed 60D',
            'SOL Fixed 30D',
            'Auto-compound ETH',
            'BTC Fixed 90D',
          ],
          warning: null,
        ),
        StakingSuitabilityProfileDraft(
          level: StakingSuitabilityProfileLevel.aggressive,
          minScore: 70,
          maxScore: 100,
          label: 'Aggressive',
          description:
              'You seek maximum returns and accept high risk. Suitable products: DeFi staking, liquid staking, governance, long lock-ups.',
          products: [
            'Liquid Staking ETH',
            'DeFi Yield Farming',
            'Governance Staking',
            'Fixed 180D',
          ],
          warning: null,
        ),
      ],
      validUntil: 'March 7, 2027',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, questionnaire state, scoring result, suitability restrictions, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsComparisonRepository
    implements SavingsComparisonRepository {
  const MockSavingsComparisonRepository();

  @override
  SavingsComparisonSnapshot getComparison() {
    final savings = const MockSavingsRepository().getSavings();

    return SavingsComparisonSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-comparison',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'So sánh sản phẩm',
      backRoute: '/earn/savings',
      defaultProductIds: const ['sav001', 'sav002'],
      maxCompare: 3,
      products: savings.products,
      details: const {
        'sav001': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 62,
          participants: 45230,
          earlyWithdrawal: 'Bất kỳ lúc nào',
          interestPayout: 'Hàng ngày',
          compounding: 'Tự động',
          insurance: true,
          minAmount: '1.0000 USDT',
          minAmountValue: 1,
          maxDeposit: 'Không giới hạn',
          features: ['Auto-compound', 'Rút bất kỳ lúc nào', 'Bảo hiểm quỹ'],
        ),
        'sav002': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 90,
          participants: 12480,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '100.0000 USDT',
          minAmountValue: 100,
          maxDeposit: '\$50,000',
          features: ['APY cao', 'VIP bonus', 'Bảo hiểm quỹ'],
        ),
        'sav003': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.medium,
          capacityPercent: 93,
          participants: 6720,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '100.0000 USDT',
          minAmountValue: 100,
          maxDeposit: '\$100,000',
          features: ['APY cao nhất', 'Bảo hiểm quỹ', 'Priority support'],
        ),
        'sav004': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 48,
          participants: 18340,
          earlyWithdrawal: 'Bất kỳ lúc nào',
          interestPayout: 'Hàng ngày',
          compounding: 'Tự động',
          insurance: true,
          minAmount: '0.0001 BTC',
          minAmountValue: 0.0001,
          maxDeposit: 'Không giới hạn',
          features: ['Auto-compound', 'Rút bất kỳ lúc nào', 'BTC exposure'],
        ),
        'sav005': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 82,
          participants: 9120,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '0.001 BTC',
          minAmountValue: 0.001,
          maxDeposit: '5 BTC',
          features: ['VIP bonus', 'Bảo hiểm quỹ', 'BTC exposure'],
        ),
        'sav006': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 55,
          participants: 15670,
          earlyWithdrawal: 'Bất kỳ lúc nào',
          interestPayout: 'Hàng ngày',
          compounding: 'Tự động',
          insurance: true,
          minAmount: '0.01 ETH',
          minAmountValue: 0.01,
          maxDeposit: 'Không giới hạn',
          features: ['Auto-compound', 'ETH exposure', 'Rút tức thì'],
        ),
        'sav007': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.medium,
          capacityPercent: 35,
          participants: 4890,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '1 SOL',
          minAmountValue: 1,
          maxDeposit: '50K SOL',
          features: ['APY cao', 'SOL ecosystem', 'Quota thấp'],
        ),
      },
      disclaimer:
          'APY có thể thay đổi theo điều kiện thị trường. Dữ liệu so sánh mang tính tham khảo, không phải cam kết lợi nhuận. Vui lòng đọc kỹ điều khoản từng sản phẩm trước khi đăng ký.',
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

final class MockAutoCompoundSettingsRepository
    implements AutoCompoundSettingsRepository {
  const MockAutoCompoundSettingsRepository();

  @override
  AutoCompoundSettingsSnapshot getSettings() {
    return const AutoCompoundSettingsSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-auto-compound',
      actionDraft: 'PATCH /earn/savings/auto-compound-settings',
      title: 'Lãi kép tự động',
      backRoute: '/earn/savings',
      positions: [
        AutoCompoundPositionDraft(
          id: 'cp1',
          product: 'USDT Linh hoạt',
          asset: 'USDT',
          amount: 3500,
          earned: 14.58,
          apy: 4.5,
          type: SavingsProductType.flexible,
          autoCompound: true,
          compoundFrequency: 'daily',
          compoundThreshold: 0.1,
          lastCompounded: '09/03/2026 08:00',
          totalCompounded: 12.32,
          compoundCount: 45,
          estimatedBoost: 9,
        ),
        AutoCompoundPositionDraft(
          id: 'cp2',
          product: 'BTC Linh hoạt',
          asset: 'BTC',
          amount: 0.05,
          earned: 0.000042,
          apy: 1.8,
          type: SavingsProductType.flexible,
          autoCompound: false,
          compoundFrequency: 'weekly',
          compoundThreshold: 0.00001,
          lastCompounded: '—',
          totalCompounded: 0,
          compoundCount: 0,
          estimatedBoost: 3,
        ),
        AutoCompoundPositionDraft(
          id: 'cp3',
          product: 'ETH Linh hoạt',
          asset: 'ETH',
          amount: 1.5,
          earned: 0.0028,
          apy: 2.1,
          type: SavingsProductType.flexible,
          autoCompound: true,
          compoundFrequency: 'weekly',
          compoundThreshold: 0.001,
          lastCompounded: '07/03/2026 12:00',
          totalCompounded: 0.0019,
          compoundCount: 8,
          estimatedBoost: 5,
        ),
      ],
      frequencies: [
        AutoCompoundFrequencyDraft(
          id: 'daily',
          label: 'Hàng ngày',
          description: 'Compound mỗi 24h',
          boostLabel: 'Tốt nhất',
        ),
        AutoCompoundFrequencyDraft(
          id: 'weekly',
          label: 'Hàng tuần',
          description: 'Compound mỗi 7 ngày',
          boostLabel: 'Khá tốt',
        ),
        AutoCompoundFrequencyDraft(
          id: 'monthly',
          label: 'Hàng tháng',
          description: 'Compound mỗi 30 ngày',
          boostLabel: 'Cơ bản',
        ),
      ],
      infoItems: [
        AutoCompoundInfoDraft(
          title: 'APY thực tế cao hơn',
          description: 'Compound hàng ngày có thể tăng APY thêm 0.03-0.15%',
          tone: EarnRiskLevel.low,
        ),
        AutoCompoundInfoDraft(
          title: 'Hoàn toàn tự động',
          description: 'Hệ thống tự compound theo tần suất bạn chọn',
          tone: EarnRiskLevel.medium,
        ),
        AutoCompoundInfoDraft(
          title: 'Không phí phát sinh',
          description: 'Auto-compound miễn phí, không tính phí giao dịch',
          tone: EarnRiskLevel.low,
        ),
        AutoCompoundInfoDraft(
          title: 'Ngưỡng tùy chỉnh',
          description: 'Chỉ compound khi lãi đạt mức tối thiểu bạn đặt',
          tone: EarnRiskLevel.high,
        ),
      ],
      note:
          'Auto-compound chỉ khả dụng cho sản phẩm linh hoạt. Sản phẩm cố định trả lãi cuối kỳ và không hỗ trợ compound giữa kỳ. Phí compound: miễn phí.',
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

final class MockSavingsGoalsRepository implements SavingsGoalsRepository {
  const MockSavingsGoalsRepository();

  @override
  SavingsGoalsSnapshot getGoals() {
    return const SavingsGoalsSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-goals',
      actionDraft:
          'GET /earn/savings/goals | POST /earn/savings/goals | PATCH /earn/savings/goals/:goalId | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Mục tiêu tiết kiệm',
      subtitle: 'Đặt mục tiêu & theo dõi tiến độ',
      backRoute: '/earn/savings',
      goals: [
        SavingsGoalDraft(
          id: 'g1',
          name: 'Quỹ khẩn cấp',
          targetAmount: 5000,
          currentAmount: 3750,
          currency: 'USDT',
          iconKey: 'emergency',
          startDate: '2025-09-01',
          targetDate: '2026-09-01',
          autoContribute: true,
          monthlyContribution: 350,
          linkedProduct: 'USDT Linh hoạt',
          linkedProductApy: 4.5,
          status: SavingsGoalStatus.active,
          milestones: [
            SavingsGoalMilestoneDraft(
              id: 'm1',
              percentage: 25,
              label: '25% Khởi đầu',
              reward: 'Badge Người tiết kiệm',
              rewardType: 'badge',
              rewardValue: 'Saver Badge',
              unlocked: true,
              claimedAt: '2025-12-15',
            ),
            SavingsGoalMilestoneDraft(
              id: 'm2',
              percentage: 50,
              label: '50% Nửa chặng đường',
              reward: '+0.2% APY Boost 30 ngày',
              rewardType: 'apy_boost',
              rewardValue: '+0.2% APY',
              unlocked: true,
              claimedAt: '2026-01-20',
            ),
            SavingsGoalMilestoneDraft(
              id: 'm3',
              percentage: 75,
              label: '75% Sắp hoàn thành',
              reward: '500 điểm thưởng',
              rewardType: 'points',
              rewardValue: '500 Points',
              unlocked: true,
              claimedAt: '2026-02-28',
            ),
            SavingsGoalMilestoneDraft(
              id: 'm4',
              percentage: 100,
              label: '100% Hoàn thành!',
              reward: '+0.5% APY Boost 60 ngày',
              rewardType: 'gift',
              rewardValue: '+0.5% APY',
              unlocked: false,
            ),
          ],
          contributions: [
            SavingsGoalContributionDraft(
              date: '2026-03-01',
              amount: 350,
              source: 'Tự động',
            ),
            SavingsGoalContributionDraft(
              date: '2026-02-01',
              amount: 350,
              source: 'Tự động',
            ),
            SavingsGoalContributionDraft(
              date: '2026-01-15',
              amount: 200,
              source: 'Thủ công',
            ),
          ],
        ),
        SavingsGoalDraft(
          id: 'g2',
          name: 'Du lịch Nhật Bản',
          targetAmount: 3000,
          currentAmount: 1200,
          currency: 'USDT',
          iconKey: 'vacation',
          startDate: '2026-01-01',
          targetDate: '2026-07-01',
          autoContribute: true,
          monthlyContribution: 300,
          linkedProduct: 'USDT Linh hoạt',
          linkedProductApy: 4.5,
          status: SavingsGoalStatus.active,
          milestones: [
            SavingsGoalMilestoneDraft(
              id: 'm5',
              percentage: 25,
              label: '25% Khởi đầu',
              reward: 'Badge Explorer',
              rewardType: 'badge',
              rewardValue: 'Explorer Badge',
              unlocked: true,
              claimedAt: '2026-02-10',
            ),
            SavingsGoalMilestoneDraft(
              id: 'm6',
              percentage: 50,
              label: '50% Nửa chặng đường',
              reward: '+0.3% APY Boost 30 ngày',
              rewardType: 'apy_boost',
              rewardValue: '+0.3% APY',
              unlocked: false,
            ),
            SavingsGoalMilestoneDraft(
              id: 'm7',
              percentage: 75,
              label: '75% Sắp hoàn thành',
              reward: '800 điểm thưởng',
              rewardType: 'points',
              rewardValue: '800 Points',
              unlocked: false,
            ),
            SavingsGoalMilestoneDraft(
              id: 'm8',
              percentage: 100,
              label: '100% Hoàn thành!',
              reward: 'Voucher ưu đãi đổi tiền',
              rewardType: 'gift',
              rewardValue: 'Exchange Voucher',
              unlocked: false,
            ),
          ],
          contributions: [
            SavingsGoalContributionDraft(
              date: '2026-03-01',
              amount: 300,
              source: 'Tự động',
            ),
            SavingsGoalContributionDraft(
              date: '2026-02-01',
              amount: 300,
              source: 'Tự động',
            ),
            SavingsGoalContributionDraft(
              date: '2026-01-01',
              amount: 600,
              source: 'Thủ công',
            ),
          ],
        ),
        SavingsGoalDraft(
          id: 'g3',
          name: 'Quỹ đầu tư BTC',
          targetAmount: 10000,
          currentAmount: 10000,
          currency: 'USDT',
          iconKey: 'custom',
          startDate: '2025-03-01',
          targetDate: '2026-03-01',
          autoContribute: false,
          monthlyContribution: 0,
          linkedProduct: 'BTC Cố định 60D',
          linkedProductApy: 3.5,
          status: SavingsGoalStatus.completed,
          milestones: [
            SavingsGoalMilestoneDraft(
              id: 'm9',
              percentage: 25,
              label: '25%',
              reward: 'Badge',
              rewardType: 'badge',
              rewardValue: 'BTC Saver',
              unlocked: true,
              claimedAt: '2025-06-01',
            ),
            SavingsGoalMilestoneDraft(
              id: 'm10',
              percentage: 50,
              label: '50%',
              reward: '+0.2% APY',
              rewardType: 'apy_boost',
              rewardValue: '+0.2%',
              unlocked: true,
              claimedAt: '2025-08-15',
            ),
            SavingsGoalMilestoneDraft(
              id: 'm11',
              percentage: 75,
              label: '75%',
              reward: '1000 Points',
              rewardType: 'points',
              rewardValue: '1000',
              unlocked: true,
              claimedAt: '2025-11-01',
            ),
            SavingsGoalMilestoneDraft(
              id: 'm12',
              percentage: 100,
              label: '100%',
              reward: '+0.5% APY 90 ngày',
              rewardType: 'gift',
              rewardValue: '+0.5%',
              unlocked: true,
              claimedAt: '2026-03-01',
            ),
          ],
          contributions: [],
        ),
      ],
      templates: [
        SavingsGoalTemplateDraft(
          id: 't1',
          name: 'Quỹ khẩn cấp',
          iconKey: 'emergency',
          suggestedTarget: 5000,
          suggestedMonths: 12,
          description: '3-6 tháng chi phí sinh hoạt',
        ),
        SavingsGoalTemplateDraft(
          id: 't2',
          name: 'Mua nhà',
          iconKey: 'house',
          suggestedTarget: 50000,
          suggestedMonths: 60,
          description: 'Tích lũy tiền đặt cọc',
        ),
        SavingsGoalTemplateDraft(
          id: 't3',
          name: 'Du lịch',
          iconKey: 'vacation',
          suggestedTarget: 3000,
          suggestedMonths: 6,
          description: 'Chuyến đi trong mơ',
        ),
        SavingsGoalTemplateDraft(
          id: 't4',
          name: 'Giáo dục',
          iconKey: 'education',
          suggestedTarget: 20000,
          suggestedMonths: 36,
          description: 'Đầu tư cho tương lai',
        ),
        SavingsGoalTemplateDraft(
          id: 't5',
          name: 'Mua xe',
          iconKey: 'car',
          suggestedTarget: 15000,
          suggestedMonths: 24,
          description: 'Phương tiện di chuyển',
        ),
        SavingsGoalTemplateDraft(
          id: 't6',
          name: 'Mục tiêu tùy chỉnh',
          iconKey: 'custom',
          suggestedTarget: 1000,
          suggestedMonths: 12,
          description: 'Tự đặt mục tiêu riêng',
        ),
      ],
      tips: [
        SavingsGoalTipDraft(
          title: 'Tự động đóng góp đều đặn',
          description:
              'Đặt auto-contribute hàng tháng giúp bạn đạt mục tiêu nhanh hơn 2.5x so với đóng góp thủ công.',
          iconKey: 'sparkles',
          tone: EarnRiskLevel.medium,
        ),
        SavingsGoalTipDraft(
          title: 'Milestone rewards tích lũy',
          description:
              'Mỗi milestone đạt được sẽ mở khóa phần thưởng APY boost, badge hoặc điểm thưởng.',
          iconKey: 'trophy',
          tone: EarnRiskLevel.high,
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

final class MockSavingsAnalyticsRepository
    implements SavingsAnalyticsRepository {
  const MockSavingsAnalyticsRepository();

  @override
  SavingsAnalyticsSnapshot getAnalytics() {
    return const SavingsAnalyticsSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-analytics',
      actionDraft:
          'GET /earn/savings/analytics | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Phân tích Tiết kiệm',
      subtitle: 'Yield, compound & phân bổ',
      backRoute: '/earn/savings',
      tabs: ['Yield', 'Compound', 'APY', 'Phân bổ'],
      timeRanges: ['30D', '90D', '6M', 'All'],
      defaultTab: 'Yield',
      defaultTimeRange: '6M',
      summary: SavingsAnalyticsSummaryDraft(
        totalInvested: 10340.86,
        totalEarned: 174.36,
        weightedApy: 4.63,
        dailyEarnings: 1.31,
        monthlyEarnings: 39.35,
        annualProjection: 478.75,
        yieldChange: 1.69,
      ),
      yieldHistory: [
        SavingsYieldPointDraft(
          date: '01/10',
          usdt: 0,
          btc: 0,
          sol: 0,
          eth: 0,
          total: 0,
        ),
        SavingsYieldPointDraft(
          date: '01/11',
          usdt: 12.50,
          btc: 0,
          sol: 0,
          eth: 0,
          total: 12.50,
        ),
        SavingsYieldPointDraft(
          date: '01/12',
          usdt: 26.30,
          btc: 3.20,
          sol: 0,
          eth: 0,
          total: 29.50,
        ),
        SavingsYieldPointDraft(
          date: '01/01',
          usdt: 41.80,
          btc: 7.90,
          sol: 8.50,
          eth: 2.10,
          total: 60.30,
        ),
        SavingsYieldPointDraft(
          date: '01/02',
          usdt: 58.20,
          btc: 13.40,
          sol: 22.30,
          eth: 5.80,
          total: 99.70,
        ),
        SavingsYieldPointDraft(
          date: '15/02',
          usdt: 66.90,
          btc: 16.80,
          sol: 35.60,
          eth: 8.20,
          total: 127.50,
        ),
        SavingsYieldPointDraft(
          date: '01/03',
          usdt: 76.40,
          btc: 20.50,
          sol: 51.20,
          eth: 11.60,
          total: 159.70,
        ),
        SavingsYieldPointDraft(
          date: '09/03',
          usdt: 80.12,
          btc: 22.38,
          sol: 58.50,
          eth: 13.36,
          total: 174.36,
        ),
      ],
      monthlyEarnings: [
        SavingsMonthlyEarningsPointDraft(
          month: 'T10',
          earned: 12.50,
          deposited: 3500,
          withdrawn: 0,
        ),
        SavingsMonthlyEarningsPointDraft(
          month: 'T11',
          earned: 17.00,
          deposited: 1350,
          withdrawn: 0,
        ),
        SavingsMonthlyEarningsPointDraft(
          month: 'T12',
          earned: 30.80,
          deposited: 3250,
          withdrawn: 500,
        ),
        SavingsMonthlyEarningsPointDraft(
          month: 'T01',
          earned: 39.40,
          deposited: 2240,
          withdrawn: 0,
        ),
        SavingsMonthlyEarningsPointDraft(
          month: 'T02',
          earned: 52.80,
          deposited: 0,
          withdrawn: 1000,
        ),
        SavingsMonthlyEarningsPointDraft(
          month: 'T03',
          earned: 22.36,
          deposited: 500,
          withdrawn: 0,
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, and realtime-refresh state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsAutoRebalanceRepository
    implements SavingsAutoRebalanceRepository {
  const MockSavingsAutoRebalanceRepository();

  @override
  SavingsAutoRebalanceSnapshot getRebalance() {
    return const SavingsAutoRebalanceSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-rebalance',
      actionDraft:
          'GET /earn/savings/rebalance | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Tái cân bằng',
      subtitle: 'Auto-rebalance portfolio',
      backRoute: '/earn/savings',
      tabs: ['Tổng quan', 'Chiến lược', 'Lịch sử', 'Cài đặt'],
      defaultTab: 'Tổng quan',
      defaultStrategyId: 'balanced',
      totalPortfolio: 10340.86,
      positions: [
        SavingsRebalancePositionDraft(
          id: 'ms1',
          asset: 'USDT',
          product: 'USDT Linh hoạt',
          currentValue: 3500,
          currentPct: 33.85,
          targetPct: 30,
          apy: 4.5,
          colorName: 'usdt',
          locked: false,
          rebalanceable: true,
        ),
        SavingsRebalancePositionDraft(
          id: 'ms2',
          asset: 'BTC',
          product: 'BTC Cố định 60D',
          currentValue: 1350.86,
          currentPct: 13.06,
          targetPct: 25,
          apy: 3.5,
          colorName: 'btc',
          locked: true,
          rebalanceable: false,
          lockDays: 60,
          daysRemaining: 7,
        ),
        SavingsRebalancePositionDraft(
          id: 'ms3',
          asset: 'SOL',
          product: 'SOL Cố định 30D',
          currentValue: 3250,
          currentPct: 31.43,
          targetPct: 25,
          apy: 6.5,
          colorName: 'sol',
          locked: true,
          rebalanceable: false,
          lockDays: 30,
          daysRemaining: 13,
        ),
        SavingsRebalancePositionDraft(
          id: 'ms4',
          asset: 'ETH',
          product: 'ETH Linh hoạt',
          currentValue: 2240,
          currentPct: 21.66,
          targetPct: 20,
          apy: 2.8,
          colorName: 'eth',
          locked: false,
          rebalanceable: true,
        ),
      ],
      strategies: [
        SavingsRebalanceStrategyDraft(
          id: 'conservative',
          name: 'An toàn',
          description: 'Ưu tiên stablecoin, giảm biến động',
          riskLevel: SavingsRebalanceRiskLevel.low,
          expectedApy: 3.95,
          allocations: {'USDT': 50, 'BTC': 15, 'SOL': 10, 'ETH': 25},
        ),
        SavingsRebalanceStrategyDraft(
          id: 'balanced',
          name: 'Cân bằng',
          description: 'Phân bổ đều, cân đối rủi ro và lợi nhuận',
          riskLevel: SavingsRebalanceRiskLevel.medium,
          expectedApy: 4.48,
          allocations: {'USDT': 30, 'BTC': 25, 'SOL': 25, 'ETH': 20},
        ),
        SavingsRebalanceStrategyDraft(
          id: 'growth',
          name: 'Tăng trưởng',
          description: 'Ưu tiên APY cao, chấp nhận biến động',
          riskLevel: SavingsRebalanceRiskLevel.high,
          expectedApy: 5.22,
          allocations: {'USDT': 15, 'BTC': 20, 'SOL': 40, 'ETH': 25},
        ),
      ],
      driftHistory: [
        SavingsRebalanceDriftPointDraft(date: '01/01', drift: 6.4),
        SavingsRebalanceDriftPointDraft(date: '15/01', drift: 7.1),
        SavingsRebalanceDriftPointDraft(date: '20/01', drift: 0.2),
        SavingsRebalanceDriftPointDraft(date: '01/02', drift: 5.1),
        SavingsRebalanceDriftPointDraft(date: '05/02', drift: 4.2),
        SavingsRebalanceDriftPointDraft(date: '15/02', drift: 5.8),
        SavingsRebalanceDriftPointDraft(date: '20/02', drift: 0.3),
        SavingsRebalanceDriftPointDraft(date: '01/03', drift: 4.5),
        SavingsRebalanceDriftPointDraft(date: '05/03', drift: 0.5),
        SavingsRebalanceDriftPointDraft(date: '09/03', drift: 5.94),
      ],
      history: [
        SavingsRebalanceHistoryDraft(
          id: 'rb1',
          date: '05/03/2026',
          strategy: 'Cân bằng',
          actions: 3,
          totalMoved: 820.50,
          status: SavingsRebalanceHistoryStatus.completed,
          driftBefore: 8.2,
          driftAfter: 0.5,
        ),
        SavingsRebalanceHistoryDraft(
          id: 'rb2',
          date: '20/02/2026',
          strategy: 'Cân bằng',
          actions: 2,
          totalMoved: 450,
          status: SavingsRebalanceHistoryStatus.completed,
          driftBefore: 5.8,
          driftAfter: 0.3,
        ),
        SavingsRebalanceHistoryDraft(
          id: 'rb3',
          date: '05/02/2026',
          strategy: 'An toàn',
          actions: 4,
          totalMoved: 1200,
          status: SavingsRebalanceHistoryStatus.partial,
          driftBefore: 12.5,
          driftAfter: 4.2,
        ),
        SavingsRebalanceHistoryDraft(
          id: 'rb4',
          date: '20/01/2026',
          strategy: 'Cân bằng',
          actions: 3,
          totalMoved: 680,
          status: SavingsRebalanceHistoryStatus.completed,
          driftBefore: 7.1,
          driftAfter: 0.2,
        ),
        SavingsRebalanceHistoryDraft(
          id: 'rb5',
          date: '05/01/2026',
          strategy: 'Tăng trưởng',
          actions: 2,
          totalMoved: 350,
          status: SavingsRebalanceHistoryStatus.failed,
          driftBefore: 6.4,
          driftAfter: 6.4,
        ),
      ],
      settings: SavingsRebalanceSettingsDraft(
        autoEnabled: true,
        frequencyLabel: 'Hằng tuần',
        driftThreshold: 5,
        skipLocked: true,
        minTradeSize: 50,
      ),
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

final class MockSavingsNotificationPreferencesRepository
    implements SavingsNotificationPreferencesRepository {
  const MockSavingsNotificationPreferencesRepository();

  @override
  SavingsNotificationPreferencesSnapshot getPreferences() {
    return const SavingsNotificationPreferencesSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-notification-preferences',
      actionDraft:
          'GET /earn/savings/notification-preferences | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Cài đặt thông báo',
      backRoute: '/earn/savings',
      tabs: [
        SavingsPreferenceTabDraft(id: 'events', label: 'Sự kiện'),
        SavingsPreferenceTabDraft(id: 'products', label: 'Sản phẩm'),
        SavingsPreferenceTabDraft(id: 'delivery', label: 'Kênh & Lịch'),
      ],
      defaultTab: 'events',
      masterEnabled: true,
      alerts: [
        SavingsNotificationAlertDraft(
          id: 'apy-change',
          title: 'Thay đổi APY',
          description: 'Thông báo khi APY sản phẩm thay đổi trên 0.5%',
          iconKey: 'trending',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.product,
          severity: SavingsNotificationPreferenceSeverity.important,
        ),
        SavingsNotificationAlertDraft(
          id: 'maturity-reminder',
          title: 'Sắp đáo hạn',
          description:
              'Thông báo 7 ngày, 3 ngày và 24h trước khi sản phẩm Cố định đáo hạn',
          iconKey: 'calendar',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.product,
          severity: SavingsNotificationPreferenceSeverity.critical,
        ),
        SavingsNotificationAlertDraft(
          id: 'capacity-warning',
          title: 'Sắp hết hạn mức',
          description: 'Thông báo khi sản phẩm còn dưới 10% hạn mức đăng ký',
          iconKey: 'warning',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.product,
          severity: SavingsNotificationPreferenceSeverity.important,
        ),
        SavingsNotificationAlertDraft(
          id: 'new-product',
          title: 'Sản phẩm mới',
          description: 'Thông báo khi có sản phẩm tiết kiệm mới ra mắt',
          iconKey: 'package',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.product,
          severity: SavingsNotificationPreferenceSeverity.info,
        ),
        SavingsNotificationAlertDraft(
          id: 'apy-opportunity',
          title: 'Cơ hội APY cao',
          description:
              'Thông báo khi có sản phẩm APY vượt trên 5% phù hợp hồ sơ rủi ro của bạn',
          iconKey: 'zap',
          enabled: false,
          category: SavingsNotificationPreferenceCategory.product,
          severity: SavingsNotificationPreferenceSeverity.info,
        ),
        SavingsNotificationAlertDraft(
          id: 'subscribe-confirm',
          title: 'Xác nhận đăng ký',
          description:
              'Thông báo khi lệnh đăng ký tiết kiệm được xử lý thành công',
          iconKey: 'download',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.transaction,
          severity: SavingsNotificationPreferenceSeverity.critical,
        ),
        SavingsNotificationAlertDraft(
          id: 'redeem-confirm',
          title: 'Xác nhận rút',
          description:
              'Thông báo khi lệnh rút tiết kiệm được xử lý và tiền về ví',
          iconKey: 'upload',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.transaction,
          severity: SavingsNotificationPreferenceSeverity.critical,
        ),
        SavingsNotificationAlertDraft(
          id: 'interest-paid',
          title: 'Nhận lãi hằng ngày',
          description: 'Thông báo khi lãi tiết kiệm được phân phối mỗi ngày',
          iconKey: 'piggy',
          enabled: false,
          category: SavingsNotificationPreferenceCategory.transaction,
          severity: SavingsNotificationPreferenceSeverity.info,
        ),
        SavingsNotificationAlertDraft(
          id: 'auto-compound',
          title: 'Lãi kép tự động',
          description:
              'Thông báo khi lãi kép tự động được thực hiện thành công',
          iconKey: 'refresh',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.transaction,
          severity: SavingsNotificationPreferenceSeverity.info,
        ),
        SavingsNotificationAlertDraft(
          id: 'goal-milestone',
          title: 'Đạt milestone mục tiêu',
          description:
              'Thông báo khi bạn đạt milestone tiết kiệm (25%, 50%, 75%, 100%)',
          iconKey: 'target',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.transaction,
          severity: SavingsNotificationPreferenceSeverity.important,
        ),
        SavingsNotificationAlertDraft(
          id: 'maintenance',
          title: 'Bảo trì hệ thống',
          description:
              'Thông báo trước khi hệ thống bảo trì ảnh hưởng đến tiết kiệm',
          iconKey: 'settings',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.system,
          severity: SavingsNotificationPreferenceSeverity.critical,
        ),
        SavingsNotificationAlertDraft(
          id: 'security-alert',
          title: 'Cảnh báo bảo mật',
          description: 'Thông báo bất thường liên quan đến tài khoản tiết kiệm',
          iconKey: 'shield',
          enabled: true,
          category: SavingsNotificationPreferenceCategory.system,
          severity: SavingsNotificationPreferenceSeverity.critical,
        ),
        SavingsNotificationAlertDraft(
          id: 'promotion',
          title: 'Khuyến mãi & Ưu đãi',
          description:
              'Thông báo về chương trình khuyến mãi, APY boost, và ưu đãi đặc biệt',
          iconKey: 'campaign',
          enabled: false,
          category: SavingsNotificationPreferenceCategory.system,
          severity: SavingsNotificationPreferenceSeverity.info,
        ),
      ],
      productAlerts: [
        SavingsProductNotificationDraft(
          id: 'ms1',
          productName: 'USDT Linh hoạt',
          asset: 'USDT',
          typeLabel: 'Linh hoạt',
          enabledCount: 2,
          totalCount: 3,
          alertLabels: ['Thay đổi APY', 'Cảnh báo hạn mức', 'Nhận lãi'],
        ),
        SavingsProductNotificationDraft(
          id: 'ms2',
          productName: 'BTC Cố định 60D',
          asset: 'BTC',
          typeLabel: 'Cố định',
          enabledCount: 4,
          totalCount: 5,
          alertLabels: [
            'Thay đổi APY',
            'Nhắc đáo hạn',
            'Nhận lãi',
            'Tự động gia hạn',
            'Cảnh báo hạn mức',
          ],
        ),
        SavingsProductNotificationDraft(
          id: 'ms3',
          productName: 'SOL Cố định 30D',
          asset: 'SOL',
          typeLabel: 'Cố định',
          enabledCount: 2,
          totalCount: 5,
          alertLabels: [
            'Thay đổi APY',
            'Nhắc đáo hạn',
            'Nhận lãi',
            'Tự động gia hạn',
            'Cảnh báo hạn mức',
          ],
        ),
      ],
      channels: [
        SavingsDeliveryChannelDraft(
          id: 'push',
          label: 'Push Notification',
          detail: 'iPhone 15 Pro · 2 thiết bị',
          iconKey: 'bell',
          enabled: true,
        ),
        SavingsDeliveryChannelDraft(
          id: 'email',
          label: 'Email',
          detail: 'n****@gmail.com',
          iconKey: 'mail',
          enabled: true,
        ),
        SavingsDeliveryChannelDraft(
          id: 'sms',
          label: 'SMS',
          detail: '+84 *** *** 890',
          iconKey: 'phone',
          enabled: false,
        ),
        SavingsDeliveryChannelDraft(
          id: 'in-app',
          label: 'Trong ứng dụng',
          detail: 'Luôn bật',
          iconKey: 'message',
          enabled: true,
          locked: true,
        ),
      ],
      digestFrequency: SavingsDeliveryFrequency.instant,
      quietHours: SavingsQuietHoursDraft(
        enabled: false,
        startHour: 22,
        endHour: 7,
        allowCritical: true,
      ),
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

final class MockSavingsDcaRepository implements SavingsDcaRepository {
  const MockSavingsDcaRepository();

  @override
  SavingsDcaSnapshot getDca() {
    return const SavingsDcaSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-dca',
      actionDraft:
          'GET /earn/savings/dca | POST /earn/subscribe|redeem|claim|vote where applicable; POST /dca/plans|rebalance|schedule',
      title: 'DCA Tiết kiệm',
      backRoute: '/earn/savings',
      tabs: [
        SavingsPreferenceTabDraft(id: 'plans', label: 'Kế hoạch (3)'),
        SavingsPreferenceTabDraft(id: 'history', label: 'Lịch sử'),
      ],
      defaultTab: 'plans',
      heroLabel: 'Dollar Cost Averaging',
      totalInvestedUsd: '\$1,420.00',
      totalCurrentUsd: '\$1,446.34',
      gainUsd: '+\$26.34',
      gainLabel: 'Lãi DCA',
      activePlanCount: 2,
      strategyLabel: 'An toàn',
      infoText:
          'DCA giúp bạn gửi tiết kiệm đều đặn theo lịch, giảm rủi ro timing và xây dựng thói quen tích lũy hiệu quả.',
      plans: [
        SavingsDcaPlanDraft(
          id: 'dca-usdt',
          productName: 'USDT Linh hoạt',
          asset: 'USDT',
          assetLabel: 'USD',
          amountPerPeriodLabel: '100.0000 USDT',
          frequencyLabel: 'hàng tuần',
          status: SavingsDcaPlanStatus.active,
          statusLabel: 'Đang chạy',
          totalInvestedLabel: '1,000.00 USDT',
          currentValueLabel: '1,018.50 USDT',
          gainLabel: '+1.85%',
          gainPositive: true,
          nextExecution: '16/03/2026',
          currentApyLabel: '4.5%',
        ),
        SavingsDcaPlanDraft(
          id: 'dca-eth',
          productName: 'ETH Linh hoạt',
          asset: 'ETH',
          assetLabel: 'ETH',
          amountPerPeriodLabel: '0.050000 ETH',
          frequencyLabel: 'hàng tháng',
          status: SavingsDcaPlanStatus.active,
          statusLabel: 'Đang chạy',
          totalInvestedLabel: '0.150000 ETH',
          currentValueLabel: '0.152800 ETH',
          gainLabel: '+1.87%',
          gainPositive: true,
          nextExecution: '15/03/2026',
          currentApyLabel: '3.8%',
        ),
        SavingsDcaPlanDraft(
          id: 'dca-sol',
          productName: 'SOL Linh hoạt',
          asset: 'SOL',
          assetLabel: 'SOL',
          amountPerPeriodLabel: '5.0000 SOL',
          frequencyLabel: 'mỗi 2 tuần',
          status: SavingsDcaPlanStatus.paused,
          statusLabel: 'Tạm dừng',
          totalInvestedLabel: '40.0000 SOL',
          currentValueLabel: '41.2000 SOL',
          gainLabel: '+3.00%',
          gainPositive: true,
          nextExecution: '—',
          currentApyLabel: '6.5%',
        ),
      ],
      executions: [
        SavingsDcaExecutionDraft(
          id: 'exec-usdt-1',
          planName: 'USDT Linh hoạt',
          date: '09/03/2026',
          amountLabel: '100.0000 USDT',
          asset: 'USDT',
          status: SavingsDcaExecutionStatus.success,
          apyLabel: '4.5%',
        ),
        SavingsDcaExecutionDraft(
          id: 'exec-eth-1',
          planName: 'ETH Linh hoạt',
          date: '15/02/2026',
          amountLabel: '0.050000 ETH',
          asset: 'ETH',
          status: SavingsDcaExecutionStatus.success,
          apyLabel: '3.8%',
        ),
        SavingsDcaExecutionDraft(
          id: 'exec-usdt-2',
          planName: 'USDT Linh hoạt',
          date: '02/03/2026',
          amountLabel: '100.0000 USDT',
          asset: 'USDT',
          status: SavingsDcaExecutionStatus.success,
          apyLabel: '4.5%',
        ),
        SavingsDcaExecutionDraft(
          id: 'exec-sol-1',
          planName: 'SOL Linh hoạt',
          date: '01/02/2026',
          amountLabel: '5.0000 SOL',
          asset: 'SOL',
          status: SavingsDcaExecutionStatus.success,
          apyLabel: '6.5%',
        ),
        SavingsDcaExecutionDraft(
          id: 'exec-usdt-failed',
          planName: 'USDT Linh hoạt',
          date: '09/02/2026',
          amountLabel: '100.0000 USDT',
          asset: 'USDT',
          status: SavingsDcaExecutionStatus.failed,
          apyLabel: '4.2%',
        ),
      ],
      products: [
        SavingsDcaProductDraft(
          id: 'sav001',
          name: 'USDT Linh hoạt',
          asset: 'USDT',
          apyLabel: '4.5%',
          balanceLabel: '12,500 USDT',
        ),
        SavingsDcaProductDraft(
          id: 'sav004',
          name: 'ETH Linh hoạt',
          asset: 'ETH',
          apyLabel: '3.8%',
          balanceLabel: '3.2 ETH',
        ),
        SavingsDcaProductDraft(
          id: 'sav003',
          name: 'SOL Linh hoạt',
          asset: 'SOL',
          apyLabel: '6.5%',
          balanceLabel: '120 SOL',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, DCA plans, schedule draft, and rebalance action state.',
      supportedStates: {
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

final class MockSavingsSmartSuggestionsRepository
    implements SavingsSmartSuggestionsRepository {
  const MockSavingsSmartSuggestionsRepository();

  @override
  SavingsSmartSuggestionsSnapshot getSuggestions() {
    return const SavingsSmartSuggestionsSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-smart-suggestions',
      actionDraft:
          'GET /earn/savings/smart-suggestions | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Gợi ý thông minh',
      backRoute: '/earn/savings',
      tabs: [
        SavingsPreferenceTabDraft(id: 'suggestions', label: 'Gợi ý (5)'),
        SavingsPreferenceTabDraft(id: 'trends', label: 'Xu hướng APY'),
        SavingsPreferenceTabDraft(id: 'signals', label: 'Tín hiệu'),
      ],
      defaultTab: 'suggestions',
      filters: [
        SavingsPreferenceTabDraft(id: 'all', label: 'Tất cả'),
        SavingsPreferenceTabDraft(id: 'high', label: 'Ưu tiên'),
        SavingsPreferenceTabDraft(id: 'medium', label: 'Trung bình'),
        SavingsPreferenceTabDraft(id: 'low', label: 'Tham khảo'),
      ],
      heroLabel: 'Smart Suggestions',
      pendingCount: 5,
      potentialApyGainLabel: '+8.2%',
      highPriorityCount: 3,
      upTrendCount: 2,
      signalCount: 3,
      suggestions: [
        SavingsSuggestionDraft(
          id: 'sg1',
          type: SavingsSuggestionType.dcaTiming,
          typeLabel: 'DCA Timing',
          priority: SavingsSuggestionPriority.high,
          priorityLabel: 'Ưu tiên cao',
          status: SavingsSuggestionStatus.newItem,
          title: 'Thời điểm DCA USDT tốt',
          description:
              'APY USDT Linh hoạt vừa tăng từ 4.2% lên 4.8%, cao nhất 30 ngày. Nên tăng mức DCA để tận dụng lãi suất cao.',
          reasoning:
              'APY tăng 14% so với trung bình 30 ngày. Xu hướng tăng kéo dài 5 ngày liên tiếp. Thanh khoản thị trường ổn định.',
          impact: '+0.6% APY so với trung bình',
          impactPositive: true,
          actionLabel: 'Tăng DCA',
          actionRoute: '/earn/savings/dca',
          confidence: 85,
          createdAt: '09/03/2026 14:30',
          expiresAt: '12/03/2026',
          tags: ['DCA', 'USDT', 'APY cao'],
        ),
        SavingsSuggestionDraft(
          id: 'sg2',
          type: SavingsSuggestionType.productSwitch,
          typeLabel: 'Chuyển SP',
          priority: SavingsSuggestionPriority.high,
          priorityLabel: 'Ưu tiên cao',
          status: SavingsSuggestionStatus.newItem,
          title: 'Chuyển SOL sang ETH Linh hoạt',
          description:
              'SOL Cố định 30D sắp đáo hạn. ETH Linh hoạt đang có APY 4.2% - cao hơn SOL Linh hoạt.',
          reasoning:
              'SOL Cố định đáo hạn còn 13 ngày. ETH Linh hoạt APY vượt SOL Linh hoạt 0.4%. Rủi ro tương đương và thanh khoản ETH tốt hơn.',
          impact: '+0.4% APY khi chuyển',
          impactPositive: true,
          actionLabel: 'Xem chi tiết',
          actionRoute: '/earn/savings/comparison',
          confidence: 72,
          createdAt: '09/03/2026 10:15',
          tags: ['Chuyển SP', 'SOL', 'ETH'],
        ),
        SavingsSuggestionDraft(
          id: 'sg6',
          type: SavingsSuggestionType.riskAlert,
          typeLabel: 'Cảnh báo',
          priority: SavingsSuggestionPriority.high,
          priorityLabel: 'Ưu tiên cao',
          status: SavingsSuggestionStatus.newItem,
          title: 'APY SOL giảm 15% trong 7 ngày',
          description:
              'APY SOL Cố định giảm từ 7.5% xuống 6.5%. Xu hướng giảm có thể tiếp tục.',
          reasoning:
              'APY giảm 3 tuần liên tiếp. On-chain staking yield giảm theo. Dự báo APY có thể về 5.8% trong 2 tuần tới.',
          impact: '-1.0% APY dự báo',
          impactPositive: false,
          actionLabel: 'Xem xu hướng',
          confidence: 70,
          createdAt: '09/03/2026 08:00',
          tags: ['Cảnh báo', 'SOL', 'APY giảm'],
        ),
        SavingsSuggestionDraft(
          id: 'sg3',
          type: SavingsSuggestionType.compoundBoost,
          typeLabel: 'Tối ưu',
          priority: SavingsSuggestionPriority.medium,
          priorityLabel: 'Trung bình',
          status: SavingsSuggestionStatus.newItem,
          title: 'Bật lãi kép cho USDT',
          description:
              'USDT Linh hoạt chưa bật lãi kép tự động. Bật lãi kép có thể tăng thu nhập thêm khoảng \$12/năm.',
          reasoning:
              'Số dư \$3,500 x 4.5% APY. Lãi kép hằng ngày tăng hiệu quả thêm khoảng 0.34% APY thực tế.',
          impact: '+~\$12/năm',
          impactPositive: true,
          actionLabel: 'Bật lãi kép',
          actionRoute: '/earn/savings/auto-compound',
          confidence: 95,
          createdAt: '08/03/2026 09:00',
          tags: ['Lãi kép', 'USDT', 'Tối ưu'],
        ),
        SavingsSuggestionDraft(
          id: 'sg4',
          type: SavingsSuggestionType.rebalance,
          typeLabel: 'Tái cân bằng',
          priority: SavingsSuggestionPriority.medium,
          priorityLabel: 'Trung bình',
          status: SavingsSuggestionStatus.viewed,
          title: 'Danh mục lệch 8% khỏi mục tiêu',
          description:
              'Tỷ trọng USDT cao hơn mục tiêu. Nên xem xét tái cân bằng để giảm rủi ro tập trung.',
          reasoning:
              'Drift USDT +8% so với target. Drift BTC -5%. Tái cân bằng giúp đa dạng hóa danh mục.',
          impact: 'Giảm rủi ro tập trung',
          impactPositive: true,
          actionLabel: 'Tái cân bằng',
          actionRoute: '/earn/savings/rebalance',
          confidence: 78,
          createdAt: '07/03/2026 16:00',
          tags: ['Tái cân bằng', 'Đa dạng hóa'],
        ),
        SavingsSuggestionDraft(
          id: 'sg5',
          type: SavingsSuggestionType.newOpportunity,
          typeLabel: 'Cơ hội mới',
          priority: SavingsSuggestionPriority.low,
          priorityLabel: 'Tham khảo',
          status: SavingsSuggestionStatus.newItem,
          title: 'Sản phẩm mới: AVAX Cố định 90D',
          description:
              'AVAX Cố định 90D vừa ra mắt với APY 7.2% - cao nhất trong nhóm rủi ro trung bình.',
          reasoning:
              'APY 7.2% cao hơn trung bình nhóm locked 90D. AVAX on-chain staking backing. Hạn mức còn 85%.',
          impact: 'APY 7.2% - cao nhất nhóm',
          impactPositive: true,
          actionLabel: 'Xem sản phẩm',
          confidence: 65,
          createdAt: '06/03/2026 11:30',
          tags: ['Mới', 'AVAX', 'Locked'],
        ),
      ],
      trends: [
        SavingsApyTrendDraft(
          product: 'USDT Linh hoạt',
          asset: 'USDT',
          currentApyLabel: '4.8%',
          averageApyLabel: '4.35%',
          predictionLabel: '5.0%',
          direction: SavingsApyTrendDirection.up,
          points: [
            SavingsApyTrendPointDraft(date: '01/02', apy: 4.0),
            SavingsApyTrendPointDraft(date: '08/02', apy: 4.1),
            SavingsApyTrendPointDraft(date: '15/02', apy: 4.0),
            SavingsApyTrendPointDraft(date: '22/02', apy: 4.2),
            SavingsApyTrendPointDraft(date: '01/03', apy: 4.5),
            SavingsApyTrendPointDraft(date: '05/03', apy: 4.6),
            SavingsApyTrendPointDraft(date: '09/03', apy: 4.8),
          ],
        ),
        SavingsApyTrendDraft(
          product: 'SOL Cố định 30D',
          asset: 'SOL',
          currentApyLabel: '6.5%',
          averageApyLabel: '7.1%',
          predictionLabel: '5.8%',
          direction: SavingsApyTrendDirection.down,
          points: [
            SavingsApyTrendPointDraft(date: '01/02', apy: 7.5),
            SavingsApyTrendPointDraft(date: '08/02', apy: 7.8),
            SavingsApyTrendPointDraft(date: '15/02', apy: 7.5),
            SavingsApyTrendPointDraft(date: '22/02', apy: 7.2),
            SavingsApyTrendPointDraft(date: '01/03', apy: 7.0),
            SavingsApyTrendPointDraft(date: '05/03', apy: 6.8),
            SavingsApyTrendPointDraft(date: '09/03', apy: 6.5),
          ],
        ),
        SavingsApyTrendDraft(
          product: 'ETH Linh hoạt',
          asset: 'ETH',
          currentApyLabel: '4.2%',
          averageApyLabel: '3.9%',
          predictionLabel: '4.5%',
          direction: SavingsApyTrendDirection.up,
          points: [
            SavingsApyTrendPointDraft(date: '01/02', apy: 3.5),
            SavingsApyTrendPointDraft(date: '08/02', apy: 3.6),
            SavingsApyTrendPointDraft(date: '15/02', apy: 3.8),
            SavingsApyTrendPointDraft(date: '22/02', apy: 3.9),
            SavingsApyTrendPointDraft(date: '01/03', apy: 4.0),
            SavingsApyTrendPointDraft(date: '05/03', apy: 4.1),
            SavingsApyTrendPointDraft(date: '09/03', apy: 4.2),
          ],
        ),
      ],
      signals: [
        SavingsMarketSignalDraft(
          id: 'ms1',
          title: 'Fed giữ lãi suất ổn định - stablecoin yield tăng nhẹ',
          type: SavingsMarketSignalType.bullish,
          impact: 'APY stablecoin có thể tăng 0.3-0.5% trong 2 tuần tới',
          affectedProducts: ['USDT Linh hoạt', 'USDT Cố định'],
          timestamp: '09/03/2026 06:00',
        ),
        SavingsMarketSignalDraft(
          id: 'ms2',
          title: 'Ethereum upgrade hoàn thành - staking yield ổn định',
          type: SavingsMarketSignalType.neutral,
          impact: 'ETH staking yield dự kiến duy trì ở mức 3.8-4.2%',
          affectedProducts: ['ETH Linh hoạt'],
          timestamp: '08/03/2026 14:00',
        ),
        SavingsMarketSignalDraft(
          id: 'ms3',
          title: 'Solana network congestion - validator rewards giảm',
          type: SavingsMarketSignalType.bearish,
          impact: 'SOL staking yield có thể giảm thêm 0.5-1.0% trong tháng 3',
          affectedProducts: ['SOL Cố định 30D', 'SOL Cố định 90D'],
          timestamp: '07/03/2026 20:00',
        ),
      ],
      disclaimer: 'Gợi ý dựa trên phân tích xu hướng APY',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, suggestion actions, APY trends, and market signals.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsExportRepository implements SavingsExportRepository {
  const MockSavingsExportRepository();

  @override
  SavingsExportSnapshot getExport() {
    return const SavingsExportSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-export',
      actionDraft:
          'GET /earn/savings/export | POST /exports | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Xuất báo cáo',
      backRoute: '/earn/savings',
      tabs: [
        SavingsPreferenceTabDraft(id: 'create', label: 'Tạo báo cáo'),
        SavingsPreferenceTabDraft(id: 'history', label: 'Lịch sử (4)'),
      ],
      defaultTab: 'create',
      heroLabel: 'Export & Báo cáo',
      createdReports: 4,
      reportTypeCountLabel: '4 loại',
      formatSummary: 'CSV · PDF · Excel',
      retentionLabel: '7 ngày',
      reportTypes: [
        SavingsExportReportDraft(
          id: SavingsExportReportType.transaction,
          title: 'Lịch sử giao dịch',
          description:
              'Xuất tất cả giao dịch tiết kiệm: gửi, rút, nhận lãi, lãi kép',
          iconKey: 'download',
          rowsLabel: '~47 dòng · 8 cột',
        ),
        SavingsExportReportDraft(
          id: SavingsExportReportType.tax,
          title: 'Báo cáo thuế',
          description:
              'Tóm tắt thu nhập lãi tiết kiệm theo năm, phù hợp nộp thuế cá nhân',
          iconKey: 'shield',
          rowsLabel: '~12 dòng · 6 cột',
        ),
        SavingsExportReportDraft(
          id: SavingsExportReportType.portfolio,
          title: 'Ảnh chụp danh mục',
          description:
              'Trạng thái hiện tại của tất cả vị thế tiết kiệm đang hoạt động',
          iconKey: 'portfolio',
          rowsLabel: '~8 dòng · 8 cột',
        ),
        SavingsExportReportDraft(
          id: SavingsExportReportType.performance,
          title: 'Hiệu suất đầu tư',
          description:
              'Phân tích hiệu suất: lãi hằng ngày, APY trung bình, tăng trưởng',
          iconKey: 'trend',
          rowsLabel: '~30 dòng · 6 cột',
        ),
      ],
      formats: [
        SavingsExportFormatDraft(
          id: SavingsExportFormat.csv,
          label: 'CSV',
          description: 'Tương thích Excel, Google Sheets',
        ),
        SavingsExportFormatDraft(
          id: SavingsExportFormat.pdf,
          label: 'PDF',
          description: 'Báo cáo định dạng in ấn',
        ),
        SavingsExportFormatDraft(
          id: SavingsExportFormat.xlsx,
          label: 'Excel',
          description: 'Microsoft Excel với định dạng',
        ),
      ],
      periods: [
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.sevenDays,
          label: '7 ngày',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.thirtyDays,
          label: '30 ngày',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.ninetyDays,
          label: '90 ngày',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.sixMonths,
          label: '6 tháng',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.oneYear,
          label: '1 năm',
        ),
        SavingsExportPeriodDraft(id: SavingsExportPeriod.all, label: 'Tất cả'),
      ],
      scopes: [
        SavingsExportScopeDraft(
          id: SavingsExportScope.all,
          label: 'Tất cả',
          iconKey: 'filter',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.subscribe,
          label: 'Gửi tiết kiệm',
          iconKey: 'download',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.redeem,
          label: 'Rút tiết kiệm',
          iconKey: 'upload',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.interest,
          label: 'Nhận lãi',
          iconKey: 'trend',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.compound,
          label: 'Lãi kép',
          iconKey: 'bolt',
        ),
      ],
      options: [
        SavingsExportOptionDraft(
          id: 'interest',
          title: 'Bao gồm lãi tích lũy',
          subtitle: 'Thêm cột lãi hằng ngày/tháng',
          iconKey: 'trend',
        ),
        SavingsExportOptionDraft(
          id: 'fees',
          title: 'Bao gồm phí',
          subtitle: 'Thêm cột phí giao dịch (nếu có)',
          iconKey: 'info',
        ),
        SavingsExportOptionDraft(
          id: 'apy-history',
          title: 'Lịch sử APY',
          subtitle: 'Thêm dữ liệu APY theo ngày',
          iconKey: 'chart',
        ),
        SavingsExportOptionDraft(
          id: 'product-details',
          title: 'Chi tiết sản phẩm',
          subtitle: 'Thêm loại, thời hạn, rủi ro',
          iconKey: 'settings',
        ),
        SavingsExportOptionDraft(
          id: 'email-copy',
          title: 'Gửi bản sao qua email',
          subtitle: 'Gửi file tới email đã đăng ký',
          iconKey: 'mail',
        ),
      ],
      defaultReportType: SavingsExportReportType.transaction,
      defaultFormat: SavingsExportFormat.csv,
      defaultPeriod: SavingsExportPeriod.thirtyDays,
      defaultScope: SavingsExportScope.all,
      defaultEnabledOptions: {'interest', 'fees', 'product-details'},
      summaryRows: '~47',
      summaryFileSize: '14.1 KB',
      sensitiveNotice:
          'Báo cáo có thể chứa thông tin tài chính nhạy cảm. Không chia sẻ file với người khác. File tự động xóa sau 7 ngày.',
      ctaLabel: 'Xem trước & Xuất CSV',
      history: [
        SavingsExportHistoryDraft(
          id: 'rep-q1',
          fileName: 'savings_transactions_2026Q1.csv',
          format: SavingsExportFormat.csv,
          reportType: SavingsExportReportType.transaction,
          period: '01/01/2026 - 31/03/2026',
          rowsLabel: '47 dòng',
          fileSize: '14.1 KB',
          status: SavingsExportStatus.completed,
          createdAt: '09/03/2026 12:20',
          expiresAt: '16/03/2026',
        ),
        SavingsExportHistoryDraft(
          id: 'rep-tax',
          fileName: 'savings_tax_report_2025.pdf',
          format: SavingsExportFormat.pdf,
          reportType: SavingsExportReportType.tax,
          period: 'Năm 2025',
          rowsLabel: '12 dòng',
          fileSize: '226 KB',
          status: SavingsExportStatus.completed,
          createdAt: '02/03/2026 09:45',
          expiresAt: '09/03/2026',
        ),
        SavingsExportHistoryDraft(
          id: 'rep-portfolio',
          fileName: 'savings_portfolio_snapshot.xlsx',
          format: SavingsExportFormat.xlsx,
          reportType: SavingsExportReportType.portfolio,
          period: 'Ảnh chụp 28/02/2026',
          rowsLabel: '8 dòng',
          fileSize: '38 KB',
          status: SavingsExportStatus.completed,
          createdAt: '28/02/2026 17:30',
          expiresAt: '06/03/2026',
        ),
        SavingsExportHistoryDraft(
          id: 'rep-performance',
          fileName: 'savings_performance_30d.csv',
          format: SavingsExportFormat.csv,
          reportType: SavingsExportReportType.performance,
          period: '30 ngày',
          rowsLabel: '30 dòng',
          fileSize: '18.4 KB',
          status: SavingsExportStatus.ready,
          createdAt: '20/02/2026 08:10',
          expiresAt: '27/02/2026',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, export configuration, preview rows, history, and POST /exports action state.',
      supportedStates: {
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

final class MockSavingsBacktestRepository implements SavingsBacktestRepository {
  const MockSavingsBacktestRepository();

  @override
  SavingsBacktestSnapshot getBacktest() {
    return const SavingsBacktestSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-backtest',
      actionDraft:
          'GET /earn/savings/backtest | POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/savings/backtest/run',
      title: 'Mô phỏng đầu tư',
      backRoute: '/earn/savings',
      recommendationsRoute: '/earn/savings/recommendations',
      tabs: [
        SavingsPreferenceTabDraft(id: 'setup', label: 'Thiết lập'),
        SavingsPreferenceTabDraft(id: 'results', label: 'Kết quả'),
        SavingsPreferenceTabDraft(id: 'compare', label: 'So sánh'),
      ],
      defaultTab: 'setup',
      heroLabel: 'Backtest Simulator',
      defaultAmountUsd: 10000,
      quickAmounts: [1000, 5000, 10000, 25000, 50000],
      defaultPeriod: SavingsBacktestPeriod.oneYear,
      periods: [
        SavingsBacktestPeriodDraft(
          id: SavingsBacktestPeriod.threeMonths,
          label: '3 tháng',
          months: 3,
        ),
        SavingsBacktestPeriodDraft(
          id: SavingsBacktestPeriod.sixMonths,
          label: '6 tháng',
          months: 6,
        ),
        SavingsBacktestPeriodDraft(
          id: SavingsBacktestPeriod.oneYear,
          label: '1 năm',
          months: 12,
        ),
        SavingsBacktestPeriodDraft(
          id: SavingsBacktestPeriod.twoYears,
          label: '2 năm',
          months: 24,
        ),
      ],
      defaultPreset: SavingsBacktestPreset.balanced,
      presets: [
        SavingsBacktestPresetDraft(
          id: SavingsBacktestPreset.conservative,
          label: 'An toàn',
          description: 'Ưu tiên stablecoin và linh hoạt, rủi ro thấp',
          iconKey: 'shield',
          riskLabel: 'Thấp',
          slots: [
            SavingsBacktestSlotDraft(
              id: 'c1',
              product: 'USDT Linh hoạt',
              asset: 'USDT',
              typeLabel: 'Linh hoạt',
              percentage: 50,
              avgApy: 4.3,
              colorKey: 'buy',
            ),
            SavingsBacktestSlotDraft(
              id: 'c2',
              product: 'USDT Cố định 30D',
              asset: 'USDT',
              typeLabel: 'Cố định',
              percentage: 30,
              avgApy: 5.2,
              colorKey: 'primary',
              lockDays: 30,
            ),
            SavingsBacktestSlotDraft(
              id: 'c3',
              product: 'BTC Cố định 60D',
              asset: 'BTC',
              typeLabel: 'Cố định',
              percentage: 10,
              avgApy: 3.5,
              colorKey: 'warn',
              lockDays: 60,
            ),
            SavingsBacktestSlotDraft(
              id: 'c4',
              product: 'ETH Linh hoạt',
              asset: 'ETH',
              typeLabel: 'Linh hoạt',
              percentage: 10,
              avgApy: 3.9,
              colorKey: 'accent',
            ),
          ],
        ),
        SavingsBacktestPresetDraft(
          id: SavingsBacktestPreset.balanced,
          label: 'Cân bằng',
          description: 'Pha trộn linh hoạt và cố định, rủi ro trung bình',
          iconKey: 'target',
          riskLabel: 'Trung bình',
          slots: [
            SavingsBacktestSlotDraft(
              id: 'b1',
              product: 'USDT Linh hoạt',
              asset: 'USDT',
              typeLabel: 'Linh hoạt',
              percentage: 30,
              avgApy: 4.3,
              colorKey: 'buy',
            ),
            SavingsBacktestSlotDraft(
              id: 'b2',
              product: 'BTC Cố định 60D',
              asset: 'BTC',
              typeLabel: 'Cố định',
              percentage: 20,
              avgApy: 3.5,
              colorKey: 'warn',
              lockDays: 60,
            ),
            SavingsBacktestSlotDraft(
              id: 'b3',
              product: 'ETH Linh hoạt',
              asset: 'ETH',
              typeLabel: 'Linh hoạt',
              percentage: 20,
              avgApy: 3.9,
              colorKey: 'accent',
            ),
            SavingsBacktestSlotDraft(
              id: 'b4',
              product: 'SOL Cố định 30D',
              asset: 'SOL',
              typeLabel: 'Cố định',
              percentage: 20,
              avgApy: 6.8,
              colorKey: 'primary',
              lockDays: 30,
            ),
            SavingsBacktestSlotDraft(
              id: 'b5',
              product: 'AVAX Cố định 90D',
              asset: 'AVAX',
              typeLabel: 'Cố định',
              percentage: 10,
              avgApy: 7.2,
              colorKey: 'sell',
              lockDays: 90,
            ),
          ],
        ),
        SavingsBacktestPresetDraft(
          id: SavingsBacktestPreset.aggressive,
          label: 'Tăng trưởng',
          description: 'Ưu tiên cố định dài hạn, APY cao, rủi ro cao hơn',
          iconKey: 'bolt',
          riskLabel: 'Cao',
          slots: [
            SavingsBacktestSlotDraft(
              id: 'a1',
              product: 'SOL Cố định 90D',
              asset: 'SOL',
              typeLabel: 'Cố định',
              percentage: 30,
              avgApy: 7.5,
              colorKey: 'primary',
              lockDays: 90,
            ),
            SavingsBacktestSlotDraft(
              id: 'a2',
              product: 'AVAX Cố định 90D',
              asset: 'AVAX',
              typeLabel: 'Cố định',
              percentage: 25,
              avgApy: 7.2,
              colorKey: 'sell',
              lockDays: 90,
            ),
            SavingsBacktestSlotDraft(
              id: 'a3',
              product: 'ETH Cố định 60D',
              asset: 'ETH',
              typeLabel: 'Cố định',
              percentage: 20,
              avgApy: 5.1,
              colorKey: 'accent',
              lockDays: 60,
            ),
            SavingsBacktestSlotDraft(
              id: 'a4',
              product: 'BTC Cố định 60D',
              asset: 'BTC',
              typeLabel: 'Cố định',
              percentage: 15,
              avgApy: 3.5,
              colorKey: 'warn',
              lockDays: 60,
            ),
            SavingsBacktestSlotDraft(
              id: 'a5',
              product: 'USDT Linh hoạt',
              asset: 'USDT',
              typeLabel: 'Linh hoạt',
              percentage: 10,
              avgApy: 4.3,
              colorKey: 'buy',
            ),
          ],
        ),
        SavingsBacktestPresetDraft(
          id: SavingsBacktestPreset.custom,
          label: 'Tùy chỉnh',
          description: 'Tự tạo phân bổ theo ý bạn',
          iconKey: 'sliders',
          riskLabel: 'Tùy chỉnh',
          slots: [
            SavingsBacktestSlotDraft(
              id: 'u1',
              product: 'USDT Linh hoạt',
              asset: 'USDT',
              typeLabel: 'Linh hoạt',
              percentage: 40,
              avgApy: 4.3,
              colorKey: 'buy',
            ),
            SavingsBacktestSlotDraft(
              id: 'u2',
              product: 'BTC Cố định 60D',
              asset: 'BTC',
              typeLabel: 'Cố định',
              percentage: 30,
              avgApy: 3.5,
              colorKey: 'warn',
              lockDays: 60,
            ),
            SavingsBacktestSlotDraft(
              id: 'u3',
              product: 'SOL Cố định 30D',
              asset: 'SOL',
              typeLabel: 'Cố định',
              percentage: 30,
              avgApy: 6.8,
              colorKey: 'primary',
              lockDays: 30,
            ),
          ],
        ),
      ],
      disclaimer:
          'Kết quả mô phỏng dựa trên dữ liệu APY lịch sử và giả định ổn định. Hiệu suất quá khứ không đảm bảo kết quả tương lai. Đây không phải lời khuyên đầu tư.',
      result: SavingsBacktestResultDraft(
        totalReturnUsd: 485,
        totalReturnPct: 4.85,
        annualizedReturnPct: 4.85,
        maxDrawdownPct: 0.12,
        sharpeRatio: 3.42,
        finalValueUsd: 10485,
        bestMonthUsd: 45.7,
        worstMonthUsd: 36.9,
        monthsPositive: 12,
        monthsNegative: 0,
        points: [
          SavingsBacktestPointDraft(
            month: '01/2025',
            valueUsd: 10040,
            interestUsd: 40,
          ),
          SavingsBacktestPointDraft(
            month: '02/2025',
            valueUsd: 10078,
            interestUsd: 38,
          ),
          SavingsBacktestPointDraft(
            month: '03/2025',
            valueUsd: 10120,
            interestUsd: 42,
          ),
          SavingsBacktestPointDraft(
            month: '04/2025',
            valueUsd: 10158,
            interestUsd: 38,
          ),
          SavingsBacktestPointDraft(
            month: '05/2025',
            valueUsd: 10201,
            interestUsd: 43,
          ),
          SavingsBacktestPointDraft(
            month: '06/2025',
            valueUsd: 10239,
            interestUsd: 38,
          ),
          SavingsBacktestPointDraft(
            month: '07/2025',
            valueUsd: 10284,
            interestUsd: 45,
          ),
          SavingsBacktestPointDraft(
            month: '08/2025',
            valueUsd: 10323,
            interestUsd: 39,
          ),
          SavingsBacktestPointDraft(
            month: '09/2025',
            valueUsd: 10365,
            interestUsd: 42,
          ),
          SavingsBacktestPointDraft(
            month: '10/2025',
            valueUsd: 10402,
            interestUsd: 37,
          ),
          SavingsBacktestPointDraft(
            month: '11/2025',
            valueUsd: 10446,
            interestUsd: 44,
          ),
          SavingsBacktestPointDraft(
            month: '12/2025',
            valueUsd: 10485,
            interestUsd: 39,
          ),
        ],
      ),
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, allocation presets, historical APY simulation, compare results, and recommendation handoff.',
      supportedStates: {
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

final class MockSavingsAutoPilotRepository
    implements SavingsAutoPilotRepository {
  const MockSavingsAutoPilotRepository();

  @override
  SavingsAutoPilotSnapshot getAutoPilot() {
    return const SavingsAutoPilotSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-autopilot',
      actionDraft:
          'GET /earn/savings/autopilot | POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/savings/autopilot/activate|pause|approve-action',
      title: 'AutoPilot',
      backRoute: '/earn/savings',
      tabs: [
        SavingsPreferenceTabDraft(id: 'overview', label: 'Tổng quan'),
        SavingsPreferenceTabDraft(id: 'actions', label: 'Hoạt động (1)'),
        SavingsPreferenceTabDraft(id: 'settings', label: 'Cài đặt'),
      ],
      defaultTab: 'overview',
      heroLabel: 'AutoPilot Savings',
      config: SavingsAutoPilotConfigDraft(
        mode: SavingsAutoPilotMode.balanced,
        status: SavingsAutoPilotStatus.active,
        monthlyBudgetUsd: 1000,
        dcaEnabled: true,
        dcaFrequencyLabel: 'Hằng tuần',
        rebalanceEnabled: true,
        rebalanceThresholdPct: 10,
        smartSwitchEnabled: true,
        switchMinApyGainPct: .8,
        compoundEnabled: true,
        riskGuardEnabled: true,
        maxSingleAssetPct: 40,
        notificationsEnabled: true,
        approvalRequired: true,
      ),
      modes: [
        SavingsAutoPilotModeDraft(
          id: SavingsAutoPilotMode.conservative,
          label: 'An toàn',
          description:
              'Stablecoin-first, DCA chậm, rebalance ít, chỉ switch khi APY chênh nhiều',
          iconKey: 'shield',
          tone: EarnRiskLevel.low,
          dcaFrequency: 'Hằng tháng',
          rebalanceThreshold: '15%',
          switchMinGain: '1.5%+',
          maxConcentration: '50%',
        ),
        SavingsAutoPilotModeDraft(
          id: SavingsAutoPilotMode.balanced,
          label: 'Cân bằng',
          description:
              'Đa dạng hóa, DCA trung bình, rebalance tự động, switch linh hoạt',
          iconKey: 'target',
          tone: EarnRiskLevel.medium,
          dcaFrequency: 'Hằng tuần',
          rebalanceThreshold: '10%',
          switchMinGain: '0.8%+',
          maxConcentration: '40%',
        ),
        SavingsAutoPilotModeDraft(
          id: SavingsAutoPilotMode.growth,
          label: 'Tăng trưởng',
          description:
              'Ưu tiên APY cao, DCA nhanh, rebalance thường xuyên, switch nhanh',
          iconKey: 'bolt',
          tone: EarnRiskLevel.high,
          dcaFrequency: 'Hằng ngày',
          rebalanceThreshold: '5%',
          switchMinGain: '0.3%+',
          maxConcentration: '35%',
        ),
      ],
      metrics: [
        SavingsAutoPilotMetricDraft(
          id: 'effective_apy',
          label: 'APY hiệu quả',
          value: '5.2%',
          deltaLabel: '+0.8%',
          iconKey: 'trend',
          tone: EarnRiskLevel.low,
        ),
        SavingsAutoPilotMetricDraft(
          id: 'dca',
          label: 'Tổng DCA',
          value: '\$250.00',
          deltaLabel: '1 lần',
          iconKey: 'repeat',
          tone: EarnRiskLevel.medium,
        ),
        SavingsAutoPilotMetricDraft(
          id: 'rebalance',
          label: 'Rebalance',
          value: '3 lần',
          deltaLabel: '30 ngày',
          iconKey: 'rebalance',
          tone: EarnRiskLevel.medium,
        ),
        SavingsAutoPilotMetricDraft(
          id: 'apy_saved',
          label: 'Tối ưu APY',
          value: '+10.1%',
          deltaLabel: '5 hành động',
          iconKey: 'spark',
          tone: EarnRiskLevel.high,
        ),
      ],
      modules: [
        SavingsAutoPilotModuleDraft(
          id: 'dca',
          label: 'DCA tự động',
          description: 'Hằng tuần · \$1,000.00/tháng',
          enabled: true,
          iconKey: 'repeat',
          tone: EarnRiskLevel.low,
          route: '/earn/savings/dca',
        ),
        SavingsAutoPilotModuleDraft(
          id: 'rebalance',
          label: 'Tái cân bằng',
          description: 'Ngưỡng: 10% drift',
          enabled: true,
          iconKey: 'rebalance',
          tone: EarnRiskLevel.medium,
          route: '/earn/savings/rebalance',
        ),
        SavingsAutoPilotModuleDraft(
          id: 'smart_switch',
          label: 'Smart Switch',
          description: 'Min APY gain: 0.8%',
          enabled: true,
          iconKey: 'spark',
          tone: EarnRiskLevel.high,
          route: '/earn/savings/smart-suggestions',
        ),
        SavingsAutoPilotModuleDraft(
          id: 'compound',
          label: 'Lãi kép tự động',
          description: 'Tự động tái đầu tư lãi',
          enabled: true,
          iconKey: 'bolt',
          tone: EarnRiskLevel.low,
          route: '/earn/savings/auto-compound',
        ),
        SavingsAutoPilotModuleDraft(
          id: 'risk_guard',
          label: 'Risk Guard',
          description: 'Max single-asset: 40%',
          enabled: true,
          iconKey: 'shield',
          tone: EarnRiskLevel.high,
          route: '/earn/savings/risk-assessment',
        ),
      ],
      actions: [
        SavingsAutoPilotActionDraft(
          id: 'act1',
          type: SavingsAutoPilotActionType.dcaExecuted,
          title: 'DCA USDT Linh hoạt',
          description:
              'Tự động gửi 250 USDT vào sản phẩm Linh hoạt theo lịch DCA hằng tuần.',
          timestamp: '09/03/2026 08:00',
          impact: '+250 USDT',
          impactValue: 250,
          status: SavingsAutoPilotActionStatus.executed,
          details: {
            'Sản phẩm': 'USDT Linh hoạt',
            'Số lượng': '250 USDT',
            'APY': '4.8%',
            'Nguồn': 'Ví Spot',
          },
        ),
        SavingsAutoPilotActionDraft(
          id: 'act2',
          type: SavingsAutoPilotActionType.rebalanced,
          title: 'Tái cân bằng danh mục',
          description:
              'Tỷ trọng USDT vượt 45% (target 40%). Chuyển 5% sang ETH Linh hoạt.',
          timestamp: '08/03/2026 14:00',
          impact: 'USDT -5% → ETH +5%',
          impactValue: 0,
          status: SavingsAutoPilotActionStatus.executed,
          details: {
            'Từ': 'USDT Linh hoạt (45%→40%)',
            'Đến': 'ETH Linh hoạt (15%→20%)',
            'Số tiền': '~\$500',
          },
        ),
        SavingsAutoPilotActionDraft(
          id: 'act3',
          type: SavingsAutoPilotActionType.apyOptimized,
          title: 'Tối ưu APY BTC',
          description:
              'APY BTC Cố định 60D tăng từ 3.2% lên 3.8%. Tăng mức DCA BTC.',
          timestamp: '07/03/2026 10:30',
          impact: '+0.6% APY',
          impactValue: .6,
          status: SavingsAutoPilotActionStatus.executed,
          details: {
            'Sản phẩm': 'BTC Cố định 60D',
            'APY cũ': '3.2%',
            'APY mới': '3.8%',
            'Hành động': 'Tăng DCA 10%',
          },
        ),
        SavingsAutoPilotActionDraft(
          id: 'act4',
          type: SavingsAutoPilotActionType.switchProduct,
          title: 'Chuyển SOL sang AVAX',
          description:
              'SOL Cố định 30D APY giảm 1.2%. AVAX Cố định 90D có APY cao hơn 1.5%. Đề xuất chuyển.',
          timestamp: '06/03/2026 16:00',
          impact: '+1.5% APY',
          impactValue: 1.5,
          status: SavingsAutoPilotActionStatus.needsApproval,
          details: {
            'Từ': 'SOL Cố định 30D (5.3%)',
            'Đến': 'AVAX Cố định 90D (6.8%)',
            'Chênh': '+1.5% APY',
            'Lưu ý': 'Lock 90 ngày',
          },
        ),
        SavingsAutoPilotActionDraft(
          id: 'act5',
          type: SavingsAutoPilotActionType.compoundActivated,
          title: 'Bật lãi kép ETH',
          description:
              'ETH Linh hoạt đủ điều kiện lãi kép tự động. Dự kiến tăng +\$8/năm.',
          timestamp: '05/03/2026 09:00',
          impact: '+~\$8/năm',
          impactValue: 8,
          status: SavingsAutoPilotActionStatus.executed,
          details: {
            'Sản phẩm': 'ETH Linh hoạt',
            'APY hiệu quả': '4.05% → 4.22%',
            'Dự kiến thêm': '+\$8/năm',
          },
        ),
        SavingsAutoPilotActionDraft(
          id: 'act6',
          type: SavingsAutoPilotActionType.riskAdjusted,
          title: 'Điều chỉnh rủi ro',
          description:
              'AVAX chiếm 32% danh mục, vượt ngưỡng 30%. Giảm 2% sang USDT.',
          timestamp: '04/03/2026 12:00',
          impact: 'Giảm rủi ro tập trung',
          impactValue: 0,
          status: SavingsAutoPilotActionStatus.executed,
          details: {
            'Tài sản': 'AVAX (32%→30%)',
            'Chuyển': '2% sang USDT Linh hoạt',
            'Lý do': 'Vượt ngưỡng single-asset',
          },
        ),
      ],
      disclaimer:
          'AutoPilot tự động thực hiện giao dịch với tài sản của bạn. Kết quả phụ thuộc vào điều kiện thị trường và thay đổi APY. Đây không phải lời khuyên tài chính. Bạn có thể tắt bất kỳ lúc nào.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, autopilot config, module status, approval queue, and action history.',
      supportedStates: {
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

final class MockSavingsLadderRepository implements SavingsLadderRepository {
  const MockSavingsLadderRepository();

  @override
  SavingsLadderSnapshot getLadder() {
    return const SavingsLadderSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-ladder',
      actionDraft:
          'GET /earn/savings/ladder | POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/savings/ladder/create|add-rung|toggle-renew',
      title: 'Maturity Ladder',
      backRoute: '/earn/savings',
      heroLabel: 'Staggered Maturity Builder',
      tabs: [
        SavingsPreferenceTabDraft(id: 'builder', label: 'Xây dựng'),
        SavingsPreferenceTabDraft(id: 'timeline', label: 'Timeline'),
        SavingsPreferenceTabDraft(id: 'analysis', label: 'Phân tích'),
      ],
      defaultTab: 'builder',
      defaultAmountUsd: 10000,
      quickAmounts: [5000, 10000, 25000, 50000],
      defaultPreset: SavingsLadderPreset.monthly,
      templates: [
        SavingsLadderTemplateDraft(
          id: SavingsLadderPreset.monthly,
          label: 'Thang hóa hằng tháng',
          description:
              'Mỗi tháng có 1 rung đáo hạn, đảm bảo thanh khoản liên tục.',
          iconKey: 'calendar',
          tone: EarnRiskLevel.low,
          intervals: [
            SavingsLadderIntervalDraft(
              lockDays: 30,
              allocationPct: 33,
              product: 'USDT Cố định 30D',
              asset: 'USDT',
              apyPct: 5.2,
              colorKey: 'buy',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 60,
              allocationPct: 33,
              product: 'USDT Cố định 60D',
              asset: 'USDT',
              apyPct: 5.8,
              colorKey: 'primary',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 90,
              allocationPct: 34,
              product: 'USDT Cố định 90D',
              asset: 'USDT',
              apyPct: 6.5,
              colorKey: 'buy',
            ),
          ],
        ),
        SavingsLadderTemplateDraft(
          id: SavingsLadderPreset.quarterly,
          label: 'Đáo hạn theo quý',
          description: 'Tối ưu APY với chu kỳ 3 tháng, phù hợp vốn trung hạn.',
          iconKey: 'bars',
          tone: EarnRiskLevel.medium,
          intervals: [
            SavingsLadderIntervalDraft(
              lockDays: 90,
              allocationPct: 25,
              product: 'USDT Cố định 90D',
              asset: 'USDT',
              apyPct: 6.5,
              colorKey: 'buy',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 90,
              allocationPct: 25,
              product: 'BTC Cố định 90D',
              asset: 'BTC',
              apyPct: 4.0,
              colorKey: 'warn',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 90,
              allocationPct: 25,
              product: 'SOL Cố định 90D',
              asset: 'SOL',
              apyPct: 7.5,
              colorKey: 'accent',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 90,
              allocationPct: 25,
              product: 'AVAX Cố định 90D',
              asset: 'AVAX',
              apyPct: 7.2,
              colorKey: 'sell',
            ),
          ],
        ),
        SavingsLadderTemplateDraft(
          id: SavingsLadderPreset.biannual,
          label: 'Ladder 6 tháng',
          description: 'Chia đều vốn thành 6 bậc, mỗi tháng 1 bậc đáo hạn.',
          iconKey: 'layers',
          tone: EarnRiskLevel.high,
          intervals: [
            SavingsLadderIntervalDraft(
              lockDays: 30,
              allocationPct: 17,
              product: 'USDT Cố định 30D',
              asset: 'USDT',
              apyPct: 5.2,
              colorKey: 'buy',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 60,
              allocationPct: 17,
              product: 'USDT Cố định 60D',
              asset: 'USDT',
              apyPct: 5.8,
              colorKey: 'primary',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 90,
              allocationPct: 17,
              product: 'USDT Cố định 90D',
              asset: 'USDT',
              apyPct: 6.5,
              colorKey: 'buy',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 30,
              allocationPct: 16,
              product: 'BTC Cố định 30D',
              asset: 'BTC',
              apyPct: 2.8,
              colorKey: 'warn',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 60,
              allocationPct: 16,
              product: 'ETH Cố định 60D',
              asset: 'ETH',
              apyPct: 3.9,
              colorKey: 'accent',
            ),
            SavingsLadderIntervalDraft(
              lockDays: 90,
              allocationPct: 17,
              product: 'SOL Cố định 90D',
              asset: 'SOL',
              apyPct: 7.5,
              colorKey: 'primary',
            ),
          ],
        ),
        SavingsLadderTemplateDraft(
          id: SavingsLadderPreset.custom,
          label: 'Tùy chỉnh',
          description: 'Tự tạo ladder theo ý muốn của bạn.',
          iconKey: 'sliders',
          tone: EarnRiskLevel.medium,
          intervals: [],
        ),
      ],
      availableProducts: [
        SavingsLadderProductDraft(
          id: 'lp1',
          product: 'USDT Cố định 30D',
          asset: 'USDT',
          colorKey: 'buy',
          lockDays: 30,
          apyPct: 5.2,
        ),
        SavingsLadderProductDraft(
          id: 'lp2',
          product: 'USDT Cố định 60D',
          asset: 'USDT',
          colorKey: 'primary',
          lockDays: 60,
          apyPct: 5.8,
        ),
        SavingsLadderProductDraft(
          id: 'lp3',
          product: 'USDT Cố định 90D',
          asset: 'USDT',
          colorKey: 'buy',
          lockDays: 90,
          apyPct: 6.5,
        ),
        SavingsLadderProductDraft(
          id: 'lp4',
          product: 'BTC Cố định 30D',
          asset: 'BTC',
          colorKey: 'warn',
          lockDays: 30,
          apyPct: 2.8,
        ),
        SavingsLadderProductDraft(
          id: 'lp5',
          product: 'ETH Cố định 60D',
          asset: 'ETH',
          colorKey: 'accent',
          lockDays: 60,
          apyPct: 3.9,
        ),
        SavingsLadderProductDraft(
          id: 'lp6',
          product: 'SOL Cố định 90D',
          asset: 'SOL',
          colorKey: 'primary',
          lockDays: 90,
          apyPct: 7.5,
        ),
      ],
      disclaimer:
          'Ladder chia vốn thành nhiều kỳ hạn để tạo dòng tiền định kỳ. APY và khả năng rút trước hạn phụ thuộc điều kiện sản phẩm tại thời điểm xác nhận.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, ladder templates, rung schedule, maturity calendar, auto-renew state, and confirm preview.',
      supportedStates: {
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

final class MockSavingsWhatIfRepository implements SavingsWhatIfRepository {
  const MockSavingsWhatIfRepository();

  @override
  SavingsWhatIfSnapshot getWhatIf() {
    return const SavingsWhatIfSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-whatif',
      actionDraft:
          'GET /earn/savings/whatif | POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/savings/whatif/run|stress-test',
      title: 'What-If Analysis',
      backRoute: '/earn/savings',
      heroLabel: 'Scenario Planner',
      tabs: [
        SavingsPreferenceTabDraft(id: 'scenarios', label: 'Kịch bản'),
        SavingsPreferenceTabDraft(id: 'results', label: 'Kết quả'),
        SavingsPreferenceTabDraft(id: 'stress', label: 'Stress Test'),
      ],
      defaultTab: 'scenarios',
      defaultScenario: SavingsWhatIfScenarioId.apyCrash,
      defaultCustomMultiplier: 1,
      defaultCustomVolatility: .1,
      scenarios: [
        SavingsWhatIfScenarioDraft(
          id: SavingsWhatIfScenarioId.apyCrash,
          label: 'APY sụt giảm',
          description: 'APY toàn bộ sản phẩm giảm 40-60% do thị trường lạnh',
          iconKey: 'trending_down',
          apyMultiplier: .45,
          volatility: .15,
          durationMonths: 12,
          riskLevel: SavingsWhatIfRiskLevel.high,
        ),
        SavingsWhatIfScenarioDraft(
          id: SavingsWhatIfScenarioId.apySpike,
          label: 'APY tăng vọt',
          description: 'APY tăng 50-80% do nhu cầu vay tăng mạnh',
          iconKey: 'trending_up',
          apyMultiplier: 1.65,
          volatility: .2,
          durationMonths: 12,
          riskLevel: SavingsWhatIfRiskLevel.low,
        ),
        SavingsWhatIfScenarioDraft(
          id: SavingsWhatIfScenarioId.rateCut,
          label: 'Cắt giảm lãi suất',
          description:
              'Ngân hàng trung ương cắt giảm lãi suất, APY on-chain giảm từ từ',
          iconKey: 'snowflake',
          apyMultiplier: .7,
          volatility: .05,
          durationMonths: 12,
          riskLevel: SavingsWhatIfRiskLevel.medium,
        ),
        SavingsWhatIfScenarioDraft(
          id: SavingsWhatIfScenarioId.marketStress,
          label: 'Stress test',
          description:
              'Khủng hoảng thanh khoản - APY giảm mạnh, biến động cao, rủi ro phá sản',
          iconKey: 'storm',
          apyMultiplier: .25,
          volatility: .35,
          durationMonths: 6,
          riskLevel: SavingsWhatIfRiskLevel.extreme,
        ),
        SavingsWhatIfScenarioDraft(
          id: SavingsWhatIfScenarioId.bullRun,
          label: 'Bull market',
          description:
              'Thị trường tăng mạnh, APY tăng đều, thanh khoản dồi dào',
          iconKey: 'flame',
          apyMultiplier: 2,
          volatility: .1,
          durationMonths: 12,
          riskLevel: SavingsWhatIfRiskLevel.low,
        ),
        SavingsWhatIfScenarioDraft(
          id: SavingsWhatIfScenarioId.custom,
          label: 'Tùy chỉnh',
          description: 'Tự chỉnh APY multiplier và volatility theo ý bạn',
          iconKey: 'sliders',
          apyMultiplier: 1,
          volatility: .1,
          durationMonths: 12,
          riskLevel: SavingsWhatIfRiskLevel.medium,
        ),
      ],
      portfolio: [
        SavingsWhatIfPortfolioPositionDraft(
          asset: 'USDT',
          product: 'USDT Linh hoạt',
          colorKey: 'buy',
          amountUsd: 3500,
          currentApyPct: 4.5,
          type: SavingsProductType.flexible,
        ),
        SavingsWhatIfPortfolioPositionDraft(
          asset: 'BTC',
          product: 'BTC Cố định 60D',
          colorKey: 'warn',
          amountUsd: 1350,
          currentApyPct: 3.5,
          type: SavingsProductType.locked,
          lockDays: 60,
        ),
        SavingsWhatIfPortfolioPositionDraft(
          asset: 'SOL',
          product: 'SOL Cố định 30D',
          colorKey: 'accent',
          amountUsd: 3250,
          currentApyPct: 6.5,
          type: SavingsProductType.locked,
          lockDays: 30,
        ),
        SavingsWhatIfPortfolioPositionDraft(
          asset: 'ETH',
          product: 'ETH Linh hoạt',
          colorKey: 'primary',
          amountUsd: 1400,
          currentApyPct: 3.9,
          type: SavingsProductType.flexible,
        ),
        SavingsWhatIfPortfolioPositionDraft(
          asset: 'AVAX',
          product: 'AVAX Cố định 90D',
          colorKey: 'sell',
          amountUsd: 500,
          currentApyPct: 7.2,
          type: SavingsProductType.locked,
          lockDays: 90,
        ),
      ],
      disclaimer:
          'Đây là mô phỏng giả định. Kết quả thực tế phụ thuộc vào nhiều yếu tố không thể dự đoán. Không phải lời khuyên đầu tư.',
      stressDisclaimer:
          'Stress test chỉ là mô phỏng giả định. Thị trường thực tế có thể biến động hoàn toàn khác biệt. Không sử dụng kết quả này làm cơ sở duy nhất cho quyết định tài chính.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, scenario catalog, custom multipliers, portfolio positions, scenario result, stress ranking, asset impact, and recommendation copy.',
      supportedStates: {
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

final class MockStakingTermsRepository implements StakingTermsRepository {
  const MockStakingTermsRepository();

  @override
  StakingTermsSnapshot getTerms() {
    return const StakingTermsSnapshot(
      endpoint: '/api/mobile/earn/earn-staking-terms',
      actionDraft:
          'GET /earn/staking/terms | POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/terms/accept',
      title: 'Điều khoản Staking',
      backRoute: '/earn/staking',
      documentTitle: 'Điều khoản Dịch vụ Staking',
      lastUpdated: '01/03/2026',
      version: '2.1',
      warning:
          'Vui lòng đọc kỹ điều khoản này trước khi sử dụng dịch vụ staking. Bằng việc đăng ký staking, bạn đồng ý tuân thủ các điều khoản dưới đây.',
      sections: [
        StakingTermsSectionDraft(
          id: 'definitions',
          title: '1. Định nghĩa',
          content: [
            '"Nền tảng" có nghĩa là dịch vụ staking được cung cấp bởi chúng tôi thông qua ứng dụng di động và web.',
            '"Người dùng" hoặc "Bạn" có nghĩa là bất kỳ cá nhân hoặc tổ chức nào sử dụng dịch vụ staking.',
            '"Tài sản số" có nghĩa là tiền điện tử, token hoặc tài sản kỹ thuật số khác được hỗ trợ trên nền tảng.',
            '"Staking" có nghĩa là việc khóa tài sản số để tham gia vào cơ chế đồng thuận Proof-of-Stake hoặc các cơ chế tương tự.',
            '"Phần thưởng" có nghĩa là lợi nhuận, tiền lãi hoặc token mới được tạo ra từ hoạt động staking.',
            '"APY" (Annual Percentage Yield) có nghĩa là tỷ lệ phần trăm lợi nhuận hằng năm, đã tính toán lãi kép.',
            '"Kỳ hạn khóa" có nghĩa là khoảng thời gian tài sản bị khóa và không thể rút trước hạn.',
            '"Validator" có nghĩa là nút mạng thực hiện xác thực giao dịch trong cơ chế Proof-of-Stake.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'service-description',
          title: '2. Mô tả dịch vụ',
          content: [
            'Nền tảng cung cấp các sản phẩm staking cho phép bạn kiếm phần thưởng bằng cách khóa tài sản số.',
            'Các loại sản phẩm gồm Staking Cố định, Staking Linh hoạt, DeFi Staking và Liquid Staking.',
            'Phần thưởng được tính toán và phân phối theo lịch trình của từng sản phẩm.',
            'Chúng tôi có quyền tạm dừng, sửa đổi hoặc ngừng cung cấp sản phẩm staking với thông báo trước.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'eligibility',
          title: '3. Điều kiện tham gia',
          content: [
            'Bạn phải đủ 18 tuổi hoặc độ tuổi trưởng thành theo pháp luật địa phương để sử dụng dịch vụ staking.',
            'Bạn phải hoàn tất xác thực danh tính theo yêu cầu của nền tảng.',
            'Bạn không được nằm trong quốc gia hoặc khu vực bị hạn chế theo quy định pháp luật.',
            'Bạn cam kết tuân thủ quy định về thuế, AML và CFT tại quốc gia của bạn.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'staking-mechanism',
          title: '4. Cơ chế Staking',
          content: [
            'Khi đăng ký staking, tài sản được chuyển từ ví giao dịch sang ví staking hoặc vùng lưu ký Earn.',
            'Tài sản có thể được ủy thác cho validator đã được nền tảng lựa chọn và thẩm định.',
            'Phần thưởng dựa trên số lượng staking, APY, hiệu suất validator và phí dịch vụ.',
            'Công thức tham chiếu: Rewards = Principal x (APY / 365) x Days - Service Fee.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'fees',
          title: '5. Phí và Chi phí',
          content: [
            'Phí dịch vụ có thể từ 0-20% phần thưởng staking tùy sản phẩm.',
            'Phí gas áp dụng khi chuyển tài sản vào hoặc ra khỏi ví staking.',
            'Rút sớm khỏi sản phẩm cố định có thể làm mất một phần hoặc toàn bộ phần thưởng đã tích lũy.',
            'Mọi phí phải được công bố rõ ràng trước khi bạn xác nhận giao dịch staking.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'reward-distribution',
          title: '6. Phân phối Phần thưởng',
          content: [
            'Staking linh hoạt thường phân phối phần thưởng hằng ngày.',
            'Staking cố định phân phối vào ngày đến hạn hoặc theo lịch của sản phẩm.',
            'Auto-Compound có thể tự động cộng phần thưởng vào số lượng tài sản đang staking.',
            'APY hiển thị là ước tính và có thể thay đổi theo điều kiện thị trường.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'risks',
          title: '7. Rủi ro',
          content: [
            'Staking tài sản số có rủi ro thị trường, thanh khoản, slashing, smart contract và pháp lý.',
            'Chúng tôi không bảo đảm bảo toàn vốn gốc hoặc thanh khoản tức thì.',
            'Bạn chỉ nên staking số lượng tài sản mà bạn có thể chấp nhận rủi ro mất mát.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'withdrawal-unstaking',
          title: '8. Rút tiền và Hủy Staking',
          content: [
            'Staking linh hoạt có thể được hủy bất kỳ lúc nào, tùy thời gian unbonding của mạng.',
            'Staking cố định thường không thể rút trước ngày đến hạn nếu không chịu phí.',
            'DeFi Staking phụ thuộc vào smart contract và có thể có cooldown period.',
            'Rút khẩn cấp có thể phát sinh phí cao hơn và cần xác nhận rủi ro.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'slashing',
          title: '9. Chính sách Slashing',
          content: [
            'Slashing là hình phạt do mạng blockchain áp dụng khi validator vi phạm quy tắc.',
            'Các hành vi có thể bị slashing gồm double signing, downtime hoặc hành vi độc hại.',
            'Nền tảng giảm thiểu rủi ro bằng cách chọn validator uy tín và phân tán tài sản.',
            'Một số sản phẩm có thể cung cấp bảo hiểm slashing với điều kiện riêng.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'tax',
          title: '10. Thuế',
          content: [
            'Phần thưởng staking có thể bị đánh thuế tùy theo pháp luật quốc gia của bạn.',
            'Bạn có trách nhiệm tự khai báo và nộp thuế cho phần thưởng staking.',
            'Nền tảng có thể cung cấp lịch sử giao dịch, báo cáo thuế và hướng dẫn tham khảo.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'liability',
          title: '11. Giới hạn Trách nhiệm',
          content: [
            'Dịch vụ staking được cung cấp trên cơ sở nguyên trạng và sẵn có.',
            'Chúng tôi không chịu trách nhiệm cho mất mát do slashing, hack, lỗi kỹ thuật hoặc thay đổi pháp lý.',
            'Trách nhiệm tối đa được giới hạn theo điều khoản pháp lý áp dụng.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'termination',
          title: '12. Chấm dứt Dịch vụ',
          content: [
            'Bạn có quyền hủy staking và ngừng sử dụng dịch vụ bất kỳ lúc nào.',
            'Nền tảng có thể tạm dừng hoặc chấm dứt tài khoản khi phát hiện vi phạm hoặc yêu cầu pháp lý.',
            'Khi chấm dứt, tài sản đang staking sẽ được xử lý theo lịch unbonding và quy định sản phẩm.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'changes',
          title: '13. Thay đổi Điều khoản',
          content: [
            'Chúng tôi có quyền sửa đổi điều khoản này bất kỳ lúc nào.',
            'Thay đổi quan trọng sẽ được thông báo trước qua email, thông báo ứng dụng hoặc banner.',
            'Nếu bạn tiếp tục sử dụng dịch vụ sau khi thay đổi có hiệu lực, bạn được xem là đã chấp nhận điều khoản mới.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'governing-law',
          title: '14. Luật áp dụng và Giải quyết Tranh chấp',
          content: [
            'Điều khoản này được điều chỉnh bởi luật pháp của quốc gia công ty.',
            'Tranh chấp được ưu tiên giải quyết bằng thương lượng, hòa giải và trọng tài theo quy định áp dụng.',
            'Bạn đồng ý không tham gia kiện tụng tập thể đối với nền tảng trong phạm vi pháp luật cho phép.',
          ],
        ),
        StakingTermsSectionDraft(
          id: 'contact',
          title: '15. Liên hệ',
          content: [
            'Email: legal@platform.com',
            'Support: support@platform.com',
            'Phone: +1-800-XXX-XXXX',
            'Thời gian phản hồi: 1-3 ngày làm việc.',
          ],
        ),
      ],
      acceptanceText:
          'Tôi đã đọc, hiểu và đồng ý với Điều khoản Dịch vụ Staking phiên bản 2.1 ngày 01/03/2026.',
      acceptanceFootnote:
          'Bằng việc đánh dấu ô này và tiếp tục sử dụng dịch vụ, bạn tạo ra một thỏa thuận có tính ràng buộc pháp lý giữa bạn và nền tảng.',
      footer:
          'Điều khoản này có hiệu lực từ 01/03/2026. Phiên bản cũ có thể được xem trong mục Lịch sử phiên bản. Nếu bạn có câu hỏi, vui lòng liên hệ legal@platform.com.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, legal terms version, acceptance state, section list, and print/download action drafts.',
      supportedStates: {
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

final class MockStakingRiskDisclosureRepository
    implements StakingRiskDisclosureRepository {
  const MockStakingRiskDisclosureRepository();

  @override
  StakingRiskDisclosureSnapshot getDisclosure() {
    return const StakingRiskDisclosureSnapshot(
      endpoint: '/api/mobile/earn/earn-staking-risk-disclosure',
      actionDraft:
          'GET /earn/staking/risk-disclosure | POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/risk-disclosure/acknowledge; GET /earn/staking/risk-assessment',
      title: 'Công bố Rủi ro',
      backRoute: '/earn/staking',
      defaultTab: 'overview',
      tabs: [
        StakingRiskDisclosureTabDraft(id: 'overview', label: 'Tổng quan'),
        StakingRiskDisclosureTabDraft(
          id: 'categories',
          label: 'Các loại rủi ro',
        ),
        StakingRiskDisclosureTabDraft(id: 'assessment', label: 'Đánh giá'),
      ],
      warningTitle: 'Cảnh báo Rủi ro Quan trọng',
      warningBody:
          'Staking tài sản số có rủi ro mất vốn. Phần thưởng không được đảm bảo. Chỉ stake số tiền bạn có thể chấp nhận mất. Đọc kỹ các rủi ro dưới đây trước khi tham gia.',
      summaryTitle: 'Tóm tắt Rủi ro',
      summaryBody:
          'Staking là hoạt động khóa tài sản số để tham gia vào mạng blockchain và nhận phần thưởng. Mặc dù có lợi nhuận tiềm năng, staking đi kèm với nhiều rủi ro có thể dẫn đến mất một phần hoặc toàn bộ tài sản.',
      riskCounts: [
        StakingRiskCountDraft(
          level: StakingDisclosureRiskLevel.low,
          count: 1,
          label: 'Rủi ro Thấp',
        ),
        StakingRiskCountDraft(
          level: StakingDisclosureRiskLevel.medium,
          count: 3,
          label: 'Rủi ro Trung bình',
        ),
        StakingRiskCountDraft(
          level: StakingDisclosureRiskLevel.high,
          count: 3,
          label: 'Rủi ro Cao',
        ),
      ],
      productSectionTitle: 'Rủi ro theo Sản phẩm',
      products: [
        StakingRiskProductDraft(
          name: 'Staking Linh hoạt',
          level: StakingDisclosureRiskLevel.medium,
          risks: ['Rủi ro Thị trường', 'Rủi ro Thanh khoản', 'Rủi ro Đối tác'],
        ),
        StakingRiskProductDraft(
          name: 'Staking Cố định',
          level: StakingDisclosureRiskLevel.high,
          risks: [
            'Rủi ro Thị trường',
            'Rủi ro Thanh khoản',
            'Rủi ro Slashing',
            'Rủi ro Đối tác',
          ],
        ),
        StakingRiskProductDraft(
          name: 'DeFi Staking',
          level: StakingDisclosureRiskLevel.high,
          risks: [
            'Rủi ro Thị trường',
            'Rủi ro Thanh khoản',
            'Rủi ro Smart Contract',
            'Rủi ro Đối tác',
          ],
        ),
      ],
      disclaimer:
          'Nền tảng KHÔNG đảm bảo lợi nhuận, bảo toàn vốn, hoặc thanh khoản. Bạn chịu hoàn toàn rủi ro khi tham gia staking. Vui lòng đọc kỹ từng loại rủi ro trong tab "Các loại rủi ro".',
      categories: [
        StakingRiskCategoryDraft(
          id: 'market',
          title: 'Rủi ro Thị trường',
          level: StakingDisclosureRiskLevel.high,
          description:
              'Giá trị tài sản số có thể biến động mạnh trong kỳ hạn khóa, dẫn đến thua lỗ vốn gốc dù vẫn nhận phần thưởng staking.',
          details: [
            'Giá tài sản số có thể giảm 20-80% trong thời gian ngắn do tin tức tiêu cực, thay đổi pháp lý, sự cố kỹ thuật hoặc bán tháo thị trường.',
            'Trong kỳ hạn khóa, bạn không thể bán tài sản để cắt lỗ.',
            'Phần thưởng staking có thể không đủ bù đắp thua lỗ giá.',
          ],
          examples: [
            'Terra LUNA sụp đổ từ khoảng 80 USD xuống gần 0 trong tháng 5/2022.',
            'Bitcoin từng giảm từ 69.000 USD xuống khoảng 15.500 USD trong chu kỳ 2022.',
          ],
          mitigation: [
            'Chỉ stake tài sản bạn sẵn sàng giữ dài hạn.',
            'Phân tán qua nhiều tài sản, không all-in một coin.',
            'Chọn Flexible Staking nếu lo ngại biến động giá.',
          ],
        ),
        StakingRiskCategoryDraft(
          id: 'liquidity',
          title: 'Rủi ro Thanh khoản',
          level: StakingDisclosureRiskLevel.high,
          description:
              'Tài sản bị khóa hoặc phải chờ unbonding, khiến bạn không thể bán hoặc chuyển đổi ngay lập tức.',
          details: [
            'Fixed Staking có thể khóa tài sản từ 30 đến 365 ngày.',
            'Flexible Staking vẫn có thể có thời gian unbonding 1-21 ngày.',
            'Rút sớm có thể mất một phần hoặc toàn bộ phần thưởng.',
          ],
          examples: [
            'Bạn stake ETH 90 ngày nhưng không thể chốt lời khi giá tăng trong ngày thứ 30.',
            'Bạn cần tiền khẩn cấp nhưng tài sản đang trong giai đoạn unbonding.',
          ],
          mitigation: [
            'Chỉ stake phần vốn dư, không dùng quỹ khẩn cấp.',
            'Giữ một phần tài sản ở trạng thái thanh khoản.',
            'Dùng ladder strategy để phân tán kỳ hạn.',
          ],
        ),
        StakingRiskCategoryDraft(
          id: 'slashing',
          title: 'Rủi ro Slashing',
          level: StakingDisclosureRiskLevel.medium,
          description:
              'Validator vi phạm quy tắc mạng có thể bị phạt, làm mất một phần tài sản đã staking.',
          details: [
            'Slashing là hình phạt tự động của blockchain khi validator downtime, double signing hoặc hành vi độc hại.',
            'Mức phạt có thể từ rất nhỏ đến toàn bộ phần stake tùy mạng.',
            'Người dùng không kiểm soát trực tiếp hành vi validator.',
          ],
          examples: [
            'Validator Cosmos double sign có thể bị phạt một phần lớn tổng stake.',
            'Validator Ethereum offline lâu có thể mất một phần phần thưởng và vốn.',
          ],
          mitigation: [
            'Ưu tiên validator có uptime cao và lịch sử minh bạch.',
            'Phân tán tài sản qua nhiều validator nếu có thể.',
            'Theo dõi validator health thường xuyên.',
          ],
        ),
        StakingRiskCategoryDraft(
          id: 'smart-contract',
          title: 'Rủi ro Smart Contract',
          level: StakingDisclosureRiskLevel.high,
          description:
              'DeFi Staking phụ thuộc vào smart contract; bug, exploit hoặc rug pull có thể làm mất toàn bộ tài sản.',
          details: [
            'Smart contract sau khi triển khai có thể khó sửa đổi.',
            'Các lỗi như reentrancy, access control hoặc oracle manipulation có thể bị khai thác.',
            'Audit giúp giảm rủi ro nhưng không loại bỏ hoàn toàn rủi ro.',
          ],
          examples: [
            'The DAO hack năm 2016 làm mất khoảng 60 triệu USD ETH.',
            'Wormhole hack năm 2022 làm mất khoảng 320 triệu USD.',
          ],
          mitigation: [
            'Chỉ dùng protocol đã được audit bởi firm uy tín.',
            'Kiểm tra TVL, lịch sử vận hành và audit report.',
            'Phân tán qua nhiều protocol thay vì all-in.',
          ],
        ),
        StakingRiskCategoryDraft(
          id: 'counterparty',
          title: 'Rủi ro Đối tác',
          level: StakingDisclosureRiskLevel.medium,
          description:
              'Nền tảng, validator hoặc đối tác lưu ký có thể gặp sự cố kỹ thuật, bị hack, phá sản hoặc gian lận.',
          details: [
            'Nền tảng có thể giữ quyền custody đối với tài sản đang staking.',
            'Rủi ro gồm hack, inside job, phá sản hoặc tạm dừng rút tiền.',
            'Trong trường hợp phá sản, người dùng có thể chỉ nhận lại một phần tài sản.',
          ],
          examples: [
            'Celsius từng đóng băng rút tiền khi gặp khủng hoảng thanh khoản năm 2022.',
            'Mt. Gox phá sản khiến người dùng mất quyền truy cập BTC trong nhiều năm.',
          ],
          mitigation: [
            'Kiểm tra license, audit, đội ngũ và quỹ bảo hiểm của nền tảng.',
            'Không stake toàn bộ tài sản ở một nền tảng.',
            'Rút tiền nếu có dấu hiệu bất thường nghiêm trọng.',
          ],
        ),
        StakingRiskCategoryDraft(
          id: 'regulatory',
          title: 'Rủi ro Pháp lý',
          level: StakingDisclosureRiskLevel.medium,
          description:
              'Quy định về staking có thể thay đổi, dẫn đến dịch vụ bị hạn chế, thuế tăng hoặc tài khoản bị yêu cầu rà soát.',
          details: [
            'Staking chưa có khung pháp lý rõ ràng ở nhiều quốc gia.',
            'Cơ quan quản lý có thể yêu cầu license, KYC bổ sung hoặc ngừng cung cấp dịch vụ.',
            'Phần thưởng staking có thể là thu nhập chịu thuế.',
          ],
          examples: [
            'Kraken từng phải dừng dịch vụ staking tại Mỹ sau thỏa thuận với SEC năm 2023.',
            'MiCA tại EU làm tăng yêu cầu tuân thủ với nhà cung cấp crypto.',
          ],
          mitigation: [
            'Theo dõi quy định pháp lý tại quốc gia của bạn.',
            'Khai báo thuế đầy đủ cho phần thưởng staking.',
            'Chọn nền tảng có license và chính sách tuân thủ rõ ràng.',
          ],
        ),
        StakingRiskCategoryDraft(
          id: 'technical',
          title: 'Rủi ro Kỹ thuật',
          level: StakingDisclosureRiskLevel.low,
          description:
              'Sự cố blockchain hoặc nền tảng có thể làm chậm rút tiền, mất phần thưởng hoặc hiển thị dữ liệu sai.',
          details: [
            'Rủi ro gồm hard fork, network congestion, downtime, lỗi API hoặc lỗi hiển thị.',
            'Sự cố kỹ thuật thường được khắc phục nhưng có thể kéo dài nhiều giờ hoặc nhiều ngày.',
            'Trong thời gian sự cố, thao tác rút hoặc claim có thể bị trì hoãn.',
          ],
          examples: [
            'Solana từng có nhiều đợt downtime kéo dài nhiều giờ trong giai đoạn 2021-2022.',
            'Sàn giao dịch có thể tạm dừng rút tiền khi API hoặc ví nóng gặp sự cố.',
          ],
          mitigation: [
            'Theo dõi status page của blockchain và nền tảng.',
            'Giữ dữ liệu giao dịch quan trọng để đối chiếu.',
            'Liên hệ support nếu sự cố kéo dài quá 24 giờ.',
          ],
        ),
      ],
      assessmentTitle: 'Đánh giá Rủi ro Cá nhân',
      assessmentSubtitle: 'Xác định mức rủi ro phù hợp với bạn',
      assessmentBody:
          'Trước khi stake, bạn nên đánh giá khả năng chấp nhận rủi ro của mình. Làm bài quiz ngắn để nhận gợi ý sản phẩm phù hợp.',
      assessmentCta: 'Bắt đầu đánh giá rủi ro',
      assessmentRoute: '/earn/staking/risk-assessment',
      faqTitle: 'Câu hỏi thường gặp',
      faqs: [
        StakingRiskFaqDraft(
          question: 'Tôi có thể mất hết tiền khi stake không?',
          answer:
              'Có. Trong trường hợp xấu nhất như smart contract bị hack, nền tảng phá sản hoặc validator bị slashing nghiêm trọng, bạn có thể mất toàn bộ tài sản.',
        ),
        StakingRiskFaqDraft(
          question: 'APY có được đảm bảo không?',
          answer:
              'Fixed Staking có thể khóa APY tại thời điểm đăng ký. Flexible hoặc DeFi Staking có thể thay đổi hằng ngày theo điều kiện mạng và thị trường.',
        ),
        StakingRiskFaqDraft(
          question: 'Nếu tôi rút sớm thì sao?',
          answer:
              'Rút sớm khỏi Fixed Staking có thể làm mất 50-100% phần thưởng. Flexible Staking có thể cần chờ unbonding trước khi tài sản khả dụng.',
        ),
        StakingRiskFaqDraft(
          question: 'Có bảo hiểm nào không?',
          answer:
              'Một số sản phẩm có slashing insurance hoặc quỹ bảo hiểm, nhưng mức bồi thường và điều kiện luôn có giới hạn.',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, risk categories, product risk mapping, personal assessment route, and acknowledgment/audit states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingWithdrawalPolicyRepository
    implements StakingWithdrawalPolicyRepository {
  const MockStakingWithdrawalPolicyRepository();

  @override
  StakingWithdrawalPolicySnapshot getPolicy() {
    return const StakingWithdrawalPolicySnapshot(
      endpoint: '/api/mobile/earn/earn-staking-withdrawal-policy',
      actionDraft:
          'GET /earn/staking/withdrawal-policy | POST /wallet/withdraw-preview | POST /wallet/withdraw-confirm | POST /earn/subscribe|redeem|claim|vote where applicable; audit trail required for high-risk withdrawal preview and confirm',
      title: 'Chính sách Rút tiền',
      backRoute: '/earn/staking',
      defaultTab: 'timeline',
      tabs: [
        StakingRiskDisclosureTabDraft(id: 'timeline', label: 'Timeline'),
        StakingRiskDisclosureTabDraft(id: 'penalties', label: 'Phí rút sớm'),
        StakingRiskDisclosureTabDraft(id: 'emergency', label: 'Rút khẩn cấp'),
      ],
      infoTitle: 'Về Chính sách Rút tiền',
      infoBody:
          'Mỗi sản phẩm staking có quy trình rút tiền khác nhau. Vui lòng đọc kỹ để hiểu thời gian xử lý và phí rút sớm nếu có.',
      processTitle: 'Quy trình Rút tiền',
      processSteps: [
        StakingWithdrawalStepDraft(
          step: 1,
          title: 'Yêu cầu rút',
          description: 'Bạn bấm nút "Unstake" hoặc "Rút tiền" trên ứng dụng.',
          tone: StakingDisclosureRiskLevel.medium,
        ),
        StakingWithdrawalStepDraft(
          step: 2,
          title: 'Xác nhận',
          description: 'Xác nhận email/SMS/2FA để đảm bảo an toàn.',
          tone: StakingDisclosureRiskLevel.low,
        ),
        StakingWithdrawalStepDraft(
          step: 3,
          title: 'Unbonding period',
          description: 'Chờ thời gian mở khóa, thường 1-21 ngày tùy sản phẩm.',
          tone: StakingDisclosureRiskLevel.medium,
        ),
        StakingWithdrawalStepDraft(
          step: 4,
          title: 'Nhận tiền',
          description: 'Tài sản được chuyển về ví giao dịch Spot Wallet.',
          tone: StakingDisclosureRiskLevel.low,
        ),
      ],
      timelineTitle: 'Timeline theo Sản phẩm',
      timelines: [
        StakingWithdrawalTimelineDraft(
          product: 'Staking Linh hoạt',
          initiate: 'Bất kỳ lúc nào',
          unbonding: '1-3 ngày',
          receive: 'T+1 đến T+3',
          penalty: 'Không',
        ),
        StakingWithdrawalTimelineDraft(
          product: 'Staking Cố định 30D',
          initiate: 'Sau ngày đến hạn',
          unbonding: 'Tức thì',
          receive: 'T+0 (ngay)',
          penalty: 'Rút sớm: Mất 100% phần thưởng',
        ),
        StakingWithdrawalTimelineDraft(
          product: 'Staking Cố định 60D',
          initiate: 'Sau ngày đến hạn',
          unbonding: 'Tức thì',
          receive: 'T+0 (ngay)',
          penalty:
              'Rút sớm <30 ngày: Mất 100% phần thưởng\nRút sớm >30 ngày: Mất 50% phần thưởng',
        ),
        StakingWithdrawalTimelineDraft(
          product: 'Staking Cố định 90D+',
          initiate: 'Sau ngày đến hạn',
          unbonding: 'Tức thì',
          receive: 'T+0 (ngay)',
          penalty:
              'Rút sớm <30 ngày: Mất 100% phần thưởng\nRút sớm >30 ngày: Mất 50% phần thưởng',
        ),
        StakingWithdrawalTimelineDraft(
          product: 'DeFi Staking',
          initiate: 'Bất kỳ lúc nào',
          unbonding: '3-21 ngày (tùy pool)',
          receive: 'T+3 đến T+21',
          penalty: 'Phí rút pool: 0.5-2%',
        ),
        StakingWithdrawalTimelineDraft(
          product: 'Liquid Staking',
          initiate: 'Bất kỳ lúc nào (swap stToken)',
          unbonding: '21-28 ngày (unstake trực tiếp)',
          receive: 'Tức thì (swap) hoặc T+21-28 (unstake)',
          penalty: 'Slippage: 0.1-1% (khi swap)',
        ),
      ],
      timelineNote:
          'Unbonding period là thời gian bắt buộc do mạng blockchain quy định, không phải do nền tảng. Chúng tôi không thể rút ngắn thời gian này.',
      penaltyTitle: 'Phí rút sớm',
      penaltyBody:
          'Nếu bạn rút tài sản khỏi sản phẩm Staking Cố định trước ngày đáo hạn, hệ thống sẽ tính phí rút sớm trên phần thưởng đã tích lũy.',
      penaltyRules: [
        StakingWithdrawalPenaltyRuleDraft(
          tone: StakingDisclosureRiskLevel.high,
          label: 'Rút sớm trong 30 ngày đầu: mất 100% phần thưởng đã tích lũy.',
        ),
        StakingWithdrawalPenaltyRuleDraft(
          tone: StakingDisclosureRiskLevel.medium,
          label: 'Rút sớm sau 30 ngày: mất 50% phần thưởng đã tích lũy.',
        ),
        StakingWithdrawalPenaltyRuleDraft(
          tone: StakingDisclosureRiskLevel.low,
          label: 'Rút đúng hạn hoặc sau hạn: không phí, nhận đủ phần thưởng.',
        ),
      ],
      penaltyExamples: [
        StakingWithdrawalPenaltyExampleDraft(
          title: 'Tình huống 1: Rút sớm sau 20 ngày',
          rows: [
            StakingWithdrawalCalculationRowDraft(
              label: 'Số lượng gốc',
              value: '1,000 USDT',
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Phần thưởng tích lũy',
              value: '+10.5 USDT',
              tone: StakingDisclosureRiskLevel.low,
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Đã stake',
              value: '20/90 ngày',
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Phí rút sớm (100%)',
              value: '-10.5 USDT',
              tone: StakingDisclosureRiskLevel.high,
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Nhận về',
              value: '1,000 USDT',
              highlight: true,
            ),
          ],
        ),
        StakingWithdrawalPenaltyExampleDraft(
          title: 'Tình huống 2: Rút sớm sau 45 ngày',
          rows: [
            StakingWithdrawalCalculationRowDraft(
              label: 'Số lượng gốc',
              value: '1,000 USDT',
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Phần thưởng tích lũy',
              value: '+22.5 USDT',
              tone: StakingDisclosureRiskLevel.low,
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Đã stake',
              value: '45/90 ngày',
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Phí rút sớm (50%)',
              value: '-11.25 USDT',
              tone: StakingDisclosureRiskLevel.medium,
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Phần thưởng còn lại',
              value: '+11.25 USDT',
              tone: StakingDisclosureRiskLevel.low,
            ),
            StakingWithdrawalCalculationRowDraft(
              label: 'Nhận về',
              value: '1,011.25 USDT',
              highlight: true,
            ),
          ],
        ),
      ],
      calculatorCta: 'Tính phí rút sớm của tôi',
      calculatorDisclaimer:
          'Đây là ước tính. Phí thực tế có thể khác nhau tùy chính sách cụ thể của sản phẩm. Luôn kiểm tra preview trước khi xác nhận rút.',
      emergencyTitle: 'Rút tiền Khẩn cấp',
      emergencyBody:
          'Rút khẩn cấp chỉ nên dùng khi bạn thực sự cần tiền gấp và không thể chờ unbonding period tiêu chuẩn.',
      emergencyReasons: [
        'Y tế khẩn cấp như bệnh viện hoặc tai nạn.',
        'Thiên tai, thảm họa hoặc sự kiện bất khả kháng.',
        'Mất việc đột ngột, cần tiền sinh hoạt.',
        'Tình huống pháp lý nghiêm trọng.',
      ],
      emergencySteps: [
        StakingEmergencyStepDraft(
          step: 1,
          text: 'Liên hệ Support 24/7 qua Live Chat hoặc Hotline.',
          time: 'Ngay lập tức',
        ),
        StakingEmergencyStepDraft(
          step: 2,
          text: 'Cung cấp lý do rút khẩn cấp và chứng minh nếu cần.',
          time: '< 1 giờ',
        ),
        StakingEmergencyStepDraft(
          step: 3,
          text: 'Team Support xem xét và phê duyệt.',
          time: '1-4 giờ',
        ),
        StakingEmergencyStepDraft(
          step: 4,
          text: 'Xác nhận phí rút khẩn cấp, thường 10-20% phần thưởng.',
          time: '< 30 phút',
        ),
        StakingEmergencyStepDraft(
          step: 5,
          text: 'Nhận tiền về ví giao dịch.',
          time: '1-6 giờ',
        ),
      ],
      emergencyFees: [
        StakingEmergencyFeeDraft(
          product: 'Flexible Staking',
          fee: '5% phần thưởng',
        ),
        StakingEmergencyFeeDraft(
          product: 'Fixed Staking <30 ngày',
          fee: '100% phần thưởng + 5% gốc',
        ),
        StakingEmergencyFeeDraft(
          product: 'Fixed Staking >30 ngày',
          fee: '50% phần thưởng + 3% gốc',
        ),
        StakingEmergencyFeeDraft(
          product: 'DeFi Staking',
          fee: '10% phần thưởng + phí pool',
        ),
      ],
      emergencyWarning:
          'Rút khẩn cấp không được đảm bảo phê duyệt; phí không hoàn lại; tối đa 2 lần mỗi năm; lạm dụng có thể dẫn đến hạn chế tài khoản.',
      supportContacts: [
        StakingSupportContactDraft(
          label: 'Live Chat',
          value: 'support.platform.com/chat',
        ),
        StakingSupportContactDraft(
          label: 'Hotline 24/7',
          value: '+1-800-XXX-XXXX',
        ),
        StakingSupportContactDraft(
          label: 'Email',
          value: 'emergency@platform.com',
        ),
      ],
      contractNotes:
          'High-risk withdrawal policy must include preview, confirm, audit trail, supported loading/empty/error/offline/submitting/success states, and data from earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData.',
      supportedStates: {
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

final class MockStakingTaxGuideRepository implements StakingTaxGuideRepository {
  const MockStakingTaxGuideRepository();

  @override
  StakingTaxGuideSnapshot getGuide() {
    return const StakingTaxGuideSnapshot(
      endpoint: '/api/mobile/earn/earn-staking-tax-guide',
      actionDraft:
          'GET /earn/staking/tax-guide | POST /exports | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Hướng dẫn Thuế',
      backRoute: '/earn/staking',
      defaultTab: 'overview',
      tabs: [
        StakingRiskDisclosureTabDraft(id: 'overview', label: 'Tổng quan'),
        StakingRiskDisclosureTabDraft(
          id: 'jurisdictions',
          label: 'Theo quốc gia',
        ),
        StakingRiskDisclosureTabDraft(id: 'calculator', label: 'Máy tính'),
      ],
      disclaimerTitle: 'Tuyên bố quan trọng',
      disclaimerBody:
          'Chúng tôi KHÔNG phải là cố vấn thuế hoặc kế toán. Thông tin dưới đây chỉ mang tính tham khảo. Vui lòng tham khảo ý kiến chuyên gia thuế địa phương trước khi khai báo thuế.',
      overviewTitle: 'Tại sao phải khai báo thuế?',
      overviewBody:
          'Phần thưởng staking được coi là thu nhập tại hầu hết các quốc gia. Khi bạn nhận phần thưởng, bạn phải khai báo và nộp thuế theo quy định pháp luật.',
      incomeEvents: [
        StakingTaxIncomeEventDraft(
          title: 'Khi nhận phần thưởng',
          description:
              'Phần thưởng được tính là thu nhập tại thời điểm nhận, dựa trên giá trị thị trường tại thời điểm đó.',
          example:
              'Ví dụ: Bạn nhận 0.1 ETH phần thưởng khi giá ETH = \$2,000 -> Thu nhập = \$200.',
        ),
        StakingTaxIncomeEventDraft(
          title: 'Khi bán phần thưởng',
          description:
              'Khi bạn bán phần thưởng, có thể phát sinh thuế lãi vốn nếu giá tăng so với khi nhận.',
          example:
              'Ví dụ: Nhận 0.1 ETH (\$200), sau 6 tháng bán với giá \$250 -> Lãi vốn = \$50.',
        ),
      ],
      summaryTitle: 'Tóm tắt Quy định',
      countrySummaries: [
        StakingTaxCountrySummaryDraft(
          code: 'US',
          country: 'Hoa Kỳ',
          treatment: 'Ordinary Income (10-37%)',
          cgt: 'Có (0-20%)',
        ),
        StakingTaxCountrySummaryDraft(
          code: 'GB',
          country: 'Vương quốc Anh',
          treatment: 'Income Tax (20-45%)',
          cgt: 'Có (10-20%)',
        ),
        StakingTaxCountrySummaryDraft(
          code: 'CA',
          country: 'Canada',
          treatment: '50% Taxable (15-33%)',
          cgt: 'Có (50% taxable)',
        ),
        StakingTaxCountrySummaryDraft(
          code: 'AU',
          country: 'Úc',
          treatment: 'Ordinary Income (19-45%)',
          cgt: 'Có (discount 50%)',
        ),
        StakingTaxCountrySummaryDraft(
          code: 'SG',
          country: 'Singapore',
          treatment: 'Có thể miễn thuế',
          cgt: 'Không',
        ),
      ],
      toolsTitle: 'Công cụ hỗ trợ',
      historyRoute: '/earn/history',
      taxReportsRoute: '/tax-reports',
      jurisdictions: [
        StakingTaxJurisdictionDraft(
          id: 'us',
          code: 'US',
          name: 'Hoa Kỳ (United States)',
          taxAuthority: 'IRS (Internal Revenue Service)',
          treatment:
              'Phần thưởng staking được coi là thu nhập thông thường tại thời điểm nhận. Thuế suất liên bang thường 10-37% tùy bậc thu nhập.',
          rate: '10-37% (Federal) + 0-13.3% (State)',
          reportingForm:
              '1040 Schedule 1 (Additional Income), Form 8949 khi bán',
          resources: [
            StakingTaxResourceDraft(
              label: 'IRS Notice 2014-21',
              url: 'https://irs.gov',
            ),
            StakingTaxResourceDraft(
              label: 'IRS FAQ - Virtual Currency',
              url: 'https://irs.gov',
            ),
          ],
        ),
        StakingTaxJurisdictionDraft(
          id: 'uk',
          code: 'GB',
          name: 'Vương quốc Anh (United Kingdom)',
          taxAuthority: 'HMRC (HM Revenue & Customs)',
          treatment:
              'Phần thưởng staking có thể là income hoặc capital gain tùy tình huống. Hoạt động thường xuyên có thể chịu Income Tax.',
          rate: '20-45% (Income Tax) hoặc 10-20% (Capital Gains Tax)',
          reportingForm: 'Self Assessment Tax Return (SA100)',
          resources: [
            StakingTaxResourceDraft(
              label: 'HMRC Crypto Manual',
              url: 'https://gov.uk',
            ),
            StakingTaxResourceDraft(
              label: 'Cryptoassets for Individuals',
              url: 'https://gov.uk',
            ),
          ],
        ),
        StakingTaxJurisdictionDraft(
          id: 'ca',
          code: 'CA',
          name: 'Canada',
          taxAuthority: 'CRA (Canada Revenue Agency)',
          treatment:
              'Phần thưởng staking có thể là business income hoặc capital gain tùy mục đích sử dụng.',
          rate: '15-33% (Federal) + 5-25.75% (Provincial)',
          reportingForm: 'T1 General, Schedule 3 (Capital Gains)',
          resources: [
            StakingTaxResourceDraft(
              label: 'CRA Cryptocurrency Guide',
              url: 'https://canada.ca',
            ),
          ],
        ),
        StakingTaxJurisdictionDraft(
          id: 'au',
          code: 'AU',
          name: 'Úc (Australia)',
          taxAuthority: 'ATO (Australian Taxation Office)',
          treatment:
              'Phần thưởng staking được coi là ordinary income tại thời điểm nhận. Khi bán, CGT có thể áp dụng.',
          rate: '19-45% (Income Tax) + 2% Medicare Levy',
          reportingForm: 'Individual Tax Return (ITR)',
          resources: [
            StakingTaxResourceDraft(
              label: 'ATO Crypto Tax Guide',
              url: 'https://ato.gov.au',
            ),
          ],
        ),
        StakingTaxJurisdictionDraft(
          id: 'sg',
          code: 'SG',
          name: 'Singapore',
          taxAuthority: 'IRAS (Inland Revenue Authority of Singapore)',
          treatment:
              'Phần thưởng staking có thể không bị đánh thuế nếu là hoạt động đầu tư dài hạn. Nếu trade thường xuyên có thể bị đánh thuế như income.',
          rate: '0-22% nếu bị đánh thuế',
          reportingForm: 'Form B / Form C cho công ty',
          resources: [
            StakingTaxResourceDraft(
              label: 'IRAS e-Tax Guide on Digital Tokens',
              url: 'https://iras.gov.sg',
            ),
          ],
        ),
        StakingTaxJurisdictionDraft(
          id: 'other',
          code: 'GL',
          name: 'Quốc gia khác',
          taxAuthority: 'Tùy theo quốc gia',
          treatment:
              'Mỗi quốc gia có quy định khác nhau. Vui lòng tham khảo luật sư thuế địa phương.',
          rate: 'Khác nhau',
          reportingForm: 'Khác nhau',
          resources: [
            StakingTaxResourceDraft(
              label: 'Crypto Tax Guide (Global)',
              url: 'https://koinly.io/guides',
            ),
          ],
        ),
      ],
      calculatorTitle: 'Máy tính Thuế',
      calculatorSubtitle: 'Ước tính thuế phải nộp',
      calculatorHint: 'Ví dụ: Hoa Kỳ 10-37%, Anh 20-45%, Canada 15-33%',
      calculatorDisclaimer:
          'Đây chỉ là ước tính đơn giản. Thuế thực tế có thể khác do thu nhập khác, khấu trừ, miễn giảm hoặc thuế địa phương.',
      faqTitle: 'Câu hỏi thường gặp',
      faqs: [
        StakingTaxFaqDraft(
          question: 'Tôi có phải nộp thuế nếu chưa bán phần thưởng?',
          answer:
              'Có. Tại hầu hết quốc gia, phần thưởng staking là thu nhập chịu thuế ngay khi nhận, bất kể bạn có bán hay không.',
        ),
        StakingTaxFaqDraft(
          question: 'Làm sao biết giá thị trường tại thời điểm nhận?',
          answer:
              'Nền tảng cung cấp lịch sử giao dịch có ghi giá USD tại thời điểm nhận phần thưởng. Bạn có thể xuất CSV/PDF để khai thuế.',
        ),
        StakingTaxFaqDraft(
          question: 'Nếu tôi không khai báo thì sao?',
          answer:
              'Trốn thuế là vi phạm pháp luật. Bạn có thể bị phạt, tính lãi hoặc chịu trách nhiệm pháp lý tùy khu vực.',
        ),
        StakingTaxFaqDraft(
          question: 'Có công cụ nào giúp khai thuế tự động?',
          answer:
              'Có. Bạn có thể dùng các dịch vụ như Koinly, CoinTracker hoặc TaxBit để import giao dịch và tạo báo cáo.',
        ),
      ],
      footer:
          'Nền tảng KHÔNG cung cấp tư vấn thuế, kế toán hoặc pháp lý. Thông tin này chỉ mang tính giáo dục. Vui lòng tham khảo chuyên gia thuế có giấy phép tại quốc gia của bạn.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, jurisdiction guidance, calculator input state, and POST /exports action state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
