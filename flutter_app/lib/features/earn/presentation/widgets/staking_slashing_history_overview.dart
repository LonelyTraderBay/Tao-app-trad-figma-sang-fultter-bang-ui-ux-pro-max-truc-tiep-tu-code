import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_slashing_history_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingSlashingInsuranceBanner extends StatelessWidget {
  const StakingSlashingInsuranceBanner({super.key, required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryKeys.info,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class StakingSlashingSummaryStats extends StatelessWidget {
  const StakingSlashingSummaryStats({super.key, required this.stats});

  final StakingSlashingStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryKeys.stats,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.x3,
        crossAxisSpacing: AppSpacing.x3,
        childAspectRatio: 1.65,
        children: [
          _StatTile(
            label: 'Total Events',
            value: stats.totalEvents.toString(),
            caption: 'Last 12 months',
          ),
          _StatTile(
            label: 'Total Slashed',
            value: '${stakingSlashingFormatEth(stats.totalSlashedEth)} ETH',
            caption: 'All networks',
            color: AppColors.sell,
            borderColor: AppColors.sell20,
          ),
          _StatTile(
            label: 'Insurance Paid',
            value: '${stakingSlashingFormatEth(stats.totalCoveredEth)} ETH',
            caption: '${stats.coverageRate}% coverage',
            color: AppColors.buy,
            borderColor: AppColors.buy20,
          ),
          _StatTile(
            label: 'Avg Recovery',
            value: stats.avgRecoveryTime,
            caption: 'Time to payout',
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.caption,
    this.color,
    this.borderColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.text1;
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: textColor,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class StakingSlashingTabs extends StatelessWidget {
  const StakingSlashingTabs({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final StakingSlashingTab active;
  final ValueChanged<StakingSlashingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingSlashingHistoryKeys.tabs,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in StakingSlashingTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingSlashingHistoryKeys.tab(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          stakingSlashingTabLabel(tab),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.transparent,
                            borderRadius: AppRadii.xsRadius,
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
