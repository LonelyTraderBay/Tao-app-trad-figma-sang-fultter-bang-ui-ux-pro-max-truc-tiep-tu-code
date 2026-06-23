part of 'staking_custody_common.dart';

class StakingCustodyActionButton extends StatelessWidget {
  const StakingCustodyActionButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class StakingCustodyLargeIconBox extends StatelessWidget {
  const StakingCustodyLargeIconBox({
    super.key,
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color.withValues(alpha: 0.32),
            width: AppSpacing.stakingCustodyActionBorderWidth,
          ),
          borderRadius: AppRadii.xlRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.stakingCustodyActionIconBox,
        height: AppSpacing.stakingCustodyActionIconBox,
        child: Icon(
          icon,
          color: color,
          size: AppSpacing.stakingCustodyActionIcon,
        ),
      ),
    );
  }
}

class StakingCustodySmallPill extends StatelessWidget {
  const StakingCustodySmallPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
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
    );
  }
}

class StakingCustodyFooterNote extends StatelessWidget {
  const StakingCustodyFooterNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCustodyKeys.footer,
      variant: VitCardVariant.inner,
      padding: AppSpacing.earnCardPaddingX4,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: AppSpacing.stakingCustodyFooterLineHeight,
        ),
      ),
    );
  }
}
