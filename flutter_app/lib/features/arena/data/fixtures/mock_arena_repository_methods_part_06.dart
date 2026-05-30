part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart06 on _MockArenaRepositoryBase {
  @override
  ArenaSafetyCenterSnapshot getArenaSafetyCenter() {
    return const ArenaSafetyCenterSnapshot(
      endpoint: '/api/mobile/arena/arena-safety',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      bannerTitle: 'Open Arena cam kết an toàn',
      bannerDescription:
          'Chúng tôi xây dựng môi trường lành mạnh, minh bạch và công bằng cho mọi người chơi.',
      communityRules: [
        ArenaSafetyRuleDraft(
          title: 'Tôn trọng kết quả',
          description: 'Không thao túng, gian lận hoặc từ chối kết quả hợp lệ.',
          kind: ArenaSafetyKind.respect,
        ),
        ArenaSafetyRuleDraft(
          title: 'Không giao dịch ngoài nền tảng',
          description: 'Mọi thỏa thuận phải diễn ra trong Open Arena.',
          kind: ArenaSafetyKind.offPlatform,
        ),
        ArenaSafetyRuleDraft(
          title: 'Ngôn ngữ văn minh',
          description:
              'Không xúc phạm, đe dọa, phân biệt đối xử người chơi khác.',
          kind: ArenaSafetyKind.civil,
        ),
        ArenaSafetyRuleDraft(
          title: 'Bảo vệ thông tin cá nhân',
          description:
              'Không chia sẻ thông tin nhạy cảm trong chat hoặc challenge.',
          kind: ArenaSafetyKind.privacy,
        ),
      ],
      bannedContent: [
        'Spam, quảng cáo, link lạ',
        'Nội dung lừa đảo hoặc scam',
        'Thao túng kết quả challenge',
        'Ngôn ngữ thù ghét, đe dọa',
        'Mạo danh người dùng khác',
        'Giao dịch tiền thật / tài sản ngoài Arena',
      ],
      reportActions: [
        ArenaSafetyRuleDraft(
          title: 'Báo cáo vi phạm',
          description:
              'Nhấn nút "Báo cáo" trên profile người dùng, challenge hoặc mode. Chọn lý do và gửi. Đội ngũ sẽ xem xét trong 24 - 48h.',
          kind: ArenaSafetyKind.report,
        ),
        ArenaSafetyRuleDraft(
          title: 'Chặn người dùng',
          description:
              'Nhấn "Chặn" trên profile người dùng. Sau khi chặn, bạn sẽ không thấy challenge hoặc tin nhắn từ người này. Có thể bỏ chặn bất cứ lúc nào.',
          kind: ArenaSafetyKind.block,
        ),
      ],
      violationProcess: [
        ArenaSafetyProcessDraft(
          step: 1,
          title: 'Gửi báo cáo',
          description:
              'Nhấn "Báo cáo" trên profile hoặc challenge và chọn lý do.',
        ),
        ArenaSafetyProcessDraft(
          step: 2,
          title: 'Tiếp nhận',
          description: 'Hệ thống xác nhận và ghi nhận báo cáo ngay lập tức.',
        ),
        ArenaSafetyProcessDraft(
          step: 3,
          title: 'Xem xét',
          description: 'Đội ngũ kiểm duyệt xem xét bằng chứng trong 24 - 48h.',
        ),
        ArenaSafetyProcessDraft(
          step: 4,
          title: 'Kết luận',
          description:
              'Thông báo kết quả qua mục "Báo cáo & chặn" trong profile.',
        ),
      ],
      resolution: ArenaSafetyInfoDraft(
        title: 'Kết quả challenge được chốt minh bạch',
        description:
            'Mỗi challenge có phương thức chốt riêng. Bạn luôn biết trước cách xác định kết quả.',
        kind: ArenaSafetyKind.resolution,
        items: [
          ArenaSafetyCheckDraft(
            text:
                'Bình chọn cộng đồng - Người tham gia bỏ phiếu. Kết quả theo đa số.',
            allowed: true,
          ),
          ArenaSafetyCheckDraft(
            text:
                'Trọng tài (Referee) - Một người được chỉ định xem xét bằng chứng và quyết định.',
            allowed: true,
          ),
          ArenaSafetyCheckDraft(
            text:
                'Tự động (Auto) - Hệ thống tự chốt dựa trên dữ liệu từ nguồn đáng tin cậy.',
            allowed: true,
          ),
        ],
      ),
      offPlatform: ArenaSafetyInfoDraft(
        title: 'Mọi thỏa thuận trong Arena',
        description:
            'Không trao đổi tiền thật, crypto hoặc tài sản ngoài Arena. Mọi challenge chỉ sử dụng Arena Points.',
        kind: ArenaSafetyKind.offPlatform,
        items: [
          ArenaSafetyCheckDraft(
            text: 'Không chuyển khoản ngân hàng cho challenge',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Không đổi Arena Points lấy tiền thật',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Báo cáo nếu bị dụ giao dịch ngoài',
            allowed: true,
          ),
        ],
      ),
      pointsDisclaimer: ArenaSafetyInfoDraft(
        title: 'Arena Points chỉ dùng trong Open Arena',
        description:
            'Arena Points là phần thưởng hoạt động, không phải tài sản tài chính, không có giá trị tiền tệ và không thể rút ra ngoài nền tảng.',
        kind: ArenaSafetyKind.points,
        items: [
          ArenaSafetyCheckDraft(
            text: 'Không mua bán Arena Points',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Không đổi sang tiền thật hoặc crypto',
            allowed: false,
          ),
          ArenaSafetyCheckDraft(
            text: 'Dùng để tham gia challenges và nhận thưởng',
            allowed: true,
          ),
          ArenaSafetyCheckDraft(
            text: 'Nhận miễn phí qua nhiệm vụ hằng ngày',
            allowed: true,
          ),
        ],
      ),
      quickLinks: [
        ArenaSafetyQuickLinkDraft(
          title: 'Danh sách người đã chặn',
          route: '/arena/blocked',
          kind: ArenaSafetyKind.block,
        ),
        ArenaSafetyQuickLinkDraft(
          title: 'Xem báo cáo của tôi',
          route: '/arena/my-reports',
          kind: ArenaSafetyKind.report,
        ),
      ],
      ctaLabel: 'Đã hiểu',
      footerLabel: 'Quy tắc cộng đồng',
      disclaimer:
          'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL. Không giao dịch ngoài nền tảng.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaBlockedUsersSnapshot getArenaBlockedUsers() {
    return const ArenaBlockedUsersSnapshot(
      endpoint: '/api/mobile/arena/arena-blocked',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      bannerTitle: 'Về tính năng chặn',
      bannerDescription:
          'Người bị chặn sẽ không thể thấy hoặc tương tác với bạn trong Open Arena. Bạn có thể bỏ chặn bất cứ lúc nào.',
      users: [
        ArenaBlockedUserDraft(
          id: 'blk001',
          name: 'SpamBot_X',
          reason: 'Spam tin nhắn quảng cáo trong chat',
          blockedAt: '2026-02-26',
          source: ArenaBlockedUserSource.manual,
        ),
        ArenaBlockedUserDraft(
          id: 'blk002',
          name: 'ToxicTrader',
          reason: 'Ngôn ngữ xúc phạm nghiêm trọng',
          blockedAt: '2026-02-15',
          source: ArenaBlockedUserSource.reportOutcome,
        ),
      ],
      emptyTitle: 'Chưa chặn ai',
      emptySubtitle:
          'Bạn chưa chặn người dùng nào trong Open Arena. Khi chặn, họ sẽ xuất hiện ở đây.',
      disclaimer:
          'Danh sách chặn chỉ áp dụng trong Open Arena. Đây là bề mặt điểm xã hội, không phải ví giao dịch hoặc PnL.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaTrustBreakdownSnapshot getArenaTrustBreakdown(String entityId) {
    if (entityId != 'cr001') {
      return ArenaTrustBreakdownSnapshot(
        endpoint: '/api/mobile/arena/arena-trust-$entityId',
        actionDraft:
            'POST /arena/challenges|join|resolve|report where applicable',
        entityId: entityId,
        creator: null,
        metrics: const [],
        emptyTitle: 'Không tìm thấy',
        emptySubtitle: 'Creator không tồn tại',
        safetyTitle: 'Trust Score giúp bạn đánh giá',
        safetyDescription:
            'Kiểm tra trust score trước khi tham gia challenge giúp đảm bảo trải nghiệm an toàn.',
        disclaimer:
            'Trust Score chỉ là chỉ báo cộng đồng trong Open Arena, không phải PnL hoặc giá trị ví.',
        supportedStates: const {
          ArenaScreenState.loading,
          ArenaScreenState.empty,
          ArenaScreenState.error,
          ArenaScreenState.offline,
        },
      );
    }

    final profile = getArenaCreator(entityId);
    return ArenaTrustBreakdownSnapshot(
      endpoint: '/api/mobile/arena/arena-trust-$entityId',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      entityId: entityId,
      creator: profile.creator,
      metrics: profile.trustMetrics,
      emptyTitle: 'Không tìm thấy',
      emptySubtitle: 'Creator không tồn tại',
      safetyTitle: 'Trust Score giúp bạn đánh giá',
      safetyDescription:
          'Kiểm tra trust score trước khi tham gia challenge giúp đảm bảo trải nghiệm an toàn.',
      disclaimer:
          'Trust Score chỉ là chỉ báo cộng đồng trong Open Arena, không phải PnL hoặc giá trị ví.',
      supportedStates: const {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  ArenaPointsLedgerSnapshot getArenaPointsLedger() {
    return const ArenaPointsLedgerSnapshot(
      endpoint: '/api/mobile/arena/arena-ledger',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      summary: ArenaPointsLedgerSummaryDraft(
        currentBalance: 2220,
        pointsEarned: 4520,
        pointsSpent: 2300,
      ),
      filters: [
        ArenaPointsLedgerFilterDraft(id: 'all', label: 'Tất cả'),
        ArenaPointsLedgerFilterDraft(id: 'earned', label: 'Nhận'),
        ArenaPointsLedgerFilterDraft(id: 'spent', label: 'Chi'),
        ArenaPointsLedgerFilterDraft(id: 'entry', label: 'Tham gia'),
        ArenaPointsLedgerFilterDraft(id: 'settlement', label: 'Kết toán'),
        ArenaPointsLedgerFilterDraft(id: 'refund', label: 'Hoàn điểm'),
        ArenaPointsLedgerFilterDraft(id: 'adjustment', label: 'Điều chỉnh'),
      ],
      entries: [
        ArenaPointsLedgerEntryDraft(
          id: 'le001',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 30,
          balanceBefore: 2190,
          balanceAfter: 2220,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '28/02 08:00',
          reasonCode: 'DAILY_CHECKIN',
          title: 'Check-in ngày 5',
          refId: 'REF-D20260228-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le002',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 50,
          balanceBefore: 2140,
          balanceAfter: 2190,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '27/02 23:59',
          reasonCode: 'TRADE_VOLUME',
          title: 'Đạt \$500 khối lượng Spot',
          refId: 'REF-V20260227-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le003',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -100,
          balanceBefore: 2240,
          balanceAfter: 2140,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '27/02 14:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'BTC \$70K? — Tuần 9',
          refId: 'REF-E20260227-001',
          linkedChallengeId: 'ch001',
          linkedChallengeName: 'BTC \$70K? — Tuần 9',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le004',
          typeId: 'settlement',
          typeLabel: 'Kết toán',
          amount: 800,
          balanceBefore: 1440,
          balanceAfter: 2240,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '26/02 00:01',
          reasonCode: 'CHALLENGE_WIN',
          title: 'Crypto Quiz Night #11',
          refId: 'REF-S20260226-001',
          linkedChallengeId: 'ch005',
          linkedChallengeName: 'Crypto Quiz Night #11',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le005',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 25,
          balanceBefore: 1415,
          balanceAfter: 1440,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '26/02 08:00',
          reasonCode: 'DAILY_CHECKIN',
          title: 'Check-in ngày 4',
          refId: 'REF-D20260226-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le006',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -200,
          balanceBefore: 1615,
          balanceAfter: 1415,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '25/02 10:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'SOL vs AVAX Battle',
          refId: 'REF-E20260225-001',
          linkedChallengeId: 'ch003',
          linkedChallengeName: 'SOL vs AVAX Battle',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le007',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 40,
          balanceBefore: 1575,
          balanceAfter: 1615,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '25/02 16:30',
          reasonCode: 'P2P_TASK',
          title: 'Giao dịch P2P hoàn tất',
          refId: 'REF-P20260225-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le008',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 100,
          balanceBefore: 1475,
          balanceAfter: 1575,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '24/02 12:00',
          reasonCode: 'REFERRAL',
          title: 'Mời bạn ArenaNewbie',
          refId: 'REF-R20260224-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le009',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 20,
          balanceBefore: 1455,
          balanceAfter: 1475,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '24/02 08:00',
          reasonCode: 'DAILY_CHECKIN',
          title: 'Check-in ngày 3',
          refId: 'REF-D20260224-001',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le010',
          typeId: 'earned',
          typeLabel: 'Nhận',
          amount: 200,
          balanceBefore: 1255,
          balanceAfter: 1455,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '23/02 18:00',
          reasonCode: 'MODE_MILESTONE',
          title: 'Mode đạt 5 clone',
          refId: 'REF-M20260223-001',
          linkedModeId: 'mode001',
          linkedModeName: 'BTC Weekly Predict',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le011',
          typeId: 'refund',
          typeLabel: 'Hoàn điểm',
          amount: 80,
          balanceBefore: 1175,
          balanceAfter: 1255,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '22/02 12:00',
          reasonCode: 'CHALLENGE_CANCEL',
          title: 'Hoàn 100% — không đủ người tham gia',
          refId: 'REF-RF20260222-001',
          linkedChallengeId: 'ch007',
          linkedChallengeName: 'NFT Floor Price Guess (đã hủy)',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le012',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -80,
          balanceBefore: 1255,
          balanceAfter: 1175,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '20/02 09:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'NFT Floor Price Guess',
          refId: 'REF-E20260220-001',
          linkedChallengeId: 'ch007',
          linkedChallengeName: 'NFT Floor Price Guess',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le013',
          typeId: 'adjustment',
          typeLabel: 'Điều chỉnh',
          amount: 50,
          balanceBefore: 1205,
          balanceAfter: 1255,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '19/02 10:00',
          reasonCode: 'ADMIN_ADJUST',
          title: 'Điều chỉnh hệ thống — bù lỗi kỹ thuật',
          refId: 'REF-A20260219-001',
          linkedChallengeId: 'ch002',
          linkedChallengeName: 'ETH Merge Predict #3',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le014',
          typeId: 'settlement',
          typeLabel: 'Kết toán',
          amount: 0,
          balanceBefore: 1205,
          balanceAfter: 1205,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '18/02 22:00',
          reasonCode: 'CHALLENGE_LOSS',
          title: 'Không thắng — entry points đã trừ trước',
          refId: 'REF-S20260218-001',
          linkedChallengeId: 'ch002',
          linkedChallengeName: 'ETH Merge Predict #3',
        ),
        ArenaPointsLedgerEntryDraft(
          id: 'le015',
          typeId: 'entry',
          typeLabel: 'Tham gia',
          amount: -50,
          balanceBefore: 1255,
          balanceAfter: 1205,
          statusLabel: 'Hoàn tất',
          statusKind: ArenaPointsEntryStatus.completed,
          time: '15/02 14:00',
          reasonCode: 'CHALLENGE_ENTRY',
          title: 'Fed Rate Predict — March',
          refId: 'REF-E20260215-001',
          linkedChallengeId: 'ch004',
          linkedChallengeName: 'Fed Rate Predict — March',
        ),
      ],
      emptyTitle: 'Không tìm thấy bản ghi',
      emptySubtitle: 'Thử đổi bộ lọc hoặc từ khóa tìm kiếm.',
      disclaimer:
          'Mọi thay đổi Arena Points đều được ghi lại với mã tham chiếu duy nhất. Arena Points không phải tài sản tài chính và không có giá trị tiền tệ.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
