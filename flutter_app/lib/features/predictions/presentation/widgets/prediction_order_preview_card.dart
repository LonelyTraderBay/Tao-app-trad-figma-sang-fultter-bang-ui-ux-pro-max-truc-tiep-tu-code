import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.primary.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primary,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(
                'Order Preview',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              _PreviewBadge(label: preview.orderTypeLabel),
            ],
          ),
          const SizedBox(height: 10),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  preview.canSubmit || row.$1 == 'Outcome'
                      ? row.$2
                      : 'Enter amount',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            if (row != rows.last) const SizedBox(height: 7),
          ],
          const SizedBox(height: 9),
          Text(
            'Prediction positions, probability, receipt, rewards, and P/L stay separate from Arena Points.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1.35,
            ),
          ),
        ],
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
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .12),
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.primary,
            fontSize: 9,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';
