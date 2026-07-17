import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking/staking_custody_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

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
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.segregationBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: EarnSpacingTokens.stakingCustodyBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Center(
                child: StakingCustodyPieChart(
                  allocations: snapshot.segregation,
                  size: EarnSpacingTokens.stakingCustodySegregationChart,
                  donut: false,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Column(
                children: [
                  for (final item in snapshot.segregationLegend) ...[
                    StakingCustodyLegendRow(item: item),
                    if (item != snapshot.segregationLegend.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
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
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.hotColdBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: EarnSpacingTokens.stakingCustodyBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Center(
                child: StakingCustodyPieChart(
                  allocations: snapshot.hotCold,
                  size: EarnSpacingTokens.stakingCustodyHotColdChart,
                  donut: true,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
