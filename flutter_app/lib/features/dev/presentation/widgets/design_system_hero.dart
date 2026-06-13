import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DesignSystemHero extends StatelessWidget {
  const DesignSystemHero({super.key, required this.snapshot});

  final DesignSystemSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Stack(
        children: [
          Positioned(
            top: -AppSpacing.x6,
            right: -AppSpacing.x6,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.accent15,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: AppSpacing.buttonHero + AppSpacing.x6,
                height: AppSpacing.buttonHero + AppSpacing.x6,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.heroEyebrow.toUpperCase(),
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(snapshot.heroTitle, style: AppTextStyles.sectionTitleMd),
              const SizedBox(height: AppSpacing.x3),
              Text(
                snapshot.heroDescription,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
