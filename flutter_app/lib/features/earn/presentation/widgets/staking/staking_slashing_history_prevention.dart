import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking/staking_slashing_history_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingSlashingPreventionTab extends StatelessWidget {
  const StakingSlashingPreventionTab({super.key, required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingSlashingHistoryKeys.prevention,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Active Prevention Measures',
          accentColor: AppColors.primarySoft,
          children: [
            for (final measure in snapshot.preventionMeasures)
              _PreventionCard(measure: measure),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.buy20,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'Proactive Protection: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                      height: EarnSpacingTokens.stakingSlashingBodyLineHeight,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Our multi-layered prevention system has reduced slashing events by 40% year-over-year. Continuous monitoring and automated rebalancing ensure your stake is always protected.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height:
                              EarnSpacingTokens.stakingSlashingBodyLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreventionCard extends StatelessWidget {
  const _PreventionCard({required this.measure});

  final StakingSlashingPreventionDraft measure;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: AppSpacing.ctaHeight,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.buy.withValues(alpha: 0.12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.lgRadius,
                ),
              ),
              child: const Center(
                child: Icon(Icons.shield_outlined, color: AppColors.buy),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        measure.measure,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    StakingSlashingStatusPill(
                      label: stakingSlashingCapitalize(measure.status),
                      color: AppColors.buy,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  measure.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: EarnSpacingTokens.stakingSlashingMeasureLineHeight,
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
