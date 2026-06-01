part of '../pages/dca_portfolio_optimizer_page.dart';

class _FloatingActions extends StatelessWidget {
  const _FloatingActions({
    required this.onShare,
    required this.onSettings,
    required this.onApply,
  });

  final VoidCallback onShare;
  final VoidCallback onSettings;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FloatingIconButton(icon: Icons.share_outlined, onTap: onShare),
        const SizedBox(width: AppSpacing.x3),
        _FloatingIconButton(
          key: DCAPortfolioOptimizer.driftSettingsKey,
          icon: Icons.notifications_none_rounded,
          iconColor: AppColors.warn,
          onTap: onSettings,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: DCAPortfolioOptimizer.applyKey,
            onPressed: onApply,
            leading: const Icon(Icons.arrow_outward_rounded),
            child: const Text('Áp dụng phân bổ'),
          ),
        ),
      ],
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  const _FloatingIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.navCenterIcon,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      child: VitCtaButton(
        onPressed: onTap,
        fullWidth: false,
        padding: EdgeInsets.zero,
        child: Icon(icon, color: iconColor, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: color.withValues(alpha: .16)),
        ),
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
    );
  }
}
