import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_slashing_history_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingSlashingHistoryTab extends StatelessWidget {
  const StakingSlashingHistoryTab({super.key, required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingSlashingHistoryKeys.history,
      label: 'Slashing Events',
      accentColor: AppColors.primarySoft,
      children: [
        for (final event in snapshot.events) _SlashingEventCard(event: event),
      ],
    );
  }
}

class _SlashingEventCard extends StatelessWidget {
  const _SlashingEventCard({required this.event});

  final StakingSlashingEventDraft event;

  @override
  Widget build(BuildContext context) {
    final statusColor = stakingSlashingStatusColor(event.status);
    return VitCard(
      key: StakingSlashingHistoryKeys.event(event.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
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
                    Text(event.validator, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${event.network} - ${event.dateLabel}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              StakingSlashingStatusPill(
                label: stakingSlashingStatusLabel(event.status),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.earnCardPaddingX3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Reason: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                    children: [
                      TextSpan(
                        text: event.reason,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Slashed',
                        value:
                            '${stakingSlashingFormatEth(event.slashedAmount)} ETH',
                        color: AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: _EventMetric(
                        label: 'Coverage',
                        value: '${event.insuranceCoverage}%',
                        color: AppColors.warn,
                      ),
                    ),
                    Expanded(
                      child: _EventMetric(
                        label: 'Users',
                        value: event.affectedUsers.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Insurance payout: ${stakingSlashingFormatEth(event.slashedAmount * event.insuranceCoverage / 100)} ETH',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventMetric extends StatelessWidget {
  const _EventMetric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

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
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
