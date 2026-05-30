part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart10 on _MockArenaRepositoryBase {
  @override
  ConnectedEcosystemProductionSnapshot getConnectedEcosystemProduction() {
    return const ConnectedEcosystemProductionSnapshot(
      endpoint: '/api/mobile/arena/arena-ecosystem',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      canonicalScreens: [
        ConnectedScreenDraft(
          name: 'HomePage_vFinal_Connected',
          route: '/',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['HomeDiscoverySection'],
          notes:
              'Discovery cards cho Predictions vÃ  Arena. Má»—i card cÃ³ disclosure badge rÃµ module. KhÃ´ng merge metrics.',
        ),
        ConnectedScreenDraft(
          name: 'ProfilePage_vFinal_Connected',
          route: '/profile',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A + 09B',
          bridgeComponents: ['ProfileModuleBlocks', 'DualModuleStatCard'],
          notes:
              'Dual surface tÃ¡ch biá»‡t: Prediction Portfolio vs MyArena. Stats khÃ´ng bao giá» gá»™p.',
        ),
        ConnectedScreenDraft(
          name: 'MarketListPage_vFinal_Connected',
          route: '/markets',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['DiscoverMoreSection'],
          notes:
              'KhÃ¡m phÃ¡ thÃªm section cuá»‘i page. Safe bridge dáº«n Ä‘áº¿n Predictions hoáº·c Arena, cÃ³ disclosure.',
        ),
        ConnectedScreenDraft(
          name: 'PredictionsHomePage_vFinal_Connected',
          route: '/markets/predictions',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A',
          bridgeComponents: ['TopicChipBar (shared taxonomy)'],
          notes:
              'Topic chips dÃ¹ng shared taxonomy. Discovery card Arena á»Ÿ cuá»‘i vá»›i badge Points only.',
        ),
        ConnectedScreenDraft(
          name: 'PredictionEventDetailPage_vFinal_Connected',
          route: '/markets/predictions/event/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B + 09C + 09D',
          bridgeComponents: [
            'ArenaRelatedRoomsSection',
            'ArenaBridgeConfirmSheet',
            'mapCategoryToTopic',
          ],
          notes:
              'Arena rooms bridge section + CTA táº¡o Arena tá»« event nÃ y, qua confirmation sheet trÆ°á»›c khi má»Ÿ Arena Studio.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaHomePage_vFinal_Connected',
          route: '/arena',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['PredictionInsightSection'],
          notes:
              'Prediction insight section á»Ÿ cuá»‘i. Badge Market context only, khÃ´ng áº£nh hÆ°á»Ÿng Arena Points.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaStudioPage_vFinal_Connected',
          route: '/arena/studio',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09D',
          bridgeComponents: [
            'BridgeSourceBar',
            'ModuleBoundaryBanner',
            'Bridge Safety Snapshot',
            'Linked Event rows',
          ],
          notes:
              'Khi má»Ÿ tá»« Prediction: source bar top, suggest templates, prefill context, safety snapshot vÃ  linked event rows.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaModeDetailPage_vFinal_Connected',
          route: '/arena/mode/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09C',
          bridgeComponents: ['PredictionContextCard', 'mapArenaTagToTopic'],
          notes:
              'Mode cÃ³ tags liÃªn quan prediction topic hiá»ƒn thá»‹ context card vá»›i CTA xem thá»‹ trÆ°á»ng dá»± Ä‘oÃ¡n.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaChallengeDetailPage_vFinal_Connected',
          route: '/arena/challenge/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09C + 09D',
          bridgeComponents: [
            'PredictionContextCard',
            'LinkedSourceCard',
            'ModuleBoundaryBanner',
            'BoundaryInfoRow',
            'Boundary sheet',
          ],
          notes:
              'Prediction context bridge + linked source card. Disclosure: káº¿t quáº£ room Arena khÃ´ng pháº£i káº¿t quáº£ trade.',
        ),
      ],
      bridgeStates: [
        ConnectedBridgeStateDraft(
          id: 'linked_available',
          label: 'Linked context available',
          description:
              'Bridge context tá»“n táº¡i vÃ  valid. Hiá»ƒn thá»‹ bridge card + disclosure.',
          tone: ArenaBridgeTone.disclosure,
          affectedScreens: [
            'PredictionEventDetail',
            'ArenaStudio',
            'ArenaChallengeDetail',
            'ArenaModeDetail',
          ],
          behavior:
              'Show bridge card, context bar, related rooms/events. Disclosure badge luÃ´n hiá»‡n.',
        ),
        ConnectedBridgeStateDraft(
          id: 'linked_unavailable',
          label: 'Linked context unavailable',
          description:
              'Event hoáº·c room nguá»“n khÃ´ng cÃ²n tá»“n táº¡i hoáº·c bá»‹ xoÃ¡.',
          tone: ArenaBridgeTone.blocked,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show fallback card, disable CTA xem event gá»‘c, giá»¯ room hoáº¡t Ä‘á»™ng bÃ¬nh thÆ°á»ng.',
        ),
        ConnectedBridgeStateDraft(
          id: 'stale_context',
          label: 'Stale context',
          description: 'Context quÃ¡ cÅ© hoáº·c event Ä‘Ã£ resolved/expired.',
          tone: ArenaBridgeTone.arena,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show warning chip Context cÅ©. CTA váº«n navigate Ä‘áº¿n event á»Ÿ tráº¡ng thÃ¡i resolved.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_arena_rooms',
          label: 'No related Arena rooms',
          description: 'Prediction event chÆ°a cÃ³ rooms Arena liÃªn quan.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['PredictionEventDetail'],
          behavior:
              'áº¨n ArenaRelatedRoomsSection, váº«n giá»¯ CTA táº¡o Arena tá»« event nÃ y.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_prediction_events',
          label: 'No related Prediction events',
          description:
              'Arena mode/challenge khÃ´ng cÃ³ Prediction events match topic.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaModeDetail'],
          behavior:
              'áº¨n PredictionContextCard vÃ  link hiá»ƒu ranh giá»›i. Room hoáº¡t Ä‘á»™ng bÃ¬nh thÆ°á»ng.',
        ),
        ConnectedBridgeStateDraft(
          id: 'bridge_disabled',
          label: 'Bridge disabled',
          description:
              'Feature flag táº¯t bridge do maintenance hoáº·c chÆ°a launch.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['All connected screens'],
          behavior:
              'áº¨n toÃ n bá»™ bridge sections, khÃ´ng hiá»‡n error hay empty state.',
        ),
        ConnectedBridgeStateDraft(
          id: 'context_removed',
          label: 'Context removed by user',
          description: 'User báº¥m bá» liÃªn káº¿t trÃªn BridgeSourceBar.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaStudio'],
          behavior:
              'áº¨n BridgeSourceBar, steps trá»Ÿ vá» tráº¡ng thÃ¡i táº¡o room thÆ°á»ng.',
        ),
        ConnectedBridgeStateDraft(
          id: 'verified_locked',
          label: 'Verified future locked',
          description:
              'Bridge features chÆ°a má»Ÿ cho verified/future screens.',
          tone: ArenaBridgeTone.prediction,
          affectedScreens: ['VerifiedChallengesPage'],
          behavior:
              'Hien release-gated preview message, khong navigate va khong CTA.',
        ),
      ],
      connectedFlows: [
        ConnectedFlowDraft(
          id: 'prediction_to_arena',
          name: 'Prediction to Arena Studio',
          tone: ArenaBridgeTone.arena,
          steps: [
            ConnectedFlowStepDraft(
              label: 'Home',
              route: '/',
              description: 'Discovery section -> tap Predictions card.',
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionsHome',
              route: '/markets/predictions',
              description: 'Browse events, filter by topic.',
            ),
            ConnectedFlowStepDraft(
              label: 'EventDetail',
              route: '/markets/predictions/event/:id',
              description: 'Xem event, scroll Ä‘áº¿n Arena section.',
            ),
            ConnectedFlowStepDraft(
              label: 'ConfirmSheet',
              route: '/markets/predictions/event/:id',
              description:
                  'Táº¡o room Arena tá»« event nÃ y? Confirmation sheet cÃ³ 3 disclosure bullets.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ArenaStudio',
              route: '/arena/studio',
              description:
                  'BridgeSourceBar top, suggested templates, prefill context.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description:
                  'Room created, linked source card hiá»‡n event gá»‘c.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'arena_to_prediction',
          name: 'Arena to Prediction Market',
          tone: ArenaBridgeTone.content,
          steps: [
            ConnectedFlowStepDraft(
              label: 'ArenaHome',
              route: '/arena',
              description: 'Browse modes and rooms.',
            ),
            ConnectedFlowStepDraft(
              label: 'ModeDetail',
              route: '/arena/mode/:id',
              description:
                  'PredictionContextCard hiá»‡n khi mode cÃ³ related topic.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Context card + sheet hiá»ƒu ranh giá»›i.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionEvent',
              route: '/markets/predictions/event/:id',
              description: 'Navigate qua CTA xem thá»‹ trÆ°á»ng dá»± Ä‘oÃ¡n.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'profile_dual',
          name: 'Profile dual surfaces',
          tone: ArenaBridgeTone.prediction,
          steps: [
            ConnectedFlowStepDraft(
              label: 'Profile',
              route: '/profile',
              description: 'ProfileModuleBlocks: 2 cards tÃ¡ch biá»‡t.',
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionPortfolio',
              route: '/markets/predictions/portfolio',
              description: 'Prediction card -> positions and P/L.',
            ),
            ConnectedFlowStepDraft(
              label: 'MyArena',
              route: '/profile/arena',
              description:
                  'Arena card -> Points, rooms, trust score, non-financial.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'market_discover',
          name: 'MarketList to KhÃ¡m phÃ¡ thÃªm',
          tone: ArenaBridgeTone.disclosure,
          steps: [
            ConnectedFlowStepDraft(
              label: 'MarketList',
              route: '/markets',
              description: 'Browse crypto, scroll Ä‘áº¿n cuá»‘i.',
            ),
            ConnectedFlowStepDraft(
              label: 'DiscoverMore',
              route: '/markets',
              description: 'Predictions card + Arena card.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'Choice: Predictions',
              route: '/markets/predictions',
              description:
                  'Tap Dá»± Ä‘oÃ¡n thá»‹ trÆ°á»ng -> PredictionsHome.',
            ),
            ConnectedFlowStepDraft(
              label: 'Choice: Arena',
              route: '/arena',
              description: 'Tap Open Arena -> ArenaHome.',
            ),
          ],
        ),
      ],
      sharedItems: [
        ConnectedRegistryItemDraft(
          name: 'Topic Taxonomy',
          description: '8 shared topics dÃ¹ng chung cho Predictions vÃ  Arena.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Context Cards',
          description:
              'PredictionContextCard vÃ  ArenaRelatedRoomCard bridge by content, not value.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Discovery Cards',
          description:
              'HomeDiscoverySection vÃ  DiscoverMoreSection lÃ  entry points an toÃ n.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Profile Surface',
          description:
              'ProfileModuleBlocks Ä‘áº·t 2 blocks tÃ¡ch biá»‡t trÃªn cÃ¹ng má»™t profile page.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Bridge Disclosures',
          description:
              'ModuleBoundaryBanner, BoundaryInfoRow, ModuleLabelBadge dÃ¹ng chung.',
        ),
      ],
      separateItems: [
        ConnectedRegistryItemDraft(
          name: 'Wallet',
          description: 'Prediction cÃ³ real wallet. Arena khÃ´ng cÃ³ wallet.',
        ),
        ConnectedRegistryItemDraft(
          name: 'PnL',
          description:
              'Prediction cÃ³ profit/loss báº±ng tiá»n tháº­t. Arena chá»‰ cÃ³ net points change.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Points Ledger',
          description: 'Arena only. Prediction khÃ´ng dÃ¹ng points system.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Order Receipts',
          description:
              'Prediction trade receipts khÃ¡c Arena result receipt points-only.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Settlement',
          description:
              'Prediction settlement tÃ¡ch biá»‡t vá»›i Arena points redistribution.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Leaderboard Metrics',
          description:
              'Prediction ranking vÃ  Arena ranking khÃ´ng bao giá» gá»™p.',
        ),
      ],
      forbiddenPatterns: [
        ConnectedForbiddenPatternDraft(
          pattern: 'Points cáº¡nh PnL',
          reason:
              'Arena Points lÃ  Ä‘iá»ƒm chÆ¡i, PnL lÃ  tiá»n tháº­t. Äáº·t cáº¡nh nhau gÃ¢y nháº§m láº«n.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Merged leaderboard',
          reason:
              'Gá»™p points Arena vá»›i PnL Prediction sai báº£n cháº¥t 2 module.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Wallet wording trong Arena',
          reason:
              'KhÃ´ng dÃ¹ng VÃ­, Sá»‘ dÆ°, TÃ i sáº£n trong Arena bridge context.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Arena card thiáº¿u disclosure',
          reason:
              'Má»i bridge card Arena pháº£i cÃ³ badge Points only hoáº·c Market context only.',
          severity: ConnectedRuleSeverity.high,
        ),
      ],
      routeRegistry: [
        ConnectedRouteEntryDraft(
          route: '/',
          page: 'HomePage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['HomeDiscoverySection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/profile',
          page: 'ProfilePage',
          bridgeType: ConnectedBridgeType.bidirectional,
          bridgeComponents: ['ProfileModuleBlocks'],
        ),
        ConnectedRouteEntryDraft(
          route: '/markets',
          page: 'MarketListPage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['DiscoverMoreSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/markets/predictions',
          page: 'PredictionsHomePage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['TopicChipBar'],
        ),
        ConnectedRouteEntryDraft(
          route: '/markets/predictions/event/:id',
          page: 'PredictionEventDetailPage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['ArenaRelatedRoomsSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena',
          page: 'ArenaHomePage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['PredictionInsightSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/studio',
          page: 'ArenaStudioPage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['BridgeSourceBar'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/mode/:id',
          page: 'ArenaModeDetailPage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['PredictionContextCard'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/challenge/:id',
          page: 'ArenaChallengeDetailPage',
          bridgeType: ConnectedBridgeType.bidirectional,
          bridgeComponents: ['PredictionContextCard', 'LinkedSourceCard'],
        ),
      ],
      componentRegistry: [
        ConnectedComponentEntryDraft(
          name: 'HomeDiscoverySection',
          file: 'ArenaPredictionBridges.tsx',
          module: '07D',
          usedIn: ['HomePage'],
          disclosure: 'Má»—i card cÃ³ badge module.',
        ),
        ConnectedComponentEntryDraft(
          name: 'PredictionContextCard',
          file: 'ArenaPredictionBridges.tsx',
          module: '07D',
          usedIn: ['ArenaChallengeDetail', 'ArenaModeDetail'],
          disclosure: 'Market context only badge.',
        ),
        ConnectedComponentEntryDraft(
          name: 'BridgeSourceBar',
          file: 'ArenaPredictionFoundation.tsx',
          module: '09A',
          usedIn: ['ArenaStudio'],
          disclosure: 'Nguá»“n bá»‘i cáº£nh + remove action.',
        ),
        ConnectedComponentEntryDraft(
          name: 'DualModuleStatCard',
          file: 'ArenaPredictionFoundation.tsx',
          module: '09A',
          usedIn: ['ProfileModuleBlocks'],
          disclosure: 'Separate stat blocks.',
        ),
      ],
      bridgeRules: [
        ConnectedBridgeRuleDraft(
          field: 'eventId',
          allowed: true,
          reason:
              'Identify prediction event nguá»“n, chá»‰ dÃ¹ng Ä‘á»ƒ link back.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'topic',
          allowed: true,
          reason: 'Shared topic taxonomy. Neutral content classification.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'wallet balance',
          allowed: false,
          reason:
              'Sá»‘ dÆ° vÃ­ lÃ  dá»¯ liá»‡u tÃ i chÃ­nh, khÃ´ng carry qua Arena.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'PnL',
          allowed: false,
          reason:
              'Profit/loss lÃ  dá»¯ liá»‡u giao dá»‹ch tháº­t, Arena chá»‰ cÃ³ points.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'settlement records',
          allowed: false,
          reason:
              'Arena chá»‰ settle points, khÃ´ng nháº­n settlement tÃ i chÃ­nh.',
        ),
      ],
      qaChecklist: [
        ConnectedQaCheckDraft(
          id: 'qa1',
          category: 'Disclosure',
          check: 'Má»i bridge card cÃ³ disclosure badge.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa2',
          category: 'Boundary',
          check: 'Prediction vÃ  Arena stats tÃ¡ch biá»‡t, khÃ´ng gá»™p.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa3',
          category: 'Navigation',
          check:
              'Prediction -> Arena flow cÃ³ confirmation sheet trÆ°á»›c navigate.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa4',
          category: 'State',
          check: 'Bridge disabled state áº©n sáº¡ch bridge sections.',
          severity: ConnectedQaSeverity.should,
        ),
      ],
      footerDisclosure:
          'Trang nÃ y dÃ nh cho PM / Designer / Dev / QA, khÃ´ng pháº£i user-facing. ToÃ n bá»™ ná»™i dung lÃ  handoff documentation cho há»‡ sinh thÃ¡i káº¿t ná»‘i giá»¯a Open Arena (points-only) vÃ  Prediction Markets (real positions).',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
