import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return const MockDiscoveryRepository();
});

abstract interface class DiscoveryRepository {
  UnifiedSearchSnapshot getUnifiedSearch({String query = ''});

  TopicHubSnapshot getTopicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  });
}

enum DiscoveryScreenState { loading, empty, error, offline }

enum DiscoveryModuleKind { prediction, arena, topic }

enum DiscoveryResultKind { prediction, arenaMode, arenaRoom, creator, spot }

final class UnifiedSearchSnapshot {
  const UnifiedSearchSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.searchHint,
    required this.staleMessage,
    required this.staleDetail,
    required this.trendingQueries,
    required this.modules,
    required this.results,
    required this.query,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String searchHint;
  final String staleMessage;
  final String staleDetail;
  final List<DiscoveryTrendingQueryDraft> trendingQueries;
  final List<DiscoveryModuleDraft> modules;
  final DiscoverySearchResults results;
  final String query;
  final String contractNotes;
  final Set<DiscoveryScreenState> supportedStates;

  bool get hasQuery => query.trim().isNotEmpty;
}

final class DiscoverySearchResults {
  const DiscoverySearchResults({
    required this.predictions,
    required this.arenaModes,
    required this.arenaRooms,
    required this.creators,
    required this.tradingPairs,
  });

  final List<DiscoveryPredictionEventDraft> predictions;
  final List<DiscoveryArenaModeDraft> arenaModes;
  final List<DiscoveryArenaRoomDraft> arenaRooms;
  final List<DiscoveryCreatorDraft> creators;
  final List<DiscoveryTradingPairDraft> tradingPairs;

  int get totalCount =>
      predictions.length +
      arenaModes.length +
      arenaRooms.length +
      creators.length +
      tradingPairs.length;

  bool get isEmpty => totalCount == 0;
}

final class TopicHubSnapshot {
  const TopicHubSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.searchRoute,
    required this.predictionsRoute,
    required this.arenaRoute,
    required this.createArenaRoute,
    required this.staleMessage,
    required this.staleDetail,
    required this.topics,
    required this.selectedTopic,
    required this.predictions,
    required this.arenaRooms,
    required this.arenaModes,
    required this.creators,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String searchRoute;
  final String predictionsRoute;
  final String arenaRoute;
  final String createArenaRoute;
  final String staleMessage;
  final String staleDetail;
  final List<DiscoveryTopicDraft> topics;
  final DiscoveryTopicDraft selectedTopic;
  final List<DiscoveryPredictionEventDraft> predictions;
  final List<DiscoveryArenaRoomDraft> arenaRooms;
  final List<DiscoveryArenaModeDraft> arenaModes;
  final List<DiscoveryCreatorDraft> creators;
  final String contractNotes;
  final Set<DiscoveryScreenState> supportedStates;

  bool get hasContent =>
      predictions.isNotEmpty || arenaRooms.isNotEmpty || arenaModes.isNotEmpty;
}

final class DiscoveryTrendingQueryDraft {
  const DiscoveryTrendingQueryDraft({
    required this.label,
    required this.iconKey,
  });

  final String label;
  final String iconKey;
}

final class DiscoveryModuleDraft {
  const DiscoveryModuleDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.iconKey,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String iconKey;
  final DiscoveryModuleKind kind;
}

final class DiscoveryTopicDraft {
  const DiscoveryTopicDraft({
    required this.id,
    required this.label,
    required this.summary,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String summary;
  final String iconKey;
}

final class DiscoveryPredictionEventDraft {
  const DiscoveryPredictionEventDraft({
    required this.id,
    required this.title,
    required this.category,
    required this.topOutcome,
    required this.chance,
    required this.volumeLabel,
    required this.route,
    required this.searchTerms,
    this.isTrending = false,
  });

  final String id;
  final String title;
  final String category;
  final String topOutcome;
  final int chance;
  final String volumeLabel;
  final String route;
  final List<String> searchTerms;
  final bool isTrending;
}

final class DiscoveryArenaModeDraft {
  const DiscoveryArenaModeDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.activeChallenges,
    required this.cloneCount,
    required this.fairPlay,
    required this.route,
    required this.searchTerms,
  });

  final String id;
  final String title;
  final String description;
  final int activeChallenges;
  final int cloneCount;
  final bool fairPlay;
  final String route;
  final List<String> searchTerms;
}

final class DiscoveryArenaRoomDraft {
  const DiscoveryArenaRoomDraft({
    required this.id,
    required this.title,
    required this.format,
    required this.entryPoints,
    required this.slotsFilled,
    required this.slotsTotal,
    required this.creatorName,
    required this.route,
    required this.searchTerms,
    this.statusLabel = 'Live',
  });

  final String id;
  final String title;
  final String format;
  final int entryPoints;
  final int slotsFilled;
  final int slotsTotal;
  final String creatorName;
  final String route;
  final List<String> searchTerms;
  final String statusLabel;

  int get fillPercent => ((slotsFilled / slotsTotal) * 100).round();
}

final class DiscoveryCreatorDraft {
  const DiscoveryCreatorDraft({
    required this.id,
    required this.name,
    required this.initials,
    required this.trustScore,
    required this.modesCreated,
    required this.fairPlayBadge,
    required this.route,
    required this.searchTerms,
  });

  final String id;
  final String name;
  final String initials;
  final int trustScore;
  final int modesCreated;
  final bool fairPlayBadge;
  final String route;
  final List<String> searchTerms;
}

final class DiscoveryTradingPairDraft {
  const DiscoveryTradingPairDraft({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.priceLabel,
    required this.change24h,
    required this.route,
    required this.searchTerms,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final String priceLabel;
  final double change24h;
  final String route;
  final List<String> searchTerms;
}

final class MockDiscoveryRepository implements DiscoveryRepository {
  const MockDiscoveryRepository();

  @override
  UnifiedSearchSnapshot getUnifiedSearch({String query = ''}) {
    final normalizedQuery = query.trim();
    return UnifiedSearchSnapshot(
      endpoint: '/api/mobile/discovery/search',
      actionDraft: 'GET with query filters',
      title: 'Tìm kiếm',
      searchHint: 'Tìm sự kiện, mode, room, creator, coin...',
      staleMessage: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
      staleDetail: 'Cập nhật lần cuối: 2 phút trước',
      trendingQueries: _trendingQueries,
      modules: _modules,
      results: _performSearch(normalizedQuery),
      query: normalizedQuery,
      contractNotes:
          'Discovery-only bridge: Prediction Markets stay wallet/USDT; Open Arena stays Arena Points only.',
      supportedStates: const {
        DiscoveryScreenState.loading,
        DiscoveryScreenState.empty,
        DiscoveryScreenState.error,
        DiscoveryScreenState.offline,
      },
    );
  }

  @override
  TopicHubSnapshot getTopicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  }) {
    final matches = _topics.where((item) => item.id == topicId);
    final topic = matches.isEmpty ? _topics.first : matches.first;
    final content = _topicContent[topic.id] ?? _topicContent['crypto']!;

    return TopicHubSnapshot(
      endpoint: detailEndpoint
          ? '/api/mobile/discovery/topic-${topic.id}'
          : '/api/mobile/discovery/topics',
      actionDraft: 'read-only or local navigation action',
      title: 'Topic Hub',
      searchRoute: '/search',
      predictionsRoute: '/markets/predictions',
      arenaRoute: '/arena',
      createArenaRoute: '/arena/studio',
      staleMessage: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
      staleDetail: 'Cập nhật lần cuối: 2 phút trước',
      topics: _topics,
      selectedTopic: topic,
      predictions: content.predictions,
      arenaRooms: content.arenaRooms,
      arenaModes: content.arenaModes,
      creators: content.creators,
      contractNotes:
          'Topic is discovery context only; Prediction positions and Arena Points remain separate module contracts.',
      supportedStates: const {
        DiscoveryScreenState.loading,
        DiscoveryScreenState.empty,
        DiscoveryScreenState.error,
        DiscoveryScreenState.offline,
      },
    );
  }

  DiscoverySearchResults _performSearch(String query) {
    final q = query.toLowerCase();
    if (q.isEmpty) {
      return const DiscoverySearchResults(
        predictions: [],
        arenaModes: [],
        arenaRooms: [],
        creators: [],
        tradingPairs: [],
      );
    }

    return DiscoverySearchResults(
      predictions: _predictionEvents.where((item) => item.matches(q)).toList(),
      arenaModes: _arenaModes.where((item) => item.matches(q)).toList(),
      arenaRooms: _arenaRooms.where((item) => item.matches(q)).toList(),
      creators: _creators.where((item) => item.matches(q)).toList(),
      tradingPairs: _tradingPairs.where((item) => item.matches(q)).toList(),
    );
  }
}

final class _TopicContentDraft {
  const _TopicContentDraft({
    required this.predictions,
    required this.arenaRooms,
    required this.arenaModes,
    required this.creators,
  });

  final List<DiscoveryPredictionEventDraft> predictions;
  final List<DiscoveryArenaRoomDraft> arenaRooms;
  final List<DiscoveryArenaModeDraft> arenaModes;
  final List<DiscoveryCreatorDraft> creators;
}

extension on DiscoveryPredictionEventDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryArenaModeDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryArenaRoomDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryCreatorDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryTradingPairDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

bool _termsMatch(List<String> terms, String query) {
  return terms.any((term) => term.toLowerCase().contains(query));
}

const _trendingQueries = [
  DiscoveryTrendingQueryDraft(label: 'Bitcoin', iconKey: 'coin'),
  DiscoveryTrendingQueryDraft(label: 'ETH price', iconKey: 'price'),
  DiscoveryTrendingQueryDraft(label: 'Fed rate', iconKey: 'bank'),
  DiscoveryTrendingQueryDraft(label: 'Arena challenge', iconKey: 'arena'),
  DiscoveryTrendingQueryDraft(label: 'Altcoin battle', iconKey: 'fire'),
  DiscoveryTrendingQueryDraft(label: 'Macro news', iconKey: 'news'),
];

const _topics = [
  DiscoveryTopicDraft(
    id: 'crypto',
    label: 'Crypto',
    summary: 'Bitcoin, Ethereum, altcoins, DeFi',
    iconKey: 'fire',
  ),
  DiscoveryTopicDraft(
    id: 'macro',
    label: 'Macro',
    summary: 'Kinh tế vĩ mô, lãi suất, GDP, CPI',
    iconKey: 'bank',
  ),
  DiscoveryTopicDraft(
    id: 'politics',
    label: 'Politics',
    summary: 'Chính trị, bầu cử, chính sách',
    iconKey: 'topic',
  ),
  DiscoveryTopicDraft(
    id: 'sports',
    label: 'Sports',
    summary: 'Thể thao, giải đấu, kết quả',
    iconKey: 'arena',
  ),
  DiscoveryTopicDraft(
    id: 'tech',
    label: 'Tech',
    summary: 'Công nghệ, sản phẩm, startup',
    iconKey: 'price',
  ),
  DiscoveryTopicDraft(
    id: 'ai',
    label: 'AI',
    summary: 'AI, machine learning, AGI',
    iconKey: 'topic',
  ),
  DiscoveryTopicDraft(
    id: 'culture',
    label: 'Culture',
    summary: 'Văn hóa, giải trí, meme',
    iconKey: 'news',
  ),
  DiscoveryTopicDraft(
    id: 'community',
    label: 'Community',
    summary: 'Cộng đồng, social, creator',
    iconKey: 'arena',
  ),
];

final _modules = [
  DiscoveryModuleDraft(
    id: 'predictions',
    title: 'Prediction Markets',
    subtitle: 'Thị trường dự đoán · Vị thế thực · USDT',
    route: '/markets/predictions',
    iconKey: 'prediction',
    kind: DiscoveryModuleKind.prediction,
  ),
  DiscoveryModuleDraft(
    id: 'arena',
    title: 'Open Arena',
    subtitle: 'Creator modes · Thách đấu · Arena Points only',
    route: '/arena',
    iconKey: 'arena',
    kind: DiscoveryModuleKind.arena,
  ),
  DiscoveryModuleDraft(
    id: 'topics',
    title: 'Topic Hub',
    subtitle: 'Khám phá theo chủ đề · Crypto, Sports, Macro...',
    route: '/topics',
    iconKey: 'topic',
    kind: DiscoveryModuleKind.topic,
  ),
];

final _predictionEvents = [
  DiscoveryPredictionEventDraft(
    id: 'pred-1',
    title: 'Bitcoin ETF approval trước Q2?',
    category: 'Crypto',
    topOutcome: 'YES',
    chance: 64,
    volumeLabel: r'$2.4M',
    route: '/markets/predictions/event/pred-1',
    searchTerms: const [
      'Bitcoin ETF approval trước Q2?',
      'bitcoin',
      'btc',
      'crypto',
      'etf',
    ],
  ),
  DiscoveryPredictionEventDraft(
    id: 'pred-2',
    title: 'Fed rate cut trong kỳ họp tới?',
    category: 'Macro',
    topOutcome: 'NO',
    chance: 57,
    volumeLabel: r'$860K',
    route: '/markets/predictions/event/pred-2',
    searchTerms: const ['Fed rate cut', 'fed', 'rate', 'macro'],
  ),
];

final _arenaModes = [
  DiscoveryArenaModeDraft(
    id: 'mode001',
    title: 'Altcoin Battle',
    description: 'Creator mode dự đoán token outperform trong 24h.',
    activeChallenges: 12,
    cloneCount: 248,
    fairPlay: true,
    route: '/arena/mode/mode001',
    searchTerms: const [
      'Altcoin Battle',
      'arena',
      'challenge',
      'mode',
      'altcoin',
      'battle',
    ],
  ),
];

final _arenaRooms = [
  DiscoveryArenaRoomDraft(
    id: 'ch003',
    title: 'BTC direction challenge',
    format: '1v1 · 24h',
    entryPoints: 50,
    slotsFilled: 12,
    slotsTotal: 24,
    creatorName: 'MacroCreator',
    route: '/arena/challenge/ch003',
    searchTerms: const [
      'BTC direction challenge',
      'arena',
      'challenge',
      'room',
      'bitcoin',
      'btc',
    ],
  ),
];

final _creators = [
  DiscoveryCreatorDraft(
    id: 'cr001',
    name: 'Minh Arena',
    initials: 'MA',
    trustScore: 98,
    modesCreated: 14,
    fairPlayBadge: true,
    route: '/arena/creator/cr001',
    searchTerms: const ['Minh Arena', 'creator', 'arena', 'mode'],
  ),
];

final _tradingPairs = [
  DiscoveryTradingPairDraft(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    priceLabel: r'$67,420.00',
    change24h: 2.14,
    route: '/pair/btcusdt',
    searchTerms: const ['BTC/USDT', 'btc', 'bitcoin', 'usdt', 'spot'],
  ),
  DiscoveryTradingPairDraft(
    id: 'ethusdt',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    quoteAsset: 'USDT',
    priceLabel: r'$3,280.50',
    change24h: -0.82,
    route: '/pair/ethusdt',
    searchTerms: const ['ETH/USDT', 'eth', 'ethereum', 'price', 'spot'],
  ),
];

final _cryptoTopicPredictions = [
  DiscoveryPredictionEventDraft(
    id: 'pred-1',
    title: 'Bitcoin reaches \$150K before July 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 34,
    volumeLabel: r'$2.5M',
    route: '/markets/predictions/event/pred-1',
    searchTerms: const ['bitcoin', 'crypto', 'btc'],
    isTrending: true,
  ),
  DiscoveryPredictionEventDraft(
    id: 'pred-crypto-2',
    title: 'Ethereum ETF approved in Q2 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 72,
    volumeLabel: r'$1.8M',
    route: '/markets/predictions/event/pred-crypto-2',
    searchTerms: const ['ethereum', 'crypto', 'eth'],
    isTrending: true,
  ),
  DiscoveryPredictionEventDraft(
    id: 'pred-crypto-3',
    title: 'Solana price above \$500 by March 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 22,
    volumeLabel: r'$1.1M',
    route: '/markets/predictions/event/pred-crypto-3',
    searchTerms: const ['solana', 'crypto', 'sol'],
  ),
  DiscoveryPredictionEventDraft(
    id: 'pred-crypto-4',
    title: 'Crypto total market cap reaches \$5T in 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 45,
    volumeLabel: r'$2.1M',
    route: '/markets/predictions/event/pred-crypto-4',
    searchTerms: const ['crypto', 'market cap'],
    isTrending: true,
  ),
  DiscoveryPredictionEventDraft(
    id: 'pred-crypto-5',
    title: 'Bitcoin dominance stays above 50%?',
    category: 'Crypto',
    topOutcome: 'No',
    chance: 49,
    volumeLabel: r'$940K',
    route: '/markets/predictions/event/pred-crypto-5',
    searchTerms: const ['bitcoin', 'dominance'],
  ),
];

final _cryptoTopicRooms = [
  DiscoveryArenaRoomDraft(
    id: 'ch003',
    title: 'BTC \$70K? — Tuần 9',
    format: 'Crypto',
    entryPoints: 100,
    slotsFilled: 38,
    slotsTotal: 50,
    creatorName: 'CryptoMaster_VN',
    route: '/arena/challenge/ch003',
    searchTerms: const ['btc', 'bitcoin', 'crypto'],
    statusLabel: 'Chờ',
  ),
  DiscoveryArenaRoomDraft(
    id: 'ch004',
    title: 'Altcoin Battle — SOL vs AVAX vs MATIC vs DOT',
    format: 'Crypto',
    entryPoints: 200,
    slotsFilled: 40,
    slotsTotal: 40,
    creatorName: 'ArenaKing',
    route: '/arena/challenge/ch004',
    searchTerms: const ['altcoin', 'crypto', 'sol', 'avax'],
    statusLabel: 'Live',
  ),
];

final _cryptoTopicModes = [
  DiscoveryArenaModeDraft(
    id: 'mode001',
    title: 'BTC Weekly Predict',
    description: 'Weekly Bitcoin direction challenge using Arena Points.',
    activeChallenges: 5,
    cloneCount: 234,
    fairPlay: true,
    route: '/arena/mode/mode001',
    searchTerms: const ['btc', 'bitcoin', 'weekly', 'crypto'],
  ),
  DiscoveryArenaModeDraft(
    id: 'mode002',
    title: 'Altcoin Battle Royale',
    description: 'Compare four altcoins in a points-only challenge format.',
    activeChallenges: 3,
    cloneCount: 156,
    fairPlay: true,
    route: '/arena/mode/mode002',
    searchTerms: const ['altcoin', 'battle', 'crypto'],
  ),
];

final _cryptoTopicCreators = [
  DiscoveryCreatorDraft(
    id: 'cr001',
    name: 'CryptoMaster_VN',
    initials: 'CM',
    trustScore: 95,
    modesCreated: 8,
    fairPlayBadge: true,
    route: '/arena/creator/cr001',
    searchTerms: const ['CryptoMaster_VN', 'crypto', 'creator'],
  ),
  DiscoveryCreatorDraft(
    id: 'cr002',
    name: 'ArenaKing',
    initials: 'AK',
    trustScore: 91,
    modesCreated: 11,
    fairPlayBadge: true,
    route: '/arena/creator/cr002',
    searchTerms: const ['ArenaKing', 'arena', 'creator'],
  ),
];

final _topicContent = {
  'crypto': _TopicContentDraft(
    predictions: _cryptoTopicPredictions,
    arenaRooms: _cryptoTopicRooms,
    arenaModes: _cryptoTopicModes,
    creators: _cryptoTopicCreators,
  ),
  'macro': _TopicContentDraft(
    predictions: [_predictionEvents[1]],
    arenaRooms: const [],
    arenaModes: const [],
    creators: const [],
  ),
  'politics': const _TopicContentDraft(
    predictions: [],
    arenaRooms: [],
    arenaModes: [],
    creators: [],
  ),
  'sports': const _TopicContentDraft(
    predictions: [],
    arenaRooms: [],
    arenaModes: [],
    creators: [],
  ),
  'tech': const _TopicContentDraft(
    predictions: [],
    arenaRooms: [],
    arenaModes: [],
    creators: [],
  ),
  'ai': const _TopicContentDraft(
    predictions: [],
    arenaRooms: [],
    arenaModes: [],
    creators: [],
  ),
  'culture': const _TopicContentDraft(
    predictions: [],
    arenaRooms: [],
    arenaModes: [],
    creators: [],
  ),
  'community': const _TopicContentDraft(
    predictions: [],
    arenaRooms: [],
    arenaModes: [],
    creators: [],
  ),
};
