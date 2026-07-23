part of '../repositories/mock_earn_repository.dart';

final class MockSavingsWhatIfRepository extends _MockEarnRepositoryBase
    implements SavingsWhatIfRepository {
  const MockSavingsWhatIfRepository({super.simulateError, super.loadDelay});

  @override
  Future<SavingsWhatIfSnapshot> getWhatIf() async {
    await _simulateNetwork();
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

final class MockStakingTermsRepository extends _MockEarnRepositoryBase
    implements StakingTermsRepository {
  const MockStakingTermsRepository({super.simulateError, super.loadDelay});

  @override
  Future<StakingTermsSnapshot> getTerms() async {
    await _simulateNetwork();
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
