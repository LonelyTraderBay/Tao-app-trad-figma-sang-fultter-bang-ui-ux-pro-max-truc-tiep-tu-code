part of '../repositories/mock_p2p_repository.dart';

const List<P2PAdDailyPerformanceDraft> _p2pAdDailyPerformance = [
  P2PAdDailyPerformanceDraft(
    date: '20/02',
    impressions: 412,
    orders: 8,
    volume: 68000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '21/02',
    impressions: 389,
    orders: 12,
    volume: 95000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '22/02',
    impressions: 478,
    orders: 15,
    volume: 112000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '23/02',
    impressions: 356,
    orders: 6,
    volume: 48000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '24/02',
    impressions: 501,
    orders: 18,
    volume: 142000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '25/02',
    impressions: 445,
    orders: 14,
    volume: 108000000,
  ),
  P2PAdDailyPerformanceDraft(
    date: '26/02',
    impressions: 520,
    orders: 20,
    volume: 158000000,
  ),
];

const List<P2PAdHourlyHeatmapDraft> _p2pAdHourlyHeatmap = [
  P2PAdHourlyHeatmapDraft(hour: 0, orders: 2),
  P2PAdHourlyHeatmapDraft(hour: 1, orders: 1),
  P2PAdHourlyHeatmapDraft(hour: 2, orders: 0),
  P2PAdHourlyHeatmapDraft(hour: 3, orders: 0),
  P2PAdHourlyHeatmapDraft(hour: 4, orders: 1),
  P2PAdHourlyHeatmapDraft(hour: 5, orders: 2),
  P2PAdHourlyHeatmapDraft(hour: 6, orders: 4),
  P2PAdHourlyHeatmapDraft(hour: 7, orders: 8),
  P2PAdHourlyHeatmapDraft(hour: 8, orders: 15),
  P2PAdHourlyHeatmapDraft(hour: 9, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 10, orders: 28),
  P2PAdHourlyHeatmapDraft(hour: 11, orders: 24),
  P2PAdHourlyHeatmapDraft(hour: 12, orders: 18),
  P2PAdHourlyHeatmapDraft(hour: 13, orders: 20),
  P2PAdHourlyHeatmapDraft(hour: 14, orders: 26),
  P2PAdHourlyHeatmapDraft(hour: 15, orders: 24),
  P2PAdHourlyHeatmapDraft(hour: 16, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 17, orders: 18),
  P2PAdHourlyHeatmapDraft(hour: 18, orders: 15),
  P2PAdHourlyHeatmapDraft(hour: 19, orders: 20),
  P2PAdHourlyHeatmapDraft(hour: 20, orders: 25),
  P2PAdHourlyHeatmapDraft(hour: 21, orders: 22),
  P2PAdHourlyHeatmapDraft(hour: 22, orders: 12),
  P2PAdHourlyHeatmapDraft(hour: 23, orders: 5),
];

const List<P2PAdPaymentBreakdownDraft> _p2pAdPaymentBreakdown = [
  P2PAdPaymentBreakdownDraft(
    method: 'Vietcombank',
    count: 156,
    volume: 1240000000,
  ),
  P2PAdPaymentBreakdownDraft(method: 'Momo', count: 118, volume: 940000000),
];

const List<P2PAdCompetitorComparisonDraft> _p2pAdCompetitorComparison = [
  P2PAdCompetitorComparisonDraft(
    metric: 'Giá',
    yours: 25360,
    average: 25320,
    top: 25280,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Tỷ lệ HT (%)',
    yours: 94.8,
    average: 89.2,
    top: 98.5,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Phản hồi (s)',
    yours: 45,
    average: 120,
    top: 25,
  ),
  P2PAdCompetitorComparisonDraft(
    metric: 'Rating',
    yours: 4.8,
    average: 4.2,
    top: 4.9,
  ),
];

const List<P2PAdOptimizationTipDraft> _p2pAdOptimizationTips = [
  P2PAdOptimizationTipDraft(
    tone: 'buy',
    iconKey: 'check',
    text: 'Tỷ lệ hoàn thành tốt! Duy trì phản hồi nhanh để giữ vị trí top 3.',
  ),
  P2PAdOptimizationTipDraft(
    tone: 'accent',
    iconKey: 'clock',
    text: 'Giờ cao điểm 9h-11h & 20h-21h. Đảm bảo online trong khung giờ này.',
  ),
  P2PAdOptimizationTipDraft(
    tone: 'warn',
    iconKey: 'trend',
    text: 'CVR tốt! Xem xét tăng available amount để đón thêm đơn.',
  ),
];

const List<P2PMyAdDraft> _p2pMyAds = [
  P2PMyAdDraft(
    id: 'myad001',
    type: P2PTradeType.sell,
    asset: 'USDT',
    price: 25360,
    currency: 'VND',
    priceType: 'fixed',
    minLimit: 500000,
    maxLimit: 30000000,
    available: 3000,
    paymentMethods: ['Vietcombank', 'Momo'],
    avgResponseTime: '5 phút',
    status: P2PMyAdStatus.active,
    totalVolume30dUsd: 28000,
    tradingHours: '08:00 - 22:00',
  ),
  P2PMyAdDraft(
    id: 'myad002',
    type: P2PTradeType.buy,
    asset: 'USDT',
    price: 25250,
    currency: 'VND',
    priceType: 'floating',
    priceMargin: -0.4,
    minLimit: 1000000,
    maxLimit: 50000000,
    available: 5000,
    paymentMethods: ['Vietcombank', 'Techcombank', 'Momo'],
    avgResponseTime: '5 phút',
    status: P2PMyAdStatus.active,
    totalVolume30dUsd: 28000,
  ),
  P2PMyAdDraft(
    id: 'myad003',
    type: P2PTradeType.sell,
    asset: 'BTC',
    price: 1718000000,
    currency: 'VND',
    priceType: 'fixed',
    minLimit: 5000000,
    maxLimit: 100000000,
    available: .1,
    paymentMethods: ['Vietcombank'],
    avgResponseTime: '5 phút',
    status: P2PMyAdStatus.paused,
    totalVolume30dUsd: 28000,
  ),
];
