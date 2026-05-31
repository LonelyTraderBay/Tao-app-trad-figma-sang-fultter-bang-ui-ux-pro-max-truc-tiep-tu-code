import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_common.dart';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface2],
        ),
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.cardRadius,
        boxShadow: [
          BoxShadow(
            color: predictionPortfolioPrimary.withValues(alpha: .12),
            blurRadius: 18,
            spreadRadius: -8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Portfolio Value',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                key: predictionPortfolioVisibilityToggleKey,
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: onToggleHidden,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.portfolioTextDim,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isHidden
                ? '\u2022\u2022\u2022\u2022\u2022\u2022'
                : formatPredictionPortfolioMoney(snapshot.totalCurrentValue),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.onAccent,
              fontSize: 29,
              height: 1.05,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (!isHidden) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: pnlColor.withValues(alpha: .16),
                      border: Border.all(
                        color: pnlColor.withValues(alpha: .22),
                      ),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          snapshot.totalPnl >= 0
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: pnlColor,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${formatPredictionPortfolioSignedMoney(snapshot.totalPnl)} '
                            '(${snapshot.totalPnlPct.toStringAsFixed(1)}%)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: pnlColor,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: PredictionPortfolioSummaryStat(
                  label: 'Positions',
                  value: isHidden ? '\u2022\u2022' : '${snapshot.activeCount}',
                ),
              ),
              const SizedBox(width: 8),
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
              const SizedBox(width: 8),
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
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontSize: 9,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontSize: 13,
              height: 1.2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class PredictionPortfolioSharesNote extends StatelessWidget {
  const PredictionPortfolioSharesNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: predictionPortfolioPrimary.withValues(alpha: .07),
        border: Border.all(
          color: predictionPortfolioPrimary.withValues(alpha: .18),
        ),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: predictionPortfolioPrimary,
            size: 15,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: const [
                  TextSpan(text: 'Shares'),
                  TextSpan(
                    text:
                        ' represent your stake in a market outcome. Each share pays ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: '\$1.00'),
                  TextSpan(
                    text: ' if correct, ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: '\$0.00'),
                  TextSpan(
                    text: ' if wrong. ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'P/L'),
                  TextSpan(
                    text: ' = current value minus amount invested.',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.45,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
