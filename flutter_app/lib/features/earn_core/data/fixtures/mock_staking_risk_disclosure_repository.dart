part of '../repositories/mock_earn_repository.dart';

final class MockStakingRiskDisclosureRepository extends _MockEarnRepositoryBase
    implements StakingRiskDisclosureRepository {
  const MockStakingRiskDisclosureRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingRiskDisclosureSnapshot> getDisclosure() async {
    await _simulateNetwork();
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
    extends _MockEarnRepositoryBase
    implements StakingWithdrawalPolicyRepository {
  const MockStakingWithdrawalPolicyRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingWithdrawalPolicySnapshot> getPolicy() async {
    await _simulateNetwork();
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
