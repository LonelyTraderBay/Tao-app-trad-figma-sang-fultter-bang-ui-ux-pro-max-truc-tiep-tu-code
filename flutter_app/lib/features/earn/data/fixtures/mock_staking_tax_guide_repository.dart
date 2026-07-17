part of '../repositories/mock_earn_repository.dart';

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
