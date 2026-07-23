part of '../repositories/mock_earn_repository.dart';

final class MockStakingGuideRepository extends _MockEarnRepositoryBase
    implements StakingGuideRepository {
  const MockStakingGuideRepository({super.simulateError, super.loadDelay});

  @override
  Future<StakingGuideSnapshot> getGuide() async {
    await _simulateNetwork();
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

final class MockStakingFAQRepository extends _MockEarnRepositoryBase
    implements StakingFAQRepository {
  const MockStakingFAQRepository({super.simulateError, super.loadDelay});

  @override
  Future<StakingFAQSnapshot> getFAQ() async {
    await _simulateNetwork();
    return StakingFAQSnapshot(
      endpoint: '/api/mobile/earn/earn-faq',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'FAQ',
      backRoute: '/earn/staking',
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.staking,
        referenceId: 'staking-faq',
        sourceRoute: '/earn/faq',
        issueLabel: 'Staking FAQ support',
      ),
      searchPlaceholder: 'Tìm câu hỏi...',
      items: const [
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
      supportedStates: const {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingNotificationsRepository extends _MockEarnRepositoryBase
    implements StakingNotificationsRepository {
  const MockStakingNotificationsRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingNotificationsSnapshot> getNotifications() async {
    await _simulateNetwork();
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
