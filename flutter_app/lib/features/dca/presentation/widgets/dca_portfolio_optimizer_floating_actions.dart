part of '../pages/dca_portfolio_optimizer_page.dart';

class _OptimizerApplyAction extends StatelessWidget {
  const _OptimizerApplyAction({required this.snapshot, required this.onApply});

  final DcaPortfolioOptimizerSnapshot snapshot;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          borderColor: AppColors.warn15,
          padding: AppSpacing.dcaPaddingX2,
          child: Column(
            children: [
              VitInfoRow(
                label: 'Trước khi áp dụng',
                value: 'Chưa đặt lệnh',
                valueColor: AppColors.warn,
                density: VitDensity.compact,
                leading: const Icon(Icons.verified_user_outlined),
              ),
              VitInfoRow(
                label: 'Cần kiểm tra',
                value:
                    'Drift ${snapshot.driftPercent.toStringAsFixed(1)}% · ngưỡng ${snapshot.driftThresholdPercent.toStringAsFixed(0)}%',
                valueColor: AppColors.text1,
                density: VitDensity.compact,
                leading: const Icon(Icons.rule_rounded),
              ),
            ],
          ),
        ),
        const Padding(padding: AppSpacing.dcaTopPaddingX3),
        VitCtaButton(
          key: DCAPortfolioOptimizer.applyKey,
          onPressed: onApply,
          leading: const Icon(Icons.arrow_outward_rounded),
          child: const Text('Xem cấu hình tái cân bằng'),
        ),
      ],
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .10),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.mdRadius,
            side: BorderSide(color: color.withValues(alpha: .16)),
          ),
        ),
        child: Padding(
          padding: AppSpacing.dcaButtonChipPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
