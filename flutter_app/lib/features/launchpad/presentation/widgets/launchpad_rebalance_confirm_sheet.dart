import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_calculations.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_summary.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadRebalanceConfirmSheet extends StatelessWidget {
  const LaunchpadRebalanceConfirmSheet({
    super.key,
    required this.sheetKey,
    required this.confirmKey,
    required this.cancelKey,
    required this.suggestions,
    required this.totalGas,
    required this.onClose,
  });

  final Key sheetKey;
  final Key confirmKey;
  final Key cancelKey;
  final List<RebalanceSuggestion> suggestions;
  final double totalGas;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final executable = suggestions
        .where((item) => item.action != LaunchpadRebalanceAction.hold)
        .toList();
    return Material(
      key: sheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x3,
                AppSpacing.contentPad,
                AppSpacing.x6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.borderSolid,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.buy,
                        size: 21,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        'Xac nhan Rebalance',
                        style: AppTextStyles.base.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  for (final suggestion in executable)
                    _ConfirmActionRow(suggestion: suggestion),
                  const SizedBox(height: AppSpacing.x3),
                  LaunchpadRebalanceSummaryRow(
                    label: 'Gas tong',
                    value: '~\$${totalGas.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  VitCtaButton(
                    key: confirmKey,
                    variant: VitCtaButtonVariant.success,
                    onPressed: onClose,
                    child: const Text('Xac nhan Rebalance (Mo phong)'),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  TextButton(
                    key: cancelKey,
                    onPressed: onClose,
                    child: Text(
                      'Huy',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmActionRow extends StatelessWidget {
  const _ConfirmActionRow({required this.suggestion});

  final RebalanceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final color = launchpadRebalanceActionColor(suggestion.action);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.x2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Text(
            launchpadRebalanceActionLabel(suggestion.action),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              suggestion.asset.symbol,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '\$${suggestion.suggestedValue.toStringAsFixed(2)}',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
