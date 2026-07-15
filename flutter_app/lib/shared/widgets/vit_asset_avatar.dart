import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

class VitAssetAvatar extends StatelessWidget {
  const VitAssetAvatar({
    super.key,
    required this.label,
    required this.accentColor,
    this.size = SharedSpacingTokens.homeCoinAvatarSize,
    this.radius = AppRadii.smRadius,
    this.border = false,
    this.maxChars = 1,
    this.fillAlpha = 0.16,
    this.borderAlpha = 0.30,
    this.borderColor,
    this.textStyle,
  });

  final String label;
  final Color accentColor;
  final double size;
  final BorderRadiusGeometry radius;
  final bool border;

  /// Number of leading characters from [label] to render (default: 1).
  final int maxChars;

  /// Opacity applied to [accentColor] for the tile fill (default: 0.16).
  final double fillAlpha;

  /// Opacity applied to [borderColor] (or [accentColor]) for the outline
  /// when [border] is true (default: 0.30).
  final double borderAlpha;

  /// Explicit outline color; falls back to [accentColor] when null.
  final Color? borderColor;

  /// Explicit label text style; falls back to the bold caption style tinted
  /// with [accentColor] when null.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final normalizedLabel = label.trim();
    final chars = normalizedLabel.characters;
    final clampedMaxChars = maxChars < 1 ? 1 : maxChars;
    final initial = chars.isEmpty ? '' : chars.take(clampedMaxChars).toString();
    final resolvedBorderColor = borderColor ?? accentColor;
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: accentColor.withValues(alpha: fillAlpha),
          shape: RoundedRectangleBorder(
            side: border
                ? BorderSide(
                    color: resolvedBorderColor.withValues(alpha: borderAlpha),
                  )
                : BorderSide.none,
            borderRadius: radius,
          ),
        ),
        child: Center(
          child: Text(
            initial,
            style:
                textStyle ??
                AppTextStyles.caption.copyWith(
                  color: accentColor,
                  fontWeight: AppTextStyles.bold,
                ),
          ),
        ),
      ),
    );
  }
}
