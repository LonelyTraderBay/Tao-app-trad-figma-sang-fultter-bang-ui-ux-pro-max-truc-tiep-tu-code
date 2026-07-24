part of '../repositories/mock_p2p_repository.dart';

const List<P2PPaymentListMethodDraft> _p2pPaymentMethodList = [
  P2PPaymentListMethodDraft(
    id: 'vietcombank-primary',
    type: P2PPaymentListMethodType.bank,
    name: 'Vietcombank',
    accountNumber: '0071000123456',
    accountName: 'NGUYEN VAN A',
    isVerified: true,
    isDefault: true,
  ),
  P2PPaymentListMethodDraft(
    id: 'techcombank-backup',
    type: P2PPaymentListMethodType.bank,
    name: 'Techcombank',
    accountNumber: '19033456789012',
    accountName: 'NGUYEN VAN A',
    isVerified: true,
  ),
  P2PPaymentListMethodDraft(
    id: 'momo-wallet',
    type: P2PPaymentListMethodType.ewallet,
    name: 'Momo',
    accountNumber: '0901234567',
    accountName: 'NGUYEN VAN A',
    isVerified: true,
  ),
  P2PPaymentListMethodDraft(
    id: 'zalopay-wallet',
    type: P2PPaymentListMethodType.ewallet,
    name: 'ZaloPay',
    accountNumber: '0901234567',
    accountName: 'NGUYEN VAN A',
    isVerified: false,
  ),
];

const List<String> _p2pPaymentBankOptions = [
  'Vietcombank',
  'Techcombank',
  'VietinBank',
  'BIDV',
  'MB Bank',
  'ACB',
  'Sacombank',
  'TPBank',
];

const List<String> _p2pPaymentEwalletOptions = [
  'Momo',
  'ZaloPay',
  'VNPay',
  'ShopeePay',
];

const List<P2PPaymentVerificationMethodDraft> _p2pPaymentVerificationMethods = [
  P2PPaymentVerificationMethodDraft(
    id: 'micro_deposit',
    label: 'Micro-deposit',
    description: 'Chúng tôi gửi 1-2 VND, bạn xác nhận số tiền',
    duration: '1-2 ngày làm việc',
    iconKey: 'card',
    recommended: true,
  ),
  P2PPaymentVerificationMethodDraft(
    id: 'photo',
    label: 'Upload ảnh',
    description: 'Chụp ảnh thẻ ATM/CCCD cùng tên',
    duration: '10 phút',
    iconKey: 'camera',
  ),
  P2PPaymentVerificationMethodDraft(
    id: 'statement',
    label: 'Bank statement',
    description: 'Tải lên sao kê có tên tài khoản',
    duration: '30 phút',
    iconKey: 'upload',
  ),
];

const List<P2POwnershipDocumentDraft> _p2pOwnershipDocuments = [
  P2POwnershipDocumentDraft(id: 'bank_card', label: 'Ảnh thẻ ATM'),
  P2POwnershipDocumentDraft(id: 'selfie_card', label: 'Selfie với thẻ'),
  P2POwnershipDocumentDraft(
    id: 'statement',
    label: 'Bank statement (optional)',
    optional: true,
  ),
];

const List<P2PPaymentHistoryTransactionDraft> _p2pPaymentHistoryTransactions = [
  P2PPaymentHistoryTransactionDraft(
    id: '1',
    orderId: '#45892',
    type: P2PTradeType.buy,
    amount: 36000000,
    status: 'completed',
    timestamp: '2026-03-05 14:20',
  ),
  P2PPaymentHistoryTransactionDraft(
    id: '2',
    orderId: '#45880',
    type: P2PTradeType.buy,
    amount: 24000000,
    status: 'completed',
    timestamp: '2026-03-05 13:45',
  ),
  P2PPaymentHistoryTransactionDraft(
    id: '3',
    orderId: '#45870',
    type: P2PTradeType.sell,
    amount: 16800000,
    status: 'completed',
    timestamp: '2026-03-04 10:30',
  ),
  P2PPaymentHistoryTransactionDraft(
    id: '4',
    orderId: '#45860',
    type: P2PTradeType.buy,
    amount: 25000000,
    status: 'cancelled',
    timestamp: '2026-03-03 16:20',
  ),
];
