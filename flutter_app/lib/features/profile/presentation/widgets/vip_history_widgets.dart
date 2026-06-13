import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class VipHistoryTab extends StatelessWidget {
  const VipHistoryTab({super.key, required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in snapshot.history) ...[
          _VipHistoryCard(row: row),
          if (row != snapshot.history.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _VipHistoryCard extends StatelessWidget {
  const _VipHistoryCard({required this.row});

  final ProfileVipHistoryRow row;

  @override
  Widget build(BuildContext context) {
    final isVip = row.level != 'Standard';
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                row.date,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const Spacer(),
              VitStatusPill(
                label: row.level,
                status: isVip
                    ? VitStatusPillStatus.orange
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _VipHistoryMetric(label: 'Khối lượng', value: row.volume),
              _VipHistoryMetric(label: 'Phí đã trả', value: row.fee),
              _VipHistoryMetric(
                label: 'Tiết kiệm',
                value: row.saved,
                valueColor: AppColors.buy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VipHistoryMetric extends StatelessWidget {
  const _VipHistoryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.numericCode.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.heavy,
            ),
          ),
        ],
      ),
    );
  }
}
