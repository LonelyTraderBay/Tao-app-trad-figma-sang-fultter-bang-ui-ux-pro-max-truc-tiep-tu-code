import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'staking_custody_actions_common.dart';
part 'staking_custody_pie_chart.dart';

final class StakingCustodyKeys {
  const StakingCustodyKeys._();

  static const hero = Key('sc375_custody_hero');
  static const custodian = Key('sc375_custodian_card');
  static const segregation = Key('sc375_segregation_card');
  static const hotCold = Key('sc375_hot_cold_card');
  static const reconciliation = Key('sc375_reconciliation_card');
  static const transparency = Key('sc375_transparency_card');
  static const auditTrailButton = Key('sc375_audit_trail_button');
  static const feedback = Key('sc375_feedback');
  static const footer = Key('sc375_footer');
}

class StakingCustodyMetricTile extends StatelessWidget {
  const StakingCustodyMetricTile({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              height: AppSpacing.stakingCustodyMetricValueLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class StakingCustodyLegendRow extends StatelessWidget {
  const StakingCustodyLegendRow({super.key, required this.item});

  final StakingCustodyLegendDraft item;

  @override
  Widget build(BuildContext context) {
    final color = stakingCustodyToneColor(item.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            stakingCustodyIconFor(item.iconKey),
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.stakingCustodyDescriptionLineHeight,
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

class StakingCustodyStorageTile extends StatelessWidget {
  const StakingCustodyStorageTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: AppSpacing.stakingCustodyDescriptionLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class StakingCustodyReconciliationLogCard extends StatelessWidget {
  const StakingCustodyReconciliationLogCard({super.key, required this.log});

  final StakingReconciliationLogDraft log;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  log.dateLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const StakingCustodyMatchStatus(),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: StakingCustodyReconciliationMetric(
                  label: 'On-chain',
                  value: stakingCustodyFormatUsd(log.onChainUsd),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: StakingCustodyReconciliationMetric(
                  label: 'Custodian',
                  value: stakingCustodyFormatUsd(log.custodyUsd),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: StakingCustodyReconciliationMetric(
                  label: 'Discrepancy',
                  value: stakingCustodyFormatUsd(log.discrepancyUsd),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StakingCustodyReconciliationMetric extends StatelessWidget {
  const StakingCustodyReconciliationMetric({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class StakingCustodyMatchStatus extends StatelessWidget {
  const StakingCustodyMatchStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.buy,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: AppSpacing.stakingCustodyStatusDot,
            height: AppSpacing.stakingCustodyStatusDot,
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          'Matched',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class StakingCustodyAddressRow extends StatelessWidget {
  const StakingCustodyAddressRow({super.key, required this.address});

  final StakingTransparencyAddressDraft address;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  address.address,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'View ->',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primarySoft,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
