part of '../repositories/mock_earn_repository.dart';

final class MockSavingsGuideRepository extends _MockEarnRepositoryBase
    implements SavingsGuideRepository {
  const MockSavingsGuideRepository({super.simulateError, super.loadDelay});

  @override
  Future<SavingsGuideSnapshot> getGuide() async {
    await _simulateNetwork();
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

final class MockSavingsFAQRepository extends _MockEarnRepositoryBase
    implements SavingsFAQRepository {
  const MockSavingsFAQRepository({super.simulateError, super.loadDelay});

  @override
  Future<SavingsFAQSnapshot> getFAQ() async {
    await _simulateNetwork();
    return SavingsFAQSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-faq',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'FAQ Tiết kiệm',
      backRoute: '/earn/savings',
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.staking,
        referenceId: 'savings-faq',
        sourceRoute: '/earn/savings/faq',
        issueLabel: 'Savings FAQ support',
      ),
      heroTitle: 'Câu hỏi thường gặp',
      heroSubtitle:
          'Tìm câu trả lời cho các thắc mắc phổ biến về Tiết kiệm Crypto. Không tìm thấy? Liên hệ hỗ trợ bất kỳ lúc nào.',
      searchPlaceholder: 'Tìm câu hỏi...',
      categories: const [
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
      items: const [
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
      supportedStates: const {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
