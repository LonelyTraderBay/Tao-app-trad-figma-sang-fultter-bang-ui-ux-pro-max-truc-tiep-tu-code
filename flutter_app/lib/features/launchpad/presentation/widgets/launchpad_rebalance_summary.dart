import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_calculations.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadRebalanceSummaryCard extends StatelessWidget {
  const LaunchpadRebalanceSummaryCard({
    super.key,
    required this.txCount,
    required this.totalGas,
    required this.strategy,
  });

  final int txCount;
  final double totalGas;
  final LaunchpadRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tom tat rebalance',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          LaunchpadRebalanceSummaryRow(
            label: 'So giao dich can thuc hien',
            value: '$txCount tx',
          ),
          LaunchpadRebalanceSummaryRow(
            label: 'Gas uoc tinh',
            value: '~\$${totalGas.toStringAsFixed(2)}',
          ),
          LaunchpadRebalanceSummaryRow(
            label: 'Chien luoc',
            value: strategy.name,
          ),
          LaunchpadRebalanceSummaryRow(
            label: 'Muc rui ro',
            value: launchpadRebalanceRiskLabel(strategy.riskLevel),
            color: strategy.accent,
          ),
        ],
      ),
    );
  }
}

class LaunchpadRebalanceSummaryRow extends StatelessWidget {
  const LaunchpadRebalanceSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: color ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LaunchpadRebalanceWarningBanner extends StatelessWidget {
  const LaunchpadRebalanceWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Day la de xuat tu dong dua tren ty le muc tieu. Gia token co the thay doi giua luc xem va luc thuc hien. Luon kiem tra lai truoc khi giao dich.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
