part of '../pages/orders_history_page.dart';

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.tradeHistoryBadgePadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final TradeOrderType type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      TradeOrderType.market => '',
      TradeOrderType.limit => 'Limit',
      TradeOrderType.stop => 'Stop',
    };
    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSpacing.tradeHistoryTypeBadgeMinWidth,
      ),
      padding: AppSpacing.tradeHistoryBadgePadding,
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.15,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeHistoryInfoGap),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.activeTab});

  final String activeTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.tradeHistoryEmptyPadding,
      child: Column(
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: AppColors.borderSolid,
            size: AppSpacing.tradeHistoryEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.tradeHistoryEmptyGap),
          Text(
            activeTab == 'open'
                ? 'Không có lệnh đang mở'
                : 'Chưa có lịch sử giao dịch',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

({String label, Color color, IconData icon}) _statusPresentation(
  TradeOrderStatus status,
) {
  return switch (status) {
    TradeOrderStatus.open => (
      label: 'Đang mở',
      color: _tradePrimary,
      icon: Icons.access_time_rounded,
    ),
    TradeOrderStatus.partial => (
      label: 'Khớp 1 phần',
      color: AppColors.warn,
      icon: Icons.trending_up_rounded,
    ),
    TradeOrderStatus.filled => (
      label: 'Đã khớp',
      color: AppColors.buy,
      icon: Icons.check_circle_rounded,
    ),
    TradeOrderStatus.cancelled => (
      label: 'Đã hủy',
      color: AppColors.text3,
      icon: Icons.cancel_rounded,
    ),
  };
}

String _formatMoney(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}
