part of '../pages/dca_portfolio_optimizer_page.dart';

class _OptimizerApplyAction extends StatelessWidget {
  const _OptimizerApplyAction({required this.onApply});

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: DCAPortfolioOptimizer.applyKey,
      onPressed: onApply,
      leading: const Icon(Icons.arrow_outward_rounded),
      child: const Text('Áp dụng phân bổ'),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
