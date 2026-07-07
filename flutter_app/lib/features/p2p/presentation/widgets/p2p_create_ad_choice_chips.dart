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
    return VitChoicePill(
      label: label,
      selected: selected,
      padding: AppSpacing.p2pMerchantCommerceChipPadding,
      onTap: onTap,
      showSelectedIcon: true,
    );
  }
}
