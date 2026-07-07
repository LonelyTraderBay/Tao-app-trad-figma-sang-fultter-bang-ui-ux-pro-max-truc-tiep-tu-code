import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

const _modePredictionNoticeLineRatio =
    ArenaSpacingTokens.arenaModePredictionNoticeLineHeight;
const _modePredictionTitleLineRatio =
    ArenaSpacingTokens.arenaModePredictionTitleLineHeight;

class ArenaModePredictionContext extends StatelessWidget {
  const ArenaModePredictionContext({
    super.key,
    required this.predictionKey,
    required this.contextDraft,
    required this.onTap,
  });

  final Key predictionKey;
  final ArenaPredictionContextDraft contextDraft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final probability = contextDraft.probability.clamp(0, 100) / 100;
    final color = contextDraft.probability >= 50
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      key: predictionKey,
      borderColor: AppColors.accent20,
      padding: ArenaSpacingTokens.arenaModePredictionCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.accent,
                size: ArenaSpacingTokens.arenaModePredictionInfoIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'MARKET CONTEXT ONLY',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing:
                        ArenaSpacingTokens.arenaModePredictionLetterSpacing,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Prediction Markets',
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Bối cảnh thị trường',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            contextDraft.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: _modePredictionTitleLineRatio,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: AppColors.accent,
                size: ArenaSpacingTokens.arenaModePredictionMetricIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Xác suất "${contextDraft.outcomeName}":',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '${contextDraft.probability}%',
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: ArenaSpacingTokens.arenaModePredictionProgressHeight,
              value: probability,
              backgroundColor: AppColors.surface3,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Align(
            alignment: Alignment.centerLeft,
            child: VitCtaButton(
              onPressed: onTap,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              density: VitDensity.compact,
              leading: const Icon(
                Icons.open_in_new_rounded,
                size: ArenaSpacingTokens.arenaModePredictionActionIcon,
              ),
              padding: AppSpacing.zeroInsets,
              child: const Text('Xem thi truong du doan'),
            ),
          ),
          Text(
            'Thông tin chỉ mang tính tham khảo. Arena Points và Prediction Markets là 2 hệ thống hoàn toàn riêng biệt.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _modePredictionNoticeLineRatio,
            ),
          ),
        ],
      ),
    );
  }
}
