part of '../pages/prediction_market_maker_page.dart';

class _EstimatedReturns extends StatelessWidget {
  const _EstimatedReturns({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: AppSpacing.predictionMarketMakerEstimatePadding,
      child: Row(
        children: [
          Expanded(
            child: _OverviewMetric(
              label: 'Daily Fees',
              value: _formatMoney(amount * .0012),
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
          Expanded(
            child: _OverviewMetric(
              label: 'Est. APR',
              value: '~22.5%',
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddLiquidityButton extends StatelessWidget {
  const _AddLiquidityButton({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.inputHeight,
      width: double.infinity,
      child: Material(
        color: _predictionPrimary.withValues(alpha: enabled ? 1 : .66),
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          key: PredictionMarketMakerPage.addLiquidityKey,
          onTap: enabled ? () {} : null,
          borderRadius: AppRadii.inputRadius,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: AppColors.onAccent.withValues(alpha: enabled ? 1 : .5),
                size: AppSpacing.predictionMarketMakerAddIcon,
              ),
              const SizedBox(width: AppSpacing.predictionMarketMakerAddIconGap),
              Text(
                'Them thanh khoan',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent.withValues(
                    alpha: enabled ? 1 : .55,
                  ),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiquidityWarning extends StatelessWidget {
  const _LiquidityWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: AppSpacing.predictionMarketMakerWarningPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.predictionMarketMakerWarningIcon,
          ),
          const SizedBox(width: AppSpacing.predictionMarketMakerWarningGap),
          Expanded(
            child: Text(
              'Cung cap thanh khoan co rui ro impermanent loss. APR khong co dinh va phu thuoc vao volume giao dich. Khong dam bao loi nhuan.',
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.text2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
