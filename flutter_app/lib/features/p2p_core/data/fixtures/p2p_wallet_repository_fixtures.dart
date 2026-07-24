part of '../repositories/mock_p2p_repository.dart';

const List<P2PWalletTransferAssetDraft> _p2pWalletTransferAssets = [
  P2PWalletTransferAssetDraft(symbol: 'USDT', name: 'Tether'),
  P2PWalletTransferAssetDraft(symbol: 'BTC', name: 'Bitcoin'),
  P2PWalletTransferAssetDraft(symbol: 'VND', name: 'Vietnamese Dong'),
];

const List<P2PWalletTransferBalanceDraft> _p2pWalletTransferBalances = [
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'USDT',
    available: 45200,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'USDT',
    available: 12450.50,
    balanceLabel: 'Số dư',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'BTC',
    available: .1234,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'BTC',
    available: .0524,
    balanceLabel: 'Số dư',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'main',
    walletLabel: 'Main Wallet',
    asset: 'VND',
    available: 120000000,
    balanceLabel: 'Khả dụng',
  ),
  P2PWalletTransferBalanceDraft(
    walletKey: 'p2p',
    walletLabel: 'P2P Wallet',
    asset: 'VND',
    available: 45600000,
    balanceLabel: 'Số dư',
  ),
];

const List<P2PFundLockRecordDraft> _p2pFundLockRecords = [
  P2PFundLockRecordDraft(
    id: 'fund_lock_45892',
    type: 'lock',
    asset: 'USDT',
    amount: 1500,
    reason: 'Order #45892 created',
    timestamp: '2026-03-05 14:20',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_unlock_45880',
    type: 'unlock',
    asset: 'USDT',
    amount: 1000,
    reason: 'Order #45880 completed',
    timestamp: '2026-03-05 13:45',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_lock_45870',
    type: 'lock',
    asset: 'BTC',
    amount: .01,
    reason: 'Order #45870 created',
    timestamp: '2026-03-05 10:30',
  ),
  P2PFundLockRecordDraft(
    id: 'fund_unlock_45850',
    type: 'unlock',
    asset: 'VND',
    amount: 12000000,
    reason: 'Order #45850 released',
    timestamp: '2026-03-04 16:20',
  ),
];

const List<P2PWalletBalanceDraft> _p2pWalletBalances = [
  P2PWalletBalanceDraft(
    asset: 'USDT',
    available: 12450.50,
    inEscrow: 3200,
    locked: 500,
    total: 16150.50,
    usdValue: 16150.50,
  ),
  P2PWalletBalanceDraft(
    asset: 'BTC',
    available: .0524,
    inEscrow: .01,
    locked: 0,
    total: .0624,
    usdValue: 4243.20,
  ),
  P2PWalletBalanceDraft(
    asset: 'VND',
    available: 45600000,
    inEscrow: 12000000,
    locked: 0,
    total: 57600000,
    usdValue: 2400,
  ),
];

const List<P2PWalletTransactionDraft> _p2pWalletTransactions = [
  P2PWalletTransactionDraft(
    id: 'tx_escrow_release_45892',
    type: 'escrow_release',
    asset: 'USDT',
    amount: 1500,
    status: 'completed',
    time: '10 phút trước',
    orderId: '#P2P-45892',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_transfer_in_5000',
    type: 'transfer_in',
    asset: 'USDT',
    amount: 5000,
    status: 'completed',
    time: '2 giờ trước',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_escrow_lock_45880',
    type: 'escrow_lock',
    asset: 'BTC',
    amount: .01,
    status: 'pending',
    time: '3 giờ trước',
    orderId: '#P2P-45880',
  ),
  P2PWalletTransactionDraft(
    id: 'tx_transfer_out_vnd',
    type: 'transfer_out',
    asset: 'VND',
    amount: 10000000,
    status: 'completed',
    time: '1 ngày trước',
  ),
];
