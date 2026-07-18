part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositorySafetyReportsMethods on _MockArenaRepositoryBase {
  @override
  Future<ArenaSafetyCenterSnapshot> getArenaSafetyCenter() async {
    await _simulateNetwork();
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
  Future<ArenaReportCaseSnapshot> getArenaReportCase(String caseId) async {
    await _simulateNetwork();
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
  Future<MyArenaReportsSnapshot> getMyArenaReports() async {
    await _simulateNetwork();
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
}
