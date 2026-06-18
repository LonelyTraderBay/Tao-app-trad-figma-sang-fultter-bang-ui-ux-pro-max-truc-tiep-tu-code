part of '../pages/margin_trading_page.dart';

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.label,
    required this.suffix,
    required this.value,
  });

  final String label;
  final String suffix;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 90,
      padding: AppSpacing.cardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: AppSpacing.transferSectionGap,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                suffix,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return _InputCard(label: 'Gia dat lenh', suffix: 'USDT', value: price);
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.amount, required this.onMaxAmount});

  final String amount;
  final VoidCallback onMaxAmount;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 97,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.walletAssetSectionGap,
        top: AppSpacing.walletAssetSectionGap,
        right: AppSpacing.walletAssetSectionGap,
        bottom: AppSpacing.walletDepositCopyIcon,
      ),
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: AppSpacing.transferSectionGap,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'So luong (BTC)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              VitStatusPill(
                key: MarginTradingPage.maxAmountKey,
                label: 'Toi da',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
                onTap: onMaxAmount,
              ),
            ],
          ),
          Text(
            amount,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
