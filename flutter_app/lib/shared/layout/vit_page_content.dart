import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
    this.customGap,
    this.grow = false,
    this.fullBleed = false,
  });

  final List<Widget> children;
  final VitContentPadding padding;
  final VitContentGap gap;
  final double? customGap;
  final bool grow;
  final bool fullBleed;

  double get _topPadding {
    switch (padding) {
      case VitContentPadding.compact:
        return 8;
      case VitContentPadding.defaultPadding:
        return 12;
      case VitContentPadding.relaxed:
        return 16;
      case VitContentPadding.none:
        return 0;
    }
  }

  double get _gap {
    if (customGap != null) return customGap!;
    switch (gap) {
      case VitContentGap.tight:
        return 8;
      case VitContentGap.defaultGap:
        return 16;
      case VitContentGap.relaxed:
        return 24;
      case VitContentGap.loose:
        return 32;
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.only(
        left: fullBleed ? 0 : AppSpacing.contentPad,
        right: fullBleed ? 0 : AppSpacing.contentPad,
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
    this.customGap,
  });

  final List<Widget> children;
  final String? label;
  final Color accentColor;
  final VitContentGap gap;
  final double? customGap;

  double get _gap {
    if (customGap != null) return customGap!;
    switch (gap) {
      case VitContentGap.tight:
        return 8;
      case VitContentGap.defaultGap:
        return 16;
      case VitContentGap.relaxed:
        return 24;
      case VitContentGap.loose:
        return 32;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label!,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
