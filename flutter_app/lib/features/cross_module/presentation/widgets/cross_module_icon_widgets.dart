import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/cross_module_spacing_tokens.dart';

/// Shared square icon badge (non-interactive) used across the cross_module
/// pages (Smart Alert Center, Tax Report Center, ...).
class CrossModuleIconBadge extends StatelessWidget {
  const CrossModuleIconBadge({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    this.size = AppSpacing.x6,
    this.iconSize = AppSpacing.iconSm,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: background,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}

/// Shared small tappable icon action chip used across the cross_module
/// pages (Smart Alert Center, Tax Report Center, ...).
class CrossModuleIconAction extends StatelessWidget {
  const CrossModuleIconAction({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: background,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

/// Shared bordered info panel (icon + copy) used across the cross_module
/// pages (Smart Alert Center, Tax Report Center, ...).
class CrossModuleInfoPanel extends StatelessWidget {
  const CrossModuleInfoPanel({
    super.key,
    required this.icon,
    required this.color,
    required this.border,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final Color border;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: border,
      padding: CrossModuleSpacingTokens.crossModulePanelPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
