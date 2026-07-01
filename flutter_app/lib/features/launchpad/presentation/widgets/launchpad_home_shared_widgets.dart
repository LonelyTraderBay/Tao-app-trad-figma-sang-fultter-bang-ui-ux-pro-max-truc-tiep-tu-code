part of '../pages/launchpad_page.dart';

class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text2,
    this.background = AppColors.surface2,
    this.border = AppColors.cardBorder,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      height: _launchpadActionHeight,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: border,
      background: ColoredBox(color: background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x2),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadInlinePillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _launchpadLineHeightCompact,
          ),
        ),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .10),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadInlinePillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            height: _launchpadLineHeightBody,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.medium,
                height: _launchpadLineHeightCompact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineIconLabel extends StatelessWidget {
  const _InlineIconLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoiBadge extends StatelessWidget {
  const _RoiBadge({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.buy10,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
          side: const BorderSide(color: AppColors.buy20),
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPillPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+$value%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.extraBold,
                fontFeatures: AppTextStyles.tabularFigures,
                height: _launchpadLineHeightTight,
              ),
            ),
            Text(
              'ROI',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _launchpadLineHeightCompact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
