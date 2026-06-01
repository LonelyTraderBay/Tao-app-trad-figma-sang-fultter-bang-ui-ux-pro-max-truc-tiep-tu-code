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
    return GestureDetector(
      key: DustConverterPage.assetKey(asset.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 59,
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .07) : _dustPanel2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected
                ? color.withValues(alpha: .45)
                : AppColors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selected ? _dustPrimary : _dustMuted,
              size: 18,
            ),
            const SizedBox(width: 13),
            _TokenLogo(symbol: asset.symbol, color: color, size: 34),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    asset.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _dustMuted,
                      fontSize: 10,
                      height: 1,
                    ),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\u2248 ${_formatUsd(asset.usdValue, preciseSmall: true)}',
                  style: AppTextStyles.micro.copyWith(
                    color: _dustMuted,
                    fontSize: 10,
                    height: 1,
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: .42)),
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.length > 3 ? symbol.substring(0, 3) : symbol,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
