part of '../pages/route_checker_page.dart';

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.testedCount,
    required this.totalCount,
    required this.onReset,
  });

  final int testedCount;
  final int totalCount;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final complete = testedCount == totalCount;

    return Row(
      children: [
        Expanded(
          child: Material(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            child: InkWell(
              key: RouteChecker.resetButtonKey,
              onTap: onReset,
              borderRadius: AppRadii.inputRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
                child: Text(
                  'Reset Tests',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (complete) ...[
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.buy10,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
                child: Text(
                  'All Routes Tested',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PhaseStats extends StatelessWidget {
  const _PhaseStats({required this.snapshot, required this.testedRoutes});

  final RouteCheckerSnapshot snapshot;
  final Set<String> testedRoutes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stats by Phase',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x3,
            crossAxisSpacing: AppSpacing.x3,
            childAspectRatio: 1.18,
            children: [
              for (final phase in snapshot.phases)
                _PhaseStatTile(
                  phase: phase,
                  total: snapshot.phaseTotal(phase),
                  tested: snapshot.routes
                      .where(
                        (route) =>
                            route.phase == phase &&
                            testedRoutes.contains(route.path),
                      )
                      .length,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseStatTile extends StatelessWidget {
  const _PhaseStatTile({
    required this.phase,
    required this.total,
    required this.tested,
  });

  final int phase;
  final int total;
  final int tested;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : tested / total;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Phase $phase',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '$tested/$total',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: ColoredBox(
                color: AppColors.bg,
                child: SizedBox(
                  height: AppSpacing.x1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress.clamp(0, 1),
                      child: const ColoredBox(color: AppColors.buy),
                    ),
                  ),
                ),
              ),
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
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20),
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
