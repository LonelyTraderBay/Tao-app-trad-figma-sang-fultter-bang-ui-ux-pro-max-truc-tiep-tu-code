part of '../pages/risk_indicator_explainer_page.dart';

class _ProductSriCard extends StatelessWidget {
  const _ProductSriCard({required this.snapshot});

  final TradeRiskIndicatorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.productName,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightCaption,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          Text(
            'Summary Risk Indicator',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotStatusGap),
          Row(
            children: [
              for (final level in snapshot.levels) ...[
                Expanded(
                  child: _ScaleTile(
                    level: level.level,
                    color: level.level <= snapshot.productSri
                        ? _colorForTier(level.tier)
                        : _riskPanel2,
                    active: level.level <= snapshot.productSri,
                  ),
                ),
                if (level != snapshot.levels.last)
                  const SizedBox(width: AppSpacing.x1),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lower Risk',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
              Text(
                'Higher Risk',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotContentGap),
          const _SriWarning(),
        ],
      ),
    );
  }
}

class _ScaleTile extends StatelessWidget {
  const _ScaleTile({
    required this.level,
    required this.color,
    required this.active,
  });

  final int level;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      height: AppSpacing.tradeBotClientCategoryIcon,
      alignment: Alignment.center,
      clip: true,
      borderColor: color.withValues(alpha: active ? .18 : .08),
      background: ColoredBox(color: color),
      child: Text(
        '$level',
        style: AppTextStyles.baseMedium.copyWith(
          color: active ? AppColors.onAccent : AppColors.text3,
          fontWeight: AppTextStyles.bold,
          height: AppSpacing.tradeBotLineHeightTight,
        ),
      ),
    );
  }
}

class _SriWarning extends StatelessWidget {
  const _SriWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotOptionMinHeight,
      ),
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: _riskAmber.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: AppSpacing.tradeBotIntroIconTopPadding,
            child: Icon(
              Icons.warning_amber_rounded,
              color: _riskAmber,
              size: AppSpacing.tradeBotSmallIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'SRI 6 - High Risk: ',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'This product has high volatility. You could lose a '
                        'significant portion of your investment.',
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: _riskAmber,
                fontWeight: AppTextStyles.medium,
                height: AppSpacing.tradeBotLineHeightCompact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
