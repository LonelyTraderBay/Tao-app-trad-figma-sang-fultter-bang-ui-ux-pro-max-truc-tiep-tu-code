import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tappable [VitCard] consent tile with a leading checkbox-style icon that
/// flips color/border/variant when [checked].
///
/// Shared by legal/consent-flow contexts across `features/trade_copy` (copy
/// trading confirmation consents, provider application disclosures). Both
/// call sites owned an almost identical hand-rolled `_ConsentTile` before
/// this extraction; this widget parameterizes the small differences
/// (variant-on-checked, icon set/size, inner spacing, text line-height)
/// rather than forcing one visual shape on both flows.
class TradeCopyConsentCard extends StatelessWidget {
  const TradeCopyConsentCard({
    super.key,
    this.cardKey,
    required this.checked,
    required this.text,
    required this.onTap,
    required this.accentColor,
    this.checkedVariant = VitCardVariant.standard,
    this.uncheckedVariant = VitCardVariant.inner,
    this.checkedIcon = Icons.check_box_rounded,
    this.uncheckedIcon = Icons.check_box_outline_blank_rounded,
    this.iconSize = AppSpacing.iconSm,
    this.density,
    this.padding,
    this.spacing = AppSpacing.x2,
    this.textHeight,
  });

  /// Key applied to the inner [VitCard] surface (kept distinct from the
  /// wrapper's own [key] so tests can target the tappable card directly).
  final Key? cardKey;

  final bool checked;
  final String text;
  final VoidCallback onTap;

  /// Color used for the checked icon and the checked-state border.
  final Color accentColor;

  final VitCardVariant checkedVariant;
  final VitCardVariant uncheckedVariant;
  final IconData checkedIcon;
  final IconData uncheckedIcon;
  final double iconSize;
  final VitDensity? density;
  final EdgeInsetsGeometry? padding;

  /// Gap between the leading icon and the label text.
  final double spacing;

  /// Optional line-height override for the label [Text].
  final double? textHeight;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: cardKey,
      variant: checked ? checkedVariant : uncheckedVariant,
      borderColor: checked ? accentColor : null,
      density: density,
      padding: padding,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked ? checkedIcon : uncheckedIcon,
            color: checked ? accentColor : AppColors.text3,
            size: iconSize,
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                height: textHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
