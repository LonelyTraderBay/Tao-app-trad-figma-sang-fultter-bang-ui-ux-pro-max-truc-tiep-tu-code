import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

class VitInlineIconAction extends StatelessWidget {
  const VitInlineIconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = AppColors.text2,
    this.size = AppSpacing.homePortfolioHeaderIcon,
    this.padding = AppSpacing.homePortfolioHeaderActionPadding,
    this.borderRadius = AppRadii.smRadius,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color color;
  final double size;
  final double padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Icon(icon, color: color, size: size),
          ),
        ),
      ),
    );
  }
}
