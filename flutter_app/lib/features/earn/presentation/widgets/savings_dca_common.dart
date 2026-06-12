part of '../pages/savings_dca_page.dart';

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .35)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: _microBold.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.savingsConsumerPillLineHeight,
          ),
        ),
      ),
    );
  }
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' || 'USD' => AppColors.buy,
    'ETH' => AppColors.accent,
    'SOL' => AppColors.warn,
    _ => AppColors.primary,
  };
}

Color _executionColor(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => AppColors.buy,
    SavingsDcaExecutionStatus.failed => AppColors.sell,
    SavingsDcaExecutionStatus.pending => AppColors.warn,
  };
}

IconData _executionIcon(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => Icons.check_circle_outline_rounded,
    SavingsDcaExecutionStatus.failed => Icons.error_outline_rounded,
    SavingsDcaExecutionStatus.pending => Icons.schedule_rounded,
  };
}

String _executionLabel(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => 'Thành công',
    SavingsDcaExecutionStatus.failed => 'Thất bại',
    SavingsDcaExecutionStatus.pending => 'Đang xử lý',
  };
}
