import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

class CopyTradingTrendPill extends StatelessWidget {
  const CopyTradingTrendPill({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: value >= 0 ? AppColors.buy15 : AppColors.sell15,
        border: Border.all(
          color: value >= 0 ? AppColors.buy20 : AppColors.sell20,
        ),
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          '${value >= 0 ? '↑' : '↓'} ${value.abs().toStringAsFixed(1)}% vs last month',
          style: AppTextStyles.micro.copyWith(
            color: value >= 0 ? AppColors.buy : AppColors.sell,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class CopyTradingTrendSmall extends StatelessWidget {
  const CopyTradingTrendSmall({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${value >= 0 ? '↑' : '↓'} ${value.abs().toStringAsFixed(1)}%',
      style: AppTextStyles.micro.copyWith(
        color: value >= 0 ? AppColors.buy : AppColors.sell,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class CopyTradingSmallButton extends StatelessWidget {
  const CopyTradingSmallButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: AppRadii.smRadius,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.primary15,
          borderRadius: AppRadii.smRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CopyTradingBadge extends StatelessWidget {
  const CopyTradingBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class CopyTradingIconLine extends StatelessWidget {
  const CopyTradingIconLine({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.buy, size: 15),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

String formatCopyTradingUsd(int value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(2)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$$value';
}

String formatCopyTradingCompact(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}
