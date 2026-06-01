part of 'p2p_create_ad_sections.dart';

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primarySoft : AppColors.text2,
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

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primarySoft : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
