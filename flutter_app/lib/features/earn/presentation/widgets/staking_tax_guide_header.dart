import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingTaxDisclaimerBanner extends StatelessWidget {
  const StakingTaxDisclaimerBanner({super.key, required this.snapshot});

  final StakingTaxGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      key: StakingTaxGuideKeys.disclaimer,
      constraints: const BoxConstraints(
        minHeight: EarnSpacingTokens.stakingTaxDisclaimerMinHeight,
      ),
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.sell10,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColors.sell20,
              width: EarnSpacingTokens.stakingTaxBorderWidth,
            ),
            borderRadius: AppRadii.cardLargeRadius,
          ),
        ),
        child: Padding(
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.sell,
                size: EarnSpacingTokens.stakingTaxDisclaimerIcon,
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
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      snapshot.disclaimerBody,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: EarnSpacingTokens.stakingTaxFooterLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: active,
      onChanged: onChanged,
      tabs: [for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label)],
    );
  }
}
