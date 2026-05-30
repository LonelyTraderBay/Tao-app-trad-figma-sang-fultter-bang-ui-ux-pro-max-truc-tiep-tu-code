part of '../repositories/mock_earn_repository.dart';

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
