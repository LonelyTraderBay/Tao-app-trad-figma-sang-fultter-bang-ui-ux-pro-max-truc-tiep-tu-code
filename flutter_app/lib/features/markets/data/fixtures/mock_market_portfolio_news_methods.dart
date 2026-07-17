part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositoryPortfolioNewsMethods on _MockMarketRepositoryBase {
  @override
  MarketPortfolioSnapshot getPortfolioTracker({
    MarketPortfolioSort sortBy = MarketPortfolioSort.value,
  }) {
    final sortedHoldings = [..._portfolioHoldings];
    switch (sortBy) {
      case MarketPortfolioSort.value:
        sortedHoldings.sort((a, b) => b.value.compareTo(a.value));
      case MarketPortfolioSort.pnl:
        sortedHoldings.sort((a, b) => b.pnlPct.compareTo(a.pnlPct));
      case MarketPortfolioSort.change:
        sortedHoldings.sort((a, b) => b.change24h.compareTo(a.change24h));
    }

    return MarketPortfolioSnapshot(
      stats: _portfolioStats,
      holdings: sortedHoldings,
      performance: _portfolioPerformance,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'portfolio-stable-allocation',
          pairId: 'usdtusdt',
          label: 'Stablecoin allocation baseline',
        ),
        MarketAlertDraft(
          id: 'portfolio-sol-outperform',
          pairId: 'solusdt',
          label: 'SOL leads portfolio performance',
        ),
      ],
      screenFilters: _marketPortfolioFilters,
      chartSeries: {
        'portfolioPerformance': [
          for (final point in _portfolioPerformance) point.value,
        ],
        'portfolioAllocation': [
          for (final holding in _portfolioHoldings) holding.allocation,
        ],
        for (final holding in _portfolioHoldings) holding.id: holding.sparkline,
      },
      sortBy: sortBy,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      },
    );
  }

  @override
  MarketNewsSnapshot getMarketNews({
    String category = 'all',
    MarketNewsSentiment? sentiment,
  }) {
    var items = [..._marketNews];
    if (category != 'all') {
      items = category == 'breaking'
          ? items.where((item) => item.isBreaking).toList()
          : items.where((item) => item.category == category).toList();
    }
    if (sentiment != null) {
      items = items.where((item) => item.sentiment == sentiment).toList();
    }

    final breaking = [
      for (final item in _marketNews)
        if (item.isBreaking) item,
    ];

    return MarketNewsSnapshot(
      news: items,
      breakingNews: breaking,
      categories: _marketNewsCategories,
      sentimentBadges: _marketNewsSentimentBadges,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'news-breaking-btc',
          pairId: 'btcusdt',
          label: 'Breaking BTC ETF news',
        ),
        MarketAlertDraft(
          id: 'news-defi-tvl',
          pairId: 'ethusdt',
          label: 'DeFi TVL news watch',
        ),
      ],
      screenFilters: _marketNewsFilters,
      chartSeries: {
        'sentimentCounts': [
          _marketNews
              .where((item) => item.sentiment == MarketNewsSentiment.bullish)
              .length
              .toDouble(),
          _marketNews
              .where((item) => item.sentiment == MarketNewsSentiment.neutral)
              .length
              .toDouble(),
          _marketNews
              .where((item) => item.sentiment == MarketNewsSentiment.bearish)
              .length
              .toDouble(),
        ],
        'categoryCounts': [
          for (final category in _marketNewsCategories.skip(1))
            category.id == 'breaking'
                ? breaking.length.toDouble()
                : _marketNews
                      .where((item) => item.category == category.id)
                      .length
                      .toDouble(),
        ],
      },
      selectedCategory: category,
      sentimentFilter: sentiment,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      },
    );
  }
}

const Map<MarketNewsSentiment, MarketNewsSentimentBadge>
_marketNewsSentimentBadges = {
  MarketNewsSentiment.bullish: MarketNewsSentimentBadge(
    label: 'Tích cực',
    color: AccentTone.buy,
  ),
  MarketNewsSentiment.neutral: MarketNewsSentimentBadge(
    label: 'Trung lập',
    color: AccentTone.text3,
  ),
  MarketNewsSentiment.bearish: MarketNewsSentimentBadge(
    label: 'Tiêu cực',
    color: AccentTone.sell,
  ),
};

const List<MarketNewsItem> _marketNews = [
  MarketNewsItem(
    id: 'n1',
    title: 'Bitcoin ETF ghi nhan dong tien vao ky luc \$1.2B trong 1 ngay',
    summary:
        'Cac quy ETF Bitcoin spot tai My da ghi nhan dong tien vao rong lon nhat tu khi ra mat, cho thay nhu cau to chuc tang manh.',
    source: 'CoinDesk',
    timeAgo: '15 phut truoc',
    category: 'bitcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['BTC'],
    icon: 'showChart',
    iconColor: AccentTone.info,
    isBreaking: true,
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n2',
    title: 'Ethereum Pectra upgrade xac nhan ngay 15/3 — nhung thay doi lon',
    summary:
        'Nang cap Pectra mang den EIP-7251 tang gioi han staking va EIP-7702 cho account abstraction, se anh huong lon den he sinh thai.',
    source: 'The Block',
    timeAgo: '45 phut truoc',
    category: 'altcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['ETH', 'ARB', 'OP'],
    icon: 'upload',
    iconColor: AccentTone.info,
    readTime: '5 phut',
  ),
  MarketNewsItem(
    id: 'n3',
    title: 'SEC My co the phe duyet ETF Solana trong quy 2 — phan tich',
    summary:
        'Cac chuyen gia phap ly nhan dinh SEC co the xem xet don xin ETF Solana som hon du kien sau thanh cong cua BTC ETF.',
    source: 'Bloomberg',
    timeAgo: '1 gio truoc',
    category: 'regulation',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['SOL'],
    icon: 'balance',
    iconColor: AccentTone.warn,
    readTime: '4 phut',
  ),
  MarketNewsItem(
    id: 'n4',
    title: 'TVL DeFi vuot \$120B — muc cao nhat ke tu 2022',
    summary:
        'Tong gia tri khoa trong DeFi dat muc cao nhat trong 2 nam, dan dau boi Aave, Lido va cac giao thuc restaking moi.',
    source: 'DeFi Llama',
    timeAgo: '2 gio truoc',
    category: 'defi',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['ETH', 'LINK', 'AAVE'],
    icon: 'accountBalance',
    iconColor: AccentTone.tierPlatinum,
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n5',
    title: 'Lam phat My thang 2 cao hon du kien — crypto giam nhe',
    summary:
        'CPI thang 2 dat 3.2% YoY, cao hon du kien 3.1%, khien thi truong lo ngai Fed se giu lai suat lau hon.',
    source: 'Reuters',
    timeAgo: '3 gio truoc',
    category: 'macro',
    sentiment: MarketNewsSentiment.bearish,
    relatedTokens: ['BTC', 'ETH'],
    icon: 'barChart',
    iconColor: AccentTone.medalSilverBlue,
    readTime: '4 phut',
  ),
  MarketNewsItem(
    id: 'n6',
    title: 'Solana Firedancer dat 1 trieu TPS tren testnet',
    summary:
        'Client moi Firedancer cua Jump Crypto dat ky luc xu ly 1 trieu giao dich/giay tren moi truong thu nghiem.',
    source: 'Solana Blog',
    timeAgo: '4 gio truoc',
    category: 'altcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['SOL'],
    icon: 'fire',
    iconColor: AccentTone.warn,
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n7',
    title: 'Binance dot 1.5 trieu BNB — gia tri gan \$620M',
    summary:
        'Dot token BNB hang quy lan thu 27 da hoan thanh, loai bo vinh vien 1.5 trieu BNB khoi luu thong.',
    source: 'Binance',
    timeAgo: '5 gio truoc',
    category: 'altcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['BNB'],
    icon: 'fire',
    iconColor: AccentTone.warn,
    readTime: '2 phut',
  ),
  MarketNewsItem(
    id: 'n8',
    title: 'Chainlink CCIP V2 ho tro 20+ blockchains — chi tiet',
    summary:
        'Phien ban moi cua Cross-Chain Interoperability Protocol mang den ho tro nhieu chuoi hon va giam 40% phi bridge.',
    source: 'Chainlink Blog',
    timeAgo: '6 gio truoc',
    category: 'defi',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['LINK'],
    icon: 'link',
    iconColor: AccentTone.tierPlatinum,
    readTime: '5 phut',
  ),
  MarketNewsItem(
    id: 'n9',
    title: 'Ca voi BTC chuyen \$450M ve san — tin hieu ban?',
    summary:
        'Du lieu on-chain cho thay mot vi ca voi da chuyen 6,700 BTC ve Coinbase, tao lo ngai ap luc ban.',
    source: 'Whale Alert',
    timeAgo: '7 gio truoc',
    category: 'bitcoin',
    sentiment: MarketNewsSentiment.bearish,
    relatedTokens: ['BTC'],
    icon: 'waterDrop',
    iconColor: AccentTone.info,
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n10',
    title: 'NFT marketplace OpenSea ra mat phien ban moi hoan toan',
    summary:
        'OpenSea 2.0 gioi thieu giao dien moi, ho tro da chuoi tot hon va giam phi giao dich xuong 1%.',
    source: 'OpenSea Blog',
    timeAgo: '8 gio truoc',
    category: 'nft',
    sentiment: MarketNewsSentiment.neutral,
    relatedTokens: ['ETH', 'SOL'],
    icon: 'palette',
    iconColor: AccentTone.accent,
    readTime: '4 phut',
  ),
  MarketNewsItem(
    id: 'n11',
    title: 'EU ap dung MiCA day du tu thang 4 — anh huong gi?',
    summary:
        'Khung phap ly Markets in Crypto-Assets se co hieu luc toan phan, yeu cau cac san giao dich phai dang ky giay phep.',
    source: 'CoinTelegraph',
    timeAgo: '10 gio truoc',
    category: 'regulation',
    sentiment: MarketNewsSentiment.neutral,
    relatedTokens: ['BTC', 'ETH', 'USDT'],
    icon: 'accountBalance',
    iconColor: AccentTone.tierPlatinum,
    readTime: '6 phut',
  ),
  MarketNewsItem(
    id: 'n12',
    title: 'Phan tich: Altcoin season sap bat dau?',
    summary:
        'Chi so Altcoin Season Index dat 68/100, nhieu altcoin lon outperform BTC trong 7 ngay qua. Chuyen gia nhan dinh xu huong se tiep tuc.',
    source: 'Messari',
    timeAgo: '12 gio truoc',
    category: 'analysis',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['SOL', 'AVAX', 'MATIC'],
    icon: 'barChart',
    iconColor: AccentTone.medalSilverBlue,
    readTime: '5 phut',
  ),
];

const PortfolioStats _portfolioStats = PortfolioStats(
  totalValue: 56279.10,
  totalPnl: 7140.30,
  totalPnlPct: 14.53,
  totalCost: 49138.80,
  best24hSymbol: 'SOL',
  best24hChange: 8.07,
  worst24hSymbol: 'ETH',
  worst24hChange: -1.23,
  stableAllocation: 22.2,
);

const List<PortfolioHolding> _portfolioHoldings = [
  PortfolioHolding(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    quantity: 0.23451,
    avgBuyPrice: 58200,
    currentPrice: 67543.21,
    value: 15839.84,
    pnl: 2190.84,
    pnlPct: 16.04,
    allocation: 28.2,
    change24h: 2.34,
    sparkline: [65100, 65800, 66500, 67000, 67200, 67543],
  ),
  PortfolioHolding(
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    quantity: 3.521,
    avgBuyPrice: 3200,
    currentPrice: 3521.45,
    value: 12400.02,
    pnl: 1132.02,
    pnlPct: 10.05,
    allocation: 22.1,
    change24h: -1.23,
    sparkline: [3565, 3555, 3540, 3530, 3525, 3521],
  ),
  PortfolioHolding(
    id: 'usdt',
    symbol: 'USDT',
    name: 'Tether',
    quantity: 12450.80,
    avgBuyPrice: 1,
    currentPrice: 1,
    value: 12450.80,
    pnl: 0,
    pnlPct: 0,
    allocation: 22.2,
    change24h: 0.01,
    sparkline: [1, 1, 1, 1, 1, 1],
  ),
  PortfolioHolding(
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    quantity: 45.8,
    avgBuyPrice: 120,
    currentPrice: 178.32,
    value: 8167.06,
    pnl: 2671.06,
    pnlPct: 48.60,
    allocation: 14.5,
    change24h: 8.07,
    sparkline: [165, 168, 172, 175, 178, 178.32],
  ),
  PortfolioHolding(
    id: 'bnb',
    symbol: 'BNB',
    name: 'BNB',
    quantity: 12.5,
    avgBuyPrice: 350,
    currentPrice: 412.87,
    value: 5160.88,
    pnl: 785.88,
    pnlPct: 17.97,
    allocation: 9.2,
    change24h: 3.61,
    sparkline: [398, 402, 407, 410, 412, 412.87],
  ),
  PortfolioHolding(
    id: 'ada',
    symbol: 'ADA',
    name: 'Cardano',
    quantity: 5000,
    avgBuyPrice: 0.38,
    currentPrice: 0.4521,
    value: 2260.50,
    pnl: 360.50,
    pnlPct: 18.97,
    allocation: 4.0,
    change24h: 3.22,
    sparkline: [0.44, 0.445, 0.448, 0.450, 0.451, 0.4521],
  ),
];

const List<PortfolioPerformancePoint> _portfolioPerformance = [
  PortfolioPerformancePoint(date: '30d trước', value: 48500),
  PortfolioPerformancePoint(date: '25d trước', value: 49200),
  PortfolioPerformancePoint(date: '20d trước', value: 50100),
  PortfolioPerformancePoint(date: '15d trước', value: 49800),
  PortfolioPerformancePoint(date: '10d trước', value: 51400),
  PortfolioPerformancePoint(date: '7d trước', value: 52800),
  PortfolioPerformancePoint(date: '5d trước', value: 53600),
  PortfolioPerformancePoint(date: '3d trước', value: 54900),
  PortfolioPerformancePoint(date: 'Hôm qua', value: 55100),
  PortfolioPerformancePoint(date: 'Hôm nay', value: 56279),
];

const MarketScreenFilters _marketPortfolioFilters = MarketScreenFilters(
  categories: ['Tổng quan', 'Tài sản', 'Hiệu suất'],
  defaultCategory: 'Tổng quan',
  defaultSort: 'value',
  sortOptions: [
    MarketSortOption(id: 'value', label: 'Giá trị'),
    MarketSortOption(id: 'pnl', label: 'Lãi/Lỗ'),
    MarketSortOption(id: 'change', label: 'Thay đổi 24h'),
  ],
);

const MarketScreenFilters _marketNewsFilters = MarketScreenFilters(
  categories: [
    'Tất cả',
    'Nóng',
    'Bitcoin',
    'Altcoin',
    'DeFi',
    'Vĩ mô',
    'Pháp lý',
    'Phân tích',
    'NFT',
  ],
  defaultCategory: 'Tất cả',
  defaultSort: 'latest',
  sortOptions: [
    MarketSortOption(id: 'bullish', label: 'Tích cực'),
    MarketSortOption(id: 'neutral', label: 'Trung lập'),
    MarketSortOption(id: 'bearish', label: 'Tiêu cực'),
  ],
);

const List<MarketNewsCategory> _marketNewsCategories = [
  MarketNewsCategory(id: 'all', label: 'Tất cả', color: AccentTone.text3),
  MarketNewsCategory(id: 'breaking', label: 'Nóng', color: AccentTone.sell),
  MarketNewsCategory(id: 'bitcoin', label: 'Bitcoin', color: AccentTone.warn),
  MarketNewsCategory(id: 'altcoin', label: 'Altcoin', color: AccentTone.accent),
  MarketNewsCategory(id: 'defi', label: 'DeFi', color: AccentTone.info),
  MarketNewsCategory(id: 'macro', label: 'Vĩ mô', color: AccentTone.text3),
  MarketNewsCategory(
    id: 'regulation',
    label: 'Pháp lý',
    color: AccentTone.warn,
  ),
  MarketNewsCategory(id: 'analysis', label: 'Phân tích', color: AccentTone.buy),
  MarketNewsCategory(id: 'nft', label: 'NFT', color: AccentTone.accent),
];
