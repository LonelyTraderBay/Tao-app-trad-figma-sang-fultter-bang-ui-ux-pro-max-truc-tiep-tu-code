import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_custody_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingCustodySegregationSection extends StatelessWidget {
  const StakingCustodySegregationSection({super.key, required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Fund Segregation',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyKeys.segregation,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.segregationBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.stakingCustodyBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Center(
                child: StakingCustodyPieChart(
                  allocations: snapshot.segregation,
                  size: AppSpacing.stakingCustodySegregationChart,
                  donut: false,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Column(
                children: [
                  for (final item in snapshot.segregationLegend) ...[
                    StakingCustodyLegendRow(item: item),
                    if (item != snapshot.segregationLegend.last)
                      const SizedBox(height: AppSpacing.x2),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StakingCustodyHotColdSection extends StatelessWidget {
  const StakingCustodyHotColdSection({super.key, required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Hot vs Cold Wallet Distribution',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyKeys.hotCold,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.hotColdBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.stakingCustodyBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Center(
                child: StakingCustodyPieChart(
                  allocations: snapshot.hotCold,
                  size: AppSpacing.stakingCustodyHotColdChart,
                  donut: true,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: StakingCustodyStorageTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Cold Storage',
                      description:
                          'Offline, air-gapped, multi-signature hardware wallets',
                      color: AppColors.buy,
                    ),
                  ),
                  SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: StakingCustodyStorageTile(
                      icon: Icons.sync_alt_rounded,
                      title: 'Hot Wallet',
                      description:
                          'Online for withdrawals, secured with MPC technology',
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
