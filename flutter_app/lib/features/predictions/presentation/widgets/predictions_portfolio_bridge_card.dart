import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              color: AppColors.warn,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
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
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Prediction positions and P/L stay separate from Arena Points.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Arena Points',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontSize: 8,
                fontWeight: AppTextStyles.bold,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 7),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.warn,
            size: 17,
          ),
        ],
      ),
    );
  }
}
