part of '../pages/launchpad_limit_orders_page.dart';

class _SideChoice extends StatelessWidget {
  const _SideChoice({
    required this.side,
    required this.active,
    required this.onTap,
  });

  final LaunchpadLimitOrderSide side;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isBuy = side == LaunchpadLimitOrderSide.buy;
    final color = isBuy ? AppColors.buy : AppColors.sell;
    return InkWell(
      key: LaunchpadLimitOrdersPage.sideKey(side),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .10) : AppColors.surface,
          border: Border.all(color: active ? color : AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          children: [
            Icon(
              isBuy ? Icons.south_rounded : Icons.north_rounded,
              color: active ? color : AppColors.text3,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              isBuy ? 'Buy' : 'Sell',
              style: AppTextStyles.base.copyWith(
                color: active ? color : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              isBuy ? 'Mua khi gia xuong' : 'Ban khi gia len',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.text
              ? const []
              : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (_) => onChanged(),
          style: AppTextStyles.base.copyWith(color: AppColors.text1),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
            isDense: true,
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpiryButton extends StatelessWidget {
  const _ExpiryButton({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final String value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LaunchpadLimitOrdersPage.expiryKey(value),
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.bg,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          '${value}d',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
