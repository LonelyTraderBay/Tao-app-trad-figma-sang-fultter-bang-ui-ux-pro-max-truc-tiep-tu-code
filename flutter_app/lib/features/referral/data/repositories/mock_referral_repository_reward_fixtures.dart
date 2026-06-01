part of 'mock_referral_repository.dart';

const _rewardRecords = [
  ReferralRewardRecordDraft(
    id: 'cr-01',
    friendName: 'Hoàng Đạt V.',
    friendInitial: 'H',
    type: ReferralRewardType.tradeCommission,
    amount: 22.30,
    currency: 'USDT',
    action: 'Giao dịch Spot BTC/USDT',
    date: '28/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-02',
    friendName: 'Nguyễn Thanh T.',
    friendInitial: 'N',
    type: ReferralRewardType.tradeCommission,
    amount: 12.40,
    currency: 'USDT',
    action: 'Giao dịch Spot ETH/USDT',
    date: '27/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-03',
    friendName: 'Võ Thị L.',
    friendInitial: 'V',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '27/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-04',
    friendName: 'Trần Văn H.',
    friendInitial: 'T',
    type: ReferralRewardType.tradeCommission,
    amount: 8.20,
    currency: 'USDT',
    action: 'Giao dịch P2P',
    date: '26/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-05',
    friendName: 'Lê Minh D.',
    friendInitial: 'L',
    type: ReferralRewardType.tradeCommission,
    amount: 15.60,
    currency: 'USDT',
    action: 'Giao dịch Spot SOL/USDT',
    date: '25/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-06',
    friendName: 'Hoàng Đạt V.',
    friendInitial: 'H',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '24/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-07',
    friendName: 'Nguyễn Thanh T.',
    friendInitial: 'N',
    type: ReferralRewardType.tradeCommission,
    amount: 9.80,
    currency: 'USDT',
    action: 'Giao dịch P2P',
    date: '23/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-08',
    friendName: 'Trần Văn H.',
    friendInitial: 'T',
    type: ReferralRewardType.tradeCommission,
    amount: 7.50,
    currency: 'USDT',
    action: 'Giao dịch Spot',
    date: '22/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-09',
    friendName: 'Lê Minh D.',
    friendInitial: 'L',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '21/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-10',
    friendName: 'Phạm Hải Y.',
    friendInitial: 'P',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Thưởng KYC hoàn tất',
    date: '20/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-11',
    friendName: 'Hoàng Đạt V.',
    friendInitial: 'H',
    type: ReferralRewardType.tradeCommission,
    amount: 18.90,
    currency: 'USDT',
    action: 'Giao dịch Spot BNB/USDT',
    date: '19/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-12',
    friendName: 'Nguyễn Thanh T.',
    friendInitial: 'N',
    type: ReferralRewardType.tradeCommission,
    amount: 14.20,
    currency: 'USDT',
    action: 'Giao dịch Convert',
    date: '18/02/2026',
    status: ReferralRewardStatus.completed,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-13',
    friendName: 'Đỗ Quốc B.',
    friendInitial: 'Đ',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Chờ hoàn tất KYC',
    date: '01/03/2026',
    status: ReferralRewardStatus.pending,
  ),
  ReferralRewardRecordDraft(
    id: 'cr-14',
    friendName: 'Bùi Anh K.',
    friendInitial: 'B',
    type: ReferralRewardType.kycBonus,
    amount: 5,
    currency: 'USDT',
    action: 'Chờ hoàn tất KYC',
    date: '01/03/2026',
    status: ReferralRewardStatus.pending,
  ),
];

const _chartPoints = [
  ReferralChartPointDraft(month: 'T10', commission: 187),
  ReferralChartPointDraft(month: 'T11', commission: 234),
  ReferralChartPointDraft(month: 'T12', commission: 198),
  ReferralChartPointDraft(month: 'T1', commission: 312),
  ReferralChartPointDraft(month: 'T2', commission: 421),
];

const _exportRanges = [
  ReferralExportRangeDraft(id: 'all', label: 'Tất cả'),
  ReferralExportRangeDraft(id: 'this_month', label: 'Tháng này'),
  ReferralExportRangeDraft(id: 'last_month', label: 'Tháng trước'),
  ReferralExportRangeDraft(id: 'last_3_months', label: '3 tháng gần nhất'),
];

const _disputeTypes = [
  ReferralDisputeTypeDraft(
    id: 'missing_commission',
    label: 'Thiếu hoa hồng',
    description: 'Bạn bè giao dịch nhưng không nhận hoa hồng',
  ),
  ReferralDisputeTypeDraft(
    id: 'wrong_amount',
    label: 'Sai số tiền',
    description: 'Số tiền hoa hồng không khớp tỷ lệ',
  ),
  ReferralDisputeTypeDraft(
    id: 'delayed',
    label: 'Chậm trễ',
    description: 'Hoa hồng chưa được cộng sau 24h',
  ),
  ReferralDisputeTypeDraft(
    id: 'other',
    label: 'Vấn đề khác',
    description: 'Vấn đề không thuộc các loại trên',
  ),
];

const _disputes = [
  ReferralDisputeDraft(
    id: 'DISP-001',
    typeId: 'delayed',
    description: 'Hoa hồng P2P ngày 23/02 chưa nhận được sau 48h.',
    statusLabel: 'Đã giải quyết',
    createdDate: '25/02/2026',
    resolvedDate: '26/02/2026',
    resolution: 'Đã cộng bổ sung 9.80 USDT vào ví.',
  ),
];

double get _completedRewardTotal => _rewardRecords
    .where((record) => record.status == ReferralRewardStatus.completed)
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

double get _pendingRewardTotal => _rewardRecords
    .where((record) => record.status == ReferralRewardStatus.pending)
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

double get _kycBonusTotal => _rewardRecords
    .where(
      (record) =>
          record.type == ReferralRewardType.kycBonus &&
          record.status == ReferralRewardStatus.completed,
    )
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

double get _tradeCommissionTotal => _rewardRecords
    .where(
      (record) =>
          record.type == ReferralRewardType.tradeCommission &&
          record.status == ReferralRewardStatus.completed,
    )
    .fold(0.0, (total, record) => total + record.amount)
    ._roundedCurrency;

String _formatUsd(double value) => '\$${value.toStringAsFixed(2)}';

extension on double {
  double get _roundedCurrency => (this * 100).roundToDouble() / 100;
}
