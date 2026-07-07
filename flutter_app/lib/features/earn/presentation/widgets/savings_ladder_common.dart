import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

const _sectionMarkerHeight = 12.0;

class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      fullWidth: true,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: EarnSpacingTokens.savingsLadderSectionMarkerWidth,
          height: _sectionMarkerHeight,
          child: Material(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: savingsLadderMicroBoldStyle.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class SmallPill extends StatelessWidget {
  const SmallPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: savingsLadderMicroBoldStyle.copyWith(color: color),
        ),
      ),
    );
  }
}

class RoundIcon extends StatelessWidget {
  const RoundIcon({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: EarnSpacingTokens.savingsLadderRoundIcon,
      child: Material(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX1,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: savingsLadderCaptionBoldStyle.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyTab extends StatelessWidget {
  const EmptyTab({
    super.key,
    required this.icon,
    required this.title,
    required this.cta,
  });

  final IconData icon;
  final String title;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: AppSpacing.iconLg),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: savingsLadderCaptionBoldStyle.copyWith(
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(fullWidth: false, onPressed: () {}, child: Text(cta)),
        ],
      ),
    );
  }
}

class LadderTabs extends StatelessWidget {
  const LadderTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EarnSpacingTokens.earnHorizontalPaddingX4,
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              activeKey: active,
              onChanged: onChanged,
              tabs: [
                for (final tab in tabs)
                  VitTabItem(key: tab.id, label: tab.label),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x1),
        ],
      ),
    );
  }
}
