part of '../pages/convert_page.dart';

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.label,
    required this.asset,
    required this.onAssetTap,
    this.amountController,
    this.quoteAmount,
    this.input = false,
    this.onChanged,
    this.onPercent,
  });

  final String label;
  final TradeConvertAsset asset;
  final VoidCallback onAssetTap;
  final TextEditingController? amountController;
  final double? quoteAmount;
  final bool input;
  final VoidCallback? onChanged;
  final ValueChanged<int>? onPercent;

  @override
  Widget build(BuildContext context) {
    final height = input ? _convertFromCardHeight : _convertToCardHeight;
    final balanceLabel =
        'Số dư: ${formatConvertBalance(asset.balance, asset.symbol)} ${asset.symbol}';
    return VitCard(
      height: height,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x4 + AppSpacing.x1,
        top: AppSpacing.x4 + AppSpacing.x1,
        right: AppSpacing.x4 + AppSpacing.x1,
        bottom: AppSpacing.x4 + AppSpacing.x1,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(width: _convertSpace),
              Text(
                balanceLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: _convertSpace),
          Row(
            children: [
              _AssetButton(
                key: input ? ConvertPage.fromAssetKey : ConvertPage.toAssetKey,
                asset: asset,
                onTap: onAssetTap,
              ),
              const SizedBox(width: _convertSpace),
              Expanded(
                child: input
                    ? VitInput(
                        fieldKey: ConvertPage.amountFieldKey,
                        controller: amountController!,
                        hintText: '0.00',
                        textAlign: TextAlign.right,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,8}'),
                          ),
                        ],
                        onChanged: (_) => onChanged?.call(),
                        textStyle: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text1,
                          fontFeatures: AppTextStyles.tabularFigures,
                          fontWeight: AppTextStyles.bold,
                        ),
                      )
                    : Text(
                        formatConvertQuoteAmount(
                          quoteAmount ?? 0,
                          asset.symbol,
                        ),
                        textAlign: TextAlign.right,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
              ),
            ],
          ),
          if (input) ...[
            const SizedBox(height: _convertSpace),
            Row(
              children: [
                for (final pct in const [25, 50, 75, 100]) ...[
                  _PercentChip(
                    key: ConvertPage.pctKey(pct),
                    label: '$pct%',
                    onTap: () => onPercent?.call(pct),
                  ),
                  if (pct != 100) const SizedBox(width: _convertSpace),
                ],
              ],
            ),
            const SizedBox(height: _convertSpace),
            Row(
              children: [
                Text(
                  'Min: \$10',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: AppSpacing.x4),
                Text(
                  'Max: \$500,000',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetButton extends StatelessWidget {
  const _AssetButton({super.key, required this.asset, required this.onTap});

  final TradeConvertAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      height: _convertControlHeight,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowGapRegular,
        right: AppSpacing.rowGapRegular,
      ),
      borderColor: _tradePrimary.withValues(alpha: .22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitCard(
            width: 26,
            height: 26,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.lg,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .22),
            child: Text(
              asset.symbol.substring(0, math.min(3, asset.symbol.length)),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: _convertSpace),
          Text(
            asset.symbol,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text2,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _PercentChip extends StatelessWidget {
  const _PercentChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      width: _convertControlHeight,
      height: _convertChipHeight,
      density: VitDensity.compact,
      alignment: Alignment.center,
      borderColor: _tradePrimary.withValues(alpha: .16),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
