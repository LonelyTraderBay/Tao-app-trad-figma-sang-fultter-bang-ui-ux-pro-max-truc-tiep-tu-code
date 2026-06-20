import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class ArenaModeDescriptionCard extends StatelessWidget {
  const ArenaModeDescriptionCard({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Mô tả',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: AppSpacing.arenaPaddingX4,
          child: Text(
            description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
              height: AppSpacing.arenaModeDescriptionLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class ArenaModeRulesSummary extends StatelessWidget {
  const ArenaModeRulesSummary({super.key, required this.rows});

  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Tóm tắt luật chơi',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: AppSpacing.arenaPaddingX4,
          child: Column(
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                _RuleRow(row: rows[index]),
                if (index != rows.length - 1)
                  const SizedBox(height: AppSpacing.x4),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.row});

  final ArenaRuleSummaryRow row;

  @override
  Widget build(BuildContext context) {
    final isRisk = row.label == 'Rủi ro tranh chấp';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.arenaModeRuleLabelWidth,
          child: Text(
            row.label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: isRisk
                ? const VitStatusPill(
                    label: 'Thấp',
                    status: VitStatusPillStatus.success,
                    size: VitStatusPillSize.sm,
                  )
                : Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.arenaModeRuleValueLineHeight,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
