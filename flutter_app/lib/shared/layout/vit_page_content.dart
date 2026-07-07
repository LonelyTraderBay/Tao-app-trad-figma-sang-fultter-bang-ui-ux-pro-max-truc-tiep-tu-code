import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';

enum VitContentPadding { compact, defaultPadding, relaxed, none }

enum VitContentGap { tight, defaultGap, relaxed, loose }

double _resolveContentGap({
  required VitContentGap gap,
  VitDensity? density,
  double? customGap,
}) {
  if (customGap != null) return customGap;
  if (density != null) return density.pageContentGap;
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

class VitPageContent extends StatelessWidget {
  const VitPageContent({
    super.key,
    required this.children,
    this.padding = VitContentPadding.defaultPadding,
    this.gap = VitContentGap.defaultGap,
    this.density,
    this.rhythm,
    this.customGap,
    this.grow = false,
    this.fullBleed = false,
  });

  final List<Widget> children;
  final VitContentPadding padding;
  final VitContentGap gap;
  final VitDensity? density;
  final VitPageRhythm? rhythm;
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
        children: _withGaps(
          children,
          customGap ??
              rhythm?.sectionGap ??
              _resolveContentGap(gap: gap, density: density, customGap: null),
        ),
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
    this.headerIcon,
    this.headerIconColor,
    this.headerVariant = VitSectionHeaderVariant.accentBar,
    this.headerDensity = VitDensity.compact,
    this.actionLabel,
    this.onAction,
    this.actionKey,
    this.actionSemanticLabel,
    this.actionShowChevron = true,
    this.accentColor = AppColors.primary,
    this.gap = VitContentGap.tight,
    this.density,
    this.rhythm,
    this.innerGap,
    this.customGap,
  });

  final List<Widget> children;
  final String? label;
  final IconData? headerIcon;
  final Color? headerIconColor;
  final VitSectionHeaderVariant headerVariant;
  final VitDensity headerDensity;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;
  final String? actionSemanticLabel;
  final bool actionShowChevron;
  final Color accentColor;
  final VitContentGap gap;
  final VitDensity? density;
  final VitPageRhythm? rhythm;
  final double? innerGap;
  final double? customGap;

  double get _labelBottomGap =>
      innerGap ?? rhythm?.innerGap ?? AppSpacing.pageRhythmStandardInnerGap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          VitSectionHeader(
            title: label!,
            icon: headerIcon,
            iconColor: headerIconColor,
            variant: headerVariant,
            accentColor: accentColor,
            density: headerDensity,
            actionLabel: actionLabel,
            onAction: onAction,
            actionKey: actionKey,
            actionSemanticLabel: actionSemanticLabel,
            actionShowChevron: actionShowChevron,
            bottomGap: _labelBottomGap,
          ),
        ],
        ..._withGaps(
          children,
          customGap ??
              rhythm?.sectionGap ??
              _resolveContentGap(gap: gap, density: density, customGap: null),
        ),
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
