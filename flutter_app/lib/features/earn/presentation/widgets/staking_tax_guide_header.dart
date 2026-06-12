import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingTaxDisclaimerBanner extends StatelessWidget {
  const StakingTaxDisclaimerBanner({super.key, required this.snapshot});

  final StakingTaxGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingTaxGuideKeys.disclaimer,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.stakingTaxDisclaimerMinHeight,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        border: Border.all(
          color: AppColors.sell20,
          width: AppSpacing.stakingTaxBorderWidth,
        ),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: AppSpacing.stakingTaxDisclaimerIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.disclaimerTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.disclaimerBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingTaxFooterLineHeight,
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

class StakingTaxTabs extends StatelessWidget {
  const StakingTaxTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingRiskDisclosureTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface2,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.stakingTaxTabsMinHeight,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(key: tab.id, label: tab.label, icon: null),
        ],
      ),
    );
  }
}
