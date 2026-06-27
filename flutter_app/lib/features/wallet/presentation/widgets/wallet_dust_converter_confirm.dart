part of '../pages/dust_converter_page.dart';

class _ConvertFooter extends StatelessWidget {
  const _ConvertFooter({
    required this.bottomSpace,
    required this.selectedCount,
    required this.targetSymbol,
    required this.enabled,
    required this.onTap,
    this.horizontalPadding = AppSpacing.contentPad,
  });

  final double bottomSpace;
  final int selectedCount;
  final String targetSymbol;
  final bool enabled;
  final VoidCallback onTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final basePadding = horizontalPadding == 0
        ? AppSpacing.zeroInsets
        : AppSpacing.contentInsets;
    return Padding(
      padding: basePadding.copyWith(
        top: _dustFooterTopPad,
        bottom: bottomSpace + _dustGap,
      ),
      child: _PrimaryButton(
        key: DustConverterPage.ctaKey,
        enabled: enabled,
        label: enabled
            ? 'Chuy\u1EC3n \u0111\u1ED5i $selectedCount t\u00E0i s\u1EA3n \u2192 $targetSymbol'
            : 'Ch\u1ECDn t\u00E0i s\u1EA3n \u0111\u1EC3 chuy\u1EC3n \u0111\u1ED5i',
        onTap: onTap,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.variant = VitCtaButtonVariant.primary,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final VitCtaButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: enabled ? onTap : null,
      variant: variant,
      height: AppSpacing.inputHeight,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.last = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return VitInfoRow(
      label: label,
      value: value,
      valueColor: valueColor,
      density: VitDensity.compact,
      showDivider: !last,
    );
  }
}

class _ConvertedBanner extends StatelessWidget {
  const _ConvertedBanner({required this.targetSymbol});

  final String targetSymbol;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.buy20,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: _dustInlineGap),
          Expanded(
            child: Text(
              '\u0110\u00E3 chuy\u1EC3n \u0111\u1ED5i sang $targetSymbol',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      icon: Icons.auto_awesome_rounded,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: AppColors.primary,
      density: VitDensity.compact,
    );
  }
}

double _sumUsd(List<WalletDustAsset> assets) {
  return assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
}

String _formatAmount(double value) => value.toStringAsFixed(4);

String _formatUsd(double value, {bool preciseSmall = false}) {
  final fixed = value.toStringAsFixed(
    preciseSmall && value < 1 && value > 0 ? 4 : 2,
  );
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    if (i > 0 && (integer.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(integer[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
