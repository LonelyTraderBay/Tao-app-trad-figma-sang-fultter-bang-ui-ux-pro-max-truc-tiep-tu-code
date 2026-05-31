import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_dca_builder_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadDcaHistorySection extends StatelessWidget {
  const LaunchpadDcaHistorySection({
    super.key,
    required this.sectionKey,
    required this.chartKey,
    required this.executions,
  });

  final Key sectionKey;
  final Key chartKey;
  final List<LaunchpadDcaExecutionDraft> executions;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            key: chartKey,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price & Tokens Purchased (ARB)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                _ExecutionBars(executions: executions),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Lich su mua',
            accentColor: AppColors.buy,
            children: [
              for (final execution in executions)
                _ExecutionCard(execution: execution),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExecutionBars extends StatelessWidget {
  const _ExecutionBars({required this.executions});

  final List<LaunchpadDcaExecutionDraft> executions;

  @override
  Widget build(BuildContext context) {
    final maxTokens = executions.fold<double>(
      0,
      (max, execution) => execution.tokens > max ? execution.tokens : max,
    );
    return SizedBox(
      height: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final execution in executions) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    execution.tokens.toStringAsFixed(1),
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Flexible(
                    child: FractionallySizedBox(
                      heightFactor: maxTokens == 0
                          ? 0
                          : (execution.tokens / maxTokens).clamp(.2, 1),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadii.sm),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    execution.date.split(' ').first,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            if (execution != executions.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ExecutionCard extends StatelessWidget {
  const _ExecutionCard({required this.execution});

  final LaunchpadDcaExecutionDraft execution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${execution.amount.toStringAsFixed(0)} -> ${execution.tokens.toStringAsFixed(2)} ARB',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  execution.date,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                launchpadDcaFormatPrice(execution.price),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'Fee: \$${execution.fee.toStringAsFixed(1)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
