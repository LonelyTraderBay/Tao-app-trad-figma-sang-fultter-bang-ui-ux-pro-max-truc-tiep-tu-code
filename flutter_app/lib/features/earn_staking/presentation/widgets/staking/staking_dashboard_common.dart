import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingCircleIconButton extends StatelessWidget {
  const StakingCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip = 'Thao tác staking',
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: onTap,
      variant: VitIconButtonVariant.ghost,
      size: VitIconButtonSize.sm,
    );
  }
}

class StakingLegendDot extends StatelessWidget {
  const StakingLegendDot({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: AppSpacing.x4,
          height: AppSpacing.x1,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.xsRadius,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

Color stakingAssetColor(int index) {
  return switch (index % 5) {
    0 => AppColors.primary,
    1 => AppColors.buy,
    2 => AppColors.accent,
    3 => AppColors.warn,
    _ => AppColors.sell,
  };
}

IconData stakingTypeIcon(StakingDashboardPositionType type) {
  return switch (type) {
    StakingDashboardPositionType.fixed => Icons.lock_outline_rounded,
    StakingDashboardPositionType.defi => Icons.bolt_rounded,
    StakingDashboardPositionType.flexible =>
      Icons.account_balance_wallet_outlined,
  };
}

Color stakingTypeColor(StakingDashboardPositionType type) {
  return switch (type) {
    StakingDashboardPositionType.fixed => AppColors.warn,
    StakingDashboardPositionType.defi => AppColors.accent,
    StakingDashboardPositionType.flexible => AppColors.buy,
  };
}

String stakingTypeLabel(StakingDashboardPositionType type) {
  return switch (type) {
    StakingDashboardPositionType.fixed => 'Cố định',
    StakingDashboardPositionType.defi => 'DeFi',
    StakingDashboardPositionType.flexible => 'Linh hoạt',
  };
}

List<int> stakingDateIndexes(int length) {
  if (length <= 1) return const [0];
  final last = length - 1;
  final indexes = <int>{0, (last * .25).round(), (last * .5).round(), last};
  return indexes.toList()..sort();
}

String stakingFormatUsd(double value) {
  final negative = value < 0;
  final fixed = value.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${negative ? '-' : ''}\$${buffer.toString()}.${parts.last}';
}

String stakingFormatAmount(double value) {
  final decimals = value < 1
      ? 5
      : value >= 100
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
