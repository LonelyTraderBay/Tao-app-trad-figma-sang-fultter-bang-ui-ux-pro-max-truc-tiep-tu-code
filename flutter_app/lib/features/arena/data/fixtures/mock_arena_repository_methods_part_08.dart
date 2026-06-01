part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart08 on _MockArenaRepositoryBase {
  @override
  ArenaProductionReadySnapshot getArenaProductionReady() {
    return const ArenaProductionReadySnapshot(
      endpoint: '/api/mobile/arena/arena-production',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      canonicalScreens: [
        ArenaProductionScreenDraft(
          name: 'ArenaHomePage',
          route: '/arena',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.offline,
          ],
          notes:
              'Gọn hơn v4: bớt quick chips, giữ hero + templates + modes + rooms + creators.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaStudioPage',
          route: '/arena/studio',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.offline,
            ArenaProductionScreenState.underReview,
          ],
          notes:
              'PublishEligibilityPanel rõ hơn, GovernanceHintBanner ở mỗi step.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaChallengeDetailPage',
          route: '/arena/challenge/:challengeId',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.offline,
            ArenaProductionScreenState.underReview,
            ArenaProductionScreenState.reported,
            ArenaProductionScreenState.hidden,
            ArenaProductionScreenState.resolved,
            ArenaProductionScreenState.canceled,
          ],
          notes:
              'Trust-first: tab mặc định là luật chơi, safety snapshot trước CTA.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaSafetyCenterPage',
          route: '/arena/safety',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.error,
          ],
          notes:
              'Trung tâm an toàn: chính sách, báo cáo, chặn users, quy tắc cộng đồng.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaResolutionCenterPage',
          route: '/arena/resolution',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
            ArenaProductionScreenState.resolved,
          ],
          notes:
              'Chốt kết quả: method-specific UI, evidence, timeline, receipt sheet.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaPointsLedgerPage',
          route: '/arena/ledger',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
          ],
          notes:
              'Full audit trail: filter chips, search, balance summary, tappable rows.',
        ),
        ArenaProductionScreenDraft(
          name: 'MyArenaPage',
          route: '/profile/arena',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.empty,
            ArenaProductionScreenState.error,
          ],
          notes:
              '3 mục riêng: challenges, modes, settings; links to reports + blocked users.',
        ),
      ],
      supportingScreens: [
        ArenaProductionScreenDraft(
          name: 'ArenaPointsPage',
          route: '/arena/points',
          status: ArenaProductionScreenStatus.live,
          version: 'v2',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
          ],
          notes: 'Points hub: tasks, history, ledger link.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaPointsEntryDetailPage',
          route: '/arena/ledger/entry/:entryId',
          status: ArenaProductionScreenStatus.live,
          version: 'vFinal',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.empty,
          ],
          notes: 'Chi tiết giao dịch điểm: amount hero, balance, refId.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaJoinPage',
          route: '/arena/join/:id',
          status: ArenaProductionScreenStatus.live,
          version: 'v2',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.loading,
            ArenaProductionScreenState.error,
          ],
          notes: 'Preview trước join: entry pts, checkboxes, fee.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaCreatorPage',
          route: '/arena/creator/:id',
          status: ArenaProductionScreenStatus.live,
          version: 'v2',
          states: [
            ArenaProductionScreenState.defaultView,
            ArenaProductionScreenState.empty,
          ],
          notes: 'Creator profile: modes, challenges, trust, report modal.',
        ),
        ArenaProductionScreenDraft(
          name: 'VerifiedChallengesPage',
          route: '/arena/verified',
          status: ArenaProductionScreenStatus.future,
          version: 'v1',
          states: [ArenaProductionScreenState.defaultView],
          notes:
              'Release-gated local preview; compliance review and KYC gate pending.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaFlowMapPage',
          route: '/arena/flow-map',
          status: ArenaProductionScreenStatus.qaOnly,
          version: 'v1',
          states: [ArenaProductionScreenState.defaultView],
          notes: 'Flow visualization cho dev/QA, không phải user-facing.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaProductionReadyPage',
          route: '/arena/production',
          status: ArenaProductionScreenStatus.qaOnly,
          version: 'v1',
          states: [ArenaProductionScreenState.defaultView],
          notes: 'Trang handoff dashboard này.',
        ),
      ],
      flows: [
        ArenaProductionFlowDraft(
          id: 'creator',
          name: 'Creator Flow',
          steps: [
            ArenaProductionFlowStepDraft(
              label: 'ArenaHome',
              route: '/arena',
              description: 'Tap tạo challenge.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ArenaStudio',
              route: '/arena/studio',
              description: 'Template -> cấu trúc -> luật -> review.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Challenge created, share link.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'Resolution',
              route: '/arena/resolution',
              description: 'Khi hết hạn -> chốt kết quả.',
            ),
          ],
        ),
        ArenaProductionFlowDraft(
          id: 'moderation',
          name: 'Moderation Flow',
          steps: [
            ArenaProductionFlowStepDraft(
              label: 'ReportDialog',
              route: '/arena/challenge/:id',
              description: 'Chọn lý do và gửi báo cáo.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'MyArenaReports',
              route: '/arena/my-reports',
              description: 'Theo dõi các case đã gửi.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ReportCase',
              route: '/arena/report/:caseId',
              description: 'Case detail, timeline, appeal.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'Safety Center',
              route: '/arena/safety',
              description: 'Community rules, blocked users.',
            ),
          ],
        ),
        ArenaProductionFlowDraft(
          id: 'points_audit',
          name: 'Points Audit Flow',
          steps: [
            ArenaProductionFlowStepDraft(
              label: 'ArenaPoints',
              route: '/arena/points',
              description: 'Balance overview, tasks, history.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'PointsLedger',
              route: '/arena/ledger',
              description: 'Full audit trail with filters.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'EntryDetail',
              route: '/arena/ledger/entry/:entryId',
              description: 'Amount, type, balance, refId.',
            ),
          ],
        ),
      ],
      components: [
        ArenaProductionComponentDraft(
          name: 'StatusChip',
          file: 'ArenaChips.tsx',
          type: 'chip',
          description: 'Challenge states: open, live, full, resolved, hidden.',
        ),
        ArenaProductionComponentDraft(
          name: 'ReportDialog',
          file: 'ArenaModeration.tsx',
          type: 'dialog',
          description: 'Report modal with reason options and text input.',
        ),
        ArenaProductionComponentDraft(
          name: 'ResultReceiptSheet',
          file: 'ArenaResultReceipt.tsx',
          type: 'sheet',
          description: 'Settlement receipt with pool and ledger refs.',
        ),
        ArenaProductionComponentDraft(
          name: 'PublishEligibilityPanel',
          file: 'ArenaStudioGovernance.tsx',
          type: 'card',
          description: 'Eligibility checks before publishing challenge.',
        ),
      ],
      dictionaries: [
        ArenaProductionDictionaryDraft(
          category: 'Resolution Methods',
          items: [
            ArenaProductionDictionaryItemDraft(
              code: 'auto',
              label: 'Tự động',
              description: 'Kết quả từ nguồn dữ liệu bên ngoài.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'mutual_confirm',
              label: 'Xác nhận 2 bên',
              description: 'Tất cả bên phải xác nhận kết quả.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'community_vote',
              label: 'Bình chọn cộng đồng',
              description: 'Bỏ phiếu với ngưỡng tối thiểu.',
            ),
          ],
        ),
        ArenaProductionDictionaryDraft(
          category: 'Ledger Reason Codes',
          items: [
            ArenaProductionDictionaryItemDraft(
              code: 'earned',
              label: 'Nhận',
              description: 'Points nhận được từ task, check-in hoặc thắng.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'entry',
              label: 'Tham gia',
              description: 'Khấu trừ khi join challenge.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'refund',
              label: 'Hoàn điểm',
              description: 'Hoàn khi challenge bị void hoặc cancel.',
            ),
          ],
        ),
      ],
      qaItems: [
        'Tap targets >= 44pt / 48dp',
        'Contrast >= 4.5:1 cho text thường',
        'Fee breakdown trước confirm Points',
        'Error, empty, loading states đầy đủ',
        'Không có dark patterns hoặc FOMO copy',
        'Arena Points disclaimer hiển thị rõ',
        'Routes DRY qua route config',
      ],
      disclaimer:
          'Internal release-readiness handoff. Do not expose this dashboard in release builds. Open Arena = points-only, not a financial asset.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
