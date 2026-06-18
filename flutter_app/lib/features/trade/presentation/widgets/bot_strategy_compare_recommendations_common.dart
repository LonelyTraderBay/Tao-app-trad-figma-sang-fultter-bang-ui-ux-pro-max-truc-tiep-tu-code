part of '../pages/bot_strategy_compare_page.dart';

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.strategy,
  });

  final TradeBotRecommendation recommendation;
  final TradeBotCompareStrategy strategy;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return _Card(
      padding: AppSpacing.tradeBotCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: AppSpacing.tradeBotRecommendationIconBox,
            height: AppSpacing.tradeBotRecommendationIconBox,
            variant: VitCardVariant.inner,
            borderColor: color.withValues(alpha: .24),
            alignment: Alignment.center,
            child: Icon(
              Icons.trending_up_rounded,
              color: color,
              size: AppSpacing.tradeBotCardIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotStatusGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.title,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotLabelGap),
                Text(
                  recommendation.strategy,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  recommendation.reason,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.tradeBotLineHeightLoose,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisPeriodCard extends StatelessWidget {
  const _AnalysisPeriodCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Period',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotRowGap),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightLong,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(padding: padding, child: child);
  }
}
