import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';

class P2PDisputeSmallPill extends StatelessWidget {
  const P2PDisputeSmallPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class P2PDisputeSmallButton extends StatelessWidget {
  const P2PDisputeSmallButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .10),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: AppSpacing.buttonCompact,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: AppSpacing.x1),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color p2pDisputeStatusColor(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => AppColors.warn,
    P2PDisputeStatus.underReview => AppModuleAccents.p2p,
    P2PDisputeStatus.resolved => AppColors.buy,
    P2PDisputeStatus.rejected => AppColors.sell,
  };
}

IconData p2pDisputeStatusIcon(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => Icons.schedule_rounded,
    P2PDisputeStatus.underReview => Icons.description_outlined,
    P2PDisputeStatus.resolved => Icons.check_circle_outline_rounded,
    P2PDisputeStatus.rejected => Icons.warning_amber_rounded,
  };
}

Color p2pDisputeLevelColor(int level) {
  return switch (level) {
    1 => AppModuleAccents.p2p,
    2 => AppColors.accent,
    3 => AppColors.warn,
    _ => AppColors.sell,
  };
}

IconData p2pDisputeLevelIcon(String iconKey) {
  return switch (iconKey) {
    'bot' => Icons.smart_toy_outlined,
    'support' => Icons.support_agent_rounded,
    'scale' => Icons.balance_rounded,
    'briefcase' => Icons.business_center_outlined,
    _ => Icons.shield_outlined,
  };
}
