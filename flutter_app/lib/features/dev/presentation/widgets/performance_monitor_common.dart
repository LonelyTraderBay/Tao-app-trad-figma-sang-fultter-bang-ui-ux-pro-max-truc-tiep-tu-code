part of '../pages/performance_monitor.dart';

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final PerformanceOptimizationTip tip;

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(tip.tone);
    final icon = switch (tip.tone) {
      PerformanceScoreTone.good => Icons.trending_down_rounded,
      PerformanceScoreTone.warning => Icons.inventory_2_outlined,
      PerformanceScoreTone.poor => Icons.schedule_rounded,
    };

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      radius: VitCardRadius.lg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: toneColor, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetsCard extends StatelessWidget {
  const _TargetsCard({required this.targets});

  final List<String> targets;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Targets',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            for (final target in targets)
              Text(
                '- $target',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
          ],
        ),
      ),
    );
  }
}

class _InternalNotice extends StatelessWidget {
  const _InternalNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.admin_panel_settings_outlined,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Divider(height: 1, thickness: 1, color: AppColors.borderSolid),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface2),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

Color _toneColor(PerformanceScoreTone tone) {
  return switch (tone) {
    PerformanceScoreTone.good => AppColors.buy,
    PerformanceScoreTone.warning => AppColors.warn,
    PerformanceScoreTone.poor => AppColors.sell,
  };
}
