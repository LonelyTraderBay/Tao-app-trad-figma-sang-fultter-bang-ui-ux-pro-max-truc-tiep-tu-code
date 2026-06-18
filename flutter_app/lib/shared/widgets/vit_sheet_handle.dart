import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

class VitSheetHandle extends StatelessWidget {
  const VitSheetHandle({
    super.key,
    this.width = AppSpacing.homeMoreProductsSheetHandleWidth,
    this.height = AppSpacing.homeMoreProductsSheetHandleHeight,
    this.color = AppColors.borderSolid,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppRadii.pillRadius,
        ),
      ),
    );
  }
}

class VitSheetPanel extends StatelessWidget {
  const VitSheetPanel({
    super.key,
    required this.title,
    required this.child,
    this.maxHeightFactor = AppSpacing.sheetPanelMaxHeightFactor,
  });

  final String title;
  final Widget child;
  final double maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: AppSpacing.homeMoreProductsSheetPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VitSheetHandle(),
              const SizedBox(height: AppSpacing.x4),
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class VitSheetSurface extends StatelessWidget {
  const VitSheetSurface({
    super.key,
    required this.child,
    this.padding = AppSpacing.homeMoreProductsSheetPadding,
    this.color = AppColors.bg,
    this.borderRadius = AppRadii.sheetTopLargeRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: child,
    );
  }
}
