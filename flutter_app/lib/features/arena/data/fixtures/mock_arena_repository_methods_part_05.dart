part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart05 on _MockArenaRepositoryBase {
  @override
  ArenaFlowMapSnapshot getArenaFlowMap() {
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
          subtitle: '3 Ã„â€˜iÃ¡Â»Æ’m vÃƒÂ o chÃƒÂ­nh tÃ¡Â»Â« bottom nav',
          kind: ArenaFlowKind.core,
          connectionNote:
              'Home quick action, Profile menu vÃƒÂ  Market banner Ã„â€˜Ã¡Â»Âu dÃ¡ÂºÂ«n vÃƒÂ o Arena.',
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
              sublabel: 'Hub chÃƒÂ­nh',
              kind: ArenaFlowKind.points,
              route: '/arena',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'discovery',
          title: 'Discovery Flow',
          subtitle: 'KhÃƒÂ¡m phÃƒÂ¡ modes, challenges, creators',
          kind: ArenaFlowKind.discovery,
          connectionNote:
              'Arena Home mÃ¡Â»Å¸ Studio, Mode Detail, Challenge Detail, Creator, Leaderboard vÃƒÂ  Points.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'ArenaHomePage',
              sublabel: 'Hub chÃƒÂ­nh',
              kind: ArenaFlowKind.points,
              route: '/arena',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaStudioPage',
              sublabel: 'TÃ¡ÂºÂ¡o challenge',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaModeDetailPage',
              sublabel: 'Chi tiÃ¡ÂºÂ¿t mode',
              kind: ArenaFlowKind.participant,
              route: '/arena/mode/mode001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaChallengeDetail',
              sublabel: 'Chi tiÃ¡ÂºÂ¿t challenge',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaCreatorPage',
              sublabel: 'HÃ¡Â»â€œ sÃ†Â¡ creator',
              kind: ArenaFlowKind.points,
              route: '/arena/creator/cr001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaLeaderboardPage',
              sublabel: 'BÃ¡ÂºÂ£ng xÃ¡ÂºÂ¿p hÃ¡ÂºÂ¡ng',
              kind: ArenaFlowKind.safety,
              route: '/arena/leaderboard',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaPointsPage',
              sublabel: 'KiÃ¡ÂºÂ¿m Points',
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
              'Template, cÃ¡ÂºÂ¥u trÃƒÂºc, luÃ¡ÂºÂ­t chÃ†Â¡i, kÃ¡ÂºÂ¿t quÃ¡ÂºÂ£, points vÃƒÂ  review dÃ¡ÂºÂ«n tÃ¡Â»â€ºi publish.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'Step 1 - Template',
              sublabel: 'ChÃ¡Â»Ân template',
              kind: ArenaFlowKind.verified,
              route: '/arena/studio',
            ),
            ArenaFlowNodeDraft(
              label: 'Step 2 - CÃ¡ÂºÂ¥u trÃƒÂºc',
              sublabel: 'Format, slots, join',
              kind: ArenaFlowKind.discovery,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 3 - LuÃ¡ÂºÂ­t chÃ†Â¡i',
              sublabel: 'TÃƒÂªn, rules, win condition',
              kind: ArenaFlowKind.points,
            ),
            ArenaFlowNodeDraft(
              label: 'Step 4 - KÃ¡ÂºÂ¿t quÃ¡ÂºÂ£',
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
              sublabel: 'KiÃ¡Â»Æ’m duyÃ¡Â»â€¡t tÃ¡Â»Â± Ã„â€˜Ã¡Â»â„¢ng',
              kind: ArenaFlowKind.participant,
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Open',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
              stateLabel: 'Ã„Âang mÃ¡Â»Å¸',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'participant',
          title: 'Participant Flow',
          subtitle: 'Tham gia challenge -> live -> kÃ¡ÂºÂ¿t quÃ¡ÂºÂ£',
          kind: ArenaFlowKind.points,
          connectionNote:
              'Open detail, confirm join, live state, pending result vÃƒÂ  resolved state.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Open',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
              stateLabel: 'Ã„Âang mÃ¡Â»Å¸',
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
              stateLabel: 'Ã„Âang diÃ¡Â»â€¦n ra',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Pending Result',
              kind: ArenaFlowKind.verified,
              stateLabel: 'ChÃ¡Â»Â kÃ¡ÂºÂ¿t quÃ¡ÂºÂ£',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'State: Resolved',
              kind: ArenaFlowKind.points,
              stateLabel: 'Ã„ÂÃƒÂ£ xÃ¡Â»Â­ lÃƒÂ½',
            ),
          ],
        ),
        ArenaFlowGroupDraft(
          id: 'owner',
          title: 'Owner Flow',
          subtitle:
              'QuÃ¡ÂºÂ£n lÃƒÂ½ phÃƒÂ²ng, modes Ã„â€˜ÃƒÂ£ tÃ¡ÂºÂ¡o, prefill studio',
          kind: ArenaFlowKind.safety,
          connectionNote:
              'My Arena quÃ¡ÂºÂ£n lÃƒÂ½ rooms, saved modes, drafts vÃƒÂ  mÃ¡Â»Å¸ lÃ¡ÂºÂ¡i studio prefill.',
          nodes: [
            ArenaFlowNodeDraft(
              label: 'MyArenaPage',
              sublabel: '5-tab management',
              kind: ArenaFlowKind.verified,
              route: '/profile/arena',
            ),
            ArenaFlowNodeDraft(
              label: 'ChallengeDetail',
              sublabel: 'QuÃ¡ÂºÂ£n lÃƒÂ½ phÃƒÂ²ng',
              kind: ArenaFlowKind.discovery,
              route: '/arena/challenge/ch003',
            ),
            ArenaFlowNodeDraft(
              label: 'ModeDetailPage',
              sublabel: 'Mode Ã„â€˜ÃƒÂ£ tÃ¡ÂºÂ¡o/lÃ†Â°u',
              kind: ArenaFlowKind.participant,
              route: '/arena/mode/mode001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaCreatorPage',
              sublabel: 'HÃ¡Â»â€œ sÃ†Â¡ creator',
              kind: ArenaFlowKind.points,
              route: '/arena/creator/cr001',
            ),
            ArenaFlowNodeDraft(
              label: 'ArenaStudioPage',
              sublabel: 'Prefilled tÃ¡Â»Â« mode',
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
              'ToÃƒÂ n bÃ¡Â»â„¢ module Open Arena sÃ¡Â»Â­ dÃ¡Â»Â¥ng Arena Points, khÃƒÂ´ng liÃƒÂªn quan vÃƒÂ­ tÃƒÂ i chÃƒÂ­nh vÃƒÂ  khÃƒÂ´ng cash-out.',
          kind: ArenaFlowKind.points,
        ),
        ArenaFlowNoteDraft(
          title: 'KhÃƒÂ´ng liÃƒÂªn quan Wallet tÃƒÂ i chÃƒÂ­nh',
          detail:
              'Arena Points tÃƒÂ¡ch biÃ¡Â»â€¡t khÃ¡Â»Âi Spot Wallet vÃƒÂ  P2P Wallet; khÃƒÂ´ng cÃƒÂ³ flow deposit/withdraw crypto cho Arena.',
          kind: ArenaFlowKind.discovery,
        ),
        ArenaFlowNoteDraft(
          title: 'Verified Challenges tÃƒÂ¡ch module riÃƒÂªng',
          detail:
              'Verified Challenges is a release-gated local preview; compliance review and KYC gate are required before user availability.',
          kind: ArenaFlowKind.safety,
        ),
        ArenaFlowNoteDraft(
          title: 'KhÃƒÂ´ng thÃƒÂªm item vÃƒÂ o bottom nav',
          detail:
              'Arena truy cÃ¡ÂºÂ­p qua Home quick action, Profile menu vÃƒÂ  Market banner; khÃƒÂ´ng chiÃ¡ÂºÂ¿m slot bottom navigation.',
          kind: ArenaFlowKind.participant,
        ),
        ArenaFlowNoteDraft(
          title: 'MÃ¡Â»Âi challenge bÃ¡ÂºÂ¯t buÃ¡Â»â„¢c cÃƒÂ³ Ã„â€˜Ã¡Â»Â§',
          detail:
              'Rules summary, resolution method, privacy setting vÃƒÂ  report/block functionality trÃ†Â°Ã¡Â»â€ºc publish.',
          kind: ArenaFlowKind.verified,
        ),
        ArenaFlowNoteDraft(
          title: 'Moderation & Safety',
          detail:
              'Report, block, community rules vÃƒÂ  offline banner phÃ¡ÂºÂ£i tÃƒÂ­ch hÃ¡Â»Â£p trÃƒÂªn cÃƒÂ¡c surface chÃƒÂ­nh.',
          kind: ArenaFlowKind.safety,
        ),
      ],
      qaItems: [
        ArenaFlowQaDraft(
          id: 'qa01',
          category: 'Route Mapping',
          label: 'ArenaHomePage - hub chÃƒÂ­nh',
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
