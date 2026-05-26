import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

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
        return 0;
      case VitPageVariant.defaultPage:
      case VitPageVariant.surface:
      case VitPageVariant.immersive:
        return 32;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ColoredBox(
        color: _background ?? Colors.transparent,
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.only(bottom: _bottomPadding),
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
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder
            ? const Border(top: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: child,
      ),
    );
  }
}
