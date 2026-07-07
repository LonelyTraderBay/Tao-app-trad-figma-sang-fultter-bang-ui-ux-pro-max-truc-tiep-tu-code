import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

enum VitSectionHeaderVariant { plain, accentBar }

class VitSectionHeader extends StatelessWidget {
  const VitSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.actionLabel,
    this.onAction,
    this.actionKey,
    this.actionSemanticLabel,
    this.actionShowChevron = true,
    this.variant = VitSectionHeaderVariant.plain,
    this.accentColor = AppColors.primary,
    this.density = VitDensity.standard,
    this.bottomGap,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  /// When false, trailing action is text-only (form shortcuts like Quét QR).
  final bool actionShowChevron;

  /// Accessible label for the trailing action button. Defaults to
  /// '$actionLabel $title' (e.g. 'Xem thêm Sản phẩm') when not provided, so
  /// every call site gets a screen-reader label distinguishing it from other
  /// sections' generic "Xem thêm"/"Xem tất cả" buttons without requiring an
  /// update everywhere.
  final String? actionSemanticLabel;
  final VitSectionHeaderVariant variant;
  final Color accentColor;
  final VitDensity density;

  /// Space below the header row (title → body). When null, callers or
  /// [VitPageSection] supply padding externally.
  final double? bottomGap;

  bool get _isCompact =>
      density == VitDensity.compact || density == VitDensity.tool;

  @override
  Widget build(BuildContext context) {
    final showAccent = variant == VitSectionHeaderVariant.accentBar;
    final header = Row(
      children: [
        if (showAccent) ...[
          SizedBox(
            width: AppSpacing.serviceTileAccentBarThickness,
            height: _isCompact
                ? AppSpacing.pageSectionAccentHeight
                : AppSpacing.serviceTileSectionBarHeight,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: accentColor,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
        ],
        if (icon != null) ...[
          Icon(icon, color: iconColor ?? accentColor, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.homeSectionHeaderIconGap),
        ],
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  (_isCompact
                          ? AppTextStyles.caption
                          : AppTextStyles.sectionTitle)
                      .copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.homeSectionHeaderTitleLineHeight,
                      ),
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          Semantics(
            button: true,
            label: actionSemanticLabel ?? '$actionLabel $title',
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                key: actionKey,
                onTap: onAction,
                borderRadius: AppRadii.inputRadius,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel!,
                        style: AppTextStyles.caption.copyWith(
                          color: accentColor,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      if (actionShowChevron) ...[
                        const SizedBox(width: AppSpacing.x1),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: accentColor,
                          size: AppSpacing.homeSectionHeaderChevronSize,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    if (bottomGap == null) return header;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: bottomGap!),
      child: header,
    );
  }
}
