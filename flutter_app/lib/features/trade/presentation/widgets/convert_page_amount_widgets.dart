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
    final height = input ? 188.0 : 108.0;
    final balanceLabel =
        'Số dư: ${formatConvertBalance(asset.balance, asset.symbol)} ${asset.symbol}';
    return VitCard(
      height: height,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
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
              const Spacer(),
              Text(
                balanceLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _AssetButton(
                key: input ? ConvertPage.fromAssetKey : ConvertPage.toAssetKey,
                asset: asset,
                onTap: onAssetTap,
              ),
              const SizedBox(width: 10),
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
            const SizedBox(height: 16),
            Row(
              children: [
                for (final pct in const [25, 50, 75, 100]) ...[
                  _PercentChip(
                    key: ConvertPage.pctKey(pct),
                    label: '$pct%',
                    onTap: () => onPercent?.call(pct),
                  ),
                  if (pct != 100) const SizedBox(width: 8),
                ],
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Min: \$10',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: 16),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
        decoration: BoxDecoration(
          color: _chipBackground,
          border: Border.all(color: _tradePrimary.withValues(alpha: .22)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              child: Text(
                asset.symbol.substring(0, math.min(3, asset.symbol.length)),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              asset.symbol,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text2,
              size: 16,
            ),
          ],
        ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        width: 50,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _chipBackground,
          border: Border.all(color: _tradePrimary.withValues(alpha: .16)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
