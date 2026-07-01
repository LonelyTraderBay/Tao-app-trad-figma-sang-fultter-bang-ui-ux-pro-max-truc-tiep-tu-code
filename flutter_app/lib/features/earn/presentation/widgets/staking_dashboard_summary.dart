import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_dashboard_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingDashboardSummaryCard extends StatelessWidget {
  const StakingDashboardSummaryCard({
    super.key,
    required this.snapshot,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onExport,
  });

  final StakingDashboardSnapshot snapshot;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng giá trị Staking',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      stakingFormatUsd(snapshot.totalStakedUsd),
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.onAccent,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              StakingCircleIconButton(
                icon: isRefreshing ? Icons.sync_rounded : Icons.refresh_rounded,
                onTap: onRefresh,
              ),
              const SizedBox(width: AppSpacing.x2),
              StakingCircleIconButton(
                icon: Icons.file_download_outlined,
                onTap: onExport,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Tổng thu nhập',
                  value: '+${stakingFormatUsd(snapshot.totalEarnedUsd)}',
                  color: AppColors.buy,
                  border: AppColors.buy20,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'APY trung bình',
                  value: '${snapshot.weightedApy.toStringAsFixed(2)}%',
                  color: AppColors.primarySoft,
                  border: AppColors.primary30,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Vị thế',
                  value: '${snapshot.activePositions} active',
                  color: AppColors.warn,
                  border: AppColors.warn15,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ProjectionMetric(
                  label: 'Hàng ngày',
                  value: snapshot.dailyEarningsUsd,
                ),
              ),
              Expanded(
                child: _ProjectionMetric(
                  label: 'Hàng tháng',
                  value: snapshot.monthlyEarningsUsd,
                ),
              ),
              Expanded(
                child: _ProjectionMetric(
                  label: 'Hàng năm',
                  value: snapshot.yearlyProjectionUsd,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.border,
  });

  final String label;
  final String value;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: border,
      padding: AppSpacing.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectionMetric extends StatelessWidget {
  const _ProjectionMetric({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '+${stakingFormatUsd(value)}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
