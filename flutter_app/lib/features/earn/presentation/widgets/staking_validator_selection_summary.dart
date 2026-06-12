import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingValidatorSelectionInfoBanner extends StatelessWidget {
  const StakingValidatorSelectionInfoBanner({
    super.key,
    required this.snapshot,
  });

  final StakingValidatorSelectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorSelectionKeys.info,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primarySoft,
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
                    height: AppSpacing.stakingValidatorSelectionBodyLineHeight,
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

class StakingValidatorSelectionStatsSummary extends StatelessWidget {
  const StakingValidatorSelectionStatsSummary({
    super.key,
    required this.snapshot,
  });

  final StakingValidatorSelectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final top = snapshot.validators.reduce((a, b) => a.apy >= b.apy ? a : b);
    final avgCommission =
        snapshot.validators.fold<double>(
          0,
          (sum, item) => sum + item.commission,
        ) /
        snapshot.validators.length;
    final avgUptime =
        snapshot.validators.fold<double>(0, (sum, item) => sum + item.uptime) /
        snapshot.validators.length;

    return VitCard(
      key: StakingValidatorSelectionKeys.summary,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              icon: Icons.trending_up_rounded,
              label: 'APY tốt nhất',
              value: '${top.apy.toStringAsFixed(2)}%',
              detail: top.name,
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              icon: Icons.schedule_rounded,
              label: 'Uptime TB',
              value: '${avgUptime.toStringAsFixed(2)}%',
              detail: '',
              color: AppColors.primarySoft,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              icon: Icons.group_outlined,
              label: 'Commission TB',
              value: '${avgCommission.toStringAsFixed(1)}%',
              detail: '',
              color: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        if (detail.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}
