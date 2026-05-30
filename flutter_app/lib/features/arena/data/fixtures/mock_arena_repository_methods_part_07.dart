part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart07 on _MockArenaRepositoryBase {
  @override
  ArenaPointsEntryDetailSnapshot getArenaPointsEntryDetail(String entryId) {
    for (final ledgerEntry in getArenaPointsLedger().entries) {
      if (ledgerEntry.id != entryId) continue;

      return ArenaPointsEntryDetailSnapshot(
        endpoint: '/api/mobile/arena/arena-ledger-entry-$entryId',
        actionDraft:
            'POST /arena/challenges|join|resolve|report where applicable',
        entryId: entryId,
        entry: ArenaPointsEntryDraft(
          id: ledgerEntry.id,
          amount: ledgerEntry.amount,
          typeLabel: ledgerEntry.typeLabel,
          typeKind: _ledgerEntryKind(ledgerEntry.typeId),
          statusLabel: ledgerEntry.statusLabel,
          statusKind: ledgerEntry.statusKind,
          note: ledgerEntry.title,
          reasonCode: ledgerEntry.reasonCode,
          time: ledgerEntry.time,
          balanceBefore: ledgerEntry.balanceBefore,
          balanceAfter: ledgerEntry.balanceAfter,
          refId: ledgerEntry.refId,
          linkedChallengeId: ledgerEntry.linkedChallengeId,
          linkedChallengeName: ledgerEntry.linkedChallengeName,
          linkedModeId: ledgerEntry.linkedModeId,
          linkedModeName: ledgerEntry.linkedModeName,
        ),
        emptyTitle: 'Không tìm thấy',
        emptySubtitle: 'Giao dịch điểm không tồn tại',
        disclaimer:
            'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL.',
        supportedStates: const {
          ArenaScreenState.loading,
          ArenaScreenState.empty,
          ArenaScreenState.error,
          ArenaScreenState.offline,
        },
      );
    }

    if (entryId != 'entry-demo') {
      return ArenaPointsEntryDetailSnapshot(
        endpoint: '/api/mobile/arena/arena-ledger-entry-$entryId',
        actionDraft:
            'POST /arena/challenges|join|resolve|report where applicable',
        entryId: entryId,
        entry: null,
        emptyTitle: 'Không tìm thấy',
        emptySubtitle: 'Giao dịch điểm không tồn tại',
        disclaimer:
            'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL.',
        supportedStates: const {
          ArenaScreenState.loading,
          ArenaScreenState.empty,
          ArenaScreenState.error,
          ArenaScreenState.offline,
        },
      );
    }

    return const ArenaPointsEntryDetailSnapshot(
      endpoint: '/api/mobile/arena/arena-ledger-entry-entry-demo',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      entryId: 'entry-demo',
      entry: ArenaPointsEntryDraft(
        id: 'entry-demo',
        amount: 240,
        typeLabel: 'Challenge reward',
        typeKind: ArenaPointsEntryKind.reward,
        statusLabel: 'Hoàn tất',
        statusKind: ArenaPointsEntryStatus.completed,
        note: 'Thưởng hoàn thành challenge BTC Weekly Predict',
        reasonCode: 'CHALLENGE_REWARD',
        time: '23/05/2026 · 21:18',
        balanceBefore: 1980,
        balanceAfter: 2220,
        refId: 'ARENA-LEDGER-20260523-ENTRY-DEMO',
        linkedChallengeId: 'ch003',
        linkedChallengeName: 'BTC \$70K? - Tuần 9',
        linkedModeId: 'mode001',
        linkedModeName: 'BTC Weekly Predict',
      ),
      emptyTitle: 'Không tìm thấy',
      emptySubtitle: 'Giao dịch điểm không tồn tại',
      disclaimer:
          'Arena Points chỉ dùng trong Open Arena, không phải ví giao dịch hoặc PnL.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  ArenaPointsEntryKind _ledgerEntryKind(String typeId) {
    return switch (typeId) {
      'entry' || 'spent' => ArenaPointsEntryKind.spend,
      'refund' => ArenaPointsEntryKind.refund,
      'adjustment' => ArenaPointsEntryKind.adjustment,
      _ => ArenaPointsEntryKind.reward,
    };
  }

  @override
  ArenaReportCaseSnapshot getArenaReportCase(String caseId) {
    final reports = _arenaReportCases;
    ArenaReportCaseDraft? reportCase;
    for (final report in reports) {
      if (report.id == caseId) {
        reportCase = report;
        break;
      }
    }

    return ArenaReportCaseSnapshot(
      endpoint: '/api/mobile/arena/arena-report-$caseId',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable; POST /exports',
      caseId: caseId,
      reportCase: reportCase,
      relatedReports: reports
          .where((report) => report.id != caseId)
          .take(2)
          .toList(growable: false),
      emptyTitle: 'Không tìm thấy',
      emptySubtitle: 'Báo cáo không tồn tại',
      disclaimer:
          'Báo cáo Open Arena chỉ áp dụng cho bề mặt điểm xã hội. Arena Points không có giá trị tiền tệ, không phải ví giao dịch hoặc PnL.',
      supportedStates: const {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  MyArenaReportsSnapshot getMyArenaReports() {
    const reports = _arenaReportCases;
    final submitted = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.submitted,
    );
    final underReview = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.underReview,
    );
    final actionTaken = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.actionTaken,
    );
    final closed = _reportStatusCount(reports, ArenaReportCaseStatus.closed);
    final appealOpen = _reportStatusCount(
      reports,
      ArenaReportCaseStatus.appealOpen,
    );

    return MyArenaReportsSnapshot(
      endpoint: '/api/mobile/arena/arena-my-reports',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable; POST /exports',
      summary: MyArenaReportsSummaryDraft(
        total: reports.length,
        inReview: submitted + underReview,
        resolved: actionTaken + closed,
      ),
      filters: [
        MyArenaReportsFilterDraft(
          id: 'all',
          label: 'Tất cả',
          count: reports.length,
        ),
        MyArenaReportsFilterDraft(
          id: 'submitted',
          label: 'Đã gửi',
          count: submitted,
          status: ArenaReportCaseStatus.submitted,
        ),
        MyArenaReportsFilterDraft(
          id: 'under_review',
          label: 'Đang xem xét',
          count: underReview,
          status: ArenaReportCaseStatus.underReview,
        ),
        MyArenaReportsFilterDraft(
          id: 'action_taken',
          label: 'Đã xử lý',
          count: actionTaken,
          status: ArenaReportCaseStatus.actionTaken,
        ),
        MyArenaReportsFilterDraft(
          id: 'closed',
          label: 'Đã đóng',
          count: closed,
          status: ArenaReportCaseStatus.closed,
        ),
        MyArenaReportsFilterDraft(
          id: 'appeal_open',
          label: 'Khiếu nại',
          count: appealOpen,
          status: ArenaReportCaseStatus.appealOpen,
        ),
      ],
      reports: reports,
      bannerTitle: 'Về quy trình xử lý',
      bannerDescription:
          'Mỗi báo cáo được đội ngũ xem xét trong 24-72h. Bạn có thể theo dõi tiến trình ở đây.',
      emptyTitle: 'Chưa có báo cáo',
      emptySubtitle: 'Bạn chưa gửi báo cáo vi phạm nào trong Open Arena.',
      disclaimer:
          'Báo cáo Open Arena chỉ áp dụng cho bề mặt điểm xã hội. Không sử dụng ví, PnL hoặc giá trị tiền tệ.',
      supportedStates: const {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  static int _reportStatusCount(
    List<ArenaReportCaseDraft> reports,
    ArenaReportCaseStatus status,
  ) {
    return reports.where((report) => report.status == status).length;
  }

  static const List<ArenaReportCaseDraft> _arenaReportCases = [
    ArenaReportCaseDraft(
      id: 'rpt001',
      status: ArenaReportCaseStatus.actionTaken,
      reason: 'Thao túng kết quả',
      targetName: 'GameMaker_HN',
      targetType: ArenaReportTargetType.user,
      targetId: 'cr004',
      createdAt: '2026-02-20 14:30',
      updatedAt: '2026-02-24 10:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '20/02 14:30',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '20/02 14:31',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét bằng chứng',
          date: '21/02 09:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Kết luận: Vi phạm xác nhận',
          date: '24/02 10:00',
          done: true,
        ),
      ],
      actionTaken: 'Tạm khóa tạo challenge 7 ngày. Cảnh cáo lần 1.',
      systemNote:
          'Người dùng đã sử dụng nhiều tài khoản để ảnh hưởng kết quả vote trong challenge ch006.',
      relatedChallengeId: 'ch006',
    ),
    ArenaReportCaseDraft(
      id: 'rpt002',
      status: ArenaReportCaseStatus.underReview,
      reason: 'Spam hoặc quảng cáo',
      targetName: 'SpamBot_X',
      targetType: ArenaReportTargetType.user,
      targetId: 'u_spam01',
      createdAt: '2026-02-26 18:00',
      updatedAt: '2026-02-27 09:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '26/02 18:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '26/02 18:01',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét',
          date: '27/02 09:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(label: 'Kết luận', date: '', done: false),
      ],
      systemNote: 'Đang chờ đội ngũ xem xét nội dung chat.',
    ),
    ArenaReportCaseDraft(
      id: 'rpt003',
      status: ArenaReportCaseStatus.closed,
      reason: 'Ngôn ngữ xúc phạm',
      targetName: 'ToxicTrader',
      targetType: ArenaReportTargetType.user,
      targetId: 'u_toxic01',
      createdAt: '2026-02-10 11:00',
      updatedAt: '2026-02-15 16:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '10/02 11:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '10/02 11:01',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét',
          date: '11/02 08:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Kết luận: Cấm vĩnh viễn',
          date: '15/02 16:00',
          done: true,
        ),
      ],
      actionTaken: 'Tài khoản bị cấm vĩnh viễn khỏi Open Arena.',
      systemNote:
          'Ngôn ngữ xúc phạm nghiêm trọng, lặp lại nhiều lần sau cảnh cáo.',
    ),
    ArenaReportCaseDraft(
      id: 'rpt004',
      status: ArenaReportCaseStatus.appealOpen,
      reason: 'Vi phạm luật chơi',
      targetName: 'ArenaKing',
      targetType: ArenaReportTargetType.challenge,
      targetId: 'ch003',
      createdAt: '2026-02-22 09:00',
      updatedAt: '2026-02-27 14:00',
      timeline: [
        ArenaReportTimelineStepDraft(
          label: 'Bạn đã gửi báo cáo',
          date: '22/02 09:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Hệ thống đã tiếp nhận',
          date: '22/02 09:01',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Đang xem xét',
          date: '23/02 10:00',
          done: true,
        ),
        ArenaReportTimelineStepDraft(
          label: 'Kết luận: Không đủ bằng chứng',
          date: '25/02 11:00',
          done: true,
        ),
      ],
      actionTaken: 'Không có hành động - không đủ bằng chứng.',
      systemNote: 'Bạn đã mở khiếu nại. Đang chờ bổ sung bằng chứng.',
      relatedChallengeId: 'ch003',
    ),
  ];

  @override
  MyArenaSnapshot getMyArena() {
    return const MyArenaSnapshot(
      endpoint: '/api/mobile/profile/profile-arena',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      stats: MyArenaStats(
        currentBalance: 2220,
        pointsEarned: 4520,
        pointsSpent: 2300,
        activeChallenges: 5,
        modesCreated: 2,
        creatorScore: 85,
        rank: 142,
        pendingNotifications: 3,
      ),
      myRooms: [
        ArenaChallengeDraft(
          id: 'ch001',
          title: 'BTC \$70K? - Tuần 9',
          format: 'Closest Guess',
          slotsFilled: 38,
          slotsTotal: 50,
          entryPoints: 100,
          prizePool: 3800,
          state: ArenaChallengeState.open,
        ),
        ArenaChallengeDraft(
          id: 'ch002',
          title: 'ETH Prediction Duel',
          format: 'Closest Guess',
          slotsFilled: 2,
          slotsTotal: 2,
          entryPoints: 200,
          prizePool: 400,
          state: ArenaChallengeState.full,
        ),
        ArenaChallengeDraft(
          id: 'ch003',
          title: 'Altcoin Team Battle - SOL vs AVAX',
          format: 'Team Battle',
          slotsFilled: 40,
          slotsTotal: 40,
          entryPoints: 200,
          prizePool: 7200,
          state: ArenaChallengeState.live,
        ),
      ],
      joinedChallenges: [
        ArenaChallengeDraft(
          id: 'ch003',
          title: 'Altcoin Team Battle - SOL vs AVAX',
          format: 'Team Battle',
          slotsFilled: 40,
          slotsTotal: 40,
          entryPoints: 200,
          prizePool: 7200,
          state: ArenaChallengeState.live,
        ),
        ArenaChallengeDraft(
          id: 'ch004',
          title: 'Fed Rate Predict - March',
          format: 'Prediction',
          slotsFilled: 67,
          slotsTotal: 100,
          entryPoints: 50,
          prizePool: 3350,
          state: ArenaChallengeState.pendingResult,
        ),
        ArenaChallengeDraft(
          id: 'ch001',
          title: 'BTC \$70K? - Tuần 9',
          format: 'Closest Guess',
          slotsFilled: 38,
          slotsTotal: 50,
          entryPoints: 100,
          prizePool: 3800,
          state: ArenaChallengeState.open,
        ),
      ],
      savedModes: [
        ArenaModeDraft(
          id: 'mode001',
          title: 'BTC Weekly Predict',
          creatorName: 'CryptoWhale',
          cloneCount: 124,
          activeChallenges: 18,
          fairPlay: true,
        ),
        ArenaModeDraft(
          id: 'mode002',
          title: 'Altcoin Battle Royale',
          creatorName: 'PredictorPro',
          cloneCount: 86,
          activeChallenges: 9,
          fairPlay: true,
        ),
        ArenaModeDraft(
          id: 'mode004',
          title: 'Crypto Trivia Cup',
          creatorName: 'QuizWizard',
          cloneCount: 51,
          activeChallenges: 6,
          fairPlay: false,
        ),
      ],
      drafts: [
        ArenaDraftChallenge(
          id: 'draft001',
          title: 'SOL vs DOT Prediction',
          format: 'Closest Guess',
          updatedAt: '27/02 14:30',
          entryPoints: 100,
        ),
        ArenaDraftChallenge(
          id: 'draft002',
          title: 'DeFi Quiz Night',
          format: 'Bracket',
          updatedAt: '25/02 18:00',
          entryPoints: 200,
        ),
      ],
      history: [
        ArenaChallengeDraft(
          id: 'ch005',
          title: 'Crypto Quiz Night #11',
          format: 'Bracket',
          slotsFilled: 16,
          slotsTotal: 16,
          entryPoints: 150,
          prizePool: 2400,
          state: ArenaChallengeState.resolved,
        ),
        ArenaChallengeDraft(
          id: 'ch007',
          title: 'NFT Floor Price Guess',
          format: 'Closest Guess',
          slotsFilled: 3,
          slotsTotal: 20,
          entryPoints: 80,
          prizePool: 0,
          state: ArenaChallengeState.canceled,
        ),
      ],
      rewardHistory: ArenaRewardHistory(
        totalReceipts: 12,
        averageReceiveRate: 142,
        largestReceipt: 2400,
        distribution: [
          ArenaRewardDistribution(label: 'Top 3', wins: 4, total: 8),
          ArenaRewardDistribution(label: 'Winner Takes All', wins: 2, total: 6),
          ArenaRewardDistribution(label: 'Chia đều', wins: 3, total: 5),
          ArenaRewardDistribution(label: 'Tỷ lệ theo điểm', wins: 1, total: 2),
          ArenaRewardDistribution(label: 'Top 5', wins: 2, total: 2),
        ],
      ),
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  MyArenaSnapshot getArenaMy() {
    return getMyArena().copyWith(endpoint: '/api/mobile/arena/arena-my');
  }
}
