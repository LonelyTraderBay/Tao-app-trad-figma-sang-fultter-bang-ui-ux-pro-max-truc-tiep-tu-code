part of '../repositories/mock_p2p_repository.dart';

const List<P2POrderTimelineEventDraft> _p2pOrderTimelineEvents = [
  P2POrderTimelineEventDraft(
    id: '1',
    typeKey: 'created',
    title: 'Order Created',
    time: '2026-03-05 14:20:00',
    status: P2POrderTimelineStatus.completed,
    actor: 'You',
  ),
  P2POrderTimelineEventDraft(
    id: '2',
    typeKey: 'matched',
    title: 'Matched with Seller',
    time: '2026-03-05 14:20:15',
    status: P2POrderTimelineStatus.completed,
    actor: 'System',
  ),
  P2POrderTimelineEventDraft(
    id: '3',
    typeKey: 'locked',
    title: 'Funds Locked in Escrow',
    time: '2026-03-05 14:20:30',
    status: P2POrderTimelineStatus.completed,
    actor: 'Seller',
  ),
  P2POrderTimelineEventDraft(
    id: '4',
    typeKey: 'payment',
    title: 'Payment Instructions Sent',
    time: '2026-03-05 14:21:00',
    status: P2POrderTimelineStatus.completed,
    actor: 'Seller',
  ),
  P2POrderTimelineEventDraft(
    id: '5',
    typeKey: 'paid',
    title: 'Marked as Paid',
    time: '2026-03-05 14:35:22',
    status: P2POrderTimelineStatus.completed,
    actor: 'You',
  ),
  P2POrderTimelineEventDraft(
    id: '6',
    typeKey: 'confirming',
    title: 'Awaiting Seller Confirmation',
    time: '2026-03-05 14:35:30',
    status: P2POrderTimelineStatus.pending,
    actor: 'Seller',
  ),
];

const List<P2POrderRateTagDraft> _p2pOrderRateTags = [
  P2POrderRateTagDraft(label: 'Giao dịch nhanh', iconKey: 'speed'),
  P2POrderRateTagDraft(label: 'Thân thiện', iconKey: 'positive'),
  P2POrderRateTagDraft(label: 'Đáng tin cậy', iconKey: 'trust'),
  P2POrderRateTagDraft(label: 'Giá tốt', iconKey: 'price'),
  P2POrderRateTagDraft(label: 'Phản hồi chậm', iconKey: 'slow'),
  P2POrderRateTagDraft(label: 'Cần cải thiện', iconKey: 'improve'),
];

const List<String> _p2pOrderCancelReasons = [
  'Không muốn giao dịch nữa',
  'Đã tìm được giá tốt hơn',
  'Người bán không phản hồi',
  'Thông tin thanh toán không đúng',
  'Lý do khác',
];

const List<String> _p2pOrderProofTips = [
  'Chụp toàn bộ màn hình giao dịch ngân hàng',
  'Hiển thị rõ số tiền, ngày giờ và người nhận',
  'Nội dung chuyển khoản phải đúng mã đơn',
  'Không chỉnh sửa hoặc cắt ghép ảnh',
];

const List<P2POrderPaymentFieldDraft> _p2pOrderPaymentFields = [
  P2POrderPaymentFieldDraft(
    id: 'bank',
    label: 'Ngân hàng',
    value: 'Vietcombank',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'account',
    label: 'Số tài khoản',
    value: '1234567890',
    monospace: true,
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'name',
    label: 'Tên chủ TK',
    value: 'NGUYEN VAN B',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'amount',
    label: 'Số tiền',
    value: '5.070.000 VND',
    emphasis: true,
  ),
  P2POrderPaymentFieldDraft(
    id: 'content',
    label: 'Nội dung CK',
    value: 'VITTA P2P001',
    monospace: true,
    emphasis: true,
  ),
];

const List<P2POrderTimelineStepDraft> _p2pOrderTimelineSteps = [
  P2POrderTimelineStepDraft(
    id: 'created',
    label: 'Đơn hàng đã tạo',
    description: 'Mua 200.0000 USDT - Escrow đã khóa',
    time: '11:00',
    status: P2POrderStepStatus.completed,
    iconKey: 'created',
  ),
  P2POrderTimelineStepDraft(
    id: 'payment',
    label: 'Chờ thanh toán',
    description: 'Chuyển 5.070.000 VND qua Vietcombank',
    time: 'Đang chờ',
    status: P2POrderStepStatus.active,
    iconKey: 'payment',
  ),
  P2POrderTimelineStepDraft(
    id: 'confirm',
    label: 'Xác nhận thanh toán',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'confirm',
  ),
  P2POrderTimelineStepDraft(
    id: 'release',
    label: 'Giải phóng crypto',
    description: '',
    time: '-',
    status: P2POrderStepStatus.pending,
    iconKey: 'release',
  ),
];

const List<P2POrderQuickActionDraft> _p2pOrderQuickActions = [
  P2POrderQuickActionDraft(
    id: 'merchant',
    label: 'Merchant',
    iconKey: 'merchant',
    route: '/p2p/merchant/mc001',
  ),
  P2POrderQuickActionDraft(
    id: 'block',
    label: 'Chặn',
    iconKey: 'block',
    route: '/p2p/blacklist',
  ),
  P2POrderQuickActionDraft(
    id: 'guide',
    label: 'Hướng dẫn',
    iconKey: 'guide',
    route: '/p2p/guide',
  ),
  P2POrderQuickActionDraft(
    id: 'support',
    label: 'Hỗ trợ',
    iconKey: 'support',
    route: '/support/help',
  ),
];

const List<P2PChatMessageDraft> _p2pChatMessages = [
  P2PChatMessageDraft(
    id: 'system-created',
    sender: P2PChatSender.system,
    text:
        'Đơn hàng #VT-P2P-20240221-001 đã được tạo. Vui lòng thanh toán trong 15 phút.',
    time: '11:00',
  ),
  P2PChatMessageDraft(
    id: 'merchant-hello',
    sender: P2PChatSender.other,
    text: 'Xin chào! Vui lòng chuyển khoản theo thông tin tôi cung cấp nhé',
    time: '11:01',
  ),
  P2PChatMessageDraft(
    id: 'buyer-account',
    sender: P2PChatSender.me,
    text: 'Vâng, tôi sẽ chuyển ngay. Số tài khoản là 1234567890 đúng không?',
    time: '11:02',
  ),
  P2PChatMessageDraft(
    id: 'merchant-confirm',
    sender: P2PChatSender.other,
    text: 'Đúng rồi. Chủ tài khoản NGUYEN VAN B - Vietcombank.',
    time: '11:02',
  ),
  P2PChatMessageDraft(
    id: 'buyer-paid',
    sender: P2PChatSender.me,
    text: 'Đã chuyển khoản xong, vui lòng xác nhận nhé!',
    time: '11:07',
  ),
];

const List<String> _p2pChatQuickReplies = [
  'Tôi đã chuyển khoản xong',
  'Bạn đã nhận tiền chưa?',
  'Cảm ơn bạn!',
  'Tôi cần hỗ trợ',
];

const List<P2PMyOrdersTabDraft> _p2pMyOrdersTabs = [
  P2PMyOrdersTabDraft(id: 'processing', label: 'Đang xử lý'),
  P2PMyOrdersTabDraft(id: 'completed', label: 'Hoàn tất'),
  P2PMyOrdersTabDraft(id: 'disputed', label: 'Tranh chấp'),
];

const List<P2PMyOrderDraft> _p2pMyOrders = [
  P2PMyOrderDraft(
    id: 'p2p001',
    orderNumber: 'VT-P2P-20240223-001',
    type: 'buy',
    asset: 'USDT',
    amount: 200,
    price: 25350,
    total: 5070000,
    currency: 'VND',
    status: 'pending_payment',
    merchant: 'CryptoKing_VN',
    merchantId: 'mc001',
    createdAt: '2024-02-23 11:00:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p002',
    orderNumber: 'VT-P2P-20240223-002',
    type: 'sell',
    asset: 'USDT',
    amount: 500,
    price: 25280,
    total: 12640000,
    currency: 'VND',
    status: 'paid',
    merchant: 'VIPTrader_HN',
    merchantId: 'mc004',
    createdAt: '2024-02-23 09:15:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p003',
    orderNumber: 'VT-P2P-20240222-003',
    type: 'buy',
    asset: 'USDT',
    amount: 1000,
    price: 25300,
    total: 25300000,
    currency: 'VND',
    status: 'released',
    merchant: 'TradeMaster99',
    merchantId: 'mc002',
    createdAt: '2024-02-22 14:30:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p004',
    orderNumber: 'VT-P2P-20240221-004',
    type: 'buy',
    asset: 'USDT',
    amount: 150,
    price: 25400,
    total: 3810000,
    currency: 'VND',
    status: 'released',
    merchant: 'CoinHunter_HCM',
    merchantId: 'mc003',
    createdAt: '2024-02-21 16:45:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p005',
    orderNumber: 'VT-P2P-20240220-005',
    type: 'sell',
    asset: 'USDT',
    amount: 300,
    price: 25260,
    total: 7578000,
    currency: 'VND',
    status: 'cancelled',
    merchant: 'FastTrade_SG',
    merchantId: 'mc005',
    createdAt: '2024-02-20 10:20:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p006',
    orderNumber: 'VT-P2P-20240219-006',
    type: 'buy',
    asset: 'USDT',
    amount: 800,
    price: 25350,
    total: 20280000,
    currency: 'VND',
    status: 'disputed',
    merchant: 'NewTrader01',
    merchantId: 'mc007',
    createdAt: '2024-02-19 08:10:00',
  ),
  P2PMyOrderDraft(
    id: 'p2p007',
    orderNumber: 'VT-P2P-20240218-007',
    type: 'buy',
    asset: 'BTC',
    amount: .05,
    price: 1715000000,
    total: 85750000,
    currency: 'VND',
    status: 'released',
    merchant: 'BTCWhale_VN',
    merchantId: 'mc006',
    createdAt: '2024-02-18 12:00:00',
  ),
];

String _formatVndDots(double value) {
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  return buffer.toString();
}
