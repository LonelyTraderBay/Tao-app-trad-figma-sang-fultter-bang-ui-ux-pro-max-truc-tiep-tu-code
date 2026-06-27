part of '../pages/dust_converter_page.dart';

class _DustAssetRow extends StatelessWidget {
  const _DustAssetRow({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final WalletDustAsset asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return Semantics(
      button: true,
      selected: selected,
      label:
          '${selected ? 'Selected' : 'Not selected'} dust asset ${asset.symbol}, ${asset.availableLabel}, approximately ${_formatUsd(asset.usdValue, preciseSmall: true)}',
      child: VitCard(
        key: DustConverterPage.assetKey(asset.id),
        onTap: onTap,
        density: VitDensity.compact,
        variant: VitCardVariant.ghost,
        borderColor: selected
            ? color.withValues(alpha: .45)
            : AppColors.transparent,
        background: ColoredBox(
          color: selected ? color.withValues(alpha: .07) : _dustPanel2,
        ),
        clip: true,
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selected ? AppColors.primary : _dustMuted,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: _dustTinyGap),
            _TokenLogo(
              symbol: asset.symbol,
              color: color,
              size: _dustTokenLogo,
            ),
            const SizedBox(width: _dustInlineGap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: _dustTinyGap),
                  Text(
                    asset.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: _dustMuted),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  asset.availableLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: _dustTinyGap),
                Text(
                  '\u2248 ${_formatUsd(asset.usdValue, preciseSmall: true)}',
                  style: AppTextStyles.micro.copyWith(
                    color: _dustMuted,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TokenLogo extends StatelessWidget {
  const _TokenLogo({
    required this.symbol,
    required this.color,
    required this.size,
  });

  final String symbol;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: size,
      height: size,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: .42),
      background: ColoredBox(color: color.withValues(alpha: .18)),
      clip: true,
      alignment: Alignment.center,
      child: Text(
        symbol.length > 3 ? symbol.substring(0, 3) : symbol,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
