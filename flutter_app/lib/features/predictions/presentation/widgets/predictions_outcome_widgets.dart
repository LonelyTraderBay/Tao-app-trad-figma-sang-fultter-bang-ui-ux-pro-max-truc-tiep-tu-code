import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

/// Shared prediction event card widgets used by both the Predictions Home
/// hub and the Predictions Search hub. Both pages previously carried
/// byte-for-byte identical private `_MultiOutcomeRow`/`_SmallBadge` widget
/// definitions; this module consolidates them into a single importable
/// source of truth.
class PredictionMultiOutcomeRow extends StatelessWidget {
  const PredictionMultiOutcomeRow({super.key, required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final outcome in event.outcomes.take(3))
          Text(
            '${outcome.label} ${outcome.chance}%',
            style: AppTextStyles.badge.copyWith(
              color: outcome.tone.resolve(),
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        if (event.outcomes.length > 3)
          Text(
            '+${event.outcomes.length - 3} khác',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class PredictionSmallBadge extends StatelessWidget {
  const PredictionSmallBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.badgeRadius),
      child: Padding(
        padding: PredictionsSpacingTokens.predictionHomeBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
