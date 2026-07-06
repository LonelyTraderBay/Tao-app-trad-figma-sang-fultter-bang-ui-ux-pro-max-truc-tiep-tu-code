part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryProductionEcosystemMethods
    on _MockArenaRepositoryBase {
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
