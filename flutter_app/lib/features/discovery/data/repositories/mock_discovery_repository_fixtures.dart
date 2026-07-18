part of 'mock_discovery_repository.dart';

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
  const DiscoveryModuleDraft(
    id: 'predictions',
    title: 'Prediction Markets',
    subtitle: 'Thị trường dự đoán · Vị thế thực · USDT',
    route: '/markets/predictions',
    iconKey: 'prediction',
    kind: DiscoveryModuleKind.prediction,
  ),
  const DiscoveryModuleDraft(
    id: 'arena',
    title: 'Open Arena',
    subtitle: 'Creator modes · Thách đấu · Arena Points only',
    route: '/arena',
    iconKey: 'arena',
    kind: DiscoveryModuleKind.arena,
  ),
  const DiscoveryModuleDraft(
    id: 'topics',
    title: 'Topic Hub',
    subtitle: 'Khám phá theo chủ đề · Crypto, Sports, Macro...',
    route: '/topics',
    iconKey: 'topic',
    kind: DiscoveryModuleKind.topic,
  ),
];

final _predictionEvents = [
  const DiscoveryPredictionEventDraft(
    id: 'pred-1',
    title: 'Bitcoin ETF approval trước Q2?',
    category: 'Crypto',
    topOutcome: 'YES',
    chance: 64,
    volumeLabel: r'$2.4M',
    route: '/markets/predictions/event/pred-1',
    searchTerms: [
      'Bitcoin ETF approval trước Q2?',
      'bitcoin',
      'btc',
      'crypto',
      'etf',
    ],
  ),
  const DiscoveryPredictionEventDraft(
    id: 'pred-2',
    title: 'Fed rate cut trong kỳ họp tới?',
    category: 'Macro',
    topOutcome: 'NO',
    chance: 57,
    volumeLabel: r'$860K',
    route: '/markets/predictions/event/pred-2',
    searchTerms: ['Fed rate cut', 'fed', 'rate', 'macro'],
  ),
];

final _arenaModes = [
  const DiscoveryArenaModeDraft(
    id: 'mode001',
    title: 'Altcoin Battle',
    description: 'Creator mode dự đoán token outperform trong 24h.',
    activeChallenges: 12,
    cloneCount: 248,
    fairPlay: true,
    route: '/arena/mode/mode001',
    searchTerms: [
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
  const DiscoveryArenaRoomDraft(
    id: 'ch003',
    title: 'BTC direction challenge',
    format: '1v1 · 24h',
    entryPoints: 50,
    slotsFilled: 12,
    slotsTotal: 24,
    creatorName: 'MacroCreator',
    route: '/arena/challenge/ch003',
    searchTerms: [
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
  const DiscoveryCreatorDraft(
    id: 'cr001',
    name: 'Minh Arena',
    initials: 'MA',
    trustScore: 98,
    modesCreated: 14,
    fairPlayBadge: true,
    route: '/arena/creator/cr001',
    searchTerms: ['Minh Arena', 'creator', 'arena', 'mode'],
  ),
];

final _tradingPairs = [
  const DiscoveryTradingPairDraft(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    priceLabel: r'$67,420.00',
    change24h: 2.14,
    route: '/pair/btcusdt',
    searchTerms: ['BTC/USDT', 'btc', 'bitcoin', 'usdt', 'spot'],
  ),
  const DiscoveryTradingPairDraft(
    id: 'ethusdt',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    quoteAsset: 'USDT',
    priceLabel: r'$3,280.50',
    change24h: -0.82,
    route: '/pair/ethusdt',
    searchTerms: ['ETH/USDT', 'eth', 'ethereum', 'price', 'spot'],
  ),
];

final _cryptoTopicPredictions = [
  const DiscoveryPredictionEventDraft(
    id: 'pred-1',
    title: 'Bitcoin reaches \$150K before July 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 34,
    volumeLabel: r'$2.5M',
    route: '/markets/predictions/event/pred-1',
    searchTerms: ['bitcoin', 'crypto', 'btc'],
    isTrending: true,
  ),
  const DiscoveryPredictionEventDraft(
    id: 'pred-crypto-2',
    title: 'Ethereum ETF approved in Q2 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 72,
    volumeLabel: r'$1.8M',
    route: '/markets/predictions/event/pred-crypto-2',
    searchTerms: ['ethereum', 'crypto', 'eth'],
    isTrending: true,
  ),
  const DiscoveryPredictionEventDraft(
    id: 'pred-crypto-3',
    title: 'Solana price above \$500 by March 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 22,
    volumeLabel: r'$1.1M',
    route: '/markets/predictions/event/pred-crypto-3',
    searchTerms: ['solana', 'crypto', 'sol'],
  ),
  const DiscoveryPredictionEventDraft(
    id: 'pred-crypto-4',
    title: 'Crypto total market cap reaches \$5T in 2026?',
    category: 'Crypto',
    topOutcome: 'Yes',
    chance: 45,
    volumeLabel: r'$2.1M',
    route: '/markets/predictions/event/pred-crypto-4',
    searchTerms: ['crypto', 'market cap'],
    isTrending: true,
  ),
  const DiscoveryPredictionEventDraft(
    id: 'pred-crypto-5',
    title: 'Bitcoin dominance stays above 50%?',
    category: 'Crypto',
    topOutcome: 'No',
    chance: 49,
    volumeLabel: r'$940K',
    route: '/markets/predictions/event/pred-crypto-5',
    searchTerms: ['bitcoin', 'dominance'],
  ),
];

final _cryptoTopicRooms = [
  const DiscoveryArenaRoomDraft(
    id: 'ch003',
    title: 'BTC \$70K? — Tuần 9',
    format: 'Crypto',
    entryPoints: 100,
    slotsFilled: 38,
    slotsTotal: 50,
    creatorName: 'CryptoMaster_VN',
    route: '/arena/challenge/ch003',
    searchTerms: ['btc', 'bitcoin', 'crypto'],
    statusLabel: 'Chờ',
  ),
  const DiscoveryArenaRoomDraft(
    id: 'ch004',
    title: 'Altcoin Battle — SOL vs AVAX vs MATIC vs DOT',
    format: 'Crypto',
    entryPoints: 200,
    slotsFilled: 40,
    slotsTotal: 40,
    creatorName: 'ArenaKing',
    route: '/arena/challenge/ch004',
    searchTerms: ['altcoin', 'crypto', 'sol', 'avax'],
    statusLabel: 'Live',
  ),
];

final _cryptoTopicModes = [
  const DiscoveryArenaModeDraft(
    id: 'mode001',
    title: 'BTC Weekly Predict',
    description: 'Weekly Bitcoin direction challenge using Arena Points.',
    activeChallenges: 5,
    cloneCount: 234,
    fairPlay: true,
    route: '/arena/mode/mode001',
    searchTerms: ['btc', 'bitcoin', 'weekly', 'crypto'],
  ),
  const DiscoveryArenaModeDraft(
    id: 'mode002',
    title: 'Altcoin Battle Royale',
    description: 'Compare four altcoins in a points-only challenge format.',
    activeChallenges: 3,
    cloneCount: 156,
    fairPlay: true,
    route: '/arena/mode/mode002',
    searchTerms: ['altcoin', 'battle', 'crypto'],
  ),
];

final _cryptoTopicCreators = [
  const DiscoveryCreatorDraft(
    id: 'cr001',
    name: 'CryptoMaster_VN',
    initials: 'CM',
    trustScore: 95,
    modesCreated: 8,
    fairPlayBadge: true,
    route: '/arena/creator/cr001',
    searchTerms: ['CryptoMaster_VN', 'crypto', 'creator'],
  ),
  const DiscoveryCreatorDraft(
    id: 'cr002',
    name: 'ArenaKing',
    initials: 'AK',
    trustScore: 91,
    modesCreated: 11,
    fairPlayBadge: true,
    route: '/arena/creator/cr002',
    searchTerms: ['ArenaKing', 'arena', 'creator'],
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
