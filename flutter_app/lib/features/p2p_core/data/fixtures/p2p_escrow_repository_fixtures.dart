part of '../repositories/mock_p2p_repository.dart';

const List<P2PEscrowAssetBalanceDraft> _p2pEscrowAssets = [
  P2PEscrowAssetBalanceDraft(asset: 'USDT', totalAmount: 3200, orderCount: 3),
  P2PEscrowAssetBalanceDraft(asset: 'BTC', totalAmount: .01, orderCount: 1),
  P2PEscrowAssetBalanceDraft(
    asset: 'VND',
    totalAmount: 12000000,
    orderCount: 1,
  ),
];

const Map<String, List<P2PEscrowOrderDraft>> _p2pEscrowOrders = {
  'USDT': [
    P2PEscrowOrderDraft(
      id: '1',
      orderId: '#P2P-45892',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 1500,
      fiatAmount: 36000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***89',
      status: P2PEscrowOrderStatus.paid,
      lockedAt: '2026-03-05 14:20',
      estimatedRelease: '2026-03-05 15:20',
    ),
    P2PEscrowOrderDraft(
      id: '2',
      orderId: '#P2P-45880',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 1000,
      fiatAmount: 24000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***12',
      status: P2PEscrowOrderStatus.pendingPayment,
      lockedAt: '2026-03-05 13:45',
      estimatedRelease: '2026-03-05 14:45',
    ),
    P2PEscrowOrderDraft(
      id: '3',
      orderId: '#P2P-45870',
      type: P2PEscrowOrderType.sell,
      asset: 'USDT',
      amount: 700,
      fiatAmount: 16800000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***45',
      status: P2PEscrowOrderStatus.dispute,
      lockedAt: '2026-03-05 10:30',
      estimatedRelease: 'Đang giải quyết',
      warning:
          'Đơn hàng đang tranh chấp. Số tiền sẽ được giữ cho đến khi giải quyết xong.',
    ),
  ],
  'BTC': [
    P2PEscrowOrderDraft(
      id: '4',
      orderId: '#P2P-45860',
      type: P2PEscrowOrderType.sell,
      asset: 'BTC',
      amount: .01,
      fiatAmount: 25000000,
      fiatCurrency: 'VND',
      counterparty: 'buyer_***78',
      status: P2PEscrowOrderStatus.paid,
      lockedAt: '2026-03-04 16:20',
      estimatedRelease: '2026-03-05 16:20',
    ),
  ],
  'VND': [
    P2PEscrowOrderDraft(
      id: '5',
      orderId: '#P2P-45850',
      type: P2PEscrowOrderType.buy,
      asset: 'USDT',
      amount: 500,
      fiatAmount: 12000000,
      fiatCurrency: 'VND',
      counterparty: 'seller_***34',
      status: P2PEscrowOrderStatus.pendingRelease,
      lockedAt: '2026-03-05 12:10',
      estimatedRelease: '2026-03-05 13:10',
    ),
  ],
};

const List<String> _p2pEscrowHelpBullets = [
  'Bán crypto: sau khi bạn release cho buyer',
  'Mua crypto: sau khi seller release cho bạn',
  'Tranh chấp: sau khi Support giải quyết xong',
  'Hủy đơn: tiền trả về ngay lập tức',
];

const String _p2pEscrowAddress = '0x579bdf13579bdf13579bdf13579bdf13579bdf13';

const List<P2PEscrowSignerDraft> _p2pEscrowSigners = [
  P2PEscrowSignerDraft(
    id: 'buyer',
    role: 'buyer',
    label: 'Người mua',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: false,
  ),
  P2PEscrowSignerDraft(
    id: 'seller',
    role: 'seller',
    label: 'Người bán (CryptoKing_VN)',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: false,
  ),
  P2PEscrowSignerDraft(
    id: 'platform',
    role: 'platform',
    label: 'VitTrade Platform',
    address: '0xfb73fb73fb73fb73fb73fb73fb73fb73fb73fb73',
    hasSigned: true,
    signedAt: '11:00',
  ),
];

const List<P2PEscrowTimelineEventDraft> _p2pEscrowTimeline = [
  P2PEscrowTimelineEventDraft(
    id: 'created',
    label: 'Escrow được tạo',
    description: 'Smart contract khởi tạo · 200.0000 USDT',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'key',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'locked',
    label: 'Coin đã khóa',
    description: '200.0000 USDT chuyển vào escrow address',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'lock',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'waiting_payment',
    label: 'Chờ thanh toán fiat',
    description: 'Người mua cần chuyển khoản & xác nhận',
    time: 'Đang chờ',
    status: P2POrderStepStatus.active,
    iconKey: 'clock',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'confirm_pending',
    label: 'Xác nhận nhận tiền',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'shield',
  ),
  P2PEscrowTimelineEventDraft(
    id: 'release_pending',
    label: 'Giải phóng coin',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'unlock',
  ),
];
