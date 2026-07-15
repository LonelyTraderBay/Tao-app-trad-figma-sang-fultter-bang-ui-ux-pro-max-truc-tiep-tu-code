import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

import 'savings_autopilot_formatters.dart';

class IconBadge extends StatelessWidget {
  const IconBadge({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: EarnSpacingTokens.savingsAutoPilotIconBadge,
      height: EarnSpacingTokens.savingsAutoPilotIconBadge,
      child: Material(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class SmallPill extends StatelessWidget {
  const SmallPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      size: VitStatusPillSize.sm,
      semanticStatus: accentSemanticStatus(color),
    );
  }
}

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
    return VitStatusPill(
      label: label,
      status: selected ? VitStatusPillStatus.info : VitStatusPillStatus.neutral,
      size: VitStatusPillSize.md,
      outline: !selected,
      onTap: onTap,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitModuleSectionHeader(title: label);
  }
}

class InfoCallout extends StatelessWidget {
  const InfoCallout({super.key, required this.text, required this.tone});

  final String text;
  final EarnRiskLevel tone;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'AutoPilot risk review',
      message: text,
    );
  }
}
