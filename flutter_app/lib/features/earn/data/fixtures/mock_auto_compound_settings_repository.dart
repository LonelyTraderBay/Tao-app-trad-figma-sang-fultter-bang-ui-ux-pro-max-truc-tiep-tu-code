part of '../repositories/mock_earn_repository.dart';

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
