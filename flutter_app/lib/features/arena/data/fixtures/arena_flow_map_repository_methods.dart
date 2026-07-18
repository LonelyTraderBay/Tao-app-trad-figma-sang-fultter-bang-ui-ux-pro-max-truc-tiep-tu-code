part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryFlowMapMethods on _MockArenaRepositoryBase {
  @override
  Future<ArenaFlowMapSnapshot> getArenaFlowMap() async {
    await _simulateNetwork();
    return const ArenaFlowMapSnapshot(
      endpoint: '/api/mobile/arena/arena-flow-map',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      stats: [
        ArenaFlowStatDraft(
          value: '10',
          label: 'Pages',
          kind: ArenaFlowKind.discovery,
        ),
        ArenaFlowStatDraft(
          value: '10',
          label: 'Routes',
          kind: ArenaFlowKind.verified,
        ),
        ArenaFlowStatDraft(
          value: '4 files',
          label: 'Components',
          kind: ArenaFlowKind.participant,
        ),
        ArenaFlowStatDraft(
          value: '12+',
          label: 'States',
          kind: ArenaFlowKind.points,
        ),
      ],
      routes: [
        ArenaFlowRouteDraft(
          path: '/arena',
          page: 'ArenaHomePage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/studio',
          page: 'ArenaStudioPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/mode/:modeId',
          page: 'ArenaModeDetailPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/challenge/:challengeId',
          page: 'ArenaChallengeDetailPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/challenge/:id/join',
          page: 'ArenaJoinPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/creator/:creatorId',
          page: 'ArenaCreatorPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/leaderboard',
          page: 'ArenaLeaderboardPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/verified',
          page: 'VerifiedChallengesPage',
          status: 'Release-gated Preview',
        ),
        ArenaFlowRouteDraft(
          path: '/arena/points',
          page: 'ArenaPointsPage',
          status: 'Live',
        ),
        ArenaFlowRouteDraft(
          path: '/profile/arena',
          page: 'MyArenaPage',
          status: 'Live',
        ),
      ],
      groups: [
        ArenaFlowGroupDraft(
          id: 'core',
          title: 'Core Entry Points',
          subtitle: '3 điểm vào chính từ bottom nav',
          kind: ArenaFlowKind.core,
          connectionNote:
              'Home quick action, Profile menu và Market banner đều dẫn vào Arena.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'HomePage_v2',
              sublabel: 'Tab Home',
              kind: ArenaFlowKind.core,
              route: '/',
            ),
            ArenaFlowNodeDraft(
              label: 'ProfilePage_v2',
              sublabel: 'Tab Profile',
              kind: ArenaFlowKind.verified,
              route: '/profile',
            ),
            ArenaFlowNodeDraft(
              label: 'MarketListPage_v2',
              sublabel: 'Tab Trade',
              kind: ArenaFlowKind.participant,
              route: '/trade',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaHomePage',
              sublabel: 'Hub chính',
              kind: ArenaFlowKind.points,
              route: '/arena',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'discovery',
          title: 'Discovery Flow',
          subtitle: 'Khám phá modes, challenges, creators',
          kind: ArenaFlowKind.discovery,
          connectionNote:
              'Arena Home mở Studio, Mode Detail, Challenge Detail, Creator, Leaderboard và Points.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'ArenaHomePage',
              sublabel: 'Hub chính',
              kind: ArenaFlowKind.points,
              route: '/arena',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaStudioPage',
              sublabel: 'Tạo challenge',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaModeDetailPage',
              sublabel: 'Chi tiết mode',
              kind: ArenaFlowKind.participant,
              route: '/arena/mode/mode001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaChallengeDetail',
              sublabel: 'Chi tiết challenge',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaCreatorPage',
              sublabel: 'Hồ sơ creator',
              kind: ArenaFlowKind.points,
              route: '/arena/creator/cr001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaLeaderboardPage',
              sublabel: 'Bảng xếp hạng',
              kind: ArenaFlowKind.safety,
              route: '/arena/leaderboard',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaPointsPage',
              sublabel: 'Kiếm Points',
              kind: ArenaFlowKind.points,
              route: '/arena/points',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'creator_flow',
          title: 'Creator Flow',
          subtitle: '6-step wizard -> publish -> challenge live',
          kind: ArenaFlowKind.creator,
          connectionNote:
              'Template, cấu trúc, luật chơi, kết quả, points và review dẫn tới publish.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'Step 1 - Template',
              sublabel: 'Chọn template',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
            ArenaFlowNodeDraft(
              label: 'Step 2 - Cấu trúc',
              sublabel: 'Format, slots, join',
              kind: ArenaFlowKind.discovery,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 3 - Luật chơi',
              sublabel: 'Tên, rules, win condition',
              kind: ArenaFlowKind.points,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 4 - Kết quả',
              sublabel: 'Resolution method',
              kind: ArenaFlowKind.participant,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 5 - Points',
              sublabel: 'Entry, privacy, EV',
              kind: ArenaFlowKind.points,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 6 - Review',
              sublabel: 'Preview & publish',
              kind: ArenaFlowKind.verified,
            ),
            ArenaFlowNodeDraft(
              label: 'Publish',
              sublabel: 'Kiểm duyệt tự động',
              kind: ArenaFlowKind.participant,
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Open',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
              stateLabel: 'Đang mở',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'participant',
          title: 'Participant Flow',
          subtitle: 'Tham gia challenge -> live -> kết quả',
          kind: ArenaFlowKind.points,
          connectionNote:
              'Open detail, confirm join, live state, pending result và resolved state.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Open',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
              stateLabel: 'Đang mở',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaJoinPage',
              sublabel: 'Confirm join + rules',
              kind: ArenaFlowKind.participant,
              route: '/arena/join/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Live',
              kind: ArenaFlowKind.participant,
              stateLabel: 'Đang diễn ra',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Pending Result',
              kind: ArenaFlowKind.verified,
              stateLabel: 'Chờ kết quả',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Resolved',
              kind: ArenaFlowKind.points,
              stateLabel: 'Đã xử lý',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'owner',
          title: 'Owner Flow',
          subtitle: 'Quản lý phòng, modes đã tạo, prefill studio',
          kind: ArenaFlowKind.safety,
          connectionNote:
              'My Arena quản lý rooms, saved modes, drafts và mở lại studio prefill.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'MyArenaPage',
              sublabel: '5-tab management',
              kind: ArenaFlowKind.verified,
              route: '/profile/arena',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'Quản lý phòng',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ModeDetailPage',
              sublabel: 'Mode đã tạo/lưu',
              kind: ArenaFlowKind.participant,
              route: '/arena/mode/mode001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaCreatorPage',
              sublabel: 'Hồ sơ creator',
              kind: ArenaFlowKind.points,
              route: '/arena/creator/cr001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaStudioPage',
              sublabel: 'Prefilled từ mode',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
          ],
        ),
      ],
      components: [
        ArenaFlowComponentDraft(
          file: 'ArenaChips.tsx',
          description:
              'Reusable chips & badges cho format, resolution, status, trust level',
          exports: ['FormatChip', 'ResolutionChip', 'StatusChip', 'TrustBadge'],
        ),
        ArenaFlowComponentDraft(
          file: 'ArenaModeration.tsx',
          description:
              'Moderation UI: report, block, rules, inline warning banners',
          exports: ['ReportDialog', 'BlockUserDialog', 'CommunityRulesDialog'],
        ),
        ArenaFlowComponentDraft(
          file: 'ArenaStates.tsx',
          description:
              'Loading/empty/error/offline states + content status banners',
          exports: [
            'ArenaLoadingSkeleton',
            'ArenaErrorState',
            'ArenaOfflineBanner',
          ],
        ),
        ArenaFlowComponentDraft(
          file: 'ArenaPageFooter.tsx',
          description:
              'Shared footer: rules dialog, disclaimer and offline detection',
          exports: ['ArenaPageFooter'],
        ),
      ],
      handoffNotes: [
        ArenaFlowNoteDraft(
          title: 'Open Arena = Points-only',
          detail:
              'Toàn bộ module Open Arena sử dụng Arena Points, không liên quan ví tài chính và không cash-out.',
          kind: ArenaFlowKind.points,
        ),
        ArenaFlowNoteDraft(
          title: 'Không liên quan Wallet tài chính',
          detail:
              'Arena Points tách biệt khỏi Spot Wallet và P2P Wallet; không có flow deposit/withdraw crypto cho Arena.',
          kind: ArenaFlowKind.discovery,
        ),
        ArenaFlowNoteDraft(
          title: 'Verified Challenges tách module riêng',
          detail:
              'Verified Challenges is a release-gated local preview; compliance review and KYC gate are required before user availability.',
          kind: ArenaFlowKind.safety,
        ),
        ArenaFlowNoteDraft(
          title: 'Không thêm item vào bottom nav',
          detail:
              'Arena truy cập qua Home quick action, Profile menu và Market banner; không chiếm slot bottom navigation.',
          kind: ArenaFlowKind.participant,
        ),
        ArenaFlowNoteDraft(
          title: 'Mọi challenge bắt buộc có đủ',
          detail:
              'Rules summary, resolution method, privacy setting và report/block functionality trước publish.',
          kind: ArenaFlowKind.verified,
        ),
        ArenaFlowNoteDraft(
          title: 'Moderation & Safety',
          detail:
              'Report, block, community rules và offline banner phải tích hợp trên các surface chính.',
          kind: ArenaFlowKind.safety,
        ),
      ],
      qaItems: [
        ArenaFlowQaDraft(
          id: 'qa01',
          category: 'Route Mapping',
          label: 'ArenaHomePage - hub chính',
        ),
        ArenaFlowQaDraft(
          id: 'qa02',
          category: 'Route Mapping',
          label: 'ArenaStudioPage - 6-step wizard',
        ),
        ArenaFlowQaDraft(
          id: 'qa03',
          category: 'Route Mapping',
          label: 'ArenaChallengeDetailPage - challenge/:challengeId',
        ),
        ArenaFlowQaDraft(
          id: 'qa04',
          category: 'Entry Points',
          label: 'Home quick action -> ArenaHomePage',
        ),
        ArenaFlowQaDraft(
          id: 'qa05',
          category: 'Entry Points',
          label: 'Profile menu -> MyArenaPage',
        ),
        ArenaFlowQaDraft(
          id: 'qa06',
          category: 'States Coverage',
          label: 'StatusChip states: open, live, pending, resolved',
        ),
        ArenaFlowQaDraft(
          id: 'qa07',
          category: 'Moderation',
          label: 'ReportDialog, BlockUserDialog, CommunityRulesDialog',
        ),
        ArenaFlowQaDraft(
          id: 'qa08',
          category: 'Verified Separation',
          label: 'VerifiedChallengesPage is release-gated local preview only',
        ),
      ],
      disclaimer:
          'Arena Points stay inside Open Arena; not a trading account or prediction performance. No off-platform agreements.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
