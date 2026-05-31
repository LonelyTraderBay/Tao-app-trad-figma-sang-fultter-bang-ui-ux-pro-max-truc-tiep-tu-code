import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_common.dart';
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
                const SizedBox(height: AppSpacing.x2),
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
    return Container(
      key: StakingInsuranceFundKeys.tabs,
      decoration: const BoxDecoration(color: AppColors.surface),
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
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
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

class StakingInsuranceFundStatusCard extends StatelessWidget {
  const StakingInsuranceFundStatusCard({super.key, required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.currentRatio / snapshot.targetRatio;
    return VitCard(
      key: StakingInsuranceFundKeys.fundStatus,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StakingInsuranceFundMetricBlock(
                  label: 'Total Fund Balance',
                  value: stakingInsuranceFundFormatUsd(snapshot.totalBalance),
                  large: true,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: StakingInsuranceFundMetricBlock(
                  label: 'Reserve Ratio',
                  value: '${snapshot.currentRatio}%',
                  suffix: '/ ${snapshot.targetRatio}%',
                  valueColor: AppColors.buy,
                  alignRight: true,
                  large: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox.square(
            dimension: 160,
            child: CustomPaint(
              painter: StakingInsuranceFundProgressRingPainter(
                progress: progress,
                color: AppColors.buy,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.buy,
                      ),
                    ),
                    Text(
                      'of target',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'Total Liabilities',
                  value: stakingInsuranceFundFormatUsd(snapshot.liabilities),
                  color: AppColors.primarySoft,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'Surplus',
                  value: stakingInsuranceFundFormatUsd(snapshot.surplus),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Last updated: ${snapshot.lastUpdated}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class StakingInsuranceFundMetricBlock extends StatelessWidget {
  const StakingInsuranceFundMetricBlock({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.valueColor = AppColors.text1,
    this.alignRight = false,
    this.large = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final Color valueColor;
  final bool alignRight;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: (large ? AppTextStyles.sectionTitle : AppTextStyles.body)
                    .copyWith(
                      color: valueColor,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: AppSpacing.x1),
                Text(
                  suffix!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class StakingInsuranceFundInlineStatCard extends StatelessWidget {
  const StakingInsuranceFundInlineStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: 0.16),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: StakingInsuranceFundMetricBlock(
        label: label,
        value: value,
        valueColor: color,
      ),
    );
  }
}

class StakingInsuranceFundAssetBreakdownCard extends StatelessWidget {
  const StakingInsuranceFundAssetBreakdownCard({
    super.key,
    required this.assets,
  });

  final List<StakingInsuranceFundAssetDraft> assets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          SizedBox.square(
            dimension: 200,
            child: CustomPaint(
              painter: StakingInsuranceFundPiePainter(assets: assets),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final asset in assets) ...[
            StakingInsuranceFundAssetRow(asset: asset),
            if (asset != assets.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class StakingInsuranceFundAssetRow extends StatelessWidget {
  const StakingInsuranceFundAssetRow({super.key, required this.asset});

  final StakingInsuranceFundAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    final color = stakingInsuranceFundAssetColor(asset.colorKey);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              asset.asset,
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stakingInsuranceFundFormatUsd(asset.value),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${asset.percentage}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StakingInsuranceFundContributionCard extends StatelessWidget {
  const StakingInsuranceFundContributionCard({
    super.key,
    required this.snapshot,
  });

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.primarySoft,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How the Fund Grows', style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      '${snapshot.stakingFeeContribution}% of all staking fees are automatically allocated to the insurance fund. No user funds are ever used.',
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
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'Monthly Avg',
                  value: stakingInsuranceFundFormatUsd(
                    snapshot.monthlyContribution,
                  ),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'YTD 2026',
                  value: stakingInsuranceFundFormatUsd(
                    snapshot.ytdContributions,
                  ),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          StakingInsuranceFundInlineStatCard(
            label: 'Total Contributed (All-time)',
            value: stakingInsuranceFundFormatUsd(snapshot.totalContributed),
            color: AppColors.primarySoft,
          ),
        ],
      ),
    );
  }
}
