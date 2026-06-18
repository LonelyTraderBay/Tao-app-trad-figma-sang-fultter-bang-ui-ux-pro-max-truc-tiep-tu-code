part of '../pages/p2p_create_ad_page.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.p2pMerchantCommerceSectionLabelPadding,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _TradeTypePicker extends StatelessWidget {
  const _TradeTypePicker({required this.value, required this.onChanged});

  final P2PTradeType value;
  final ValueChanged<P2PTradeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: AppSpacing.p2pMerchantCommerceSegmentPadding,
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              key: P2PCreateAdPage.adTypeKey(P2PTradeType.buy),
              label: 'Tôi muốn MUA',
              selected: value == P2PTradeType.buy,
              color: AppColors.buy,
              onTap: () => onChanged(P2PTradeType.buy),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              key: P2PCreateAdPage.adTypeKey(P2PTradeType.sell),
              label: 'Tôi muốn BÁN',
              selected: value == P2PTradeType.sell,
              color: AppColors.sell,
              onTap: () => onChanged(P2PTradeType.sell),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceTypePicker extends StatelessWidget {
  const _PriceTypePicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: AppSpacing.p2pMerchantCommerceSegmentPadding,
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              key: P2PCreateAdPage.priceTypeKey('fixed'),
              label: 'Cố định',
              selected: value == 'fixed',
              color: AppColors.primary,
              onTap: () => onChanged('fixed'),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              key: P2PCreateAdPage.priceTypeKey('floating'),
              label: 'Thả nổi %',
              selected: value == 'floating',
              color: AppColors.accent,
              onTap: () => onChanged('floating'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.p2pMerchantCommerceSegmentHeight,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      background: ColoredBox(color: selected ? color : AppColors.transparent),
      onTap: onTap,
      clip: true,
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.label,
    required this.values,
    required this.selected,
    required this.keyBuilder,
    required this.onSelected,
  });

  final String label;
  final List<String> values;
  final String selected;
  final Key Function(String value) keyBuilder;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final value in values)
              _ChoiceChipButton(
                key: keyBuilder(value),
                label: value,
                selected: selected == value,
                onTap: () => onSelected(value),
              ),
          ],
        ),
      ],
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
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      borderColor: selected ? AppColors.primary30 : AppColors.cardBorder,
      background: ColoredBox(
        color: selected ? AppColors.primary12 : AppColors.surface2,
      ),
      padding: AppSpacing.p2pMerchantCommerceWideChipPadding,
      onTap: onTap,
      clip: true,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: selected ? AppColors.primarySoft : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _InputBlock extends StatelessWidget {
  const _InputBlock({required this.label, required this.child, this.hint});

  final String label;
  final Widget child;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label),
        child,
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            hint!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}
