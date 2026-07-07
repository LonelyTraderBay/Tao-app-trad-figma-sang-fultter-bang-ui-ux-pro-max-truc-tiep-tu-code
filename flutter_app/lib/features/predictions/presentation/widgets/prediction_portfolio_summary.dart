import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const predictionPortfolioSharesNoteMessage =
    'Shares represent your stake in a market outcome. Each share pays \$1.00 '
    'if correct, \$0.00 if wrong. P/L = current value minus amount invested.';

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
    final pnlTone = snapshot.totalPnl >= 0
        ? VitMetricDeltaTone.positive
        : VitMetricDeltaTone.negative;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Portfolio Value',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            VitInlineIconAction(
              key: predictionPortfolioVisibilityToggleKey,
              tooltip: isHidden ? 'Show balance' : 'Hide balance',
              onPressed: onToggleHidden,
              icon: isHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.portfolioTextDim,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          isHidden
              ? '\u2022\u2022\u2022\u2022\u2022\u2022'
              : formatPredictionPortfolioMoney(snapshot.totalCurrentValue),
          style: AppTextStyles.heroNumber.copyWith(
            color: AppColors.onAccent,
            letterSpacing: 0,
          ),
        ),
        if (!isHidden) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Flexible(
                child: VitMetricDeltaPill(
                  label:
                      '${formatPredictionPortfolioSignedMoney(snapshot.totalPnl)} '
                      '(${snapshot.totalPnlPct.toStringAsFixed(1)}%)',
                  tone: pnlTone,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'all time',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            Expanded(
              child: VitCardStat(
                child: _SummaryStatContent(
                  label: 'Positions',
                  value: isHidden ? '\u2022\u2022' : '${snapshot.activeCount}',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCardStat(
                child: _SummaryStatContent(
                  label: 'P/L',
                  value: isHidden
                      ? '\u2022\u2022'
                      : formatPredictionPortfolioSignedMoney(
                          snapshot.totalPnl,
                          decimals: 0,
                        ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCardStat(
                child: _SummaryStatContent(
                  label: 'Open Orders',
                  value: isHidden ? '\u2022\u2022' : '$openOrderCount',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryStatContent extends StatelessWidget {
  const _SummaryStatContent({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
