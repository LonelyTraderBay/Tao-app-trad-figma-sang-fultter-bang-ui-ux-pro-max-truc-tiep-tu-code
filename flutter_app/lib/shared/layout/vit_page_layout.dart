import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

enum VitPageVariant { defaultPage, surface, flush, immersive }

class VitPageLayout extends StatelessWidget {
  const VitPageLayout({
    super.key,
    required this.child,
    this.variant = VitPageVariant.defaultPage,
    this.semanticLabel,
  });

  final Widget child;
  final VitPageVariant variant;
  final String? semanticLabel;

  Color? get _background {
    switch (variant) {
      case VitPageVariant.defaultPage:
      case VitPageVariant.flush:
        return AppColors.bg;
      case VitPageVariant.surface:
        return AppColors.surface;
      case VitPageVariant.immersive:
        return null;
    }
  }

  double get _bottomPadding {
    switch (variant) {
      case VitPageVariant.flush:
        return AppSpacing.zero;
      case VitPageVariant.defaultPage:
      case VitPageVariant.surface:
      case VitPageVariant.immersive:
        return AppSpacing.pageContentGapLoose;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ColoredBox(
        color: _background ?? AppColors.transparent,
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsetsDirectional.only(bottom: _bottomPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}

class VitStickyFooter extends StatelessWidget {
  const VitStickyFooter({
    super.key,
    required this.child,
    this.showBorder = true,
    this.backgroundColor = AppColors.surface,
  });

  final Widget child;
  final bool showBorder;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: showBorder
            ? const Border(top: BorderSide(color: AppColors.divider))
            : const Border(),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.contentPad,
          AppSpacing.pageContentTopRelaxed,
          AppSpacing.contentPad,
          AppSpacing.contentPad,
        ),
        child: child,
      ),
    );
  }
}
