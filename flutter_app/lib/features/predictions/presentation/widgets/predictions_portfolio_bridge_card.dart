import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class PredictionsPortfolioArenaBridgeCard extends StatelessWidget {
  const PredictionsPortfolioArenaBridgeCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: AppColors.warningBorder,
      padding: AppSpacing.predictionPortfolioBridgePadding,
      child: Row(
        children: [
          Container(
            width: AppSpacing.predictionPortfolioBridgeIconBox,
            height: AppSpacing.predictionPortfolioBridgeIconBox,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              color: AppColors.warn,
              size: AppSpacing.predictionPortfolioBridgeIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.predictionPortfolioBridgeGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khám phá Arena cùng chủ đề',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Social points-only · Không liên quan ví hay vị thế Prediction',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.predictionPortfolioBridgeTextGap,
                ),
                Text(
                  'Prediction positions and P/L stay separate from Arena Points.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.predictionPortfolioBridgeBadgeGap),
          Container(
            padding: AppSpacing.predictionPortfolioBridgeBadgePadding,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.badgeRadius,
            ),
            child: Text(
              'Arena Points',
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.predictionPortfolioBridgeChevronGap),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.warn,
            size: AppSpacing.predictionPortfolioBridgeChevron,
          ),
        ],
      ),
    );
  }
}
