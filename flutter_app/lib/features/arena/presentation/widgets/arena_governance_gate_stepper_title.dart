part of '../pages/arena_governance_gate_page.dart';

class _GovernanceStepper extends StatelessWidget {
  const _GovernanceStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _StepMarker(item: steps[i], activeStep: step),
          ),
          if (i != steps.length - 1)
            Container(
              width: AppSpacing.x5,
              height: AppSpacing.arenaGovernanceStepperLineHeight,
              margin: const EdgeInsets.only(bottom: AppSpacing.x5),
              decoration: BoxDecoration(
                color: steps[i].index < step
                    ? AppColors.buy
                    : AppColors.surface3,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepMarker extends StatelessWidget {
  const _StepMarker({required this.item, required this.activeStep});

  final ArenaStudioStepDraft item;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final done = item.index < activeStep;
    final active = item.index == activeStep;
    return Column(
      children: [
        Container(
          width: active
              ? AppSpacing.arenaGovernanceStepActive
              : AppSpacing.arenaGovernanceStepDefault,
          height: active
              ? AppSpacing.arenaGovernanceStepActive
              : AppSpacing.arenaGovernanceStepDefault,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done
                ? AppColors.buy
                : active
                ? AppColors.accent
                : AppColors.surface3,
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(
                  Icons.check_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.arenaGovernanceIcon,
                )
              : Text(
                  '${item.index}',
                  style: AppTextStyles.micro.copyWith(
                    color: active ? AppColors.onAccent : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: done
                ? AppColors.buy
                : active
                ? AppColors.accent
                : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _GovernanceTitle extends StatelessWidget {
  const _GovernanceTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Luật chơi — Governed Mode',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Governance Gate tự động kiểm tra rule trước khi publish',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: AppSpacing.arenaGovernanceSubtitleLineHeight,
          ),
        ),
      ],
    );
  }
}
