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
              'Bridge chÃƒÂ¡Ã‚Â»Ã¢â‚¬Â° qua topic/category/event title. KhÃƒÆ’Ã‚Â´ng bao giÃƒÂ¡Ã‚Â»Ã‚Â qua tiÃƒÂ¡Ã‚Â»Ã‚Ân, wallet, hoÃƒÂ¡Ã‚ÂºÃ‚Â·c sÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœ dÃƒâ€ Ã‚Â°.',
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
          title:
              'Prediction Markets khÃƒÆ’Ã‚Â´ng chia sÃƒÂ¡Ã‚ÂºÃ‚Â» wallet/sÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœ dÃƒâ€ Ã‚Â° vÃƒÂ¡Ã‚Â»Ã¢â‚¬Âºi Arena',
          description:
              'Wallet, balance, P/L cÃƒÂ¡Ã‚Â»Ã‚Â§a Prediction hoÃƒÆ’Ã‚Â n toÃƒÆ’Ã‚Â n tÃƒÆ’Ã‚Â¡ch biÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡t. KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ chÃƒÆ’Ã‚Â©o.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgePrincipleDraft(
          number: 4,
          title:
              'MÃƒÂ¡Ã‚Â»Ã‚Âi bridge Ãƒâ€žÃ¢â‚¬ËœÃƒÂ¡Ã‚Â»Ã‚Âu phÃƒÂ¡Ã‚ÂºÃ‚Â£i cÃƒÆ’Ã‚Â³ disclosure',
          description:
              'ModuleBoundaryBanner hoÃƒÂ¡Ã‚ÂºÃ‚Â·c BoundaryInfoRow bÃƒÂ¡Ã‚ÂºÃ‚Â¯t buÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢c khi hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ content cross-module.',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgePrincipleDraft(
          number: 5,
          title: 'KhÃƒÆ’Ã‚Â´ng gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p leaderboard metrics',
          description:
              'Leaderboard Prediction khÃƒÆ’Ã‚Â¡c Leaderboard Arena. KhÃƒÆ’Ã‚Â´ng tÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¢ng hÃƒÂ¡Ã‚Â»Ã‚Â£p, khÃƒÆ’Ã‚Â´ng so sÃƒÆ’Ã‚Â¡nh.',
          tone: ArenaBridgeTone.danger,
        ),
        ArenaBridgePrincipleDraft(
          number: 6,
          title:
              'KhÃƒÆ’Ã‚Â´ng gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p settlement / receipts / ledger',
          description:
              'ResultReceipt, Points Ledger, Order Receipt lÃƒÆ’Ã‚Â  3 hÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡ thÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœng riÃƒÆ’Ã‚Âªng. KhÃƒÆ’Ã‚Â´ng merge.',
          tone: ArenaBridgeTone.blocked,
        ),
      ],
      allowedItems: [
        ArenaBridgeRuleDraft(
          label: 'Topic',
          description:
              'ChÃƒÂ¡Ã‚Â»Ã‚Â§ Ãƒâ€žÃ¢â‚¬ËœÃƒÂ¡Ã‚Â»Ã‚Â chung: Crypto, Macro, Sports...',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Category',
          description: 'PhÃƒÆ’Ã‚Â¢n loÃƒÂ¡Ã‚ÂºÃ‚Â¡i event/mode',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Event title',
          description:
              'TÃƒÆ’Ã‚Âªn sÃƒÂ¡Ã‚Â»Ã‚Â± kiÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡n prediction lÃƒÆ’Ã‚Â m bÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi cÃƒÂ¡Ã‚ÂºÃ‚Â£nh',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'Source label',
          description:
              'Label "NguÃƒÂ¡Ã‚Â»Ã¢â‚¬Å“n bÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi cÃƒÂ¡Ã‚ÂºÃ‚Â£nh"',
          allowed: true,
        ),
        ArenaBridgeRuleDraft(
          label: 'EventId context',
          description:
              'Link Ãƒâ€žÃ¢â‚¬ËœÃƒÂ¡Ã‚ÂºÃ‚Â¿n event detail (read-only)',
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
          description:
              'KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ sÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœ dÃƒâ€ Ã‚Â° vÃƒÆ’Ã‚Â­ ÃƒÂ¡Ã‚Â»Ã…Â¸ module khÃƒÆ’Ã‚Â¡c',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'PnL',
          description:
              'KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ lÃƒÆ’Ã‚Â£i/lÃƒÂ¡Ã‚Â»Ã¢â‚¬â€ prediction ÃƒÂ¡Ã‚Â»Ã…Â¸ Arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Open orders',
          description:
              'KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ lÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡nh Ãƒâ€žÃ¢â‚¬Ëœang mÃƒÂ¡Ã‚Â»Ã…Â¸ chÃƒÆ’Ã‚Â©o module',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Payout value',
          description:
              'KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ tiÃƒÂ¡Ã‚Â»Ã‚Ân thÃƒÂ¡Ã‚ÂºÃ‚Â­t ÃƒÂ¡Ã‚Â»Ã…Â¸ Arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Order receipt',
          description:
              'KhÃƒÆ’Ã‚Â´ng gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p receipt prediction + arena',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Points conversion',
          description:
              'KhÃƒÆ’Ã‚Â´ng quy Ãƒâ€žÃ¢â‚¬ËœÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¢i Arena Points thÃƒÆ’Ã‚Â nh tiÃƒÂ¡Ã‚Â»Ã‚Ân',
          allowed: false,
        ),
        ArenaBridgeRuleDraft(
          label: 'Shared settlement',
          description:
              'KhÃƒÆ’Ã‚Â´ng kÃƒÂ¡Ã‚ÂºÃ‚Â¿t hÃƒÂ¡Ã‚Â»Ã‚Â£p settlement 2 module',
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
              'VÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ thÃƒÂ¡Ã‚ÂºÃ‚Â¿ thÃƒÂ¡Ã‚Â»Ã‚Â±c trÃƒÆ’Ã‚Âªn thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ trÃƒâ€ Ã‚Â°ÃƒÂ¡Ã‚Â»Ã‚Âng dÃƒÂ¡Ã‚Â»Ã‚Â± Ãƒâ€žÃ¢â‚¬ËœoÃƒÆ’Ã‚Â¡n, tÃƒÆ’Ã‚Â¡ch biÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡t hoÃƒÆ’Ã‚Â n toÃƒÆ’Ã‚Â n vÃƒÂ¡Ã‚Â»Ã¢â‚¬Âºi Arena Points.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'market_context_only',
          title: 'Market context only',
          description:
              'ChÃƒÂ¡Ã‚Â»Ã¢â‚¬Â° dÃƒÆ’Ã‚Â¹ng lÃƒÆ’Ã‚Â m bÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi cÃƒÂ¡Ã‚ÂºÃ‚Â£nh tham khÃƒÂ¡Ã‚ÂºÃ‚Â£o. KhÃƒÆ’Ã‚Â´ng ÃƒÂ¡Ã‚ÂºÃ‚Â£nh hÃƒâ€ Ã‚Â°ÃƒÂ¡Ã‚Â»Ã…Â¸ng vÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ thÃƒÂ¡Ã‚ÂºÃ‚Â¿ hoÃƒÂ¡Ã‚ÂºÃ‚Â·c sÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœ dÃƒâ€ Ã‚Â°.',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'no_wallet_link',
          title: 'KhÃƒÆ’Ã‚Â´ng liÃƒÆ’Ã‚Âªn quan Wallet',
          description:
              'Module nÃƒÆ’Ã‚Â y khÃƒÆ’Ã‚Â´ng kÃƒÂ¡Ã‚ÂºÃ‚Â¿t nÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi vÃƒÂ¡Ã‚Â»Ã¢â‚¬Âºi vÃƒÆ’Ã‚Â­ hoÃƒÂ¡Ã‚ÂºÃ‚Â·c sÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœ dÃƒâ€ Ã‚Â° tÃƒÆ’Ã‚Â i sÃƒÂ¡Ã‚ÂºÃ‚Â£n cÃƒÂ¡Ã‚Â»Ã‚Â§a bÃƒÂ¡Ã‚ÂºÃ‚Â¡n.',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'verified_future',
          title: 'Verified - Future',
          description:
              'TÃƒÆ’Ã‚Â­nh nÃƒâ€žÃ†â€™ng Verified Challenges sÃƒÂ¡Ã‚ÂºÃ‚Â½ mÃƒÂ¡Ã‚Â»Ã…Â¸ trong tÃƒâ€ Ã‚Â°Ãƒâ€ Ã‚Â¡ng lai.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeBoundaryDraft(
          id: 'risk_disclosure',
          title: 'LÃƒâ€ Ã‚Â°u ÃƒÆ’Ã‚Â½ rÃƒÂ¡Ã‚Â»Ã‚Â§i ro',
          description:
              'Prediction Markets cÃƒÆ’Ã‚Â³ rÃƒÂ¡Ã‚Â»Ã‚Â§i ro. Arena Points khÃƒÆ’Ã‚Â´ng phÃƒÂ¡Ã‚ÂºÃ‚Â£i tiÃƒÂ¡Ã‚Â»Ã‚Ân thÃƒÂ¡Ã‚ÂºÃ‚Â­t.',
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
          text:
              'Prediction Markets tÃƒÆ’Ã‚Â¡ch biÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡t hoÃƒÆ’Ã‚Â n toÃƒÆ’Ã‚Â n.',
          tone: ArenaBridgeTone.prediction,
        ),
        ArenaBridgeInfoRowDraft(
          text:
              'Module nÃƒÆ’Ã‚Â y khÃƒÆ’Ã‚Â´ng liÃƒÆ’Ã‚Âªn quan vÃƒÆ’Ã‚Â­ cÃƒÂ¡Ã‚Â»Ã‚Â§a bÃƒÂ¡Ã‚ÂºÃ‚Â¡n.',
          tone: ArenaBridgeTone.neutral,
        ),
        ArenaBridgeInfoRowDraft(
          text:
              'ChÃƒÂ¡Ã‚Â»Ã¢â‚¬Â° dÃƒÆ’Ã‚Â¹ng lÃƒÆ’Ã‚Â m bÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi cÃƒÂ¡Ã‚ÂºÃ‚Â£nh tham khÃƒÂ¡Ã‚ÂºÃ‚Â£o.',
          tone: ArenaBridgeTone.content,
        ),
      ],
      bridgeComponents: [
        ArenaBridgeComponentDraft(
          name: 'PredictionContextCard',
          badgeLabel: 'Event context',
          description:
              'DÃƒÆ’Ã‚Â¹ng trong Arena pages. HiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ bÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi cÃƒÂ¡Ã‚ÂºÃ‚Â£nh thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ trÃƒâ€ Ã‚Â°ÃƒÂ¡Ã‚Â»Ã‚Âng prediction, khÃƒÆ’Ã‚Â´ng phÃƒÂ¡Ã‚ÂºÃ‚Â£i trading UI.',
          sampleTitle:
              'BTC vÃƒâ€ Ã‚Â°ÃƒÂ¡Ã‚Â»Ã‚Â£t 100,000 USD trÃƒâ€ Ã‚Â°ÃƒÂ¡Ã‚Â»Ã¢â‚¬Âºc 31/03/2026?',
          sampleMeta:
              'Yes Ãƒâ€šÃ‚Â· 72% probability Ãƒâ€šÃ‚Â· read-only context',
          tone: ArenaBridgeTone.content,
        ),
        ArenaBridgeComponentDraft(
          name: 'ArenaRelatedRoomCard',
          badgeLabel: 'Open Arena',
          description:
              'DÃƒÆ’Ã‚Â¹ng trong Prediction pages. Room card cÃƒÆ’Ã‚Â³ trust badge, resolution, privacy.',
          sampleTitle: 'Fed Rate Predict - March 2026',
          sampleMeta: '50 pts Ãƒâ€šÃ‚Â· 67/100 slots Ãƒâ€šÃ‚Â· Fair Play 88',
          tone: ArenaBridgeTone.arena,
        ),
        ArenaBridgeComponentDraft(
          name: 'DualModuleStatCard',
          badgeLabel: 'Linked context',
          description:
              'DÃƒÆ’Ã‚Â¹ng trÃƒÆ’Ã‚Âªn Profile. 2 khÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi stats tÃƒÆ’Ã‚Â¡ch biÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡t, khÃƒÆ’Ã‚Â´ng gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p sÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœ liÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡u.',
          sampleTitle: 'Prediction block + Arena block',
          sampleMeta:
              'Tap tÃƒÂ¡Ã‚Â»Ã‚Â«ng block Ãƒâ€žÃ¢â‚¬ËœÃƒÂ¡Ã‚Â»Ã†â€™ mÃƒÂ¡Ã‚Â»Ã…Â¸ module riÃƒÆ’Ã‚Âªng',
          tone: ArenaBridgeTone.disclosure,
        ),
        ArenaBridgeComponentDraft(
          name: 'BridgeSourceBar',
          badgeLabel: 'Market context only',
          description:
              'DÃƒÆ’Ã‚Â¹ng trong Arena Studio khi user Ãƒâ€žÃ¢â‚¬ËœÃƒÂ¡Ã‚ÂºÃ‚Â¿n tÃƒÂ¡Ã‚Â»Ã‚Â« Prediction event. CÃƒÆ’Ã‚Â³ remove action.',
          sampleTitle:
              'NguÃƒÂ¡Ã‚Â»Ã¢â‚¬Å“n bÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi cÃƒÂ¡Ã‚ÂºÃ‚Â£nh: BTC vÃƒâ€ Ã‚Â°ÃƒÂ¡Ã‚Â»Ã‚Â£t 100,000 USD?',
          sampleMeta: 'Topic Crypto Ãƒâ€šÃ‚Â· Event pred-1 Ãƒâ€šÃ‚Â· removable',
          tone: ArenaBridgeTone.content,
        ),
      ],
      examples: [
        ArenaBridgeExampleDraft(
          id: 'example_a',
          status: ArenaBridgeExampleStatus.correct,
          title: 'PredictionContextCard trong Arena Challenge',
          description:
              'HiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ bÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi cÃƒÂ¡Ã‚ÂºÃ‚Â£nh prediction bÃƒÆ’Ã‚Âªn trong challenge detail vÃƒÂ¡Ã‚Â»Ã¢â‚¬Âºi badge rÃƒÆ’Ã‚Âµ rÃƒÆ’Ã‚Â ng.',
          frameTitle: 'ArenaChallengeDetailPage',
          evidenceRows: [
            'Disclosure badge + microcopy bÃƒÂ¡Ã‚ÂºÃ‚Â¯t buÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢c.',
            'KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ order/PnL.',
          ],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_b',
          status: ArenaBridgeExampleStatus.correct,
          title: 'ArenaRelatedRoomCard trong Prediction Event',
          description:
              'HiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ room Arena liÃƒÆ’Ã‚Âªn quan cÃƒÆ’Ã‚Â¹ng topic, cÃƒÆ’Ã‚Â³ Points-only badge.',
          frameTitle: 'PredictionEventDetailPage',
          evidenceRows: [
            'Trust badge + Points-only badge bÃƒÂ¡Ã‚ÂºÃ‚Â¯t buÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢c.',
            'KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ wallet balance.',
          ],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_c',
          status: ArenaBridgeExampleStatus.correct,
          title: 'DualModuleStatCard trÃƒÆ’Ã‚Âªn Profile',
          description:
              '2 block tÃƒÆ’Ã‚Â¡ch biÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡t vÃƒÂ¡Ã‚Â»Ã¢â‚¬Âºi boundary separator. SÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœ liÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡u khÃƒÆ’Ã‚Â´ng gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p.',
          frameTitle: 'ProfilePage',
          evidenceRows: [
            'MÃƒÂ¡Ã‚Â»Ã¢â‚¬â€i block cÃƒÆ’Ã‚Â³ badge riÃƒÆ’Ã‚Âªng.',
            'Tap mÃƒÂ¡Ã‚Â»Ã…Â¸ module riÃƒÆ’Ã‚Âªng.',
          ],
        ),
        ArenaBridgeExampleDraft(
          id: 'example_d',
          status: ArenaBridgeExampleStatus.blocked,
          title: 'GÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p Points + PnL',
          description:
              'Anti-pattern tÃƒÂ¡Ã‚ÂºÃ‚Â¡o nhÃƒÂ¡Ã‚ÂºÃ‚Â§m lÃƒÂ¡Ã‚ÂºÃ‚Â«n giÃƒÂ¡Ã‚Â»Ã‚Â¯a tiÃƒÂ¡Ã‚Â»Ã‚Ân thÃƒÂ¡Ã‚ÂºÃ‚Â­t vÃƒÆ’Ã‚Â  Ãƒâ€žÃ¢â‚¬ËœiÃƒÂ¡Ã‚Â»Ã†â€™m xÃƒÆ’Ã‚Â£ hÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢i.',
          frameTitle: 'WRONG - MergedStatsCard',
          evidenceRows: [
            'KhÃƒÆ’Ã‚Â´ng gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p Points + PnL vÃƒÆ’Ã‚Â o cÃƒÆ’Ã‚Â¹ng 1 card.',
            'KhÃƒÆ’Ã‚Â´ng hiÃƒÂ¡Ã‚Â»Ã†â€™n thÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ tÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¢ng tÃƒÆ’Ã‚Â i sÃƒÂ¡Ã‚ÂºÃ‚Â£n gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p 2 module.',
            'KhÃƒÆ’Ã‚Â´ng so sÃƒÆ’Ã‚Â¡nh Points = tiÃƒÂ¡Ã‚Â»Ã‚Ân thÃƒÂ¡Ã‚ÂºÃ‚Â­t.',
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
          'Foundation layer - boundary phÃƒÂ¡Ã‚ÂºÃ‚Â£i khÃƒÆ’Ã‚Â³a trÃƒâ€ Ã‚Â°ÃƒÂ¡Ã‚Â»Ã¢â‚¬Âºc khi nÃƒÂ¡Ã‚Â»Ã¢â‚¬Ëœi flow. Open Arena = Points only. Prediction Markets = Real positions. KhÃƒÆ’Ã‚Â´ng bao giÃƒÂ¡Ã‚Â»Ã‚Â gÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢p.',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
