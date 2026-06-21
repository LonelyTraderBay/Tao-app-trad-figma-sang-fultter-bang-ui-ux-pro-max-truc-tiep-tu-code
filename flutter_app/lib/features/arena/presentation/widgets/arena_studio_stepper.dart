part of '../pages/arena_studio_page.dart';

class _StudioStepper extends StatelessWidget {
  const _StudioStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaStudioStepperPadding,
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepMarker(item: steps[i], activeStep: step),
            ),
            if (i != steps.length - 1)
              Padding(
                padding: AppSpacing.arenaStudioStepperLineMargin,
                child: SizedBox(
                  width: AppSpacing.x5,
                  height: _studioStepperLineExtent,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: steps[i].index < step
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
      ),
    );
  }
}

class _StepMarker extends StatelessWidget {
  const _StepMarker({required this.item, required this.activeStep});

  final ArenaStudioStepDraft item;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final isDone = item.index < activeStep;
    final isActive = item.index == activeStep;
    final fill = isDone
        ? AppColors.buy
        : isActive
        ? _arenaAccent
        : AppColors.surface2;
    final textColor = isActive || isDone
        ? AppColors.navCenterIcon
        : AppColors.text3;

    return Column(
      children: [
        SizedBox(
          width: AppSpacing.arenaStudioStepDot,
          height: AppSpacing.arenaStudioStepDot,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: fill,
              shape: CircleBorder(
                side: BorderSide(
                  color: isActive ? AppColors.warn15 : AppColors.borderSolid,
                ),
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.navCenterIcon,
                      size: AppSpacing.arenaStudioStepIcon,
                    )
                  : Text(
                      '${item.index}',
                      style: AppTextStyles.micro.copyWith(
                        color: textColor,
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
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: isActive
                ? _arenaAccent
                : isDone
                ? AppColors.buy
                : AppColors.text3,
            fontWeight: AppTextStyles.medium,
            height: _studioStepLabelLineRatio,
          ),
        ),
      ],
    );
  }
}
