import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DesignSystemSectionHeaderSection extends StatelessWidget {
  const DesignSystemSectionHeaderSection({
    super.key,
    required this.sectionKey,
    required this.demos,
  });

  final Key sectionKey;
  final List<DesignSectionDemoDraft> demos;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: sectionKey,
      label: 'SectionHeader Component',
      children: [
        for (final demo in demos)
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            radius: VitCardRadius.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppSpacing.x1,
                      height: AppSpacing.iconMd,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(demo.title, style: AppTextStyles.baseMedium),
                          if (demo.subtitle != null)
                            Text(
                              demo.subtitle!,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (demo.badge != null)
                      DesignSystemPositiveBadge(label: demo.badge!),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: SizedBox(height: AppSpacing.x6),
                ),
              ],
            ),
          ),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DesignSystemAccentSample(
                label: 'Mua (Buy)',
                color: AppColors.buy,
              ),
              DesignSystemAccentSample(
                label: 'Bán (Sell)',
                color: AppColors.sell,
              ),
              DesignSystemAccentSample(
                label: 'Cảnh báo',
                color: AppColors.warn,
              ),
              DesignSystemAccentSample(
                label: 'Premium',
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
