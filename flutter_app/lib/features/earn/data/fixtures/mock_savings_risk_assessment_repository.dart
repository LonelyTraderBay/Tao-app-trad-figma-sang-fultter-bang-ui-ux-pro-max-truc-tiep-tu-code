part of '../repositories/mock_earn_repository.dart';

final class MockSavingsRiskAssessmentRepository extends _MockEarnRepositoryBase
    implements SavingsRiskAssessmentRepository {
  const MockSavingsRiskAssessmentRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<SavingsRiskAssessmentSnapshot> getRiskAssessment() async {
    await _simulateNetwork();
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
