import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bordered [VitCard] that separates an icon+title header row from a
/// flexible body (bulleted lines, arbitrary children, or free-form text).
///
/// Prefer [VitInfoCallout] when the content is a single icon + optional
/// title + one message string. Use this widget instead when the body needs
/// more than a single message — e.g. a bulleted alert list or stacked
/// sub-panels — while keeping the same icon+title header shape.
class TradeCopyHeaderBodyCard extends StatelessWidget {
  const TradeCopyHeaderBodyCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleStyle,
    required this.body,
    this.iconSize = AppSpacing.iconMd,
    this.headerGap = AppSpacing.x2,
    this.variant = VitCardVariant.standard,
    this.density,
    this.padding,
    this.borderColor,
    this.constraints,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final TextStyle titleStyle;

  /// Flexible content rendered below the header row. Can be a bulleted
  /// [Column], arbitrary children, or free-form text.
  final Widget body;

  final double iconSize;

  /// Gap between the icon and title, and between the header row and [body].
  final double headerGap;

  final VitCardVariant variant;
  final VitDensity? density;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final BoxConstraints? constraints;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: variant,
      density: density,
      padding: padding,
      borderColor: borderColor,
      constraints: constraints,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: iconSize),
              SizedBox(width: headerGap),
              Text(title, style: titleStyle),
            ],
          ),
          SizedBox(height: headerGap),
          body,
        ],
      ),
    );
  }
}
