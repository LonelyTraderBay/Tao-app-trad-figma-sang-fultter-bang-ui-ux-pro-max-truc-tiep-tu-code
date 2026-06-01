part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryMethodsPart09 on _MockArenaRepositoryBase {
  @override
  ArenaPredictionBridgeSnapshot getArenaPredictionBridge() {
    return const ArenaPredictionBridgeSnapshot(
      endpoint: '/api/mobile/arena/arena-bridge',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      principles: [
        ArenaBridgePrincipleDraft(
          number: 1,
          title: 'Connect by content, not by value',
          description:
              'Bridge chỉ qua topic/category/event title. Không bao giờ qua tiền, wallet, hoặc số dư.',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgePrincipleDraft(
          number: 2,
          title: 'Arena Points are not financial assets',
          description:
              'Points are social scoring only. They cannot be converted, withdrawn, or traded.',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgePrincipleDraft(
          number: 3,
          title: 'Prediction Markets không chia sẻ wallet/số dư với Arena',
          description:
              'Wallet, balance, P/L của Prediction hoàn toàn tách biệt. Không hiển thị chéo.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgePrincipleDraft(
          number: 4,
          title: 'Mọi bridge đều phải có disclosure',
          description:
              'ModuleBoundaryBanner hoặc BoundaryInfoRow bắt buộc khi hiển thị content cross-module.',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgePrincipleDraft(
          number: 5,
          title: 'Không gộp leaderboard metrics',
          description:
              'Leaderboard Prediction khác Leaderboard Arena. Không tổng hợp, không so sánh.',
          tone: ArenaBridgeTone.danger,
        ),
        ArenaBridgePrincipleDraft(
          number: 6,
          title: 'Không gộp settlement / receipts / ledger',
          description:
              'ResultReceipt, Points Ledger, Order Receipt là 3 hệ thống riêng. Không merge.',
          tone: ArenaBridgeTone.blocked,
        ),
      ],
      allowedItems: [
        ArenaBridgeRuleDraft(
          label: 'Topic',
          description: 'Chủ đề chung: Crypto, Macro, Sports...',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Category',
          description: 'Phân loại event/mode',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Event title',
          description: 'Tên sự kiện prediction làm bối cảnh',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Source label',
          description: 'Label "Nguồn bối cảnh"',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'EventId context',
          description: 'Link đến event detail (read-only)',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Trust/Safety summary',
          description: 'Trust score, Fair Play badge',
          allowed: true,
        ),
      ],
      notAllowedItems: [
        ArenaBridgeRuleDraft(
          label: 'Wallet balance',
          description: 'Không hiển thị số dư ví ở module khác',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'PnL',
          description: 'Không hiển thị lãi/lỗ prediction ở Arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Open orders',
          description: 'Không hiển thị lệnh đang mở chéo module',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Payout value',
          description: 'Không hiển thị tiền thật ở Arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Order receipt',
          description: 'Không gộp receipt prediction + arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Points conversion',
          description: 'Không quy đổi Arena Points thành tiền',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Shared settlement',
          description: 'Không kết hợp settlement 2 module',
          allowed: false,
        ),
      ],
      topics: [
        ArenaBridgeTopicDraft(
          id: 'crypto',
          label: 'Crypto',
          predictionUsage: 'category filter, event tags',
          arenaUsage: 'mode tags, room filter',
          bridgeUsage: 'bridge matching key',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeTopicDraft(
          id: 'macro',
          label: 'Macro',
          predictionUsage: 'macro event grouping',
          arenaUsage: 'forecast challenge tags',
          bridgeUsage: 'topic-only context',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeTopicDraft(
          id: 'politics',
          label: 'Politics',
          predictionUsage: 'event category',
          arenaUsage: 'discussion mode tag',
          bridgeUsage: 'read-only context',
          tone: ArenaBridgeTone.danger,
        ),
        ArenaBridgeTopicDraft(
          id: 'sports',
          label: 'Sports',
          predictionUsage: 'match event tags',
          arenaUsage: 'friendly challenge tags',
          bridgeUsage: 'topic-only context',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgeTopicDraft(
          id: 'tech',
          label: 'Tech',
          predictionUsage: 'launch / adoption events',
          arenaUsage: 'creator mode tags',
          bridgeUsage: 'shared taxonomy',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeTopicDraft(
          id: 'ai',
          label: 'AI',
          predictionUsage: 'AI market events',
          arenaUsage: 'AI challenge tags',
          bridgeUsage: 'shared taxonomy',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeTopicDraft(
          id: 'culture',
          label: 'Culture',
          predictionUsage: 'culture event tags',
          arenaUsage: 'community challenge tags',
          bridgeUsage: 'content discovery',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeTopicDraft(
          id: 'community',
          label: 'Community',
          predictionUsage: 'community event tags',
          arenaUsage: 'creator discovery tags',
          bridgeUsage: 'safe discovery',
          tone: ArenaBridgeTone.disclosure,
        ),
      ],
      boundaryBanners: [
        ArenaBridgeBoundaryDraft(
          id: 'arena_points_only',
          title: 'Arena Points are not financial assets',
          description:
              'Points are social scoring only. They cannot be converted, withdrawn, or traded.',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'prediction_market',
          title: 'Prediction Markets',
          description:
              'Vị thế thực trên thị trường dự đoán, tách biệt hoàn toàn với Arena Points.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'market_context_only',
          title: 'Market context only',
          description:
              'Chỉ dùng làm bối cảnh tham khảo. Không ảnh hưởng vị thế hoặc số dư.',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'no_wallet_link',
          title: 'Không liên quan Wallet',
          description:
              'Module này không kết nối với ví hoặc số dư tài sản của bạn.',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'verified_future',
          title: 'Verified - Future',
          description: 'Tính năng Verified Challenges sẽ mở trong tương lai.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'risk_disclosure',
          title: 'Lưu ý rủi ro',
          description:
              'Prediction Markets có rủi ro. Arena Points không phải tiền thật.',
          tone: ArenaBridgeTone.danger,
        ),
      ],
      badges: [
        ArenaBridgeBadgeDraft(
          id: 'open_arena',
          label: 'Open Arena',
          description: 'Points-only challenge surface',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeBadgeDraft(
          id: 'prediction_markets',
          label: 'Prediction Markets',
          description: 'Value-based prediction surface',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBadgeDraft(
          id: 'linked_context',
          label: 'Linked Context',
          description: 'Topic/event context only',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeBadgeDraft(
          id: 'future',
          label: 'Future',
          description: 'Release gate pending',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeBadgeDraft(
          id: 'creator_mode',
          label: 'Creator Mode',
          description: 'Arena creator flow',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeBadgeDraft(
          id: 'event_context',
          label: 'Event Context',
          description: 'Read-only Prediction event context',
          tone: ArenaBridgeTone.content,
        ),
      ],
      infoRows: [
        ArenaBridgeInfoRowDraft(
          text:
              'Arena Points are social scoring only; no conversion, withdrawal, or trading.',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeInfoRowDraft(
          text: 'Prediction Markets tách biệt hoàn toàn.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeInfoRowDraft(
          text: 'Module này không liên quan ví của bạn.',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeInfoRowDraft(
          text: 'Chỉ dùng làm bối cảnh tham khảo.',
          tone: ArenaBridgeTone.content,
        ),
      ],
      bridgeComponents: [
        ArenaBridgeComponentDraft(
          name: 'PredictionContextCard',
          badgeLabel: 'Event context',
          description:
              'Dùng trong Arena pages. Hiển thị bối cảnh thị trường prediction, không phải trading UI.',
          sampleTitle: 'BTC vượt 100,000 USD trước 31/03/2026?',
          sampleMeta: 'Yes · 72% probability · read-only context',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeComponentDraft(
          name: 'ArenaRelatedRoomCard',
          badgeLabel: 'Open Arena',
          description:
              'Dùng trong Prediction pages. Room card có trust badge, resolution, privacy.',
          sampleTitle: 'Fed Rate Predict - March 2026',
          sampleMeta: '50 pts · 67/100 slots · Fair Play 88',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeComponentDraft(
          name: 'DualModuleStatCard',
          badgeLabel: 'Linked context',
          description:
              'Dùng trên Profile. 2 khối stats tách biệt, không gộp số liệu.',
          sampleTitle: 'Prediction block + Arena block',
          sampleMeta: 'Tap từng block để mở module riêng',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgeComponentDraft(
          name: 'BridgeSourceBar',
          badgeLabel: 'Market context only',
          description:
              'Dùng trong Arena Studio khi user đến từ Prediction event. Có remove action.',
          sampleTitle: 'Nguồn bối cảnh: BTC vượt 100,000 USD?',
          sampleMeta: 'Topic Crypto · Event pred-1 · removable',
          tone: ArenaBridgeTone.content,
        ),
      ],
      examples: [
        ArenaBridgeExampleDraft(
          id: 'example_a',
          status: ArenaBridgeExampleStatus.correct,
          title: 'PredictionContextCard trong Arena Challenge',
          description:
              'Hiển thị bối cảnh prediction bên trong challenge detail với badge rõ ràng.',
          frameTitle: 'ArenaChallengeDetailPage',
          evidenceRows: [
            'Disclosure badge + microcopy bắt buộc.',
            'Không hiển thị order/PnL.',
          ],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_b',
          status: ArenaBridgeExampleStatus.correct,
          title: 'ArenaRelatedRoomCard trong Prediction Event',
          description:
              'Hiển thị room Arena liên quan cùng topic, có Points-only badge.',
          frameTitle: 'PredictionEventDetailPage',
          evidenceRows: [
            'Trust badge + Points-only badge bắt buộc.',
            'Không hiển thị wallet balance.',
          ],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_c',
          status: ArenaBridgeExampleStatus.correct,
          title: 'DualModuleStatCard trên Profile',
          description:
              '2 block tách biệt với boundary separator. Số liệu không gộp.',
          frameTitle: 'ProfilePage',
          evidenceRows: ['Mỗi block có badge riêng.', 'Tap mở module riêng.'],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_d',
          status: ArenaBridgeExampleStatus.blocked,
          title: 'Gộp Points + PnL',
          description:
              'Anti-pattern tạo nhầm lẫn giữa tiền thật và điểm xã hội.',
          frameTitle: 'WRONG - MergedStatsCard',
          evidenceRows: [
            'Không gộp Points + PnL vào cùng 1 card.',
            'Không hiển thị tổng tài sản gộp 2 module.',
            'Không so sánh Points = tiền thật.',
          ],
        ),
      ],
      dualStats: ArenaBridgeDualStatsDraft(
        predictionPositions: 5,
        predictionPnlLabel: '+127.50 USD',
        predictionPnlPositive: true,
        arenaPointsLabel: '2,450 pts',
        arenaRooms: 3,
      ),
      footerDisclosure:
          'Foundation layer - boundary phải khóa trước khi nối flow. Open Arena = Points only. Prediction Markets = Real positions. Không bao giờ gộp.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
