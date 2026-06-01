part of '../pages/arena_studio_page.dart';

class _StudioStepper extends StatelessWidget {
  const _StudioStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepMarker(item: steps[i], activeStep: step),
            ),
            if (i != steps.length - 1)
              Container(
                width: AppSpacing.x5,
                height: 2,
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
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.warn15 : AppColors.borderSolid,
            ),
          ),
          alignment: Alignment.center,
          child: isDone
              ? const Icon(
                  Icons.check_rounded,
                  color: AppColors.navCenterIcon,
                  size: 14,
                )
              : Text(
                  '${item.index}',
                  style: AppTextStyles.micro.copyWith(
                    color: textColor,
                    fontWeight: AppTextStyles.bold,
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
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
