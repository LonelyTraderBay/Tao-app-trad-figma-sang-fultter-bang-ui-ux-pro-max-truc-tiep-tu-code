part of '../repositories/mock_p2p_repository.dart';

const List<String> _p2pHomeAssets = ['USDT', 'BTC', 'ETH', 'BNB', 'SOL'];

const List<String> _p2pHomeFiats = ['VND', 'USD'];

const P2PHomePlatformStatsDraft _p2pHomePlatformStats =
    P2PHomePlatformStatsDraft(
      volume24h: 12850000000,
      volume24hChange: 8.7,
      totalTrades24h: 3247,
      activeMerchants: 428,
      onlineTraders: 1892,
      avgCompletionRate: 94.5,
      avgCompletionTime: '6 phút',
      escrowProtected: 45200000000,
    );

const List<P2PHomeQuickActionDraft> _p2pHomeQuickActions = [
  P2PHomeQuickActionDraft(
    id: 'express',
    title: 'Express nhanh',
    subtitle: 'Ghép tin nhanh · 1 chạm',
    iconKey: 'bolt',
    route: '/p2p/express',
    toneKey: 'buy',
  ),
  P2PHomeQuickActionDraft(
    id: 'create',
    title: 'Tạo tin',
    subtitle: 'Tạo quảng cáo P2P',
    iconKey: 'add',
    route: '/p2p/create',
    toneKey: 'primary',
  ),
];

// Shared ad catalog owned by Home/Discovery — getHome()/getExpress() browse
// it directly; Ads' getAdDetail() reaches in to look up a single record.
const List<P2PAdDraft> _p2pAds = [
  P2PAdDraft(
    id: 'ad001',
    type: P2PTradeType.sell,
    asset: 'USDT',
    merchant: 'CryptoKing_VN',
    merchantId: 'mc001',
    merchantVerified: true,
    completedOrders: 1243,
    completionRate: 98.5,
    price: 25350,
    minLimit: 500000,
    maxLimit: 50000000,
    paymentMethods: ['Vietcombank', 'Momo', 'ZaloPay'],
    avgResponseTime: '2 phút',
    isOnline: true,
    kycMinimum: 1,
    available: 10000,
    merchantBadge: 'elite',
    merchantRating: 4.8,
  ),
  P2PAdDraft(
    id: 'ad002',
    type: P2PTradeType.sell,
    asset: 'USDT',
    merchant: 'TradeMaster99',
    merchantId: 'mc002',
    merchantVerified: true,
    completedOrders: 567,
    completionRate: 96.2,
    price: 25380,
    minLimit: 1000000,
    maxLimit: 100000000,
    paymentMethods: ['Techcombank', 'VietinBank'],
    avgResponseTime: '5 phút',
    isOnline: true,
    kycMinimum: 1,
    available: 5000,
    priceType: 'floating',
    priceMargin: .12,
    merchantBadge: 'pro',
    merchantRating: 4.2,
  ),
  P2PAdDraft(
    id: 'ad003',
    type: P2PTradeType.sell,
    asset: 'USDT',
    merchant: 'CoinHunter_HCM',
    merchantId: 'mc003',
    merchantVerified: false,
    completedOrders: 234,
    completionRate: 94.1,
    price: 25400,
    minLimit: 200000,
    maxLimit: 20000000,
    paymentMethods: ['Momo', 'ZaloPay'],
    avgResponseTime: '8 phút',
    isOnline: false,
    kycMinimum: 0,
    available: 2500,
    isNewMerchant: true,
    merchantRating: 3.8,
  ),
  P2PAdDraft(
    id: 'ad004',
    type: P2PTradeType.buy,
    asset: 'USDT',
    merchant: 'VIPTrader_HN',
    merchantId: 'mc004',
    merchantVerified: true,
    completedOrders: 3421,
    completionRate: 99.1,
    price: 25280,
    minLimit: 2000000,
    maxLimit: 200000000,
    paymentMethods: ['Vietcombank', 'BIDV', 'Momo'],
    avgResponseTime: '1 phút',
    isOnline: true,
    kycMinimum: 2,
    available: 50000,
    merchantBadge: 'elite',
    merchantRating: 4.9,
  ),
];

const List<P2PAssetDraft> _p2pAssets = [
  P2PAssetDraft(symbol: 'USDT', name: 'Tether', marketPriceVnd: 25300),
  P2PAssetDraft(symbol: 'BTC', name: 'Bitcoin', marketPriceVnd: 1715000000),
  P2PAssetDraft(symbol: 'ETH', name: 'Ethereum', marketPriceVnd: 89000000),
  P2PAssetDraft(symbol: 'BNB', name: 'BNB', marketPriceVnd: 15200000),
  P2PAssetDraft(symbol: 'SOL', name: 'Solana', marketPriceVnd: 4800000),
];

const List<P2PPaymentMethodDraft> _p2pPaymentMethods = [
  P2PPaymentMethodDraft(
    id: 'vietcombank',
    bankName: 'Vietcombank',
    isVerified: true,
  ),
  P2PPaymentMethodDraft(
    id: 'techcombank',
    bankName: 'Techcombank',
    isVerified: true,
  ),
  P2PPaymentMethodDraft(id: 'momo', bankName: 'Momo', isVerified: true),
];
