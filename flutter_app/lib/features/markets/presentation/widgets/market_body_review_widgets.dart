import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketBodyReviewSection extends StatelessWidget {
  const MarketBodyReviewSection({
    super.key,
    required this.title,
    required this.message,
    required this.detail,
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  final String title;
  final String message;
  final String detail;
  final String primary;
  final String secondary;
  final String tertiary;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      accentColor: AppColors.primary,
      children: [
        VitBanner(
          variant: VitBannerVariant.info,
          icon: Icons.sync_rounded,
          message: message,
          detail: detail,
        ),
        VitCard(
          padding: AppSpacing.marketBodyReviewCardPadding,
          child: Text(
            primary,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ),
        VitCard(
          padding: AppSpacing.marketBodyReviewCardPadding,
          child: Text(
            secondary,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ),
        VitCard(
          padding: AppSpacing.marketBodyReviewCardPadding,
          child: Text(
            tertiary,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}
