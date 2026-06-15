import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
    this.variant = VitSectionHeaderVariant.plain,
    this.accentColor = AppColors.primary,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VitSectionHeaderVariant variant;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final showAccent = variant == VitSectionHeaderVariant.accentBar;
    return Row(
      children: [
        if (showAccent) ...[
          Container(
            width: AppSpacing.serviceTileAccentBarThickness,
            height: AppSpacing.serviceTileSectionBarHeight,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: AppRadii.xsRadius,
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
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.homeSectionHeaderTitleLineHeight,
              ),
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onAction,
              borderRadius: AppRadii.smRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(
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
                    const SizedBox(width: AppSpacing.x1),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: accentColor,
                      size: AppSpacing.homeSectionHeaderChevronSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
