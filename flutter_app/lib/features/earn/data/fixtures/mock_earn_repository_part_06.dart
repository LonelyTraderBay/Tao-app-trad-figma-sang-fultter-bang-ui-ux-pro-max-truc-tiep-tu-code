part of '../repositories/mock_earn_repository.dart';

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
