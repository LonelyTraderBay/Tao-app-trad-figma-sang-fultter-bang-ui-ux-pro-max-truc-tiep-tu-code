import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

enum VitContentPadding { compact, defaultPadding, relaxed, none }

enum VitContentGap { tight, defaultGap, relaxed, loose }

class VitPageContent extends StatelessWidget {
  const VitPageContent({
    super.key,
    required this.children,
    this.padding = VitContentPadding.defaultPadding,
    this.gap = VitContentGap.defaultGap,
    this.density,
    this.customGap,
    this.grow = false,
    this.fullBleed = false,
  });

  final List<Widget> children;
  final VitContentPadding padding;
  final VitContentGap gap;
  final VitDensity? density;
  final double? customGap;
  final bool grow;
  final bool fullBleed;

  double get _topPadding {
    if (density != null) return density!.pageContentTopPadding;
    switch (padding) {
      case VitContentPadding.compact:
        return AppSpacing.pageContentTopCompact;
      case VitContentPadding.defaultPadding:
        return AppSpacing.pageContentTopDefault;
      case VitContentPadding.relaxed:
        return AppSpacing.pageContentTopRelaxed;
      case VitContentPadding.none:
        return AppSpacing.zero;
    }
  }

  double get _gap {
    if (customGap != null) return customGap!;
    if (density != null) return density!.pageContentGap;
    switch (gap) {
      case VitContentGap.tight:
        return AppSpacing.pageContentGapTight;
      case VitContentGap.defaultGap:
        return AppSpacing.pageContentGapDefault;
      case VitContentGap.relaxed:
        return AppSpacing.pageContentGapRelaxed;
      case VitContentGap.loose:
        return AppSpacing.pageContentGapLoose;
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsetsDirectional.only(
        start: fullBleed ? AppSpacing.zero : AppSpacing.contentPad,
        end: fullBleed ? AppSpacing.zero : AppSpacing.contentPad,
        top: _topPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withGaps(children, _gap),
      ),
    );

    if (!grow) return content;
    return Expanded(child: content);
  }
}

class VitPageSection extends StatelessWidget {
  const VitPageSection({
    super.key,
    required this.children,
    this.label,
    this.accentColor = AppColors.primary,
    this.gap = VitContentGap.tight,
    this.density,
    this.customGap,
  });

  final List<Widget> children;
  final String? label;
  final Color accentColor;
  final VitContentGap gap;
  final VitDensity? density;
  final double? customGap;

  double get _gap {
    if (customGap != null) return customGap!;
    if (density != null) return density!.pageContentGap;
    switch (gap) {
      case VitContentGap.tight:
        return AppSpacing.pageContentGapTight;
      case VitContentGap.defaultGap:
        return AppSpacing.pageContentGapDefault;
      case VitContentGap.relaxed:
        return AppSpacing.pageContentGapRelaxed;
      case VitContentGap.loose:
        return AppSpacing.pageContentGapLoose;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: AppSpacing.pageSectionLabelBottomGap,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: AppSpacing.pageSectionLabelGap,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      width: AppSpacing.pageSectionAccentWidth,
                      height: AppSpacing.pageSectionAccentHeight,
                    ),
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: accentColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadii.hairlineRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  label!,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        ..._withGaps(children, _gap),
      ],
    );
  }
}

List<Widget> _withGaps(List<Widget> children, double gap) {
  if (children.isEmpty) return const [];
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) SizedBox(height: gap),
      children[i],
    ],
  ];
}
