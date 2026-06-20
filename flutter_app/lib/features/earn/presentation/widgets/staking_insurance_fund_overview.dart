import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_asset_breakdown.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_contribution_card.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_status_card.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingInsuranceFundInfoBanner extends StatelessWidget {
  const StakingInsuranceFundInfoBanner({super.key, required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsuranceFundKeys.info,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingProductBodyLineHeight,
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

class StakingInsuranceFundTabs extends StatelessWidget {
  const StakingInsuranceFundTabs({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final StakingInsuranceFundTab active;
  final ValueChanged<StakingInsuranceFundTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: StakingInsuranceFundKeys.tabs,
      color: AppColors.surface,
      child: Row(
        children: [
          for (final tab in StakingInsuranceFundTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingInsuranceFundKeys.tab(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: AppSpacing.earnTopPaddingX4,
                    child: Column(
                      children: [
                        Text(
                          stakingInsuranceFundTabLabel(tab),
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 160),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: active == tab ? AppSpacing.buttonHero : 0,
                            height: AppSpacing.stakingProductTabIndicatorHeight,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                color: active == tab
                                    ? AppColors.primarySoft
                                    : AppColors.transparent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadii.xsRadius,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StakingInsuranceFundOverviewTab extends StatelessWidget {
  const StakingInsuranceFundOverviewTab({super.key, required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Current Fund Status',
          accentColor: AppColors.primarySoft,
          children: [StakingInsuranceFundStatusCard(snapshot: snapshot)],
        ),
        VitPageSection(
          key: StakingInsuranceFundKeys.assetBreakdown,
          label: 'Asset Breakdown',
          accentColor: AppColors.primarySoft,
          children: [
            StakingInsuranceFundAssetBreakdownCard(assets: snapshot.assets),
          ],
        ),
        VitPageSection(
          key: StakingInsuranceFundKeys.contribution,
          label: 'Fund Contribution Model',
          accentColor: AppColors.primarySoft,
          children: [StakingInsuranceFundContributionCard(snapshot: snapshot)],
        ),
      ],
    );
  }
}
