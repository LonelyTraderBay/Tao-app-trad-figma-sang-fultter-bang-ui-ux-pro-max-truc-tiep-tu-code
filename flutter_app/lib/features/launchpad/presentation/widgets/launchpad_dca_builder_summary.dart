import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_dca_builder_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadDcaSummaryCard extends StatelessWidget {
  const LaunchpadDcaSummaryCard({super.key, required this.snapshot});

  final LaunchpadDcaBuilderSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              _SummaryMetric(
                label: 'Total Invested',
                value: launchpadDcaFormatMoney(snapshot.totalInvested),
                color: AppColors.text1,
                large: true,
              ),
              _SummaryMetric(
                label: 'Current Value',
                value: launchpadDcaFormatMoney(snapshot.currentValue),
                color: AppColors.buy,
                large: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              _SummaryMetric(
                label: 'Active Strategies',
                value: '${snapshot.activeStrategyCount}',
                color: AppColors.text1,
              ),
              _SummaryMetric(
                label: 'Total Orders',
                value: '${snapshot.executedOrderCount}',
                color: AppColors.text1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
    this.large = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final valueStyle = large
        ? AppTextStyles.amountBase
        : AppTextStyles.baseMedium;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            style: valueStyle.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
