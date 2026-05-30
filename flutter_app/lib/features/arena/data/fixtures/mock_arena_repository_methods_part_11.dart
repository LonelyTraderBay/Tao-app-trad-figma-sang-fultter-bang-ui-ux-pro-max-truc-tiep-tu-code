part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart11 on _MockArenaRepositoryBase {
  @override
  ArenaGuideSnapshot getArenaGuide() {
    return const ArenaGuideSnapshot(
      endpoint: '/api/mobile/arena/arena-guide',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      heroTitle: 'Tạo challenge đầu tiên trong 5 phút',
      heroSubtitle:
          'Chỉ 6 bước đơn giản - có gợi ý thông minh giúp bạn tạo challenge hấp dẫn',
      createSteps: [
        ArenaGuideStepDraft(
          step: 1,
          iconKey: 'layers',
          title: 'Chọn Template',
          description:
              'Chọn template phù hợp: Dự đoán, Thử thách, Cá cược bạn bè. Mỗi template có luật và cấu trúc sẵn giúp bạn bắt đầu nhanh.',
          tip: 'Bắt đầu với "Dự đoán giá" - đơn giản và phổ biến nhất.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideStepDraft(
          step: 2,
          iconKey: 'users',
          title: 'Thiết lập cấu trúc',
          description:
              'Chọn format: 1v1, team vs team hoặc Open Lobby. Cài đặt số người tham gia tối đa và kiểu tham gia.',
          tip: 'Open Lobby phù hợp khi bạn muốn nhiều người tham gia.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideStepDraft(
          step: 3,
          iconKey: 'file',
          title: 'Viết luật chơi',
          description:
              'Đặt tên, mô tả rõ ràng, chọn điều kiện thắng, luật hòa và luật hủy. Luật càng rõ - tranh chấp càng ít.',
          tip: 'Dùng Smart Rule Builder để tạo luật chuyên nghiệp tự động.',
          tone: ArenaGuideTone.success,
        ),
        ArenaGuideStepDraft(
          step: 4,
          iconKey: 'target',
          title: 'Chọn cách xác nhận kết quả',
          description:
              'Auto, Mutual Confirm, Referee hoặc Community Vote. Chọn phương án phù hợp với loại challenge.',
          tip: 'Auto resolution ít tranh chấp nhất - ưu tiên khi có thể.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideStepDraft(
          step: 5,
          iconKey: 'gift',
          title: 'Cài đặt Points & Phần thưởng',
          description:
              'Đặt entry points, chọn kiểu chia pool điểm như Winner All, Top 3 hoặc chia đều. Xem trước pool dự kiến.',
          tip: 'Entry 50-200 pts thu hút nhiều người nhất theo thống kê.',
          tone: ArenaGuideTone.danger,
        ),
        ArenaGuideStepDraft(
          step: 6,
          iconKey: 'check',
          title: 'Review & Đăng',
          description:
              'Kiểm tra toàn bộ thông tin, preview trước khi publish. Hệ thống sẽ kiểm tra Rule Clarity Score và đưa gợi ý.',
          tip: 'Rule Clarity Score >= 80% - challenge ít bị tranh chấp.',
          tone: ArenaGuideTone.arena,
        ),
      ],
      joinSteps: [
        ArenaGuideStepDraft(
          step: 1,
          iconKey: 'search',
          title: 'Tìm challenge phù hợp',
          description:
              'Duyệt phòng đang mở, lọc theo category, format, entry points hoặc tìm kiếm theo tên.',
          tip: 'Lọc theo Fair Play để chơi an toàn hơn.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideStepDraft(
          step: 2,
          iconKey: 'eye',
          title: 'Xem chi tiết & luật chơi',
          description:
              'Đọc kỹ luật, điều kiện thắng và cách xác nhận kết quả. Kiểm tra Trust Score của creator.',
          tip: 'Creator có Trust >= 85% thường tạo challenge chất lượng.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideStepDraft(
          step: 3,
          iconKey: 'zap',
          title: 'Tham gia bằng Arena Points',
          description:
              'Xác nhận entry points và chọn vị trí hoặc đội nếu có. Points được khóa trong pool đến khi có kết quả.',
          tip: 'Points được khóa an toàn - không ai rút trước kết quả.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideStepDraft(
          step: 4,
          iconKey: 'trophy',
          title: 'Chờ kết quả & nhận points',
          description:
              'Kết quả tự xác nhận hoặc cần vote. Nếu thắng, Arena Points được cộng theo luật pool đã công bố.',
          tip: 'Theo dõi timeline trực tiếp trên trang challenge.',
          tone: ArenaGuideTone.success,
        ),
      ],
      proTips: [
        ArenaGuideTipDraft(
          iconKey: 'target',
          title: 'Đặt tên hấp dẫn, rõ ràng',
          description:
              'Tên tốt: "BTC phá 100K trước 30/6?" - ngắn, rõ chủ đề, có deadline. Tránh tiêu đề mơ hồ.',
          category: 'naming',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'file',
          title: 'Viết luật chơi chi tiết',
          description:
              'Nêu rõ nguồn dữ liệu, điều kiện thắng, cách xử lý hòa hoặc hủy. Smart Rule Builder giúp chuẩn hóa luật.',
          category: 'rules',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'points',
          title: 'Entry points vừa phải',
          description:
              'Entry 50-200 pts thu hút nhiều người và giảm áp lực cho người mới. Entry cao chỉ nên dùng khi creator đã có uy tín.',
          category: 'points',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'clock',
          title: 'Thời hạn hợp lý',
          description:
              'Challenge 1-7 ngày hoạt động tốt nhất. Quá ngắn thì ít người kịp join, quá dài thì giảm hứng thú.',
          category: 'timing',
          impact: ArenaGuideImpact.medium,
        ),
        ArenaGuideTipDraft(
          iconKey: 'tag',
          title: 'Gắn tag đúng category',
          description:
              'Tag chính xác giúp challenge xuất hiện đúng đối tượng. Crypto, Sports, Tech - chọn theo nội dung.',
          category: 'discovery',
          impact: ArenaGuideImpact.medium,
        ),
        ArenaGuideTipDraft(
          iconKey: 'shield',
          title: 'Bật Fair Play badge',
          description:
              'Lưu challenge thành Mode và xây dựng Trust Score. Badge giúp người tham gia hiểu tiêu chuẩn an toàn.',
          category: 'trust',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'auto',
          title: 'Ưu tiên Auto Resolution',
          description:
              'Kết quả tự động giúp giảm tranh chấp. Dùng nguồn dữ liệu uy tín nếu loại challenge cho phép.',
          category: 'resolution',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'trophy',
          title: 'Phân thưởng dễ hiểu',
          description:
              'Top 3 hoặc Top 5 phù hợp khi có nhiều người. Winner Takes All chỉ nên dùng cho 1v1 hoặc nhóm nhỏ.',
          category: 'rewards',
          impact: ArenaGuideImpact.medium,
        ),
      ],
      safetyTips: [
        ArenaGuideSafetyTipDraft(
          iconKey: 'shield',
          title: 'Points, không phải tiền thật',
          description:
              'Arena chỉ dùng Arena Points - không liên quan đến tài sản crypto hay fiat.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'lock',
          title: 'Pool điểm được khóa an toàn',
          description:
              'Entry points được khóa trong pool đến khi challenge kết thúc và có kết quả. Creator không thể rút riêng.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'warning',
          title: 'Đọc kỹ luật trước khi join',
          description:
              'Luôn đọc hết luật chơi, điều kiện thắng thua và cách xác nhận kết quả trước khi tham gia.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'eye',
          title: 'Kiểm tra Trust Score creator',
          description:
              'Ưu tiên challenge từ creator có Trust Score cao và Fair Play badge. Xem lịch sử tranh chấp khi cần.',
          tone: ArenaGuideTone.success,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'report',
          title: 'Báo cáo nếu nghi ngờ',
          description:
              'Thấy challenge bất thường? Báo cáo để đội ngũ kiểm tra trong 24h và bảo vệ cộng đồng.',
          tone: ArenaGuideTone.danger,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'file',
          title: 'Tranh chấp có quy trình rõ ràng',
          description:
              'Resolution Center cho phép gửi bằng chứng, theo dõi timeline và nhận kết luận minh bạch.',
          tone: ArenaGuideTone.arena,
        ),
      ],
      faqs: [
        ArenaGuideFaqDraft(
          question: 'Arena Points là gì?',
          answer:
              'Arena Points là đơn vị dùng trong Open Arena để tham gia challenge. Points không phải tiền thật và không liên quan đến crypto hoặc fiat.',
        ),
        ArenaGuideFaqDraft(
          question: 'Tạo challenge có mất phí không?',
          answer:
              'Không mất phí tạo. Nếu đặt entry points, creator có thể cần góp points vào pool theo cấu hình đã công bố.',
        ),
        ArenaGuideFaqDraft(
          question: 'Làm sao để challenge thu hút nhiều người?',
          answer:
              'Đặt tên rõ, entry points vừa phải, luật minh bạch, ưu tiên Auto Resolution và chia sẻ link đúng cộng đồng.',
        ),
        ArenaGuideFaqDraft(
          question: 'Kết quả được xác nhận như thế nào?',
          answer:
              'Có 4 cách: Auto, Mutual Confirm, Referee hoặc Community Vote. Auto thường ít tranh chấp nhất khi có nguồn dữ liệu phù hợp.',
        ),
        ArenaGuideFaqDraft(
          question: 'Nếu tôi không đồng ý kết quả thì sao?',
          answer:
              'Bạn có thể mở tranh chấp trong Resolution Center, gửi bằng chứng và theo dõi quy trình xử lý minh bạch.',
        ),
        ArenaGuideFaqDraft(
          question: 'Rule Clarity Score là gì?',
          answer:
              'Điểm đánh giá mức rõ ràng của luật chơi từ 0-100%. Score cao giúp giảm tranh chấp và tăng độ tin cậy.',
        ),
      ],
      examples: [
        ArenaGuideExampleDraft(
          title: 'BTC phá 100K trước 30/6?',
          template: 'Dự đoán giá',
          entryPoints: 100,
          format: 'Open Lobby',
          resolution: 'Auto',
          rating: 'Tốt',
          tone: ArenaGuideTone.success,
          reasons: [
            'Tên rõ ràng, có deadline',
            'Entry vừa phải',
            'Auto resolution',
          ],
        ),
        ArenaGuideExampleDraft(
          title: 'Ai đoán đúng?',
          template: 'Dự đoán',
          entryPoints: 500,
          format: '1v1',
          resolution: 'Mutual',
          rating: 'Cần cải thiện',
          tone: ArenaGuideTone.warning,
          reasons: [
            'Tên mơ hồ, thiếu chủ đề',
            'Entry cao cho beginner',
            'Thiếu mô tả chi tiết',
          ],
        ),
      ],
      keyConcepts: [
        ArenaGuideConceptDraft(
          term: 'Arena Points',
          definition:
              'Đơn vị dùng trong Open Arena để tham gia challenge. Không phải tiền thật.',
        ),
        ArenaGuideConceptDraft(
          term: 'Template',
          definition:
              'Mẫu challenge có sẵn cấu trúc và luật - bạn chỉ cần điền nội dung.',
        ),
        ArenaGuideConceptDraft(
          term: 'Mode',
          definition:
              'Challenge template đã hoàn chỉnh, có thể chia sẻ và clone bởi người khác.',
        ),
        ArenaGuideConceptDraft(
          term: 'Resolution',
          definition:
              'Cách xác nhận kết quả: Auto, Mutual, Referee hoặc Community Vote.',
        ),
        ArenaGuideConceptDraft(
          term: 'Trust Score',
          definition:
              'Điểm uy tín của creator dựa trên lịch sử tạo challenge và tỷ lệ tranh chấp.',
        ),
        ArenaGuideConceptDraft(
          term: 'Rule Clarity',
          definition:
              'Điểm rõ ràng của luật chơi. Càng cao càng ít tranh chấp.',
        ),
        ArenaGuideConceptDraft(
          term: 'Fair Play',
          definition:
              'Huy hiệu cho challenge hoặc creator tuân thủ quy tắc cộng đồng.',
        ),
      ],
      checklist: [
        'Tên challenge rõ ràng, có chủ đề và deadline',
        'Mô tả đầy đủ điều kiện thắng/thua',
        'Entry points phù hợp đối tượng (50-200 pts)',
        'Chọn Resolution method, ưu tiên Auto khi có thể',
        'Kiểm tra Rule Clarity Score >= 80%',
        'Thiết lập luật hòa và luật hủy',
        'Preview và đọc lại toàn bộ trước khi đăng',
      ],
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
