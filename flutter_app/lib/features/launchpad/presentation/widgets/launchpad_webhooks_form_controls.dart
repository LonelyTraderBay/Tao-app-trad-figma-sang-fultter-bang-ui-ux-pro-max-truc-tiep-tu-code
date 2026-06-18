part of '../pages/launchpad_webhooks_page.dart';

class _SheetInputField extends StatelessWidget {
  const _SheetInputField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.monospace = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        VitInput(
          controller: controller,
          onChanged: onChanged,
          semanticLabel: label,
          hintText: hint,
          textStyle:
              (monospace ? AppTextStyles.monoCode : AppTextStyles.caption)
                  .copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.label,
    required this.items,
    required this.active,
    required this.colorFor,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String active;
  final Color Function(String value) colorFor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in items) ...[
                _SelectablePill(
                  label: item,
                  color: colorFor(item),
                  active: active == item,
                  onTap: () => onChanged(item),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: active ? color.withValues(alpha: .14) : AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
              side: BorderSide(
                color: active
                    ? color.withValues(alpha: .34)
                    : AppColors.cardBorder,
              ),
            ),
          ),
          child: Padding(
            padding: AppSpacing.launchpadPillPadding,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: active ? color : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color.withValues(alpha: .11),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
            ),
          ),
          child: Padding(
            padding: AppSpacing.launchpadActionButtonPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: AppSpacing.launchpadIconMd),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
