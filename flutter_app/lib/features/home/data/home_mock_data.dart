import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';

class HomeMockData {
  const HomeMockData._();

  static const double totalBalance = 54276.79;
  static const double totalBtc = 0.57133463;
  static const double spotBalance = 37993.75;
  static const double earnBalance = 10855.36;
  static const double fundingBalance = 5427.68;
  static const double dailyPnl = 1842.31;
  static const double dailyPct = 3.52;
  static const portfolioTrend7d = <double>[
    52400.0,
    52850.0,
    53100.0,
    52900.0,
    53500.0,
    53800.0,
    totalBalance,
  ];
  static const int notifications = 3;

  static const snapshot = HomeSnapshot(
    totalBalance: totalBalance,
    totalBtc: totalBtc,
    spotBalance: spotBalance,
    earnBalance: earnBalance,
    fundingBalance: fundingBalance,
    dailyPnl: dailyPnl,
    dailyPct: dailyPct,
    portfolioTrend7d: portfolioTrend7d,
    notifications: notifications,
    announcements: announcements,
    quickActions: quickActions,
    productGroups: [],
    nextAction: nextAction,
    recentProducts: recentProducts,
    pairs: pairs,
  );

  static const announcements = [
    HomeAnnouncement(
      id: 'btc-fee-campaign',
      text: 'Phí giao dịch 0% cho BTC/USDT trong 7 ngày!',
      type: HomeAnnouncementType.campaign,
      routePath: '/trade/btcusdt',
    ),
    HomeAnnouncement(
      id: 'p2p-launch-info',
      text: 'Ra mắt tính năng P2P - Mua bán USDT bằng VND ngay!',
      type: HomeAnnouncementType.info,
      routePath: '/p2p',
    ),
    HomeAnnouncement(
      id: 'security-2fa',
      text: 'Bật 2FA để bảo vệ tài khoản VitTrade',
      type: HomeAnnouncementType.security,
      routePath: '/settings/security',
    ),
  ];

  /// Compact «Hành động nhanh»: 4 ô visible; phần còn lại vào sheet.
  /// Một nguồn sản phẩm — không nhân đôi bằng productGroups trên scroll.
  /// Không gồm Support / Referral / Discovery (Predictions, Arena).
  static const quickActions = [
    HomeQuickAction(
      icon: 'quickBuy',
      label: 'Mua nhanh',
      routePath: '/trade/btcusdt',
      accentKey: 'trade',
      stateLabel: 'Spot',
    ),
    HomeQuickAction(
      icon: 'convert',
      label: 'Chuyển đổi',
      routePath: '/trade/convert',
      accentKey: 'trade',
      stateLabel: 'Core',
    ),
    HomeQuickAction(
      icon: 'wallet',
      label: 'Nạp/Rút',
      routePath: '/wallet',
      accentKey: 'info',
      stateLabel: 'Wallet',
    ),
    HomeQuickAction(
      icon: 'p2p',
      label: 'P2P',
      routePath: '/p2p',
      accentKey: 'successBright',
      stateLabel: 'Escrow',
    ),
    HomeQuickAction(
      icon: 'dca',
      label: 'Mua định kỳ',
      routePath: '/dca',
      accentKey: 'caution',
      stateLabel: 'DCA',
    ),
    HomeQuickAction(
      icon: 'staking',
      label: 'Staking',
      routePath: '/earn',
      accentKey: 'buy',
      stateLabel: 'Earn',
    ),
    HomeQuickAction(
      icon: 'savings',
      label: 'Tiết kiệm',
      routePath: '/earn/savings',
      accentKey: 'buy',
      stateLabel: 'Yield',
    ),
    HomeQuickAction(
      icon: 'launchpad',
      label: 'Launchpad',
      routePath: '/launchpad',
      accentKey: 'riskHigh',
      stateLabel: 'Token mới',
      riskBadge: 'Rủi ro cao',
    ),
    HomeQuickAction(
      icon: 'rewards',
      label: 'Phần thưởng',
      routePath: '/rewards',
      accentKey: 'medalGold',
      stateLabel: 'Phần thưởng',
    ),
    HomeQuickAction(
      icon: 'margin',
      label: 'Margin',
      routePath: '/trade/margin',
      accentKey: 'riskHigh',
      stateLabel: 'Pro',
      riskBadge: 'Rủi ro cao',
    ),
    HomeQuickAction(
      icon: 'copyTrade',
      label: 'Copy Trade',
      routePath: '/trade/copy-trading',
      accentKey: 'accentDark',
      stateLabel: 'Social',
    ),
    HomeQuickAction(
      icon: 'bot',
      label: 'Bot',
      routePath: '/trade/bots',
      accentKey: 'caution',
      stateLabel: 'Auto',
      riskBadge: 'Rủi ro cao',
    ),
    HomeQuickAction(
      icon: 'discover',
      label: 'Chủ đề',
      routePath: '/topics',
      accentKey: 'discovery',
      stateLabel: 'Chủ đề',
    ),
  ];

  static const nextAction = HomeNextAction(
    icon: 'withdraw',
    title: 'Hoàn tất rút USDT',
    subtitle: 'TRC20 sẵn sàng, cần xem lại phí và xác nhận 2FA',
    routePath: '/wallet/withdraw/USDT',
    ctaLabel: 'Tiếp tục',
    accentKey: 'wallet',
    stateLabel: 'Next',
  );

  static const recentProducts = [
    HomeRecentProduct(
      id: 'spot-btc',
      icon: 'quickBuy',
      label: 'BTC/USDT',
      contextLabel: 'Lệnh spot',
      routePath: '/trade/btcusdt',
      accentKey: 'trade',
      stateLabel: 'Spot',
    ),
    HomeRecentProduct(
      id: 'p2p-usdt',
      icon: 'p2p',
      label: 'P2P USDT/VND',
      contextLabel: 'Ký quỹ',
      routePath: '/p2p',
      accentKey: 'p2p',
      stateLabel: 'P2P',
    ),
    HomeRecentProduct(
      id: 'staking-eth',
      icon: 'staking',
      label: 'ETH staking',
      contextLabel: 'Earn',
      routePath: '/earn',
      accentKey: 'earn',
      stateLabel: 'Earn',
    ),
    HomeRecentProduct(
      id: 'copy-alpha',
      icon: 'copyTrade',
      label: 'Alpha Copy',
      contextLabel: 'Nhà cung cấp',
      routePath: '/trade/copy-trading',
      accentKey: 'trade',
      stateLabel: 'Copy',
    ),
  ];

  static const pairs = [
    HomeCryptoPair(
      id: 'btcusdt',
      symbol: 'BTC/USDT',
      baseAsset: 'BTC',
      price: 67543.21,
      change24h: 2.34,
      volume24h: 23456789000,
      sparkline: [
        65100,
        65400,
        65200,
        65800,
        66200,
        65900,
        66500,
        67000,
        66800,
        67200,
        67100,
        67543,
      ],
      isFavorite: true,
    ),
    HomeCryptoPair(
      id: 'ethusdt',
      symbol: 'ETH/USDT',
      baseAsset: 'ETH',
      price: 3521.45,
      change24h: -1.23,
      volume24h: 8765432000,
      sparkline: [
        3565,
        3555,
        3570,
        3540,
        3530,
        3545,
        3520,
        3510,
        3525,
        3515,
        3530,
        3521,
      ],
      isFavorite: true,
    ),
    HomeCryptoPair(
      id: 'bnbusdt',
      symbol: 'BNB/USDT',
      baseAsset: 'BNB',
      price: 412.87,
      change24h: 3.61,
      volume24h: 1234567000,
      sparkline: [398, 400, 402, 405, 403, 407, 410, 408, 411, 413, 412.87],
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'solusdt',
      symbol: 'SOL/USDT',
      baseAsset: 'SOL',
      price: 178.32,
      change24h: 8.07,
      volume24h: 3456789000,
      sparkline: [165, 168, 170, 172, 171, 175, 176, 179, 178, 180, 178.32],
      isFavorite: true,
    ),
    HomeCryptoPair(
      id: 'xrpusdt',
      symbol: 'XRP/USDT',
      baseAsset: 'XRP',
      price: 0.6234,
      change24h: -2.59,
      volume24h: 1876543000,
      sparkline: [0.64, 0.638, 0.635, 0.632, 0.628, 0.625, 0.621, 0.6234],
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'adausdt',
      symbol: 'ADA/USDT',
      baseAsset: 'ADA',
      price: 0.4521,
      change24h: 3.22,
      volume24h: 654321000,
      sparkline: [0.438, 0.440, 0.442, 0.445, 0.448, 0.450, 0.452, 0.4521],
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'dotusdt',
      symbol: 'DOT/USDT',
      baseAsset: 'DOT',
      price: 7.832,
      change24h: -3.55,
      volume24h: 432109000,
      sparkline: [8.12, 8.05, 7.98, 7.92, 7.88, 7.85, 7.83, 7.832],
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'maticusdt',
      symbol: 'MATIC/USDT',
      baseAsset: 'MATIC',
      price: 0.8976,
      change24h: 5.60,
      volume24h: 789012000,
      sparkline: [0.850, 0.855, 0.862, 0.870, 0.875, 0.882, 0.890, 0.8976],
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'avaxusdt',
      symbol: 'AVAX/USDT',
      baseAsset: 'AVAX',
      price: 38.54,
      change24h: 4.73,
      volume24h: 567890000,
      sparkline: [36.8, 37.0, 37.3, 37.6, 37.9, 38.1, 38.4, 38.54],
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'linkusdt',
      symbol: 'LINK/USDT',
      baseAsset: 'LINK',
      price: 14.23,
      change24h: -5.76,
      volume24h: 345678000,
      sparkline: [15.10, 15.00, 14.85, 14.70, 14.55, 14.40, 14.30, 14.23],
      isFavorite: false,
    ),
  ];
}
