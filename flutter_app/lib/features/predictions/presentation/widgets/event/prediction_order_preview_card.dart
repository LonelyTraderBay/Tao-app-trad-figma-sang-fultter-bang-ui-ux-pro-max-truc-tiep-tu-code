import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

class PredictionOrderPreviewCard extends StatelessWidget {
  const PredictionOrderPreviewCard({super.key, required this.preview});

  final PredictionOrderPreview preview;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Outcome', preview.outcome),
      ('Probability', '${preview.probabilityPct}%'),
      ('Estimated shares', preview.shares.toStringAsFixed(2)),
      ('Fee preview', _formatMoney(preview.fee)),
      ('Max loss', _formatMoney(preview.maxLoss)),
    ];
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primary.withValues(alpha: .22)),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: PredictionsSpacingTokens.predictionOrderPreviewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.primary,
                  size: PredictionsSpacingTokens.predictionOrderPreviewIcon,
                ),
                const SizedBox(
                  width: PredictionsSpacingTokens.predictionOrderPreviewIconGap,
                ),
                Expanded(
                  child: Text(
                    'Order Preview',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: PredictionsSpacingTokens.predictionOrderPreviewIconGap,
                ),
                _PreviewBadge(label: preview.orderTypeLabel),
              ],
            ),
            const SizedBox(
              height: PredictionsSpacingTokens.predictionOrderPreviewHeaderGap,
            ),
            for (final row in rows) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Text(
                    preview.canSubmit || row.$1 == 'Outcome'
                        ? row.$2
                        : 'Enter amount',
                    style: AppTextStyles.numericMicro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
              if (row != rows.last)
                const SizedBox(
                  height: PredictionsSpacingTokens.predictionOrderPreviewRowGap,
                ),
            ],
            const SizedBox(
              height: PredictionsSpacingTokens.predictionOrderPreviewFooterGap,
            ),
            Text(
              'Prediction positions, probability, receipt, rewards, and P/L stay separate from Arena Points.',
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.primary.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: PredictionsSpacingTokens.predictionOrderPreviewBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.badge.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';
