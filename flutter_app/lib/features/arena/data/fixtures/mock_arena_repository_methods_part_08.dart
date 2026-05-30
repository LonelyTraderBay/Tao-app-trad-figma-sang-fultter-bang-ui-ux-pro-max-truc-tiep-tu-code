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
              'Gá»n hÆ¡n v4: bá»›t quick chips, giá»¯ hero + templates + modes + rooms + creators.',
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
              'PublishEligibilityPanel rÃµ hÆ¡n, GovernanceHintBanner á»Ÿ má»—i step.',
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
              'Trust-first: tab máº·c Ä‘á»‹nh lÃ  luáº­t chÆ¡i, safety snapshot trÆ°á»›c CTA.',
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
              'Trung tÃ¢m an toÃ n: chÃ­nh sÃ¡ch, bÃ¡o cÃ¡o, cháº·n users, quy táº¯c cá»™ng Ä‘á»“ng.',
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
              'Chá»‘t káº¿t quáº£: method-specific UI, evidence, timeline, receipt sheet.',
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
              '3 má»¥c riÃªng: challenges, modes, settings; links to reports + blocked users.',
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
          notes: 'Chi tiáº¿t giao dá»‹ch Ä‘iá»ƒm: amount hero, balance, refId.',
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
          notes: 'Preview trÆ°á»›c join: entry pts, checkboxes, fee.',
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
          notes: 'Flow visualization cho dev/QA, khÃ´ng pháº£i user-facing.',
        ),
        ArenaProductionScreenDraft(
          name: 'ArenaProductionReadyPage',
          route: '/arena/production',
          status: ArenaProductionScreenStatus.qaOnly,
          version: 'v1',
          states: [ArenaProductionScreenState.defaultView],
          notes: 'Trang handoff dashboard nÃ y.',
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
              description: 'Tap táº¡o challenge.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ArenaStudio',
              route: '/arena/studio',
              description: 'Template -> cáº¥u trÃºc -> luáº­t -> review.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Challenge created, share link.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'Resolution',
              route: '/arena/resolution',
              description: 'Khi háº¿t háº¡n -> chá»‘t káº¿t quáº£.',
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
              description: 'Chá»n lÃ½ do vÃ  gá»­i bÃ¡o cÃ¡o.',
            ),
            ArenaProductionFlowStepDraft(
              label: 'MyArenaReports',
              route: '/arena/my-reports',
              description: 'Theo dÃµi cÃ¡c case Ä‘Ã£ gá»­i.',
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
              label: 'Tá»± Ä‘á»™ng',
              description: 'Káº¿t quáº£ tá»« nguá»“n dá»¯ liá»‡u bÃªn ngoÃ i.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'mutual_confirm',
              label: 'XÃ¡c nháº­n 2 bÃªn',
              description: 'Táº¥t cáº£ bÃªn pháº£i xÃ¡c nháº­n káº¿t quáº£.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'community_vote',
              label: 'BÃ¬nh chá»n cá»™ng Ä‘á»“ng',
              description: 'Bá» phiáº¿u vá»›i ngÆ°á»¡ng tá»‘i thiá»ƒu.',
            ),
          ],
        ),
        ArenaProductionDictionaryDraft(
          category: 'Ledger Reason Codes',
          items: [
            ArenaProductionDictionaryItemDraft(
              code: 'earned',
              label: 'Nháº­n',
              description:
                  'Points nháº­n Ä‘Æ°á»£c tá»« task, check-in hoáº·c tháº¯ng.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'entry',
              label: 'Tham gia',
              description: 'Kháº¥u trá»« khi join challenge.',
            ),
            ArenaProductionDictionaryItemDraft(
              code: 'refund',
              label: 'HoÃ n Ä‘iá»ƒm',
              description: 'HoÃ n khi challenge bá»‹ void hoáº·c cancel.',
            ),
          ],
        ),
      ],
      qaItems: [
        'Tap targets >= 44pt / 48dp',
        'Contrast >= 4.5:1 cho text thÆ°á»ng',
        'Fee breakdown trÆ°á»›c confirm Points',
        'Error, empty, loading states Ä‘áº§y Ä‘á»§',
        'KhÃ´ng cÃ³ dark patterns hoáº·c FOMO copy',
        'Arena Points disclaimer hiá»ƒn thá»‹ rÃµ',
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
