part of '../pages/dust_converter_page.dart';

class _ConvertFooter extends StatelessWidget {
  const _ConvertFooter({
    required this.bottomSpace,
    required this.selectedCount,
    required this.targetSymbol,
    required this.enabled,
    required this.onTap,
    this.horizontalPadding = 20,
  });

  final double bottomSpace;
  final int selectedCount;
  final String targetSymbol;
  final bool enabled;
  final VoidCallback onTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        bottomSpace + 6,
      ),
      decoration: const BoxDecoration(
        color: AppColors.modalScrimStrong,
        border: Border(top: BorderSide(color: AppColors.border)),
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
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _dustPrimary : AppColors.surface3,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? AppColors.onAccent : AppColors.text3,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ),
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
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 11),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConvertedBanner extends StatelessWidget {
  const _ConvertedBanner({required this.targetSymbol});

  final String targetSymbol;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(13),
      borderColor: _dustGreen.withValues(alpha: .28),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: _dustGreen, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '\u0110\u00E3 chuy\u1EC3n \u0111\u1ED5i sang $targetSymbol',
              style: AppTextStyles.caption.copyWith(
                color: _dustGreen,
                fontSize: 12,
                fontWeight: FontWeight.w800,
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _dustPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
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
