part of '../pages/launchpad_webhooks_page.dart';

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFamily: monospace ? 'monospace' : null,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontFamily: monospace ? 'monospace' : null,
            ),
            filled: true,
            fillColor: AppColors.surface2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x3,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderSolid),
              borderRadius: AppRadii.inputRadius,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: AppRadii.inputRadius,
            ),
          ),
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            fontSize: 11,
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: .14) : AppColors.surface2,
            border: Border.all(
              color: active
                  ? color.withValues(alpha: .34)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? color : AppColors.text3,
              fontWeight: AppTextStyles.bold,
              fontSize: 10,
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
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .11),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
