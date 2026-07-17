part of '../repositories/mock_predictions_repository.dart';

List<PredictionEventDraft> _applyFilter(
  List<PredictionEventDraft> events,
  PredictionFilterTab filter,
) {
  final active = events
      .where((event) => event.status == PredictionEventStatus.active)
      .toList();
  switch (filter) {
    case PredictionFilterTab.trending:
      active.sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));
    case PredictionFilterTab.newEvents:
      active.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case PredictionFilterTab.popular:
      active.sort((a, b) => b.participants.compareTo(a.participants));
    case PredictionFilterTab.liquid:
      active.sort((a, b) => b.liquidity.compareTo(a.liquidity));
    case PredictionFilterTab.ending:
      active.sort((a, b) => a.endDate.compareTo(b.endDate));
    case PredictionFilterTab.competitive:
      active.sort(
        (a, b) => (a.outcomes.first.chance - 50).abs().compareTo(
          (b.outcomes.first.chance - 50).abs(),
        ),
      );
  }
  return active;
}

List<PredictionEventDraft> _sortSearchEvents(
  List<PredictionEventDraft> events,
  PredictionSearchSort sort,
) {
  final sorted = events.toList();
  switch (sort) {
    case PredictionSearchSort.trending:
      sorted.sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));
    case PredictionSearchSort.liquidity:
      sorted.sort((a, b) => b.liquidity.compareTo(a.liquidity));
    case PredictionSearchSort.volume:
      sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    case PredictionSearchSort.newest:
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case PredictionSearchSort.ending:
      sorted.sort((a, b) => a.endDate.compareTo(b.endDate));
    case PredictionSearchSort.competitive:
      sorted.sort(
        (a, b) => (a.outcomes.first.chance - 50).abs().compareTo(
          (b.outcomes.first.chance - 50).abs(),
        ),
      );
  }
  return sorted;
}

const List<String> _predictionCategories = [
  'Live Crypto',
  'Politics',
  'Sports',
  'Tech',
  'AI',
  'Finance',
  'Culture',
];

final List<PredictionEventDraft> _predictionEvents = [
  PredictionEventDraft(
    id: 'pred-1',
    title: 'Bitcoin reaches \$150K before July 2026?',
    category: 'Live Crypto',
    tags: ['BTC', 'Price Target'],
    outcomes: _yesNo(34, 66),
    volume24h: 2450000,
    totalVolume: 18700000,
    endDate: DateTime.utc(2026, 7, 1),
    liquidity: 5200000,
    participants: 12840,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 5.2,
    createdAt: DateTime.utc(2026, 1, 15),
  ),
  PredictionEventDraft(
    id: 'pred-2',
    title: 'Ethereum ETF approved in Q2 2026?',
    category: 'Live Crypto',
    tags: ['ETH', 'Regulation'],
    outcomes: _yesNo(72, 28),
    volume24h: 1830000,
    totalVolume: 14200000,
    endDate: DateTime.utc(2026, 6, 30),
    liquidity: 3800000,
    participants: 9450,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 3.8,
    createdAt: DateTime.utc(2026, 1, 20),
  ),
  PredictionEventDraft(
    id: 'pred-3',
    title: 'US Presidential approval rating above 50% by March?',
    category: 'Politics',
    tags: ['US', 'Approval'],
    outcomes: _yesNo(41, 59),
    volume24h: 980000,
    totalVolume: 8100000,
    endDate: DateTime.utc(2026, 3, 31),
    liquidity: 2100000,
    participants: 6320,
    status: PredictionEventStatus.active,
    change24h: -2.1,
    createdAt: DateTime.utc(2026, 1, 10),
  ),
  PredictionEventDraft(
    id: 'pred-4',
    title: 'Champions League Winner 2026',
    category: 'Sports',
    tags: ['Football', 'UCL'],
    outcomes: const [
      PredictionOutcomeDraft(
        label: 'Real Madrid',
        chance: 28,
        tone: AccentTone.warn,
      ),
      PredictionOutcomeDraft(
        label: 'Man City',
        chance: 24,
        tone: AccentTone.info,
      ),
      PredictionOutcomeDraft(
        label: 'Bayern',
        chance: 18,
        tone: AccentTone.sell,
      ),
      PredictionOutcomeDraft(
        label: 'Other',
        chance: 30,
        tone: AccentTone.accent,
      ),
    ],
    volume24h: 1250000,
    totalVolume: 11300000,
    endDate: DateTime.utc(2026, 6, 1),
    liquidity: 4500000,
    participants: 15200,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 1.5,
    createdAt: DateTime.utc(2025, 12, 1),
  ),
  PredictionEventDraft(
    id: 'pred-5',
    title: 'Apple releases AR glasses in 2026?',
    category: 'Tech',
    tags: ['Apple', 'AR/VR'],
    outcomes: _yesNo(55, 45),
    volume24h: 720000,
    totalVolume: 5400000,
    endDate: DateTime.utc(2026, 12, 31),
    liquidity: 1800000,
    participants: 4100,
    status: PredictionEventStatus.active,
    isNew: true,
    change24h: 8.3,
    createdAt: DateTime.utc(2026, 2, 20),
  ),
  PredictionEventDraft(
    id: 'pred-6',
    title: 'GPT-5 released before June 2026?',
    category: 'AI',
    tags: ['OpenAI', 'LLM'],
    outcomes: _yesNo(68, 32),
    volume24h: 1560000,
    totalVolume: 9800000,
    endDate: DateTime.utc(2026, 6, 1),
    liquidity: 3200000,
    participants: 8900,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: -1.2,
    createdAt: DateTime.utc(2026, 1, 5),
  ),
  PredictionEventDraft(
    id: 'pred-7',
    title: 'Fed cuts rates below 4% by Q3 2026?',
    category: 'Finance',
    tags: ['Fed', 'Interest Rate'],
    outcomes: _yesNo(47, 53),
    volume24h: 890000,
    totalVolume: 7200000,
    endDate: DateTime.utc(2026, 9, 30),
    liquidity: 2600000,
    participants: 5800,
    status: PredictionEventStatus.active,
    change24h: 2.4,
    createdAt: DateTime.utc(2026, 2, 1),
  ),
  PredictionEventDraft(
    id: 'pred-8',
    title: 'Next Marvel movie grosses \$1B worldwide?',
    category: 'Culture',
    tags: ['Marvel', 'Box Office'],
    outcomes: _yesNo(62, 38),
    volume24h: 340000,
    totalVolume: 2800000,
    endDate: DateTime.utc(2026, 8, 1),
    liquidity: 950000,
    participants: 3200,
    status: PredictionEventStatus.active,
    change24h: .8,
    createdAt: DateTime.utc(2026, 2, 10),
  ),
  PredictionEventDraft(
    id: 'pred-9',
    title: 'Solana price above \$500 by March 2026?',
    category: 'Live Crypto',
    tags: ['SOL', 'Price Target'],
    outcomes: _yesNo(22, 78),
    volume24h: 1120000,
    totalVolume: 6500000,
    endDate: DateTime.utc(2026, 3, 31),
    liquidity: 2900000,
    participants: 7600,
    status: PredictionEventStatus.active,
    change24h: -4.5,
    createdAt: DateTime.utc(2026, 1, 25),
  ),
  PredictionEventDraft(
    id: 'pred-10',
    title: 'Tesla stock above \$400 by mid-2026?',
    category: 'Finance',
    tags: ['TSLA', 'Stock'],
    outcomes: _yesNo(38, 62),
    volume24h: 670000,
    totalVolume: 4300000,
    endDate: DateTime.utc(2026, 6, 30),
    liquidity: 1500000,
    participants: 4800,
    status: PredictionEventStatus.active,
    isNew: true,
    change24h: 6.1,
    createdAt: DateTime.utc(2026, 2, 22),
  ),
  PredictionEventDraft(
    id: 'pred-11',
    title: 'Will AI-generated movie win an Oscar by 2027?',
    category: 'AI',
    tags: ['AI', 'Entertainment'],
    outcomes: _yesNo(12, 88),
    volume24h: 290000,
    totalVolume: 1900000,
    endDate: DateTime.utc(2027, 3, 1),
    liquidity: 680000,
    participants: 2100,
    status: PredictionEventStatus.active,
    change24h: 1.1,
    createdAt: DateTime.utc(2026, 2, 18),
  ),
  PredictionEventDraft(
    id: 'pred-12',
    title: 'Crypto total market cap reaches \$5T in 2026?',
    category: 'Live Crypto',
    tags: ['Market Cap', 'Bull Run'],
    outcomes: _yesNo(45, 55),
    volume24h: 2100000,
    totalVolume: 15600000,
    endDate: DateTime.utc(2026, 12, 31),
    liquidity: 4800000,
    participants: 11200,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 3.2,
    createdAt: DateTime.utc(2026, 1, 1),
  ),
  PredictionEventDraft(
    id: 'pred-r1',
    title: 'Bitcoin above \$100K by Feb 2026?',
    category: 'Live Crypto',
    tags: ['BTC', 'Price'],
    outcomes: _yesNo(100, 0),
    volume24h: 0,
    totalVolume: 22000000,
    endDate: DateTime.utc(2026, 2, 1),
    liquidity: 0,
    participants: 18500,
    status: PredictionEventStatus.resolved,
    resolvedOutcome: 'Yes',
    change24h: 0,
    createdAt: DateTime.utc(2025, 6, 1),
  ),
  PredictionEventDraft(
    id: 'pred-r2',
    title: 'Super Bowl LX Winner: Kansas City?',
    category: 'Sports',
    tags: ['NFL', 'Super Bowl'],
    outcomes: _yesNo(0, 100),
    volume24h: 0,
    totalVolume: 9800000,
    endDate: DateTime.utc(2026, 2, 9),
    liquidity: 0,
    participants: 14200,
    status: PredictionEventStatus.resolved,
    resolvedOutcome: 'No',
    change24h: 0,
    createdAt: DateTime.utc(2025, 9, 1),
  ),
];

List<PredictionOutcomeDraft> _yesNo(int yes, int no) {
  return [
    PredictionOutcomeDraft(label: 'Yes', chance: yes, tone: AccentTone.buy),
    PredictionOutcomeDraft(label: 'No', chance: no, tone: AccentTone.sell),
  ];
}

const List<PredictionPositionDraft> _predictionPositions = [
  PredictionPositionDraft(
    id: 'pos-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    shares: 500,
    avgPrice: .28,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-2',
    eventId: 'pred-2',
    outcome: 'Yes',
    shares: 120,
    avgPrice: .61,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-3',
    eventId: 'pred-4',
    outcome: 'Real Madrid',
    shares: 80,
    avgPrice: .24,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-4',
    eventId: 'pred-10',
    outcome: 'No',
    shares: 140,
    avgPrice: .58,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-5',
    eventId: 'pred-12',
    outcome: 'Yes',
    shares: 220,
    avgPrice: .41,
    status: PredictionPositionStatus.open,
  ),
];

final List<PredictionPortfolioPositionDraft> _predictionPortfolioPositions = [
  PredictionPortfolioPositionDraft(
    id: 'pos-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    shares: 500,
    avgPrice: .28,
    currentPrice: .34,
    investedAmount: 140,
    currentValue: 170,
    pnl: 30,
    pnlPct: 21.43,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 10),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-2',
    eventId: 'pred-2',
    outcome: 'Yes',
    shares: 300,
    avgPrice: .65,
    currentPrice: .72,
    investedAmount: 195,
    currentValue: 216,
    pnl: 21,
    pnlPct: 10.77,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 5),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-3',
    eventId: 'pred-6',
    outcome: 'No',
    shares: 200,
    avgPrice: .38,
    currentPrice: .32,
    investedAmount: 76,
    currentValue: 64,
    pnl: -12,
    pnlPct: -15.79,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 15),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-4',
    eventId: 'pred-5',
    outcome: 'Yes',
    shares: 400,
    avgPrice: .42,
    currentPrice: .55,
    investedAmount: 168,
    currentValue: 220,
    pnl: 52,
    pnlPct: 30.95,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 22),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-5',
    eventId: 'pred-r1',
    outcome: 'Yes',
    shares: 1000,
    avgPrice: .55,
    currentPrice: 1,
    investedAmount: 550,
    currentValue: 1000,
    pnl: 450,
    pnlPct: 81.82,
    status: PredictionPortfolioPositionStatus.won,
    purchasedAt: DateTime.utc(2025, 8, 1),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-6',
    eventId: 'pred-r2',
    outcome: 'Yes',
    shares: 250,
    avgPrice: .45,
    currentPrice: 0,
    investedAmount: 112.5,
    currentValue: 0,
    pnl: -112.5,
    pnlPct: -100,
    status: PredictionPortfolioPositionStatus.lost,
    purchasedAt: DateTime.utc(2025, 11, 1),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-7',
    eventId: 'pred-9',
    outcome: 'No',
    shares: 150,
    avgPrice: .70,
    currentPrice: .78,
    investedAmount: 105,
    currentValue: 117,
    pnl: 12,
    pnlPct: 11.43,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 1),
  ),
];

final List<PredictionPortfolioOrderDraft> _predictionPortfolioOrders = [
  PredictionPortfolioOrderDraft(
    id: 'oo-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    side: 'buy',
    orderType: 'limit',
    price: .30,
    shares: 200,
    filled: 0,
    total: 60,
    createdAt: DateTime.utc(2026, 2, 27, 8),
  ),
  PredictionPortfolioOrderDraft(
    id: 'oo-2',
    eventId: 'pred-2',
    outcome: 'No',
    side: 'buy',
    orderType: 'limit',
    price: .25,
    shares: 150,
    filled: 50,
    total: 37.5,
    createdAt: DateTime.utc(2026, 2, 26, 15, 30),
  ),
  PredictionPortfolioOrderDraft(
    id: 'oo-3',
    eventId: 'pred-7',
    outcome: 'Yes',
    side: 'sell',
    orderType: 'limit',
    price: .55,
    shares: 100,
    filled: 0,
    total: 55,
    createdAt: DateTime.utc(2026, 2, 27, 10),
  ),
];
