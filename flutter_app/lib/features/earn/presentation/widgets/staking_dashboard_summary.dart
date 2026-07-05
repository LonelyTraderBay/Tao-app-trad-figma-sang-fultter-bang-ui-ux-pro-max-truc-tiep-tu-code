import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _HeroKpi(
                        label: 'Tổng giá trị Staking',
                        value: stakingFormatUsd(snapshot.totalStakedUsd),
                        caption: '${snapshot.activePositions} vị thế đang hoạt động',
                        valueColor: AppColors.text1,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: AppSpacing.x6,
                      color: AppColors.border,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.x4),
                        child: _HeroKpi(
                          label: 'APY ước tính',
                          value: '${snapshot.weightedApy.toStringAsFixed(2)}%',
                          caption: 'Tham khảo, có thể thay đổi',
                          valueColor: AppModuleAccents.earn,
                        ),
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
                child: _FlatMetric(
                  label: 'Tổng thu nhập',
                  value: '+${stakingFormatUsd(snapshot.totalEarnedUsd)}',
                  valueColor: AppColors.text1,
                ),
              ),
              Expanded(
                child: _FlatMetric(
                  label: 'Vị thế',
                  value: '${snapshot.activePositions} active',
                  valueColor: AppColors.text1,
                ),
              ),
              Expanded(
                child: _FlatMetric(
                  label: 'Đáo hạn sớm',
                  value: '${snapshot.maturingSoon}',
                  valueColor: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Dự báo thu nhập (ước tính tham khảo)',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
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

class _HeroKpi extends StatelessWidget {
  const _HeroKpi({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _FlatMetric extends StatelessWidget {
  const _FlatMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
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
            color: AppModuleAccents.earn,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
