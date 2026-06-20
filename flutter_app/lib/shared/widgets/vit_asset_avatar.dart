import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

class VitAssetAvatar extends StatelessWidget {
  const VitAssetAvatar({
    super.key,
    required this.label,
    required this.accentColor,
    this.size = AppSpacing.homeCoinAvatarSize,
    this.radius = AppRadii.smRadius,
    this.border = false,
  });

  final String label;
  final Color accentColor;
  final double size;
  final BorderRadiusGeometry radius;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final normalizedLabel = label.trim();
    final initial = normalizedLabel.isEmpty
        ? ''
        : normalizedLabel.characters.first;
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: accentColor.withValues(alpha: 0.16),
          shape: RoundedRectangleBorder(
            side: border
                ? BorderSide(color: accentColor.withValues(alpha: 0.30))
                : BorderSide.none,
            borderRadius: radius,
          ),
        ),
        child: Center(
          child: Text(
            initial,
            style: AppTextStyles.caption.copyWith(
              color: accentColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
