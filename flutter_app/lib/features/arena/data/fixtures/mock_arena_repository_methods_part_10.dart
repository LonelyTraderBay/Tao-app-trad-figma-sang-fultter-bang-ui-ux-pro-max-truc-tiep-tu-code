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
              'Discovery cards cho Predictions và Arena. Mỗi card có disclosure badge rõ module. Không merge metrics.',
        ),
        ConnectedScreenDraft(
          name: 'ProfilePage_vFinal_Connected',
          route: '/profile',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A + 09B',
          bridgeComponents: ['ProfileModuleBlocks', 'DualModuleStatCard'],
          notes:
              'Dual surface tách biệt: Prediction Portfolio vs MyArena. Stats không bao giờ gộp.',
        ),
        ConnectedScreenDraft(
          name: 'MarketListPage_vFinal_Connected',
          route: '/markets',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['DiscoverMoreSection'],
          notes:
              'Khám phá thêm section cuối page. Safe bridge dẫn đến Predictions hoặc Arena, có disclosure.',
        ),
        ConnectedScreenDraft(
          name: 'PredictionsHomePage_vFinal_Connected',
          route: '/markets/predictions',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A',
          bridgeComponents: ['TopicChipBar (shared taxonomy)'],
          notes:
              'Topic chips dùng shared taxonomy. Discovery card Arena ở cuối với badge Points only.',
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
              'Arena rooms bridge section + CTA tạo Arena từ event này, qua confirmation sheet trước khi mở Arena Studio.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaHomePage_vFinal_Connected',
          route: '/arena',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['PredictionInsightSection'],
          notes:
              'Prediction insight section ở cuối. Badge Market context only, không ảnh hưởng Arena Points.',
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
              'Khi mở từ Prediction: source bar top, suggest templates, prefill context, safety snapshot và linked event rows.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaModeDetailPage_vFinal_Connected',
          route: '/arena/mode/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09C',
          bridgeComponents: ['PredictionContextCard', 'mapArenaTagToTopic'],
          notes:
              'Mode có tags liên quan prediction topic hiển thị context card với CTA xem thị trường dự đoán.',
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
              'Prediction context bridge + linked source card. Disclosure: kết quả room Arena không phải kết quả trade.',
        ),
      ],
      bridgeStates: [
        ConnectedBridgeStateDraft(
          id: 'linked_available',
          label: 'Linked context available',
          description:
              'Bridge context tồn tại và valid. Hiển thị bridge card + disclosure.',
          tone: ArenaBridgeTone.disclosure,
          affectedScreens: [
            'PredictionEventDetail',
            'ArenaStudio',
            'ArenaChallengeDetail',
            'ArenaModeDetail',
          ],
          behavior:
              'Show bridge card, context bar, related rooms/events. Disclosure badge luôn hiện.',
        ),
        ConnectedBridgeStateDraft(
          id: 'linked_unavailable',
          label: 'Linked context unavailable',
          description: 'Event hoặc room nguồn không còn tồn tại hoặc bị xoá.',
          tone: ArenaBridgeTone.blocked,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show fallback card, disable CTA xem event gốc, giữ room hoạt động bình thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'stale_context',
          label: 'Stale context',
          description: 'Context quá cũ hoặc event đã resolved/expired.',
          tone: ArenaBridgeTone.arena,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show warning chip Context cũ. CTA vẫn navigate đến event ở trạng thái resolved.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_arena_rooms',
          label: 'No related Arena rooms',
          description: 'Prediction event chưa có rooms Arena liên quan.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['PredictionEventDetail'],
          behavior:
              'Ẩn ArenaRelatedRoomsSection, vẫn giữ CTA tạo Arena từ event này.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_prediction_events',
          label: 'No related Prediction events',
          description:
              'Arena mode/challenge không có Prediction events match topic.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaModeDetail'],
          behavior:
              'Ẩn PredictionContextCard và link hiểu ranh giới. Room hoạt động bình thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'bridge_disabled',
          label: 'Bridge disabled',
          description:
              'Feature flag tắt bridge do maintenance hoặc chưa launch.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['All connected screens'],
          behavior:
              'Ẩn toàn bộ bridge sections, không hiện error hay empty state.',
        ),
        ConnectedBridgeStateDraft(
          id: 'context_removed',
          label: 'Context removed by user',
          description: 'User bấm bỏ liên kết trên BridgeSourceBar.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaStudio'],
          behavior:
              'Ẩn BridgeSourceBar, steps trở về trạng thái tạo room thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'verified_locked',
          label: 'Verified future locked',
          description: 'Bridge features chưa mở cho verified/future screens.',
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
              description: 'Xem event, scroll đến Arena section.',
            ),
            ConnectedFlowStepDraft(
              label: 'ConfirmSheet',
              route: '/markets/predictions/event/:id',
              description:
                  'Tạo room Arena từ event này? Confirmation sheet có 3 disclosure bullets.',
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
              description: 'Room created, linked source card hiện event gốc.',
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
                  'PredictionContextCard hiện khi mode có related topic.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Context card + sheet hiểu ranh giới.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionEvent',
              route: '/markets/predictions/event/:id',
              description: 'Navigate qua CTA xem thị trường dự đoán.',
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
              description: 'ProfileModuleBlocks: 2 cards tách biệt.',
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
          name: 'MarketList to Khám phá thêm',
          tone: ArenaBridgeTone.disclosure,
          steps: [
            ConnectedFlowStepDraft(
              label: 'MarketList',
              route: '/markets',
              description: 'Browse crypto, scroll đến cuối.',
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
              description: 'Tap Dự đoán thị trường -> PredictionsHome.',
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
          description: '8 shared topics dùng chung cho Predictions và Arena.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Context Cards',
          description:
              'PredictionContextCard và ArenaRelatedRoomCard bridge by content, not value.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Discovery Cards',
          description:
              'HomeDiscoverySection và DiscoverMoreSection là entry points an toàn.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Profile Surface',
          description:
              'ProfileModuleBlocks đặt 2 blocks tách biệt trên cùng một profile page.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Bridge Disclosures',
          description:
              'ModuleBoundaryBanner, BoundaryInfoRow, ModuleLabelBadge dùng chung.',
        ),
      ],
      separateItems: [
        ConnectedRegistryItemDraft(
          name: 'Wallet',
          description: 'Prediction có real wallet. Arena không có wallet.',
        ),
        ConnectedRegistryItemDraft(
          name: 'PnL',
          description:
              'Prediction có profit/loss bằng tiền thật. Arena chỉ có net points change.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Points Ledger',
          description: 'Arena only. Prediction không dùng points system.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Order Receipts',
          description:
              'Prediction trade receipts khác Arena result receipt points-only.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Settlement',
          description:
              'Prediction settlement tách biệt với Arena points redistribution.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Leaderboard Metrics',
          description: 'Prediction ranking và Arena ranking không bao giờ gộp.',
        ),
      ],
      forbiddenPatterns: [
        ConnectedForbiddenPatternDraft(
          pattern: 'Points cạnh PnL',
          reason:
              'Arena Points là điểm chơi, PnL là tiền thật. Đặt cạnh nhau gây nhầm lẫn.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Merged leaderboard',
          reason: 'Gộp points Arena với PnL Prediction sai bản chất 2 module.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Wallet wording trong Arena',
          reason: 'Không dùng Ví, Số dư, Tài sản trong Arena bridge context.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Arena card thiếu disclosure',
          reason:
              'Mọi bridge card Arena phải có badge Points only hoặc Market context only.',
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
          disclosure: 'Mỗi card có badge module.',
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
          disclosure: 'Nguồn bối cảnh + remove action.',
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
          reason: 'Identify prediction event nguồn, chỉ dùng để link back.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'topic',
          allowed: true,
          reason: 'Shared topic taxonomy. Neutral content classification.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'wallet balance',
          allowed: false,
          reason: 'Số dư ví là dữ liệu tài chính, không carry qua Arena.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'PnL',
          allowed: false,
          reason: 'Profit/loss là dữ liệu giao dịch thật, Arena chỉ có points.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'settlement records',
          allowed: false,
          reason: 'Arena chỉ settle points, không nhận settlement tài chính.',
        ),
      ],
      qaChecklist: [
        ConnectedQaCheckDraft(
          id: 'qa1',
          category: 'Disclosure',
          check: 'Mọi bridge card có disclosure badge.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa2',
          category: 'Boundary',
          check: 'Prediction và Arena stats tách biệt, không gộp.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa3',
          category: 'Navigation',
          check:
              'Prediction -> Arena flow có confirmation sheet trước navigate.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa4',
          category: 'State',
          check: 'Bridge disabled state ẩn sạch bridge sections.',
          severity: ConnectedQaSeverity.should,
        ),
      ],
      footerDisclosure:
          'Trang này dành cho PM / Designer / Dev / QA, không phải user-facing. Toàn bộ nội dung là handoff documentation cho hệ sinh thái kết nối giữa Open Arena (points-only) và Prediction Markets (real positions).',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
