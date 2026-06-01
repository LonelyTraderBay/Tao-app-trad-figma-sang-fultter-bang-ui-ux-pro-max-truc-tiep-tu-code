part of '../pages/two_fa_setup_page.dart';

class _TwoFaStepper extends StatelessWidget {
  const _TwoFaStepper({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          for (var index = 1; index <= 3; index++) ...[
            _StepDot(index: index, activeStep: step),
            if (index < 3)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: index < step ? _authPrimary : _authPrimary30,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.activeStep});

  final int index;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final isActive = index == activeStep;
    final isComplete = index < activeStep;
    final color = isActive || isComplete ? _authPrimary : _authStepInactive;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: isComplete
          ? const Icon(Icons.check_rounded, color: AppColors.onAccent, size: 17)
          : Text(
              '$index',
              style: AppTextStyles.caption.copyWith(
                color: isActive ? AppColors.onAccent : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
    );
  }
}
