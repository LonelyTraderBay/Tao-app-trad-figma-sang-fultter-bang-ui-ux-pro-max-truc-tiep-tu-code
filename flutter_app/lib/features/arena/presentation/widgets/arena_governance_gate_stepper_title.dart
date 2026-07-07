import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

enum ArenaWizardStepperStyle { governance, studio, smartRule }

class ArenaWizardStepper extends StatelessWidget {
  const ArenaWizardStepper({
    super.key,
    required this.steps,
    required this.activeStep,
    this.style = ArenaWizardStepperStyle.governance,
    this.accentColor = AppModuleAccents.arena,
  });

  final List<ArenaStudioStepDraft> steps;
  final int activeStep;
  final ArenaWizardStepperStyle style;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _ArenaWizardStepMarker(
              item: steps[i],
              activeStep: activeStep,
              style: style,
              accentColor: accentColor,
            ),
          ),
          if (i != steps.length - 1)
            Padding(
              padding: _connectorPadding,
              child: SizedBox(
                width: AppSpacing.x5,
                height: _connectorHeight,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: steps[i].index < activeStep
                        ? AppColors.buy
                        : AppColors.surface3,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.xsRadius,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );

    if (style == ArenaWizardStepperStyle.studio) {
      return Padding(
        padding: ArenaSpacingTokens.arenaStudioStepperPadding,
        child: row,
      );
    }
    return row;
  }

  EdgeInsetsGeometry get _connectorPadding => switch (style) {
    ArenaWizardStepperStyle.governance =>
      ArenaSpacingTokens.arenaGovernanceStepperLineMargin,
    ArenaWizardStepperStyle.studio =>
      ArenaSpacingTokens.arenaStudioStepperLineMargin,
    ArenaWizardStepperStyle.smartRule =>
      ArenaSpacingTokens.arenaSmartRuleStepperLineMargin,
  };

  double get _connectorHeight => switch (style) {
    ArenaWizardStepperStyle.governance =>
      ArenaSpacingTokens.arenaGovernanceStepperLineHeight,
    ArenaWizardStepperStyle.studio =>
      ArenaSpacingTokens.arenaStudioStepperLineHeight,
    ArenaWizardStepperStyle.smartRule =>
      ArenaSpacingTokens.arenaSmartRuleStepperLineHeight,
  };
}

class _ArenaWizardStepMarker extends StatelessWidget {
  const _ArenaWizardStepMarker({
    required this.item,
    required this.activeStep,
    required this.style,
    required this.accentColor,
  });

  final ArenaStudioStepDraft item;
  final int activeStep;
  final ArenaWizardStepperStyle style;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final done = item.index < activeStep;
    final active = item.index == activeStep;

    final (dotSize, fill, borderSide, iconColor, labelStyle) = switch (style) {
      ArenaWizardStepperStyle.governance => (
        active
            ? ArenaSpacingTokens.arenaGovernanceStepActive
            : ArenaSpacingTokens.arenaGovernanceStepDefault,
        done
            ? AppColors.buy
            : active
            ? AppColors.accent
            : AppColors.surface3,
        null as BorderSide?,
        active ? AppColors.onAccent : AppColors.text3,
        AppTextStyles.micro.copyWith(
          color: done
              ? AppColors.buy
              : active
              ? AppColors.accent
              : AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
      ArenaWizardStepperStyle.studio => (
        ArenaSpacingTokens.arenaStudioStepDot,
        done
            ? AppColors.buy
            : active
            ? accentColor
            : AppColors.surface2,
        BorderSide(color: active ? AppColors.warn15 : AppColors.borderSolid),
        active || done ? AppColors.navCenterIcon : AppColors.text3,
        AppTextStyles.micro.copyWith(
          color: active
              ? accentColor
              : done
              ? AppColors.buy
              : AppColors.text3,
          fontWeight: AppTextStyles.medium,
          height: ArenaSpacingTokens.arenaStudioStepLabelLineHeight,
        ),
      ),
      ArenaWizardStepperStyle.smartRule => (
        ArenaSpacingTokens.arenaSmartRuleStepDot,
        done
            ? AppColors.buy
            : active
            ? AppColors.accent
            : AppColors.surface2,
        BorderSide(color: active ? AppColors.accent20 : AppColors.borderSolid),
        active ? AppColors.navCenterIcon : AppColors.text3,
        AppTextStyles.micro.copyWith(
          color: done
              ? AppColors.buy
              : active
              ? AppColors.accent
              : AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    };

    return Column(
      children: [
        SizedBox(
          width: dotSize,
          height: dotSize,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: fill,
              shape: CircleBorder(side: borderSide ?? BorderSide.none),
            ),
            child: Center(
              child: done
                  ? Icon(
                      Icons.check_rounded,
                      color: iconColor,
                      size: style == ArenaWizardStepperStyle.governance
                          ? ArenaSpacingTokens.arenaGovernanceIcon
                          : ArenaSpacingTokens.arenaSmartRuleStepIcon,
                    )
                  : Text(
                      '${item.index}',
                      style: AppTextStyles.micro.copyWith(
                        color: iconColor,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: style == ArenaWizardStepperStyle.studio
              ? TextAlign.center
              : TextAlign.start,
          style: labelStyle,
        ),
      ],
    );
  }
}

class ArenaGovernanceGateHeader extends StatelessWidget {
  const ArenaGovernanceGateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Luật chơi — Governed Mode',
          accentColor: AppModuleAccents.arena,
          bottomGap: 0,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Governance Gate tự động kiểm tra rule trước khi publish',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: ArenaSpacingTokens.arenaGovernanceSubtitleLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
      ],
    );
  }
}
