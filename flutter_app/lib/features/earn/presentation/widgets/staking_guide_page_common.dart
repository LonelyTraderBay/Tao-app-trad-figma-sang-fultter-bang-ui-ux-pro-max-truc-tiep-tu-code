part of '../pages/staking_guide_page.dart';

class _StepDetail extends StatelessWidget {
  const _StepDetail({required this.step});

  final StakingGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RoundIcon(
              icon: _guideIcon(step.iconKey),
              color: AppColors.primarySoft,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(child: Text(step.title, style: AppTextStyles.baseMedium)),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          step.description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class _TipPanel extends StatelessWidget {
  const _TipPanel({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tips quan trọng',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final tip in tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: SizedBox(
                    width: 4,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.text3,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != tips.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _DifficultyPill extends StatelessWidget {
  const _DifficultyPill({required this.difficulty});

  final StakingGuideDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = _difficultyColor(difficulty);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          difficulty.name,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.color,
    this.size = AppSpacing.x7,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(icon, color: color, size: AppSpacing.iconMd),
        ),
      ),
    );
  }
}

String _difficultyTabLabel(StakingGuideDifficulty difficulty) {
  return switch (difficulty) {
    StakingGuideDifficulty.beginner => 'Beginner',
    StakingGuideDifficulty.intermediate => 'Intermediate',
    StakingGuideDifficulty.advanced => 'Advanced',
  };
}

Color _difficultyColor(StakingGuideDifficulty difficulty) {
  return switch (difficulty) {
    StakingGuideDifficulty.beginner => AppColors.buy,
    StakingGuideDifficulty.intermediate => AppColors.primarySoft,
    StakingGuideDifficulty.advanced => AppColors.warn,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    'danger' => AppColors.sell,
    _ => AppColors.primarySoft,
  };
}

IconData _guideIcon(String iconKey) {
  return switch (iconKey) {
    'book' => Icons.menu_book_outlined,
    'calculator' => Icons.calculate_outlined,
    'shield' => Icons.shield_outlined,
    'chart' => Icons.bar_chart_rounded,
    'lock' => Icons.lock_outline_rounded,
    'bell' => Icons.notifications_active_outlined,
    'calendar' => Icons.event_available_outlined,
    'trend' => Icons.trending_up_rounded,
    'warning' => Icons.warning_amber_rounded,
    _ => Icons.lightbulb_outline_rounded,
  };
}
