import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class PredictionPortfolioSummaryCard extends StatelessWidget {
  const PredictionPortfolioSummaryCard({
    required this.snapshot,
    required this.openOrderCount,
    required this.isHidden,
    required this.onToggleHidden,
    super.key,
  });

  final PredictionPortfolioSnapshot snapshot;
  final int openOrderCount;
  final bool isHidden;
  final VoidCallback onToggleHidden;

  @override
  Widget build(BuildContext context) {
    final pnlColor = snapshot.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface2],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.accent20),
        ),
        shadows: [
          BoxShadow(
            color: predictionPortfolioPrimary.withValues(alpha: .12),
            blurRadius: 18,
            spreadRadius: -8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: AppSpacing.predictionPortfolioSummaryPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Portfolio Value',
                  style: AppTextStyles.badge.copyWith(
                    color: AppColors.portfolioTextDim,
                  ),
                ),
                const Spacer(),
                VitCard(
                  key: predictionPortfolioVisibilityToggleKey,
                  onTap: onToggleHidden,
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.sm,
                  width: AppSpacing.predictionPortfolioVisibilityButton,
                  height: AppSpacing.predictionPortfolioVisibilityButton,
                  padding: AppSpacing.zeroInsets,
                  child: Icon(
                    isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.portfolioTextDim,
                    size: AppSpacing.predictionPortfolioVisibilityIcon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.predictionPortfolioValueGap),
            Text(
              isHidden
                  ? '\u2022\u2022\u2022\u2022\u2022\u2022'
                  : formatPredictionPortfolioMoney(snapshot.totalCurrentValue),
              style: AppTextStyles.amountMd.copyWith(color: AppColors.onAccent),
            ),
            if (!isHidden) ...[
              const SizedBox(height: AppSpacing.predictionPortfolioPnlGap),
              Row(
                children: [
                  Flexible(
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: pnlColor.withValues(alpha: .16),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.mdRadius,
                          side: BorderSide(
                            color: pnlColor.withValues(alpha: .22),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: AppSpacing.predictionPortfolioPnlPillPadding,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              snapshot.totalPnl >= 0
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              color: pnlColor,
                              size: AppSpacing.predictionPortfolioPnlIcon,
                            ),
                            const SizedBox(
                              width: AppSpacing.predictionPortfolioPnlIconGap,
                            ),
                            Flexible(
                              child: Text(
                                '${formatPredictionPortfolioSignedMoney(snapshot.totalPnl)} '
                                '(${snapshot.totalPnlPct.toStringAsFixed(1)}%)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.badge.copyWith(
                                  color: pnlColor,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.predictionPortfolioPnlIconGap,
                  ),
                  Text(
                    'all time',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(
              height: AppSpacing.predictionPortfolioSummaryStatsGap,
            ),
            Row(
              children: [
                Expanded(
                  child: PredictionPortfolioSummaryStat(
                    label: 'Positions',
                    value: isHidden
                        ? '\u2022\u2022'
                        : '${snapshot.activeCount}',
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.predictionPortfolioSummaryStatGap,
                ),
                Expanded(
                  child: PredictionPortfolioSummaryStat(
                    label: 'P/L',
                    value: isHidden
                        ? '\u2022\u2022'
                        : formatPredictionPortfolioSignedMoney(
                            snapshot.totalPnl,
                            decimals: 0,
                          ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.predictionPortfolioSummaryStatGap,
                ),
                Expanded(
                  child: PredictionPortfolioSummaryStat(
                    label: 'Open Orders',
                    value: isHidden ? '\u2022\u2022' : '$openOrderCount',
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

class PredictionPortfolioSummaryStat extends StatelessWidget {
  const PredictionPortfolioSummaryStat({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.predictionPortfolioSummaryStatHeight,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.onAccent.withValues(alpha: .10),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
          ),
        ),
        child: Padding(
          padding: AppSpacing.predictionPortfolioSummaryStatPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.numericMicro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.onAccent,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionPortfolioSharesNote extends StatelessWidget {
  const PredictionPortfolioSharesNote({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: predictionPortfolioPrimary.withValues(alpha: .07),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(
            color: predictionPortfolioPrimary.withValues(alpha: .18),
          ),
        ),
      ),
      child: Padding(
        padding: AppSpacing.predictionPortfolioSharesNotePadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: predictionPortfolioPrimary,
              size: AppSpacing.predictionPortfolioSharesNoteIcon,
            ),
            const SizedBox(width: AppSpacing.predictionPortfolioSharesNoteGap),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Shares'),
                    TextSpan(
                      text:
                          ' represent your stake in a market outcome. Each share pays ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                    const TextSpan(text: '\$1.00'),
                    TextSpan(
                      text: ' if correct, ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                    const TextSpan(text: '\$0.00'),
                    TextSpan(
                      text: ' if wrong. ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                    const TextSpan(text: 'P/L'),
                    TextSpan(
                      text: ' = current value minus amount invested.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                  ],
                ),
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
